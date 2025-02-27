const mongoose = require("mongoose");
const degreeEnum = ["IT", "ET", "BT"];
const UserModuleSchema = new mongoose.Schema({
  module: [{ type: mongoose.Schema.Types.Mixed, required: true }],
  academic_year: { type: String, default: null },
  user_id: { type: String, required: true, unique: true },
  degree_name: { type: String, enum: degreeEnum },
});

module.exports = mongoose.model("UserModule", UserModuleSchema);
