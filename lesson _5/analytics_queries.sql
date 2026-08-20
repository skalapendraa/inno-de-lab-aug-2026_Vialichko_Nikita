
-- Description: Бизнес-запросы к аналитической модели DWH


-- Запрос 1: Топ артистов по суммарному времени воспроизведения за отчетный период
-- Бизнес-цель: Определение наиболее востребованных исполнителей для выплаты роялти
SELECT 
    s.artist_name,
    COUNT(f.stream_id) AS total_streams,
    COUNT(DISTINCT f.user_key) AS unique_listeners,
    ROUND(SUM(f.listen_duration_seconds)::NUMERIC / 60, 2) AS total_minutes_listened
FROM fact_streams f
JOIN dim_songs s ON f.song_key = s.song_key
JOIN dim_date d ON f.date_key = d.date_key
WHERE d.year = 2026 AND d.month = 8
GROUP BY s.artist_name
ORDER BY total_minutes_listened DESC;

-- Запрос 2: Метрики активности и полного прослушивания по типам подписок
-- Бизнес-цель: Сравнение вовлеченности (Premium/Family) и бесплатной (Free) аудиторий
SELECT 
    u.subscription_type,
    COUNT(DISTINCT u.user_key) AS active_users,
    COUNT(f.stream_id) AS total_streams,
    ROUND(COUNT(f.stream_id)::NUMERIC / NULLIF(COUNT(DISTINCT u.user_key), 0), 1) AS avg_streams_per_user,
    ROUND(AVG(CASE WHEN f.is_completed THEN 1 ELSE 0 END) * 100, 2) AS completion_rate_pct
FROM fact_streams f
JOIN dim_users u ON f.user_key = u.user_key
GROUP BY u.subscription_type
ORDER BY avg_streams_per_user DESC;

-- Запрос 3: Процент ранних пропусков (Skip Rate) по жанрам
-- Бизнес-цель: Поиск жанров с высоким уровнем оттока внимания (скип в первые 30 секунд)
SELECT 
    s.genre,
    COUNT(f.stream_id) AS total_streams,
    COUNT(CASE WHEN f.is_skipped THEN 1 END) AS skipped_streams,
    ROUND(COUNT(CASE WHEN f.is_skipped THEN 1 END)::NUMERIC / COUNT(f.stream_id) * 100, 2) AS skip_rate_pct
FROM fact_streams f
JOIN dim_songs s ON f.song_key = s.song_key
GROUP BY s.genre
ORDER BY skip_rate_pct DESC;

-- Запрос 4: Распределение объема стримов Плейлисты /Прямой поиск
-- Бизнес-цель: Оценка влияния рекомендательных алгоритмов и плейлистов на общий трафик
SELECT 
    CASE 
        WHEN p.playlist_key = -1 THEN 'Прямой поиск / Страница артиста'
        ELSE 'Воспроизведение из плейлиста'
    END AS stream_source,
    COUNT(f.stream_id) AS total_streams,
    ROUND(COUNT(f.stream_id)::NUMERIC / (SELECT COUNT(*) FROM fact_streams) * 100, 2) AS share_pct
FROM fact_streams f
JOIN dim_playlists p ON f.playlist_key = p.playlist_key
GROUP BY 
    CASE 
        WHEN p.playlist_key = -1 THEN 'Прямой поиск / Страница артиста'
        ELSE 'Воспроизведение из плейлиста'
    END;

-- Запрос 5: Динамика нагрузки и уникальных слушателей по дням недели
-- Бизнес-цель: Выявление пиковых дней для планирования маркетинговых активов и релизов
SELECT 
    d.day_name,
    d.is_weekend,
    COUNT(f.stream_id) AS total_streams,
    COUNT(DISTINCT f.user_key) AS unique_active_users,
    ROUND(AVG(f.listen_duration_seconds), 1) AS avg_stream_duration_sec
FROM fact_streams f
JOIN dim_date d ON f.date_key = d.date_key
GROUP BY d.day_name, d.is_weekend, d.day_of_week
ORDER BY d.day_of_week;