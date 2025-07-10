# Olist E-commerce Customer Sales Dashboard

# Project Overview
This project involves a comprehensive data analysis and visualization of the Olist Brazilian E-commerce public dataset. The primary goal is to provide actionable insights into customer sales behavior, operational efficiency, and customer satisfaction, presented through an interactive dashboard.

# Tools Used
- RStudio: For data loading, cleaning, transformation, feature engineering, and initial exploratory data analysis.
- Tidyverse (R):Specifically `dplyr` for data manipulation, `ggplot2` for initial visualizations, and `lubridate` for date handling.
- Tableau Public:For creating interactive, aesthetic, and user-friendly dashboards to visualize key findings.

## Data Sources
The analysis utilizes various interconnected datasets from Olist. Due to their large size, the original raw datasets are not included directly in this repository. You can download them from the official Olist Brazilian E-commerce Public Dataset on Kaggle:
[Link to Olist Kaggle Dataset](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)

## Key Analysis Areas & Visualizations
The project focuses on answering key business questions through the following visualizations:

1.  Delivery Time vs. Review Score: Investigates the relationship between delivery duration and customer satisfaction.
2.  Top Product Categories: Identifies the most popular product types by order volume.
3.  Most Used Payment Methods: Shows preferred customer payment options.
4.  Average Delivery Time by Review Score: Highlights how average delivery time impacts different satisfaction levels.
5.  Top Cities by Orders: Pinpoints key geographical areas for sales at a city level.
6.  Top States by Orders: Provides a broader geographical overview of order distribution.

# Interactive Dashboard
Explore the full interactive dashboard with all insights on Tableau Public:

https://public.tableau.com/app/profile/nisha.saklani/viz/CustomerSalesDashboard_17521331431010/OlistBusinessAnalyticsDashboard

## Files in this Repository
- `Olist_Ecommerce_Analysis.R`: The complete R script used for data processing and analysis.
- `avg_delivery_by_score.csv`: Cleaned and prepared data for average delivery time by review score analysis.
- `delivery_vs_review.csv`: Cleaned and prepared data for delivery time and review score analysis.
- `payment_counts.csv`: Data for payment method analysis.
- `top_categories.csv`: Data for top product categories.
- `top_cities.csv`: Data for top cities by orders.
- `top_states.csv`: Data for top states by orders.
- `README.md`: This file, providing an overview of the project.

## How to Replicate
1.  Download the raw datasets from the Kaggle link provided above.
2.  clone the repository:
    `git clone https://github.com/Nish410/Customer_Sales_Dashboard.git`
   
3.  Place the downloaded raw CSVs** into the cloned repository folder.
4.  Open `Olist_Ecommerce_Analysis.R` in RStudio.
5.  Run the R script to perform data cleaning, feature engineering, and generate the analysis-ready CSVs.
6.  Connect the generated CSVs to Tableau Public to view and interact with the dashboards.


Nisha saklani

