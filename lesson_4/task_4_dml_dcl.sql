-- 1. Увеличение Salary сотрудников в отделе 'HR' на 10%
UPDATE Employees 
SET Salary = Salary * 1.10 
WHERE Department = 'HR';

-- 2. Перевод сотрудников с Salary > 70000.00 в 'Senior IT'
UPDATE Employees 
SET Department = 'Senior IT' 
WHERE Salary > 70000.00;

-- 3. Удаление сотрудников, не назначенных ни на один проект
DELETE FROM Employees e
WHERE NOT EXISTS (
    SELECT 1 
    FROM EmployeeProjects ep 
    WHERE ep.EmployeeID = e.EmployeeID
);

-- 4. Транзакция: новый проект и назначение двух сотрудников
BEGIN;

INSERT INTO Projects (ProjectName, Budget, StartDate, EndDate)
VALUES ('Cloud Migration', 120000.00, '2023-09-01', '2023-12-31');

-- Назначение сотрудников (используем currval для автосгенерированного ProjectID)
INSERT INTO EmployeeProjects (EmployeeID, ProjectID, HoursWorked)
VALUES 
    (1, currval('projects_projectid_seq'), 40),
    (2, currval('projects_projectid_seq'), 60);

COMMIT;