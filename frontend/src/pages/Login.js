import React, { useState } from "react";
import API from "../services/api";
import { useNavigate } from "react-router-dom";

export default function Login() {
    const [email, setEmail] = useState("");
    const [password, setPassword] = useState("");
    const navigate = useNavigate();

    const handleSubmit = async (e) => {
        e.preventDefault();
        try {
            const res = await API.post("/auth/login", { email, password });
            localStorage.setItem("token", res.data.token);
            navigate("/dashboard");
        } catch (err) {
            alert("Login failed");
        }
    };

    return (
        <div style={{ padding: "2rem", maxWidth: "400px", margin: "auto" }}>
            <h2>AI Cyber Defense Login</h2>
            <form onSubmit={handleSubmit}>
                <input type="email" placeholder="Email" value={email} onChange={e=>setEmail(e.target.value)} required /><br/>
                <input type="password" placeholder="Password" value={password} onChange={e=>setPassword(e.target.value)} required /><br/>
                <button type="submit">Login</button>
            </form>
            <p>Demo: use email "admin@example.com" / "admin123" after registering</p>
        </div>
    );
}
