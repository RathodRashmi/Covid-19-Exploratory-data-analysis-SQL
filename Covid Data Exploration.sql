/*
Covid 19 Data Exploration 

Skills used: Joins,Windows Functions, Aggregate Functions, Converting Data Types
LANGUAGE sql;
*/


/*
 NOTE - continent IS NOT NULL and it is frequently used in queries
dataset also includes continents in location column - North America, Asia, Africa, Oceania, South America, Europe
continent	location
NULL		Africa
NULL		Asia
NULL		South America
NULL		Europe
NULL		Oceania
 for these rows, continent is NULL. Excluding these from result set
*/



-- Show Top 50 Records
SELECT TOP 50 * FROM Covid_Deaths



Select *
From Covid_Deaths
Where continent is not null 
order by location,date



-- List Of Countries Affected By Covid19

SELECT DISTINCT location AS 'List_of_Countries' FROM Covid_Deaths
WHERE continent IS NOT NULL AND total_cases IS NOT NULL
ORDER BY location



-- Number Of Countries Affected By Covid19

SELECT COUNT(*) AS 'Number of Countries' FROM (
	SELECT DISTINCT location FROM Covid_Deaths
		WHERE continent IS NOT NULL AND total_cases IS NOT NULL
) AS country_count



-- Date Of First Case Reported For Each Country
 
SELECT location AS Country, MIN(date) AS FirstCaseReportedOn 
FROM Covid_Deaths
WHERE continent IS NOT NULL AND total_cases IS NOT NULL
ORDER BY location


-- Countries with Highest Death Count per Population

Select Location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From Covid_Deaths
Where continent is not null 
Group by Location
order by TotalDeathCount desc


-- likelihood of dying in particular location

Select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From Covid_Deaths
--Where location like '%states%'
Where location like '%India%'
and continent is not null 
order by 1,2



-- percentage of population infected

Select Location, date, Population, total_cases,  (total_cases/population)*100 as PercentPopulationInfected
From Covid_Deaths
order by 1,2



-- Countries with Highest Infection Rate compared to Population

Select Location, Population, MAX(total_cases) as InfectionCount,  Max((total_cases/population))*100 as 

PercentPopulationInfected
From Covid_Deaths
Group by Location, Population
order by PercentPopulationInfected desc


-- Countries with total death count per Population

Select Location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From Covid_Deaths
Where continent is not null 
Group by Location
order by TotalDeathCount desc


-- Total cases,deaths and deaths percentage globally

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From Covid_Deaths
where continent is not null 



-- Show Top 50 Records from vaccination table

select Top 50 * from Covid_Vaccinations



--total booster dose percentage for Each Country

select location,population,max(total_boosters) AS total_boosters,
(max(total_boosters)/population)*100 as boosters_dose_percentage 
from vaccination
where continent is not null
and location like '%country%'
group by location,population
order by max(total_boosters)




-- Total No. Of People Vaccinated, Vaccination Percentage Of Population

SELECT location, population, 
MAX(people_vaccinated) AS PeopleVaccinated, 
MAX(people_vaccinated)/population*100 AS Percentage_of_population_vaccinated
FROM Covid_Vaccinations
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY location
    


-- Shows Percentage of Population that has recieved at least one Covid Vaccine

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From Covid_Deaths dea
Join Covid_Vaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3
























