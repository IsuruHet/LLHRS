const mongoose = require("mongoose");

const moduleTypeEnum = ["Practical", "Lecture", "Tutorial"];
const semesterEnum = ["01", "02", "03", "04", "05", "06", "07", "08"];

const TemporaryRescheduleModuleSchema = new mongoose.Schema({
  module_code: { type: String, required: true },
  module_name: { type: String, required: true },
  module_type: { type: String, enum: moduleTypeEnum, required: true },
  hl_name: { type: String, required: true },
  capacity: { type: Number, required: true },
  semester: { type: String, enum: semesterEnum, required: true },
  academic_year: { type: String, required: true },
  l_d_uni_email: { type: String, required: true },
  start_time: { type: String, required: true },
  end_time: { type: String, required: true },
  date: { type: String, required: true },
});

module.exports = mongoose.model(
  "TemporaryRescheduleModule",
  TemporaryRescheduleModuleSchema
);
