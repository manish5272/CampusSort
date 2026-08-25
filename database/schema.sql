USE campusort;

-- =========================================
-- 1. USERS
-- =========================================

CREATE TABLE users (
                       id BIGINT PRIMARY KEY AUTO_INCREMENT,
                       name VARCHAR(100) NOT NULL,
                       email VARCHAR(150) NOT NULL UNIQUE,
                       password VARCHAR(255) NOT NULL,
                       role ENUM('STUDENT', 'RECRUITER', 'ADMIN') NOT NULL,
                       created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                       updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
                           ON UPDATE CURRENT_TIMESTAMP
);


-- =========================================
-- 2. STUDENTS
-- =========================================

CREATE TABLE students (
                          id BIGINT PRIMARY KEY AUTO_INCREMENT,
                          user_id BIGINT NOT NULL UNIQUE,
                          roll_number VARCHAR(50) NOT NULL UNIQUE,
                          branch VARCHAR(100) NOT NULL,
                          cgpa DECIMAL(4,2) NOT NULL,
                          graduation_year INT NOT NULL,
                          phone VARCHAR(15),
                          resume_url VARCHAR(500),
                          profile_completion INT DEFAULT 0,

                          CONSTRAINT fk_student_user
                              FOREIGN KEY (user_id)
                                  REFERENCES users(id)
                                  ON DELETE CASCADE
);


-- =========================================
-- 3. COMPANIES
-- =========================================

CREATE TABLE companies (
                           id BIGINT PRIMARY KEY AUTO_INCREMENT,
                           company_name VARCHAR(150) NOT NULL,
                           description TEXT,
                           website VARCHAR(255),
                           location VARCHAR(150),
                           industry VARCHAR(100),
                           created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- =========================================
-- 4. RECRUITERS
-- =========================================

CREATE TABLE recruiters (
                            id BIGINT PRIMARY KEY AUTO_INCREMENT,
                            user_id BIGINT NOT NULL UNIQUE,
                            company_id BIGINT NOT NULL,
                            designation VARCHAR(100),
                            phone VARCHAR(15),

                            CONSTRAINT fk_recruiter_user
                                FOREIGN KEY (user_id)
                                    REFERENCES users(id)
                                    ON DELETE CASCADE,

                            CONSTRAINT fk_recruiter_company
                                FOREIGN KEY (company_id)
                                    REFERENCES companies(id)
                                    ON DELETE CASCADE
);


-- =========================================
-- 5. SKILLS
-- =========================================

CREATE TABLE skills (
                        id BIGINT PRIMARY KEY AUTO_INCREMENT,
                        skill_name VARCHAR(100) NOT NULL UNIQUE,
                        category VARCHAR(100)
);


-- =========================================
-- 6. STUDENT SKILLS
-- Many-to-Many: Students <-> Skills
-- =========================================

CREATE TABLE student_skills (
                                student_id BIGINT NOT NULL,
                                skill_id BIGINT NOT NULL,
                                proficiency ENUM(
        'BEGINNER',
        'INTERMEDIATE',
        'ADVANCED'
    ) DEFAULT 'BEGINNER',

                                PRIMARY KEY (student_id, skill_id),

                                CONSTRAINT fk_student_skill_student
                                    FOREIGN KEY (student_id)
                                        REFERENCES students(id)
                                        ON DELETE CASCADE,

                                CONSTRAINT fk_student_skill_skill
                                    FOREIGN KEY (skill_id)
                                        REFERENCES skills(id)
                                        ON DELETE CASCADE
);


-- =========================================
-- 7. JOBS
-- =========================================

CREATE TABLE jobs (
                      id BIGINT PRIMARY KEY AUTO_INCREMENT,
                      company_id BIGINT NOT NULL,
                      recruiter_id BIGINT NOT NULL,
                      title VARCHAR(150) NOT NULL,
                      description TEXT,
                      location VARCHAR(150),
                      employment_type ENUM(
        'FULL_TIME',
        'INTERNSHIP',
        'CONTRACT'
    ) DEFAULT 'FULL_TIME',

                      minimum_cgpa DECIMAL(4,2),
                      graduation_year INT,

                      status ENUM(
        'OPEN',
        'CLOSED',
        'DRAFT'
    ) DEFAULT 'DRAFT',

                      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                      deadline DATETIME,

                      CONSTRAINT fk_job_company
                          FOREIGN KEY (company_id)
                              REFERENCES companies(id)
                              ON DELETE CASCADE,

                      CONSTRAINT fk_job_recruiter
                          FOREIGN KEY (recruiter_id)
                              REFERENCES recruiters(id)
                              ON DELETE CASCADE
);


-- =========================================
-- 8. JOB SKILLS
-- Many-to-Many: Jobs <-> Skills
-- =========================================

CREATE TABLE job_skills (
                            job_id BIGINT NOT NULL,
                            skill_id BIGINT NOT NULL,
                            is_required BOOLEAN DEFAULT TRUE,

                            PRIMARY KEY (job_id, skill_id),

                            CONSTRAINT fk_job_skill_job
                                FOREIGN KEY (job_id)
                                    REFERENCES jobs(id)
                                    ON DELETE CASCADE,

                            CONSTRAINT fk_job_skill_skill
                                FOREIGN KEY (skill_id)
                                    REFERENCES skills(id)
                                    ON DELETE CASCADE
);


-- =========================================
-- 9. APPLICATIONS
-- Students <-> Jobs
-- =========================================

CREATE TABLE applications (
                              id BIGINT PRIMARY KEY AUTO_INCREMENT,
                              student_id BIGINT NOT NULL,
                              job_id BIGINT NOT NULL,

                              status ENUM(
        'APPLIED',
        'UNDER_REVIEW',
        'SHORTLISTED',
        'ASSESSMENT',
        'INTERVIEW',
        'SELECTED',
        'REJECTED'
    ) DEFAULT 'APPLIED',

                              applied_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                              updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
                                  ON UPDATE CURRENT_TIMESTAMP,

                              CONSTRAINT fk_application_student
                                  FOREIGN KEY (student_id)
                                      REFERENCES students(id)
                                      ON DELETE CASCADE,

                              CONSTRAINT fk_application_job
                                  FOREIGN KEY (job_id)
                                      REFERENCES jobs(id)
                                      ON DELETE CASCADE,

                              CONSTRAINT unique_student_job
                                  UNIQUE (student_id, job_id)
);