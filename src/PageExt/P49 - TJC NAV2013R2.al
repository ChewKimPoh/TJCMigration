// page 49 "Purchase Quote"
// {
//     Caption = 'Purchase Quote';
//     PageType = Document;
//     RefreshOnActivate = true;
//     SourceTable = Table38;
//     SourceTableView = WHERE(Document Type=FILTER(Quote));

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
//                 field("Requested Receipt Date";"Requested Receipt Date")
//                 {
//                 }
//                 field("Vendor Order No.";"Vendor Order No.")
//                 {
//                 }
//                 field("Vendor Shipment No.";"Vendor Shipment No.")
//                 {
//                 }
//                 field("Order Address Code";"Order Address Code")
//                 {
//                     Importance = Additional;
//                 }
//                 field("Purchaser Code";"Purchaser Code")
//                 {

//                     trigger OnValidate()
//                     begin
//                         PurchaserCodeOnAfterValidate;
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
//                 field(Status;Status)
//                 {
//                     Importance = Promoted;
//                 }
//             }
//             part(PurchLines;97)
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
//                 }
//                 field("Ship-to Address 2";"Ship-to Address 2")
//                 {
//                 }
//                 field("Ship-to Post Code";"Ship-to Post Code")
//                 {
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
//                 field("Shipment Method Code";"Shipment Method Code")
//                 {
//                 }
//                 field("Expected Receipt Date";"Expected Receipt Date")
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
//                         ChangeExchangeRate.SetParameter("Currency Code","Currency Factor",WORKDATE);
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
//         }
//         area(factboxes)
//         {
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
//             part(;9092)
//             {
//                 SubPageLink = Table ID=CONST(38),
//                               Document Type=FIELD(Document Type),
//                               Document No.=FIELD(No.);
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
//             group("&Quote")
//             {
//                 Caption = '&Quote';
//                 Image = Quote;
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
//                         PAGE.RUNMODAL(PAGE::"Purchase Statistics",Rec);
//                     end;
//                 }
//                 action(Vendor)
//                 {
//                     Caption = 'Vendor';
//                     Image = Vendor;
//                     RunObject = Page 26;
//                     RunPageLink = No.=FIELD(Buy-from Vendor No.);
//                     ShortCutKey = 'Shift+F7';
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
//                         ApprovalEntries.Setfilters(DATABASE::"Purchase Header","Document Type","No.");
//                         ApprovalEntries.RUN;
//                     end;
//                 }
//             }
//         }
//         area(processing)
//         {
//             action("&Print")
//             {
//                 Caption = '&Print';
//                 Ellipsis = true;
//                 Image = Print;
//                 Promoted = true;
//                 PromotedCategory = Process;

//                 trigger OnAction()
//                 begin
//                     DocPrint.PrintPurchHeader(Rec);
//                 end;
//             }
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
//                         IF ApprovalMgt.SendPurchaseApprovalRequest(Rec) THEN;
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
//                         IF ApprovalMgt.CancelPurchaseApprovalRequest(Rec,TRUE,TRUE) THEN;
//                     end;
//                 }
//             }
//             group("Make Order")
//             {
//                 Caption = 'Make Order';
//                 Image = MakeOrder;
//                 action("Make Order")
//                 {
//                     Caption = 'Make &Order';
//                     Image = MakeOrder;
//                     Promoted = true;
//                     PromotedCategory = Process;

//                     trigger OnAction()
//                     var
//                         SalesHeader: Record "36";
//                         ApprovalMgt: Codeunit "439";
//                     begin
//                         IF ApprovalMgt.PrePostApprovalCheck(SalesHeader,Rec) THEN
//                           CODEUNIT.RUN(CODEUNIT::"Purch.-Quote to Order (Yes/No)",Rec);
//                     end;
//                 }
//             }
//         }
//     }

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
//         DocPrint: Codeunit "229";
//         UserMgt: Codeunit "5700";
//         ArchiveManagement: Codeunit "5063";

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
// }

