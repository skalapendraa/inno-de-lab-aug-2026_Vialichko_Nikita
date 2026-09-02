"""Модуль учёта успеваемости стажеров (Trainee LMS)."""


class Trainee:
    """Базовый класс стажера."""

    def __init__(
        self,
        name: str,
        surname: str,
        score: int = 0,
        passing_grade: int = 10,
    ) -> None:
        self.name: str = name
        self.surname: str = surname
        self.passing_grade: int = passing_grade
        self.score = score

    @property
    def score(self) -> int:
        return self.__score

    @score.setter
    def score(self, value: int) -> None:
        if type(value) is not int:
            raise ValueError(f"Expected value of type int, got {type(value)}")
        if value < 0:
            raise ValueError("The score shouldn't be less than 0!")
        self.__score = value

    def do_homework(self) -> None:
        """Increases score by 1"""
        self.score += 1

    def miss_homework(self) -> None:
        """Decreases score by 1"""
        self.score -= 1

    def visit_lecture(self) -> None:
        """Increases score by 1"""
        self.score += 1

    def miss_lecture(self) -> None:
        """Decreases score by 1"""
        self.score -= 1

    def is_passing(self) -> bool:
        return self.score >= self.passing_grade


class HardworkingTrainee(Trainee):
    """Стажер-трудоголик, получающий +2 балла за домашнее задание."""

    def do_homework(self) -> None:
        """Increases score by 2"""
        self.score += 2


class AuditTrainee(Trainee):
    """Вольнослушатель, который всегда успешно проходит курс."""

    def is_passing(self) -> bool:
        return True


class Cohort:
    """Учебная группа стажеров."""

    def __init__(
        self,
        title: str,
        trainees: list[Trainee] | None = None,
    ) -> None:
        self.title: str = title
        self.trainees: list[Trainee] = trainees if trainees is not None else []

    def add_trainee(self, trainee: Trainee) -> None:
        self.trainees.append(trainee)

    def conduct_lecture(self) -> None:
        for trainee in self.trainees:
            trainee.visit_lecture()

    def get_passing_students(self) -> list[Trainee]:
        return [trainee for trainee in self.trainees if trainee.is_passing()]


def run_tests() -> None:
    """Запуск тестовых сценариев из задания."""
    print("=== ПРОВЕРКА УСПЕВАЕМОСТИ СТАЖЕРА ===")

    # 1. Задание 1: Проверка работы Trainee
    trainee = Trainee(name="Иван", surname="Иванов", score=9, passing_grade=10)

    # 2. Выполнение домашнего задания
    trainee.do_homework()
    print(f"Баллы: {trainee.score}, Прошел курс: {trainee.is_passing()}")

    # 3. Пропуск лекции
    trainee.miss_lecture()
    print(f"Баллы: {trainee.score}, Прошел курс: {trainee.is_passing()}")

    # 4. Проверка валидации отрицательного балла
    try:
        trainee.score = -5
    except ValueError as e:
        print(f"Ошибка: {e}")

    print()

    # Задание 2: Создание учащихся разных типов и группы
    std_trainee = Trainee("Алексей", "Смирнов", score=8, passing_grade=10)
    hard_trainee = HardworkingTrainee(
        "Елена", "Петрова", score=8, passing_grade=10
    )
    audit_trainee = AuditTrainee("Дмитрий", "Сидоров", score=0, passing_grade=10)

    cohort = Cohort("Python Advanced")
    cohort.add_trainee(std_trainee)
    cohort.add_trainee(hard_trainee)
    cohort.add_trainee(audit_trainee)

    # Проведение лекции (+1 всем) и выполнение ДЗ трудоголиком (+2)
    cohort.conduct_lecture()
    hard_trainee.do_homework()

    passing_students = cohort.get_passing_students()

    print(f"=== УСПЕВАЕМОСТЬ ГРУППЫ '{cohort.title}' ===")
    for student in cohort.trainees:
        print(
            f"{student.name} {student.surname} | "
            f"Баллы: {student.score} | "
            f"Проходит: {student.is_passing()}"
        )

    print("\nУспешно зачислены на следующий модуль:")
    for student in passing_students:
        print(f"- {student.name} {student.surname}")


if __name__ == "__main__":
    run_tests()