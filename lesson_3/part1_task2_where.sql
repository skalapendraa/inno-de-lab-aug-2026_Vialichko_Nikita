-- Часть 1. Задача 2
-- Выбор заказов, сумма которых больше 1000
SELECT order_id, item, amount, customer_id
FROM Orders
WHERE amount > 1000;
