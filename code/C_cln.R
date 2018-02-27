get_suburb <- function(FILE_NAME = "Niteroi_occurrences.csv") {
  library(rjson)
  DEFAULT_URL <- 'http://nominatim.openstreetmap.org/reverse?format=json&lat=<<LAT>>&lon=<<LON>>&zoom=18&addressdetails=1'
  result_data <- data.frame(stringsAsFactors=FALSE)
  data <- read.csv(FILE_NAME)
  suburb <- 'DEFAULT'
  temp_dataframe <- data.frame()
  llat <- 0 #last latitude
  llon <- 0 #last longitude
  for(i in 1:length(data$latitude))
  {
    temp_dataframe <- data[i,]
    nlat <- data[i,]$latitude #new latitude
    nlon <- data[i,]$longitude #new longitude
    if(nlat == llat && nlon == llon)
    {
      temp_dataframe <- cbind(temp_dataframe, suburb)
      result_data <- rbind(result_data, temp_dataframe)
      next
    }
    llat <- nlat
    llon <- nlon
    URL <- gsub('<<LAT>>', llat, DEFAULT_URL)
    URL <- gsub('<<LON>>', llon, URL)
    result <- fromJSON(readLines(URL, warn = FALSE)[1])
    suburb <- as.character(result$address$suburb)
    if(identical(suburb, character(0)))
      suburb <- NA    
    temp_dataframe <- cbind(temp_dataframe, suburb)
    result_data <- rbind(result_data, temp_dataframe)
    print(i)
  }
  colnames(result_data) <- c(names(data), 'suburb')
  FILE_NAME <- strsplit(FILE_NAME, "[.]")[[1]][1]
  write.csv(result_data, paste(FILE_NAME, "_suburb.csv", sep=""))
}