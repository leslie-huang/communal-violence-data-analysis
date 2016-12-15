# Leslie Huang
# Political Violence, Fall 2016
# Is diversity associated with communal violence?

set.seed(1234)

rm(list=ls())
setwd("/Users/lesliehuang/Dropbox/Fall 2016/Political Violence/Communal violence paper/communal-violence-data-analysis/")

libraries <- c("foreign", "utils", "stargazer", "dplyr", "devtools", "ggplot2", "stringr")
lapply(libraries, require, character.only = TRUE)

# Load ACLED violence data, source: http://www.acleddata.com/data/version-6-data-1997-2015/
acled_data <- read.csv("/Users/lesliehuang/Dropbox/Fall 2016/Political Violence/Communal violence paper/communal-violence-data-analysis/ACLED Version 6 All Africa 1997-2015_csv_dyadic.csv", stringsAsFactors = FALSE)
acled_data <- rename(acled_data, country = COUNTRY)
acled_data <- rename(acled_data, year = YEAR)

# Load Ethnic Power Relations data, source: http://www.epr.ucla.edu/
EPR_data <- foreign::read.dta("/Users/lesliehuang/Dropbox/Fall 2016/Political Violence/Communal violence paper/communal-violence-data-analysis/EPR3CountryNewReduced.dta")
# keep just the columns we want and rename some vars
EPR_data <- select(EPR_data, year:gdpcapl, popavg, polity2, polity, democ, groups, egipgrps:maxpop)
EPR_data <- rename(EPR_data, 
                   num_ethnopoli_relevant_groups = groups, 
                   num_incl_EPR_groups = egipgrps, 
                   num_excl_EPR_groups = exclgrps, 
                   relative_size_excl_pop = exclpop, 
                   ln_relative_size_ecl_pop = lrexclpop, 
                   total_ethnopoli_relevant_pop_percent = ttlpop, 
                   discrim_pop_percent = discpop, 
                   powerless_pop_percent = pwrlpop, 
                   only_local_pwr_pop_percent = olppop, 
                   only_local_sep_power_pop_percent = olpspop, 
                   jr_partner_pop_percent = jppop, 
                   sr_partner_pop_percent = sppop, 
                   dominant_pop_percent = dompop, 
                   monopoly_pop_percent = monpop, 
                   size_largest_excl_grp_pop_percent = maxexclpop, 
                   size_largest_incl_grp_pop_percent = maxegippop, 
                   size_largest_group_pop_percent = maxpop)

EPR_data$country[EPR_data$country == "Cote d'Ivoire"] <- "Ivory Coast"
EPR_data$country[EPR_data$country == "Democratic Republic of the Congo"] <- "Democratic Republic of Congo"

# because EPR data only goes until 2010, fill in 2011-2015 with 2010 data
EPR_fillers <- filter(EPR_data, year == 2010)

i <- 2011
while (i <= 2015) {
  EPR_fillers$year <- i
  EPR_data <- rbind(EPR_data, EPR_fillers)
  i <- i + 1
}


# Load polarization data, source: http://www.econ.upf.edu/%7Emontalvo/marta/marta.htm
polar_data <- read.csv("/Users/lesliehuang/Dropbox/Fall 2016/Political Violence/Communal violence paper/communal-violence-data-analysis/polarization.csv", stringsAsFactors = FALSE)
# rename some countries for merging
polar_data$country[polar_data$country == "Congo, Dem. Rep."] <- "Democratic Republic of Congo"
polar_data$country[polar_data$country == "Congo,. Rep."] <- "Republic of Congo"
polar_data$country[polar_data$country == "Cote d'Ivoire"] <- "Ivory Coast"
polar_data$country[polar_data$country == "Egypt, Arab Rep."] <- "Egypt"
polar_data$country[polar_data$country == "Gambia, The"] <- "Gambia"


# Load fractionalization data, source: http://www.anderson.ucla.edu/faculty_pages/romain.wacziarg/papersum.html
frac_data <- read.csv("/Users/lesliehuang/Dropbox/Fall 2016/Political Violence/Communal violence paper/communal-violence-data-analysis/Alesina fractionalization.csv", stringsAsFactors = FALSE)
frac_data <- subset(frac_data, select = c("Country", "Ethnic", "Language", "Religion"))
frac_data <- rename(frac_data, country = Country)

# Merged data

# ACLED x polarization: missing some countries
merged_polar <- left_join(acled_data, polar_data, by = "country")

# add in frac indices
merged <- left_join(merged_polar, frac_data, by = "country")

# add in EPR
merged <- left_join(merged, EPR_data, by = c("country", "year"))

# filtered for militias
any_militia <- filter(merged, INTER1 == 4 | INTER2 == 4)

intermilitia <- filter(merged, INTERACTION == 44)
