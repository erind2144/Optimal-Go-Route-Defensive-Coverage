### Date Created
This project was created on 1/07/2021

### Project Title
Optimal Go-Route Defensive Coverage created for the NFL Big Data Bowl 2021

### Introduction
The goal of this analysis is to determine the optimal point at which a defensive player should turn their hips to run parallel with a receiver when in coverage against a “go” route. By understanding the optimal hip-pivot timing, we’re able to observe how individual defensive players’ decisions stack up against our “optimal decision” framework.

This methodology provides a niche-but-useful tool for NFL GMs and scouts to grade defensive players on their abilities to optimally cover “go” routes. Furthermore, by coaching players to implement our simple optimal “go” route coverage strategy, we estimate NFL teams could expect to prevent up to **6 incremental points against** over the course of a season.

To display our player-level results, we created a report card in Tableau to grade defenders on the three main areas of our analysis: pivot timing, EPA reduction, and receiver separation at time of pass. A link to our Tableau page can be found [here][1].

[1]: https://public.tableau.com/app/profile/erin.dorsey/viz/NFLReportCard/ReportCard

The rest of this workbook details the data prep and methodology that went into our analysis.

### Data Prep
Since our analysis focuses on individual coverage matchups, our first step was to combine the weekly files and identify defensive players who were unambiguously covering a single offensive player on a given play. For a pair of offensive and defensive players to be included in our analysis, we required them to satisfy all the following conditions:

* The defensive player must be the closest defender to the offensive player at the time of the snap.
* The defensive player must be the closest defender to the offensive player at the time of the pass.
* There must not be a gap of more than 20 yards between the offensive and defensive players during the coverage.

Across the 2018 NFL season, there were over 45,000 “coverage pairs” of offensive and defensive players that met our restrictions.

For each coverage pair, we then determined the point at which the defensive player decided to pivot his hips and turn from backpedaling to running parallel with the receiver.

### Analysis
By using a two-stage regression approach, we’re first able to isolate the effect of the defender’s pivot timing on the receiver’s eventual “openness” (separation from defender) at the time of the pass on “go” routes. To model the complex shape of this relationship, we use a locally-smoothed regression technique (LOESS). The defender’s pivot timing is encoded as a two-dimensional vector consisting of the absolute horizontal gap and the vertical gap between the defender and the receiver at the time of the pivot, both in yards. A negative vertical gap indicates that the receiver is already behind the defender.

The heat plot in the Appendix shows the relationship between pivot timing and eventual receiver openness.

In the second stage, we look to uncover the relationship between receiver openness and offensive play outcomes. Our first second-stage model focuses on the relationship between receiver target likelihood and openness at the time of the pass, controlling for distance downfield. Our second model looks at the relationship between EPA (expected points added) and receiver openness for receivers that are targeted, controlling for distance downfield and red zone chances.

Regression outputs for both models are presented in the Appendix.

### Results
Our second-stage models reveal two important findings:

1. Receivers that have larger separation from the nearest defender at the time of the pass are more likely to be targeted.
2. When targeted, receivers that have larger separation from the nearest defender at the time of the pass produce a larger number of expected points added.

With this information, the goal of the defender should be relatively simple: attempt to minimize the receiver’s separation at the time of the pass.

In the context of “go” route coverage, the results of our first-stage regression model can be used to show optimal pivot timing. Our results show that, to minimize the receiver’s separation, the defender should pivot their hips when the receiver is between **0.3** and **0.7** yards in front of them. The variation in the optimal point depends on the horizontal gap: a larger horizontal gap necessitates an earlier pivot.

### Impact
By understanding the optimal time for a defender to pivot when covering a “go” route, we’re able to examine how players and teams perform against this framework. We find that, on average, NFL defenders tend to pivot marginally too early (but remarkably close to our optimal point). However, these results vary drastically at the player- and team-level.

Our player report card in Tableau grades defenders on the three main areas of our analysis: pivot timing, EPA reduction, and receiver separation at time of pass. Only players who defended against at least 10 go routes during the 2018 regular season were included on the report card while all go routes were considered in the team rankings based on the same performance areas.

A link to our workbook can be found [here][1].

From a team-level perspective, we estimate that defending teams could have reduced the average receiver separation on go routes by 0.1 - 0.9 yards, simply by pivoting at the correct time. Based on our second-stage regression results, this decrease in receiver openness would lead to a 0.01 - 0.10 reduction in EPA per targeted go route. Over the course of a season, this translates to an expected reduction of up to 6 incremental points allowed.

### Conclusion
By performing a complex analysis of receiver/defender spatial positioning on "go" routes during the 2018 NFL season, we arrived at a relatively simple recommendation for defender pivot timing:

***A defender should pivot to run parallel with a receiver when the receiver is between 0.3 and 0.7 yards in front of them.***

Making this simple strategic adjustment could lead to a reduction of **6 points against** over the course of a full NFL season. While the magnitude of this effect may not seem massively influential, the current competitive state of the NFL necessitates that teams look for any possible edge. Because of the relatively simple framework of our recommendation, this analysis presents an actionable strategy that can be implemented by NFL teams immediately.

### Intructions
The raw data for this project can be found [here][3].
Run the scripts in the following order:
1. data_load.r
2. aggregation.r
3. player_distance.r
4. hip_turn.r
5. target.r
6. tracking.r
7. regression_first_stage.r
8. regression_second_stage.r
9. final_evaluation.r

NOTE: for loops in player_distance.r and hip_turn.r are commented out because of long run-times (several hours).

### Credits
This project was created with Garrett Schirmer for the NFL Big Data Bowl 2021.

Details about the competition as well as the raw data can be found [here][2].

[2]: https://www.kaggle.com/c/nfl-big-data-bowl-2021/overview
[3]: https://www.kaggle.com/c/nfl-big-data-bowl-2021/data
