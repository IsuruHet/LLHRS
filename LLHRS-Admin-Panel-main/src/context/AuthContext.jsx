// AuthContext.js
import { createContext, useContext, useState, useEffect } from "react";
import { getToken } from "../utils/authUtils";
import PropTypes from "prop-types";

const AuthContext = createContext();

export const AuthProvider = ({ children }) => {
  const [isAuthenticated, setIsAuthenticated] = useState(false);

  useEffect(() => {
    const token = getToken();
    setIsAuthenticated(!!token);
  }, []);

  const login = (token) => {
    setIsAuthenticated(true);
    sessionStorage.setItem("authToken", token);
  };

  const logout = () => {
    setIsAuthenticated(false);
    sessionStorage.removeItem("authToken");
  };

  return (
    <AuthContext.Provider value={{ isAuthenticated, login, logout }}>
      {children}
    </AuthContext.Provider>
  );
};

AuthProvider.propTypes = {
  children: PropTypes.node.isRequired,
};

export const useAuth = () => useContext(AuthContext);
