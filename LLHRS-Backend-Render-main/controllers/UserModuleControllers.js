const UserModuleModel = require("../models/UserModuleModel");
const ModuleModel = require("../models/ModuleModel");
const UserModel = require("../models/UserModel");
const { verifyToken } = require("../utils/jwt");

module.exports.addUserModules = async (req, res) => {
  const { token } = req.body;

  decodedToken = verifyToken(token);
  user_id = decodedToken.id;
  academic_year = decodedToken.academicYear;
  degree = decodedToken.degree;

  try {
    // Check if user is a Lecturer/Demonstrator or a student
    const user = await UserModel.findOne({ user_id }).lean();

    if (!user) {
      return res.status(404).json({ message: "User not found." });
    }

    const isLecturerOrDemonstrator =
      user.role === "Lecturer" || user.role === "Demonstrator";

    console.log(
      `User found: ${user_id}. Role: ${user.role}, Email: ${user.uni_email}`
    );

    // Check if user module already exists
    const existingUserModule = await UserModuleModel.findOne({ user_id });

    if (existingUserModule) {
      return res.status(400).json({
        message: "User modules already exists.",
      });
    }

    // Find modules based on user role
    let modules;
    if (isLecturerOrDemonstrator) {
      if (!user.uni_email) {
        console.error(`User with ID ${user_id} has no uni_email set.\n`);
        return res.status(400).json({
          message: "Lecturer/Demonstrator email is not set.",
        });
      }

      modules = await ModuleModel.find({
        l_d_uni_email: user.uni_email,
      }).lean();

      if (!modules.length) {
        console.warn(
          `\nNo modules found for lecturer/demonstrator with email ${user.uni_email}.\n`
        );
      }
    } else {
      modules = await ModuleModel.find({
        module_code: { $regex: `^${degree}` },
        academic_year,
      }).lean();

      if (!modules.length) {
        console.warn(
          `\nNo modules found for student in academic year ${academic_year}.\n`
        );
      }
    }

    if (!modules.length) {
      return res
        .status(404)
        .json({ message: "No modules found for the given criteria." });
    }

    // Map modules to user modules format
    const userModules = modules.map((module) => ({
      module_code: module.module_code,
      module_name: module.module_name,
      module_type: module.module_type,
      hl_name: module.hl_name,
      capacity: module.capacity,
      semester: module.semester,
      academic_year: module.academic_year,
      l_d_uni_email: module.l_d_uni_email,
      start_time: module.start_time,
      end_time: module.end_time,
      day: module.day,
    }));

    // Create new user module data
    const userModuleData = new UserModuleModel({
      module: userModules,
      academic_year,
      user_id,
      degree_name: degree,
    });

    // Save user module data
    await userModuleData.save();

    return res
      .status(201)
      .json({ message: "User modules added successfully." });
  } catch (err) {
    console.error("Error while adding user modules:", err);
    return res
      .status(500)
      .json({ message: "An error occurred while adding user modules.", err });
  }
};

// Delete user modules
module.exports.deleteUserModules = async (req, res) => {
  try {
    const result = await UserModuleModel.updateMany(
      {},
      { $set: { module: [] } }
    );
    // console.log("Modules cleared from all documents:", result);
    return res.status(200).json({ message: "Modules cleared successfully." });
  } catch (error) {
    console.error("Error clearing modules:", error);
    return res
      .status(500)
      .json({ message: "An error occurred while clearing modules.", error });
  }
};

//Update System
module.exports.updateUserModules = async (req, res) => {
  try {
    // Find all unique academic years in the UserModuleModel
    const userModules = await UserModuleModel.find({}).lean();
    const academicYears = [
      ...new Set(userModules.map((userModule) => userModule.academic_year)),
    ];

    if (academicYears.length === 0) {
      console.warn("No academic years found in UserModuleModel.");
    }

    // Find all user_ids starting with 'L' or 'D'
    const lecturerAndDemos = await UserModel.find({
      user_id: { $regex: "^[LD]", $options: "i" },
    }).lean();

    const lecturerAndDemoIds = lecturerAndDemos.map((user) => user.user_id);

    if (lecturerAndDemoIds.length === 0) {
      console.warn(
        "No lecturers or demonstrators found. Proceeding with students."
      );
    } else {
      // Update modules for lecturers and demonstrators if they exist
      for (const lecturerAndDemoId of lecturerAndDemoIds) {
        const user = await UserModel.findOne({
          user_id: lecturerAndDemoId,
        }).lean();
        const uni_email = user?.uni_email;

        const modules = await ModuleModel.find({
          l_d_uni_email: uni_email,
        }).lean();

        if (modules.length === 0) {
          console.warn(
            `No modules found for lecturer/demonstrator with ID: ${lecturerAndDemoId}`
          );
          continue;
        }

        const userModulesToUpdate = modules.map((module) => ({
          module_code: module.module_code,
          module_name: module.module_name,
          module_type: module.module_type,
          hl_name: module.hl_name,
          capacity: module.capacity,
          semester: module.semester,
          academic_year: module.academic_year,
          l_d_uni_email: module.l_d_uni_email,
          start_time: module.start_time,
          end_time: module.end_time,
          day: module.day,
        }));

        await UserModuleModel.updateMany(
          { user_id: lecturerAndDemoId },
          { $set: { module: userModulesToUpdate } }
        );
      }
    }

    // Update modules for students based on academic year and degree name
    if (academicYears.length > 0) {
      for (const academic_year of academicYears) {
        const degreeStrings = await UserModuleModel.find({
          academic_year,
        }).lean();
        const degreeNames = [
          ...new Set(
            degreeStrings.map((degreeString) => degreeString.degree_name)
          ),
        ];

        for (const degree of degreeNames) {
          const modules = await ModuleModel.find({
            academic_year,
            module_code: { $regex: `^${degree}` },
          }).lean();

          if (modules.length === 0) {
            console.warn(
              `No modules found for academic year: ${academic_year} and degree: ${degree}`
            );
            continue;
          }

          const userModulesToUpdate = modules.map((module) => ({
            module_code: module.module_code,
            module_name: module.module_name,
            module_type: module.module_type,
            hl_name: module.hl_name,
            capacity: module.capacity,
            semester: module.semester,
            academic_year: module.academic_year,
            l_d_uni_email: module.l_d_uni_email,
            start_time: module.start_time,
            end_time: module.end_time,
            day: module.day,
          }));

          await UserModuleModel.updateMany(
            { academic_year, degree_name: degree },
            { $set: { module: userModulesToUpdate } }
          );
        }
      }
    }

    return res
      .status(200)
      .json({ message: "User modules updated successfully." });
  } catch (error) {
    console.error("Error updating modules:", error);
    return res.status(500).json({
      message: "An error occurred while updating user modules.",
      error,
    });
  }
};

//implementing getFilterModules
module.exports.getFilterModules = async (req, res) => {
  const { tokenWithLetter } = req.body;

  try {
    const token = tokenWithLetter.slice(0, -1);
    const letter = tokenWithLetter.slice(-1);
    const decodedToken = verifyToken(token);
    const user_id = decodedToken.id;

    // Fetch the document
    const document = await UserModuleModel.findOne({ user_id: user_id });

    // Get the current time in Singapore (server time)
    const singaporeTime = new Date();

    // Convert to Sri Lanka time (UTC+5:30)
    const sriLankaTime = new Date(singaporeTime.getTime() + 330 * 60000);
    const days = [
      "Sunday",
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
    ];
    const dayNameInSriLanka = days[sriLankaTime.getDay()];

    if (document) {
      let filteredModules;

      // Filter the modules based on user role
      if (decodedToken.role !== "Student") {
        filteredModules = document.module.filter(
          (mod) =>
            mod.l_d_uni_email === decodedToken.email &&
            mod.day === dayNameInSriLanka
        );
      } else {
        filteredModules = document.module.filter(
          (mod) =>
            (mod.module_code[2] === "C" || mod.module_code[2] === letter) &&
            mod.day === dayNameInSriLanka
        );
      }

      // Sort the filtered modules by start time in ascending order
      filteredModules.sort((a, b) => {
        const timeA = new Date(`1970-01-01T${a.start_time}:00Z`);
        const timeB = new Date(`1970-01-01T${b.start_time}:00Z`);
        return timeA - timeB;
      });

      return res.json(filteredModules);
    } else {
      console.log("No document found");
      return res.status(404).json({ message: "No document found" });
    }
  } catch (err) {
    console.error("Error fetching document:", err);
    return res.status(500).json({ message: "Internal server error" });
  }
};

//get modules by Day

module.exports.getFilterByDate = async (req, res) => {
  const { tokenWithLetter, date } = req.body;

  //Example dateString = '2024-08-11'
  const dateString = new Date(date);
  const day = new Intl.DateTimeFormat("en-US", { weekday: "long" }).format(
    dateString
  );
  //console.log(day);

  try {
    const token = tokenWithLetter.slice(0, -1);
    const letter = tokenWithLetter.slice(-1);
    const decodedToken = verifyToken(token);
    const user_id = decodedToken.id;
    // Fetch the document
    const document = await UserModuleModel.findOne({ user_id: user_id });

    if (document) {
      let filteredModules;

      // Filter the modules based on user role
      if (decodedToken.role !== "Student") {
        filteredModules = document.module.filter(
          (mod) => mod.l_d_uni_email === decodedToken.email && mod.day === day
        );
      } else {
        filteredModules = document.module.filter(
          (mod) =>
            (mod.module_code[2] === "C" || mod.module_code[2] === letter) &&
            mod.day === day
        );
      }

      // Sort the filtered modules by start time in ascending order
      filteredModules.sort((a, b) => {
        const timeA = new Date(`1970-01-01T${a.start_time}:00Z`);
        const timeB = new Date(`1970-01-01T${b.start_time}:00Z`);
        return timeA - timeB;
      });

      return res.json(filteredModules);
    } else {
      console.log("No document found");
      return res.status(404).json({ message: "No document found" });
    }
  } catch (err) {
    console.error("Error fetching document:", err);
    return res.status(500).json({ message: "Internal server error" });
  }
};
