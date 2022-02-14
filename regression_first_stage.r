### Script to run regression models relating defender pivot timing to offensive play outcomes
### Two-stage regression approach (FIRST STAGE)
### Inlcudes heat plot

## Create dataset to use for modeling ("PP_model")
## Remove pairings that have anomolies, indicating that the defender was not "cpvering" the offensive player
PP_model <- PP[PP$gapVertical_AtPivot < 10 & PP$gap_AtPivot < 20 & PP$firstHipTurn_frameId > 15 & nchar(as.character(PP$hipTurn_frameId)) > 20,]
PP_model <- PP_model[PP_model$adjPlayerPosition != "DEF",]  # Remove defnsive players playing offense

## First model: Relating defender pivot timing (positionally relative of offensive player) on "GO" routes to eventual receiver openness at time of pass
## LOESS regression, only "GO" routes
m1 <- loess(data = PP_model[PP_model$offRoute == "GO",], gap_AtPass ~ gapVertical_AtPivot + gapHorizontal_AtPivot)

## Evaluate the modeled relationship
m1_eval <- data.frame(gapVertical_AtPivot = rep(seq(-3, 5, 0.1), length(seq(0, 2, 0.1))), gapHorizontal_AtPivot = rep(seq(0, 2, 0.1), length(seq(-3, 5, 0.1))))
m1_eval$predGap_AtPass <- predict(m1, m1_eval)

ggplot(data = m1_eval, aes(x = gapHorizontal_AtPivot, y = gapVertical_AtPivot, fill = predGap_AtPass, height = 0.3, width = 0.1)) +
  geom_tile() +
  scale_fill_gradient(low="orange", high="blue") +
  labs(title = "NFL Receiver Openness by Defender Pivot Timing (Go Routes)", subtitle = "Defender pivot timing is relative to receiver position",
       x = "Absolute Horizontal Gap (Between Defender & Receiver, Yds)", y = "Vertical Gap (Between Defender & Receiver, Yds)", fill = "Receiver Openness at\nTime of Pass (Yds)") +
  theme(plot.title = element_text(hjust = 0.5, face = "bold", size = 12),
        plot.subtitle = element_text(hjust = 0.5),
        axis.text.x = element_text(size = 8),
        axis.text.y = element_text(size = 8),
        axis.title.x = element_text(face = "bold"),
        axis.title.y = element_text(face = "bold"),
        legend.title = element_text(face = "bold"))
