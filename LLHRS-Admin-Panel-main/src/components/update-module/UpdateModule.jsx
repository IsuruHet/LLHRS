import { useState, useEffect } from "react";
import { useNavigate, useLocation } from "react-router-dom";
import axiosInstance from "../../../axiosInstance";
import "./UpdateModule.css"; // Ensure you have the correct path to your CSS file

function UpdateModule() {
  const navigate = useNavigate();
  const location = useLocation();
  const queryParams = new URLSearchParams(location.search);
  const moduleCode = queryParams.get("module_code");
  const moduleType = queryParams.get("module_type");

  const [module, setModule] = useState({
    module_name: "",
    module_type: "",
    hl_name: "",
    capacity: "",
    semester: "",
    academic_year: "",
    l_d_uni_email: "",
    start_time: "",
    end_time: "",
    day: "",
  });

  useEffect(() => {
    const fetchModule = async () => {
      try {
        const response = await axiosInstance.get(
          `/api/modules/get/${moduleCode}/${moduleType}`
        );
        setModule(response.data);
      } catch (error) {
        console.error("Error fetching module:", error);
      }
    };

    if (moduleCode && moduleType) {
      fetchModule();
    }
  }, [moduleCode, moduleType]);

  const handleChange = (e) => {
    const { name, value } = e.target;
    setModule((prevModule) => ({
      ...prevModule,
      [name]: value,
    }));
  };

  const handleSubmit = async (e) => {
    e.preventDefault();

    try {
      // Update the module
      await axiosInstance.put(
        `/api/modules/change/${moduleCode}/${moduleType}`,
        module
      );

      // Clean up user modules and update them
      await axiosInstance.delete("/api/usermodules/deletemodules");
      await axiosInstance.put("/api/usermodules/updatemodules");

      // Notify the user of success
      alert("System updated successfully");
      navigate("/modules");
    } catch (error) {
      console.error("Error updating system:", error);
    }
  };

  return (
    <div className="update-module-container">
      <h1>Update Module</h1>
      <form onSubmit={handleSubmit} className="update-module-form">
        <div className="form-group">
          <label>Module Name</label>
          <input
            type="text"
            name="module_name"
            value={module.module_name}
            onChange={handleChange}
            required
          />
        </div>
        <div className="form-group">
          <label>Module Type</label>
          <select
            name="module_type"
            onChange={handleChange}
            value={module.module_type}
            required
          >
            <option value="">Select Module Type</option>
            <option value="Lecture">Lecture</option>
            <option value="Practical">Practical</option>
            <option value="Tutorial">Tutorial</option>
          </select>
        </div>
        <div className="form-group">
          <label>Hall/Lab Name</label>
          <input
            type="text"
            name="hl_name"
            value={module.hl_name}
            onChange={handleChange}
            required
          />
        </div>
        <div className="form-group">
          <label>Capacity</label>
          <input
            type="number"
            name="capacity"
            value={module.capacity}
            onChange={handleChange}
          />
        </div>
        <div className="form-group">
          <label htmlFor="semester">Semester</label>
          <select
            id="semester"
            name="semester"
            onChange={handleChange}
            value={module.semester}
          >
            <option value="">Select Semester</option>
            <option value="01">01</option>
            <option value="02">02</option>
            <option value="03">03</option>
            <option value="04">04</option>
            <option value="05">05</option>
            <option value="06">06</option>
            <option value="07">07</option>
            <option value="08">08</option>
          </select>
        </div>
        <div className="form-group">
          <label htmlFor="academic_year">Academic Year</label>
          <input
            list="academic_years"
            id="academic_year"
            name="academic_year"
            placeholder="Select Academic Year"
            value={module.academic_year}
            onChange={handleChange}
          />
          <datalist id="academic_years">
            <option value="2018/19" />
            <option value="2019/20" />
            <option value="2020/21" />
            <option value="2021/22" />
            <option value="2022/23" />
          </datalist>
        </div>
        <div className="form-group">
          <label htmlFor="l_d_uni_email">Lecture/Demonstrator Uni Email</label>
          <input
            type="email"
            id="l_d_uni_email"
            name="l_d_uni_email"
            placeholder="Lecture/Demonstrator Uni Email"
            value={module.l_d_uni_email}
            onChange={handleChange}
          />
        </div>
        <div className="form-group">
          <label>Start Time</label>
          <input
            type="time"
            name="start_time"
            value={module.start_time}
            onChange={handleChange}
            required
          />
        </div>
        <div className="form-group">
          <label>End Time</label>
          <input
            type="time"
            name="end_time"
            value={module.end_time}
            onChange={handleChange}
            required
          />
        </div>
        <div className="form-group">
          <label>Day</label>
          <select
            name="day"
            onChange={handleChange}
            value={module.day}
            required
          >
            <option value="">Select Day</option>
            <option value="Monday">Monday</option>
            <option value="Tuesday">Tuesday</option>
            <option value="Wednesday">Wednesday</option>
            <option value="Thursday">Thursday</option>
            <option value="Friday">Friday</option>
            <option value="Saturday">Saturday</option>
            <option value="Sunday">Sunday</option>
          </select>
        </div>
        <button type="submit">Update Module</button>
      </form>
    </div>
  );
}

export default UpdateModule;
