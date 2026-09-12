‎=<p align="center">
‎  
‎    <img src="https://github.com/Mickekofi/ClassQuizManagementSystem/blob/master/logo.png" width="130">
‎  </a>
‎  
‎  <h1 align="center"><strong>A Web Teacher-Student Quiz Management Application</strong></h1>
‎  </a>
‎  <p align="center">
‎    <a href="">
‎      <img src="https://img.shields.io/badge/Join-Community-blue.svg" alt="MIT License">
‎    </a>
‎    <a href="https://wa.me/233597326320?text=*QuizManagement_From_Github_User_💬Message_:*%20">
‎      <img src="https://img.shields.io/badge/Contact-Engineers-red.svg" alt="Build Status">
‎    </a>
‎  </p>
‎</p>
‎
‎---




# 📚 InSchool – Learning Management System (LMS)

**A web-based Learning Management System for Senior High Schools enabling administrators to manage users, teachers to create online quizzes, and students to take quizzes with automatic grading and instant feedback.**

---

![Preview](https://github.com/Mickekofi/ClassQuizManagementSystem/blob/master/AppImages/image1.png)



## 📋 Table of Contents

- [Vision & Overview](#vision--overview)
- [Features](#features)
- [System Requirements](#system-requirements)
- [Installation & Setup](#installation--setup)
- [Quick Start Guide](#quick-start-guide)
- [How It Works](#how-it-works)
- [Technology Stack](#technology-stack)
- [Project Structure](#project-structure)
- [Configuration](#configuration)
- [User Roles & Workflows](#user-roles--workflows)
- [Quiz Lifecycle](#quiz-lifecycle)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)
- [License](#license)

---

## 🎯 Vision & Overview

### Problem Statement

Many Senior High Schools still rely on paper-based quizzes and manual marking, making it difficult for teachers to assess students efficiently and for students to receive immediate feedback.

### Vision & Solution

**InSchool** provides a simple, web-based Learning Management System that enables:
- ✅ Administrators to manage users and courses
- ✅ Teachers to create online quizzes with automatic grading
- ✅ Students to take quizzes and instantly view results
- ✅ Instant feedback with answer explanations
- ✅ Teacher analytics to track student performance

### Goals

1. **Digitize Assessment** — Replace paper-based quizzes with digital online quizzes
2. **Automatic Grading** — Eliminate manual marking; grade instantly
3. **Instant Feedback** — Students receive scores immediately after submission
4. **Performance Analytics** — Teachers track student progress and identify learning gaps
5. **Secure Assessment** — Control quiz access with optional access codes
6. **Simple User Management** — Admins easily manage teachers, students, and courses

---

## ✨ Features

### 👤 Admin Features

| Feature | Description |
|---------|-------------|
| **Teacher Management** | Create teacher accounts with username and password |
| **Student Import** | Bulk import students from Excel file |
| **Course Management** | Create courses (subjects) with optional course images |
| **Teacher Assignment** | Assign teachers to teach specific courses |
| **User Account Management** | View, edit, activate, deactivate user accounts |
| **System Dashboard** | View system statistics and user counts |
| **Account Status Control** | Activate or deactivate student and teacher accounts |

### 👨‍🏫 Teacher Features

| Feature | Description |
|---------|-------------|
| **View Assigned Courses** | See all courses assigned by admin |
| **Create Quiz** | Create new quiz for assigned course with title and duration |
| **Add Questions** | Add multiple-choice questions (A, B, C, D options) |
| **Quiz Access Control** | Set optional access code (or use default) for quiz security |
| **Publish Quiz** | Change quiz status from DRAFT to PUBLISHED |
| **Quiz Closure** | Close quiz manually or automatically if set |
| **View Quiz Attempts** | See which students attempted quiz and their scores |
| **Student Analytics** | View detailed analytics on student performance per quiz |
| **Track Submissions** | Monitor submission status and student scores |
| **Performance Insights** | Identify struggling students and common problem questions |

### 👨‍🎓 Student Features

| Feature | Description |
|---------|-------------|
| **Secure Login** | Login with username and password |
| **View Available Quizzes** | See all published quizzes for enrolled courses |
| **Quiz Information** | See course, title, and duration before attempting |
| **One-Time Attempt** | Take each quiz only once (enforced by system) |
| **Answer Questions** | Select from A, B, C, D options for each question |
| **Timer** | Quiz timer shows remaining time during attempt |
| **Submit Quiz** | Submit completed quiz for automatic grading |
| **View Results Instantly** | See score immediately after submission |
| **Correct Answer Feedback** | See which answers were correct/incorrect |
| **Performance Summary** | View number of correct and incorrect answers |

---

## 🖥️ System Requirements

### Server Requirements

- **Operating System**: Windows Server 2012 R2 or higher / Linux with IIS compatibility
- **Framework**: .NET Framework 4.7.2 or higher
- **Web Server**: IIS (Internet Information Services) 7.5 or higher
- **RAM**: 4 GB minimum (8 GB recommended)
- **Storage**: 2 GB free disk space

### Database Requirements

- **Database System**: MySQL 5.7 or higher / MySQL 8.0 (recommended)
- **Database Port**: Default 3306 (or custom as configured)
- **User Permissions**: Full CREATE, ALTER, DROP, SELECT, INSERT, UPDATE, DELETE permissions

### Client Requirements

- **Web Browser**: Chrome, Firefox, Safari, Edge (latest versions)
- **Internet Connection**: Required for accessing the web application
- **Screen Resolution**: 1024 x 768 minimum

### Development Tools (for customization)

- **IDE**: Visual Studio 2022 Community Edition (or higher)
- **Language**: C# with ASP.NET Web Forms
- **Database Client**: MySQL Workbench or MySQL Command Line

---

## ⚙️ Installation & Setup

### Step 1: Clone or Download the Project

```bash
# Clone the repository
git clone https://github.com/Mickekofi/ClassQuizManagementSystem.git
cd InSchool
```

### Step 2: Database Setup

1. **Open MySQL Command Line or MySQL Workbench**

2. **Create database:**
   ```sql
   CREATE DATABASE inschool CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
   ```

3. **Import database schema:**
   - Navigate to `Assets/` folder
   - Find `DatabaseQuery.txt`
   - Run it in MySQL to create all tables

4. **Verify database creation:**
   ```sql
   USE inschool;
   SHOW TABLES;
   ```

   Expected tables: `users`, `courses`, `teacher_courses`, `quizzes`, `quiz_questions`, `quiz_attempts`, `quiz_attempt_answers`

### Step 3: Configure Database Connection

1. **Open project in Visual Studio 2022**
   - File → Open → InSchool.sln

2. **Locate Web.config file**
   - Right-click project → Properties
   - Or find `Web.config` in root folder

3. **Update connection string:**
   ```xml
   <connectionStrings>
       <add name="MySqlConnection" connectionString="Server=localhost;Database=inschool;Uid=root;Pwd=your_password;Port=3306" providerName="MySql.Data.MySqlClient" />
   </connectionStrings>
   ```

   Update: `Server`, `Database`, `Uid`, `Pwd`, `Port`

4. **Save file**

### Step 4: Create Initial Admin Account

```sql
INSERT INTO users (username, password_hash, role, full_name, account_status)
VALUES ('admin', SHA2('admin', 256), 'ADMIN', 'System Administrator', 'ACTIVE');
```

Login credentials:
- **Username**: `admin`
- **Password**: `admin123`


### Step 5: Build and Run

1. **Build the solution:**
   - Visual Studio → Build → Build Solution (Ctrl+Shift+B)
   - Verify no compilation errors

2. **Run the application:**
   - Press F5 or Debug → Start Debugging
   - Application opens in default web browser
   - Login page appears

3. **Test Login:**
   - **Admin**: Username: `admin`, Password: `admin123`

---

## 🚀 Quick Start Guide

### For Administrators (First-Time Setup)

#### Phase 1: System Initialization

1. **Login as Admin**
   - Username: `admin`
   - Password: `admin123` (default)
   
![Preview](https://github.com/Mickekofi/ClassQuizManagementSystem/blob/master/AppImages/image1.png)

2. **Create Courses**
   - Admin Dashboard → Courses
   - Add courses: Mathematics, English Language, Physics, Chemistry, History, Government
   - Optionally upload course image



![Preview](https://github.com/Mickekofi/ClassQuizManagementSystem/blob/master/AppImages/image2.png)

![Preview](https://github.com/Mickekofi/ClassQuizManagementSystem/blob/master/AppImages/image3.png)


3. **Create Teachers**
   - Admin Dashboard → Users → Create Teacher
   - Enter: Full Name, Username, Password
   - Create multiple teachers

![Preview](https://github.com/Mickekofi/ClassQuizManagementSystem/blob/master/AppImages/image4.png)




4. **Assign Courses to Teachers**
   - Admin Dashboard → Teacher Assignments
   - Select teacher and assign courses
   - Example: Mr. Mensah teaches Mathematics and Physics

![Preview](https://github.com/Mickekofi/ClassQuizManagementSystem/blob/master/AppImages/image5.png)

![Preview](https://github.com/Mickekofi/ClassQuizManagementSystem/blob/master/AppImages/image6.png)

![Preview](https://github.com/Mickekofi/ClassQuizManagementSystem/blob/master/AppImages/image7.png)


5. **Import Students**
   - Admin Dashboard → Students → Import
   - Prepare Excel CSV file with columns: Username, Full Name
   **NOTE**: Sample of CSV file is found at `Asserts/Book1`
   
![Preview](https://github.com/Mickekofi/ClassQuizManagementSystem/blob/master/AppImages/image8.png)

   - Upload file
   - System auto-creates student accounts with Default Password `1234`

![Preview](https://github.com/Mickekofi/ClassQuizManagementSystem/blob/master/AppImages/image9.png)

6. **Manage User Status**
   - View all users (admins, teachers, students)
   - Activate or deactivate accounts as needed


![Preview](https://github.com/Mickekofi/ClassQuizManagementSystem/blob/master/AppImages/image10.png)


![Preview](https://github.com/Mickekofi/ClassQuizManagementSystem/blob/master/AppImages/image7.png)


#### Phase 2: System Ready for Teachers & Students

Teachers can create quizzes, students can take quizzes.

---

### For Teachers (Quiz Creation & Management)

#### Phase 1: Prepare Quiz

1. **Login as Teacher**
   - Username and password provided by admin

![Preview](https://github.com/Mickekofi/ClassQuizManagementSystem/blob/master/AppImages/image11.png)


2. **View Assigned Courses**
   - Teacher Dashboard shows all assigned courses
   - Example: Mathematics, Physics

3. **Create New Quiz**
   - Select a course: Mathematics
   - Enter: Quiz Title (e.g., "Algebra Basics Quiz")
   - Enter: Duration in minutes (e.g., 30 minutes)
   - Quiz created as DRAFT (not visible to students yet)

![Preview](https://github.com/Mickekofi/ClassQuizManagementSystem/blob/master/AppImages/image12.png)

4. **Add Questions**
   - Click: Add Question
   - Enter: Question text
   - Enter: Option A, Option B, Option C, Option D
   - Select: Correct option (A, B, C, or D)
   - Repeat for all questions (e.g., 20 questions)

![Preview](https://github.com/Mickekofi/ClassQuizManagementSystem/blob/master/AppImages/image13.png)


#### Phase 2: Control Access & Publish

1. **Set Quiz Access Code** (Optional)
   - Default: System generates access code automatically
   - Custom: Teacher can set custom access code
   - Students must enter code before starting quiz

2. **Publish Quiz**
   - Change status from DRAFT to PUBLISHED
   - Quiz immediately visible to all students for that course
   - Quiz timer becomes active

![Preview](https://github.com/Mickekofi/ClassQuizManagementSystem/blob/master/AppImages/image14.png)


#### Phase 3: Monitor & Analytics

![Preview](https://github.com/Mickekofi/ClassQuizManagementSystem/blob/master/AppImages/image22.png)

1. **View Quiz Attempts**
   - See which students attempted the quiz
   - View each student's score
   - Check submission status (submitted or in progress)

![Preview](https://github.com/Mickekofi/ClassQuizManagementSystem/blob/master/AppImages/image23.png)

2. **Student Analytics**
   - View detailed performance per student
   - See which questions students got wrong
   - Identify struggling students
   - Track average score for the quiz

![Preview](https://github.com/Mickekofi/ClassQuizManagementSystem/blob/master/AppImages/image24.png)

3. **Close Quiz**
   - Close quiz manually when testing period ends
   - Or set automatic closure if configured
   - Students can no longer access closed quiz

![Preview](https://github.com/Mickekofi/ClassQuizManagementSystem/blob/master/AppImages/image25.png)

---

### For Students (Taking & Viewing Quiz)

#### Phase 1: Access Quiz

1. **Login as Student**
   - Username and password provided by admin


![Preview](https://github.com/Mickekofi/ClassQuizManagementSystem/blob/master/AppImages/image15.png)


2. **View Available Quizzes**
   - Student Dashboard shows all published quizzes
   - Each quiz shows: Course name, Quiz title, Duration

![Preview](https://github.com/Mickekofi/ClassQuizManagementSystem/blob/master/AppImages/image16.png)

3. **Verify Quiz Details**
   - Click quiz to see full details
   - Confirm you want to start

![Preview](https://github.com/Mickekofi/ClassQuizManagementSystem/blob/master/AppImages/image16.png)

#### Phase 2: Take Quiz

1. **Start Quiz**
   - Click: Start Quiz
   - If quiz has access code: Enter code
   - Quiz timer starts

![Preview](https://github.com/Mickekofi/ClassQuizManagementSystem/blob/master/AppImages/image17.png)


2. **Answer Questions**
   - Read question
   - Select from: A, B, C, or D
   - Move to next question
   - **Note**: Each quiz can only be taken ONCE

![Preview](https://github.com/Mickekofi/ClassQuizManagementSystem/blob/master/AppImages/image18.png)

3. **Submit Quiz**
   - Review all answers
   - Click: Submit
   - System auto-grades and records score

![Preview](https://github.com/Mickekofi/ClassQuizManagementSystem/blob/master/AppImages/image19.png)

#### Phase 3: View Results

1. **See Score Immediately**
   - View: Total score (e.g., 18/20)
   - View: Number correct and incorrect
   - See which answers were correct/incorrect

![Preview](https://github.com/Mickekofi/ClassQuizManagementSystem/blob/master/AppImages/image20.png)

2. **Review Performance**
   - Identify weak areas
   - Learn from mistakes

![Preview](https://github.com/Mickekofi/ClassQuizManagementSystem/blob/master/AppImages/image21.png)

---

## 🔄 How It Works

### Complete System Flow

```
ADMIN SETUP
├─ Create Courses (Mathematics, English, Physics, etc.)
├─ Create Teachers (Mr. Mensah, Mrs. Owusu, etc.)
├─ Assign Teachers to Courses
└─ Import Students (bulk from Excel)

TEACHER CREATES QUIZ
├─ Select assigned course
├─ Enter: Quiz title, Duration (minutes)
├─ Add questions (multiple-choice A/B/C/D)
├─ Set optional access code (or use default)
├─ Change status: DRAFT → PUBLISHED
└─ Quiz visible to all students in that course

STUDENT TAKES QUIZ
├─ Login and view available published quizzes
├─ Start quiz (if access code required, enter it)
├─ Answer each multiple-choice question
├─ Submit completed quiz
├─ System automatically grades (compare selected_option vs correct_option)
├─ Display score immediately
└─ Show correct/incorrect answers

TEACHER MONITORS
├─ View which students attempted quiz
├─ See each student's score
├─ View analytics on performance
└─ Close quiz when done
```

---

## 🛠️ Technology Stack

| Layer | Technology | Version |
|-------|-----------|---------|
| **Language** | C# | .NET Framework 4.7.2+ |
| **Web Framework** | ASP.NET Web Forms | Built-in |
| **IDE** | Visual Studio | 2022 |
| **Database** | MySQL | 5.7 / 8.0 |
| **Web Server** | IIS | 7.5+ |
| **Architecture** | Single-tier Monolithic | Web Application |

---

## 📂 Project Structure

```
InSchool/
├── App_Data/                           # Application data storage
├── App_Start/                          # Application startup configuration
├── Content/                            # CSS, styles
├── Scripts/                            # JavaScript files
├── src/
│   ├── Assets/
│   │   └── DatabaseQuery.txt           # MySQL database schema
│   ├── Core/                           # Core utilities
│   ├── Features/
│   │   ├── Admin/
│   │   │   ├── CourseManagement.aspx   # Create courses
│   │   │   ├── UserManagement.aspx     # Create users
│   │   │   ├── TeacherAssignment.aspx  # Assign teachers to courses
│   │   │   ├── StudentImport.aspx      # Bulk import students
│   │   │   └── AdminDashboard.aspx     # Admin main screen
│   │   ├── Teacher/
│   │   │   ├── CreateQuiz.aspx         # Create new quiz
│   │   │   ├── AddQuestions.aspx       # Add questions to quiz
│   │   │   ├── PublishQuiz.aspx        # Change quiz status
│   │   │   ├── ViewAttempts.aspx       # View student attempts
│   │   │   ├── Analytics.aspx          # Student performance analytics
│   │   │   └── TeacherDashboard.aspx   # Teacher main screen
│   │   ├── Student/
│   │   │   ├── ViewQuizzes.aspx        # List available quizzes
│   │   │   ├── TakeQuiz.aspx           # Quiz interface
│   │   │   ├── SubmitQuiz.aspx         # Quiz submission handler
│   │   │   ├── ViewResults.aspx        # Quiz results and feedback
│   │   │   └── StudentDashboard.aspx   # Student main screen
│   │   └── Shared/
│   │       ├── Login.aspx              # Login page
│   │       └── MasterPage.master       # Site master template
│   └── Trials/                         # Trial/test pages
├── Web.config                          # Application configuration
├── Global.asax                         # Global application events
└── InSchool.sln                        # Visual Studio Solution
```

---

## 🔧 Configuration

### Database Connection

**File**: `Web.config`

```xml
<connectionStrings>
    <add name="MySqlConnection" 
         connectionString="Server=localhost;Database=inschool;Uid=root;Pwd=password;Port=3306" 
         providerName="MySql.Data.MySqlClient" />
</connectionStrings>
```

**Parameters**:
- `Server` — MySQL server address (localhost for local)
- `Database` — Database name (inschool)
- `Uid` — MySQL username (root)
- `Pwd` — MySQL password
- `Port` — MySQL port (3306)

### Application Settings

Edit `Web.config` for application-level settings:
- Default access code length
- Quiz timer defaults
- Maximum import file size

---

## 👥 User Roles & Workflows

### 1. Administrator Role

**Responsibilities**:
- Create and manage teacher accounts
- Import student accounts in bulk
- Create courses (subjects)
- Assign teachers to courses
- Activate/deactivate accounts
- Monitor system usage

**Dashboard Access**:
- User Management
- Course Management
- Teacher Assignment
- Student Import
- System Statistics

---

### 2. Teacher Role

**Responsibilities**:
- Create quizzes for assigned courses
- Add multiple-choice questions
- Publish quizzes to students
- Monitor student attempts
- View student performance analytics
- Close quizzes when done

**Dashboard Access**:
- My Courses (assigned by admin)
- Create Quiz
- Quiz Management
- Student Performance Analytics
- Quiz Attempts View

---

### 3. Student Role

**Responsibilities**:
- Take published quizzes
- Answer questions correctly
- Submit quiz for grading
- View instant results
- Learn from feedback

**Dashboard Access**:
- Available Quizzes (published only)
- Take Quiz
- View Results

---

## 📊 Quiz Lifecycle

Every quiz progresses through defined states:

```
DRAFT
└─ Teacher creating quiz
└─ Not visible to students
└─ Teacher can add/edit questions
└─ Teacher can delete quiz

PUBLISHED
└─ Quiz visible to students
└─ Students can start and take quiz
└─ Each student can attempt ONLY ONCE
└─ Teacher can close quiz

CLOSED
└─ Quiz no longer visible to students
└─ Students cannot start new attempts
└─ Teacher can still view previous attempts
└─ Quiz archived
```

---

## 🐛 Troubleshooting

### Database Connection Issues

**Problem**: "Cannot connect to database"
```
Solution:
1. Verify MySQL server is running
2. Check connection string in Web.config
3. Verify username and password
4. Ensure database 'inschool' exists
5. Test connection: mysql -h localhost -u root -p
```

### Login Issues

**Problem**: "Invalid username or password"
```
Solution:
1. Verify user exists: SELECT * FROM users WHERE username = 'username';
2. Check account status: account_status = 'ACTIVE'
3. Activate account if needed: UPDATE users SET account_status = 'ACTIVE'
4. Reset password in database
```

### Quiz Not Appearing for Students

**Problem**: "Quiz doesn't show in student's available quizzes"
```
Solution:
1. Verify quiz status = 'PUBLISHED' (not 'DRAFT')
2. Check student is enrolled in quiz's course
3. Verify teacher assigned to that course
4. Verify student account is ACTIVE
```

### Quiz Grading Issues

**Problem**: "Quiz score is incorrect"
```
Solution:
1. Verify all questions have correct_option set
2. Check quiz_attempt_answers: selected_option vs correct_option
3. Verify is_correct flag is properly calculated
```

### Student Can Take Quiz Multiple Times

**Problem**: "Student took quiz more than once"
```
Solution:
1. Check quiz_attempts table: Should have only 1 record per student per quiz
2. Verify application logic prevents duplicate attempts
3. Add database constraint if needed: UNIQUE(quiz_id, student_user_id)
```

---

## 👥 Contributing

### How to Contribute

1. **Report Bugs** — Open GitHub Issue with:
   - Steps to reproduce
   - Expected vs actual behavior
   - Screenshots
   - Browser/environment info

2. **Suggest Features** — Open Feature Request issue

3. **Submit Code**:
   ```bash
   # Fork, create feature branch
   git checkout -b feature/YourFeature
   # Make changes
   git commit -m "Add feature"
   git push origin feature/YourFeature
   # Open Pull Request
   ```

---

## 📄 License

See `LICENSE` file for licensing terms.

---

## 📞 Support

**Questions?** Review:
- [DATABASE.md](./DATABASE.md) — Complete database schema
- [ARCHITECTURE.md](./ARCHITECTURE.md) — System design and workflows

---

## 🎯 Keywords for SEO

`learning management system`, `online quiz system`, `automatic grading`, `school LMS`, `quiz software`, `student assessment`, `online testing`, `teacher analytics`, `exam management`, `web-based learning`, `ASP.NET learning system`, `school quiz platform`

---


**Built With**: C# | ASP.NET Web Forms | MySQL

📚 *Simplifying online assessment for Senior High Schools.*
