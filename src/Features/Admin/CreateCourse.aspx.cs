using System;
using System.Data;
using System.IO;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;

namespace InSchool.src.Features.Admin
{
    public partial class CreateCourse : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadCourses();
            }
        }

        private void LoadCourses()
        {
            try
            {
                using (MySqlConnection conn = Database.CreateOpenConnection())
                {
                    string query = "SELECT course_id, course_name, image_path FROM courses ORDER BY course_id DESC";
                    using (MySqlCommand cmd = new MySqlCommand(query, conn))
                    {
                        using (MySqlDataAdapter sda = new MySqlDataAdapter(cmd))
                        {
                            DataTable dt = new DataTable();
                            sda.Fill(dt);
                            gvCourses.DataSource = dt;
                            gvCourses.DataBind();
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error loading courses: " + ex.Message, true);
            }
        }

        protected void btnSaveCourse_Click(object sender, EventArgs e)
        {
            string courseName = txtCourseName.Text.Trim();
            if (string.IsNullOrEmpty(courseName))
            {
                ShowMessage("Course Name is required.", true);
                return;
            }

            string imagePath = null;

            // Handle Image Upload
            if (fuCourseImage.HasFile)
            {
                try
                {
                    string fileExtension = Path.GetExtension(fuCourseImage.FileName).ToLower();
                    if (fileExtension != ".jpg" && fileExtension != ".jpeg" && fileExtension != ".png")
                    {
                        ShowMessage("Only JPG and PNG images are allowed.", true);
                        return;
                    }

                    // Create a unique file name to prevent overwriting
                    string uniqueFileName = Guid.NewGuid().ToString() + fileExtension;

                    // Define the physical save path and the relative DB path
                    string saveDir = Server.MapPath("~/src/Features/Assets/Uploads/Courses/");

                    // Ensure directory exists
                    if (!Directory.Exists(saveDir))
                    {
                        Directory.CreateDirectory(saveDir);
                    }

                    string physicalPath = Path.Combine(saveDir, uniqueFileName);
                    fuCourseImage.SaveAs(physicalPath);

                    imagePath = "~/src/Features/Assets/Uploads/Courses/" + uniqueFileName;
                }
                catch (Exception ex)
                {
                    ShowMessage("Error uploading image: " + ex.Message, true);
                    return;
                }
            }

            // Database Insertion
            try
            {
                using (MySqlConnection conn = Database.CreateOpenConnection())
                {
                    string query = "INSERT INTO courses (course_name, image_path) VALUES (@CourseName, @ImagePath)";
                    using (MySqlCommand cmd = new MySqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@CourseName", courseName);
                        cmd.Parameters.AddWithValue("@ImagePath", (object)imagePath ?? DBNull.Value);
                        cmd.ExecuteNonQuery();
                    }
                }

                txtCourseName.Text = "";
                ShowMessage("Course successfully created.", false);
                LoadCourses();
            }
            catch (MySqlException sqlEx)
            {
                if (sqlEx.Number == 1062) // Duplicate entry
                {
                    ShowMessage("A course with this name already exists.", true);
                }
                else
                {
                    ShowMessage("Database error: " + sqlEx.Message, true);
                }
            }
            catch (Exception ex)
            {
                ShowMessage("System error: " + ex.Message, true);
            }
        }

        private void ShowMessage(string message, bool isError)
        {
            lblMessage.Text = message;
            lblMessage.ForeColor = isError ? System.Drawing.Color.DarkRed : System.Drawing.Color.Green;
        }
    }
}