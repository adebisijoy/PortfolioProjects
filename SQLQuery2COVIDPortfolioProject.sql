SELECT *
FROM [Portfolio Project]..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 3,4;

SELECT *
FROM [Portfolio Project]..CovidVaccinations
WHERE continent IS NOT NULL
ORDER BY 3,4;

SELECT location, date, total_cases, total_deaths, population
FROM [Portfolio Project]..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1,2;

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM [Portfolio Project]..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1,2;

SELECT location, date, total_cases, total_deaths, (total_deaths/population)*100 AS DeathPercentage
FROM [Portfolio Project]..CovidDeaths
WHERE continent IS NOT NULL AND location LIKE '%igeria%'
ORDER BY 1,2;

SELECT location, date, total_cases, total_deaths, (total_deaths/population)*100 AS DeathPercentage
FROM [Portfolio Project]..CovidDeaths
WHERE continent IS NOT NULL AND location LIKE '%states%'
ORDER BY 1,2;

SELECT location, date, population, total_cases, (total_cases/population)*100 AS PercentPopulationInfected
FROM [Portfolio Project]..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1,2;

SELECT location, date, population, total_cases, (total_cases/population)*100 AS PercentPopulationInfected
FROM [Portfolio Project]..CovidDeaths
WHERE continent IS NOT NULL AND location LIKE '%igeria%'
ORDER BY 1,2;

SELECT continent, population, MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/population))*100 AS HighestPercentPopulationInfected
FROM [Portfolio Project]..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent, population
ORDER BY 1,2;

SELECT location, population, MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/population))*100 AS HighestPercentPopulationInfected
FROM [Portfolio Project]..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY HighestPercentPopulationInfected DESC;

SELECT location, population, MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/population))*100 AS HighestPercentPopulationInfected
FROM [Portfolio Project]..CovidDeaths
WHERE continent IS NOT NULL AND location LIKE '%igeria%'
GROUP BY location, population
ORDER BY HighestPercentPopulationInfected DESC;

SELECT location, MAX(CONVERT(FLOAT, total_deaths)) AS HighestTotalDeathCount
FROM [Portfolio Project]..CovidDeaths
WHERE continent IS NULL
GROUP BY location
ORDER BY HighestTotalDeathCount DESC;

SELECT location,MAX(CAST(total_deaths AS FLOAT)) AS HighestdeathCount
FROM [Portfolio Project]..CovidDeaths
WHERE continent IS NOT NULL AND location LIKE '%igeria%'
GROUP BY location

SELECT continent,MAX(CAST(total_deaths AS FLOAT)) AS HighestTotaldeathCount
FROM [Portfolio Project]..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY HighestTotaldeathCount DESC;

SELECT continent,MAX(CAST(total_deaths AS FLOAT)) AS HighestTotaldeathCount
FROM [Portfolio Project]..CovidDeaths
WHERE continent IS NULL
GROUP BY continent
ORDER BY HighestTotaldeathCount DESC;

SELECT date, SUM(new_cases) AS Total_cases, SUM(new_deaths) AS Total_deaths, SUM(new_deaths)/NULLIF(SUM(new_cases), 0)*100 
AS DeathPercentage
FROM [Portfolio Project]..CovidDeaths
WHERE continent IS NOT NULL AND new_cases IS NOT NULL
GROUP BY date
ORDER BY 1,2;

SELECT SUM(new_cases) AS Total_cases, SUM(new_deaths) AS Total_deaths, SUM(new_deaths)/NULLIF(SUM(new_cases), 0)*100 AS
DeathPercentage
FROM [Portfolio Project]..CovidDeaths
WHERE continent IS NOT NULL AND new_cases IS NOT NULL
ORDER BY 1,2;

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(INT, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date)
AS RollingPeopleVaccinated
FROM [Portfolio Project]..CovidDeaths dea
JOIN [Portfolio Project]..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2,3;

WITH PopvsVac (Continent, Location, Date, Population, New_vaccinations, RollingPeopleVaccinated)
AS (
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,SUM(CONVERT(INT,vac.new_vaccinations))
OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date ) AS RollingPeopleVaccinated
FROM [Portfolio Project]..CovidDeaths dea
JOIN [Portfolio Project]..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
)
SELECT *, (RollingPeopleVaccinated/Population)*100
FROM PopvsVac

DROP TABLE IF EXISTS #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated (
 Continent NVARCHAR(255),
 Location NVARCHAR(255),
 Date DATETIME,
 Population NUMERIC,
 New_Vaccinations NUMERIC,
 RollingPeopleVaccinated NUMERIC
)
INSERT INTO #PercentPopulationVaccinated 
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(CONVERT(FLOAT, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date)
AS RollingPeopleVaccinated
FROM [Portfolio Project]..CovidDeaths dea
JOIN [Portfolio Project]..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
SELECT *, (RollingPeopleVaccinated/Population)*100
FROM #PercentPopulationInfected

CREATE VIEW PopulationVaccinated AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(INT, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location,
dea.date) AS RollingPeopleVaccinated
FROM [Portfolio Project]..CovidDeaths dea
JOIN [Portfolio Project]..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL

SELECT *
FROM PopulationVaccinated;
