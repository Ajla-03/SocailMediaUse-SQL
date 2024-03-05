-- Basic Data Understanding
select count(age) from media;

select max(age), min(age), avg(age) from media; 

select distinct location from media;

select distinct profession from media;

select max(income), min(income), avg(income) from media;

select count(*) as 'ownsCar' from media 
where owns_car = 'True';

-- Platform Analysis
select platform, count(platform) as 'Total Platform Use'
from media
group by platform ;

-- Average time spent for all entries
select round(avg(time_spent)) as 'Average_Time_Spent' from media; 

-- Average Income grouped by profession
select profession, cast(avg(income) as decimal(7,2)) as 'Average Income', round(avg(time_spent),1) as 'AverageTimeSpent'
from media
group by profession
order by 2 desc;

-- Average income grouped by gender and profession
select gender, profession, cast(avg(income) as decimal(7,2)) as 'Average Income'
from media
group by gender, profession
order by 1,3 desc;

-- Highest income based on demographic
select demographics, max(income) as 'Highest Income'
from media 
group by demographics
order by 2 desc; 

-- Using a CASE statement to categorize Student income into groups
select profession, income,
case
    when income between 10000 and 13000 then "Low Income"
    when income between 13000 and 16000 then "Medium Income"
    when income between 16000 and 20000 then "High Income"
    else "NA"
end as 'Income Status'
from media
where profession = 'Student'
group by profession, income
order by 2;

-- Creating a view to calculate avg income and total timespent for each profession based on location
create view Profession_Summary as
select profession, location, 
	cast(avg(income) as decimal(7,2)) as 'AvgIncome', 
    sum(time_spent) as 'TotalTime_Spent'
from media 
where Owns_Car = 'True'
group by profession, location
order by 2, 3 desc;

select * from profession_summary;

-- CTE Finding who owns a car, has above avg income, and spend more time on social media than avg time spent
WITH UserCTE AS (
  SELECT 
    profession, 
    income, 
    Owns_Car, 
    time_spent,
    AVG(income) OVER () AS AvgIncome,
    AVG(time_spent) OVER () AS AvgTimeSpent
  FROM media
  WHERE Owns_Car = "True"
    AND income > (SELECT AVG(income) FROM media WHERE Owns_Car = "True")
    AND time_spent > (SELECT AVG(time_spent) FROM media WHERE Owns_Car = "True")
)

SELECT profession, income, Owns_Car, time_spent
FROM UserCTE;





