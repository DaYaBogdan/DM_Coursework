from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy import Column, Integer, VARCHAR, REAL
from sqlalchemy.dialects.postgresql import ENUM

userrole_enum = ENUM(
    'Пользователь', 
    'Мастер', 
    'Администратор', 
    name='userrole',
    create_type=True,  # Автоматически создаст тип
    metadata=declarative_base().metadata  # Привязываем к метаданным
)

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
    
class Account(declarative_base()):
    
    """
    Класс для работы с таблицой ACCOUNT
    """
    
    __tablename__ = "account"
    
    login = Column(VARCHAR(32), nullable=False, primary_key=True)
    password = Column(VARCHAR(32))
    avatar_path = Column(VARCHAR(32))
    fio = Column(VARCHAR(64))
    email = Column(VARCHAR(64))
    phone = Column(VARCHAR(32))
    money = Column(REAL)
<<<<<<< HEAD
    role = Column(VARCHAR(32))
    
class Reports(declarative_base()):
    
    """
    Класс для работы с таблицой REPORTS
    """
    
    __tablename__ = "reports"
    
    id = Column(Integer, primary_key=True)
    reporter = Column(VARCHAR(32))
    reported = Column(VARCHAR(32))
    descriprion = Column(VARCHAR(256))
=======
    role = Column(userrole_enum)
>>>>>>> f4cada6d89c43d0592848e934d8121a6ac449c0f
