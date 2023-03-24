library(tidyverse)
library(dm)

#### Data Modelling ####

initial_dm <- dm(
  circuits,constructor_results,constructor_standings,
  constructors,driver_standings,drivers,lap_times,
  pit_stops,qualifying,races,results,safety_hybrid,
  seasons,sprint_results,status,tyres_hybrid,weather_hybrid
)

pks_dm <- initial_dm %>% 
  dm_add_pk(circuits,circuit_id) %>% 
  dm_add_pk(constructor_results,constructor_results_id) %>% 
  dm_add_pk(constructor_standings,constructor_standings_id) %>% 
  dm_add_pk(constructors,constructor_id) %>% 
  dm_add_pk(driver_standings,driver_standings_id) %>% 
  dm_add_pk(drivers,driver_id) %>% 
  dm_add_pk(lap_times,lap_id) %>% 
  dm_add_pk(pit_stops,stop_id) %>% 
  dm_add_pk(qualifying,qualify_id) %>% 
  dm_add_pk(races,race_id) %>% 
  dm_add_pk(results,result_id) %>% 
  dm_add_pk(safety_hybrid,safety_id) %>% 
  dm_add_pk(seasons,year) %>% 
  dm_add_pk(status,status_id) %>% 
  dm_add_pk(sprint_results,sprint_result_id) %>% 
  dm_add_pk(weather_hybrid,race_id) %>% 
  dm_add_pk(tyres_hybrid,stint_id)

xo_dm <- pks_dm %>% 
  dm_add_fk(weather_hybrid,year,seasons) %>% 
  dm_add_fk(weather_hybrid,race_id,races) %>% 
  dm_add_fk(qualifying,race_id,races) %>% 
  dm_add_fk(qualifying,driver_id,drivers) %>% 
  dm_add_fk(qualifying,constructor_id,constructors) %>% 
  dm_add_fk(lap_times,race_id,races) %>% 
  dm_add_fk(lap_times,driver_id,drivers) %>%
  dm_add_fk(lap_times,circuit_id,circuits) %>%
  dm_add_fk(sprint_results,race_id,races) %>% 
  dm_add_fk(sprint_results,driver_id,drivers) %>% 
  dm_add_fk(sprint_results,constructor_id,constructors) %>% 
  dm_add_fk(sprint_results,status_id,status) %>% 
  dm_add_fk(constructor_standings,race_id,races) %>% 
  dm_add_fk(constructor_standings,constructor_id,constructors) %>% 
  dm_add_fk(constructor_results,race_id,races) %>% 
  dm_add_fk(constructor_results,constructor_id,constructors) %>% 
  dm_add_fk(races,year,seasons) %>% 
  dm_add_fk(races,circuit_id,circuits) %>%
  dm_add_fk(tyres_hybrid,year,seasons) %>% 
  dm_add_fk(tyres_hybrid,driver_id,drivers) %>% 
  dm_add_fk(tyres_hybrid,race_id,races) %>% 
  dm_add_fk(results,race_id,races) %>% 
  dm_add_fk(results,driver_id,drivers) %>% 
  dm_add_fk(results,constructor_id,constructors) %>% 
  dm_add_fk(driver_standings,driver_id,drivers) %>% 
  dm_add_fk(driver_standings,race_id,races) %>% 
  dm_add_fk(safety_hybrid,year,seasons) %>% 
  dm_add_fk(safety_hybrid,race_id,races) %>% 
  dm_add_fk(pit_stops,race_id,races) %>% 
  dm_add_fk(pit_stops,driver_id,drivers)



dm_draw(pks_dm,view_type="all")
dm_draw(
  xo_dm,
  #view_type="all",
  rankdir="TB",
  column_types = T
)
