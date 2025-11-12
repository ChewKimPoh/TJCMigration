// page 50055 "TJC MFG2"
// {
//     PageType = RoleCenter;

//     layout
//     {
//         area(rolecenter)
//         {
//             group()
//             {
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
//             group("TJC - Manufacturing")
//             {
//                 Caption = 'TJC - Manufacturing';
//                 action("Phys. Inventory List")
//                 {
//                     Caption = 'Phys. Inventory List';
//                     Image = "report";
//                     RunObject = Report 722;
//                 }
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
//         }
//         area(sections)
//         {
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
//                 action("Sales Quotes")
//                 {
//                     Caption = 'Sales Quotes';
//                     Image = Quote;
//                     RunObject = Page 9300;
//                 }
//                 action("Sales Orders")
//                 {
//                     Caption = 'Sales Orders';
//                     Image = "Order";
//                     RunObject = Page 9305;
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
//             group("Posted Sales Documents")
//             {
//                 Caption = 'Posted Sales Documents';
//                 Image = FiledPosted;
//                 action("Posted Sales Invoices")
//                 {
//                     Caption = 'Posted Sales Invoices';
//                     Image = PostedOrder;
//                     RunObject = Page 143;
//                 }
//                 action("Posted Sales Shipments")
//                 {
//                     Caption = 'Posted Sales Shipments';
//                     Image = PostedShipment;
//                     RunObject = Page 142;
//                 }
//                 action("Posted Sales Credit Memos")
//                 {
//                     Caption = 'Posted Sales Credit Memos';
//                     Image = PostedOrder;
//                     RunObject = Page 144;
//                 }
//                 action("Posted Return Receipts")
//                 {
//                     Caption = 'Posted Return Receipts';
//                     Image = PostedReturnReceipt;
//                     RunObject = Page 6662;
//                 }
//                 action(Registers)
//                 {
//                     Caption = 'Registers';
//                     RunObject = Page 116;
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
//             group("Posted Purchase Documents")
//             {
//                 Caption = 'Posted Purchase Documents';
//                 Image = FiledPosted;
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
//             group("TJC - Manufacturing")
//             {
//                 Caption = 'TJC - Manufacturing';
//                 Image = ProductDesign;
//                 Visible = false;
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
//         }
//         area(creation)
//         {
//         }
//         area(processing)
//         {
//             group("Item by Location")
//             {
//                 Caption = 'Item by Location';
//                 action("Items by Location")
//                 {
//                     Caption = 'Items by Location';
//                     RunObject = Page 491;
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
//         }
//     }
// }

