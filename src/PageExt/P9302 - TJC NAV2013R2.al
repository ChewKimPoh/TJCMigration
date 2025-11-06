// page 9302 "Sales Credit Memos"
// {
//     Caption = 'Sales Credit Memos';
//     CardPageID = "Sales Credit Memo";
//     Editable = false;
//     PageType = List;
//     SourceTable = Table36;
//     SourceTableView = WHERE(Document Type=CONST(Credit Memo));

//     layout
//     {
//         area(content)
//         {
//             repeater()
//             {
//                 field("No.";"No.")
//                 {
//                 }
//                 field("Sell-to Customer No.";"Sell-to Customer No.")
//                 {
//                 }
//                 field("Sell-to Customer Name";"Sell-to Customer Name")
//                 {
//                 }
//                 field("External Document No.";"External Document No.")
//                 {
//                 }
//                 field("Sell-to Post Code";"Sell-to Post Code")
//                 {
//                     Visible = false;
//                 }
//                 field("Sell-to Country/Region Code";"Sell-to Country/Region Code")
//                 {
//                     Visible = false;
//                 }
//                 field("Sell-to Contact";"Sell-to Contact")
//                 {
//                     Visible = false;
//                 }
//                 field("Bill-to Customer No.";"Bill-to Customer No.")
//                 {
//                     Visible = false;
//                 }
//                 field("Bill-to Name";"Bill-to Name")
//                 {
//                     Visible = false;
//                 }
//                 field("Bill-to Post Code";"Bill-to Post Code")
//                 {
//                     Visible = false;
//                 }
//                 field("Bill-to Country/Region Code";"Bill-to Country/Region Code")
//                 {
//                     Visible = false;
//                 }
//                 field("Bill-to Contact";"Bill-to Contact")
//                 {
//                     Visible = false;
//                 }
//                 field("Ship-to Code";"Ship-to Code")
//                 {
//                     Visible = false;
//                 }
//                 field("Ship-to Name";"Ship-to Name")
//                 {
//                     Visible = false;
//                 }
//                 field("Ship-to Post Code";"Ship-to Post Code")
//                 {
//                     Visible = false;
//                 }
//                 field("Ship-to Country/Region Code";"Ship-to Country/Region Code")
//                 {
//                     Visible = false;
//                 }
//                 field("Ship-to Contact";"Ship-to Contact")
//                 {
//                     Visible = false;
//                 }
//                 field("Posting Date";"Posting Date")
//                 {
//                     Visible = false;
//                 }
//                 field("Shortcut Dimension 1 Code";"Shortcut Dimension 1 Code")
//                 {
//                     Visible = false;
//                 }
//                 field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
//                 {
//                     Visible = false;
//                 }
//                 field("Location Code";"Location Code")
//                 {
//                     Visible = true;
//                 }
//                 field("Salesperson Code";"Salesperson Code")
//                 {
//                     Visible = false;
//                 }
//                 field(Amount;Amount)
//                 {
//                 }
//                 field("Amount Including VAT";"Amount Including VAT")
//                 {
//                 }
//                 field("Assigned User ID";"Assigned User ID")
//                 {
//                 }
//                 field("Currency Code";"Currency Code")
//                 {
//                     Visible = false;
//                 }
//                 field("Document Date";"Document Date")
//                 {
//                     Visible = false;
//                 }
//                 field("Campaign No.";"Campaign No.")
//                 {
//                     Visible = false;
//                 }
//                 field(Status;Status)
//                 {
//                     Visible = false;
//                 }
//                 field("Payment Terms Code";"Payment Terms Code")
//                 {
//                     Visible = false;
//                 }
//                 field("Due Date";"Due Date")
//                 {
//                     Visible = false;
//                 }
//                 field("Shipment Date";"Shipment Date")
//                 {
//                     Visible = false;
//                 }
//                 field("Applies-to Doc. Type";"Applies-to Doc. Type")
//                 {
//                     Visible = false;
//                 }
//                 field("Job Queue Status";"Job Queue Status")
//                 {
//                     Visible = JobQueueActive;
//                 }
//             }
//         }
//         area(factboxes)
//         {
//             part(;9082)
//             {
//                 SubPageLink = No.=FIELD(Bill-to Customer No.),
//                               Date Filter=FIELD(Date Filter);
//                 Visible = true;
//             }
//             part(;9084)
//             {
//                 SubPageLink = No.=FIELD(Bill-to Customer No.),
//                               Date Filter=FIELD(Date Filter);
//                 Visible = true;
//             }
//             systempart(;Links)
//             {
//                 Visible = false;
//             }
//             systempart(;Notes)
//             {
//                 Visible = true;
//             }
//         }
//     }

//     actions
//     {
//         area(navigation)
//         {
//             group("&Cr. Memo")
//             {
//                 Caption = '&Cr. Memo';
//                 Image = CreditMemo;
//                 action(Statistics)
//                 {
//                     Caption = 'Statistics';
//                     Image = Statistics;
//                     Promoted = true;
//                     PromotedCategory = Process;
//                     ShortCutKey = 'F7';

//                     trigger OnAction()
//                     begin
//                         CalcInvDiscForHeader;
//                         COMMIT;
//                         PAGE.RUNMODAL(PAGE::"Sales Statistics",Rec);
//                     end;
//                 }
//                 action("Co&mments")
//                 {
//                     Caption = 'Co&mments';
//                     Image = ViewComments;
//                     RunObject = Page 67;
//                     RunPageLink = Document Type=FIELD(Document Type),
//                                   No.=FIELD(No.),
//                                   Document Line No.=CONST(0);
//                 }
//                 action(Dimensions)
//                 {
//                     Caption = 'Dimensions';
//                     Image = Dimensions;
//                     ShortCutKey = 'Shift+Ctrl+D';

//                     trigger OnAction()
//                     begin
//                         ShowDocDim;
//                     end;
//                 }
//                 action(Approvals)
//                 {
//                     Caption = 'Approvals';
//                     Image = Approvals;

//                     trigger OnAction()
//                     var
//                         ApprovalEntries: Page "658";
//                     begin
//                         ApprovalEntries.Setfilters(DATABASE::"Sales Header","Document Type","No.");
//                         ApprovalEntries.RUN;
//                     end;
//                 }
//             }
//         }
//         area(processing)
//         {
//             group(Release)
//             {
//                 Caption = 'Release';
//                 Image = ReleaseDoc;
//                 action("Re&lease")
//                 {
//                     Caption = 'Re&lease';
//                     Image = ReleaseDoc;
//                     ShortCutKey = 'Ctrl+F9';

//                     trigger OnAction()
//                     var
//                         ReleaseSalesDoc: Codeunit "414";
//                     begin
//                         ReleaseSalesDoc.PerformManualRelease(Rec);
//                     end;
//                 }
//                 action("Re&open")
//                 {
//                     Caption = 'Re&open';
//                     Image = ReOpen;

//                     trigger OnAction()
//                     var
//                         ReleaseSalesDoc: Codeunit "414";
//                     begin
//                         ReleaseSalesDoc.PerformManualReopen(Rec);
//                     end;
//                 }
//             }
//             group("F&unctions")
//             {
//                 Caption = 'F&unctions';
//                 Image = "Action";
//                 action("Send A&pproval Request")
//                 {
//                     Caption = 'Send A&pproval Request';
//                     Image = SendApprovalRequest;

//                     trigger OnAction()
//                     var
//                         ApprovalMgt: Codeunit "439";
//                     begin
//                         IF ApprovalMgt.SendSalesApprovalRequest(Rec) THEN;
//                     end;
//                 }
//                 action("Cancel Approval Re&quest")
//                 {
//                     Caption = 'Cancel Approval Re&quest';
//                     Image = Cancel;

//                     trigger OnAction()
//                     var
//                         ApprovalMgt: Codeunit "439";
//                     begin
//                         IF ApprovalMgt.CancelSalesApprovalRequest(Rec,TRUE,TRUE) THEN;
//                     end;
//                 }
//                 separator()
//                 {
//                 }
//             }
//             group("P&osting")
//             {
//                 Caption = 'P&osting';
//                 Image = Post;
//                 action("Test Report")
//                 {
//                     Caption = 'Test Report';
//                     Ellipsis = true;
//                     Image = TestReport;

//                     trigger OnAction()
//                     begin
//                         ReportPrint.PrintSalesHeader(Rec);
//                     end;
//                 }
//                 action("P&ost")
//                 {
//                     Caption = 'P&ost';
//                     Image = PostOrder;
//                     Promoted = true;
//                     PromotedCategory = Process;
//                     PromotedIsBig = true;
//                     ShortCutKey = 'F9';

//                     trigger OnAction()
//                     begin
//                         SendToPosting(CODEUNIT::"Sales-Post (Yes/No)");
//                     end;
//                 }
//                 action("Post and &Print")
//                 {
//                     Caption = 'Post and &Print';
//                     Image = PostPrint;
//                     Promoted = true;
//                     PromotedCategory = Process;
//                     PromotedIsBig = true;
//                     ShortCutKey = 'Shift+F9';

//                     trigger OnAction()
//                     begin
//                         SendToPosting(CODEUNIT::"Sales-Post + Print");
//                     end;
//                 }
//                 action("Post &Batch")
//                 {
//                     Caption = 'Post &Batch';
//                     Ellipsis = true;
//                     Image = PostBatch;
//                     Promoted = false;
//                     //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
//                     //PromotedCategory = Process;

//                     trigger OnAction()
//                     begin
//                         REPORT.RUNMODAL(REPORT::"Batch Post Sales Credit Memos",TRUE,TRUE,Rec);
//                         CurrPage.UPDATE(FALSE);
//                     end;
//                 }
//                 action("Remove From Job Queue")
//                 {
//                     Caption = 'Remove From Job Queue';
//                     Image = RemoveLine;
//                     Visible = JobQueueActive;

//                     trigger OnAction()
//                     begin
//                         CancelBackgroundPosting;
//                     end;
//                 }
//             }
//         }
//     }

//     trigger OnOpenPage()
//     var
//         SalesSetup: Record "311";
//     begin
//         SetSecurityFilterOnRespCenter;
//         JobQueueActive := SalesSetup.JobQueueActive;
//     end;

//     var
//         ReportPrint: Codeunit "228";
//         [InDataSet]
//         JobQueueActive: Boolean;
// }

