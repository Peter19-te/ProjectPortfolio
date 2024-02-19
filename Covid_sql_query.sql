Select *
From PeterPortfolio.dbo.CovidDeaths
order by 3,4


Select *
From PeterPortfolio.dbo.CovidVaccinations
order by 3,4


Select location, date, population, total_cases, new_cases, total_deaths
From PeterPortfolio.dbo.CovidDeaths
order by 1,2

--Looking at Total cases vs Total deaths

Select location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PeterPortfolio.dbo.CovidDeaths
where location like '%Nigeria%'
order by 1,2

--Total cases vs Population

Select location, date, total_cases, population, (total_cases/population)*100 as InfectedPercentage
From PeterPortfolio.dbo.CovidDeaths
where location like '%Nigeria%'
order by 1,2

--Looking at Highest infection rate compared to population
Select location, MAX(total_cases) as Infected, population, MAX((total_cases/population)*100) as InfectedPercentage
From PeterPortfolio.dbo.CovidDeaths
--where location like '%Nigeria%'
group by location, population
order by 4 desc

--Showing countries with the Highest Death count per Population
Select location, MAX(cast(total_deaths as int)) as DeathCount
From PeterPortfolio.dbo.CovidDeaths
--where location like '%Nigeria%'
where continent is not null
group by location
order by 2 desc

--Death count by Continent
Select continent, MAX(cast(total_deaths as int)) as DeathCount
From PeterPortfolio.dbo.CovidDeaths
--where location like '%Nigeria%'
where continent is not null
group by continent
order by 2 desc

--Global Numbers Daily death percentage
Select date, SUM(new_cases) as daily_cases, SUM(cast(new_deaths as int))as daily_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From PeterPortfolio.dbo.CovidDeaths
--where location like '%Nigeria%'
where continent is not null
Group by date
order by 1

--Global numbers Death percentage across the world
Select SUM(new_cases) as daily_cases, SUM(cast(new_deaths as int))as daily_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From PeterPortfolio.dbo.CovidDeaths
--where location like '%Nigeria%'
where continent is not null
--Group by date
order by 1

--Looking  at Total population vs Vaccination
Select death.continent, death.location, death.date, death.population, vacc.new_vaccinations, SUM(cast(vacc.new_vaccinations as int)) 
OVER(Partition by death.location order by death.location, death.date) as RollingVaccineCount
From PeterPortfolio..CovidDeaths death
Join PeterPortfolio..CovidVaccinations vacc
	on death.location = vacc.location
	and death.date = vacc.date
where death.continent is not null
order by 2,3

--CTE
With PopulationvsVaccinated(Continent, location, date, population, new_vaccinations,RollingVaccineCount )
as
(
Select death.continent, death.location, death.date, death.population, vacc.new_vaccinations, SUM(cast(vacc.new_vaccinations as int)) 
OVER(Partition by death.location order by death.location, death.date) as RollingVaccineCount
From PeterPortfolio..CovidDeaths death
Join PeterPortfolio..CovidVaccinations vacc
	on death.location = vacc.location
	and death.date = vacc.date
where death.continent is not null
--order by 2,3
)
select*,(RollingVaccineCount/population)*100 as PercentageofPopulationVaccinated
From PopulationvsVaccinated






