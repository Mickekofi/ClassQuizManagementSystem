using System;
using MySql.Data.MySqlClient;

namespace InSchool.src.Features.Teacher
{
    public partial class TeacherDashboard : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // 1. THE SECURITY GATE
            if (!SessionManager.IsAuthenticated || SessionManager.Role != "TEACHER")
            {
                Response.Redirect("~/src/Features/Authentication/Login.aspx", false);
                return;
            }

            // 2. Load UI Elements
            if (!IsPostBack)
            {
                lblTeacherName.Text = SessionManager.FullName;
                LoadTeacherSubject();
            }
        }

        private void LoadTeacherSubject()
        {
            string subjectName = "Unassigned";

            try
            {
                using (MySqlConnection conn = Database.CreateOpenConnection())
                {
                    // Query to find the course assigned to this specific teacher
                    string query = @"
                        SELECT c.course_name 
                        FROM teacher_courses tc
                        JOIN courses c ON tc.course_id = c.course_id
                        WHERE tc.teacher_user_id = @UserId
                        LIMIT 1";

                    using (MySqlCommand cmd = new MySqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserId", SessionManager.UserId);

                        object result = cmd.ExecuteScalar();
                        if (result != null)
                        {
                            subjectName = result.ToString();
                        }
                    }
                }
            }
            catch (Exception)
            {
                // Fail silently on the UI, but fallback to "Error loading subject"
                subjectName = "Subject Data Unavailable";
            }

            lblTeacherSubject.Text = "Subject: " + subjectName;
        }

        // --- Navigation Routing ---

        protected void btnCreateQuiz_Click(object sender, EventArgs e)
        {
            Response.Redirect("CreateQuize.aspx", false);
        }

        protected void btnGrades_Click(object sender, EventArgs e) 
        {
            Response.Redirect("QuizeStatistics.aspx", false);
        }


        protected void btnLogout_Click(object sender, EventArgs e)
        {
            SessionManager.ClearSession();
            Response.Redirect("../../../Login.aspx", false);
        }
    }
}