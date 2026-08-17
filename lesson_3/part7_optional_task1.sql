-- Часть 7 (Опционально)
-- Находим клиентов, которым доставка уже выполнена (status = 'Delivered'),
-- и у которых при этом 2 и более заказов.
SELECT 
    CONCAT(c.first_name, ' ', c.last_name) AS full_name,
    c.country,
    COUNT(o.order_id) AS total_orders,
    SUM(o.amount) AS total_amount
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
WHERE c.customer_id IN (
    -- подзапрос: id клиентов, у которых статус доставки Delivered
    SELECT customer
    FROM Shippings
    WHERE status = 'Delivered'
)
GROUP BY c.customer_id, c.first_name, c.last_name, c.country
HAVING COUNT(o.order_id) >= 2;