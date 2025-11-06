// page 251 "General Journal Batches"
// {
//     Caption = 'General Journal Batches';
//     DataCaptionExpression = DataCaption;
//     PageType = List;
//     SourceTable = Table232;

//     layout
//     {
//         area(content)
//         {
//             repeater()
//             {
//                 field(Name;Name)
//                 {
//                 }
//                 field(Description;Description)
//                 {
//                 }
//                 field("Bal. Account Type";"Bal. Account Type")
//                 {
//                 }
//                 field("Bal. Account No.";"Bal. Account No.")
//                 {
//                 }
//                 field("No. Series";"No. Series")
//                 {
//                 }
//                 field("Posting No. Series";"Posting No. Series")
//                 {
//                 }
//                 field("Reason Code";"Reason Code")
//                 {
//                 }
//                 field("Copy VAT Setup to Jnl. Lines";"Copy VAT Setup to Jnl. Lines")
//                 {
//                 }
//                 field("Allow VAT Difference";"Allow VAT Difference")
//                 {
//                 }
//                 field("Allow Payment Export";"Allow Payment Export")
//                 {
//                 }
//                 field("Bank Statement Import Format";"Bank Statement Import Format")
//                 {
//                 }
//             }
//         }
//         area(factboxes)
//         {
//             systempart(;Links)
//             {
//                 Visible = false;
//             }
//             systempart(;Notes)
//             {
//                 Visible = false;
//             }
//         }
//     }

//     actions
//     {
//         area(processing)
//         {
//             action(EditJournal)
//             {
//                 Caption = 'Edit Journal';
//                 Image = OpenJournal;
//                 Promoted = true;
//                 PromotedCategory = Process;
//                 PromotedIsBig = true;
//                 ShortCutKey = 'Return';

//                 trigger OnAction()
//                 begin
//                     GenJnlManagement.TemplateSelectionFromBatch(Rec);
//                 end;
//             }
//             action("Block/Unblock Customer Card")
//             {
//                 Caption = 'Block/Unblock Customer Card';
//                 Ellipsis = true;
//                 Image = Overdue;
//                 Promoted = true;
//                 PromotedCategory = Process;
//                 PromotedIsBig = true;
//                 RunObject = Report 50020;
//             }
//             group("P&osting")
//             {
//                 Caption = 'P&osting';
//                 Image = Post;
//                 action(Reconcile)
//                 {
//                     Caption = 'Reconcile';
//                     Image = Reconcile;
//                     ShortCutKey = 'Ctrl+F11';

//                     trigger OnAction()
//                     begin
//                         GenJnlLine.SETRANGE("Journal Template Name","Journal Template Name");
//                         GenJnlLine.SETRANGE("Journal Batch Name",Name);
//                         GLReconcile.SetGenJnlLine(GenJnlLine);
//                         GLReconcile.RUN;
//                     end;
//                 }
//                 action("Test Report")
//                 {
//                     Caption = 'Test Report';
//                     Ellipsis = true;
//                     Image = TestReport;

//                     trigger OnAction()
//                     begin
//                         ReportPrint.PrintGenJnlBatch(Rec);
//                     end;
//                 }
//                 action("P&ost")
//                 {
//                     Caption = 'P&ost';
//                     Image = PostOrder;
//                     Promoted = true;
//                     PromotedCategory = Process;
//                     PromotedIsBig = true;
//                     RunObject = Codeunit 233;
//                     ShortCutKey = 'F9';
//                 }
//                 action("Post and &Print")
//                 {
//                     Caption = 'Post and &Print';
//                     Image = PostPrint;
//                     Promoted = true;
//                     PromotedCategory = Process;
//                     PromotedIsBig = true;
//                     RunObject = Codeunit 234;
//                     ShortCutKey = 'Shift+F9';
//                 }
//             }
//         }
//     }

//     trigger OnNewRecord(BelowxRec: Boolean)
//     begin
//         SetupNewBatch;
//     end;

//     trigger OnOpenPage()
//     begin
//         GenJnlManagement.OpenJnlBatch(Rec);
//     end;

//     var
//         ReportPrint: Codeunit "228";
//         GenJnlManagement: Codeunit "230";
//         GenJnlLine: Record "81";
//         GLReconcile: Page "345";

//     local procedure DataCaption(): Text[250]
//     var
//         GenJnlTemplate: Record "80";
//     begin
//         IF NOT CurrPage.LOOKUPMODE THEN
//           IF GETFILTER("Journal Template Name") <> '' THEN
//             IF GETRANGEMIN("Journal Template Name") = GETRANGEMAX("Journal Template Name") THEN
//               IF GenJnlTemplate.GET(GETRANGEMIN("Journal Template Name")) THEN
//                 EXIT(GenJnlTemplate.Name + ' ' + GenJnlTemplate.Description);
//     end;
// }

