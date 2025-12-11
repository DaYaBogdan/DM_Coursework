from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy import Column, Integer, VARCHAR

class Orders(declarative_base()):
    
    """
    Класс для работы с таблицой ORDERS
    """
    
    __tablename__ = "orders"
    
    id = Column(Integer, nullable=False, primary_key=True)
    name = Column(VARCHAR(32))
    image_path = Column(VARCHAR(32))
    contract_url = Column(VARCHAR(64))
    status = Column(VARCHAR(64))
    customer = Column(VARCHAR(32), nullable=False)
    master = Column(VARCHAR(32))
    
class Orders(declarative_base()):
    
    """
    Класс для работы с таблицой ACCOUNT
    """
    
    __tablename__ = "account"
    
    login = Column(VARCHAR(32), nullable=False, primary_key=True)
    password = Column(VARCHAR(32))
    avatar_path = Column(VARCHAR(32))
    fio = Column(VARCHAR(64))
    email = Column(VARCHAR(64))
    phone = Column(VARCHAR(32), nullable=False)
    money = Column(VARCHAR(32))
    role = Column(VARCHAR(32))