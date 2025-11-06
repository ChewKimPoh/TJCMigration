// page 50082 "Check Up Part"
// {
//     // Version No.         : TJCSG1.00
//     // Developer           : DP.AYD
//     // Init. DEV. Date     : 27/6/2014
//     // Date of last Change : 27/6/2014
//     // Description         : Based on DD#166

//     Editable = false;
//     PageType = CardPart;
//     SourceTable = Table50003;

//     layout
//     {
//         area(content)
//         {
//             field("History No.";"History No.")
//             {

//                 trigger OnDrillDown()
//                 begin
//                     PAGE.RUNMODAL(50083,Rec);
//                 end;
//             }
//             field(Tongue1;Tongue1)
//             {
//             }
//             field(Tongue2;Tongue2)
//             {
//             }
//             field("Left Pulse";"Left Pulse")
//             {
//             }
//             field("Right Pulse";"Right Pulse")
//             {
//             }
//             field("Low Blood Pressure";"Low Blood Pressure")
//             {
//             }
//             field("High Blood Pressure";"High Blood Pressure")
//             {
//             }
//         }
//     }

//     actions
//     {
//     }
// }

