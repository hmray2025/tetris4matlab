# import data
data1 <- read.csv("processedData2.csv")
nSubs = length(data1$Timestamp);

# ANOVA Table for H1!

# h1: Still to Do!
# alpha = slow/easy
# beta = fast/easy
# gamma = slow/hard
# delta = fast/hard
wkldData = c(data1$WorkloadA, data1$WorkloadB, data1$WorkloadC, data1$WorkloadD)
tetrisDiff = c(rep(0,nSubs),rep(0,nSubs),rep(1,nSubs),rep(1,nSubs))
wordSpd = c(rep(0,nSubs),rep(1,nSubs),rep(0,nSubs),rep(1,nSubs))
condition = c(rep(1,nSubs),rep(2,nSubs),rep(3,nSubs),rep(4,nSubs))
h1 = aov(wkldData~tetrisDiff+wordSpd+tetrisDiff:wordSpd)
summary(h1)
h1a = aov(wkldData~tetrisDiff+wordSpd)
summary(h1a)

boxplot(wkldData~condition)

interaction.plot(x.factor = wordSpd, trace.factor = tetrisDiff, response = wkldData, fun = median,   ylab = "Workload",
                 xlab = "Word Presentation Rate",
                 col = c("red", "blue"),
                 lty = 1, #line type
                 lwd = 2, #line width
                 trace.label = "Game Difficulty")

interaction.plot(x.factor = tetrisDiff, trace.factor = wordSpd, response = wkldData, fun = median,   ylab = "Workload",
                 xlab = "Game Difficulty",
                 col = c("red", "blue"),
                 lty = 1, #line type
                 lwd = 2, #line width
                 trace.label = "Word Presentation Rate")

# h2: workload vs recall linear regression --> not sure this is really allowed w rep measures
rcllData = 100*c(data1$recallA, data1$recallB, data1$recallC, data1$recallD)
wkldData = c(data1$WorkloadA, data1$WorkloadB, data1$WorkloadC, data1$WorkloadD)
h2 = lm(rcllData~wkldData)
plot(wkldData,rcllData, main="H2) Recall vs Workload",
     xlab="Reported Workload [MBS]", ylab="% Recall")
abline(h2)
boxplot(rcllData~condition)


# h3: workload vs precision linear regression
# should be ANOVA instead
prcsnData = 100*c(data1$precisionA, data1$precisionB, data1$precisionC, data1$precisionD)
h3 = lm(prcsnData~wkldData)
plot(wkldData,prcsnData, main="H3) Precision vs Workload",
     xlab="Reported Workload [MBS]", ylab="% Precision")
abline(h3)
boxplot(prcsnData~condition)

# h4: tetris experience vs workload
wkldDataAvg = integer(nSubs)
for (i in 1:nSubs) {
  wkldDataAvg[i] = mean(data1$WorkloadA[i], data1$WorkloadB[i], data1$WorkloadC[i], data1$WorkloadD[i])
}
r4 = cor(wkldDataAvg,data1$TetrisXP)
h4 = lm(wkldDataAvg~data1$TetrisXP)
plot(data1$TetrisXP,wkldDataAvg, main="H4a) Workload vs. Tetris Experience",
     xlab="Self-Rated Tetris Experience", ylab="Reported Workload [MBS]")
abline(h4)

# h4a: high workload experience vs workload
r4a = cor(wkldDataAvg,data1$TetrisXP)
h4a = lm(wkldDataAvg~data1$TetrisXP)
plot(data1$WorkloadXP,wkldDataAvg, main="H4b) Workload vs. High-Workload Experience",
     xlab="Self-Rated High-Workload Experience", ylab="Reported Workload [MBS]")
abline(h4a)

# h5: game scores and recall % --> also not sure these two are entirely legal
scoreData = c(data1$ScoreA, data1$ScoreB, data1$ScoreC, data1$ScoreD)
r5 = cor(scoreData,rcllData)
h5 = lm(rcllData~scoreData)
plot(scoreData,rcllData, main="H5a) Game Score vs. % Recall",
     xlab="Game Score", ylab="% Recall")
abline(h5)

# h5: game scores and recall % --> also not sure these two are entirely legal
# plot separate for each trial
scoreData = c(data1$ScoreA, data1$ScoreB, data1$ScoreC, data1$ScoreD)
r5 = cor(scoreData,rcllData)
h5 = lm(rcllData~scoreData)
plot(scoreData,rcllData, main="H5a) Game Score vs. % Recall",
     xlab="Game Score", ylab="% Recall")
abline(h5)

# h5a: game scores and recall % 
r5a = cor(scoreData,prcsnData)
h5a = lm(prcsnData~scoreData)
plot(scoreData,prcsnData, main="H5b) Game Score vs. % Precision",
     xlab="Game Score", ylab="% Precision")
abline(h5a)



# h6: still to do.

# precision vs recall
plot(prcsnData,rcllData)
h0 = lm(rcllData~prcsnData)
abline(h0)