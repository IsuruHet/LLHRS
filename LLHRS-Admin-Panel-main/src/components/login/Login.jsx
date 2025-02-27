import { useState } from "react";
import "./Login.css";
import axiosInstance from "../../../axiosInstance";
import { useNavigate, Link } from "react-router-dom";
import { useAuth } from "../../context/AuthContext";

function Login() {
  const [userID, setUserID] = useState("");
  const [password, setPassword] = useState("");
  const [loginStatus, setLoginStatus] = useState("");

  const navigate = useNavigate();
  const { login } = useAuth();

  const handleSubmit = async (e) => {
    e.preventDefault();
    setLoginStatus("");

    try {
      const response = await axiosInstance.post("api/users/login", {
        userID,
        password,
      });

      if (response.status === 200) {
        setLoginStatus("Login successful!");
        const { token } = response.data;

        login(token); // Update the auth context

        navigate("/modules");
      } else {
        setLoginStatus(response.data.message || "Login failed!");
      }
    } catch (error) {
      setLoginStatus("An error occurred. Please try again.");
    }
  };

  return (
    <div className="container">
      <h2 className="card-header text-center">
        <img
          src="https://lms.tech.sjp.ac.lk/pluginfile.php/1/core_admin/logo/0x200/1726723952/LMS%20Heading%20Small.png"
          title="Learning Management System - Faculty of Technology"
          alt="Learning Management System - Faculty of Technology"
        />
      </h2>
      <div className="login-text">Admin Panel</div>
      <form onSubmit={handleSubmit}>
        <label htmlFor="userID">User ID</label>
        <input
          type="text"
          id="userID"
          autoComplete="username"
          value={userID}
          onChange={(e) => setUserID(e.target.value)}
        />

        <label htmlFor="password">Password</label>
        <input
          type="password"
          id="password"
          autoComplete="current-password"
          value={password}
          onChange={(e) => setPassword(e.target.value)}
        />

        <Link to="/forgot-password">Forgot Password?</Link>
        <div
          className={`login-state ${
            loginStatus.includes("successful") ? "success" : "fail"
          }`}
        >
          {loginStatus}
        </div>

        <button type="submit">Login</button>
      </form>
    </div>
  );
}

export default Login;
