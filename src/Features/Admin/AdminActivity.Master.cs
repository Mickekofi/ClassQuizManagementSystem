using System;

namespace InSchool.src.Features.Admin
{
    public partial class AdminDashboard : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Security Gate
            if (!SessionManager.IsAuthenticated || SessionManager.Role != "ADMIN")
            {
                Response.Redirect("Login.aspx", false);
                return;
            }

            if (!IsPostBack)
            {
                // Failsafe in case FullName is null
                string name = SessionManager.FullName ?? "Administrator";
                // lblAdminName.Text = "Welcome, " + name;
            }
        }

        protected void btnDashboard_Click(object sender, EventArgs e)
        {
            Response.Redirect("AdminHome.aspx", false);
        }

        protected void btnCourses_Click(object sender, EventArgs e)
        {
            Response.Redirect("CreateCourse.aspx", false);
        }

        protected void btnCreateTeacher_Click(object sender, EventArgs e)
        {
            Response.Redirect("CreateTeacher.aspx", false);
        }

        protected void btnCreateStudent_Click(object sender, EventArgs e)
        {
            Response.Redirect("CreateStudent.aspx", false);
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            SessionManager.ClearSession();
            Response.Redirect("../../../Login.aspx", false);
        }
    }
}