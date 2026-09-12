<%@ Page Title="Quiz Statistics" Language="C#" MasterPageFile="~/src/Features/Teacher/TeacherActivity.Master" AutoEventWireup="true" CodeBehind="QuizeStatistics.aspx.cs" Inherits="InSchool.src.Features.Teacher.QuizeStatistics" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        /* 1. Page Header (Professional Dark) */
        .page-header {
            margin-bottom: 30px;
            border-left: 4px solid #2563eb; /* Professional Blue */
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

        /* 2. Glass Cards (Matte Obsidian) */
        .glass-card {
            background: #18181b;
            border-radius: 12px;
            padding: 25px 30px;
            box-shadow: 0 8px 30px rgba(0, 0, 0, 0.4);
            border: 1px solid #27272a;
            margin-bottom: 30px;
            transition: all 0.3s ease;
        }

        /* 3. Controls & Inputs */
        .control-group {
            display: flex;
            align-items: flex-end;
            gap: 20px;
            flex-wrap: wrap;
            justify-content: space-between; /* Spreads out the flex items */
        }

        .control-left {
            display: flex;
            align-items: flex-end;
            gap: 20px;
            flex-grow: 1;
        }

        .form-label {
            display: block;
            font-size: 13px;
            font-weight: 600;
            color: #d4d4d8;
            margin-bottom: 8px;
        }

        .form-control-modern {
            width: 100%;
            min-width: 300px;
            padding: 12px 16px;
            border: 1px solid #3f3f46;
            border-radius: 6px;
            background-color: #09090b;
            font-size: 14px;
            color: #ffffff;
            transition: all 0.2s ease;
            box-sizing: border-box;
            appearance: none;
            background-image: url("data:image/svg+xml;charset=UTF-8,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='%23a1a1aa' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3e%3cpolyline points='6 9 12 15 18 9'%3e%3c/polyline%3e%3c/svg%3e");
            background-repeat: no-repeat;
            background-position: right 1rem center;
            background-size: 1em;
            cursor: pointer;
        }

        .form-control-modern:focus {
            border-color: #2563eb; /* Corporate Blue Focus */
            outline: none;
            box-shadow: 0 0 0 2px rgba(37, 99, 235, 0.2);
        }

        .form-control-modern option {
            background-color: #18181b;
            color: #ffffff;
        }

        /* Action Buttons */
        .btn-export {
            background: #10b981; /* Clean Academic Green */
            color: white;
            border: none;
            padding: 12px 24px;
            border-radius: 6px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            box-shadow: 0 2px 8px rgba(16, 185, 129, 0.2);
            transition: all 0.2s ease;
            white-space: nowrap;
        }

        .btn-export:hover {
            background: #059669;
            transform: translateY(-1px);
        }

        .btn-danger {
            background: #ef4444; /* Alert Red */
            color: white;
            border: none;
            padding: 12px 24px;
            border-radius: 6px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            box-shadow: 0 2px 8px rgba(239, 68, 68, 0.2);
            transition: all 0.2s ease;
            white-space: nowrap;
        }

        .btn-danger:hover {
            background: #dc2626;
            transform: translateY(-1px);
        }

        /* 4. Data Summary Cards */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .stat-card {
            background: #18181b;
            padding: 25px;
            border-radius: 12px;
            border: 1px solid #27272a;
            position: relative;
            display: flex;
            flex-direction: column;
            align-items: flex-start;
            box-shadow: 0 4px 15px rgba(0,0,0,0.2);
        }

        /* Professional Accent Lines */
        .stat-submissions { border-top: 4px solid #3b82f6; } /* Blue */
        .stat-average { border-top: 4px solid #f59e0b; } /* Amber */
        .stat-highest { border-top: 4px solid #10b981; } /* Green */

        .stat-card h4 {
            margin: 0 0 10px 0;
            color: #a1a1aa;
            font-size: 13px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .stat-value {
            font-size: 36px;
            font-weight: 700;
            margin: 0;
            color: #ffffff;
        }

        /* 5. The Analytics Data Grid */
        .section-title {
            color: #ffffff;
            font-size: 18px;
            font-weight: 700;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 1px solid #27272a;
        }

        .modern-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 10px;
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

        /* 6. Dark Mode Conditional Formatting for Backend Classes */
        .modern-table tr.grade-excellent td {
            background-color: rgba(16, 185, 129, 0.1) !important;
            color: #34d399 !important; 
        }

        .modern-table tr.grade-fail td {
            background-color: rgba(239, 68, 68, 0.1) !important;
            color: #f87171 !important; 
        }

        .msg-label {
            display: block;
            margin-bottom: 20px;
            padding: 12px;
            border-radius: 6px;
            font-size: 14px;
            font-weight: 500;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    
    <div class="page-header">
        <h2 class="page-title">Quiz Analytics & Reports</h2>
        <p class="page-subtitle">Review class performance and assessment metrics.</p>
    </div>

    <asp:Label ID="lblMessage" runat="server" CssClass="msg-label"></asp:Label>

    <!-- Quiz Selection Control Deck -->
    <div class="glass-card">
        <div class="control-group">
            <div class="control-left">
                <div style="flex-grow: 1;">
                    <label class="form-label">Select Published Quiz</label>
                    <asp:DropDownList ID="ddlQuizzes" runat="server" CssClass="form-control-modern" AutoPostBack="true" OnSelectedIndexChanged="ddlQuizzes_SelectedIndexChanged" />
                </div>
                <div>
                    <asp:Button ID="btnExportCSV" runat="server" Text="Download CSV" CssClass="btn-export" OnClick="btnExportCSV_Click" Visible="false" />
                </div>
            </div>
            
            <!-- New Deactivate Control -->
            <div runat="server" id="divQuizStatus" visible="false">
                <asp:Button ID="btnDeactivateQuiz" runat="server" Text="Deactivate Quiz" CssClass="btn-danger" 
                    OnClientClick="return confirm('WARNING: Deactivating this quiz will immediately force-submit all active student sessions and remove it from the course catalog. Proceed?');" 
                    OnClick="btnDeactivateQuiz_Click" />
            </div>

        </div>
    </div>

    <!-- Analytics Dashboard (Hidden until a quiz is selected) -->
    <asp:Panel ID="pnlAnalytics" runat="server" Visible="false">
        
        <!-- Top Level Stats -->
        <div class="stats-grid">
            <div class="stat-card stat-submissions">
                <h4>Total Submissions</h4>
                <p class="stat-value"><asp:Literal ID="litTotalSubmissions" runat="server">0</asp:Literal></p>
            </div>
            <div class="stat-card stat-average">
                <h4>Average Score</h4>
                <p class="stat-value"><asp:Literal ID="litAvgScore" runat="server">0%</asp:Literal></p>
            </div>
            <div class="stat-card stat-highest">
                <h4>Highest Score</h4>
                <p class="stat-value"><asp:Literal ID="litHighScore" runat="server">0%</asp:Literal></p>
            </div>
        </div>

        <!-- Detailed Results Grid -->
        <div class="glass-card" style="padding: 30px 40px;">
            <h3 class="section-title">Student Rankings</h3>
            
            <asp:GridView ID="gvResults" runat="server" AutoGenerateColumns="False" CssClass="modern-table" GridLines="None" OnRowDataBound="gvResults_RowDataBound">
                <Columns>
                    <asp:BoundField DataField="Rank" HeaderText="#" ItemStyle-Width="40px" ItemStyle-Font-Bold="true" />
                    <asp:BoundField DataField="StudentName" HeaderText="Student Name" />
                    <asp:BoundField DataField="RawScore" HeaderText="Correct Answers" ItemStyle-Width="150px" />
                    <asp:BoundField DataField="Percentage" HeaderText="Percentage" DataFormatString="{0:F1}%" ItemStyle-Width="120px" />
                    <asp:BoundField DataField="Grade" HeaderText="Grade" ItemStyle-Width="80px" ItemStyle-Font-Bold="true" />
                    <asp:BoundField DataField="SubmissionTime" HeaderText="Submitted At" DataFormatString="{0:MMM dd, hh:mm tt}" />
                </Columns>
            </asp:GridView>
        </div>
        
    </asp:Panel>
</asp:Content>