from fastapi import APIRouter
from ...models import LoginData, AuthResponse

login_router = APIRouter()

@login_router.post("/login")
async def login(user_data: LoginData):
    return {"status": 200, "message": "Успешно! Вход выполнен корректно"}