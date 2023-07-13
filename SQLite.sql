create table appleStore_description_combined AS 

SELECT * from appleStore_description1

UNION all 

SELECT * from appleStore_description2

UNION all 

SELECT * from appleStore_description3

UNION all 

SELECT * from appleStore_description4

-- Checking the number of unique apps

select count (distinct id) AS UniqueAppleIDs
from AppleStore

select count (distinct id) AS UniqueAppleIDs
from appleStore_description_combined

-- Checking for missing values
select count (*) AS MissingValues
FROM AppleStore
WHERE track_name IS null or user_rating is null or prime_genre is null 

select count(*) AS MissingValues2
from appleStore_description_combined
where app_desc is null 

-- number of apps by genre 
select prime_genre, count(*)  as NumApps
from AppleStore
group by prime_genre
order by NumApps DESC

-- Overview of app ratings
select min(user_rating) AS min_rating
from AppleStore

select max(user_rating) as max_rating
from AppleStore

select avg(user_rating) as avg_rating
from AppleStore

-- Data Analysis -- 

-- Determining whether paid or free apps have better ratings 
select case 
	when price > 0 then 'Paid'
    else 'Free'
    end as App_Type,
    avg(user_rating) as AvgRating
FROM AppleStore
group by App_Type

-- Do apps supporting more languages have higher ratings?
select case
	when lang_num < 10 then 'Less than 10 Languages'
    when lang_num between 10 and 30 then 'Between 10 and 30'
    else 'More than 30'
end as language_bucket, 
avg(user_rating) as AvgRating
FROM AppleStore
group by language_bucket
order by AvgRating DESC

-- Checking apps with low ratings
select prime_genre, avg(user_rating) as AvgRating
from AppleStore
group by prime_genre
order by AvgRating ASC 
limit 10 

-- Is there any correlation between the length of the app description and the user rating?

select case 
when length(b.app_desc) <500 then 'short'
WHEN length(b.app_desc) between 500 and 1000 then 'medium'
else 'long'
end as description_length, avg(a.user_rating) as avg_rating 
from AppleStore as a 
join appleStore_description_combined as b 
oN a.id = b.id 
group by description_length
order by avg_rating desc 

-- Checking the top rated apps for each genre AppleStore
SELECT 
	prime_genre,
    track_name,
    user_rating
FROM ( select prime_genre, track_name, user_rating, RANK() OVER(PARTITION BY prime_genre order by user_rating desc,
                                                                rating_count_tot desc) as rank
      from AppleStore) as a 
where a.rank = 1
