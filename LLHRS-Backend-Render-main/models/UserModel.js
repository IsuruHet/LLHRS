const mongoose = require("mongoose");

const userRolesEnum = [
  "Admin",
  "Lecturer",
  "Demonstrator",
  "Student",
  "DoorOpener",
];

const UserSchema = new mongoose.Schema({
  user_id: { type: String, required: true, unique: true },
  first_name: { type: String, required: true },
  last_name: { type: String, required: true },
  uni_email: { type: String, required: true, unique: true },
  password: { type: String, required: true },
  role: { type: String, enum: userRolesEnum, required: true },
  verification_token: { type: String },
  isVerified: { type: Boolean, default: false, required: true },
  resetToken: { type: String, default: null },
  resetTokenExpiration: { type: Date, default: null },
});

module.exports = mongoose.model("User", UserSchema);
