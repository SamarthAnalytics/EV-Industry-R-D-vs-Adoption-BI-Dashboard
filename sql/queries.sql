-- Create tables
DROP TABLE IF EXISTS ev_registrations;
CREATE TABLE ev_registrations (
  year INTEGER,
  quarter TEXT,
  region TEXT,
  ev_sales INTEGER,
  total_sales INTEGER
);

DROP TABLE IF EXISTS company_rnd;
CREATE TABLE company_rnd (
  year INTEGER,
  quarter TEXT,
  company TEXT,
  rnd_spend_usd_b REAL,
  revenue_usd_b REAL
);

DROP TABLE IF EXISTS automation_levels;
CREATE TABLE automation_levels (
  company TEXT,
  avg_automation_level REAL
);

-- KPIs
-- EV Market Share by Year + Quarter
SELECT year, quarter,
       SUM(ev_sales)*1.0 / SUM(total_sales) AS ev_share
FROM ev_registrations
GROUP BY year, quarter
ORDER BY year, quarter;

-- R&D spend ratio by company per Year + Quarter
SELECT year, quarter, company,
       rnd_spend_usd_b / NULLIF(revenue_usd_b, 0) AS rnd_ratio
FROM company_rnd
ORDER BY company, year, quarter;

-- Latest quarter per company → join automation levels
WITH latest AS (
  SELECT company, MAX(year) AS max_year
  FROM company_rnd
  GROUP BY company
),
latest_q AS (
  SELECT c.company, c.year, MAX(quarter) AS max_quarter
  FROM company_rnd c
  JOIN latest l ON l.company = c.company AND l.max_year = c.year
  GROUP BY c.company, c.year
)
SELECT a.company, a.avg_automation_level, c.rnd_spend_usd_b, c.revenue_usd_b
FROM automation_levels a
JOIN latest_q q ON q.company = a.company
JOIN company_rnd c ON c.company = q.company AND c.year = q.year AND c.quarter = q.max_quarter
ORDER BY a.avg_automation_level DESC;
