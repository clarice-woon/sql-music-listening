**1\. Schema at a glance**

| **Table**        | **Rows** | **Purpose**                                  | **Primary key** |
| ---------------- | -------- | -------------------------------------------- | --------------- |
| listeners        | 13       | Listener profile and subscription attributes | listener_id     |
| platforms        | 6        | Music platform directory                     | platform_id     |
| artists          | 7        | Artist directory                             | artist_id       |
| tracks           | 14       | Track, artist, genre, and popularity data    | track_id        |
| listening_events | 36       | One row per recorded listening event         | event_id        |

Foreign-key relationships:

| **Child column**             | **Relationship** | **Parent column**     |
| ---------------------------- | ---------------- | --------------------- |
| tracks.artist_id             | \=               | artists.artist_id     |
| listening_events.listener_id | \=               | listeners.listener_id |
| listening_events.track_id    | \=               | tracks.track_id       |
| listening_events.platform_id | \=               | platforms.platform_id |

**2\. Questions**

## Basic (30 marks)

Core retrieval, filtering, grouping, aggregation, HAVING, and sorting.

## 1. Premium listeners in Singapore (6 marks)

| **Tables:** listeners | **Focus:** SELECT, FROM, WHERE, ORDER BY |
| --------------------- | ---------------------------------------- |

List Premium listeners whose home_region is Singapore.

**Return:** listener_id, listener_name, age

**Ordering:** Sort by age descending, then listener_name ascending.

## 2. Popular tracks in selected genres (6 marks)

| **Tables:** tracks | **Focus:** WHERE with IN and comparison; ORDER BY |
| ------------------ | ------------------------------------------------- |

List tracks in the Pop, Rock, or Electronic genres with a popularity_score of at least 85.

**Return:** track_id, track_name, genre, popularity_score

**Ordering:** Sort by popularity_score descending, then track_id ascending.

## 3. Listeners by subscription tier (6 marks)

| **Tables:** listeners | **Focus:** GROUP BY, COUNT, AVG, ROUND, ORDER BY |
| --------------------- | ------------------------------------------------ |

For each subscription tier, calculate the number of listeners and their average age rounded to two decimal places.

**Return:** subscription_tier, listener_count, average_age

**Ordering:** Sort by listener_count descending, then subscription_tier ascending.

## 4. Monthly listening activity (6 marks)

| **Tables:** listening_events | **Focus:** DATE_FORMAT, GROUP BY, COUNT, SUM, ORDER BY |
| ---------------------------- | ------------------------------------------------------ |

Summarise listening activity by calendar month. Format the month as YYYY-MM and round total minutes to two decimal places.

**Return:** listen_month, play_count, total_minutes

**Ordering:** Sort chronologically by listen_month.

## 5. Genres meeting a popularity threshold (6 marks)

| **Tables:** tracks | **Focus:** GROUP BY, HAVING, COUNT, AVG, ORDER BY |
| ------------------ | ------------------------------------------------- |

For each genre, calculate the number of tracks and average popularity score. Keep only genres whose average popularity is at least 85; round the average to two decimal places.

**Return:** genre, track_count, average_popularity

**Ordering:** Sort by average_popularity descending, then genre ascending.

## Intermediate (35 marks)

Equi joins, multi-table inner joins, outer joins, and a scalar subquery.

## 6. Tracks and their artists (7 marks)

| **Tables:** tracks, artists | **Focus:** INNER JOIN using an equi-join condition |
| --------------------------- | -------------------------------------------------- |

Use an INNER JOIN with the equality condition tracks.artist_id = artists.artist_id to list tracks released from 2024 onward.

**Return:** track_id, track_name, artist_name, release_year

**Ordering:** Sort by release_year descending, then track_id ascending.

## 7. Incomplete listening events (7 marks)

| **Tables:** listening_events, listeners, tracks, platforms | **Focus:** Multiple INNER JOINs, WHERE, DATE, ORDER BY |
| ---------------------------------------------------------- | ------------------------------------------------------ |

List every event for which completed is FALSE, together with the listener, track, and platform names. Display only the date portion of listened_at.

**Return:** event_id, listen_date, listener_name, track_name, platform_name, minutes_played

**Ordering:** Sort by listened_at ascending, then event_id ascending.

## 8. Listening totals for every listener (7 marks)

| **Tables:** listeners, listening_events | **Focus:** LEFT OUTER JOIN, aggregation, COALESCE |
| --------------------------------------- | ------------------------------------------------- |

Show every listener, including listeners with no listening events. Calculate play_count and total_minutes; display 0.00 for a missing total.

**Return:** listener_id, listener_name, play_count, total_minutes

**Ordering:** Sort by play_count ascending, then listener_id ascending.

## 9. Listening totals for every platform (7 marks)

| **Tables:** listening_events, platforms | **Focus:** RIGHT OUTER JOIN, aggregation, COALESCE |
| --------------------------------------- | -------------------------------------------------- |

Write the query with listening_events on the left and platforms on the right. Preserve every platform, including platforms with no events, and calculate play_count and total_minutes.

**Return:** platform_id, platform_name, play_count, total_minutes

**Ordering:** Sort by play_count descending, then platform_id ascending.

## 10. Tracks above the overall popularity average (7 marks)

| **Tables:** tracks | **Focus:** Scalar subquery |
| ------------------ | -------------------------- |

Use a subquery to find tracks whose popularity_score is greater than the overall average popularity_score across all tracks.

**Return:** 2

**Ordering:** Sort by popularity_score descending, then track_id ascending.

## Advanced (35 marks)

A correlated subquery, CTEs, partitioned window functions, and a view.

## 11. Tracks above their genre average (7 marks)

| **Tables:** tracks | **Focus:** Correlated subquery |
| ------------------ | ------------------------------ |

Use a correlated subquery to find tracks whose popularity_score is greater than the average popularity_score for their own genre.

**Return:** track_id, track_name, genre, popularity_score

**Ordering:** Sort by genre ascending, popularity_score descending, then track_id ascending.

## 12. High-listening users using a CTE (7 marks)

| **Tables:** listeners, listening_events | **Focus:** WITH statement (common table expression), JOIN, GROUP BY |
| --------------------------------------- | ------------------------------------------------------------------- |

Create a CTE named listener_totals that calculates total listening minutes for each listener with events. Return listeners with at least 12.00 total minutes.

**Return:** listener_id, listener_name, total_minutes

**Ordering:** Sort by total_minutes descending, then listener_id ascending.

## 13. Event rows with a listener-level window total (7 marks)

| **Tables:** listening_events | **Focus:** SUM(...) OVER (PARTITION BY ...) |
| ---------------------------- | ------------------------------------------- |

For listener_id values 1, 4, and 11, show each event and add the total minutes for that listener on every event row. Use a window function so the event rows are not collapsed.

**Return:** event_id, listener_id, listen_date, minutes_played, listener_total_minutes

**Ordering:** Sort by listener_id, listened_at, and event_id, all ascending.

## 14. Reusable track-play view (7 marks)

| **Tables:** tracks, artists, listening_events | **Focus:** CREATE VIEW, INNER JOIN, LEFT OUTER JOIN, aggregation |
| --------------------------------------------- | ---------------------------------------------------------------- |

Create a view named vw_track_play_summary with one row per track. Include the artist name, play_count, and total_minutes; tracks with no events must show 0 and 0.00. Then query the view for tracks with no plays or at least four plays.

**Return:** track_id, track_name, artist_name, play_count, total_minutes

**Ordering:** Sort by play_count descending, total_minutes descending, then track_id ascending.

## 15. Top two platforms within each month (7 marks)

| **Tables:** listening_events, platforms | **Focus:** WITH statements, ROW_NUMBER() OVER (PARTITION BY ...), aggregation |
| --------------------------------------- | ----------------------------------------------------------------------------- |

First aggregate monthly activity by platform. Then rank platforms separately within each month and return the top two. Break ties by total_minutes descending, then platform_id ascending.

**Return:** listen_month, platform_id, platform_name, play_count, total_minutes, platform_rank

**Ordering:** Sort the final output by listen_month ascending and platform_rank ascending.

# Appendix A. Topic and mark map

| **Level**    | **Questions** | **Marks** | **Principal topics**                           |
| ------------ | ------------- | --------- | ---------------------------------------------- |
| Basic        | 1-5           | 30        | Core clauses, aggregation, HAVING              |
| Intermediate | 6-10          | 35        | Inner/equi joins, outer joins, scalar subquery |
| Advanced     | 11-15         | 35        | Correlated subquery, CTE, window, view         |
| Total        | 1-15          | 100       |                                                |