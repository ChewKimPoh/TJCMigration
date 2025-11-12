// page 50053 "TMC (Clinic) Activities"
// {
//     // Version No.         : BINSG1.00
//     // Developer           : DP.LYL
//     // Init. DEV. Date     : 06/09/2013
//     // Date of Last Change :
//     // Description:
//     //   1. New page to create for Sales & Purchase Activities (BIN-30)

//     Caption = 'Activities';
//     PageType = CardPart;
//     SourceTable = Table50014;

//     layout
//     {
//         area(content)
//         {
//             cuegroup(SALES)
//             {
//                 Caption = 'SALES';
//                 field("Sales Orders - Open";"Sales Orders - Open")
//                 {
//                     Caption = 'Open SO';
//                     DrillDownPageID = "Sales Order List";
//                 }
//                 field("Sales Orders - Released";"Sales Orders - Released")
//                 {
//                     Caption = 'Released SO';
//                     DrillDownPageID = "Sales Order List";
//                 }
//                 field("Overdue Sales Documents";"Overdue Sales Documents")
//                 {
//                     DrillDownPageID = "Customer Ledger Entries";
//                 }
//                 field("Sales Return Orders - All";"Sales Return Orders - All")
//                 {
//                     Caption = 'Sales Return Orders';
//                     DrillDownPageID = "Sales Return Order List";
//                 }

//                 actions
//                 {
//                     action("New Sales Order")
//                     {
//                         Caption = 'New Sales Order';
//                         RunObject = Page 42;
//                         RunPageMode = Create;
//                     }
//                     action("New Sales Invoice")
//                     {
//                         Caption = 'New Sales Invoice';
//                         RunObject = Page 43;
//                         RunPageMode = Create;
//                     }
//                     action("New Sales Return Order")
//                     {
//                         Caption = 'New Sales Return Order';
//                         RunObject = Page 6630;
//                         RunPageMode = Create;
//                     }
//                 }
//             }
//             cuegroup(PURCHASE)
//             {
//                 Caption = 'PURCHASE';
//                 field("To Send or Confirm";"To Send or Confirm")
//                 {
//                     DrillDownPageID = "Purchase Order List";
//                 }
//                 field("Upcoming Orders";"Upcoming Orders")
//                 {
//                     DrillDownPageID = "Purchase Order List";
//                 }
//                 field("Outstanding Purch. Orders";"Outstanding Purch. Orders")
//                 {
//                     Caption = 'Outstanding PO';
//                     DrillDownPageID = "Purchase Order List";
//                 }
//                 field("Expected Purch. Orders - Today";"Expected Purch. Orders - Today")
//                 {
//                     Caption = 'Expected PO - Today';
//                     DrillDownPageID = "Purchase Order List";
//                 }

//                 actions
//                 {
//                     action("New Purch. Order")
//                     {
//                         Caption = 'New Purch. Order';
//                         RunObject = Page 50;
//                         RunPageMode = Create;
//                     }
//                     action("New Purch. Invoice")
//                     {
//                         Caption = 'New Purch. Invoice';
//                         RunObject = Page 9308;
//                         RunPageMode = Create;
//                     }
//                     action("New Purch. Credit Note")
//                     {
//                         Caption = 'New Purch. Credit Note';
//                         RunObject = Page 9309;
//                         RunPageMode = Create;
//                     }
//                     action("New Inventory Put-away")
//                     {
//                         Caption = 'New Inventory Put-away';
//                         RunObject = Page 7375;
//                         RunPageMode = Create;
//                     }
//                 }
//             }
//             cuegroup()
//             {
//                 field("Not Invoiced (Purch)";"Not Invoiced (Purch)")
//                 {
//                     DrillDownPageID = "Purchase Order List";
//                 }
//                 field("Partially Invoiced (Purch)";"Partially Invoiced (Purch)")
//                 {
//                     DrillDownPageID = "Purchase Order List";
//                 }
//                 field("Purch. Invoices Due Today";"Purch. Invoices Due Today")
//                 {
//                     Caption = 'Invoices Due Today';
//                     DrillDownPageID = "Vendor Ledger Entries";
//                 }
//                 field("Purch. Credit Memo - All";"Purch. Credit Memo - All")
//                 {
//                     Caption = 'Credit Notes';
//                     DrillDownPageID = "Purchase Credit Memos";
//                 }
//                 field("Inventory Put-aways - Today";"Inventory Put-aways - Today")
//                 {
//                     DrillDownPageID = "Inventory Put-aways";
//                 }
//             }
//         }
//     }

//     actions
//     {
//     }

//     trigger OnOpenPage()
//     begin
//         RESET;
//         IF NOT GET THEN BEGIN
//           INIT;
//           INSERT;
//         END;

//         SETRANGE("Date Filter1",0D,WORKDATE - 1);
//         SETRANGE("Date Filter3",0D,WORKDATE);

//         SETFILTER("Due Date Filter",'<=%1',WORKDATE);
//         SETFILTER("Overdue Date Filter",'<%1',WORKDATE);

//         LocationCode := WhseWMSCue.GetEmployeeLocation(USERID);
//         SETFILTER("Location Filter",LocationCode);
//     end;

//     var
//         WhseWMSCue: Record "9051";
//         LocationCode: Text[1024];
// }

