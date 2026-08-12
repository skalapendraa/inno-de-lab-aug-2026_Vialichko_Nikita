-- Часть 2. Задача 1
-- Соединяем таблицы заказов и клиентов, чтобы увидеть, кто и что заказал (имя клиента + товар + сумма)
SELECT c.first_name, c.last_name, o.item, o.amount
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id;
