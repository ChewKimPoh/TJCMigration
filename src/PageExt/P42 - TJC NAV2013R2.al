// page 42 "Sales Order"
// {
//     // TJCSG1.00
//     // NAV 2013 R2 Upgrade.
//     // Last Changes: 30/06/2014.
//     //  1. 25/02/2011  dp.ds
//     //     REF: DP-03266-FHY3S1
//     //     - Created new menu item Functions->Create Sales Lines to automatically generate sales
//     //       order lines from Item card.
//     //  2. 07/04/2014 DP.JL DD#86
//     //     - Change Run modal to run
//     //     - Temp commented out report.
//     //  3. 05/09/2014  dp.dst
//     //     - Enhanced the codes in function "AssignAllLotNo" to optimise the codes and removed any unnecessary codes.
//     //  4. DP.NCM TJC# 427 04/09/2017

//     Caption = 'Sales Order';
//     PageType = Document;
//     RefreshOnActivate = true;
//     SourceTable = Table36;
//     SourceTableView = WHERE(Document Type=FILTER(Order));

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
//                     Importance = Additional;

//                     trigger OnValidate()
//                     begin
//                         IF GETFILTER("Sell-to Contact No.") = xRec."Sell-to Contact No." THEN
//                           IF "Sell-to Contact No." <> xRec."Sell-to Contact No." THEN
//                             SETRANGE("Sell-to Contact No.");
//                     end;
//                 }
//                 field("Sell-to Customer Name";"Sell-to Customer Name")
//                 {
//                     QuickEntry = false;
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
//                     QuickEntry = false;
//                 }
//                 field("Sell-to Contact";"Sell-to Contact")
//                 {
//                     Importance = Additional;
//                 }
//                 field("No Picking List";"No Picking List")
//                 {
//                 }
//                 field("No. of Archived Versions";"No. of Archived Versions")
//                 {
//                     Importance = Additional;
//                 }
//                 field("Posting Date";"Posting Date")
//                 {
//                     QuickEntry = false;
//                     Style = StrongAccent;
//                     StyleExpr = TRUE;
//                 }
//                 field("Order Date";"Order Date")
//                 {
//                     Importance = Promoted;
//                     QuickEntry = false;
//                     Style = StrongAccent;
//                     StyleExpr = TRUE;
//                 }
//                 field("Document Date";"Document Date")
//                 {
//                     QuickEntry = false;
//                     Style = StrongAccent;
//                     StyleExpr = TRUE;
//                 }
//                 field("Requested Delivery Date";"Requested Delivery Date")
//                 {
//                 }
//                 field("Promised Delivery Date";"Promised Delivery Date")
//                 {
//                     Importance = Additional;
//                 }
//                 field("Quote No.";"Quote No.")
//                 {
//                     Importance = Additional;
//                 }
//                 field("External Document No.";"External Document No.")
//                 {
//                     Importance = Promoted;
//                 }
//                 field("Salesperson Code";"Salesperson Code")
//                 {
//                     QuickEntry = false;
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
//                 field("Opportunity No.";"Opportunity No.")
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
//                     QuickEntry = false;
//                 }
//             }
//             part(SalesLines;46)
//             {
//                 Editable = DynamicEditable;
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
//                     Importance = Additional;
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
//                     Style = StrongAccent;
//                     StyleExpr = TRUE;
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
//                 field("Your Reference";"Your Reference")
//                 {
//                 }
//                 field("Location Code";"Location Code")
//                 {
//                 }
//                 field("Outbound Whse. Handling Time";"Outbound Whse. Handling Time")
//                 {
//                     Importance = Additional;
//                 }
//                 field("Shipment Method Code";"Shipment Method Code")
//                 {
//                 }
//                 field("Shipping Agent Code";"Shipping Agent Code")
//                 {
//                     Importance = Additional;
//                 }
//                 field("Shipping Agent Service Code";"Shipping Agent Service Code")
//                 {
//                     Importance = Additional;
//                 }
//                 field("Shipping Time";"Shipping Time")
//                 {
//                 }
//                 field("Late Order Shipping";"Late Order Shipping")
//                 {
//                     Importance = Additional;
//                 }
//                 field("Package Tracking No.";"Package Tracking No.")
//                 {
//                     Importance = Additional;
//                 }
//                 field("Shipment Date";"Shipment Date")
//                 {
//                     Importance = Promoted;
//                 }
//                 field("Shipping Advice";"Shipping Advice")
//                 {
//                     Importance = Promoted;

//                     trigger OnValidate()
//                     begin
//                         IF "Shipping Advice" <> xRec."Shipping Advice" THEN
//                           IF NOT CONFIRM(Text001,FALSE,FIELDCAPTION("Shipping Advice")) THEN
//                             ERROR(Text002);
//                     end;
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
//             group(Prepayment)
//             {
//                 Caption = 'Prepayment';
//                 field("Prepayment %";"Prepayment %")
//                 {
//                     Importance = Promoted;

//                     trigger OnValidate()
//                     begin
//                         Prepayment37OnAfterValidate;
//                     end;
//                 }
//                 field("Compress Prepayment";"Compress Prepayment")
//                 {
//                 }
//                 field("Prepmt. Payment Terms Code";"Prepmt. Payment Terms Code")
//                 {
//                 }
//                 field("Prepayment Due Date";"Prepayment Due Date")
//                 {
//                     Importance = Promoted;
//                 }
//                 field("Prepmt. Payment Discount %";"Prepmt. Payment Discount %")
//                 {
//                 }
//                 field("Prepmt. Pmt. Discount Date";"Prepmt. Pmt. Discount Date")
//                 {
//                 }
//             }
//         }
//         area(factboxes)
//         {
//             part(;9080)
//             {
//                 SubPageLink = No.=FIELD(Sell-to Customer No.);
//                 Visible = true;
//             }
//             part(;9082)
//             {
//                 SubPageLink = No.=FIELD(Bill-to Customer No.);
//                 Visible = false;
//             }
//             part(;9084)
//             {
//                 SubPageLink = No.=FIELD(Sell-to Customer No.);
//                 Visible = false;
//             }
//             part(;9087)
//             {
//                 Provider = SalesLines;
//                 SubPageLink = Document Type=FIELD(Document Type),
//                               Document No.=FIELD(Document No.),
//                               Line No.=FIELD(Line No.);
//                 Visible = true;
//             }
//             part(;9089)
//             {
//                 Provider = SalesLines;
//                 SubPageLink = No.=FIELD(No.);
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
//             part(;9109)
//             {
//                 Provider = SalesLines;
//                 SubPageLink = No.=FIELD(No.);
//                 Visible = false;
//             }
//             part(;9081)
//             {
//                 SubPageLink = No.=FIELD(Bill-to Customer No.);
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
//             group("O&rder")
//             {
//                 Caption = 'O&rder';
//                 Image = "Order";
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
//                         PAGE.RUNMODAL(PAGE::"Sales Order Statistics",Rec);
//                     end;
//                 }
//                 action(Card)
//                 {
//                     Caption = 'Card';
//                     Image = EditLines;
//                     RunObject = Page 21;
//                     RunPageLink = No.=FIELD(Sell-to Customer No.);
//                     ShortCutKey = 'Shift+F7';
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
//                 action("A&pprovals")
//                 {
//                     Caption = 'A&pprovals';
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
//                 action("Credit Cards Transaction Lo&g Entries")
//                 {
//                     Caption = 'Credit Cards Transaction Lo&g Entries';
//                     Image = CreditCardLog;
//                     RunObject = Page 829;
//                     RunPageLink = Document No.=FIELD(No.),
//                                   Customer No.=FIELD(Bill-to Customer No.);
//                 }
//                 action("Assembly Orders")
//                 {
//                     Caption = 'Assembly Orders';
//                     Image = AssemblyOrder;

//                     trigger OnAction()
//                     var
//                         AssembleToOrderLink: Record "904";
//                     begin
//                         AssembleToOrderLink.ShowAsmOrders(Rec);
//                     end;
//                 }
//             }
//             group(Documents)
//             {
//                 Caption = 'Documents';
//                 Image = Documents;
//                 action("S&hipments")
//                 {
//                     Caption = 'S&hipments';
//                     Image = Shipment;
//                     RunObject = Page 142;
//                     RunPageLink = Order No.=FIELD(No.);
//                     RunPageView = SORTING(Order No.);
//                 }
//                 action(Invoices)
//                 {
//                     Caption = 'Invoices';
//                     Image = Invoice;
//                     RunObject = Page 143;
//                     RunPageLink = Order No.=FIELD(No.);
//                     RunPageView = SORTING(Order No.);
//                 }
//             }
//             group(Warehouse)
//             {
//                 Caption = 'Warehouse';
//                 Image = Warehouse;
//                 action("In&vt. Put-away/Pick Lines")
//                 {
//                     Caption = 'In&vt. Put-away/Pick Lines';
//                     Image = PickLines;
//                     RunObject = Page 5774;
//                     RunPageLink = Source Document=CONST(Sales Order),
//                                   Source No.=FIELD(No.);
//                     RunPageView = SORTING(Source Document,Source No.,Location Code);
//                 }
//                 action("Whse. Shipment Lines")
//                 {
//                     Caption = 'Whse. Shipment Lines';
//                     Image = ShipmentLines;
//                     RunObject = Page 7341;
//                     RunPageLink = Source Type=CONST(37),
//                                   Source Subtype=FIELD(Document Type),
//                                   Source No.=FIELD(No.);
//                     RunPageView = SORTING(Source Type,Source Subtype,Source No.,Source Line No.);
//                 }
//             }
//             group(Prepayment)
//             {
//                 Caption = 'Prepayment';
//                 Image = Prepayment;
//                 action("Prepa&yment Invoices")
//                 {
//                     Caption = 'Prepa&yment Invoices';
//                     Image = PrepaymentInvoice;
//                     RunObject = Page 143;
//                     RunPageLink = Prepayment Order No.=FIELD(No.);
//                     RunPageView = SORTING(Prepayment Order No.);
//                 }
//                 action("Prepayment Credi&t Memos")
//                 {
//                     Caption = 'Prepayment Credi&t Memos';
//                     Image = PrepaymentCreditMemo;
//                     RunObject = Page 144;
//                     RunPageLink = Prepayment Order No.=FIELD(No.);
//                     RunPageView = SORTING(Prepayment Order No.);
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
//                     Promoted = true;
//                     PromotedCategory = Process;

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
//                 action("Calculate &Invoice Discount")
//                 {
//                     Caption = 'Calculate &Invoice Discount';
//                     Image = CalculateInvoiceDiscount;

//                     trigger OnAction()
//                     begin
//                         ApproveCalcInvDisc;
//                     end;
//                 }
//                 action("Auto Assign All Lot No.")
//                 {
//                     Caption = 'Auto Assign All Lot No.';
//                     Image = "Action";
//                     Promoted = true;

//                     trigger OnAction()
//                     begin
//                         AssignAllLotNo("No.");
//                     end;
//                 }
//                 action("Import RMS")
//                 {
//                     Caption = 'Import RMS';
//                     Image = "Action";
//                     Promoted = true;

//                     trigger OnAction()
//                     var
//                         ImportRMS: XMLport "50000";
//                     begin
//                         ImportRMS.SetDocumentNo("No.","Document Type");
//                         /*START TJCSG1.00 #3*/
//                         ImportRMS.RUN;
//                         //ImportRMS.RUNMODAL;
//                         /*END TJCSG1.00 #3*/
//                         CLEAR(ImportRMS);

//                     end;
//                 }
//                 action("Create Sales Lines")
//                 {
//                     Caption = 'Create Sales Lines';
//                     Image = "Action";
//                     Promoted = true;

//                     trigger OnAction()
//                     var
//                         LCreateSalesLines: Report "50006";
//                     begin
//                         // Start: TJCSG1.00 #1
//                         IF NOT CONFIRM(TJCSG_Text000,FALSE) THEN
//                           EXIT;

//                         CLEAR(LCreateSalesLines);
//                         LCreateSalesLines.GetSalesOrderNo("Document Type","No.");
//                         LCreateSalesLines.RUNMODAL;
//                         // End: TJCSG1.00 #1
//                     end;
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
//                 action("Archive Document")
//                 {
//                     Caption = 'Archi&ve Document';
//                     Image = Archive;

//                     trigger OnAction()
//                     begin
//                         ArchiveManagement.ArchiveSalesDocument(Rec);
//                         CurrPage.UPDATE(FALSE);
//                     end;
//                 }
//                 action("Send IC Sales Order Cnfmn.")
//                 {
//                     Caption = 'Send IC Sales Order Cnfmn.';
//                     Image = IntercompanyOrder;

//                     trigger OnAction()
//                     var
//                         ICInOutboxMgt: Codeunit "427";
//                         ApprovalMgt: Codeunit "439";
//                         PurchaseHeader: Record "38";
//                     begin
//                         IF ApprovalMgt.PrePostApprovalCheck(Rec,PurchaseHeader) THEN
//                           ICInOutboxMgt.SendSalesDoc(Rec,FALSE);
//                     end;
//                 }
//             }
//             group(Plan)
//             {
//                 Caption = 'Plan';
//                 Image = Planning;
//                 action("Order &Promising")
//                 {
//                     Caption = 'Order &Promising';
//                     Image = OrderPromising;

//                     trigger OnAction()
//                     var
//                         OrderPromisingLine: Record "99000880" temporary;
//                     begin
//                         OrderPromisingLine.SETRANGE("Source Type","Document Type");
//                         OrderPromisingLine.SETRANGE("Source ID","No.");
//                         PAGE.RUNMODAL(PAGE::"Order Promising Lines",OrderPromisingLine);
//                     end;
//                 }
//                 action("Demand Overview")
//                 {
//                     Caption = 'Demand Overview';
//                     Image = Forecast;

//                     trigger OnAction()
//                     var
//                         DemandOverview: Page "5830";
//                     begin
//                         DemandOverview.SetCalculationParameter(TRUE);
//                         DemandOverview.Initialize(0D,1,"No.",'','');
//                         DemandOverview.RUNMODAL;
//                     end;
//                 }
//                 action("Pla&nning")
//                 {
//                     Caption = 'Pla&nning';
//                     Image = Planning;

//                     trigger OnAction()
//                     var
//                         SalesPlanForm: Page "99000883";
//                     begin
//                         SalesPlanForm.SetSalesOrder("No.");
//                         SalesPlanForm.RUNMODAL;
//                     end;
//                 }
//             }
//             group(Request)
//             {
//                 Caption = 'Request';
//                 Image = SendApprovalRequest;
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
//                 group(Authorize)
//                 {
//                     Caption = 'Authorize';
//                     Image = AuthorizeCreditCard;
//                     action(Authorize)
//                     {
//                         Caption = 'Authorize';
//                         Image = AuthorizeCreditCard;

//                         trigger OnAction()
//                         begin
//                             Authorize;
//                         end;
//                     }
//                     action("Void A&uthorize")
//                     {
//                         Caption = 'Void A&uthorize';
//                         Image = VoidCreditCard;

//                         trigger OnAction()
//                         begin
//                             Void;
//                         end;
//                     }
//                 }
//             }
//             group(Warehouse)
//             {
//                 Caption = 'Warehouse';
//                 Image = Warehouse;
//                 action("Create Inventor&y Put-away / Pick")
//                 {
//                     Caption = 'Create Inventor&y Put-away / Pick';
//                     Ellipsis = true;
//                     Image = CreateInventoryPickup;
//                     Promoted = true;
//                     PromotedCategory = Process;

//                     trigger OnAction()
//                     begin
//                         CreateInvtPutAwayPick;

//                         IF NOT FIND('=><') THEN
//                           INIT;
//                     end;
//                 }
//                 action("Create &Whse. Shipment")
//                 {
//                     Caption = 'Create &Whse. Shipment';
//                     Image = NewShipment;

//                     trigger OnAction()
//                     var
//                         GetSourceDocOutbound: Codeunit "5752";
//                     begin
//                         GetSourceDocOutbound.CreateFromSalesOrder(Rec);

//                         IF NOT FIND('=><') THEN
//                           INIT;
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
//                     Ellipsis = true;
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
//                 action("Post and &Print")
//                 {
//                     Caption = 'Post and &Print';
//                     Ellipsis = true;
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
//                 action("Post &Batch")
//                 {
//                     Caption = 'Post &Batch';
//                     Ellipsis = true;
//                     Image = PostBatch;

//                     trigger OnAction()
//                     begin
//                         REPORT.RUNMODAL(REPORT::"Batch Post Sales Orders",TRUE,TRUE,Rec);
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
//                 group("Prepa&yment")
//                 {
//                     Caption = 'Prepa&yment';
//                     Image = Prepayment;
//                     action("Prepayment &Test Report")
//                     {
//                         Caption = 'Prepayment &Test Report';
//                         Ellipsis = true;
//                         Image = PrepaymentSimulation;

//                         trigger OnAction()
//                         begin
//                             ReportPrint.PrintSalesHeaderPrepmt(Rec);
//                         end;
//                     }
//                     action(PostPrepaymentInvoice)
//                     {
//                         Caption = 'Post Prepayment &Invoice';
//                         Ellipsis = true;
//                         Image = PrepaymentPost;

//                         trigger OnAction()
//                         var
//                             PurchaseHeader: Record "38";
//                             SalesPostYNPrepmt: Codeunit "443";
//                         begin
//                             IF ApprovalMgt.PrePostApprovalCheck(Rec,PurchaseHeader) THEN
//                               SalesPostYNPrepmt.PostPrepmtInvoiceYN(Rec,FALSE);
//                         end;
//                     }
//                     action("Post and Print Prepmt. Invoic&e")
//                     {
//                         Caption = 'Post and Print Prepmt. Invoic&e';
//                         Ellipsis = true;
//                         Image = PrepaymentPostPrint;

//                         trigger OnAction()
//                         var
//                             PurchaseHeader: Record "38";
//                             SalesPostYNPrepmt: Codeunit "443";
//                         begin
//                             IF ApprovalMgt.PrePostApprovalCheck(Rec,PurchaseHeader) THEN
//                               SalesPostYNPrepmt.PostPrepmtInvoiceYN(Rec,TRUE);
//                         end;
//                     }
//                     action(PostPrepaymentCreditMemo)
//                     {
//                         Caption = 'Post Prepayment &Credit Memo';
//                         Ellipsis = true;
//                         Image = PrepaymentPost;

//                         trigger OnAction()
//                         var
//                             PurchaseHeader: Record "38";
//                             SalesPostYNPrepmt: Codeunit "443";
//                         begin
//                             IF ApprovalMgt.PrePostApprovalCheck(Rec,PurchaseHeader) THEN
//                               SalesPostYNPrepmt.PostPrepmtCrMemoYN(Rec,FALSE);
//                         end;
//                     }
//                     action("Post and Print Prepmt. Cr. Mem&o")
//                     {
//                         Caption = 'Post and Print Prepmt. Cr. Mem&o';
//                         Ellipsis = true;
//                         Image = PrepaymentPostPrint;

//                         trigger OnAction()
//                         var
//                             PurchaseHeader: Record "38";
//                             SalesPostYNPrepmt: Codeunit "443";
//                         begin
//                             IF ApprovalMgt.PrePostApprovalCheck(Rec,PurchaseHeader) THEN
//                               SalesPostYNPrepmt.PostPrepmtCrMemoYN(Rec,TRUE);
//                         end;
//                     }
//                 }
//             }
//             group("&Print")
//             {
//                 Caption = '&Print';
//                 Image = Print;
//                 action("Order Confirmation")
//                 {
//                     Caption = 'Order Confirmation';
//                     Ellipsis = true;
//                     Image = Print;

//                     trigger OnAction()
//                     begin
//                         DocPrint.PrintSalesOrder(Rec,Usage::"Order Confirmation");
//                     end;
//                 }
//                 action("Work Order")
//                 {
//                     Caption = 'Work Order';
//                     Ellipsis = true;
//                     Image = Print;

//                     trigger OnAction()
//                     begin
//                         DocPrint.PrintSalesOrder(Rec,Usage::"Work Order");
//                     end;
//                 }
//                 action("Pick Instruction")
//                 {
//                     Caption = 'Pick Instruction';
//                     Image = Print;

//                     trigger OnAction()
//                     begin
//                         DocPrint.PrintSalesOrder(Rec,Usage::"Pick Instruction");
//                     end;
//                 }
//                 action("Order Confirmation TJC")
//                 {
//                     Caption = 'Order Confirmation TJC';
//                     Image = "Report";
//                     Promoted = true;
//                     PromotedIsBig = true;

//                     trigger OnAction()
//                     begin
//                         //{Start:TJC1.00 DP.CST}
//                         recSalesHeader.RESET;
//                         recSalesHeader.SETRANGE("Document Type","Document Type");
//                         recSalesHeader.SETRANGE("No.","No.");
//                         IF recSalesHeader.FINDFIRST THEN
//                           REPORT.RUNMODAL(50038,TRUE,FALSE,recSalesHeader);
//                     end;
//                 }
//             }
//         }
//     }

//     trigger OnAfterGetCurrRecord()
//     begin
//         DynamicEditable := CurrPage.EDITABLE;
//     end;

//     trigger OnAfterGetRecord()
//     begin
//         JobQueueVisible := "Job Queue Status" = "Job Queue Status"::"Scheduled for Posting";
//     end;

//     trigger OnDeleteRecord(): Boolean
//     begin
//         CurrPage.SAVERECORD;
//         EXIT(ConfirmDeletion);
//     end;

//     trigger OnInsertRecord(BelowxRec: Boolean): Boolean
//     begin
//         CheckCreditMaxBeforeInsert;
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

//         SETRANGE("Date Filter",0D,WORKDATE - 1);
//     end;

//     var
//         Text000: Label 'Unable to execute this function while in view only mode.';
//         CopySalesDoc: Report "292";
//         MoveNegSalesLines: Report "6699";
//         ApprovalMgt: Codeunit "439";
//         ReportPrint: Codeunit "228";
//         DocPrint: Codeunit "229";
//         ArchiveManagement: Codeunit "5063";
//         ChangeExchangeRate: Page "511";
//         UserMgt: Codeunit "5700";
//         Usage: Option "Order Confirmation","Work Order","Pick Instruction";
//         [InDataSet]
//         JobQueueVisible: Boolean;
//         Text001: Label 'Do you want to change %1 in all related records in the warehouse?';
//         Text002: Label 'The update has been interrupted to respect the warning.';
//         DynamicEditable: Boolean;
//         "--- TJCSG Constants ---": ;
//         TJCSG_Text000: Label 'Are you sure you wish to create Sales Order lines automatically?';
//         recSalesHeader: Record "36";

//     local procedure Post(PostingCodeunitID: Integer)
//     begin
//         SendToPosting(PostingCodeunitID);
//         IF "Job Queue Status" = "Job Queue Status"::"Scheduled for Posting" THEN
//           CurrPage.CLOSE;
//         CurrPage.UPDATE(FALSE);
//     end;

//     procedure UpdateAllowed(): Boolean
//     begin
//         IF CurrPage.EDITABLE = FALSE THEN
//           ERROR(Text000);
//         EXIT(TRUE);
//     end;

//     procedure AssignAllLotNo(No: Text[30])
//     var
//         T_SalesLine: Record "37";
//         ItemTrackingMgmt: Codeunit "6500";
//     begin
//         T_SalesLine.RESET;
//         /*Start: TJCSG1.00 #3*/
//         T_SalesLine.SETCURRENTKEY("Document Type","Document No.",Type,"No.");
//         /*End: TJCSG1.00 #3*/
//         T_SalesLine.SETRANGE("Document Type",T_SalesLine."Document Type"::Order);
//         T_SalesLine.SETRANGE("Document No.",No);
//         T_SalesLine.SETRANGE(Type,T_SalesLine.Type::Item);
//         T_SalesLine.SETFILTER("No.",'<>%1','');
//         // IF T_SalesLine.FIND('-') THEN
//         IF T_SalesLine.FINDSET THEN
//           REPEAT
//             /*Start: TJCSG1.00 #3*/
//             // IF T_SalesLine.Type <> T_SalesLine.Type::" " THEN Begin  // unnecessary as it was already filtered by Type = Item.
//             // T_SalesLine.TESTFIELD(Type,T_SalesLine.Type::Item);      // unnecessary as it was already filtered by Type = Item.
//             // T_SalesLine.TESTFIELD("No.");                            // unnecessary as the Item No. will never be empty.
//             /*End: TJCSG1.00 #3*/
//             T_SalesLine.TESTFIELD("Quantity (Base)");
//             ItemTrackingMgmt.AutoAssignLotNo(T_SalesLine,1);
//           UNTIL T_SalesLine.NEXT = 0;

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

//     local procedure Prepayment37OnAfterValidate()
//     begin
//         CurrPage.UPDATE;
//     end;

//     procedure CheckSalesperson()
//     begin
//         IF "Salesperson Code" = '' THEN //DP.NCM TJC# 427 04/09/2017
//           ERROR('DP: Salesperson cannot be blank.');
//     end;
// }

