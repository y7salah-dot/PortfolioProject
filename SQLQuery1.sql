select *
from [PortfolioProject.]..CovidDeaths
where continent is Not Null
order by 3,4

select *
from [PortfolioProject.]..CovidVaccinations
order by 3,4

select location , date ,total_cases ,new_cases , total_deaths ,population
from [PortfolioProject.]..CovidDeaths
order by 1,2


select location , date ,total_cases , total_deaths , (total_deaths/total_cases)*100 as Deathpercentage
from [PortfolioProject.]..CovidDeaths
where location like '%Egypt%'
order by 1,CAST(date AS date)



select location , date ,total_cases , population , (total_cases/population)*100 as percentpopulationinfected
from [PortfolioProject.]..CovidDeaths
--where location like '%Egypt%'
order by 1,CAST(date AS date)


select location , population , max(total_cases) as Highestinfecationcount , max((total_cases/population))*100 as percentpopulationinfected
from [PortfolioProject.]..CovidDeaths
--where location like '%Egypt%'
group by location , population
order by percentpopulationinfected DESC



select location ,max(Total_deaths) as totalDeaathCount
from [PortfolioProject.]..CovidDeaths
--where location like '%Egypt%'
where continent is Not Null
group by location 
order by totalDeaathCount DESC



select location ,max(cast(Total_deaths as int)) as totalDeaathCount
from [PortfolioProject.]..CovidDeaths
--where location like '%Egypt%'
where continent is Null
group by location 
order by totalDeaathCount DESC



select sum(new_cases) as total_case ,sum(cast(new_deaths as int)) as total_deaths , sum(cast(new_deaths as int)) / sum(new_cases)*100 as totalDeaathCount
from [PortfolioProject.]..CovidDeaths
--where location like '%Egypt%'
where continent is Not Null
--group by location 
order by 1,2 ;

-- use CTE

with popvsvac (continent,location ,date,population,new_vaccinations , RollingPeoplevaccinated)
as
(
select  dea.continent, dea.location , dea.date , dea.population , Vac.new_vaccinations
, SUM(CONVERT(int,Vac.new_vaccinations)) over (partition by dea.location order by dea.location , dea.date) as RollingPeoplevaccinated
from [PortfolioProject.]..CovidDeaths dea
join [PortfolioProject.]..CovidVaccinations Vac
on dea.location = Vac.location
and dea.date = Vac.date
where dea.continent is Not Null
--order by 2,3
)
select *, (RollingPeoplevaccinated/population)*100
from popvsvac

--temp table

DroP table if exists #RollingPeoplevaccinated
create table #RollingPeoplevaccinated
(
continent nvarchar(255),
location nvarchar(255) ,
date datetime,
population numeric,
new_vaccinations numeric,
RollingPeoplevaccinated numeric,
)
insert into #RollingPeoplevaccinated
select  dea.continent, dea.location , dea.date , dea.population , Vac.new_vaccinations
, SUM(CONVERT(int,Vac.new_vaccinations)) over (partition by dea.location order by dea.location , dea.date) as RollingPeoplevaccinated
from [PortfolioProject.]..CovidDeaths dea
join [PortfolioProject.]..CovidVaccinations Vac
on dea.location = Vac.location
and dea.date = Vac.date
where dea.continent is Not Null
--order by 2,3

select *,(RollingPeoplevaccinated/population)*100
from #RollingPeoplevaccinated


----
create view RollingPeoplevaccinated as
select  dea.continent, dea.location , dea.date , dea.population , Vac.new_vaccinations
, SUM(CONVERT(int,Vac.new_vaccinations)) over (partition by dea.location order by dea.location , dea.date) as RollingPeoplevaccinated
from [PortfolioProject.]..CovidDeaths dea
join [PortfolioProject.]..CovidVaccinations Vac
on dea.location = Vac.location
and dea.date = Vac.date
where dea.continent is Not Null
--order by 2,3





select * 
from RollingPeoplevaccinated

