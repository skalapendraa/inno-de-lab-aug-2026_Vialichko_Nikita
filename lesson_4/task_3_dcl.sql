-- 1. Создаем нового user 
CREATE USER hr_user WITH PASSWORD 'hr_password123';

-- 2. Выдаем право SELECT на таблицу Employees
GRANT SELECT ON TABLE Employees TO hr_user;

-- 3. Выдаем права на вставку и обновление данных для hr_user
GRANT INSERT, UPDATE ON TABLE Employees TO hr_user;

-- 4. Выдаем права на использование генератора автоинкремента
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO hr_user;