using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace InSchool.src.Features.Teacher
{
    public partial class QuizeStatistics : System.Web.UI.Page
    {
        private DataTable CurrentResultsTable
        {
            get { return ViewState["CurrentResults"] as DataTable; }
            set { ViewState["CurrentResults"] = value; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadTeacherQuizzes();
            }
        }

        private void LoadTeacherQuizzes()
        {
            try
            {
                using (MySqlConnection conn = Database.CreateOpenConnection())
                {
                    // Pulls both active and closed quizzes, dynamically tagging closed ones.
                    string query = @"
                        SELECT 
                            quiz_id, 
                            CASE 
                                WHEN status = 'CLOSED' THEN CONCAT(title, ' [CLOSED]')
                                ELSE title 
                            END AS display_title
                        FROM quizzes 
                        WHERE creator_user_id = @UserId AND status IN ('PUBLISHED', 'CLOSED') 
                        ORDER BY quiz_id DESC";

                    using (MySqlCommand cmd = new MySqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserId", SessionManager.UserId);
                        using (MySqlDataReader reader = cmd.ExecuteReader())
                        {
                            ddlQuizzes.DataSource = reader;
                            ddlQuizzes.DataTextField = "display_title";
                            ddlQuizzes.DataValueField = "quiz_id";
                            ddlQuizzes.DataBind();
                            ddlQuizzes.Items.Insert(0, new ListItem("-- Select a Published or Closed Quiz --", ""));
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error loading quizzes: " + ex.Message, true);
            }
        }

        protected void ddlQuizzes_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(ddlQuizzes.SelectedValue))
            {
                pnlAnalytics.Visible = false;
                btnExportCSV.Visible = false;
                divQuizStatus.Visible = false;
                return;
            }

            // Hide the deactivate button if the quiz is already closed
            if (ddlQuizzes.SelectedItem.Text.Contains("[CLOSED]"))
            {
                divQuizStatus.Visible = false;
            }
            else
            {
                divQuizStatus.Visible = true;
            }

            LoadQuizStatistics(Convert.ToInt32(ddlQuizzes.SelectedValue));
        }

        private void LoadQuizStatistics(int quizId)
        {
            try
            {
                using (MySqlConnection conn = Database.CreateOpenConnection())
                {
                    string query = @"
                        SELECT 
                            u.full_name AS StudentName,
                            qa.score AS RawScore,
                            qa.start_time AS SubmissionTime,
                            (SELECT COUNT(*) FROM quiz_questions qq WHERE qq.quiz_id = qa.quiz_id) AS TotalQuestions
                        FROM quiz_attempts qa
                        JOIN users u ON qa.student_user_id = u.user_id
                        WHERE qa.quiz_id = @QuizId AND qa.is_submitted = TRUE
                        ORDER BY qa.score DESC, qa.start_time ASC";

                    using (MySqlCommand cmd = new MySqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@QuizId", quizId);
                        using (MySqlDataAdapter sda = new MySqlDataAdapter(cmd))
                        {
                            DataTable rawData = new DataTable();
                            sda.Fill(rawData);
                            ProcessAndBindData(rawData);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error loading statistics: " + ex.Message, true);
            }
        }

        private void ProcessAndBindData(DataTable rawData)
        {
            if (rawData.Rows.Count == 0)
            {
                ShowMessage("No students have submitted this quiz yet.", false);
                pnlAnalytics.Visible = false;
                btnExportCSV.Visible = false;
                return;
            }

            DataTable processedData = new DataTable();
            processedData.Columns.Add("Rank", typeof(int));
            processedData.Columns.Add("StudentName", typeof(string));
            processedData.Columns.Add("RawScore", typeof(string));
            processedData.Columns.Add("Percentage", typeof(decimal));
            processedData.Columns.Add("Grade", typeof(string));
            processedData.Columns.Add("SubmissionTime", typeof(DateTime));

            int rank = 1;
            decimal totalPercentage = 0;
            decimal highestPercentage = 0;

            foreach (DataRow row in rawData.Rows)
            {
                int score = Convert.ToInt32(row["RawScore"]);
                int totalQuestions = Convert.ToInt32(row["TotalQuestions"]);

                decimal percentage = totalQuestions > 0 ? ((decimal)score / totalQuestions) * 100 : 0;
                string grade = CalculateGrade(percentage);

                totalPercentage += percentage;
                if (percentage > highestPercentage) highestPercentage = percentage;

                processedData.Rows.Add(
                    rank,
                    row["StudentName"].ToString(),
                    score + " / " + totalQuestions,
                    percentage,
                    grade,
                    Convert.ToDateTime(row["SubmissionTime"])
                );

                rank++;
            }

            litTotalSubmissions.Text = rawData.Rows.Count.ToString();
            litAvgScore.Text = (totalPercentage / rawData.Rows.Count).ToString("F1") + "%";
            litHighScore.Text = highestPercentage.ToString("F1") + "%";

            CurrentResultsTable = processedData;
            gvResults.DataSource = processedData;
            gvResults.DataBind();

            pnlAnalytics.Visible = true;
            btnExportCSV.Visible = true;
            lblMessage.Text = "";
        }

        private string CalculateGrade(decimal percentage)
        {
            if (percentage >= 80) return "A";
            if (percentage >= 70) return "B";
            if (percentage >= 60) return "C";
            if (percentage >= 50) return "D";
            return "F";
        }

        protected void gvResults_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                string grade = DataBinder.Eval(e.Row.DataItem, "Grade").ToString();

                if (grade == "A")
                {
                    e.Row.CssClass = "grade-excellent";
                }
                else if (grade == "F")
                {
                    e.Row.CssClass = "grade-fail";
                }
            }
        }

        protected void btnExportCSV_Click(object sender, EventArgs e)
        {
            if (CurrentResultsTable == null || CurrentResultsTable.Rows.Count == 0) return;

            Response.Clear();
            Response.Buffer = true;
            Response.AddHeader("content-disposition", "attachment;filename=Quiz_Results_" + DateTime.Now.ToString("yyyyMMdd") + ".csv");
            Response.Charset = "";
            Response.ContentType = "application/text";

            StringBuilder sb = new StringBuilder();
            sb.AppendLine("Rank,Student Name,Score,Percentage,Grade,Submitted At");

            foreach (DataRow row in CurrentResultsTable.Rows)
            {
                sb.AppendFormat("{0},\"{1}\",\"{2}\",{3},{4},\"{5}\"\n",
                    row["Rank"],
                    row["StudentName"],
                    row["RawScore"],
                    Convert.ToDecimal(row["Percentage"]).ToString("F1"),
                    row["Grade"],
                    row["SubmissionTime"]
                );
            }

            Response.Output.Write(sb.ToString());
            Response.Flush();
            Response.End();
        }

        // --- DEACTIVATION LOGIC ---

        protected void btnDeactivateQuiz_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(ddlQuizzes.SelectedValue)) return;

            int quizId = Convert.ToInt32(ddlQuizzes.SelectedValue);

            try
            {
                using (MySqlConnection conn = Database.CreateOpenConnection())
                {
                    using (MySqlTransaction trans = conn.BeginTransaction())
                    {
                        try
                        {
                            // 1. Mark Quiz as CLOSED (Terminal state)
                            string lockQuery = "UPDATE quizzes SET status = 'CLOSED' WHERE quiz_id = @QuizId";
                            using (MySqlCommand cmdLock = new MySqlCommand(lockQuery, conn, trans))
                            {
                                cmdLock.Parameters.AddWithValue("@QuizId", quizId);
                                cmdLock.ExecuteNonQuery();
                            }

                            // 2. Find all active (unsubmitted) attempts for this quiz
                            string findActiveQuery = "SELECT attempt_id FROM quiz_attempts WHERE quiz_id = @QuizId AND is_submitted = FALSE";
                            using (MySqlCommand cmdFind = new MySqlCommand(findActiveQuery, conn, trans))
                            {
                                cmdFind.Parameters.AddWithValue("@QuizId", quizId);
                                using (MySqlDataReader reader = cmdFind.ExecuteReader())
                                {
                                    DataTable activeAttempts = new DataTable();
                                    activeAttempts.Load(reader);

                                    // Process each open attempt
                                    foreach (DataRow row in activeAttempts.Rows)
                                    {
                                        int attemptId = Convert.ToInt32(row["attempt_id"]);
                                        ForceSubmitAttempt(attemptId, conn, trans);
                                    }
                                }
                            }

                            trans.Commit();

                            ShowMessage("Quiz successfully deactivated. All active student sessions have been force-submitted and graded.", false);

                            // Refresh the UI to reflect the new CLOSED status in the dropdown
                            LoadTeacherQuizzes();
                            pnlAnalytics.Visible = false;
                            btnExportCSV.Visible = false;
                            divQuizStatus.Visible = false;
                        }
                        catch
                        {
                            trans.Rollback();
                            throw;
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage("System Error during deactivation: " + ex.Message, true);
            }
        }

        private void ForceSubmitAttempt(int attemptId, MySqlConnection conn, MySqlTransaction trans)
        {
            // Calculate score based on answers already recorded in the database
            int finalScore = 0;
            string scoreQuery = "SELECT COUNT(*) FROM quiz_attempt_answers WHERE attempt_id = @AttemptId AND is_correct = TRUE";

            using (MySqlCommand cmdScore = new MySqlCommand(scoreQuery, conn, trans))
            {
                cmdScore.Parameters.AddWithValue("@AttemptId", attemptId);
                finalScore = Convert.ToInt32(cmdScore.ExecuteScalar());
            }

            // Close the attempt and write the final score
            string closeQuery = "UPDATE quiz_attempts SET is_submitted = TRUE, score = @Score WHERE attempt_id = @AttemptId";
            using (MySqlCommand cmdClose = new MySqlCommand(closeQuery, conn, trans))
            {
                cmdClose.Parameters.AddWithValue("@Score", finalScore);
                cmdClose.Parameters.AddWithValue("@AttemptId", attemptId);
                cmdClose.ExecuteNonQuery();
            }
        }

        private void ShowMessage(string message, bool isError)
        {
            lblMessage.Text = message;
            // The Dark Mode CSS overrides standard colors, so we use inline hex codes for high contrast
            lblMessage.ForeColor = System.Drawing.ColorTranslator.FromHtml(isError ? "#ef4444" : "#10b981");
        }
    }
}