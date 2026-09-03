"""Задача 3: Безопасный парсинг конфигурации API.

Извлекает параметры соединения из вложенного словаря, безопасно
подставляет значение по умолчанию для ssl_mode и обновляет словарь.
"""

# Конфигурационный словарь, полученный от сервиса инициализации
db_config = {
    "connection": {
        "host": "production-db.internal",
        "port": 5432,
        "user": "postgres",
    }
}

# 1. Извлекаем host и port из вложенного словаря connection
connection_info = db_config.get("connection", {})
host = connection_info.get("host")
port = connection_info.get("port")

# 2. Безопасно достаём ssl_mode без try-except (дефолт "verify-full")
ssl_mode = db_config.get("ssl_settings", {}).get("ssl_mode", "verify-full")

# 3. Изменяем значение пользователя на "admin"
connection_info["user"] = "admin"

# 4. Добавляем новый параметр max_connections в connection
connection_info["max_connections"] = 100

# 5. Выводим результат, итерируя по .items()
print(f"SSL Mode: {ssl_mode}")
print("Параметры соединения:")
for key, value in connection_info.items():
    print(f"* {key}: {value}")
