"""Задача 2: Фильтрация транзакций платежного шлюза.

Один генератор списка отбирает успешные транзакции с положительной
суммой и преобразует сумму в int.
"""

# Список транзакций, полученных от платежного шлюза
raw_transactions = [
    "SUCCESS: 100",
    "FAILED:50",
    "SUCCESS:-10",
    "SUCCESS:0",
    "SUCCESS:250",
    "ERROR:200",
]

# Один генератор списка:
# 1. Разбиваем каждую строку на статус и сумму (split с limit=1)
# 2. Оставляем только транзакции со статусом SUCCESS
# 3. Отбрасываем суммы <= 0
# 4. Приводим сумму к int
cleaned_transactions = [
    int(amount.strip())
    for status, amount in (tx.split(":", 1) for tx in raw_transactions)
    if status.strip() == "SUCCESS" and int(amount.strip()) > 0
]

print(f"Очищенные транзакции: {cleaned_transactions}")
