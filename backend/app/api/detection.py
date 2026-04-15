from fastapi import APIRouter, Depends, BackgroundTasks
from sqlalchemy.orm import Session
from .. import auth, detection, alert

router = APIRouter(prefix="/api/detection", tags=["detection"])

@router.post("/run")
def run_detection_endpoint(background_tasks: BackgroundTasks, db: Session = Depends(auth.get_db), current_user=Depends(auth.get_current_user)):
    threats = detection.run_detection(db)
    background_tasks.add_task(alert.create_alerts_for_high_risk, db)
    return {"threats_detected": threats}
