from pydantic import BaseModel

class LoginData(BaseModel):
    login: str
    password: str
    
class RegisterData(BaseModel):
    login: str
    password_primary: str
    password_sustaining: str
    
class AuthResponse(BaseModel):
    login: str
    password: str
    fio: str
    email: str
    phone: str
    money: float
    role: str