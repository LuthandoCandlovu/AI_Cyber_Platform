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
