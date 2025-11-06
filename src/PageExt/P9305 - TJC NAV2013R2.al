// page 9305 "Sales Order List"
// {
//     Caption = 'Sales Orders';
//     CardPageID = "Sales Order";
//     Editable = false;
//     PageType = List;
//     SourceTable = Table36;
//     SourceTableView = WHERE(Document Type=CONST(Order));

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
//                 field("Assigned User ID";"Assigned User ID")
//                 {
//                 }
//                 field("Currency Code";"Currency Code")
//                 {
//                     Visible = false;
//                 }
//                 field(Amount;Amount)
//                 {
//                 }
//                 field("Amount Including VAT";"Amount Including VAT")
//                 {
//                 }
//                 field("Document Date";"Document Date")
//                 {
//                     Visible = false;
//                 }
//                 field("Requested Delivery Date";"Requested Delivery Date")
//                 {
//                     Visible = false;
//                 }
//                 field("Campaign No.";"Campaign No.")
//                 {
//                     Visible = false;
//                 }
//                 field(Status;Status)
//                 {
//                 }
//                 field("Payment Terms Code";"Payment Terms Code")
//                 {
//                     Visible = false;
//                 }
//                 field("Due Date";"Due Date")
//                 {
//                     Visible = false;
//                 }
//                 field("Payment Discount %";"Payment Discount %")
//                 {
//                     Visible = false;
//                 }
//                 field("Shipment Method Code";"Shipment Method Code")
//                 {
//                     Visible = false;
//                 }
//                 field("Shipping Agent Code";"Shipping Agent Code")
//                 {
//                     Visible = false;
//                 }
//                 field("Shipment Date";"Shipment Date")
//                 {
//                     Visible = false;
//                 }
//                 field("Shipping Advice";"Shipping Advice")
//                 {
//                     Visible = false;
//                 }
//                 field("Completely Shipped";"Completely Shipped")
//                 {
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
//             group("O&rder")
//             {
//                 Caption = 'O&rder';
//                 Image = "Order";
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
//             group(Warehouse)
//             {
//                 Caption = 'Warehouse';
//                 Image = Warehouse;
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
//                 action("In&vt. Put-away/Pick Lines")
//                 {
//                     Caption = 'In&vt. Put-away/Pick Lines';
//                     Image = PickLines;
//                     RunObject = Page 5774;
//                     RunPageLink = Source Document=CONST(Sales Order),
//                                   Source No.=FIELD(No.);
//                     RunPageView = SORTING(Source Document,Source No.,Location Code);
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
//                 action("Pla&nning")
//                 {
//                     Caption = 'Pla&nning';
//                     Image = Planning;

//                     trigger OnAction()
//                     var
//                         SalesOrderPlanningForm: Page "99000883";
//                     begin
//                         SalesOrderPlanningForm.SetSalesOrder("No.");
//                         SalesOrderPlanningForm.RUNMODAL;
//                     end;
//                 }
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
//             group(Warehouse)
//             {
//                 Caption = 'Warehouse';
//                 Image = Warehouse;
//                 action("Create Inventor&y Put-away/Pick")
//                 {
//                     Caption = 'Create Inventor&y Put-away/Pick';
//                     Ellipsis = true;
//                     Image = CreatePutawayPick;

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
//                 action("P&ost")
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
//                         SendToPosting(CODEUNIT::"Sales-Post (Yes/No)");
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
//                         SendToPosting(CODEUNIT::"Sales-Post + Print");
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
//                     Promoted = true;
//                     PromotedCategory = Process;

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
//                     Visible = JobQueueActive;

//                     trigger OnAction()
//                     begin
//                         CancelBackgroundPosting;
//                     end;
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
//                     Promoted = true;
//                     PromotedCategory = Process;

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
//             }
//         }
//         area(reporting)
//         {
//             action("Sales Reservation Avail.")
//             {
//                 Caption = 'Sales Reservation Avail.';
//                 Image = "Report";
//                 Promoted = true;
//                 PromotedCategory = "Report";
//                 RunObject = Report 209;
//             }
//         }
//     }

//     trigger OnOpenPage()
//     var
//         SalesSetup: Record "311";
//     begin
//         IF UserMgt.GetSalesFilter <> '' THEN BEGIN
//           FILTERGROUP(2);
//           SETRANGE("Responsibility Center",UserMgt.GetSalesFilter);
//           FILTERGROUP(0);
//         END;

//         SETRANGE("Date Filter",0D,WORKDATE - 1);

//         JobQueueActive := SalesSetup.JobQueueActive;
//     end;

//     var
//         DocPrint: Codeunit "229";
//         ReportPrint: Codeunit "228";
//         UserMgt: Codeunit "5700";
//         Usage: Option "Order Confirmation","Work Order","Pick Instruction";
//         [InDataSet]
//         JobQueueActive: Boolean;
// }

