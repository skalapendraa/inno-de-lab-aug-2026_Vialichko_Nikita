-- 1. Добавление двух сотрудников (отделы отличные от 'IT')
INSERT INTO Employees (FirstName, LastName, Department, Salary) 
VALUES 
    ('John', 'Doe', 'Marketing', 55000.00),
    ('Grace', 'Hopper', 'DevOps', 85000.00);

-- 2. Выборка всех сотрудников
SELECT * FROM Employees;

-- 3. Выборка FirstName и LastName сотрудников из отдела 'IT'
SELECT FirstName, LastName 
FROM Employees 
WHERE Department = 'IT';

-- 4. Обновление зарплаты Alice Smith
UPDATE Employees 
SET Salary = 65000.00 
WHERE FirstName = 'Alice' AND LastName = 'Smith';

-- 5. Удаление сотрудника Eve Davis
DELETE FROM Employees 
WHERE FirstName = 'Eve' AND LastName = 'Davis';

-- 6. Проверка изменений
SELECT * FROM Employees;