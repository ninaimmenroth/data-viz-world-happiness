# correlation matrix plot
library(corrplot)

# load data
whr <- read.csv("Data/WHR_AllYears.csv")

#remove non-numeric variables
whr_num <- whr[, c(3,4,5,6,7,8,9,10)]
whr_num$perceptions_of_corruption <- as.numeric(whr_num$perceptions_of_corruption)

# remove NaN values
whr_num_nonan <- na.omit(whr_num)

# calculate correlation
whr_cor <- cor(whr_num_nonan)
whr_cor

# shorten the variable names for the plot
new_names <- c("HS", "GpC", "SS", "HLE", "FtmLC", "G", "PoC", "Y")
colnames(whr_cor) <- new_names
rownames(whr_cor) <- new_names

# calculate p-values
testRes <- cor.mtest(whr_num_nonan, conf.level = 0.95)
colnames(testRes$p) <- new_names
rownames(testRes$p) <- new_names

corrplot.mixed(whr_cor,p.mat = testRes$p, order = 'AOE')

corrplot(whr_cor, p.mat = testRes$p, method = 'circle', type = 'lower', insig='blank',
         addCoef.col ='black', number.cex = 0.8, order = 'AOE', diag=FALSE)



