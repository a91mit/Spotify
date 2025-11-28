/*
Easy Level
Retrieve the names of all tracks that have more than 1 billion streams.
List all albums along with their respective artists.
Get the total number of comments for tracks where licensed = TRUE.
Find all tracks that belong to the album type single.
Retrieve the track names that have been streamed on Spotify more than YouTube.
*/

count the total number of tracks by each artist.
select count(*)
from spotify;

select count(distinct album)
from spotify;

--Q.1 Retrieve the names of all tracks that have more than 1 billion streams.
select album
from spotify
where stream > 1000000;

--Q.2 List all albums along with their respective artists.
select distinct album,count(artist)
from spotify
group by 1
order by 2 desc;

-- Q.3 Get the total number of comments for tracks where licensed = TRUE.
select sum(comments) as total_comment 
from spotify
where licensed = TRUE;

-- Q.4 Find all tracks that belong to the album type single.
select *
from spotify
where album_type = 'single'

-- Q.5 Count the total number of tracks by each artist.
select artist,count(*) as no_of_track
from spotify
group by 1
order by 2 asc;

/*
Medium Level
Calculate the average danceability of tracks in each album.
Find the top 5 tracks with the highest energy values.
List all tracks along with their views and likes where official_video = TRUE.
For each album, calculate the total views of all associated tracks.
Retrieve the track names that have been streamed on Spotify more than YouTube.
*/
--Q.6 Calculate the average danceability of tracks in each album.
select album,avg(danceability) as avg_danceability
from spotify
group by 1
order by 2 desc;

--Q.7 Find the top 5 tracks with the highest energy values.
select track,max(energy) as energy_level
from spotify
group by 1
order by 2 desc
limit 5;

--Q.8 List all tracks along with their views and likes where official_video = TRUE.
select track,sum(views) as total_views,sum(likes) as total_likes
from spotify
where official_video = 'TRUE'
group by 1;

--Q.9 For each album, calculate the total views of all associated tracks.
select album,track,sum(views) as total_view
from spotify
group by 1,2
order by 3 desc;

--Q.10 Retrieve the track names that have been streamed on Spotify more than YouTube.
select *
from
(select track,
        coalesce(sum(case when most_played_on = 'Youtube' then stream end),0) as most_played_on_youtube,
         coalesce(sum(case when most_played_on = 'Spotify' then stream end),0) as most_played_on_spotify
from spotify
group by 1) as a
where most_played_on_spotify > most_played_on_youtube and most_played_on_youtube <> 0;



/*
Find the top 3 most-viewed tracks for each artist using window functions.
Write a query to find tracks where the liveness score is above the average.
Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.
Find tracks where the energy-to-liveness ratio is greater than 1.2.
Calculate the cumulative sum of likes for tracks ordered by the number of views, using window functions.
*/

--Q.11 Find the top 3 most-viewed tracks for each artist using window functions.
with artist_ranking as
(select artist,track,sum(views) as total_views,
              dense_rank() over(partition by artist order by sum(views) desc) as rank
from spotify
group by track,artist
order by 1,3 desc) 
select * from artist_ranking
where rank <= 3;

--Q.12 Write a query to find tracks where the liveness score is above the average.
select artist,album,liveness
from spotify
where liveness > (select avg(liveness) from spotify);
                                        
--Q.13 Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in
--  each album.
with energy_level as (select album,
                             max(energy) as highest,
							 min(energy) as lowest
                       from  spotify
					   group by album)
select album,highest - lowest as energy_diff
from energy_level
order by 2 desc

















