creat schema imdb;

use imdb;
drop table if exists movies;
create table movies(
	rank_no int,
    movie_title varchar(200),
    released_year int,
    imdb_rating varchar (50),
    director varchar(50),
    leading_actors varchar(200),
    user_ratings int
);

select * from movies;
--------------------------------------------------------------------------------------
-- cleaning white spaces

update movies 
set director = trim(director),
	leading_actors = trim(leading_actors);
---------------------------------------------------------------------------------

-- Evaluating movie remarks
select *,
case 
	when imdb_rating > 8.5 then 'Excellent'
    else 'Good'
    end as Remarks
from movies;
-------------------------------------------------------------------------------------------

-- Directors who directed more than 1 movie

select director, count(*) as no_of_movies
from movies
group by director
having no_of_movies > 1
order by no_of_movies DESC
-----------------------------------------------------------------------------------------

-- Directors who casted in their own movies

select *
from movies
where director in (substring_index(leading_actors,',',1))
--------------------------------------------------------------------------------------------
-- select all records from movies directed by Christopher Nolan and Peter Jackson

select * 
from movies
where director in ('Christopher Nolan','Peter Jackson');
--------------------------------------------------------------------------------------------------
-- find the number of movies released in the same year which is more than 1

select movie_title,released_year, count(movie_title) over (partition by released_year) as num_of_movies 
from movies

select movie_title, released_year, num_of_movies
from (
  select movie_title, released_year, count(movie_title) over (partition by released_year) as num_of_movies
  from movies
) t
where num_of_movies > 1

-----------------------------------------------------------------------------------
-- last 50 percent of records

select *
from (select *, ntile(2) over(order by rank_no) nt from movies) t
where nt = 2

----------------------------------------------------------------
-- avg imdb rating of directors who directed more than 1 movies

select director,round(avg(imdb_rating),1) as average_rating,count(movie_title) as total_movies
from movies
where director in (select director
					from movies
					group by director
					having count(*) > 1)
group by director
order by average_rating desc

---------------------------------------------------------------------
select * from movies

-- movies released in last 10 years

ALTER TABLE movies MODIFY COLUMN released_year YEAR;

select *
from movies 
where released_year BETWEEN year(current_date()) - 10 AND year(current_date())

------------------------------------------------------
-- determining the user ratings

select *
from movies
order by user_ratings desc

select *
from movies 
where user_ratings = (select min(user_ratings) from movies)
or imdb_rating = (select max(imdb_rating) from movies)
----------------------------------------------------------------------

-- total distinct directors

select count(distinct director) as distinct_directors from movies

