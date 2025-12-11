from fastapi import APIRouter
from .listing.listing import listing_router

orders_router = APIRouter()

orders_router.include_router(listing_router, prefix="/orders", tags=["orders"])