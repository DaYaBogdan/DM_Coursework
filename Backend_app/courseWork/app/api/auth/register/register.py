from fastapi import APIRouter
from ...models import RegisterData
from ...db.connection import sessionMaker
from ...db.models import Account
from sqlalchemy import insert

register_router = APIRouter()

async def registrateInDB(login: str, password: str):
    
    DBConnectionCreator = sessionMaker("administrator", "12345", "Restoration workshop")
    _, AsyncSessionLocal = DBConnectionCreator.get_engine()
    
    async with AsyncSessionLocal() as session:
        stmt = insert(Account)
        
        data = {
            'login': login,
            'password': password,
            'avatar_path': "album_1",
            'fio': "_",
            'email': "_",
            'phone': "_",
            'money': 0,
            'role': 'Пользователь'
        }
        
        await session.execute(stmt, data)
        await session.commit()
        
    return data

@register_router.post("/register")
async def register(user_data: RegisterData):
    
    if not user_data.password_primary == user_data.password_sustaining:
        {
            "status": 400, "message": "Ошибка входа, пароли не совпадают", 
            "data": { "login": "", "password": "", "image_path": "", "fio": "", "email": "", "phone": "", "money": 0.0, "role": "" }
        }
    
    accountInfo = await registrateInDB(user_data.login, user_data.password_primary)
    
    if not accountInfo:
        {
            "status": 400, "message": "Ошибка входа, ошибка создания аккаунта", 
            "data": { "login": "", "password": "", "image_path": "", "fio": "", "email": "", "phone": "", "money": 0.0, "role": "" }
        }
    
    return {"status": 200, "message": "Успешно! Вход выполнен корректно", "data":  accountInfo }