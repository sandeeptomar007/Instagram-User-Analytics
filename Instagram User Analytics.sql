-- 1. Rewarding 5 Most Loyal Users:

SELECT username, created_at
FROM ig_clone.users
ORDER BY created_at asc
LIMIT 5;

-- 2. Remind Inactive Users to Start Posting:

SELECT  
    users.id,
    users.username
FROM 
    ig_clone.users
LEFT JOIN 
    ig_clone.photos 
ON users.id = photos.user_id
WHERE photos.user_id IS NULL;

-- 3. Declaring Contest Winner Most Like In Single Photos:

SELECT users.username, 
MAX(photo_id) as max_likes
FROM ig_clone.users
JOIN ig_clone.likes 
ON users.id = likes.user_id
GROUP BY users.id
ORDER BY max_likes DESC
LIMIT 1;

-- 4. Hashtag Researching Top 5 most commonly used hashtags :

SELECT 
	COUNT(tags.id) as count,
	tags.tag_name
FROM 
    ig_clone.photo_tags
LEFT JOIN 
    ig_clone.tags 
ON photo_tags.tag_id = tags.id
WHERE tag_id IS NOT NULL
GROUP BY tag_id
ORDER BY count DESC
LIMIT 5;

-- 5. Find the day of the week do most users register:

SELECT 
   DATE_FORMAT(created_at, '%W') AS Days, 
   COUNT(*) AS number_of_users
FROM 
   ig_clone.users
GROUP BY 
     Days
ORDER BY  
     number_of_users DESC
LIMIT 1;


-- 6. User Engagement: 
SELECT 
   COUNT(*)/COUNT(DISTINCT user_id) AS average_posts_per_user,
   COUNT(*) AS total_photos, COUNT(DISTINCT user_id) AS total_users
FROM 
    ig_clone.users
JOIN 
    ig_clone.photos 
ON users.id = photos.user_id;

-- 7. Bots & Fake Accounts: 
SELECT user_id, username
FROM ig_clone.likes
JOIN 
    ig_clone.users
ON users.id = likes.user_id
GROUP BY user_id
HAVING COUNT(DISTINCT photo_id) = (SELECT COUNT(*) FROM ig_clone.photos);
