using System;
using System.Web;

public static class SessionManager
{
    // 1. User ID (Returns 0 if not logged in)
    public static int UserId
    {
        get
        {
            if (HttpContext.Current.Session["UserId"] != null)
                return Convert.ToInt32(HttpContext.Current.Session["UserId"]);
            return 0;
        }
        set { HttpContext.Current.Session["UserId"] = value; }
    }

    // 2. Role (ADMIN, TEACHER, STUDENT)
    public static string Role
    {
        get { return HttpContext.Current.Session["Role"] as string; }
        set { HttpContext.Current.Session["Role"] = value; }
    }

    // 3. Full Name (For UI display)
    public static string FullName
    {
        get { return HttpContext.Current.Session["FullName"] as string; }
        set { HttpContext.Current.Session["FullName"] = value; }
    }

    // 4. Quick Authentication Check
    public static bool IsAuthenticated
    {
        get { return UserId > 0; }
    }

    // 5. Secure Logout
    public static void ClearSession()
    {
        HttpContext.Current.Session.Clear();
        HttpContext.Current.Session.Abandon();
    }
}