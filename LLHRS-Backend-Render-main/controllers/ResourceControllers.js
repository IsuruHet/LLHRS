const ResourceModel = require("../models/ResourceModel");

module.exports.getAllResources = async (req, res) => {
  try {
    const resources = await ResourceModel.find();
    res.json(resources);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

module.exports.createNewResource = async (req, res) => {
  const resource = new ResourceModel({
    hl_name: req.body.hl_name,
    resource: req.body.resource,
  });

  try {
    const newResource = await resource.save();
    res.status(201).json(newResource);
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
};
