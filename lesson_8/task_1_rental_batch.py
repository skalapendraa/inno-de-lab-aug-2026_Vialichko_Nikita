"""Модуль для расчёта стоимости оптовой аренды фильмов."""

MAX_RENTAL_BATCH_LIMIT = 150.0


def calculate_rental_batch(
    quantity: int, rental_rate: float, discount: float = 0.0
) -> tuple[float, bool]:
    """Рассчитывает стоимость партии аренды фильмов с учётом скидки.

    Args:
        quantity: Количество фильмов в партии.
        rental_rate: Базовая стоимость аренды за единицу.
        discount: Размер скидки (от 0.0 до 1.0).

    Returns:
        Кортеж из итоговой суммы (округленной до 2 знаков) и флага
        превышения лимита MAX_RENTAL_BATCH_LIMIT.
    """
    final_sum = round(quantity * rental_rate * (1 - discount), 2)
    is_limit_exceeded = final_sum > MAX_RENTAL_BATCH_LIMIT
    return final_sum, is_limit_exceeded


if __name__ == "__main__":
    print("=== ОТЧЕТ ПО ПАРТИЯМ АРЕНДЫ ===")

    # Academy Dinosaur: 30 дисков по 2.99$, без скидки (позиционные аргументы)
    sum1, exceeded1 = calculate_rental_batch(30, 2.99, 0.0)
    print(f"Партия 1 (Academy Dinosaur): Сумма {sum1}$. Превышение лимита: {exceeded1}")

    # Affair Prejudice: 40 дисков по 4.99$, скидка 10% (позиционные аргументы)
    sum2, exceeded2 = calculate_rental_batch(40, 4.99, 0.10)
    print(f"Партия 2 (Affair Prejudice): Сумма {sum2}$. Превышение лимита: {exceeded2}")

    # Agent Truman: 10 дисков по 1.99$, без скидки (именованные аргументы)
    sum3, exceeded3 = calculate_rental_batch(
        quantity=10, rental_rate=1.99, discount=0.0
    )
    print(f"Партия 3 (Agent Truman): Сумма {sum3}$. Превышение лимита: {exceeded3}")

    # African Egg: 50 дисков по 3.50$, скидка 20% (именованные аргументы)
    sum4, exceeded4 = calculate_rental_batch(
        quantity=50, rental_rate=3.50, discount=0.20
    )
    print(f"Партия 4 (African Egg): Сумма {sum4}$. Превышение лимита: {exceeded4}")