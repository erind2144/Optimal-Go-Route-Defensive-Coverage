### Script to determine the point during each play at which the defender turns his hips
## NOTE: For-loop code commented out because of long run-time (several hours)
## Save final result in csv called "Player Pairings"

## Add unique lookup key to each: concatenation of gameId, playId, playerId
AllWeeks$lookupkey <- paste(AllWeeks$gameId, AllWeeks$playId, AllWeeks$nflId, sep="_")
CP$lookupkey <- paste(CP$gameId, CP$playId, CP$DEF_nflId, sep = "_")

## Loop through each play/player that is contained in CP
## Figure out the play direction, and therefore which orientation would constitute "hip turning"
## Figure out the frames during which the defensive player turned his hips

CP$hipTurn_frameId <- NA

# for (i in unique(CP$lookupkey)){
#   print(paste(match(i, unique(CP$lookupkey)), "out of", length(unique(CP$lookupkey))))
#
#   play_direction <- AllWeeks$playDirection[AllWeeks$lookupkey == i][1]
#
#   if (play_direction == "left"){
#     hip_turned_frames <- AllWeeks$frameId[AllWeeks$o > 180 & AllWeeks$lookupkey == i]
#   } else {
#     hip_turned_frames <- AllWeeks$frameId[AllWeeks$o < 180 & AllWeeks$lookupkey == i]
#   }
#
#   CP$hipTurn_frameId[match(i, CP$lookupkey)] <- ifelse(length(hip_turned_frames) == 0, NA, paste(hip_turned_frames, collapse = ", "))
# }
#
# write.csv(CP, "Player Pairings.csv", row.names = FALSE)

PP <- read.csv("../input/player-pairings/Player Pairings.csv", header = TRUE)

## Enrich/clean the player pairings data
PP <- PP[PP$lookupkey != "NA_NA_NA",]
PP$adjPlayerPosition <- ifelse(PP$playerPosition %in% c("FB", "HB"), "RB",
                               ifelse(PP$playerPosition %in% c("RB", "WR", "TE"), PP$playerPosition, "DEF"))

# Add a column for the first frame during which the defender pivots (NA if no pivot)
PP$firstHipTurn_frameId <- as.numeric(gsub(" ", "", gsub(",", "", substr(PP$hipTurn_frameId, 1, 3))))
