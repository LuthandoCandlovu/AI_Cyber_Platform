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
