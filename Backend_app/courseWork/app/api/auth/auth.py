from fastapi import APIRouter
from .login.login import login_router
from .register.register import register_router

auth_router = APIRouter()

auth_router.include_router(login_router, prefix="/auth", tags=["authentication"])
auth_router.include_router(register_router, prefix="/auth", tags=["authentication"])