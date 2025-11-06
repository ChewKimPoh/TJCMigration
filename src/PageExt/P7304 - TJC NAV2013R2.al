// page 7304 "Bin Content"
// {
//     Caption = 'Bin Content';
//     DataCaptionExpression = GetCaption;
//     DelayedInsert = true;
//     PageType = List;
//     SourceTable = Table7302;

//     layout
//     {
//         area(content)
//         {
//             repeater()
//             {
//                 field("Item Desc1";"Item Desc1")
//                 {
//                 }
//                 field("Item Desc2";"Item Desc2")
//                 {
//                 }
//                 field("Location Code";"Location Code")
//                 {
//                     Editable = false;
//                     Visible = false;
//                 }
//                 field("Zone Code";"Zone Code")
//                 {
//                     Visible = false;
//                 }
//                 field("Bin Code";"Bin Code")
//                 {
//                     Editable = false;
//                 }
//                 field("Bin Type Code";"Bin Type Code")
//                 {
//                     Visible = false;
//                 }
//                 field("Block Movement";"Block Movement")
//                 {
//                     Visible = false;
//                 }
//                 field("Bin Ranking";"Bin Ranking")
//                 {
//                     Visible = false;
//                 }
//                 field(Fixed;Fixed)
//                 {
//                 }
//                 field(Default;Default)
//                 {
//                 }
//                 field(Dedicated;Dedicated)
//                 {
//                 }
//                 field("Warehouse Class Code";"Warehouse Class Code")
//                 {
//                     Visible = false;
//                 }
//                 field("Item No.";"Item No.")
//                 {
//                 }
//                 field("Variant Code";"Variant Code")
//                 {
//                     Visible = false;
//                 }
//                 field(CalcQtyUOM;CalcQtyUOM)
//                 {
//                     Caption = 'Quantity';
//                     DecimalPlaces = 0:5;
//                 }
//                 field("Quantity (Base)";"Quantity (Base)")
//                 {
//                 }
//                 field("Min. Qty.";"Min. Qty.")
//                 {
//                     Visible = false;
//                 }
//                 field("Max. Qty.";"Max. Qty.")
//                 {
//                     Visible = false;
//                 }
//                 field("Qty. per Unit of Measure";"Qty. per Unit of Measure")
//                 {
//                     Visible = false;
//                 }
//                 field("Unit of Measure Code";"Unit of Measure Code")
//                 {
//                     Visible = false;
//                 }
//             }
//         }
//         area(factboxes)
//         {
//             part(;9126)
//             {
//                 SubPageLink = Item No.=FIELD(Item No.),
//                               Variant Code=FIELD(Variant Code),
//                               Location Code=FIELD(Location Code);
//                 Visible = false;
//             }
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
//     }

//     trigger OnNewRecord(BelowxRec: Boolean)
//     begin
//         IF xRec."Location Code" <> '' THEN
//           "Location Code" := xRec."Location Code";
//         IF xRec."Bin Code" <> '' THEN
//           "Bin Code" := xRec."Bin Code";
//         SetUpNewLine;
//     end;
// }

