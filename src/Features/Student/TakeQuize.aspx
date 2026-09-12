<%@ Page Title="Take Assessment" Language="C#" MasterPageFile="~/src/Features/Student/StudentActivity.Master" AutoEventWireup="true" CodeBehind="TakeQuize.aspx.cs" Inherits="InSchool.src.Features.Student.TakeQuize" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        /* 1. Sticky Exam HUD (Heads Up Display) */
        .exam-header {
            position: sticky;
            top: 75px; /* Sits just under the navbar */
            z-index: 100;
            display: flex;
            justify-content: space-between;
            align-items: center;
            background: rgba(24, 24, 27, 0.95); /* Obsidian glass */
            backdrop-filter: blur(10px);
            padding: 20px 30px;
            border-radius: 12px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.5);
            border: 1px solid #27272a;
            border-top: 4px solid #2563eb; /* Corporate Azure Blue line */
            margin-bottom: 40px;
        }

        .exam-title {
            margin: 0;
            color: #ffffff;
            font-size: 22px;
            font-weight: 800;
            letter-spacing: 0.5px;
        }

        .exam-subtitle {
            margin: 5px 0 0 0;
            color: #a1a1aa;
            font-size: 13px;
            font-weight: 500;
        }

        /* 2. Professional Timer */
        .timer-box {
            font-size: 24px;
            font-weight: 900;
            color: #60a5fa; /* Light Blue */
            background: rgba(37, 99, 235, 0.1);
            padding: 12px 24px;
            border-radius: 8px;
            border: 1px solid rgba(37, 99, 235, 0.3);
            letter-spacing: 2px;
            font-variant-numeric: tabular-nums; /* Keeps numbers from jumping */
            box-shadow: inset 0 0 20px rgba(37, 99, 235, 0.05);
        }
        
        .timer-warning {
            color: #f87171 !important;
            background: rgba(239, 68, 68, 0.1) !important;
            border-color: rgba(239, 68, 68, 0.4) !important;
            animation: pulseWarning 1s infinite alternate;
        }
        
        @keyframes pulseWarning {
            from { box-shadow: inset 0 0 10px rgba(239, 68, 68, 0); }
            to { box-shadow: inset 0 0 20px rgba(239, 68, 68, 0.2); }
        }

        /* 3. Question Cards */
        .question-card {
            background: #18181b;
            padding: 30px 35px;
            border-radius: 12px;
            border: 1px solid #27272a;
            margin-bottom: 30px;
            transition: border-color 0.3s ease;
        }
        
        .question-card:hover {
            border-color: #3f3f46;
        }

        .question-text {
            font-size: 18px;
            font-weight: 700;
            color: #f8fafc;
            margin-bottom: 25px;
            line-height: 1.6;
            padding-bottom: 15px;
            border-bottom: 1px solid #27272a;
        }

        /* Customizing the RadioButtonList for Dark Mode */
        .options-list {
            width: 100%;
        }
        
        .options-list td {
            padding: 12px 0;
            display: block; /* Forces vertical stacking if ASP.NET renders them inline */
        }
        
        .options-list label {
            font-size: 15px;
            color: #d4d4d8;
            font-weight: 500;
            cursor: pointer;
            line-height: 1.5;
            transition: color 0.2s ease;
            margin-left: 10px;
        }
        
        .options-list input[type="radio"] {
            appearance: none;
            width: 20px;
            height: 20px;
            border: 2px solid #52525b;
            border-radius: 50%;
            outline: none;
            position: relative;
            cursor: pointer;
            top: 4px;
            transition: border-color 0.2s ease;
        }
        
        .options-list input[type="radio"]:checked {
            border-color: #2563eb;
        }
        
        .options-list input[type="radio"]:checked::before {
            content: '';
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            width: 10px;
            height: 10px;
            background-color: #3b82f6;
            border-radius: 50%;
        }

        .options-list input[type="radio"]:hover {
            border-color: #a1a1aa;
        }

        /* 4. Feedback Display */
        .feedback-box {
            margin-top: 20px;
            padding: 15px 20px;
            border-radius: 8px;
            font-weight: 700;
            font-size: 14px;
            display: block;
            letter-spacing: 0.5px;
        }
        
        .feedback-correct { 
            background-color: rgba(16, 185, 129, 0.1); 
            color: #34d399; 
            border: 1px solid rgba(16, 185, 129, 0.3); 
        }
        
        .feedback-wrong { 
            background-color: rgba(239, 68, 68, 0.1); 
            color: #f87171; 
            border: 1px solid rgba(239, 68, 68, 0.3); 
        }

        /* 5. Post-Exam Score Dashboard */
        .score-display {
            text-align: center;
            background: #18181b;
            padding: 60px 40px;
            border-radius: 16px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.5);
            border: 1px solid #27272a;
            margin-bottom: 40px;
            border-top: 4px solid #10b981; /* Green success top line */
        }
        
        .score-display h2 {
            color: #ffffff;
            font-size: 24px;
            font-weight: 800;
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-top: 0;
        }
        
        .score-number { 
            font-size: 80px; 
            font-weight: 900; 
            color: #ffffff; 
            margin: 20px 0 10px 0; 
            text-shadow: 0 4px 20px rgba(0,0,0,0.5);
        }
        
        .score-grade { 
            font-size: 28px; 
            font-weight: 800; 
            letter-spacing: 2px;
        }

        /* 6. Buttons */
        .btn-submit {
            background: #10b981; /* Academic Green */
            color: white;
            border: none;
            padding: 16px 45px;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 800;
            text-transform: uppercase;
            letter-spacing: 1.5px;
            cursor: pointer;
            box-shadow: 0 4px 15px rgba(16, 185, 129, 0.3);
            transition: all 0.2s ease;
        }
        
        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(16, 185, 129, 0.4);
            background: #059669;
        }

        .btn-return {
            background: #2563eb; /* Corporate Blue */
            color: white;
            border: none;
            padding: 14px 30px;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 700;
            cursor: pointer;
            margin-top: 30px;
            transition: all 0.2s ease;
        }

        .btn-return:hover {
            background: #1d4ed8;
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

    <script type="text/javascript">
        var timeLeft = 0;
        var timerInterval;

        function startTimer(durationMinutes) {
            timeLeft = durationMinutes * 60;
            var display = document.getElementById('countdown-display');
            var timerBox = document.getElementById('<%= Div1.ClientID %>');

            timerInterval = setInterval(function () {
                var minutes = parseInt(timeLeft / 60, 10);
                var seconds = parseInt(timeLeft % 60, 10);

                minutes = minutes < 10 ? "0" + minutes : minutes;
                seconds = seconds < 10 ? "0" + seconds : seconds;

                display.textContent = minutes + ":" + seconds;
                
                // Add warning class when under 2 minutes
                if (timeLeft < 120 && timerBox && !timerBox.classList.contains('timer-warning')) {
                    timerBox.classList.add('timer-warning');
                }

                if (--timeLeft < 0) {
                    clearInterval(timerInterval);
                    display.textContent = "00:00";
                    // Only click if button exists
                    var submitBtn = document.getElementById('<%= btnSubmitQuiz.ClientID %>');
                    if (submitBtn) {
                        submitBtn.click();
                    }
                }
            }, 1000);
        }
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    
    <asp:Label ID="lblMessage" runat="server" CssClass="msg-label"></asp:Label>
    <asp:HiddenField ID="hfQuizId" runat="server" />
    <asp:HiddenField ID="hfAttemptId" runat="server" />

    <!-- Post-Exam Results Dashboard -->
    <asp:Panel ID="pnlResults" runat="server" Visible="false">
        <div class="score-display">
            <h2>Assessment Complete</h2>
            <div class="score-number"><asp:Literal ID="litScore" runat="server"></asp:Literal></div>
            
            <!-- C# behind adds coloring to this literal based on the grade -->
            <div class="score-grade" style="color: #60a5fa;"><asp:Literal ID="litGrade" runat="server"></asp:Literal></div>
            
            <p style="color: #a1a1aa; margin-top: 25px; font-weight: 500;">Review your answers below.</p>
            <asp:Button ID="btnReturn" runat="server" Text="Return to Catalog" CssClass="btn-return" OnClick="btnReturn_Click" />
        </div>
    </asp:Panel>

    <!-- Active Examination Interface -->
    <asp:Panel ID="pnlExam" runat="server">
        <div class="exam-header">
            <div>
                <h2 class="exam-title"><asp:Literal ID="litQuizTitle" runat="server"></asp:Literal></h2>
                <p class="exam-subtitle">Select the best option. System auto-submits when time expires.</p>
            </div>
            <div class="timer-box" id="Div1" runat="server">
                ⏱ <span id="countdown-display">--:--</span>
            </div>
        </div>

        <asp:Repeater ID="rptQuestions" runat="server" OnItemDataBound="rptQuestions_ItemDataBound">
            <ItemTemplate>
                <div class="question-card">
                    <div class="question-text"><%# Container.ItemIndex + 1 %>. <%# Eval("question_text") %></div>
                    
                    <asp:HiddenField ID="hfQuestionId" runat="server" Value='<%# Eval("question_id") %>' />
                    <asp:HiddenField ID="hfCorrectOption" runat="server" Value='<%# Eval("correct_option") %>' />
                    
                    <asp:RadioButtonList ID="rblOptions" runat="server" CssClass="options-list" RepeatLayout="Table">
                    </asp:RadioButtonList>

                    <asp:Label ID="lblFeedback" runat="server" Visible="false" CssClass="feedback-box"></asp:Label>
                </div>
            </ItemTemplate>
        </asp:Repeater>

        <div style="text-align: center; margin-top: 40px; margin-bottom: 60px;">
            <asp:Button ID="btnSubmitQuiz" runat="server" Text="Submit Assessment" CssClass="btn-submit" OnClick="btnSubmitQuiz_Click" />
        </div>
    </asp:Panel>

</asp:Content>