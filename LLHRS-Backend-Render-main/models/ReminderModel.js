const mongoose = require("mongoose");

const ReminderSchema = new mongoose.Schema({
  user_id: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "User",
    required: true,
  },
  r_message: { type: String, required: true },
});

module.exports = mongoose.model("Reminder", ReminderSchema);
