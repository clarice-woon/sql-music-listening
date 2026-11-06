-- Question 1
SELECT listener_id, listener_name, age
FROM listeners
WHERE subscription_tier = "Premium" and home_region = "Singapore"
ORDER BY age DESC, listener_name ASC;

-- Question 2
SELECT track_id, track_name, genre, popularity_score
FROM tracks
WHERE genre in ("Pop", "Rock", "Electronic") and popularity_score >= 85
ORDER BY popularity_score DESC, track_id ASC;

-- Question 3
SELECT subscription_tier, COUNT(*) listener_count, ROUND(AVG(age), 2) average_age
FROM listeners
GROUP BY subscription_tier
ORDER BY listener_count DESC, subscription_tier ASC;

-- Question 4
SELECT date_format(listened_at, '%Y-%m') listen_month, COUNT(*) play_count, ROUND(SUM(minutes_played), 2) total_minutes
FROM listening_events
GROUP BY listen_month
ORDER BY listen_month ASC;

-- Question 5
SELECT genre, COUNT(*) track_count, ROUND(AVG(popularity_score),2) average_popularity
FROM tracks
GROUP BY genre
HAVING average_popularity >=85
ORDER BY average_popularity DESC, genre ASC;

-- Question 6
SELECT a.track_id, a.track_name, b.artist_name, a.release_year
FROM tracks a
JOIN artists b
	ON a.artist_id = b.artist_id
WHERE a.release_year >= 2024
ORDER BY a.release_year DESC, a.track_id ASC
;

-- Question 7
SELECT a.event_id, DATE(a.listened_at) listen_date, 
	b.listener_name, track_name, platform_name, minutes_played
FROM listening_events a, listeners b, tracks c, platforms d WHERE
	a.listener_id=b.listener_id AND
    a.track_id=c.track_id AND
    a.platform_id=d.platform_id AND
	a.completed=0
ORDER BY listen_date ASC, a.event_id ASC
;

-- Question 8
SELECT a.listener_id, a.listener_name, 
	COUNT(*) OVER (PARTITION BY b.track_id) play_count, 
	coalesce(SUM(minutes_played) OVER (PARTITION BY b.track_id), 0.00) total_minutes
FROM listeners a
LEFT JOIN listening_events b
	ON a.listener_id=b.listener_id
ORDER BY play_count ASC, a.listener_id ASC
;

-- Question 9
SELECT b.platform_id, b.platform_name, 
	COUNT(a.track_id) OVER (PARTITION BY a.track_id) play_count, 
    coalesce(SUM(minutes_played) OVER (PARTITION BY a.track_id), 0.00) total_minutes
FROM listening_events a
RIGHT JOIN platforms b
	ON a.platform_id = b.platform_id
ORDER BY play_count DESC, platform_ID ASC;
    
-- Question 10
SELECT track_id, track_name, popularity_score
FROM tracks
WHERE popularity_score > (
	SELECT AVG(popularity_score) FROM tracks)
ORDER BY popularity_score DESC, track_id ASC;

-- Question 11
SELECT track_id, track_name, a.genre, popularity_score
FROM tracks a
WHERE popularity_score > (
	SELECT AVG(popularity_score) FROM tracks b
    WHERE b.genre = a.genre)
ORDER BY genre ASC, popularity_score DESC, track_id ASC;

-- Question 12
WITH listener_totals as (
	SELECT a.listener_id, a.listener_name, 
		SUM(b.minutes_played) total_minutes
    FROM listeners a
	JOIN listening_events b
		ON a.listener_id=b.listener_id
	GROUP BY listener_id)
SELECT listener_id, listener_name, total_minutes
FROM listener_totals
WHERE total_minutes >= 12.00
ORDER BY total_minutes DESC, listener_id ASC;

-- Question 13
SELECT event_id, listener_id, date(listened_at) listen_date, 
	minutes_played, 
    SUM(minutes_played) OVER (PARTITION BY listener_id) listener_total_minutes
FROM listening_events
WHERE listener_id IN (1,4,11)
ORDER BY listener_id, listened_at, event_id
;

-- Question 14
DROP VIEW IF EXISTS vw_track_play_summary;

CREATE VIEW vw_track_play_summary (track_id, track_name, artist_name, play_count, total_minutes)
AS SELECT b.track_id, b.track_name, a.artist_name, 
	coalesce(COUNT(event_id),0), 
	coalesce(SUM(minutes_played),0.00)
	FROM artists a
	JOIN tracks b ON a.artist_id = b.artist_id
    LEFT JOIN listening_events c ON b.track_id = c.track_id
    GROUP BY b.track_id;
    
SELECT track_id, track_name, artist_name, play_count, total_minutes
FROM vw_track_play_summary
WHERE play_count = 0 OR play_count >=4
ORDER BY play_count DESC, total_minutes DESC, track_id ASC;

-- Question 15
WITH monthly_platform_activity AS (
	SELECT date_format(a.listened_at, '%Y-%m') listen_month, 
		b.platform_id, 
        b.platform_name,
        COUNT(a.event_id) play_count,
        SUM(minutes_played) total_minutes,
        ROW_NUMBER() OVER (PARTITION BY date_format(a.listened_at, '%Y-%m')
			ORDER BY SUM(minutes_played) DESC, b.platform_id ASC) as platform_rank
	FROM listening_events a JOIN platforms b
		ON a.platform_id = b.platform_id
	GROUP BY listen_month, 
		b.platform_id, 
        b.platform_name)
SELECT listen_month, platform_id, platform_name, play_count, total_minutes, platform_rank
FROM monthly_platform_activity
WHERE platform_rank <= 2
ORDER BY listen_month ASC, platform_rank ASC
;
