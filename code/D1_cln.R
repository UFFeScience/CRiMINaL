#
# Clube de Ci?ncia de Dados - UFF (CCD-UFF)
# Author: V?tor Louren?o
#
# Last modified: 2015/10/01
#
# This script has the objective to discretize date and time
#

nearby_location <- function(distance = 0.5, #distance in km
                            occurrences_path = "Niteroi_occurrences.csv",
                            locations_path   = "geo_places.csv",
                            output           = "nearby_location.csv") {
  
  haversine <- function(lat1, long1, lat2, long2) {
    R <- 6371 # Earth mean radius [km]
    lat1 <- (lat1*pi/180)
    lat2 <- (lat2*pi/180)
    long1 <- (long1*pi/180)
    long2 <- (long2*pi/180)
    delta.long <- (long2 - long1)
    delta.lat <- (lat2 - lat1)
    a <- sin(delta.lat/2)^2 + cos(lat1) * cos(lat2) * sin(delta.long/2)^2
    c <- 2 * asin(min(1,sqrt(a)))
    d = R * c
    return(d) # Distance in km
  }
  occ_db <- read.csv(occurrences_path)
  loc_db <- read.csv(locations_path)
  new_db <- data.frame()
  for (i in 1:length(occ_db$latitude)) {
    for (j in 1:length(loc_db$latitude)) {
      if(haversine(occ_db[i,]$latitude, occ_db[i,]$longitude,
                   loc_db[j,]$latitude, loc_db[j,]$longitude) <= distance) {
        location_list <- occ_db[i,]
        location_list <- cbind(location_list, nearby_location = loc_db[j,]$type)
        new_db <- rbind(new_db, location_list)
      }
    }
  }
  write.csv(new_db, output)
}