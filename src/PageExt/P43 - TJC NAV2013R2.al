// page 43 "Sales Invoice"
// {
//     // TJCSG1.00
//     // NAV 2013 R2 Upgrade
//     // Last Changes: 12/08/2014.
//     //  1. 28/02/2011  dp.ds
//     //     REF: DP-03266-FHY3S1
//     //     - Created new menu item Functions->Create Sales Lines to automatically generate sales
//     //       order lines from Item card.
//     //  2. 07/04/2014  DP.JL DD#86
//     //     - Commented out dialog
//     //  3. 05/08/2014  dp.dst
//     //     - Created the action to Create Sales Invoice Lines & Import Sales Inv. Lines from Excel.
//     //     - Needs to change the way Excel reads the content of the worksheet as the old method is not working in NAV 2013 R2.
//     //     - Created new action:
//     //       - Import Excel from CSV that uses XMLport as TJC does not have latest Excel program that can save the file to XLSX due
//     //         to old Excel format (XLS) is no longer supported in NAV 2013 R2.
//     //     - Renamed the existing action to "Import Excel from XLSX".
//     //  4. 08/09/2014  dp.dst
//     //     TJC DD #234
//     //     - Enhanced the codes in function "AssignAllLotNo".
//     //  5. DP.NCM 30/11/2016 TJC #385
//     //  6. DP.NCM TJC# 427 04/09/2017

//     Caption = 'Sales Invoice';
//     PageType = Document;
//     RefreshOnActivate = true;
//     SourceTable = Table36;
//     SourceTableView = WHERE(Document Type=FILTER(Invoice));

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
//                     Style = StrongAccent;
//                     StyleExpr = TRUE;

//                     trigger OnAssistEdit()
//                     begin
//                         IF AssistEdit(xRec) THEN
//                           CurrPage.UPDATE;
//                     end;
//                 }
//                 field("Sell-to Customer No.";"Sell-to Customer No.")
//                 {
//                     Importance = Promoted;
//                     Style = StrongAccent;
//                     StyleExpr = TRUE;

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
//                     Style = StrongAccent;
//                     StyleExpr = TRUE;
//                 }
//                 field("Document Date";"Document Date")
//                 {
//                     Style = StrongAccent;
//                     StyleExpr = TRUE;
//                 }
//                 field("Incoming Document Entry No.";"Incoming Document Entry No.")
//                 {
//                     Visible = false;
//                 }
//                 field("External Document No.";"External Document No.")
//                 {
//                     Importance = Promoted;
//                     Style = StrongAccent;
//                     StyleExpr = TRUE;
//                 }
//                 field("Salesperson Code";"Salesperson Code")
//                 {
//                     Style = StrongAccent;
//                     StyleExpr = TRUE;

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
//             part(SalesLines;47)
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
//                 field("Last Posting No.";"Last Posting No.")
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
//                     Style = StrongAccent;
//                     StyleExpr = TRUE;

//                     trigger OnValidate()
//                     begin
//                         ShortcutDimension1CodeOnAfterV;
//                     end;
//                 }
//                 field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
//                 {
//                     Style = StrongAccent;
//                     StyleExpr = TRUE;

//                     trigger OnValidate()
//                     begin
//                         ShortcutDimension2CodeOnAfterV;
//                     end;
//                 }
//                 field("Payment Terms Code";"Payment Terms Code")
//                 {
//                     Importance = Promoted;
//                     Style = StrongAccent;
//                     StyleExpr = TRUE;
//                 }
//                 field("Due Date";"Due Date")
//                 {
//                     Importance = Promoted;
//                     Style = StrongAccent;
//                     StyleExpr = TRUE;
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
//                 field("Direct Debit Mandate ID";"Direct Debit Mandate ID")
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
//                     Style = StrongAccent;
//                     StyleExpr = TRUE;
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
//                 field("Ship-to Code";"Ship-to Code")
//                 {
//                     Importance = Promoted;
//                 }
//                 field("Ship-to Name";"Ship-to Name")
//                 {
//                     Style = StrongAccent;
//                     StyleExpr = TRUE;
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
//                 field("Shipment Method Code";"Shipment Method Code")
//                 {
//                 }
//                 field("Shipping Agent Code";"Shipping Agent Code")
//                 {
//                 }
//                 field("Package Tracking No.";"Package Tracking No.")
//                 {
//                     Importance = Additional;
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
//                 SubPageLink = No.=FIELD(Bill-to Customer No.);
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
//             part(;9089)
//             {
//                 Provider = SalesLines;
//                 SubPageLink = No.=FIELD(No.);
//                 Visible = true;
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
//             group("&Invoice")
//             {
//                 Caption = '&Invoice';
//                 Image = Invoice;
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
//                 action(Customer)
//                 {
//                     Caption = 'Customer';
//                     Image = Customer;
//                     RunObject = Page 21;
//                     RunPageLink = No.=FIELD(Sell-to Customer No.);
//                     ShortCutKey = 'Shift+F7';
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
//                 action("Co&mments")
//                 {
//                     Caption = 'Co&mments';
//                     Image = ViewComments;
//                     RunObject = Page 67;
//                     RunPageLink = Document Type=FIELD(Document Type),
//                                   No.=FIELD(No.),
//                                   Document Line No.=CONST(0);
//                 }
//                 separator()
//                 {
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
//                 separator()
//                 {
//                 }
//                 action("Create Sales Lines")
//                 {
//                     Caption = 'Create Sales Lines';
//                     Image = CreateLinesFromJob;

//                     trigger OnAction()
//                     var
//                         LCreateSalesLines: Report "50006";
//                     begin
//                         // Start: TJCSG1.00 #3
//                         IF NOT CONFIRM(TJCSG_Text000,FALSE) THEN
//                           EXIT;

//                         CLEAR(LCreateSalesLines);
//                         LCreateSalesLines.GetSalesOrderNo("Document Type","No.");
//                         LCreateSalesLines.RUNMODAL;
//                         // End: TJCSG1.00 #3
//                     end;
//                 }
//                 separator()
//                 {
//                 }
//                 action("Import Excel (XLSX)")
//                 {
//                     Caption = 'Import Excel (XLSX)';
//                     Image = ImportExcel;

//                     trigger OnAction()
//                     begin
//                         /*Start: TJCSG1.00 #3*/
//                         IF CONFIRM(TJCSG_Text003,FALSE) THEN
//                           ImportExcelData;
//                         /*End: TJCSG1.00 #3*/

//                     end;
//                 }
//                 action("Import Excel (CSV)")
//                 {
//                     Caption = 'Import Excel (CSV)';
//                     Image = Import;
//                     Visible = false;

//                     trigger OnAction()
//                     begin
//                         /*Start: TJCSG1.00 #3*/
//                         CLEAR(ImportSalesInvLines);
//                         ImportSalesInvLines.GetParams("No.","Document Type","Location Code");
//                         ImportSalesInvLines.RUN;
//                         /*End: TJCSG1.00 #3*/

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
//                 separator()
//                 {
//                 }
//             }
//             group("F&unctions")
//             {
//                 Caption = 'F&unctions';
//                 Image = "Action";
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
//                 action("Copy Document")
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
//                 action("Export Line")
//                 {
//                     Image = ExportShipment;
//                     Promoted = true;
//                     PromotedCategory = Process;
//                     PromotedIsBig = true;

//                     trigger OnAction()
//                     var
//                         pPageExport: Page "50054";
//                     begin
//                         pPageExport.SetSINo("No.");
//                         pPageExport.GenerateList;
//                         pPageExport.RUN;
//                     end;
//                 }
//             }
//             group("Credit Card")
//             {
//                 Caption = 'Credit Card';
//                 Image = AuthorizeCreditCard;
//                 action(Authorize)
//                 {
//                     Caption = 'Authorize';
//                     Image = AuthorizeCreditCard;

//                     trigger OnAction()
//                     begin
//                         Authorize;
//                     end;
//                 }
//                 action("Void A&uthorize")
//                 {
//                     Caption = 'Void A&uthorize';
//                     Image = VoidCreditCard;

//                     trigger OnAction()
//                     begin
//                         Void;
//                     end;
//                 }
//             }
//             group("P&osting")
//             {
//                 Caption = 'P&osting';
//                 Image = Post;
//                 action(Post)
//                 {
//                     Caption = 'P&ost';
//                     Image = PostOrder;
//                     Promoted = true;
//                     PromotedCategory = Process;
//                     PromotedIsBig = true;
//                     ShortCutKey = 'F9';

//                     trigger OnAction()
//                     begin
//                         CheckSalesperson; //DP.NCM TJC #427
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
//                 action("Print Invoice")
//                 {
//                     Caption = 'Print Invoice';
//                     Image = ReOpen;

//                     trigger OnAction()
//                     begin
//                         T_REC.RESET;
//                         T_REC.SETRANGE(T_REC."No.","No.");
//                         T_REC.FIND('-');

//                         REPORT.RUNMODAL(50001,TRUE,FALSE,T_REC);
//                     end;
//                 }
//                 action("Auto Assign Lot")
//                 {
//                     Caption = 'Auto Assign Lot';
//                     Image = "Action";
//                     Promoted = true;

//                     trigger OnAction()
//                     begin
//                         AssignAllLotNo("No.","Document Type");
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
//                         CheckSalesperson; //DP.NCM TJC #427
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
//                         REPORT.RUNMODAL(REPORT::"Batch Post Sales Invoices",TRUE,TRUE,Rec);
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
//         T_REC: Record "36";
//         BinContent: Record "7302";
//         ChangeExchangeRate: Page "511";
//         CopySalesDoc: Report "292";
//         MoveNegSalesLines: Report "6699";
//         ReportPrint: Codeunit "228";
//         UserMgt: Codeunit "5700";
//         FileManagement: Codeunit "419";
//         ImportSalesInvLines: XMLport "50002";
//         [InDataSet]
//         JobQueueVisible: Boolean;
//         "--- TJCSG Constants ---": ;
//         TJCSG_Text000: Label 'Are you sure you wish to create Sales Invoice lines automatically?';
//         TJCSG_Text001: Label 'Import from Excel File';
//         TJCSG_Text002: Label 'Item No. %1 cannot be found in Bin Content Location %2 & Bin Code %3.';
//         TJCSG_Text003: Label 'This program does not support the old Excel format (XLS). \The Excel format must be in XLSX if you wish to run this program. \Do you wish to continue?';

//     local procedure Post(PostingCodeunitID: Integer)
//     begin
//         SendToPosting(PostingCodeunitID);
//         IF "Job Queue Status" = "Job Queue Status"::"Scheduled for Posting" THEN
//           CurrPage.CLOSE;
//         CurrPage.UPDATE(FALSE);
//     end;

//     local procedure AssignAllLotNo(No: Text[30];Type: Option)
//     var
//         LSalesLine: Record "37";
//         ItemTrackingMgmt: Codeunit "6500";
//     begin
//         /*Start: TJCSG1.00 #4*/
//         // Optimise the following codes and removed all unnecessary codes.
//         /*
//         //DP
//         T_SalesLine.RESET;
//         T_SalesLine.SETRANGE("Document Type" , Type);
//         T_SalesLine.SETRANGE("Document No." , No);
//         IF T_SalesLine.FIND('-') THEN
//         REPEAT
//         IF T_SalesLine.Type <> T_SalesLine.Type::" " THEN
//         BEGIN
//             T_SalesLine.TESTFIELD(Type,T_SalesLine.Type::Item);
//             T_SalesLine.TESTFIELD("No.");
//             T_SalesLine.TESTFIELD("Quantity (Base)");
//             ItemTrackingMgmt.AutoAssignLotNo(T_SalesLine,2);
//         END;
//         UNTIL T_SalesLine.NEXT = 0;
//         */
//         LSalesLine.RESET;
//         LSalesLine.SETCURRENTKEY("Document Type","Document No.",Type,"No.");
//         LSalesLine.SETRANGE("Document Type",Type);
//         LSalesLine.SETRANGE("Document No.","No.");
//         LSalesLine.SETRANGE(Type,LSalesLine.Type::Item);
//         LSalesLine.SETFILTER("No.",'<>%1','');
//         LSalesLine.SETFILTER("Quantity (Base)",'<>%1',0);
//         IF LSalesLine.FINDSET THEN
//           REPEAT
//             ItemTrackingMgmt.AutoAssignLotNo(LSalesLine,2);
//           UNTIL LSalesLine.NEXT = 0;
//         /*End: TJCSG1.00 #4*/

//     end;

//     procedure ImportExcelData()
//     var
//         lrecExcelBuffer: Record "370";
//         lrecSalesLine: Record "37";
//         lWinDialog: Dialog;
//         lExcelFileName: Text[1024];
//         lSheetName: Text[250];
//         lItemNo: Code[30];
//         lQuantity: Decimal;
//         LastRowNo: Integer;
//         lLineNo: Integer;
//         lImportedLines: Integer;
//         lTotalLines: Integer;
//         lTxt63000: Label 'Import is successful, there are %1 imported lines out of %2.';
//     begin
//         //ImportExcelData                   DP.EDS #1

//         lrecExcelBuffer.RESET;
//         lrecExcelBuffer.DELETEALL;

//         /*START TJCSG1.00 #3*/
//         // Needs to replace the following codes as they are no longer available in NAV 2013 R2. Common Dialog Management codeunit is deprecated feature in NAV 2013 R2.
//         // lcduCommonDialog  -> Codeunit412
//         // CLEAR(lcduCommonDialog);
//         // lExcelFileName := lcduCommonDialog.OpenFile('Open file', '', 0, '', 0);
//         CLEAR (FileManagement);
//         //lExcelFileName := FileManagement.OpenFileDialog(TJCSG_Text001,lExcelFileName,FileManagement.GetToFilterText('','.xls'));
//         lExcelFileName := FileManagement.UploadFile(TJCSG_Text001,'.xlsx');
//         /*END TJCSG1.00 #3*/

//         lSheetName := lrecExcelBuffer.SelectSheetsName(lExcelFileName);
//         lrecExcelBuffer.OpenBook(lExcelFileName,lSheetName);
//         lrecExcelBuffer.ReadSheet;

//         //-- Find last record & identify if it is totaling
//         lrecExcelBuffer.RESET;
//         IF lrecExcelBuffer.FIND('+') THEN BEGIN
//           LastRowNo := lrecExcelBuffer."Row No.";
//           lrecExcelBuffer.RESET;
//           lrecExcelBuffer.SETRANGE("Row No.", LastRowNo);
//           lrecExcelBuffer.SETRANGE("Column No.", 1);
//           IF NOT lrecExcelBuffer.FIND('-') THEN
//             LastRowNo := LastRowNo - 1;
//         END;

//         lLineNo := 0;
//         lrecSalesLine.RESET;
//         lrecSalesLine.SETRANGE("Document Type", "Document Type");
//         lrecSalesLine.SETRANGE("Document No.", "No.");
//         IF lrecSalesLine.FIND('+') THEN
//           lLineNo := lrecSalesLine."Line No.";

//         lWinDialog.OPEN('#1#############');

//         lImportedLines := 0;
//         lTotalLines := 0;
//         //-- Apply Filterings
//         lrecExcelBuffer.RESET;
//         lrecExcelBuffer.SETFILTER("Row No.", '%1..%2', 3, LastRowNo);
//         lrecExcelBuffer.SETFILTER("Column No.", '1|5');
//         IF lrecExcelBuffer.FIND('-') THEN REPEAT
//           lWinDialog.UPDATE(1, lrecExcelBuffer."Cell Value as Text");
//           lItemNo := lrecExcelBuffer."Cell Value as Text";

//           IF lrecExcelBuffer."Column No." = 1 THEN BEGIN
//             LastRowNo := lrecExcelBuffer."Row No.";
//             lrecExcelBuffer.NEXT;
//             lTotalLines += 1;
//           END;

//           IF (lrecExcelBuffer."Column No." = 5) AND (lrecExcelBuffer."Cell Value as Text" <> '0') THEN BEGIN
//             EVALUATE(lQuantity, lrecExcelBuffer."Cell Value as Text");

//             lLineNo += 10000;
//             lrecSalesLine.INIT;
//             lrecSalesLine.VALIDATE("Document Type", "Document Type");
//             lrecSalesLine.VALIDATE("Document No.", "No.");
//             lrecSalesLine."Line No." := lLineNo;

//             lrecSalesLine.VALIDATE(Type, lrecSalesLine.Type::Item);
//             lrecSalesLine.VALIDATE("No.", lItemNo);
//             /*Start: TJCSG1.00 #3*/
//             // Changed the sequence for Location & Bin Code. Checked if the Bin Content is valid too
//             // lrecSalesLine.VALIDATE("Bin Code", lSheetName);
//             // lrecSalesLine.VALIDATE("Location Code", "Location Code");
//             BinContent.RESET;
//             BinContent.SETRANGE("Location Code","Location Code");
//             BinContent.SETRANGE("Item No.",lItemNo);
//             BinContent.SETRANGE("Bin Code",lSheetName);
//             IF NOT BinContent.FINDSET THEN
//               ERROR(STRSUBSTNO(
//                 TJCSG_Text002,lItemNo,"Location Code",lSheetName));

//             lrecSalesLine.VALIDATE("Location Code", "Location Code");
//             lrecSalesLine.VALIDATE("Bin Code", lSheetName);
//             /*End: TJCSG1.00 #3*/

//             lrecSalesLine.VALIDATE(Quantity, lQuantity);

//             IF LastRowNo = lrecExcelBuffer."Row No." THEN BEGIN
//               //IF lrecSalesLine.Quantity > 0 THEN BEGIN  //DP.NCM 30/11/2016 TJC #385 - Comment out
//                 IF lrecSalesLine."Bin Code" <> lSheetName THEN
//                   lrecSalesLine."Bin Code" := lSheetName;
//                 lrecSalesLine.INSERT(TRUE);
//                 lImportedLines += 1;
//               //END;
//             END;
//           END;
//         UNTIL lrecExcelBuffer.NEXT = 0;
//         lWinDialog.CLOSE;

//         MESSAGE(STRSUBSTNO(lTxt63000, lImportedLines, lTotalLines));

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

//     procedure CheckSalesperson()
//     begin
//         IF "Salesperson Code" = '' THEN //DP.NCM TJC# 427 04/09/2017
//           ERROR('DP: Salesperson cannot be blank.');
//     end;
// }

