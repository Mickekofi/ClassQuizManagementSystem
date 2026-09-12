using System;
using System.Data;
using MySql.Data.MySqlClient;
using System.Web.UI.WebControls;

namespace InSchool.src.Features.Admin
{
    public partial class CreateTeacher : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadDropdowns();
                LoadAssignments();
            }
        }

        private void LoadDropdowns()
        {
            try
            {
                using (MySqlConnection conn = Database.CreateOpenConnection())
                {
                    // Load Teachers
                    using (MySqlCommand cmd = new MySqlCommand("SELECT user_id, full_name FROM users WHERE role = 'TEACHER' ORDER BY full_name", conn))
                    {
                        using (MySqlDataReader reader = cmd.ExecuteReader())
                        {
                            ddlTeachers.DataSource = reader;
                            ddlTeachers.DataTextField = "full_name";
                            ddlTeachers.DataValueField = "user_id";
                            ddlTeachers.DataBind();
                            ddlTeachers.Items.Insert(0, new ListItem("-- Select Teacher --", ""));
                        }
                    }

                    // Load Courses
                    using (MySqlCommand cmd = new MySqlCommand("SELECT course_id, course_name FROM courses ORDER BY course_name", conn))
                    {
                        using (MySqlDataReader reader = cmd.ExecuteReader())
                        {
                            ddlCourses.DataSource = reader;
                            ddlCourses.DataTextField = "course_name";
                            ddlCourses.DataValueField = "course_id";
                            ddlCourses.DataBind();
                            ddlCourses.Items.Insert(0, new ListItem("-- Select Course --", ""));
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error loading data: " + ex.Message, false);
            }
        }

        private void LoadAssignments()
        {
            try
            {
                using (MySqlConnection conn = Database.CreateOpenConnection())
                {
                    string query = @"
                        SELECT u.full_name AS TeacherName, c.course_name AS CourseName, tc.assigned_at AS AssignedDate 
                        FROM teacher_courses tc
                        JOIN users u ON tc.teacher_user_id = u.user_id
                        JOIN courses c ON tc.course_id = c.course_id
                        ORDER BY u.full_name, c.course_name";

                    using (MySqlCommand cmd = new MySqlCommand(query, conn))
                    {
                        using (MySqlDataAdapter sda = new MySqlDataAdapter(cmd))
                        {
                            DataTable dt = new DataTable();
                            sda.Fill(dt);
                            gvAssignments.DataSource = dt;
                            gvAssignments.DataBind();
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error loading assignments: " + ex.Message, false);
            }
        }

        protected void btnSaveTeacher_Click(object sender, EventArgs e)
        {
            string fullName = txtFullName.Text.Trim();
            string username = txtUsername.Text.Trim();
            string password = txtPassword.Text.Trim();

            if (string.IsNullOrEmpty(fullName) || string.IsNullOrEmpty(username) || string.IsNullOrEmpty(password))
            {
                ShowMessage("All fields are required to create a teacher.", false);
                return;
            }

            try
            {
                using (MySqlConnection conn = Database.CreateOpenConnection())
                {
                    // Remember: We bypassed the hash for this sprint. If you re-enabled it, wrap 'password' in your SecurityHelper.
                    string query = "INSERT INTO users (username, password_hash, role, full_name) VALUES (@Username, @Password, 'TEACHER', @FullName)";
                    using (MySqlCommand cmd = new MySqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@Username", username);
                        cmd.Parameters.AddWithValue("@Password", password);
                        cmd.Parameters.AddWithValue("@FullName", fullName);
                        cmd.ExecuteNonQuery();

                        ShowMessage("Teacher account created successfully.", true);
                        txtFullName.Text = "";
                        txtUsername.Text = "";

                        // Refresh the dropdowns so the new teacher appears
                        LoadDropdowns();
                    }
                }
            }
            catch (MySqlException ex)
            {
                if (ex.Number == 1062) ShowMessage("Error: That username is already taken.", false);
                else ShowMessage("Database error: " + ex.Message, false);
            }
            catch (Exception ex)
            {
                ShowMessage("System error: " + ex.Message, false);
            }
        }

        protected void btnAssignCourse_Click(object sender, EventArgs e)
        {
            string teacherId = ddlTeachers.SelectedValue;
            string courseId = ddlCourses.SelectedValue;

            if (string.IsNullOrEmpty(teacherId) || string.IsNullOrEmpty(courseId))
            {
                ShowMessage("Please select both a Teacher and a Course to assign.", false);
                return;
            }

            try
            {
                using (MySqlConnection conn = Database.CreateOpenConnection())
                {
                    string query = "INSERT INTO teacher_courses (teacher_user_id, course_id) VALUES (@TeacherId, @CourseId)";
                    using (MySqlCommand cmd = new MySqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@TeacherId", teacherId);
                        cmd.Parameters.AddWithValue("@CourseId", courseId);
                        cmd.ExecuteNonQuery();

                        ShowMessage("Course assigned to teacher successfully.", true);
                        LoadAssignments(); // Refresh the grid
                    }
                }
            }
            catch (MySqlException ex)
            {
                if (ex.Number == 1062) ShowMessage("Error: This teacher is already assigned to this course.", false);
                else ShowMessage("Database error: " + ex.Message, false);
            }
        }

        private void ShowMessage(string message, bool isSuccess)
        {
            lblMessage.Text = message;
            lblMessage.ForeColor = isSuccess ? System.Drawing.Color.Green : System.Drawing.Color.DarkRed;
        }
    }
}