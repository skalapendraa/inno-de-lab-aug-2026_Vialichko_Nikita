-- 1. Создаем нового user 
CREATE USER hr_user WITH PASSWORD 'hr_password123';

-- 2. Выдаем право SELECT на таблицу Employees
GRANT SELECT ON TABLE Employees TO hr_user;

-- 3. Выдаем права на вставку и обновление данных для hr_user, через admin соединение
--GRANT INSERT, UPDATE ON TABLE Employees TO hr_user;

-- 4. Выдаем права на использование генератора автоинкремента, через admin соединение 
--GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO hr_user;

-- Результаты тестирования 
-- Тест 1 (SELECT под hr_user, до выдачи прав INSERT/UPDATE): успешно.
--   См. task3_1_dcl_select_success.jpg
-- Тест 2 (INSERT под hr_user, до выдачи прав INSERT): ошибка доступа,
--   SQL Error 42501: permission denied for table employees.
--   См. task3_2_dcl_insert_permission_denied.jpg
-- Тест 3 (INSERT и UPDATE под hr_user, после GRANT INSERT, UPDATE): успешно.
--   См. task3_3_dcl_insert_update_success.jpg