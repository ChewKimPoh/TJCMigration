// page 50043 "Sales Role Center"
// {
//     PageType = RoleCenter;

//     layout
//     {
//         area(rolecenter)
//         {
//             group()
//             {
//                 part(;50050)
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
//             action("Set Customer Points to Redeeme")
//             {
//                 Caption = 'Set Customer Points to Redeeme';
//                 RunObject = Report 50029;
//             }
//             group("Sales Reports")
//             {
//                 Caption = 'Sales Reports';
//                 Image = "Report";
//                 action("Customer - Order Detail")
//                 {
//                     Caption = 'Customer - Order Detail';
//                     Image = "Report";
//                     RunObject = Report 108;
//                 }
//                 action("Customer - &Order Summary")
//                 {
//                     Caption = 'Customer - &Order Summary';
//                     Image = "Report";
//                     RunObject = Report 107;
//                 }
//                 action("Customer - &Top 10 List")
//                 {
//                     Caption = 'Customer - &Top 10 List';
//                     Image = "Report";
//                     RunObject = Report 111;
//                 }
//                 separator()
//                 {
//                 }
//                 action("S&ales Statistics")
//                 {
//                     Caption = 'S&ales Statistics';
//                     Image = "Report";
//                     RunObject = Report 112;
//                 }
//                 action("Salesperson - Sales &Statistics")
//                 {
//                     Caption = 'Salesperson - Sales &Statistics';
//                     Image = "Report";
//                     RunObject = Report 114;
//                 }
//                 action("Customer/Item Sales")
//                 {
//                     Caption = 'Customer/Item Sales';
//                     Image = "Report";
//                     RunObject = Report 113;
//                 }
//                 action("Customer - Sales List")
//                 {
//                     Caption = 'Customer - Sales List';
//                     Image = "Report";
//                     RunObject = Report 119;
//                 }
//                 action("Report 50002")
//                 {
//                     Caption = 'Picking List report';
//                     Image = "Report";
//                 }
//                 action("Report 50010")
//                 {
//                     Caption = 'Sales upon shipment';
//                 }
//                 action("Inventory Customer Sales")
//                 {
//                     Caption = 'Inventory Customer Sales';
//                     Image = "Report";
//                     RunObject = Report 713;
//                 }
//                 action("Inventory Top 10 List")
//                 {
//                     Caption = 'Inventory Top 10 List';
//                     Image = "Report";
//                     RunObject = Report 711;
//                 }
//             }
//             group("Sales Documents")
//             {
//                 Caption = 'Sales Documents';
//                 Image = "Report";
//                 action("Order Confirmation")
//                 {
//                     Caption = 'Order Confirmation';
//                     Image = "Report";
//                     //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
//                     //PromotedCategory = New;
//                     RunObject = Report 205;
//                 }
//                 action("Sales Document Test")
//                 {
//                     Caption = 'Sales Document Test';
//                     Image = "Report";
//                     RunObject = Report 202;
//                 }
//                 action("Sales Quote")
//                 {
//                     Caption = 'Sales Quote';
//                     Image = "Report";
//                     RunObject = Report 204;
//                 }
//                 action("Blanket Sales Order")
//                 {
//                     Caption = 'Blanket Sales Order';
//                     Image = "Report";
//                     RunObject = Report 210;
//                 }
//                 action("Sales Invoice")
//                 {
//                     Caption = 'Sales Invoice';
//                     Image = "Report";
//                     RunObject = Report 206;
//                 }
//                 action("Sales Credit Memo")
//                 {
//                     Caption = 'Sales Credit Memo';
//                     Image = "Report";
//                     RunObject = Report 207;
//                 }
//                 action("Sales - Shipment")
//                 {
//                     Caption = 'Sales - Shipment';
//                     Image = "Report";
//                     RunObject = Report 208;
//                 }
//                 action("Customer - Payment Receipt")
//                 {
//                     Caption = 'Customer - Payment Receipt';
//                     Image = "Report";
//                     RunObject = Report 211;
//                 }
//                 action("Return Order")
//                 {
//                     Caption = 'Return Order';
//                     Image = "Report";
//                     RunObject = Report 6641;
//                 }
//                 action("Sales - Return Receipt")
//                 {
//                     Caption = 'Sales - Return Receipt';
//                     Image = "Report";
//                     RunObject = Report 6646;
//                 }
//             }
//         }
//         area(embedding)
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
//         }
//         area(sections)
//         {
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
//         }
//         area(creation)
//         {
//             action("Sales Orders")
//             {
//                 Caption = 'Sales Orders';
//                 Image = Sales;
//                 RunObject = Page 42;
//                 RunPageMode = Create;
//             }
//         }
//         area(processing)
//         {
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
//                 action(Navigate)
//                 {
//                     Caption = 'Navigate';
//                     Image = Navigate;
//                     RunObject = Page 344;
//                 }
//             }
//         }
//     }
// }

