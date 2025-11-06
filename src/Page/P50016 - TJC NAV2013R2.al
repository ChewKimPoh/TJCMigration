// page 50016 Sickness
// {
//     PageType = List;
//     SourceTable = Table50006;

//     layout
//     {
//         area(content)
//         {
//             repeater()
//             {
//                 field("Sickness EntryNo";"Sickness EntryNo")
//                 {
//                 }
//                 field("Sickness Name";"Sickness Name")
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
//                 action("Sickness &Type")
//                 {
//                     Caption = 'Sickness &Type';
//                     Promoted = true;
//                     PromotedCategory = Process;
//                     RunObject = Page 50015;
//                     RunPageLink = Category EntryNo=FIELD(Category EntryNo),
//                                   Sickness EntryNo=FIELD(Sickness EntryNo);
//                 }
//             }
//         }
//     }

//     trigger OnInsertRecord(BelowxRec: Boolean): Boolean
//     var
//         rSickness: Record "50006";
//         LineNo: Integer;
//     begin
//         rSickness.RESET;
//         rSickness.SETRANGE(rSickness."Category EntryNo","Category EntryNo");
//         IF rSickness.FINDLAST THEN
//           LineNo :=rSickness."Sickness EntryNo";

//         "Sickness EntryNo" := LineNo + 1;
//     end;
// }

