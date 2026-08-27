import random

secret_number = random.randint(1, 20)
attempts = 5
attempt_count = 1

print("Я загадал число от 1 до 20. У тебя 5 попыток!")

while attempts > 0:
    guess = int(input(f"Попытка {attempt_count}. Введите число: "))

    if guess == secret_number:
        print("Ты угадал! Отличная работа.")
        break

    # Действия происходят ровно один раз за итерацию цикла
    attempts -= 1
    attempt_count += 1

    if attempts > 0:
        hint = "мало" if guess < secret_number else "много"
        print(f"Слишком {hint}! Осталось попыток: {attempts}")

if attempts == 0:
    print(f"Попытки закончились. Я загадал число {secret_number}.")