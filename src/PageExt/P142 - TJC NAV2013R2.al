// page 142 "Posted Sales Shipments"
// {
//     Caption = 'Posted Sales Shipments';
//     CardPageID = "Posted Sales Shipment";
//     Editable = false;
//     PageType = List;
//     SourceTable = Table110;

//     layout
//     {
//         area(content)
//         {
//             repeater()
//             {
//                 field("Order No.";"Order No.")
//                 {
//                 }
//                 field("No.";"No.")
//                 {
//                 }
//                 field("Sell-to Customer No.";"Sell-to Customer No.")
//                 {
//                 }
//                 field("Sell-to Customer Name";"Sell-to Customer Name")
//                 {
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
//                 field("Currency Code";"Currency Code")
//                 {
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
//                 field("Requested Delivery Date";"Requested Delivery Date")
//                 {
//                     Visible = false;
//                 }
//                 field("Shipment Method Code";"Shipment Method Code")
//                 {
//                     Visible = false;
//                 }
//                 field("Shipping Agent Code";"Shipping Agent Code")
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
//             group("&Shipment")
//             {
//                 Caption = '&Shipment';
//                 Image = Shipment;
//                 action(Statistics)
//                 {
//                     Caption = 'Statistics';
//                     Image = Statistics;
//                     Promoted = true;
//                     PromotedCategory = Process;
//                     RunObject = Page 396;
//                     RunPageLink = No.=FIELD(No.);
//                     ShortCutKey = 'F7';
//                 }
//                 action("Co&mments")
//                 {
//                     Caption = 'Co&mments';
//                     Image = ViewComments;
//                     RunObject = Page 67;
//                     RunPageLink = Document Type=CONST(Shipment),
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
//                 action(CertificateOfSupplyDetails)
//                 {
//                     Caption = 'Certificate of Supply Details';
//                     Image = Certificate;
//                     RunObject = Page 780;
//                     RunPageLink = Document Type=FILTER(Sales Shipment),
//                                   Document No.=FIELD(No.);
//                 }
//                 action(PrintCertificateofSupply)
//                 {
//                     Caption = 'Print Certificate of Supply';
//                     Image = PrintReport;
//                     Promoted = false;
//                     //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
//                     //PromotedCategory = Process;

//                     trigger OnAction()
//                     var
//                         CertificateOfSupply: Record "780";
//                     begin
//                         CertificateOfSupply.SETRANGE("Document Type",CertificateOfSupply."Document Type"::"Sales Shipment");
//                         CertificateOfSupply.SETRANGE("Document No.","No.");
//                         CertificateOfSupply.Print;
//                     end;
//                 }
//             }
//         }
//         area(processing)
//         {
//             group("F&unctions")
//             {
//                 Caption = 'F&unctions';
//                 Image = "Action";
//                 action("&Track Package")
//                 {
//                     Caption = '&Track Package';
//                     Image = ItemTracking;

//                     trigger OnAction()
//                     begin
//                         StartTrackingSite;
//                     end;
//                 }
//             }
//             action("&Print")
//             {
//                 Caption = '&Print';
//                 Ellipsis = true;
//                 Image = Print;
//                 Promoted = true;
//                 PromotedCategory = Process;

//                 trigger OnAction()
//                 var
//                     SalesShptHeader: Record "110";
//                 begin
//                     CurrPage.SETSELECTIONFILTER(SalesShptHeader);
//                     SalesShptHeader.PrintRecords(TRUE);
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

