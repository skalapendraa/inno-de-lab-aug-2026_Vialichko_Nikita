-- Часть 6. Задача 1
-- Оконная функция SUM() OVER (PARTITION BY ...) считает
-- сумму всех заказов каждого клиента, каждый заказ остаётся видимым
-- отдельной строкой, а рядом с ним показана его "групповая" сумма
SELECT 
    order_id, 
    customer_id, 
    item, 
    amount,
    SUM(amount) OVER (PARTITION BY customer_id) AS total_by_customer
FROM Orders;
