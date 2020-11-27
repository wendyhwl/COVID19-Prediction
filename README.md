Steps for running the code:
1) Run findMinCost.m to produce the best beta and gamma values for the global data (min_b and min_g).
2) Pass min_b and min_g as arguments to SIR.m. For example, if min_b = 0.1 and min_g = 0.03, then you would call 'SIR(0.1, 0.03);' in the command window.

Additional info:
- If a country name is passed as a third argument to SIR, the model will show the actual data for that country and attempt to run the SIR model with the given 
beta and gamma values. However, findMinCost is only set up to find the best beta and gamma values for the global data, therefore we do not have the optimal
values for each country. As mentioned in the report, this is something we would like to address in the future.
- The model can only run on countries whose populations are recorded inside of pop.mat. If you wish to run the model on a country that is not currently listed
in this file, you must add it in manually and save the mat file.
- 'covid_confirmed.csv', 'covid_deaths.csv', and 'covid_recovered.csv' are from https://data.humdata.org/dataset/novel-coronavirus-2019-ncov-cases, as
mentioned in the report.
- The total population in the SIR model is divided by 1.6 as this yielded more accurate results. This is just an adjustment on the population and not particularly
interesting with regards to how the SIR model works, so we omitted this from the calculations in the report.