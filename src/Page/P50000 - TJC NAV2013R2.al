// page 50000 RTCcontrol
// {
//     PageType = CardPart;

//     layout
//     {
//         area(content)
//         {
//             usercontrol("<Control3>";"NavTimer.TimerControl")
//             {
//             }
//         }
//     }

//     actions
//     {
//     }

//     trigger OnOpenPage()
//     begin
//         MyTimer := '10';

//         IF ISCLEAR(MySendKeys) THEN
//           CREATE(MySendKeys, FALSE, TRUE);
//     end;

//     var
//         "Count": Integer;
//         MyTimer: Text[10];
//         MySendKeys: Automation ;
// }

