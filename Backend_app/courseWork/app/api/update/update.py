from fastapi import APIRouter
from ..models import FullData
from ..db.connection import sessionMaker
from ..db.models import Account
from sqlalchemy import update

update_router = APIRouter()

async def updateUserInfo(data: FullData):
    
    DBConnectionCreator = sessionMaker("administrator", "12345", "Restoration workshop")
    _, AsyncSessionLocal = DBConnectionCreator.get_engine()
    
    async with AsyncSessionLocal() as session:
        stmt = (
            update(Account)
            .where(Account.login == data.login)
            .values(
                login=data.new_login,
                password=data.password,
                fio=data.fio,
                email=data.email,
                phone=data.phone,
                role=data.role
            )
        )
        await session.execute(stmt)
        await session.commit()
        
    return

@update_router.post("/account_update")
async def account_update(user_data: FullData):
    
    await updateUserInfo(user_data)
    
    return {
        "status": 200, 
        "message": "Изменения применены" 
        }