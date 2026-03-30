CREATE TABLE accounts (
    id INT PRIMARY KEY,
    description VARCHAR(255)
);

INSERT INTO accounts (id, description)
VALUES 
    (1007096, 'Org A'),
    (1237676, 'Publisher B'),
    (1105546, 'Advertiser X');

CREATE TABLE click_event (
    click_event_time DATETIME,
    publisher_id INT,
    advertiser_id INT,
    campaign_id INT
);

INSERT INTO click_event (click_event_time, publisher_id, advertiser_id, campaign_id)
VALUES 
    ('2024-06-27 14:23:51', 1237676, 1105546, 24989526),
    ('2024-06-28 09:15:00', 1007096, 1105546, 24989526),
    ('2024-06-29 18:45:22', 1237676, 1105546, 25000111);

CREATE TABLE campaign_targeting (
    campaign_id INT,
    publisher_id INT,
    restriction_type VARCHAR(10),
    performer VARCHAR(255)
);

INSERT INTO campaign_targeting (campaign_id, publisher_id, restriction_type, performer)
VALUES 
    (24989526, 1007096, 'INCLUDE', 'zephyr@nilber.com'),
    (24989526, 1237676, 'INCLUDE', 'maia@nilber.com'),
    (25000111, 1007096, 'EXCLUDE', 'elliott@nilber.com');


-- Query returning publisher and clicks for a specific campaign
WITH clicks AS (
	SELECT publisher_id, COUNT(*) as total_clicks
    FROM click_event
    WHERE campaign_id = 24989526
    GROUP BY publisher_id
) 

SELECT a.id, a.description, c.total_clicks
FROM clicks 
JOIN accounts a ON c.publisher_id  = a.id


-- Query returning publisher targeting rules for all campaigns with at least 3 clicks
WITH clicks AS (
    SELECT campaign_id, COUNT(*) as total_clicks
    FROM click_event
    GROUP BY campaign_id
    HAVING total_clicks >= 3	
)

SELECT m.campaign_id, m.publisher_id, m.restriction_type, m.total_clicks, a.description
FROM campaign_targeting m
JOIN clicks c ON c.campaign_id = t.campaign_id
JOIN accounts a ON m.publisher_id = a.id
WHERE m.restriction_type = ‘INCLUDE’
