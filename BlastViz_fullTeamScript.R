# Input is the selection of the BlastMergingCleaning.R file
source(file.choose())
library(Rmisc)
library(dplyr)
library(ggplot2)
library(tidyr)
library(magrittr)
library(ggalt)
library(tibble)
library(gridExtra)
library(grid)
library(easycsv)
library(gridExtra)

# Aggregate team df for the averages and to subset by player
# Input is a prompt to select the folder with all of the player files
team <- aggregateBlast(choose_dir())
team <- blastClean(team)
team <- team %>%
  drop_na(On.Plane.Efficiency....) %>%
  drop_na(Bat.Speed..mph.) %>%
  drop_na(Time.to.Contact..sec.) %>%
  drop_na(Vertical.Bat.Angle..deg.) %>%
  mutate(week = as.factor(isoweek(Date)))

# Choose the week you want to look at
# Script will automatically compare it to the previous week
thisWeek <- as.numeric(readline(prompt = 'Enter week number: '))

# Lists file names of each player
fileList <- list.files()

# Loop that runs through each players' file, creating the same output charts
# and tables for each
for(i in fileList){
  
  nameSplit <- strsplit(i, split = "_")
  nameSplit <- strsplit(nameSplit[[1]][2], split = " ")
  playerName <- nameSplit[[1]][1]
  print(playerName)
  
  playerSub <- subset(team, (week %in% c(thisWeek - 1, thisWeek)) & (Name == playerName))
  playerGrouped <- playerSub %>%
    dplyr::group_by(week) %>%
    dplyr::summarise("# of Swings" = n(),
              "Rotational Acceleration (g)" = round(mean(Rotational.Acceleration..g.), 2), 
              "On-Plane Efficiency (%)" = round(mean(On.Plane.Efficiency....), 2), 
              "Connection Impact (deg)" = round(mean(Connection.at.Impact..deg.), 2), 
              "Early Connection (deg)" = round(mean(Early.Connection..deg.), 2),
              "Commit Time (s)" = round(mean(Time.to.Contact..sec.), 2),
              "Bat Speed" = round(mean(Bat.Speed..mph.), 2),
              "Attack Angle (deg)" = round(mean(Attack.Angle..deg.), 2)) %>%
    t() %>%
    as.data.frame()
  
  colnames(playerGrouped) <- c(paste("Week", playerGrouped[1,1]), paste("Week", playerGrouped[1,2]))
  playerGrouped <- playerGrouped[-1,]
  playerGrouped[,1] <- as.numeric(as.character(playerGrouped[,1]))
  playerGrouped[,2] <- as.numeric(as.character(playerGrouped[,2]))
  playerGrouped$Difference <- round((playerGrouped[,2] - playerGrouped[,1]), 2)
  
  playerSwingCount <- playerSub %>%
    group_by(week) %>%
    tally(name = "# Swings")
  
  # Plots
  rotVope <- ggplot(playerSub, aes(x = On.Plane.Efficiency...., y = Rotational.Acceleration..g.)) +
    geom_encircle(aes(fill = week), alpha = .5, expand = .01) +
    geom_point(aes(color = week)) +
    geom_vline(xintercept = mean(team$On.Plane.Efficiency....)) +
    labs(y = 'Rotational Acceleration (g)', x = 'On Plane Efficieny (%)')
  
  attackVspeed <- ggplot(playerSub, aes(x = Bat.Speed..mph., y = Attack.Angle..deg.)) +
    geom_encircle(aes(fill = week), alpha = .5, expand = .01) +
    geom_point(aes(color = week)) +
    geom_vline(xintercept = mean(team$Bat.Speed..mph.)) +
    labs(y = 'Attack Angle (deg)', x = 'Bat Speed (mph)')
  
  rotVcommit <- ggplot(playerSub, aes(x = (Time.to.Contact..sec. * 1000), y = Rotational.Acceleration..g.)) +
    geom_encircle(aes(fill = week), alpha = .5, expand = .01) +
    geom_point(aes(color = week)) +
    geom_vline(xintercept = mean(team$Time.to.Contact..sec. * 1000)) +
    labs(y = 'Rotational Acceleration (g)', x = 'Time to Contact (ms)')
  
  conVvert <- ggplot(playerSub, aes(x = Vertical.Bat.Angle..deg., y = Connection.at.Impact..deg.)) +
    geom_encircle(aes(fill = week), alpha = .5, expand = .01) +
    geom_point(aes(color = week)) +
    geom_vline(xintercept = mean(team$Vertical.Bat.Angle..deg.)) +
    labs(y = 'Connection at Impact (deg)', x = 'Vertical Bat Angle (deg)') +
    scale_x_reverse()
  
  earlyconVvert <- ggplot(playerSub, aes(x = Vertical.Bat.Angle..deg., y = Early.Connection..deg.)) +
    geom_encircle(aes(fill = week), alpha = .5, expand = .01) +
    geom_point(aes(color = week)) +
    geom_vline(xintercept = mean(team$Vertical.Bat.Angle..deg.)) +
    labs(y = 'Early Connection (deg)', x = 'Vertical Bat Angle (deg)') +
    scale_x_reverse()
  
  fileName <- paste(playerName,'_week', thisWeek, '.pdf', sep = "")
  
  pdf(fileName)
  
  title <- paste(playerName, "- Week", thisWeek, sep = " ")
  
  grid::grid.newpage()
  grid::grid.text(title,x = .5, y = .9)
  grid.table(playerGrouped)

  multiplot(rotVope, 
            attackVspeed, 
            rotVcommit, 
            conVvert, 
            earlyconVvert,
            cols = 2)
  grid::grid.text(title,x = .75, y = .1)

  dev.off()

}
