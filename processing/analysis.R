# import data
library(ggplot2)
library(ggpubr)
library(tidyverse)
library(broom)
library(AICcmodavg)
library(MASS)


data1 <- read.csv("processedData.csv")
nSubs = length(data1$Timestamp);

################################## H1 ######################################
# h1: Still to Do!
# alpha = slow/easy
# beta = fast/easy
# gamma = slow/hard
# delta = fast/hard
wkldData = c(data1$WorkloadA, data1$WorkloadB, data1$WorkloadC, data1$WorkloadD)
tetrisDiff = factor(c(rep(0,nSubs),rep(0,nSubs),rep(1,nSubs),rep(1,nSubs)))
wordSpd = factor(c(rep(0,nSubs),rep(1,nSubs),rep(0,nSubs),rep(1,nSubs)))
condition = c(rep(1,nSubs),rep(2,nSubs),rep(3,nSubs),rep(4,nSubs))
condition <- factor(condition)
levels(condition)<-c("Alpha [low/slow]","Beta [low/fast]","Gamma [high/slow]","Delta [high/fast]")
subjNum = (rep(1:nSubs,4))
block = factor(subjNum)

h1a = aov(wkldData~tetrisDiff+wordSpd)
summary(h1a)

boxplot(wkldData~condition, main="H1) Workload by Condition",
        xlab="Condition", ylab="Workload Rating")

interaction.plot(x.factor = wordSpd, trace.factor = tetrisDiff, response = wkldData, fun = median,   ylab = "Workload",
                 xlab = "Word Presentation Rate",
                 col = c("red", "blue"),
                 lty = 1, #line type
                 lwd = 2, #line width
                 trace.label = "Game Difficulty")


# hypothesis 1: 2-factor ANOVA
h1a <- aov(wkldData~tetrisDiff*wordSpd + Error(factor(subjNum)))
summary(h1a)
h1b <- aov(wkldData~tetrisDiff*wordSpd + block)
plot(h1b, pch = 16, col='darkslateblue', cex.lab=1.2, cex.axis=1.2, cex.main = 2)


h1c <- aov((wkldData)^(2/3)~tetrisDiff*wordSpd + block)
plot(h1c, pch = 16, col='darkslateblue', cex.lab=1.2, cex.axis=1.2, cex.main = 2)

h2b <- aov(prcsnData~tetrisDiff*wordSpd + block)
plot(h2b, pch = 16, col='darkslateblue', cex.lab=1.2, cex.axis=1.2, cex.main = 2)

h3b <- aov(rcllData~tetrisDiff*wordSpd + block)
plot(h3b, pch = 16, col='darkslateblue', cex.lab=1.2, cex.axis=1.2, cex.main = 2)



boxcox()
# to present! h1: non-parametric, friedmans anova with condition
h1f = friedman.test(wkldData,condition,subjNum)
summary(h1f)
boxplot(wkldData~condition, main="H1) Workload by Condition",
        xlab="Condition", ylab="Workload Rating",col=c("yellow","darkorange","orangered","red3"))

# some pairwise comparisons
wilcox.test(data1$WorkloadA,data1$WorkloadB, paired=TRUE)
wilcox.test(data1$WorkloadA,data1$WorkloadC, paired=TRUE)
wilcox.test(data1$WorkloadA,data1$WorkloadD, paired=TRUE)

wilcox.test(data1$WorkloadB,data1$WorkloadC, paired=TRUE)
wilcox.test(data1$WorkloadB,data1$WorkloadD, paired=TRUE)

wilcox.test(data1$WorkloadC,data1$WorkloadD, paired=TRUE)
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
hist(rcllData,main="Histogram of Recall",
     xlab="Recall %", ylab="Frequency")
shapiro.test(rcllData)
hist(data1$recallA*100 ,col='gold', add=TRUE)
shapiro.test(data1$recallA)
hist(data1$recallB*100, col='orange', add=TRUE)
shapiro.test(data1$recallB)
hist(data1$recallC*100, col='darkorange1', add=TRUE)
shapiro.test(data1$recallC)
hist(data1$recallD*100, col='red', add=TRUE)
shapiro.test(data1$recallD)

#h2: non-parametric, friedmans anova with condition
h2f = friedman.test(rcllData,condition,subjNum)
boxplot(rcllData~condition, main="H2) Recall % by Condition",
        xlab="Condition", ylab="Recall %",col=c("yellow","darkorange","orangered","red3"))


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
hist(prcsnData,main="Histogram of Precision", xlab="Precision %", ylab="Frequency")
shapiro.test(prcsnData)
hist(data1$precisionA*100, col='gold', add=TRUE)
shapiro.test(data1$precisionA)
hist(data1$precisionB*100, col='orange', add=TRUE)
shapiro.test(data1$precisionB)
hist(data1$precisionC*100, col='darkorange1', add=TRUE)
shapiro.test(data1$precisionC)
hist(data1$precisionD*100,col='red', add=TRUE)
shapiro.test(data1$precisionD)

#h3: non-parametric, friedmans anova with condition
h3f = friedman.test(prcsnData,condition,subjNum)
boxplot(prcsnData~condition, main="H3) Precision % by Condition",
        xlab="Condition", ylab="Precision %",col=c("yellow","darkorange","orangered","red3"))

# some pairwise comparisons
wilcox.test(data1$precisionA,data1$precisionB, paired=TRUE)
wilcox.test(data1$precisionA,data1$precisionC, paired=TRUE)
wilcox.test(data1$precisionA,data1$precisionD, paired=TRUE)

wilcox.test(data1$precisionB,data1$precisionC, paired=TRUE)
wilcox.test(data1$precisionB,data1$precisionD, paired=TRUE)

wilcox.test(data1$precisionC,data1$precisionD, paired=TRUE)

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
hist(wkldDataAvg)

# h4a: tetris experience vs workload
tetrisXP = rep(data1$TetrisXP,1)
h4a = lm(wkldDataAvg~tetrisXP)
wkldAvgExp = h4a$coefficients[2]*tetrisXP + h4a$coefficients[1]
residuals = wkldDataAvg-wkldAvgExp
plot(wkldAvgExp,abs(residuals))
h4b = lm(wkldAvgExp~abs(residuals))

h4ak = kruskal.test(wkldDataAvg,tetrisXP)
boxplot(wkldDataAvg~tetrisXP, main="H4) Workload and Tetris Experience",
        xlab="Self-Reported Tetris XP", ylab="Worklaod [MBS]", 
        col = c('mediumorchid1','mediumorchid2','mediumorchid3','mediumorchid4'),
        cex.lab=1.5, cex.axis=1.2, cex.main = 1.5, cex = 1.5,
        ylim = c(1,10))
axis(2, at = c(1:10),cex.axis=1.2)



# h4b: high workload experience vs workload
r4b = cor(wkldDataAvg,data1$WorkloadXP)
h4b = lm(wkldDataAvg~data1$WorkloadXP)
plot(data1$WorkloadXP,wkldDataAvg, main="H4b) Workload vs. High-Workload Experience",
     xlab="Self-Rated High-Workload Experience", ylab="Reported Workload [MBS]")
abline(h4b)

h4bk = kruskal.test(wkldDataAvg,data1$WorkloadXP)
boxplot(wkldDataAvg~data1$WorkloadXP, main="H4) Workload and Operational Experience",
        xlab="Self-Reported Workload XP", ylab="Worklaod [MBS]", 
        col = c('darkslategray1','darkslategray2','darkslategray3','darkslategray4','darkslategray'),
        cex.lab=1.5, cex.axis=1.2, cex.main = 1.5, cex = 1.5,
        ylim = c(1,10))lim = caxis(2, 1,1a))
t = c(1:10),cex.axis=1.2)



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



################################## H6-8 ######################################
# h6: is there an ordering effect on tetris score
# h7: is there an ordering effect on precision
trialNums = c(data1$TrialNumA, data1$TrialNumB, data1$TrialNumC, data1$TrialNumD)
h6f = friedman.test(scoreData,trialNums,subjNum)
boxplot(scoreData~trialNums, main="H6) Tetris Score by Trial Number",
        xlab="Trial #", ylab="Tetris Score")
h7f = friedman.test(prcsnData,trialNums,subjNum)
boxplot(prcsnData~trialNums, main="H7) Precision Data by Trial Number",
        xlab="Trial #", ylab="% Precision")
h8f = friedman.test(rcllData,trialNums,subjNum)
boxplot(rcllData~trialNums, main="H8) Recall Data by Trial Number",
        xlab="Trial #", ylab="% Recall")
h9f = friedman.test(wkldData,trialNums,subjNum)
boxplot(wkldData~trialNums, main="H9) Workload Rating by Trial Number",
        xlab="Trial #", ylab="Workload Rating")

################################## H9 ######################################
# h9: is there an effect of learning style on recall
learningStyle = factor(data1$LearnStyle)
rcllDataAvg = integer(nSubs)
for (i in 1:nSubs) {
  rcllDataAvg[i] = 100*mean(data1$recallA[i], data1$recallB[i], data1$recallC[i], data1$recallD[i])
}
shapiro.test(rcllDataAvg)
hist(rcllDataAvg)

h9k = kruskal.test(rcllDataAvg~learningStyle)
boxplot(rcllDataAvg~learningStyle, main="H9) Average Recall Data by Learning Style",
        xlab="Learning Style", ylab="Average Recall %",col = c("green","blue","purple"))

# some pairwise comparisons
wilcox.test(data1$precisionA,data1$precisionB, paired=TRUE)
wilcox.test(data1$precisionA,data1$precisionC, paired=TRUE)
wilcox.test(data1$precisionA,data1$precisionD, paired=TRUE)

################################### H10 ######################################
# h10: did we mess up randomization?
h10f = friedman.test(trialNums,condition,subjNum)
boxplot(wkldData~trialNums, main="Workload Rating by Trial Number",
        xlab="Trial #", ylab="Workload Rating",
        col = c('darkseagreen1','darkseagreen2','darkseagreen3','darkseagreen4'),
        cex.lab=1.5, cex.axis=1.2, cex.main = 1.5, cex = 1.5,
        ylim = c(1,10))
axis(2, at = c(1:10),cex.axis=1.2)


plot(condition,trialNums, main = "Trial Condition vs. Trial Order",
      xlab="Trial Condition", ylab="Order [place]",col=c("yellow","darkorange","orangered","red3"),
     cex.lab=1.5, cex.axis=1.2, cex.main = 1.5, cex = 1.5, yaxt = "n")
axis(2, at = c(1,2,3,4),cex.axis=1.2)

plot(data1$recallA*100, data1$precisionA*100, main="Precision vs. Recall", 
     ylab="Precision %", xlab="Recall %", pch = 16, col='gold2', xlim = c(0,100), ylim = c(0,100),
      cex.lab=1.5, cex.axis=1.2, cex.main = 1.5, cex = 1.5)
par(new=TRUE)
scatter(data1$recallB*100, data1$precisionB*100, pch = 16, col='orange',main="", 
        ylab="", xlab="", axes = FALSE, xlim = c(0,100), ylim = c(0,100), cex = 1.5)
par(new=TRUE)
plot(data1$recallC*100, data1$precisionC*100, pch = 16,col='darkorange1',main="", ylab="", xlab="",
     axes = FALSE, xlim = c(0,100), ylim = c(0,100), cex = 1.5)
par(new=TRUE)
plot(data1$recallD*100, data1$precisionD*100, pch = 16, col='red',main="", ylab="", xlab="",
     axes = FALSE, xlim = c(0,100), ylim = c(0,100), cex = 1.5)

