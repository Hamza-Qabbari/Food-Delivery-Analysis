library(dplyr)
library(readr)


data <- read.csv("Food_Delivery_Times.csv")


clean_data <- data %>%

  mutate(across(where(is.numeric), ~ifelse(is.na(.), mean(., na.rm = TRUE), .))) %>%
  

  drop_na() %>%
  

  mutate(

    Speed = Distance_km / (Delivery_Time_min / 60),
    

    late_order = ifelse(Delivery_Time_min > 45, "Late", "Not late")
  )


write.csv(clean_data, "cleaned_food_delivery_data.csv", row.names = FALSE)


summary(clean_data)
