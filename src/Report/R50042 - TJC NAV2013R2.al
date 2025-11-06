// report 50042 "TJC 429 patch"
// {
//     ProcessingOnly = true;

//     dataset
//     {
//     }

//     requestpage
//     {

//         layout
//         {
//             area(content)
//             {
//                 group(Options)
//                 {
//                     field("Test Run";TestRun)
//                     {
//                     }
//                 }
//             }
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
//         rILE.GET(3575021);
//         IF rILE."Item No." = 'SGCLZB1' THEN BEGIN
//           //rILE.Quantity := -3;
//           rILE."Unit of Measure Code" := 'BOT';
//           rILE."Qty. per Unit of Measure" := 1;
//           //rILE."Shipped Qty. Not Returned" := -3;
//           IF TestRun = TRUE THEN
//             rILE.MODIFY(FALSE)
//           ELSE
//             rILE.MODIFY(TRUE);
//         END;

//         rVE.RESET;
//         rVE.GET(7841698);
//         IF rVE."Item No." = 'SGCLZB1' THEN BEGIN
//           //rVE."Valued Quantity" := -3;  //DP.NCM 02102017
//           //rVE."Item Ledger Entry Quantity" := -3; //DP.NCM 02102017
//           IF TestRun = TRUE THEN
//             rVE.MODIFY(FALSE)
//           ELSE
//             rVE.MODIFY(TRUE);
//         END;

//         rVE.RESET;
//         rVE.GET(7841700);
//         IF rVE."Item No." = 'SGCLZB1' THEN BEGIN
//           //rVE."Valued Quantity" := -3; //DP.NCM 02102017
//           IF TestRun = TRUE THEN
//             rVE.MODIFY(FALSE)
//           ELSE
//             rVE.MODIFY(TRUE);
//         END;

//         rSL.RESET;
//         rSL.GET(rSL."Document Type"::Order,'OR17/10721',20000);
//         IF rSL."No." = 'SGCLZB1' THEN BEGIN
//           //rSL."Unit of Measure" := 'SET of 3';
//           rSL."Unit of Measure Code" := 'BOT';
//           rSL."Qty. per Unit of Measure" := 1;
//           //rSL."Quantity (Base)" := 3;
//           //rSL."Qty. to Invoice (Base)" := 3;
//           //rSL."Qty. Shipped Not Invd. (Base)" := 3;
//           //rSL."Qty. Shipped (Base)" := 3;
//           IF TestRun = TRUE THEN
//             rSL.MODIFY(FALSE)
//           ELSE
//             rSL.MODIFY(TRUE);
//         END;

//         rSSL.RESET;
//         rSSL.GET('DO17/16199',20000);
//         IF rSSL."No." = 'SGCLZB1' THEN BEGIN
//           //rSSL."Quantity (Base)" := 3;
//           rSSL."Unit of Measure Code" := 'BOT';
//           rSSL."Qty. per Unit of Measure" := 1;
//           IF TestRun = TRUE THEN
//             rSSL.MODIFY(FALSE)
//           ELSE
//             rSSL.MODIFY(TRUE);
//         END;


//         rTS.RESET;
//         rTS.GET(3575021);
//         IF rTS."Item No." = 'SGCLZB1' THEN BEGIN
//           //rTS."Quantity (Base)" := -3;
//           rTS."Qty. to Handle (Base)" := 0;
//           rTS."Qty. to Invoice" := -1;
//           //rTS."Quantity Handled (Base)" := -3;
//           rTS."Qty. per Unit of Measure" := 1; //DP.NCM 02102017
//           rTS."Qty. to Handle" := 0;
//           rTS."Qty. to Invoice (Base)" := -1;//DP.NCM 02102017
//           //rTS."Buffer Value1" := -3;
//           IF TestRun = TRUE THEN
//             rTS.MODIFY(FALSE)
//           ELSE
//             rTS.MODIFY(TRUE);
//         END;

//         MESSAGE('Done');


//     end;

//     trigger OnPreReport()
//     begin
//         TestRun := TRUE;
//     end;

//     var
//         rILE: Record "32";
//         rVE: Record "5802";
//         rSL: Record "37";
//         rSSL: Record "111";
//         rTS: Record "336";
//         TestRun: Boolean;
// }

