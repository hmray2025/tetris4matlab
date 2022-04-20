# import data
data1 <- read.csv("processedData2.csv")
nSubs = length(data1$Timestamp);

################################## H1 ######################################
# h1: Still to Do!
# alpha = slow/easy
# beta = fast/easy
# gamma = slow/hard
# delta = fast/hard
wkldData = c(data1$WorkloadA, data1$WorkloadB, data1$WorkloadC, data1$WorkloadD)
tetrisDiff = c(rep(0,nSubs),rep(0,nSubs),rep(1,nSubs),rep(1,nSubs))
wordSpd = c(rep(0,nSubs),rep(1,nSubs),rep(0,nSubs),rep(1,nSubs))
condition = c(rep(1,nSubs),rep(2,nSubs),rep(3,nSubs),rep(4,nSubs))
condition <- factor(condition)
levels(condition)<-c("Alpha","Beta","Gamma","Delta")

h1a = aov(wkldData~tetrisDiff+wordSpd)
summary(h1a)

boxplot(wkldData~condition)

interaction.plot(x.factor = wordSpd, trace.factor = tetrisDiff, response = wkldData, fun = median,   ylab = "Workload",
                 xlab = "Word Presentation Rate",
                 col = c("red", "blue"),
                 lty = 1, #line type
                 lwd = 2, #line width
                 trace.label = "Game Difficulty")


# hypothesis 1: 2-factor ANOVA
h1a <- aov(wkldData~factor(tetrisDiff) + factor(wordSpd) + factor(tetrisDiff):factor(wordSpd) +Error(factor(subjNum)))
summary(h1a)

# h1: test for normality
hist(wkldData, main="H1) Histogram of Workload",
     xlab="Workload Rating", ylab="Frequency")
shapiro.test(wkldData)

# to present! h1: non-parametric, friedmans anova with condition
subjNum = factor(rep(1:nSubs,4))
h1f = friedman.test(wkldData,condition,subjNum)
summary(h1f)
boxplot(wkldData~condition, main="H1) Workload by Condition",
        xlab="Condition", ylab="Workload Rating")

################################## H2 ######################################
# h2: workload vs recall linear regression --> not sure this is really allowed w rep measures
rcllData = 100*c(data1$recallA, data1$recallB, data1$recallC, data1$recallD)
wkldData = c(data1$WorkloadA, data1$WorkloadB, data1$WorkloadC, data1$WorkloadD)
h2 = lm(rcllData~wkldData)
plot(wkldData,rcllData, main="H2) Recall vs Workload",
     xlab="Reported Workload [MBS]", ylab="% Recall")
abline(h2)
boxplot(rcllData~condition)

# h2: test for normality
hist(rcllData, main="H1) Histogram of Recall Percentage",
     xlab="Recall Percentage", ylab="Frequency")
shapiro.test(rcllData)

#h2: non-parametric, friedmans anova with condition
h2f = friedman.test(rcllData,condition,subjNum)
boxplot(rcllData~condition, main="H2) Recall % by Condition",
        xlab="Condition", ylab="Recall %")

################################## H3 ######################################
# h3: workload vs precision linear regression
# should be ANOVA instead
prcsnData = 100*c(data1$precisionA, data1$precisionB, data1$precisionC, data1$precisionD)
h3 = lm(prcsnData~wkldData)
plot(wkldData,prcsnData, main="H3) Precision vs Workload",
     xlab="Reported Workload [MBS]", ylab="% Precision")
abline(h3)
boxplot(prcsnData~condition)

# h3: test for normality
hist(prcsnData, main="H3) Histogram of Precision Percentage",
     xlab="Precision Percentage", ylab="Frequency")
shapiro.test(prcsnData)

#h3: non-parametric, friedmans anova with condition
h3f = friedman.test(prcsnData,condition,subjNum)
boxplot(prcsnData~condition, main="H3) Precision % by Condition",
        xlab="Condition", ylab="Precision %")

################################## H0 ######################################
# not kosher stats but interesting that precision is significant and recall is not
# correlating precision and workload
# correlating recall and workload
plot(wkldData,prcsnData)
plot(wkldData,rcllData)
corr <- cor.test(prcsnData, wkldData, method = 'spearman')
corr <- cor.test(rcllData, wkldData, method = 'spearman')

################################## H4 ######################################
# h4: tetris experience vs workload
wkldDataAvg = integer(nSubs)
for (i in 1:nSubs) {
  wkldDataAvg[i] = mean(data1$WorkloadA[i], data1$WorkloadB[i], data1$WorkloadC[i], data1$WorkloadD[i])
}
shapiro.test(wkldDataAvg)

# h4a: tetris experience vs workload
r4a = cor(wkldDataAvg,data1$TetrisXP)
h4a = lm(wkldDataAvg~data1$TetrisXP)
plot(data1$TetrisXP,wkldDataAvg, main="H4a) Workload vs. Tetris Experience",
     xlab="Self-Rated Tetris Experience", ylab="Reported Workload [MBS]")
abline(h4a)


# h4b: high workload experience vs workload
r4b = cor(wkldDataAvg,data1$WorkloadXP)
h4b = lm(wkldDataAvg~data1$WorkloadXP)
plot(data1$WorkloadXP,wkldDataAvg, main="H4b) Workload vs. High-Workload Experience",
     xlab="Self-Rated High-Workload Experience", ylab="Reported Workload [MBS]")
abline(h4b)

################################## H5 ######################################
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