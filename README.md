# US Unemployment Rate Graph

Stata code for AEM 7010 (Cornell University, Spring 2026) that plots U.S. and state unemployment rates from FRED and the low-skill vs high-skill unemployment gap from IPUMS CPS microdata.

Files:
- Do File/AEM 7010 US Unemployment Rate Graph.do : main script. Part 1 merges the FRED series and plots the U.S., California, New York and Texas unemployment rates from 2000 with NBER recessions shaded. Part 2 keeps ages 25-54 in the CPS data, computes weighted annual unemployment rates for workers with a high school education or less and with a bachelor's degree or more, and plots the gap between them.
- readme.rtf : longer step-by-step notes on the data and methods

Data:
- Data/UNRATE.csv, CAUR.csv, NYUR.csv, TXUR.csv : monthly unemployment rates from FRED (U.S., California, New York, Texas)
- cps_00002.dta (not included) : IPUMS CPS extract with YEAR, AGE, EMPSTAT, EDUC and WTFINL. It is too large for GitHub and IPUMS does not allow redistribution, so download it from https://cps.ipums.org and save it in Data/.

Visualizations:
- Visualizations/Unemployment Rate Graph.png : Part 1 figure
- Visualizations/Unemployment Gap.png : Part 2 figure

To run: change the cd path at the top of the do file and the two graph export paths to your own folders, then run it in Stata.
