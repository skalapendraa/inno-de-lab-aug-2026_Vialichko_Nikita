import random

# Генерируем случайное число от 1 до 20
secret_number = random.randint(1, 20)
attempts = 5
attempt_count = 1

print("Я загадал число от 1 до 20. У тебя 5 попыток!")

# Запускаем цикл с условием наличия попыток
while attempts > 0:
    guess = int(input(f"Попытка {attempt_count}. Введите число: "))

    if guess == secret_number:
        print("Ты угадал! Отличная работа.")
        break  # Досрочный выход из цикла при победе
    elif guess < secret_number:
        attempts -= 1
        if attempts > 0:
            print(f"Слишком мало! Осталось попыток: {attempts}")
    else:
        attempts -= 1
        if attempts > 0:
            print(f"Слишком много! Осталось попыток: {attempts}")

    attempt_count += 1

# Сообщение о проигрыше, если попытки исчерпаны
if attempts == 0:
    print(f"Попытки закончились. Я загадал число {secret_number}.")