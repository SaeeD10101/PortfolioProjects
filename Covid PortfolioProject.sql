select *
from CovidDeaths



-- Select the data that we are going to be using 
select location , date , total_cases , new_cases , total_deaths , population
from CovidDeaths 
order by 1,2

--Looking at Total Cases vs Total Deaths 
--  Shows the liklehood of daying if you contract covid in your country 

select location , date , total_cases , total_deaths , (cast (total_deaths as float)/cast (total_cases as float )) * 100  as DeahtPercentage
from CovidDeaths 
where location like '%Saudi Arabia%' 
order by 1,2

-- Looking at the Total Cases vs Population
-- Shows What percantage of population got covid

select location , date ,  population  ,total_cases, (cast (total_cases as float)/cast (population as float )) * 100  as PercentageOfPopulationInfected 
from CovidDeaths 
where location like '%Saudi Arabia%'
order by 1,2

-- Looking at countries  with highest infection rate compared to population
select location ,  population ,max(total_cases)as highestInfctionCount, max((cast (total_cases as float)/cast (population as float ))) * 100  as  PercentageOfPopulationInfected  
from CovidDeaths 
group by location, population
order by PercentageOfPopulationInfected desc 

-- Showing the countries with the highiest Death count per population 

select location , max(cast(total_deaths as int))as TotalDeathCount
from CovidDeaths 
where continent is not null
group by location
order by TotalDeathCount desc 


--Lets Break things Down By Continent
-- Showing the Continents with the highst Death Count 


select continent, max(cast(total_deaths as int))as TotalDeathCount
from CovidDeaths 
where continent is not null
group by continent
order by TotalDeathCount desc 



-- Global Numbers

--SET ARITHABORT on;
----SET ANSI_WARNINGS on;
----SET ARITHIGNORE ON;
--select date , sum(new_cases) as totalcases , sum (cast(new_deaths as int)) as totaldeaths, sum(cast(new_deaths as int))/sum(cast(New_cases as int)) * 100  as DeahtPercentage
--from CovidDeaths 
----where location like '%Saudi Arabia%'
--where continent is not null
--group by date
--order by 1,2

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From CovidDeaths
--Where location like '%states%'
where continent is not null 
--Group By date
order by 1,2
 
-- looking at total Population vs Vaccinations


Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From CovidDeaths dea
Join CovidVac vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3


-- use CTE
 with popvsVac ( continent ,Location , Date , Population ,new_vaccinations, RollingPeopleVaccinated )
 as 
 (
 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From CovidDeaths dea
Join CovidVac vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3

)
select * ,(RollingPeopleVaccinated/Population) * 100
from popvsVac


-- TEMP Table


DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From CovidDeaths dea
Join CovidVac vac
	On dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null 
--order by 2,3
Select *, (RollingPeopleVaccinated/Population)*100 as RollingPeoplePercintage
From #PercentPopulationVaccinated






-- Creating View To Store Data for Later Visualization
create view PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From CovidDeaths dea
Join CovidVac vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3