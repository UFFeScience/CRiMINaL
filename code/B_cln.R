#
# Clube de Ciência de Dados - UFF (CCD-UFF)
# Author: Paulo Roberto Mann Marques Junior
#
# Last modified: 2015/06/16
#
# This script has the objective to get all the occurrences that is from a generic city.
#
getOccurrences <- function(CITY = "Niteroi")
{
  # Args:
  #   CITY = "Niteroi" : It's the city to filter by. 
  #                     (doesn't matter if the word is lower or upper case or have accents)
  # Returns:
  #   A .csv file containing all the occurrences in the parameter city.
  #   Note 1: The csv file is written in the actual working directory.
  #   Note 2: In order to execute this algorithm YOU MUST have an "ondefuiroubado_occurrences"
  #           directory(inside your working directory) containing all the csv files with
  #           all the occurrences csv's.
  DEFAULT_PATH <- getwd()
  OCCURRENCES_PATH <- "ondefuiroubado_occurrences"
  NEW_PATH <- paste(DEFAULT_PATH, OCCURRENCES_PATH, sep="/")
  print(NEW_PATH)

  #This map is used to remove accents.
  unwanted_array = list('S'='S', 's'='s', 'Z'='Z', 'z'='z', 'À'='A', 'Á'='A', 'Â'='A', 'Ã'='A', 'Ä'='A',
                        'Å'='A', 'Æ'='A', 'Ç'='C', 'È'='E', 'É'='E','Ê'='E', 'Ë'='E', 'Ì'='I', 'Í'='I',
                        'Î'='I', 'Ï'='I', 'Ñ'='N', 'Ò'='O', 'Ó'='O', 'Ô'='O', 'Õ'='O', 'Ö'='O', 'Ø'='O',
                        'Ù'='U','Ú'='U', 'Û'='U', 'Ü'='U', 'Ý'='Y', 'Þ'='B', 'ß'='Ss', 'à'='a', 'á'='a',
                        'â'='a', 'ã'='a', 'ä'='a', 'å'='a', 'æ'='a', 'ç'='c','è'='e', 'é'='e', 'ê'='e',
                        'ë'='e', 'ì'='i', 'í'='i', 'î'='i', 'ï'='i', 'ð'='o', 'ñ'='n', 'ò'='o', 'ó'='o',
                        'ô'='o', 'õ'='o','ö'='o', 'ø'='o', 'ù'='u', 'ú'='u', 'û'='u', 'ý'='y', 'ý'='y',
                        'þ'='b', 'ÿ'='y', '`'='', '´'='', '^'='', 'ª'='', 'º'='', '~'='', '"'='', 'ü' = 'u',
                        '½'='1/2', '¾'='3/4', '¼'='1/4', '»'='>>', '¿'='?', 'ø'='o', '«'='<<', '¨'='', '¡'='!',
                        '¹'='1', '²'='2', '³'='3', '£'='', '¢'='c', '¬'='', '§'='', '°'='', '|'='',
                        '\\n'= ' ', '\\t' = ' ', '\\r' = ' ')
  library(stringr)
  library(gdata)
  
  #Remove accents from the CITY parameter
  for(q in seq_along(unwanted_array))
    CITY <- gsub(names(unwanted_array)[q], unwanted_array[q], CITY)
  
  data <- data.frame()
  files <- list.files(path = NEW_PATH, pattern = "*.csv")
  result_data <- data.frame()
  
  
  for(v in 1:length(files))
  {
    print(files[v])
    data <- read.csv(paste(NEW_PATH, files[v], sep="/"), strip.white = TRUE)
    
    for(i in 1:nrow(data))
    {
      #CITY PART
      city <- as.character(data[i, "city"])
      city <- trim(city)
      #Remove accents
      for(j in seq_along(unwanted_array))
        city <- gsub(names(unwanted_array)[j],unwanted_array[j], city)
      if(tolower(city) != tolower(CITY))
        next
      #END CITY PART
      
      data_row <- data.frame()
      n_occurrence <- data[i,"n_occurrence"]
      latitude <- data[i, "latitude"]
      longitude <- data[i, "longitude"]
      occurrence_type <- data[i, "occurrence_type"]
      
      #OBJECTS
      object_names <- colnames(data)
      objects <- c()
      for(k in 8:26)
      {
        objects <- cbind(objects, data[i,k])
      }
      colnames(objects) <- object_names[8:26]
      #END OBJECTS
      
      #DATE AND TIME
      date_time <- as.character(data[i,"date_time"])
      date_time <- trim(date_time)
      time <- strsplit(date_time, split=" ")[[1]][2]
      date <- as.Date(strsplit(date_time, split=" ")[[1]][1], "%d/%m/%Y")
      #END DATE AND TIME
      
      data_row <- data.frame(n_occurrence, latitude, longitude, city, occurrence_type, objects, date, time)
      result_data <- rbind(result_data, data_row)
    }
  }
  file_name <- paste(paste(CITY, "occurrences", sep="_"), ".csv", sep="")
  write.csv(result_data, file_name)
  setwd(DEFAULT_PATH)
}