<%@ Page Title="Manage Courses" Language="C#" MasterPageFile="~/src/Features/Admin/AdminActivity.master" AutoEventWireup="true" CodeBehind="CreateCourse.aspx.cs" Inherits="InSchool.src.Features.Admin.CreateCourse" %>

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

        /* 2. Obsidian Glass Cards */
        .glass-card {
            background: rgba(9, 9, 11, 0.85); /* Dark obsidian */
            backdrop-filter: blur(10px);
            border-radius: 16px;
            padding: 35px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.5);
            border: 1px solid #27272a;
            margin-bottom: 40px;
            transition: all 0.3s cubic-bezier(0.25, 0.8, 0.25, 1);
        }

        .glass-card:hover {
            box-shadow: 0 15px 35px rgba(220, 38, 38, 0.15); /* Red subtle glow */
            border-color: rgba(220, 38, 38, 0.3);
        }

        /* 3. Form Typography & Inputs */
        .form-group {
            margin-bottom: 25px;
        }

        .form-label {
            display: block;
            font-size: 12px;
            font-weight: 800;
            color: #d4d4d8;
            text-transform: uppercase;
            letter-spacing: 1.5px;
            margin-bottom: 10px;
        }

        .form-control-modern {
            width: 100%;
            max-width: 500px;
            padding: 14px 18px;
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

        /* Modernized Dark File Upload */
        .file-upload-modern {
            width: 100%;
            max-width: 500px;
            padding: 12px;
            background-color: #121214;
            border: 2px dashed #3f3f46;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.3s ease;
            box-sizing: border-box;
            color: #a1a1aa;
        }
        
        .file-upload-modern:hover {
            border-color: #10b981; /* Green hover for upload */
            background-color: #052e16;
            color: #ffffff;
        }

        /* 4. Action Button (Animated R-G-G Gaming Flow) */
        .btn-primary-action {
            background: linear-gradient(90deg, #dc2626, #fbbf24, #10b981, #fbbf24, #dc2626);
            background-size: 300% 300%;
            animation: panGradient 4s linear infinite;
            color: white;
            text-shadow: 1px 1px 2px rgba(0,0,0,0.5);
            border: none;
            padding: 14px 32px;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 900;
            text-transform: uppercase;
            letter-spacing: 1px;
            cursor: pointer;
            transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
            box-shadow: 0 4px 12px rgba(251, 191, 36, 0.2);
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

        /* 5. The Gaming Data Grid */
        .section-title {
            color: #ffffff;
            font-size: 20px;
            font-weight: 800;
            margin-bottom: 20px;
            border-bottom: 2px solid #27272a;
            padding-bottom: 10px;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .modern-table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0 8px; /* Distinct row separation */
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
            padding: 12px 20px;
            background: #18181b;
            vertical-align: middle;
            color: #f4f4f5;
            font-size: 15px;
            font-weight: 600;
            border-top: 1px solid #27272a;
            border-bottom: 1px solid #27272a;
            transition: background 0.2s ease;
        }

        /* Rounded corners for separated rows */
        .modern-table td:first-child {
            border-left: 1px solid #27272a;
            border-radius: 8px 0 0 8px;
            border-left: 4px solid #dc2626; /* Red accent on row start */
        }
        
        .modern-table td:last-child {
            border-right: 1px solid #27272a;
            border-radius: 0 8px 8px 0;
        }

        .modern-table tr:hover td {
            background: #27272a;
        }

        /* 6. Course Thumbnail Polishing */
        .modern-thumbnail {
            width: 55px;
            height: 55px;
            object-fit: cover;
            background-color: #000000;
            border-radius: 8px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.5);
            border: 2px solid #3f3f46;
            transition: transform 0.3s ease, border-color 0.3s ease;
        }

        .modern-table tr:hover .modern-thumbnail {
            transform: scale(1.1);
            border-color: #fbbf24; /* Illuminates gold on hover */
        }
        
        /* Message Label styling */
        .msg-label {
            display: block;
            margin-bottom: 20px;
            padding: 10px;
            border-radius: 6px;
            font-size: 14px;
            font-weight: bold;
        }
    </style>
</head>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    
    <div class="page-header">
        <h2 class="page-title">Manage Courses</h2>
        <p class="page-subtitle">Configure Curriculum Framework</p>
    </div>
    
    <asp:Label ID="lblMessage" runat="server" CssClass="msg-label"></asp:Label>

    <!-- Premium Course Creation Form Card -->
    <div class="glass-card">
        
        <div class="form-group">
            <label class="form-label">Course Designation</label>
            <asp:TextBox ID="txtCourseName" runat="server" CssClass="form-control-modern" placeholder="E.G. CORE MATHEMATICS"></asp:TextBox>
        </div>

        <div class="form-group">
            <label class="form-label">Course Thumbnail Image (Optional)</label>
            <asp:FileUpload ID="fuCourseImage" runat="server" accept="image/png, image/jpeg, image/jpg" CssClass="file-upload-modern" />
        </div>

        <div style="margin-top: 30px;">
            <asp:Button ID="btnSaveCourse" runat="server" Text="Create Course" CssClass="btn-primary-action" OnClick="btnSaveCourse_Click" />
        </div>
        
    </div>

    <!-- Premium Data Grid Display -->
    <div class="glass-card" style="padding: 30px 40px;">
        <h3 class="section-title">Active Course Catalog</h3>
        
        <asp:GridView ID="gvCourses" runat="server" AutoGenerateColumns="False" CssClass="modern-table" GridLines="None">
            <Columns>
                <asp:BoundField DataField="course_id" HeaderText="ID" ItemStyle-Width="80px" />
                
                <asp:TemplateField HeaderText="Cover Art" ItemStyle-Width="120px">
                    <ItemTemplate>
                        <asp:Image ID="imgCourse" runat="server" 
                            ImageUrl='<%# string.IsNullOrEmpty(Eval("image_path").ToString()) ? "~/assets/default-course.png" : Eval("image_path") %>' 
                            CssClass="modern-thumbnail" />
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:BoundField DataField="course_name" HeaderText="Course Designation" />
            </Columns>
        </asp:GridView>
    </div>

</asp:Content>