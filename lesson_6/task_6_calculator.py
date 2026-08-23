# Запрашиваем два числа и преобразуем их во float для поддержки дробных вычислений
num1 = float(input("Введите первое число: "))
num2 = float(input("Введите второе число: "))

# Запрашиваем оператор
operator = input("Выберите оператор (+, -, *, /): ")

# Выполняем расчет в зависимости от выбранного оператора
if operator == '+':
    result = num1 + num2
elif operator == '-':
    result = num1 - num2
elif operator == '*':
    result = num1 * num2
elif operator == '/':
    if num2 != 0:
        result = num1 / num2
    else:
        result = "Ошибка: деление на ноль!"
else:
    result = "Ошибка: неверный оператор!"

# Выводим результат
if isinstance(result, float):
    print(f"Результат: {num1} {operator} {num2} = {result}")
else:
    print(result)