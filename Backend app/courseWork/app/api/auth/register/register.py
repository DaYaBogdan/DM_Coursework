from fastapi import APIRouter
from ...models import RegisterData, AuthResponse

register_router = APIRouter()

@register_router.post("/register")
async def register(user_data: RegisterData):
    return {"status": 200, "message": "Успешно! Вход выполнен корректно"}