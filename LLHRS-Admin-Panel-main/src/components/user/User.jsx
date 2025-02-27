import { useState, useEffect } from "react";
import axiosInstance from "../../../axiosInstance";
import "./User.css";
import { useNavigate } from "react-router-dom";
import addIcon from "../../assets/add.png";

function User() {
  const [users, setUsers] = useState([]);
  const [filters, setFilters] = useState({
    uni_email: "",
    user_id: "",
    role: "",
  });

  const navigate = useNavigate();

  const fetchUsers = async () => {
    try {
      const response = await axiosInstance.get("/api/users/filter", {
        params: filters,
      });
      setUsers(response.data);
    } catch (error) {
      console.error(error);
    }
  };

  useEffect(() => {
    fetchUsers();
  }, [filters]);

  const handleDelete = async (userID) => {
    const confirmDelete = window.confirm(
      "Are you sure you want to delete this user?"
    );
    if (confirmDelete) {
      try {
        await axiosInstance.delete(`/api/users/delete/${userID}`);
        setUsers(users.filter((user) => user.user_id !== userID));
      } catch (error) {
        console.error(error);
      }
    } else {
      console.log("User deletion canceled.");
    }
  };

  const handleCreate = () => {
    navigate("/create-user");
  };

  const handleVerify = async (userID) => {
    try {
      const response = await axiosInstance.post("/api/users/verify", {
        userID,
      });
      alert(response.data.message);
      fetchUsers(); // Refetch users to update the verification status
    } catch (error) {
      console.error(error);
    }
  };

  return (
    <div className="user-list-container">
      <div className="navbar-container">
        <span className="logo">
          <img
            src="//lms.tech.sjp.ac.lk/pluginfile.php/1/theme_klass/logo/1726723952/LMS%20Heading%20White.png"
            alt="LMS_USJ_FOT"
          />
        </span>
      </div>

      <div className="filter-container">
        <button className="create-button" onClick={handleCreate}>
          New
          <img src={addIcon} alt="Add" className="icon" />
        </button>
        <input
          type="text"
          placeholder="Uni Email"
          value={filters.uni_email}
          onChange={(e) =>
            setFilters({ ...filters, uni_email: e.target.value })
          }
        />
        <input
          type="text"
          placeholder="User ID"
          value={filters.user_id}
          onChange={(e) => setFilters({ ...filters, user_id: e.target.value })}
        />

        <select
          id="role"
          name="role"
          value={filters.role}
          onChange={(e) => setFilters({ ...filters, role: e.target.value })}
        >
          <option value="">Role</option>
          <option value="Lecturer">Lecturer</option>
          <option value="Student">Student</option>
          <option value="Demonstrator">Demonstrator</option>
          {/* <option value="DoorOpener">Door Opener</option> */}
        </select>
      </div>
      <div className="user-table-wrapper">
        <h1>Users</h1>
        <table className="user-table">
          <thead>
            <tr>
              <th>User ID</th>
              <th>First Name</th>
              <th>Last Name</th>
              <th>Uni Email</th>
              <th>Role</th>
              <th>Verification</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody>
            {users.length > 0 ? (
              users.map((user) => (
                <tr key={user.user_id}>
                  <td>{user.user_id}</td>
                  <td>{user.first_name}</td>
                  <td>{user.last_name}</td>
                  <td>{user.uni_email}</td>
                  <td>{user.role}</td>
                  <td>{user.isVerified ? "Verified" : "Not Verified"}</td>
                  <td>
                    {user.role !== "Admin" ? (
                      <div className="update-delete-btn-container">
                        {!user.isVerified ? (
                          <button onClick={() => handleVerify(user.user_id)}>
                            Verify
                          </button>
                        ) : (
                          <button disabled>Verified</button>
                        )}
                        <button
                          className="delete-btn"
                          onClick={() => handleDelete(user.user_id)}
                        >
                          Remove
                        </button>
                      </div>
                    ) : (
                      "Super User"
                    )}
                  </td>
                </tr>
              ))
            ) : (
              <tr>
                <td colSpan="7">No users available</td>
              </tr>
            )}
          </tbody>
        </table>
      </div>
    </div>
  );
}

export default User;
