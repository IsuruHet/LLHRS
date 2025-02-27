const mongoose = require("mongoose");

const ResourceSchema = new mongoose.Schema({
  hl_name: { type: String, required: true },
  resource: { type: Number, required: true },
});

module.exports = mongoose.model("Resource", ResourceSchema);
