-- Часть 3. Задача 1
-- Подсчёт количества клиентов в каждой стране
SELECT country, COUNT(*) AS count
FROM Customers
GROUP BY country;
