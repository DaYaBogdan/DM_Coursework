from sqlalchemy.ext.asyncio import create_async_engine, async_sessionmaker, AsyncSession

class sessionMaker:
    
    def __init__(self, DATABASE_USER, MY_PASSWORD, DATABASE_NAME):
        self.DATABASE_URL = f'postgresql+asyncpg://{DATABASE_USER}:{MY_PASSWORD}@localhost/{DATABASE_NAME}'
        self._engine = None
        self._AsyncSessionLocal = None

    def get_engine(self):
        """Создает и возвращает движок и сессию для работы с БД"""
        if self._engine is None:
            self._engine = create_async_engine(
                self.DATABASE_URL,
                echo=True,
                pool_size=10,
                max_overflow=20,
                pool_pre_ping=True
            )

            self._AsyncSessionLocal = async_sessionmaker(
                self._engine,
                class_=AsyncSession,
                expire_on_commit=False
            )

        return self._engine, self._AsyncSessionLocal

    async def close_engine(self):
        """Закрывает движок базы данных"""
        if self._engine:
            await self._engine.dispose()