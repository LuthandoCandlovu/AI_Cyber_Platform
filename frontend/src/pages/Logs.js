import React, { useState, useEffect } from "react";
import API from "../services/api";

export default function Logs() {
    const [logs, setLogs] = useState([]);
    const [file, setFile] = useState(null);
    useEffect(() => {
        API.get("/logs").then(res => setLogs(res.data));
    }, []);
    const uploadLogs = async () => {
        if (!file) return;
        const text = await file.text();
        const jsonLogs = JSON.parse(text);
        await API.post("/logs/upload", { logs: jsonLogs });
        alert("Uploaded");
        API.get("/logs").then(res => setLogs(res.data));
    };
    return (
        <div>
            <h2>Logs</h2>
            <input type="file" onChange={e => setFile(e.target.files[0])} />
            <button onClick={uploadLogs}>Upload JSON logs</button>
            <pre>{JSON.stringify(logs, null, 2)}</pre>
        </div>
    );
}
