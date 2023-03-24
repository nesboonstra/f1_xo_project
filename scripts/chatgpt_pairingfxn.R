## Chat (edited)
# Get unique race IDs
race_ids <- unique(laps_hybrid$race_id)

# Create an empty data frame to store the driver pairs
driver_pairs <- data.frame(matrix(ncol = 4, nrow = 0))
colnames(driver_pairs) <- c("race_id", "lap_number", "driver_1", "driver_2")

# Loop over each race
for (race_id in race_ids) {
  # Get lap data for the current race
  race_data <- laps_hybrid %>%
    filter(race_id == .data$race_id)
  
  # Get unique driver IDs for the current race
  driver_ids <- unique(race_data$driver_id)
  
  # Loop over each lap
  for (lap_number in 1:max(race_data$lap_number)) {
    # Get lap data for the current lap
    lap_data <- race_data %>%
      filter(lap_number == .data$lap_number)
    
    # Create a data frame of driver pairs for the current lap
    lap_pairs <- expand.grid(driver_1 = driver_ids, driver_2 = driver_ids)
    lap_pairs <- lap_pairs %>%
      filter(driver_1 != driver_2)
    lap_pairs$race_id <- race_id
    lap_pairs$lap_number <- lap_number
    
    # Add the current lap's driver pairs to the main data frame
    driver_pairs <- rbind(driver_pairs, lap_pairs)
  }
}

# Sort by race ID, lap number, and driver pair
driver_pairs <- driver_pairs %>%
  arrange(race_id, lap_number, driver_1, driver_2)