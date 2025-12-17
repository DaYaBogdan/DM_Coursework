from pydantic import BaseModel, EmailStr

class LoginData(BaseModel):
    login: str
    password: str
        
class RegisterData(BaseModel):
    login: str
    password_primary: str
    password_sustaining: str
    
class ReportData(BaseModel):
    reporter: str
    reported: str
    description: str
    
class FullData(BaseModel):
    new_login: str
    login: str
    password: str
    fio: str
    email: str
    phone: str
    role: str
    
class OrderData(BaseModel):
    name: str
    login: str
    tags: list