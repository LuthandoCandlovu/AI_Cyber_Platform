import React, { useEffect, useState } from "react";
import API from "../services/api";

export default function Alerts() {
    const [alerts, setAlerts] = useState([]);
    useEffect(() => {
        API.get("/alerts").then(res => setAlerts(res.data));
    }, []);
    return (
        <div>
            <h2>Security Alerts</h2>
            {alerts.map(a => <div key={a.id} style={{border:"1px solid red", margin:"5px", padding:"5px"}}>{a.message} (Severity: {a.severity})</div>)}
        </div>
    );
}
