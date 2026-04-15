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
