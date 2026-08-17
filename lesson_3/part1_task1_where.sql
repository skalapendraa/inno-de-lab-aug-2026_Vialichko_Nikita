-- Часть 1. Задача 1
-- Выбор клиентов из США старше 25 лет
SELECT first_name, last_name, age, country
FROM Customers
WHERE country = 'USA' AND age > 25;
