// page 7379 "Item Bin Contents"
// {
//     Caption = 'Item Bin Contents';
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
//                 field("Item No.";"Item No.")
//                 {
//                     Visible = false;
//                 }
//                 field("Item Desc1";"Item Desc1")
//                 {
//                 }
//                 field("Item Desc2";"Item Desc2")
//                 {
//                 }
//                 field("Variant Code";"Variant Code")
//                 {
//                     Visible = false;
//                 }
//                 field("Location Code";"Location Code")
//                 {
//                 }
//                 field("Bin Code";"Bin Code")
//                 {
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
//                 field(CalcQtyUOM;CalcQtyUOM)
//                 {
//                     Caption = 'Quantity';
//                     DecimalPlaces = 0:5;
//                 }
//                 field("Unit of Measure Code";"Unit of Measure Code")
//                 {
//                 }
//                 field("Quantity (Base)";"Quantity (Base)")
//                 {
//                 }
//                 field("Bin Type Code";"Bin Type Code")
//                 {
//                     Visible = false;
//                 }
//                 field("Zone Code";"Zone Code")
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
//     end;

//     local procedure GetCaption(): Text[250]
//     var
//         ObjTransl: Record "377";
//         ItemNo: Code[20];
//         VariantCode: Code[10];
//         BinCode: Code[20];
//         FormCaption: Text[250];
//         SourceTableName: Text[30];
//     begin
//         SourceTableName := ObjTransl.TranslateObject(ObjTransl."Object Type"::Table,14);
//         FormCaption := STRSUBSTNO('%1 %2',SourceTableName,"Location Code");
//         IF GETFILTER("Item No.") <> '' THEN
//           IF GETRANGEMIN("Item No.") = GETRANGEMAX("Item No.") THEN BEGIN
//             ItemNo := GETRANGEMIN("Item No.");
//             IF ItemNo <> '' THEN BEGIN
//               SourceTableName := ObjTransl.TranslateObject(ObjTransl."Object Type"::Table,27);
//               FormCaption := STRSUBSTNO('%1 %2 %3',FormCaption,SourceTableName,ItemNo)
//             END;
//           END;

//         IF GETFILTER("Variant Code") <> '' THEN
//           IF GETRANGEMIN("Variant Code") = GETRANGEMAX("Variant Code") THEN BEGIN
//             VariantCode := GETRANGEMIN("Variant Code");
//             IF VariantCode <> '' THEN BEGIN
//               SourceTableName := ObjTransl.TranslateObject(ObjTransl."Object Type"::Table,5401);
//               FormCaption := STRSUBSTNO('%1 %2 %3',FormCaption,SourceTableName,VariantCode)
//             END;
//           END;

//         IF GETFILTER("Bin Code") <> '' THEN
//           IF GETRANGEMIN("Bin Code") = GETRANGEMAX("Bin Code") THEN BEGIN
//             BinCode := GETRANGEMIN("Bin Code");
//             IF BinCode <> '' THEN BEGIN
//               SourceTableName := ObjTransl.TranslateObject(ObjTransl."Object Type"::Table,7354);
//               FormCaption := STRSUBSTNO('%1 %2 %3',FormCaption,SourceTableName,BinCode);
//             END;
//           END;

//         EXIT(FormCaption);
//     end;
// }

