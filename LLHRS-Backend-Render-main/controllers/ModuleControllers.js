const ModuleModel = require("../models/ModuleModel");

//get existing module
module.exports.getExistingModule = async (req, res) => {
  try {
    const { module_code, module_type } = req.params;

    const module = await ModuleModel.findOne({
      module_code: module_code,
      module_type: module_type,
    });

    if (module) {
      res.json(module);
    } else {
      res.status(404).json({ message: "Module not found" });
    }
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

//get filtered modules
module.exports.getFilteredModules = async (req, res) => {
  const { module_name, module_code, hl_name } = req.query;

  try {
    const filter = {};
    if (module_name)
      filter.module_name = { $regex: module_name, $options: "i" };
    if (module_code)
      filter.module_code = { $regex: module_code, $options: "i" };
    if (hl_name) filter.hl_name = { $regex: hl_name, $options: "i" };

    const modules = await ModuleModel.find(filter);
    res.json(modules);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

//create new module
module.exports.createNewModule = async (req, res) => {
  try {
    const existingModule = await ModuleModel.findOne({
      module_code: req.body.module_code,
      module_type: req.body.module_type,
    });

    if (existingModule) {
      return res.status(400).json({
        message: `A ${req.body.module_type} for this module already exists.`,
      });
    }

    const module = new ModuleModel({
      module_code: req.body.module_code,
      module_name: req.body.module_name,
      module_type: req.body.module_type,
      hl_name: req.body.hl_name,
      capacity: req.body.capacity,
      semester: req.body.semester,
      academic_year: req.body.academic_year,
      l_d_uni_email: req.body.l_d_uni_email,
      start_time: req.body.start_time,
      end_time: req.body.end_time,
      day: req.body.day,
      reschedule: false,
    });

    const newModule = await module.save();
    res.status(201).json(newModule);
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
};

//update existing module
module.exports.updateExistingModule = async (req, res) => {
  try {
    const { module_code, module_type } = req.params;

    // Update the query to include `module_type`
    const updatedModule = await ModuleModel.findOneAndUpdate(
      { module_code, module_type }, // Query criteria
      req.body,
      { new: true, runValidators: true }
    );

    if (!updatedModule) {
      return res.status(404).json({ message: "Module not found" });
    }

    res.json(updatedModule);
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
};

//delete existing module
module.exports.deleteExistingModule = async (req, res) => {
  try {
    const { module_code, module_type } = req.params;

    const deletedModule = await ModuleModel.findOneAndDelete({
      module_code: { $eq: module_code },
      module_type: { $eq: module_type },
    });

    if (!deletedModule) {
      return res.status(404).json({
        message:
          "Module not found. Ensure both module code and type are correct.",
      });
    }

    res.json({ message: "Module deleted successfully" });
  } catch (err) {
    res.status(500).json({ message: `Error deleting module: ${err.message}` });
  }
};
