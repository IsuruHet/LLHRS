const jwt = require("jsonwebtoken");
const dotenv = require("dotenv");

dotenv.config();

const generateToken = (user) => {
  const yearString = user.uni_email.slice(3, 5);
  let academicYear = `20${yearString - 1}/${yearString}`;
  const degreeString = user.uni_email.slice(0, 3).toLocaleUpperCase().split("");
  let degree = degreeString[0] + degreeString[2];
  let firstName = user.first_name;
  let lastName = user.last_name;
  let role = user.role;

  if (user.role !== "Student") {
    academicYear = null;
    degree = null;
  }

  return jwt.sign(
    {
      id: user.user_id,
      firstName: firstName,
      lastName: lastName,
      role: role,
      email: user.uni_email,
      academicYear: academicYear,
      degree: degree,
    },
    process.env.JWT_SECRET,
    { expiresIn: "7d" }
  );
};

const verifyToken = (token) => {
  return jwt.verify(token, process.env.JWT_SECRET);
};

module.exports = { generateToken, verifyToken };
