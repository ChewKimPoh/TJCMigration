// page 50086 "Patient Comment List"
// {
//     // Version No.         : TJCSG1.00
//     // Developer           : DP.AYD
//     // Init. DEV. Date     : 27/6/2014
//     // Date of last Change : 27/6/2014
//     // Description         : Based on DD#166

//     AutoSplitKey = true;
//     MultipleNewLines = true;
//     PageType = List;
//     ShowFilter = false;
//     SourceTable = Table5061;
//     SourceTableView = SORTING(Table Name,No.,Sub No.,Line No.)
//                       ORDER(Ascending)
//                       WHERE(Table Name=CONST(Contact),
//                             Sub No.=CONST(0));

//     layout
//     {
//         area(content)
//         {
//             repeater(Group)
//             {
//                 field(Date;Date)
//                 {

//                     trigger OnDrillDown()
//                     begin
//                         PAGE.RUNMODAL(5086,Rec);
//                     end;
//                 }
//                 field(Code;Code)
//                 {
//                     Visible = false;
//                 }
//                 field(Comment;Comment)
//                 {
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
// }

