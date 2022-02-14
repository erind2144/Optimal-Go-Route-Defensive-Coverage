### Script for identifying the closest opposing player at various times during the play
## Used to identify coverage pairs to use in our analysis
## NOTE: For-loop code commented out because of long run-time (several hours)
## Resulting dataframe saved as .csv then loaded at the end

# Exclude QBs
d <- d[d$playerPosition != "QB",]

d$lookupkey <- paste(d$weekId, d$gameId, d$playId, d$nflId, sep = "_")

d$closest_AtSnap <- NA
d$distance_AtSnap <- NA
d$closest_AtPass <- NA
d$distance_AtPass <- NA
d$closest_AtBallArrive <- NA
d$distance_AtBallArrive <- NA

# for (i in 1:nrow(d)){
#   this_game <- d$gameId[i]
#   this_week <- d$weekId[i]
#   this_play <- d$playId[i]
#   this_player <- d$nflId[i]
#   this_team <- d$teamAbbr[i]
#
#   # Vector of opposing players to loop through, checking each pairwise distance
#   this_players_opponents <- d$nflId[d$gameId == this_game & d$weekId == this_week & d$playId == this_play & d$teamAbbr != this_team] # vector of players in same week/game/play w/ different team
#
#   # Initialize values for shortest distance and closest player at various times
#   shortest_distance_AtSnap <- Inf
#   closest_player_AtSnap <- NA
#
#   shortest_distance_AtPass <- Inf
#   closest_player_AtPass <- NA
#
#   shortest_distance_AtBallArrive <- Inf
#   closest_player_AtBallArrive <- NA
#
#   x1_AtSnap <- d$x_AtSnap[i]
#   y1_AtSnap <- d$y_AtSnap[i]
#
#   x1_AtPass <- d$x_AtPass[i]
#   y1_AtPass <- d$y_AtPass[i]
#
#   x1_AtBallArrive <- d$x_AtBallArrive[i]
#   y1_AtBallArrive <- d$y_AtBallArrive[i]
#
#   # Loop through the vector of opposing players
#   for (j in this_players_opponents){
#
#     #Assign Coordinates
#     x2_AtSnap <- d$x_AtSnap[match(paste(this_week, this_game, this_play, j, sep = "_"), d$lookupkey)]
#     y2_AtSnap <- d$y_AtSnap[match(paste(this_week, this_game, this_play, j, sep = "_"), d$lookupkey)]
#
#     x2_AtPass <- d$x_AtPass[match(paste(this_week, this_game, this_play, j, sep = "_"), d$lookupkey)]
#     y2_AtPass <- d$y_AtPass[match(paste(this_week, this_game, this_play, j, sep = "_"), d$lookupkey)]
#
#     x2_AtBallArrive <- d$x_AtBallArrive[match(paste(this_week, this_game, this_play, j, sep = "_"), d$lookupkey)]
#     y2_AtBallArrive <- d$y_AtBallArrive[match(paste(this_week, this_game, this_play, j, sep = "_"), d$lookupkey)]
#
#     # Check distance at snap
#     if (!is.na(x1_AtSnap) & !is.na(x2_AtSnap)){
#
#       distance_AtSnap <- sqrt((x1_AtSnap - x2_AtSnap)^2 + (y1_AtSnap - y2_AtSnap)^2)
#
#       if (distance_AtSnap < shortest_distance_AtSnap){
#         shortest_distance_AtSnap <- distance_AtSnap
#         closest_player_AtSnap <- j
#       }
#     }
#
#     # Check distances at pass
#     if (!is.na(x1_AtPass) & !is.na(x2_AtPass)){
#
#       distance_AtPass <- sqrt((x1_AtPass - x2_AtPass)^2 + (y1_AtPass - y2_AtPass)^2)
#
#       if (distance_AtPass < shortest_distance_AtPass){
#         shortest_distance_AtPass <- distance_AtPass
#         closest_player_AtPass <- j
#       }
#     }
#
#     # Check distances at ball arrival
#     if (!is.na(x1_AtBallArrive) & !is.na(x2_AtBallArrive)){
#
#       distance_AtBallArrive <- sqrt((x1_AtBallArrive - x2_AtBallArrive)^2 + (y1_AtBallArrive - y2_AtBallArrive)^2)
#
#       if (distance_AtBallArrive < shortest_distance_AtBallArrive){
#         shortest_distance_AtBallArrive <- distance_AtBallArrive
#         closest_player_AtBallArrive <- j
#       }
#     }
#
#   }
#
#   d$closest_AtSnap[i] <- closest_player_AtSnap
#   d$distance_AtSnap[i] <- shortest_distance_AtSnap
#   d$closest_AtPass[i] <- closest_player_AtPass
#   d$distance_AtPass[i] <- shortest_distance_AtPass
#   d$closest_AtBallArrive[i] <- closest_player_AtBallArrive
#   d$distance_AtBallArrive[i] <- shortest_distance_AtBallArrive
#
# }
#
# write.csv(d, "Closest Players.csv", row.names = FALSE)

CP <- read.csv("../input/closest-players/Closest Players.csv", header = TRUE)

### Create CP dataframe aggregated at the offensive/defensive coverage pair level (per play)
## Remove defensive players (since they'll be duplicated)
CP <- CP[CP$playerType == "OFF",]

## Filter for situations where closest defensive player at time of pass is same as at time of snap
CP <- CP[!is.na(CP$closest_AtPass) | !is.na(CP$closest_AtSnap),]
CP <- CP[CP$closest_AtPass == CP$closest_AtSnap,]

## Remove/rename columns
CP <- CP[, 1:17]

colnames(CP)[colnames(CP) == "nflId"] <- "OFF_nflId"
colnames(CP)[colnames(CP) == "closest_AtSnap"] <- "DEF_nflId"

CP <- CP[, !grepl("x_", colnames(CP)) & !grepl("y_", colnames(CP))]

## Add supplemental play-level data
CP <- merge(CP, plays, by = c("playId", "gameId"), all.x = TRUE)
