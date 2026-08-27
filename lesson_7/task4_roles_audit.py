"""Задача 4: Аудит прав доступа и дедупликация.

Использует операции над множествами для дедупликации ролей, поиска
пересечений, разности и проверки членства за O(1).
"""

# Список ролей, переданный в запросе на авторизацию (содержит повторы)
requested_roles = [
    "guest", "developer", "guest", "admin", "developer", "guest",
]

# Набор обязательных ролей для выполнения административных функций
required_admin_roles = {"admin", "security_officer", "audit_manager"}

# 1. Преобразуем список запрошенных ролей во множество (дедупликация)
unique_requested_roles = set(requested_roles)

# 2. Находим общие административные роли (пересечение множеств)
common_admin_roles = unique_requested_roles & required_admin_roles

# 3. Вычисляем недостающие административные роли (разность множеств)
missing_admin_roles = required_admin_roles - unique_requested_roles

# 4. Проверяем наличие "security_officer" через оператор in, O(1)
is_security_officer_present = "security_officer" in unique_requested_roles

print(f"Уникальные запрошенные роли: {unique_requested_roles}")
print(f"Общие административные роли: {common_admin_roles}")
print(f"Недостающие административные роли: {missing_admin_roles}")
print(
    "Наличие роли security_officer в запросе: "
    f"{is_security_officer_present}"
)
