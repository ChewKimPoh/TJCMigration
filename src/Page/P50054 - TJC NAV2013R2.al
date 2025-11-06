// page 50054 "PO Line Export"
// {
//     Editable = false;
//     PageType = List;
//     SourceTable = Table50015;

//     layout
//     {
//         area(content)
//         {
//             repeater(Group)
//             {
//                 field("Entry No.";"Entry No.")
//                 {
//                 }
//                 field("Document No.";"Document No.")
//                 {
//                 }
//                 field("Sell-to Customer No.";"Sell-to Customer No.")
//                 {
//                 }
//                 field("Sell-to Customer Name";"Sell-to Customer Name")
//                 {
//                 }
//                 field("External Document No.";"External Document No.")
//                 {
//                 }
//                 field("Document Line No.";"Document Line No.")
//                 {
//                 }
//                 field("Item No.";"Item No.")
//                 {
//                 }
//                 field(Description;Description)
//                 {
//                 }
//                 field("Lot No.";"Lot No.")
//                 {
//                 }
//                 field("Expiry date";"Expiry date")
//                 {
//                 }
//                 field(Quantity;Quantity)
//                 {
//                 }
//                 field("Packing unit price";"Packing unit price")
//                 {
//                 }
//                 field("Discount %";"Discount %")
//                 {
//                 }
//             }
//         }
//     }

//     actions
//     {
//         area(creation)
//         {
//             action("Generate List")
//             {
//                 Caption = 'Generate List';
//                 Image = GetLines;
//                 Promoted = true;
//                 PromotedIsBig = true;
//                 Visible = false;

//                 trigger OnAction()
//                 begin
//                     GenerateList;
//                     MESSAGE('Done');
//                 end;
//             }
//         }
//     }

//     var
//         SINo: Code[20];
//         rRE: Record "337";

//     procedure SetSINo(pSINo: Code[20])
//     begin
//         SINo := pSINo;
//     end;

//     procedure GenerateList()
//     var
//         lrExport: Record "50015";
//         lrSalesLine: Record "37";
//         LineNo: Integer;
//         lrSalesHeader: Record "36";
//         lrTempRE: Record "337" temporary;
//     begin
//         //SONo
//         lrExport.RESET;
//         lrExport.DELETEALL;
//         lrSalesHeader.RESET;
//         lrSalesHeader.GET(lrSalesHeader."Document Type"::Invoice,SINo);
//         lrSalesLine.RESET;
//         lrSalesLine.SETRANGE("Document Type",lrSalesLine."Document Type"::Invoice);
//         lrSalesLine.SETRANGE("Document No.",SINo);
//         lrSalesLine.SETFILTER(Quantity,'<>%1',0);
//         IF lrSalesLine.FINDFIRST THEN REPEAT
//           lrTempRE.RESET;lrTempRE.DELETEALL;
//           rRE.RESET;
//           rRE.SETRANGE("Source Type",37);
//           rRE.SETRANGE("Source Subtype",2);
//           rRE.SETRANGE("Source ID",SINo);
//           rRE.SETRANGE("Source Ref. No.",lrSalesLine."Line No.");
//           IF rRE.FINDFIRST THEN BEGIN
//             REPEAT
//               lrTempRE.RESET;
//               IF lrTempRE.FINDFIRST THEN BEGIN
//                 IF rRE."Expiration Date" < lrTempRE."Expiration Date" THEN BEGIN
//                   lrTempRE.DELETE;
//                   CLEAR(lrTempRE);
//                   lrTempRE := rRE;
//                   lrTempRE.INSERT;
//                 END;
//               END ELSE BEGIN
//                 lrTempRE := rRE;
//                 lrTempRE.INSERT;
//               END;
//             UNTIL rRE.NEXT = 0;
//             lrTempRE.RESET;
//             IF lrTempRE.FINDFIRST THEN;
//             LineNo += 1;
//             lrExport.INIT;
//             lrExport."Entry No." := LineNo;
//             lrExport."Document No." := lrSalesLine."Document No.";
//             lrExport."Document Line No." := lrSalesLine."Line No.";
//             lrExport."Sell-to Customer No." := lrSalesLine."Sell-to Customer No.";
//             lrExport."Sell-to Customer Name" := lrSalesHeader."Sell-to Customer Name";
//             lrExport."External Document No." := lrSalesHeader."External Document No.";
//             lrExport."Item No." := lrSalesLine."No.";
//             lrExport."Lot No." := lrTempRE."Lot No.";
//             lrExport."Expiry date" := lrTempRE."Expiration Date";
//             lrExport.Quantity := -lrTempRE.Quantity;
//             lrExport."Packing unit price" := lrSalesLine."Unit Price";
//             lrExport."Discount %" := lrSalesLine."Line Discount %";
//             lrExport.Description := lrSalesLine.Description;
//             lrExport.INSERT;
//           END ELSE BEGIN
//             LineNo += 1;
//             CLEAR(lrExport);
//             lrExport.INIT;
//             lrExport."Entry No." := LineNo;
//             lrExport."Document No." := lrSalesLine."Document No.";
//             lrExport."Document Line No." := lrSalesLine."Line No.";
//             lrExport."Sell-to Customer No." := lrSalesLine."Sell-to Customer No.";
//             lrExport."Sell-to Customer Name" := lrSalesHeader."Sell-to Customer Name";
//             lrExport."External Document No." := lrSalesHeader."External Document No.";
//             lrExport."Item No." := lrSalesLine."No.";
//             lrExport.Quantity := lrSalesLine.Quantity;
//             lrExport."Packing unit price" := lrSalesLine."Unit Price";
//             lrExport."Discount %" := lrSalesLine."Line Discount %";
//             lrExport.Description := lrSalesLine.Description;
//             lrExport.INSERT;
//           END;
//         UNTIL lrSalesLine.NEXT = 0;
//     end;
// }

