library(dplyr)
library(lubridate)

# Loop through to add name column and bind the data frames

aggregateBlast <- function(dataDir){
  
  aggregateBlastFrame <- data.frame()
  
  setwd(dataDir)
  
  fileList <- list.files()
  
  # Read in csv and add in name var
  for (i in fileList) {
    tempFrame <- read.csv(i, skip = 7)
    nameSplit <- strsplit(i, split = " ")
    tempFrame[,"Name"] <- nameSplit[[1]][2]
    aggregateBlastFrame <- rbind(aggregateBlastFrame,tempFrame)
  }
  
  return(aggregateBlastFrame)
  
}


# Cleaning takes blast frame as parm and updates dates and names to datetime and factors respectively

blastClean <- function(blastFrame){
  
  blastFrame$fullDate <- mdy_hms(blastFrame$Date)
  blastFrame$Date <- date(blastFrame$fullDate)
  blastFrame$Name <- factor(blastFrame$Name)
  
}



