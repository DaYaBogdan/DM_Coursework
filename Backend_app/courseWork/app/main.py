from fastapi import FastAPI
from .api.auth.auth import auth_router
from .api.orders.orders import orders_router
from .api.image_router.image_router import images_router
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI()

origins = ["*"]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(images_router, prefix="/api", tags=["images"])
app.include_router(orders_router, prefix="/api", tags=["orders"])
app.include_router(auth_router, prefix="/api", tags=["auth"])