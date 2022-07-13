SELECT * 
FROM Covid19Project..CovidDeaths
ORDER BY 3,4

--SELECT * 
--FROM Covid19Project..CovidVaccinations
--ORDER BY 3,4

--Select The Data to be used from the Database

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM Covid19Project..CovidDeaths
ORDER BY 1,2

--Total Cases vs Total Deaths
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercent
FROM Covid19Project..CovidDeaths
WHERE location = 'Canada' AND continent is NOT NULL
ORDER BY location,date

--Popluation Infected
SELECT location, date, population, total_cases, (total_cases/population)*100 AS InfectedPercent
FROM Covid19Project..CovidDeaths
WHERE location = 'Canada' AND continent is NOT NULL
ORDER BY location,date

--Countries with Highest infection rates around the world
SELECT location, population, MAX(total_cases) AS HighestInfection, MAX((total_cases/population))*100 AS InfectedPercent
FROM Covid19Project..CovidDeaths
WHERE continent is NOT NULL
GROUP BY location, population
ORDER BY InfectedPercent desc

--Countries with highest Death Count
SELECT location, MAX(CAST(total_deaths AS INT)) AS HighestDeathCount
FROM Covid19Project..CovidDeaths
WHERE continent is NOT NULL
GROUP BY location
ORDER BY HighestDeathCount desc

--Death Count by Continent
SELECT continent, MAX(CAST(total_deaths AS INT)) AS HighestDeathCount
FROM Covid19Project..CovidDeaths
WHERE continent is NOT NULL
GROUP BY continent
ORDER BY HighestDeathCount desc

--GLOBAL COUNT OVERALL
Select SUM(total_cases) as total_cases, SUM(cast(total_deaths as BIGINT)) as total_deaths, SUM(cast(total_deaths as BIGINT))/SUM(total_cases)*100 as DeathPercent
From Covid19Project..CovidDeaths
where continent is not null


--Popluation with partial Vaccination status Globally

SELECT deaths.location, deaths.date, deaths.continent, vaccine.total_vaccinations,
SUM(CONVERT(BIGINT,vaccine.total_vaccinations)) OVER (Partition by deaths.Location Order by deaths.location) as RollingPeopleVaccinated
FROM Covid19Project..CovidDeaths deaths
JOIN Covid19Project..CovidVaccinations vaccine
ON deaths.location = vaccine.location
AND deaths.date = vaccine.date
WHERE deaths.continent IS NOT NULL
ORDER BY 1,2,3


--Population with Fully Vaccination Status Globally
SELECT deaths.location, deaths.date, deaths.continent, vaccine.people_fully_vaccinated,
SUM(CONVERT(BIGINT,vaccine.people_fully_vaccinated)) OVER (Partition by deaths.Location Order by deaths.location) as RollingPeopleVaccinated
FROM Covid19Project..CovidDeaths deaths
JOIN Covid19Project..CovidVaccinations vaccine
ON deaths.location = vaccine.location
AND deaths.date = vaccine.date
WHERE deaths.continent IS NOT NULL
ORDER BY 1,2,3

-- Using CTE to perform Calculation on Partition By in previous query

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select deaths.continent, deaths.location, deaths.date, deaths.population, vaccine.new_vaccinations
, SUM(CONVERT(BIGINT,vaccine.new_vaccinations)) OVER (Partition by deaths.Location ORDER BY deaths.date) as RollingPeopleVaccinated
From Covid19Project..CovidDeaths deaths
Join Covid19Project..CovidVaccinations vaccine
	On deaths.location = vaccine.location
	and deaths.date = vaccine.date
where deaths.continent is not null

)
Select *, (RollingPeopleVaccinated/Population)*100 AS VaccinePercent
From PopvsVac

-- Using Temp Table to perform Calculation on Partition By in previous query

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

SELECT * FROM #PercentPopulationVaccinated;
