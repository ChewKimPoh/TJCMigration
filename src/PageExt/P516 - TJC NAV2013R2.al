// page 516 "Sales Lines"
// {
//     Caption = 'Sales Lines';
//     Editable = false;
//     LinksAllowed = false;
//     PageType = List;
//     SourceTable = Table37;

//     layout
//     {
//         area(content)
//         {
//             repeater()
//             {
//                 field("Document Type";"Document Type")
//                 {
//                 }
//                 field("Document No.";"Document No.")
//                 {
//                 }
//                 field("Sell-to Customer No.";"Sell-to Customer No.")
//                 {
//                 }
//                 field("Line No.";"Line No.")
//                 {
//                     Visible = false;
//                 }
//                 field(Type;Type)
//                 {
//                 }
//                 field("No.";"No.")
//                 {
//                 }
//                 field("Qty. to Ship";"Qty. to Ship")
//                 {
//                 }
//                 field("Variant Code";"Variant Code")
//                 {
//                     Visible = false;
//                 }
//                 field(Description;Description)
//                 {
//                 }
//                 field("Location Code";"Location Code")
//                 {
//                     Visible = true;
//                 }
//                 field(Reserve;Reserve)
//                 {
//                 }
//                 field(Quantity;Quantity)
//                 {
//                 }
//                 field("Reserved Qty. (Base)";"Reserved Qty. (Base)")
//                 {
//                 }
//                 field("Unit of Measure Code";"Unit of Measure Code")
//                 {
//                 }
//                 field("Line Amount";"Line Amount")
//                 {
//                     BlankZero = true;
//                 }
//                 field("Job No.";"Job No.")
//                 {
//                     Visible = false;
//                 }
//                 field("Work Type Code";"Work Type Code")
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
//                 field(ShortcutDimCode[3];ShortcutDimCode[3])
//                 {
//                     CaptionClass = '1,2,3';
//                     Visible = false;

//                     trigger OnLookup(var Text: Text): Boolean
//                     begin
//                         LookupShortcutDimCode(3,ShortcutDimCode[3]);
//                     end;
//                 }
//                 field(ShortcutDimCode[4];ShortcutDimCode[4])
//                 {
//                     CaptionClass = '1,2,4';
//                     Visible = false;

//                     trigger OnLookup(var Text: Text): Boolean
//                     begin
//                         LookupShortcutDimCode(4,ShortcutDimCode[4]);
//                     end;
//                 }
//                 field(ShortcutDimCode[5];ShortcutDimCode[5])
//                 {
//                     CaptionClass = '1,2,5';
//                     Visible = false;

//                     trigger OnLookup(var Text: Text): Boolean
//                     begin
//                         LookupShortcutDimCode(5,ShortcutDimCode[5]);
//                     end;
//                 }
//                 field(ShortcutDimCode[6];ShortcutDimCode[6])
//                 {
//                     CaptionClass = '1,2,6';
//                     Visible = false;

//                     trigger OnLookup(var Text: Text): Boolean
//                     begin
//                         LookupShortcutDimCode(6,ShortcutDimCode[6]);
//                     end;
//                 }
//                 field(ShortcutDimCode[7];ShortcutDimCode[7])
//                 {
//                     CaptionClass = '1,2,7';
//                     Visible = false;

//                     trigger OnLookup(var Text: Text): Boolean
//                     begin
//                         LookupShortcutDimCode(7,ShortcutDimCode[7]);
//                     end;
//                 }
//                 field(ShortcutDimCode[8];ShortcutDimCode[8])
//                 {
//                     CaptionClass = '1,2,8';
//                     Visible = false;

//                     trigger OnLookup(var Text: Text): Boolean
//                     begin
//                         LookupShortcutDimCode(8,ShortcutDimCode[8]);
//                     end;
//                 }
//                 field("Shipment Date";"Shipment Date")
//                 {
//                 }
//                 field("Outstanding Quantity";"Outstanding Quantity")
//                 {
//                 }
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
//                 action("Show Document")
//                 {
//                     Caption = 'Show Document';
//                     Image = View;
//                     Promoted = true;
//                     PromotedCategory = Process;
//                     PromotedIsBig = true;
//                     ShortCutKey = 'Shift+F7';

//                     trigger OnAction()
//                     begin
//                         SalesHeader.GET("Document Type","Document No.");
//                         CASE "Document Type" OF
//                           "Document Type"::Quote:
//                             PAGE.RUN(PAGE::"Sales Quote",SalesHeader);
//                           "Document Type"::Order:
//                             PAGE.RUN(PAGE::"Sales Order",SalesHeader);
//                           "Document Type"::Invoice:
//                             PAGE.RUN(PAGE::"Sales Invoice",SalesHeader);
//                           "Document Type"::"Return Order":
//                             PAGE.RUN(PAGE::"Sales Return Order",SalesHeader);
//                           "Document Type"::"Credit Memo":
//                             PAGE.RUN(PAGE::"Sales Credit Memo",SalesHeader);
//                           "Document Type"::"Blanket Order":
//                             PAGE.RUN(PAGE::"Blanket Sales Order",SalesHeader);
//                         END;
//                     end;
//                 }
//                 action("Reservation Entries")
//                 {
//                     Caption = 'Reservation Entries';
//                     Image = ReservationLedger;
//                     Promoted = true;
//                     PromotedCategory = Process;
//                     PromotedIsBig = true;

//                     trigger OnAction()
//                     begin
//                         ShowReservationEntries(TRUE);
//                     end;
//                 }
//                 action("Item &Tracking Lines")
//                 {
//                     Caption = 'Item &Tracking Lines';
//                     Image = ItemTrackingLines;
//                     Promoted = true;
//                     PromotedCategory = Process;
//                     PromotedIsBig = true;
//                     ShortCutKey = 'Shift+Ctrl+I';

//                     trigger OnAction()
//                     begin
//                         OpenItemTrackingLines;
//                     end;
//                 }
//             }
//         }
//     }

//     trigger OnAfterGetRecord()
//     begin
//         ShowShortcutDimCode(ShortcutDimCode);
//     end;

//     trigger OnNewRecord(BelowxRec: Boolean)
//     begin
//         CLEAR(ShortcutDimCode);
//     end;

//     var
//         SalesHeader: Record "36";
//         ShortcutDimCode: array [8] of Code[20];
// }

