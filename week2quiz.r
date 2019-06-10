## install.packages("data.table")
library("data.table")

pollutantmean <- function(directory, pollutant, id = 1:332) {
  
  # Format number with fixed width and then append .csv to number
  fileNames <- paste0(directory, '/', formatC(id, width=3, flag="0"), ".csv" )
  
  # Reading in all files and making a large data.table
  lst <- lapply(fileNames, data.table::fread)
  dt <- rbindlist(lst)
  
  if (c(pollutant) %in% names(dt)){
    return(dt[, lapply(.SD, mean, na.rm = TRUE), .SDcols = pollutant][[1]])
  } 
}

# Example usage
pollutantmean(directory = "specdata", pollutant = 'sulfate', id = 34)

cc <- complete("specdata", c(6, 10, 20, 34, 100, 200, 310))
print(cc$nobs)

complete <- function(directory,  id = 1:332) {
  
  # Format number with fixed width and then append .csv to number
  fileNames <- paste0(directory, '/', formatC(id, width=3, flag="0"), ".csv" )
  
  # Reading in all files and making a large data.table
  lst <- lapply(fileNames, data.table::fread)
  dt <- rbindlist(lst)
  
  return(dt[complete.cases(dt), .(nobs = .N), by = ID])
  
}


# Jansen A. Simanullang, 20.02.2016
# complete.R
# example usage:
#> setwd("[this source code directory path]")
#> source("complete.R")
#> complete("specdata", c(6, 10, 20, 34, 100, 200, 310))
#> complete("specdata", 54)
#> complete("specdata", 332:1)
#--------------------------------

complete <- function(directory, id = 1:332) {
  
  # 'complete'
  # computes the number of observations with complete result, with no 'NA' values
  # as a function of 'directory', 'pollutant' and 'id'
  # 'directory' is location of the CSV files
  # 'id' is the id of each file
  #---------------------------------------------------------
  # 1. list all the files inside directory
  
  csv_files <- list.files(directory, full.names = TRUE)
  
  # 2. initialize the data frame 'z' with 0 columns and 0 rows
  
  z <- data.frame()
  
  # 3. loop for each file id
  # 3.1 Read the file
  # 3.2 count the number of complete cases 'nobs',
  # 3.3 make a new dataframe 'y' to show the number of observations
  # 3.4 bind it to our data frame 'z'
  
  for (i in id) {
    
    x <- read.csv(csv_files[i])
    nobs <- sum(complete.cases(x))
    y <- data.frame(i, nobs)
    z <- rbind(z, y)
  }
  
  
  # 4. label column names of our data frame 'z'
  
  colnames(z) <- c("id", "nobs")
  
  # 5. Return data frame 'z'
  # which output looks like:
  # id nobs
  # 1  117
  # 2  1041
  # ...
  
  return(z)
}
# corr
# example usage:
#> setwd("[this source code directory path]")
#> source("corr.R")
#> corr("specdata")
#> corr("specdata", 129)
#> corr("specdata", 2000)
#> corr("specdata", 1000)
#> corr("specdata", 1094)
#> corr("specdata", 1095)
#--------------------------------

corr <- function(directory, threshold = 0) {
  
  # 'complete'
  # computes the correlation between nitrate and sulfate
  # as a function of 'directory', and 'threshold';
  # 'directory' is location of the CSV files;
  # 'id' is the id of each file;
  # 'threshold' is the number of completely observed observations (on all variables),
  #  the default 'threshold' is 0.
  #---------------------------------------------------------
  # 1. list all the files inside directory
  
  csv_files <- list.files(directory, full.names = TRUE)
  
  # 2. initialize the numeric vector 'v' with 0 length
  
  v <- vector(mode = "numeric", length = 0)
  
  # 3. loop for each file id
  
  for (i in 1:length(csv_files)) {
    
    # 3.1 Read the file;
    x <- read.csv(csv_files[i])
    
    # 3.2 count the number of complete cases 'csum';
    csum <- sum(complete.cases(x))
    
    # 3.3 check if 'csum' is greather than threshold;
    if (csum > threshold) {
      
      # 3.3.1 create 'xSulfate'
      # select from 'x' which has complete sulfate data
      # which does not contain 'na' values in sulfate data
      xSulfate <- x[which(!is.na(x$sulfate)), ]
      
      # 3.3.2 create 'xPollutant' 
      # select from 'xSulfate' which also has complete nitrate data
      # which also does not contain 'na' values in nitrate data
      xPollutant <- xSulfate[which(!is.na(xSulfate$nitrate)), ]
      
      # 3.3.3 update vector 'v'
      # 'cor' function is used to compute the correlation value
      v <- c(v, cor(xPollutant$sulfate, xPollutant$nitrate))
      
    }
  }
  
  return(v)
}
