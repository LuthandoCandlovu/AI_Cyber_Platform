import React from "react";
import { BrowserRouter, Routes, Route, Navigate } from "react-router-dom";
import Login from "./pages/Login";
import Dashboard from "./pages/Dashboard";
import Logs from "./pages/Logs";
import Threats from "./pages/Threats";
import Alerts from "./pages/Alerts";

function App() {
    const isAuth = !!localStorage.getItem("token");
    return (
        <BrowserRouter>
            <Routes>
                <Route path="/login" element={<Login />} />
                <Route path="/dashboard" element={isAuth ? <Dashboard /> : <Navigate to="/login" />} />
                <Route path="/logs" element={isAuth ? <Logs /> : <Navigate to="/login" />} />
                <Route path="/threats" element={isAuth ? <Threats /> : <Navigate to="/login" />} />
                <Route path="/alerts" element={isAuth ? <Alerts /> : <Navigate to="/login" />} />
                <Route path="*" element={<Navigate to="/dashboard" />} />
            </Routes>
        </BrowserRouter>
    );
}
export default App;
