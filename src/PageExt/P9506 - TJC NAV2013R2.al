// page 9506 "Session List"
// {
//     // TJCSG1.00
//     //  1. 02/09/2014  dp.dst
//     //     - Enabled deletion an any sessions.
//     //     - Changed the page's DeleteAllowed property to YES.
//     //     - Inserted codes on OnDeleteRecord() to delete the current session ID.

//     Caption = 'Session List';
//     DeleteAllowed = true;
//     InsertAllowed = false;
//     LinksAllowed = false;
//     ModifyAllowed = false;
//     PageType = List;
//     PromotedActionCategories = 'New,Process,Report,Session,SQL Trace';
//     RefreshOnActivate = true;
//     SourceTable = Table2000000110;

//     layout
//     {
//         area(content)
//         {
//             repeater(Group)
//             {
//                 field(SessionIdText;SessionIdText)
//                 {
//                     Caption = 'Session ID';
//                     Editable = false;
//                 }
//                 field("User ID";"User ID")
//                 {
//                     Caption = 'User ID';
//                     Editable = false;
//                 }
//                 field(IsSQLTracing;IsSQLTracing)
//                 {
//                     Caption = 'SQL Tracing';

//                     trigger OnValidate()
//                     begin
//                         DEBUGGER.ENABLESQLTRACE("Session ID",IsSQLTracing);
//                     end;
//                 }
//                 field("Client Type";ClientTypeText)
//                 {
//                     Caption = 'Client Type';
//                     Editable = false;
//                 }
//                 field("Login Datetime";"Login Datetime")
//                 {
//                     Caption = 'Login Date';
//                     Editable = false;
//                 }
//                 field("Server Computer Name";"Server Computer Name")
//                 {
//                     Caption = 'Server Computer Name';
//                     Editable = false;
//                 }
//                 field("Server Instance Name";"Server Instance Name")
//                 {
//                     Caption = 'Server Instance Name';
//                     Editable = false;
//                 }
//                 field(IsDebugging;IsDebugging)
//                 {
//                     Caption = 'Debugging';
//                     Editable = false;
//                 }
//                 field(IsDebugged;IsDebugged)
//                 {
//                     Caption = 'Debugged';
//                     Editable = false;
//                 }
//             }
//         }
//     }

//     actions
//     {
//         area(processing)
//         {
//             separator()
//             {
//             }
//             group(Session)
//             {
//                 Caption = 'Session';
//                 action("Debug Selected Session")
//                 {
//                     Caption = 'Debug';
//                     Enabled = CanDebugSelectedSession;
//                     Image = Debug;
//                     Promoted = true;
//                     PromotedCategory = Category4;
//                     PromotedIsBig = true;
//                     ShortCutKey = 'Shift+Ctrl+S';
//                     ToolTip = 'Debug the selected session';

//                     trigger OnAction()
//                     begin
//                         DebuggerManagement.SetDebuggedSession(Rec);
//                         DebuggerManagement.OpenDebuggerTaskPage;
//                     end;
//                 }
//                 action("Debug Next Session")
//                 {
//                     Caption = 'Debug Next';
//                     Enabled = CanDebugNextSession;
//                     Image = DebugNext;
//                     Promoted = true;
//                     PromotedCategory = Category4;
//                     PromotedIsBig = true;
//                     ShortCutKey = 'Shift+Ctrl+N';
//                     ToolTip = 'Debug the next session that breaks code execution.';

//                     trigger OnAction()
//                     var
//                         DebuggedSessionTemp: Record "2000000110";
//                     begin
//                         DebuggedSessionTemp."Session ID" := 0;
//                         DebuggerManagement.SetDebuggedSession(DebuggedSessionTemp);
//                         DebuggerManagement.OpenDebuggerTaskPage;
//                     end;
//                 }
//             }
//             group("SQL Trace")
//             {
//                 Caption = 'SQL Trace';
//                 action("Start Full SQL Tracing")
//                 {
//                     Caption = 'Start Full SQL Tracing';
//                     Enabled = NOT FullSQLTracingStarted;
//                     Image = Continue;
//                     Promoted = true;
//                     PromotedCategory = Category5;

//                     trigger OnAction()
//                     begin
//                         DEBUGGER.ENABLESQLTRACE(0,TRUE);
//                         FullSQLTracingStarted := TRUE;
//                     end;
//                 }
//                 action("Stop Full SQL Tracing")
//                 {
//                     Caption = 'Stop Full SQL Tracing';
//                     Enabled = FullSQLTracingStarted;
//                     Image = Stop;
//                     Promoted = true;
//                     PromotedCategory = Category5;

//                     trigger OnAction()
//                     begin
//                         DEBUGGER.ENABLESQLTRACE(0,FALSE);
//                         FullSQLTracingStarted := FALSE;
//                     end;
//                 }
//             }
//         }
//     }

//     trigger OnAfterGetRecord()
//     begin
//         IsDebugging := DEBUGGER.ISACTIVE AND ("Session ID" = DEBUGGER.DEBUGGINGSESSIONID);
//         IsDebugged := DEBUGGER.ISATTACHED AND ("Session ID" = DEBUGGER.DEBUGGEDSESSIONID);
//         IsSQLTracing := DEBUGGER.ENABLESQLTRACE("Session ID");

//         // If this is the empty row, clear the Session ID and Client Type
//         IF "Session ID" = 0 THEN BEGIN
//           SessionIdText := '';
//           ClientTypeText := '';
//         END ELSE BEGIN
//           SessionIdText := FORMAT("Session ID");
//           ClientTypeText := FORMAT("Client Type");
//         END;
//     end;

//     trigger OnDeleteRecord(): Boolean
//     begin
//         /*Start: TJCSG1.00 #1*/
//         STOPSESSION("Session ID");
//         /*End: TJCSG1.00 #1*/

//     end;

//     trigger OnFindRecord(Which: Text): Boolean
//     begin
//         CanDebugNextSession := NOT DEBUGGER.ISACTIVE;
//         CanDebugSelectedSession := NOT DEBUGGER.ISATTACHED AND NOT ISEMPTY;

//         // If the session list is empty, insert an empty row to carry the button state to the client
//         IF NOT FIND(Which) THEN BEGIN
//           INIT;
//           "Session ID" := 0;
//         END;

//         EXIT(TRUE);
//     end;

//     trigger OnOpenPage()
//     begin
//         FILTERGROUP(2);
//         SETFILTER("Server Instance ID",'=%1',SERVICEINSTANCEID);
//         SETFILTER("Session ID",'<>%1',SESSIONID);
//         FILTERGROUP(0);

//         FullSQLTracingStarted := DEBUGGER.ENABLESQLTRACE(0);
//     end;

//     var
//         DebuggerManagement: Codeunit "9500";
//         [InDataSet]
//         CanDebugNextSession: Boolean;
//         [InDataSet]
//         CanDebugSelectedSession: Boolean;
//         [InDataSet]
//         FullSQLTracingStarted: Boolean;
//         IsDebugging: Boolean;
//         IsDebugged: Boolean;
//         IsSQLTracing: Boolean;
//         SessionIdText: Text;
//         ClientTypeText: Text;
// }

