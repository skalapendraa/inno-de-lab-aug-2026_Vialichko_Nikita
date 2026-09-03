-- Description: DDL таблицы хранилища данных и DML наполнение тестовыми данными

-- 1. DROP EXISTING TABLES (порядок учитывает зависимости FK, поэтому CASCADE не требуется:
--    fact_streams удаляется первой, до своих родительских dimension-таблиц)
DROP TABLE IF EXISTS fact_streams;
DROP TABLE IF EXISTS dim_playlists;
DROP TABLE IF EXISTS dim_date;
DROP TABLE IF EXISTS dim_songs;
DROP TABLE IF EXISTS dim_users;

-- 2. DDL: DIMENSION TABLES & FACT TABLE

-- Измерение пользователей (Информация о слушателях)
CREATE TABLE dim_users (
    user_key INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id INT NOT NULL UNIQUE,
    username VARCHAR(100) NOT NULL,
    age INT CHECK (age BETWEEN 0 AND 120),
    country VARCHAR(100),
    subscription_type VARCHAR(50) DEFAULT 'Free'
);

-- Измерение треков и исполнителей 
CREATE TABLE dim_songs (
    song_key INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    song_id INT NOT NULL UNIQUE,
    song_title VARCHAR(255) NOT NULL,
    artist_name VARCHAR(255) NOT NULL,
    album_title VARCHAR(255),
    genre VARCHAR(100) NOT NULL,
    duration_seconds INT CHECK (duration_seconds > 0),
    release_year INT CHECK (release_year BETWEEN 1900 AND 2100)
);

-- Календарное измерение 
CREATE TABLE dim_date (
    date_key INT PRIMARY KEY,
    full_date DATE NOT NULL,
    day_of_week INT NOT NULL CHECK (day_of_week BETWEEN 1 AND 7),
    day_name VARCHAR(20) NOT NULL,
    month INT NOT NULL CHECK (month BETWEEN 1 AND 12),
    month_name VARCHAR(20) NOT NULL,
    quarter INT NOT NULL CHECK (quarter BETWEEN 1 AND 4),
    year INT NOT NULL,
    is_weekend BOOLEAN NOT NULL
);

-- Измерение плейлистов
CREATE TABLE dim_playlists (
    playlist_key INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    playlist_id INT UNIQUE,
    playlist_title VARCHAR(255) NOT NULL,
    is_public BOOLEAN DEFAULT TRUE
);

-- Таблица фактов прослушивания треков ( 1 строка = 1 событие)
-- play_source и playlist_key намеренно разделены: playlist_key — это чистая FK-связь
-- ("из какого плейлиста", NULL = плейлиста не было), play_source — это то, как
-- пользователь запустил трек ("через плейлист / прямым поиском / со страницы артиста").
CREATE TABLE fact_streams (
    stream_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_key INT NOT NULL,
    song_key INT NOT NULL,
    date_key INT NOT NULL,
    playlist_key INT,
    play_source VARCHAR(20) NOT NULL DEFAULT 'playlist'
        CHECK (play_source IN ('playlist', 'direct_search', 'artist_page')),
    stream_timestamp TIMESTAMP NOT NULL,
    listen_duration_seconds INT NOT NULL CHECK (listen_duration_seconds >= 0),
    is_skipped BOOLEAN NOT NULL DEFAULT FALSE,
    is_completed BOOLEAN NOT NULL DEFAULT FALSE,
    
    FOREIGN KEY (user_key) REFERENCES dim_users(user_key) ON DELETE RESTRICT,
    FOREIGN KEY (song_key) REFERENCES dim_songs(song_key) ON DELETE RESTRICT,
    FOREIGN KEY (date_key) REFERENCES dim_date(date_key) ON DELETE RESTRICT,
    FOREIGN KEY (playlist_key) REFERENCES dim_playlists(playlist_key) ON DELETE RESTRICT,

    -- Согласованность двух полей: playlist_key IS NULL обязан сопровождаться
    -- "не-плейлистовым" play_source, и наоборот
    CONSTRAINT chk_play_source_playlist_consistency CHECK (
        (play_source = 'playlist' AND playlist_key IS NOT NULL) OR
        (play_source IN ('direct_search', 'artist_page') AND playlist_key IS NULL)
    )
);

-- 3. DML: TEST DATA INSERTION

INSERT INTO dim_users (user_id, username, age, country, subscription_type) VALUES
(101, 'alex_coder', 24, 'Belarus', 'Premium'),
(102, 'maria_music', 19, 'Belarus', 'Free'),
(103, 'john_doe', 31, 'Poland', 'Family'),
(104, 'kate_rock', 27, 'Lithuania', 'Free');

INSERT INTO dim_songs (song_id, song_title, artist_name, album_title, genre, duration_seconds, release_year) VALUES
(501, 'Numb', 'Linkin Park', 'Meteora', 'Rock', 187, 2003),
(502, 'In the End', 'Linkin Park', 'Hybrid Theory', 'Rock', 216, 2000),
(503, 'Blinding Lights', 'The Weeknd', 'After Hours', 'Pop', 200, 2020),
(504, 'Starboy', 'The Weeknd', 'Starboy', 'Pop', 230, 2016),
(505, 'Stoberry', 'Kipras', 'Summer Vibes', 'Electronic', 180, 2025);

INSERT INTO dim_date (date_key, full_date, day_of_week, day_name, month, month_name, quarter, year, is_weekend) VALUES
(20260815, '2026-08-15', 6, 'Saturday', 8, 'August', 3, 2026, TRUE),
(20260816, '2026-08-16', 7, 'Sunday', 8, 'August', 3, 2026, TRUE),
(20260817, '2026-08-17', 1, 'Monday', 8, 'August', 3, 2026, FALSE),
(20260818, '2026-08-18', 2, 'Tuesday', 8, 'August', 3, 2026, FALSE),
(20260819, '2026-08-19', 3, 'Wednesday', 8, 'August', 3, 2026, FALSE);

INSERT INTO dim_playlists (playlist_id, playlist_title, is_public) VALUES
(701, 'Rock Classics', TRUE),
(702, 'Top 50 Global 2026', TRUE);

INSERT INTO fact_streams (user_key, song_key, date_key, playlist_key, play_source, stream_timestamp, listen_duration_seconds, is_skipped, is_completed) VALUES
(1, 1, 20260815, 1, 'playlist', '2026-08-15 09:12:00', 187, FALSE, TRUE),
(1, 2, 20260815, 1, 'playlist', '2026-08-15 09:15:30', 216, FALSE, TRUE),
(1, 3, 20260816, NULL, 'direct_search', '2026-08-16 21:03:10', 20, TRUE, FALSE),
(2, 3, 20260817, 2, 'playlist', '2026-08-17 08:47:00', 200, FALSE, TRUE),
(2, 4, 20260817, 2, 'playlist', '2026-08-17 08:50:25', 15, TRUE, FALSE),
(3, 1, 20260818, NULL, 'artist_page', '2026-08-18 18:30:00', 187, FALSE, TRUE),
(3, 5, 20260818, NULL, 'direct_search', '2026-08-18 18:33:10', 180, FALSE, TRUE),
(4, 3, 20260819, 2, 'playlist', '2026-08-19 13:05:00', 200, FALSE, TRUE),
(4, 5, 20260819, NULL, 'direct_search', '2026-08-19 13:08:45', 12, TRUE, FALSE);