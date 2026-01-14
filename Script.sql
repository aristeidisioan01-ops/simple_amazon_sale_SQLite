SELECT
  category,
  COUNT(*) AS total_products_per_cat
FROM amazon
GROUP BY category
ORDER BY total_products_per_cat  DESC;

SELECT
  user_name,
  count(*) as total_items_per_user
  FROM amazon
  GROUP BY user_name
  ORDER BY total_items_per_user  DESC;

WITH user_spend AS (
  SELECT
    user_id,
    user_name,
    COUNT(*) AS total_items,
    SUM(CAST(REPLACE(REPLACE(discounted_price, '₹', ''), ',', '') AS REAL)) AS total_spent_disc,
    SUM(CAST(REPLACE(REPLACE(actual_price, '₹', ''), ',', '') AS REAL)) AS total_spent_actual
  FROM amazon
  GROUP BY user_id, user_name
  HAVING COUNT(*) > 5
),
user_savings AS (
  SELECT
    user_id,
    user_name,
    total_items,
    total_spent_actual,
    total_spent_disc,
    (total_spent_actual - total_spent_disc) AS total_saved,
    (total_spent_actual - total_spent_disc) / NULLIF(total_spent_actual, 0) AS savings_rate
  FROM user_spend
)
SELECT
  user_id,
  user_name,
  total_items,
  total_spent_actual,
  total_spent_disc,
  total_saved,
  savings_rate,
  CASE
    WHEN savings_rate > 0.30 THEN 'Sale Hunter'
    WHEN savings_rate BETWEEN 0.15 AND 0.30 THEN 'Moderate Saver'
    ELSE 'Low Saver'
  END AS user_saving_category
FROM user_savings
ORDER BY savings_rate DESC
LIMIT 10;

CREATE VIEW IF NOT EXISTS cleaned_prices AS
SELECT
  category,
  CAST(REPLACE(REPLACE(actual_price, '₹', ''), ',', '') AS REAL) AS actual_price_num,
  CAST(REPLACE(REPLACE(discounted_price, '₹', ''), ',', '') AS REAL) AS discounted_price_num,
  CAST(REPLACE(discount_percentage, '%', '') AS REAL) AS discount_percentage_num
FROM amazon;

SELECT
  category,
  AVG(discount_percentage_num) AS avg_declared_discount,
  (SUM(actual_price_num) - SUM(discounted_price_num))
    / NULLIF(SUM(actual_price_num), 0) * 100 AS avg_real_discount
FROM cleaned_prices
GROUP BY category
ORDER BY avg_real_discount DESC;

-- Variance
-- VAR(x) = AVG(x*x) - AVG(x)*AVG(x)
---PERCENRAGE
SELECT
  category,
  AVG(x) AS avg_discount_rate,
  AVG(x * x) - AVG(x) * AVG(x) AS discount_variance
FROM (
  SELECT
    category,
    (actual_price_num - discounted_price_num) / NULLIF(actual_price_num, 0) AS x
  FROM cleaned_prices
)
GROUP BY category
ORDER BY discount_variance DESC;

---AMOUNT
SELECT
  category,
  AVG(x) AS avg_amount_rate,
  AVG(x * x) - AVG(x) * AVG(x) AS savings_amount_variance
FROM (
  SELECT
    category,
    (actual_price_num - discounted_price_num) / NULLIF(actual_price_num, 0) AS x
  FROM cleaned_prices
)
GROUP BY category
ORDER BY savings_amount_variance DESC;