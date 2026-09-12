# 🗄️ Database Schema & Documentation

![Preview](https://github.com/Mickekofi/ClassQuizManagementSystem/blob/master/AppImages/db_image.png)


**InSchool Learning Management System — Database Design Reference**

Complete documentation of the MySQL database structure, relationships, constraints, and data dictionary.

---

## 📋 Table of Contents

- [Database Overview](#database-overview)
- [Core Concepts](#core-concepts)
- [Entity Relationship Diagram](#entity-relationship-diagram)
- [Complete Schema Reference](#complete-schema-reference)
  - [User Management](#user-management)
  - [Course Management](#course-management)
  - [Quiz Configuration](#quiz-configuration)
  - [Quiz Attempts & Answers](#quiz-attempts--answers)
- [Data Dictionary](#data-dictionary)
- [Relationships & Constraints](#relationships--constraints)
- [Indexes & Performance](#indexes--performance)
- [Initialization & Sample Data](#initialization--sample-data)
- [SQL Scripts & Deployment](#sql-scripts--deployment)
- [Best Practices](#best-practices)

---

## 📊 Database Overview

### Database Name
```sql
inschool
```

### Database Properties
- **Character Set**: UTF8MB4 (international character support)
- **Collation**: UTF8MB4_UNICODE_CI (case-insensitive)
- **Engine**: InnoDB (ACID transactions, foreign keys)
- **Total Tables**: 7 core tables with relationships

### Key Features
✅ **ACID Compliance** — Transaction integrity guaranteed
✅ **Referential Integrity** — Foreign key constraints prevent orphaned data
✅ **Cascading Operations** — Related records automatically updated
✅ **Unique Constraints** — Prevent duplicate entries (e.g., username, teacher-course assignment)
✅ **Automatic Timestamps** — Track creation times

---

## 🎯 Core Concepts

### 1. Three-Tier User Model

```
ADMIN (System Administrator)
    └─ Creates teachers, students, courses
    └─ Assigns teachers to courses
    └─ Imports students in bulk
    └─ Manages user accounts

TEACHER (Instructor)
    └─ Creates quizzes for assigned courses
    └─ Adds multiple-choice questions
    └─ Publishes quizzes to students
    └─ Views student performance analytics
    └─ Closes quizzes when done

STUDENT (Learner)
    └─ Takes published quizzes
    └─ Answers multiple-choice questions
    └─ Receives instant feedback
    └─ Views scores and explanations
```

### 2. Course-Teacher Relationship

```
One course → Many teachers can teach it
One teacher → Many courses can be assigned

Example:
- Teacher "Mr. Mensah" teaches Mathematics and Physics
- Course "Mathematics" is taught by Mr. Mensah and Mrs. Owusu
```

### 3. Quiz Lifecycle

```
DRAFT (Under creation)
    └─ Teacher creating quiz
    └─ Not visible to students
    └─ Can add/edit/delete questions

PUBLISHED (Active)
    └─ Visible to all students in course
    └─ Students can start quiz
    └─ Each student takes ONLY ONCE
    └─ Automatic grading on submission

CLOSED (Finished)
    └─ No new student attempts allowed
    └─ Teacher can still view previous attempts
    └─ Quiz archived
```

### 4. Quiz Attempt & Grading

```
One Quiz → Many Student Attempts (One per student maximum)
One Quiz Attempt → Many Question Answers

Auto-Grading Logic:
- For each question:
  - Compare: selected_option (student) vs correct_option (teacher)
  - Set: is_correct = TRUE or FALSE
  - Calculate: score = count of correct answers

Result Shown to Student Immediately:
- Score (e.g., 18/20)
- Each question marked correct or incorrect
- Correct answer shown
```

---

## 📐 Entity Relationship Diagram

```
┌──────────────────────────┐
│        users             │
├──────────────────────────┤
│ user_id (PK)             │
│ username (UNIQUE)        │◄──────────┐
│ password_hash            │           │
│ role (ADMIN/TEACHER...)  │           │
│ full_name                │           │
│ account_status           │           │
│ created_at               │           │
└────┬──────────────┬──────┘           │
     │ (1:M)        │ (1:M)            │
     │              │                  │
     │         ┌────▼──────────────┐   │
     │         │ teacher_courses   │   │
     │         ├───────────────────┤   │
     │         │ assignment_id(PK) │   │
     │         │ teacher_user_id   │   │
     │         │ course_id         │   │
     │         │ assigned_at       │   │
     │         │ UNIQUE(teacher,   │   │
     │         │ course)           │   │
     │         └────┬──────────────┘   │
     │              │ (1:M)             │
     │              │                   │
     │         ┌────▼──────────────┐   │
     │         │    courses        │   │
     │         ├───────────────────┤   │
     │         │ course_id (PK)    │   │
     │         │ course_name(U)    │   │
     │         │ image_path        │   │
     │         │ created_at        │   │
     │         └────┬──────────────┘   │
     │              │ (1:M)             │
     │              │                   │
     │         ┌────▼──────────────┐   │
     │         │    quizzes        │   │
     │         ├───────────────────┤   │
     │         │ quiz_id (PK)      │   │
     │         │ course_id (FK)    │   │
     │         │ creator_user_id   │◄──┘
     │         │ access_code       │
     │         │ title             │
     │         │ duration_minutes  │
     │         │ status            │
     │         │ created_at        │
     │         └────┬──────────────┘
     │              │ (1:M)
     │         ┌────▼──────────────┐
     │         │ quiz_questions    │
     │         ├───────────────────┤
     │         │ question_id (PK)  │
     │         │ quiz_id (FK)      │
     │         │ question_text     │
     │         │ option_a/b/c/d    │
     │         │ correct_option    │
     │         │ created_at        │
     │         └───────────────────┘
     │
     │  (1:M)
     ├─────────────────────────────┐
     │                             │
┌────▼──────────────────┐   ┌──────▼───────────────┐
│  quiz_attempts        │   │  quiz_attempt_       │
├───────────────────────┤   │     answers          │
│ attempt_id (PK)       │   ├───────────────────────┤
│ quiz_id (FK)          │   │ answer_id (PK)       │
│ student_user_id(FK)   │   │ attempt_id (FK)      │
│ score                 │   │ question_id (FK)     │
│ start_time            │   │ selected_option      │
│ is_submitted          │   │ is_correct           │
│ created_at            │   │ created_at           │
│                       │   └───────────────────────┘
│ UNIQUE(quiz_id,       │
│ student_user_id)      │
└───────────────────────┘
```

---

## 🔐 Complete Schema Reference

### TABLE 1: `users`

Represents all system users (Admin, Teacher, Student).

```sql
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    role ENUM('ADMIN', 'TEACHER', 'STUDENT') NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    account_status ENUM('ACTIVE', 'INACTIVE') DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

**Column Details**:

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| `user_id` | INT | PK, AUTO_INCREMENT | Unique user identifier |
| `username` | VARCHAR(50) | NOT NULL, UNIQUE | Login username (no duplicates) |
| `password_hash` | VARCHAR(255) | NOT NULL | SHA-256 hashed password |
| `role` | ENUM | NOT NULL | ADMIN, TEACHER, or STUDENT |
| `full_name` | VARCHAR(100) | NOT NULL | User's full legal name |
| `account_status` | ENUM | DEFAULT 'ACTIVE' | ACTIVE or INACTIVE status |
| `created_at` | TIMESTAMP | DEFAULT NOW | Account creation timestamp |

**Example Data**:
```sql
-- Admin
INSERT INTO users (username, password_hash, role, full_name, account_status)
VALUES ('admin', SHA2('admin', 256), 'ADMIN', 'System Administrator', 'ACTIVE');

-- Teacher
INSERT INTO users (username, password_hash, role, full_name, account_status)
VALUES ('mensah', SHA2('password123', 256), 'TEACHER', 'Mr. Samuel Mensah', 'ACTIVE');

-- Student
INSERT INTO users (username, password_hash, role, full_name, account_status)
VALUES ('student001', SHA2('student001', 256), 'STUDENT', 'John Doe', 'ACTIVE');
```

---

### TABLE 2: `courses`

Represents subject courses (Mathematics, English, Physics, etc.).

```sql
CREATE TABLE courses (
    course_id INT AUTO_INCREMENT PRIMARY KEY,
    course_name VARCHAR(100) NOT NULL UNIQUE,
    image_path VARCHAR(255) NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

**Column Details**:

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| `course_id` | INT | PK, AUTO_INCREMENT | Unique course identifier |
| `course_name` | VARCHAR(100) | NOT NULL, UNIQUE | Course name (e.g., "Mathematics") |
| `image_path` | VARCHAR(255) | NULLABLE | Path to course image (optional) |
| `created_at` | TIMESTAMP | DEFAULT NOW | Course creation timestamp |

**Example Data**:
```sql
INSERT INTO courses (course_name, image_path)
VALUES 
('Mathematics', 'assets/math.png'),
('English Language', 'assets/english.png'),
('Physics', 'assets/physics.png'),
('Chemistry', NULL),
('History', NULL),
('Government', NULL);
```

---

### TABLE 3: `teacher_courses`

**JUNCTION TABLE** — Links teachers to courses they teach.

```sql
CREATE TABLE teacher_courses (
    assignment_id INT AUTO_INCREMENT PRIMARY KEY,
    teacher_user_id INT NOT NULL,
    course_id INT NOT NULL,
    assigned_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (teacher_user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES courses(course_id) ON DELETE CASCADE,
    
    -- Prevents duplicate assignments
    CONSTRAINT uq_teacher_course UNIQUE (teacher_user_id, course_id)
);
```

**Column Details**:

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| `assignment_id` | INT | PK, AUTO_INCREMENT | Unique assignment identifier |
| `teacher_user_id` | INT | NOT NULL, FK | Teacher (references users.user_id) |
| `course_id` | INT | NOT NULL, FK | Course (references courses.course_id) |
| `assigned_at` | DATETIME | DEFAULT NOW | When assignment created |

**Unique Constraint**:
```sql
CONSTRAINT uq_teacher_course UNIQUE (teacher_user_id, course_id)
```
✅ Prevents same teacher being assigned to same course twice

**Example Data**:
```sql
-- Teacher "mensah" assigned to "Mathematics" and "Physics"
INSERT INTO teacher_courses (teacher_user_id, course_id)
VALUES 
(2, 1),  -- mensah teaches Mathematics
(2, 3);  -- mensah teaches Physics
```

---

### TABLE 4: `quizzes`

**CORE TABLE** — Represents quiz headers created by teachers.

```sql
CREATE TABLE quizzes (
    quiz_id INT AUTO_INCREMENT PRIMARY KEY,
    course_id INT NOT NULL,
    creator_user_id INT NOT NULL,
    access_code VARCHAR(50) NULL,
    title VARCHAR(150) NOT NULL,
    duration_minutes INT NOT NULL,
    status ENUM('DRAFT', 'PUBLISHED', 'CLOSED') DEFAULT 'DRAFT',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (course_id) REFERENCES courses(course_id),
    FOREIGN KEY (creator_user_id) REFERENCES users(user_id)
);
```

**Column Details**:

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| `quiz_id` | INT | PK, AUTO_INCREMENT | Unique quiz identifier |
| `course_id` | INT | NOT NULL, FK | Course this quiz is for (references courses.course_id) |
| `creator_user_id` | INT | NOT NULL, FK | Teacher who created (references users.user_id) |
| `access_code` | VARCHAR(50) | NULLABLE | Optional access code for quiz security |
| `title` | VARCHAR(150) | NOT NULL | Quiz title (e.g., "Algebra Basics Quiz") |
| `duration_minutes` | INT | NOT NULL | Time limit in minutes |
| `status` | ENUM | DEFAULT 'DRAFT' | DRAFT, PUBLISHED, or CLOSED |
| `created_at` | TIMESTAMP | DEFAULT NOW | Creation timestamp |

**Status Values**:
- **DRAFT** — Teacher creating quiz, not visible to students, can edit/delete
- **PUBLISHED** — Visible to students, students can take (one time only)
- **CLOSED** — No new attempts, students cannot start quiz

**Access Code**:
- Teacher can leave NULL (system uses default) or set custom code
- Students must enter code before starting quiz (if required)

**Example Data**:
```sql
-- Teacher "mensah" creates quiz for Mathematics
INSERT INTO quizzes (course_id, creator_user_id, access_code, title, duration_minutes, status)
VALUES (1, 2, 'MATH101', 'Algebra Basics Quiz', 30, 'PUBLISHED');
```

---

### TABLE 5: `quiz_questions`

Stores individual questions that make up a quiz.

```sql
CREATE TABLE quiz_questions (
    question_id INT AUTO_INCREMENT PRIMARY KEY,
    quiz_id INT NOT NULL,
    question_text TEXT NOT NULL,
    option_a VARCHAR(255) NOT NULL,
    option_b VARCHAR(255) NOT NULL,
    option_c VARCHAR(255) NOT NULL,
    option_d VARCHAR(255) NOT NULL,
    correct_option ENUM('A','B','C','D') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (quiz_id) REFERENCES quizzes(quiz_id) ON DELETE CASCADE
);
```

**Column Details**:

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| `question_id` | INT | PK, AUTO_INCREMENT | Unique question identifier |
| `quiz_id` | INT | NOT NULL, FK | Quiz this question belongs to (references quizzes.quiz_id) |
| `question_text` | TEXT | NOT NULL | The question prompt |
| `option_a` | VARCHAR(255) | NOT NULL | Option A text |
| `option_b` | VARCHAR(255) | NOT NULL | Option B text |
| `option_c` | VARCHAR(255) | NOT NULL | Option C text |
| `option_d` | VARCHAR(255) | NOT NULL | Option D text |
| `correct_option` | ENUM | NOT NULL | Correct answer (A, B, C, or D) |
| `created_at` | TIMESTAMP | DEFAULT NOW | Creation timestamp |

**Cascade Behavior**:
```sql
ON DELETE CASCADE
```
✅ If quiz is deleted, all its questions are automatically deleted

**Example Data**:
```sql
INSERT INTO quiz_questions (quiz_id, question_text, option_a, option_b, option_c, option_d, correct_option)
VALUES (1, 'What is 2 + 2?', '3', '4', '5', '6', 'B');
```

---

### TABLE 6: `quiz_attempts`

Represents each student's attempt at taking a quiz.

```sql
CREATE TABLE quiz_attempts (
    attempt_id INT AUTO_INCREMENT PRIMARY KEY,
    quiz_id INT NOT NULL,
    student_user_id INT NOT NULL,
    score INT DEFAULT 0,
    start_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    is_submitted BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (quiz_id) REFERENCES quizzes(quiz_id),
    FOREIGN KEY (student_user_id) REFERENCES users(user_id),
    
    -- ONE attempt per student per quiz (enforces "take only once" rule)
    CONSTRAINT uq_student_quiz UNIQUE (quiz_id, student_user_id)
);
```

**Column Details**:

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| `attempt_id` | INT | PK, AUTO_INCREMENT | Unique attempt identifier |
| `quiz_id` | INT | NOT NULL, FK | Which quiz (references quizzes.quiz_id) |
| `student_user_id` | INT | NOT NULL, FK | Which student (references users.user_id) |
| `score` | INT | DEFAULT 0 | Number of correct answers (calculated on submit) |
| `start_time` | DATETIME | DEFAULT NOW | When student started quiz |
| `is_submitted` | BOOLEAN | DEFAULT FALSE | Has student submitted quiz? |
| `created_at` | TIMESTAMP | DEFAULT NOW | Record creation timestamp |

**Unique Constraint** (Critical):
```sql
CONSTRAINT uq_student_quiz UNIQUE (quiz_id, student_user_id)
```
✅ Enforces: Each student can take each quiz **ONLY ONCE**
❌ Prevents: Duplicate (quiz_id, student_user_id) pairs

**Example Data**:
```sql
-- Student "student001" started and submitted "MATH101" quiz
INSERT INTO quiz_attempts (quiz_id, student_user_id, score, is_submitted)
VALUES (1, 3, 18, TRUE);
```

---

### TABLE 7: `quiz_attempt_answers`

Records each student's answer to each question.

```sql
CREATE TABLE quiz_attempt_answers (
    answer_id INT AUTO_INCREMENT PRIMARY KEY,
    attempt_id INT NOT NULL,
    question_id INT NOT NULL,
    selected_option ENUM('A','B','C','D') NOT NULL,
    is_correct BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (attempt_id) REFERENCES quiz_attempts(attempt_id) ON DELETE CASCADE,
    FOREIGN KEY (question_id) REFERENCES quiz_questions(question_id) ON DELETE CASCADE
);
```

**Column Details**:

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| `answer_id` | INT | PK, AUTO_INCREMENT | Unique answer record ID |
| `attempt_id` | INT | NOT NULL, FK | Which quiz attempt (references quiz_attempts.attempt_id) |
| `question_id` | INT | NOT NULL, FK | Which question (references quiz_questions.question_id) |
| `selected_option` | ENUM | NOT NULL | What student selected (A, B, C, or D) |
| `is_correct` | BOOLEAN | DEFAULT FALSE | Was answer correct? (TRUE or FALSE) |
| `created_at` | TIMESTAMP | DEFAULT NOW | Record creation timestamp |

**Grading Logic**:
```
On submission:
For each answer:
    IF selected_option == question.correct_option:
        is_correct = TRUE
    ELSE:
        is_correct = FALSE

Calculate score:
    score = COUNT(where is_correct = TRUE)
```

**Example Data**:
```sql
-- Student answered Question 1 with "B", which is correct
INSERT INTO quiz_attempt_answers (attempt_id, question_id, selected_option, is_correct)
VALUES (1, 1, 'B', TRUE);

-- Student answered Question 2 with "A", which is incorrect (correct was "C")
INSERT INTO quiz_attempt_answers (attempt_id, question_id, selected_option, is_correct)
VALUES (1, 2, 'A', FALSE);
```

---

## 📊 Data Dictionary

### Enumeration Values

| Table | Column | Allowed Values | Description |
|-------|--------|-----------------|-------------|
| `users` | `role` | ADMIN, TEACHER, STUDENT | User type and access level |
| `users` | `account_status` | ACTIVE, INACTIVE | Account active/inactive |
| `quizzes` | `status` | DRAFT, PUBLISHED, CLOSED | Quiz lifecycle state |
| `quiz_questions` | `correct_option` | A, B, C, D | Correct multiple-choice option |
| `quiz_attempt_answers` | `selected_option` | A, B, C, D | Student's selected option |

---

## 🔗 Relationships & Constraints

### Primary-Foreign Key Relationships

| Relationship | From Table | Column | To Table | Column | Cascade |
|-------------|-----------|--------|----------|--------|---------|
| Teacher to User | `teacher_courses` | `teacher_user_id` | `users` | `user_id` | CASCADE |
| Course to Teacher | `teacher_courses` | `course_id` | `courses` | `course_id` | CASCADE |
| Quiz to Course | `quizzes` | `course_id` | `courses` | `course_id` | — |
| Quiz to Teacher | `quizzes` | `creator_user_id` | `users` | `user_id` | — |
| Question to Quiz | `quiz_questions` | `quiz_id` | `quizzes` | `quiz_id` | CASCADE |
| Attempt to Quiz | `quiz_attempts` | `quiz_id` | `quizzes` | `quiz_id` | — |
| Attempt to Student | `quiz_attempts` | `student_user_id` | `users` | `user_id` | — |
| Answer to Attempt | `quiz_attempt_answers` | `attempt_id` | `quiz_attempts` | `attempt_id` | CASCADE |
| Answer to Question | `quiz_attempt_answers` | `question_id` | `quiz_questions` | `question_id` | CASCADE |

### Unique Constraints

| Table | Constraint | Columns | Purpose |
|-------|-----------|---------|---------|
| `users` | UNIQUE | `username` | Prevent duplicate usernames |
| `courses` | UNIQUE | `course_name` | Prevent duplicate courses |
| `teacher_courses` | UNIQUE | `teacher_user_id`, `course_id` | Prevent duplicate assignments |
| `quizzes` | — | — | No unique constraints |
| `quiz_questions` | — | — | Multiple questions allowed |
| `quiz_attempts` | UNIQUE | `quiz_id`, `student_user_id` | **CRITICAL**: One attempt per student per quiz |

---

## 🚀 Indexes & Performance

### Critical Indexes for Common Queries

```sql
-- User lookups
CREATE INDEX idx_users_username ON users(username);
CREATE INDEX idx_users_role ON users(role);

-- Teacher course assignments
CREATE INDEX idx_teacher_courses_teacher ON teacher_courses(teacher_user_id);
CREATE INDEX idx_teacher_courses_course ON teacher_courses(course_id);

-- Quiz lookups
CREATE INDEX idx_quizzes_course ON quizzes(course_id);
CREATE INDEX idx_quizzes_creator ON quizzes(creator_user_id);
CREATE INDEX idx_quizzes_status ON quizzes(status);

-- Quiz question lookup
CREATE INDEX idx_quiz_questions_quiz ON quiz_questions(quiz_id);

-- Quiz attempts
CREATE INDEX idx_quiz_attempts_quiz ON quiz_attempts(quiz_id);
CREATE INDEX idx_quiz_attempts_student ON quiz_attempts(student_user_id);
CREATE INDEX idx_quiz_attempts_submitted ON quiz_attempts(is_submitted);

-- Quiz answers
CREATE INDEX idx_quiz_answers_attempt ON quiz_attempt_answers(attempt_id);
CREATE INDEX idx_quiz_answers_question ON quiz_attempt_answers(question_id);
```

---

## 🌱 Initialization & Sample Data

### Create Database & Tables

```sql
CREATE DATABASE inschool CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE inschool;

-- Run all CREATE TABLE statements from DatabaseQuery.txt
```

### Sample Initial Data

```sql
-- Create admin
INSERT INTO users (username, password_hash, role, full_name)
VALUES ('admin', SHA2('admin', 256), 'ADMIN', 'System Administrator');

-- Create teachers
INSERT INTO users (username, password_hash, role, full_name)
VALUES 
('mensah', SHA2('password123', 256), 'TEACHER', 'Mr. Samuel Mensah'),
('owusu', SHA2('password123', 256), 'TEACHER', 'Mrs. Abigail Owusu');

-- Create courses
INSERT INTO courses (course_name)
VALUES 
('Mathematics'),
('English Language'),
('Physics'),
('Chemistry'),
('History'),
('Government');

-- Assign teachers to courses
INSERT INTO teacher_courses (teacher_user_id, course_id)
VALUES 
(2, 1),  -- Mensah teaches Mathematics
(2, 3),  -- Mensah teaches Physics
(3, 2),  -- Owusu teaches English Language
(3, 4);  -- Owusu teaches Chemistry
```

---

## 🔧 SQL Scripts & Deployment

### Backup Database

```bash
mysqldump -u root -p inschool > inschool_backup_$(date +%Y%m%d_%H%M%S).sql
```

### Restore Database

```bash
mysql -u root -p inschool < inschool_backup_20261015_143022.sql
```

### Check Database Integrity

```sql
-- Verify all tables exist
SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'inschool';

-- Check teacher-course assignments
SELECT u.full_name, c.course_name 
FROM teacher_courses tc
INNER JOIN users u ON tc.teacher_user_id = u.user_id
INNER JOIN courses c ON tc.course_id = c.course_id;

-- Count quiz attempts per quiz
SELECT q.title, COUNT(qa.attempt_id) as attempts
FROM quizzes q
LEFT JOIN quiz_attempts qa ON q.quiz_id = qa.quiz_id
GROUP BY q.quiz_id;
```

---

## ✅ Best Practices

### Data Integrity

✅ **Always use parameterized queries** (prevent SQL injection)
✅ **Validate foreign key references** before inserting
✅ **Use transactions** for multi-step operations
✅ **Enforce unique constraints** at database level

### Query Optimization

✅ **Index frequently-searched columns** (user, status, date)
✅ **Use LIMIT clauses** when fetching lists
✅ **Avoid SELECT *** — select only needed columns
✅ **Cache course and teacher lists** (rarely change)

### Security

✅ **Hash passwords** (SHA-256 minimum, bcrypt recommended)
✅ **Validate input data** at application level
✅ **Restrict database user permissions** (no DROP privileges)
✅ **Use SSL/TLS** for database connections (production)

### Maintenance

✅ **Regular backups** (daily in production)
✅ **Monitor table sizes** for growth
✅ **Archive old quiz attempts** after academic year (compliance)
✅ **Clean up inactive accounts** periodically

---

## 📚 Related Documentation

- **README.md** — System overview and setup guide
- **ARCHITECTURE.md** — System design and workflows
- **Assets/DatabaseQuery.txt** — Raw SQL for table creation

---

**Version**: 1.0  
**Database Engine**: MySQL 5.7 / 8.0  


🗄️ *Clean, efficient database for online quiz management.*
