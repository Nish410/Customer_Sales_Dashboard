library(tidyverse)
olist_customers_df <- read_csv("olist_customers_dataset.csv")
olist_geolocation_df <- read_csv("olist_geolocation_dataset.csv")
olist_order_items_df <- read_csv("olist_order_items_dataset.csv")
olist_order_payments_df <- read_csv("olist_order_payments_dataset.csv")
olist_order_reviews_df <- read_csv("olist_order_reviews_dataset.csv")
olist_orders_df <- read_csv("olist_orders_dataset.csv")
olist_products_df <- read_csv("olist_products_dataset.csv")
olist_sellers_df <- read_csv("olist_sellers_dataset.csv")
product_category_name_translation_df <- read_csv("product_category_name_translation.csv")

glimpse(olist_orders_df)
glimpse(olist_customers_df)
glimpse(olist_order_items_df)
glimpse(olist_order_payments_df)
glimpse(olist_order_reviews_df)
glimpse(olist_products_df)
glimpse(product_category_name_translation_df)

combined_df <- olist_orders_df %>%
  left_join(olist_order_items_df, by = "order_id") %>%
  left_join(olist_order_payments_df, by = "order_id") %>%
  left_join(olist_order_reviews_df, by = "order_id") %>%
  left_join(olist_customers_df, by = "customer_id") %>%
  left_join(olist_products_df, by = "product_id") %>%
  left_join(product_category_name_translation_df, by = "product_category_name")

glimpse(combined_df)

#Analyze top selling product categories
top_categories <- combined_df %>%
  count(product_category_name_english, sort = TRUE) %>%
  slice_max(n, n = 10)

print(top_categories)
#Visualize the Top Categories with a Bar Chart
library(ggplot2)
ggplot(top_categories, aes(x = reorder(product_category_name_english, n), y = n)) +
  geom_col(fill = "skyblue") +
  coord_flip() +
  labs(title = "Top 10 Product Categories",
       x = "Product Category",
       y = "Number of Orders")

#Step 6-Payment method analysis
payment_counts <- combined_df %>%
  count(payment_type, sort = TRUE)

print(payment_counts)
ggplot(payment_counts, aes(x = reorder(payment_type, n), y = n)) +
  geom_col(fill = "orange") +
  coord_flip() +
  labs(title = "Most Used Payment Methods",
       x = "Payment Method",
       y = "Number of Orders")

#Deloivery time Analysis
#Creating a delivery time column
library(lubridate)

delivery_time_df <- combined_df %>%
  mutate(order_purchase_timestamp = as_datetime(order_purchase_timestamp),
         order_delivered_customer_date = as_datetime(order_delivered_customer_date),
         delivery_days = as.numeric(difftime(order_delivered_customer_date, order_purchase_timestamp, units = "days"))) %>%
  filter(!is.na(delivery_days))  # remove missing values

mean(delivery_time_df$delivery_days) #avg no. of days it take to deliver an order

#Visualize delivery time distribution
ggplot(delivery_time_df, aes(x = delivery_days)) +
  geom_histogram(binwidth = 1, fill = "green", color = "black") +
  labs(title = "Delivery Time Distribution",
       x = "Delivery Days",
       y = "Number of Orders")

#Analyzing review score
review_counts <- combined_df %>%
  count(review_score, sort = TRUE)

print(review_counts)

#Visualizing Review Score Distribution
ggplot(review_counts, aes(x = factor(review_score), y = n)) +
  geom_col(fill = "purple") +
  labs(title = "Review Score Distribution",
       x = "Review Score",
       y = "Number of Reviews")

#Average Review Score per Category
avg_review_by_category <- combined_df %>%
  group_by(product_category_name_english) %>%
  summarise(avg_review = mean(review_score, na.rm = TRUE),
            review_count = n()) %>%
  arrange(desc(avg_review)) %>%
  filter(!is.na(product_category_name_english))  # remove missing category names

print(avg_review_by_category)

# Visualize Top 10 Best-Rated Categories
top_reviews <- avg_review_by_category %>%
  filter(review_count > 100) %>%  # optional: only show categories with enough data
  slice_max(avg_review, n = 10)

ggplot(top_reviews, aes(x = reorder(product_category_name_english, avg_review), y = avg_review, fill = avg_review)) +
  geom_col(show.legend = FALSE) +
  coord_flip() +
  scale_fill_gradient(low = "lightblue", high = "darkblue") +
  geom_text(aes(label = round(avg_review, 2)), hjust = -0.1, color = "black", size = 3.5) +
  labs(title = "⭐ Top 10 Product Categories by Average Review Score",
       subtitle = "Only categories with over 100 reviews",
       x = "Product Category",
       y = "Average Review Score") +
  theme_minimal()

#Creating a Table with Delivery Time + Review Score
delivery_review_df <- combined_df %>%
  mutate(order_purchase_timestamp = as_datetime(order_purchase_timestamp),
         order_delivered_customer_date = as_datetime(order_delivered_customer_date),
         delivery_days = as.numeric(difftime(order_delivered_customer_date, order_purchase_timestamp, units = "days"))) %>%
  filter(!is.na(delivery_days), !is.na(review_score)) %>%
  select(delivery_days, review_score)

avg_delivery_by_score <- delivery_review_df %>%
  group_by(review_score) %>%
  summarise(avg_delivery = mean(delivery_days))

ggplot(avg_delivery_by_score, aes(x = factor(review_score), y = avg_delivery, fill = review_score)) +
  geom_col(show.legend = FALSE) +
  labs(title = "Average Delivery Time by Review Score",
       x = "Review Score",
       y = "Avg Delivery Time (Days)") +
  theme_minimal() +
  scale_fill_gradient(low = "lightcoral", high = "darkred") +
  geom_text(aes(label = round(avg_delivery, 1)), vjust = -0.5, size = 4)

#Analyze Top Cities and States by Number of Orders
top_cities <- combined_df %>%
  count(customer_city, sort = TRUE) %>%
  slice_max(n, n = 10)

ggplot(top_cities, aes(x = reorder(customer_city, n), y = n)) +
  geom_col(fill = "steelblue") +
  coord_flip() +
  labs(title = "Top 10 Cities by Number of Orders",
       x = "City",
       y = "Number of Orders") +
  geom_text(aes(label = n), hjust = -0.2) +
  theme_minimal()

#Top 10 States by Number of Orders
top_states <- combined_df %>%
  count(customer_state, sort = TRUE) %>%
  slice_max(n, n = 10)

ggplot(top_states, aes(x = reorder(customer_state, n), y = n, fill = n)) +
  geom_col(width = 0.6, show.legend = FALSE) +
  coord_flip() +
  scale_fill_gradient(low = "#a8dadc", high = "#1d3557") +
  geom_text(aes(label = n), hjust = -0.1, color = "black", size = 4) +
  labs(title = "🌎 Top 10 States by Number of Orders",
       subtitle = "Based on customer_state field",
       x = "State",
       y = "Total Orders") +
  theme_minimal(base_size = 13) +
  theme(plot.title = element_text(face = "bold"),
        plot.subtitle = element_text(size = 10),
        axis.title.y = element_text(face = "bold"),
        axis.title.x = element_text(face = "bold"))

summary_table <- tibble(
  Metric = c(
    "Total Orders",
    "Unique Customers",
    "Unique Products",
    "Average Delivery Time (days)",
    "Most Used Payment Method",
    "Most Popular Product Category",
    "Average Review Score"
  ),
  Value = c(
    n_distinct(combined_df$order_id),
    n_distinct(combined_df$customer_id),
    n_distinct(combined_df$product_id),
    round(mean(delivery_review_df$delivery_days), 2),
    combined_df %>% count(payment_type, sort = TRUE) %>% slice(1) %>% pull(payment_type),
    combined_df %>% count(product_category_name_english, sort = TRUE) %>% slice(1) %>% pull(product_category_name_english),
    round(mean(combined_df$review_score, na.rm = TRUE), 2)
  )
)

print(summary_table)
#Summary report
library(gt)
summary_table %>%
  gt() %>%
  tab_header(
    title = "📊 E-Commerce Project: Key Business Insights"
  )
# Export Cleaned Data for Tableau
write_csv(top_categories, "top_categories.csv")
write_csv(top_states, "top_states.csv")
write_csv(top_cities, "top_cities.csv")
write_csv(delivery_review_df, "delivery_vs_review.csv")
write_csv(payment_counts, "payment_counts.csv")
write_csv(avg_delivery_by_score, "avg_delivery_by_score.csv")
