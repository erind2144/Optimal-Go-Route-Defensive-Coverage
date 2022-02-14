### Script for NFL Big Data Bowl 2021 data load
## Combines weekly tracking files into AllWeeks dataset
library(data.table)
library(tidyr)
library(stringr)
library(ggplot2)
library(dplyr)

games <- read.csv("../input/nfl-big-data-bowl-2021/games.csv", header = TRUE)
players <- read.csv("../input/nfl-big-data-bowl-2021/players.csv", header = TRUE)
plays <- read.csv("../input/nfl-big-data-bowl-2021/plays.csv", header = TRUE)

## Loop through the weekly files, pulling each and storing in a list
data_list <- list()
for (i in 1:17){
  this_data <- read.csv(paste0("../input/nfl-big-data-bowl-2021/week", i, ".csv"), header = TRUE)
  this_data$week <- i
  data_list[[length(data_list) + 1]] <- this_data
}

## Combine the weekly files into one big dataframe (AllWeeks)
AllWeeks <- rbindlist(data_list)

## Remove unneeded workspace objects
rm(list = setdiff(ls(), c("AllWeeks", "games", "players", "plays")))
