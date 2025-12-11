from fastapi import APIRouter
from fastapi.responses import FileResponse
from pathlib import Path
from ...db.connection import sessionMaker
from sqlalchemy import select, func
from ...db.models import Orders

listing_router = APIRouter()

async def getAllTypes(orderID: int):
    
    DBConnectionCreator = sessionMaker("administrator", "12345", "Restoration workshop")
    _, AsyncSessionLocal = DBConnectionCreator.get_engine()
    
    async with AsyncSessionLocal() as session:
        stmt = select(func.get_all_types(orderID))
        all_types = await session.execute(stmt)
        
    return all_types.scalars().all()

async def getLatestOrders():
    
    DBConnectionCreator = sessionMaker("administrator", "12345", "Restoration workshop")
    _, AsyncSessionLocal = DBConnectionCreator.get_engine()
    
    async with AsyncSessionLocal() as session:
        stmt = select(Orders)
        latest_orders = await session.execute(stmt)
    
    return latest_orders.scalars().all()

@listing_router.get("/get_listing")
async def get_listing():
    
    list_of_orders = []
    
    for i in await getLatestOrders():
        image_path = Path(f"app/images/orders/{i.image_path}")
        if not image_path.is_file():
            return {
                    "status": 400, 
                    "message": f"Error! Cannot find image on path {image_path}", 
                    "data": {
                        }
                    }
        
        list_of_orders.append({
                                "id": i.id, 
                                "name": i.name, 
                                "image": i.image_path, 
                                "order_status": i.status, 
                                "types": await getAllTypes(i.id), 
                                "customer": i.customer, 
                                "master": i.master   
                            })
    
    return {
                "status": 200, 
                "message": "GitGud", 
                "data": list_of_orders}
    
@listing_router.get("/get_image/{filename}")
async def get_image(filename: str):
    
    image_path = Path(f"app/images/orders/{filename}")
    
    if not image_path.is_file():
            return {
                    "status": 400, 
                    "message": f"Error! Cannot find image on path {image_path}", 
                    "data": {
                        }
                    }
    
    return FileResponse(image_path)