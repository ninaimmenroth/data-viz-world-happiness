library(tidyverse)

# load data
whr <- read.csv("Data/WHR_AllYears.csv")
whr_me_na <- subset(whr, region=="Middle East and North Africa")
str(whr_me_na)

ggplot(whr_me_na, aes(x = happiness_score)) +
  geom_freqpoly(bins = 10) +
  ggtitle("Distribution of Happiness Score for Middle East and North Africa") +
  xlab("Happiness Score") +
  theme(text = element_text(size = 15))
