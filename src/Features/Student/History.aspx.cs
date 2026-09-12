using System;
using System.Data;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;

namespace InSchool.src.Features.Student
{
    public partial class History : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadStudentHistory();
            }
        }

        private void LoadStudentHistory()
        {
            try
            {
                using (MySqlConnection conn = Database.CreateOpenConnection())
                {
                    // Query joins attempts, quizzes, and courses, and counts total questions
                    string query = @"
                        SELECT 
                            c.course_name AS CourseName,
                            q.title AS QuizTitle,
                            qa.score AS RawScore,
                            qa.start_time AS SubmissionDate,
                            (SELECT COUNT(*) FROM quiz_questions qq WHERE qq.quiz_id = q.quiz_id) AS TotalQuestions
                        FROM quiz_attempts qa
                        JOIN quizzes q ON qa.quiz_id = q.quiz_id
                        JOIN courses c ON q.course_id = c.course_id
                        WHERE qa.student_user_id = @StudentId AND qa.is_submitted = TRUE
                        ORDER BY qa.start_time DESC";

                    using (MySqlCommand cmd = new MySqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@StudentId", SessionManager.UserId);

                        using (MySqlDataAdapter sda = new MySqlDataAdapter(cmd))
                        {
                            DataTable rawData = new DataTable();
                            sda.Fill(rawData);

                            if (rawData.Rows.Count == 0)
                            {
                                pnlHistory.Visible = false;
                                pnlEmpty.Visible = true;
                                return;
                            }

                            ProcessAndBindData(rawData);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error loading history: " + ex.Message, true);
            }
        }

        private void ProcessAndBindData(DataTable rawData)
        {
            DataTable processedData = new DataTable();
            processedData.Columns.Add("CourseName", typeof(string));
            processedData.Columns.Add("QuizTitle", typeof(string));
            processedData.Columns.Add("SubmissionDate", typeof(DateTime));
            processedData.Columns.Add("ScoreText", typeof(string));
            processedData.Columns.Add("Grade", typeof(string));

            foreach (DataRow row in rawData.Rows)
            {
                int score = Convert.ToInt32(row["RawScore"]);
                int totalQuestions = Convert.ToInt32(row["TotalQuestions"]);

                decimal percentage = totalQuestions > 0 ? ((decimal)score / totalQuestions) * 100 : 0;
                string grade = CalculateGrade(percentage);

                processedData.Rows.Add(
                    row["CourseName"].ToString(),
                    row["QuizTitle"].ToString(),
                    Convert.ToDateTime(row["SubmissionDate"]),
                    $"{score} / {totalQuestions} ({(int)percentage}%)",
                    grade
                );
            }

            gvHistory.DataSource = processedData;
            gvHistory.DataBind();

            pnlHistory.Visible = true;
            pnlEmpty.Visible = false;
        }

        private string CalculateGrade(decimal percentage)
        {
            if (percentage >= 80) return "A";
            if (percentage >= 70) return "B";
            if (percentage >= 60) return "C";
            if (percentage >= 50) return "D";
            return "F";
        }

        protected void gvHistory_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                Label lblGrade = (Label)e.Row.FindControl("lblGrade");
                if (lblGrade != null)
                {
                    string grade = lblGrade.Text;
                    lblGrade.CssClass = "grade-badge grade-" + grade;
                }
            }
        }

        protected void btnGoToCourses_Click(object sender, EventArgs e)
        {
            Response.Redirect("AvailableCourses.aspx", false);
        }

        private void ShowMessage(string message, bool isError)
        {
            lblMessage.Text = message;
            lblMessage.ForeColor = isError ? System.Drawing.Color.DarkRed : System.Drawing.Color.Green;
        }
    }
}