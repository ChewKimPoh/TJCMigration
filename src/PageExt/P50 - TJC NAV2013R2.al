// page 50 "Purchase Order"
// {
//     Caption = 'Purchase Order';
//     PageType = Document;
//     RefreshOnActivate = true;
//     SourceTable = Table38;
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

//                     trigger OnAssistEdit()
//                     begin
//                         IF AssistEdit(xRec) THEN
//                           CurrPage.UPDATE;
//                     end;
//                 }
//                 field("Buy-from Vendor No.";"Buy-from Vendor No.")
//                 {
//                     Importance = Promoted;

//                     trigger OnValidate()
//                     begin
//                         BuyfromVendorNoOnAfterValidate;
//                     end;
//                 }
//                 field("Buy-from Contact No.";"Buy-from Contact No.")
//                 {
//                 }
//                 field("Buy-from Vendor Name";"Buy-from Vendor Name")
//                 {
//                 }
//                 field("Buy-from Address";"Buy-from Address")
//                 {
//                     Importance = Additional;
//                 }
//                 field("Buy-from Address 2";"Buy-from Address 2")
//                 {
//                     Importance = Additional;
//                 }
//                 field("Buy-from Post Code";"Buy-from Post Code")
//                 {
//                     Importance = Additional;
//                 }
//                 field("Buy-from City";"Buy-from City")
//                 {
//                 }
//                 field("Buy-from Contact";"Buy-from Contact")
//                 {
//                     Importance = Additional;
//                 }
//                 field("No. of Archived Versions";"No. of Archived Versions")
//                 {
//                     Importance = Additional;
//                 }
//                 field("Posting Date";"Posting Date")
//                 {
//                 }
//                 field("Order Date";"Order Date")
//                 {
//                     Importance = Promoted;
//                 }
//                 field("Document Date";"Document Date")
//                 {
//                 }
//                 field("Quote No.";"Quote No.")
//                 {
//                     Importance = Additional;
//                 }
//                 field("Vendor Order No.";"Vendor Order No.")
//                 {
//                 }
//                 field("Vendor Shipment No.";"Vendor Shipment No.")
//                 {
//                 }
//                 field("Vendor Invoice No.";"Vendor Invoice No.")
//                 {
//                 }
//                 field("Order Address Code";"Order Address Code")
//                 {
//                     Importance = Additional;
//                     Visible = false;
//                 }
//                 field("Printing Version";"Printing Version")
//                 {
//                 }
//                 field("Purchaser Code";"Purchaser Code")
//                 {
//                     Importance = Additional;

//                     trigger OnValidate()
//                     begin
//                         PurchaserCodeOnAfterValidate;
//                     end;
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
//             part(PurchLines;54)
//             {
//                 SubPageLink = Document No.=FIELD(No.);
//             }
//             group(Invoicing)
//             {
//                 Caption = 'Invoicing';
//                 field("Pay-to Vendor No.";"Pay-to Vendor No.")
//                 {
//                     Importance = Promoted;

//                     trigger OnValidate()
//                     begin
//                         PaytoVendorNoOnAfterValidate;
//                     end;
//                 }
//                 field("Pay-to Contact No.";"Pay-to Contact No.")
//                 {
//                     Importance = Additional;
//                 }
//                 field("Pay-to Name";"Pay-to Name")
//                 {
//                 }
//                 field("Pay-to Address";"Pay-to Address")
//                 {
//                     Importance = Additional;
//                 }
//                 field("Pay-to Address 2";"Pay-to Address 2")
//                 {
//                     Importance = Additional;
//                 }
//                 field("Pay-to Post Code";"Pay-to Post Code")
//                 {
//                     Importance = Additional;
//                 }
//                 field("Pay-to City";"Pay-to City")
//                 {
//                 }
//                 field("Pay-to Contact";"Pay-to Contact")
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
//                     Importance = Additional;
//                 }
//                 field("Payment Reference";"Payment Reference")
//                 {
//                 }
//                 field("Creditor No.";"Creditor No.")
//                 {
//                 }
//                 field("On Hold";"On Hold")
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
//             }
//             group(Shipping)
//             {
//                 Caption = 'Shipping';
//                 field("Ship-to Name";"Ship-to Name")
//                 {
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
//                     Importance = Additional;
//                 }
//                 field("Ship-to City";"Ship-to City")
//                 {
//                 }
//                 field("Ship-to Contact";"Ship-to Contact")
//                 {
//                 }
//                 field("Location Code";"Location Code")
//                 {
//                     Importance = Promoted;
//                 }
//                 field("Inbound Whse. Handling Time";"Inbound Whse. Handling Time")
//                 {
//                     Importance = Additional;
//                 }
//                 field("Shipment Method Code";"Shipment Method Code")
//                 {
//                 }
//                 field("Lead Time Calculation";"Lead Time Calculation")
//                 {
//                     Importance = Additional;
//                 }
//                 field("Requested Receipt Date";"Requested Receipt Date")
//                 {
//                 }
//                 field("Promised Receipt Date";"Promised Receipt Date")
//                 {
//                 }
//                 field("Expected Receipt Date";"Expected Receipt Date")
//                 {
//                     Importance = Promoted;
//                 }
//                 field("Sell-to Customer No.";"Sell-to Customer No.")
//                 {
//                 }
//                 field("Ship-to Code";"Ship-to Code")
//                 {
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
//                 field("Transaction Type";"Transaction Type")
//                 {
//                 }
//                 field("Transaction Specification";"Transaction Specification")
//                 {
//                 }
//                 field("Transport Method";"Transport Method")
//                 {
//                 }
//                 field("Entry Point";"Entry Point")
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
//                 field("Vendor Cr. Memo No.";"Vendor Cr. Memo No.")
//                 {
//                 }
//             }
//         }
//         area(factboxes)
//         {
//             part(;9090)
//             {
//                 Provider = PurchLines;
//                 SubPageLink = No.=FIELD(No.);
//                 Visible = false;
//             }
//             part(;9092)
//             {
//                 SubPageLink = Table ID=CONST(38),
//                               Document Type=FIELD(Document Type),
//                               Document No.=FIELD(No.);
//                 Visible = false;
//             }
//             part(;9093)
//             {
//                 SubPageLink = No.=FIELD(Buy-from Vendor No.);
//                 Visible = false;
//             }
//             part(;9094)
//             {
//                 SubPageLink = No.=FIELD(Buy-from Vendor No.);
//                 Visible = true;
//             }
//             part(;9095)
//             {
//                 SubPageLink = No.=FIELD(Buy-from Vendor No.);
//                 Visible = true;
//             }
//             part(;9096)
//             {
//                 SubPageLink = No.=FIELD(Pay-to Vendor No.);
//                 Visible = false;
//             }
//             part(;9100)
//             {
//                 Provider = PurchLines;
//                 SubPageLink = Document Type=FIELD(Document Type),
//                               Document No.=FIELD(Document No.),
//                               Line No.=FIELD(Line No.);
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
//                     Promoted = false;
//                     //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
//                     //PromotedIsBig = false;
//                     ShortCutKey = 'Shift+Ctrl+D';

//                     trigger OnAction()
//                     begin
//                         ShowDocDim;
//                         CurrPage.SAVERECORD;
//                     end;
//                 }
//                 action(Statistics)
//                 {
//                     Caption = 'Statistics';
//                     Image = Statistics;
//                     Promoted = true;
//                     PromotedCategory = Process;
//                     PromotedIsBig = true;
//                     ShortCutKey = 'F7';

//                     trigger OnAction()
//                     begin
//                         CalcInvDiscForHeader;
//                         COMMIT;
//                         PAGE.RUNMODAL(PAGE::"Purchase Order Statistics",Rec);
//                     end;
//                 }
//                 action(Card)
//                 {
//                     Caption = 'Card';
//                     Image = EditLines;
//                     Promoted = false;
//                     //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
//                     //PromotedIsBig = false;
//                     RunObject = Page 26;
//                     RunPageLink = No.=FIELD(Buy-from Vendor No.);
//                     ShortCutKey = 'Shift+F7';
//                 }
//                 action(Approvals)
//                 {
//                     Caption = 'Approvals';
//                     Image = Approvals;
//                     Promoted = false;
//                     //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
//                     //PromotedIsBig = false;

//                     trigger OnAction()
//                     var
//                         ApprovalEntries: Page "658";
//                     begin
//                         ApprovalEntries.Setfilters(DATABASE::"Purchase Header","Document Type","No.");
//                         ApprovalEntries.RUN;
//                     end;
//                 }
//                 action("Co&mments")
//                 {
//                     Caption = 'Co&mments';
//                     Image = ViewComments;
//                     RunObject = Page 66;
//                     RunPageLink = Document Type=FIELD(Document Type),
//                                   No.=FIELD(No.),
//                                   Document Line No.=CONST(0);
//                 }
//             }
//             group(Documents)
//             {
//                 Caption = 'Documents';
//                 Image = Documents;
//                 action(Receipts)
//                 {
//                     Caption = 'Receipts';
//                     Image = PostedReceipts;
//                     RunObject = Page 145;
//                     RunPageLink = Order No.=FIELD(No.);
//                     RunPageView = SORTING(Order No.);
//                 }
//                 action(Invoices)
//                 {
//                     Caption = 'Invoices';
//                     Image = Invoice;
//                     Promoted = false;
//                     //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
//                     //PromotedIsBig = false;
//                     RunObject = Page 146;
//                     RunPageLink = Order No.=FIELD(No.);
//                     RunPageView = SORTING(Order No.);
//                 }
//                 action("Prepa&yment Invoices")
//                 {
//                     Caption = 'Prepa&yment Invoices';
//                     Image = PrepaymentInvoice;
//                     RunObject = Page 146;
//                     RunPageLink = Prepayment Order No.=FIELD(No.);
//                     RunPageView = SORTING(Prepayment Order No.);
//                 }
//                 action("Prepayment Credi&t Memos")
//                 {
//                     Caption = 'Prepayment Credi&t Memos';
//                     Image = PrepaymentCreditMemo;
//                     RunObject = Page 147;
//                     RunPageLink = Prepayment Order No.=FIELD(No.);
//                     RunPageView = SORTING(Prepayment Order No.);
//                 }
//             }
//             group(Warehouse)
//             {
//                 Caption = 'Warehouse';
//                 Image = Warehouse;
//                 separator()
//                 {
//                 }
//                 action("In&vt. Put-away/Pick Lines")
//                 {
//                     Caption = 'In&vt. Put-away/Pick Lines';
//                     Image = PickLines;
//                     RunObject = Page 5774;
//                     RunPageLink = Source Document=CONST(Purchase Order),
//                                   Source No.=FIELD(No.);
//                     RunPageView = SORTING(Source Document,Source No.,Location Code);
//                 }
//                 action("Whse. Receipt Lines")
//                 {
//                     Caption = 'Whse. Receipt Lines';
//                     Image = ReceiptLines;
//                     RunObject = Page 7342;
//                     RunPageLink = Source Type=CONST(39),
//                                   Source Subtype=FIELD(Document Type),
//                                   Source No.=FIELD(No.);
//                     RunPageView = SORTING(Source Type,Source Subtype,Source No.,Source Line No.);
//                 }
//                 separator()
//                 {
//                 }
//                 group("Dr&op Shipment")
//                 {
//                     Caption = 'Dr&op Shipment';
//                     Image = Delivery;
//                     action("Get &Sales Order")
//                     {
//                         Caption = 'Get &Sales Order';
//                         Image = "Order";
//                         RunObject = Codeunit 76;
//                     }
//                 }
//                 group("Speci&al Order")
//                 {
//                     Caption = 'Speci&al Order';
//                     Image = SpecialOrder;
//                     action("Get &Sales Order")
//                     {
//                         Caption = 'Get &Sales Order';
//                         Image = "Order";

//                         trigger OnAction()
//                         var
//                             PurchHeader: Record "38";
//                             DistIntegration: Codeunit "5702";
//                         begin
//                             PurchHeader.COPY(Rec);
//                             DistIntegration.GetSpecialOrders(PurchHeader);
//                             Rec := PurchHeader;
//                         end;
//                     }
//                 }
//             }
//         }
//         area(processing)
//         {
//             group(Release)
//             {
//                 Caption = 'Release';
//                 Image = ReleaseDoc;
//                 separator()
//                 {
//                 }
//                 action(Release)
//                 {
//                     Caption = 'Re&lease';
//                     Image = ReleaseDoc;
//                     Promoted = true;
//                     PromotedCategory = Process;
//                     ShortCutKey = 'Ctrl+F9';

//                     trigger OnAction()
//                     var
//                         ReleasePurchDoc: Codeunit "415";
//                     begin
//                         ReleasePurchDoc.PerformManualRelease(Rec);
//                     end;
//                 }
//                 action("Re&open")
//                 {
//                     Caption = 'Re&open';
//                     Image = ReOpen;

//                     trigger OnAction()
//                     var
//                         ReleasePurchDoc: Codeunit "415";
//                     begin
//                         ReleasePurchDoc.PerformManualReopen(Rec);
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
//                 action("Get St&d. Vend. Purchase Codes")
//                 {
//                     Caption = 'Get St&d. Vend. Purchase Codes';
//                     Ellipsis = true;
//                     Image = VendorCode;

//                     trigger OnAction()
//                     var
//                         StdVendPurchCode: Record "175";
//                     begin
//                         StdVendPurchCode.InsertPurchLines(Rec);
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
//                         CopyPurchDoc.SetPurchHeader(Rec);
//                         CopyPurchDoc.RUNMODAL;
//                         CLEAR(CopyPurchDoc);
//                     end;
//                 }
//                 action("Move Negative Lines")
//                 {
//                     Caption = 'Move Negative Lines';
//                     Ellipsis = true;
//                     Image = MoveNegativeLines;

//                     trigger OnAction()
//                     begin
//                         CLEAR(MoveNegPurchLines);
//                         MoveNegPurchLines.SetPurchHeader(Rec);
//                         MoveNegPurchLines.RUNMODAL;
//                         MoveNegPurchLines.ShowDocument;
//                     end;
//                 }
//                 group("Dr&op Shipment")
//                 {
//                     Caption = 'Dr&op Shipment';
//                     Image = Delivery;
//                     action("Get &Sales Order")
//                     {
//                         Caption = 'Get &Sales Order';
//                         Image = "Order";
//                         RunObject = Codeunit 76;
//                     }
//                 }
//                 group("Speci&al Order")
//                 {
//                     Caption = 'Speci&al Order';
//                     Image = SpecialOrder;
//                     action("Get &Sales Order")
//                     {
//                         Caption = 'Get &Sales Order';
//                         Image = "Order";

//                         trigger OnAction()
//                         var
//                             DistIntegration: Codeunit "5702";
//                             PurchHeader: Record "38";
//                         begin
//                             PurchHeader.COPY(Rec);
//                             DistIntegration.GetSpecialOrders(PurchHeader);
//                             Rec := PurchHeader;
//                         end;
//                     }
//                 }
//                 action("Archive Document")
//                 {
//                     Caption = 'Archi&ve Document';
//                     Image = Archive;

//                     trigger OnAction()
//                     begin
//                         ArchiveManagement.ArchivePurchDocument(Rec);
//                         CurrPage.UPDATE(FALSE);
//                     end;
//                 }
//                 action("Send IC Purchase Order")
//                 {
//                     Caption = 'Send IC Purchase Order';
//                     Image = IntercompanyOrder;

//                     trigger OnAction()
//                     var
//                         ICInOutboxMgt: Codeunit "427";
//                         SalesHeader: Record "36";
//                         ApprovalMgt: Codeunit "439";
//                     begin
//                         IF ApprovalMgt.PrePostApprovalCheck(SalesHeader,Rec) THEN
//                           ICInOutboxMgt.SendPurchDoc(Rec,FALSE);
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
//                 group(Approval)
//                 {
//                     Caption = 'Approval';
//                     Image = Approval;
//                     action("Send A&pproval Request")
//                     {
//                         Caption = 'Send A&pproval Request';
//                         Image = SendApprovalRequest;

//                         trigger OnAction()
//                         var
//                             ApprovalMgt: Codeunit "439";
//                         begin
//                             IF ApprovalMgt.SendPurchaseApprovalRequest(Rec) THEN;
//                         end;
//                     }
//                     action("Cancel Approval Re&quest")
//                     {
//                         Caption = 'Cancel Approval Re&quest';
//                         Image = Cancel;

//                         trigger OnAction()
//                         var
//                             ApprovalMgt: Codeunit "439";
//                         begin
//                             IF ApprovalMgt.CancelPurchaseApprovalRequest(Rec,TRUE,TRUE) THEN;
//                         end;
//                     }
//                 }
//             }
//             group(Warehouse)
//             {
//                 Caption = 'Warehouse';
//                 Image = Warehouse;
//                 action("Create &Whse. Receipt")
//                 {
//                     Caption = 'Create &Whse. Receipt';
//                     Image = NewReceipt;

//                     trigger OnAction()
//                     var
//                         GetSourceDocInbound: Codeunit "5751";
//                     begin
//                         GetSourceDocInbound.CreateFromPurchOrder(Rec);

//                         IF NOT FIND('=><') THEN
//                           INIT;
//                     end;
//                 }
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
//                 separator()
//                 {
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
//                         Post(CODEUNIT::"Purch.-Post (Yes/No)");
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
//                         Post(CODEUNIT::"Purch.-Post + Print");
//                     end;
//                 }
//                 action("Test Report")
//                 {
//                     Caption = 'Test Report';
//                     Ellipsis = true;
//                     Image = TestReport;

//                     trigger OnAction()
//                     begin
//                         ReportPrint.PrintPurchHeader(Rec);
//                     end;
//                 }
//                 action("Post &Batch")
//                 {
//                     Caption = 'Post &Batch';
//                     Ellipsis = true;
//                     Image = PostBatch;

//                     trigger OnAction()
//                     begin
//                         REPORT.RUNMODAL(REPORT::"Batch Post Purchase Orders",TRUE,TRUE,Rec);
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
//                 separator()
//                 {
//                 }
//                 group("Prepa&yment")
//                 {
//                     Caption = 'Prepa&yment';
//                     Image = Prepayment;
//                     action("Prepayment Test &Report")
//                     {
//                         Caption = 'Prepayment Test &Report';
//                         Ellipsis = true;
//                         Image = PrepaymentSimulation;

//                         trigger OnAction()
//                         begin
//                             ReportPrint.PrintPurchHeaderPrepmt(Rec);
//                         end;
//                     }
//                     action(PostPrepaymentInvoice)
//                     {
//                         Caption = 'Post Prepayment &Invoice';
//                         Ellipsis = true;
//                         Image = PrepaymentPost;

//                         trigger OnAction()
//                         var
//                             SalesHeader: Record "36";
//                             ApprovalMgt: Codeunit "439";
//                             PurchPostYNPrepmt: Codeunit "445";
//                         begin
//                             IF ApprovalMgt.PrePostApprovalCheck(SalesHeader,Rec) THEN
//                               PurchPostYNPrepmt.PostPrepmtInvoiceYN(Rec,FALSE);
//                         end;
//                     }
//                     action("Post and Print Prepmt. Invoic&e")
//                     {
//                         Caption = 'Post and Print Prepmt. Invoic&e';
//                         Ellipsis = true;
//                         Image = PrepaymentPostPrint;

//                         trigger OnAction()
//                         var
//                             SalesHeader: Record "36";
//                             ApprovalMgt: Codeunit "439";
//                             PurchPostYNPrepmt: Codeunit "445";
//                         begin
//                             IF ApprovalMgt.PrePostApprovalCheck(SalesHeader,Rec) THEN
//                               PurchPostYNPrepmt.PostPrepmtInvoiceYN(Rec,TRUE);
//                         end;
//                     }
//                     action(PostPrepaymentCreditMemo)
//                     {
//                         Caption = 'Post Prepayment &Credit Memo';
//                         Ellipsis = true;
//                         Image = PrepaymentPost;

//                         trigger OnAction()
//                         var
//                             SalesHeader: Record "36";
//                             ApprovalMgt: Codeunit "439";
//                             PurchPostYNPrepmt: Codeunit "445";
//                         begin
//                             IF ApprovalMgt.PrePostApprovalCheck(SalesHeader,Rec) THEN
//                               PurchPostYNPrepmt.PostPrepmtCrMemoYN(Rec,FALSE);
//                         end;
//                     }
//                     action("Post and Print Prepmt. Cr. Mem&o")
//                     {
//                         Caption = 'Post and Print Prepmt. Cr. Mem&o';
//                         Ellipsis = true;
//                         Image = PrepaymentPostPrint;

//                         trigger OnAction()
//                         var
//                             SalesHeader: Record "36";
//                             ApprovalMgt: Codeunit "439";
//                             PurchPostYNPrepmt: Codeunit "445";
//                         begin
//                             IF ApprovalMgt.PrePostApprovalCheck(SalesHeader,Rec) THEN
//                               PurchPostYNPrepmt.PostPrepmtCrMemoYN(Rec,TRUE);
//                         end;
//                     }
//                 }
//             }
//             group(Print)
//             {
//                 Caption = 'Print';
//                 Image = Print;
//                 action("&Print")
//                 {
//                     Caption = '&Print';
//                     Ellipsis = true;
//                     Image = Print;
//                     Promoted = true;
//                     PromotedCategory = Process;

//                     trigger OnAction()
//                     begin
//                         DocPrint.PrintPurchHeader(Rec);
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
//         "Responsibility Center" := UserMgt.GetPurchasesFilter;
//     end;

//     trigger OnOpenPage()
//     begin
//         IF UserMgt.GetPurchasesFilter <> '' THEN BEGIN
//           FILTERGROUP(2);
//           SETRANGE("Responsibility Center",UserMgt.GetPurchasesFilter);
//           FILTERGROUP(0);
//         END;
//     end;

//     var
//         ChangeExchangeRate: Page "511";
//         CopyPurchDoc: Report "492";
//         MoveNegPurchLines: Report "6698";
//         ReportPrint: Codeunit "228";
//         DocPrint: Codeunit "229";
//         UserMgt: Codeunit "5700";
//         ArchiveManagement: Codeunit "5063";
//         [InDataSet]
//         JobQueueVisible: Boolean;

//     local procedure Post(PostingCodeunitID: Integer)
//     begin
//         SendToPosting(PostingCodeunitID);
//         IF "Job Queue Status" = "Job Queue Status"::"Scheduled for Posting" THEN
//           CurrPage.CLOSE;
//         CurrPage.UPDATE(FALSE);
//     end;

//     local procedure ApproveCalcInvDisc()
//     begin
//         CurrPage.PurchLines.PAGE.ApproveCalcInvDisc;
//     end;

//     local procedure BuyfromVendorNoOnAfterValidate()
//     begin
//         IF GETFILTER("Buy-from Vendor No.") = xRec."Buy-from Vendor No." THEN
//           IF "Buy-from Vendor No." <> xRec."Buy-from Vendor No." THEN
//             SETRANGE("Buy-from Vendor No.");
//         CurrPage.UPDATE;
//     end;

//     local procedure PurchaserCodeOnAfterValidate()
//     begin
//         CurrPage.PurchLines.PAGE.UpdateForm(TRUE);
//     end;

//     local procedure PaytoVendorNoOnAfterValidate()
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
// }

