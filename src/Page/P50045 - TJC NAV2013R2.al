// page 50045 "Sales, Mfg & Whse. Role Center"
// {
//     PageType = RoleCenter;

//     layout
//     {
//         area(rolecenter)
//         {
//             group()
//             {
//                 part(;50052)
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
//             group("TJC - Inventory")
//             {
//                 Caption = 'TJC - Inventory';
//                 group("Inventory Costing")
//                 {
//                     Caption = 'Inventory Costing';
//                     Image = "Report";
//                     action("Inventory Availability")
//                     {
//                         Caption = 'Inventory Availability';
//                         Image = "Report";
//                         RunObject = Report 705;
//                     }
//                     action("Inventory - Cost Variance")
//                     {
//                         Caption = 'Inventory - Cost Variance';
//                         Image = "Report";
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
//             group("TJC - Manufacturing")
//             {
//                 Caption = 'TJC - Manufacturing';
//             }
//         }
//         area(sections)
//         {
//             group("TJC - Sales Front Office")
//             {
//                 Caption = 'TJC - Sales Front Office';
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
//             group("TJC - Inventory")
//             {
//                 Caption = 'TJC - Inventory';
//                 action(Items)
//                 {
//                     Caption = 'Items';
//                     Image = Item;
//                     RunObject = Page 31;
//                 }
//                 action("Product Groups")
//                 {
//                     Caption = 'Product Groups';
//                     RunObject = Page 5731;
//                 }
//                 action("Item Categories")
//                 {
//                     Caption = 'Item Categories';
//                 }
//                 action("Item Journals")
//                 {
//                     Caption = 'Item Journals';
//                     RunObject = Page 262;
//                     RunPageView = WHERE(Template Type=CONST(Item),
//                                         Recurring=CONST(No));
//                 }
//                 action("Item Reclass. Journals")
//                 {
//                     Caption = 'Item Reclass. Journals';
//                     RunObject = Page 262;
//                     RunPageView = WHERE(Template Type=CONST(Transfer),
//                                         Recurring=CONST(No));
//                 }
//                 action("Phys. Inventory Journals")
//                 {
//                     Caption = 'Phys. Inventory Journals';
//                     RunObject = Page 262;
//                     RunPageView = WHERE(Template Type=CONST(Phys. Inventory),
//                                         Recurring=CONST(No));
//                 }
//                 action("Phys. Invt. Counting Periods")
//                 {
//                     Caption = 'Phys. Invt. Counting Periods';
//                     RunObject = Page 7381;
//                 }
//                 action(Locations)
//                 {
//                     Caption = 'Locations';
//                     RunObject = Page 15;
//                 }
//                 action(Registers)
//                 {
//                     Caption = 'Registers';
//                     RunObject = Page 117;
//                 }
//             }
//             group("Production Design")
//             {
//                 Caption = 'Production Design';
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
//             }
//             group("Production Execution")
//             {
//                 Caption = 'Production Execution';
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
//             group("TJC - Inventory")
//             {
//                 Caption = 'TJC - Inventory';
//             }
//             group("TJC - Manufacturing")
//             {
//                 Caption = 'TJC - Manufacturing';
//             }
//         }
//         area(processing)
//         {
//             group("TJC - Inventory")
//             {
//                 Caption = 'TJC - Inventory';
//                 action("Recurring Item Journals")
//                 {
//                     Caption = 'Recurring Item Journals';
//                     RunObject = Page 286;
//                 }
//                 action("Revaluation Journals")
//                 {
//                     Caption = 'Revaluation Journals';
//                     RunObject = Page 5803;
//                 }
//                 action("Sales Price Worksheet")
//                 {
//                     Caption = 'Sales Price Worksheet';
//                     RunObject = Page 7023;
//                 }
//                 action("Stock Take List")
//                 {
//                     Caption = 'Stock Take List';
//                     RunObject = Page 50006;
//                 }
//             }
//             group("TJC - Manufacturing")
//             {
//                 Caption = 'TJC - Manufacturing';
//                 Image = Production;
//                 action("Consumption Journal")
//                 {
//                     Caption = 'Consumption Journal';
//                     RunObject = Page 99000846;
//                 }
//                 action("Output Journals")
//                 {
//                     Caption = 'Output Journals';
//                     RunObject = Page 99000823;
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
//                 action("Inve&ntory Setup")
//                 {
//                     Caption = 'Inve&ntory Setup';
//                     Image = InventorySetup;
//                     RunObject = Page 461;
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
//                 action(Navigate)
//                 {
//                     Caption = 'Navigate';
//                     RunObject = Page 344;
//                 }
//             }
//         }
//     }
// }

