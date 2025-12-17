from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy import Column, Integer, VARCHAR, REAL, Sequence
from sqlalchemy.dialects.postgresql import ENUM

userrole_enum = ENUM(
    'Пользователь', 
    'Мастер', 
    'Администратор', 
    name='userrole',
    create_type=True,  # Автоматически создаст тип
    metadata=declarative_base().metadata  # Привязываем к метаданным
)

orderstatus_enum = ENUM(
	'В обработке',
	'Размещён',
	'Принят мастером',
	'Завершен',
	'Отклонён',
    name='orderstatus',
    create_type=True,
    metadata=declarative_base().metadata
)

class Orders(declarative_base()):
    
    """
    Класс для работы с таблицой ORDERS
    """
    
    __tablename__ = "orders"
    
    id = Column(Integer, primary_key=True, autoincrement=True)
    name = Column(VARCHAR(32))
    image_path = Column(VARCHAR(32))
    contract_url = Column(VARCHAR(64))
    status = Column(orderstatus_enum)
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
    role = Column(userrole_enum)

class Reports(declarative_base()):
    
    """
    Класс для работы с таблицой REPORTS
    """
    
    __tablename__ = "reports"
    
    id = Column(Integer, primary_key=True)
    reporter = Column(VARCHAR(32))
    reported = Column(VARCHAR(32))
    description = Column(VARCHAR(256))
    
class OrderType(declarative_base()):
    
    """
    Класс для работы с таблицой ORDER_TYPE
    """
    
    __tablename__ = "order_type"
    
    name = Column(VARCHAR(32), primary_key=True)
    description = Column(VARCHAR(128))
    
class OrderTypeInOrders(declarative_base()):
    
    """
    Класс для работы с таблицой ORDER_TYPES_IN_ORDERS
    """
    
    __tablename__ = "order_types_in_orders"
    
    id = Column(Integer, primary_key=True)
    name = Column(VARCHAR(32))