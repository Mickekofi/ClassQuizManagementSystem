<%@ Page Title="Available Courses" Language="C#" MasterPageFile="~/src/Features/Student/StudentActivity.Master" AutoEventWireup="true" CodeBehind="AvailableCourses.aspx.cs" Inherits="InSchool.src.Features.Student.AvailableCourses" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        /* 1. Ambient Background Effects (Matches Login Page) */
        .ambient-bg-wrapper {
            position: fixed;
            top: 0; left: 0; right: 0; bottom: 0;
            z-index: -1;
            background-color: #09090b;
            background-image: 
                radial-gradient(circle at 15% 20%, rgba(37, 99, 235, 0.12) 0%, transparent 40%), 
                radial-gradient(circle at 85% 80%, rgba(16, 185, 129, 0.10) 0%, transparent 40%);
            animation: pulseBackground 8s ease-in-out infinite alternate;
            pointer-events: none;
        }

        @keyframes pulseBackground {
            0% { opacity: 0.7; }
            100% { opacity: 1; }
        }

        /* 2. Page Header */
        .page-header {
            margin-bottom: 30px;
            border-left: 4px solid #2563eb;
            padding-left: 15px;
        }
        
        .page-title {
            color: #ffffff;
            font-size: 28px;
            font-weight: 800;
            margin: 0 0 5px 0;
            letter-spacing: 0.5px;
        }
        
        .page-subtitle {
            color: #a1a1aa;
            font-size: 15px;
            font-weight: 500;
            margin: 0;
        }

        /* 3. Professional Grid & Cards */
        .course-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 25px;
            margin-top: 20px;
        }
        
        .course-card {
            background: rgba(24, 24, 27, 0.9);
            backdrop-filter: blur(10px);
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 8px 30px rgba(0,0,0,0.5);
            border: 1px solid #27272a;
            position: relative;
            transition: all 0.3s ease;
            display: flex;
            flex-direction: column;
        }
        
        .course-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 12px 35px rgba(37, 99, 235, 0.2);
            border-color: rgba(37, 99, 235, 0.5);
        }

        /* Image Container & Full-Size Rule */
        .course-img-container {
            width: 100%;
            height: 160px;
            background-color: #05050a; /* Dark presentation theater frame */
            overflow: hidden;
            border-bottom: 1px solid #27272a;
            position: relative;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .course-img {
            width: 100%;
            height: 100%;
            object-fit: cover; /* Forces full image to show without cropping */
            padding: 5px;
            transition: transform 0.3s ease;
        }
        
        .course-card:hover .course-img {
            transform: scale(1.03);
        }

        .course-card-body {
            padding: 20px;
            display: flex;
            flex-direction: column;
            flex-grow: 1;
        }

        .course-title {
            font-size: 18px;
            font-weight: 700;
            color: #ffffff;
            margin-bottom: 5px;
        }

        .teacher-name {
            font-size: 13px;
            font-weight: 500;
            color: #a1a1aa;
            margin-bottom: 20px;
        }

        /* 4. Professional Notification Badge */
        .notification-badge {
            position: absolute;
            top: 15px;
            right: 15px;
            background: #ef4444;
            color: #ffffff;
            border-radius: 6px;
            padding: 4px 10px;
            font-size: 11px;
            font-weight: 700;
            box-shadow: 0 2px 8px rgba(239, 68, 68, 0.4);
            z-index: 10;
            letter-spacing: 0.5px;
        }

        .no-quiz {
            background: #3f3f46;
            box-shadow: none;
            color: #a1a1aa;
        }

        /* 5. Professional Action Button */
        .btn-play {
            background: #2563eb;
            color: white;
            border: none;
            padding: 12px;
            border-radius: 6px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            width: 100%;
            margin-top: auto;
            transition: all 0.2s ease;
            box-shadow: 0 2px 8px rgba(37, 99, 235, 0.3);
        }

        .btn-play:hover:not([disabled]) {
            background: #1d4ed8;
            transform: translateY(-1px);
        }
        
        .btn-play[disabled] {
            background: #27272a;
            box-shadow: none;
            cursor: not-allowed;
            color: #52525b;
            border: 1px solid #3f3f46;
        }

        /* 6. Assessment Select Panel */
        .assessment-panel {
            background: rgba(24, 24, 27, 0.95);
            backdrop-filter: blur(10px);
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 8px 30px rgba(0,0,0,0.5);
            border: 1px solid #27272a;
        }

        .btn-back {
            background: transparent;
            color: #a1a1aa;
            border: 1px solid #3f3f46;
            padding: 8px 16px;
            border-radius: 6px;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
            margin-bottom: 25px;
            transition: all 0.2s ease;
        }

        .btn-back:hover {
            background: #27272a;
            color: #ffffff;
            border-color: #52525b;
        }

        /* 7. Clean Data Grid */
        .modern-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        .modern-table th {
            color: #a1a1aa;
            font-weight: 600;
            font-size: 12px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            padding: 12px 20px;
            text-align: left;
            border-bottom: 2px solid #3f3f46;
            background: #18181b;
        }

        .modern-table td {
            padding: 16px 20px;
            background: #18181b;
            vertical-align: middle;
            color: #e4e4e7;
            font-size: 14px;
            border-bottom: 1px solid #27272a;
        }

        .modern-table tr:hover td {
            background: #27272a;
        }

        /* Passcode Input & Start Button */
        .passcode-input {
            width: 100%;
            max-width: 180px;
            padding: 10px 14px;
            border: 1px solid #3f3f46;
            border-radius: 6px;
            background-color: #09090b;
            font-size: 14px;
            color: #ffffff;
            text-align: center;
            letter-spacing: 1px;
        }

        .passcode-input:focus {
            border-color: #2563eb;
            outline: none;
            box-shadow: 0 0 0 2px rgba(37, 99, 235, 0.2);
        }
        
        .passcode-input::placeholder {
            color: #52525b;
            font-weight: 400;
        }
        
        .btn-start-assessment {
            background: #10b981;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 6px;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
            box-shadow: 0 2px 8px rgba(16, 185, 129, 0.2);
            transition: all 0.2s ease;
        }
        
        .btn-start-assessment:hover {
            background: #059669;
            transform: translateY(-1px);
        }
        
        .msg-label {
            display: block;
            margin-bottom: 20px;
            padding: 10px;
            border-radius: 6px;
            font-size: 14px;
            font-weight: 500;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    
    <!-- Atmospheric Background FX Layer -->
    <div class="ambient-bg-wrapper"></div>

    <div class="page-header">
        <h2 class="page-title">Course Catalog</h2>
        <p class="page-subtitle">Select a course to view available assessments.</p>
    </div>
    
    <asp:Label ID="lblMessage" runat="server" CssClass="msg-label"></asp:Label>

    <!-- Panel 1: The Course Grid -->
    <asp:Panel ID="pnlCourseList" runat="server">
        <div class="course-grid">
            <asp:Repeater ID="rptCourses" runat="server" OnItemCommand="rptCourses_ItemCommand">
                <ItemTemplate>
                    <div class="course-card">
                        
                        <div class='<%# Convert.ToInt32(Eval("ActiveQuizCount")) > 0 ? "notification-badge" : "notification-badge no-quiz" %>'>
                            <%# Eval("ActiveQuizCount") %> NEW
                        </div>
                        
                        <div class="course-img-container">
                            <asp:Image ID="imgCourseThumb" runat="server" 
                                ImageUrl='<%# string.IsNullOrEmpty(Eval("image_path") as string) ? "~/assets/default-course.png" : Eval("image_path") %>' 
                                CssClass="course-img" AlternateText="Course Image" />
                        </div>

                        <div class="course-card-body">
                            <div class="course-title"><%# Eval("course_name") %></div>
                            <div class="teacher-name">Instructor: <%# Eval("TeacherName") %></div>
                            
                            <asp:Button ID="btnViewQuizzes" runat="server" 
                                Text='<%# Convert.ToInt32(Eval("ActiveQuizCount")) > 0 ? "View Assessments" : "No Active Assessments" %>' 
                                CommandName="ViewCourse" 
                                CommandArgument='<%# Eval("course_id") %>' 
                                CssClass="btn-play" 
                                Enabled='<%# Convert.ToInt32(Eval("ActiveQuizCount")) > 0 %>' />
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>
    </asp:Panel>

    <!-- Panel 2: Available Quizzes for the Selected Course -->
    <asp:Panel ID="pnlQuizList" runat="server" Visible="false" CssClass="assessment-panel">
        
        <asp:Button ID="btnBack" runat="server" Text="← Back to Catalog" CssClass="btn-back" OnClick="btnBack_Click" />
        
        <h3 class="page-title" style="font-size: 20px; border-bottom: 1px solid #27272a; padding-bottom: 15px; margin-bottom: 20px;">
            Active Assessments: <span style="color: #2563eb;"><asp:Literal ID="litSelectedCourse" runat="server"></asp:Literal></span>
        </h3>
        
        <asp:GridView ID="gvQuizzes" runat="server" AutoGenerateColumns="False" CssClass="modern-table" GridLines="None" OnRowCommand="gvQuizzes_RowCommand">
            <Columns>
                <asp:BoundField DataField="title" HeaderText="Assessment Title" />
                
                <asp:TemplateField HeaderText="Duration" ItemStyle-Width="120px">
                    <ItemTemplate>
                        <span style="color: #a1a1aa; font-weight: 500;"><%# Eval("duration_minutes") %> Minutes</span>
                    </ItemTemplate>
                </asp:TemplateField>
                
                <asp:TemplateField HeaderText="Access Code" ItemStyle-Width="200px">
                    <ItemTemplate>
                        <asp:TextBox ID="txtStudentPasscode" runat="server" CssClass="passcode-input" placeholder="Enter Access Code"></asp:TextBox>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField ItemStyle-Width="150px" ItemStyle-HorizontalAlign="Right">
                    <ItemTemplate>
                        <asp:Button ID="btnStartQuiz" runat="server" Text="Begin" 
                            CommandName="StartQuiz" 
                            CommandArgument='<%# Eval("quiz_id") %>' 
                            CssClass="btn-start-assessment" />
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
    </asp:Panel>

</asp:Content>