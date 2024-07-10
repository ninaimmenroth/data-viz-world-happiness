# combine datasets of World Happiness for each year into one

# load all data

whr15 <- read.csv("Data/WHR each year/WHR_2015.csv")
whr16 <- read.csv("Data/WHR each year/WHR_2016.csv")
whr17 <- read.csv("Data/WHR each year/WHR_2017.csv")
whr18 <- read.csv("Data/WHR each year/WHR_2018.csv")
whr19 <- read.csv("Data/WHR each year/WHR_2019.csv")
whr20 <- read.csv("Data/WHR each year/WHR_2020.csv")
whr21 <- read.csv("Data/WHR each year/WHR_2021.csv")
whr22 <- read.csv("Data/WHR each year/WHR_2022.csv")
whr23 <- read.csv("Data/WHR each year/WHR_2023.csv")

# add a variable year to each set
whr15$year <- 2015
whr16$year <- 2016
whr17$year <- 2017
whr18$year <- 2018
whr19$year <- 2019
whr20$year <- 2020
whr21$year <- 2021
whr22$year <- 2022
whr23$year <- 2023

# concatenate all dfs
whr_all_years <- rbind(whr15, whr16, whr17, whr18, whr19, whr20, whr21, whr22, whr23)

# save df to csv
write.csv(whr_all_years, "Data/WHR_AllYears.csv", row.names = FALSE)
