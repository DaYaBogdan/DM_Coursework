from fastapi import APIRouter
from ...db.connection import sessionMaker
from sqlalchemy import update
from ...db.models import Orders
from ...models import OrderData, OrderDataEx

update_order_router = APIRouter()

async def update_it(data: OrderData, statement: str):
    
    DBConnectionCreator = sessionMaker("administrator", "12345", "Restoration workshop")
    _, AsyncSessionLocal = DBConnectionCreator.get_engine()
    
    async with AsyncSessionLocal() as session:
        stmt = (
            update(Orders)
            .values(status=statement)
            .where(Orders.name == data.name)
            .where(Orders.customer == data.customer)
)
        await session.execute(stmt)
        await session.commit()
        
    return

async def update_it_Ex(data: OrderDataEx, statement: str):
    
    DBConnectionCreator = sessionMaker("administrator", "12345", "Restoration workshop")
    _, AsyncSessionLocal = DBConnectionCreator.get_engine()
    
    print(data.master)
    
    async with AsyncSessionLocal() as session:
        stmt = update(Orders).values(master=data.master).where(Orders.name == data.name).where(Orders.customer == data.customer)
        await session.execute(stmt)
        await session.commit()
        
    new_data = OrderData(
        name=data.name,
        customer=data.customer,
        tags=data.tags
    )
    
    await update_it(new_data, statement)
            
    return

@update_order_router.post("/discard_order")
async def discard_order(data: OrderData):
    
    await update_it(data, "Отклонён")
        
    return {
                "status": 200, 
                "message": "GitGud"
            }
    
@update_order_router.post("/accept_order")
async def accept_order(data: OrderDataEx):
    
    await update_it_Ex(data, "Принят мастером")
        
    return {
                "status": 200, 
                "message": "GitGud"
            }
    
@update_order_router.post("/complete_order")
async def complete_order(data: OrderData):
    
    await update_it(data, "Завершен")
        
    return {
                "status": 200, 
                "message": "GitGud"
            }