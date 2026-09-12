using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;

namespace InSchool.src.Features.Student
{
    public partial class AvailableCourses : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadCourseCatalog();
            }
        }

        private void LoadCourseCatalog()
        {
            try
            {
                using (MySqlConnection conn = Database.CreateOpenConnection())
                {
                    string query = @"
                        SELECT 
                            c.course_id,
                            c.course_name,
                            c.image_path,
                            COALESCE(u.full_name, 'Unassigned') AS TeacherName,
                            (SELECT COUNT(q.quiz_id) 
                             FROM quizzes q 
                             WHERE q.course_id = c.course_id 
                               AND q.status = 'PUBLISHED' -- STRICT CHECK: Excludes DRAFT and CLOSED
                               AND q.quiz_id NOT IN (
                                   SELECT qa.quiz_id FROM quiz_attempts qa 
                                   WHERE qa.student_user_id = @StudentId AND qa.is_submitted = TRUE
                               )
                            ) AS ActiveQuizCount
                        FROM courses c
                        LEFT JOIN teacher_courses tc ON c.course_id = tc.course_id
                        LEFT JOIN users u ON tc.teacher_user_id = u.user_id
                        ORDER BY c.course_name";

                    using (MySqlCommand cmd = new MySqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@StudentId", SessionManager.UserId);
                        using (MySqlDataAdapter sda = new MySqlDataAdapter(cmd))
                        {
                            DataTable dt = new DataTable();
                            sda.Fill(dt);
                            rptCourses.DataSource = dt;
                            rptCourses.DataBind();
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error loading catalog: " + ex.Message, true);
            }
        }

        protected void rptCourses_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "ViewCourse")
            {
                int courseId = Convert.ToInt32(e.CommandArgument);
                LoadQuizzesForCourse(courseId);
            }
        }

        private void LoadQuizzesForCourse(int courseId)
        {
            try
            {
                using (MySqlConnection conn = Database.CreateOpenConnection())
                {
                    string nameQuery = "SELECT course_name FROM courses WHERE course_id = @CourseId";
                    using (MySqlCommand nameCmd = new MySqlCommand(nameQuery, conn))
                    {
                        nameCmd.Parameters.AddWithValue("@CourseId", courseId);
                        litSelectedCourse.Text = nameCmd.ExecuteScalar()?.ToString();
                    }

                    string quizQuery = @"
                        SELECT quiz_id, title, duration_minutes 
                        FROM quizzes 
                        WHERE course_id = @CourseId 
                          AND status = 'PUBLISHED' -- STRICT CHECK: Only load open quizzes
                          AND quiz_id NOT IN (
                              SELECT quiz_id FROM quiz_attempts 
                              WHERE student_user_id = @StudentId AND is_submitted = TRUE
                          )";

                    using (MySqlCommand quizCmd = new MySqlCommand(quizQuery, conn))
                    {
                        quizCmd.Parameters.AddWithValue("@CourseId", courseId);
                        quizCmd.Parameters.AddWithValue("@StudentId", SessionManager.UserId);

                        using (MySqlDataAdapter sda = new MySqlDataAdapter(quizCmd))
                        {
                            DataTable dt = new DataTable();
                            sda.Fill(dt);
                            gvQuizzes.DataSource = dt;
                            gvQuizzes.DataBind();
                        }
                    }
                }

                pnlCourseList.Visible = false;
                pnlQuizList.Visible = true;
                lblMessage.Text = "";
            }
            catch (Exception ex)
            {
                ShowMessage("Error loading quizzes: " + ex.Message, true);
            }
        }

        protected void btnBack_Click(object sender, EventArgs e)
        {
            pnlQuizList.Visible = false;
            pnlCourseList.Visible = true;

            // Refresh the catalog just in case they finished a quiz and clicked back
            LoadCourseCatalog();
        }

        protected void gvQuizzes_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "StartQuiz")
            {
                int quizId = Convert.ToInt32(e.CommandArgument);

                GridViewRow row = (GridViewRow)(((Control)e.CommandSource).NamingContainer);
                TextBox txtPasscode = (TextBox)row.FindControl("txtStudentPasscode");

                if (txtPasscode == null)
                {
                    ShowMessage("System Error: Could not locate passcode input field.", true);
                    return;
                }

                string enteredCode = txtPasscode.Text.Trim();

                try
                {
                    using (MySqlConnection conn = Database.CreateOpenConnection())
                    {
                        string query = "SELECT access_code FROM quizzes WHERE quiz_id = @QuizId";
                        using (MySqlCommand cmd = new MySqlCommand(query, conn))
                        {
                            cmd.Parameters.AddWithValue("@QuizId", quizId);
                            object dbCodeObj = cmd.ExecuteScalar();

                            string realCode = (dbCodeObj == DBNull.Value || dbCodeObj == null) ? "" : dbCodeObj.ToString().Trim();

                            if (!string.IsNullOrEmpty(realCode))
                            {
                                if (string.IsNullOrEmpty(enteredCode))
                                {
                                    ShowMessage("ERROR: This assessment requires an access code.", true);
                                    return; // Stops execution
                                }
                                if (!enteredCode.Equals(realCode, StringComparison.OrdinalIgnoreCase))
                                {
                                    ShowMessage("ERROR: Incorrect access code. Please try again.", true);
                                    return; // Stops execution
                                }
                            }

                            Response.Redirect($"TakeQuize.aspx?id={quizId}", false);
                        }
                    }
                }
                catch (Exception ex)
                {
                    ShowMessage("System error verifying passcode: " + ex.Message, true);
                }
            }
        }

        private void ShowMessage(string message, bool isError)
        {
            lblMessage.Text = message;
            // Overriding default colors for visibility on Dark Mode
            lblMessage.ForeColor = System.Drawing.ColorTranslator.FromHtml(isError ? "#ef4444" : "#10b981");
        }
    }
}