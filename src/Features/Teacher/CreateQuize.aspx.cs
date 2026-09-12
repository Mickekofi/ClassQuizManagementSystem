using System;
using System.Data;
using MySql.Data.MySqlClient;

namespace InSchool.src.Features.Teacher
{
    public partial class CreateQuize : System.Web.UI.Page
    {
        private int _assignedCourseId = 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            FetchTeacherCourse();

            if (!IsPostBack)
            {
                if (_assignedCourseId == 0)
                {
                    ShowMessage("You are not assigned to any course. You cannot create quizzes.", false);
                    pnlCreateQuiz.Visible = false;
                }
            }
        }

        private void FetchTeacherCourse()
        {
            try
            {
                using (MySqlConnection conn = Database.CreateOpenConnection())
                {
                    string query = "SELECT course_id FROM teacher_courses WHERE teacher_user_id = @UserId LIMIT 1";
                    using (MySqlCommand cmd = new MySqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserId", SessionManager.UserId);
                        object result = cmd.ExecuteScalar();
                        if (result != null)
                        {
                            _assignedCourseId = Convert.ToInt32(result);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage("System Error: " + ex.Message, false);
            }
        }

        protected void btnSaveQuiz_Click(object sender, EventArgs e)
        {
            string title = txtQuizTitle.Text.Trim();
            string accessCode = txtAccessCode.Text.Trim(); // CAPTURING THE PASSCODE
            int duration;

            if (string.IsNullOrEmpty(title) || !int.TryParse(txtDuration.Text, out duration))
            {
                ShowMessage("Please provide a valid title and numeric duration.", false);
                return;
            }

            try
            {
                using (MySqlConnection conn = Database.CreateOpenConnection())
                {
                    // INJECTING THE PASSCODE INTO THE SQL
                    string query = @"
                        INSERT INTO quizzes (course_id, creator_user_id, title, duration_minutes, status, access_code) 
                        VALUES (@CourseId, @CreatorId, @Title, @Duration, 'DRAFT', @AccessCode);
                        SELECT LAST_INSERT_ID();";

                    using (MySqlCommand cmd = new MySqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@CourseId", _assignedCourseId);
                        cmd.Parameters.AddWithValue("@CreatorId", SessionManager.UserId);
                        cmd.Parameters.AddWithValue("@Title", title);
                        cmd.Parameters.AddWithValue("@Duration", duration);

                        // If left blank, store NULL in the database
                        cmd.Parameters.AddWithValue("@AccessCode", string.IsNullOrEmpty(accessCode) ? (object)DBNull.Value : accessCode);

                        int newQuizId = Convert.ToInt32(cmd.ExecuteScalar());

                        hfCurrentQuizId.Value = newQuizId.ToString();

                        ShowMessage("Quiz Header created! Now, add your questions below.", true);
                        pnlCreateQuiz.Enabled = false;
                        pnlAddQuestions.Visible = true;

                        LoadQuestions();
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Database error: " + ex.Message, false);
            }
        }

        protected void btnAddQuestion_Click(object sender, EventArgs e)
        {
            string qText = txtQuestionText.Text.Trim();
            string optA = txtOptA.Text.Trim();
            string optB = txtOptB.Text.Trim();
            string optC = txtOptC.Text.Trim();
            string optD = txtOptD.Text.Trim();
            string correct = ddlCorrectOption.SelectedValue;
            int quizId = Convert.ToInt32(hfCurrentQuizId.Value);

            if (string.IsNullOrEmpty(qText) || string.IsNullOrEmpty(optA) || string.IsNullOrEmpty(optB))
            {
                ShowMessage("Question text and at least options A and B are required.", false);
                return;
            }

            try
            {
                using (MySqlConnection conn = Database.CreateOpenConnection())
                {
                    string query = @"
                        INSERT INTO quiz_questions (quiz_id, question_text, option_a, option_b, option_c, option_d, correct_option) 
                        VALUES (@QuizId, @QText, @OptA, @OptB, @OptC, @OptD, @Correct)";

                    using (MySqlCommand cmd = new MySqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@QuizId", quizId);
                        cmd.Parameters.AddWithValue("@QText", qText);
                        cmd.Parameters.AddWithValue("@OptA", optA);
                        cmd.Parameters.AddWithValue("@OptB", optB);
                        cmd.Parameters.AddWithValue("@OptC", optC);
                        cmd.Parameters.AddWithValue("@OptD", optD);
                        cmd.Parameters.AddWithValue("@Correct", correct);

                        cmd.ExecuteNonQuery();

                        ShowMessage("Question added successfully.", true);

                        txtQuestionText.Text = "";
                        txtOptA.Text = ""; txtOptB.Text = ""; txtOptC.Text = ""; txtOptD.Text = "";

                        LoadQuestions();
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Database error: " + ex.Message, false);
            }
        }

        protected void btnPublishQuiz_Click(object sender, EventArgs e)
        {
            int quizId = Convert.ToInt32(hfCurrentQuizId.Value);

            try
            {
                using (MySqlConnection conn = Database.CreateOpenConnection())
                {
                    string query = "UPDATE quizzes SET status = 'PUBLISHED' WHERE quiz_id = @QuizId";
                    using (MySqlCommand cmd = new MySqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@QuizId", quizId);
                        cmd.ExecuteNonQuery();

                        ShowMessage("Quiz successfully published to students!", true);

                        pnlAddQuestions.Enabled = false;
                        btnPublishQuiz.Visible = false;
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Publishing error: " + ex.Message, false);
            }
        }

        private void LoadQuestions()
        {
            int quizId = Convert.ToInt32(hfCurrentQuizId.Value);
            try
            {
                using (MySqlConnection conn = Database.CreateOpenConnection())
                {
                    string query = "SELECT question_text, correct_option FROM quiz_questions WHERE quiz_id = @QuizId";
                    using (MySqlCommand cmd = new MySqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@QuizId", quizId);
                        using (MySqlDataAdapter sda = new MySqlDataAdapter(cmd))
                        {
                            DataTable dt = new DataTable();
                            sda.Fill(dt);
                            gvQuestions.DataSource = dt;
                            gvQuestions.DataBind();
                        }
                    }
                }
            }
            catch { }
        }

        private void ShowMessage(string message, bool isSuccess)
        {
            lblMessage.Text = message;
            lblMessage.ForeColor = isSuccess ? System.Drawing.Color.Green : System.Drawing.Color.DarkRed;
        }
    }
}