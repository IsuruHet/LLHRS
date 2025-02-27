const express = require("express");
const cors = require("cors");
const connectDB = require("./db");
const dotenv = require("dotenv");
const helmet = require("helmet");
const rateLimit = require("express-rate-limit");
const cookieParser = require("cookie-parser");
const path = require("path");

// Load environment variables from .env file
dotenv.config();

const app = express();

// Middleware Functions
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(helmet()); // Add Helmet to enhance security
app.use(cookieParser()); // Use cookie-parser

// CORS Configuration
const corsOptions = {
  origin: process.env.CLIENT_URL, // Replace with your frontend URL
  credentials: true, // Allow credentials (cookies) to be sent
};
app.use(cors(corsOptions));

// Rate Limiting
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100, // Limit each IP to 100 requests per windowMs
});
app.use(limiter);

// Connect to DB
connectDB();

// Define Routes
app.use("/api/users", require("./routes/UserRoute"));
app.use("/api/modules", require("./routes/ModuleRoute"));
app.use("/api/usermodules", require("./routes/UserModuleRoute"));
app.use("/api/lablecturehalls", require("./routes/LabLectureHallRoute"));
app.use("/api/reschedule", require("./routes/RescheduleModuleRoute"));

// Error Handling Middleware
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).send("Something went wrong!");
});

// Set EJS as the templating engine
app.set("view engine", "ejs");
// Set the directory where the EJS templates are located
app.set("views", path.join(__dirname, "views"));

const PORT = process.env.PORT || 5000;

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});

// Define a route for testing
app.get("/", (req, res) => {
  res.send("Hello, HTTPS world!");
});
