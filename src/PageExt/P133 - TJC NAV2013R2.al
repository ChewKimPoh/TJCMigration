// page 133 "Posted Sales Invoice Subform"
// {
//     AutoSplitKey = true;
//     Caption = 'Lines';
//     Editable = false;
//     LinksAllowed = false;
//     PageType = ListPart;
//     SourceTable = Table113;

//     layout
//     {
//         area(content)
//         {
//             repeater()
//             {
//                 field("Line No.";"Line No.")
//                 {
//                 }
//                 field(Type;Type)
//                 {
//                 }
//                 field("Shipment No.";"Shipment No.")
//                 {
//                 }
//                 field("No.";"No.")
//                 {
//                 }
//                 field("Gen. Bus. Posting Group";"Gen. Bus. Posting Group")
//                 {
//                 }
//                 field("Gen. Prod. Posting Group";"Gen. Prod. Posting Group")
//                 {
//                 }
//                 field("VAT Bus. Posting Group";"VAT Bus. Posting Group")
//                 {
//                 }
//                 field("VAT Prod. Posting Group";"VAT Prod. Posting Group")
//                 {
//                 }
//                 field("Cross-Reference No.";"Cross-Reference No.")
//                 {
//                     Visible = false;
//                 }
//                 field("IC Partner Code";"IC Partner Code")
//                 {
//                     Visible = false;
//                 }
//                 field("Variant Code";"Variant Code")
//                 {
//                     Visible = false;
//                 }
//                 field(Description;Description)
//                 {
//                 }
//                 field("Return Reason Code";"Return Reason Code")
//                 {
//                     Visible = false;
//                 }
//                 field(Quantity;Quantity)
//                 {
//                     BlankZero = true;
//                 }
//                 field("Unit of Measure Code";"Unit of Measure Code")
//                 {
//                 }
//                 field("Unit of Measure";"Unit of Measure")
//                 {
//                     Visible = false;
//                 }
//                 field("Unit Cost (LCY)";"Unit Cost (LCY)")
//                 {
//                     Visible = false;
//                 }
//                 field("Unit Price";"Unit Price")
//                 {
//                     BlankZero = true;
//                 }
//                 field("Line Amount";"Line Amount")
//                 {
//                     BlankZero = true;
//                 }
//                 field("Line Discount %";"Line Discount %")
//                 {
//                     BlankZero = true;
//                 }
//                 field("Line Discount Amount";"Line Discount Amount")
//                 {
//                     Visible = false;
//                 }
//                 field("Allow Invoice Disc.";"Allow Invoice Disc.")
//                 {
//                     Visible = false;
//                 }
//                 field("Job No.";"Job No.")
//                 {
//                     Visible = false;
//                 }
//                 field("Appl.-to Item Entry";"Appl.-to Item Entry")
//                 {
//                     Visible = false;
//                 }
//                 field("Shortcut Dimension 1 Code";"Shortcut Dimension 1 Code")
//                 {
//                     Visible = false;
//                 }
//                 field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
//                 {
//                     Visible = true;
//                 }
//             }
//         }
//     }

//     actions
//     {
//         area(processing)
//         {
//             group("&Line")
//             {
//                 Caption = '&Line';
//                 Image = Line;
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
//                 action("Co&mments")
//                 {
//                     Caption = 'Co&mments';
//                     Image = ViewComments;

//                     trigger OnAction()
//                     begin
//                         ShowLineComments;
//                     end;
//                 }
//                 action(ItemTrackingEntries)
//                 {
//                     Caption = 'Item &Tracking Entries';
//                     Image = ItemTrackingLedger;

//                     trigger OnAction()
//                     begin
//                         ShowItemTrackingLines;
//                     end;
//                 }
//                 action("Item Shipment &Lines")
//                 {
//                     Caption = 'Item Shipment &Lines';
//                     Image = ShipmentLines;

//                     trigger OnAction()
//                     begin
//                         IF NOT (Type IN [Type::Item,Type::"Charge (Item)"]) THEN
//                           TESTFIELD(Type);
//                         ShowItemShipmentLines;
//                     end;
//                 }
//             }
//         }
//     }
// }

