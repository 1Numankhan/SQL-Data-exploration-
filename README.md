# SQL-Data-exploration-
# COVID-19 DATA  Analysis with BigQuery

## Overview

This project leverages Google BigQuery to analyze the COVID-19 dataset, providing insights into the pandemic's impact on various regions and populations. The analysis includes key metrics such as total cases, total deaths, vaccination rates, and more. This README provides an overview of the queries used and their findings. finding the total cases and total deaths in percentage based on the population of the regions and countries.

## Queries

### Total Deaths and Cases by Location and Date
### Show the likelihood of dying if you contract COVID in these countries
```sql

 -- looking to the total cases vs Total deaths
 -- show the likelihood of dying if you contract COVID in your country
 SELECT  location, date, total_cases,total_deaths,(total_deaths/total_cases)*100 as deathPercentage
 from `my-data-science-project-123.covid_deaths.Coivddeaths_19`
```
|   Location   |     Date     |  Total Cases  | Total Deaths | Death Percentage |
|--------------|--------------|--------------|--------------|------------------|
| Afghanistan  |  2023-09-13  |    225,568   |     7,945    |      3.52%       |


## COVID SCENARIO IN PAKISTAN
 Total cases vs. Total population so I am from Pakistan I will filter the location to Pakistan 
```sql

 SELECT 
 location,date,total_cases,population,(total_cases/population)*100 as CasesPercentage 
 from `my-data-science-project-123.covid_deaths.Coivddeaths_19`
 WHERE location LIKE 'P%'
 ORDER BY 1,2;
```
### **Key finding**
- I found the maximum total cases percentage which is 0.67% of the total population of Pakistan
  
|  Location  |    Date    |  Total Cases  |  Population   | Cases Percentage |
|------------|------------|---------------|---------------|------------------|
|  Pakistan  | 2023-09-13|     1580631     |   235,824,864 |     0.67%      |


### Most affected Countries from the Covid infection 
The data is current and I checked it on Google which is 100 % authentic It's in the year 2023 based  on the population Cyprus is the most effected c
``` SELECT
location,
population,
MAX(total_cases) as HighestCovidCases ,MAX(total_cases/population)*100 as PercentPOPeffected 
FROM `my-data-science-project-123.covid_deaths.Coivddeaths_19`                             
group by location,
population
ORDER BY percentPOPeffected DESC;
```
**Key finding**
- Cyprus is the most affected by COVID-19 based on its population
- which make up 73.75 % of its populations
  

| Location | Population  | Highest Covid Cases | Percent Population Effected |
|----------|------------|---------------------|-----------------------------|
|  Cyprus  |   896,007  |       660,854       |          73.76%             |


## Country With the Highest Death
```sql
SELECT
location,
MAX(total_deaths) AS TotalDeathsCounts
FROM `my-data-science-project-123.covid_deaths.Coivddeaths_19`  
WHERE continent is not NULL                             
group by location


ORDER BY TotalDeathsCounts DESC;
```
**key finding**
-  United States with the mostdeathsCounts which is 1127152  and the data is authentic.
  
|   Location    | Total Deaths Counts |
|---------------|----------------------|
| United States |       1,127,152      |

