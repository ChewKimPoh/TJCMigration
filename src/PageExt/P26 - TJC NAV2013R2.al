// page 26 "Vendor Card"
// {
//     Caption = 'Vendor Card';
//     PageType = Card;
//     RefreshOnActivate = true;
//     SourceTable = Table23;

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
//                 field(Name;Name)
//                 {
//                     Importance = Promoted;
//                 }
//                 field(Address;Address)
//                 {
//                 }
//                 field("Address 2";"Address 2")
//                 {
//                 }
//                 field("Post Code";"Post Code")
//                 {
//                     Importance = Promoted;
//                 }
//                 field("Country/Region Code";"Country/Region Code")
//                 {
//                 }
//                 field("Phone No.";"Phone No.")
//                 {
//                 }
//                 field(Contact;Contact)
//                 {
//                     Editable = ContactEditable;
//                     Importance = Promoted;

//                     trigger OnValidate()
//                     begin
//                         ContactOnAfterValidate;
//                     end;
//                 }
//                 field(City;City)
//                 {
//                 }
//                 field("Search Name";"Search Name")
//                 {
//                 }
//                 field("Balance (LCY)";"Balance (LCY)")
//                 {

//                     trigger OnDrillDown()
//                     var
//                         VendLedgEntry: Record "25";
//                         DtldVendLedgEntry: Record "380";
//                     begin
//                         DtldVendLedgEntry.SETRANGE("Vendor No.","No.");
//                         COPYFILTER("Global Dimension 1 Filter",DtldVendLedgEntry."Initial Entry Global Dim. 1");
//                         COPYFILTER("Global Dimension 2 Filter",DtldVendLedgEntry."Initial Entry Global Dim. 2");
//                         COPYFILTER("Currency Filter",DtldVendLedgEntry."Currency Code");
//                         VendLedgEntry.DrillDownOnEntries(DtldVendLedgEntry);
//                     end;
//                 }
//                 field("Purchaser Code";"Purchaser Code")
//                 {
//                 }
//                 field("Responsibility Center";"Responsibility Center")
//                 {
//                 }
//                 field(Blocked;Blocked)
//                 {
//                 }
//                 field("Last Date Modified";"Last Date Modified")
//                 {
//                 }
//             }
//             group(Communication)
//             {
//                 Caption = 'Communication';
//                 field("Name 2";"Name 2")
//                 {
//                 }
//                 field("Phone No.2";"Phone No.")
//                 {
//                     Importance = Promoted;
//                 }
//                 field("Fax No.";"Fax No.")
//                 {
//                 }
//                 field("E-Mail";"E-Mail")
//                 {
//                     Importance = Promoted;
//                 }
//                 field("Home Page";"Home Page")
//                 {
//                 }
//                 field("IC Partner Code";"IC Partner Code")
//                 {
//                 }
//                 field("Primary Contact No.";"Primary Contact No.")
//                 {
//                 }
//             }
//             group(Invoicing)
//             {
//                 Caption = 'Invoicing';
//                 field("Pay-to Vendor No.";"Pay-to Vendor No.")
//                 {
//                 }
//                 field("Gen. Bus. Posting Group";"Gen. Bus. Posting Group")
//                 {
//                     Importance = Promoted;
//                 }
//                 field("VAT Bus. Posting Group";"VAT Bus. Posting Group")
//                 {
//                 }
//                 field("Vendor Posting Group";"Vendor Posting Group")
//                 {
//                     Importance = Promoted;
//                 }
//                 field("Invoice Disc. Code";"Invoice Disc. Code")
//                 {
//                     NotBlank = true;
//                 }
//                 field("Prices Including VAT";"Prices Including VAT")
//                 {
//                 }
//                 field("Prepayment %";"Prepayment %")
//                 {
//                 }
//             }
//             group(Payments)
//             {
//                 Caption = 'Payments';
//                 field("Application Method";"Application Method")
//                 {
//                 }
//                 field("Partner Type";"Partner Type")
//                 {
//                 }
//                 field("Payment Terms Code";"Payment Terms Code")
//                 {
//                     Importance = Promoted;
//                 }
//                 field("Payment Method Code";"Payment Method Code")
//                 {
//                     Importance = Promoted;
//                 }
//                 field(Priority;Priority)
//                 {
//                 }
//                 field("Cash Flow Payment Terms Code";"Cash Flow Payment Terms Code")
//                 {
//                 }
//                 field("Our Account No.";"Our Account No.")
//                 {
//                 }
//                 field("Block Payment Tolerance";"Block Payment Tolerance")
//                 {

//                     trigger OnValidate()
//                     begin
//                         IF "Block Payment Tolerance" THEN BEGIN
//                           IF CONFIRM(Text002,FALSE) THEN
//                             PaymentToleranceMgt.DelTolVendLedgEntry(Rec);
//                         END ELSE BEGIN
//                           IF CONFIRM(Text001,FALSE) THEN
//                             PaymentToleranceMgt.CalcTolVendLedgEntry(Rec);
//                         END;
//                     end;
//                 }
//                 field("Creditor No.";"Creditor No.")
//                 {
//                 }
//                 field("Preferred Bank Account";"Preferred Bank Account")
//                 {
//                 }
//             }
//             group(Receiving)
//             {
//                 Caption = 'Receiving';
//                 field("Location Code";"Location Code")
//                 {
//                     Importance = Promoted;
//                 }
//                 field("Shipment Method Code";"Shipment Method Code")
//                 {
//                     Importance = Promoted;
//                 }
//                 field("Lead Time Calculation";"Lead Time Calculation")
//                 {
//                     Importance = Promoted;
//                 }
//                 field("Base Calendar Code";"Base Calendar Code")
//                 {
//                     DrillDown = false;
//                 }
//                 field("Customized Calendar";CalendarMgmt.CustomizedCalendarExistText(CustomizedCalendar."Source Type"::Vendor,"No.",'',"Base Calendar Code"))
//                 {
//                     Caption = 'Customized Calendar';
//                     Editable = false;

//                     trigger OnDrillDown()
//                     begin
//                         CurrPage.SAVERECORD;
//                         TESTFIELD("Base Calendar Code");
//                         CalendarMgmt.ShowCustomizedCalendar(CustomizedCalEntry."Source Type"::Vendor,"No.",'',"Base Calendar Code");
//                     end;
//                 }
//             }
//             group("Foreign Trade")
//             {
//                 Caption = 'Foreign Trade';
//                 field("Currency Code";"Currency Code")
//                 {
//                     Importance = Promoted;
//                 }
//                 field("Language Code";"Language Code")
//                 {
//                 }
//                 field("VAT Registration No.";"VAT Registration No.")
//                 {
//                 }
//             }
//         }
//         area(factboxes)
//         {
//             part(;9094)
//             {
//                 SubPageLink = No.=FIELD(No.),
//                               Currency Filter=FIELD(Currency Filter),
//                               Date Filter=FIELD(Date Filter),
//                               Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
//                               Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter);
//                 Visible = true;
//             }
//             part(;9095)
//             {
//                 SubPageLink = No.=FIELD(No.),
//                               Currency Filter=FIELD(Currency Filter),
//                               Date Filter=FIELD(Date Filter),
//                               Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
//                               Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter);
//                 Visible = true;
//             }
//             part(;9096)
//             {
//                 SubPageLink = No.=FIELD(No.),
//                               Currency Filter=FIELD(Currency Filter),
//                               Date Filter=FIELD(Date Filter),
//                               Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
//                               Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter);
//                 Visible = false;
//             }
//             systempart(;Links)
//             {
//                 Visible = true;
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
//             group("Ven&dor")
//             {
//                 Caption = 'Ven&dor';
//                 Image = Vendor;
//                 action(Dimensions)
//                 {
//                     Caption = 'Dimensions';
//                     Image = Dimensions;
//                     RunObject = Page 540;
//                     RunPageLink = Table ID=CONST(23),
//                                   No.=FIELD(No.);
//                     ShortCutKey = 'Shift+Ctrl+D';
//                 }
//                 action("Bank Accounts")
//                 {
//                     Caption = 'Bank Accounts';
//                     Image = BankAccount;
//                     RunObject = Page 426;
//                     RunPageLink = Vendor No.=FIELD(No.);
//                 }
//                 action("C&ontact")
//                 {
//                     Caption = 'C&ontact';
//                     Image = ContactPerson;

//                     trigger OnAction()
//                     begin
//                         ShowContact;
//                     end;
//                 }
//                 action("Order &Addresses")
//                 {
//                     Caption = 'Order &Addresses';
//                     Image = Addresses;
//                     RunObject = Page 369;
//                     RunPageLink = Vendor No.=FIELD(No.);
//                 }
//                 action("Co&mments")
//                 {
//                     Caption = 'Co&mments';
//                     Image = ViewComments;
//                     RunObject = Page 124;
//                     RunPageLink = Table Name=CONST(Vendor),
//                                   No.=FIELD(No.);
//                 }
//                 action("Cross References")
//                 {
//                     Caption = 'Cross References';
//                     Image = Change;
//                     RunObject = Page 5723;
//                     RunPageLink = Cross-Reference Type=CONST(Vendor),
//                                   Cross-Reference Type No.=FIELD(No.);
//                     RunPageView = SORTING(Cross-Reference Type,Cross-Reference Type No.);
//                 }
//                 action("Online Map")
//                 {
//                     Caption = 'Online Map';
//                     Image = Map;

//                     trigger OnAction()
//                     begin
//                         DisplayMap;
//                     end;
//                 }
//                 separator()
//                 {
//                 }
//                 separator()
//                 {
//                     Caption = '';
//                 }
//                 separator()
//                 {
//                 }
//             }
//             group("&Purchases")
//             {
//                 Caption = '&Purchases';
//                 Image = Purchasing;
//                 action(Items)
//                 {
//                     Caption = 'Items';
//                     Image = Item;
//                     RunObject = Page 297;
//                     RunPageLink = Vendor No.=FIELD(No.);
//                     RunPageView = SORTING(Vendor No.,Item No.);
//                 }
//                 action("Invoice &Discounts")
//                 {
//                     Caption = 'Invoice &Discounts';
//                     Image = CalculateInvoiceDiscount;
//                     RunObject = Page 28;
//                     RunPageLink = Code=FIELD(Invoice Disc. Code);
//                 }
//                 action(Prices)
//                 {
//                     Caption = 'Prices';
//                     Image = Price;
//                     RunObject = Page 7012;
//                     RunPageLink = Vendor No.=FIELD(No.);
//                     RunPageView = SORTING(Vendor No.);
//                 }
//                 action("Line Discounts")
//                 {
//                     Caption = 'Line Discounts';
//                     Image = LineDiscount;
//                     RunObject = Page 7014;
//                     RunPageLink = Vendor No.=FIELD(No.);
//                     RunPageView = SORTING(Vendor No.);
//                 }
//                 action("Prepa&yment Percentages")
//                 {
//                     Caption = 'Prepa&yment Percentages';
//                     Image = PrepaymentPercentages;
//                     RunObject = Page 665;
//                     RunPageLink = Vendor No.=FIELD(No.);
//                     RunPageView = SORTING(Vendor No.);
//                 }
//                 action("S&td. Vend. Purchase Codes")
//                 {
//                     Caption = 'S&td. Vend. Purchase Codes';
//                     Image = CodesList;
//                     RunObject = Page 178;
//                     RunPageLink = Vendor No.=FIELD(No.);
//                 }
//                 separator()
//                 {
//                 }
//             }
//             group(Documents)
//             {
//                 Caption = 'Documents';
//                 Image = Administration;
//                 action(Quotes)
//                 {
//                     Caption = 'Quotes';
//                     Image = Quote;
//                     RunObject = Page 9306;
//                     RunPageLink = Buy-from Vendor No.=FIELD(No.);
//                     RunPageView = SORTING(Document Type,Buy-from Vendor No.);
//                 }
//                 action(Orders)
//                 {
//                     Caption = 'Orders';
//                     Image = Document;
//                     RunObject = Page 9307;
//                     RunPageLink = Buy-from Vendor No.=FIELD(No.);
//                     RunPageView = SORTING(Document Type,Buy-from Vendor No.);
//                 }
//                 action("Return Orders")
//                 {
//                     Caption = 'Return Orders';
//                     Image = ReturnOrder;
//                     RunObject = Page 9311;
//                     RunPageLink = Buy-from Vendor No.=FIELD(No.);
//                     RunPageView = SORTING(Document Type,Buy-from Vendor No.);
//                 }
//                 action("Blanket Orders")
//                 {
//                     Caption = 'Blanket Orders';
//                     Image = BlanketOrder;
//                     RunObject = Page 9310;
//                     RunPageLink = Buy-from Vendor No.=FIELD(No.);
//                     RunPageView = SORTING(Document Type,Buy-from Vendor No.);
//                 }
//             }
//             group(History)
//             {
//                 Caption = 'History';
//                 Image = History;
//                 action("Ledger E&ntries")
//                 {
//                     Caption = 'Ledger E&ntries';
//                     Image = VendorLedger;
//                     Promoted = false;
//                     //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
//                     //PromotedCategory = Process;
//                     RunObject = Page 29;
//                     RunPageLink = Vendor No.=FIELD(No.);
//                     RunPageView = SORTING(Vendor No.);
//                     ShortCutKey = 'Ctrl+F7';
//                 }
//                 action(Statistics)
//                 {
//                     Caption = 'Statistics';
//                     Image = Statistics;
//                     Promoted = true;
//                     PromotedCategory = Process;
//                     RunObject = Page 152;
//                     RunPageLink = No.=FIELD(No.),
//                                   Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
//                                   Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter);
//                     ShortCutKey = 'F7';
//                 }
//                 action(Purchases)
//                 {
//                     Caption = 'Purchases';
//                     Image = Purchase;
//                     RunObject = Page 156;
//                     RunPageLink = No.=FIELD(No.),
//                                   Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
//                                   Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter);
//                 }
//                 action("Entry Statistics")
//                 {
//                     Caption = 'Entry Statistics';
//                     Image = EntryStatistics;
//                     RunObject = Page 303;
//                     RunPageLink = No.=FIELD(No.),
//                                   Date Filter=FIELD(Date Filter),
//                                   Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
//                                   Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter);
//                 }
//                 action("Statistics by C&urrencies")
//                 {
//                     Caption = 'Statistics by C&urrencies';
//                     Image = Currencies;
//                     RunObject = Page 487;
//                     RunPageLink = Vendor Filter=FIELD(No.),
//                                   Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
//                                   Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter),
//                                   Date Filter=FIELD(Date Filter);
//                 }
//                 action("Item &Tracking Entries")
//                 {
//                     Caption = 'Item &Tracking Entries';
//                     Image = ItemTrackingLedger;

//                     trigger OnAction()
//                     var
//                         ItemTrackingMgt: Codeunit "6500";
//                     begin
//                         ItemTrackingMgt.CallItemTrackingEntryForm(2,"No.",'','','','','');
//                     end;
//                 }
//             }
//         }
//         area(creation)
//         {
//             action("Blanket Purchase Order")
//             {
//                 Caption = 'Blanket Purchase Order';
//                 Image = BlanketOrder;
//                 Promoted = false;
//                 //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
//                 //PromotedCategory = New;
//                 RunObject = Page 509;
//                 RunPageLink = Buy-from Vendor No.=FIELD(No.);
//                 RunPageMode = Create;
//             }
//             action("Purchase Quote")
//             {
//                 Caption = 'Purchase Quote';
//                 Image = Quote;
//                 Promoted = false;
//                 //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
//                 //PromotedCategory = New;
//                 RunObject = Page 49;
//                 RunPageLink = Buy-from Vendor No.=FIELD(No.);
//                 RunPageMode = Create;
//             }
//             action("Purchase Invoice")
//             {
//                 Caption = 'Purchase Invoice';
//                 Image = Invoice;
//                 Promoted = true;
//                 PromotedCategory = New;
//                 RunObject = Page 51;
//                 RunPageLink = Buy-from Vendor No.=FIELD(No.);
//                 RunPageMode = Create;
//             }
//             action("Purchase Order")
//             {
//                 Caption = 'Purchase Order';
//                 Image = Document;
//                 Promoted = true;
//                 PromotedCategory = New;
//                 RunObject = Page 50;
//                 RunPageLink = Buy-from Vendor No.=FIELD(No.);
//                 RunPageMode = Create;
//             }
//             action("Purchase Credit Memo")
//             {
//                 Caption = 'Purchase Credit Memo';
//                 Image = CreditMemo;
//                 Promoted = false;
//                 //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
//                 //PromotedCategory = New;
//                 RunObject = Page 52;
//                 RunPageLink = Buy-from Vendor No.=FIELD(No.);
//                 RunPageMode = Create;
//             }
//             action("Purchase Return Order")
//             {
//                 Caption = 'Purchase Return Order';
//                 Image = ReturnOrder;
//                 Promoted = false;
//                 //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
//                 //PromotedCategory = New;
//                 RunObject = Page 6640;
//                 RunPageLink = Buy-from Vendor No.=FIELD(No.);
//                 RunPageMode = Create;
//             }
//         }
//         area(processing)
//         {
//             group("F&unctions")
//             {
//                 Caption = 'F&unctions';
//                 Image = "Action";
//                 action("Apply Template")
//                 {
//                     Caption = 'Apply Template';
//                     Ellipsis = true;
//                     Image = ApplyTemplate;
//                     Promoted = true;
//                     PromotedCategory = Process;

//                     trigger OnAction()
//                     var
//                         ConfigTemplateMgt: Codeunit "8612";
//                         RecRef: RecordRef;
//                     begin
//                         RecRef.GETTABLE(Rec);
//                         ConfigTemplateMgt.UpdateFromTemplateSelection(RecRef);
//                     end;
//                 }
//             }
//             action("Payment Journal")
//             {
//                 Caption = 'Payment Journal';
//                 Image = PaymentJournal;
//                 Promoted = true;
//                 PromotedCategory = Process;
//                 RunObject = Page 256;
//             }
//             action("Purchase Journal")
//             {
//                 Caption = 'Purchase Journal';
//                 Image = Journals;
//                 Promoted = true;
//                 PromotedCategory = Process;
//                 RunObject = Page 254;
//             }
//         }
//         area(reporting)
//         {
//             action("Vendor - Labels")
//             {
//                 Caption = 'Vendor - Labels';
//                 Image = "Report";
//                 Promoted = false;
//                 //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
//                 //PromotedCategory = "Report";
//                 RunObject = Report 310;
//             }
//             action("Vendor - Balance to Date")
//             {
//                 Caption = 'Vendor - Balance to Date';
//                 Image = "Report";
//                 Promoted = false;
//                 //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
//                 //PromotedCategory = "Report";
//                 RunObject = Report 321;
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

//     trigger OnInit()
//     begin
//         ContactEditable := TRUE;
//         MapPointVisible := TRUE;
//     end;

//     trigger OnOpenPage()
//     var
//         MapMgt: Codeunit "802";
//     begin
//         ActivateFields;
//         IF NOT MapMgt.TestSetup THEN
//           MapPointVisible := FALSE;
//     end;

//     var
//         CalendarMgmt: Codeunit "7600";
//         PaymentToleranceMgt: Codeunit "426";
//         CustomizedCalEntry: Record "7603";
//         CustomizedCalendar: Record "7602";
//         Text001: Label 'Do you want to allow payment tolerance for entries that are currently open?';
//         Text002: Label 'Do you want to remove payment tolerance from entries that are currently open?';
//         [InDataSet]
//         MapPointVisible: Boolean;
//         [InDataSet]
//         ContactEditable: Boolean;

//     procedure ActivateFields()
//     begin
//         ContactEditable := "Primary Contact No." = '';
//     end;

//     local procedure ContactOnAfterValidate()
//     begin
//         ActivateFields;
//     end;
// }

