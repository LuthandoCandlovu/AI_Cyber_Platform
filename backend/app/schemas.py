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
