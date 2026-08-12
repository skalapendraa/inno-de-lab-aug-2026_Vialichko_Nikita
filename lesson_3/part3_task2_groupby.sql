-- Часть 3. Задача 2
-- Для каждого товара просчитывается количество заказов и средняя сумма заказа
SELECT item, COUNT(*) AS count, AVG(amount) AS avg_amount
FROM Orders
GROUP BY item;
