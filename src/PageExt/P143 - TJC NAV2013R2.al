// page 143 "Posted Sales Invoices"
// {
//     Caption = 'Posted Sales Invoices';
//     CardPageID = "Posted Sales Invoice";
//     Editable = false;
//     PageType = List;
//     SourceTable = Table112;

//     layout
//     {
//         area(content)
//         {
//             repeater()
//             {
//                 field("No.";"No.")
//                 {
//                 }
//                 field("Sell-to Customer No.";"Sell-to Customer No.")
//                 {
//                 }
//                 field("Sell-to Customer Name";"Sell-to Customer Name")
//                 {
//                 }
//                 field("External Document No.";"External Document No.")
//                 {
//                 }
//                 field("Currency Code";"Currency Code")
//                 {
//                 }
//                 field(Amount;Amount)
//                 {

//                     trigger OnDrillDown()
//                     begin
//                         SETRANGE("No.");
//                         PAGE.RUNMODAL(PAGE::"Posted Sales Invoice",Rec)
//                     end;
//                 }
//                 field("Amount Including VAT";"Amount Including VAT")
//                 {

//                     trigger OnDrillDown()
//                     begin
//                         SETRANGE("No.");
//                         PAGE.RUNMODAL(PAGE::"Posted Sales Invoice",Rec)
//                     end;
//                 }
//                 field("Sell-to Post Code";"Sell-to Post Code")
//                 {
//                     Visible = false;
//                 }
//                 field("Sell-to Country/Region Code";"Sell-to Country/Region Code")
//                 {
//                     Visible = false;
//                 }
//                 field("Sell-to Contact";"Sell-to Contact")
//                 {
//                     Visible = false;
//                 }
//                 field("Bill-to Customer No.";"Bill-to Customer No.")
//                 {
//                     Visible = false;
//                 }
//                 field("Bill-to Name";"Bill-to Name")
//                 {
//                     Visible = false;
//                 }
//                 field("Bill-to Post Code";"Bill-to Post Code")
//                 {
//                     Visible = false;
//                 }
//                 field("Bill-to Country/Region Code";"Bill-to Country/Region Code")
//                 {
//                     Visible = false;
//                 }
//                 field("Bill-to Contact";"Bill-to Contact")
//                 {
//                     Visible = false;
//                 }
//                 field("Ship-to Code";"Ship-to Code")
//                 {
//                     Visible = false;
//                 }
//                 field("Ship-to Name";"Ship-to Name")
//                 {
//                     Visible = false;
//                 }
//                 field("Ship-to Post Code";"Ship-to Post Code")
//                 {
//                     Visible = false;
//                 }
//                 field("Ship-to Country/Region Code";"Ship-to Country/Region Code")
//                 {
//                     Visible = false;
//                 }
//                 field("Ship-to Contact";"Ship-to Contact")
//                 {
//                     Visible = false;
//                 }
//                 field("Posting Date";"Posting Date")
//                 {
//                     Visible = false;
//                 }
//                 field("Salesperson Code";"Salesperson Code")
//                 {
//                     Visible = false;
//                 }
//                 field("Shortcut Dimension 1 Code";"Shortcut Dimension 1 Code")
//                 {
//                     Visible = false;
//                 }
//                 field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
//                 {
//                     Visible = false;
//                 }
//                 field("Location Code";"Location Code")
//                 {
//                     Visible = true;
//                 }
//                 field("No. Printed";"No. Printed")
//                 {
//                 }
//                 field("Document Date";"Document Date")
//                 {
//                     Visible = false;
//                 }
//                 field("Payment Terms Code";"Payment Terms Code")
//                 {
//                     Visible = false;
//                 }
//                 field("Due Date";"Due Date")
//                 {
//                     Visible = false;
//                 }
//                 field("Payment Discount %";"Payment Discount %")
//                 {
//                     Visible = false;
//                 }
//                 field("Shipment Method Code";"Shipment Method Code")
//                 {
//                     Visible = false;
//                 }
//                 field("Shipment Date";"Shipment Date")
//                 {
//                     Visible = false;
//                 }
//             }
//         }
//         area(factboxes)
//         {
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
//             group("&Invoice")
//             {
//                 Caption = '&Invoice';
//                 Image = Invoice;
//                 action(Card)
//                 {
//                     Caption = 'Card';
//                     Image = EditLines;
//                     ShortCutKey = 'Shift+F7';

//                     trigger OnAction()
//                     begin
//                         PAGE.RUN(PAGE::"Posted Sales Invoice",Rec)
//                     end;
//                 }
//                 action(Statistics)
//                 {
//                     Caption = 'Statistics';
//                     Image = Statistics;
//                     Promoted = true;
//                     PromotedCategory = Process;
//                     RunObject = Page 397;
//                     RunPageLink = No.=FIELD(No.);
//                     ShortCutKey = 'F7';
//                 }
//                 action("Co&mments")
//                 {
//                     Caption = 'Co&mments';
//                     Image = ViewComments;
//                     RunObject = Page 67;
//                     RunPageLink = Document Type=CONST(Posted Invoice),
//                                   No.=FIELD(No.);
//                 }
//                 action(Dimensions)
//                 {
//                     Caption = 'Dimensions';
//                     Image = Dimensions;
//                     ShortCutKey = 'Shift+Ctrl+D';

//                     trigger OnAction()
//                     begin
//                         ShowDimensions;
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
//                 var
//                     SalesInvHeader: Record "112";
//                 begin
//                     CurrPage.SETSELECTIONFILTER(SalesInvHeader);
//                     SalesInvHeader.PrintRecords(TRUE);
//                 end;
//             }
//             action("&Navigate")
//             {
//                 Caption = '&Navigate';
//                 Image = Navigate;
//                 Promoted = true;
//                 PromotedCategory = Process;

//                 trigger OnAction()
//                 begin
//                     Navigate;
//                 end;
//             }
//         }
//     }

//     trigger OnOpenPage()
//     begin
//         SetSecurityFilterOnRespCenter;
//     end;
// }

