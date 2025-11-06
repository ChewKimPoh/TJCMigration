// report 50000 TJC300Datafix
// {
//     Permissions = TableData 32=rimd,
//                   TableData 7312=rimd;
//     ProcessingOnly = true;

//     dataset
//     {
//     }

//     requestpage
//     {

//         layout
//         {
//         }

//         actions
//         {
//         }
//     }

//     labels
//     {
//     }

//     trigger OnPostReport()
//     begin
//         rILE.RESET;
//         rILE.SETCURRENTKEY("Item No.","Lot No.","Posting Date");
//         rILE.SETRANGE("Item No.",'SGTTMQ1');
//         rILE.SETRANGE("Lot No.",'1210141');
//         rILE.SETRANGE(Open,TRUE);
//         IF rILE.FINDFIRST THEN
//           REPEAT
//             rILE."Unit of Measure Code" := 'KG';
//             rILE.MODIFY;
//           UNTIL rILE.NEXT = 0;
//         rWE.RESET;
//         rWE.SETCURRENTKEY("Item No.","Location Code","Variant Code","Bin Type Code","Unit of Measure Code","Lot No.","Serial No.");
//         rWE.SETRANGE("Item No.",'SGTTMQ1');
//         rWE.SETRANGE("Lot No.",'1210141');
//         rWE.SETRANGE("Unit of Measure Code",'BOT');
//         IF rWE.FINDFIRST THEN
//           REPEAT
//             rWE."Unit of Measure Code" := 'KG';
//             rWE.MODIFY;
//           UNTIL rWE.NEXT = 0;
//         MESSAGE('Data fix Completed');
//     end;

//     var
//         rILE: Record "32";
//         rWE: Record "7312";
// }

