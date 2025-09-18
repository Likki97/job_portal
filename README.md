Job Portal Database

A fully designed Job Portal database schema built in MySQL, supporting a job portal system where candidates, employers, and admins interact. This database captures users, profiles, jobs, applications, skills, and reviews, enabling advanced queries for analytics and recommendations.

Features

User Management

Roles: candidate, employer, admin

Stores contact info, location, and account metadata

Candidate Profiles

Resume, portfolio, education, experience

Skill mapping with proficiency levels

Employer Profiles

Company details, industry, size, and description

Jobs

Multiple employment types (Full-time, Part-time, Internship, Contract, Remote)

Salary ranges, deadlines, and status (Open, Closed, On Hold)

Applications

Candidate applications with cover letters and resume snapshots

Track application status (Applied, Shortlisted, Interview, Offered, Rejected)

Skills

Centralized skill table

Candidate skill mapping and years of experience

Job skill requirements with importance levels

Saved Jobs

Allows candidates to bookmark jobs

Job Reviews

Candidate ratings and feedback on jobs

Sample Queries

Top 3 Highest Paying Open Jobs

Active Candidates (applied to more than 2 jobs)

Employers with Most Job Postings

Most Demanded Skills Across Jobs

Match Jobs to Candidate Skills

Average Application Count per Job

Average Employer Rating

Candidates with Highest Skill Diversity

Jobs Closing Soon

Application Pipeline by Status

Experienced Candidates (>3 years)

Jobs with Average Rating Above 4

Database Schema Overview

Tables:

users – Stores all registered users

candidate_profiles – Candidate-specific info

employer_profiles – Employer-specific info

skills – Master list of skills

candidate_skills – Maps candidates to skills

jobs – Job postings

job_skills – Job skill requirements

applications – Candidate applications

saved_jobs – Bookmarked jobs

job_reviews – Candidate feedback on jobs

Relationships:

users → candidate_profiles / employer_profiles (1:1)

candidate_profiles ↔ skills (Many-to-Many via candidate_skills)

jobs ↔ skills (Many-to-Many via job_skills)

jobs ↔ applications (1:Many)

jobs ↔ job_reviews (1:Many)

candidate_profiles ↔ saved_jobs (Many-to-Many)

Getting Started

Clone the repository:

git clone <repository-url>


Open MySQL Workbench or CLI.

Run the SQL script job_portal.sql to create the database and populate sample data.

Start querying using the sample queries provided.

Sample Data

Users: 10 (5 candidates, 5 employers)

Jobs: 10

Skills: 10

Applications: 10

Saved Jobs: 10

Job Reviews: 10

Tools

MySQL 

MySQL Workbench (for visualization)
