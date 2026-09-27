
**** AEM 7010 Project: US Unemployment Rate Graph *****

clear all 

* Set working directory 
cd "/Users/zakserby/Documents/Documents (MAC)/Cornell University/Spring 2026/Doing Applied Ecnomics/US-Unemployment-Rate-Graph/Data"

******************************************************************
*************************** PART 1 *******************************
******************************************************************

* Import the Unemployment Rate data
import delimited "CAUR.csv", clear
tempfile CA_UR
save `CA_UR'

import delimited "NYUR.csv", clear
tempfile NY_UR
save `NY_UR'

import delimited "TXUR.csv", clear
tempfile TX_UR
save `TX_UR'

* Merge the data and use US as master (only keeping entries between 2000-01-01 to 2026-02-01)
import delimited "UNRATE.csv", clear
merge 1:1 observation_date using `CA_UR'
drop if _merge == 1
drop _merge
* Note that the dropped merges were 2 entries after 2026-01-01
merge 1:1 observation_date using `NY_UR'
drop _merge
merge 1:1 observation_date using `TX_UR'
drop _merge

* Plot the national unemployment rate and states on a graph. Shaded area indicate NBER-defined recessions
* Observation data convert to numeric
gen date = daily(observation_date, "YMD")
format date %td
* Upper bound for shading
gen upper = 20

* Plot graph
twoway ///
    (area upper date if inrange(date, td(01mar2001), td(01nov2001)), color(gs14)) ///
    (area upper date if inrange(date, td(01dec2007), td(01jun2009)), color(gs14)) ///
    (area upper date if inrange(date, td(01feb2020), td(01apr2020)), color(gs14)) ///
    (line unrate date, lc(navy) lwidth(medthick)) ///
    (line caur date, lc(cranberry)) ///
    (line nyur date, lcolor(forest_green)) ///
    (line txur date, lcolor(orange_red)) ///
, ///
    title("Unemployment Rates: US vs Selected States") ///
    ytitle("Unemployment Rate (%)") ///
    xtitle("Date") ///
    legend(order(4 "US" 5 "California" 6 "New York" 7 "Texas") pos(6) row(1)) ///
    scheme(s1color)
	
graph export "/Users/zakserby/Documents/Documents (MAC)/Cornell University/Spring 2026/Doing Applied Ecnomics/US-Unemployment-Rate-Graph/Visualizations/Unemployment Rate Graph.png", replace

	
******************************************************************
*************************** PART 2 *******************************
******************************************************************

* Import the IPUMS data 
use "cps_00002.dta", clear

* Keep correct age in sample (25–54)
keep if age >= 25 & age <= 54

* Weighted Statistics: Calculate the annual weighted unemployment rate for two groups: High-Skilled and Low-Skilled
* First generating variables for unemployed and employed individuals
gen employed = inlist(empstat, 1, 10, 12)
gen unemployed = inlist(empstat, 21, 22)
gen labor_force = employed | unemployed

* Generating unemployed as a binary
gen u = unemployed

* Creating variable for skill (differentiates high skill as 1 and low skills as 0)
gen skill = .
* Low skill: high school or less
replace skill = 0 if inlist(educ, 2, 10, 20, 30, 40, 50, 60, 71, 73)
* High skill: bachelor's or more
replace skill = 1 if inlist(educ, 111, 123, 124, 125)
* Since we only care about high and low skilled but not inbetween as stated in the project guidelines, we drop observations like (e.g. some college and no degree)
drop if missing(skill)

* Weight the unemployment variables
gen u_w  = unemployed * wtfinl
gen lf_w = labor_force * wtfinl

* Collapse to anual and skill group level
collapse (sum) u_w lf_w, by(year skill)
* Compute unemployment rate
gen unemp_rate = u_w / lf_w

* Now create graph 
keep year skill unemp_rate
reshape wide unemp_rate, i(year) j(skill) 
gen gap = unemp_rate0 - unemp_rate1
twoway (line gap year, lc(navy) lwidth(medthick)), ///
       title("Unemployment Gap: Low-Skilled minus High-Skilled") ///
       ytitle("Unemployment Rate Gap") ///
       xtitle("Year") ///
       xlabel(2010(2)2024)
	   
graph export "/Users/zakserby/Documents/Documents (MAC)/Cornell University/Spring 2026/Doing Applied Ecnomics/US-Unemployment-Rate-Graph/Visualizations/Unemployment Gap.png", replace

















	
	
	
	
	


