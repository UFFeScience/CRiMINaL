#
# Clube de Ciência de Dados - UFF (CCD-UFF)
# Author: Vítor Lourenço
#
# Last modified: 2015/10/01
#
# This script has the objective to discretize date and time
#

time_discretize <- function(dataset_path = "nearby_location.csv", out = "time_discretize_nit.csv") {
  
  nearby_location_db <- read.csv(dataset_path)
  new_db <- data.frame()
  header_names <- colnames(nearby_location_db)
  for (i in 1:length(nearby_location_db$n_occurrence)) {
    #date
    for(j in 1:length(header_names)) {
      if(colnames(nearby_location_db[j]) == "date") {
        new_line <- nearby_location_db[i, 1:j - 1]
        break
      }
    }
    x <- toString(nearby_location_db[i,]$date)
    x <- weekdays(as.Date(x,'%Y-%m-%d'))
    if (x == "domingo" || x == "sábado") {
      x <- "weekend"
    } else {
      x <- "business_day"
    }
    new_line <- cbind(new_line, date = x)
    #time
    x <- toString(nearby_location_db[i,]$time)
    x <- strsplit(x, ":")[[1]]
    x <- as.numeric(x[1])
    if(x >= 0 && x < 6) {
      new_line <- cbind(new_line, time = "dawn")
    } else if(x >= 6 && x < 12) {
      new_line <- cbind(new_line, time = "morning")
    } else if(x >= 12 && x < 18) {
      new_line <- cbind(new_line, time = "evening")
    } else if(x >= 18 && x < 24) {
      new_line <- cbind(new_line, time = "night")
    }
    new_line <- cbind(new_line, nearby_location = nearby_location_db[i,]$nearby_location)
    new_db <- rbind(new_db, new_line)
  }
  #drop_col <- c("","X","X.1") #drop some random column
  #new_db <- new_db[,!(names(new_db) %in% drop_col)]
  #print(paste("All the ", i, " are completed"))
  write.csv(new_db, out)
}