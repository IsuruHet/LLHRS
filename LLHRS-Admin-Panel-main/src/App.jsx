// App.jsx
import "./App.css";
import { BrowserRouter as Router, Route, Routes } from "react-router-dom";
import ModuleList from "./components/module-list/ModuleList";
import CreateModule from "./components/create-module/CreateModule";
import UpdateModule from "./components/update-module/UpdateModule";
import Login from "./components/login/Login";
import ForgotPasswordPage from "./components/login/ForgotPasswordPage";
import ProtectedRoute from "./components/ProtectedRoute";
import User from "./components/user/User";
import CreateUser from "./components/user/CreateUser";
import { AuthProvider } from "./context/AuthContext";

function App() {
  return (
    <AuthProvider>
      <Router>
        <Routes>
          <Route path="/" element={<Login />} />
          <Route
            path="/modules"
            element={<ProtectedRoute element={<ModuleList />} />}
          />
          <Route
            path="/create"
            element={<ProtectedRoute element={<CreateModule />} />}
          />
          <Route
            path="/create-user"
            element={<ProtectedRoute element={<CreateUser />} />}
          />
          <Route
            path="/update"
            element={<ProtectedRoute element={<UpdateModule />} />}
          />
          <Route
            path="/users"
            element={<ProtectedRoute element={<User />} />}
          />

          <Route path="/forgot-password" element={<ForgotPasswordPage />} />

          {/* Add a route for a default 404 page if needed */}
        </Routes>
      </Router>
    </AuthProvider>
  );
}

export default App;
