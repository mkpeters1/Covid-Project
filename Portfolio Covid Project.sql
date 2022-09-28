--Looking at the data

Select *
From PortfolioCovidProject..CovidCases


Select *
From PortfolioCovidProject..MaskUse


-- Looking at Total Cases vs Total Deaths

Select "state", county, cases, deaths, Round((deaths/cases)*100,2) as DeathPercentage
From PortfolioCovidProject..CovidCases


-- Looking at Total Cases per state arranged highest to lowest

Select "state", sum(cases) as TotalCases
From PortfolioCovidProject..CovidCases
Group by "state"
Order by TotalCases Desc


-- Looking at counties in Nebraska with highest number of cases arranged highest to lowest

Select county, cases, "state"
From PortfolioCovidProject..CovidCases
Where "state" like 'Nebraska'
Order by cases Desc


-- Looking at counties in Nebraska that had the lowest percentage of deaths

Select county, cases, deaths, Round((deaths/cases)*100,2) as DeathPercentage
From PortfolioCovidProject..CovidCases
Where "state" like 'Nebraska'
Order by DeathPercentage ASC


-- Looking at national numbers
Select sum(cases) as national_cases, sum(deaths) as national_deaths, Round(sum(deaths)/sum(cases)*100,2) as death_percentage
From PortfolioCovidProject..CovidCases


-- National numbers vs Nebraska numbers

Select sum(cases) as cases, sum(deaths) as deaths, Round(sum(deaths)/sum(cases)*100,2) as death_rate
From PortfolioCovidProject..CovidCases
Where "state" <> 'Nebraska'
Union
Select sum(cases), sum(deaths), Round(sum(deaths)/sum(cases)*100,2)
From PortfolioCovidProject..CovidCases
Where "state" = 'Nebraska'


--National average mask use

Select Round(avg(mask.always)*100,2) as always_mask_percent, Round(avg(mask.frequently)*100,2) as frequently_mask_percent, Round(avg(mask.sometimes)*100,2) as sometimes_mask_percent, 
	Round(avg(mask.rarely)*100,2) as rarely_mask_percent, Round(avg(mask.never)*100,2) as never_mask_percent
From PortfolioCovidProject..CovidCases as cas
Join PortfolioCovidProject..MaskUse as mask
	On cas.fips = mask.fips


--Showing mask use in Nebraska

Select cas."state", Round(avg(mask.always)*100,2) as always_mask_percent, Round(avg(mask.frequently)*100,2) as frequently_mask_percent, Round(avg(mask.sometimes)*100,2) as sometimes_mask_percent, 
	Round(avg(mask.rarely)*100,2) as rarely_mask_percent, Round(avg(mask.never)*100,2) as never_mask_percent
From PortfolioCovidProject..CovidCases as cas
Join PortfolioCovidProject..MaskUse as mask
	On cas.fips = mask.fips
Where cas."state" = 'Nebraska'
Group by cas."state"


-- Looking at total cases compared to average of people who always wear a mask

Select cas."state", sum(cas.cases) as total_cases, Round(avg(mask.always)*100,2) as always_mask_percent
From PortfolioCovidProject..CovidCases as cas
Join PortfolioCovidProject..MaskUse as mask
	On cas.fips = mask.fips
Group by cas."state"
Order by cas."state" ASC


-- Looking at states by their percentage of total national deaths

Select "state", Round(sum(deaths)/(Select sum(deaths) From PortfolioCovidProject..CovidCases)*100,2) as DeathPercent
From PortfolioCovidProject..CovidCases
Group by "state"
Order by DeathPercent Desc


-- Looking to see if states with high averages of never or rare mask use results in higher death percentages

Select cas."state", Round(sum(cas.deaths)/sum(cas.cases)*100,2) as death_percentage, Round((avg(mask."never") + avg(mask.rarely))*100,2) as LowMaskUse
From PortfolioCovidProject..CovidCases as cas
Join PortfolioCovidProject..MaskUse as mask
	On cas.fips = mask.fips
Group by cas."state"
Order by LowMaskUse DESC