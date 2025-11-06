// page 50025 "Clinic Item Categories"
// {
//     Caption = 'Clinic Item Categories';
//     PageType = List;
//     SourceTable = Table5722;
//     SourceTableView = SORTING(Code)
//                       WHERE(Clinic=CONST(Yes));

//     layout
//     {
//         area(content)
//         {
//             repeater()
//             {
//                 field(Code;Code)
//                 {
//                 }
//                 field(Description;Description)
//                 {
//                 }
//                 field(Clinic;Clinic)
//                 {
//                     Editable = false;
//                 }
//             }
//         }
//     }

//     actions
//     {
//         area(processing)
//         {
//             action("&Prod. Groups")
//             {
//                 Caption = '&Prod. Groups';
//                 Promoted = true;
//                 PromotedCategory = Process;
//                 RunObject = Page 50026;
//                 RunPageLink = Item Category Code=FIELD(Code);
//             }
//         }
//     }

//     trigger OnInsertRecord(BelowxRec: Boolean): Boolean
//     begin
//         Clinic := TRUE;
//     end;

//     trigger OnNewRecord(BelowxRec: Boolean)
//     begin
//         Clinic := TRUE;
//     end;
// }

