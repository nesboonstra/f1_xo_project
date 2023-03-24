#### Preamble ####

library(tidyverse)
library(snakecase)

snakecols <- function(x){
  to_snake_case(colnames(x),numerals="left")
}

lap_times_22 <- read_csv("data/lap_times.csv")
colnames(lap_times_22) <- snakecols(lap_times_22)

races_22 <- read_csv("data/races.csv")
colnames(races_22) <- snakecols(races_22)

races_22 <- races_22 %>% 
  filter(year == 2022) %>% 
  rename(time_race = time)

lap_times_22 <- lap_times_22 %>% 
  rename(time_lap = time) %>% 
  right_join(races_22) %>% 
  select(race_id:time_race) %>% 
  arrange(race_id,driver_id,lap)







