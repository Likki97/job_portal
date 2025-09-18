DROP DATABASE IF EXISTS job_portal;
CREATE DATABASE job_portal;
USE job_portal;


-- USERS TABLE

-- Stores all registered users.
-- Each user can be a candidate, employer, or admin.
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,            -- Unique user ID
    full_name VARCHAR(150) NOT NULL,                   -- Full name
    email VARCHAR(150) UNIQUE NOT NULL,                -- Unique email (login)
    password_hash VARCHAR(255) NOT NULL,               -- Encrypted password
    role VARCHAR(20) NOT NULL CHECK (role IN ('candidate','employer','admin')), -- Role type
    phone VARCHAR(20),                                 -- Phone number
    location VARCHAR(100),                             -- User's city/country
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP     -- Account creation timestamp
);
select * from users;

-- CANDIDATE PROFILES

-- Extends "users" with candidate-specific data.
CREATE TABLE candidate_profiles (
    candidate_id INT PRIMARY KEY,                      -- Same as user_id
    resume_url VARCHAR(255),                           -- Resume link
    experience_years INT DEFAULT 0,                    -- Work experience
    education TEXT,                                    -- Education details
    portfolio_url VARCHAR(255),                        -- Portfolio/GitHub
    headline VARCHAR(255),                             -- Short job headline
    about TEXT,                                        -- Bio
    FOREIGN KEY (candidate_id) REFERENCES users(user_id) ON DELETE CASCADE
);
select * from candidate_profiles;
-- EMPLOYER PROFILES

-- Extends "users" with employer-specific data.
CREATE TABLE employer_profiles (
    employer_id INT PRIMARY KEY,                       -- Same as user_id
    company_name VARCHAR(150) NOT NULL,                -- Company name
    company_website VARCHAR(255),                      -- Website
    company_description TEXT,                          -- Company description
    industry VARCHAR(100),                             -- Industry sector
    company_size VARCHAR(50),                          -- Size of company
    FOREIGN KEY (employer_id) REFERENCES users(user_id) ON DELETE CASCADE
);
select * from employer_profiles;

-- SKILLS

-- Master table of all skills.
CREATE TABLE skills (
    skill_id INT AUTO_INCREMENT PRIMARY KEY,           -- Unique skill ID
    skill_name VARCHAR(100) UNIQUE NOT NULL            -- Skill name (React, SQL, etc.)
);
select * from skills;


-- CANDIDATE SKILLS

-- Maps candidates to their skills.
CREATE TABLE candidate_skills (
    candidate_id INT,                                  -- Candidate reference
    skill_id INT,                                      -- Skill reference
    proficiency VARCHAR(20) DEFAULT 'Beginner' CHECK (proficiency IN ('Beginner','Intermediate','Expert')), -- Level
    years_experience DECIMAL(3,1) DEFAULT 0,           -- Years of experience
    PRIMARY KEY (candidate_id, skill_id),
    FOREIGN KEY (candidate_id) REFERENCES candidate_profiles(candidate_id) ON DELETE CASCADE,
    FOREIGN KEY (skill_id) REFERENCES skills(skill_id) ON DELETE CASCADE
);
select * from candidate_skills;

-- JOBS

-- Stores job postings by employers.
CREATE TABLE jobs (
    job_id INT AUTO_INCREMENT PRIMARY KEY,             -- Job ID
    employer_id INT NOT NULL,                          -- Employer reference
    job_title VARCHAR(200) NOT NULL,                   -- Title
    job_description TEXT NOT NULL,                     -- Description
    employment_type VARCHAR(20) NOT NULL CHECK (employment_type IN ('Full-time','Part-time','Internship','Contract','Remote')), -- Type
    location VARCHAR(150),                             -- Job location
    salary_min DECIMAL(12,2),                          -- Min salary
    salary_max DECIMAL(12,2),                          -- Max salary
    posted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,     -- Post date
    deadline DATE,                                     -- Application deadline
    status VARCHAR(20) DEFAULT 'Open' CHECK (status IN ('Open','Closed','On Hold')), -- Status
    FOREIGN KEY (employer_id) REFERENCES employer_profiles(employer_id) ON DELETE CASCADE
);
select * from jobs;

-- JOB SKILLS

-- Skills required for jobs.
CREATE TABLE job_skills (
    job_id INT,                                        -- Job reference
    skill_id INT,                                      -- Skill reference
    importance INT DEFAULT 1,                          -- Importance level (1–5)
    PRIMARY KEY (job_id, skill_id),
    FOREIGN KEY (job_id) REFERENCES jobs(job_id) ON DELETE CASCADE,
    FOREIGN KEY (skill_id) REFERENCES skills(skill_id) ON DELETE CASCADE
);
select * from job_skills;

-- APPLICATIONS

-- Candidate job applications.
CREATE TABLE applications (
    application_id INT AUTO_INCREMENT PRIMARY KEY,     -- Unique application ID
    job_id INT NOT NULL,                               -- Job reference
    candidate_id INT NOT NULL,                         -- Candidate reference
    cover_letter TEXT,                                 -- Cover letter
    resume_url VARCHAR(255),                           -- Resume at time of application
    status VARCHAR(20) DEFAULT 'Applied' CHECK (status IN ('Applied','Shortlisted','Interview','Offered','Rejected')), -- Stage
    applied_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,    -- Applied date
    FOREIGN KEY (job_id) REFERENCES jobs(job_id) ON DELETE CASCADE,
    FOREIGN KEY (candidate_id) REFERENCES candidate_profiles(candidate_id) ON DELETE CASCADE
);
select * from applications;

-- SAVED JOBS

-- Candidates saving/bookmarking jobs.
CREATE TABLE saved_jobs (
    candidate_id INT,
    job_id INT,
    saved_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,      -- When saved
    PRIMARY KEY (candidate_id, job_id),
    FOREIGN KEY (candidate_id) REFERENCES candidate_profiles(candidate_id) ON DELETE CASCADE,
    FOREIGN KEY (job_id) REFERENCES jobs(job_id) ON DELETE CASCADE
);
select * from saved_jobs;

-- JOB REVIEWS

-- Candidate feedback on jobs.
CREATE TABLE job_reviews (
    review_id INT AUTO_INCREMENT PRIMARY KEY,          -- Unique review ID
    job_id INT NOT NULL,                               -- Job reference
    candidate_id INT NOT NULL,                         -- Reviewer
    rating TINYINT CHECK (rating BETWEEN 1 AND 5),     -- Rating 1–5
    review_text TEXT,                                  -- Review text
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,    -- Posted at
    FOREIGN KEY (job_id) REFERENCES jobs(job_id) ON DELETE CASCADE,
    FOREIGN KEY (candidate_id) REFERENCES candidate_profiles(candidate_id) ON DELETE CASCADE
);
select * from job_reviews;

-- USERS (10 users)
INSERT INTO users (full_name,email,password_hash,role,location) VALUES
('Ayesha Kapoor','ayesha@pixelforge.com','pass','employer','Bengaluru'),
('Ravi Kumar','ravi@gmail.com','pass','candidate','Hyderabad'),
('Neha Sharma','neha@fintech.com','pass','employer','Delhi'),
('Arjun Mehta','arjun@yahoo.com','pass','candidate','Pune'),
('Priya Singh','priya@designhub.com','pass','employer','Mumbai'),
('Karan Patel','karan@gmail.com','pass','candidate','Ahmedabad'),
('Sneha Reddy','sneha@edtech.com','pass','employer','Hyderabad'),
('Vikram Jain','vikram@gmail.com','pass','candidate','Chennai'),
('Rahul Das','rahul@medicorp.com','pass','employer','Kolkata'),
('Meera Iyer','meera@gmail.com','pass','candidate','Bengaluru');

-- EMPLOYER PROFILES (5)
INSERT INTO employer_profiles VALUES
(1,'PixelForge Tech','https://pixelforge.com','We build SaaS products','IT','51-200'),
(3,'FinTech Global','https://fintech.com','Finance solutions company','Finance','201-500'),
(5,'DesignHub','https://designhub.com','Creative agency','Design','11-50'),
(7,'EduSpark','https://eduspark.com','Online learning platform','EdTech','501-1000'),
(9,'MediCorp','https://medicorp.com','Healthcare solutions','Healthcare','1001-5000');

-- CANDIDATE PROFILES (5)
INSERT INTO candidate_profiles VALUES
(2,'https://resume.com/ravi.pdf',5,'B.Tech CSE','https://portfolio.com/ravi','Full-Stack Dev','React + Node.js developer'),
(4,'https://resume.com/arjun.pdf',2,'B.Sc IT','https://portfolio.com/arjun','Frontend Dev','Skilled in Angular'),
(6,'https://resume.com/karan.pdf',4,'MCA','https://portfolio.com/karan','Backend Engineer','Java + Spring specialist'),
(8,'https://resume.com/vikram.pdf',6,'B.Tech ECE','https://portfolio.com/vikram','Data Scientist','Python ML enthusiast'),
(10,'https://resume.com/meera.pdf',3,'MBA','https://portfolio.com/meera','Business Analyst','SQL & BI tools expert');

-- SKILLS (10)
INSERT INTO skills (skill_name) VALUES
('React'),('Node.js'),('Python'),('Java'),('SQL'),
('Angular'),('Spring Boot'),('Data Science'),('Machine Learning'),('UI/UX Design');

-- CANDIDATE SKILLS (10+)
INSERT INTO candidate_skills VALUES
(2,1,'Expert',4),(2,2,'Expert',5),(2,5,'Intermediate',3),
(4,6,'Intermediate',2),(4,10,'Expert',3),
(6,2,'Intermediate',3),(6,4,'Expert',4),(6,7,'Expert',3),
(8,3,'Expert',5),(8,8,'Expert',4),(8,9,'Expert',4),
(10,5,'Expert',4),(10,10,'Intermediate',2);

-- JOBS (10)
INSERT INTO jobs (employer_id,job_title,job_description,employment_type,location,salary_min,salary_max,deadline,status) VALUES
(1,'Senior Full-Stack Engineer','React + Node.js','Full-time','Bengaluru',1200000,2000000,'2025-12-31','Open'),
(3,'Finance Analyst','Work on reports','Full-time','Delhi',800000,1500000,'2025-11-30','Open'),
(5,'UI/UX Designer','Design web apps','Contract','Mumbai',600000,1000000,'2025-10-31','Open'),
(7,'ML Engineer','Work on AI models','Full-time','Hyderabad',1500000,2500000,'2025-09-30','Open'),
(9,'Healthcare Consultant','Support hospitals','Part-time','Kolkata',500000,900000,'2025-12-15','Open'),
(1,'Backend Engineer','Node.js APIs','Full-time','Remote',1000000,1800000,'2025-11-15','Open'),
(3,'Data Analyst','SQL + PowerBI','Full-time','Delhi',700000,1200000,'2025-10-20','Closed'),
(5,'Frontend Developer','Angular apps','Full-time','Mumbai',900000,1600000,'2025-12-10','Open'),
(7,'Education Content Creator','Build EdTech content','Contract','Hyderabad',400000,700000,'2025-09-25','On Hold'),
(9,'Hospital IT Support','Healthcare systems','Full-time','Kolkata',600000,1100000,'2025-11-05','Open');

-- JOB SKILLS (10+)
INSERT INTO job_skills VALUES
(1,1,5),(1,2,5),(2,5,4),(2,3,3),(3,10,5),
(4,3,5),(4,8,5),(4,9,5),(5,5,3),(6,2,5),(6,4,4),(7,5,5),
(8,6,4),(8,10,5),(9,10,3),(10,4,4),(10,5,3);

-- APPLICATIONS (10)
INSERT INTO applications (job_id,candidate_id,cover_letter,resume_url,status) VALUES
(1,2,'Excited to join','https://resume.com/ravi.pdf','Applied'),
(1,4,'Strong in frontend','https://resume.com/arjun.pdf','Interview'),
(2,10,'Finance interest','https://resume.com/meera.pdf','Shortlisted'),
(3,4,'Creative designer','https://resume.com/arjun.pdf','Applied'),
(4,8,'ML background','https://resume.com/vikram.pdf','Interview'),
(5,10,'Interested in healthcare','https://resume.com/meera.pdf','Offered'),
(6,6,'Backend expertise','https://resume.com/karan.pdf','Rejected'),
(7,2,'SQL reporting','https://resume.com/ravi.pdf','Applied'),
(8,4,'Angular pro','https://resume.com/arjun.pdf','Interview'),
(10,6,'Healthcare systems','https://resume.com/karan.pdf','Applied');

-- SAVED JOBS (10)
INSERT INTO saved_jobs VALUES
(2,1,NOW()),(2,6,NOW()),(4,3,NOW()),(4,8,NOW()),
(6,1,NOW()),(6,10,NOW()),(8,4,NOW()),(8,5,NOW()),
(10,2,NOW()),(10,7,NOW());

-- JOB REVIEWS (10)
INSERT INTO job_reviews (job_id,candidate_id,rating,review_text) VALUES
(1,2,5,'Great interview process'),
(1,4,4,'Challenging but fair'),
(2,10,3,'Good company'),
(3,4,5,'Loved design culture'),
(4,8,5,'Cutting edge ML'),
(5,10,4,'Good healthcare firm'),
(6,6,2,'Strict interviews'),
(7,2,3,'Decent data analyst role'),
(8,4,4,'Fun frontend team'),
(10,6,5,'Helpful IT support team');



-- Q1. Top 3 highest paying open jobs
-- Shows the 3 jobs with the maximum salary (where job is still open).
SELECT job_title, salary_max 
FROM jobs 
WHERE status='Open' 
ORDER BY salary_max DESC 
LIMIT 3;

-- Q2. Candidates who applied to more than 2 jobs
-- Identifies highly active candidates.
SELECT c.candidate_id,u.full_name,COUNT(a.application_id) AS applications_count
FROM applications a
JOIN candidate_profiles c ON a.candidate_id=c.candidate_id
JOIN users u ON u.user_id=c.candidate_id
GROUP BY c.candidate_id
HAVING COUNT(a.application_id) > 2;

-- Q3. Employers with most job postings
-- Finds which company posts the highest number of jobs.
SELECT e.company_name, COUNT(j.job_id) AS total_jobs
FROM jobs j
JOIN employer_profiles e ON j.employer_id = e.employer_id
GROUP BY e.company_name
ORDER BY total_jobs DESC;

-- Q4. Most demanded skills across jobs
-- Lists skills and how many jobs require them.
SELECT s.skill_name, COUNT(js.job_id) AS demand_count
FROM job_skills js
JOIN skills s ON js.skill_id=s.skill_id
GROUP BY s.skill_name
ORDER BY demand_count DESC;

-- Q5. Match jobs with candidate skills (Example: Ravi, id=2)
-- Recommends jobs based on candidate's existing skills.
SELECT j.job_title,s.skill_name
FROM jobs j
JOIN job_skills js ON j.job_id=js.job_id
JOIN skills s ON js.skill_id=s.skill_id
WHERE js.skill_id IN (SELECT skill_id FROM candidate_skills WHERE candidate_id=2);

-- Q6. Average application count per job
-- Shows which jobs attract the most applications.
SELECT j.job_title, COUNT(a.application_id) AS applications_count
FROM jobs j
LEFT JOIN applications a ON j.job_id=a.job_id
GROUP BY j.job_id;

-- Q7. Average rating per employer
-- Aggregates candidate reviews to rate employers.
SELECT e.company_name, ROUND(AVG(r.rating),2) AS avg_rating
FROM job_reviews r
JOIN jobs j ON r.job_id=j.job_id
JOIN employer_profiles e ON j.employer_id=e.employer_id
GROUP BY e.company_name;

-- Q8. Candidates with highest skill diversity
-- Ranks candidates by number of different skills.
SELECT c.candidate_id,u.full_name,COUNT(cs.skill_id) AS skills_count
FROM candidate_skills cs
JOIN candidate_profiles c ON cs.candidate_id=c.candidate_id
JOIN users u ON u.user_id=c.candidate_id
GROUP BY c.candidate_id
ORDER BY skills_count DESC;

-- Q9. Jobs closing soon (within next 30 days)
-- Helps candidates apply before deadlines expire.
SELECT job_title, deadline
FROM jobs
WHERE deadline BETWEEN CURDATE() AND DATE_ADD(CURDATE(),INTERVAL 30 DAY);

-- Q10. Application pipeline by status
-- Shows how many applications are in each stage.
SELECT status, COUNT(*) AS total
FROM applications
GROUP BY status;
-- Find all candidates with more than 3 years of experience
WITH ExperiencedCandidates AS (
    SELECT candidate_id, experience_years
    FROM candidate_profiles
    WHERE experience_years > 3
)
SELECT u.full_name, u.location, e.experience_years
FROM ExperiencedCandidates e
JOIN users u ON u.user_id = e.candidate_id;
-- Show jobs with average rating above 4

WITH JobRatings AS (
    SELECT job_id, AVG(rating) AS avg_rating
    FROM job_reviews
    GROUP BY job_id
)
SELECT j.job_title, e.company_name, r.avg_rating
FROM JobRatings r
JOIN jobs j ON j.job_id = r.job_id
JOIN employer_profiles e ON e.employer_id = j.employer_id
WHERE r.avg_rating > 4;
