<%@ Page Title="My Submissions" Language="C#" MasterPageFile="~/src/Features/Student/StudentActivity.Master" AutoEventWireup="true" CodeBehind="History.aspx.cs" Inherits="InSchool.src.Features.Student.History" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        /* 1. Page Header (Professional Style) */
        .page-header {
            margin-bottom: 30px;
            border-left: 4px solid #2563eb; /* Corporate Azure Blue */
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

        /* 2. Glass Cards */
        .glass-card {
            background: #18181b; /* Matte Obsidian */
            border-radius: 12px;
            padding: 30px;
            box-shadow: 0 8px 30px rgba(0,0,0,0.4);
            border: 1px solid #27272a;
            margin-bottom: 30px;
            transition: all 0.3s ease;
        }

        /* 3. Clean Data Grid */
        .modern-table {
            width: 100%;
            border-collapse: collapse;
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
            transition: background 0.2s ease;
        }

        .modern-table tr:hover td {
            background: #27272a;
        }

        /* 4. Dark-Mode Grade Badges */
        .grade-badge {
            padding: 6px 14px;
            border-radius: 6px;
            font-size: 13px;
            font-weight: 700;
            display: inline-block;
            text-align: center;
            min-width: 45px;
            letter-spacing: 1px;
        }
        
        .grade-A { 
            background-color: rgba(16, 185, 129, 0.1); 
            color: #34d399; 
            border: 1px solid rgba(16, 185, 129, 0.3); 
        }
        .grade-B { 
            background-color: rgba(59, 130, 246, 0.1); 
            color: #60a5fa; 
            border: 1px solid rgba(59, 130, 246, 0.3); 
        }
        .grade-C { 
            background-color: rgba(245, 158, 11, 0.1); 
            color: #fbbf24; 
            border: 1px solid rgba(245, 158, 11, 0.3); 
        }
        .grade-D { 
            background-color: rgba(249, 115, 22, 0.1); 
            color: #fb923c; 
            border: 1px solid rgba(249, 115, 22, 0.3); 
        }
        .grade-F { 
            background-color: rgba(239, 68, 68, 0.1); 
            color: #f87171; 
            border: 1px solid rgba(239, 68, 68, 0.3); 
        }
        
        /* 5. Empty State Panel */
        .empty-state {
            background: #18181b;
            padding: 50px 30px;
            border-radius: 12px;
            text-align: center;
            border: 1px dashed #3f3f46;
            color: #a1a1aa;
        }

        .empty-state h3 {
            margin-top: 0;
            color: #ffffff;
            font-size: 20px;
            font-weight: 700;
            margin-bottom: 10px;
        }
        
        .empty-state p {
            font-size: 14px;
            margin-bottom: 25px;
            color: #71717a;
        }

        .btn-primary-action {
            background: #2563eb; /* Corporate Azure Blue */
            color: white;
            border: none;
            padding: 12px 28px;
            border-radius: 6px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s ease;
            box-shadow: 0 2px 8px rgba(37, 99, 235, 0.3);
            display: inline-block;
        }

        .btn-primary-action:hover {
            background: #1d4ed8;
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
    
    <div class="page-header">
        <h2 class="page-title">Academic History</h2>
        <p class="page-subtitle">Review your past assessment scores and final grades.</p>
    </div>
    
    <asp:Label ID="lblMessage" runat="server" CssClass="msg-label"></asp:Label>

    <!-- History Data Grid Panel -->
    <asp:Panel ID="pnlHistory" runat="server" CssClass="glass-card">
        <asp:GridView ID="gvHistory" runat="server" AutoGenerateColumns="False" CssClass="modern-table" GridLines="None" Width="100%" OnRowDataBound="gvHistory_RowDataBound">
            <Columns>
                <asp:BoundField DataField="CourseName" HeaderText="Course" />
                <asp:BoundField DataField="QuizTitle" HeaderText="Assessment" />
                <asp:BoundField DataField="SubmissionDate" HeaderText="Date Completed" DataFormatString="{0:MMM dd, yyyy - hh:mm tt}" />
                <asp:BoundField DataField="ScoreText" HeaderText="Raw Score" ItemStyle-Font-Bold="true" />
                
                <asp:TemplateField HeaderText="Final Grade" ItemStyle-Width="120px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                    <ItemTemplate>
                        <!-- The code-behind injects "grade-badge grade-A", etc. -->
                        <asp:Label ID="lblGrade" runat="server" Text='<%# Eval("Grade") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
    </asp:Panel>

    <!-- Empty State Panel -->
    <asp:Panel ID="pnlEmpty" runat="server" Visible="false" CssClass="empty-state">
        <h3>No Submissions Found</h3>
        <p>You have not completed any assessments yet. Visit the Course Catalog to begin.</p>
        <asp:Button ID="btnGoToCourses" runat="server" Text="Browse Catalog" CssClass="btn-primary-action" OnClick="btnGoToCourses_Click" />
    </asp:Panel>

</asp:Content>