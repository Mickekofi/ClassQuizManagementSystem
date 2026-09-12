# 🏗️ System Architecture & Design


![Preview](https://github.com/Mickekofi/ClassQuizManagementSystem/blob/master/AppImages/achitecture_image.png)


**InSchool Learning Management System — Technical Architecture Reference**

Complete documentation of the system architecture, component design, data flows, design patterns, and technical implementation.

---

## 📋 Table of Contents

- [Architecture Overview](#architecture-overview)
- [System Architecture Diagram](#system-architecture-diagram)
- [Technology Stack](#technology-stack)
- [Application Layers](#application-layers)
- [Core Modules & Components](#core-modules--components)
- [Data Flow & Workflows](#data-flow--workflows)
- [Design Patterns](#design-patterns)
- [Authentication & Authorization](#authentication--authorization)
- [Security Architecture](#security-architecture)
- [Quiz Grading Engine](#quiz-grading-engine)
- [Performance Optimization](#performance-optimization)
- [Scalability & Future Enhancements](#scalability--future-enhancements)
- [Development Standards](#development-standards)

---

## 🎯 Architecture Overview

### System Type

**Three-Tier Web Application for Online Quiz Management**

- **Deployment Model**: Web-based ASP.NET Web Forms application
- **Architecture Pattern**: Single-tier web application (simplified N-tier)
- **Execution Model**: Server-side rendering with database backend
- **Scalability**: Designed for school use; handles 100-1000 students, 50+ quizzes

### Core Principles

✅ **Three-Tier User Model** — Admin, Teacher, Student with separate workflows
✅ **Course-Based Organization** — Quizzes tied to courses with teacher assignments
✅ **Automatic Grading** — Instant quiz grading on submission
✅ **One-Time Attempt** — Students take each quiz only once (enforced at database)
✅ **Instant Feedback** — Students see results immediately after submission

### Key Architectural Decisions

| Decision | Rationale | Trade-Off |
|----------|-----------|-----------|
| **Web-Based** | Accessible from browser, no installation needed | Requires web server |
| **ASP.NET Web Forms** | Rapid development with drag-drop controls | Not modern compared to MVC/Core |
| **Single Database** | Simple deployment, easy backup | Not scalable for massive data |
| **Automatic Grading** | Instant feedback for students | Requires carefully designed questions |
| **One Attempt Only** | Prevents cheating through re-takes | No practice mode |

---

## 🔀 System Architecture Diagram

### High-Level Component Architecture

```
┌────────────────────────────────────────────────────────┐
│             INSCHOOL LEARNING MANAGEMENT SYSTEM          │
│                    Web-Based Application                │
└────────────────────────────────────────────────────────┘

┌────────────────────────────────────────────────────────────────┐
│            PRESENTATION LAYER (ASP.NET Web Forms UI)           │
├──────────────────┬─────────────────┬───────────────────────────┤
│                  │                 │                           │
│ ADMIN INTERFACE  │ TEACHER PORTAL  │  STUDENT PORTAL          │
│ ────────────     │ ────────────    │  ──────────────          │
│ • Dashboard      │ • Dashboard     │  • Available Quizzes     │
│ • Users          │ • My Courses    │  • Take Quiz             │
│ • Courses        │ • Create Quiz   │  • View Results          │
│ • Assign Teachers│ • Add Questions │  • Quiz History          │
│ • Import Students│ • Publish Quiz  │                          │
│ • Manage Status  │ • View Attempts │                          │
│                  │ • Analytics     │                          │
│                  │ • Close Quiz    │                          │
│                  │                 │                          │
└──────────────────┴─────────────────┴───────────────────────────┘

┌────────────────────────────────────────────────────────────────┐
│            BUSINESS LOGIC LAYER (Core Operations)              │
├────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌──────────────────────────────────────────────────────────┐ │
│  │ USER MANAGEMENT ENGINE                                  │ │
│  │ • Authenticate users (username/password)                │ │
│  │ • Authorize by role (ADMIN, TEACHER, STUDENT)           │ │
│  │ • Manage account status (ACTIVE/INACTIVE)               │ │
│  │ • Bulk import students from Excel                       │ │
│  └──────────────────────────────────────────────────────────┘ │
│                                                                 │
│  ┌──────────────────────────────────────────────────────────┐ │
│  │ COURSE & TEACHER MANAGEMENT ENGINE                      │ │
│  │ • Create courses (subjects)                              │ │
│  │ • Assign teachers to courses (unique per pair)           │ │
│  │ • Validate teacher-course relationships                  │ │
│  └──────────────────────────────────────────────────────────┘ │
│                                                                 │
│  ┌──────────────────────────────────────────────────────────┐ │
│  │ QUIZ CREATION & MANAGEMENT ENGINE                       │ │
│  │ • Create quiz (DRAFT status)                             │ │
│  │ • Add multiple-choice questions (A/B/C/D)                │ │
│  │ • Publish quiz (DRAFT → PUBLISHED)                       │ │
│  │ • Set access codes (optional or default)                 │ │
│  │ • Close quiz (PUBLISHED → CLOSED)                        │ │
│  │ • Prevent unauthorized access                           │ │
│  └──────────────────────────────────────────────────────────┘ │
│                                                                 │
│  ┌──────────────────────────────────────────────────────────┐ │
│  │ QUIZ ATTEMPT ENGINE                                     │ │
│  │ • Start quiz for student (check PUBLISHED status)        │ │
│  │ • Enforce one-attempt rule (unique constraint)           │ │
│  │ • Track start time and submission                        │ │
│  │ • Capture student answers                                │ │
│  └──────────────────────────────────────────────────────────┘ │
│                                                                 │
│  ┌──────────────────────────────────────────────────────────┐ │
│  │ AUTOMATIC GRADING ENGINE                                │ │
│  │ • Compare selected_option vs correct_option              │ │
│  │ • Mark each question correct/incorrect                   │ │
│  │ • Calculate final score                                  │ │
│  │ • Show instant feedback                                  │ │
│  └──────────────────────────────────────────────────────────┘ │
│                                                                 │
│  ┌──────────────────────────────────────────────────────────┐ │
│  │ ANALYTICS & REPORTING ENGINE                            │ │
│  │ • Calculate student performance per quiz                 │ │
│  │ • Identify struggling students                           │ │
│  │ • Track common wrong questions                           │ │
│  │ • Generate teacher reports                               │ │
│  └──────────────────────────────────────────────────────────┘ │
│                                                                 │
└────────────────────────────────────────────────────────────────┘

┌────────────────────────────────────────────────────────────────┐
│                 DATA ACCESS LAYER (Repository)                 │
├────────────────────────────────────────────────────────────────┤
│                                                                 │
│  • ADO.NET for database access                                 │
│  • Parameterized queries (prevent SQL injection)               │
│  • Connection pooling from Web.config                          │
│  • CRUD operations on all entities                             │
│                                                                 │
└────────────────────────────────────────────────────────────────┘

┌────────────────────────────────────────────────────────────────┐
│            PERSISTENCE LAYER (MySQL Database)                  │
├────────────────────────────────────────────────────────────────┤
│                                                                 │
│  • users (authentication, 3 roles)                             │
│  • courses (subjects)                                          │
│  • teacher_courses (junction table)                            │
│  • quizzes (quiz headers with status)                          │
│  • quiz_questions (multiple-choice questions)                  │
│  • quiz_attempts (student attempts, unique constraint)         │
│  • quiz_attempt_answers (student answers, auto-grading)        │
│                                                                 │
│  MySQL 5.7 / 8.0 Database (inschool)                            │
│  ACID Compliant | Foreign Key Constraints | Cascading Updates  │
│                                                                 │
└────────────────────────────────────────────────────────────────┘
```

---

## 🛠️ Technology Stack

| Layer | Technology | Version | Purpose |
|-------|-----------|---------|---------|
| **Language** | C# | .NET Framework 4.7.2+ | Backend logic |
| **Web Framework** | ASP.NET Web Forms | Built-in | Web UI |
| **IDE** | Visual Studio | 2022 | Development |
| **Database** | MySQL | 5.7 / 8.0 | Data storage |
| **Web Server** | IIS | 7.5+ | Hosting |
| **Frontend** | HTML5, CSS3, JavaScript | Latest | Client-side |
| **Architecture** | Single-tier Web App | Monolithic | System design |

---

## 📚 Application Layers

### Layer 1: Presentation Layer

**Location**: `src/Features/` folder (Admin, Teacher, Student .aspx files)

**Responsibility**: Render UI, capture input, display data

**Components**:
- **Admin Pages**
  - CourseManagement.aspx — Create/manage courses
  - UserManagement.aspx — Create teachers/students
  - TeacherAssignment.aspx — Assign teachers to courses
  - StudentImport.aspx — Bulk student import from Excel
  - AdminDashboard.aspx — System overview

- **Teacher Pages**
  - CreateQuiz.aspx — New quiz creation
  - AddQuestions.aspx — Add multiple-choice questions
  - PublishQuiz.aspx — Change quiz status
  - ViewAttempts.aspx — Student attempt list
  - Analytics.aspx — Student performance analytics
  - TeacherDashboard.aspx — Teacher home

- **Student Pages**
  - ViewQuizzes.aspx — Available quizzes
  - TakeQuiz.aspx — Quiz interface with timer
  - SubmitQuiz.aspx — Submit for grading
  - ViewResults.aspx — Score and feedback
  - StudentDashboard.aspx — Student home

- **Shared Pages**
  - Login.aspx — User authentication
  - MasterPage.master — Site template

---

### Layer 2: Business Logic Layer

**Location**: `src/` folder (C# business classes)

**Responsibility**: Implement core workflows

**Key Logic**:

```csharp
// User Authentication
public class UserService {
    public User Authenticate(string username, string password) {
        // Query: users WHERE username = @username
        // Compare SHA-256 hashes
        // Return user if match
    }
    
    public bool Authorize(User user, string requiredRole) {
        // Check: user.role == requiredRole
        // Return true/false
    }
}

// Quiz Management
public class QuizService {
    public Quiz CreateQuiz(int courseId, int teacherId, string title, int duration) {
        // Validate: teacher assigned to course
        // INSERT INTO quizzes (status='DRAFT')
        // Return quiz_id
    }
    
    public void PublishQuiz(int quizId) {
        // Validate: Quiz has questions
        // UPDATE quizzes SET status='PUBLISHED'
    }
}

// Quiz Attempt & Grading
public class QuizAttemptService {
    public QuizAttempt StartQuiz(int quizId, int studentId, string accessCode) {
        // Validate: Quiz status = 'PUBLISHED'
        // Validate: Access code (if required)
        // Check: Student hasn't already attempted this quiz (UNIQUE constraint)
        // INSERT INTO quiz_attempts
        // Return attempt_id
    }
    
    public void SubmitQuiz(int attemptId, Dictionary<int, char> answers) {
        // For each answer:
        //   Compare selected_option vs correct_option
        //   Mark is_correct = true/false
        //   INSERT INTO quiz_attempt_answers
        // Calculate score = COUNT(is_correct)
        // UPDATE quiz_attempts SET score, is_submitted=TRUE
        // Display results to student
    }
}

// Analytics
public class AnalyticsService {
    public QuizAnalytics GetQuizAnalytics(int quizId) {
        // Calculate: Average score, highest/lowest scores
        // Identify: Which questions most students got wrong
        // Return: Summary for teacher
    }
}
```

---

### Layer 3: Data Access Layer

**Location**: `src/` folder (Repository classes)

**Pattern**: ADO.NET with parameterized queries

```csharp
public class UserRepository {
    public User GetByUsername(string username) {
        // Open connection from pool
        // Execute: SELECT * FROM users WHERE username = @username
        // Map ResultSet to User object
        // Return user
    }
    
    public void CreateUser(User user) {
        // Hash password
        // INSERT INTO users (username, password_hash, role, full_name)
        // Close connection
    }
}

public class QuizRepository {
    public Quiz GetById(int quizId) {
        // SELECT * FROM quizzes WHERE quiz_id = @id
        // With joined course and creator info
    }
    
    public List<Quiz> GetPublishedQuizzesByCourse(int courseId) {
        // SELECT * FROM quizzes WHERE course_id = @course AND status = 'PUBLISHED'
    }
}
```

---

### Layer 4: Persistence Layer

**Location**: MySQL database (inschool)

**7 Tables**: users, courses, teacher_courses, quizzes, quiz_questions, quiz_attempts, quiz_attempt_answers

---

## 🔄 Data Flow & Workflows

### Workflow 1: Admin Creates Courses & Assigns Teachers

```
Admin Login
    ↓
Admin Dashboard
    ↓
Create Course: Mathematics
    ├→ course_name = "Mathematics"
    ├→ image_path = "assets/math.png" (optional)
    └→ INSERT INTO courses
    ↓
Create Teacher: Mr. Mensah
    ├→ username = "mensah"
    ├→ password_hash = SHA-256("password123")
    ├→ role = "TEACHER"
    └→ INSERT INTO users
    ↓
Assign Teacher to Course
    ├→ teacher_user_id = mensah's ID
    ├→ course_id = Mathematics ID
    └→ INSERT INTO teacher_courses (UNIQUE constraint prevents duplicates)
    ↓
Teacher Can Now Create Quizzes for Mathematics
```

---

### Workflow 2: Teacher Creates & Publishes Quiz

```
Teacher Login
    ↓
Teacher Dashboard → My Courses
    ├→ Query: teacher_courses WHERE teacher_user_id = current_user
    ├→ Display assigned courses
    └→ Select: Mathematics
    ↓
Create Quiz
    ├→ title = "Algebra Basics Quiz"
    ├→ duration_minutes = 30
    ├→ access_code = (optional, or use system default)
    └→ INSERT INTO quizzes (status='DRAFT')
    ↓
Add Questions to Quiz
    ├→ Question 1: "What is 2+2?"
    │   Options: A=3, B=4, C=5, D=6
    │   Correct: B
    │   INSERT INTO quiz_questions
    ├→ Question 2: ...
    └→ Question 20: ...
    ↓
Publish Quiz
    └→ UPDATE quizzes SET status='PUBLISHED'
    ↓
Quiz Now Visible to All Students in Mathematics Course
```

---

### Workflow 3: Student Takes Quiz

```
Student Login
    ↓
Student Dashboard
    ├→ Query: quizzes WHERE course_id IN (student's enrolled courses)
    ├→ Filter: status='PUBLISHED' AND status!='CLOSED'
    └→ Display available quizzes
    ↓
Click: "Algebra Basics Quiz"
    ├→ Show: Title, Duration (30 min), Course
    └→ Click: "Start Quiz"
    ↓
StartQuiz()
    ├→ Validate: Quiz status = 'PUBLISHED'
    ├→ If quiz requires access_code: Ask student to enter
    ├→ Check: unique_constraint(quiz_id, student_user_id)
    │   ✓ If no existing attempt: Proceed
    │   ✗ If already attempted: Show error "Already attempted"
    └→ INSERT INTO quiz_attempts (is_submitted=FALSE)
    ↓
Take Quiz (30-minute timer)
    ├→ Question 1: Student selects "B"
    ├→ Question 2: Student selects "D"
    ├→ ...continues...
    └→ Question 20: Student selects "A"
    ↓
Submit Quiz
    ├→ SubmitQuiz()
    ├→ For each answer:
    │   ├→ Compare selected_option vs correct_option
    │   ├→ Set is_correct = true/false
    │   └→ INSERT INTO quiz_attempt_answers
    ├→ Calculate: score = 18 (18 correct out of 20)
    ├→ UPDATE quiz_attempts SET score=18, is_submitted=TRUE
    └→ Return to results page
    ↓
View Results Instantly
    ├→ Display: Score 18/20 (90%)
    ├→ Show: Correct answers vs incorrect answers
    ├→ List: Questions marked correct (✓) or incorrect (✗)
    └→ Show: Correct option for each wrong answer
```

---

### Workflow 4: Teacher Views Analytics

```
Teacher Dashboard
    ↓
Select: "Algebra Basics Quiz"
    ↓
View Attempts
    ├→ Query: quiz_attempts WHERE quiz_id = @quiz
    ├→ List: All students who attempted
    ├→ Show: Each student's score
    └→ Status: Submitted or In Progress
    ↓
Analytics View
    ├→ Average Score: 75%
    ├→ Highest Score: 98%
    ├→ Lowest Score: 45%
    ├→ Questions Analysis:
    │   ├→ Question 5: 80% got wrong (most difficult)
    │   └→ Question 15: 90% got wrong (review needed)
    └→ Struggling Students: [List names with scores < 50%]
```

---

## 🎨 Design Patterns

### 1. Repository Pattern (Data Access)

```csharp
public class UserRepository {
    public User GetById(int userId) { /* ... */ }
    public User GetByUsername(string username) { /* ... */ }
    public void Create(User user) { /* ... */ }
    public void Update(User user) { /* ... */ }
    public void Delete(int userId) { /* ... */ }
}

// Usage in business layer:
var user = userRepository.GetByUsername("mensah");
if (user != null && user.accountStatus == "ACTIVE") {
    // Proceed with login
}
```

---

### 2. Service Layer Pattern

```csharp
public class QuizService {
    private QuizRepository quizRepository;
    private QuestionRepository questionRepository;
    private AttemptRepository attemptRepository;
    
    public Quiz CreateQuiz(QuizRequest request) {
        // Validation logic
        // Business logic
        // Call repository to persist
    }
}
```

---

### 3. Singleton Pattern (Configuration)

```csharp
public class AppSettings {
    private static AppSettings instance;
    
    public static AppSettings GetInstance() {
        if (instance == null) {
            instance = new AppSettings();
        }
        return instance;
    }
}
```

---

## 🔐 Authentication & Authorization

### Authentication (Login)

```csharp
public class AuthService {
    public bool Login(string username, string password) {
        var user = userRepository.GetByUsername(username);
        
        if (user == null || user.accountStatus == "INACTIVE") {
            return false;
        }
        
        // Hash input password and compare
        string inputHash = PasswordHasher.Hash(password);
        
        if (inputHash == user.passwordHash) {
            // Login successful
            Session["UserID"] = user.userId;
            Session["Role"] = user.role;
            Session["FullName"] = user.fullName;
            return true;
        }
        
        return false;
    }
}
```

### Authorization (Role-Based)

```csharp
public class AuthorizationFilter {
    public static bool IsAdmin() {
        return Session["Role"]?.ToString() == "ADMIN";
    }
    
    public static bool IsTeacher() {
        return Session["Role"]?.ToString() == "TEACHER";
    }
    
    public static bool IsStudent() {
        return Session["Role"]?.ToString() == "STUDENT";
    }
}

// Usage in Page_Load:
if (!AuthorizationFilter.IsTeacher()) {
    Response.Redirect("~/Login.aspx");
}
```

---

## 🛡️ Security Architecture

### Input Validation

✅ **Parameterized Queries** (prevent SQL injection)

### Password Security

✅ **SHA-256 Hashing** (minimum; bcrypt recommended for production)

### Access Control

✅ **Role-Based Authorization** (ADMIN, TEACHER, STUDENT)
✅ **Session Management** (timeout, automatic logout)

### Quiz Access Control

✅ **Access Codes** (optional, teacher-set or system default)
✅ **Quiz Status Validation** (can't start DRAFT or CLOSED quizzes)

---

## 📊 Quiz Grading Engine

### Automatic Grading Algorithm

```csharp
public class GradingEngine {
    public QuizResult Grade(int attemptId) {
        var attempt = attemptRepository.GetById(attemptId);
        var answers = attemptAnswerRepository.GetByAttemptId(attemptId);
        
        int correctCount = 0;
        
        foreach (var answer in answers) {
            var question = questionRepository.GetById(answer.questionId);
            
            if (answer.selectedOption == question.correctOption) {
                answer.isCorrect = true;
                correctCount++;
            } else {
                answer.isCorrect = false;
            }
            
            attemptAnswerRepository.Update(answer);
        }
        
        // Update attempt with final score
        attempt.score = correctCount;
        attempt.isSubmitted = true;
        attemptRepository.Update(attempt);
        
        return new QuizResult {
            TotalQuestions = answers.Count,
            CorrectAnswers = correctCount,
            Percentage = (correctCount * 100) / answers.Count,
            Feedback = GenerateFeedback(correctCount, answers.Count)
        };
    }
}
```

---

## ⚡ Performance Optimization

### Database Indexing

```sql
-- Frequently queried columns
CREATE INDEX idx_users_username ON users(username);
CREATE INDEX idx_courses_name ON courses(course_name);
CREATE INDEX idx_quizzes_status ON quizzes(status);
CREATE INDEX idx_quiz_attempts_quiz ON quiz_attempts(quiz_id);
CREATE INDEX idx_quiz_attempts_student ON quiz_attempts(student_user_id);
```

### Connection Pooling

```xml
<!-- Web.config -->
<connectionStrings>
    <add name="MySqlConnection" 
         connectionString="Server=localhost;Database=inschool;Min Pool Size=5;Max Pool Size=20;..." />
</connectionStrings>
```

### Caching

```csharp
// Cache course list (rarely changes)
var courses = HttpContext.Current.Cache["Courses"] as List<Course>;
if (courses == null) {
    courses = courseRepository.GetAll();
    HttpContext.Current.Cache.Insert("Courses", courses, null, 
        DateTime.Now.AddHours(1), TimeSpan.Zero);
}
```

---

## 🚀 Scalability & Future Enhancements

### Phase 2 Enhancements

- [ ] Multiple attempts with best score tracking
- [ ] Timed practice quizzes (no grading, instant feedback)
- [ ] Question categories and difficulty levels
- [ ] Shuffle question order for each student
- [ ] Partial credit options (e.g., multiple correct answers)
- [ ] Quiz statistics and reports (PDF export)

### Phase 3+ Enhancements

- [ ] Question bank and question randomization
- [ ] Mobile app for students (take quizzes on phone)
- [ ] Real-time notifications (submission alerts)
- [ ] Advanced analytics (learning curve tracking)
- [ ] AI-powered question recommendation
- [ ] Video explanations for wrong answers
- [ ] Integration with school ERP system

---

## 📝 Development Standards

### Naming Conventions

```csharp
// Classes (PascalCase)
public class QuizService { }
public class UserRepository { }

// Methods (PascalCase)
public void CreateQuiz() { }
public User GetByUsername() { }

// Variables (camelCase)
int attemptId = 5;
string quizTitle = "Math Quiz";

// Constants (UPPER_SNAKE_CASE)
private const int MAX_QUESTIONS = 100;
private const string DEFAULT_ACCESS_CODE = "DEFAULT";
```

### Code Organization

```
src/
├── Core/
│   ├── Services/
│   ├── Repositories/
│   └── Models/
├── Features/
│   ├── Admin/
│   ├── Teacher/
│   └── Student/
└── Shared/
    ├── Utilities/
    └── Helpers/
```

---

## 🔗 Related Documentation

- **README.md** — Project overview and setup guide
- **DATABASE.md** — Complete database schema
- **Assets/DatabaseQuery.txt** — SQL table creation script

---


**Technology**: ASP.NET Web Forms | C# | MySQL  

🏗️ *Simple, effective online quiz management for schools.*
