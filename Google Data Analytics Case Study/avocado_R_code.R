library(tidyverse)
library(lubridate)

avocado <- read.csv("C:/Users/santo/Downloads/avocado.csv/avocado.csv",
                    header = TRUE,
                    stringsAsFactors = FALSE)

# Clean column names 
names(avocado) <- make.names(names(avocado))

avocado$Date <- as.Date(avocado$Date)

## Descriptive Analysis
# Summary of average prices
summary(avocado$AveragePrice)

# Average price by type
avocado %>%
  group_by(type) %>%
  summarise(avg_price = mean(AveragePrice))


##Sales Trends Over Time
ggplot(avocado, aes(x = Date, y = AveragePrice, color = type)) +
  geom_line(size = 1) +
  labs(title = "Avocado Average Price Over Time",
       x = "Date", y = "Average Price (USD)") +
  theme_minimal()



## Regional Comparison -> Average Price by Region
region_avg <- avocado %>%
  group_by(region, type) %>%
  summarise(avg_price = mean(AveragePrice), .groups = 'drop')

ggplot(region_avg, aes(x = reorder(region, avg_price), y = avg_price, fill = type)) +
  geom_col(position = "dodge") +
  coord_flip() +
  labs(title = "Average Avocado Price by Region and Type",
       x = "Region", y = "Average Price") +
  theme_minimal()


## Market Share (Volume) -> Organic vs Conventional Share
share <- avocado %>%
  group_by(type) %>%
  summarise(total_vol = sum(Total.Volume))

ggplot(share, aes(x = "", y = total_vol, fill = type)) +
  geom_col(width = 1) +
  coord_polar(theta = "y") +
  labs(title = "Market Share: Organic vs Conventional") +
  theme_void()



## Seasonality Differences
avocado %>%
  mutate(month = month(Date, label = TRUE)) %>%
  group_by(month, type) %>%
  summarise(avg_price = mean(AveragePrice), .groups = 'drop') %>%
  ggplot(aes(x = month, y = avg_price, color = type, group = type)) +
  geom_line(size = 1) +
  labs(title = "Seasonality of Avocado Prices by Type",
       x = "Month", y = "Average Price") +
  theme_minimal()

