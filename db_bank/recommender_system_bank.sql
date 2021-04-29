/*
 						Требования к курсовому проекту:

	1. Составить общее текстовое описание БД и решаемых ею задач;
	2. минимальное количество таблиц - 10;
	3. скрипты создания структуры БД (с первичными ключами, индексами, внешними ключами);
	4. создать ERDiagram для БД;
	5. скрипты наполнения БД данными;
	6. скрипты характерных выборок (включающие группировки, JOIN'ы, вложенные таблицы);
	7. представления (минимум 2);
	8. хранимые процедуры / триггеры;
	
	Примеры: описать модель хранения данных популярного веб-сайта: кинопоиск, booking.com, wikipedia, интернет-магазин, geekbrains, госуслуги...

 */


-- 1. Составить общее текстовое описание БД и решаемых ею задач;

/*
	База хронит: 
		данные клиентов, 
		данные продуктов банка,
		данные по отдельным сигментам банка(кредиты, инвестиции, ...),
		данные по текущим и планируемым скидкам,
                данные по сотрудникам колл центра и запросам клиентов,
		рекомендации продукта клиентам

	Задачи БД:
		1. Хранение и сбор информации о клиентах.
		2. Таргетная реклама скидок и новых продктов.
 */


DROP DATABASE IF EXISTS Discount_MVP;
CREATE DATABASE Discount_MVP;

USE Discount_MVP;


--Таблица №1 Клиенты
CREATE TABLE users(
	id SERIAL PRIMARY KEY, 
	firsname VARCHAR(100), 
	lastname VARCHAR(100),
	telephon VARCHAR(100),
	date_of_creation DATE,
	update_date DATE);				--дата обновления(покупкка или использование продукта банка)

INSERT INTO users VALUES
	(0, 'Leo_1', 'Simson', '89996667878', '2000-04-12', '2000-04-12'),
	(0, 'Leo_2', 'Simson', '89996667878', '2000-04-12', '2000-04-12'),
	(0, 'Leo_3', 'Simson', '89996667878', '2000-04-12', '2000-04-12'),
	(0, 'Leo_4', 'Simson', '89996667878', '2000-04-12', '2000-04-12'),
	(0, 'Leo_5', 'Simson', '89996667878', '2000-04-12', '2000-04-12');


--Таблица №2 Продукты банка
CREATE TABLE products(
        id SERIAL PRIMARY KEY,		
        group_name VARCHAR(255),
        name VARCHAR(100));				--Товар

INSERT INTO products VALUES
	(0, 'investments', 'gold'),
        (0, 'investments', 'USE'),
        (0, 'investments', 'EUR'),
        (0, 'investments', 'bonds'),
        (0, 'investments', 'stocks'),
	(0, 'card', 'debit'),
	(0, 'card', 'credit'),
        (0, 'credit', 'mortgage'),
	(0, 'credit', 'consumer_credit'),
	(0, 'insurance', 'life'),
	(0, 'insurance', 'property');


--Таблица №3 Инвестиции
CREATE TABLE investments(
        id SERIAL PRIMARY KEY,
	user_id BIGINT UNSIGNED,
	product_id BIGINT UNSIGNED,
	ue INT,
	date_of_creation DATE,
	FOREIGN KEY (user_id) REFERENCES users(id),
        FOREIGN KEY (product_id) REFERENCES products(id),
	INDEX (user_id));

INSERT INTO investments VALUES
	(0, 1, 3, 5000, '2000-05-24'),
	(0, 1, 1, 5, '2005-02-24'),
	(0, 3, 4, 50, '2010-07-24'),
	(0, 5, 5, 10, '2020-09-24');


--Таблица №4 Карты(дебетовый, кредитные)
CREATE TABLE cards(
        id SERIAL PRIMARY KEY,
        user_id BIGINT UNSIGNED,
        product_id BIGINT UNSIGNED,
	ue INT,
        date_of_creation DATE,
	FOREIGN KEY (user_id) REFERENCES users(id),
	FOREIGN KEY (product_id) REFERENCES products(id),
	INDEX (user_id));

INSERT INTO cards VALUES
	(0, 2, 6, 20000, '2000-01-21'),
	(0, 2, 7, 100000, '2000-01-21'),
	(0, 3, 7, 100000, '2010-03-23'),
	(0, 3, 7, 100000, '2015-04-04'),
	(0, 3, 6, 20000, '2020-05-25');


--Таблица №5 Кредиты процент(annual_percentage), сумма(ue)
CREATE TABLE credits(
        id SERIAL PRIMARY KEY,
	user_id BIGINT UNSIGNED,
        product_id BIGINT UNSIGNED,
	ue INT,
	annual_percentage INT,
	date_of_creation DATE,
	date_of_end DATE,
	FOREIGN KEY (user_id) REFERENCES users(id),
        FOREIGN KEY (product_id) REFERENCES products(id),
        INDEX (user_id));

INSERT INTO credits VALUES
	(0, 1, 8, 100000, 5, '2015-04-04', '2017-04-04'),
	(0, 1, 9, 100000, 8, '2017-04-04', '2019-04-04'),
	(0, 2, 9, 100000, 8, '2015-04-04', '2017-04-04'),
	(0, 3, 8, 100000, 5, '2015-04-04', '2017-04-04'),
	(0, 5, 8, 100000, 5, '2015-04-04', '2017-04-04');


--Таблица №6 Страхование
CREATE TABLE insurances(
        id SERIAL PRIMARY KEY,
	user_id BIGINT UNSIGNED,
        product_id BIGINT UNSIGNED,
	ue INT,
        date_of_creation DATE,
        FOREIGN KEY (user_id) REFERENCES users(id),
        FOREIGN KEY (product_id) REFERENCES products(id),
        INDEX (user_id));

INSERT INTO insurances VALUES
	(0, 4, 10, 5000, '2015-04-04'),
	(0, 4, 11, 5000, '2015-04-04'),
	(0, 5, 10, 5000, '2015-04-04'),
	(0, 5, 11, 5000, '2015-04-04'),
	(0, 5, 11, 5000, '2015-04-04');


--Таблица №7 Планируемые скидки
CREATE TABLE discounts_next_manf(
	id SERIAL PRIMARY KEY,
       	product_id BIGINT UNSIGNED,
	discount INT,
	date_start DATE,
	date_stop DATE,
	FOREIGN KEY (product_id) REFERENCES products(id));

INSERT INTO discounts_next_manf VALUES
	(0, 6, 5, '2015-04-04', '2015-06-04'),
	(0, 8, 5, '2015-04-04', '2015-06-04'),
	(0, 8, 5, '2015-04-04', '2015-06-04'),
	(0, 9, 5, '2015-04-04', '2015-06-04'),
	(0, 10, 5, '2015-04-04', '2015-06-04');


--Таблица №8 Скидки 
CREATE TABLE discounts_now( 
	id SERIAL PRIMARY KEY,
       	product_id BIGINT UNSIGNED,
	discount INT,
        date_start DATE, 
	date_stop DATE,
	FOREIGN KEY (product_id) REFERENCES products(id));

INSERT INTO discounts_now VALUES
	(0, 6, 5, '2015-04-04', '2015-06-04'),
	(0, 6, 5, '2015-04-04', '2015-06-04'),
	(0, 6, 5, '2015-04-04', '2015-06-04'),
	(0, 6, 5, '2015-04-04', '2015-06-04'),
	(0, 6, 5, '2015-04-04', '2015-06-04');


--Таблица №9 Колл центр
CREATE TABLE call_agent(
	id SERIAL PRIMARY KEY,
        firsname VARCHAR(100),
        lastname VARCHAR(100),
        telephon VARCHAR(100));

INSERT INTO call_agent VALUES
        (0, 'Alex_1', 'Black', '89996660000'),
        (0, 'Alex_2', 'Black', '89996660000'),
        (0, 'Alex_3', 'Black', '89996660000'),
        (0, 'Alex_4', 'Black', '89996660000'),
        (0, 'Alex_5', 'Black', '89996660000');


--Таблица №10 Тех поддержка
CREATE TABLE tech_support(
	id SERIAL PRIMARY KEY,
        user_id BIGINT UNSIGNED,
	call_agent_id BIGINT UNSIGNED,
	question_user TEXT,
	enswer_agent TEXT,
	FOREIGN KEY (user_id) REFERENCES users(id),
        FOREIGN KEY (call_agent_id) REFERENCES call_agent(id));

INSERT INTO tech_support VALUES
        (0, 1, 2, 'error = 2342423', 'text support'),
	(0, 5, 1, 'error = 2342423', 'text support'),
	(0, 3, 3, 'error = 2342423', 'text support'),
	(0, 1, 1, 'error = 2342423', 'text support'),
	(0, 4, 4, 'error = 2342423', 'text support');


--Представление №1, JOIN
CREATE VIEW client_get_products AS SELECT
        users.id AS id,
        investments.product_id AS invest_prod,
        cards.product_id AS card_prod,
        credits.product_id AS credit_prod,
        insurances.product_id AS insurance_prod
FROM users       
LEFT JOIN investments ON investments.user_id = users.id
LEFT JOIN cards ON cards.user_id = users.id
LEFT JOIN credits ON credits.user_id = users.id
LEFT JOIN insurances ON insurances.user_id = users.id
ORDER BY id, invest_prod;

SELECT * FROM client_get_products;

--Представление №2, групперовка
CREATE VIEW count_client_get_products AS SELECT
        id,
        count(invest_prod) AS invest_prod,                                                       
        count(card_prod) AS card_prod, 
        count(credit_prod) AS credit_prod, 
        count(insurance_prod) AS insurance_prod
FROM client_get_products GROUP BY id ORDER BY id;

SELECT * FROM count_client_get_products;


--Процедура, вложенные таблицы, транзакции(debit carts)
DELIMITER //

CREATE PROCEDURE mvp (value INT)
BEGIN
        IF value > (SELECT MAX(id) FROM users) THEN
                SELECT "count user" AS error, (SELECT MAX(id) FROM users) AS last_user_id;
        END IF;

        IF (SELECT invest_prod FROM count_client_get_products WHERE id = value) > 3 THEN
                SELECT value AS users, "investments > 3" AS recomend;
        ELSEIF (SELECT invest_prod FROM count_client_get_products WHERE id = value) = 0 THEN
                SELECT value AS users, "investments = 0" AS recomend;
        END IF;

        IF (SELECT card_prod FROM count_client_get_products WHERE id = value) > 3 THEN
                SELECT value AS users, "card > 3" AS recomend;
        ELSEIF (SELECT card_prod FROM count_client_get_products WHERE id = value) = 0 THEN
                SELECT value AS users, "card = 0" AS recomend;
        END IF;

        IF (SELECT credit_prod FROM count_client_get_products WHERE id = value) > 3 THEN
                SELECT value AS users, "credit > 3" AS recomend;
        ELSEIF (SELECT credit_prod FROM count_client_get_products WHERE id = value) = 0 THEN
                SELECT value AS users, "credit = 0" AS recomend;
        END IF;

        IF (SELECT insurance_prod FROM count_client_get_products WHERE id = value) > 3 THEN
                SELECT value AS users, "insurance > 3" AS recomend;
        ELSEIF (SELECT insurance_prod FROM count_client_get_products WHERE id = value) = 0 THEN
                SELECT value AS users, "insurance = 0" AS recomend;
        END IF;

END //


--transaction debit card (tdc)
CREATE PROCEDURE tdc (user_id_1 INT, summa INT, user_id_2 INT)
BEGIN
        START TRANSACTION;

        IF user_id_1 > (SELECT MAX(id) FROM users) or user_id_2 > (SELECT MAX(id) FROM users) THEN
                SELECT "ERROR user_id not found";
        ELSEIF user_id_1 NOT IN (SELECT user_id FROM cards WHERE product_id = 6) or user_id_2 NOT IN (SELECT user_id FROM cards WHERE product_id = 6) THEN
                SELECT "ERROR user cadrs not found";
	ELSE
		UPDATE cards SET ue = ue - summa WHERE user_id = user_id_1 AND product_id = 6;
	        UPDATE cards SET ue = ue + summa WHERE user_id = user_id_2 AND product_id = 6;

        END IF;
                
        COMMIT;

END //


--тригеры
CREATE TRIGGER update_date_use_cards AFTER INSERT ON cards
FOR EACH ROW
BEGIN
        UPDATE users SET update_date = NOW() WHERE NEW.user_id = id;

END //

CREATE TRIGGER update_date_use_investments AFTER INSERT ON investments
FOR EACH ROW
BEGIN
        UPDATE users SET update_date = NOW() WHERE NEW.user_id = id;

END //

CREATE TRIGGER update_date_use_credits AFTER INSERT ON credits
FOR EACH ROW
BEGIN
        UPDATE users SET update_date = NOW() WHERE NEW.user_id = id;

END //

CREATE TRIGGER update_date_use_insurances AFTER INSERT ON insurances
FOR EACH ROW
BEGIN
        UPDATE users SET update_date = NOW() WHERE NEW.user_id = id;
END //

DELIMITER ;
