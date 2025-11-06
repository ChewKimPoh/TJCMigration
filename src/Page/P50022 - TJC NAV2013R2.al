// page 50022 "Sickness Category"
// {
//     PageType = List;
//     SourceTable = Table50010;

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
//         area(processing)
//         {
//             group()
//             {
//                 action(Sickness)
//                 {
//                     Caption = 'Sickness';
//                     Image = AbsenceCategories;
//                     Promoted = true;
//                     PromotedCategory = Process;
//                     RunObject = Page 50016;
//                     RunPageLink = Category EntryNo=FIELD(EntryNo);
//                 }
//             }
//         }
//     }

//     trigger OnInsertRecord(BelowxRec: Boolean): Boolean
//     var
//         rCategory: Record "50010";
//         LineNo: Integer;
//     begin

//         rCategory.RESET;
//         IF rCategory.FINDLAST THEN
//           LineNo := rCategory.EntryNo
//         ELSE
//           LineNo := 0 ;
//         EntryNo :=LineNo + 1;
//     end;
// }

