// page 50017 "Patient Comment Sheet"
// {
//     AutoSplitKey = true;
//     Caption = 'Rlshp. Mgt. Comment Sheet';
//     DataCaptionFields = "No.";
//     DelayedInsert = true;
//     PageType = List;
//     ShowFilter = false;
//     SourceTable = Table5061;
//     SourceTableView = WHERE(Table Name=CONST(Contact),
//                             Sub No.=CONST(0));

//     layout
//     {
//         area(content)
//         {
//             repeater()
//             {
//                 field(Date;Date)
//                 {
//                 }
//                 field(Comment;Comment)
//                 {
//                 }
//                 field(Code;Code)
//                 {
//                     Visible = false;
//                 }
//             }
//         }
//     }

//     actions
//     {
//     }

//     trigger OnNewRecord(BelowxRec: Boolean)
//     begin
//         SetUpNewLine;
//     end;

//     var
//         ContactNo: Code[20];

//     procedure setcontactcomment(pContactNo: Code[20])
//     begin

//         SETRANGE("No.", pContactNo);
//         CurrPage.UPDATE;
//     end;
// }

