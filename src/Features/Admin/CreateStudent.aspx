<%@ Page Title="Manage Students" Language="C#" MasterPageFile="~/src/Features/Admin/AdminActivity.Master" AutoEventWireup="true" CodeBehind="CreateStudent.aspx.cs" Inherits="InSchool.src.Features.Admin.CreateStudent" %>

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

        /* 3. Modernized Dark File Upload Area */
        .upload-zone {
            display: flex;
            align-items: center;
            gap: 20px;
            background-color: #121214;
            border: 2px dashed #3f3f46;
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 20px;
            transition: all 0.3s ease;
        }

        .upload-zone:hover {
            border-color: #10b981; /* Green hover for upload */
            background-color: #052e16;
        }
        
        .upload-zone input[type="file"] {
            font-size: 14px;
            color: #a1a1aa;
            font-weight: 600;
            letter-spacing: 0.5px;
        }

        /* 4. Action Buttons & Search Bar */
        .btn-primary-action {
            background: linear-gradient(90deg, #dc2626, #fbbf24, #10b981, #fbbf24, #dc2626);
            background-size: 300% 300%;
            animation: panGradient 4s linear infinite;
            color: white;
            text-shadow: 1px 1px 2px rgba(0,0,0,0.5);
            border: none;
            padding: 12px 28px;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 900;
            text-transform: uppercase;
            letter-spacing: 1px;
            cursor: pointer;
            transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
            box-shadow: 0 4px 12px rgba(251, 191, 36, 0.2);
            white-space: nowrap;
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
        
        /* Stealth Delete Button */
        .btn-delete {
            background: transparent;
            color: #ef4444;
            border: 2px solid #ef4444;
            padding: 6px 14px;
            border-radius: 6px;
            font-size: 12px;
            font-weight: 800;
            text-transform: uppercase;
            letter-spacing: 1px;
            cursor: pointer;
            transition: all 0.2s ease;
        }
        
        .btn-delete:hover {
            background: #ef4444;
            color: #ffffff;
            box-shadow: 0 0 15px rgba(239, 68, 68, 0.4);
        }

        /* Neon Search Bar */
        .search-bar-modern {
            width: 100%;
            max-width: 350px;
            padding: 12px 16px;
            border: 2px solid #27272a;
            border-radius: 20px;
            background-color: #09090b;
            font-size: 14px;
            color: #ffffff;
            transition: all 0.3s ease;
        }

        .search-bar-modern:focus {
            border-color: #fbbf24; /* Gold Focus */
            background-color: #000000;
            box-shadow: 0 0 0 3px rgba(251, 191, 36, 0.15);
            outline: none;
        }
        
        .search-bar-modern::placeholder {
            color: #52525b;
            font-weight: 600;
            letter-spacing: 1px;
        }

        /* 5. The Gaming Data Grid */
        .section-header-flex {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
            flex-wrap: wrap;
            gap: 15px;
        }

        .section-title {
            color: #ffffff;
            font-size: 20px;
            font-weight: 800;
            margin: 0;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .modern-table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0 8px; /* Separated rows */
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
            font-size: 14px;
            font-weight: 600;
            border-top: 1px solid #27272a;
            border-bottom: 1px solid #27272a;
            transition: background 0.2s ease;
        }

        /* Rounded corners for separated rows */
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

        /* Highlight recently added rows (Neon Green Glow) */
        .new-row td {
            background-color: rgba(16, 185, 129, 0.1) !important;
            border-color: rgba(16, 185, 129, 0.3) !important;
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

    <script type="text/javascript">
        function filterGrid() {
            var input, filter, table, tr, tdName, tdIndex, i, txtValueName, txtValueIndex;
            input = document.getElementById('<%= txtIndexNumberSearch.ClientID %>');
            filter = input.value.toUpperCase();
            table = document.getElementById('<%= dgvApplicants.ClientID %>');

            if (!table) return;

            tr = table.getElementsByTagName("tr");

            for (i = 1; i < tr.length; i++) {
                tdIndex = tr[i].getElementsByTagName("td")[0];
                tdName = tr[i].getElementsByTagName("td")[1];

                if (tdIndex || tdName) {
                    txtValueIndex = tdIndex.textContent || tdIndex.innerText;
                    txtValueName = tdName.textContent || tdName.innerText;

                    if (txtValueIndex.toUpperCase().indexOf(filter) > -1 || txtValueName.toUpperCase().indexOf(filter) > -1) {
                        tr[i].style.display = "";
                    } else {
                        tr[i].style.display = "none";
                    }
                }
            }
        }
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    
    <div class="page-header">
        <h2 class="page-title">Student Batch Enrollment</h2>
        <p class="page-subtitle">Upload CSV rosters to register multiple students instantly.</p>
    </div>
    
    <asp:Label ID="lblMessage" runat="server" CssClass="msg-label"></asp:Label>

    <!-- Upload Panel Glass Card -->
    <div class="glass-card">
        <h3 class="section-title" style="margin-bottom: 10px; border: none;">Upload Student Roster</h3>
        <p style="color: #94a3b8; font-size: 13px; margin-bottom: 20px; font-weight: 600; letter-spacing: 0.5px;">
            <strong style="color: #fbbf24;">FORMAT REQUIRED:</strong> AdmissionNumber, FullName (No header row in CSV).
        </p>
        
        <div class="upload-zone">
            <asp:FileUpload ID="fileUpload" runat="server" accept=".csv" />
            <asp:Button ID="btnUpload" runat="server" Text="Upload & Process" CssClass="btn-primary-action" OnClick="btnUpload_Click" />
        </div>
        
        <asp:Label ID="lblFilePath" runat="server" ForeColor="#52525b" Font-Size="11px" Font-Bold="true" style="text-transform: uppercase; letter-spacing: 1px;"></asp:Label>
    </div>

    <!-- Registered Students Glass Card -->
    <div class="glass-card" style="padding: 30px 0;">
        
        <div class="section-header-flex" style="padding: 0 35px; border-bottom: 2px solid #27272a; padding-bottom: 20px;">
            <h3 class="section-title" style="border: none; padding: 0;">Registered Students</h3>
            <asp:TextBox ID="txtIndexNumberSearch" runat="server" CssClass="search-bar-modern" placeholder="SEARCH BY ID OR NAME..." onkeyup="filterGrid()"></asp:TextBox>
        </div>

        <div style="overflow-x: auto; padding: 0 35px;">
            <asp:GridView ID="dgvApplicants" runat="server" AutoGenerateColumns="False" CssClass="modern-table" GridLines="None" 
                DataKeyNames="user_id" OnRowDeleting="dgvApplicants_RowDeleting" OnRowDataBound="dgvApplicants_RowDataBound">
                <Columns>
                    <asp:BoundField DataField="username" HeaderText="Admission No." ItemStyle-Width="150px" />
                    <asp:BoundField DataField="full_name" HeaderText="Full Name" />
                    
                    <asp:TemplateField HeaderText="Status" ItemStyle-Width="120px">
                        <ItemTemplate>
                            <span style='<%# Eval("account_status").ToString() == "ACTIVE" ? "color: #10b981; font-weight: 900; letter-spacing: 1px;" : "color: #ef4444; font-weight: 900; letter-spacing: 1px;" %>'>
                                <%# Eval("account_status") %>
                            </span>
                        </ItemTemplate>
                    </asp:TemplateField>
                    
                    <asp:TemplateField ItemStyle-Width="100px" ItemStyle-HorizontalAlign="Right">
                        <ItemTemplate>
                            <asp:Button ID="btnDelete" runat="server" Text="Delete" CommandName="Delete" 
                                OnClientClick="return confirm('Are you sure you want to completely remove this student?');" 
                                CssClass="btn-delete" />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
    </div>
    
</asp:Content>