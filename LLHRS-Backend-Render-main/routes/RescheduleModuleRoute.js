const express = require("express");
const router = express.Router();
const {
  availableHallOrLab,
  rescheduleModule,
  delRescheduled,
  approveReschedule,
  getFilterRescheduledModules,
} = require("../controllers/RescheduleModuleControllers");

router.post("/available", availableHallOrLab);
router.post("/reschedule", rescheduleModule);
router.delete("/delrescheduled", delRescheduled);
router.get("/approve", approveReschedule);
router.post("/filtermodules", getFilterRescheduledModules);

module.exports = router;
