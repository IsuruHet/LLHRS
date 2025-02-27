const express = require("express");
const router = express.Router();

const {
  addUserModules,
  deleteUserModules,
  updateUserModules,
  getFilterModules,
  getFilterByDate,
} = require("../controllers/UserModuleControllers");

router.post("/addmodules", addUserModules);
router.delete("/deletemodules", deleteUserModules);
router.put("/updatemodules", updateUserModules);
router.post("/filtermodules", getFilterModules);
router.post("/filterbydate", getFilterByDate);

module.exports = router;
