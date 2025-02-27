const express = require("express");
const router = express.Router();

const {
  getAllUsers,
  createNewUser,
  loginUser,
  authUser,
  logoutUser,
  verifyEmail,
  getFilteredUsers,
  deleteExistingUser,
  adminVerifyUser,
  verifyTokenResonse,
  forgotPassword,
  resetPassword,
  resetPasswordVerify,
} = require("../controllers/UserControllers");

router.get("/all", authUser, getAllUsers);
router.post("/register", createNewUser);
router.post("/login", loginUser);
router.post("/logout", authUser, logoutUser);
router.get("/auth", authUser, verifyTokenResonse);
router.get("/verify-email", verifyEmail);
router.get("/filter", getFilteredUsers);
router.delete("/delete/:user_id", deleteExistingUser);
router.post("/verify", adminVerifyUser);
router.post("/forgotpassword", forgotPassword);
router.get("/resetpassword/:token", resetPasswordVerify);
router.post("/resetpassword", resetPassword);
module.exports = router;
