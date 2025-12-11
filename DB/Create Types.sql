DROP TYPE OrderType;
DROP TYPE OrderStatus;
DROP TYPE UserRole;
DROP TYPE MeasurementType;

CREATE TYPE OrderType AS ENUM('Реставрация материала фото', 'Восстановление цвета', 'Обновление покрытия');
CREATE TYPE OrderStatus AS ENUM('В обработке', 'Размещён', 'Принят мастером', 'Завершен');
CREATE TYPE UserRole AS ENUM('Пользователь', 'Мастер', 'Администратор');
CREATE TYPE MeasurementType AS ENUM('кг', 'л', 'м', 'шт', 'м в кубе')