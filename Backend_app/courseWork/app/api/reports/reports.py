from fastapi import APIRouter
from ..models import ReportData
from ..db.connection import sessionMaker
from sqlalchemy import select, insert
from ..db.models import Reports

reports_router = APIRouter()

async def getReports():
    
    DBConnectionCreator = sessionMaker("administrator", "12345", "Restoration workshop")
    _, AsyncSessionLocal = DBConnectionCreator.get_engine()
    
    async with AsyncSessionLocal() as session:
        stmt = select(Reports)
        latest_orders = await session.execute(stmt)
    
    return latest_orders.scalars().all()

async def report(data: ReportData):
    
    DBConnectionCreator = sessionMaker("administrator", "12345", "Restoration workshop")
    _, AsyncSessionLocal = DBConnectionCreator.get_engine()
    
    async with AsyncSessionLocal() as session:
        stmt = insert(Reports).values(reporter=data.reporter, reported=data.reported, description=data.description)
        await session.execute(stmt)
        await session.commit()
    
    return

@reports_router.post("/send_report")
async def send_report(data: ReportData):
    
    await report(data)
    
    return {
                "status": 200, 
                "message": "GitGud"
            }

@reports_router.get("/get_reports")
async def get_reports():
    
    list_of_reports = []
    
    for i in await getReports():
        
        list_of_reports.append({
                                "id": i.id, 
                                "reporter": i.reporter, 
                                "reported": i.reported, 
                                "description": i.description,
                            })
    
    return {
                "status": 200, 
                "message": "GitGud", 
                "data": list_of_reports}