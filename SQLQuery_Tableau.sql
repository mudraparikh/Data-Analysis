SELECT SUM(total_cases)AS Total_cases,
SUM(CAST(total_deaths AS BIGINT))AS Total_Deaths,
((SUM(CAST(total_deaths AS BIGINT))/SUM(total_cases))*100) AS DeathPercentage
FROM Covid19Project..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1,2

--We take these out as they are not inluded in the above queries and want to stay consistent
-- European Union is part of Europe

SELECT location, SUM(CAST(total_deaths AS BIGINT)) as TotalDeathCount
FROM Covid19Project..CovidDeaths
WHERE continent IS NOT NULL
and location not in ('World', 'European Union', 'International')
Group by location
order by TotalDeathCount desc


SELECT location, population, date, continent, MAX(total_cases) as HighestInfectionCount, 
MAX(total_cases/population)*100 as PerecentInfectedPopulation
FROM Covid19Project..CovidDeaths
WHERE continent IS NOT NULL
Group by location, population, date, continent
order by PerecentInfectedPopulation desc

Select dea.continent, dea.location, dea.date, dea.population
, MAX(vac.total_vaccinations) as RollingPeopleVaccinated
From Covid19Project..CovidDeaths dea
Join Covid19Project..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
group by dea.continent, dea.location, dea.date, dea.population
order by 1,2,3

------NEW QUERY

With PopvsVac (Continent, Location, Date, Population, FullyVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.people_fully_vaccinated
From Covid19Project..CovidDeaths dea
Join Covid19Project..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
)
Select *, (FullyVaccinated/Population)*100 as PercentPeopleVaccinated
From PopvsVac