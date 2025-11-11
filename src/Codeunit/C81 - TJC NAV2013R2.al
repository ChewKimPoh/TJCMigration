// DP.NCM TJC 606 change from 3 to 1
// force post ship only

// codeunit 81 "Sales-Post (Yes/No)"
// {
//     TableNo = 36;

//     trigger OnRun()
//     begin
//         SalesHeader.COPY(Rec);
//         Code;
//         Rec := SalesHeader;
//     end;

//     var
//         Text000: Label '&Ship,&Invoice,Ship &and Invoice';
//         Text001: Label 'Do you want to post the %1?';
//         Text002: Label '&Receive,&Invoice,Receive &and Invoice';
//         SalesHeader: Record "36";
//         Selection: Integer;

//     local procedure "Code"()
//     var
//         SalesSetup: Record "311";
//         SalesPostViaJobQueue: Codeunit "88";
//     begin
//         SalesSetup.GET;
//         WITH SalesHeader DO BEGIN
//           CASE "Document Type" OF
//             "Document Type"::Order:
//               BEGIN
//                 Selection := STRMENU(Text000,1); //DP.NCM TJC 606 change from 3 to 1
//                 IF Selection = 0 THEN
//                   EXIT;
//                 Ship := Selection IN [1,3];
//                 Invoice := Selection IN [2,3];
//               END;
//             "Document Type"::"Return Order":
//               BEGIN
//                 Selection := STRMENU(Text002,3);
//                 IF Selection = 0 THEN
//                   EXIT;
//                 Receive := Selection IN [1,3];
//                 Invoice := Selection IN [2,3];
//               END
//             ELSE
//               IF NOT
//                  CONFIRM(
//                    Text001,FALSE,
//                    "Document Type")
//               THEN
//                 EXIT;
//           END;
//           "Print Posted Documents" := FALSE;

//           IF SalesSetup."Post with Job Queue" THEN
//             SalesPostViaJobQueue.EnqueueSalesDoc(SalesHeader)
//           ELSE
//             CODEUNIT.RUN(CODEUNIT::"Sales-Post",SalesHeader);
//         END;
//     end;
// }

