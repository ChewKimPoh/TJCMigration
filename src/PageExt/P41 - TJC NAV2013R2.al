// page 41 "Sales Quote"
// {
//     Caption = 'Sales Quote';
//     PageType = Document;
//     RefreshOnActivate = true;
//     SourceTable = Table36;
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
//                     Enabled = "Sell-to Customer No.Enable";
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
//                     QuickEntry = false;

//                     trigger OnValidate()
//                     begin
//                         SelltoContactNoOnAfterValidate;
//                     end;
//                 }
//                 field("Sell-to Customer Template Code";"Sell-to Customer Template Code")
//                 {
//                     Enabled = SelltoCustomerTemplateCodeEnab;
//                     Importance = Additional;

//                     trigger OnValidate()
//                     begin
//                         SelltoCustomerTemplateCodeOnAf;
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
//                 field("No. of Archived Versions";"No. of Archived Versions")
//                 {
//                     Importance = Additional;

//                     trigger OnDrillDown()
//                     begin
//                         CurrPage.SAVERECORD;
//                         COMMIT;
//                         SalesHeaderArchive.SETRANGE("Document Type","Document Type"::Quote);
//                         SalesHeaderArchive.SETRANGE("No.","No.");
//                         SalesHeaderArchive.SETRANGE("Doc. No. Occurrence","Doc. No. Occurrence");
//                         IF SalesHeaderArchive.GET("Document Type"::Quote,"No.","Doc. No. Occurrence","No. of Archived Versions") THEN ;
//                         PAGE.RUNMODAL(PAGE::"Sales List Archive",SalesHeaderArchive);
//                         CurrPage.UPDATE(FALSE);
//                     end;
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
//                     Style = StrongAccent;
//                     StyleExpr = TRUE;
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
//                     QuickEntry = false;
//                 }
//                 field("Opportunity No.";"Opportunity No.")
//                 {
//                     QuickEntry = false;
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
//                     QuickEntry = false;
//                 }
//             }
//             part(SalesLines;95)
//             {
//                 SubPageLink = Document No.=FIELD(No.);
//             }
//             group(Invoicing)
//             {
//                 Caption = 'Invoicing';
//                 field("Bill-to Customer No.";"Bill-to Customer No.")
//                 {
//                     Enabled = "Bill-to Customer No.Enable";
//                     Importance = Promoted;
//                     Style = StrongAccent;
//                     StyleExpr = TRUE;

//                     trigger OnValidate()
//                     begin
//                         BilltoCustomerNoOnAfterValidat;
//                     end;
//                 }
//                 field("Bill-to Contact No.";"Bill-to Contact No.")
//                 {
//                 }
//                 field("Bill-to Customer Template Code";"Bill-to Customer Template Code")
//                 {
//                     Enabled = BilltoCustomerTemplateCodeEnab;
//                     Importance = Additional;

//                     trigger OnValidate()
//                     begin
//                         BilltoCustomerTemplateCodeOnAf;
//                     end;
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
//                     Style = StrongAccent;
//                     StyleExpr = TRUE;
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
//                     Importance = Additional;
//                 }
//                 field("Location Code";"Location Code")
//                 {
//                     Importance = Promoted;
//                 }
//                 field("Shipment Method Code";"Shipment Method Code")
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
//                         ChangeExchangeRate.SetParameter("Currency Code","Currency Factor",WORKDATE);
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
//                 Visible = true;
//             }
//             part(;9081)
//             {
//                 SubPageLink = No.=FIELD(Bill-to Customer No.);
//                 Visible = false;
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
//                         PAGE.RUNMODAL(PAGE::"Sales Statistics",Rec);
//                     end;
//                 }
//                 action("Customer Card")
//                 {
//                     Caption = 'Customer Card';
//                     Image = Customer;
//                     RunObject = Page 21;
//                     RunPageLink = No.=FIELD(Sell-to Customer No.);
//                     ShortCutKey = 'Shift+F7';
//                 }
//                 action("C&ontact Card")
//                 {
//                     Caption = 'C&ontact Card';
//                     Image = Card;
//                     RunObject = Page 5050;
//                     RunPageLink = No.=FIELD(Sell-to Contact No.);
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
//                     DocPrint.PrintSalesHeader(Rec);
//                 end;
//             }
//             group(Release)
//             {
//                 Caption = 'Release';
//                 Image = ReleaseDoc;
//                 action(Release)
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
//                 separator()
//                 {
//                 }
//             }
//             group(Create)
//             {
//                 Caption = 'Create';
//                 Image = NewCustomer;
//                 action("Make Order")
//                 {
//                     Caption = 'Make &Order';
//                     Image = MakeOrder;
//                     Promoted = true;
//                     PromotedCategory = Process;

//                     trigger OnAction()
//                     var
//                         PurchaseHeader: Record "38";
//                         ApprovalMgt: Codeunit "439";
//                     begin
//                         IF ApprovalMgt.PrePostApprovalCheck(Rec,PurchaseHeader) THEN
//                           CODEUNIT.RUN(CODEUNIT::"Sales-Quote to Order (Yes/No)",Rec);
//                     end;
//                 }
//                 action("C&reate Customer")
//                 {
//                     Caption = 'C&reate Customer';
//                     Image = NewCustomer;

//                     trigger OnAction()
//                     begin
//                         IF CheckCustomerCreated(FALSE) THEN
//                           CurrPage.UPDATE(TRUE);
//                     end;
//                 }
//                 action("Create &To-do")
//                 {
//                     Caption = 'Create &To-do';
//                     Image = NewToDo;

//                     trigger OnAction()
//                     begin
//                         CreateTodo;
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
//         }
//     }

//     trigger OnAfterGetCurrRecord()
//     begin
//         ActivateFields;
//     end;

//     trigger OnAfterGetRecord()
//     begin
//         ActivateFields;
//     end;

//     trigger OnDeleteRecord(): Boolean
//     begin
//         CurrPage.SAVERECORD;
//         EXIT(ConfirmDeletion);
//     end;

//     trigger OnInit()
//     begin
//         "Bill-to Customer No.Enable" := TRUE;
//         "Sell-to Customer No.Enable" := TRUE;
//         SelltoCustomerTemplateCodeEnab := TRUE;
//         BilltoCustomerTemplateCodeEnab := TRUE;
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

//         ActivateFields;
//     end;

//     var
//         Text000: Label 'Unable to execute this function while in view only mode.';
//         ChangeExchangeRate: Page "511";
//         CopySalesDoc: Report "292";
//         DocPrint: Codeunit "229";
//         UserMgt: Codeunit "5700";
//         ArchiveManagement: Codeunit "5063";
//         SalesHeaderArchive: Record "5107";
//         [InDataSet]
//         BilltoCustomerTemplateCodeEnab: Boolean;
//         [InDataSet]
//         SelltoCustomerTemplateCodeEnab: Boolean;
//         [InDataSet]
//         "Sell-to Customer No.Enable": Boolean;
//         [InDataSet]
//         "Bill-to Customer No.Enable": Boolean;

//     procedure UpdateAllowed(): Boolean
//     begin
//         IF CurrPage.EDITABLE = FALSE THEN BEGIN
//           MESSAGE(Text000);
//           EXIT(FALSE);
//         END;
//         EXIT(TRUE);
//     end;

//     procedure ActivateFields()
//     begin
//         BilltoCustomerTemplateCodeEnab := "Bill-to Customer No." = '';
//         SelltoCustomerTemplateCodeEnab := "Sell-to Customer No." = '';
//         "Sell-to Customer No.Enable" := "Sell-to Customer Template Code" = '';
//         "Bill-to Customer No.Enable" := "Bill-to Customer Template Code" = '';
//     end;

//     local procedure ApproveCalcInvDisc()
//     begin
//         CurrPage.SalesLines.PAGE.ApproveCalcInvDisc;
//     end;

//     local procedure SelltoCustomerNoOnAfterValidat()
//     begin
//         ClearSellToFilter;
//         ActivateFields;
//         CurrPage.UPDATE;
//     end;

//     local procedure SalespersonCodeOnAfterValidate()
//     begin
//         CurrPage.SalesLines.PAGE.UpdateForm(TRUE);
//     end;

//     local procedure SelltoContactNoOnAfterValidate()
//     begin
//         ClearSellToFilter;
//         ActivateFields;
//         CurrPage.UPDATE;
//     end;

//     local procedure SelltoCustomerTemplateCodeOnAf()
//     begin
//         ActivateFields;
//         CurrPage.UPDATE;
//     end;

//     local procedure BilltoCustomerNoOnAfterValidat()
//     begin
//         ActivateFields;
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

//     local procedure BilltoCustomerTemplateCodeOnAf()
//     begin
//         ActivateFields;
//         CurrPage.UPDATE;
//     end;

//     procedure ClearSellToFilter()
//     begin
//         IF GETFILTER("Sell-to Customer No.") = xRec."Sell-to Customer No." THEN
//           IF "Sell-to Customer No." <> xRec."Sell-to Customer No." THEN
//             SETRANGE("Sell-to Customer No.");
//         IF GETFILTER("Sell-to Contact No.") = xRec."Sell-to Contact No." THEN
//           IF "Sell-to Contact No." <> xRec."Sell-to Contact No." THEN
//             SETRANGE("Sell-to Contact No.");
//     end;
// }

