CREATE VIEW DeathPercentage AS
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM [Portfolio Project]..CovidDeaths
WHERE continent IS NOT NULL;

CREATE VIEW PercentPopulationInfected AS
SELECT location, date, population, total_cases, (total_cases/population)*100 AS PercentPopulationInfected
FROM [Portfolio Project]..CovidDeaths
WHERE continent IS NOT NULL

CREATE VIEW HighestInfectionCount AS
SELECT continent, population, MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/population))*100 AS 
HighestPercentPopulationInfected
FROM [Portfolio Project]..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent, population;

CREATE VIEW HighestTotalDeathCount AS
SELECT continent, MAX(CONVERT(FLOAT, total_deaths)) AS HighestTotalDeathCount
FROM [Portfolio Project]..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent;

CREATE VIEW TotalDeathPercentage AS
SELECT SUM(new_cases) AS Total_cases, SUM(new_deaths) AS Total_deaths, SUM(new_deaths)/NULLIF(SUM(new_cases), 0)*100 
AS TotalDeathPercentage
FROM [Portfolio Project]..CovidDeaths
WHERE continent IS NOT NULL AND new_cases IS NOT NULL;










