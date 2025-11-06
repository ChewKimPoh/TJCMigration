// page 53 "Purchase List"
// {
//     Caption = 'Purchase List';
//     DataCaptionFields = "Document Type";
//     Editable = false;
//     PageType = List;
//     SourceTable = Table38;

//     layout
//     {
//         area(content)
//         {
//             repeater()
//             {
//                 field("Posting Date";"Posting Date")
//                 {
//                 }
//                 field(Status;Status)
//                 {
//                 }
//                 field("No.";"No.")
//                 {
//                 }
//                 field("Buy-from Vendor No.";"Buy-from Vendor No.")
//                 {
//                 }
//                 field("Printing Version";"Printing Version")
//                 {
//                 }
//                 field("Order Address Code";"Order Address Code")
//                 {
//                     Visible = false;
//                 }
//                 field("Buy-from Vendor Name";"Buy-from Vendor Name")
//                 {
//                 }
//                 field("Vendor Authorization No.";"Vendor Authorization No.")
//                 {
//                 }
//                 field("Buy-from Post Code";"Buy-from Post Code")
//                 {
//                     Visible = false;
//                 }
//                 field("Buy-from Country/Region Code";"Buy-from Country/Region Code")
//                 {
//                     Visible = false;
//                 }
//                 field("Buy-from Contact";"Buy-from Contact")
//                 {
//                     Visible = false;
//                 }
//                 field("Pay-to Vendor No.";"Pay-to Vendor No.")
//                 {
//                     Visible = false;
//                 }
//                 field("Pay-to Name";"Pay-to Name")
//                 {
//                     Visible = false;
//                 }
//                 field("Pay-to Post Code";"Pay-to Post Code")
//                 {
//                     Visible = false;
//                 }
//                 field("Pay-to Country/Region Code";"Pay-to Country/Region Code")
//                 {
//                     Visible = false;
//                 }
//                 field("Pay-to Contact";"Pay-to Contact")
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
//                 field("Shortcut Dimension 1 Code";"Shortcut Dimension 1 Code")
//                 {
//                     Visible = false;

//                     trigger OnLookup(var Text: Text): Boolean
//                     begin
//                         DimMgt.LookupDimValueCodeNoUpdate(1);
//                     end;
//                 }
//                 field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
//                 {
//                     Visible = false;

//                     trigger OnLookup(var Text: Text): Boolean
//                     begin
//                         DimMgt.LookupDimValueCodeNoUpdate(2);
//                     end;
//                 }
//                 field("Location Code";"Location Code")
//                 {
//                     Visible = true;
//                 }
//                 field("Purchaser Code";"Purchaser Code")
//                 {
//                     Visible = false;
//                 }
//                 field("Assigned User ID";"Assigned User ID")
//                 {
//                 }
//                 field("Currency Code";"Currency Code")
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
//                 Visible = false;
//             }
//         }
//     }

//     actions
//     {
//         area(navigation)
//         {
//             group("&Line")
//             {
//                 Caption = '&Line';
//                 Image = Line;
//                 action(Card)
//                 {
//                     Caption = 'Card';
//                     Image = EditLines;
//                     ShortCutKey = 'Shift+F7';

//                     trigger OnAction()
//                     begin
//                         CASE "Document Type" OF
//                           "Document Type"::Quote:
//                             PAGE.RUN(PAGE::"Purchase Quote",Rec);
//                           "Document Type"::"Blanket Order":
//                             PAGE.RUN(PAGE::"Blanket Purchase Order",Rec);
//                           "Document Type"::Order:
//                             PAGE.RUN(PAGE::"Purchase Order",Rec);
//                           "Document Type"::Invoice:
//                             PAGE.RUN(PAGE::"Purchase Invoice",Rec);
//                           "Document Type"::"Return Order":
//                             PAGE.RUN(PAGE::"Purchase Return Order",Rec);
//                           "Document Type"::"Credit Memo":
//                             PAGE.RUN(PAGE::"Purchase Credit Memo",Rec);
//                         END;
//                     end;
//                 }
//             }
//         }
//         area(reporting)
//         {
//             action("Purchase Reservation Avail.")
//             {
//                 Caption = 'Purchase Reservation Avail.';
//                 Image = "Report";
//                 Promoted = false;
//                 //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
//                 //PromotedCategory = "Report";
//                 RunObject = Report 409;
//             }
//         }
//     }

//     var
//         DimMgt: Codeunit "408";
// }

