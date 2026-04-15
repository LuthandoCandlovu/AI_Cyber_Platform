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
