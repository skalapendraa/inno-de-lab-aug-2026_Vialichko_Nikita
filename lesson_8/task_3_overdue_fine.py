"""Модуль для безопасного расчёта штрафов и индекса возврата."""

from typing import Any

DEFAULT_RETURN_INDEX_BASE = 10.0


def calculate_overdue_fine(
    days_overdue: Any, fine_rate: Any, movie_title: Any = ""
) -> tuple[float, float] | None:
    """Рассчитывает штраф за просрочку и индекс возврата.

    Args:
        days_overdue: Дни просрочки (сырые данные, могут быть любого типа).
        fine_rate: Дневная ставка штрафа (сырые данные, могут быть любого типа).
        movie_title: Название фильма для сообщений об ошибках (опционально).

    Returns:
        Кортеж (total_fine, return_index) при успешном расчёте, либо None,
        если данные нельзя привести к числу (TypeError, ValueError) или
        дни просрочки равны нулю (ZeroDivisionError).
    """
    try:
        days = float(days_overdue)
        rate = float(fine_rate)

        total_fine = days * rate
        return_index = DEFAULT_RETURN_INDEX_BASE / days

        return round(total_fine, 2), round(return_index, 2)

    except TypeError as e:
        print(f"[ОШИБКА ТИПА] Некорректный тип данных для '{movie_title}': {e}")
        return None
    except ValueError as e:
        print(f"[ОШИБКА ЗНАЧЕНИЯ] Невозможно преобразовать дни в число для '{movie_title}': {e}")
        return None
    except ZeroDivisionError as e:
        print(f"[ОШИБКА ДЕЛЕНИЯ НА НОЛЬ] Возврат без просрочки для '{movie_title}': {e}")
        return None
    finally:
        print("--- Проверка транзакции возврата завершена ---")


if __name__ == "__main__":
    print("=== ПРОВЕРКА ВОЗВРАТОВ ===")

    result = calculate_overdue_fine(5, 1.50, "Matrix")
    if result is not None:
        fine, index = result
        print(f"Фильм: 'Matrix' | Итоговый штраф: {fine}$ | Индекс: {index}")

    calculate_overdue_fine("пять", 2.0, "Inception")

    calculate_overdue_fine(0, 2.5, "Avatar")

    calculate_overdue_fine([3,], 3.0, "Interstellar")