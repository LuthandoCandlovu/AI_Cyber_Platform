<!-- AI Cyber Defense Platform - README.md -->
<div align="center">

# 🛡️ AI Cyber Defense Platform

### *Enterprise‑grade · Real‑time · AI‑powered Security Analytics*

<p align="center">
  <img src="https://img.shields.io/badge/FastAPI-0.104-009688?logo=fastapi&logoColor=white" alt="FastAPI">
  <img src="https://img.shields.io/badge/React-18.2-61DAFB?logo=react&logoColor=black" alt="React">
  <img src="https://img.shields.io/badge/Python-3.11-3776AB?logo=python&logoColor=white" alt="Python">
  <img src="https://img.shields.io/badge/PostgreSQL-15-4169E1?logo=postgresql&logoColor=white" alt="PostgreSQL">
  <img src="https://img.shields.io/badge/Docker-✓-2496ED?logo=docker&logoColor=white" alt="Docker">
  <img src="https://img.shields.io/badge/License-MIT-blue.svg" alt="License">
</p>

<div align="center">
  <img src="https://readme-typing-svg.herokuapp.com?font=Fira+Code&pause=1000&color=009688&center=true&vCenter=true&width=435&lines=Detect+zero-day+attacks...;Score+risk+in+real+time...;Get+instant+alerts...;Beautiful+live+dashboard...;🚀+Ready+to+deploy!" alt="Typing SVG" />
</div>

</div>

---

<div align="center">

## 🎯 **What if your logs could talk?** ✨

![Cyber Shield](https://img.shields.io/badge/Status-🚀%20Production%20Ready-00D084?style=for-the-badge&logo=data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMTUiIGhlaWdodD0iMTUiIHZpZXdCb3g9IjAgMCAxNSAxNSIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPGNpcmNsZSBjeD0iNy41IiBjeT0iNy41IiByPSI3LjUiIGZpbGw9IiMwMEQwODQiLz4KPC9zdmc+)
</div>

The **AI Cyber Defense Platform** ingests server logs, network traffic, and user activity, then uses **Isolation Forest** (machine learning) to spot anomalies – **even attacks never seen before**. Every threat gets a **risk score (0–100)**. High‑risk events trigger **instant alerts** (email/dashboard). All visualized on a **live dashboard**.

### **Perfect for:** 
✅ **SOC analysts**  
✅ **Security engineers**  
✅ **DevSecOps teams**  
✅ **Portfolio projects that impress employers** 🎯

---

## 🏗️ **Architecture** <img src="https://raw.githubusercontent.com/catppuccin/catppuccin/main/assets/footer-wide.png" height="25" />

```mermaid
flowchart TD
    A[📊 Data Sources<br/>Logs · Traffic · Users] --> B[⚡ Ingestion Layer<br/>FastAPI · Kafka]
    B --> C[🧠 Processing Layer<br/>Feature Extraction<br/>Isolation Forest · Autoencoder]
    C --> D[(💾 Storage<br/>PostgreSQL · Redis)]
    D --> E[🔒 Backend Services<br/>Auth · Detection · Alerts]
    E --> F[📈 Frontend Dashboard<br/>React + Chart.js]
    E --> G[🚨 Notifications<br/>Email · Webhooks]
    
    style A fill:#e1f5fe
    style B fill:#f3e5f5
    style C fill:#e8f5e8
    style D fill:#fff3e0
    style E fill:#fce4ec
    style F fill:#e3f2fd
    style G fill:#ffebee
✨ Core Features
Feature

Description

🔍 **Log Ingestion

Upload CSV/JSON or stream logs in **real time

🧠 **AI Threat Detection

Isolation Forest & Autoencoder** – detects **zero‑day anomalies

📊 **Risk Scoring

Every threat gets a score from **0 (safe) to 100 (critical)

🚨 **Alerts

Email + dashboard notifications** for high‑risk threats

📈 **Live Dashboard

Risk trends, threat counts, system health

🔐 **Authentication

JWT + roles** (Admin / Analyst)

🚀 Quick Start (Docker – 1 minute setup)
bash

Copy code
# Clone the repository
git clone https://github.com/LuthandoCandlovu/AI_Cyber_Platform.git
cd AI_Cyber_Platform

# Launch everything (backend, frontend, PostgreSQL, Redis)
docker-compose up --build
<div align="center">
Then open:

Service

URL

🖥️ **Frontend

http://localhost:3000

📚 **API Docs

http://localhost:8000/docs

First time? Register → upload sample_logs.json → click "Run Threat Detection" 🎮

</div>
🧪 Manual Setup (No Docker)
Backend (FastAPI)
bash

Copy code
cd backend
python -m venv venv
source venv/bin/activate      # Windows: .\venv\Scripts\activate
pip install -r requirements.txt
uvicorn app.main:app --reload
Frontend (React)
bash

Copy code
cd frontend
npm install
npm start
📸 Dashboard Preview
<div align="center"> <img src="https://via.placeholder.com/1000x500/0a2540/ffffff?text=🔥+LIVE+THREAT+MONITORING+PLATFORM+%F0%9F%9A%A8" alt="Dashboard Preview"> <br><br> <img src="https://via.placeholder.com/800x200/009688/e1f5fe?text=Risk+Trends+%C2%B7+Threat+Counts+%C2%B7+Alert+History+%C2%B7+System+Health" alt="Features"> </div>
🛠️ Tech Stack
<div align="center"> <table> <tr> <td align="center"> <img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/fastapi/fastapi-original.svg" width="65" height="65" /><br/> <code>FastAPI</code> </td> <td align="center"> <img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/react/react-original.svg" width="65" height="65" /><br/> <code>React</code> </td> <td align="center"> <img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/postgresql/postgresql-original.svg" width="65" height="65" /><br/> <code>PostgreSQL</code> </td> <td align="center"> <img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/redis/redis-original.svg" width="65" height="65" /><br/> <code>Redis</code> </td> <td align="center"> <img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/docker/docker-original.svg" width="65" height="65" /><br/> <code>Docker</code> </td> <td align="center"> <img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/scikitlearn/scikitlearn-original.svg" width="65" height="65" /><br/> <code>Scikit-learn</code> </td> </tr> </table> </div>
📁 Project Structure

Copy code
.
├── backend/
│   ├── app/
│   │   ├── api/           # REST endpoints
│   │   ├── models.py      # SQLAlchemy models
│   │   ├── detection.py   # Isolation Forest logic
│   │   └── alert.py       # Email/webhook alerts
│   └── requirements.txt
├── frontend/
│   ├── src/
│   │   ├── pages/         # Login, Dashboard, Logs, Threats, Alerts
│   │   └── services/      # API client
│   └── package.json
├── docker-compose.yml
└── README.md
<div align="center">
🤝 Contributing
<p> <img src="https://img.shields.io/badge/PRs-Welcome-brightgreen.svg?style=for-the-badge&logo=github&logoColor=white" alt="PRs Welcome"> </p> Pull requests welcome! For major changes, please open an issue first.
📄 License
<img src="https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge&logo=data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSI4NSIgaGVpZ2h0PSIyMiIgdmlld0JveD0iMCAwIDg1IDIyIj4KPHBhdGggZmlsbD0iIzFGN0YwMCIgZD0iTTIwIDBjLTEwIDAtMjAgOC0yMCAxOGgxOFY5aDE5VjBoLTJ6bS00IDBoMTZ2MTRoMTZWMHoiLz4KPHBhdGggZmlsbD0iI0ZGRiIgZD0iTTM2IDBoMjJ2MjJIMzZ6Ii8+CjxwYXRoIGZpbGw9IiMxRjdGNzAiIGQ9Ik0zNiAwaDJ2MjFoLTJ6Ii8+CjxwYXRoIGZpbGw9IiNGRkYiIGQ9Ik02NCAwaDE4djloLTE4djloLTE4djE4aDIwVjBoLTJ6Ii8+CjxwYXRoIGZpbGw9IiMxRjdGNzAiIGQ9Ik02NCAwaDE4djloLTE4djloLTE4djloLTE4djloLTE4eiIvPgo8L3N2Zz4K" alt="MIT License">
⭐ Show your support
If this project helped you, give it a ⭐ on GitHub – it means the world! 🌟

</div> <div align="center"> <img src="https://komarev.com/ghpvc/?username=LuthandoCandlovu&color=009688&style=for-the-badge" alt="Visitors"> </div>
<div align="center"> <sub><strong>Built with ❤️ by Luthando Candlovu</strong> | <a href="https://twitter.com/yourtwitter">🐦 Twitter</a> · <a href="https://linkedin.com/in/yourprofile">💼 LinkedIn</a> · <a href="mailto:your@email.com">📧 Contact</a> </sub> </div> <div align="center"> <img src="https://raw.githubusercontent.com/catppuccin/catppuccin/main/assets/footer-wide.png" height="25" /> </div> ```
