-- 1. Создание таблицы Departments
CREATE TABLE Departments (
    DepartmentID SERIAL PRIMARY KEY,
    DepartmentName VARCHAR(50) UNIQUE NOT NULL,
    Location VARCHAR(50)
);

-- 2. Добавление столбца Email в Employees
ALTER TABLE Employees 
ADD COLUMN Email VARCHAR(100);

-- 3. Заполнение столбца Email уникальными значениями
UPDATE Employees 
SET Email = LOWER(FirstName) || '.' || LOWER(LastName) || '@company.com';

-- 4. Добавление ограничения UNIQUE на Email
ALTER TABLE Employees 
ADD CONSTRAINT unique_employee_email UNIQUE (Email);

-- 5. Переименование столбца Location в OfficeLocation
ALTER TABLE Departments 
RENAME COLUMN Location TO OfficeLocation;