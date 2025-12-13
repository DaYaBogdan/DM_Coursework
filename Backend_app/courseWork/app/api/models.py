from pydantic import BaseModel

class LoginData(BaseModel):
    login: str
    password: str
    
class RegisterData(BaseModel):
    login: str
    password_primary: str
    password_sustaining: str