### Script to figure out who the ball was thrown to on each play
## Creates a boolean column in PP called "offTarget" which indicates whether or not that offensive player was targeted on that play

Players <- read.csv("../input/nfl-big-data-bowl-2021/players.csv", header = TRUE)

Players <- Players[, c("nflId", "displayName")]
colnames(Players) <- c("OFF_nflId", "offPlayerName")

PP <- merge(PP, Players, by = c("OFF_nflId"), all.x = TRUE)

# Convert names to firstinitial.lastname format
PP$offFirstInitial.LastName <- NA

PP$offPlayerName <- as.character(PP$offPlayerName)

firstInitial <- substr(PP$offPlayerName, 1, 1)
firstInitial. <- paste(firstInitial, ".", sep = "")

lastName_start_index <- str_locate(PP$offPlayerName, " ") + 1
lastName_substring <- substr(PP$offPlayerName, lastName_start_index, nchar(PP$offPlayerName))

PP$offFirstInitial.LastName <- paste(firstInitial., lastName_substring, sep = "")

## Manually fix a few player names to properly identify players in the play descriptions
PP$offFirstInitial.LastName[PP$offPlayerName == "Odell Beckham Jr."] <- "O.Beckham"
PP$offFirstInitial.LastName[PP$offPlayerName == "Demaryius Thomas"] <- "De.Thomas"
PP$offFirstInitial.LastName[PP$offPlayerName == "Tyrell Williams"] <- "Ty.Williams"

# Look for offPlayerName in playDescription
PP$playDescription <- as.character(PP$playDescription)
PP$offTarget <- str_detect(PP$playDescription, PP$offFirstInitial.LastName)

# Route run by offensive player
PP$offRoute <- AllWeeks$route[match(paste(PP$weekId, PP$gameId, PP$playId, PP$OFF_nflId, sep="_"), paste(AllWeeks$week, AllWeeks$gameId, AllWeeks$playId, AllWeeks$nflId, sep="_"))]
