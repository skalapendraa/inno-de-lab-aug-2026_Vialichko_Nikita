-- 1. Создание функции расчёта годового бонуса (10% от Salary)
CREATE OR REPLACE FUNCTION CalculateAnnualBonus(
    employee_id INT, 
    Salary DECIMAL
)
RETURNS DECIMAL AS $$
BEGIN
    RETURN Salary * 0.10;
END;
$$ LANGUAGE plpgsql;

-- 2. Использование функции в SELECT
SELECT 
    EmployeeID, 
    FirstName, 
    LastName, 
    Salary, 
    CalculateAnnualBonus(EmployeeID, Salary) AS AnnualBonus
FROM Employees;

-- 3. Создание представления IT_Department_View 
CREATE OR REPLACE VIEW IT_Department_View AS
SELECT 
    EmployeeID, 
    FirstName, 
    LastName, 
    Salary
FROM Employees
WHERE Department = 'IT';

-- 4. Выборка из представления
SELECT * FROM IT_Department_View;