#### Preamble ####

library(tidyverse)
library(snakecase)

snakecols <- function(x){
  to_snake_case(colnames(x),numerals="left")
  }


#### Reading in #### 

lap_times <- read_csv("data/lap_times.csv")
colnames(lap_times) <- snakecols(lap_times)

drivers <- read_csv("data/drivers.csv")
colnames(drivers) <- snakecols(drivers)

results <- read_csv("data/results.csv")
colnames(results) <- snakecols(results)

pit_stops <- read_csv("data/pit_stops.csv")
colnames(pit_stops) <- snakecols(pit_stops)

status <- read_csv("data/status.csv")
colnames(status) <- snakecols(status)

races <- read_csv("data/races.csv")
colnames(races) <- snakecols(races)

constructors <- read_csv("data/constructors.csv")
colnames(constructors) <- snakecols(constructors)

circuits <- read_csv("data/circuits.csv")
colnames(circuits) <- snakecols(circuits)

races <- races %>% 
  mutate(circuit_id = case_when(
    name == "Sakhir Grand Prix" ~ 99,
    T ~ circuit_id
  ))

circuits <- circuits %>% 
  mutate(circuit_id = case_when(
    name == "Sakhir Grand Prix" ~ 99,
    T ~ circuit_id
  ))


#### GPT ####

### Pairing code


races_hybrid <- races %>% 
  filter(year>=2014 & year<=2022) %>% 
  filter(race_id != 1063) # 2021 Belgian GP

races_hybrid_weather <- read_csv("data/races_hybrid_weather.csv")

## Prep
laps_clean <- lap_times %>% 
  rename(lap_number = lap) %>% 
  rename(position_lap = position) %>% 
  rename(milli_lap = milliseconds)

results_clean <- results %>% 
  rename(position_final = position) %>% 
  rename(milli_final = milliseconds) %>% 
  mutate(milli_final = as.numeric(milli_final))


hybrid_join <- lap_times %>% 
  select(!time) %>% # remove that stupid character lap time, just keep milli
  rename(milli_lap = milliseconds) %>% # multiple dfs use milliseconds name
  right_join(races_hybrid_weather) %>% # right join to only keep hybrid era
  select(!c(name:sprint_time)) %>% # unnecessary cols
  left_join(pit_stops, by=c("race_id","driver_id","lap")) %>% # pit stops
  rename(milli_pit = milliseconds) %>% # length of pit stop, but I remove this col
  mutate(pit_dummy = case_when( # did they stop this lap
    is.na(stop) == 1 ~ 0,
    T ~ 1
  )) %>% 
  select(!c(time:duration)) %>% # unnec. cols from pits
  group_by(race_id,driver_id) %>% fill(stop) %>% ungroup() %>% # fill in # stops
  mutate(stop = replace_na(stop,0)) %>% 
  rename(pit_stops = stop) %>% # rename # stops
  select(!milli_pit) # there you go -- length of pit stop
 

hybrid_join_write <- hybrid_join %>% 
  left_join(drivers) %>% 
  select(!c(dob:url)) %>% 
  left_join(races) %>% 
  select(!c(date:sprint_time))



# rm(list=setdiff(ls(),"hybrid_join"))


