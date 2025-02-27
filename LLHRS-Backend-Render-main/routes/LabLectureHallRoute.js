const express = require("express");
const router = express.Router();
const {
  getAllLabLectureHalls,
  createNewLabLectureHall,
} = require("../controllers/LabLectureHallControllers");

router.get("/all", getAllLabLectureHalls);
router.post("/new", createNewLabLectureHall);

module.exports = router;
