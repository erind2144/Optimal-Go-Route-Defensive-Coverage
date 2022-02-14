### Script to run regression models relating defender pivot timing to offensive play outcomes
### Two-stage regression approach (SECOND STAGE)
## Consists of two models relating receiver openness to offensive play outcomes (target likelihood and EPA when targeted)

## Generalized, all routes
m2 <- glm(data = PP_model, offTarget ~ gap_AtPass + offDistDownfield_AtPass + gap_AtPass:offDistDownfield_AtPass, family = binomial(link = "logit"))
summary(m2)

m3 <- lm(data = PP_model[PP_model$offTarget,], epa ~ gap_AtPass + offDistDownfield_AtPass + gap_AtPass:offDistDownfield_AtPass + I(absoluteYardlineNumber > 90))
summary(m3)
