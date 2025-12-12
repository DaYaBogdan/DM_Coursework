from pydantic import BaseModel

class LoginData(BaseModel):
    login: str
    password: str
    
class RegisterData(BaseModel):
    login: str
    password_primary: str
    password_sustaining: str
    
class AuthResponse(BaseModel):
    login: str = ""
    password: str = ""
    image_path: str = ""
    fio: str = ""
    email: str = ""
    phone: str = ""
    money: float = 0
    role: str = ""