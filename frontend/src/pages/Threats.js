import React, { useEffect, useState } from "react";
import API from "../services/api";

export default function Threats() {
    const [threats, setThreats] = useState([]);
    useEffect(() => {
        API.get("/threats").then(res => setThreats(res.data));
    }, []);
    return (
        <div>
            <h2>Detected Threats</h2>
            <table border="1"><thead><tr><th>ID</th><th>Risk Score</th><th>Type</th><th>Status</th></tr></thead><tbody>
                {threats.map(t => <tr key={t.id}><td>{t.id}</td><td>{t.risk_score}</td><td>{t.anomaly_type}</td><td>{t.status}</td></tr>)}
            </tbody></table>
        </div>
    );
}
