// page 27 "Vendor List"
// {
//     Caption = 'Vendor List';
//     CardPageID = "Vendor Card";
//     Editable = false;
//     PageType = List;
//     SourceTable = Table23;

//     layout
//     {
//         area(content)
//         {
//             repeater()
//             {
//                 field("No.";"No.")
//                 {
//                 }
//                 field(Name;Name)
//                 {
//                 }
//                 field("Name 2";"Name 2")
//                 {
//                 }
//                 field("Responsibility Center";"Responsibility Center")
//                 {
//                 }
//                 field("Location Code";"Location Code")
//                 {
//                 }
//                 field("Post Code";"Post Code")
//                 {
//                     Visible = false;
//                 }
//                 field("Country/Region Code";"Country/Region Code")
//                 {
//                     Visible = false;
//                 }
//                 field("Phone No.";"Phone No.")
//                 {
//                 }
//                 field("Fax No.";"Fax No.")
//                 {
//                     Visible = false;
//                 }
//                 field("IC Partner Code";"IC Partner Code")
//                 {
//                     Visible = false;
//                 }
//                 field(Contact;Contact)
//                 {
//                 }
//                 field("Purchaser Code";"Purchaser Code")
//                 {
//                     Visible = false;
//                 }
//                 field("Vendor Posting Group";"Vendor Posting Group")
//                 {
//                     Visible = false;
//                 }
//                 field("Gen. Bus. Posting Group";"Gen. Bus. Posting Group")
//                 {
//                     Visible = false;
//                 }
//                 field("VAT Bus. Posting Group";"VAT Bus. Posting Group")
//                 {
//                     Visible = false;
//                 }
//                 field("Payment Terms Code";"Payment Terms Code")
//                 {
//                     Visible = false;
//                 }
//                 field("Fin. Charge Terms Code";"Fin. Charge Terms Code")
//                 {
//                     Visible = false;
//                 }
//                 field("Currency Code";"Currency Code")
//                 {
//                     Visible = false;
//                 }
//                 field("Language Code";"Language Code")
//                 {
//                     Visible = false;
//                 }
//                 field("Search Name";"Search Name")
//                 {
//                 }
//                 field(Blocked;Blocked)
//                 {
//                     Visible = false;
//                 }
//                 field("Last Date Modified";"Last Date Modified")
//                 {
//                     Visible = false;
//                 }
//                 field("Application Method";"Application Method")
//                 {
//                     Visible = false;
//                 }
//                 field("Location Code2";"Location Code")
//                 {
//                     Visible = false;
//                 }
//                 field("Shipment Method Code";"Shipment Method Code")
//                 {
//                     Visible = false;
//                 }
//                 field("Lead Time Calculation";"Lead Time Calculation")
//                 {
//                     Visible = false;
//                 }
//                 field("Base Calendar Code";"Base Calendar Code")
//                 {
//                     Visible = false;
//                 }
//             }
//         }
//         area(factboxes)
//         {
//             part(;9093)
//             {
//                 SubPageLink = No.=FIELD(No.),
//                               Currency Filter=FIELD(Currency Filter),
//                               Date Filter=FIELD(Date Filter),
//                               Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
//                               Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter);
//                 Visible = false;
//             }
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
//                 group(Dimensions)
//                 {
//                     Caption = 'Dimensions';
//                     Image = Dimensions;
//                     action("Dimensions-Single")
//                     {
//                         Caption = 'Dimensions-Single';
//                         Image = Dimensions;
//                         RunObject = Page 540;
//                         RunPageLink = Table ID=CONST(23),
//                                       No.=FIELD(No.);
//                         ShortCutKey = 'Shift+Ctrl+D';
//                     }
//                     action("Dimensions-&Multiple")
//                     {
//                         Caption = 'Dimensions-&Multiple';
//                         Image = DimensionSets;

//                         trigger OnAction()
//                         var
//                             Vend: Record "23";
//                             DefaultDimMultiple: Page "542";
//                         begin
//                             CurrPage.SETSELECTIONFILTER(Vend);
//                             DefaultDimMultiple.SetMultiVendor(Vend);
//                             DefaultDimMultiple.RUNMODAL;
//                         end;
//                     }
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
//                 separator()
//                 {
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
//                 action("Cross Re&ferences")
//                 {
//                     Caption = 'Cross Re&ferences';
//                     Image = Change;
//                     RunObject = Page 5723;
//                     RunPageLink = Cross-Reference Type=CONST(Vendor),
//                                   Cross-Reference Type No.=FIELD(No.);
//                     RunPageView = SORTING(Cross-Reference Type,Cross-Reference Type No.);
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
//                     RunPageView = SORTING(Vendor No.);
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
//                     Image = CustomerLedger;
//                     Promoted = true;
//                     PromotedCategory = Process;
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
//                                   Date Filter=FIELD(Date Filter),
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
//                 Promoted = false;
//                 //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
//                 //PromotedCategory = Process;
//                 RunObject = Page 254;
//             }
//         }
//         area(reporting)
//         {
//             group(General)
//             {
//                 Caption = 'General';
//                 action("Vendor - List")
//                 {
//                     Caption = 'Vendor - List';
//                     Image = "Report";
//                     Promoted = false;
//                     //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
//                     //PromotedCategory = "Report";
//                     RunObject = Report 301;
//                 }
//                 action("Vendor Register")
//                 {
//                     Caption = 'Vendor Register';
//                     Image = "Report";
//                     Promoted = false;
//                     //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
//                     //PromotedCategory = "Report";
//                     RunObject = Report 303;
//                 }
//                 action("Vendor Item Catalog")
//                 {
//                     Caption = 'Vendor Item Catalog';
//                     Image = "Report";
//                     Promoted = false;
//                     //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
//                     //PromotedCategory = "Report";
//                     RunObject = Report 320;
//                 }
//                 action("Vendor - Labels")
//                 {
//                     Caption = 'Vendor - Labels';
//                     Image = "Report";
//                     Promoted = false;
//                     //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
//                     //PromotedCategory = "Report";
//                     RunObject = Report 310;
//                 }
//                 action("Vendor - Top 10 List")
//                 {
//                     Caption = 'Vendor - Top 10 List';
//                     Image = "Report";
//                     Promoted = true;
//                     PromotedCategory = "Report";
//                     RunObject = Report 311;
//                 }
//             }
//             group(Orders)
//             {
//                 Caption = 'Orders';
//                 Image = "Report";
//                 action("Vendor - Order Summary")
//                 {
//                     Caption = 'Vendor - Order Summary';
//                     Image = "Report";
//                     Promoted = true;
//                     PromotedCategory = "Report";
//                     RunObject = Report 307;
//                 }
//                 action("Vendor - Order Detail")
//                 {
//                     Caption = 'Vendor - Order Detail';
//                     Image = "Report";
//                     Promoted = false;
//                     //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
//                     //PromotedCategory = "Report";
//                     RunObject = Report 308;
//                 }
//             }
//             group(Purchase)
//             {
//                 Caption = 'Purchase';
//                 Image = Purchase;
//                 action("Vendor - Purchase List")
//                 {
//                     Caption = 'Vendor - Purchase List';
//                     Image = "Report";
//                     Promoted = true;
//                     PromotedCategory = "Report";
//                     RunObject = Report 309;
//                 }
//                 action("Vendor/Item Purchases")
//                 {
//                     Caption = 'Vendor/Item Purchases';
//                     Image = "Report";
//                     Promoted = false;
//                     //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
//                     //PromotedCategory = "Report";
//                     RunObject = Report 313;
//                 }
//                 action("Purchase Statistics")
//                 {
//                     Caption = 'Purchase Statistics';
//                     Image = "Report";
//                     Promoted = false;
//                     //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
//                     //PromotedCategory = "Report";
//                     RunObject = Report 312;
//                 }
//             }
//             group("Financial Management")
//             {
//                 Caption = 'Financial Management';
//                 Image = "Report";
//                 action("Payments on Hold")
//                 {
//                     Caption = 'Payments on Hold';
//                     Image = "Report";
//                     Promoted = true;
//                     PromotedCategory = "Report";
//                     RunObject = Report 319;
//                 }
//                 action("Vendor - Summary Aging")
//                 {
//                     Caption = 'Vendor - Summary Aging';
//                     Image = "Report";
//                     Promoted = false;
//                     //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
//                     //PromotedCategory = "Report";
//                     RunObject = Report 305;
//                 }
//                 action("Aged Accounts Payable")
//                 {
//                     Caption = 'Aged Accounts Payable';
//                     Image = "Report";
//                     Promoted = true;
//                     PromotedCategory = "Report";
//                     RunObject = Report 322;
//                 }
//                 action("Vendor - Balance to Date")
//                 {
//                     Caption = 'Vendor - Balance to Date';
//                     Image = "Report";
//                     Promoted = true;
//                     PromotedCategory = "Report";
//                     RunObject = Report 321;
//                 }
//                 action("Vendor - Trial Balance")
//                 {
//                     Caption = 'Vendor - Trial Balance';
//                     Image = "Report";
//                     Promoted = false;
//                     //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
//                     //PromotedCategory = "Report";
//                     RunObject = Report 329;
//                 }
//                 action("Vendor - Detail Trial Balance")
//                 {
//                     Caption = 'Vendor - Detail Trial Balance';
//                     Image = "Report";
//                     Promoted = false;
//                     //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
//                     //PromotedCategory = "Report";
//                     RunObject = Report 304;
//                 }
//             }
//         }
//     }

//     procedure GetSelectionFilter(): Text
//     var
//         Vend: Record "23";
//         SelectionFilterManagement: Codeunit "46";
//     begin
//         CurrPage.SETSELECTIONFILTER(Vend);
//         EXIT(SelectionFilterManagement.GetSelectionFilterForVendor(Vend));
//     end;

//     procedure SetSelection(var Vend: Record "23")
//     begin
//         CurrPage.SETSELECTIONFILTER(Vend);
//     end;
// }

