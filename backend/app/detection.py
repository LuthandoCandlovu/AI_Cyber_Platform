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
