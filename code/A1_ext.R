#
# Clube de Ciência de Dados - UFF (CCD-UFF)
# Author: Marcelo A. R. d'Almeida
#
# Last modified: 2015/04/19
#
# This script has the objective to extract the data from 'ondefuiroubado' site
#

extract_data <- function(first_element = 1,
                         last_element  = "ALL", 
                         repair        = FALSE, 
                         update        = FALSE, 
                         sample        = 1000) {
    
    
    #
    # Args:
    #   first_element = 1     : points out the first element to start the 
    #                           sweeping
    #   last_element  = "ALL" : points out the last element which will stop the
    #                           sweeping
    #   repair        = FALSE : points out if the script will only try to 
    #                           repair the missing elements
    #   update        = FALSE : points out if the script will only sweep from 
    #                           the last recorded element
    #   sample        = 1000  : points out the numbers of elements to record in
    #                           each .csv file 
    #
    # Returns:
    #   Several files with the retrieved data and several log files with the 
    #   outcome
    #
    #
    # Strong Points:
    #   - Stores the entire data in a relatively regular small data packages 
    #     (Default: 1000)
    #   - Enables partial data retrieving (first-to-last element sweep)
    #   - Enables repairing the gathered data
    #   - Enables incremental updates to gathered data
    #   - Stores log information
    #   - Organize the retrieved data and log in directory tree (folders)
    #   - Handles stolen objects list to distinct variables 
    #     (* Bernardo Costa Amaral *)
    #   - Handles possible missing value in occurrence description
    #   - Error threshold to interrupt sweeping after too much error
    #   - Handles errors to allow 'uninterrupted' sweeping 
    #   - File names contains date-time information
    #    
    
    getStolen <- function(objects, options) {
        # convert list of characters of stolen objects into a Boolean vector
        #
        # Args:
        #   objects: a list of characters representing all stolen objects
        #   options: a vector of characters representing all possible  stolen objects
        #
        # Returns:
        #   A Boolean vector representing the stolen vector
        
        res <- c()
        for (obj in options){
            res <- c(res, any(objects == obj))
        }
        return(res)
    }
    
    
    library(XML)
    dataset <- data.frame()
    dataset_log <- data.frame()
    occurrence_data <- data.frame()
    
    DEFAULT_PATH <- getwd()
    OCCURRENCES_PATH <- "ondefuiroubado_occurrences"
    OCCURRENCES_LOG_PATH <- "ondefuiroubado_occurrences/LOG"
    BASE_URL <- "http://www.ondefuiroubado.com.br/denuncias/"
    NEW_OCCURRENCE_URL <- 
        "http://www.ondefuiroubado.com.br/rio-de-janeiro/RJ/nova-denuncia"
    
    new_occurrence_page <- htmlTreeParse(NEW_OCCURRENCE_URL, 
                                         useInternalNodes = TRUE, 
                                         encoding = "UTF-8")
    ALL_OBJECTS <- xpathSApply(new_occurrence_page, 
                               "//*[@class=\"nr-obj-name\"]", 
                               xmlValue)
    
    ERROR_THRESHOLD <- sample
    consecutive_error_count <- 0

    end_of_pages <- FALSE
    
    missing_value <- list()
    
    if (!file.exists(OCCURRENCES_PATH)) {
        dir.create(OCCURRENCES_PATH)
        dir.create(OCCURRENCES_LOG_PATH)
    }
    
    if (update) {
        file <- tail(list.files(), 1)
        first_element <- as.numeric(read.csv(file, 
                            skip = length(readLines(file)) - 1, 
                            header = FALSE)[2]) + 1
    }
    
    if (repair) {
        setwd(paste(DEFAULT_PATH, "/", OCCURRENCES_PATH, sep = ""))
        files <- list.files(pattern = "occurrence")
        numbers_fixed <- c()
        for (file in files) {
            numbers_fixed <- c(numbers_fixed, 
                               as.vector(unique(read.csv(file)[, 2])))
            
        }
    }
    
    n <- first_element
    start_index <- n
    
    
    while (ifelse(last_element == "ALL", 
                 (!end_of_pages), 
                 (!end_of_pages && (n <= last_element)))) {
        result <- tryCatch( {
            
            if (repair) {
                while (n == numbers_fixed[1] 
                       && !identical(numbers_fixed, integer(0))) {
                    if (n < last_element) {
                        n <- n + 1                        
                    }
                    numbers_fixed <- numbers_fixed[-1]
                }
            }
            
            url <- paste(BASE_URL, n, sep = "")
            
            # Retrieve the entire html page
            html <- htmlTreeParse(url, useInternalNodes = TRUE, 
                                  encoding = "UTF-8")
              
            # Retrieve field values with xpath notation
            n_occurrence           <- xpathSApply(html, 
                                        "//*[@id=\"id_report\"]", 
                                        xmlValue)
            latitude               <- xpathSApply(html, 
                                        "//*[@id=\"lat\"]", 
                                        xmlValue)
            longitude              <- xpathSApply(html, 
                                        "//*[@id=\"lng\"]", 
                                        xmlValue)
            city                   <- xpathSApply(html, 
                                        "//*[@class=\"hc-city-name\"]",
                                        xmlValue)
            occurrence_type        <- xpathSApply(html, 
                                        "//*[@class=\"sd-info-type\"]",
                                        xmlValue)
            occurrence_title       <- xpathSApply(html, 
                                        "//*[@class=\"sd-info-title\"]",
                                        xmlValue)
            spoil                  <- xpathSApply(html, 
                                        "//*[@class=\"obj-label valign-middle\"]",
                                        xmlValue)
            
            date_time              <- xpathSApply(html, 
                                        "//*[@class=\"sd-info-data-hora\"]",
                                        xmlValue)    
            occurrence_description <- xpathSApply(html, 
                                        "//*[@class=\"description valign-top\"]", 
                                        xmlValue)
            
            # Convert all possible stolen objects to distinct variables
            spoil <- getStolen(spoil, ALL_OBJECTS)
            spoil <- as.data.frame(t(spoil))
            
            # There is some occurrences that description is missing
            if (identical(occurrence_description, missing_value)) {
                occurrence_description <- NA
            }
                         
            # organize the data retrieved
            occurrence_data <- data.frame(n_occurrence, latitude, longitude, 
                                          city, occurrence_type, 
                                          occurrence_title, spoil, 
                                          date_time, occurrence_description)
                                     
        }, warning = function(w) {
            ##warning-handler-code
        }, error = function(e) {
            print(paste("\\", e, "\\"))
            return(paste("UNHANDLED_ERROR:", e))
        })
        
        # Code to handle error
        suppressWarnings(
        if (grepl("UNHANDLED_ERROR", result)) {
            dataset_log <- rbind(dataset_log, data.frame(
                LOG = paste(n, " [UNHANDLED_ERROR] ", result, 
                            " TimeStamp: ", Sys.time()),
                stringsAsFactors = FALSE))
            print(result)
            consecutive_error_count <- consecutive_error_count + 1
        } else {
            consecutive_error_count <- 0   
        }
        )
        
        if (consecutive_error_count == ERROR_THRESHOLD){
            end_of_pages <- TRUE
        }   
        
        dataset_log <- rbind(dataset_log, data.frame(LOG = 
            paste("occurrence ", n, " read.", " TimeStamp: ",Sys.time())
                , stringsAsFactors = FALSE))
        print(paste("occurrence ", n, " read"))
        dataset <- rbind(dataset, occurrence_data)    
             
        if (((n %% sample) == 0) || end_of_pages || (n == last_element)) {
            
            # Fix the possible stolen names            
            first_p_s_o_position <- grep("V1", names(dataset), fixed = TRUE)[1]
            ## 'first_p_s_o_position' means first possible stolen object 
            ## position on dataframe
            names(dataset)[first_p_s_o_position:(length(ALL_OBJECTS) - 1 +
                            first_p_s_o_position)] <- t(ALL_OBJECTS)
            
            names(dataset) <- tolower(names(dataset))
            names(dataset) <- iconv(names(dataset), from = "UTF-8",
                                    to = "ASCII//TRANSLIT") 
            names(dataset) <- gsub(" ", "_", names(dataset))
            
            
            time <- gsub(":", "-", Sys.time())
            setwd(paste(DEFAULT_PATH, "/", OCCURRENCES_PATH, sep = ""))
            write.csv(dataset, 
                      paste("ondefuiroubado_occurrences ", start_index, 
                            " - ", n, ". TimeStamp ", time ,".csv", sep = ""))
            
            setwd(paste(DEFAULT_PATH, "/", OCCURRENCES_LOG_PATH, sep = ""))
            write.table(dataset_log, 
                        paste("[LOG]ondefuiroubado_occurrences ", start_index, 
                              " - ", n, ". TimeStamp ", time ,".txt", sep = ""))
            
            dataset <- data.frame()
            dataset_log <- data.frame()
            
            start_index <- n + 1
        }
                 
        n <- n + 1
    } 
    
    # Set the working directory to original one
    setwd(DEFAULT_PATH)
}