const express = require("express");
const router = express.Router();
const {
  getExistingModule,
  getFilteredModules,
  createNewModule,
  updateExistingModule,
  deleteExistingModule,
} = require("../controllers/ModuleControllers");

router.get("/get/:module_code/:module_type", getExistingModule);
router.get("/filter", getFilteredModules);
router.post("/new", createNewModule);
router.put("/change/:module_code/:module_type", updateExistingModule);
router.delete("/delete/:module_code/:module_type", deleteExistingModule);

module.exports = router;
