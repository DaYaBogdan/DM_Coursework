from fastapi import APIRouter
from ...db.connection import sessionMaker
from sqlalchemy import select
from ...db.models import OrderType

order_types_router = APIRouter()

async def getAllTypes():
    
    DBConnectionCreator = sessionMaker("administrator", "12345", "Restoration workshop")
    _, AsyncSessionLocal = DBConnectionCreator.get_engine()
    
    async with AsyncSessionLocal() as session:
        stmt = select(OrderType)
        all_types = await session.execute(stmt)
        
    return all_types.scalars().all()

@order_types_router.get("/all_types")
async def all_types():
    
    allTypes = await getAllTypes()
    
    if not allTypes:
        return {
            "status": 400, 
            "message": "NotGud", 
            "data": []
        }
        
    return {
                "status": 200, 
                "message": "GitGud", 
                "data": allTypes
            }