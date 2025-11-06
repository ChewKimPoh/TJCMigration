// page 50018 "Tongue 1"
// {
//     PageType = List;
//     SourceTable = Table50007;

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
//         rTongue1: Record "50007";
//         LineNo: Integer;
//     begin
//         rTongue1.RESET;
//         IF rTongue1.FINDLAST THEN
//           LineNo := rTongue1.EntryNo
//         ELSE
//           LineNo := 0 ;
//         EntryNo :=LineNo + 1;
//     end;
// }

