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
