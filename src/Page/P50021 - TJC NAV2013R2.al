// page 50021 Pulse
// {
//     PageType = List;
//     SourceTable = Table50009;

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
//         rPulse: Record "50009";
//         LineNo: Integer;
//     begin
//         rPulse.RESET;
//         IF rPulse.FINDLAST THEN
//           LineNo := rPulse.EntryNo
//         ELSE
//           LineNo := 0 ;
//         EntryNo :=LineNo + 1;
//     end;
// }

