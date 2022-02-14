### Script for aggregating data at the play/player level into dataframe "d"
d <- data.frame(UID = unique(paste(AllWeeks$week, AllWeeks$gameId, AllWeeks$playId, AllWeeks$nflId, sep = "_")))
d <- separate(d, UID, c("weekId", "gameId", "playId", "nflId"), sep = "_")

## "A" is a subset of AllWeeks containing only key events from each play
## Cuts down run-time for upcoming match functions
A <- AllWeeks[AllWeeks$event %in% c("ball_snap", "pass_forward", "pass_arrived"),]

## Remove the football from dataset d
d$playerTeam <- A$team[match(paste(d$weekId, d$gameId, d$playId, d$nflId), paste(A$week, A$gameId, A$playId, A$nflId))]
d <- d[d$playerTeam != "football",]
d <- d[!is.na(d$playerTeam),]

## Coordinate locations at key points during each play
d$x_AtSnap <- A$x[match(paste(d$weekId, d$gameId, d$playId, d$nflId, "ball_snap"), paste(A$week, A$gameId, A$playId, A$nflId, A$event))]
d$y_AtSnap <- A$y[match(paste(d$weekId, d$gameId, d$playId, d$nflId, "ball_snap"), paste(A$week, A$gameId, A$playId, A$nflId, A$event))]
d$x_AtPass <- A$x[match(paste(d$weekId, d$gameId, d$playId, d$nflId, "pass_forward"), paste(A$week, A$gameId, A$playId, A$nflId, A$event))]
d$y_AtPass <- A$y[match(paste(d$weekId, d$gameId, d$playId, d$nflId, "pass_forward"), paste(A$week, A$gameId, A$playId, A$nflId, A$event))]
d$x_AtBallArrive <- A$x[match(paste(d$weekId, d$gameId, d$playId, d$nflId, "pass_arrived"), paste(A$week, A$gameId, A$playId, A$nflId, A$event))]
d$y_AtBallArrive <- A$y[match(paste(d$weekId, d$gameId, d$playId, d$nflId, "pass_arrived"), paste(A$week, A$gameId, A$playId, A$nflId, A$event))]

## Identify whether each player is on offense or defense
d$teamAbbr[d$playerTeam == "home"] <- games$homeTeamAbbr[match(d$gameId[d$playerTeam == "home"], games$gameId)]
d$teamAbbr[d$playerTeam == "away"] <- games$visitorTeamAbbr[match(d$gameId[d$playerTeam == "away"], games$gameId)]
d$possessionTeam <- plays$possessionTeam[match(paste(d$gameId, d$playId), paste(plays$gameId, plays$playId))]

d$playerType <- ifelse(d$teamAbbr == d$possessionTeam, "OFF", "DEF")
d$playerPosition <- A$position[match(paste(d$weekId, d$gameId, d$playId, d$nflId), paste(A$week, A$gameId, A$playId, A$nflId))]
