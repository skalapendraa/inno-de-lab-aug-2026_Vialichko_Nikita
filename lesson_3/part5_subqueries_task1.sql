-- Часть 5. Задача 1
-- Находим клиента и заказ с максимальной суммой.
-- Подзапрос (SELECT MAX(amount) FROM Orders) сначала находит
-- максимальную сумму среди всех заказов, а внешний запрос
-- ищет заказ и клиента с этой суммой
SELECT c.first_name, c.last_name, o.amount
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
WHERE o.amount = (SELECT MAX(amount) FROM Orders);
