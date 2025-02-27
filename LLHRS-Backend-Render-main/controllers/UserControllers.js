const UserModel = require("../models/UserModel");
const UserModuleModel = require("../models/UserModuleModel");
const bcrypt = require("bcrypt");
const nodemailer = require("nodemailer");
const { generateToken, verifyToken } = require("../utils/jwt");
const crypto = require("crypto");

const createUserId = async (userRole) => {
  const firstLetter = String(userRole).charAt(0).toUpperCase();

  // Fetch the last created user
  const lastUser = await UserModel.findOne({ role: userRole }).sort({
    _id: -1,
  });

  let newNumber = 1; // Default to 0001 if no users found
  if (lastUser) {
    // Extract the four-digit number from the last user's ID
    const lastUserId = lastUser.user_id;
    const lastNumber = parseInt(lastUserId.substring(1), 10);
    newNumber = lastNumber + 1;
  }

  // Pad the number with leading zeros to ensure it is four digits
  const fourDigitNumber = String(newNumber).padStart(4, "0");

  return firstLetter + fourDigitNumber;
};

// Create a transporter
const transporter = nodemailer.createTransport({
  service: "gmail",
  auth: {
    user: process.env.EMAIL_ADDRESS, // Replace with your email
    pass: process.env.EMAIL_PASSWORD, // Replace with your email password
  },
});

const sendEmail = async (email, userId, verificationToken) => {
  console.log(
    `https://localhost:5000/api/users/verify-email?token=${verificationToken}`
  );

  // Set up email data
  let mailOptions = {
    from: "isuruhettiarachchi2001@gmail.com",
    to: email,
    subject: "Your New User ID",
    html: `
      <p>Welcome! Your new user ID is: ${userId}</p>
      <p>
        <a href="https://localhost:5000/api/users/verify-email?token=${verificationToken}" 
           style="display: inline-block; padding: 10px 20px; font-size: 16px; color: white; background-color: lightgreen; text-decoration: none; border-radius: 5px;">
           Verify Your Email
        </a>
      </p>
    `,
  };

  // Send the email
  await transporter.sendMail(mailOptions);
};

module.exports.getAllUsers = async (req, res) => {
  try {
    const users = await UserModel.find();
    res.json(users);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

// Register new user
module.exports.createNewUser = async (req, res) => {
  let userUniEmail = req.body.uni_email;
  let userRole = null;
  const validStarts = ["ict", "egt", "bst"];
  const endsWith = "fot.sjp.ac.lk";

  const startsWithValidPrefix = validStarts.some((prefix) =>
    userUniEmail.startsWith(prefix)
  );
  const endsWithValidSuffix = userUniEmail.endsWith(endsWith);

  if (startsWithValidPrefix || endsWithValidSuffix) {
    userRole = "Student";
  } else {
    userRole = req.body.role;
  }

  let userId;

  try {
    // Check if the user already exists with the provided email
    const existingUser = await UserModel.findOne({
      uni_email: req.body.uni_email,
    });
    if (existingUser) {
      return res
        .status(409)
        .json({ message: "User with this email already registered" });
    }

    userId = await createUserId(userRole);
    console.log(`Send this user_id via email User ID: ${userId}`);
  } catch (err) {
    return res.status(500).json({ message: err.message });
  }

  try {
    const hashedPassword = await bcrypt.hash(req.body.password, 10); // Hash password with a salt round of 10
    const verificationToken = crypto.randomBytes(32).toString("hex");
    const user = new UserModel({
      user_id: userId,
      first_name: req.body.first_name,
      last_name: req.body.last_name,
      uni_email: userUniEmail,
      password: hashedPassword, // Store hashed password
      role: userRole,
      verification_token: verificationToken,
      isVerified: false, // Set isVerified to false initially
    });

    const newUser = await user.save();

    // Send email with the user ID if the user is a student
    if (userRole === "Student") {
      await sendEmail(req.body.uni_email, userId, verificationToken);
    }

    res.status(201).json(newUser);
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
};

// Login user
module.exports.loginUser = async (req, res) => {
  const { userID, password } = req.body;

  try {
    const user = await UserModel.findOne({ user_id: userID });

    if (user) {
      // Check if the user is verified
      if (!user.isVerified) {
        return res.status(403).json({
          message:
            "Your email is not verified. Please check your email and verify your account.",
        });
      }

      if (await bcrypt.compare(password, user.password)) {
        // Compare hashed password with input password
        console.log("Login successful!..");

        // Generate jwt token
        const token = generateToken(user);
        console.log(`JWT token: ${token}`);

        // Send success response with token
        return res.status(200).json({ message: "Login successful!", token });
      } else {
        console.log("User ID or Password incorrect!");
        return res
          .status(401)
          .json({ message: "User ID or Password incorrect!" });
      }
    } else {
      console.log("User not found!");
      return res.status(404).json({ message: "User not found!" });
    }
  } catch (error) {
    console.log(error + " User not found");
    return res.status(500).json({ message: "Internal server error" });
  }
};

module.exports.logoutUser = async (req, res) => {
  res.status(200).json({ message: "Logout successful" });
};

module.exports.authUser = async (req, res, next) => {
  try {
    const token = req.header("Authorization").replace("Bearer ", "");
    const decoded = await verifyToken(token);
    req.user = decoded;
    next();
  } catch (error) {
    res.status(401).json({ message: "Unauthorized", error: error });
  }
};

module.exports.verifyTokenResonse = (req, res) => {
  res.status(200).json({ message: "Authorized", user: req.user });
};

// Verify student by uni email
module.exports.verifyEmail = async (req, res) => {
  const { token } = req.query;

  try {
    const user = await UserModel.findOne({ verification_token: token });

    if (!user) {
      return res.status(400).send("Invalid token");
    }

    user.isVerified = true;
    user.verification_token = undefined;
    await user.save();

    res.send("Email verified successfully");
  } catch (error) {
    res.status(500).send(error.message);
  }
};

// Admin verification function
module.exports.adminVerifyUser = async (req, res) => {
  const { userID } = req.body;

  try {
    const user = await UserModel.findOne({ user_id: userID });

    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    user.isVerified = true;
    await user.save();

    res.json({ message: "User verified successfully" });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

//get filtered users
module.exports.getFilteredUsers = async (req, res) => {
  const { uni_email, user_id, role } = req.query;

  try {
    const filter = {};
    if (uni_email) filter.uni_email = { $regex: uni_email, $options: "i" };
    if (user_id) filter.user_id = { $regex: user_id, $options: "i" };
    if (role) filter.role = { $regex: role, $options: "i" };

    const users = await UserModel.find(filter);
    res.json(users);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

//delete existing module
module.exports.deleteExistingUser = async (req, res) => {
  try {
    const deletedUser = await UserModel.findOneAndDelete({
      user_id: req.params.user_id,
    });
    if (!deletedUser) {
      return res.status(404).json({ message: "User not found" });
    }
    // Delete associated user modules from UserModuleModel
    await UserModuleModel.deleteMany({ user_id: req.params.user_id });

    res.json({ message: "User and associated modules deleted successfully" });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

//forget password implementation

module.exports.forgotPassword = async (req, res) => {
  const { uni_email } = req.body;

  try {
    // Find user by email
    const user = await UserModel.findOne({ uni_email: uni_email });

    if (!user) {
      return res.status(404).json({ message: "User not found." });
    }

    // Generate a unique token for password reset
    const token = generateToken(user);

    // Save the token to the user document
    user.resetToken = token;
    user.resetTokenExpiration = new Date(Date.now() + 3600000);
    await user.save();

    // Send reset password email to the user
    sendResetEmail(uni_email, token);

    res.status(200).json({ message: "Reset email sent successfully." });
  } catch (error) {
    console.error("Error:", error);
    res.status(500).json({ message: "Something went wrong." });
  }
};

module.exports.resetPasswordVerify = async (req, res) => {
  const { token } = req.params;

  try {
    // Find the user by the resetToken
    const user = await UserModel.findOne({ resetToken: token });
    if (user && user.resetTokenExpiration > Date.now()) {
      // Render the reset password page (assuming you're using a view engine like EJS, Pug, etc.)
      res.render("reset-password", { token, apiUrl: process.env.SERVER_URL });
    } else {
      return res.status(400).json({ message: "Invalid or expired token." });
    }
  } catch (error) {
    console.error("Error:", error);
    res.status(400).json({ message: "Invalid or expired token." });
  }
};

module.exports.resetPassword = async (req, res) => {
  const { token, password } = req.body;
  const hashedPassword = await bcrypt.hash(password, 10);

  try {
    // Verify the token
    const decoded = verifyToken(token);

    // Find the user by the token's user ID
    const user = await UserModel.findOne(decoded.uni_email);

    console.log("Token found" + user.resetToken);

    if (!user || user.resetToken !== token) {
      return res.status(400).json({ message: "Invalid or expired token." });
    }

    user.password = hashedPassword;
    user.resetToken = undefined; // Clear the reset token
    await user.save();

    res.status(200).json({ message: "Password reset successful." });
  } catch (error) {
    console.error("Error:", error);
    res.status(400).json({ message: "Invalid or expired token." });
  }
};

const sendResetEmail = (email, token) => {
  const resetLink = `${process.env.SERVER_URL}/api/users/resetpassword/${token}`;
  console.log(resetLink);
  const mailOptions = {
    from: process.env.EMAIL_ADDRESS,
    to: email,
    subject: "Password Reset Request",
    html: `<p>You are receiving this email because you (or someone else) have requested the reset of the password for your account.</p>
           <p>Please click on the following link to reset your password:</p>
           <a href="${resetLink}">${resetLink}</a>
           <p>If you did not request this, please ignore this email and your password will remain unchanged.</p>`,
  };

  transporter.sendMail(mailOptions, function (error, info) {
    if (error) {
      console.log(error);
    } else {
      console.log("Email sent: " + info.response);
    }
  });
};
