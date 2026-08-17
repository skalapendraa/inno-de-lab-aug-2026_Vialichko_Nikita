-- 1. Проекты, где Bob Johnson работал более 150 часов
SELECT p.ProjectName
FROM Projects p
JOIN EmployeeProjects ep ON p.ProjectID = ep.ProjectID
JOIN Employees e ON e.EmployeeID = ep.EmployeeID
WHERE e.FirstName = 'Bob' 
  AND e.LastName = 'Johnson' 
  AND ep.HoursWorked > 150;

-- 2. Увеличение бюджета проектов на 10%, если назначен сотрудник из 'IT' / 'Senior IT'
UPDATE Projects
SET Budget = Budget * 1.10
WHERE ProjectID IN (
    SELECT DISTINCT ep.ProjectID
    FROM EmployeeProjects ep
    JOIN Employees e ON ep.EmployeeID = e.EmployeeID
    WHERE e.Department LIKE '%IT%'
);

-- 3. Установка EndDate на 1 год позже StartDate, если EndDate IS NULL
UPDATE Projects
SET EndDate = StartDate + INTERVAL '1 year'
WHERE EndDate IS NULL;

-- 4. Транзакция с RETURNING: вставка нового сотрудника и привязка к 'Website Redesign'
BEGIN;

WITH new_employee AS (
    INSERT INTO Employees (FirstName, LastName, Department, Salary, Email)
    VALUES ('Alex', 'Mercer', 'IT', 72000.00, 'alex.mercer@company.com')
    RETURNING EmployeeID
)
INSERT INTO EmployeeProjects (EmployeeID, ProjectID, HoursWorked)
SELECT 
    ne.EmployeeID,
    p.ProjectID, 
    80
FROM new_employee ne
CROSS JOIN Projects p
WHERE p.ProjectName = 'Website Redesign';

COMMIT;