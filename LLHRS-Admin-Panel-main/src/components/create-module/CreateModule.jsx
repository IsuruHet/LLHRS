import { useState } from "react";
import axiosInstance from "../../../axiosInstance";
import "./CreateModule.css";

function CreateModule() {
  const [formData, setFormData] = useState({
    module_code: "",
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

  const handleChange = (e) => {
    setFormData({ ...formData, [e.target.name]: e.target.value });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      await axiosInstance.post("/api/modules/new", formData);
      alert("Module created successfully");
      setFormData({
        module_code: "",
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
    } catch (error) {
      console.error(error);
      const errorMessage =
        error.response?.data?.message || "Failed to create module";
      alert(errorMessage);
    }
  };

  return (
    <div className="container">
      <div className="create-module">
        <h1>Create Module</h1>
        <form onSubmit={handleSubmit}>
          <div className="form-group">
            <label htmlFor="module_code">Module Code</label>
            <input
              type="text"
              id="module_code"
              className="uppercase-text"
              name="module_code"
              placeholder="Module Code"
              value={formData.module_code}
              onChange={handleChange}
            />
          </div>
          <div className="form-group">
            <label htmlFor="module_name">Module Name</label>
            <input
              type="text"
              id="module_name"
              name="module_name"
              placeholder="Module Name"
              value={formData.module_name}
              onChange={handleChange}
            />
          </div>
          <div className="form-group">
            <label htmlFor="module_type">Module Type</label>
            <select
              id="module_type"
              name="module_type"
              onChange={handleChange}
              value={formData.module_type}
            >
              <option value="">Select Module Type</option>
              <option value="Lecture">Lecture</option>
              <option value="Practical">Practical</option>
              <option value="Tutorial">Tutorial</option>
            </select>
          </div>
          <div className="form-group">
            <label htmlFor="hl_name">Hall/Lab Name</label>
            <input
              type="text"
              id="hl_name"
              className="uppercase-text"
              name="hl_name"
              placeholder="Hall/Lab Name"
              value={formData.hl_name}
              onChange={handleChange}
            />
          </div>
          <div className="form-group">
            <label htmlFor="capacity">Capacity</label>
            <input
              type="number"
              id="capacity"
              name="capacity"
              placeholder="Capacity"
              value={formData.capacity}
              onChange={handleChange}
            />
          </div>
          <div className="form-group">
            <label htmlFor="semester">Semester</label>
            <select
              id="semester"
              name="semester"
              onChange={handleChange}
              value={formData.semester}
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
              value={formData.academic_year}
              onChange={handleChange}
            />
            <div>
              <datalist id="academic_years">
                <option value="2018/19" />
                <option value="2019/20" />
                <option value="2020/21" />
                <option value="2021/22" />
                <option value="2022/23" />
              </datalist>
            </div>
          </div>
          <div className="form-group">
            <label htmlFor="l_d_uni_email">
              Lecture/Demonstrator Uni Email
            </label>
            <input
              type="email"
              id="l_d_uni_email"
              name="l_d_uni_email"
              placeholder="Lecture/Demonstrator Uni Email"
              value={formData.l_d_uni_email}
              onChange={handleChange}
            />
          </div>
          <div className="form-group">
            <label htmlFor="start_time">Start Time</label>
            <input
              type="time"
              id="start_time"
              name="start_time"
              value={formData.start_time}
              onChange={handleChange}
            />
          </div>
          <div className="form-group">
            <label htmlFor="end_time">End Time</label>
            <input
              type="time"
              id="end_time"
              name="end_time"
              value={formData.end_time}
              onChange={handleChange}
            />
          </div>
          <div className="form-group">
            <label htmlFor="day">Day</label>
            <select
              id="day"
              name="day"
              onChange={handleChange}
              value={formData.day}
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
          <button type="submit">Create Module</button>
        </form>
      </div>
    </div>
  );
}

export default CreateModule;
