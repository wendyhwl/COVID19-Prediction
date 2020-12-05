# Total Infected Number Prediction for COVID-19

Creating estimated numbers of the currently infected, susceptible and recovered cases of COVID-19 using a mathematical epidemic prediction model called the SIR model

## Table of Contents
- [Setup](#Setup)
- [SIR Model](SIR-Model)
- [Result](#Result)
- [Additional Info](#Additional-Info)
- [Contributors](#Contributors)

## Setup
### Steps for running the code
1) Run findMinCost.m to produce the best beta and gamma values for the global data (min_b and min_g).
2) Pass min_b and min_g as arguments to SIR.m. For example, if min_b = 0.1 and min_g = 0.03, then you would call 'SIR(0.1, 0.03);' in the command window.

## SIR Model
The SIR model is a predictive model for infectious diseases that generates proportions of susceptible, infected, and recovered (or dead) populations given initial parameters. By using data collected on COVID-19, this model can be used to predict the number of people infected with the disease, and to approximate when to expect the peak and end of the pandemic.

There are many examples of SIR models for general use (without sample data) as well
as for specific viruses such as COVID-19. One such model that exists for COVID-19
is the fitVirusCV19v3 (COVID-19 SIR Model) [1] for MATLAB, which retrieves the
latest data, estimates the initial parameters using this data, and then uses both the data
and initial parameters to form the SIR model. Other models have focused on specific
countries, such as the COVID-19 data with SIR model on Italy and Japan. This 
model divides the data into “phases” based on measures that were taken by the countries’ governments and tweaks the parameters for each phase. 

###

## Result
After creating the SIR model in MATLAB, we attempted to create projections by calculating the rates of infection and recovery and deriving the parameters from these rates. The resulting projections were not accurate enough, therefore we looked to create an optimization function that would provide us with more accurate parameters.
The optimization function produced parameters that in turn produced a much more accurate projection, allowing us to chart the potential peak of the virus. According to our projections, the peak will likely take place around April 24th, 2020 and will see a total number of infections at roughly 1.8 million.

Although the prediction model and the assumptions are very basic and lack of consideration of real-life situations the prediction its making are meaningful in a way of providing an idea of the size of the epidemic. The accuracy of such basic model is somewhat surprising. Using the data until April 13th, the prediction shows the on the 17th the total infection number is 1,504,000 and the total recover plus death 732,500, and the actual numbers from the 17th are 1,530,689(+1.7%) and 727,769(+0.6%) compared to the prediction using such model. 

See [report](https://github.com/wendyhwl/COVID19-Prediction/blob/main/report.pdf) for detail results.

## Additional Info
- If a country name is passed as a third argument to SIR, the model will show the actual data for that country and attempt to run the SIR model with the given 
beta and gamma values. However, findMinCost is only set up to find the best beta and gamma values for the global data, therefore we do not have the optimal
values for each country. As mentioned in the report, this is something we would like to address in the future.
- The model can only run on countries whose populations are recorded inside of pop.mat. If you wish to run the model on a country that is not currently listed
in this file, you must add it in manually and save the mat file.
- 'covid_confirmed.csv', 'covid_deaths.csv', and 'covid_recovered.csv' are from https://data.humdata.org/dataset/novel-coronavirus-2019-ncov-cases, as mentioned in the report.
- The total population in the SIR model is divided by 1.6 as this yielded more accurate results. This is just an adjustment on the population and not particularly
interesting with regards to how the SIR model works, so we omitted this from the calculations in the report.

## Contributors
Jianhong Chen, Sheldon Fries, Wendy Huang, Shanila Javed and James Young
