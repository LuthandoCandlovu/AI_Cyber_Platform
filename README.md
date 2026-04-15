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

## 🎯 **What if your logs could talk?** ✨

![Cyber Shield](https://img.shields.io/badge/Status-🚀%20Production%20Ready-00D084?style=for-the-badge)

The **AI Cyber Defense Platform** ingests server logs, network traffic, and user activity, then uses **Isolation Forest** (machine learning) to spot anomalies – **even attacks never seen before**. Every threat gets a **risk score (0–100)**. High‑risk events trigger **instant alerts** (email/dashboard). All visualized on a **live dashboard**.

### **Perfect for:** 
✅ SOC analysts  
✅ Security engineers  
✅ DevSecOps teams  
✅ Portfolio projects that impress employers 🎯

---

## 🏗️ **Architecture**

```mermaid
flowchart TD
    A[📊 Data Sources<br/>Logs · Traffic · Users] --> B[⚡ Ingestion Layer<br/>FastAPI · Kafka]
    B --> C[🧠 Processing Layer<br/>Feature Extraction<br/>Isolation Forest · Autoencoder]
    C --> D[(💾 Storage<br/>PostgreSQL · Redis)]
    D --> E[🔒 Backend Services<br/>Auth · Detection · Alerts]
    E --> F[📈 Frontend Dashboard<br/>React + Chart.js]
    E --> G[🚨 Notifications<br/>Email · Webhooks]

    style A fill:#e1f5fe,stroke:#01579b,stroke-width:2px
    style B fill:#f3e5f5,stroke:#4a148c,stroke-width:2px
    style C fill:#e8f5e9,stroke:#1b5e20,stroke-width:2px
    style D fill:#fff3e0,stroke:#e65100,stroke-width:2px
    style E fill:#fce4ec,stroke:#880e4f,stroke-width:2px
    style F fill:#e3f2fd,stroke:#0d47a1,stroke-width:2px
    style G fill:#ffebee,stroke:#b71c1c,stroke-width:2px
✨ Core Features
Feature	Description
🔍 Log Ingestion	Upload CSV/JSON or stream logs in real time.
🧠 AI Threat Detection	Isolation Forest & Autoencoder – detects zero‑day anomalies.
📊 Risk Scoring	Every threat gets a score from 0 (safe) to 100 (critical).
🚨 Alerts	Email + dashboard notifications for high‑risk threats.
📈 Live Dashboard	Risk trends, threat counts, system health.
🔐 Authentication	JWT + roles (Admin / Analyst).
🚀 Quick Start (Docker – 1 minute setup)
bash
# Clone the repository
git clone https://github.com/LuthandoCandlovu/AI_Cyber_Platform.git
cd AI_Cyber_Platform

# Launch everything (backend, frontend, PostgreSQL, Redis)
docker-compose up --build
<div align="center">
Then open:

Service	URL
🖥️ Frontend	http://localhost:3000
📚 API Docs	http://localhost:8000/docs
First time? Register → upload sample_logs.json → click "Run Threat Detection" 🎮

</div>
🧪 Manual Setup (No Docker)
Backend (FastAPI)
bash
cd backend
python -m venv venv
source venv/bin/activate      # Windows: .\venv\Scripts\activate
pip install -r requirements.txt
uvicorn app.main:app --reload
Frontend (React)
bash
cd frontend
npm install
npm start
📸 Dashboard Preview
<div align="center"> <img src="https://via.placeholder.com/1000x500/0a2540/ffffff?text=🔥+LIVE+THREAT+MONITORING+PLATFORM+%F0%9F%9A%A8" alt="Dashboard Preview"> <br><br> <img src="https://via.placeholder.com/800x200/009688/e1f5fe?text=Risk+Trends+%C2%B7+Threat+Counts+%C2%B7+Alert+History+%C2%B7+System+Health" alt="Features"> </div>
Replace the placeholder images with actual screenshots of your running dashboard.

🛠️ Tech Stack
<div align="center">
<img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/fastapi/fastapi-original.svg" width="65" height="65" />
FastAPI	<img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/react/react-original.svg" width="65" height="65" />
React	<img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/postgresql/postgresql-original.svg" width="65" height="65" />
PostgreSQL	<img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/redis/redis-original.svg" width="65" height="65" />
Redis	<img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/docker/docker-original.svg" width="65" height="65" />
Docker	<img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/scikitlearn/scikitlearn-original.svg" width="65" height="65" />
Scikit-learn
</div>
📁 Project Structure
text
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
<p> <img src="https://img.shields.io/badge/PRs-Welcome-brightgreen.svg?style=for-the-badge&logo=github&logoColor=white" alt="PRs Welcome"> </p>
Pull requests welcome! For major changes, please open an issue first.

📄 License
<img src="https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge" alt="MIT License">
⭐ Show your support
If this project helped you, give it a ⭐ on GitHub – it means the world! 🌟

<img src="https://komarev.com/ghpvc/?username=LuthandoCandlovu&color=009688&style=for-the-badge" alt="Visitors">
<sub><strong>Built with ❤️ by Luthando Candlovu</strong> | <a href="https://twitter.com/yourtwitter">🐦 Twitter</a> · <a href="https://linkedin.com/in/yourprofile">💼 LinkedIn</a> · <a href="mailto:your@email.com">📧 Contact</a></sub>

<img src="https://raw.githubusercontent.com/catppuccin/catppuccin/main/assets/footer-wide.png" height="25" /></div> ```
