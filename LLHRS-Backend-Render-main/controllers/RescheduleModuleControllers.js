const RescheduleModuleModel = require("../models/RescheduleModuleModel");
const TemporaryRescheduleModuleModel = require("../models/TemporaryRescheduleModuleModel");
const ModuleModel = require("../models/ModuleModel");
const { verifyToken } = require("../utils/jwt");
const cron = require("node-cron");
const jwt = require("jsonwebtoken");
const nodemailer = require("nodemailer");

module.exports.availableHallOrLab = async (req, res) => {
  try {
    const { moduleType, date, startTime, endTime, capacity } = req.body;
    const dateString = new Date(date);
    const day = new Intl.DateTimeFormat("en-US", { weekday: "long" }).format(
      dateString
    );

    // Define time overlap conditions
    const timeOverlapConditions = [
      { end_time: { $gt: startTime, $lte: endTime } },
      { start_time: { $lt: endTime, $gte: startTime } },
      { start_time: { $lte: startTime }, end_time: { $gte: endTime } },
    ];

    // Find halls/labs that are free in ModuleModel
    const originalModules = await ModuleModel.find({
      module_type: moduleType,
      day: day,
      $or: timeOverlapConditions,
      capacity: { $gte: capacity },
    })
      .select("hl_name")
      .lean();

    const originalHallOrLabNames = originalModules.map((mod) => mod.hl_name);

    // Find all halls/labs with their IDs
    const allHallsOrLabs = await ModuleModel.find({
      hl_name: { $nin: originalHallOrLabNames },
      module_type: moduleType,
      capacity: { $gte: capacity },
    })
      .distinct("hl_name")
      .lean();

    // Retrieve detailed information for filtered halls/labs
    const hallOrLabDetails = await ModuleModel.find({
      hl_name: { $in: allHallsOrLabs },
      module_type: moduleType,
      capacity: { $gte: capacity },
    })
      .select("hl_name")
      .lean();

    // Extract names for rescheduling checks
    const hallOrLabNames = hallOrLabDetails.map((hall) => hall.hl_name);

    // Find rescheduled modules that affect availability
    const rescheduledModules = await RescheduleModuleModel.find({
      hl_name: { $in: hallOrLabNames },
      date: date,
      $or: timeOverlapConditions,
      capacity: { $gte: capacity },
    }).lean();

    const tempRescheduledModules = await TemporaryRescheduleModuleModel.find({
      hl_name: { $in: hallOrLabNames },
      date: date,
      $or: timeOverlapConditions,
      capacity: { $gte: capacity },
    }).lean();

    // Combine all unavailable halls/labs from rescheduled modules
    const unavailableHallsOrLabs = new Set([
      ...rescheduledModules.map((mod) => mod.hl_name),
      ...tempRescheduledModules.map((mod) => mod.hl_name),
    ]);

    // Filter hallOrLabDetails to exclude those unavailable due to rescheduling
    const available = hallOrLabDetails.filter(
      (hall) => !unavailableHallsOrLabs.has(hall.hl_name)
    );

    // Convert to Set to remove duplicates and then back to an array
    const uniqueAvailable = Array.from(
      new Map(available.map((hall) => [hall.hl_name, hall])).values()
    );

    res.status(200).json({ available: uniqueAvailable });
  } catch (error) {
    console.error("Error checking availability:", error);
    res.status(500).json({ error: "Internal server error" });
  }
};

module.exports.rescheduleModule = async (req, res) => {
  try {
    const {
      token,
      moduleCode,
      moduleType,
      hlName,
      startTime,
      endTime,
      date,
      capacity,
    } = req.body;

    // Decode the token to get the user's email
    const decodedToken = verifyToken(token);
    const uni_email = decodedToken.email;
    const role = decodedToken.role;

    const dateString = new Date(date);
    const day = new Intl.DateTimeFormat("en-US", { weekday: "long" }).format(
      dateString
    );

    if (role !== "Student") {
      // Find the module to be rescheduled
      const moduleReschedule = await ModuleModel.findOne({
        module_code: moduleCode,
        module_type: moduleType,
        l_d_uni_email: uni_email,
      });

      if (!moduleReschedule) {
        return res.status(404).json({ error: "Module not found" });
      }

      // Check if the hall/lab has already been booked in the rescheduled slot
      const isBooked = await RescheduleModuleModel.findOne({
        hl_name: hlName,
        day: day,
        $or: [
          { end_time: { $gt: startTime, $lt: endTime } }, // Overlaps with the requested start time
          { start_time: { $gt: startTime, $lt: endTime } }, // Overlaps with the requested end time
          {
            start_time: { $lte: startTime },
            end_time: { $gte: endTime },
          }, // Completely overlaps the requested time slot
        ],
      });

      if (isBooked) {
        return res
          .status(409)
          .json({ error: "Hall/Lab already booked in this time slot" });
      }

      // Check if a rescheduled module with the same slot already exists
      const existingReschedule = await RescheduleModuleModel.findOne({
        hl_name: hlName,
        date: date,
        start_time: startTime,
        end_time: endTime,
      });

      if (existingReschedule) {
        return res
          .status(409)
          .json({ error: "Rescheduled module already exists for this slot" });
      }

      const moduleName = moduleReschedule.module_name;

      // Create and save the rescheduled module
      const saveTemporaryRescheduleModules = new TemporaryRescheduleModuleModel(
        {
          module_code: moduleCode,
          module_name: moduleName,
          module_type: moduleType,
          hl_name: hlName,
          capacity: capacity,
          semester: moduleReschedule.semester,
          academic_year: moduleReschedule.academic_year,
          l_d_uni_email: uni_email,
          start_time: startTime,
          end_time: endTime,
          date: date,
        }
      );

      await saveTemporaryRescheduleModules.save();

      // Create a unique token for approval process
      const approvalToken = jwt.sign(
        {
          moduleCode,
          moduleName: moduleReschedule.module_name,
          moduleType: moduleReschedule.module_type,
          hlName,
          date,
          startTime,
          endTime,
          capacity,
          uni_email,
        },
        process.env.APPROVAL_JWT_SECRET,
        { expiresIn: "1d" }
      );

      //Send the approval email

      const transporter = nodemailer.createTransport({
        service: "gmail",
        auth: {
          user: process.env.EMAIL_ADDRESS,
          pass: process.env.EMAIL_PASSWORD,
        },
      });

      const approvalLink = `${process.env.SERVER_URL}/api/reschedule/approve?token=${approvalToken}`;
      console.log(approvalLink);

      const mailOptions = {
        from: process.env.EMAIL_ADDRESS,
        to: process.env.DR_EMAIL_ADDRESS,
        subject: "Module Reschedule Approval Required",
        html: `
          <p>Please approve the rescheduling of the following module by clicking the button below:</p>
          <p><strong>Module Code:</strong> ${moduleCode}</p>
          <p><strong>Module Name:</strong> ${moduleReschedule.module_name}</p>
          <p><strong>Hall/Lab Name:</strong> ${hlName}</p>
          <p><strong>Date:</strong> ${date}</p>
          <a href="${approvalLink}" style="
              display: inline-block;
              padding: 10px 20px;
              font-size: 16px;
              color: white;
              background-color: #90EE90;
              border-radius: 5px;
              text-align: center;
              text-decoration: none;
              margin-top: 20px;
            ">
            Approve Reschedule
          </a>
        `,
      };

      transporter.sendMail(mailOptions, (error, info) => {
        if (error) {
          console.error("Error sending mail: " + error);
          return res
            .status(500)
            .json({ error: "Error sending approval email" });
        } else {
          console.log("Approval email sent: " + info.response);
          res.status(200).json({ message: "Approval email sent." });
        }
      });
    }
  } catch (error) {
    console.error("Error rescheduling module:", error);
    res.status(500).json({ error: "Internal server error" });
  }
};

module.exports.delRescheduled = async (req, res) => {
  try {
    const oneWeekAgo = new Date();
    oneWeekAgo.setDate(oneWeekAgo.getDate() - 7);

    // Find and store the modules to be deleted
    const outdatedModules = await RescheduleModuleModel.find({
      date: { $lt: oneWeekAgo },
    });

    const outdatedModuleCodes = outdatedModules.map((module) => ({
      module_code: module.module_code,
      module_type: module.module_type,
    }));

    // Delete the outdated rescheduled modules
    const result = await RescheduleModuleModel.deleteMany({
      date: { $lt: oneWeekAgo },
    });

    // Update the corresponding Module schema's reschedule field to false
    if (outdatedModuleCodes.length > 0) {
      await Promise.all(
        outdatedModuleCodes.map(async ({ module_code, module_type }) => {
          await ModuleModel.updateMany(
            { module_code, module_type },
            { $set: { reschedule: false } }
          );
        })
      );
    }

    res.status(200).json({
      message: `${result.deletedCount} outdated rescheduled modules deleted and relevant modules updated.`,
    });
  } catch (error) {
    res.status(500).json({
      error:
        "An error occurred while deleting outdated rescheduled modules and updating the module schema.",
    });
  }
};

// Schedule the task to run every week on Sunday at midnight
cron.schedule("0 0 * * 0", () => {
  console.log("Running weekly task to delete outdated rescheduled modules.");
  delRescheduled();
});

//Approvale of rescheduled modules

module.exports.approveReschedule = async (req, res) => {
  try {
    const { token } = req.query;

    // Decode the approval token
    const decodedData = jwt.verify(token, process.env.APPROVAL_JWT_SECRET);

    // Extract details from the token
    const {
      moduleCode,
      moduleName,
      moduleType,
      hlName,
      date,
      startTime,
      endTime,
      capacity,
      uni_email,
    } = decodedData;

    // Find the module to be rescheduled
    const moduleReschedule = await ModuleModel.findOne({
      module_code: moduleCode,
      module_type: moduleType,
      l_d_uni_email: uni_email,
    });

    if (!moduleReschedule) {
      return res.status(404).json({ error: "Module not found" });
    }

    // Create and save the rescheduled module
    const saveRescheduleModules = new RescheduleModuleModel({
      module_code: moduleCode,
      module_name: moduleName,
      module_type: moduleType,
      hl_name: hlName,
      capacity: capacity,
      semester: moduleReschedule.semester,
      academic_year: moduleReschedule.academic_year,
      l_d_uni_email: uni_email,
      start_time: startTime,
      end_time: endTime,
      date: date,
    });

    await saveRescheduleModules.save();

    // Delete the found document by module_code
    await TemporaryRescheduleModuleModel.deleteOne({
      hl_name: hlName,
      date: date,
      module_code: moduleCode,
    });

    // Update the original module's reschedule field to true
    moduleReschedule.reschedule = true;
    await moduleReschedule.save();

    res
      .status(200)
      .json({ message: "Module reschedule approved and saved successfully." });
  } catch (error) {
    console.error("Error approving module reschedule:", error);
    res.status(500).json({ error: "Internal server error" });
  }
};

//implementing getFilterRescheduledModules
module.exports.getFilterRescheduledModules = async (req, res) => {
  const { tokenWithLetter } = req.body;

  try {
    const token = tokenWithLetter.slice(0, -1);
    const letter = tokenWithLetter.slice(-1);
    const decodedToken = verifyToken(token);
    const role = decodedToken.role;
    const academicYear = decodedToken.academicYear;
    const email = decodedToken.email;

    if (role === "Student") {
      // Fetch the document
      const document = await RescheduleModuleModel.find({
        academic_year: academicYear,
        $expr: {
          $or: [
            { $eq: [{ $substr: ["$module_code", 2, 1] }, "C"] },
            { $eq: [{ $substr: ["$module_code", 2, 1] }, letter] },
          ],
        },
      }).lean();
      return res.json(document);
    } else {
      // Fetch the document
      const document = await RescheduleModuleModel.find({
        l_d_uni_email: email,
      }).lean();
      return res.json(document);
    }
  } catch (err) {
    console.error("Error fetching document:", err);
    return res.status(500).json({ message: "Internal server error" });
  }
};
