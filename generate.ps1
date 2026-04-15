# ============================================================
# AI Cyber Defense Platform - Fixed Project Generator
# Uses single-quoted here-strings to avoid parsing errors.
# ============================================================

Write-Host "Creating project structure..." -ForegroundColor Cyan

# Create directories
$dirs = @(
    "backend/app/api",
    "backend/app/services",
    "backend/app/models",
    "backend/app/schemas",
    "frontend/src/components",
    "frontend/src/pages",
    "frontend/src/services",
    "frontend/public"
)
foreach ($dir in $dirs) {
    New-Item -ItemType Directory -Force -Path $dir | Out-Null
}

# ---------- BACKEND ----------
Write-Host "Generating backend files..." -ForegroundColor Green

# requirements.txt
@'
fastapi==0.104.1
uvicorn[standard]==0.24.0
sqlalchemy==2.0.23
psycopg2-binary==2.9.9
python-jose[cryptography]==3.3.0
passlib[bcrypt]==1.7.4
python-multipart==0.0.6
pandas==2.1.3
scikit-learn==1.3.2
numpy==1.26.2
redis==5.0.1
pydantic==2.5.0
email-validator==2.1.0
python-dotenv==1.0.0
'@ | Out-File -FilePath "backend/requirements.txt" -Encoding utf8

# Dockerfile (backend)
@'
FROM python:3.11-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY ./app /app
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000", "--reload"]
'@ | Out-File -FilePath "backend/Dockerfile" -Encoding utf8

# app/config.py
@'
import os
from dotenv import load_dotenv

load_dotenv()

class Config:
    DATABASE_URL = os.getenv("DATABASE_URL", "postgresql://user:pass@db:5432/cyberdb")
    REDIS_URL = os.getenv("REDIS_URL", "redis://redis:6379/0")
    SECRET_KEY = os.getenv("SECRET_KEY", "your-secret-key-change-in-production")
    ALGORITHM = "HS256"
    ACCESS_TOKEN_EXPIRE_MINUTES = 30
'@ | Out-File -FilePath "backend/app/config.py" -Encoding utf8

# app/database.py
@'
from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
from .config import Config

engine = create_engine(Config.DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = declarative_base()
'@ | Out-File -FilePath "backend/app/database.py" -Encoding utf8

# app/models.py
@'
from sqlalchemy import Column, Integer, String, Float, DateTime, ForeignKey, Text
from sqlalchemy.sql import func
from .database import Base

class User(Base):
    __tablename__ = "users"
    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, nullable=False)
    email = Column(String, unique=True, index=True, nullable=False)
    password_hash = Column(String, nullable=False)
    role = Column(String, default="analyst")
    created_at = Column(DateTime(timezone=True), server_default=func.now())

class Log(Base):
    __tablename__ = "logs"
    id = Column(Integer, primary_key=True, index=True)
    timestamp = Column(DateTime(timezone=True), nullable=False)
    source_ip = Column(String)
    destination_ip = Column(String)
    event_type = Column(String)
    payload = Column(Text, nullable=True)

class Threat(Base):
    __tablename__ = "threats"
    id = Column(Integer, primary_key=True, index=True)
    log_id = Column(Integer, ForeignKey("logs.id"))
    risk_score = Column(Float)
    anomaly_type = Column(String)
    status = Column(String, default="active")
    created_at = Column(DateTime(timezone=True), server_default=func.now())

class Alert(Base):
    __tablename__ = "alerts"
    id = Column(Integer, primary_key=True, index=True)
    threat_id = Column(Integer, ForeignKey("threats.id"))
    message = Column(String)
    severity = Column(String)
    sent_at = Column(DateTime(timezone=True), server_default=func.now())
'@ | Out-File -FilePath "backend/app/models.py" -Encoding utf8

# app/schemas.py
@'
from pydantic import BaseModel, EmailStr
from datetime import datetime
from typing import Optional, List

class UserCreate(BaseModel):
    name: str
    email: EmailStr
    password: str

class UserLogin(BaseModel):
    email: EmailStr
    password: str

class Token(BaseModel):
    token: str
    role: str

class LogEntry(BaseModel):
    timestamp: datetime
    source_ip: str
    destination_ip: Optional[str] = None
    event_type: str
    payload: Optional[str] = None

class LogUpload(BaseModel):
    logs: List[LogEntry]

class ThreatResponse(BaseModel):
    id: int
    log_id: int
    risk_score: float
    anomaly_type: str
    status: str
    created_at: datetime

class AlertResponse(BaseModel):
    id: int
    threat_id: int
    message: str
    severity: str
    sent_at: datetime

class StatsResponse(BaseModel):
    total_logs: int
    threats: int
    high_risk: int
'@ | Out-File -FilePath "backend/app/schemas.py" -Encoding utf8

# app/auth.py
@'
from jose import JWTError, jwt
from passlib.context import CryptContext
from datetime import datetime, timedelta
from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from sqlalchemy.orm import Session
from .database import SessionLocal
from .models import User
from .config import Config

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")
security = HTTPBearer()

def verify_password(plain, hashed):
    return pwd_context.verify(plain, hashed)

def get_password_hash(password):
    return pwd_context.hash(password)

def create_access_token(data: dict):
    to_encode = data.copy()
    expire = datetime.utcnow() + timedelta(minutes=Config.ACCESS_TOKEN_EXPIRE_MINUTES)
    to_encode.update({"exp": expire})
    return jwt.encode(to_encode, Config.SECRET_KEY, algorithm=Config.ALGORITHM)

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

def get_current_user(credentials: HTTPAuthorizationCredentials = Depends(security), db: Session = Depends(get_db)):
    token = credentials.credentials
    try:
        payload = jwt.decode(token, Config.SECRET_KEY, algorithms=[Config.ALGORITHM])
        email: str = payload.get("sub")
        if email is None:
            raise HTTPException(status_code=401, detail="Invalid token")
    except JWTError:
        raise HTTPException(status_code=401, detail="Invalid token")
    user = db.query(User).filter(User.email == email).first()
    if user is None:
        raise HTTPException(status_code=401, detail="User not found")
    return user
'@ | Out-File -FilePath "backend/app/auth.py" -Encoding utf8

# app/detection.py
@'
import pandas as pd
import numpy as np
from sklearn.ensemble import IsolationForest
from sqlalchemy.orm import Session
from .models import Log, Threat

def extract_features(logs):
    data = []
    for log in logs:
        hour = log.timestamp.hour
        event_map = {"login_attempt": 0, "file_access": 1, "network_conn": 2, "cmd_exec": 3}
        event_code = event_map.get(log.event_type, 4)
        ip_parts = log.source_ip.split(".")
        ip_first = int(ip_parts[0]) if len(ip_parts) > 0 else 0
        ip_second = int(ip_parts[1]) if len(ip_parts) > 1 else 0
        features = [hour, event_code, ip_first, ip_second]
        data.append(features)
    return np.array(data)

def run_detection(db: Session):
    logs = db.query(Log).all()
    if len(logs) < 10:
        return 0
    X = extract_features(logs)
    model = IsolationForest(contamination=0.1, random_state=42)
    preds = model.fit_predict(X)
    scores = model.score_samples(X)
    threats_created = 0
    for i, (log, pred) in enumerate(zip(logs, preds)):
        if pred == -1:
            risk = (1 - (scores[i] + 0.5)) * 100
            risk = max(0, min(100, risk))
            existing = db.query(Threat).filter(Threat.log_id == log.id).first()
            if not existing:
                threat = Threat(log_id=log.id, risk_score=risk, anomaly_type="isolation_forest", status="active")
                db.add(threat)
                threats_created += 1
    db.commit()
    return threats_created
'@ | Out-File -FilePath "backend/app/detection.py" -Encoding utf8

# app/alert.py
@'
from sqlalchemy.orm import Session
from .models import Threat, Alert

def send_email_alert(recipient, subject, body):
    print(f"EMAIL ALERT to {recipient}: {subject} - {body}")

def create_alerts_for_high_risk(db: Session, threshold=80):
    threats = db.query(Threat).filter(Threat.risk_score >= threshold, Threat.status == "active").all()
    alerts_created = 0
    for threat in threats:
        existing = db.query(Alert).filter(Alert.threat_id == threat.id).first()
        if not existing:
            alert = Alert(threat_id=threat.id, message=f"High risk threat detected (score {threat.risk_score})", severity="critical")
            db.add(alert)
            alerts_created += 1
            send_email_alert("admin@example.com", "Security Alert", alert.message)
    db.commit()
    return alerts_created
'@ | Out-File -FilePath "backend/app/alert.py" -Encoding utf8

# API files
# app/api/auth.py
@'
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from .. import schemas, auth, models

router = APIRouter(prefix="/api/auth", tags=["auth"])

@router.post("/register", response_model=schemas.Token)
def register(user: schemas.UserCreate, db: Session = Depends(auth.get_db)):
    existing = db.query(models.User).filter(models.User.email == user.email).first()
    if existing:
        raise HTTPException(status_code=400, detail="Email already registered")
    hashed = auth.get_password_hash(user.password)
    db_user = models.User(name=user.name, email=user.email, password_hash=hashed, role="analyst")
    db.add(db_user)
    db.commit()
    db.refresh(db_user)
    token = auth.create_access_token(data={"sub": db_user.email})
    return {"token": token, "role": db_user.role}

@router.post("/login", response_model=schemas.Token)
def login(user: schemas.UserLogin, db: Session = Depends(auth.get_db)):
    db_user = db.query(models.User).filter(models.User.email == user.email).first()
    if not db_user or not auth.verify_password(user.password, db_user.password_hash):
        raise HTTPException(status_code=401, detail="Invalid credentials")
    token = auth.create_access_token(data={"sub": db_user.email})
    return {"token": token, "role": db_user.role}
'@ | Out-File -FilePath "backend/app/api/auth.py" -Encoding utf8

# app/api/logs.py
@'
from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from .. import schemas, auth, models

router = APIRouter(prefix="/api/logs", tags=["logs"])

@router.post("/upload")
def upload_logs(upload: schemas.LogUpload, db: Session = Depends(auth.get_db), current_user=Depends(auth.get_current_user)):
    for entry in upload.logs:
        log = models.Log(
            timestamp=entry.timestamp,
            source_ip=entry.source_ip,
            destination_ip=entry.destination_ip,
            event_type=entry.event_type,
            payload=entry.payload
        )
        db.add(log)
    db.commit()
    return {"message": f"{len(upload.logs)} logs uploaded"}

@router.get("/")
def get_logs(skip: int = 0, limit: int = 100, db: Session = Depends(auth.get_db), current_user=Depends(auth.get_current_user)):
    logs = db.query(models.Log).offset(skip).limit(limit).all()
    return logs
'@ | Out-File -FilePath "backend/app/api/logs.py" -Encoding utf8

# app/api/detection.py
@'
from fastapi import APIRouter, Depends, BackgroundTasks
from sqlalchemy.orm import Session
from .. import auth, detection, alert

router = APIRouter(prefix="/api/detection", tags=["detection"])

@router.post("/run")
def run_detection_endpoint(background_tasks: BackgroundTasks, db: Session = Depends(auth.get_db), current_user=Depends(auth.get_current_user)):
    threats = detection.run_detection(db)
    background_tasks.add_task(alert.create_alerts_for_high_risk, db)
    return {"threats_detected": threats}
'@ | Out-File -FilePath "backend/app/api/detection.py" -Encoding utf8

# app/api/threats.py
@'
from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from .. import auth, models, schemas

router = APIRouter(prefix="/api/threats", tags=["threats"])

@router.get("/", response_model=list[schemas.ThreatResponse])
def get_threats(db: Session = Depends(auth.get_db), current_user=Depends(auth.get_current_user)):
    return db.query(models.Threat).all()

@router.get("/{threat_id}")
def get_threat(threat_id: int, db: Session = Depends(auth.get_db), current_user=Depends(auth.get_current_user)):
    return db.query(models.Threat).filter(models.Threat.id == threat_id).first()
'@ | Out-File -FilePath "backend/app/api/threats.py" -Encoding utf8

# app/api/alerts.py
@'
from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from .. import auth, models, schemas

router = APIRouter(prefix="/api/alerts", tags=["alerts"])

@router.get("/", response_model=list[schemas.AlertResponse])
def get_alerts(db: Session = Depends(auth.get_db), current_user=Depends(auth.get_current_user)):
    return db.query(models.Alert).all()

@router.post("/send")
def send_alert_manually(threat_id: int, db: Session = Depends(auth.get_db), current_user=Depends(auth.get_current_user)):
    from ..alert import create_alerts_for_high_risk
    count = create_alerts_for_high_risk(db)
    return {"alerts_sent": count}
'@ | Out-File -FilePath "backend/app/api/alerts.py" -Encoding utf8

# app/api/dashboard.py
@'
from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from .. import auth, models, schemas
from datetime import datetime, timedelta

router = APIRouter(prefix="/api/dashboard", tags=["dashboard"])

@router.get("/stats", response_model=schemas.StatsResponse)
def get_stats(db: Session = Depends(auth.get_db), current_user=Depends(auth.get_current_user)):
    total_logs = db.query(models.Log).count()
    threats = db.query(models.Threat).count()
    high_risk = db.query(models.Threat).filter(models.Threat.risk_score >= 80).count()
    return {"total_logs": total_logs, "threats": threats, "high_risk": high_risk}

@router.get("/risk-trend")
def risk_trend(db: Session = Depends(auth.get_db), current_user=Depends(auth.get_current_user)):
    date_n_days_ago = datetime.utcnow() - timedelta(days=7)
    threats = db.query(models.Threat).filter(models.Threat.created_at >= date_n_days_ago).all()
    trend = {}
    for t in threats:
        day = t.created_at.date().isoformat()
        trend[day] = trend.get(day, 0) + 1
    return {"trend": [{"date": k, "count": v} for k, v in trend.items()]}
'@ | Out-File -FilePath "backend/app/api/dashboard.py" -Encoding utf8

# Empty __init__.py files
New-Item -Force -Path "backend/app/__init__.py" -ItemType File | Out-Null
New-Item -Force -Path "backend/app/api/__init__.py" -ItemType File | Out-Null

# app/main.py
@'
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from .database import engine, Base
from .api import auth, logs, detection, threats, alerts, dashboard

Base.metadata.create_all(bind=engine)

app = FastAPI(title="AI Cyber Defense Platform")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(auth.router)
app.include_router(logs.router)
app.include_router(detection.router)
app.include_router(threats.router)
app.include_router(alerts.router)
app.include_router(dashboard.router)

@app.get("/")
def root():
    return {"message": "AI Cyber Defense API is running"}
'@ | Out-File -FilePath "backend/app/main.py" -Encoding utf8

# ---------- FRONTEND ----------
Write-Host "Generating frontend files..." -ForegroundColor Green

# package.json
@'
{
  "name": "ai-cyber-frontend",
  "version": "0.1.0",
  "private": true,
  "dependencies": {
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "react-router-dom": "^6.20.0",
    "axios": "^1.6.2",
    "chart.js": "^4.4.0",
    "react-chartjs-2": "^5.2.0",
    "react-scripts": "5.0.1"
  },
  "scripts": {
    "start": "react-scripts start",
    "build": "react-scripts build"
  },
  "proxy": "http://localhost:8000"
}
'@ | Out-File -FilePath "frontend/package.json" -Encoding utf8

# public/index.html
@'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <title>AI Cyber Defense</title>
</head>
<body>
    <div id="root"></div>
</body>
</html>
'@ | Out-File -FilePath "frontend/public/index.html" -Encoding utf8

# src/index.js
@'
import React from "react";
import ReactDOM from "react-dom/client";
import App from "./App";
const root = ReactDOM.createRoot(document.getElementById("root"));
root.render(<App />);
'@ | Out-File -FilePath "frontend/src/index.js" -Encoding utf8

# src/services/api.js
@'
import axios from "axios";
const API = axios.create({ baseURL: "http://localhost:8000/api" });
API.interceptors.request.use((req) => {
    const token = localStorage.getItem("token");
    if (token) req.headers.Authorization = `Bearer ${token}`;
    return req;
});
export default API;
'@ | Out-File -FilePath "frontend/src/services/api.js" -Encoding utf8

# src/App.js
@'
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
'@ | Out-File -FilePath "frontend/src/App.js" -Encoding utf8

# src/pages/Login.js
@'
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
'@ | Out-File -FilePath "frontend/src/pages/Login.js" -Encoding utf8

# src/pages/Dashboard.js
@'
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
'@ | Out-File -FilePath "frontend/src/pages/Dashboard.js" -Encoding utf8

# src/pages/Logs.js
@'
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
'@ | Out-File -FilePath "frontend/src/pages/Logs.js" -Encoding utf8

# src/pages/Threats.js
@'
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
'@ | Out-File -FilePath "frontend/src/pages/Threats.js" -Encoding utf8

# src/pages/Alerts.js
@'
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
'@ | Out-File -FilePath "frontend/src/pages/Alerts.js" -Encoding utf8

# ---------- DOCKER & MISC ----------
Write-Host "Generating Docker Compose and environment..." -ForegroundColor Green

# docker-compose.yml
@'
version: '3.8'
services:
  db:
    image: postgres:15
    environment:
      POSTGRES_USER: user
      POSTGRES_PASSWORD: pass
      POSTGRES_DB: cyberdb
    ports:
      - "5432:5432"
    volumes:
      - pgdata:/var/lib/postgresql/data
  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"
  backend:
    build: ./backend
    ports:
      - "8000:8000"
    depends_on:
      - db
      - redis
    environment:
      DATABASE_URL: postgresql://user:pass@db:5432/cyberdb
      REDIS_URL: redis://redis:6379/0
    volumes:
      - ./backend/app:/app
  frontend:
    build: ./frontend
    ports:
      - "3000:3000"
    stdin_open: true
    depends_on:
      - backend
volumes:
  pgdata:
'@ | Out-File -FilePath "docker-compose.yml" -Encoding utf8

# frontend Dockerfile
@'
FROM node:18-alpine
WORKDIR /app
COPY package.json .
RUN npm install
COPY . .
CMD ["npm", "start"]
'@ | Out-File -FilePath "frontend/Dockerfile" -Encoding utf8

# .env.example
@'
DATABASE_URL=postgresql://user:pass@localhost:5432/cyberdb
SECRET_KEY=your-super-secret-key-change-this
'@ | Out-File -FilePath ".env.example" -Encoding utf8

# README.md
@'
# AI Cyber Defense Platform

Full-stack security analytics with anomaly detection.

## Run with Docker Compose
```bash
docker-compose up --build