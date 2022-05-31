---VIEW IMPORTED DATA
SELECT *
FROM PortfolioProject..coviddeaths
ORDER BY location;

--DELETE rows with 'Asia' in the location as it should be in the continent
DELETE FROM PortfolioProject..coviddeaths
WHERE location = 'Asia';

SELECT *
FROM PortfolioProject..covidvaccinations


---SELECT DATA THAT WE ARE GOING TO BE USING
SELECT location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject..coviddeaths
ORDER BY location, date

---DATA EXPLORATION
-- Examining Total Cases vs Total Deaths (% of Death in total cases)
-- Shows likelihood of dying if you contract covid in your country
SELECT location, date, total_cases, total_deaths, (total_deaths/nullif(total_cases, 0))*100 AS Death_Percentage
FROM PortfolioProject..coviddeaths
-- Checking Asia: WHERE location like '%Asia%'
ORDER BY location, date

-- Examining Total Cases vs Population
-- Shows what percentage of population got Covid
SELECT location, date, total_cases, population, (total_cases/nullif(population, 0))*100 AS Population_Case_Percentage
FROM PortfolioProject..coviddeaths
--Checking Asia: WHERE location like '%Asia%'
ORDER BY location, date

--Looking at Countries with highest infection rate compared to Population
SELECT location, population, MAX(total_cases) AS Highest_Infection_Count, MAX(total_cases/nullif(population, 0))*100 AS Highest_Percent_Population_Infected
FROM PortfolioProject..coviddeaths
--Grouping
GROUP BY location, population
ORDER BY Highest_Percent_Population_Infected desc

--Showing Countries with Total Death Count per Population
SELECT location, MAX(total_deaths) AS Total_Deaths_Count
FROM PortfolioProject..coviddeaths
--Grouping
GROUP BY location
ORDER BY Total_Deaths_Count desc

---Break information down by continent for Total Death Count
--SELECT location, MAX(total_deaths) AS Total_Deaths_Count
--FROM PortfolioProject..coviddeaths
--WHERE continent = ' '
--GROUP BY location
--ORDER BY Total_Deaths_Count desc

--We will be using this for continent breakdown instead
-- blank continent is observed as World
SELECT continent, MAX(total_deaths) AS Total_Deaths_Count
FROM PortfolioProject..coviddeaths
WHERE continent != ' '
GROUP BY continent
ORDER BY Total_Deaths_Count desc


-- Global Numbers by Date
SELECT date, SUM(new_cases) AS Global_New_Cases, SUM(new_deaths) AS Global_New_Deaths, SUM(new_deaths)/nullif(SUM(new_cases),0)*100 AS Global_Death_Percentage
-- Checking Asia: WHERE location like '%Asia%'
FROM PortfolioProject..coviddeaths
GROUP BY date
ORDER BY date, Global_New_Cases

--Global Cases
SELECT SUM(new_cases) AS Global_New_Cases, SUM(new_deaths) AS Global_New_Deaths, SUM(new_deaths)/nullif(SUM(new_cases),0)*100 AS Global_Death_Percentage
-- Checking Asia: WHERE location like '%Asia%'
FROM PortfolioProject..coviddeaths


-- Looking at Total Population vs Vaccinations
SELECT dea.continent, dea.location, dea.date, CAST(dea.population AS bigint) AS population, vac.new_vaccinations,
SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS Rolling_People_Vaccination_Count
FROM PortfolioProject..coviddeaths dea
JOIN PortfolioProject..covidvaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent != ' '
ORDER BY dea.location, dea.date

-- Use CTE to expand query to include Rolling Percentage of population vaccinated
WITH perc_vacc (continent, location, date, population, new_vaccinations, Rolling_People_Vaccination_Count)
AS
(
SELECT dea.continent, dea.location, dea.date, CAST(dea.population AS bigint) AS population, vac.new_vaccinations,
SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS Rolling_People_Vaccination_Count
FROM PortfolioProject..coviddeaths dea
JOIN PortfolioProject..covidvaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent != ' '
)

SELECT *, (Rolling_People_Vaccination_Count/NULLIF(Population,0))*100 AS Rolling_Percentage_Pop_Vacc
FROM perc_vacc
ORDER BY location, date


-- Alternatively you can also use TEMP TABLE

DROP TABLE IF EXISTS Percentpopvacc
CREATE TABLE Percentpopvacc
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population bigint,
new_vaccinations bigint,
Rolling_People_Vaccination_Count bigint,
)
INSERT INTO Percentpopvacc
SELECT dea.continent, dea.location, dea.date, CAST(dea.population AS bigint) AS population, vac.new_vaccinations,
SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS Rolling_People_Vaccination_Count
FROM PortfolioProject..coviddeaths dea
JOIN PortfolioProject..covidvaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent != ' '
SELECT *, (Rolling_People_Vaccination_Count/NULLIF(Population,0))*100 AS Rolling_Percentage_Pop_Vacc
FROM Percentpopvacc
ORDER BY location, date

-- Creating View to store data for later visualizations

CREATE VIEW popvaccview AS
SELECT dea.continent, dea.location, dea.date, CAST(dea.population AS bigint) AS population, vac.new_vaccinations,
SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS Rolling_People_Vaccination_Count
FROM PortfolioProject..coviddeaths dea
JOIN PortfolioProject..covidvaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent != ' '
--THE ORDER BY CLAUSE IS INVALID IN VIEW: ORDER BY dea.location, dea.date

-- Now you can view the selected visual table
SELECT *
FROM popvaccview