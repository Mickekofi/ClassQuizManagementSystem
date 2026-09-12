using System;
using System.Web.UI;
using MySql.Data.MySqlClient;

namespace InSchool.src.Features.Authentication
{
    public partial class Login1 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Security measure: Kill existing session if they return to login
            if (!IsPostBack)
            {
                SessionManager.ClearSession();
            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            // 1. Input Validation
            string username = txtUsername.Text.Trim();
            string password = txtPassword.Text.Trim();

            if (string.IsNullOrEmpty(username) || string.IsNullOrEmpty(password))
            {
                DisplayError("Username and Password are required.");
                return;
            }

            AuthenticateSystemUser(username, password);
        }

        private void AuthenticateSystemUser(string username, string password)
        {
            try
            {
                using (MySqlConnection conn = Database.CreateOpenConnection())
                {
                    // 2. Querying the locked 7-table schema
                    string query = @"SELECT user_id, role, password_hash, full_name 
                                     FROM users 
                                     WHERE username = @Username AND account_status = 'ACTIVE'";

                    using (MySqlCommand cmd = new MySqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@Username", username);

                        using (MySqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                string storedPassword = reader["password_hash"].ToString();

                                // 3. Plain Text Comparison (Survival Mode)
                                if (password == storedPassword)
                                {
                                    // 4. Establish Session
                                    SessionManager.UserId = Convert.ToInt32(reader["user_id"]);
                                    SessionManager.Role = reader["role"].ToString();
                                    SessionManager.FullName = reader["full_name"].ToString();

                                    string userRole = SessionManager.Role;

                                    // 5. Strict Routing to Executable ASPX Pages
                                    if (userRole == "ADMIN")
                                    {
                                        Response.Redirect("~/src/Features/Admin/CreateCourse.aspx", false);
                                    }
                                    else if (userRole == "TEACHER")
                                    {
                                        // Note: Assuming your spelling of CreateQuize is exact to your file structure
                                        Response.Redirect("~/src/Features/Teacher/CreateQuize.aspx", false);
                                    }
                                    else if (userRole == "STUDENT")
                                    {
                                        Response.Redirect("~/src/Features/Student/AvailableCourses.aspx", false);
                                    }
                                    else
                                    {
                                        DisplayError("System error: Unrecognized role assignment.");
                                    }
                                }
                                else
                                {
                                    DisplayError("Authentication failed: Incorrect password.");
                                }
                            }
                            else
                            {
                                DisplayError("Authentication failed: User not found or inactive.");
                            }
                        }
                    }
                }
            }
            catch (MySqlException)
            {
                DisplayError("Database connectivity failed. Ensure your MySQL server is running.");
            }
            catch (Exception ex)
            {
                DisplayError("A system error occurred: " + ex.Message);
            }
        }

        private void DisplayError(string message)
        {
            // Assumes you have an asp:Label named lblError in your ASPX markup
            lblError.Text = message;
            lblError.Visible = true;
        }
    }
}