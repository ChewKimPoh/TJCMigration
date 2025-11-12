// page 50040 "Administration Role Center"
// {
//     PageType = RoleCenter;

//     layout
//     {
//         area(rolecenter)
//         {
//             group()
//             {
//                 part(;50047)
//                 {
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
//                         action("Trial Balance")
//                         {
//                             Caption = 'Trial Balance';
//                             Image = "Report";
//                             RunObject = Report 6;
//                         }
//                         action("Trial Balance/Budget")
//                         {
//                             Caption = 'Trial Balance/Budget';
//                             Image = "Report";
//                             RunObject = Report 9;
//                         }
//                         action("Trial Balance/Previous Year")
//                         {
//                             Caption = 'Trial Balance/Previous Year';
//                             Image = "Report";
//                             RunObject = Report 7;
//                         }
//                         action("Trial Balance by Period")
//                         {
//                             Caption = 'Trial Balance by Period';
//                             Image = "Report";
//                             RunObject = Report 38;
//                         }
//                         action("Fiscal Year Balance")
//                         {
//                             Caption = 'Fiscal Year Balance';
//                             Image = "Report";
//                             RunObject = Report 36;
//                         }
//                         action("Balance Comp. - Prev. Year")
//                         {
//                             Caption = 'Balance Comp. - Prev. Year';
//                             Image = "Report";
//                             RunObject = Report 37;
//                         }
//                         action("Closing Trial Balance")
//                         {
//                             Caption = 'Closing Trial Balance';
//                             Image = "report";
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
//                         action("Statement of Balance Sheet")
//                         {
//                             Caption = 'Statement of Balance Sheet';
//                             Image = "report";
//                             RunObject = Report 50039;
//                         }
//                         action("Statement of Income Statement")
//                         {
//                             Caption = 'Statement of Income Statement';
//                             Image = "report";
//                             RunObject = Report 50040;
//                         }
//                     }
//                     group("GST Reporting")
//                     {
//                         Caption = 'GST Reporting';
//                         Image = "Report";
//                         action("GST Exceptions")
//                         {
//                             Caption = 'GST Exceptions';
//                             Image = "report";
//                             RunObject = Report 31;
//                         }
//                         action("GST Register")
//                         {
//                             Caption = 'GST Register';
//                             Image = "report";
//                             RunObject = Report 13;
//                         }
//                         action("GST Registration No. Check")
//                         {
//                             Caption = 'GST Registration No. Check';
//                             Image = "report";
//                             RunObject = Report 32;
//                         }
//                         action("GST Statement")
//                         {
//                             Caption = 'GST Statement';
//                             Image = "report";
//                             RunObject = Report 12;
//                         }
//                         action("GST- VIES Declaration Tax Auth")
//                         {
//                             Caption = 'GST- VIES Declaration Tax Auth';
//                             Image = "report";
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
//             group("TJC - Commission")
//             {
//                 Caption = 'TJC - Commission';
//                 group("Detailed Commission Reports")
//                 {
//                     Caption = 'Detailed Commission Reports';
//                     Image = "report";
//                     action("Profit By Salesperson Report")
//                     {
//                         Caption = 'Profit By Salesperson Report';
//                         Image = "report";
//                         RunObject = Report 50011;
//                     }
//                     action("Salesperson Commission Report")
//                     {
//                         Caption = 'Salesperson Commission Report';
//                         Image = "report";
//                         RunObject = Report 50012;
//                     }
//                     action("Management Commission Report")
//                     {
//                         Caption = 'Management Commission Report';
//                         Image = "report";
//                         RunObject = Report 50013;
//                     }
//                     action("Production Commission Report")
//                     {
//                         Caption = 'Production Commission Report';
//                         Image = "report";
//                         RunObject = Report 50014;
//                     }
//                     action("Customer Point Report")
//                     {
//                         Caption = 'Customer Point Report';
//                         Image = "report";
//                         RunObject = Report 50015;
//                         Visible = false;
//                     }
//                     action("Doctor Commission wef 01/02/2010")
//                     {
//                         Caption = 'Doctor Commission wef 01/02/2010';
//                         Image = "report";
//                         RunObject = Report 50036;
//                     }
//                     action("Retail Commission(Retail Staff)")
//                     {
//                         Caption = 'Retail Commission(Retail Staff)';
//                         Image = "report";
//                         RunObject = Report 50034;
//                     }
//                     action("Retail Commission(Prod. Staff)")
//                     {
//                         Caption = 'Retail Commission(Prod. Staff)';
//                         Image = "report";
//                         RunObject = Report 50035;
//                     }
//                 }
//                 group("Summary Commission Reports")
//                 {
//                     Caption = 'Summary Commission Reports';
//                     Image = "report";
//                     action("Summary Salesperson Commission")
//                     {
//                         Caption = 'Summary Salesperson Commission';
//                         Image = "report";
//                         RunObject = Report 50019;
//                     }
//                     action("Summary Customer Point")
//                     {
//                         Caption = 'Summary Customer Point';
//                         Image = "report";
//                         RunObject = Report 50022;
//                     }
//                     action("Yearly Commission Summary")
//                     {
//                         Caption = 'Yearly Commission Summary';
//                         Image = "report";
//                         RunObject = Report 50026;
//                     }
//                     action("Yearly Customer Point Summary")
//                     {
//                         Caption = 'Yearly Customer Point Summary';
//                         Image = "report";
//                         RunObject = Report 50025;
//                     }
//                 }
//             }
//             group("TJC - Inventory")
//             {
//                 Caption = 'TJC - Inventory';
//                 group("Inventory Costing")
//                 {
//                     Caption = 'Inventory Costing';
//                     Image = "report";
//                     action("Inventory Availability")
//                     {
//                         Caption = 'Inventory Availability';
//                         Image = "report";
//                         RunObject = Report 705;
//                     }
//                     action("Inventory - Cost Variance")
//                     {
//                         Caption = 'Inventory - Cost Variance';
//                         Image = "report";
//                         RunObject = Report 721;
//                     }
//                     action("Inventory - Inbound Transfer")
//                     {
//                         Caption = 'Inventory - Inbound Transfer';
//                         Image = "report";
//                         RunObject = Report 5702;
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
//                     action("Item Age Composition - Qty.")
//                     {
//                         Caption = 'Item Age Composition - Qty.';
//                         Image = "report";
//                         RunObject = Report 5807;
//                     }
//                     action("Item Age Composition - Value")
//                     {
//                         Caption = 'Item Age Composition - Value';
//                         Image = "report";
//                         RunObject = Report 5808;
//                     }
//                     action("Item Charges - Specification")
//                     {
//                         Caption = 'Item Charges - Specification';
//                         Image = "report";
//                         RunObject = Report 5806;
//                     }
//                     action("Item Register - Quantity")
//                     {
//                         Caption = 'Item Register - Quantity';
//                         Image = "report";
//                         RunObject = Report 703;
//                     }
//                     action("Item Register - Value")
//                     {
//                         Caption = 'Item Register - Value';
//                         Image = "report";
//                         RunObject = Report 5805;
//                     }
//                     action("Safety Stock Check")
//                     {
//                         Caption = 'Safety Stock Check';
//                         Image = "report";
//                         RunObject = Report 50009;
//                     }
//                     action("Item Availability")
//                     {
//                         Caption = 'Item Availability';
//                         Image = "report";
//                         RunObject = Report 50020;
//                     }
//                 }
//                 group("Inventory & Pricing")
//                 {
//                     Caption = 'Inventory & Pricing';
//                     Image = "report";
//                     action("Inventory Posting - Test")
//                     {
//                         Caption = 'Inventory Posting - Test';
//                         Image = "report";
//                         RunObject = Report 702;
//                     }
//                     action("Inventory Availability")
//                     {
//                         Caption = 'Inventory Availability';
//                         Image = "report";
//                         RunObject = Report 705;
//                     }
//                     action("Inventory Order Details")
//                     {
//                         Caption = 'Inventory Order Details';
//                         Image = "report";
//                         RunObject = Report 708;
//                     }
//                     action("Inventory - Top 10 List")
//                     {
//                         Caption = 'Inventory - Top 10 List';
//                         Image = "report";
//                         RunObject = Report 711;
//                     }
//                     action("Inventory - Sales Statistics")
//                     {
//                         Caption = 'Inventory - Sales Statistics';
//                         Image = "report";
//                         RunObject = Report 712;
//                     }
//                     action("Inventory - Customer Sales")
//                     {
//                         Caption = 'Inventory - Customer Sales';
//                         Image = "report";
//                         RunObject = Report 713;
//                     }
//                     action("Price List")
//                     {
//                         Caption = 'Price List';
//                         Image = "report";
//                         RunObject = Report 715;
//                     }
//                     action("Inventory Cost and Price List")
//                     {
//                         Caption = 'Inventory Cost and Price List';
//                         Image = "report";
//                         RunObject = Report 716;
//                     }
//                     action("Inventory - Sales Back Orders")
//                     {
//                         Caption = 'Inventory - Sales Back Orders';
//                         Image = "report";
//                         RunObject = Report 718;
//                     }
//                     action("Item Charges - Specification")
//                     {
//                         Caption = 'Item Charges - Specification';
//                         Image = "report";
//                         RunObject = Report 5806;
//                     }
//                     action("Item Price")
//                     {
//                         Caption = 'Item Price';
//                         Image = "report";
//                         RunObject = Report 50008;
//                     }
//                 }
//                 group("Stock Take")
//                 {
//                     Caption = 'Stock Take';
//                     Image = "report";
//                     action("Phys. Inventory List")
//                     {
//                         Caption = 'Phys. Inventory List';
//                         Image = "report";
//                         RunObject = Report 722;
//                     }
//                 }
//             }
//             group("TJC - Sales Front Office")
//             {
//                 Caption = 'TJC - Sales Front Office';
//                 group("Sales Reports")
//                 {
//                     Caption = 'Sales Reports';
//                     Image = "report";
//                     action("Customer - Order Detail")
//                     {
//                         Caption = 'Customer - Order Detail';
//                         Image = "report";
//                         RunObject = Report 108;
//                     }
//                     action("Customer - Order Summary")
//                     {
//                         Caption = 'Customer - Order Summary';
//                         Image = "report";
//                         RunObject = Report 107;
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
//                     action("Customer - Sales List")
//                     {
//                         Caption = 'Customer - Sales List';
//                         Image = "report";
//                         RunObject = Report 119;
//                     }
//                     action("Picking List")
//                     {
//                         Caption = 'Picking List';
//                         Image = "report";
//                         RunObject = Report 50002;
//                     }
//                     action("Sales Upon Shipment")
//                     {
//                         Caption = 'Sales Upon Shipment';
//                         Image = "report";
//                         RunObject = Report 50010;
//                     }
//                     action("Inventory - Customer Sales")
//                     {
//                         Caption = 'Inventory - Customer Sales';
//                         Image = "report";
//                         RunObject = Report 713;
//                     }
//                     action("Inventory - Top 10 List")
//                     {
//                         Caption = 'Inventory - Top 10 List';
//                         Image = "report";
//                         RunObject = Report 711;
//                     }
//                 }
//                 group("Sales Documents")
//                 {
//                     Caption = 'Sales Documents';
//                     Image = "report";
//                     action("Order Confirmation")
//                     {
//                         Caption = 'Order Confirmation';
//                         Image = "report";
//                         RunObject = Report 205;
//                     }
//                     action("Sales Document - Test")
//                     {
//                         Caption = 'Sales Document - Test';
//                         Image = "report";
//                         RunObject = Report 202;
//                     }
//                     action("Sales - Quote")
//                     {
//                         Caption = 'Sales - Quote';
//                         Image = "report";
//                         RunObject = Report 204;
//                     }
//                     action("Blanket Sales Order")
//                     {
//                         Caption = 'Blanket Sales Order';
//                         Image = "report";
//                         RunObject = Report 210;
//                     }
//                     action("Sales - Invoice")
//                     {
//                         Caption = 'Sales - Invoice';
//                         Image = "report";
//                         RunObject = Report 206;
//                     }
//                     action("Sales - Credit Memo")
//                     {
//                         Caption = 'Sales - Credit Memo';
//                         Image = "report";
//                         RunObject = Report 207;
//                     }
//                     action("Sales - Shipment")
//                     {
//                         Caption = 'Sales - Shipment';
//                         Image = "report";
//                         RunObject = Report 208;
//                     }
//                     action("Customer - Payment Receipt")
//                     {
//                         Caption = 'Customer - Payment Receipt';
//                         Image = "report";
//                         RunObject = Report 211;
//                     }
//                     action("Return Order")
//                     {
//                         Caption = 'Return Order';
//                         Image = "report";
//                         RunObject = Report 6641;
//                     }
//                     action("Sales - Return Receipt")
//                     {
//                         Caption = 'Sales - Return Receipt';
//                         Image = "report";
//                         RunObject = Report 6646;
//                     }
//                 }
//                 action("Set Customer Points to Redeeme")
//                 {
//                     Caption = 'Set Customer Points to Redeeme';
//                     Image = "Report";
//                     RunObject = Report 50029;
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
//             group("TJC - Manufacturing")
//             {
//                 Caption = 'TJC - Manufacturing';
//                 group(Execution)
//                 {
//                     Caption = 'Execution';
//                     Image = "report";
//                     action("Prod.Order Component List")
//                     {
//                         Caption = 'Prod.Order Component List';
//                         Image = "report";
//                         RunObject = Report 50007;
//                     }
//                     action("Prod. Order - Job Card")
//                     {
//                         Caption = 'Prod. Order - Job Card';
//                         Image = "report";
//                         RunObject = Report 99000762;
//                     }
//                     action("Prod. Order - Picking List")
//                     {
//                         Caption = 'Prod. Order - Picking List';
//                         Image = "report";
//                         RunObject = Report 99000766;
//                     }
//                     action("Prod. Order - Shortage List")
//                     {
//                         Caption = 'Prod. Order - Shortage List';
//                         Image = "report";
//                         RunObject = Report 99000788;
//                     }
//                     action("Prod. Order - Mat. Requisition")
//                     {
//                         Caption = 'Prod. Order - Mat. Requisition';
//                         Image = "report";
//                         RunObject = Report 99000765;
//                     }
//                     action("Prod. Order - List")
//                     {
//                         Caption = 'Prod. Order - List';
//                         Image = "report";
//                         RunObject = Report 99000763;
//                     }
//                     action("Prod. Order - Routing List")
//                     {
//                         Caption = 'Prod. Order - Routing List';
//                         Image = "report";
//                         RunObject = Report 99000761;
//                     }
//                     action("Prod. Order Comp. and Routing")
//                     {
//                         Caption = 'Prod. Order Comp. and Routing';
//                         Image = "report";
//                         RunObject = Report 5500;
//                     }
//                     action("Prod. Order - Precalc. Time")
//                     {
//                         Caption = 'Prod. Order - Precalc. Time';
//                         Image = "report";
//                         RunObject = Report 99000764;
//                     }
//                     action("Capacity Task List")
//                     {
//                         Caption = 'Capacity Task List';
//                         Image = "report";
//                         RunObject = Report 99000780;
//                     }
//                     action("Machine Center Load")
//                     {
//                         Caption = 'Machine Center Load';
//                         Image = "report";
//                         RunObject = Report 99000784;
//                     }
//                     action("Machine Center Load / Bar")
//                     {
//                         Caption = 'Machine Center Load / Bar';
//                         Image = "report";
//                         RunObject = Report 99000786;
//                     }
//                     action("Work Center Load")
//                     {
//                         Caption = 'Work Center Load';
//                         Image = "report";
//                         RunObject = Report 99000783;
//                     }
//                     action("Work Center Load / Bar")
//                     {
//                         Caption = 'Work Center Load / Bar';
//                         Image = "report";
//                         RunObject = Report 99000785;
//                     }
//                     action("Subcontractor - Dispatch List")
//                     {
//                         Caption = 'Subcontractor - Dispatch List';
//                         Image = "report";
//                         RunObject = Report 99000789;
//                     }
//                 }
//                 group(Reports)
//                 {
//                     Caption = 'Reports';
//                     Image = "report";
//                     action("Production Order Statistics")
//                     {
//                         Caption = 'Production Order Statistics';
//                         Image = "report";
//                         RunObject = Report 99000791;
//                     }
//                     action("Detailed Calculation")
//                     {
//                         Caption = 'Detailed Calculation';
//                         Image = "report";
//                         RunObject = Report 99000756;
//                     }
//                     action("Prod. Order - Calculation")
//                     {
//                         Caption = 'Prod. Order - Calculation';
//                         Image = "report";
//                         RunObject = Report 99000767;
//                     }
//                     action("Prod. Order - Detailed Calc.")
//                     {
//                         Caption = 'Prod. Order - Detailed Calc.';
//                         Image = "report";
//                         RunObject = Report 99000768;
//                     }
//                     action(Status)
//                     {
//                         Caption = 'Status';
//                         Image = "report";
//                         RunObject = Report 706;
//                     }
//                     action("Item Register - Quantity")
//                     {
//                         Caption = 'Item Register - Quantity';
//                         Image = "report";
//                         RunObject = Report 703;
//                     }
//                     action("Inventory - Transaction Detail")
//                     {
//                         Caption = 'Inventory - Transaction Detail';
//                         Image = "report";
//                         RunObject = Report 704;
//                     }
//                     action("Inventory Valuation WIP")
//                     {
//                         Caption = 'Inventory Valuation WIP';
//                         Image = "report";
//                         RunObject = Report 5802;
//                     }
//                 }
//             }
//         }
//         area(embedding)
//         {
//             action("Job Queue Entries")
//             {
//                 Caption = 'Job Queue Entries';
//                 RunObject = Page 672;
//             }
//             action("User Setup")
//             {
//                 Caption = 'User Setup';
//                 Image = UserSetup;
//                 RunObject = Page 119;
//             }
//             action("No. Series")
//             {
//                 Caption = 'No. Series';
//                 RunObject = Page 456;
//             }
//             action("Approval User Setup")
//             {
//                 Caption = 'Approval User Setup';
//                 RunObject = Page 663;
//             }
//             action("Approval Templates")
//             {
//                 Caption = 'Approval Templates';
//                 RunObject = Page 668;
//             }
//             action("Data Templates List")
//             {
//                 Caption = 'Data Templates List';
//                 RunObject = Page 8620;
//             }
//             action("Base Calendar List")
//             {
//                 Caption = 'Base Calendar List';
//                 RunObject = Page 7601;
//             }
//             action("Post Codes")
//             {
//                 Caption = 'Post Codes';
//                 RunObject = Page 367;
//             }
//             action("Reason Codes")
//             {
//                 Caption = 'Reason Codes';
//                 RunObject = Page 259;
//             }
//             action("Extended Text")
//             {
//                 Caption = 'Extended Text';
//                 RunObject = Page 391;
//             }
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
//             action("No. Series")
//             {
//                 Caption = 'No. Series';
//                 RunObject = Page 456;
//             }
//             action("TJC Web Users")
//             {
//                 Caption = 'TJC Web Users';
//                 Image = setup;
//                 RunObject = Page 50089;
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
//                 action("General Journals")
//                 {
//                     Caption = 'General Journals';
//                     Image = Journal;
//                     RunObject = Page 251;
//                     RunPageView = WHERE(Template Type=CONST(General),
//                                         Recurring=CONST(No));
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
//             group("TJC - Commission")
//             {
//                 Caption = 'TJC - Commission';
//                 Image = Payables;
//                 action("User Setup")
//                 {
//                     Caption = 'User Setup';
//                     RunObject = Page 119;
//                 }
//                 action("Product Groups")
//                 {
//                     Caption = 'Product Groups';
//                     RunObject = Page 5731;
//                 }
//                 action("Item Categories")
//                 {
//                     Caption = 'Item Categories';
//                     RunObject = Page 5730;
//                 }
//             }
//             group("TJC - Inventory")
//             {
//                 Caption = 'TJC - Inventory';
//                 Image = Intrastat;
//                 action(Item)
//                 {
//                     Caption = 'Item';
//                     RunObject = Page 31;
//                 }
//                 action("Phys. Invt. Counting Periods")
//                 {
//                     Caption = 'Phys. Invt. Counting Periods';
//                     RunObject = Page 7381;
//                 }
//             }
//             group("TJC - Sales Front Office")
//             {
//                 Caption = 'TJC - Sales Front Office';
//                 Image = Sales;
//                 action(Items)
//                 {
//                     Caption = 'Items';
//                     Image = Item;
//                     RunObject = Page 31;
//                 }
//                 action(Customers)
//                 {
//                     Caption = 'Customers';
//                     RunObject = Page 22;
//                 }
//                 action("Sales Quotes")
//                 {
//                     Caption = 'Sales Quotes';
//                     RunObject = Page 9300;
//                 }
//                 action("Sales Orders")
//                 {
//                     Caption = 'Sales Orders';
//                     RunObject = Page 9305;
//                 }
//                 action("Sales Invoices")
//                 {
//                     Caption = 'Sales Invoices';
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
//                 action(Items)
//                 {
//                     Caption = 'Items';
//                     Image = Item;
//                     RunObject = Page 31;
//                 }
//                 action(Vendor)
//                 {
//                     Caption = 'Vendor';
//                     RunObject = Page 27;
//                 }
//                 action("Purchase Quotes")
//                 {
//                     Caption = 'Purchase Quotes';
//                     RunObject = Page 9306;
//                 }
//                 action("Transfer Order")
//                 {
//                     Caption = 'Transfer Order';
//                     RunObject = Page 5742;
//                 }
//                 action("Purchase Orders")
//                 {
//                     Caption = 'Purchase Orders';
//                     RunObject = Page 9307;
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
//                 action("Posted Purchase Receipts")
//                 {
//                     Caption = 'Posted Purchase Receipts';
//                     RunObject = Page 145;
//                 }
//                 action("Posted Purchase Invoices")
//                 {
//                     Caption = 'Posted Purchase Invoices';
//                     RunObject = Page 146;
//                 }
//                 action("Posted Return Shipments")
//                 {
//                     Caption = 'Posted Return Shipments';
//                     RunObject = Page 6652;
//                 }
//                 action("Posted Purchase Credit Memos")
//                 {
//                     Caption = 'Posted Purchase Credit Memos';
//                     RunObject = Page 147;
//                 }
//             }
//             group("TJC - Manufacturing")
//             {
//                 Caption = 'TJC - Manufacturing';
//                 Image = ProductDesign;
//                 separator("Production Design")
//                 {
//                     Caption = 'Production Design';
//                 }
//                 action(Items)
//                 {
//                     Caption = 'Items';
//                     Image = Item;
//                     RunObject = Page 31;
//                 }
//                 action("Production BOM")
//                 {
//                     Caption = 'Production BOM';
//                     RunObject = Page 99000787;
//                 }
//                 action(Routings)
//                 {
//                     Caption = 'Routings';
//                     RunObject = Page 99000764;
//                 }
//                 action(Families)
//                 {
//                     Caption = 'Families';
//                     RunObject = Page 99000791;
//                 }
//                 separator("Production Execution")
//                 {
//                     Caption = 'Production Execution';
//                 }
//                 action("Firm Planned Prod. Orders")
//                 {
//                     Caption = 'Firm Planned Prod. Orders';
//                     RunObject = Page 9325;
//                 }
//                 action("Released Prod. Orders")
//                 {
//                     Caption = 'Released Prod. Orders';
//                     RunObject = Page 9326;
//                 }
//                 action("Change Production Order Status")
//                 {
//                     Caption = 'Change Production Order Status';
//                     RunObject = Page 9323;
//                 }
//                 action("Finished Production Orders")
//                 {
//                     Caption = 'Finished Production Orders';
//                     RunObject = Page 9327;
//                 }
//             }
//             group("TJC - TMC (Clinic)")
//             {
//                 Caption = 'TJC - TMC (Clinic)';
//                 Image = HumanResources;
//                 action("Medicine List")
//                 {
//                     Caption = 'Medicine List';
//                     RunObject = Page 50024;
//                     RunPageMode = View;
//                 }
//                 action("Patient List")
//                 {
//                     Caption = 'Patient List';
//                     RunObject = Page 50020;
//                 }
//                 action("Clinic Item Categories")
//                 {
//                     Caption = 'Clinic Item Categories';
//                     RunObject = Page 50025;
//                 }
//                 action("Sickness Category")
//                 {
//                     Caption = 'Sickness Category';
//                     RunObject = Page 50022;
//                 }
//                 action("Bar Code")
//                 {
//                     Caption = 'Bar Code';
//                     RunObject = Page 50029;
//                 }
//                 action("Tongue 1")
//                 {
//                     Caption = 'Tongue 1';
//                     RunObject = Page 50018;
//                 }
//                 action("Tongue 2")
//                 {
//                     Caption = 'Tongue 2';
//                     RunObject = Page 50019;
//                 }
//                 action(Pulse)
//                 {
//                     Caption = 'Pulse';
//                     RunObject = Page 50021;
//                 }
//                 action("User Setup")
//                 {
//                     Caption = 'User Setup';
//                     RunObject = Page 119;
//                 }
//             }
//         }
//         area(creation)
//         {
//         }
//         area(processing)
//         {
//             group("TJC - Finance")
//             {
//                 Caption = 'TJC - Finance';
//                 group("General Ledger")
//                 {
//                     Caption = 'General Ledger';
//                     Image = GeneralLedger;
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
//                 action("Payment Terms")
//                 {
//                     Caption = 'Payment Terms';
//                     RunObject = Page 4;
//                 }
//             }
//             group("TJC - Commission")
//             {
//                 Caption = 'TJC - Commission';
//                 action("Cust Point / Comm Update")
//                 {
//                     Caption = 'Cust Point / Comm Update';
//                     Image = AmountByPeriod;
//                     RunObject = Page 50003;
//                 }
//             }
//             group("TJC - Inventory")
//             {
//                 Caption = 'TJC - Inventory';
//                 action("Item Journal")
//                 {
//                     Caption = 'Item Journal';
//                     Image = Journals;
//                     RunObject = Page 40;
//                 }
//                 action("Item Reclass. Journal")
//                 {
//                     Caption = 'Item Reclass. Journal';
//                     Image = Journals;
//                     RunObject = Page 393;
//                 }
//                 action("Recurring Item Jnl.")
//                 {
//                     Caption = 'Recurring Item Jnl.';
//                     Image = Journals;
//                     RunObject = Page 286;
//                 }
//                 action("Phys. Inventory Journal")
//                 {
//                     Caption = 'Phys. Inventory Journal';
//                     Image = Journals;
//                     RunObject = Page 392;
//                 }
//                 action("Revaluation Journal")
//                 {
//                     Caption = 'Revaluation Journal';
//                     Image = Journals;
//                     RunObject = Page 5803;
//                 }
//             }
//             group("TJC - Manufacturing")
//             {
//                 Caption = 'TJC - Manufacturing';
//                 Image = ProductDesign;
//                 action("Consumption Journal")
//                 {
//                     Caption = 'Consumption Journal';
//                     Image = Journals;
//                     RunObject = Page 99000846;
//                 }
//                 action("Output Journals")
//                 {
//                     Caption = 'Output Journals';
//                     Image = Journals;
//                     RunObject = Page 99000823;
//                 }
//                 action("&Warehouse Setup")
//                 {
//                     Caption = '&Warehouse Setup';
//                     Image = WarehouseSetup;
//                     RunObject = Page 5775;
//                 }
//                 action("Manufacturing Setup")
//                 {
//                     Caption = 'Manufacturing Setup';
//                     Image = ProductionSetup;
//                     RunObject = Page 99000768;
//                 }
//             }
//             group("TJC - TMC (Clinic)")
//             {
//                 Caption = 'TJC - TMC (Clinic)';
//                 action("Clinic Visit Analysis")
//                 {
//                     Caption = 'Clinic Visit Analysis';
//                     RunObject = Page 50027;
//                 }
//                 separator()
//                 {
//                 }
//                 action("User Setup")
//                 {
//                     Caption = 'User Setup';
//                     Image = UserSetup;
//                     RunObject = Page 119;
//                 }
//                 action("Relationship Management Setup")
//                 {
//                     Caption = 'Relationship Management Setup';
//                     Image = MarketingSetup;
//                     RunObject = Page 5094;
//                 }
//                 action("Sales & Receivables Setup")
//                 {
//                     Caption = 'Sales & Receivables Setup';
//                     Image = ReceivablesPayablesSetup;
//                     RunObject = Page 459;
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
//                 separator()
//                 {
//                 }
//                 action("Relationship Management Setup")
//                 {
//                     Caption = 'Relationship Management Setup';
//                     RunObject = Page 5094;
//                 }
//                 action("Sales & Receivables Setup")
//                 {
//                     Caption = 'Sales & Receivables Setup';
//                     Image = setup;
//                     RunObject = Page 459;
//                 }
//             }
//         }
//         area(navigation)
//         {
//             action("Item Charges")
//             {
//                 Caption = 'Item Charges';
//                 Image = Setup;
//                 RunObject = Page 5800;
//             }
//         }
//     }
// }

