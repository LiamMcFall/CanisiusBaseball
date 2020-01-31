source("/Users/liammcfall/CanisiusBaseball/BlastMergingCleaning.R")
library(dplyr)
library(ggplot2)
library(tidyr)
library(magrittr)
library(ggalt)

blast2019 <- aggregateBlast("/Users/liammcfall/CanisiusBaseball/BlastData/")
blast2019 <- blastClean(blast2019)

blastgg <- ggplot(blast2019, aes(x = Bat.Speed..mph., y = Attack.Angle..deg.))

blastgg +
  geom_point()

blastgg +
  geom_encircle(s_shape=.5, expand=.1) +
  geom_point()

blast2019sub <- subset(blast2019, Name %in% c("bennett","leader"))

blastsubgg <- ggplot(blast2019sub, aes(x = Bat.Speed..mph., y = Attack.Angle..deg., color = Name))

blastsubgg +
  geom_encircle(aes(fill = Name), alpha = .5, expand = .01)  

