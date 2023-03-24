#### Preamble ####

library(tidyverse)
library(snakecase)
library(stringi)

snakecols <- function(x){
  to_snake_case(colnames(x),numerals="left")
}

#### Reading in ####

# circuits.csv

circuits <- read_csv("old_data/circuits.csv")
colnames(circuits) <- snakecols(circuits)
circuits <- circuits %>% 
  rename(circuit_name = name,
         circuit_loc = location,
         circuit_country = country,
         circuit_lat = lat,
         circuit_lng = lng,
         circuit_alt = alt,
         circuit_url = url)

# write_csv(circuits,"tidy_data/circuits_tidy.csv")

# constructor_results.csv

constructor_results <- read_csv("old_data/constructor_results.csv")
colnames(constructor_results) <- snakecols(constructor_results)

# write_csv(constructor_results,"tidy_data/conresults_tidy.csv")

# constructor_standings.csv

constructor_standings <- read_csv("old_data/constructor_standings.csv")
colnames(constructor_standings) <- snakecols(constructor_standings)

# write_csv(constructor_standings,"tidy_data/constands_tidy.csv")

# constructors.csv

constructors <- read_csv("old_data/constructors.csv")
colnames(constructors) <- snakecols(constructors)

write_csv(constructors,"tidy_data/constructors_tidy.csv")

# driver_standings.csv

driver_standings <- read_csv("old_data/driver_standings.csv")
colnames(driver_standings) <- snakecols(driver_standings)

# write_csv(driver_standings,"tidy_data/drvstands_tidy.csv")

# drivers.csv

drivers <- read_csv("old_data/drivers.csv")
colnames(drivers) <- snakecols(drivers)
drivers <- drivers %>% 
  mutate(driver_name = str_c(forename,surname,sep=" ")) %>% 
  mutate(driver_name = stri_trans_general(driver_name,id="Latin-ASCII")) %>% # removes diacritics
  rename(driver_url = url)

# write_csv(drivers,"tidy_data/drivers_tidy.csv")

# races.csv

races <- read_csv("old_data/races.csv")
colnames(races) <- snakecols(races)
races <- races %>% 
  rename(race_name = name,
         race_date = date,
         race_time = time,
         race_url = url)

# write_csv(races,"tidy_data/races_tidy.csv")

# lap_times.csv

lap_times <- read_csv("old_data/lap_times.csv")
colnames(lap_times) <- snakecols(lap_times) 
lap_times <- lap_times %>% 
  mutate(lap_id = row_number())

races_circuits <- races %>% # placeholder df to add circuit_id to lap_times
  select(c(race_id,circuit_id))

lap_times <- lap_times %>% 
  left_join(races_circuits) 

rm(races_circuits) # rm df

# write_csv(lap_times,"tidy_data/laps_tidy.csv")

# pit_stops.csv

pit_stops <- read_csv("old_data/pit_stops.csv")
colnames(pit_stops) <- snakecols(pit_stops)
pit_stops <- pit_stops %>% 
  mutate(stop_id = row_number())

# write_csv(pit_stops,"tidy_data/pits_tidy.csv")

# qualifying.csv

qualifying <- read_csv("old_data/qualifying.csv")
colnames(qualifying) <- snakecols(qualifying)
qualifying <- qualifying %>% 
  mutate(across(q1:q3,ms)) %>% 
  mutate(across(q1:q3,as.numeric)) %>% 
  pivot_longer(
    cols = q1:q3,
    names_to = "qual_round",
    names_prefix = "q",
    values_to = "qual_time"
  ) %>% 
  mutate(qual_round=as.numeric(qual_round)) %>% 
  filter(is.na(qual_time)==0) %>% 
  mutate(qualify_id=row_number())

# write_csv(qualifying,"tidy_data/quali_tidy.csv")

# results.csv

results <- read_csv("old_data/results.csv")
colnames(results) <- snakecols(results)
results <- results %>% 
  rename(finishing_time = time)

# write_csv(results,"tidy_data/results_tidy.csv")

# safety_hybrid.csv

safety_hybrid <- read_csv("old_data/safety_hybrid.csv")
colnames(safety_hybrid) <- snakecols(safety_hybrid)
safety_hybrid <- safety_hybrid %>% 
  rename(race_name = name) %>% 
  mutate(safety_id = row_number()) %>% 
  left_join(races) %>% 
  select(!c(circuit_id:sprint_time)) %>% 
  select(!safety_count) # if we really want this we can summ it back

# write_csv(safety_hybrid,"tidy_data/safety_tidy.csv")

# seasons.csv

seasons <- read_csv("old_data/seasons.csv")
colnames(seasons) <- snakecols(seasons)
seasons <- seasons %>% 
  rename(season_url = url)

# write_csv(seasons,"tidy_data/seasons_tidy.csv")

# sprint_results.csv

sprint_results <- read_csv("old_data/sprint_results.csv")
colnames(sprint_results) <- snakecols(sprint_results)
sprint_results <- sprint_results %>% 
  rename(sprint_result_id = result_id)

# write_csv(sprint_results,"tidy_data/sprints_tidy.csv")

# status.csv

status <- read_csv("old_data/status.csv")
colnames(status) <- snakecols(status)

# write_csv(status,"tidy_data/status_tidy.csv")

# tyres_hybrid.csv

tyres_hybrid <- read_csv("old_data/tyres_hybrid.csv")
colnames(tyres_hybrid) <- snakecols(tyres_hybrid)
tyres_hybrid <- tyres_hybrid %>% 
  rename(race_name = name) %>% 
  fill(c(year:race_name)) %>% # fill down missing values
  mutate(driver_name = stri_trans_general(driver_name,id="Latin-ASCII")) %>%# drop diacritics
  left_join(drivers) %>% # for driver id from driver_name
  select(!c(driver_ref:driver_url)) %>% # fluff from drivers
  left_join(races) %>% # race name from year and round
  select(!c(circuit_id:sprint_time)) %>% # fluff from drivers
  pivot_longer( 
    cols = stint1:stint7,
    names_prefix = "stint",
    names_to = "stint",
    values_to = "compound_and_length", # separate below
    values_drop_na = T
  ) %>% 
  separate(
    col = compound_and_length,
    into = c("stint_comp","stint_length"),
    sep = "\\("
  ) %>% 
  mutate(stint_length = as.numeric(str_remove(stint_length,"\\)"))) %>% 
  mutate(stint_comp = trimws(stint_comp)) %>%
  mutate(stint_id = row_number()) %>% 
  mutate(driver_id = case_when( # fill in mismatched driver ids
    driver_name == "Carlos Sainz Jnr" ~ 832, 
    driver_name == "Nyck De Vries" ~ 856,
    driver_name == "Zhou Guanyu" ~ 855,
    T ~ driver_id
  ))

# write_csv(tyres_hybrid,"tidy_data/tyres_tidy.csv")

# weather_hybrid.csv

weather_hybrid <- read_csv("old_data/weather_hybrid.csv")
colnames(weather_hybrid) <- snakecols(weather_hybrid)
weather_hybrid <- weather_hybrid %>% 
  rename(race_name = name) %>% 
  left_join(races) %>% 
  select(!c(circuit_id:sprint_time)) 

# write_csv(weather_hybrid,"tidy_data/weather_tidy.csv")
