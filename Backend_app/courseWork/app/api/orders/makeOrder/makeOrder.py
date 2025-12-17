from fastapi import APIRouter
from ...db.connection import sessionMaker
from sqlalchemy import insert, update
from ...db.models import Orders, OrderTypeInOrders
from ...models import OrderData
from random import randint

make_order_router = APIRouter()

async def insert_order(data: OrderData):
    
    DBConnectionCreator = sessionMaker("administrator", "12345", "Restoration workshop")
    _, AsyncSessionLocal = DBConnectionCreator.get_engine()
    
    async with AsyncSessionLocal() as session:
        stmt = insert(Orders).values(name=data.name, image_path=f"album_{randint(a=1, b=15)}.jpg", contract_url="", status="В обработке", customer=data.login, master=None).returning(Orders.id)
        result = await session.execute(stmt)
        pk = result.scalar_one()
        await session.commit()
        
        for i in data.tags:
            stmt = insert(OrderTypeInOrders).values(id=pk, name=i)
            await session.execute(stmt)
            await session.commit()
        
        stmt = update(Orders).values(status="Размещён").where(Orders.id==pk)
        await session.execute(stmt)
        await session.commit()
        
    return

@make_order_router.post("/make_order")
async def all_types(data: OrderData):
    
    await insert_order(data)
        
    return {
                "status": 200, 
                "message": "GitGud"
            }