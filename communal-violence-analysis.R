# Leslie Huang
# Political Violence, Fall 2016
# Is diversity associated with communal violence?

set.seed(1234)

libraries <- c("foreign", "utils", "stargazer", "dplyr", "devtools", "ggplot2", "stringr")
lapply(libraries, require, character.only = TRUE)

acled_data <- read.csv("/Users/lesliehuang/Dropbox/Fall 2016/Political Violence/Communal violence paper/data/ACLED Version 6 All Africa 1997-2015_csv_dyadic.csv", stringsAsFactors = FALSE)
# data from http://www.acleddata.com/data/version-6-data-1997-2015/

militia_data <- filter(acled_data, INTER1 == 4 | INTER2 == 4)

intermilitia_data <- filter(acled_data, INTERACTION == 44)
