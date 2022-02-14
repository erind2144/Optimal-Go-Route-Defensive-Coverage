### Script to evaluate defender gap timing vs. optimal timing for past data
## Based on models m2 and m3, the goal of the defender should be to minimize the receiver's eventual openness at the time of the pass
## We view the defender's pivot-timing choice in the frame of the vertical gap, given the horizontal gap

## Function to return the optimal defender pivot timing (vertical gap relative to receiver) given the horizontal gap
# Note: truncated at 1.4 yards of horizontal gap (majority of data for LOESS model has horizontal gap < 1)
fOptimalVertGap <- function(x){
  m1_eval$gapHorizontal_AtPivot <- round(m1_eval$gapHorizontal_AtPivot, 1)
  m1_eval$gapVertical_AtPivot <- round(m1_eval$gapVertical_AtPivot, 1)
  m1_eval = m1_eval[m1_eval$gapHorizontal_AtPivot <= 1.5 & m1_eval$gapVertical_AtPivot >= -3 & m1_eval$gapVertical_AtPivot <= 5,]

  return(m1_eval$gapVertical_AtPivot[m1_eval$gapHorizontal_AtPivot == min(round(x, 1), 1.4)][match(min(m1_eval$predGap_AtPass[m1_eval$gapHorizontal_AtPivot == min(round(x, 1), 1.4)]), m1_eval$predGap_AtPass[m1_eval$gapHorizontal_AtPivot == min(round(x, 1), 1.4)])])
}

## Output data for player scorecards
output <- PP_model[PP_model$offRoute == "GO" & !is.na(PP_model$gapVertical_AtPivot),
                   colnames(PP_model) %in% c("weekId", "gameId", "playId", "OFF_nflId", "DEF_nflId",
                     "gapHorizontal_AtPivot", "gapVertical_AtPivot", "defA_AtPivot", "gap_AtPass",
                     "absoluteYardlineNumber", "offRoute", "offDistDownfield_AtPass", "offTarget", "epa")]
output$gapHorizontal_AtPivot[is.na(output$gapHorizontal_AtPivot)] <- 0
output$gapOptimal_AtPivot <- sapply(output$gapHorizontal_AtPivot, FUN = fOptimalVertGap)

dummy_data <- output[, c("gapHorizontal_AtPivot", "gapOptimal_AtPivot")]
colnames(dummy_data)[2] <- "gapVertical_AtPivot"
output$gapHypothetical_AtPass <- predict(m1, dummy_data)

output$possTeam <- as.character(plays$possessionTeam[match(paste(output$playId, output$gameId), paste(plays$playId, plays$gameId))])
output$defTeam <- ifelse(output$possTeam == as.character(games$homeTeamAbbr[match(output$gameId, games$gameId)]), as.character(games$visitorTeamAbbr[match(output$gameId, games$gameId)]), as.character(games$homeTeamAbbr[match(output$gameId, games$gameId)]))
