// page 21 "Customer Card"
// {
//     Caption = 'Customer Card';
//     PageType = Card;
//     RefreshOnActivate = true;
//     SourceTable = Table18;

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
//                 field("Name 2";"Name 2")
//                 {
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
//                 field(City;City)
//                 {
//                 }
//                 field("Country/Region Code";"Country/Region Code")
//                 {
//                 }
//                 field(County;County)
//                 {
//                 }
//                 field("Phone No.";"Phone No.")
//                 {
//                 }
//                 field("Primary Contact No.";"Primary Contact No.")
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
//                 field("Search Name";"Search Name")
//                 {
//                 }
//                 field("Balance (LCY)";"Balance (LCY)")
//                 {

//                     trigger OnDrillDown()
//                     var
//                         DtldCustLedgEntry: Record "379";
//                         CustLedgEntry: Record "21";
//                     begin
//                         DtldCustLedgEntry.SETRANGE("Customer No.","No.");
//                         COPYFILTER("Global Dimension 1 Filter",DtldCustLedgEntry."Initial Entry Global Dim. 1");
//                         COPYFILTER("Global Dimension 2 Filter",DtldCustLedgEntry."Initial Entry Global Dim. 2");
//                         COPYFILTER("Currency Filter",DtldCustLedgEntry."Currency Code");
//                         CustLedgEntry.DrillDownOnEntries(DtldCustLedgEntry);
//                     end;
//                 }
//                 field("Credit Limit (LCY)";"Credit Limit (LCY)")
//                 {
//                     StyleExpr = StyleTxt;

//                     trigger OnValidate()
//                     begin
//                         StyleTxt := SetStyle;
//                     end;
//                 }
//                 field("Salesperson Code";"Salesperson Code")
//                 {
//                 }
//                 field("Responsibility Center";"Responsibility Center")
//                 {
//                 }
//                 field("Customer Point";"Customer Point")
//                 {
//                     Caption = 'Customer Points';
//                 }
//                 field("Promoter Price Group";"Promoter Price Group")
//                 {
//                 }
//                 field("Exclude from Prod. Comm.";"Exclude from Prod. Comm.")
//                 {
//                 }
//                 field("Service Zone Code";"Service Zone Code")
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
//             }
//             group(Invoicing)
//             {
//                 Caption = 'Invoicing';
//                 field("Bill-to Customer No.";"Bill-to Customer No.")
//                 {
//                 }
//                 field("Invoice Copies";"Invoice Copies")
//                 {
//                 }
//                 field("Invoice Disc. Code";"Invoice Disc. Code")
//                 {
//                     NotBlank = true;
//                 }
//                 field("Copy Sell-to Addr. to Qte From";"Copy Sell-to Addr. to Qte From")
//                 {
//                 }
//                 field("Gen. Bus. Posting Group";"Gen. Bus. Posting Group")
//                 {
//                     Importance = Promoted;
//                 }
//                 field("VAT Bus. Posting Group";"VAT Bus. Posting Group")
//                 {
//                     Caption = 'GST Bus. Posting Group';
//                 }
//                 field("Customer Posting Group";"Customer Posting Group")
//                 {
//                     Importance = Promoted;
//                 }
//                 field("Customer Price Group";"Customer Price Group")
//                 {
//                     Importance = Promoted;
//                 }
//                 field("Customer Disc. Group";"Customer Disc. Group")
//                 {
//                     Importance = Promoted;
//                 }
//                 field("Allow Line Disc.";"Allow Line Disc.")
//                 {
//                 }
//                 field("Prices Including VAT";"Prices Including VAT")
//                 {
//                     Caption = 'Prices Including GST';
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
//                 field("Reminder Terms Code";"Reminder Terms Code")
//                 {
//                     Importance = Promoted;
//                 }
//                 field("Fin. Charge Terms Code";"Fin. Charge Terms Code")
//                 {
//                     Importance = Promoted;
//                 }
//                 field("Cash Flow Payment Terms Code";"Cash Flow Payment Terms Code")
//                 {
//                 }
//                 field("Print Statements";"Print Statements")
//                 {
//                 }
//                 field("Last Statement No.";"Last Statement No.")
//                 {
//                 }
//                 field("Block Payment Tolerance";"Block Payment Tolerance")
//                 {
//                 }
//                 field("Preferred Bank Account";"Preferred Bank Account")
//                 {
//                 }
//             }
//             group(Shipping)
//             {
//                 Caption = 'Shipping';
//                 field("Location Code";"Location Code")
//                 {
//                     Importance = Promoted;
//                 }
//                 field("Combine Shipments";"Combine Shipments")
//                 {
//                 }
//                 field(Reserve;Reserve)
//                 {
//                 }
//                 field("Shipping Advice";"Shipping Advice")
//                 {
//                     Importance = Promoted;
//                 }
//                 field("Shipment Method Code";"Shipment Method Code")
//                 {
//                     Importance = Promoted;
//                 }
//                 field("Shipping Agent Code";"Shipping Agent Code")
//                 {
//                     Importance = Promoted;
//                 }
//                 field("Shipping Agent Service Code";"Shipping Agent Service Code")
//                 {
//                 }
//                 field("Shipping Time";"Shipping Time")
//                 {
//                 }
//                 field("Base Calendar Code";"Base Calendar Code")
//                 {
//                     DrillDown = false;
//                 }
//                 field("Customized Calendar";CalendarMgmt.CustomizedCalendarExistText(CustomizedCalendar."Source Type"::Customer,"No.",'',"Base Calendar Code"))
//                 {
//                     Caption = 'Customized Calendar';
//                     Editable = false;

//                     trigger OnDrillDown()
//                     begin
//                         CurrPage.SAVERECORD;
//                         TESTFIELD("Base Calendar Code");
//                         CalendarMgmt.ShowCustomizedCalendar(CustomizedCalEntry."Source Type"::Customer,"No.",'',"Base Calendar Code");
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
//                     Caption = 'GST Registration No.';
//                 }
//             }
//         }
//         area(factboxes)
//         {
//             part(;9080)
//             {
//                 SubPageLink = No.=FIELD(No.),
//                               Currency Filter=FIELD(Currency Filter),
//                               Date Filter=FIELD(Date Filter),
//                               Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
//                               Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter);
//                 Visible = true;
//             }
//             part(;9081)
//             {
//                 SubPageLink = No.=FIELD(No.),
//                               Currency Filter=FIELD(Currency Filter),
//                               Date Filter=FIELD(Date Filter),
//                               Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
//                               Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter);
//                 Visible = false;
//             }
//             part(;9082)
//             {
//                 SubPageLink = No.=FIELD(No.),
//                               Currency Filter=FIELD(Currency Filter),
//                               Date Filter=FIELD(Date Filter),
//                               Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
//                               Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter);
//                 Visible = true;
//             }
//             part(;9083)
//             {
//                 SubPageLink = Table ID=CONST(18),
//                               No.=FIELD(No.);
//                 Visible = false;
//             }
//             part(;9085)
//             {
//                 SubPageLink = No.=FIELD(No.),
//                               Currency Filter=FIELD(Currency Filter),
//                               Date Filter=FIELD(Date Filter),
//                               Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
//                               Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter);
//                 Visible = false;
//             }
//             part(;9086)
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
//             group("&Customer")
//             {
//                 Caption = '&Customer';
//                 Image = Customer;
//                 action(Dimensions)
//                 {
//                     Caption = 'Dimensions';
//                     Image = Dimensions;
//                     RunObject = Page 540;
//                     RunPageLink = Table ID=CONST(18),
//                                   No.=FIELD(No.);
//                     ShortCutKey = 'Shift+Ctrl+D';
//                 }
//                 action("Bank Accounts")
//                 {
//                     Caption = 'Bank Accounts';
//                     Image = BankAccount;
//                     RunObject = Page 424;
//                     RunPageLink = Customer No.=FIELD(No.);
//                 }
//                 action("Direct Debit Mandates")
//                 {
//                     Caption = 'Direct Debit Mandates';
//                     Image = MakeAgreement;
//                     RunObject = Page 1230;
//                     RunPageLink = Customer No.=FIELD(No.);
//                 }
//                 action("Ship-&to Addresses")
//                 {
//                     Caption = 'Ship-&to Addresses';
//                     Image = ShipAddress;
//                     RunObject = Page 301;
//                     RunPageLink = Customer No.=FIELD(No.);
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
//                 action("Cross Re&ferences")
//                 {
//                     Caption = 'Cross Re&ferences';
//                     Image = Change;
//                     RunObject = Page 5723;
//                     RunPageLink = Cross-Reference Type=CONST(Customer),
//                                   Cross-Reference Type No.=FIELD(No.);
//                     RunPageView = SORTING(Cross-Reference Type,Cross-Reference Type No.);
//                 }
//                 action("Co&mments")
//                 {
//                     Caption = 'Co&mments';
//                     Image = ViewComments;
//                     RunObject = Page 124;
//                     RunPageLink = Table Name=CONST(Customer),
//                                   No.=FIELD(No.);
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
//             }
//             group(History)
//             {
//                 Caption = 'History';
//                 Image = History;
//                 action("Ledger E&ntries")
//                 {
//                     Caption = 'Ledger E&ntries';
//                     Image = CustomerLedger;
//                     Promoted = false;
//                     //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
//                     //PromotedCategory = Process;
//                     RunObject = Page 25;
//                     RunPageLink = Customer No.=FIELD(No.);
//                     RunPageView = SORTING(Customer No.);
//                     ShortCutKey = 'Ctrl+F7';
//                 }
//                 action(Statistics)
//                 {
//                     Caption = 'Statistics';
//                     Image = Statistics;
//                     Promoted = true;
//                     PromotedCategory = Process;
//                     RunObject = Page 151;
//                     RunPageLink = No.=FIELD(No.),
//                                   Date Filter=FIELD(Date Filter),
//                                   Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
//                                   Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter);
//                     ShortCutKey = 'F7';
//                 }
//                 action("S&ales")
//                 {
//                     Caption = 'S&ales';
//                     Image = Sales;
//                     RunObject = Page 155;
//                     RunPageLink = No.=FIELD(No.),
//                                   Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
//                                   Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter);
//                 }
//                 action("Entry Statistics")
//                 {
//                     Caption = 'Entry Statistics';
//                     Image = EntryStatistics;
//                     RunObject = Page 302;
//                     RunPageLink = No.=FIELD(No.),
//                                   Date Filter=FIELD(Date Filter),
//                                   Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
//                                   Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter);
//                 }
//                 action("Statistics by C&urrencies")
//                 {
//                     Caption = 'Statistics by C&urrencies';
//                     Image = Currencies;
//                     RunObject = Page 486;
//                     RunPageLink = Customer Filter=FIELD(No.),
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
//                         ItemTrackingMgt.CallItemTrackingEntryForm(1,"No.",'','','','','');
//                     end;
//                 }
//                 separator()
//                 {
//                 }
//             }
//             group("S&ales")
//             {
//                 Caption = 'S&ales';
//                 Image = Sales;
//                 action("Invoice &Discounts")
//                 {
//                     Caption = 'Invoice &Discounts';
//                     Image = CalculateInvoiceDiscount;
//                     RunObject = Page 23;
//                     RunPageLink = Code=FIELD(Invoice Disc. Code);
//                 }
//                 action(Prices)
//                 {
//                     Caption = 'Prices';
//                     Image = Price;
//                     RunObject = Page 7002;
//                     RunPageLink = Sales Type=CONST(Customer),
//                                   Sales Code=FIELD(No.);
//                     RunPageView = SORTING(Sales Type,Sales Code);
//                 }
//                 action("Line Discounts")
//                 {
//                     Caption = 'Line Discounts';
//                     Image = LineDiscount;
//                     RunObject = Page 7004;
//                     RunPageLink = Sales Type=CONST(Customer),
//                                   Sales Code=FIELD(No.);
//                     RunPageView = SORTING(Sales Type,Sales Code);
//                 }
//                 action("Prepa&yment Percentages")
//                 {
//                     Caption = 'Prepa&yment Percentages';
//                     Image = PrepaymentPercentages;
//                     RunObject = Page 664;
//                     RunPageLink = Sales Type=CONST(Customer),
//                                   Sales Code=FIELD(No.);
//                     RunPageView = SORTING(Sales Type,Sales Code);
//                 }
//                 action("S&td. Cust. Sales Codes")
//                 {
//                     Caption = 'S&td. Cust. Sales Codes';
//                     Image = CodesList;
//                     RunObject = Page 173;
//                     RunPageLink = Customer No.=FIELD(No.);
//                 }
//             }
//             group(Documents)
//             {
//                 Caption = 'Documents';
//                 Image = Documents;
//                 action(Quotes)
//                 {
//                     Caption = 'Quotes';
//                     Image = Quote;
//                     RunObject = Page 9300;
//                     RunPageLink = Sell-to Customer No.=FIELD(No.);
//                     RunPageView = SORTING(Document Type,Sell-to Customer No.);
//                 }
//                 action(Orders)
//                 {
//                     Caption = 'Orders';
//                     Image = Document;
//                     RunObject = Page 9305;
//                     RunPageLink = Sell-to Customer No.=FIELD(No.);
//                     RunPageView = SORTING(Document Type,Sell-to Customer No.);
//                 }
//                 action("Return Orders")
//                 {
//                     Caption = 'Return Orders';
//                     Image = ReturnOrder;
//                     RunObject = Page 9304;
//                     RunPageLink = Sell-to Customer No.=FIELD(No.);
//                     RunPageView = SORTING(Document Type,Sell-to Customer No.);
//                 }
//                 group("Issued Documents")
//                 {
//                     Caption = 'Issued Documents';
//                     Image = Documents;
//                     action("Issued &Reminders")
//                     {
//                         Caption = 'Issued &Reminders';
//                         Image = OrderReminder;
//                         RunObject = Page 440;
//                         RunPageLink = Customer No.=FIELD(No.);
//                         RunPageView = SORTING(Customer No.,Posting Date);
//                     }
//                     action("Issued &Finance Charge Memos")
//                     {
//                         Caption = 'Issued &Finance Charge Memos';
//                         Image = FinChargeMemo;
//                         RunObject = Page 452;
//                         RunPageLink = Customer No.=FIELD(No.);
//                         RunPageView = SORTING(Customer No.,Posting Date);
//                     }
//                 }
//                 action("Blanket Orders")
//                 {
//                     Caption = 'Blanket Orders';
//                     Image = BlanketOrder;
//                     RunObject = Page 9303;
//                     RunPageLink = Sell-to Customer No.=FIELD(No.);
//                     RunPageView = SORTING(Document Type,Sell-to Customer No.);
//                 }
//                 action("&Jobs")
//                 {
//                     Caption = '&Jobs';
//                     Image = Job;
//                     RunObject = Page 89;
//                     RunPageLink = Bill-to Customer No.=FIELD(No.);
//                     RunPageView = SORTING(Bill-to Customer No.);
//                 }
//             }
//             group("Credit Card")
//             {
//                 Caption = 'Credit Card';
//                 Image = CreditCard;
//                 group("Credit Cards")
//                 {
//                     Caption = 'Credit Cards';
//                     Image = CreditCard;
//                     action("C&redit Cards")
//                     {
//                         Caption = 'C&redit Cards';
//                         Image = CreditCard;
//                         RunObject = Page 828;
//                         RunPageLink = Customer No.=FIELD(No.);
//                     }
//                     action("Credit Cards Transaction Lo&g Entries")
//                     {
//                         Caption = 'Credit Cards Transaction Lo&g Entries';
//                         Image = CreditCardLog;
//                         RunObject = Page 829;
//                         RunPageLink = Customer No.=FIELD(No.);
//                     }
//                 }
//             }
//             group(Service)
//             {
//                 Caption = 'Service';
//                 Image = ServiceItem;
//                 action("Service Orders")
//                 {
//                     Caption = 'Service Orders';
//                     Image = Document;
//                     RunObject = Page 9318;
//                     RunPageLink = Customer No.=FIELD(No.);
//                     RunPageView = SORTING(Document Type,Customer No.);
//                 }
//                 action("Ser&vice Contracts")
//                 {
//                     Caption = 'Ser&vice Contracts';
//                     Image = ServiceAgreement;
//                     RunObject = Page 6065;
//                     RunPageLink = Customer No.=FIELD(No.);
//                     RunPageView = SORTING(Customer No.,Ship-to Code);
//                 }
//                 action("Service &Items")
//                 {
//                     Caption = 'Service &Items';
//                     Image = ServiceItem;
//                     RunObject = Page 5988;
//                     RunPageLink = Customer No.=FIELD(No.);
//                     RunPageView = SORTING(Customer No.,Ship-to Code,Item No.,Serial No.);
//                 }
//             }
//         }
//         area(creation)
//         {
//             action("Blanket Sales Order")
//             {
//                 Caption = 'Blanket Sales Order';
//                 Image = BlanketOrder;
//                 Promoted = false;
//                 //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
//                 //PromotedCategory = New;
//                 RunObject = Page 507;
//                 RunPageLink = Sell-to Customer No.=FIELD(No.);
//                 RunPageMode = Create;
//             }
//             action("Sales Quote")
//             {
//                 Caption = 'Sales Quote';
//                 Image = Quote;
//                 Promoted = false;
//                 //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
//                 //PromotedCategory = New;
//                 RunObject = Page 41;
//                 RunPageLink = Sell-to Customer No.=FIELD(No.);
//                 RunPageMode = Create;
//             }
//             action("Sales Invoice")
//             {
//                 Caption = 'Sales Invoice';
//                 Image = Invoice;
//                 Promoted = true;
//                 PromotedCategory = New;
//                 RunObject = Page 43;
//                 RunPageLink = Sell-to Customer No.=FIELD(No.);
//                 RunPageMode = Create;
//             }
//             action("Sales Order")
//             {
//                 Caption = 'Sales Order';
//                 Image = Document;
//                 Promoted = true;
//                 PromotedCategory = New;
//                 RunObject = Page 42;
//                 RunPageLink = Sell-to Customer No.=FIELD(No.);
//                 RunPageMode = Create;
//             }
//             action("Sales Credit Memo")
//             {
//                 Caption = 'Sales Credit Memo';
//                 Image = CreditMemo;
//                 Promoted = false;
//                 //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
//                 //PromotedCategory = New;
//                 RunObject = Page 44;
//                 RunPageLink = Sell-to Customer No.=FIELD(No.);
//                 RunPageMode = Create;
//             }
//             action("Sales Return Order")
//             {
//                 Caption = 'Sales Return Order';
//                 Image = ReturnOrder;
//                 Promoted = false;
//                 //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
//                 //PromotedCategory = New;
//                 RunObject = Page 6630;
//                 RunPageLink = Sell-to Customer No.=FIELD(No.);
//                 RunPageMode = Create;
//             }
//             action("Service Quote")
//             {
//                 Caption = 'Service Quote';
//                 Image = Quote;
//                 Promoted = false;
//                 //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
//                 //PromotedCategory = New;
//                 RunObject = Page 5964;
//                 RunPageLink = Customer No.=FIELD(No.);
//                 RunPageMode = Create;
//             }
//             action("Service Invoice")
//             {
//                 Caption = 'Service Invoice';
//                 Image = Invoice;
//                 Promoted = false;
//                 //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
//                 //PromotedCategory = New;
//                 RunObject = Page 5933;
//                 RunPageLink = Customer No.=FIELD(No.);
//                 RunPageMode = Create;
//             }
//             action("Service Order")
//             {
//                 Caption = 'Service Order';
//                 Image = Document;
//                 Promoted = false;
//                 //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
//                 //PromotedCategory = New;
//                 RunObject = Page 5900;
//                 RunPageLink = Customer No.=FIELD(No.);
//                 RunPageMode = Create;
//             }
//             action("Service Credit Memo")
//             {
//                 Caption = 'Service Credit Memo';
//                 Image = CreditMemo;
//                 Promoted = false;
//                 //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
//                 //PromotedCategory = New;
//                 RunObject = Page 5935;
//                 RunPageLink = Customer No.=FIELD(No.);
//                 RunPageMode = Create;
//             }
//             action(Reminder)
//             {
//                 Caption = 'Reminder';
//                 Image = Reminder;
//                 Promoted = true;
//                 PromotedCategory = New;
//                 RunObject = Page 434;
//                 RunPageLink = Customer No.=FIELD(No.);
//                 RunPageMode = Create;
//             }
//             action("Finance Charge Memo")
//             {
//                 Caption = 'Finance Charge Memo';
//                 Image = FinChargeMemo;
//                 Promoted = false;
//                 //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
//                 //PromotedCategory = New;
//                 RunObject = Page 446;
//                 RunPageLink = Customer No.=FIELD(No.);
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
//             action("Cash Receipt Journal")
//             {
//                 Caption = 'Cash Receipt Journal';
//                 Image = CashReceiptJournal;
//                 Promoted = true;
//                 PromotedCategory = Process;
//                 RunObject = Page 255;
//             }
//             action("Update Customer Points")
//             {
//                 Caption = 'Update Customer Points';
//                 Image = Document;
//                 Promoted = true;
//                 PromotedCategory = Process;
//                 RunObject = Page 50003;
//             }
//             action("Sales Journal")
//             {
//                 Caption = 'Sales Journal';
//                 Image = Journals;
//                 Promoted = true;
//                 PromotedCategory = Process;
//                 RunObject = Page 253;
//             }
//         }
//         area(reporting)
//         {
//             action("Customer Detailed Aging")
//             {
//                 Caption = 'Customer Detailed Aging';
//                 Image = "Report";
//                 Promoted = false;
//                 //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
//                 //PromotedCategory = "Report";
//                 RunObject = Report 106;
//             }
//             action("Customer - Labels")
//             {
//                 Caption = 'Customer - Labels';
//                 Image = "Report";
//                 Promoted = false;
//                 //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
//                 //PromotedCategory = "Report";
//                 RunObject = Report 110;
//             }
//             action("Customer - Balance to Date")
//             {
//                 Caption = 'Customer - Balance to Date';
//                 Image = "Report";
//                 Promoted = true;
//                 PromotedCategory = "Report";
//                 RunObject = Report 121;
//             }
//         }
//     }

//     trigger OnAfterGetCurrRecord()
//     begin
//         ActivateFields;
//         StyleTxt := SetStyle;
//     end;

//     trigger OnAfterGetRecord()
//     begin
//         ActivateFields;
//         StyleTxt := SetStyle;
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
//         CustomizedCalEntry: Record "7603";
//         CustomizedCalendar: Record "7602";
//         CalendarMgmt: Codeunit "7600";
//         StyleTxt: Text;
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

