"""Задача 5*: Сборщик метрик инфраструктуры.

Распаковывает кортежи телеметрии, отфильтровывает офлайн-узлы за один
проход и агрегирует метрики через len(), sum() и max().
"""

import pprint

# Поток данных телеметрии от серверов кластера
system_telemetry = [
    ("srv_01", 12.5, 64, "online"),
    ("srv_02", 85.0, 92, "online"),
    ("srv_03", 0.0, 0, "offline"),
    ("srv_04", 45.2, 78, "online"),
    ("srv_05", 95.1, 99, "online"),
]

# 1-3. Распаковка кортежей и фильтрация активных серверов за один
#      проход по исходному списку (без обращения по индексам)
active_servers = [
    (node_name, cpu_load, ram_usage)
    for node_name, cpu_load, ram_usage, status in system_telemetry
    if status == "online"
]
active_nodes = [node_name for node_name, cpu_load, ram_usage in active_servers]
cpu_loads = [cpu_load for node_name, cpu_load, ram_usage in active_servers]
ram_usages = [ram_usage for node_name, cpu_load, ram_usage in active_servers]

# 4. Агрегация метрик через встроенные функции len(), sum(), max()
active_nodes_count = len(active_nodes)
average_cpu = round(sum(cpu_loads) / active_nodes_count, 2)
max_ram = max(ram_usages)

# 5. Формируем итоговый отчёт
telemetry_report = {
    "active_nodes_count": active_nodes_count,
    "metrics": {
        "average_cpu": average_cpu,
        "max_ram": max_ram,
    },
}

print(f"Активные узлы в сети: {active_nodes}")
print("Итоговый отчет телеметрии:")
pprint.pprint(telemetry_report, sort_dicts=False)
