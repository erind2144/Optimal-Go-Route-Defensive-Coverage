### Script to add supplementary tracking variables for both offensive and defensive players at key points during the play
## Position, speed, acceleration, and direction of movement at the time of the defender pivot and position at time of pass
## NOTE: Some fields were ultimately unused in modeling (commented out)

PP$offX_AtPivot <- AllWeeks$x[match(paste(PP$weekId, PP$gameId, PP$playId, PP$OFF_nflId, PP$firstHipTurn_frameId, sep="_"), paste(AllWeeks$week, AllWeeks$gameId, AllWeeks$playId, AllWeeks$nflId, AllWeeks$frameId, sep="_"))]
PP$offY_AtPivot <- AllWeeks$y[match(paste(PP$weekId, PP$gameId, PP$playId, PP$OFF_nflId, PP$firstHipTurn_frameId, sep="_"), paste(AllWeeks$week, AllWeeks$gameId, AllWeeks$playId, AllWeeks$nflId, AllWeeks$frameId, sep="_"))]
#PP$offS_AtPivot <- AllWeeks$s[match(paste(PP$weekId, PP$gameId, PP$playId, PP$OFF_nflId, PP$firstHipTurn_frameId, sep="_"), paste(AllWeeks$week, AllWeeks$gameId, AllWeeks$playId, AllWeeks$nflId, AllWeeks$frameId, sep="_"))]
#PP$offA_AtPivot <- AllWeeks$a[match(paste(PP$weekId, PP$gameId, PP$playId, PP$OFF_nflId, PP$firstHipTurn_frameId, sep="_"), paste(AllWeeks$week, AllWeeks$gameId, AllWeeks$playId, AllWeeks$nflId, AllWeeks$frameId, sep="_"))]
#PP$offDir_AtPivot <- AllWeeks$dir[match(paste(PP$weekId, PP$gameId, PP$playId, PP$OFF_nflId, PP$firstHipTurn_frameId, sep="_"), paste(AllWeeks$week, AllWeeks$gameId, AllWeeks$playId, AllWeeks$nflId, AllWeeks$frameId, sep="_"))]

PP$defX_AtPivot <- AllWeeks$x[match(paste(PP$weekId, PP$gameId, PP$playId, PP$DEF_nflId, PP$firstHipTurn_frameId, sep="_"), paste(AllWeeks$week, AllWeeks$gameId, AllWeeks$playId, AllWeeks$nflId, AllWeeks$frameId, sep="_"))]
PP$defY_AtPivot <- AllWeeks$y[match(paste(PP$weekId, PP$gameId, PP$playId, PP$DEF_nflId, PP$firstHipTurn_frameId, sep="_"), paste(AllWeeks$week, AllWeeks$gameId, AllWeeks$playId, AllWeeks$nflId, AllWeeks$frameId, sep="_"))]
#PP$defS_AtPivot <- AllWeeks$s[match(paste(PP$weekId, PP$gameId, PP$playId, PP$DEF_nflId, PP$firstHipTurn_frameId, sep="_"), paste(AllWeeks$week, AllWeeks$gameId, AllWeeks$playId, AllWeeks$nflId, AllWeeks$frameId, sep="_"))]
#PP$defA_AtPivot <- AllWeeks$a[match(paste(PP$weekId, PP$gameId, PP$playId, PP$DEF_nflId, PP$firstHipTurn_frameId, sep="_"), paste(AllWeeks$week, AllWeeks$gameId, AllWeeks$playId, AllWeeks$nflId, AllWeeks$frameId, sep="_"))]
#PP$defDir_AtPivot <- AllWeeks$dir[match(paste(PP$weekId, PP$gameId, PP$playId, PP$DEF_nflId, PP$firstHipTurn_frameId, sep="_"), paste(AllWeeks$week, AllWeeks$gameId, AllWeeks$playId, AllWeeks$nflId, AllWeeks$frameId, sep="_"))]

PP$offX_AtPass <- d$x_AtPass[match(paste(PP$weekId, PP$gameId, PP$playId, PP$OFF_nflId, sep="_"), paste(d$weekId, d$gameId, d$playId, d$nflId, sep="_"))]
PP$offY_AtPass <- d$y_AtPass[match(paste(PP$weekId, PP$gameId, PP$playId, PP$OFF_nflId, sep="_"), paste(d$weekId, d$gameId, d$playId, d$nflId, sep="_"))]
PP$defX_AtPass <- d$x_AtPass[match(paste(PP$weekId, PP$gameId, PP$playId, PP$DEF_nflId, sep="_"), paste(d$weekId, d$gameId, d$playId, d$nflId, sep="_"))]
PP$defY_AtPass <- d$y_AtPass[match(paste(PP$weekId, PP$gameId, PP$playId, PP$DEF_nflId, sep="_"), paste(d$weekId, d$gameId, d$playId, d$nflId, sep="_"))]

PP$gap_AtPass <- sqrt((PP$offX_AtPass - PP$defX_AtPass)^2 + (PP$offY_AtPass - PP$defY_AtPass)^2)

## Offensive player distance downfield at pivot and pass
PP$playDirection <- AllWeeks$playDirection[match(paste(PP$weekId, PP$gameId, PP$playId, sep="_"), paste(AllWeeks$week, AllWeeks$gameId, AllWeeks$playId, sep="_"))]
PP$offDistDownfield_AtPivot <- ifelse(PP$playDirection == "left", PP$absoluteYardlineNumber - PP$offX_AtPivot, PP$offX_AtPivot - PP$absoluteYardlineNumber)
PP$offDistDownfield_AtPass <- ifelse(PP$playDirection == "left", PP$absoluteYardlineNumber - PP$offX_AtPass, PP$offX_AtPass - PP$absoluteYardlineNumber)

## Variable differentials at pivot
PP$gap_AtPivot <- sqrt((PP$offX_AtPivot - PP$defX_AtPivot)^2 + (PP$offY_AtPivot - PP$defY_AtPivot)^2)
PP$gapVertical_AtPivot <- ifelse(PP$playDirection == "left", PP$offX_AtPivot - PP$defX_AtPivot, PP$defX_AtPivot - PP$offX_AtPivot)
PP$gapHorizontal_AtPivot <- abs(PP$offY_AtPivot - PP$defY_AtPivot)
#PP$velocityDiff_AtPivot <- PP$defS_AtPivot - PP$offS_AtPivot
#PP$accelerationDiff_AtPivot <- PP$defA_AtPivot - PP$offA_AtPivot
