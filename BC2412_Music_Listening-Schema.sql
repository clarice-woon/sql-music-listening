-- BC2412 Individual Assignment: Music Listening Analytics
-- Revised teaching database (clean, typed, and fully simulated)
-- Target: MySQL 8.0+
--
-- Design note:
-- This version intentionally contains no data-quality defects. Values use suitable
-- data types, identifiers are consistent, and foreign keys are valid. A few valid
-- unmatched rows are included to support outer-join questions:
--   * listener 13 has no listening events;
--   * platform 6 has no listening events;
--   * track 114 has no listening events.

DROP DATABASE IF EXISTS `bc2412_music`;
CREATE DATABASE `bc2412_music`
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_0900_ai_ci;
USE `bc2412_music`;

CREATE TABLE `listeners` (
  `listener_id` INT PRIMARY KEY,
  `listener_name` VARCHAR(80) NOT NULL,
  `age` TINYINT UNSIGNED NOT NULL,
  `gender` VARCHAR(20) NOT NULL,
  `subscription_tier` VARCHAR(20) NOT NULL,
  `home_region` VARCHAR(40) NOT NULL,
  `join_date` DATE NOT NULL,
  `preferred_genre` VARCHAR(30) NOT NULL,
  CONSTRAINT `chk_listener_age` CHECK (`age` BETWEEN 16 AND 100),
  CONSTRAINT `chk_subscription_tier`
    CHECK (`subscription_tier` IN ('Free', 'Premium', 'Student', 'Family'))
) ENGINE=InnoDB;

CREATE TABLE `platforms` (
  `platform_id` INT PRIMARY KEY,
  `platform_name` VARCHAR(60) NOT NULL UNIQUE,
  `platform_category` VARCHAR(30) NOT NULL,
  `monthly_price` DECIMAL(6,2) NOT NULL,
  `headquarters` VARCHAR(40) NOT NULL,
  CONSTRAINT `chk_monthly_price` CHECK (`monthly_price` >= 0)
) ENGINE=InnoDB;

CREATE TABLE `artists` (
  `artist_id` INT PRIMARY KEY,
  `artist_name` VARCHAR(80) NOT NULL UNIQUE,
  `home_country` VARCHAR(40) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE `tracks` (
  `track_id` INT PRIMARY KEY,
  `track_name` VARCHAR(100) NOT NULL,
  `artist_id` INT NOT NULL,
  `genre` VARCHAR(30) NOT NULL,
  `release_year` SMALLINT UNSIGNED NOT NULL,
  `duration_seconds` SMALLINT UNSIGNED NOT NULL,
  `popularity_score` TINYINT UNSIGNED NOT NULL,
  CONSTRAINT `fk_tracks_artist`
    FOREIGN KEY (`artist_id`) REFERENCES `artists` (`artist_id`),
  CONSTRAINT `chk_release_year` CHECK (`release_year` BETWEEN 1900 AND 2026),
  CONSTRAINT `chk_duration_seconds` CHECK (`duration_seconds` > 0),
  CONSTRAINT `chk_popularity_score` CHECK (`popularity_score` BETWEEN 0 AND 100)
) ENGINE=InnoDB;

CREATE TABLE `listening_events` (
  `event_id` INT PRIMARY KEY,
  `listener_id` INT NOT NULL,
  `track_id` INT NOT NULL,
  `platform_id` INT NOT NULL,
  `listened_at` DATETIME NOT NULL,
  `minutes_played` DECIMAL(6,2) NOT NULL,
  `completed` BOOLEAN NOT NULL,
  CONSTRAINT `fk_events_listener`
    FOREIGN KEY (`listener_id`) REFERENCES `listeners` (`listener_id`),
  CONSTRAINT `fk_events_track`
    FOREIGN KEY (`track_id`) REFERENCES `tracks` (`track_id`),
  CONSTRAINT `fk_events_platform`
    FOREIGN KEY (`platform_id`) REFERENCES `platforms` (`platform_id`),
  CONSTRAINT `chk_minutes_played` CHECK (`minutes_played` > 0)
) ENGINE=InnoDB;

CREATE INDEX `idx_events_listener` ON `listening_events` (`listener_id`);
CREATE INDEX `idx_events_track` ON `listening_events` (`track_id`);
CREATE INDEX `idx_events_platform` ON `listening_events` (`platform_id`);
CREATE INDEX `idx_events_listened_at` ON `listening_events` (`listened_at`);

INSERT INTO `listeners`
  (`listener_id`, `listener_name`, `age`, `gender`, `subscription_tier`,
   `home_region`, `join_date`, `preferred_genre`)
VALUES
  (1,  'Ava Lim',        22, 'Female', 'Premium', 'Singapore', '2025-01-15', 'Pop'),
  (2,  'Ben Tan',        28, 'Male',   'Free',    'Singapore', '2024-11-03', 'Rock'),
  (3,  'Chloe Ng',       35, 'Female', 'Student', 'Malaysia',  '2025-03-20', 'Jazz'),
  (4,  'Daniel Lee',     41, 'Male',   'Premium', 'Singapore', '2023-07-11', 'Classical'),
  (5,  'Elena Garcia',   31, 'Female', 'Family',  'Spain',     '2024-05-09', 'Latin'),
  (6,  'Farid Khan',     26, 'Male',   'Premium', 'Malaysia',  '2025-06-01', 'Hip-Hop'),
  (7,  'Grace Wong',     24, 'Female', 'Free',    'Singapore', '2026-01-12', 'K-Pop'),
  (8,  'Hugo Martin',    46, 'Male',   'Family',  'France',    '2022-09-18', 'Electronic'),
  (9,  'Iris Chen',      29, 'Female', 'Student', 'Taiwan',    '2024-12-05', 'Pop'),
  (10, 'Jamal Brown',    38, 'Male',   'Premium', 'USA',       '2023-10-22', 'R&B'),
  (11, 'Keiko Sato',     33, 'Female', 'Free',    'Japan',     '2025-08-14', 'Classical'),
  (12, 'Liam O''Connor', 27, 'Male',   'Premium', 'Ireland',   '2026-02-02', 'Rock'),
  (13, 'Maya Patel',     30, 'Female', 'Free',    'India',     '2026-03-01', 'Indie');

INSERT INTO `platforms`
  (`platform_id`, `platform_name`, `platform_category`, `monthly_price`, `headquarters`)
VALUES
  (1, 'SoundSphere', 'Streaming',    9.90, 'Singapore'),
  (2, 'TuneTrail',   'Streaming',    0.00, 'Berlin'),
  (3, 'EchoCloud',   'Radio',        5.90, 'London'),
  (4, 'BeatBridge',  'Social Music', 7.90, 'Seoul'),
  (5, 'MelodyNow',   'Streaming',   11.90, 'Toronto'),
  (6, 'QuietWave',   'Radio',        4.90, 'Sydney');

INSERT INTO `artists` (`artist_id`, `artist_name`, `home_country`)
VALUES
  (1, 'The Northern Lights', 'Canada'),
  (2, 'Marina Sol',          'Spain'),
  (3, 'Kinetic Pulse',       'South Korea'),
  (4, 'Blue Note Trio',      'USA'),
  (5, 'Atlas Strings',       'United Kingdom'),
  (6, 'Neon Harbor',         'Japan'),
  (7, 'Silent Orchard',      'New Zealand');

INSERT INTO `tracks`
  (`track_id`, `track_name`, `artist_id`, `genre`, `release_year`,
   `duration_seconds`, `popularity_score`)
VALUES
  (101, 'Midnight Drive',  1, 'Electronic', 2024, 245, 91),
  (102, 'Paper Skies',     1, 'Indie',      2022, 218, 84),
  (103, 'Luna Roja',       2, 'Latin',      2023, 201, 88),
  (104, 'Ocean Letters',   2, 'Pop',        2021, 230, 79),
  (105, 'Neon Steps',      3, 'K-Pop',      2025, 189, 95),
  (106, 'City Rhythm',     3, 'Hip-Hop',    2024, 210, 86),
  (107, 'Blue Morning',    4, 'Jazz',       2020, 260, 82),
  (108, 'After Hours',     4, 'R&B',        2022, 240, 90),
  (109, 'Winter Suite',    5, 'Classical',  2019, 420, 76),
  (110, 'Open Roads',      5, 'Rock',       2024, 225, 87),
  (111, 'Tokyo Lights',    6, 'Electronic', 2023, 205, 89),
  (112, 'Sakura Rain',     6, 'Pop',        2025, 195, 93),
  (113, 'First Snow',      5, 'Classical',  2026, 410, 80),
  (114, 'Horizon Echo',    7, 'Indie',      2024, 215, 85);

INSERT INTO `listening_events`
  (`event_id`, `listener_id`, `track_id`, `platform_id`, `listened_at`,
   `minutes_played`, `completed`)
VALUES
  (1,  1,  112, 1, '2026-01-03 08:15:00', 3.25, TRUE),
  (2,  2,  110, 2, '2026-01-04 18:40:00', 3.75, FALSE),
  (3,  3,  107, 3, '2026-01-05 09:10:00', 4.10, TRUE),
  (4,  4,  109, 1, '2026-01-07 21:05:00', 6.50, TRUE),
  (5,  5,  103, 4, '2026-01-10 12:20:00', 3.20, TRUE),
  (6,  6,  106, 2, '2026-01-12 07:45:00', 2.80, FALSE),
  (7,  1,  104, 1, '2026-01-15 19:30:00', 3.50, TRUE),
  (8,  7,  105, 4, '2026-01-18 16:00:00', 3.00, TRUE),
  (9,  8,  101, 5, '2026-02-01 10:00:00', 4.00, TRUE),
  (10, 9,  112, 1, '2026-02-02 11:30:00', 3.25, TRUE),
  (11, 10, 108, 3, '2026-02-03 20:15:00', 4.00, TRUE),
  (12, 11, 109, 2, '2026-02-05 22:10:00', 7.00, TRUE),
  (13, 12, 110, 1, '2026-02-07 14:25:00', 3.75, TRUE),
  (14, 2,  101, 2, '2026-02-10 08:50:00', 3.50, TRUE),
  (15, 3,  107, 3, '2026-02-12 17:35:00', 4.20, TRUE),
  (16, 5,  103, 4, '2026-02-14 13:05:00', 3.10, TRUE),
  (17, 6,  106, 2, '2026-02-16 09:45:00', 3.20, TRUE),
  (18, 8,  111, 5, '2026-02-20 23:00:00', 3.40, TRUE),
  (19, 1,  105, 1, '2026-03-01 07:20:00', 3.10, TRUE),
  (20, 2,  102, 2, '2026-03-02 18:10:00', 3.60, TRUE),
  (21, 4,  109, 3, '2026-03-03 21:30:00', 6.80, TRUE),
  (22, 7,  105, 4, '2026-03-05 15:40:00', 3.00, TRUE),
  (23, 9,  104, 1, '2026-03-07 10:25:00', 3.80, FALSE),
  (24, 10, 108, 3, '2026-03-09 20:45:00', 4.10, TRUE),
  (25, 11, 113, 2, '2026-03-11 22:05:00', 6.90, TRUE),
  (26, 12, 110, 1, '2026-03-13 14:15:00', 3.70, TRUE),
  (27, 3,  107, 3, '2026-03-15 17:55:00', 4.30, TRUE),
  (28, 6,  106, 2, '2026-03-17 09:35:00', 3.50, TRUE),
  (29, 5,  103, 4, '2026-03-19 12:50:00', 3.30, TRUE),
  (30, 8,  101, 5, '2026-03-21 23:20:00', 4.20, FALSE),
  (31, 1,  112, 1, '2026-04-01 08:05:00', 3.20, TRUE),
  (32, 4,  109, 3, '2026-04-02 21:10:00', 6.70, TRUE),
  (33, 7,  105, 4, '2026-04-03 16:30:00', 3.10, TRUE),
  (34, 9,  112, 1, '2026-04-04 11:15:00', 3.30, TRUE),
  (35, 10, 108, 3, '2026-04-05 20:05:00', 3.90, TRUE),
  (36, 12, 102, 2, '2026-04-06 18:45:00', 3.60, FALSE);

-- End-of-load checks. Expected counts: 13, 6, 7, 14, and 36.
SELECT 'listeners' AS table_name, COUNT(*) AS row_count FROM `listeners`
UNION ALL
SELECT 'platforms', COUNT(*) FROM `platforms`
UNION ALL
SELECT 'artists', COUNT(*) FROM `artists`
UNION ALL
SELECT 'tracks', COUNT(*) FROM `tracks`
UNION ALL
SELECT 'listening_events', COUNT(*) FROM `listening_events`;
