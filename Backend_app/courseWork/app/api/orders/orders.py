from fastapi import APIRouter
from .listing.listing import listing_router
from .makeOrder.makeOrder import make_order_router

orders_router = APIRouter()

orders_router.include_router(make_order_router, prefix="/orders", tags=["orders"])
orders_router.include_router(listing_router, prefix="/orders", tags=["orders"])