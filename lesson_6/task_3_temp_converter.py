# Получаем температуру и преобразуем в вещественное число
celsius = float(input("Введите температуру в градусах Цельсия: "))

# Применяем формулу перевода в Фаренгейты
fahrenheit = celsius * 9 / 5 + 32

# Выводим результат (форматируем числа для удаления лишних нулей, если введено целое число)
celsius_formatted = int(celsius) if celsius.is_integer() else celsius
print(f"{celsius_formatted}°C это {fahrenheit}°F")