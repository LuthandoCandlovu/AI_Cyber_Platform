from app.database import SessionLocal
from app.models import User
from app.auth import get_password_hash

db = SessionLocal()
email = 'luthando.candl@gmail.com'
existing = db.query(User).filter(User.email == email).first()
if existing:
    print('User already exists:', existing.email)
else:
    hashed = get_password_hash('luth123')
    user = User(name='Luthando', email=email, password_hash=hashed, role='analyst')
    db.add(user)
    db.commit()
    print('User created successfully')
db.close()
