-- multiple session_start events per user and ga_session_id
WITH base AS (
  SELECT
    event_date,
    user_pseudo_id,
    (SELECT value.int_value FROM UNNEST(event_params) WHERE key = "ga_session_id") AS ga_session_id,
    batch_page_id,
    event_name
  FROM `bigquery-dataset.analytics_368946682.events_*`
  WHERE user_pseudo_id IS NOT NULL AND TABLE_SUFFIX = "20250710"
  AND event_name = "session_start"
)

SELECT event_date, user_pseudo_id, ga_session_id, COUNT(*) AS session_starts
FROM base
GROUP BY 1,2,3
HAVING session_starts > 1
ORDER BY 1,4 DESC


-- Multiple first_visits per user
SELECT user_pseudo_id, COUNT(*) AS first_visits
FROM `bigquery-dataset.analytics_368946682.events_*`
WHERE user_pseudo_id IS NOT NULL AND TABLE_SUFFIX = "20250710"
AND event_name = "first_visit"
GROUP BY 1
HAVING first_visits > 1
ORDER BY 2 DESC