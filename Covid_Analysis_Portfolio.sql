
select * from [Covid Deaths]
where continent is not null 
order by 3,4


--select * from [Covid Vaccinations]
--order by 3,4

--Selecting the colums from Covide death table 

select location,date,total_cases,new_cases,total_deaths,population
from [Covid Deaths]
order by 1,2

-------Calculation the Death rate ----------

select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
from [Covid Deaths]
order by 1,2

select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
from [Covid Deaths] where location like '%states%'
order by 1,2

-------calculating the total cases vs poulation ---------

select location,date,total_cases,population,(total_cases/population)*100 as covidinfectedpercent
from [Covid Deaths] 
--where location like '%states%' and continent is not null
order by 1,2


----Countries with Highest population rate .

select location,population,max(total_cases) as highest_infection_count ,max((total_cases/population))*100 as covid_infected_percent
from [Covid Deaths] 
--where location like '%states%'
group by location,population
order by covid_infected_percent desc

------------Countries with higest death counts  --------

select location,max(cast (total_deaths as int )) as highest_death_counts
from [Covid Deaths] 
--where location like '%states%'
where continent is not null
group by location
order by highest_death_counts desc


----------FILTERING THE COLUMN WITH CONTINENT ----

--select location,max(cast (total_deaths as int )) as highest_death_counts
--from [Covid Deaths] 
----where location like '%World%'
--where continent is  null
--group by location
--order by highest_death_counts desc

select continent,max(cast (total_deaths as int )) as highest_death_counts
from [Covid Deaths] 
--where location like '%World%'
where continent is  not null
group by continent
order by highest_death_counts desc


---Continents with Highest death count ---

select continent,max(cast (total_deaths as int )) as highest_death_counts
from [Covid Deaths] 
--where location like '%states%'
where continent is not null
group by continent
order by highest_death_counts desc

---------Global numbers-----

select sum(new_cases) as total_cases ,sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as Death_percentage
from [Covid Deaths] 
--where location like '%states%'
where continent is not null
order by 1,2


---------joining the 2 tables---------

 
select *
from [Covid Deaths] dea
join [Covid Vaccinations] vac
on dea.location=vac.location 
and dea.date=vac.date


----calculating  the total vaccination ----

select dea.continent, dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(cast(vac.new_vaccinations as bigint)) over(partition by dea.location order by dea.location , dea.date) as people_vacinated
from [Covid Deaths] dea
join [Covid Vaccinations] vac
on dea.location=vac.location 
and dea.date=vac.date
where dea.continent is not null
order by 2,3

---Creating a view

create view People_vaccinated as 
select dea.continent, dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(cast(vac.new_vaccinations as bigint)) over(partition by dea.location order by dea.location , dea.date) as people_vacinated
from [Covid Deaths] dea
join [Covid Vaccinations] vac
on dea.location=vac.location 
and dea.date=vac.date
where dea.continent is not null
--order by 2,3

select * from People_vaccinated
