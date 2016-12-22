* Leslie Huang
* MA paper

* set up the workspace
clear all
set more off
cd "/Users/lesliehuang/Dropbox/Fall 2016/Political Violence/Communal violence paper/communal-violence-data-analysis"
capture log close
log using communal_violence.log, replace

set seed 1234

* import data from R: already cleaned and transformed
use data.dta

encode country, gen(country1)
xtset country1 year

* drop South Sudan
drop if country == "South Sudan"

* HYPOTHESIS 1 The existence of a dominant ethnic group is positively associated with ethnic communal violence.

* National

reg ln_num_incidents size_largest_group_pop_percent ln_gdpcap ln_pop polity, vce(cluster country)
outreg2 using table1, tex replace title(Table 1: Ethnic dominance) ctitle(Percent share) paren se bdec(3) nocons

reg ln_num_incidents size_largest_excl_grp_pop_prcnt ln_gdpcap ln_pop polity, vce(cluster country)
outreg2 using table1, tex append paren se bdec(3) nocons


reg ln_num_incidents ethdom_dummy50 ln_gdpcap ln_pop polity, vce(cluster country)
outreg2 using table1, tex append ctitle(Dummy for >50% share) paren se bdec(3) nocons

reg ln_num_incidents ethdom_dummy60 ln_gdpcap ln_pop polity, vce(cluster country)
outreg2 using table1, tex append ctitle(Dummy for >60% share) paren se bdec(3) nocons

reg ln_num_incidents ethdom_dummy70 ln_gdpcap ln_pop polity, vce(cluster country)
outreg2 using table1, tex append ctitle(Dummy for >70% share) paren se bdec(3) nocons


* Local: Nigeria data


* HYPOTHESIS 2 Ethnic polarization is positively associated with ethnic communal violence. 

reg ln_num_incidents ETHPOL ln_gdpcap ln_pop polity, vce(cluster country)
outreg2 using table2, tex replace title(Table 2: Polarization) ctitle(Ethnic) paren se bdec(3) nocons

reg ln_num_incidents RELPOL ln_gdpcap ln_pop polity, vce(cluster country)
outreg2 using table2, tex append ctitle(Religious) paren se bdec(3) nocons


* HYPOTHESIS 3 Higher levels of ethnic exclusion from power are associated with higher levels of ethnic communal violence.

reg ln_num_incidents size_largest_excl_grp_pop_prcnt ln_gdpcap ln_pop polity, vce(cluster country)
outreg2 using table3, tex replace title(Table 3: Exclusion from Political Power) ctitle(Ethnic exclusion) paren se bdec(3) nocons

reg ln_num_incidents powerless_pop_percent ln_gdpcap ln_pop polity, vce(cluster country)
outreg2 using table3, tex append ctitle(Powerless pop.) paren se bdec(3) nocons

reg ln_num_incidents discrim_pop_percent ln_gdpcap ln_pop polity, vce(cluster country)
outreg2 using table3, tex append ctitle(Discriminated pop.) paren se bdec(3) nocons


* HYPOTHESIS 4 Raw measures of diversity are not positively associated with the incidence of ethnic communal violence.

* xtreg ln_num_incidents ETHFRAC, fe
*reg ln_num_incidents ETHFRAC i.country1

reg ln_num_incidents Ethnic ln_gdpcap ln_pop polity, vce(cluster country)
outreg2 using table4, tex replace title(Table 4: Diversity and Incidence of Violence) ctitle(Ethnic) paren se bdec(3) nocons

reg ln_num_incidents Religion ln_gdpcap ln_pop polity, vce(cluster country)
outreg2 using table4, tex append ctitle(Religion) paren se bdec(3) nocons

reg ln_num_incidents Language ln_gdpcap ln_pop polity, vce(cluster country)
outreg2 using table4, tex append ctitle(Language) paren se bdec(3) nocons


* HYPOTHESIS 5 Raw measures of diversity are positively associated with mean intensity of violence.

reg ln_avg_fatalities Ethnic ln_gdpcap ln_pop polity, vce(cluster country)
outreg2 using table5, tex replace title(Table 5: Diversity and Intensity of Violence) ctitle(Ethnic) paren se bdec(3) nocons

reg ln_avg_fatalities Religion ln_gdpcap ln_pop polity, vce(cluster country)
outreg2 using table5, tex append ctitle(Religion) paren se bdec(3) nocons

reg ln_avg_fatalities Language ln_gdpcap ln_pop polity, vce(cluster country)
outreg2 using table5, tex append ctitle(Religion) paren se bdec(3) nocons

