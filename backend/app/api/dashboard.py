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
