const mongoose = require("mongoose");

const LabLectureHallSchema = new mongoose.Schema({
  hl_name: { type: String, required: true },
  open_close: { type: Boolean, required: true },
  date: { type: Date, required: true },
  start_time: { type: String, required: true },
  end_time: { type: String, required: true },
  availability: { type: Boolean, required: true },
});

module.exports = mongoose.model("LabLectureHall", LabLectureHallSchema);
