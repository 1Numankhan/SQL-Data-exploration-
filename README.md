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


## Let's Break it down into Continents
![carbon (4)](https://github.com/1Numankhan/SQL-Data-exploration-/assets/138983077/f603f651-32d0-4620-97b7-f9d88b99aba2)

|   Continent    | Total Deaths Count |
|----------------|--------------------|
| North America  |      1,127,152     |
| South America  |        704,659     |
|      Asia      |        532,027     |
|     Europe     |        399,999     |
|     Africa     |        102,595     |
|    Oceania     |         22,887     |

## Total Deaths and cases worldwide

``` 

SELECT

  SUM(new_cases) AS TotalCases,
  SUM(new_deaths) AS TotalDeaths,
  (SUM(new_deaths) / SUM(new_cases)) * 100 AS TotalDeathPercentage --  Totalcases = 770644152 , TotalDeaths = 6963700, percentage 0.9036% 
FROM
  `my-data-science-project-123.covid_deaths.Coivddeaths_19`
WHERE
  continent IS NOT NULL
```
|  Total Cases  |  Total Deaths  |  Total Death Percentage  |
|--------------|----------------|--------------------------|
|  770,644,152  |     6,963,700    |         0.9036%         |

**key finding**
- Total Cases in the world is 770,644,152
- Total Deaths is   6,963,700
- which makes up 0.9036% of the world's Populations

This  insight is all about the COVID deaths and cases worldwide in the continents, countries,  and regions.


# Covid Vaccinations data 
Extract insights from the vaccination data 

Joining the tables
``` SQL

 SELECT 
 * 
 FROM `my-data-science-project-123.covid_deaths.Coivddeaths_19` death
 
 join `my-data-science-project-123.covid_vaccinations.Vaccination` vacc
 On death.location = vacc.location
 and death.date = vacc.date;
```
**Key Finding**
 - looking for the Total Population vs. vaccination 
- How many people got vaccinated in the world 
- china is led in the vaccination program


## Vaccinated Country by Populations
![carbon (5)](https://github.com/1Numankhan/SQL-Data-exploration-/assets/138983077/5ca599b2-95c1-4e2c-87df-fb0da2c8c565)


|  Location  |     Date     |  Population  |  Continent  | New Vaccinations | Rolling People Vaccinated | Vaccination Percentage |
|------------|--------------|--------------|-------------|------------------|---------------------------|------------------------|
|  Zimbabwe  |  2023-08-14  |  16,320,539  |   Africa    |       null       |        10,801,392         |        66.18%          |



## **Key insights from the **Covid-19** data 
key finding
1. I found the maximum **total cases percentage** which is 0.67% of the total population of **Pakistan**
2. **Cyprus** is the most affected by COVID-19 based on its population
which makes up **73.75** %of its populations
3. United States with the **mostdeathsCounts** which is **1127152** and the data is authentic.
4.  North America** which is the most affected continent 	**1,127,152** Total Death counts  till now.
5.  **Total Cases** in the world is **770,644,152**
**Total Deaths is 6,963,700** which makes up **0.9036**%of the world's Population



