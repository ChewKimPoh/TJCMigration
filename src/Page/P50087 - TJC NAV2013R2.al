// page 50087 "Patient Info Card Part"
// {
//     // Version No.         : TJCSG1.00
//     // Developer           : DP.AYD
//     // Init. DEV. Date     : 27/6/2014
//     // Date of last Change : 27/6/2014
//     // Description         : Based on DD#166

//     PageType = CardPart;
//     SourceTable = Table5050;

//     layout
//     {
//         area(content)
//         {
//             field("No.";"No.")
//             {

//                 trigger OnDrillDown()
//                 begin
//                     PAGE.RUNMODAL(50080,Rec);
//                 end;
//             }
//             field("Chinese Name";"Chinese Name")
//             {

//                 trigger OnDrillDown()
//                 begin
//                     PAGE.RUNMODAL(50080,Rec);
//                 end;
//             }
//             field(Name;Name)
//             {

//                 trigger OnDrillDown()
//                 begin
//                     PAGE.RUNMODAL(50080,Rec);
//                 end;
//             }
//             field("NRIC No.";"NRIC No.")
//             {

//                 trigger OnDrillDown()
//                 begin
//                     PAGE.RUNMODAL(50080,Rec);
//                 end;
//             }
//             field(Age;Age)
//             {

//                 trigger OnDrillDown()
//                 begin
//                     PAGE.RUNMODAL(50080,Rec);
//                 end;
//             }
//         }
//     }

//     actions
//     {
//     }
// }

