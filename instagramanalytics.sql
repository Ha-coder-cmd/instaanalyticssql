-- find the 5 oldest users from databse provided;

select * from users;


-- Ans
select id,username,created_at from users where(extract(year from created_at))=2016 and (extract(month from created_at)) =5 
order by (extract(day from created_at)) asc limit 5 ;

--  find the users who never posted a single photo on instagram
select * from users;
select * from photos;
-- Ans
select id,username from users where id not in (select user_id  from photos) order by username;


-- find the winner of the contest and provide their details to the team i.e the user whose photo got most
select * from likes;
select * from users;
select * from photos;

select count( l.user_id) as total_likes,l.photo_id,u.username
from likes l inner join photos p on l.photo_id=p.id
inner join users u on p.user_id=u.id 
group by l.photo_id,u.username 
order by total_likes desc;

-- identify and suggest the top 5  most commonly used hastages
select * from tags;
select * from photo_tags;

-- ANS
with my_cte as (
select t.tag_name,count(pt.photo_id) as tag_count ,pt.tag_id from tags t inner join photo_tags pt on t.id=pt.tag_id group by pt.tag_id,t.tag_name order by tag_count desc)
select a.tag_name,a.rnk from (select tag_name,dense_rank() over(order by tag_count desc) as rnk from my_cte) a
where a.rnk>=1 and a.rnk<=5;


--  find the day at which most users register
select * from users;
select date_format((created_at),'%W') as day,count(username) from users group by 1 order by 2 desc;

-- 
--  find out the bots who have liked each and every photo
select * from users;
select * from  photos;
select * from likes;

select username from users where id in(select l.user_id from users u
inner join photos p
on u.id=p.user_id
inner join likes l
on p.id=l.photo_id
group by l.user_id
having count(l.photo_id)=257
)
;


-- find the users who name start with c and end with number and posted as well as liked
select * from users;
select * from likes;
select * from photos;

select distinct(u.username) from users u
inner join photos p
on u.id=p.user_id
inner join likes l
on l.user_id=u.id
where u.username regexp '^C.*[0-9]$';


--  demonstrate top 30 usernames  who have posted photos in range of 3 to 5
select distinct(u.username),count(p.id) from users u
inner join photos p
on u.id=p.user_id
group by p.user_id
having count(p.id) >=3 and count(p.id) <=5
order by count(p.id)
desc limit 30;
