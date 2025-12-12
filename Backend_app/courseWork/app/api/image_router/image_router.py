from fastapi import APIRouter
from fastapi.responses import FileResponse
from pathlib import Path

images_router = APIRouter()

@images_router.get("/get_image/{filename}")
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