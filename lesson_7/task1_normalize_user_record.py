"""Задача 1: Нормализация и сборка записи пользователя.

Разбирает неочищенную строку с данными пользователя, приводит каждое
поле к нужному формату и собирает результат в единую строку.
"""

# Исходная необработанная строка из источника данных
raw_user_record = " 10827 ; aLeXanDer_vLaDimiRov ; mInSk ; ACTIVE "

# 1. Разбиваем строку по разделителю ";"
raw_elements = raw_user_record.split(";")

# 2. Очищаем элементы от внешних пробелов
cleaned_elements = [item.strip() for item in raw_elements]

# 3. Применяем префикс "UID-" к идентификатору с помощью f-строки
uid = f"UID-{cleaned_elements[0]}"

# 4. Заменяем "_" на пробел и приводим слова к заглавному регистру
name = cleaned_elements[1].replace("_", " ").title()

# 5. Переводим название города в верхний регистр
city = cleaned_elements[2].upper()

# 6. Переводим статус в нижний регистр
status = cleaned_elements[3].lower()

# 7. Объединяем элементы в строку с разделителем " | "
normalized_record = " | ".join([uid, name, city, status])

print(f"Нормализованная запись: {normalized_record}")
