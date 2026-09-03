"""Модуль для мониторинга производительности и сортировки отчётов."""

import time
from functools import wraps
from typing import Any, Callable

PERFORMANCE_LOG_PREFIX = "[PERF_LOG]"
TIME_DECIMALS = 8


def performance_logger(func: Callable[..., Any]) -> Callable[..., Any]:
    """Декоратор для замера времени выполнения функции.

    Args:
        func: Оборачиваемая функция.

    Returns:
        Обёртку, которая выполняет func, логирует время выполнения
        и возвращает результат func без изменений.
    """

    @wraps(func)
    def wrapper(*args: Any, **kwargs: Any) -> Any:
        start_time = time.perf_counter()
        result = func(*args, **kwargs)
        exec_time = round(time.perf_counter() - start_time, TIME_DECIMALS)
        print(f"{PERFORMANCE_LOG_PREFIX} Функция '{func.__name__}' выполнена за {exec_time} сек.")
        return result

    return wrapper


@performance_logger
def get_sorted_report(
    report_data: list[dict[str, str | float]],
) -> list[dict[str, str | float]]:
    """Сортирует список отчётов по выручке (total_sales) по убыванию.

    Args:
        report_data: Список словарей с данными по категориям и выручке.

    Returns:
        Отсортированный список словарей.
    """
    return sorted(report_data, key=lambda item: item["total_sales"], reverse=True)


def print_top_categories(sorted_report: list[dict[str, str | float]]) -> None:
    """Печатает отсортированный отчёт в виде нумерованного списка."""
    print("Топ категорий по выручке:")
    for index, item in enumerate(sorted_report, start=1):
        print(f"{index}. {item['category']}: {item['total_sales']}")


if __name__ == "__main__":
    print("=== ТЕСТИРОВАНИЕ ПРОИЗВОДИТЕЛЬНОСТИ ===")

    # Набор 1: стандартный
    dataset_1 = [
        {"category": "Action", "total_sales": 4311.85},
        {"category": "Animation", "total_sales": 4656.30},
        {"category": "Children", "total_sales": 3655.55},
    ]
    print("\n--- ТЕСТ 1 ---")
    print_top_categories(get_sorted_report(dataset_1))

    # Набор 2: с одинаковой выручкой
    dataset_2 = [
        {"category": "Classics", "total_sales": 1200.10},
        {"category": "Comedy", "total_sales": 4000.00},
        {"category": "Documentary", "total_sales": 4000.00},
    ]
    print("\n--- ТЕСТ 2 ---")
    print_top_categories(get_sorted_report(dataset_2))

    # Набор 3: единичный элемент
    dataset_3 = [{"category": "Drama", "total_sales": 500.00}]
    print("\n--- ТЕСТ 3 ---")
    print_top_categories(get_sorted_report(dataset_3))