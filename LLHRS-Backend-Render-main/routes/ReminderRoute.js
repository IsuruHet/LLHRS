const express = require("express");
const router = express.Router();
const {
  getAllReminders,
  createNewReminder,
} = require("../controllers/ReminderControllers");

router.get("/all", getAllReminders);
router.post("/new", createNewReminder);

module.exports = router;
