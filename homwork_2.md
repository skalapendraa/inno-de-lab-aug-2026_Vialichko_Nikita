# Домашнее задание 2: Проектирование и нормализация базы данных

## Part 1: Выбор сценария, цели и задачи

### Выбранный сценарий:
**Сценарий 4: Сервис потоковой передачи музыки**  
Система управляет информацией об артистах, альбомах, треках, пользователях и их плейлистах.

### Цели и задачи системы:
* **Цель:** Спроектировать нормализованную схему базы данных PostgreSQL для музыкального сервиса с поддержкой целостности данных.
* **Задачи:**
  1. Организовать хранение каталога исполнителей, их альбомов и треков.
  2. Реализовать хранение аккаунтов пользователей.
  3. Сделать функционал создания плейлистов и добавления в них песен.
  4. Настроить ограничения СУБД с помощью PRIMARY KEY, FOREIGN KEY, CHECK, UNIQUE и NOT NULL.

---

## Part 2: Проектирование Базы Данных и Документация

### Идентификация Сущностей и Атрибутов:
1. **Артисты (`Artists`):** Исполнители и музыкальные коллективы (`ArtistID`, `ArtistName`, `Country`).
2. **Альбомы (`Albums`):** Музыкальные альбомы артистов (`AlbumID`, `Title`, `ReleaseYear`, `ArtistID`).
3. **Песни (`Songs`):** Музыкальные треки (`SongID`, `Title`, `DurationSeconds`, `AlbumID`).
4. **Пользователи (`Users`):** Слушатели сервиса (`UserID`, `Username`, `Email`, `CreatedAt`).
5. **Плейлисты (`Playlists`):** Подборки треков пользователей (`PlaylistID`, `Title`, `IsPublic`, `UserID`).
6. **Песни в плейлистах (`PlaylistSongs`):** Связующая сущность для состава плейлистов (`PlaylistSongID`, `PlaylistID`, `SongID`, `AddedAt`).

---

### Проектирование Таблиц 

#### 1. Table Name: `Artists`
* **Description:** Хранит сведения о музыкальных исполнителях и группах.
* **Attributes:**
  * `ArtistID`: `INTEGER`, PK
  * `ArtistName`: `VARCHAR(150)`, NOT NULL
  * `Country`: `VARCHAR(100)`
* **Constraints:**
  * `PK_Artists`: `PRIMARY KEY (ArtistID)`
  * `UQ_ArtistName`: `UNIQUE (ArtistName)`

#### 2. Table Name: `Albums`
* **Description:** Хранит информацию об альбомах артистов.
* **Attributes:**
  * `AlbumID`: `INTEGER`, PK
  * `Title`: `VARCHAR(255)`, NOT NULL
  * `ReleaseYear`: `INTEGER`, NOT NULL
  * `ArtistID`: `INTEGER`, FK (REFERENCES `Artists`), NOT NULL
* **Constraints:**
  * `PK_Albums`: `PRIMARY KEY (AlbumID)`
  * `FK_Albums_Artists`: `FOREIGN KEY (ArtistID) REFERENCES Artists (ArtistID)`
  * `CHK_ReleaseYear`: `CHECK (ReleaseYear >= 1900 AND ReleaseYear <= 2100)`

#### 3. Table Name: `Songs`
* **Description:** Хранит данные о конкретных музыкальных композициях.
* **Attributes:**
  * `SongID`: `INTEGER`, PK
  * `Title`: `VARCHAR(255)`, NOT NULL
  * `DurationSeconds`: `INTEGER`, NOT NULL
  * `AlbumID`: `INTEGER`, FK (REFERENCES `Albums`), NOT NULL
* **Constraints:**
  * `PK_Songs`: `PRIMARY KEY (SongID)`
  * `FK_Songs_Albums`: `FOREIGN KEY (AlbumID) REFERENCES Albums (AlbumID)`
  * `CHK_Duration`: `CHECK (DurationSeconds > 0)`

#### 4. Table Name: `Users`
* **Description:** Хранит учетные записи зарегистрированных пользователей.
* **Attributes:**
  * `UserID`: `INTEGER`, PK
  * `Username`: `VARCHAR(100)`, NOT NULL
  * `Email`: `VARCHAR(255)`, NOT NULL
  * `CreatedAt`: `TIMESTAMP`, NOT NULL, DEFAULT `CURRENT_TIMESTAMP`
* **Constraints:**
  * `PK_Users`: `PRIMARY KEY (UserID)`
  * `UQ_Email`: `UNIQUE (Email)`
  * `UQ_Username`: `UNIQUE (Username)`

#### 5. Table Name: `Playlists`
* **Description:** Содержит заголовки и настройки пользовательских плейлистов.
* **Attributes:**
  * `PlaylistID`: `INTEGER`, PK
  * `Title`: `VARCHAR(255)`, NOT NULL
  * `IsPublic`: `BOOLEAN`, NOT NULL, DEFAULT `TRUE`
  * `UserID`: `INTEGER`, FK (REFERENCES `Users`), NOT NULL
* **Constraints:**
  * `PK_Playlists`: `PRIMARY KEY (PlaylistID)`
  * `FK_Playlists_Users`: `FOREIGN KEY (UserID) REFERENCES Users (UserID)`
  * `CHK_PlaylistTitle`: `CHECK (LENGTH(Title) > 0)`

#### 6. Table Name: `PlaylistSongs`
* **Description:** Таблица для реализации связи **«многие-ко-многим»** между плейлистами и треками.
* **Attributes:**
  * `PlaylistSongID`: `INTEGER`, PK
  * `PlaylistID`: `INTEGER`, FK (REFERENCES `Playlists`), NOT NULL
  * `SongID`: `INTEGER`, FK (REFERENCES `Songs`), NOT NULL
  * `AddedAt`: `TIMESTAMP`, NOT NULL, DEFAULT `CURRENT_TIMESTAMP`
* **Constraints:**
  * `PK_PlaylistSongs`: `PRIMARY KEY (PlaylistSongID)`
  * `FK_PlaylistSongs_Playlists`: `FOREIGN KEY (PlaylistID) REFERENCES Playlists (PlaylistID)`
  * `FK_PlaylistSongs_Songs`: `FOREIGN KEY (SongID) REFERENCES Songs (SongID)`
  * `UQ_Playlist_Song`: `UNIQUE (PlaylistID, SongID)`

---

### Анализ Нормализации (3NF):
* **1NF:** Все значения атрибутов неделимы (атомарны), отсутствуют дублирующиеся группы, у каждой таблицы задан суррогатный `PRIMARY KEY`.
* **2NF:** Таблицы находятся в 1NF, все неключевые столбцы полностью зависят от первичного ключа.
* **3NF:** Таблицы находятся во 2NF, отсутствуют транзитивные зависимости. Например, данные исполнителя находятся в `Artists` и не дублируются в `Songs` или `Playlists`.

---

### Описание Взаимосвязей:
* **`Artists` и `Albums` (Один-ко-Многим):** Один артист может выпустить множество альбомов, но каждый альбом относится только к одному исполнителю.
  * `Albums.ArtistID` является внешним ключом, ссылающимся на `Artists.ArtistID`.
* **`Albums` и `Songs` (Один-ко-Многим):** В один альбом входит несколько песен, но каждая песня принадлежит одному конкретному альбому.
  * `Songs.AlbumID` является внешним ключом, ссылающимся на `Albums.AlbumID`.
* **`Users` и `Playlists` (Один-ко-Многим):** Один пользователь может создать множество плейлистов, но у каждого плейлиста строго один владелец.
  * `Playlists.UserID` является внешним ключом, ссылающимся на `Users.UserID`.
* **`Playlists` и `Songs` (Многие-ко-Многим):** Один плейлист может содержать множество песен, и одна и та же песня может присутствовать во множестве плейлистов. Связь реализована через промежуточную таблицу .**`PlaylistSongs`**:
  * `PlaylistSongs.PlaylistID` -> `Playlists.PlaylistID`
  * `PlaylistSongs.SongID` -> `Songs.SongID`

---

## Part 3: ER-Диаграмма
![ER Diagram](./img/er_diagram.png)


