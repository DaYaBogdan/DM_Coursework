from fastapi import APIRouter
from ...models import LoginData
from ...db.connection import sessionMaker
from ...db.models import Account
from sqlalchemy import select

login_router = APIRouter()

async def getLoging(login: str, password: str):
    
    DBConnectionCreator = sessionMaker("administrator", "12345", "Restoration workshop")
    _, AsyncSessionLocal = DBConnectionCreator.get_engine()
    
    async with AsyncSessionLocal() as session:
        stmt = select(Account).where(Account.login == login).where(Account.password == password)
        account = await session.execute(stmt)
        
    return account.scalars().one()

@login_router.post("/login")
async def login(user_data: LoginData):
    
    print(user_data)
    
    accountInfo = await getLoging(user_data.login, user_data.password)
    
    print({accountInfo})
    
    if not accountInfo:
        {
            "status": 400, "message": "Ошибка входа, логин или пароль не соответствуют", 
            "data": { "login": "", "password": "", "image_path": "", "fio": "", "email": "", "phone": "", "money": 0.0, "role": "" }
        }
    
    return {"status": 200, "message": "Успешно! Вход выполнен корректно", "data": { accountInfo }}