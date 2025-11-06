// page 44 "Sales Credit Memo"
// {
//     Caption = 'Sales Credit Memo';
//     PageType = Document;
//     RefreshOnActivate = true;
//     SourceTable = Table36;
//     SourceTableView = WHERE(Document Type=FILTER(Credit Memo));

//     layout
//     {
//         area(content)
//         {
//             group(General)
//             {
//                 Caption = 'General';
//                 field("No.";"No.")
//                 {
//                     Importance = Promoted;

//                     trigger OnAssistEdit()
//                     begin
//                         IF AssistEdit(xRec) THEN
//                           CurrPage.UPDATE;
//                     end;
//                 }
//                 field("Sell-to Customer No.";"Sell-to Customer No.")
//                 {
//                     Importance = Promoted;

//                     trigger OnValidate()
//                     begin
//                         SelltoCustomerNoOnAfterValidat;
//                     end;
//                 }
//                 field("Sell-to Contact No.";"Sell-to Contact No.")
//                 {

//                     trigger OnValidate()
//                     begin
//                         IF GETFILTER("Sell-to Contact No.") = xRec."Sell-to Contact No." THEN
//                           IF "Sell-to Contact No." <> xRec."Sell-to Contact No." THEN
//                             SETRANGE("Sell-to Contact No.");
//                     end;
//                 }
//                 field("Sell-to Customer Name";"Sell-to Customer Name")
//                 {
//                 }
//                 field("Sell-to Address";"Sell-to Address")
//                 {
//                     Importance = Additional;
//                 }
//                 field("Sell-to Address 2";"Sell-to Address 2")
//                 {
//                     Importance = Additional;
//                 }
//                 field("Sell-to Post Code";"Sell-to Post Code")
//                 {
//                     Importance = Additional;
//                 }
//                 field("Sell-to City";"Sell-to City")
//                 {
//                 }
//                 field("Sell-to Contact";"Sell-to Contact")
//                 {
//                 }
//                 field("Posting Date";"Posting Date")
//                 {
//                     Importance = Promoted;
//                 }
//                 field("Document Date";"Document Date")
//                 {
//                 }
//                 field("Incoming Document Entry No.";"Incoming Document Entry No.")
//                 {
//                     Visible = false;
//                 }
//                 field("External Document No.";"External Document No.")
//                 {
//                     Importance = Promoted;
//                 }
//                 field("Salesperson Code";"Salesperson Code")
//                 {

//                     trigger OnValidate()
//                     begin
//                         SalespersonCodeOnAfterValidate;
//                     end;
//                 }
//                 field("Campaign No.";"Campaign No.")
//                 {
//                     Importance = Additional;
//                 }
//                 field("Responsibility Center";"Responsibility Center")
//                 {
//                     Importance = Additional;
//                 }
//                 field("Assigned User ID";"Assigned User ID")
//                 {
//                     Importance = Additional;
//                 }
//                 field("Job Queue Status";"Job Queue Status")
//                 {
//                     Importance = Additional;
//                 }
//                 field(Status;Status)
//                 {
//                     Importance = Promoted;
//                 }
//             }
//             part(SalesLines;96)
//             {
//                 SubPageLink = Document No.=FIELD(No.);
//             }
//             group(Invoicing)
//             {
//                 Caption = 'Invoicing';
//                 field("Bill-to Customer No.";"Bill-to Customer No.")
//                 {
//                     Importance = Promoted;

//                     trigger OnValidate()
//                     begin
//                         BilltoCustomerNoOnAfterValidat;
//                     end;
//                 }
//                 field("Bill-to Contact No.";"Bill-to Contact No.")
//                 {
//                 }
//                 field("Bill-to Name";"Bill-to Name")
//                 {
//                 }
//                 field("Bill-to Address";"Bill-to Address")
//                 {
//                     Importance = Additional;
//                 }
//                 field("Bill-to Address 2";"Bill-to Address 2")
//                 {
//                     Importance = Additional;
//                 }
//                 field("Bill-to Post Code";"Bill-to Post Code")
//                 {
//                     Importance = Additional;
//                 }
//                 field("Bill-to City";"Bill-to City")
//                 {
//                 }
//                 field("Bill-to Contact";"Bill-to Contact")
//                 {
//                     Importance = Additional;
//                 }
//                 field("Shortcut Dimension 1 Code";"Shortcut Dimension 1 Code")
//                 {

//                     trigger OnValidate()
//                     begin
//                         ShortcutDimension1CodeOnAfterV;
//                     end;
//                 }
//                 field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
//                 {

//                     trigger OnValidate()
//                     begin
//                         ShortcutDimension2CodeOnAfterV;
//                     end;
//                 }
//                 field("Payment Terms Code";"Payment Terms Code")
//                 {
//                     Importance = Promoted;
//                 }
//                 field("Due Date";"Due Date")
//                 {
//                     Importance = Promoted;
//                 }
//                 field("Payment Discount %";"Payment Discount %")
//                 {
//                 }
//                 field("Pmt. Discount Date";"Pmt. Discount Date")
//                 {
//                     Importance = Additional;
//                 }
//                 field("Payment Method Code";"Payment Method Code")
//                 {
//                 }
//                 field("Prices Including VAT";"Prices Including VAT")
//                 {

//                     trigger OnValidate()
//                     begin
//                         PricesIncludingVATOnAfterValid;
//                     end;
//                 }
//                 field("VAT Bus. Posting Group";"VAT Bus. Posting Group")
//                 {
//                 }
//                 field("Credit Card No.";"Credit Card No.")
//                 {
//                 }
//                 field(GetCreditcardNumber;GetCreditcardNumber)
//                 {
//                     Caption = 'Cr. Card Number (Last 4 Digits)';
//                 }
//             }
//             group(Shipping)
//             {
//                 Caption = 'Shipping';
//                 field("Ship-to Name";"Ship-to Name")
//                 {
//                     Importance = Promoted;
//                 }
//                 field("Ship-to Address";"Ship-to Address")
//                 {
//                     Importance = Additional;
//                 }
//                 field("Ship-to Address 2";"Ship-to Address 2")
//                 {
//                     Importance = Additional;
//                 }
//                 field("Ship-to Post Code";"Ship-to Post Code")
//                 {
//                     Importance = Promoted;
//                 }
//                 field("Ship-to City";"Ship-to City")
//                 {
//                 }
//                 field("Ship-to Contact";"Ship-to Contact")
//                 {
//                     Importance = Additional;
//                 }
//                 field("Location Code";"Location Code")
//                 {
//                 }
//                 field("Shipment Date";"Shipment Date")
//                 {
//                     Importance = Promoted;
//                 }
//             }
//             group("Foreign Trade")
//             {
//                 Caption = 'Foreign Trade';
//                 field("Currency Code";"Currency Code")
//                 {
//                     Importance = Promoted;

//                     trigger OnAssistEdit()
//                     begin
//                         CLEAR(ChangeExchangeRate);
//                         IF "Posting Date" <> 0D THEN
//                           ChangeExchangeRate.SetParameter("Currency Code","Currency Factor","Posting Date")
//                         ELSE
//                           ChangeExchangeRate.SetParameter("Currency Code","Currency Factor",WORKDATE);
//                         IF ChangeExchangeRate.RUNMODAL = ACTION::OK THEN BEGIN
//                           VALIDATE("Currency Factor",ChangeExchangeRate.GetParameter);
//                           CurrPage.UPDATE;
//                         END;
//                         CLEAR(ChangeExchangeRate);
//                     end;
//                 }
//                 field("EU 3-Party Trade";"EU 3-Party Trade")
//                 {
//                 }
//                 field("Transaction Type";"Transaction Type")
//                 {
//                 }
//                 field("Transaction Specification";"Transaction Specification")
//                 {
//                 }
//                 field("Transport Method";"Transport Method")
//                 {
//                 }
//                 field("Exit Point";"Exit Point")
//                 {
//                 }
//                 field(Area;Area)
//                 {
//                 }
//             }
//             group(Application)
//             {
//                 Caption = 'Application';
//                 field("Applies-to Doc. Type";"Applies-to Doc. Type")
//                 {
//                 }
//                 field("Applies-to Doc. No.";"Applies-to Doc. No.")
//                 {
//                 }
//                 field("Applies-to ID";"Applies-to ID")
//                 {
//                 }
//             }
//         }
//         area(factboxes)
//         {
//             part(;9080)
//             {
//                 SubPageLink = No.=FIELD(Sell-to Customer No.);
//                 Visible = false;
//             }
//             part(;9081)
//             {
//                 SubPageLink = No.=FIELD(Sell-to Customer No.);
//                 Visible = false;
//             }
//             part(;9082)
//             {
//                 SubPageLink = No.=FIELD(Bill-to Customer No.);
//                 Visible = true;
//             }
//             part(;9084)
//             {
//                 SubPageLink = No.=FIELD(Sell-to Customer No.);
//                 Visible = true;
//             }
//             part(;9087)
//             {
//                 Provider = SalesLines;
//                 SubPageLink = Document Type=FIELD(Document Type),
//                               Document No.=FIELD(Document No.),
//                               Line No.=FIELD(Line No.);
//                 Visible = false;
//             }
//             part(;9092)
//             {
//                 SubPageLink = Table ID=CONST(36),
//                               Document Type=FIELD(Document Type),
//                               Document No.=FIELD(No.);
//                 Visible = false;
//             }
//             part(;9108)
//             {
//                 Provider = SalesLines;
//                 SubPageLink = No.=FIELD(No.);
//                 Visible = false;
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
//             group("&Credit Memo")
//             {
//                 Caption = '&Credit Memo';
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
//                 action(Customer)
//                 {
//                     Caption = 'Customer';
//                     Image = EditLines;
//                     RunObject = Page 21;
//                     RunPageLink = No.=FIELD(Sell-to Customer No.);
//                     ShortCutKey = 'Shift+F7';
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
//                         CurrPage.SAVERECORD;
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
//             group("Credit Card")
//             {
//                 Caption = 'Credit Card';
//                 Image = CreditCardLog;
//                 action("Credit Cards Transaction Lo&g Entries")
//                 {
//                     Caption = 'Credit Cards Transaction Lo&g Entries';
//                     Image = CreditCardLog;
//                     RunObject = Page 829;
//                     RunPageLink = Document Type=FIELD(Document Type),
//                                   Document No.=FIELD(No.),
//                                   Customer No.=FIELD(Bill-to Customer No.);
//                 }
//             }
//         }
//         area(processing)
//         {
//             group(Release)
//             {
//                 Caption = 'Release';
//                 Image = ReleaseDoc;
//                 action(Release)
//                 {
//                     Caption = 'Re&lease';
//                     Image = ReleaseDoc;
//                     Promoted = true;
//                     PromotedCategory = Process;
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
//                 action(GetPostedDocumentLinesToReverse)
//                 {
//                     Caption = 'Get Posted Doc&ument Lines to Reverse';
//                     Ellipsis = true;
//                     Image = ReverseLines;

//                     trigger OnAction()
//                     begin
//                         GetPstdDocLinesToRevere;
//                     end;
//                 }
//                 action("Calculate &Invoice Discount")
//                 {
//                     Caption = 'Calculate &Invoice Discount';
//                     Image = CalculateInvoiceDiscount;

//                     trigger OnAction()
//                     begin
//                         ApproveCalcInvDisc;
//                     end;
//                 }
//                 separator()
//                 {
//                 }
//                 action(ApplyEntries)
//                 {
//                     Caption = 'Apply Entries';
//                     Ellipsis = true;
//                     Image = ApplyEntries;
//                     Promoted = true;
//                     PromotedCategory = Process;
//                     ShortCutKey = 'Shift+F11';

//                     trigger OnAction()
//                     begin
//                         CODEUNIT.RUN(CODEUNIT::"Sales Header Apply",Rec);
//                     end;
//                 }
//                 separator()
//                 {
//                 }
//                 action("Get St&d. Cust. Sales Codes")
//                 {
//                     Caption = 'Get St&d. Cust. Sales Codes';
//                     Ellipsis = true;
//                     Image = CustomerCode;

//                     trigger OnAction()
//                     var
//                         StdCustSalesCode: Record "172";
//                     begin
//                         StdCustSalesCode.InsertSalesLines(Rec);
//                     end;
//                 }
//                 separator()
//                 {
//                 }
//                 action(CopyDocument)
//                 {
//                     Caption = 'Copy Document';
//                     Ellipsis = true;
//                     Image = CopyDocument;
//                     Promoted = true;
//                     PromotedCategory = Process;

//                     trigger OnAction()
//                     begin
//                         CopySalesDoc.SetSalesHeader(Rec);
//                         CopySalesDoc.RUNMODAL;
//                         CLEAR(CopySalesDoc);
//                     end;
//                 }
//                 action("Move Negative Lines")
//                 {
//                     Caption = 'Move Negative Lines';
//                     Ellipsis = true;
//                     Image = MoveNegativeLines;

//                     trigger OnAction()
//                     begin
//                         CLEAR(MoveNegSalesLines);
//                         MoveNegSalesLines.SetSalesHeader(Rec);
//                         MoveNegSalesLines.RUNMODAL;
//                         MoveNegSalesLines.ShowDocument;
//                     end;
//                 }
//                 separator()
//                 {
//                 }
//             }
//             group(Approval)
//             {
//                 Caption = 'Approval';
//                 Image = Approval;
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
//                         Post(CODEUNIT::"Sales-Post (Yes/No)");
//                     end;
//                 }
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
//                 action("Print Credit Note")
//                 {
//                     Caption = 'Print Credit Note';
//                     Ellipsis = true;
//                     Image = TestReport;
//                     //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
//                     //PromotedCategory = "Report";

//                     trigger OnAction()
//                     begin
//                          T_REC.RESET;
//                                                          T_REC.SETRANGE(T_REC."No.","No.");
//                                                          T_REC.FIND('-');
//                                                          REPORT.RUNMODAL(50004,TRUE,FALSE,T_REC);
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
//                         Post(CODEUNIT::"Sales-Post + Print");
//                     end;
//                 }
//                 action("Post &Batch")
//                 {
//                     Caption = 'Post &Batch';
//                     Ellipsis = true;
//                     Image = PostBatch;

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
//                     Visible = JobQueueVisible;

//                     trigger OnAction()
//                     begin
//                         CancelBackgroundPosting;
//                     end;
//                 }
//             }
//         }
//     }

//     trigger OnAfterGetRecord()
//     begin
//         JobQueueVisible := "Job Queue Status" = "Job Queue Status"::"Scheduled for Posting";
//     end;

//     trigger OnDeleteRecord(): Boolean
//     begin
//         CurrPage.SAVERECORD;
//         EXIT(ConfirmDeletion);
//     end;

//     trigger OnNewRecord(BelowxRec: Boolean)
//     begin
//         "Responsibility Center" := UserMgt.GetSalesFilter;
//     end;

//     trigger OnOpenPage()
//     begin
//         IF UserMgt.GetSalesFilter <> '' THEN BEGIN
//           FILTERGROUP(2);
//           SETRANGE("Responsibility Center",UserMgt.GetSalesFilter);
//           FILTERGROUP(0);
//         END;
//     end;

//     var
//         ChangeExchangeRate: Page "511";
//         CopySalesDoc: Report "292";
//         MoveNegSalesLines: Report "6699";
//         ReportPrint: Codeunit "228";
//         UserMgt: Codeunit "5700";
//         [InDataSet]
//         JobQueueVisible: Boolean;
//         T_REC: Record "36";

//     local procedure Post(PostingCodeunitID: Integer)
//     begin
//         SendToPosting(PostingCodeunitID);
//         IF "Job Queue Status" = "Job Queue Status"::"Scheduled for Posting" THEN
//           CurrPage.CLOSE;
//         CurrPage.UPDATE(FALSE);
//     end;

//     local procedure ApproveCalcInvDisc()
//     begin
//         CurrPage.SalesLines.PAGE.ApproveCalcInvDisc;
//     end;

//     local procedure SelltoCustomerNoOnAfterValidat()
//     begin
//         IF GETFILTER("Sell-to Customer No.") = xRec."Sell-to Customer No." THEN
//           IF "Sell-to Customer No." <> xRec."Sell-to Customer No." THEN
//             SETRANGE("Sell-to Customer No.");
//         CurrPage.UPDATE;
//     end;

//     local procedure SalespersonCodeOnAfterValidate()
//     begin
//         CurrPage.SalesLines.PAGE.UpdateForm(TRUE);
//     end;

//     local procedure BilltoCustomerNoOnAfterValidat()
//     begin
//         CurrPage.UPDATE;
//     end;

//     local procedure ShortcutDimension1CodeOnAfterV()
//     begin
//         CurrPage.UPDATE;
//     end;

//     local procedure ShortcutDimension2CodeOnAfterV()
//     begin
//         CurrPage.UPDATE;
//     end;

//     local procedure PricesIncludingVATOnAfterValid()
//     begin
//         CurrPage.UPDATE;
//     end;
// }

