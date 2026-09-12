using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;

namespace InSchool.src.Features.Student
{
    public partial class TakeQuize : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Request.QueryString["id"] == null)
                {
                    Response.Redirect("AvailableCourses.aspx");
                    return;
                }

                int quizId;
                if (int.TryParse(Request.QueryString["id"], out quizId))
                {
                    hfQuizId.Value = quizId.ToString();
                    CheckAttemptAndLoadQuiz(quizId);
                }
            }
        }

        private void CheckAttemptAndLoadQuiz(int quizId)
        {
            try
            {
                using (MySqlConnection conn = Database.CreateOpenConnection())
                {
                    string checkQuery = "SELECT attempt_id, is_submitted, score FROM quiz_attempts WHERE quiz_id = @QuizId AND student_user_id = @StudentId";
                    using (MySqlCommand cmd = new MySqlCommand(checkQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@QuizId", quizId);
                        cmd.Parameters.AddWithValue("@StudentId", SessionManager.UserId);

                        using (MySqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                bool isSubmitted = Convert.ToBoolean(reader["is_submitted"]);
                                if (isSubmitted)
                                {
                                    ShowMessage("You have already submitted this assessment.", true);
                                    pnlExam.Visible = false;
                                    return;
                                }
                                else
                                {
                                    hfAttemptId.Value = reader["attempt_id"].ToString();
                                }
                            }
                        }
                    }

                    // --- THE FIX IS APPLIED HERE ---
                    if (string.IsNullOrEmpty(hfAttemptId.Value))
                    {
                        string insertAttempt = "INSERT INTO quiz_attempts (quiz_id, student_user_id) VALUES (@QuizId, @StudentId)";
                        using (MySqlCommand cmd = new MySqlCommand(insertAttempt, conn))
                        {
                            cmd.Parameters.AddWithValue("@QuizId", quizId);
                            cmd.Parameters.AddWithValue("@StudentId", SessionManager.UserId);
                            cmd.ExecuteNonQuery(); // Execute normally
                            hfAttemptId.Value = cmd.LastInsertedId.ToString(); // Safely retrieve the generated ID
                        }
                    }
                    // -------------------------------

                    int durationMins = 0;
                    string titleQuery = "SELECT title, duration_minutes FROM quizzes WHERE quiz_id = @QuizId";
                    using (MySqlCommand cmd = new MySqlCommand(titleQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@QuizId", quizId);
                        using (MySqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                litQuizTitle.Text = reader["title"].ToString();
                                durationMins = Convert.ToInt32(reader["duration_minutes"]);
                            }
                        }
                    }

                    ScriptManager.RegisterStartupScript(this, GetType(), "StartTimer", $"startTimer({durationMins});", true);



                    string qQuery = "SELECT question_id, question_text, option_a, option_b, option_c, option_d, correct_option FROM quiz_questions WHERE quiz_id = @QuizId";
                    using (MySqlCommand cmd = new MySqlCommand(qQuery, conn))
                    {
                        // THIS LINE WAS MISSING
                        cmd.Parameters.AddWithValue("@QuizId", quizId);

                        using (MySqlDataAdapter sda = new MySqlDataAdapter(cmd))
                        {
                            DataTable dt = new DataTable();
                            sda.Fill(dt);
                            rptQuestions.DataSource = dt;
                            rptQuestions.DataBind();
                        }
                    }








                }
            }
            catch (Exception ex)
            {
                ShowMessage("System error loading exam: " + ex.Message, true);
            }
        }

        protected void rptQuestions_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                RadioButtonList rbl = (RadioButtonList)e.Item.FindControl("rblOptions");
                DataRowView row = (DataRowView)e.Item.DataItem;

                if (rbl != null && row != null)
                {
                    rbl.Items.Add(new ListItem(row["option_a"].ToString(), "A"));
                    rbl.Items.Add(new ListItem(row["option_b"].ToString(), "B"));
                    rbl.Items.Add(new ListItem(row["option_c"].ToString(), "C"));
                    rbl.Items.Add(new ListItem(row["option_d"].ToString(), "D"));
                }
            }
        }

        protected void btnSubmitQuiz_Click(object sender, EventArgs e)
        {
            int totalQuestions = rptQuestions.Items.Count;
            int score = 0;
            int attemptId = Convert.ToInt32(hfAttemptId.Value);

            try
            {
                using (MySqlConnection conn = Database.CreateOpenConnection())
                {
                    foreach (RepeaterItem item in rptQuestions.Items)
                    {
                        if (item.ItemType == ListItemType.Item || item.ItemType == ListItemType.AlternatingItem)
                        {
                            HiddenField hfQId = (HiddenField)item.FindControl("hfQuestionId");
                            HiddenField hfCorrect = (HiddenField)item.FindControl("hfCorrectOption");
                            RadioButtonList rbl = (RadioButtonList)item.FindControl("rblOptions");
                            Label lblFeedback = (Label)item.FindControl("lblFeedback");

                            int questionId = Convert.ToInt32(hfQId.Value);
                            string correctAnswer = hfCorrect.Value;
                            string selectedAnswer = rbl.SelectedValue;

                            bool isCorrect = (!string.IsNullOrEmpty(selectedAnswer) && selectedAnswer == correctAnswer);

                            if (isCorrect) score++;

                            string ansQuery = "INSERT INTO quiz_attempt_answers (attempt_id, question_id, selected_option, is_correct) VALUES (@AttemptId, @QId, @Selected, @IsCorrect)";
                            using (MySqlCommand cmd = new MySqlCommand(ansQuery, conn))
                            {
                                cmd.Parameters.AddWithValue("@AttemptId", attemptId);
                                cmd.Parameters.AddWithValue("@QId", questionId);
                                cmd.Parameters.AddWithValue("@Selected", string.IsNullOrEmpty(selectedAnswer) ? "A" : selectedAnswer);
                                cmd.Parameters.AddWithValue("@IsCorrect", isCorrect);
                                cmd.ExecuteNonQuery();
                            }

                            rbl.Enabled = false;
                            lblFeedback.Visible = true;

                            if (isCorrect)
                            {
                                lblFeedback.Text = "✓ Correct";
                                lblFeedback.CssClass = "feedback-box feedback-correct";
                            }
                            else
                            {
                                string textAnswer = GetAnswerText(rbl, correctAnswer);
                                lblFeedback.Text = string.IsNullOrEmpty(selectedAnswer) ?
                                    $"✗ Unanswered. The correct answer was {correctAnswer} ({textAnswer})" :
                                    $"✗ Incorrect. The correct answer was {correctAnswer} ({textAnswer})";
                                lblFeedback.CssClass = "feedback-box feedback-wrong";
                            }
                        }
                    }

                    string updateQuery = "UPDATE quiz_attempts SET score = @Score, is_submitted = TRUE WHERE attempt_id = @AttemptId";
                    using (MySqlCommand cmd = new MySqlCommand(updateQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@Score", score);
                        cmd.Parameters.AddWithValue("@AttemptId", attemptId);
                        cmd.ExecuteNonQuery();
                    }
                }

                decimal percentage = totalQuestions > 0 ? ((decimal)score / totalQuestions) * 100 : 0;

                litScore.Text = $"{score} / {totalQuestions}";

                if (percentage >= 80) litGrade.Text = "<span style='color: #2e7d32;'>Grade: A (Excellent)</span>";
                else if (percentage >= 70) litGrade.Text = "<span style='color: #1976d2;'>Grade: B (Good)</span>";
                else if (percentage >= 60) litGrade.Text = "<span style='color: #fbc02d;'>Grade: C (Average)</span>";
                else if (percentage >= 50) litGrade.Text = "<span style='color: #f57c00;'>Grade: D (Pass)</span>";
                else litGrade.Text = "<span style='color: #d32f2f;'>Grade: F (Fail)</span>";

                btnSubmitQuiz.Visible = false;
                Div1.Visible = false;
                pnlResults.Visible = true;
                lblMessage.Text = "Assessment submitted successfully.";
                lblMessage.ForeColor = System.Drawing.Color.Green;
            }
            catch (Exception ex)
            {
                ShowMessage("Error grading exam: " + ex.Message, true);
            }
        }

        private string GetAnswerText(RadioButtonList rbl, string optionValue)
        {
            ListItem item = rbl.Items.FindByValue(optionValue);
            return item != null ? item.Text : "";
        }

        protected void btnReturn_Click(object sender, EventArgs e)
        {
            Response.Redirect("AvailableCourses.aspx");
        }

        private void ShowMessage(string message, bool isError)
        {
            lblMessage.Text = message;
            lblMessage.ForeColor = isError ? System.Drawing.Color.DarkRed : System.Drawing.Color.Green;
        }
    }
}