const express = require("express");
const router = express.Router();
const {
  getAllResources,
  createNewResource,
} = require("../controllers/ResourceControllers");

router.get("/all", getAllResources);
router.post("/new", createNewResource);

module.exports = router;
