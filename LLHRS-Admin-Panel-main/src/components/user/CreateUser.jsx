import { useState } from "react";
import axiosInstance from "../../../axiosInstance";
import "./CreateUser.css";

function CreateUser() {
  const [formData, setFormData] = useState({
    first_name: "",
    last_name: "",
    uni_email: "",
    password: "",
    role: "",
  });

  const handleChange = (e) => {
    setFormData({ ...formData, [e.target.name]: e.target.value });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      await axiosInstance.post("/api/users/register", formData);
      alert("User added successfully");
      setFormData({
        first_name: "",
        last_name: "",
        uni_email: "",
        password: "",
        role: "",
      });
    } catch (error) {
      console.error(error);
      alert("Failed to create user");
    }
  };

  return (
    <div className="container">
      <div className="create-user">
        <h1>Add User</h1>
        <form onSubmit={handleSubmit}>
          <div className="form-group">
            <label htmlFor="first_name">First Name</label>
            <input
              type="text"
              id="first_name"
              className="capitalize-text"
              name="first_name"
              placeholder="First Name"
              value={formData.first_name}
              onChange={handleChange}
            />
          </div>
          <div className="form-group">
            <label htmlFor="last_name">Last Name</label>
            <input
              type="text"
              id="last_name"
              className="capitalize-text"
              name="last_name"
              placeholder="Last Name"
              value={formData.last_name}
              onChange={handleChange}
            />
          </div>

          <div className="form-group">
            <label htmlFor="uni_email">Uni Email</label>
            <input
              type="email"
              id="uni_email"
              name="uni_email"
              placeholder="Uni Email"
              value={formData.uni_email}
              onChange={handleChange}
            />
          </div>

          <div className="form-group">
            <label htmlFor="password">Password</label>
            <input
              type="password"
              id="password"
              name="password"
              placeholder="Password"
              value={formData.password}
              onChange={handleChange}
            />
          </div>

          <div className="form-group">
            <label htmlFor="role">Role</label>
            <select
              id="role"
              name="role"
              onChange={handleChange}
              value={formData.role}
            >
              <option value="">Select User Role</option>
              <option value="Lecturer">Lecturer</option>
              <option value="Student">Student</option>
              <option value="Demonstrator">Demonstrator</option>
              {/* <option value="DoorOpener">Door Opener</option> */}
            </select>
          </div>
          <button type="submit">Add User</button>
        </form>
      </div>
    </div>
  );
}

export default CreateUser;
