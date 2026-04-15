import React, { useEffect, useState } from "react";
import API from "../services/api";
import { Line } from "react-chartjs-2";
import { Chart as ChartJS, CategoryScale, LinearScale, PointElement, LineElement, Title, Tooltip, Legend } from "chart.js";
ChartJS.register(CategoryScale, LinearScale, PointElement, LineElement, Title, Tooltip, Legend);

export default function Dashboard() {
    const [stats, setStats] = useState({ total_logs: 0, threats: 0, high_risk: 0 });
    const [trend, setTrend] = useState({ labels: [], data: [] });
    useEffect(() => {
        API.get("/dashboard/stats").then(res => setStats(res.data));
        API.get("/dashboard/risk-trend").then(res => {
            const labels = res.data.trend.map(t => t.date);
            const data = res.data.trend.map(t => t.count);
            setTrend({ labels, data });
        });
    }, []);
    const chartData = { labels: trend.labels, datasets: [{ label: "Threats per day", data: trend.data, borderColor: "red" }] };
    return (
        <div style={{ padding: "1rem" }}>
            <h1>Security Dashboard</h1>
            <div style={{ display: "flex", gap: "2rem" }}>
                <div>Total Logs: {stats.total_logs}</div>
                <div>Total Threats: {stats.threats}</div>
                <div>High Risk: {stats.high_risk}</div>
            </div>
            <h3>Risk Trend (last 7 days)</h3>
            <Line data={chartData} />
            <button onClick={() => API.post("/detection/run").then(() => alert("Detection started"))}>Run Threat Detection</button>
        </div>
    );
}
