DROP TABLE MATERIALS_IN_ORDER_TYPE;

DROP TABLE MATERIALS;

DROP TABLE ORDER_TYPES_IN_ORDERS;

DROP TABLE ORDER_TYPE;

DROP TABLE TRANSACTIONS;

DROP TABLE REPORTS;

DROP TABLE MASTER;

DROP TABLE ORDERS;

DROP TABLE ACCOUNT;

DROP TYPE ORDERTYPE;

DROP TYPE ORDERSTATUS;

DROP TYPE USERROLE;

DROP TYPE MEASUREMENTTYPE;

DROP TYPE TRANSACTIONTYPE;

CREATE TYPE ORDERTYPE AS ENUM(
	'Ламинация'
	'Реставрация фото',
	'Колоризация',
	'Ретушь',
	'Восстановление слайдов',
	'Цифровая реставрация',
	'Увеличение фото',
	'Восстановление рамок',
	'Создание коллажей',
	'Реставрация портретов'
);

CREATE TYPE ORDERSTATUS AS ENUM(
	'В обработке',
	'Размещён',
	'Принят мастером',
	'Завершен',
	'Отклонён'
);

CREATE TYPE USERROLE AS ENUM('Пользователь', 'Мастер', 'Администратор');

CREATE TYPE MEASUREMENTTYPE AS ENUM('кг', 'л', 'м', 'шт', 'м в кубе');

CREATE TYPE TRANSACTIONTYPE AS ENUM('Пополнение', 'Списание', 'Отклонено');

CREATE TABLE ACCOUNT (
	LOGIN VARCHAR(32) PRIMARY KEY,
	PASSWORD VARCHAR(32),
	AVATAR_PATH VARCHAR(32),
	FIO VARCHAR(64),
	EMAIL VARCHAR(32),
	PHONE VARCHAR(16),
	MONEY REAL NOT NULL CONSTRAINT POSIBLEMONEY CHECK (MONEY >= 0),
	ROLE USERROLE
);

CREATE TABLE ORDERS (
	ID SERIAL PRIMARY KEY,
	NAME VARCHAR(32) NOT NULL UNIQUE,
	IMAGE_PATH VARCHAR(32) NOT NULL, 
	CONTRACT_URL VARCHAR(64),
	STATUS ORDERSTATUS,
	CUSTOMER VARCHAR(32) NOT NULL REFERENCES ACCOUNT (LOGIN) ON UPDATE CASCADE,
	MASTER VARCHAR(32) REFERENCES ACCOUNT (LOGIN) ON UPDATE CASCADE
);

CREATE TABLE MASTER (
	LOGIN VARCHAR(32) REFERENCES ACCOUNT (LOGIN) ON UPDATE CASCADE,
	WAGE DECIMAL(5, 4) CONSTRAINT POSIBLEWAGE CHECK (WAGE < 1 AND WAGE > 0),
	EMPLOYMENT_DATE DATE
);

CREATE TABLE REPORTS (
	ID SERIAL PRIMARY KEY,
	REPORTER VARCHAR(32) REFERENCES ACCOUNT (LOGIN) ON UPDATE CASCADE,
	REPORTED VARCHAR(32) REFERENCES ACCOUNT (LOGIN) ON UPDATE CASCADE,
	DESCRIPTION VARCHAR(256)
);

CREATE TABLE TRANSACTIONS(
	ID SERIAL PRIMARY KEY,
	ACCOUNT VARCHAR(32) REFERENCES ACCOUNT (LOGIN) ON UPDATE CASCADE,
	TRANSACTION_SUM REAL NOT NULL,
	WHAT_TRANSACTION TRANSACTIONTYPE,
	TIMESTAMP DATE
);

CREATE TABLE ORDER_TYPE (
	NAME VARCHAR(32) PRIMARY KEY,
	DESCRIPTION VARCHAR(128)
);

CREATE TABLE ORDER_TYPES_IN_ORDERS (
	ID SERIAL REFERENCES ORDERS (ID) ON UPDATE CASCADE,
	NAME VARCHAR(32) REFERENCES ORDER_TYPE (NAME) ON UPDATE CASCADE
);

CREATE TABLE MATERIALS (
	NAME VARCHAR(32) PRIMARY KEY,
	AMOUNT REAL DEFAULT 0,
	COST REAL NOT NULL,
	MEASUREMENT MEASUREMENTTYPE
);

CREATE TABLE MATERIALS_IN_ORDER_TYPE (
	ORDER_TYPE_NAME VARCHAR(32) REFERENCES ORDER_TYPE (NAME) ON UPDATE CASCADE,
	MATERIAL_NAME VARCHAR(32) REFERENCES MATERIALS (NAME) ON UPDATE CASCADE,
	AVERAGE_AMOUNT_USED REAL NOT NULL
);

DROP OWNED BY ACCOUNTED_USER;
DROP ROLE IF EXISTS ACCOUNTED_USER;

DROP OWNED BY WORKER;
DROP ROLE IF EXISTS WORKER;

DROP OWNED BY ADMINISTRATOR;
DROP ROLE IF EXISTS ADMINISTRATOR;

CREATE ROLE ACCOUNTED_USER LOGIN PASSWORD 'QWERTY';
GRANT SELECT ON ORDER_TYPE, MATERIALS, MATERIALS_IN_ORDER_TYPE, MASTER TO ACCOUNTED_USER;
GRANT SELECT, INSERT ON ORDERS, TRANSACTIONS, ORDER_TYPES_IN_ORDERS TO ACCOUNTED_USER;
GRANT SELECT, UPDATE ON ACCOUNT TO ACCOUNTED_USER;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA public TO ACCOUNTED_USER;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO ACCOUNTED_USER;

CREATE ROLE WORKER LOGIN PASSWORD '09876';
GRANT SELECT ON ORDER_TYPE, MATERIALS, MATERIALS_IN_ORDER_TYPE, MASTER TO WORKER;
GRANT SELECT, INSERT ON TRANSACTIONS, ORDER_TYPES_IN_ORDERS TO WORKER;
GRANT SELECT, UPDATE ON ORDERS, ACCOUNT TO WORKER;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA public TO WORKER;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO WORKER;

CREATE ROLE ADMINISTRATOR LOGIN PASSWORD '12345';
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA PUBLIC TO ADMINISTRATOR;
ALTER DEFAULT PRIVILEGES IN SCHEMA PUBLIC GRANT ALL ON TABLES TO ADMINISTRATOR;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO ADMINISTRATOR;

DROP TRIGGER IF EXISTS TRIGGER_DISCARD_SUM_ON_ORDER_PLACE ON ORDERS;

DROP FUNCTION IF EXISTS DISCARD_SUM_ON_ORDER_PLACE;

DROP TRIGGER IF EXISTS TRIGGER_UPDATE_SUM_ON_ORDER_DISCARD ON ORDERS;

DROP FUNCTION IF EXISTS UPDATE_SUM_ON_ORDER_DISCARD;

DROP TRIGGER IF EXISTS TRIGGER_UPDATE_SUM_ON_ORDER_COMPLETION ON ORDERS;

DROP FUNCTION IF EXISTS UPDATE_SUM_ON_ORDER_COMPLETION;

DROP TRIGGER IF EXISTS TRIGGER_UPDATE_MATERIALS ON ORDERS;

DROP FUNCTION IF EXISTS UPDATE_MATERIALS;

DROP FUNCTION IF EXISTS USER_MONEY_DISMISSAL;

DROP FUNCTION IF EXISTS USER_MONEY_REPLENISHMENT;

DROP FUNCTION IF EXISTS FINAL_COST;

DROP FUNCTION IF EXISTS GET_ALL_TYPES;

CREATE OR REPLACE FUNCTION DISCARD_SUM_ON_ORDER_PLACE()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.status = 'Размещён'
       AND OLD.status IS DISTINCT FROM 'Размещён' THEN

        IF COALESCE(
            (SELECT money FROM account WHERE login = NEW.customer),
            0
        ) < COALESCE(FINAL_COST(NEW.id), 0) THEN

            NEW.status = 'Отклонён';

        ELSE
            UPDATE account
            SET money = COALESCE(money, 0) - COALESCE(FINAL_COST(NEW.id), 0)
            WHERE login = NEW.customer;
        END IF;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER TRIGGER_DISCARD_SUM_ON_ORDER_PLACE BEFORE UPDATE ON ORDERS FOR EACH ROW
EXECUTE FUNCTION DISCARD_SUM_ON_ORDER_PLACE ();

CREATE OR REPLACE FUNCTION UPDATE_SUM_ON_ORDER_DISCARD () RETURNS TRIGGER AS $$
BEGIN
    IF (NEW.STATUS = 'Отклонён') THEN
		UPDATE ACCOUNT
		SET MONEY = MONEY + FINAL_COST(NEW.ID)
		WHERE LOGIN = NEW.CUSTOMER;
	END IF;
    RETURN NEW;
END;
$$ LANGUAGE PLPGSQL SECURITY DEFINER;

CREATE TRIGGER TRIGGER_UPDATE_SUM_ON_ORDER_DISCARD
AFTER
UPDATE ON ORDERS FOR EACH ROW
EXECUTE FUNCTION UPDATE_SUM_ON_ORDER_DISCARD ();

CREATE OR REPLACE FUNCTION UPDATE_SUM_ON_ORDER_COMPLETION()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.status = 'Завершен'
       AND OLD.status IS DISTINCT FROM 'Завершен' THEN
a
        UPDATE account AS A
        SET money = A.money + FINAL_COST(NEW.id) * M.wage
        FROM master AS M
        WHERE A.login = M.login
          AND M.login = NEW.master;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER TRIGGER_UPDATE_SUM_ON_ORDER_COMPLETION
AFTER
UPDATE ON ORDERS FOR EACH ROW
EXECUTE FUNCTION UPDATE_SUM_ON_ORDER_COMPLETION ();

CREATE OR REPLACE FUNCTION UPDATE_MATERIALS () RETURNS TRIGGER AS $$
BEGIN
    IF (NEW.STATUS = 'Завершен') THEN
		UPDATE MATERIALS
		SET AMOUNT = AMOUNT - MIOT1.AVERAGE_AMOUNT_USED FROM MATERIALS_IN_ORDER_TYPE AS MIOT1
		WHERE NAME IN (
			SELECT MIOT2.MATERIAL_NAME FROM MATERIALS_IN_ORDER_TYPE AS MIOT2
			WHERE MIOT2.ORDER_TYPE_NAME IN (
				SELECT OTIO.NAME FROM ORDER_TYPES_IN_ORDERS AS OTIO
				WHERE OTIO.ID = NEW.ID
			)
		);
		UPDATE MATERIALS
		SET AMOUNT = 0
		WHERE AMOUNT < 0;
	END IF;
    RETURN NEW;
END;
$$ LANGUAGE PLPGSQL SECURITY DEFINER;

CREATE TRIGGER TRIGGER_UPDATE_MATERIALS
AFTER
UPDATE ON ORDERS FOR EACH ROW
EXECUTE FUNCTION UPDATE_MATERIALS ();

CREATE OR REPLACE FUNCTION USER_MONEY_REPLENISHMENT (
	ACCOUNTLOGIN VARCHAR(32),
	REPLENSHMENT_AMOUNT REAL
) RETURNS VOID AS $$
BEGIN
    INSERT INTO TRANSACTIONS (ACCOUNT, TRANSACTION_SUM, WHAT_TRANSACTION, TIMESTAMP)
    VALUES (ACCOUNTLOGIN, REPLENSHMENT_AMOUNT, 'Пополнение', CURRENT_TIMESTAMP);

	UPDATE ACCOUNT
	SET MONEY = MONEY + REPLENSHMENT_AMOUNT
	WHERE LOGIN = ACCOUNTLOGIN;
END;
$$ LANGUAGE PLPGSQL SECURITY DEFINER;

CREATE OR REPLACE FUNCTION USER_MONEY_DISMISSAL (ACCOUNTLOGIN VARCHAR(32), DISMISSAL_AMOUNT REAL) RETURNS VOID AS $$
BEGIN
    INSERT INTO TRANSACTIONS (ACCOUNT, TRANSACTION_SUM, WHAT_TRANSACTION, TIMESTAMP)
    VALUES (ACCOUNTLOGIN, DISMISSAL_AMOUNT, 'Списание', CURRENT_TIMESTAMP);

	IF (SELECT MONEY - DISMISSAL_AMOUNT FROM ACCOUNT WHERE LOGIN = ACCOUNTLOGIN) < 0 THEN
		INSERT INTO TRANSACTIONS (
        ACCOUNT,
        TRANSACTION_SUM,
        WHAT_TRANSACTION,
		TIMESTAMP) 
		VALUES (
        ACCOUNTLOGIN,
		DISMISSAL_AMOUNT,
        'Отклонено',
		CURRENT_TIMESTAMP);
	ELSE
		UPDATE ACCOUNT
		SET MONEY = MONEY - DISMISSAL_AMOUNT
		WHERE LOGIN = ACCOUNTLOGIN;
	END IF;
END;
$$ LANGUAGE PLPGSQL SECURITY DEFINER;

CREATE OR REPLACE FUNCTION FINAL_COST (ORDERID INTEGER) RETURNS REAL AS $$
DECLARE
	_COST REAL;
BEGIN
    SELECT SUM(MIOT.AVERAGE_AMOUNT_USED * M.COST) INTO _COST FROM MATERIALS AS M	 				
	JOIN MATERIALS_IN_ORDER_TYPE AS MIOT ON MIOT.MATERIAL_NAME = M.NAME	
	WHERE MIOT.ORDER_TYPE_NAME IN (							
		SELECT NAME FROM ORDER_TYPES_IN_ORDERS 		
		WHERE ID = ORDERID								
	);
	RETURN COALESCE(_COST, 0);
END;
$$ LANGUAGE PLPGSQL SECURITY DEFINER;

CREATE OR REPLACE FUNCTION GET_ALL_TYPES(ORDERID INTEGER) RETURNS TABLE(type_name VARCHAR(32)) AS $$  
BEGIN
	RETURN QUERY
	SELECT NAME FROM ORDER_TYPE 
	WHERE NAME IN (
		SELECT NAME FROM ORDER_TYPES_IN_ORDERS 
		WHERE ID = ORDERID
	);
END;
$$ LANGUAGE PLPGSQL SECURITY DEFINER;

TRUNCATE TABLE MATERIALS CASCADE;
TRUNCATE TABLE ORDER_TYPE CASCADE;
TRUNCATE TABLE ORDERS CASCADE;
TRUNCATE TABLE ACCOUNT CASCADE;
ALTER SEQUENCE ORDERS_ID_SEQ RESTART WITH 1;
ALTER SEQUENCE ORDER_TYPES_IN_ORDERS_ID_SEQ RESTART WITH 1;
ALTER SEQUENCE REPORTS_ID_SEQ RESTART WITH 1;
ALTER SEQUENCE TRANSACTIONS_ID_SEQ RESTART WITH 1;

INSERT INTO ACCOUNT (LOGIN, PASSWORD, AVATAR_PATH, FIO, EMAIL, PHONE, MONEY, ROLE) VALUES
('user1', 'pass123', 'album_1.jpg', 'Иванов Иван Иванович', 'ivanov@mail.ru', '+79161234567', 15000.50, 'Пользователь'),
('user2', 'pass456', 'album_1.jpg', 'Петров Петр Петрович', 'petrov@mail.ru', '+79162345678', 8500.00, 'Пользователь'),
('user3', 'pass789', 'album_1.jpg', 'Сидорова Анна Сергеевна', 'sidorova@mail.ru', '+79163456789', 12000.00, 'Пользователь'),
('user4', 'pass101', 'album_1.jpg', 'Кузнецов Алексей Дмитриевич', 'kuznetsov@mail.ru', '+79164567890', 5000.00, 'Пользователь'),
('user5', 'pass112', 'album_1.jpg', 'Смирнова Елена Владимировна', 'smirnova@mail.ru', '+79165678901', 30000.00, 'Пользователь'),
('master1', 'mast123', 'album_1.jpg', 'Волков Денис Игоревич', 'volkov@mail.ru', '+79166789012', 25000.00, 'Мастер'),
('master2', 'mast456', 'album_1.jpg', 'Козлова Мария Петровна', 'kozlova@mail.ru', '+79167890123', 18000.00, 'Мастер'),
('master3', 'mast789', 'album_1.jpg', 'Лебедев Сергей Александрович', 'lebedev@mail.ru', '+79168901234', 22000.00, 'Мастер'),
('master4', 'mast101', 'album_1.jpg', 'Новикова Ольга Викторовна', 'novikova@mail.ru', '+79169012345', 19000.00, 'Мастер'),
('master5', 'mast112', 'album_1.jpg', 'Морозов Игорь Николаевич', 'morozov@mail.ru', '+79160123456', 21000.00, 'Мастер'),
('admin1', 'admin123', 'album_1.jpg', 'Федоров Андрей Борисович', 'fedorov@mail.ru', '+79161234560', 40000.00, 'Администратор'),
('user6', 'pass131', 'album_1.jpg', 'Григорьева Татьяна Олеговна', 'grigoreva@mail.ru', '+79162345671', 7500.00, 'Пользователь'),
('user7', 'pass141', 'album_1.jpg', 'Белов Артем Константинович', 'belov@mail.ru', '+79163456782', 9200.00, 'Пользователь'),
('user8', 'pass151', 'album_1.jpg', 'Краснова Ирина Васильевна', 'krasnova@mail.ru', '+79164567893', 11000.00, 'Пользователь'),
('user9', 'pass161', 'album_1.jpg', 'Павлов Николай Львович', 'pavlov@mail.ru', '+79165678904', 16000.00, 'Пользователь');

INSERT INTO MASTER (LOGIN, WAGE, EMPLOYMENT_DATE) VALUES
('master1', 0.78, '2022-03-15'),
('master2', 0.66, '2022-05-20'),
('master3', 0.43, '2021-11-10'),
('master4', 0.5, '2023-01-25'),
('master5', 0.96, '2022-07-30');

INSERT INTO ORDER_TYPE (NAME, DESCRIPTION) VALUES
('Реставрация фото', 'Восстановление старых фотографий'),
('Колоризация', 'Раскрашивание черно-белых фото'),
('Ретушь', 'Удаление дефектов с фото'),
('Восстановление рамок', 'Реставрация фото-рамок'),
('Ламинация', 'Защитное покрытие фотографий'),
('Увеличение фото', 'Увеличение размера фотографий'),
('Цифровая реставрация', 'Восстановление в цифровом виде'),
('Восстановление слайдов', 'Реставрация фотопленок'),
('Создание коллажей', 'Создание композиций из фото'),
('Реставрация портретов', 'Специализированная реставрация портретов'),
('Восстановление документов', 'Реставрация фото документов'),
('Фотоархивация', 'Оцифровка и сохранение фото'),
('Реставрация пейзажей', 'Восстановление пейзажных фото'),
('Коррекция экспозиции', 'Исправление освещения на фото'),
('Восстановление групповых фото', 'Реставрация групповых снимков');

INSERT INTO MATERIALS (NAME, AMOUNT, COST, MEASUREMENT) VALUES
('Фотобумага', 50.5, 120.00, 'шт'),
('Клей фотографический', 12.3, 450.00, 'л'),
('Красители', 8.7, 780.00, 'кг'),
('Защитный лак', 25.0, 320.00, 'л'),
('Растворитель', 18.9, 560.00, 'л'),
('Пленка для ламинации', 45.0, 230.00, 'м'),
('Химикаты для проявки', 32.1, 890.00, 'кг'),
('Рамки деревянные', 120.0, 150.00, 'шт'),
('Стекло для рамок', 75.0, 95.00, 'шт'),
('Картон для задников', 200.0, 45.00, 'шт'),
('Чистящие средства', 15.8, 340.00, 'л'),
('Кисти реставрационные', 60.0, 180.00, 'шт'),
('Перчатки', 300.0, 25.00, 'шт'),
('Салфетки безворсовые', 500.0, 15.00, 'шт'),
('Фотопленка', 35.0, 670.00, 'м');

INSERT INTO ORDERS (NAME, IMAGE_PATH, CONTRACT_URL, STATUS, CUSTOMER, MASTER) VALUES
('order1', 'album_1.jpg', 'contracts/order1.pdf', 'В обработке', 'user1', NULL),
('order2', 'album_2.jpg', 'contracts/order2.pdf', 'Размещён', 'user2', NULL),
('order3', 'album_3.jpg', 'contracts/order3.pdf', 'Принят мастером', 'user3', 'master3'),
('order4', 'album_4.jpg', 'contracts/order4.pdf', 'Завершен', 'user4', 'master4'),
('order5', 'album_5.jpg', 'contracts/order5.pdf', 'В обработке', 'user5', NULL),
('order6', 'album_6.jpg', 'contracts/order6.pdf', 'Размещён', 'user6', NULL),
('order7', 'album_7.jpg', 'contracts/order7.pdf', 'Принят мастером', 'user7', 'master2'),
('order8', 'album_8.jpg', 'contracts/order8.pdf', 'Завершен', 'user8', 'master3'),
('order9', 'album_9.jpg', 'contracts/order9.pdf', 'В обработке', 'user9', NULL),
('order10', 'album_10.jpg', 'contracts/order10.pdf', 'Размещён', 'user1', NULL),
('order11', 'album_11.jpg', 'contracts/order11.pdf', 'Принят мастером', 'user2', 'master1'),
('order12', 'album_12.jpg', 'contracts/order12.pdf', 'Завершен', 'user3', 'master2'),
('order13', 'album_13.jpg', 'contracts/order13.pdf', 'В обработке', 'user4', NULL),
('order14', 'album_14.jpg', 'contracts/order14.pdf', 'Размещён', 'user5', NULL),
('order15', 'album_15.jpg', 'contracts/order15.pdf', 'Принят мастером', 'user6', 'master5');

INSERT INTO ORDER_TYPES_IN_ORDERS (ID, NAME) VALUES
(1, 'Реставрация фото'),
(2, 'Колоризация'),
(3, 'Ретушь'),
(4, 'Восстановление рамок'),
(5, 'Ламинация'),
(6, 'Увеличение фото'),
(7, 'Цифровая реставрация'),
(8, 'Восстановление слайдов'),
(9, 'Создание коллажей'),
(10, 'Реставрация портретов'),
(11, 'Восстановление документов'),
(12, 'Фотоархивация'),
(13, 'Реставрация пейзажей'),
(14, 'Коррекция экспозиции'),
(15, 'Восстановление групповых фото'),
(10, 'Создание коллажей'),
(4, 'Реставрация портретов'),
(2, 'Восстановление документов'),
(1, 'Фотоархивация'),
(8, 'Реставрация пейзажей');

INSERT INTO MATERIALS_IN_ORDER_TYPE (ORDER_TYPE_NAME, MATERIAL_NAME, AVERAGE_AMOUNT_USED) VALUES
('Реставрация фото', 'Фотобумага', 2.5),
('Реставрация фото', 'Клей фотографический', 0.3),
('Колоризация', 'Красители', 0.5),
('Колоризация', 'Фотобумага', 1.0),
('Ретушь', 'Чистящие средства', 0.2),
('Ретушь', 'Салфетки безворсовые', 5.0),
('Восстановление рамок', 'Рамки деревянные', 1.0),
('Восстановление рамок', 'Стекло для рамок', 1.0),
('Ламинация', 'Пленка для ламинации', 0.5),
('Ламинация', 'Фотобумага', 1.0),
('Увеличение фото', 'Фотобумага', 3.0),
('Цифровая реставрация', 'Фотобумага', 2.0),
('Восстановление слайдов', 'Фотопленка', 0.8),
('Создание коллажей', 'Картон для задников', 2.0),
('Реставрация портретов', 'Красители', 0.7),
('Восстановление документов', 'Фотобумага', 2.0),
('Восстановление документов', 'Клей фотографический', 0.05),
('Восстановление документов', 'Защитный лак', 0.03),
('Восстановление документов', 'Перчатки', 1.0),
('Фотоархивация', 'Фотопленка', 0.5),
('Фотоархивация', 'Салфетки безворсовые', 3.0),
('Фотоархивация', 'Чистящие средства', 0.02),
('Реставрация пейзажей', 'Фотобумага', 3.0),
('Реставрация пейзажей', 'Красители', 0.1),
('Реставрация пейзажей', 'Кисти реставрационные', 1.0),
('Реставрация пейзажей', 'Защитный лак', 0.07),
('Коррекция экспозиции', 'Красители', 0.05),
('Коррекция экспозиции', 'Химикаты для проявки', 0.08),
('Коррекция экспозиции', 'Растворитель', 0.04),
('Восстановление групповых фото', 'Фотобумага', 4.0),
('Восстановление групповых фото', 'Красители', 0.15),
('Восстановление групповых фото', 'Клей фотографический', 0.08),
('Восстановление групповых фото', 'Пленка для ламинации', 1.2),
('Восстановление групповых фото', 'Перчатки', 2.0);


INSERT INTO REPORTS (REPORTER, REPORTED, DESCRIPTION) VALUES
('user1', 'master1', 'Некачественно выполненная работа'),
('user2', 'master2', 'Нарушение сроков выполнения заказа'),
('user3', 'master3', 'Грубое общение с клиентом'),
('user4', 'master4', 'Повреждение оригинального фото'),
('user5', 'master5', 'Несоответствие результата ожиданиям'),
('master1', 'user1', 'Клиент не предоставил все необходимые материалы'),
('master2', 'user2', 'Клиент не явился на встречу'),
('master3', 'user3', 'Некорректное описание задачи'),
('master4', 'user4', 'Клиент отказался оплачивать доп. работы'),
('master5', 'user5', 'Постоянные переносы сроков со стороны клиента'),
('admin1', 'master1', 'Нарушение внутреннего регламента'),
('admin1', 'user6', 'Нарушение правил сервиса'),
('user7', 'user8', 'Некорректное поведение на форуме'),
('user8', 'user7', 'Распространение ложной информации'),
('user9', 'master2', 'Несанкционированное использование материалов');

INSERT INTO TRANSACTIONS (ACCOUNT, TRANSACTION_SUM, WHAT_TRANSACTION, TIMESTAMP) VALUES
('user1', 1500.00, 'Пополнение', '2024-01-15'),
('user2', -500.00, 'Списание', '2024-01-16'),
('user3', 2000.00, 'Пополнение', '2024-01-17'),
('user4', -1200.00, 'Списание', '2024-01-18'),
('user5', 3000.00, 'Пополнение', '2024-01-19'),
('master1', 4500.00, 'Пополнение', '2024-01-20'),
('master2', -300.00, 'Списание', '2024-01-21'),
('master3', 5200.00, 'Пополнение', '2024-01-22'),
('master4', -800.00, 'Списание', '2024-01-23'),
('master5', 2100.00, 'Пополнение', '2024-01-24'),
('user6', 1800.00, 'Пополнение', '2024-01-25'),
('user7', -950.00, 'Списание', '2024-01-26'),
('user8', 0.00, 'Отклонено', '2024-01-27'),
('user9', 2750.00, 'Пополнение', '2024-01-28'),
('admin1', -150.00, 'Списание', '2024-01-29'),
('admin1', 2000.00, 'Пополнение', '2024-01-17'),
('master3', -1200.00, 'Списание', '2024-01-18'),
('user2', 3000.00, 'Пополнение', '2024-01-19'),
('master4', 4500.00, 'Пополнение', '2024-01-20'),
('admin1', -300.00, 'Списание', '2024-01-21');