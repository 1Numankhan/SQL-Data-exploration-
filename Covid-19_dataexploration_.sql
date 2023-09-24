
--looking at the total deaths and cases

SELECT location, date, total_cases, new_cases,total_deaths,population
 FROM `my-data-science-project-123.covid_deaths.Coivddeaths_19`
 order by 1,2 ;
 


 -- looking to the total cases vs Total deaths
 -- show likelihood of dying if you contract covid in your country
 SELECT  location, date, total_cases,total_deaths,(total_deaths/total_cases)*100 as deathPercentage
 from `my-data-science-project-123.covid_deaths.Coivddeaths_19`

 order by 1,2 DESC;


 -- Total cases vs Total populattion so I from pakistan I will filtered the location to pakistan 
 SELECT 
 location,date,total_cases,population,(total_cases/population)*100 as CasesPercentage 
 from `my-data-science-project-123.covid_deaths.Coivddeaths_19`
 WHERE location LIKE 'P%'
 ORDER BY 1,2;


 -- i find the maximum totalcases percentage which is 0.67% of the total population of pakistan
 -- date 2023-09-13, totalcases = 1580631 population = 235824864, casespercentage = 0.67%

 WITH PercentageData AS (
  SELECT 
    location,
    date,
    total_cases,
    population,
    (total_cases / population) * 100 as CasesPercentage
  FROM `my-data-science-project-123.covid_deaths.Coivddeaths_19`
  WHERE location LIKE '%Pakistan%'
)
SELECT 
  location,
  date,
  total_cases,
  population,
  CasesPercentage
FROM PercentageData
WHERE CasesPercentage = (SELECT MAX(CasesPercentage) FROM PercentageData)
ORDER BY location, date;


-- Most affected Countried from the Covid infection
SELECT
location,
population,
MAX(total_cases) as HighestCovidCases ,MAX(total_cases/population)*100 as PercentPOPeffected -- cyprus is the most effected by covid based on its population 
FROM `my-data-science-project-123.covid_deaths.Coivddeaths_19`                               -- which make 73.75 % of its populations 
group by location,
population
ORDER BY percentPOPeffected DESC;



-- Countries with the highest death counts
SELECT
location,
MAX(total_deaths) AS TotalDeathsCounts
FROM `my-data-science-project-123.covid_deaths.Coivddeaths_19`  -- United States with the mostdeathsCounts which is 1127152 
WHERE continent is not NULL                             
group by location


ORDER BY TotalDeathsCounts DESC;



--lets break down by continents
SELECT continent,
MAX(total_deaths) as totaldeathscount
FROM `my-data-science-project-123.covid_deaths.Coivddeaths_19`  -- North America with most death cases which 1127152
where continent is not NULL
group by continent
Order by totaldeathscount DESC;

-- Total deaths and cases worldwide

SELECT

  SUM(new_cases) AS TotalCases,
  SUM(new_deaths) AS TotalDeaths,
  (SUM(new_deaths) / SUM(new_cases)) * 100 AS TotalDeathPercentage --  Totalcases = 770644152 , TotalDeaths = 6963700, percentage 0.9036% 
FROM
  `my-data-science-project-123.covid_deaths.Coivddeaths_19`
WHERE
  continent IS NOT NULL

ORDER BY
  TotalCases, TotalDeaths;




-- So we have two Tables to explore one is about the Covid deaths and second is about Covid vaccination 
-- Now lets explore the vaccination data 

SELECT * 
FROM `my-data-science-project-123.covid_vaccinations.Vaccination`;
 
 --lets joins both table
 SELECT 
 * 
 FROM `my-data-science-project-123.covid_deaths.Coivddeaths_19` death
 
 join `my-data-science-project-123.covid_vaccinations.Vaccination` vacc
 On death.location = vacc.location
 and death.date = vacc.date;

 -- looking for the Total Population Vs Vaccination 
-- How many poeple got vaccinated in the world 
-- china is leaded inthe vaccination porgram
SELECT 
 death.location,death.date,death.population,death.continent,vacc.new_vaccinations
 FROM `my-data-science-project-123.covid_deaths.Coivddeaths_19` death
 
 join `my-data-science-project-123.covid_vaccinations.Vaccination` vacc
 On death.location = vacc.location
  and death.date = vacc.date 
 where death.continent is not null
ORder by 2,3 DESC;

--adding partition by to the query adding new_vaccination


-- use CTE population vs vaccination

SELECT 
 death.location,death.date,death.population,death.continent,vacc.new_vaccinations,
 SUM(vacc.new_vaccinations) over (partition by death.location order by death.location,death.date) as RollligPeopleVaccinated
 FROM `my-data-science-project-123.covid_deaths.Coivddeaths_19` death
 
 join `my-data-science-project-123.covid_vaccinations.Vaccination` vacc
 On death.location = vacc.location
  and death.date = vacc.date 
 where death.continent is not null
ORder by 2,3 ;


 /* SELECT
    death.location,
    death.date,
    death.population,
    death.continent,
    vacc.new_vaccinations,
    sum(vacc.new_vaccinations) over (partition by death.location order by death.location, death.date) as RollingpeopleVaccinated
  FROM
    `my-data-science-project-123.covid_deaths.Coivddeaths_19` death
  JOIN
    `my-data-science-project-123.covid_vaccinations.Vaccination` vacc
  ON
    death.location = vacc.location
    and death.date = vacc.date
  WHERE
    death.continent is not null
)*/

-- USE CTE
-- popvsvac


WITH popvsvacc AS (
  SELECT 
    death.location,
    death.date,
    death.population,
    death.continent,
    vacc.new_vaccinations,
    SUM(vacc.new_vaccinations) OVER (PARTITION BY death.location ORDER BY death.location, death.date) AS RollingPeopleVaccinated
  FROM `my-data-science-project-123.covid_deaths.Coivddeaths_19` death
  JOIN `my-data-science-project-123.covid_vaccinations.Vaccination` vacc
  ON death.location = vacc.location
  AND death.date = vacc.date 
  WHERE death.continent IS NOT NULL
)
SELECT *,(RollingPeopleVaccinated/population)*100 as vaccinationinpercentage
FROM popvsvacc;
--ORder by vaccinationinpercentage DESC ;


-- TEMP TABLE
CREATE TABLE vaccination.percentpopulationvaccinated (
  Continent STRING,
  location STRING,
  date DATETIME,
  population INT64,
  new_vaccinations NUMERIC,
  RollingPeopleVaccinated NUMERIC
);


   INSERT INTO percentpopulationvaccinated
SELECT 
  death.location,
  death.date,
  death.population,
  death.continent,
  vacc.new_vaccinations,
  SUM(vacc.new_vaccinations) OVER (PARTITION BY death.location ORDER BY death.location, death.date) AS RollingPeopleVaccinated
FROM `my-data-science-project-123.covid_deaths.Coivddeaths_19` death
JOIN `my-data-science-project-123.covid_vaccinations.Vaccination` vacc
ON death.location = vacc.location
AND death.date = vacc.date 
WHERE death.continent IS NOT NULL;

-- Calculate vaccination percentage
SELECT *,
       (RollingPeopleVaccinated / population) * 100 as vaccinationinpercentage
FROM percentpopulationvaccinated;

  
 --creating a View to store data for  later visualization

CREATE VIEW
percentpopulationvaccinated 
AS 
  SELECT 
    death.location,
    death.date,
    death.population,
    death.continent,
    vacc.new_vaccinations,
    SUM(vacc.new_vaccinations) OVER (PARTITION BY death.location ORDER BY death.location, death.date) AS RollingPeopleVaccinated
  FROM `my-data-science-project-123.covid_deaths.Coivddeaths_19` death
  JOIN `my-data-science-project-123.covid_vaccinations.Vaccination` vacc
  ON death.location = vacc.location
  AND death.date = vacc.date 
  WHERE death.continent IS NOT NULL
