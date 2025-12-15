from fastapi import APIRouter
from ..models import ReportData
from ..db.connection import sessionMaker
from sqlalchemy import select
from ..db.models import Reports

reports_router = APIRouter()

async def getReports():
    
    DBConnectionCreator = sessionMaker("administrator", "12345", "Restoration workshop")
    _, AsyncSessionLocal = DBConnectionCreator.get_engine()
    
    async with AsyncSessionLocal() as session:
        stmt = select(Reports)
        latest_orders = await session.execute(stmt)
    
    return latest_orders.scalars().all()

@reports_router.post("/send_report")
async def send_report(data: ReportData):
    return {
                "status": 200, 
                "message": "GitGud"}

@reports_router.get("/get_reports")
async def get_reports():
    
    list_of_reports = []
    
    for i in await getReports():
        
        list_of_reports.append({
                                "id": i.id, 
                                "reporter": i.reporter, 
                                "reported": i.reported, 
                                "description": i.descriprion,
                            })
    
    return {
                "status": 200, 
                "message": "GitGud", 
                "data": list_of_reports}