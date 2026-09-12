<%@ Page Title="Create Quiz" Language="C#" MasterPageFile="~/src/Features/Teacher/TeacherActivity.master" AutoEventWireup="true" CodeBehind="CreateQuize.aspx.cs" Inherits="InSchool.src.Features.Teacher.CreateQuize" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        /* 1. Page Header */
        .page-header {
            margin-bottom: 30px;
            border-left: 5px solid;
            border-image: linear-gradient(to bottom, #dc2626, #fbbf24, #10b981) 1;
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

        /* 2. Obsidian Glass Cards */
        .glass-card {
            background: rgba(9, 9, 11, 0.85);
            backdrop-filter: blur(10px);
            border-radius: 12px;
            padding: 35px;
            box-shadow: 0 8px 30px rgba(0, 0, 0, 0.4);
            border: 1px solid #27272a;
            margin-bottom: 40px;
            transition: all 0.3s ease;
        }

        .glass-card:hover {
            border-color: rgba(16, 185, 129, 0.4); /* Professional green subtle border */
        }

        .card-header {
            margin-top: 0;
            color: #ffffff;
            font-size: 18px;
            font-weight: 700;
            border-bottom: 1px solid #27272a;
            padding-bottom: 15px;
            margin-bottom: 25px;
        }

        /* 3. Form Typography & Inputs */
        .form-group {
            margin-bottom: 25px;
        }

        .form-label {
            display: block;
            font-size: 13px;
            font-weight: 600;
            color: #d4d4d8;
            margin-bottom: 8px;
        }

        .form-hint {
            color: #71717a;
            font-size: 12px;
            font-weight: 500;
            display: block;
            margin-top: 6px;
        }

        .form-control-modern {
            width: 100%;
            padding: 12px 16px;
            border: 1px solid #3f3f46;
            border-radius: 6px;
            background-color: #18181b;
            font-size: 14px;
            color: #ffffff;
            transition: all 0.2s ease;
            box-sizing: border-box;
        }

        .form-control-modern:focus {
            border-color: #10b981; /* Professional Green Focus */
            background-color: #09090b;
            box-shadow: 0 0 0 2px rgba(16, 185, 129, 0.2);
            outline: none;
        }

        .form-control-modern::placeholder {
            color: #52525b;
            font-weight: 400;
        }

        /* Dropdown specific */
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

        /* Highlight Box for Correct Answer Dropdown */
        .highlight-box {
            background: rgba(16, 185, 129, 0.05);
            padding: 20px;
            border-radius: 8px;
            border: 1px solid rgba(16, 185, 129, 0.2);
            display: inline-block;
            margin-bottom: 30px;
        }

        /* 4. Action Buttons (Clean & Professional) */
        .btn-primary-action {
            background: #2563eb; /* Professional Blue */
            color: white;
            border: none;
            padding: 12px 28px;
            border-radius: 6px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s ease;
            box-shadow: 0 2px 8px rgba(37, 99, 235, 0.3);
        }

        .btn-primary-action:hover {
            background: #1d4ed8;
            transform: translateY(-1px);
        }

        .btn-secondary-action {
            background: #27272a;
            color: #ffffff;
            border: 1px solid #3f3f46;
            padding: 12px 24px;
            border-radius: 6px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .btn-secondary-action:hover {
            background: #3f3f46;
            border-color: #52525b;
        }

        .btn-success-action {
            background: #10b981; /* Professional Green */
            color: white;
            border: none;
            padding: 12px 28px;
            border-radius: 6px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            box-shadow: 0 2px 8px rgba(16, 185, 129, 0.3);
            transition: all 0.2s ease;
        }
        
        .btn-success-action:hover {
            background: #059669;
            transform: translateY(-1px);
        }

        /* Flex Layouts */
        .flex-row {
            display: flex;
            gap: 20px;
            flex-wrap: wrap;
            margin-bottom: 20px;
        }

        .flex-item {
            flex: 1;
            min-width: 250px;
        }

        .action-bar {
            display: flex;
            gap: 15px;
            margin-bottom: 30px;
        }

        /* 5. The Data Grid */
        .modern-table {
            width: 100%;
            border-collapse: collapse; /* Reverted to standard clean table */
            margin-top: 10px;
        }

        .modern-table th {
            color: #a1a1aa;
            font-weight: 600;
            font-size: 12px;
            padding: 12px 20px;
            text-align: left;
            border-bottom: 2px solid #27272a;
            background: #18181b;
        }

        .modern-table td {
            padding: 16px 20px;
            background: #18181b;
            vertical-align: middle;
            color: #e4e4e7;
            font-size: 14px;
            border-bottom: 1px solid #27272a;
            line-height: 1.5;
        }

        .modern-table tr:hover td {
            background: #27272a;
        }

        /* Separator Line */
        .divider {
            margin: 40px 0 30px 0;
            border: 0;
            border-top: 1px solid #27272a;
        }
        
        .msg-label {
            display: block;
            margin-bottom: 25px;
            padding: 12px;
            border-radius: 6px;
            font-size: 14px;
            font-weight: 500;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    
    <div class="page-header">
        <h2 class="page-title">Course Assessment Builder</h2>
        <p class="page-subtitle">Configure quiz parameters and manage questions.</p>
    </div>
    
    <asp:Label ID="lblMessage" runat="server" CssClass="msg-label"></asp:Label>

    <!-- STEP 1: CREATE QUIZ HEADER -->
    <asp:Panel ID="pnlCreateQuiz" runat="server" CssClass="glass-card">
        <h3 class="card-header">Step 1: Quiz Settings</h3>
        
        <div class="form-group">
            <label class="form-label">Quiz Title</label>
            <asp:TextBox ID="txtQuizTitle" runat="server" CssClass="form-control-modern" style="max-width: 500px;" placeholder="e.g. Midterm Examination"></asp:TextBox>
        </div>

        <div class="flex-row">
            <div class="flex-item" style="max-width: 250px;">
                <label class="form-label">Duration (Minutes)</label>
                <asp:TextBox ID="txtDuration" runat="server" CssClass="form-control-modern" TextMode="Number" placeholder="45"></asp:TextBox>
            </div>
            
            <div class="flex-item" style="max-width: 350px;">
                <label class="form-label">Access Code</label>
                <asp:TextBox ID="txtAccessCode" runat="server" CssClass="form-control-modern" placeholder="e.g. MATH101"></asp:TextBox>
                <span class="form-hint">Leave blank for open access.</span>
            </div>
        </div>

        <div style="margin-top: 15px;">
            <asp:Button ID="btnSaveQuiz" runat="server" Text="Initialize Quiz" CssClass="btn-primary-action" OnClick="btnSaveQuiz_Click" />
        </div>
    </asp:Panel>

    <!-- STEP 2: ADD QUESTIONS -->
    <asp:Panel ID="pnlAddQuestions" runat="server" Visible="false" CssClass="glass-card">
        <h3 class="card-header">Step 2: Add Questions</h3>
        
        <asp:HiddenField ID="hfCurrentQuizId" runat="server" />

        <div class="form-group">
            <label class="form-label">Question Text</label>
            <asp:TextBox ID="txtQuestionText" runat="server" CssClass="form-control-modern" TextMode="MultiLine" Rows="3" placeholder="Enter the question here..."></asp:TextBox>
        </div>

        <div class="flex-row">
            <div class="flex-item">
                <label class="form-label">Option A</label>
                <asp:TextBox ID="txtOptA" runat="server" CssClass="form-control-modern"></asp:TextBox>
            </div>
            <div class="flex-item">
                <label class="form-label">Option B</label>
                <asp:TextBox ID="txtOptB" runat="server" CssClass="form-control-modern"></asp:TextBox>
            </div>
        </div>

        <div class="flex-row" style="margin-bottom: 30px;">
            <div class="flex-item">
                <label class="form-label">Option C</label>
                <asp:TextBox ID="txtOptC" runat="server" CssClass="form-control-modern"></asp:TextBox>
            </div>
            <div class="flex-item">
                <label class="form-label">Option D</label>
                <asp:TextBox ID="txtOptD" runat="server" CssClass="form-control-modern"></asp:TextBox>
            </div>
        </div>

        <div class="highlight-box">
            <label class="form-label" style="color: #10b981;">Correct Answer</label>
            <asp:DropDownList ID="ddlCorrectOption" runat="server" CssClass="form-control-modern" style="max-width: 250px;">
                <asp:ListItem Value="A">Option A</asp:ListItem>
                <asp:ListItem Value="B">Option B</asp:ListItem>
                <asp:ListItem Value="C">Option C</asp:ListItem>
                <asp:ListItem Value="D">Option D</asp:ListItem>
            </asp:DropDownList>
        </div>
        
        <div class="action-bar">
            <asp:Button ID="btnAddQuestion" runat="server" Text="Add Question" CssClass="btn-secondary-action" OnClick="btnAddQuestion_Click" />
            <asp:Button ID="btnPublishQuiz" runat="server" Text="Publish Quiz" CssClass="btn-success-action" OnClick="btnPublishQuiz_Click" />
        </div>

        <hr class="divider" />

        <h4 class="card-header" style="border:none; margin-bottom:10px; padding-bottom:0;">Questions Added</h4>
        
        <asp:GridView ID="gvQuestions" runat="server" AutoGenerateColumns="False" CssClass="modern-table" GridLines="None">
            <Columns>
                <asp:BoundField DataField="question_text" HeaderText="Question" />
                <asp:BoundField DataField="correct_option" HeaderText="Correct Option" ItemStyle-Width="120px" ItemStyle-Font-Bold="true" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center" />
            </Columns>
        </asp:GridView>
    </asp:Panel>
    
</asp:Content>