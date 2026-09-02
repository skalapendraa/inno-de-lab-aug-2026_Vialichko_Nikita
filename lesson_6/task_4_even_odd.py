# Запрашиваем целое число
number = int(input("Введите целое число: "))

# Проверяем остаток от деления на 2
result = "чётное" if number % 2 == 0 else "нечётное"

print(f"Число {number} - {result}.")