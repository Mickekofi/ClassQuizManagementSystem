<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="InSchool.src.Features.Authentication.Login1" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>inSchool - System Login</title>
    
    <link href="../../../Styles.css" rel="stylesheet" type="text/css" />
    
    <style>
        /* CSS Reset & Font Setup */
        body, html {
            margin: 0;
            padding: 0;
            height: 100%;
            font-family: 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
            -webkit-font-smoothing: antialiased;
            background-color: #05050a; /* Deepest black/slate */
        }

        /* 1. Dark Gaming Background with subtle animated glowing orbs */
        .login-wrapper {
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            background-image: 
                
                
                radial-gradient(circle at 15% 20%, rgba(220, 38, 38, 0.15) 0%, transparent 40%), 
                radial-gradient(circle at 85% 80%, rgba(16, 185, 129, 0.15) 0%, transparent 40%);
            padding: 20px;
            animation: pulseBackground 8s ease-in-out infinite alternate;
        }

        @keyframes pulseBackground {
            0% { opacity: 0.8; }
            100% { opacity: 1; }
        }

        /* 2. The Animated LED Border Wrapper (Slowed down for maturity) */
        .login-box-wrapper {
            position: relative;
            padding: 2px;
            background: linear-gradient(90deg, #dc2626, #10b981, #dc2626);
            background-size: 200% 200%;
            animation: panGradient 8s linear infinite; /* Slowed from 4s to 8s */
            border-radius: 18px;
            width: 100%;
            max-width: 380px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.6), 0 0 20px rgba(220, 38, 38, 0.15);
            
            /* Entry Animation */
            transform: translateY(30px);
            opacity: 0;
            animation: slideUpFade 0.7s cubic-bezier(0.16, 1, 0.3, 1) forwards;
        }

        @keyframes slideUpFade {
            to { transform: translateY(0); opacity: 1; }
        }

        @keyframes panGradient {
            0% { background-position: 0% 50%; }
            100% { background-position: 200% 50%; }
        }

        /* 3. Dark Glassmorphism Interior */
        .login-box {
            background: rgba(9, 9, 11, 0.95);
            backdrop-filter: blur(20px);
            padding: 50px 40px;
            border-radius: 16px;
            text-align: center;
        }

        /* 4. Logo Placeholder */
        .logo-container {
            margin-bottom: 25px;
        }
        
        .sys-logo {
            width: 80px;
            height: 80px;
            object-fit: contain;
            border-radius: 12px;
            background-color: #18181b;
            padding: 10px;
            border: 1px solid #27272a;
            box-shadow: 0 4px 10px rgba(0,0,0,0.4);
        }

        /* 5. Typography */
        .login-title {
            color: #ffffff;
            font-size: 26px;
            font-weight: 900;
            margin: 0 0 5px 0;
            letter-spacing: 1px;
            text-transform: uppercase;
        }

        .login-subtitle {
            color: #a1a1aa;
            font-size: 14px;
            margin-bottom: 30px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 2px;
        }

        /* 6. Dark Mode Inputs */
        .form-group {
            margin-bottom: 22px;
            text-align: left;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-size: 11px;
            font-weight: 800;
            color: #a1a1aa;
            text-transform: uppercase;
            letter-spacing: 1.5px;
        }

        .form-control {
            width: 100%;
            padding: 14px 16px;
            box-sizing: border-box;
            border: 2px solid #27272a;
            border-radius: 8px;
            background-color: #121214;
            font-size: 15px;
            color: #ffffff;
            transition: all 0.3s ease;
        }

        .form-control:focus {
            border-color: #ef4444; /* Sharp Red focus */
            background-color: #000000;
            box-shadow: 0 0 0 3px rgba(220, 38, 38, 0.15);
            outline: none;
        }

        .form-control::placeholder {
            color: #3f3f46;
            font-weight: 600;
            letter-spacing: 1px;
        }

        /* 7. Action Button (Mature Esports Style) */
        .btn-login {
            position: relative;
            width: 100%;
            padding: 16px;
            margin-top: 15px;
            background-color: #09090b; /* Stealth dark background */
            color: #ffffff;
            border: 2px solid #ef4444; /* Sharp red border */
            border-radius: 8px;
            font-size: 14px;
            font-weight: 900;
            text-transform: uppercase;
            letter-spacing: 2px;
            cursor: pointer;
            overflow: hidden;
            z-index: 1;
            transition: color 0.3s ease, box-shadow 0.3s ease, border-color 0.3s ease;
        }

        /* The liquid sweep effect */
        .btn-login::before {
            content: '';
            position: absolute;
            top: 0; left: 0; right: 0; bottom: 0;
            background: linear-gradient(90deg, #dc2626, #10b981); /* Red to Green dash */
            z-index: -1;
            transform: scaleX(0);
            transform-origin: left;
            transition: transform 0.4s cubic-bezier(0.4, 0, 0.2, 1);
        }

        .btn-login:hover {
            border-color: transparent;
            box-shadow: 0 0 25px rgba(220, 38, 38, 0.4);
            color: #ffffff;
        }

        .btn-login:hover::before {
            transform: scaleX(1);
        }

        .btn-login:active {
            transform: scale(0.98);
        }

        /* 8. Error States */
        .error-label {
            display: block;
            background-color: rgba(220, 38, 38, 0.1);
            color: #ef4444;
            padding: 12px;
            border-radius: 6px;
            border: 1px solid #7f1d1d;
            font-size: 13px;
            font-weight: 700;
            margin-bottom: 20px;
            text-align: center;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">    
        <div class="login-wrapper">
            <div class="login-box-wrapper">
                <div class="login-box">
                    
                    <div class="logo-container">
                        <asp:Image ID="imgLogo" runat="server" ImageUrl="logo.png" AlternateText="System Logo" CssClass="sys-logo" />
                    </div>

                    <h2 class="login-title">inSchool LMS</h2>
                    <p class="login-subtitle">System Authentication</p>
                    
                    <asp:Label ID="lblError" runat="server" CssClass="error-label" Visible="false"></asp:Label>

                    <div class="form-group">
                        <label>Username</label>
                        <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" 
                                     ToolTip="Enter your assigned system username." 
                                     placeholder="ENTER USERNAME"></asp:TextBox>
                    </div>

                    <div class="form-group">
                        <label>Password</label>
                        <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" 
                                     TextMode="Password" 
                                     ToolTip="Enter your secure password." 
                                     placeholder="••••••••"></asp:TextBox>
                    </div>

                    <asp:Button ID="btnLogin" runat="server" Text="Secure Login" 
                                CssClass="btn-login" 
                                ToolTip="Click to authenticate and enter the system." 
                                OnClick="btnLogin_Click" />
                </div>
            </div>
        </div>
    </form>
</body>
</html>