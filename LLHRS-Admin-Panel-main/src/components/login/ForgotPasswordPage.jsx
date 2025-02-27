import { useState } from "react";
import "./forgot-password.css";
import axiosInstance from "../../../axiosInstance";

function ForgotPasswordPage() {
  const [uni_email, setUniEmail] = useState("");
  const [message, setMessage] = useState("");

  const handleForgotPassword = async () => {
    try {
      const response = await axiosInstance.post("api/users/forgotpassword", {
        uni_email,
      });
      setMessage(response.data.message);
      console.log(response.data.message);
    } catch (error) {
      setMessage(
        "Somthing went wrong. Please try again later. " + error.message
      );
    }
  };

  return (
    <div className="forgot-password-container">
      <h2>Forgot Password</h2>
      <input
        type="email"
        placeholder="Enter your uni_email"
        value={uni_email}
        onChange={(e) => setUniEmail(e.target.value)}
        className="forgot-email-input"
      />
      <button onClick={handleForgotPassword} className="forgot-button">
        Reset Password
      </button>
      {message && <p>{message}</p>}
    </div>
  );
}

export default ForgotPasswordPage;
