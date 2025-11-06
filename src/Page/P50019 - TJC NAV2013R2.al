// page 50019 "Tongue 2"
// {
//     PageType = List;
//     SourceTable = Table50008;

//     layout
//     {
//         area(content)
//         {
//             repeater()
//             {
//                 field(EntryNo;EntryNo)
//                 {
//                 }
//                 field(Name;Name)
//                 {
//                 }
//             }
//         }
//     }

//     actions
//     {
//     }

//     trigger OnNewRecord(BelowxRec: Boolean)
//     var
//         rTongue2: Record "50008";
//         LineNo: Integer;
//     begin
//         rTongue2.RESET;
//         IF rTongue2.FINDLAST THEN
//           LineNo := rTongue2.EntryNo
//         ELSE
//           LineNo := 0 ;
//         EntryNo :=LineNo + 1;
//     end;
// }

