<%@ Page Title="Manage Teachers" Language="C#" MasterPageFile="~/src/Features/Admin/AdminActivity.master" AutoEventWireup="true" CodeBehind="CreateTeacher.aspx.cs" Inherits="InSchool.src.Features.Admin.CreateTeacher" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        /* 1. Page Header (Gaming Style) */
        .page-header {
            margin-bottom: 30px;
            border-left: 5px solid;
            border-image: linear-gradient(to bottom, #dc2626, #fbbf24, #10b981) 1;
            padding-left: 15px;
        }
        
        .page-title {
            color: #ffffff;
            font-size: 28px;
            font-weight: 900;
            margin: 0 0 5px 0;
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        
        .page-subtitle {
            color: #a1a1aa;
            font-size: 15px;
            font-weight: 600;
            margin: 0;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        /* 2. Layout Grid for Forms */
        .forms-layout {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(350px, 1fr));
            gap: 30px;
            margin-bottom: 40px;
        }

        /* 3. Obsidian Glass Cards */
        .glass-card {
            background: rgba(9, 9, 11, 0.85); /* Dark obsidian */
            backdrop-filter: blur(10px);
            border-radius: 16px;
            padding: 35px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.5);
            border: 1px solid #27272a;
            transition: all 0.3s cubic-bezier(0.25, 0.8, 0.25, 1);
            display: flex;
            flex-direction: column;
        }

        .glass-card:hover {
            box-shadow: 0 15px 35px rgba(220, 38, 38, 0.15); /* Red subtle glow */
            border-color: rgba(220, 38, 38, 0.3);
        }

        .card-header {
            margin-top: 0;
            color: #ffffff;
            font-size: 18px;
            font-weight: 800;
            border-bottom: 2px solid #27272a;
            padding-bottom: 15px;
            margin-bottom: 25px;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        /* 4. Form Typography & Inputs */
        .form-group {
            margin-bottom: 22px;
        }

        .form-label {
            display: block;
            font-size: 12px;
            font-weight: 800;
            color: #d4d4d8;
            text-transform: uppercase;
            letter-spacing: 1.5px;
            margin-bottom: 8px;
        }

        .form-control-modern {
            width: 100%;
            padding: 14px 16px;
            border: 2px solid #27272a;
            border-radius: 8px;
            background-color: #121214;
            font-size: 15px;
            color: #ffffff;
            transition: all 0.3s ease;
            box-sizing: border-box;
        }

        .form-control-modern:focus {
            border-color: #fbbf24; /* Gold focus */
            background-color: #000000;
            box-shadow: 0 0 0 3px rgba(251, 191, 36, 0.15);
            outline: none;
        }

        .form-control-modern::placeholder {
            color: #52525b;
            font-weight: 600;
            letter-spacing: 1px;
        }

        /* Customizing the Dropdown Arrow for Dark Mode */
        select.form-control-modern {
            appearance: none;
            background-image: url("data:image/svg+xml;charset=UTF-8,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='%23a1a1aa' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3e%3cpolyline points='6 9 12 15 18 9'%3e%3c/polyline%3e%3c/svg%3e");
            background-repeat: no-repeat;
            background-position: right 1rem center;
            background-size: 1em;
            padding-right: 40px;
        }
        
        select.form-control-modern option {
            background-color: #18181b;
            color: #ffffff;
        }

        /* 5. Action Buttons */
        .btn-primary-action {
            background: linear-gradient(90deg, #dc2626, #fbbf24, #10b981, #fbbf24, #dc2626);
            background-size: 300% 300%;
            animation: panGradient 4s linear infinite;
            color: white;
            text-shadow: 1px 1px 2px rgba(0,0,0,0.5);
            border: none;
            padding: 14px 24px;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 900;
            text-transform: uppercase;
            letter-spacing: 1px;
            cursor: pointer;
            transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
            box-shadow: 0 4px 12px rgba(251, 191, 36, 0.2);
            width: 100%;
            margin-top: auto; 
        }

        .btn-primary-action:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(251, 191, 36, 0.4);
            filter: brightness(1.1);
        }

        @keyframes panGradient {
            0% { background-position: 0% 50%; }
            100% { background-position: 100% 50%; }
        }

        .btn-secondary-action {
            background: #18181b;
            color: #ffffff;
            border: 2px solid #27272a;
            padding: 14px 24px;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 900;
            text-transform: uppercase;
            letter-spacing: 1px;
            cursor: pointer;
            transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
            width: 100%;
            margin-top: auto;
        }

        .btn-secondary-action:hover {
            border-color: #10b981; /* Green hover for Assign */
            box-shadow: 0 0 15px rgba(16, 185, 129, 0.2);
            transform: translateY(-2px);
        }

        /* 6. The Gaming Data Grid */
        .modern-table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0 8px;
            margin-top: 10px;
        }

        .modern-table th {
            color: #a1a1aa;
            font-weight: 800;
            text-transform: uppercase;
            font-size: 12px;
            letter-spacing: 1px;
            padding: 10px 20px;
            text-align: left;
            border: none;
        }

        .modern-table td {
            padding: 16px 20px;
            background: #18181b;
            vertical-align: middle;
            color: #f4f4f5;
            font-size: 15px;
            font-weight: 600;
            border-top: 1px solid #27272a;
            border-bottom: 1px solid #27272a;
            transition: background 0.2s ease;
        }
        
        .modern-table td:first-child {
            border-left: 1px solid #27272a;
            border-radius: 8px 0 0 8px;
            border-left: 4px solid #10b981; /* Green accent on row start */
        }
        
        .modern-table td:last-child {
            border-right: 1px solid #27272a;
            border-radius: 0 8px 8px 0;
        }

        .modern-table tr:hover td {
            background: #27272a;
        }
        
        /* Badges for assignments (Gaming Style) */
        .badge {
            background-color: #000000;
            color: #fbbf24; /* Glowing gold */
            padding: 6px 12px;
            border-radius: 6px;
            font-size: 12px;
            font-weight: 900;
            border: 1px solid rgba(251, 191, 36, 0.3);
            display: inline-block;
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        
        .msg-label {
            display: block;
            margin-bottom: 25px;
            padding: 10px;
            border-radius: 6px;
            font-size: 14px;
            font-weight: bold;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    
    <div class="page-header">
        <h2 class="page-title">Manage Teachers & Assignments</h2>
        <p class="page-subtitle">Create instructor profiles and assign them to active courses.</p>
    </div>
    
    <asp:Label ID="lblMessage" runat="server" CssClass="msg-label"></asp:Label>

    <div class="forms-layout">
        
        <!-- Section 1: Create Teacher Account -->
        <div class="glass-card">
            <h3 class="card-header">1. Initialize Teacher Record</h3>
            
            <div class="form-group">
                <label class="form-label">Full Name</label>
                <asp:TextBox ID="txtFullName" runat="server" CssClass="form-control-modern" placeholder="E.G. MR. MENSAH"></asp:TextBox>
            </div>

            <div class="form-group">
                <label class="form-label">Username</label>
                <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control-modern" placeholder="E.G. MENSAH_TEACH"></asp:TextBox>
            </div>

            <div class="form-group" style="margin-bottom: 30px;">
                <label class="form-label">Initial Password</label>
                <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control-modern" TextMode="Password" placeholder="••••••••"></asp:TextBox>
            </div>

            <asp:Button ID="btnSaveTeacher" runat="server" Text="Create Profile" CssClass="btn-primary-action" OnClick="btnSaveTeacher_Click" />
        </div>

        <!-- Section 2: Assign Course -->
        <div class="glass-card">
            <h3 class="card-header">2. Assign to Course Matrix</h3>
            
            <div class="form-group">
                <label class="form-label">Select Teacher</label>
                <asp:DropDownList ID="ddlTeachers" runat="server" CssClass="form-control-modern"></asp:DropDownList>
            </div>

            <div class="form-group" style="margin-bottom: 30px;">
                <label class="form-label">Select Course</label>
                <asp:DropDownList ID="ddlCourses" runat="server" CssClass="form-control-modern"></asp:DropDownList>
            </div>

            <asp:Button ID="btnAssignCourse" runat="server" Text="Confirm Assignment" CssClass="btn-secondary-action" OnClick="btnAssignCourse_Click" />
        </div>

    </div>

    <!-- Active Assignments Grid -->
    <div class="glass-card" style="padding: 30px 40px;">
        <h3 class="card-header" style="border:none; margin-bottom:0; padding-bottom:5px;">Active Teaching Roster</h3>
        
        <asp:GridView ID="gvAssignments" runat="server" AutoGenerateColumns="False" CssClass="modern-table" GridLines="None">
            <Columns>
                <asp:BoundField DataField="TeacherName" HeaderText="Teacher Name" />
                
                <asp:TemplateField HeaderText="Assigned Course">
                    <ItemTemplate>
                        <span class="badge"><%# Eval("CourseName") %></span>
                    </ItemTemplate>
                </asp:TemplateField>
                
                <asp:BoundField DataField="AssignedDate" HeaderText="Date Assigned" DataFormatString="{0:MMM dd, yyyy}" />
            </Columns>
        </asp:GridView>
    </div>

</asp:Content>