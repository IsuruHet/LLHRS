import { useState, useEffect } from "react";
import axiosInstance from "../../../axiosInstance";
import { useNavigate } from "react-router-dom";
import "./ModuleList.css";
import { useAuth } from "../../context/AuthContext";
import logoutIcon from "../../assets/logout.png";
import usersIcon from "../../assets/users.png";
import addIcon from "../../assets/add.png";

function ModuleList() {
  const [modules, setModules] = useState([]);
  const [filters, setFilters] = useState({
    module_name: "",
    module_code: "",
    hl_name: "",
  });

  const navigate = useNavigate();
  const { logout } = useAuth();

  const fetchModules = async () => {
    try {
      const response = await axiosInstance.get("/api/modules/filter", {
        params: filters,
      });
      setModules(response.data);
    } catch (error) {
      console.error(error);
    }
  };

  useEffect(() => {
    fetchModules();
  }, [filters]);

  const handleDelete = async (moduleDel) => {
    const confirmDelete = window.confirm(
      "Are you sure you want to delete this module?"
    );

    if (!confirmDelete) {
      console.log("Module deletion canceled.");
      return;
    }

    try {
      await axiosInstance.delete(
        `/api/modules/delete/${moduleDel.module_code}/${moduleDel.module_type}`
      );

      setModules((prevModules) =>
        prevModules.filter(
          (module) =>
            module.module_code !== moduleDel.module_code ||
            module.module_type !== moduleDel.module_type
        )
      );
    } catch (error) {
      console.error("Error deleting module:", error);
      alert("Failed to delete module. Please try again.");
    }
  };

  const handleUpdate = (module) => {
    navigate(
      `/update?module_code=${module.module_code}&module_type=${module.module_type}`
    );
  };

  const handleCreate = () => {
    navigate("/create");
  };

  const handleUser = () => {
    navigate("/users");
  };

  const handleLogout = () => {
    logout();
  };

  return (
    <div className="module-list-container">
      <div className="navbar-container">
        <span className="logo">
          <img
            src="//lms.tech.sjp.ac.lk/pluginfile.php/1/theme_klass/logo/1726723952/LMS%20Heading%20White.png"
            alt="LMS_USJ_FOT"
          />
        </span>
      </div>

      <div className="filter-container">
        <button onClick={handleCreate} className="create-button">
          New
          <img src={addIcon} alt="Add" className="icon" />
        </button>
        <button onClick={handleUser} className="user-button">
          <img src={usersIcon} alt="Users" className="icon" />
          Users
        </button>

        <button onClick={handleLogout} className="logout-button">
          <img src={logoutIcon} alt="Logout" className="icon" />
          Logout
        </button>
        <input
          type="text"
          placeholder="Module Name"
          value={filters.module_name}
          onChange={(e) =>
            setFilters({ ...filters, module_name: e.target.value })
          }
        />
        <input
          type="text"
          placeholder="Module Code"
          value={filters.module_code}
          onChange={(e) =>
            setFilters({ ...filters, module_code: e.target.value })
          }
        />
        <input
          type="text"
          placeholder="Hall/Lab Name"
          value={filters.hl_name}
          onChange={(e) => setFilters({ ...filters, hl_name: e.target.value })}
        />
      </div>
      <div className="module-table-wrapper">
        <h1>Time Table</h1>
        <table className="module-table">
          <thead>
            <tr>
              <th>Module Code</th>
              <th>Module Name</th>
              <th>Module Type</th>
              <th>Hall/Lab Name</th>
              <th>Capacity</th>
              <th>Semester</th>
              <th>Academic Year</th>
              <th>Lec/Demo Uni Email</th>
              <th>Start Time</th>
              <th>End Time</th>
              <th>Day</th>
              <th>Reschedule</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody>
            {modules.length > 0 ? (
              modules.map((module) => (
                <tr key={module.module_code}>
                  <td>{module.module_code}</td>
                  <td>{module.module_name}</td>
                  <td>{module.module_type}</td>
                  <td>{module.hl_name}</td>
                  <td>{module.capacity}</td>
                  <td>{module.semester}</td>
                  <td>{module.academic_year}</td>
                  <td>{module.l_d_uni_email}</td>
                  <td>{module.start_time}</td>
                  <td>{module.end_time}</td>
                  <td>{module.day}</td>
                  <td>
                    {module.reschedule ? "Rescheduled" : "Not Rescheduled"}
                  </td>
                  <td>
                    <div className="update-delete-btn-container">
                      <button onClick={() => handleUpdate(module)}>
                        Update
                      </button>
                      <button
                        className="delete-btn"
                        onClick={() => handleDelete(module)}
                      >
                        Delete
                      </button>
                    </div>
                  </td>
                </tr>
              ))
            ) : (
              <tr>
                <td colSpan="11">No modules available</td>
              </tr>
            )}
          </tbody>
        </table>
      </div>
    </div>
  );
}

export default ModuleList;
