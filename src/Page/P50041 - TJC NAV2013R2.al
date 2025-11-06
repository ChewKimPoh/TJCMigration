// page 50041 "Financial Mgmt. Role Center"
// {
//     PageType = RoleCenter;

//     layout
//     {
//         area(rolecenter)
//         {
//             group()
//             {
//                 part(;50048)
//                 {
//                     Visible = false;
//                 }
//                 systempart(;Outlook)
//                 {
//                     Visible = false;
//                 }
//             }
//             group()
//             {
//                 systempart(;MyNotes)
//                 {
//                 }
//             }
//         }
//     }

//     actions
//     {
//         area(reporting)
//         {
//             group("TJC - Finance")
//             {
//                 Caption = 'TJC - Finance';
//                 group("General Ledger")
//                 {
//                     Caption = 'General Ledger';
//                     Image = "Report";
//                     group(Entries)
//                     {
//                         Caption = 'Entries';
//                         Image = "Report";
//                         action("G/L Register")
//                         {
//                             Caption = 'G/L Register';
//                             Image = "Report";
//                             RunObject = Report 3;
//                         }
//                         action("Detail Trial Balance")
//                         {
//                             Caption = 'Detail Trial Balance';
//                             Image = "Report";
//                             RunObject = Report 4;
//                         }
//                         action("General Journal - Test")
//                         {
//                             Caption = 'General Journal - Test';
//                             Image = "Report";
//                             RunObject = Report 2;
//                         }
//                         action("Dimensions - Detail")
//                         {
//                             Caption = 'Dimensions - Detail';
//                             Image = "Report";
//                             RunObject = Report 28;
//                         }
//                         action("Dimensions - Total")
//                         {
//                             Caption = 'Dimensions - Total';
//                             Image = "Report";
//                             RunObject = Report 27;
//                         }
//                         action("Check Value Posting")
//                         {
//                             Caption = 'Check Value Posting';
//                             Image = "Report";
//                             RunObject = Report 30;
//                         }
//                     }
//                     group("Financial Statement")
//                     {
//                         Caption = 'Financial Statement';
//                         Image = "Report";
//                         action("Account Schedule")
//                         {
//                             Caption = 'Account Schedule';
//                             Image = "Report";
//                             RunObject = Report 25;
//                         }
//                         action(Budget)
//                         {
//                             Caption = 'Budget';
//                             Image = "Report";
//                             RunObject = Report 8;
//                         }
//                         action("&G/L Trial Balance")
//                         {
//                             Caption = '&G/L Trial Balance';
//                             Image = "Report";
//                             RunObject = Report 6;
//                         }
//                         action("Trial Bala&nce/Budget")
//                         {
//                             Caption = 'Trial Bala&nce/Budget';
//                             Image = "Report";
//                             RunObject = Report 9;
//                         }
//                         action("Trial Balance/Previous Year")
//                         {
//                             Caption = 'Trial Balance/Previous Year';
//                             Image = "Report";
//                             RunObject = Report 7;
//                         }
//                         action("Trial Balance by &Period")
//                         {
//                             Caption = 'Trial Balance by &Period';
//                             Image = "Report";
//                             RunObject = Report 38;
//                         }
//                         action("&Fiscal Year Balance")
//                         {
//                             Caption = '&Fiscal Year Balance';
//                             Image = "Report";
//                             RunObject = Report 36;
//                         }
//                         action("Balance Comp. - Prev. Y&ear")
//                         {
//                             Caption = 'Balance Comp. - Prev. Y&ear';
//                             Image = "Report";
//                             RunObject = Report 37;
//                         }
//                         action("&Closing Trial Balance")
//                         {
//                             Caption = '&Closing Trial Balance';
//                             Image = "Report";
//                             RunObject = Report 10;
//                         }
//                         action("Consolidated Trial Balance")
//                         {
//                             Caption = 'Consolidated Trial Balance';
//                             Image = "report";
//                             RunObject = Report 17;
//                         }
//                         action("Consolidated Trial Balance (4)")
//                         {
//                             Caption = 'Consolidated Trial Balance (4)';
//                             Image = "report";
//                             RunObject = Report 18;
//                         }
//                         action("Balance Sheet")
//                         {
//                             Caption = 'Balance Sheet';
//                             Image = "report";
//                             RunObject = Report 50039;
//                         }
//                         action("Income Statement")
//                         {
//                             Caption = 'Income Statement';
//                             Image = "report";
//                             RunObject = Report 50040;
//                         }
//                     }
//                     group("GST Reporting")
//                     {
//                         Caption = 'GST Reporting';
//                         Image = "Report";
//                         action("GST E&xceptions")
//                         {
//                             Caption = 'GST E&xceptions';
//                             Image = "Report";
//                             RunObject = Report 31;
//                         }
//                         action("GST Register")
//                         {
//                             Caption = 'GST Register';
//                             Image = "report";
//                             RunObject = Report 13;
//                         }
//                         action("&GST Registration No. Check")
//                         {
//                             Caption = '&GST Registration No. Check';
//                             Image = "Report";
//                             RunObject = Report 32;
//                         }
//                         action("GST &Statement")
//                         {
//                             Caption = 'GST &Statement';
//                             Image = "Report";
//                             RunObject = Report 12;
//                         }
//                         action("GST - VIES Declaration Tax Aut&h")
//                         {
//                             Caption = 'GST - VIES Declaration Tax Aut&h';
//                             Image = "Report";
//                             RunObject = Report 19;
//                         }
//                     }
//                     group("Setup List")
//                     {
//                         Caption = 'Setup List';
//                         Image = "Report";
//                         action("Chart of Accounts")
//                         {
//                             Caption = 'Chart of Accounts';
//                             Image = "report";
//                             RunObject = Report 1;
//                         }
//                         action("No. Series")
//                         {
//                             Caption = 'No. Series';
//                             Image = "report";
//                             RunObject = Report 21;
//                         }
//                         action("No. Series Check")
//                         {
//                             Caption = 'No. Series Check';
//                             Image = "report";
//                             RunObject = Report 22;
//                         }
//                         action("G/L Document Nos.")
//                         {
//                             Caption = 'G/L Document Nos.';
//                             Image = "report";
//                             RunObject = Report 23;
//                         }
//                         action("Change Log Setup List")
//                         {
//                             Caption = 'Change Log Setup List';
//                             Image = "report";
//                             RunObject = Report 508;
//                         }
//                     }
//                     group("Periodic Activities")
//                     {
//                         Caption = 'Periodic Activities';
//                         Image = "Report";
//                         action("Update Analysis Views")
//                         {
//                             Caption = 'Update Analysis Views';
//                             Image = "report";
//                             RunObject = Report 84;
//                         }
//                         action("GST - Calc. and Post GST Settlement")
//                         {
//                             Caption = 'GST - Calc. and Post GST Settlement';
//                             Image = "report";
//                             RunObject = Report 20;
//                         }
//                         action("GST - GST-VIES Declaration Disk")
//                         {
//                             Caption = 'GST - GST-VIES Declaration Disk';
//                             Image = "report";
//                             RunObject = Report 88;
//                         }
//                         action("Currency - Adjust Exchange Rates")
//                         {
//                             Caption = 'Currency - Adjust Exchange Rates';
//                             Image = "report";
//                             RunObject = Report 595;
//                         }
//                     }
//                 }
//                 group("Cash Management")
//                 {
//                     Caption = 'Cash Management';
//                     Image = "report";
//                     action(Register)
//                     {
//                         Caption = 'Register';
//                         Image = "report";
//                         RunObject = Report 1403;
//                     }
//                     action("Check Details")
//                     {
//                         Caption = 'Check Details';
//                         Image = "report";
//                         RunObject = Report 1406;
//                     }
//                     action(Labels)
//                     {
//                         Caption = 'Labels';
//                         Image = "report";
//                         RunObject = Report 1405;
//                     }
//                     action(List)
//                     {
//                         Caption = 'List';
//                         Image = "report";
//                         RunObject = Report 1402;
//                     }
//                     action("Detail Trial Balance")
//                     {
//                         Caption = 'Detail Trial Balance';
//                         Image = "report";
//                         RunObject = Report 1404;
//                     }
//                 }
//                 group(Receivables)
//                 {
//                     Caption = 'Receivables';
//                     Image = "report";
//                     action("Customer - Summary Aging")
//                     {
//                         Caption = 'Customer - Summary Aging';
//                         Image = "Report";
//                         RunObject = Report 105;
//                     }
//                     action("Customer - Summary Aging Simp.")
//                     {
//                         Caption = 'Customer - Summary Aging Simp.';
//                         Image = "report";
//                         RunObject = Report 109;
//                     }
//                     action("Customer Detailed Aging")
//                     {
//                         Caption = 'Customer Detailed Aging';
//                         Image = "report";
//                         RunObject = Report 106;
//                     }
//                     action("Aged Accounts Receivable")
//                     {
//                         Caption = 'Aged Accounts Receivable';
//                         Image = "report";
//                         RunObject = Report 120;
//                     }
//                     action("Customer - Balance to Date")
//                     {
//                         Caption = 'Customer - Balance to Date';
//                         Image = "report";
//                         RunObject = Report 121;
//                     }
//                     action("Customer - Trial Balance")
//                     {
//                         Caption = 'Customer - Trial Balance';
//                         Image = "report";
//                         RunObject = Report 129;
//                     }
//                     action("Customer - Detail Trial Bal.")
//                     {
//                         Caption = 'Customer - Detail Trial Bal.';
//                         Image = "report";
//                         RunObject = Report 104;
//                     }
//                     action("Customer - List")
//                     {
//                         Caption = 'Customer - List';
//                         Image = "report";
//                         RunObject = Report 101;
//                     }
//                     action("Customer Register")
//                     {
//                         Caption = 'Customer Register';
//                         Image = "report";
//                         RunObject = Report 103;
//                     }
//                     action("Customer - Order Summary")
//                     {
//                         Caption = 'Customer - Order Summary';
//                         Image = "report";
//                         RunObject = Report 107;
//                     }
//                     action("Customer - Order Detail")
//                     {
//                         Caption = 'Customer - Order Detail';
//                         Image = "report";
//                         RunObject = Report 108;
//                     }
//                     action("Customer - Top 10 List")
//                     {
//                         Caption = 'Customer - Top 10 List';
//                         Image = "report";
//                         RunObject = Report 111;
//                     }
//                     action("Customer - Sales List")
//                     {
//                         Caption = 'Customer - Sales List';
//                         Image = "report";
//                         RunObject = Report 119;
//                     }
//                     action("Customer - Labels")
//                     {
//                         Caption = 'Customer - Labels';
//                         Image = "report";
//                         RunObject = Report 110;
//                     }
//                     action("Sales Statistics")
//                     {
//                         Caption = 'Sales Statistics';
//                         Image = "report";
//                         RunObject = Report 112;
//                     }
//                     action("Customer/Item Sales")
//                     {
//                         Caption = 'Customer/Item Sales';
//                         Image = "report";
//                         RunObject = Report 113;
//                     }
//                     action("Salesperson - Sales Statistics")
//                     {
//                         Caption = 'Salesperson - Sales Statistics';
//                         Image = "report";
//                         RunObject = Report 114;
//                     }
//                 }
//                 group(Payables)
//                 {
//                     Caption = 'Payables';
//                     Image = "report";
//                     action("Vendor - Summary Aging")
//                     {
//                         Caption = 'Vendor - Summary Aging';
//                         Image = "report";
//                         RunObject = Report 305;
//                     }
//                     action("Aged Accounts Payable")
//                     {
//                         Caption = 'Aged Accounts Payable';
//                         Image = "report";
//                         RunObject = Report 322;
//                     }
//                     action("Vendor - Balance to Date")
//                     {
//                         Caption = 'Vendor - Balance to Date';
//                         Image = "report";
//                         RunObject = Report 321;
//                     }
//                     action("Vendor - Trial Balance")
//                     {
//                         Caption = 'Vendor - Trial Balance';
//                         Image = "report";
//                         RunObject = Report 329;
//                     }
//                     action("Vendor - Detail Trial Balance")
//                     {
//                         Caption = 'Vendor - Detail Trial Balance';
//                         Image = "report";
//                         RunObject = Report 304;
//                     }
//                     action("Vendor - List")
//                     {
//                         Caption = 'Vendor - List';
//                         Image = "report";
//                         RunObject = Report 301;
//                     }
//                     action("Vendor Register")
//                     {
//                         Caption = 'Vendor Register';
//                         Image = "report";
//                         RunObject = Report 303;
//                     }
//                     action("Vendor - Order Summary")
//                     {
//                         Caption = 'Vendor - Order Summary';
//                         Image = "report";
//                         RunObject = Report 307;
//                     }
//                     action("Vendor - Order Detail")
//                     {
//                         Caption = 'Vendor - Order Detail';
//                         Image = "report";
//                         RunObject = Report 308;
//                     }
//                     action("Vendor - Top 10 List")
//                     {
//                         Caption = 'Vendor - Top 10 List';
//                         Image = "report";
//                         RunObject = Report 311;
//                     }
//                     action("Vendor - Purchase List")
//                     {
//                         Caption = 'Vendor - Purchase List';
//                         Image = "report";
//                         RunObject = Report 309;
//                     }
//                     action("Vendor - Labels")
//                     {
//                         Caption = 'Vendor - Labels';
//                         Image = "report";
//                         RunObject = Report 310;
//                     }
//                     action("Payments on Hold")
//                     {
//                         Caption = 'Payments on Hold';
//                         Image = "report";
//                         RunObject = Report 319;
//                     }
//                     action("Purchase Statistics")
//                     {
//                         Caption = 'Purchase Statistics';
//                         Image = "report";
//                         RunObject = Report 312;
//                     }
//                     action("Vendor/Item Purchases")
//                     {
//                         Caption = 'Vendor/Item Purchases';
//                         Image = "report";
//                         RunObject = Report 313;
//                     }
//                     action("Vendor Item Catalog")
//                     {
//                         Caption = 'Vendor Item Catalog';
//                         Image = "report";
//                         RunObject = Report 320;
//                     }
//                     action("Vendor Document Nos.")
//                     {
//                         Caption = 'Vendor Document Nos.';
//                         Image = "report";
//                         RunObject = Report 328;
//                     }
//                     action("Purchase Invoice Nos.")
//                     {
//                         Caption = 'Purchase Invoice Nos.';
//                         Image = "report";
//                         RunObject = Report 324;
//                     }
//                     action("Purchase Credit Memo Nos.")
//                     {
//                         Caption = 'Purchase Credit Memo Nos.';
//                         Image = "report";
//                         RunObject = Report 325;
//                     }
//                 }
//                 group(Inventory)
//                 {
//                     Caption = 'Inventory';
//                     Image = "report";
//                     action("Inventory Valuation")
//                     {
//                         Caption = 'Inventory Valuation';
//                         Image = "report";
//                         RunObject = Report 1001;
//                     }
//                     action("Inventory Valuation - WIP")
//                     {
//                         Caption = 'Inventory Valuation - WIP';
//                         Image = "report";
//                         RunObject = Report 5802;
//                     }
//                     action("Inventory - List")
//                     {
//                         Caption = 'Inventory - List';
//                         Image = "report";
//                         RunObject = Report 701;
//                     }
//                     action("Invt. Valuation - Cost Spec.")
//                     {
//                         Caption = 'Invt. Valuation - Cost Spec.';
//                         Image = "report";
//                         RunObject = Report 5801;
//                     }
//                     action("Item Age Composition - Value")
//                     {
//                         Caption = 'Item Age Composition - Value';
//                         Image = "report";
//                         RunObject = Report 5808;
//                     }
//                     action("Item Register - Value")
//                     {
//                         Caption = 'Item Register - Value';
//                         Image = "report";
//                         RunObject = Report 5805;
//                     }
//                     action("Physical Inventory List")
//                     {
//                         Caption = 'Physical Inventory List';
//                         Image = "report";
//                         RunObject = Report 722;
//                     }
//                     action(Status)
//                     {
//                         Caption = 'Status';
//                         Image = "report";
//                         RunObject = Report 706;
//                     }
//                 }
//             }
//             group("TJC - Sales Front Office")
//             {
//                 Caption = 'TJC - Sales Front Office';
//                 action("Set Customer Points to Redeeme")
//                 {
//                     Caption = 'Set Customer Points to Redeeme';
//                     RunObject = Report 50029;
//                 }
//                 group("Sales Reports")
//                 {
//                     Caption = 'Sales Reports';
//                     Image = "Report";
//                     action("Customer - Order Detail")
//                     {
//                         Caption = 'Customer - Order Detail';
//                         Image = "Report";
//                         RunObject = Report 108;
//                     }
//                     action("Customer - &Order Summary")
//                     {
//                         Caption = 'Customer - &Order Summary';
//                         Image = "Report";
//                         RunObject = Report 107;
//                     }
//                     action("Customer - &Top 10 List")
//                     {
//                         Caption = 'Customer - &Top 10 List';
//                         Image = "Report";
//                         RunObject = Report 111;
//                     }
//                     separator()
//                     {
//                     }
//                     action("S&ales Statistics")
//                     {
//                         Caption = 'S&ales Statistics';
//                         Image = "Report";
//                         RunObject = Report 112;
//                     }
//                     action("Salesperson - Sales &Statistics")
//                     {
//                         Caption = 'Salesperson - Sales &Statistics';
//                         Image = "Report";
//                         RunObject = Report 114;
//                     }
//                     action("Customer/Item Sales")
//                     {
//                         Caption = 'Customer/Item Sales';
//                         Image = "Report";
//                         RunObject = Report 113;
//                     }
//                     action("Customer - Sales List")
//                     {
//                         Caption = 'Customer - Sales List';
//                         Image = "Report";
//                         RunObject = Report 119;
//                     }
//                     action("Report 50002")
//                     {
//                         Caption = 'Picking List report';
//                         Image = "Report";
//                     }
//                     action("Report 50010")
//                     {
//                         Caption = 'Sales upon shipment';
//                     }
//                     action("Inventory Customer Sales")
//                     {
//                         Caption = 'Inventory Customer Sales';
//                         Image = "Report";
//                         RunObject = Report 713;
//                     }
//                     action("Inventory Top 10 List")
//                     {
//                         Caption = 'Inventory Top 10 List';
//                         Image = "Report";
//                         RunObject = Report 711;
//                     }
//                 }
//                 group("Sales Documents")
//                 {
//                     Caption = 'Sales Documents';
//                     Image = "Report";
//                     action("Order Confirmation")
//                     {
//                         Caption = 'Order Confirmation';
//                         Image = "Report";
//                         //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
//                         //PromotedCategory = New;
//                         RunObject = Report 205;
//                     }
//                     action("Sales Document Test")
//                     {
//                         Caption = 'Sales Document Test';
//                         Image = "Report";
//                         RunObject = Report 202;
//                     }
//                     action("Sales Quote")
//                     {
//                         Caption = 'Sales Quote';
//                         Image = "Report";
//                         RunObject = Report 204;
//                     }
//                     action("Blanket Sales Order")
//                     {
//                         Caption = 'Blanket Sales Order';
//                         Image = "Report";
//                         RunObject = Report 210;
//                     }
//                     action("Sales Invoice")
//                     {
//                         Caption = 'Sales Invoice';
//                         Image = "Report";
//                         RunObject = Report 206;
//                     }
//                     action("Sales Credit Memo")
//                     {
//                         Caption = 'Sales Credit Memo';
//                         Image = "Report";
//                         RunObject = Report 207;
//                     }
//                     action("Sales - Shipment")
//                     {
//                         Caption = 'Sales - Shipment';
//                         Image = "Report";
//                         RunObject = Report 208;
//                     }
//                     action("Customer - Payment Receipt")
//                     {
//                         Caption = 'Customer - Payment Receipt';
//                         Image = "Report";
//                         RunObject = Report 211;
//                     }
//                     action("Return Order")
//                     {
//                         Caption = 'Return Order';
//                         Image = "Report";
//                         RunObject = Report 6641;
//                     }
//                     action("Sales - Return Receipt")
//                     {
//                         Caption = 'Sales - Return Receipt';
//                         Image = "Report";
//                         RunObject = Report 6646;
//                     }
//                 }
//             }
//             group("TJC - Purchase Front Office")
//             {
//                 Caption = 'TJC - Purchase Front Office';
//                 group("Purchase Reports")
//                 {
//                     Caption = 'Purchase Reports';
//                     Image = "report";
//                     action("Vendor/Item Purchases")
//                     {
//                         Caption = 'Vendor/Item Purchases';
//                         Image = "report";
//                         RunObject = Report 313;
//                     }
//                     action("Inventory Availability")
//                     {
//                         Caption = 'Inventory Availability';
//                         Image = "report";
//                         RunObject = Report 705;
//                     }
//                     action("Inventory Cost and Price List")
//                     {
//                         Caption = 'Inventory Cost and Price List';
//                         Image = "report";
//                         RunObject = Report 716;
//                     }
//                     action("Inventory Posting - Test")
//                     {
//                         Caption = 'Inventory Posting - Test';
//                         Image = "report";
//                         RunObject = Report 702;
//                     }
//                     action("Inventory Purchase Orders")
//                     {
//                         Caption = 'Inventory Purchase Orders';
//                         Image = "report";
//                         RunObject = Report 709;
//                     }
//                     action("Inventory - List")
//                     {
//                         Caption = 'Inventory - List';
//                         Image = "report";
//                         RunObject = Report 701;
//                     }
//                     action("Inventory Transaction Detail")
//                     {
//                         Caption = 'Inventory Transaction Detail';
//                         Image = "report";
//                         RunObject = Report 704;
//                     }
//                     action("Inventory - Vendor Purchases")
//                     {
//                         Caption = 'Inventory - Vendor Purchases';
//                         Image = "report";
//                         RunObject = Report 714;
//                     }
//                     action("Item Charges - Specification")
//                     {
//                         Caption = 'Item Charges - Specification';
//                         Image = "report";
//                         RunObject = Report 5806;
//                     }
//                 }
//                 group("Purchase Documents")
//                 {
//                     Caption = 'Purchase Documents';
//                     Image = "report";
//                     action(Quote)
//                     {
//                         Caption = 'Quote';
//                         Image = "report";
//                         RunObject = Report 404;
//                     }
//                     action(Order)
//                     {
//                         Caption = 'Order';
//                         Image = "report";
//                         RunObject = Report 405;
//                     }
//                     action(Invoice)
//                     {
//                         Caption = 'Invoice';
//                         Image = "report";
//                         RunObject = Report 406;
//                     }
//                     action("Credit Memo")
//                     {
//                         Caption = 'Credit Memo';
//                         Image = "report";
//                         RunObject = Report 407;
//                     }
//                     action(Receipt)
//                     {
//                         Caption = 'Receipt';
//                         Image = "report";
//                         RunObject = Report 408;
//                     }
//                     action("Vendor - Payment Receipt")
//                     {
//                         Caption = 'Vendor - Payment Receipt';
//                         Image = "report";
//                         RunObject = Report 411;
//                     }
//                     action("Purchase Document Test")
//                     {
//                         Caption = 'Purchase Document Test';
//                         Image = "report";
//                         RunObject = Report 402;
//                     }
//                 }
//             }
//         }
//         area(embedding)
//         {
//             action("Accounting Periods")
//             {
//                 Caption = 'Accounting Periods';
//                 Image = AccountingPeriods;
//                 RunObject = Page 100;
//             }
//             action("User Posting Rights")
//             {
//                 Caption = 'User Posting Rights';
//                 Image = UserSetup;
//                 RunObject = Page 119;
//             }
//             action("G/L Account List")
//             {
//                 Caption = 'G/L Account List';
//                 RunObject = Page 18;
//             }
//         }
//         area(sections)
//         {
//             group("TJC - Finance")
//             {
//                 Caption = 'TJC - Finance';
//                 Image = CostAccounting;
//                 action("Chart of Accounts")
//                 {
//                     Caption = 'Chart of Accounts';
//                     Image = ChartOfAccounts;
//                     RunObject = Page 16;
//                 }
//                 action(Vendors)
//                 {
//                     Caption = 'Vendors';
//                     Image = Vendor;
//                     RunObject = Page 27;
//                 }
//                 action(Balance)
//                 {
//                     Caption = 'Balance';
//                     Image = Balance;
//                     RunObject = Page 27;
//                     RunPageView = WHERE(Balance (LCY)=FILTER(<>0));
//                 }
//                 action(Budgets)
//                 {
//                     Caption = 'Budgets';
//                     RunObject = Page 121;
//                 }
//                 action("Bank Accounts")
//                 {
//                     Caption = 'Bank Accounts';
//                     Image = BankAccount;
//                     RunObject = Page 371;
//                 }
//                 action("GST Statements")
//                 {
//                     Caption = 'GST Statements';
//                     RunObject = Page 320;
//                 }
//                 action(Items)
//                 {
//                     Caption = 'Items';
//                     Image = Item;
//                     RunObject = Page 31;
//                 }
//                 action(Customers)
//                 {
//                     Caption = 'Customers';
//                     Image = Customer;
//                     RunObject = Page 22;
//                 }
//                 action(Balance)
//                 {
//                     Caption = 'Balance';
//                     Image = Balance;
//                     RunObject = Page 22;
//                     RunPageView = WHERE(Balance (LCY)=FILTER(<>0));
//                 }
//                 action("General Journal")
//                 {
//                     Caption = 'General Journal';
//                     Image = GeneralLedger;
//                     RunObject = Page 251;
//                 }
//                 action("G/L Budget Entries")
//                 {
//                     Caption = 'G/L Budget Entries';
//                     RunObject = Page 120;
//                 }
//                 action("Account Schedule")
//                 {
//                     Caption = 'Account Schedule';
//                     RunObject = Page 103;
//                 }
//                 action("G/L Registers")
//                 {
//                     Caption = 'G/L Registers';
//                     RunObject = Page 116;
//                 }
//                 action("Currency - Currencies")
//                 {
//                     Caption = 'Currency - Currencies';
//                     RunObject = Page 5;
//                 }
//                 action("Currency - Exchange Rate Adjmt. Register")
//                 {
//                     Caption = 'Currency - Exchange Rate Adjmt. Register';
//                     RunObject = Page 106;
//                 }
//             }
//             group(Journals)
//             {
//                 Caption = 'Journals';
//                 Image = Journals;
//                 action("Purchase Journals")
//                 {
//                     Caption = 'Purchase Journals';
//                     RunObject = Page 251;
//                     RunPageView = WHERE(Template Type=CONST(Purchases),
//                                         Recurring=CONST(No));
//                 }
//                 action("Sales Journals")
//                 {
//                     Caption = 'Sales Journals';
//                     RunObject = Page 251;
//                     RunPageView = WHERE(Template Type=CONST(Sales),
//                                         Recurring=CONST(No));
//                 }
//                 action("Cash Receipt Journals")
//                 {
//                     Caption = 'Cash Receipt Journals';
//                     Image = Journals;
//                     RunObject = Page 251;
//                     RunPageView = WHERE(Template Type=CONST(Cash Receipts),
//                                         Recurring=CONST(No));
//                 }
//                 action("Payment Journals")
//                 {
//                     Caption = 'Payment Journals';
//                     Image = Journals;
//                     RunObject = Page 251;
//                     RunPageView = WHERE(Template Type=CONST(Payments),
//                                         Recurring=CONST(No));
//                 }
//                 action("IC General Journals")
//                 {
//                     Caption = 'IC General Journals';
//                     RunObject = Page 251;
//                     RunPageView = WHERE(Template Type=CONST(Intercompany),
//                                         Recurring=CONST(No));
//                 }
//                 action("General Journals")
//                 {
//                     Caption = 'General Journals';
//                     Image = Journal;
//                     RunObject = Page 251;
//                     RunPageView = WHERE(Template Type=CONST(General),
//                                         Recurring=CONST(No));
//                 }
//                 action("Intrastat Journals")
//                 {
//                     Caption = 'Intrastat Journals';
//                     Image = "Report";
//                     RunObject = Page 327;
//                 }
//             }
//             group("Posted Documents")
//             {
//                 Caption = 'Posted Documents';
//                 Image = FiledPosted;
//                 action("Posted Sales Invoices")
//                 {
//                     Caption = 'Posted Sales Invoices';
//                     Image = PostedOrder;
//                     RunObject = Page 143;
//                 }
//                 action("Posted Sales Credit Memos")
//                 {
//                     Caption = 'Posted Sales Credit Memos';
//                     Image = PostedOrder;
//                     RunObject = Page 144;
//                 }
//                 action("Posted Sales Shipments")
//                 {
//                     Caption = 'Posted Sales Shipments';
//                     Image = PostedShipment;
//                     RunObject = Page 142;
//                 }
//                 action("Posted Return Receipts")
//                 {
//                     Caption = 'Posted Return Receipts';
//                     Image = PostedReturnReceipt;
//                     RunObject = Page 6662;
//                 }
//                 action("Posted Purchase Invoices")
//                 {
//                     Caption = 'Posted Purchase Invoices';
//                     RunObject = Page 146;
//                 }
//                 action("Posted Purchase Credit Memos")
//                 {
//                     Caption = 'Posted Purchase Credit Memos';
//                     RunObject = Page 147;
//                 }
//                 action("Posted Return Shipments")
//                 {
//                     Caption = 'Posted Return Shipments';
//                     RunObject = Page 6652;
//                 }
//                 action("Posted Purchase Receipts")
//                 {
//                     Caption = 'Posted Purchase Receipts';
//                     RunObject = Page 145;
//                 }
//                 action("Issued Reminders")
//                 {
//                     Caption = 'Issued Reminders';
//                     Image = OrderReminder;
//                     RunObject = Page 440;
//                 }
//                 action("Issued Fin. Charge Memos")
//                 {
//                     Caption = 'Issued Fin. Charge Memos';
//                     Image = PostedMemo;
//                     RunObject = Page 452;
//                 }
//                 action("G/L Registers")
//                 {
//                     Caption = 'G/L Registers';
//                     Image = GLRegisters;
//                     RunObject = Page 116;
//                 }
//                 action("Cost Accounting Registers")
//                 {
//                     Caption = 'Cost Accounting Registers';
//                     RunObject = Page 1104;
//                 }
//                 action("Cost Accounting Budget Registers")
//                 {
//                     Caption = 'Cost Accounting Budget Registers';
//                     RunObject = Page 1121;
//                 }
//                 action(Currencies)
//                 {
//                     Caption = 'Currencies';
//                     Image = Currency;
//                     RunObject = Page 5;
//                 }
//                 action("Accounting Periods")
//                 {
//                     Caption = 'Accounting Periods';
//                     Image = AccountingPeriods;
//                     RunObject = Page 100;
//                 }
//                 action("Number Series")
//                 {
//                     Caption = 'Number Series';
//                     RunObject = Page 456;
//                 }
//                 action("Analysis Views")
//                 {
//                     Caption = 'Analysis Views';
//                     RunObject = Page 556;
//                 }
//                 action("Account Schedules")
//                 {
//                     Caption = 'Account Schedules';
//                     RunObject = Page 103;
//                 }
//                 action(Dimensions)
//                 {
//                     Caption = 'Dimensions';
//                     Image = Dimensions;
//                     RunObject = Page 536;
//                 }
//                 action("Bank Account Posting Groups")
//                 {
//                     Caption = 'Bank Account Posting Groups';
//                     RunObject = Page 373;
//                 }
//             }
//             group("TJC - Sales Front Office")
//             {
//                 Caption = 'TJC - Sales Front Office';
//                 Image = Sales;
//                 action("Sales Orders")
//                 {
//                     Caption = 'Sales Orders';
//                     Image = "Order";
//                     RunObject = Page 9305;
//                 }
//                 action("Sales Quotes")
//                 {
//                     Caption = 'Sales Quotes';
//                     Image = Quote;
//                     RunObject = Page 9300;
//                 }
//                 action(Items)
//                 {
//                     Caption = 'Items';
//                     Image = Item;
//                     RunObject = Page 31;
//                 }
//                 action(Contacts)
//                 {
//                     Caption = 'Contacts';
//                     Image = CustomerContact;
//                     RunObject = Page 5052;
//                 }
//                 action(Customers)
//                 {
//                     Caption = 'Customers';
//                     Image = Customer;
//                     RunObject = Page 22;
//                 }
//                 action(Open)
//                 {
//                     Caption = 'Open';
//                     Image = Edit;
//                     RunObject = Page 9305;
//                     RunPageView = WHERE(Status=FILTER(Open));
//                     ShortCutKey = 'Return';
//                 }
//                 action("Sales Invoices")
//                 {
//                     Caption = 'Sales Invoices';
//                     Image = Invoice;
//                     RunObject = Page 9301;
//                 }
//                 action("Credit Memos")
//                 {
//                     Caption = 'Credit Memos';
//                     RunObject = Page 9302;
//                 }
//                 action("Transfer Orders")
//                 {
//                     Caption = 'Transfer Orders';
//                     RunObject = Page 5742;
//                 }
//                 action("Cash Receipt Journals")
//                 {
//                     Caption = 'Cash Receipt Journals';
//                     Image = Journals;
//                     RunObject = Page 251;
//                     RunPageView = WHERE(Template Type=CONST(Cash Receipts),
//                                         Recurring=CONST(No));
//                 }
//             }
//             group("TJC - Purchase Front Office")
//             {
//                 Caption = 'TJC - Purchase Front Office';
//                 Image = Purchasing;
//                 action("Purchase Orders")
//                 {
//                     Caption = 'Purchase Orders';
//                     RunObject = Page 9307;
//                 }
//                 action("Purchase Quotes")
//                 {
//                     Caption = 'Purchase Quotes';
//                     RunObject = Page 9306;
//                 }
//                 action(Items)
//                 {
//                     Caption = 'Items';
//                     Image = Item;
//                     RunObject = Page 31;
//                 }
//                 action(Vendors)
//                 {
//                     Caption = 'Vendors';
//                     Image = Vendor;
//                     RunObject = Page 27;
//                 }
//                 action("Transfer Order")
//                 {
//                     Caption = 'Transfer Order';
//                     RunObject = Page 5742;
//                 }
//                 action("Purchase Invoices")
//                 {
//                     Caption = 'Purchase Invoices';
//                     RunObject = Page 9308;
//                 }
//                 action("Purchase Credit Memos")
//                 {
//                     Caption = 'Purchase Credit Memos';
//                     RunObject = Page 9309;
//                 }
//                 action("Return Reasons")
//                 {
//                     Caption = 'Return Reasons';
//                     RunObject = Page 6635;
//                 }
//             }
//             group(Administration)
//             {
//                 Caption = 'Administration';
//                 Image = Administration;
//             }
//         }
//         area(processing)
//         {
//             group("TJC - Finance")
//             {
//                 Caption = 'TJC - Finance';
//                 group("General Ledger")
//                 {
//                     Caption = 'General Ledger';
//                     action("Chart of Accounts")
//                     {
//                         Caption = 'Chart of Accounts';
//                         RunObject = Page 16;
//                     }
//                     action(Budgets)
//                     {
//                         Caption = 'Budgets';
//                         RunObject = Page 113;
//                     }
//                     action("General Journal")
//                     {
//                         Caption = 'General Journal';
//                         RunObject = Page 39;
//                     }
//                     group("Analysis & Reporting")
//                     {
//                         Caption = 'Analysis & Reporting';
//                         action("Account Schedules")
//                         {
//                             Caption = 'Account Schedules';
//                             RunObject = Page 104;
//                         }
//                         action("Analysis by Dimensions")
//                         {
//                             Caption = 'Analysis by Dimensions';
//                             RunObject = Page 554;
//                         }
//                         action("XBRL Taxonomies")
//                         {
//                             Caption = 'XBRL Taxonomies';
//                             RunObject = Page 582;
//                         }
//                         action("XBRL Export Instance - Spec. 2")
//                         {
//                             Caption = 'XBRL Export Instance - Spec. 2';
//                             Image = "report";
//                             RunObject = Report 505;
//                         }
//                     }
//                     group(History)
//                     {
//                         Caption = 'History';
//                         action(Registers)
//                         {
//                             Caption = 'Registers';
//                             RunObject = Page 116;
//                         }
//                         action(Navigate)
//                         {
//                             Caption = 'Navigate';
//                             RunObject = Page 344;
//                         }
//                     }
//                     group("Periodic Activities")
//                     {
//                         Caption = 'Periodic Activities';
//                         action("Update Analysis Views")
//                         {
//                             Caption = 'Update Analysis Views';
//                             RunObject = Report 84;
//                         }
//                         group(GST)
//                         {
//                             Caption = 'GST';
//                             action("Calc. and Post VAT Settlement")
//                             {
//                                 Caption = 'Calc. and Post VAT Settlement';
//                                 RunObject = Report 20;
//                             }
//                             action("VAT Statement")
//                             {
//                                 Caption = 'VAT Statement';
//                                 RunObject = Page 317;
//                             }
//                             action("VAT- VIES Declaration Disk")
//                             {
//                                 Caption = 'VAT- VIES Declaration Disk';
//                                 RunObject = Report 88;
//                             }
//                         }
//                         group(Currency)
//                         {
//                             Caption = 'Currency';
//                             action(Currencies)
//                             {
//                                 Caption = 'Currencies';
//                                 RunObject = Page 5;
//                             }
//                             action("Adjust Exchange Rates")
//                             {
//                                 Caption = 'Adjust Exchange Rates';
//                                 RunObject = Report 595;
//                             }
//                             action("Exchange Rate Adjmt. Register")
//                             {
//                                 Caption = 'Exchange Rate Adjmt. Register';
//                                 RunObject = Page 106;
//                             }
//                         }
//                         group("Fiscal Year")
//                         {
//                             Caption = 'Fiscal Year';
//                             action("Accounting Periods")
//                             {
//                                 Caption = 'Accounting Periods';
//                                 RunObject = Page 100;
//                             }
//                             action("Close Income Statement")
//                             {
//                                 Caption = 'Close Income Statement';
//                                 RunObject = Report 94;
//                             }
//                             action("Dimension Export/Import for YE")
//                             {
//                                 Caption = 'Dimension Export/Import for YE';
//                             }
//                         }
//                     }
//                 }
//                 group("Cash Management")
//                 {
//                     Caption = 'Cash Management';
//                     action("Bank Accounts")
//                     {
//                         Caption = 'Bank Accounts';
//                         RunObject = Page 370;
//                     }
//                     action("Cash Receipt Journal")
//                     {
//                         Caption = 'Cash Receipt Journal';
//                         RunObject = Page 255;
//                     }
//                     action("Payment Journal")
//                     {
//                         Caption = 'Payment Journal';
//                         RunObject = Page 256;
//                     }
//                     action("Bank Acc. Reconciliation")
//                     {
//                         Caption = 'Bank Acc. Reconciliation';
//                         RunObject = Page 379;
//                     }
//                 }
//                 group(Receivables)
//                 {
//                     Caption = 'Receivables';
//                     action(Customers)
//                     {
//                         Caption = 'Customers';
//                         RunObject = Page 21;
//                     }
//                     action("Sales Journals")
//                     {
//                         Caption = 'Sales Journals';
//                         RunObject = Page 253;
//                     }
//                     action("Cash Receipt Journals")
//                     {
//                         Caption = 'Cash Receipt Journals';
//                         RunObject = Page 255;
//                     }
//                     action("Sales Invoices")
//                     {
//                         Caption = 'Sales Invoices';
//                         RunObject = Page 43;
//                     }
//                     action("Sales Credit Memos")
//                     {
//                         Caption = 'Sales Credit Memos';
//                         RunObject = Page 44;
//                     }
//                     group(Documents)
//                     {
//                         Caption = 'Documents';
//                         action("Customer Statement")
//                         {
//                             Caption = 'Customer Statement';
//                             RunObject = Report 116;
//                         }
//                         action("Customer - Payment Receipt")
//                         {
//                             Caption = 'Customer - Payment Receipt';
//                             RunObject = Report 211;
//                         }
//                         action(Invoice)
//                         {
//                             Caption = 'Invoice';
//                             RunObject = Report 206;
//                         }
//                         action("Credit Memo")
//                         {
//                             Caption = 'Credit Memo';
//                             RunObject = Report 207;
//                         }
//                         action("Sales Document - Test")
//                         {
//                             Caption = 'Sales Document - Test';
//                             RunObject = Report 202;
//                         }
//                     }
//                     group(History)
//                     {
//                         Caption = 'History';
//                         action("Posted Sales Shipment")
//                         {
//                             Caption = 'Posted Sales Shipment';
//                             RunObject = Page 130;
//                         }
//                         action("Posted Sales Invoice")
//                         {
//                             Caption = 'Posted Sales Invoice';
//                             RunObject = Page 132;
//                         }
//                         action("Posted Return Receipt")
//                         {
//                             Caption = 'Posted Return Receipt';
//                             RunObject = Page 6660;
//                         }
//                         action("Posted Sales Credit Memo")
//                         {
//                             Caption = 'Posted Sales Credit Memo';
//                             RunObject = Page 134;
//                         }
//                         action(Registers)
//                         {
//                             Caption = 'Registers';
//                             RunObject = Page 116;
//                         }
//                         action(Navigate)
//                         {
//                             Caption = 'Navigate';
//                             RunObject = Page 344;
//                         }
//                     }
//                     group(Setup)
//                     {
//                         Caption = 'Setup';
//                         action("Sales & Receivables Setup")
//                         {
//                             Caption = 'Sales & Receivables Setup';
//                             RunObject = Page 459;
//                         }
//                     }
//                 }
//             }
//             group(Setup)
//             {
//                 Caption = 'Setup';
//                 action("Item Charges")
//                 {
//                     Caption = 'Item Charges';
//                     Image = Setup;
//                     RunObject = Page 5800;
//                 }
//                 action("Payment Terms")
//                 {
//                     Caption = 'Payment Terms';
//                     Image = Setup;
//                     RunObject = Page 4;
//                 }
//                 action("Payment Methods")
//                 {
//                     Caption = 'Payment Methods';
//                     Image = Setup;
//                     RunObject = Page 427;
//                 }
//                 action("Customer Price Groups")
//                 {
//                     Caption = 'Customer Price Groups';
//                     Image = setup;
//                     RunObject = Page 7;
//                 }
//                 action("Customer Disc. Groups")
//                 {
//                     Caption = 'Customer Disc. Groups';
//                     Image = Setup;
//                     RunObject = Page 512;
//                 }
//                 action("Standard Sales Codes")
//                 {
//                     Caption = 'Standard Sales Codes';
//                     Image = setup;
//                     RunObject = Page 172;
//                 }
//                 action("Item Discount Groups")
//                 {
//                     Caption = 'Item Discount Groups';
//                     Image = setup;
//                     RunObject = Page 513;
//                 }
//                 action("Shipment Methods")
//                 {
//                     Caption = 'Shipment Methods';
//                     Image = Setup;
//                     RunObject = Page 11;
//                 }
//                 action("Shipping Agents")
//                 {
//                     Caption = 'Shipping Agents';
//                     Image = setup;
//                     RunObject = Page 428;
//                 }
//                 action("Return Reasons")
//                 {
//                     Caption = 'Return Reasons';
//                     Image = Setup;
//                     RunObject = Page 6635;
//                 }
//                 action("Report Selection - Sales")
//                 {
//                     Caption = 'Report Selection - Sales';
//                     Image = setup;
//                     RunObject = Page 306;
//                 }
//             }
//             separator(History)
//             {
//                 Caption = 'History';
//                 IsHeader = true;
//             }
//             action("Navi&gate")
//             {
//                 Caption = 'Navi&gate';
//                 Image = Navigate;
//                 RunObject = Page 344;
//             }
//         }
//     }
// }

