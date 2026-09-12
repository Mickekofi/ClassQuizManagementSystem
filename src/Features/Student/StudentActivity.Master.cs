using System;

namespace InSchool.src.Features.Student
{
    public partial class StudentActivity : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // 1. THE SECURITY GATE
            if (!SessionManager.IsAuthenticated || SessionManager.Role != "STUDENT")
            {
                Response.Redirect("../../../Login.aspx", false);
                return;
            }

            // 2. Load UI Elements
            if (!IsPostBack)
            {
                lblStudentName.Text = SessionManager.FullName;
            }
        }

        protected void btnCourses_Click(object sender, EventArgs e)
        {
            Response.Redirect("AvailableCourses.aspx", false);
        }

        protected void btnHistory_Click(object sender, EventArgs e)
        {
            Response.Redirect("History.aspx", false);
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            SessionManager.ClearSession();
            Response.Redirect("../../../Login.aspx", false);
        }
    }
}