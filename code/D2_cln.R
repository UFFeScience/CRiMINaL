

#The file must be inside the folder with the script
get_neighbourhoods <- function(FILE_NAME = "nearby_location.csv")
{
  library(rjson)
  unwanted_array = list('S'='S', 's'='s', 'Z'='Z', 'z'='z', 'À'='A', 'Á'='A', 'Â'='A', 'Ã'='A', 'Ä'='A',
                        'Å'='A', 'Æ'='A', 'Ç'='C', 'È'='E', 'É'='E','Ê'='E', 'Ë'='E', 'Ì'='I', 'Í'='I',
                        'Î'='I', 'Ï'='I', 'Ñ'='N', 'Ò'='O', 'Ó'='O', 'Ô'='O', 'Õ'='O', 'Ö'='O', 'Ø'='O',
                        'Ù'='U','Ú'='U', 'Û'='U', 'Ü'='U', 'Ý'='Y', 'Þ'='B', 'ß'='Ss', 'à'='a', 'á'='a',
                        'â'='a', 'ã'='a', 'ä'='a', 'å'='a', 'æ'='a', 'ç'='c','è'='e', 'é'='e', 'ê'='e',
                        'ë'='e', 'ì'='i', 'í'='i', 'î'='i', 'ï'='i', 'ð'='o', 'ñ'='n', 'ò'='o', 'ó'='o',
                        'ô'='o', 'õ'='o','ö'='o', 'ø'='o', 'ù'='u', 'ú'='u', 'û'='u', 'ý'='y', 'ý'='y',
                        'þ'='b', '`'='', '´'='', '^'='', 'ª'='', 'º'='', '~'='', '"'='', 'ü' = 'u',
                        '½'='1/2', '¾'='3/4', '¼'='1/4', '»'='>>', '¿'='?', 'ø'='o', '«'='<<', '¨'='', '¡'='!',
                        '¹'='1', '²'='2', '³'='3', '£'='', '¢'='c', '¬'='', '§'='', '°'='', '|'='',
                        '\\n'= ' ', '\\t' = ' ', '\\r' = ' ')
  lat <- 0
  lon <- 0
  DEFAULT_URL <- 'http://nominatim.openstreetmap.org/reverse?format=json&lat=<<LAT>>&lon=<<LON>>&zoom=18&addressdetails=1'
  result_data <- data.frame(stringsAsFactors=FALSE)
  data <- read.csv(FILE_NAME, nrow = 5000)
  suburb <- 'DEFAULT'
  for(i in 1:nrow(data))
  {
    new_lat <- data[i,]$latitude
    new_lon <- data[i,]$longitude
    if(new_lat == lat & new_lon == lon)
    {
      result_data <- rbind(result_data, data.frame(suburb))
      next
    }
    print(i)
    lat <- new_lat
    lon <- new_lon
    URL <- gsub('<<LAT>>', lat, DEFAULT_URL)
    URL <- gsub('<<LON>>', lon, URL)
    #print(URL)
    result <- fromJSON(readLines(URL)[1])
    suburb <- as.character(result$address$suburb)
    for(i in seq_along(unwanted_array))
      suburb <- gsub(names(unwanted_array)[i],unwanted_array[i],suburb)
  }
  colnames(result_data) <- 'suburb'
  data <- cbind(data, result_data)
  write_utf8_csv(data, 'nearby_locations_plus_neighbourhoods.csv')
  #write.csv(data, 'nearby_locations_plus_neighbourhoods.csv')
}

write_utf8_csv <- 
  function(df, file){
    firstline <- paste(  '"', names(df), '"', sep = "", collapse = " , ")
    char_columns <- seq_along(df[1,])[sapply(df, class)=="character"]
    for( i in  char_columns){
      df[,i] <- toUTF8(df[,i])
    }
    data <- apply(df, 1, function(x){paste('"', x,'"', sep = "",collapse = " , ")})
    writeLines( c(firstline, data), file , useBytes = T)
  }