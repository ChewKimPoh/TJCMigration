// page 50015 "Sickness Type"
// {
//     PageType = List;
//     SourceTable = Table50005;

//     layout
//     {
//         area(content)
//         {
//             repeater()
//             {
//                 field("Type EntryNo";"Type EntryNo")
//                 {
//                 }
//                 field("Type Name";"Type Name")
//                 {
//                 }
//                 field(Description;Description)
//                 {
//                 }
//             }
//         }
//     }

//     actions
//     {
//     }

//     trigger OnInsertRecord(BelowxRec: Boolean): Boolean
//     var
//         rSicknessType: Record "50005";
//         LineNo: Integer;
//     begin
//         rSicknessType.RESET;
//         rSicknessType.SETRANGE(rSicknessType."Category EntryNo","Category EntryNo");
//         rSicknessType.SETRANGE(rSicknessType."Sickness EntryNo","Sickness EntryNo");
//         IF rSicknessType.FINDLAST THEN
//           LineNo :=rSicknessType."Type EntryNo";

//         "Type EntryNo" := LineNo + 1;
//     end;
// }

