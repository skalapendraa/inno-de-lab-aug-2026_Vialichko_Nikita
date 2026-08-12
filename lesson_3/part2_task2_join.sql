-- Часть 2. Задача 2
-- Соединяем таблицы доставок и клиентов, чтобы увидеть статус доставки для каждого клиента
SELECT s.status, c.first_name, c.last_name
FROM Shippings s
JOIN Customers c ON s.customer = c.customer_id;
