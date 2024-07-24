# needed libraries
library(randomForest)
library(tidyverse)

# load data
whr <- read.csv("Data/WHR_AllYears.csv")

summary(whr)
str(whr)
?str

table(whr$country)
# some countries don't appear 9 times / "each year" in the data

table(whr$region)

table(whr$year)
# over time there are less countries present in the data

# given happiness score is the most important feature we want to look at:
# how does it interact with the other variables?

attach(whr)

# country not plotted because too smallgrained

boxplot(happiness_score ~ region, las = 2, xlab = "")
# Western Europe and North America / ANZ are the happiest in the world
# Sub Saharan Africa is lowest
# North Africa has a big variance

plot(happiness_score, gdp_per_capita)
# higher gdp per capita means higher happiness score

plot(happiness_score, social_support)
# higher social support means higher happiness

plot(happiness_score, healthy_life_expectancy)
# higher (better?) healthy life expectancy means higher happiness

plot(happiness_score, freedom_to_make_life_choices)
# more freedom for life choices means higher happiness

plot(happiness_score, generosity)
# rather mixed, no real connection

plot(happiness_score, perceptions_of_corruption)
# generally there's a lot of values that are low on perception of corruption
# for the high happy values there's a lot of strong perception of corruption
# which is weird

boxplot(happiness_score ~ year)
# for the median values there is an upwards trend over the years
# quite a big variance in 2020 and 2023

detach(whr)

# find out which features influence the happiness score the most when training
# a random forest model
# just out of curiosity

# do copy of data set without NAs
whr_noNA <- na.omit(whr)

# train random forest
set.seed(1)
rf.whr <- randomForest(happiness_score ~ ., data = whr_noNA, mtry = 6, ntRee = 100,
                       importance = TRUE)

# plot importance of variables
varImpPlot(rf.whr)
# %IncMSE indicates the increase of the mean squared error when the variable
# is randomly permuted
# IncNodePurity is a measure of how much the model error increases when a particular
# variable is randomly permuted or shuffled

# top variables change depending on the seed and the mtry variable set
# however the bottom with year, social_support and generosity is stable over
# each iteration
# the first 4 are also pretty stable, even if they can switch places


# look at connections between all numerical variables
whr_sub <- whr[,-c(1,2,10)]
pairs(whr_sub)

# try pca on subset with numerical variables
# fix perception of corruption to be numeric
whr_sub$perceptions_of_corruption <- as.numeric(whr_sub$perceptions_of_corruption)
# filter rows where perceptions_of_corruption is NA
whr_sub <- na.omit(whr_sub)
pr.out <- prcomp(whr_sub, scale = TRUE)
summary(pr.out)

# get percent of variance of each principal component
perc <- pr.out$sdev/sum(pr.out$sdev)

# plot it
plot(perc, xlab = "Principal Component", ylab = "Proportion of Variance Explained", ylim = c(0,1), type = "b")
# wow this is kinda sad

# ok trying kmeans without pca only on the numerical variables
# find out good k with sum of squares
sc_whr <- scale(whr_sub)
wss <- c()
for (k in 2:7) {
  km.out <- kmeans(sc_whr, centers = k, nstart = 20)
  wss <- append(wss, km.out$tot.withinss)
}
plot(wss, xlab = "k", ylab = "WSS", type = "b")
# decrease is quite consistent, let's take k = 2

km.out <- kmeans(whr_sub, centers = 2, nstart = 20)
km.out

# show scatterplots again coloured by assigned cluster
pairs(sc_whr, col = km.out$cluster, pch = 16)
# for each plot where the happiness score is involved, we see clear clusters

# correlation matrix plot
library(corrplot)

#remove non-numeric variables
whr_num <- whr[, c(3,4,5,6,7,8,9,10)]
whr_num$perceptions_of_corruption <- as.numeric(whr_num$perceptions_of_corruption)

# remove NaN values
whr_num_nonan <- na.omit(whr_num)

# calculate correlation
whr_cor <- cor(whr_num_nonan)

# calculate p-values
testRes <- cor.mtest(whr_num_nonan, conf.level = 0.95)

corrplot.mixed(whr_cor, order = 'AOE')

corrplot(whr_cor, p.mat = testRes$p, method = 'circle', type = 'lower', insig='blank',
         addCoef.col ='black', number.cex = 0.8, order = 'AOE', diag=FALSE)



