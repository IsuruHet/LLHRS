const ReminderModel = require("../models/ReminderModel");

module.exports.getAllReminders = async (req, res) => {
  try {
    const reminders = await ReminderModel.find().populate("user_id");
    res.json(reminders);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

module.exports.createNewReminder = async (req, res) => {
  const reminder = new ReminderModel({
    user_id: req.body.user_id,
    r_message: req.body.r_message,
  });

  try {
    const newReminder = await reminder.save();
    res.status(201).json(newReminder);
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
};
