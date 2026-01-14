# Amazon SQL Analysis

This project explores Amazon product and user data using SQL, with the goal of understanding product categories, user purchasing behavior, and discounts.

## Project Overview

The analysis focuses on:
- How products are distributed across categories
- How actively users purchase items
- How much users save through discounts
- Differences between declared and real discounts
- How stable or variable discounts are across categories

## Dataset Assumptions

The analysis is based on a table named `amazon` with the following fields:
- `category`
- `user_id`
- `user_name`
- `actual_price`
- `discounted_price`
- `discount_percentage`

Prices are stored as strings (e.g. `₹1,299`) and are cleaned during the analysis.

## Analysis Steps

1. **Category Analysis**
   - Count of products per category

2. **User Activity**
   - Number of purchased items per user

3. **User Savings Segmentation**
   - Total spending vs discounted spending
   - Classification of users based on savings behavior

4. **Discount Analysis**
   - Comparison between declared and real discounts per category

5. **Variance Analysis**
   - Discount rate variability across categories
   - Savings amount variability across categories

## Technical Notes

- SQL is used for all data processing and analysis.
- A database view is created to clean and convert price fields into numeric values.
- Variance is calculated using the formula: VAR(x)=AVG(x^2)-(AVG(x))^2

## Purpose

This project was created to practice SQL analytics, data cleaning, and basic business-oriented analysis on real-world styled e-commerce data.


