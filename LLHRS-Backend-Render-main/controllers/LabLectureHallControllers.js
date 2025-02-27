const LabLectureHallModel = require("../models/LabLectureHallModel");

module.exports.getAllLabLectureHalls = async (req, res) => {
  try {
    const halls = await LabLectureHallModel.find();
    res.json(halls);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};
module.exports.createNewLabLectureHall = async (req, res) => {
  const hall = new LabLectureHallModel({
    hl_name: req.body.hl_name,
    open_close: req.body.open_close,
    date: req.body.date,
    start_time: req.body.start_time,
    end_time: req.body.end_time,
    availability: req.body.availability,
  });

  try {
    const newHall = await hall.save();
    res.status(201).json(newHall);
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
};
