CREATE OR REPLACE TABLE `bigquery-vari-com-380521.ua_au_75513510.pages_query_1_dedup` 
PARTITION BY
  date
  OPTIONS(

  )
AS
(
  SELECT * EXCEPT(row_num) from (
      SELECT *,
        ROW_NUMBER() OVER (
          PARTITION by pagePath, pageTitle, channelGrouping, deviceCategory, landingPagePath, previousPagePath, sourceMedium
          ORDER BY date DESC
        ) AS row_num
      FROM
      `bigquery-380521.analytics_75513510.pages_query`
   )
  WHERE row_num = 1 AND
  date BETWEEN "2018-01-01" AND "2018-07-03"
)