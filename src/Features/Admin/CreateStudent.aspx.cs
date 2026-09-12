using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace InSchool.src.Features.Admin
{
    public partial class CreateStudent : System.Web.UI.Page
    {
        // Keeps track of the index numbers we just uploaded so we can highlight them
        private List<string> NewlyInsertedIndexes
        {
            get
            {
                if (ViewState["NewIndexes"] == null) return new List<string>();
                return (List<string>)ViewState["NewIndexes"];
            }
            set { ViewState["NewIndexes"] = value; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadStudents();
            }
        }

        private void LoadStudents()
        {
            try
            {
                using (MySqlConnection conn = Database.CreateOpenConnection())
                {
                    string query = "SELECT user_id, username, full_name, account_status FROM users WHERE role = 'STUDENT' ORDER BY user_id DESC";
                    using (MySqlCommand cmd = new MySqlCommand(query, conn))
                    {
                        using (MySqlDataAdapter sda = new MySqlDataAdapter(cmd))
                        {
                            DataTable dt = new DataTable();
                            sda.Fill(dt);
                            dgvApplicants.DataSource = dt;
                            dgvApplicants.DataBind();
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error loading students: " + ex.Message, true);
            }
        }

        protected void btnUpload_Click(object sender, EventArgs e)
        {
            if (!fileUpload.HasFile)
            {
                ShowMessage("Please select a file to upload.", true);
                return;
            }

            string extension = Path.GetExtension(fileUpload.FileName).ToLower();
            if (extension != ".csv")
            {
                ShowMessage("Invalid file format. Please upload a .csv file.", true);
                return;
            }

            lblFilePath.Text = "Last uploaded: " + fileUpload.FileName;
            List<string> successfulInserts = new List<string>();
            int duplicateCount = 0;
            int errorCount = 0;

            try
            {
                using (MySqlConnection conn = Database.CreateOpenConnection())
                {
                    using (StreamReader sr = new StreamReader(fileUpload.PostedFile.InputStream))
                    {
                        string line;
                        while ((line = sr.ReadLine()) != null)
                        {
                            if (string.IsNullOrWhiteSpace(line)) continue;

                            string[] columns = line.Split(',');

                            // Now expecting only 2 columns: Index, Name
                            if (columns.Length >= 2)
                            {
                                string indexNumber = columns[0].Trim();
                                string fullName = columns[1].Trim();

                                // SYSTEM GENERATED DEFAULT PASSWORD
                                string defaultPassword = "1234";

                                if (string.IsNullOrEmpty(indexNumber) || string.IsNullOrEmpty(fullName)) continue;

                                try
                                {
                                    string query = "INSERT INTO users (username, full_name, password_hash, role) VALUES (@Username, @FullName, @Password, 'STUDENT')";
                                    using (MySqlCommand cmd = new MySqlCommand(query, conn))
                                    {
                                        cmd.Parameters.AddWithValue("@Username", indexNumber);
                                        cmd.Parameters.AddWithValue("@FullName", fullName);
                                        cmd.Parameters.AddWithValue("@Password", defaultPassword);

                                        cmd.ExecuteNonQuery();
                                        successfulInserts.Add(indexNumber);
                                    }
                                }
                                catch (MySqlException sqlEx)
                                {
                                    if (sqlEx.Number == 1062) duplicateCount++;
                                    else errorCount++;
                                }
                            }
                        }
                    }
                }

                NewlyInsertedIndexes = successfulInserts;

                ShowMessage($"Upload complete. Successfully added {successfulInserts.Count} students with default password '1234'. Duplicates skipped: {duplicateCount}. Errors: {errorCount}.", false);

                LoadStudents();
            }
            catch (Exception ex)
            {
                ShowMessage("System error processing file: " + ex.Message, true);
            }
        }

        protected void dgvApplicants_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                // Grab the username (Index Number) from the first column
                string indexNumber = DataBinder.Eval(e.Row.DataItem, "username").ToString();

                // If this index number was part of the recent upload, paint the row green
                if (NewlyInsertedIndexes.Contains(indexNumber))
                {
                    e.Row.CssClass = "new-row";
                }
            }
        }

        protected void dgvApplicants_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            try
            {
                // Retrieve the user_id from the DataKeyNames property
                int userId = Convert.ToInt32(dgvApplicants.DataKeys[e.RowIndex].Value);

                using (MySqlConnection conn = Database.CreateOpenConnection())
                {
                    string query = "DELETE FROM users WHERE user_id = @UserId AND role = 'STUDENT'";
                    using (MySqlCommand cmd = new MySqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserId", userId);
                        cmd.ExecuteNonQuery();
                    }
                }

                ShowMessage("Student record deleted successfully.", false);

                // Clear the highlight list so rows don't stay green after a delete postback
                NewlyInsertedIndexes = new List<string>();

                LoadStudents();
            }
            catch (Exception ex)
            {
                ShowMessage("Error deleting student: " + ex.Message, true);
            }
        }

        private void ShowMessage(string message, bool isError)
        {
            lblMessage.Text = message;
            lblMessage.ForeColor = isError ? System.Drawing.Color.DarkRed : System.Drawing.Color.Green;
        }
    }
}