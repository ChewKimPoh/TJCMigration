// codeunit 90 "Purch.-Post"
// {
//     // DP.NCM TJC #449 04/04/2018 - Bring description line over to g/l entries
//     // DP.NCM TJC #461 20/06/2018 - Add condition to bring only if description is not blank

//     Permissions = TableData 36=m,
//                   TableData 37=m,
//                   TableData 39=imd,
//                   TableData 49=imd,
//                   TableData 93=imd,
//                   TableData 94=imd,
//                   TableData 110=imd,
//                   TableData 111=imd,
//                   TableData 120=imd,
//                   TableData 121=imd,
//                   TableData 122=imd,
//                   TableData 123=imd,
//                   TableData 124=imd,
//                   TableData 125=imd,
//                   TableData 223=imd,
//                   TableData 357=imd,
//                   TableData 359=imd,
//                   TableData 6507=ri,
//                   TableData 6508=rid,
//                   TableData 6650=imd,
//                   TableData 6651=imd;
//     TableNo = 38;

//     trigger OnRun()
//     var
//         ItemEntryRelation: Record "6507";
//         TempInvoicingSpecification: Record "336" temporary;
//         DummyTrackingSpecification: Record "336";
//         Vendor: Record "23";
//         ICHandledInboxTransaction: Record "420";
//         ICPartner: Record "413";
//         SalesSetup: Record "311";
//         SalesCommentLine: Record "44";
//         PurchInvHdr: Record "122";
//         PurchHeader2: Record "38";
//         ICInboxPurchHdr: Record "436";
//         SalesHeader: Record "36";
//         UpdateAnalysisView: Codeunit "410";
//         UpdateItemAnalysisView: Codeunit "7150";
//         CostBaseAmount: Decimal;
//         TrackingSpecificationExists: Boolean;
//         EndLoop: Boolean;
//         GLEntryNo: Integer;
//         BiggestLineNo: Integer;
//         PrevStatus: Option;
//     begin
//         IF PostingDateExists AND (ReplacePostingDate OR ("Posting Date" = 0D)) THEN BEGIN
//           "Posting Date" := PostingDate;
//           VALIDATE("Currency Code");
//         END;

//         IF PostingDateExists AND (ReplaceDocumentDate OR ("Document Date" = 0D)) THEN
//           VALIDATE("Document Date",PostingDate);

//         CLEARALL;
//         PurchHeader.COPY(Rec);
//         WITH PurchHeader DO BEGIN
//           TESTFIELD("Document Type");
//           TESTFIELD("Buy-from Vendor No.");
//           TESTFIELD("Pay-to Vendor No.");
//           TESTFIELD("Posting Date");
//           TESTFIELD("Document Date");
//           IF GenJnlCheckLine.DateNotAllowed("Posting Date") THEN
//             FIELDERROR("Posting Date",Text045);

//           CASE "Document Type" OF
//             "Document Type"::Order:
//               Ship := FALSE;
//             "Document Type"::Invoice:
//               BEGIN
//                 Receive := TRUE;
//                 Invoice := TRUE;
//                 Ship := FALSE;
//               END;
//             "Document Type"::"Return Order":
//               Receive := FALSE;
//             "Document Type"::"Credit Memo":
//               BEGIN
//                 Receive := FALSE;
//                 Invoice := TRUE;
//                 Ship := TRUE;
//               END;
//           END;

//           IF NOT (Receive OR Invoice OR Ship) THEN
//             ERROR(
//               Text025,
//               FIELDCAPTION(Receive),FIELDCAPTION(Invoice),FIELDCAPTION(Ship));

//           WhseReference := "Posting from Whse. Ref.";
//           "Posting from Whse. Ref." := 0;

//           IF Invoice THEN
//             CreatePrepmtLines(PurchHeader,TempPrepmtPurchLine,TRUE);

//           CheckDim;

//           CopyAprvlToTempApprvl;

//           Vend.GET("Buy-from Vendor No.");
//           Vend.CheckBlockedVendOnDocs(Vend,TRUE);
//           IF "Pay-to Vendor No." <> "Buy-from Vendor No." THEN BEGIN
//             Vend.GET("Pay-to Vendor No.");
//             Vend.CheckBlockedVendOnDocs(Vend,TRUE);
//           END;

//           IF "Send IC Document" AND ("IC Direction" = "IC Direction"::Outgoing) AND
//              ("Document Type" IN ["Document Type"::Order,"Document Type"::"Return Order"])
//           THEN
//             IF NOT CONFIRM(Text058) THEN
//               ERROR('');

//           IF Invoice AND ("IC Direction" = "IC Direction"::Incoming) THEN BEGIN
//             IF "Document Type" = "Document Type"::Order THEN BEGIN
//               PurchHeader2.SETRANGE("Document Type","Document Type"::Invoice);
//               PurchHeader2.SETRANGE("Vendor Order No.","Vendor Order No.");
//               IF PurchHeader2.FINDFIRST THEN
//                 IF NOT CONFIRM(Text052,TRUE,"No.",PurchHeader2."No.") THEN
//                   ERROR('');
//               ICInboxPurchHdr.SETRANGE("Document Type","Document Type"::Invoice);
//               ICInboxPurchHdr.SETRANGE("Vendor Order No.","Vendor Order No.");
//               IF ICInboxPurchHdr.FINDFIRST THEN
//                 IF NOT CONFIRM(Text053,TRUE,"No.",ICInboxPurchHdr."No.") THEN
//                   ERROR('');
//               PurchInvHdr.SETRANGE("Vendor Order No.","Vendor Order No.");
//               IF PurchInvHdr.FINDFIRST THEN
//                 IF NOT CONFIRM(Text054,FALSE,PurchInvHdr."No.","No.") THEN
//                   ERROR('');
//             END;
//             IF ("Document Type" = "Document Type"::Invoice) AND ("Vendor Order No." <> '') THEN BEGIN
//               PurchHeader2.SETRANGE("Document Type","Document Type"::Order);
//               PurchHeader2.SETRANGE("Vendor Order No.","Vendor Order No.");
//               IF PurchHeader2.FINDFIRST THEN
//                 IF NOT CONFIRM(Text055,TRUE,PurchHeader2."No.","No.") THEN
//                   ERROR('');
//               ICInboxPurchHdr.SETRANGE("Document Type","Document Type"::Order);
//               ICInboxPurchHdr.SETRANGE("Vendor Order No.","Vendor Order No.");
//               IF ICInboxPurchHdr.FINDFIRST THEN
//                 IF NOT CONFIRM(Text056,TRUE,"No.",ICInboxPurchHdr."No.") THEN
//                   ERROR('');
//               PurchInvHdr.SETRANGE("Vendor Order No.","Vendor Order No.");
//               IF PurchInvHdr.FINDFIRST THEN
//                 IF NOT CONFIRM(Text057,FALSE,PurchInvHdr."No.","No.") THEN
//                   ERROR('');
//             END;
//           END;

//           IF Invoice THEN BEGIN
//             PurchLine.RESET;
//             PurchLine.SETRANGE("Document Type","Document Type");
//             PurchLine.SETRANGE("Document No.","No.");
//             PurchLine.SETFILTER(Quantity,'<>0');
//             IF "Document Type" IN ["Document Type"::Order,"Document Type"::"Return Order"] THEN
//               PurchLine.SETFILTER("Qty. to Invoice",'<>0');
//             Invoice := NOT PurchLine.ISEMPTY;
//             IF Invoice AND (NOT Receive) AND
//                ("Document Type" = "Document Type"::Order)
//             THEN BEGIN
//               Invoice := FALSE;
//               PurchLine.FINDSET;
//               REPEAT
//                 Invoice := (PurchLine."Quantity Received" - PurchLine."Quantity Invoiced") <> 0;
//               UNTIL Invoice OR (PurchLine.NEXT = 0);
//             END ELSE
//               IF Invoice AND (NOT Ship) AND
//                  ("Document Type" = "Document Type"::"Return Order")
//               THEN BEGIN
//                 Invoice := FALSE;
//                 PurchLine.FINDSET;
//                 REPEAT
//                   Invoice := (PurchLine."Return Qty. Shipped" - PurchLine."Quantity Invoiced") <> 0;
//                 UNTIL Invoice OR (PurchLine.NEXT = 0);
//               END;
//           END;

//           IF Invoice THEN
//             CopyAndCheckItemCharge(PurchHeader);

//           IF Invoice AND NOT ("Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"]) THEN
//             TESTFIELD("Due Date");

//           IF Receive THEN BEGIN
//             PurchLine.RESET;
//             PurchLine.SETRANGE("Document Type","Document Type");
//             PurchLine.SETRANGE("Document No.","No.");
//             PurchLine.SETFILTER(Quantity,'<>0');
//             IF "Document Type" = "Document Type"::Order THEN
//               PurchLine.SETFILTER("Qty. to Receive",'<>0');
//             PurchLine.SETRANGE("Receipt No.",'');
//             Receive := PurchLine.FINDFIRST;
//             WhseReceive := TempWhseRcptHeader.FINDFIRST;
//             WhseShip := TempWhseShptHeader.FINDFIRST;
//             InvtPickPutaway := WhseReference <> 0;
//             IF Receive THEN
//               CheckTrackingSpecification(PurchLine);
//             IF Receive AND NOT (WhseReceive OR WhseShip OR InvtPickPutaway) THEN
//               CheckWarehouse(PurchLine);
//           END;

//           IF Ship THEN BEGIN
//             PurchLine.RESET;
//             PurchLine.SETRANGE("Document Type","Document Type");
//             PurchLine.SETRANGE("Document No.","No.");
//             PurchLine.SETFILTER(Quantity,'<>0');
//             PurchLine.SETFILTER("Return Qty. to Ship",'<>0');
//             PurchLine.SETRANGE("Return Shipment No.",'');
//             Ship := PurchLine.FINDFIRST;
//             WhseReceive := TempWhseRcptHeader.FINDFIRST;
//             WhseShip := TempWhseShptHeader.FINDFIRST;
//             InvtPickPutaway := WhseReference <> 0;
//             IF Ship THEN
//               CheckTrackingSpecification(PurchLine);
//             IF Ship AND NOT (WhseShip OR WhseReceive OR InvtPickPutaway) THEN
//               CheckWarehouse(PurchLine);
//           END;

//           IF NOT (Receive OR Invoice OR Ship) THEN
//             IF NOT OnlyAssgntPosting THEN
//               ERROR(Text001);

//           IF Invoice THEN BEGIN
//             PurchLine.RESET;
//             PurchLine.SETRANGE("Document Type","Document Type");
//             PurchLine.SETRANGE("Document No.","No.");
//             PurchLine.SETFILTER("Sales Order Line No.",'<>0');
//             IF PurchLine.FINDSET THEN
//               REPEAT
//                 SalesOrderLine.GET(
//                   SalesOrderLine."Document Type"::Order,
//                   PurchLine."Sales Order No.",PurchLine."Sales Order Line No.");
//                 IF Receive AND
//                    Invoice AND
//                    (PurchLine."Qty. to Invoice" <> 0) AND
//                    (PurchLine."Qty. to Receive" <> 0)
//                 THEN
//                   ERROR(Text002);
//                 IF ABS(PurchLine."Quantity Received" - PurchLine."Quantity Invoiced") <
//                    ABS(PurchLine."Qty. to Invoice")
//                 THEN BEGIN
//                   PurchLine."Qty. to Invoice" := PurchLine."Quantity Received" - PurchLine."Quantity Invoiced";
//                   PurchLine."Qty. to Invoice (Base)" := PurchLine."Qty. Received (Base)" - PurchLine."Qty. Invoiced (Base)";
//                 END;
//                 IF ABS(PurchLine.Quantity - (PurchLine."Qty. to Invoice" + PurchLine."Quantity Invoiced")) <
//                    ABS(SalesOrderLine.Quantity - SalesOrderLine."Quantity Invoiced")
//                 THEN
//                   ERROR(
//                     Text003 +
//                     Text004,
//                     PurchLine."Sales Order No.");
//               UNTIL PurchLine.NEXT = 0;
//           END;

//           InitProgressWindow(PurchHeader);

//           GetGLSetup;
//           PurchSetup.GET;
//           GetCurrency;

//           IF Invoice AND PurchSetup."Ext. Doc. No. Mandatory" THEN
//             IF "Document Type" IN ["Document Type"::Order,"Document Type"::Invoice] THEN
//               TESTFIELD("Vendor Invoice No.")
//             ELSE
//               TESTFIELD("Vendor Cr. Memo No.");

//           IF Receive AND ("Receiving No." = '') THEN
//             IF ("Document Type" = "Document Type"::Order) OR
//                (("Document Type" = "Document Type"::Invoice) AND PurchSetup."Receipt on Invoice")
//             THEN BEGIN
//               TESTFIELD("Receiving No. Series");
//               "Receiving No." := NoSeriesMgt.GetNextNo("Receiving No. Series","Posting Date",TRUE);
//               ModifyHeader := TRUE;
//             END;

//           IF Ship AND ("Return Shipment No." = '') THEN
//             IF ("Document Type" = "Document Type"::"Return Order") OR
//                (("Document Type" = "Document Type"::"Credit Memo") AND PurchSetup."Return Shipment on Credit Memo")
//             THEN BEGIN
//               TESTFIELD("Return Shipment No. Series");
//               "Return Shipment No." := NoSeriesMgt.GetNextNo("Return Shipment No. Series","Posting Date",TRUE);
//               ModifyHeader := TRUE;
//             END;

//           IF Invoice AND ("Posting No." = '') THEN BEGIN
//             IF ("No. Series" <> '') OR
//                ("Document Type" IN ["Document Type"::Order,"Document Type"::"Return Order"])
//             THEN
//               TESTFIELD("Posting No. Series");
//             IF ("No. Series" <> "Posting No. Series") OR
//                ("Document Type" IN ["Document Type"::Order,"Document Type"::"Return Order"])
//             THEN BEGIN
//               "Posting No." := NoSeriesMgt.GetNextNo("Posting No. Series","Posting Date",TRUE);
//               ModifyHeader := TRUE;
//             END;
//           END;

//           IF NOT ItemChargeAssgntOnly THEN BEGIN
//             PurchLine.RESET;
//             PurchLine.SETRANGE("Document Type","Document Type");
//             PurchLine.SETRANGE("Document No.","No.");
//             PurchLine.SETFILTER("Sales Order Line No.",'<>0');
//             IF PurchLine.FINDSET THEN BEGIN
//               DropShipOrder := TRUE;
//               IF Receive THEN
//                 REPEAT
//                   IF SalesOrderHeader."No." <> PurchLine."Sales Order No." THEN BEGIN
//                     SalesOrderHeader.GET(
//                       SalesOrderHeader."Document Type"::Order,
//                       PurchLine."Sales Order No.");
//                     SalesOrderHeader.TESTFIELD("Bill-to Customer No.");
//                     SalesOrderHeader.Ship := TRUE;
//                     CODEUNIT.RUN(CODEUNIT::"Release Sales Document",SalesOrderHeader);
//                     IF SalesOrderHeader."Shipping No." = '' THEN BEGIN
//                       SalesOrderHeader.TESTFIELD("Shipping No. Series");
//                       SalesOrderHeader."Shipping No." :=
//                         NoSeriesMgt.GetNextNo(SalesOrderHeader."Shipping No. Series","Posting Date",TRUE);
//                       SalesOrderHeader.MODIFY;
//                       ModifyHeader := TRUE;
//                     END;
//                   END;
//                 UNTIL PurchLine.NEXT = 0;
//             END;
//           END;
//           IF ModifyHeader THEN BEGIN
//             MODIFY;
//             COMMIT;
//           END;

//           IF PurchSetup."Calc. Inv. Discount" AND
//              (Status <> Status::Open) AND
//              NOT ItemChargeAssgntOnly
//           THEN BEGIN
//             PurchLine.RESET;
//             PurchLine.SETRANGE("Document Type","Document Type");
//             PurchLine.SETRANGE("Document No.","No.");
//             PurchLine.FINDFIRST;
//             TempInvoice := Invoice;
//             TempRcpt := Receive;
//             TempReturn := Ship;
//             PurchCalcDisc.RUN(PurchLine);
//             GET("Document Type","No.");
//             Invoice := TempInvoice;
//             Receive := TempRcpt;
//             Ship := TempReturn;
//             COMMIT;
//           END;

//           IF (Status = Status::Open) OR (Status = Status::"Pending Prepayment") THEN BEGIN
//             TempInvoice := Invoice;
//             TempRcpt := Receive;
//             TempReturn := Ship;
//             PrevStatus := Status;
//             CODEUNIT.RUN(CODEUNIT::"Release Purchase Document",PurchHeader);
//             TESTFIELD(Status,Status::Released);
//             Status := PrevStatus;
//             Invoice := TempInvoice;
//             Receive := TempRcpt;
//             Ship := TempReturn;
//             MODIFY;
//             COMMIT;
//             Status := Status::Released;
//           END;

//           IF Receive OR Ship THEN
//             ArchiveUnpostedOrder; // has a COMMIT;

//           IF ("Buy-from IC Partner Code" <> '') AND ICPartner.GET("Buy-from IC Partner Code") THEN
//             ICPartner.TESTFIELD(Blocked,FALSE);
//           IF ("Pay-to IC Partner Code" <> '') AND ICPartner.GET("Pay-to IC Partner Code") THEN
//             ICPartner.TESTFIELD(Blocked,FALSE);
//           IF "Send IC Document" AND ("IC Status" = "IC Status"::New) AND ("IC Direction" = "IC Direction"::Outgoing) AND
//              ("Document Type" IN ["Document Type"::Order,"Document Type"::"Return Order"])
//           THEN BEGIN
//             ICInOutBoxMgt.SendPurchDoc(Rec,TRUE);
//             "IC Status" := "IC Status"::Pending;
//             ModifyHeader := TRUE;
//           END;
//           IF "IC Direction" = "IC Direction"::Incoming THEN BEGIN
//             CASE "Document Type" OF
//               "Document Type"::Invoice:
//                 ICHandledInboxTransaction.SETRANGE("Document No.","Vendor Invoice No.");
//               "Document Type"::Order:
//                 ICHandledInboxTransaction.SETRANGE("Document No.","Vendor Order No.");
//               "Document Type"::"Credit Memo":
//                 ICHandledInboxTransaction.SETRANGE("Document No.","Vendor Cr. Memo No.");
//               "Document Type"::"Return Order":
//                 ICHandledInboxTransaction.SETRANGE("Document No.","Vendor Order No.");
//             END;
//             Vendor.GET("Buy-from Vendor No.");
//             ICHandledInboxTransaction.SETRANGE("IC Partner Code",Vendor."IC Partner Code");
//             ICHandledInboxTransaction.LOCKTABLE;
//             IF ICHandledInboxTransaction.FINDFIRST THEN BEGIN
//               ICHandledInboxTransaction.Status := ICHandledInboxTransaction.Status::Posted;
//               ICHandledInboxTransaction.MODIFY;
//             END;
//           END;

//           LockTables;

//           SourceCodeSetup.GET;
//           SrcCode := SourceCodeSetup.Purchases;

//           // Insert receipt header
//           IF Receive THEN BEGIN
//             IF ("Document Type" = "Document Type"::Order) OR
//                (("Document Type" = "Document Type"::Invoice) AND PurchSetup."Receipt on Invoice")
//             THEN BEGIN
//               IF DropShipOrder THEN BEGIN
//                 PurchRcptHeader.LOCKTABLE;
//                 PurchRcptLine.LOCKTABLE;
//                 SalesShptHeader.LOCKTABLE;
//                 SalesShptLine.LOCKTABLE;
//               END;
//               PurchRcptHeader.INIT;
//               PurchRcptHeader.TRANSFERFIELDS(PurchHeader);
//               PurchRcptHeader."No." := "Receiving No.";
//               IF "Document Type" = "Document Type"::Order THEN BEGIN
//                 PurchRcptHeader."Order No. Series" := "No. Series";
//                 PurchRcptHeader."Order No." := "No.";
//               END;
//               PurchRcptHeader."No. Printed" := 0;
//               PurchRcptHeader."Source Code" := SrcCode;
//               PurchRcptHeader."User ID" := USERID;
//               PurchRcptHeader.INSERT;

//               ApprovalMgt.MoveApprvalEntryToPosted(TempApprovalEntry,DATABASE::"Purch. Rcpt. Header",PurchRcptHeader."No.");

//               IF PurchSetup."Copy Comments Order to Receipt" THEN BEGIN
//                 CopyCommentLines(
//                   "Document Type",PurchCommentLine."Document Type"::Receipt,
//                   "No.",PurchRcptHeader."No.");
//                 PurchRcptHeader.COPYLINKS(Rec);
//               END;
//               IF WhseReceive THEN BEGIN
//                 WhseRcptHeader.GET(TempWhseRcptHeader."No.");
//                 WhsePostRcpt.CreatePostedRcptHeader(PostedWhseRcptHeader,WhseRcptHeader,"Receiving No.","Posting Date");
//               END;
//               IF WhseShip THEN BEGIN
//                 WhseShptHeader.GET(TempWhseShptHeader."No.");
//                 WhsePostShpt.CreatePostedShptHeader(PostedWhseShptHeader,WhseShptHeader,"Receiving No.","Posting Date");
//               END;
//             END;
//             IF SalesHeader.GET("Document Type",PurchLine."Sales Order No.") THEN
//               ServItemMgt.CopyReservationEntry(SalesHeader);
//           END;
//           // Insert return shipment header
//           IF Ship THEN
//             IF ("Document Type" = "Document Type"::"Return Order") OR
//                (("Document Type" = "Document Type"::"Credit Memo") AND PurchSetup."Return Shipment on Credit Memo")
//             THEN BEGIN
//               ReturnShptHeader.INIT;
//               ReturnShptHeader.TRANSFERFIELDS(PurchHeader);
//               ReturnShptHeader."No." := "Return Shipment No.";
//               IF "Document Type" = "Document Type"::"Return Order" THEN BEGIN
//                 ReturnShptHeader."Return Order No. Series" := "No. Series";
//                 ReturnShptHeader."Return Order No." := "No.";
//               END;
//               ReturnShptHeader."No. Series" := "Return Shipment No. Series";
//               ReturnShptHeader."No. Printed" := 0;
//               ReturnShptHeader."Source Code" := SrcCode;
//               ReturnShptHeader."User ID" := USERID;
//               ReturnShptHeader.INSERT;

//               ApprovalMgt.MoveApprvalEntryToPosted(TempApprovalEntry,DATABASE::"Return Shipment Header",ReturnShptHeader."No.");

//               IF PurchSetup."Copy Cmts Ret.Ord. to Ret.Shpt" THEN BEGIN
//                 CopyCommentLines(
//                   "Document Type",PurchCommentLine."Document Type"::"Posted Return Shipment",
//                   "No.",ReturnShptHeader."No.");
//                 ReturnShptHeader.COPYLINKS(Rec);
//               END;
//               IF WhseShip THEN BEGIN
//                 WhseShptHeader.GET(TempWhseShptHeader."No.");
//                 WhsePostShpt.CreatePostedShptHeader(PostedWhseShptHeader,WhseShptHeader,"Return Shipment No.","Posting Date");
//               END;
//               IF WhseReceive THEN BEGIN
//                 WhseRcptHeader.GET(TempWhseRcptHeader."No.");
//                 WhsePostRcpt.CreatePostedRcptHeader(PostedWhseRcptHeader,WhseRcptHeader,"Return Shipment No.","Posting Date");
//               END;
//             END;

//           // Insert invoice header or credit memo header
//           IF Invoice THEN
//             IF "Document Type" IN ["Document Type"::Order,"Document Type"::Invoice] THEN BEGIN
//               PurchInvHeader.INIT;
//               PurchInvHeader.TRANSFERFIELDS(PurchHeader);
//               IF "Document Type" = "Document Type"::Order THEN BEGIN
//                 PurchInvHeader."Pre-Assigned No. Series" := '';
//                 PurchInvHeader."No." := "Posting No.";
//                 PurchInvHeader."Order No. Series" := "No. Series";
//                 PurchInvHeader."Order No." := "No.";
//                 IF GUIALLOWED THEN
//                   Window.UPDATE(1,STRSUBSTNO(Text010,"Document Type","No.",PurchInvHeader."No."));
//               END ELSE BEGIN
//                 IF "Posting No." <> '' THEN BEGIN
//                   PurchInvHeader."No." := "Posting No.";
//                   IF GUIALLOWED THEN
//                     Window.UPDATE(1,STRSUBSTNO(Text010,"Document Type","No.",PurchInvHeader."No."));
//                 END;
//                 PurchInvHeader."Pre-Assigned No. Series" := "No. Series";
//                 PurchInvHeader."Pre-Assigned No." := "No.";
//               END;
//               PurchInvHdr."Creditor No." := "Creditor No.";
//               PurchInvHdr."Payment Reference" := "Payment Reference";
//               PurchInvHdr."Payment Method Code" := "Payment Method Code";
//               PurchInvHeader."Source Code" := SrcCode;
//               PurchInvHeader."User ID" := USERID;
//               PurchInvHeader."No. Printed" := 0;
//               PurchInvHeader.INSERT;

//               ApprovalMgt.MoveApprvalEntryToPosted(TempApprovalEntry,DATABASE::"Purch. Inv. Header",PurchInvHeader."No.");

//               IF PurchSetup."Copy Comments Order to Invoice" THEN BEGIN
//                 CopyCommentLines(
//                   "Document Type",PurchCommentLine."Document Type"::"Posted Invoice",
//                   "No.",PurchInvHeader."No.");
//                 PurchInvHeader.COPYLINKS(Rec);
//               END;
//               GenJnlLineDocType := GenJnlLine."Document Type"::Invoice;
//               GenJnlLineDocNo := PurchInvHeader."No.";
//               GenJnlLineExtDocNo := "Vendor Invoice No.";
//             END ELSE BEGIN // Credit Memo
//               PurchCrMemoHeader.INIT;
//               PurchCrMemoHeader.TRANSFERFIELDS(PurchHeader);
//               IF "Document Type" = "Document Type"::"Return Order" THEN BEGIN
//                 PurchCrMemoHeader."No." := "Posting No.";
//                 PurchCrMemoHeader."Pre-Assigned No. Series" := '';
//                 PurchCrMemoHeader."Return Order No. Series" := "No. Series";
//                 PurchCrMemoHeader."Return Order No." := "No.";
//                 IF GUIALLOWED THEN
//                   Window.UPDATE(1,STRSUBSTNO(Text011,"Document Type","No.",PurchCrMemoHeader."No."));
//               END ELSE BEGIN
//                 PurchCrMemoHeader."Pre-Assigned No. Series" := "No. Series";
//                 PurchCrMemoHeader."Pre-Assigned No." := "No.";
//                 IF "Posting No." <> '' THEN BEGIN
//                   PurchCrMemoHeader."No." := "Posting No.";
//                   IF GUIALLOWED THEN
//                     Window.UPDATE(1,STRSUBSTNO(Text011,"Document Type","No.",PurchCrMemoHeader."No."));
//                 END;
//               END;
//               PurchCrMemoHeader."Source Code" := SrcCode;
//               PurchCrMemoHeader."User ID" := USERID;
//               PurchCrMemoHeader."No. Printed" := 0;
//               PurchCrMemoHeader.INSERT(TRUE);

//               ApprovalMgt.MoveApprvalEntryToPosted(TempApprovalEntry,DATABASE::"Purch. Cr. Memo Hdr.",PurchCrMemoHeader."No.");

//               IF PurchSetup."Copy Cmts Ret.Ord. to Cr. Memo" THEN BEGIN
//                 CopyCommentLines(
//                   "Document Type",PurchCommentLine."Document Type"::"Posted Credit Memo",
//                   "No.",PurchCrMemoHeader."No.");
//                 PurchCrMemoHeader.COPYLINKS(Rec);
//               END;
//               GenJnlLineDocType := GenJnlLine."Document Type"::"Credit Memo";
//               GenJnlLineDocNo := PurchCrMemoHeader."No.";
//               GenJnlLineExtDocNo := "Vendor Cr. Memo No.";
//             END;

//           UpdateIncomingDocument("Incoming Document Entry No.","Posting Date",GenJnlLineDocNo);

//           // Lines
//           InvPostingBuffer[1].DELETEALL;
//           DropShptPostBuffer.DELETEALL;
//           EverythingInvoiced := TRUE;

//           PurchLine.RESET;
//           PurchLine.SETRANGE("Document Type","Document Type");
//           PurchLine.SETRANGE("Document No.","No.");
//           LineCount := 0;
//           RoundingLineInserted := FALSE;
//           MergePurchLines(PurchHeader,PurchLine,TempPrepmtPurchLine,CombinedPurchLineTemp);
//           AdjustFinalInvWith100PctPrepmt(CombinedPurchLineTemp);

//           TempVATAmountLineRemainder.DELETEALL;
//           PurchLine.CalcVATAmountLines(1,PurchHeader,CombinedPurchLineTemp,TempVATAmountLine);

//           SortLines(PurchLine);
//           PurchaseLinesProcessed := FALSE;
//           IF PurchLine.FINDSET THEN
//             REPEAT
//               IF PurchLine.Type = PurchLine.Type::Item THEN
//                 DummyTrackingSpecification.CheckItemTrackingQuantity(
//                   DATABASE::"Purchase Line",PurchLine."Document Type",PurchLine."Document No.",PurchLine."Line No.",
//                   PurchLine."Qty. to Receive (Base)",PurchLine."Qty. to Invoice (Base)",Receive,Invoice);
//               IF PurchLine."Job No." <> '' THEN
//                 PurchLine.TESTFIELD("Job Task No.");
//               ItemJnlRollRndg := FALSE;
//               LineCount := LineCount + 1;
//               IF GUIALLOWED THEN
//                 Window.UPDATE(2,LineCount);
//               IF PurchLine.Type = PurchLine.Type::"Charge (Item)" THEN BEGIN
//                 PurchLine.TESTFIELD(Amount);
//                 PurchLine.TESTFIELD("Job No.",'');
//               END;

//               IF PurchLine.Type = PurchLine.Type::Item THEN
//                 CostBaseAmount := PurchLine."Line Amount";
//               UpdateQtyPerUnitOfMeasure(PurchLine);
//               IF PurchLine.Type = PurchLine.Type::"Fixed Asset" THEN BEGIN
//                 PurchLine.TESTFIELD("Job No.",'');
//                 PurchLine.TESTFIELD("Depreciation Book Code");
//                 PurchLine.TESTFIELD("FA Posting Type");
//                 FA.GET(PurchLine."No.");
//                 DeprBook.GET(PurchLine."Depreciation Book Code");
//                 FA.TESTFIELD("Budgeted Asset",FALSE);
//                 IF PurchLine."Budgeted FA No." <> '' THEN BEGIN
//                   FA.GET(PurchLine."Budgeted FA No.");
//                   FA.TESTFIELD("Budgeted Asset",TRUE);
//                 END;
//                 IF PurchLine."FA Posting Type" = PurchLine."FA Posting Type"::Maintenance THEN BEGIN
//                   PurchLine.TESTFIELD("Insurance No.",'');
//                   PurchLine.TESTFIELD("Depr. until FA Posting Date",FALSE);
//                   PurchLine.TESTFIELD("Depr. Acquisition Cost",FALSE);
//                   DeprBook.TESTFIELD("G/L Integration - Maintenance",TRUE);
//                 END;
//                 IF PurchLine."FA Posting Type" = PurchLine."FA Posting Type"::"Acquisition Cost" THEN BEGIN
//                   PurchLine.TESTFIELD("Maintenance Code",'');
//                   DeprBook.TESTFIELD("G/L Integration - Acq. Cost",TRUE);
//                 END;
//                 IF PurchLine."Insurance No." <> '' THEN BEGIN
//                   FASetup.GET;
//                   FASetup.TESTFIELD("Insurance Depr. Book",PurchLine."Depreciation Book Code");
//                 END;
//               END ELSE BEGIN
//                 PurchLine.TESTFIELD("Depreciation Book Code",'');
//                 PurchLine.TESTFIELD("FA Posting Type",0);
//                 PurchLine.TESTFIELD("Maintenance Code",'');
//                 PurchLine.TESTFIELD("Insurance No.",'');
//                 PurchLine.TESTFIELD("Depr. until FA Posting Date",FALSE);
//                 PurchLine.TESTFIELD("Depr. Acquisition Cost",FALSE);
//                 PurchLine.TESTFIELD("Budgeted FA No.",'');
//                 PurchLine.TESTFIELD("FA Posting Date",0D);
//                 PurchLine.TESTFIELD("Salvage Value",0);
//                 PurchLine.TESTFIELD("Duplicate in Depreciation Book",'');
//                 PurchLine.TESTFIELD("Use Duplication List",FALSE);
//               END;

//               CASE "Document Type" OF
//                 "Document Type"::Order:
//                   PurchLine.TESTFIELD("Return Qty. to Ship",0);
//                 "Document Type"::Invoice:
//                   BEGIN
//                     IF PurchLine."Receipt No." = '' THEN
//                       PurchLine.TESTFIELD("Qty. to Receive",PurchLine.Quantity);
//                     PurchLine.TESTFIELD("Return Qty. to Ship",0);
//                     PurchLine.TESTFIELD("Qty. to Invoice",PurchLine.Quantity);
//                   END;
//                 "Document Type"::"Return Order":
//                   PurchLine.TESTFIELD("Qty. to Receive",0);
//                 "Document Type"::"Credit Memo":
//                   BEGIN
//                     IF PurchLine."Return Shipment No." = '' THEN
//                       PurchLine.TESTFIELD("Return Qty. to Ship",PurchLine.Quantity);
//                     PurchLine.TESTFIELD("Qty. to Receive",0);
//                     PurchLine.TESTFIELD("Qty. to Invoice",PurchLine.Quantity);
//                   END;
//               END;

//               IF NOT (Receive OR RoundingLineInserted) THEN BEGIN
//                 PurchLine."Qty. to Receive" := 0;
//                 PurchLine."Qty. to Receive (Base)" := 0;
//               END;

//               IF NOT (Ship OR RoundingLineInserted) THEN BEGIN
//                 PurchLine."Return Qty. to Ship" := 0;
//                 PurchLine."Return Qty. to Ship (Base)" := 0;
//               END;

//               IF ("Document Type" = "Document Type"::Invoice) AND (PurchLine."Receipt No." <> '') THEN BEGIN
//                 PurchLine."Quantity Received" := PurchLine.Quantity;
//                 PurchLine."Qty. Received (Base)" := PurchLine."Quantity (Base)";
//                 PurchLine."Qty. to Receive" := 0;
//                 PurchLine."Qty. to Receive (Base)" := 0;
//               END;

//               IF ("Document Type" = "Document Type"::"Credit Memo") AND (PurchLine."Return Shipment No." <> '')
//               THEN BEGIN
//                 PurchLine."Return Qty. Shipped" := PurchLine.Quantity;
//                 PurchLine."Return Qty. Shipped (Base)" := PurchLine."Quantity (Base)";
//                 PurchLine."Return Qty. to Ship" := 0;
//                 PurchLine."Return Qty. to Ship (Base)" := 0;
//               END;

//               IF Invoice THEN BEGIN
//                 IF ABS(PurchLine."Qty. to Invoice") > ABS(PurchLine.MaxQtyToInvoice) THEN
//                   PurchLine.InitQtyToInvoice;
//               END ELSE BEGIN
//                 PurchLine."Qty. to Invoice" := 0;
//                 PurchLine."Qty. to Invoice (Base)" := 0;
//               END;

//               IF PurchLine."Qty. to Invoice" + PurchLine."Quantity Invoiced" <> PurchLine.Quantity THEN
//                 EverythingInvoiced := FALSE;

//               IF PurchLine.Quantity <> 0 THEN BEGIN
//                 PurchLine.TESTFIELD("No.");
//                 PurchLine.TESTFIELD(Type);
//                 PurchLine.TESTFIELD("Gen. Bus. Posting Group");
//                 PurchLine.TESTFIELD("Gen. Prod. Posting Group");
//                 DivideAmount(1,PurchLine."Qty. to Invoice");
//               END ELSE
//                 PurchLine.TESTFIELD(Amount,0);

//               CheckItemReservDisruption;
//               RoundAmount(PurchLine."Qty. to Invoice");

//               IF "Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"] THEN BEGIN
//                 ReverseAmount(PurchLine);
//                 ReverseAmount(PurchLineACY);
//               END;

//               RemQtyToBeInvoiced := PurchLine."Qty. to Invoice";
//               RemQtyToBeInvoicedBase := PurchLine."Qty. to Invoice (Base)";

//               // Job Credit Memo Item Qty Check
//               IF "Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"] THEN
//                 IF (PurchLine."Job No." <> '') AND (PurchLine.Type = PurchLine.Type::Item) AND
//                    (PurchLine."Qty. to Invoice" <> 0)
//                 THEN
//                   JobPostLine.CheckItemQuantityPurchCredit(Rec,PurchLine);

//               // Item Tracking:
//               IF NOT PurchLine."Prepayment Line" THEN BEGIN
//                 IF Invoice THEN
//                   IF PurchLine."Qty. to Invoice" = 0 THEN
//                     TrackingSpecificationExists := FALSE
//                   ELSE
//                     TrackingSpecificationExists :=
//                       ReservePurchLine.RetrieveInvoiceSpecification(PurchLine,TempInvoicingSpecification);
//                 EndLoop := FALSE;

//                 IF "Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"] THEN BEGIN
//                   IF ABS(RemQtyToBeInvoiced) > ABS(PurchLine."Return Qty. to Ship") THEN BEGIN
//                     ReturnShptLine.RESET;
//                     CASE "Document Type" OF
//                       "Document Type"::"Return Order":
//                         BEGIN
//                           ReturnShptLine.SETCURRENTKEY("Return Order No.","Return Order Line No.");
//                           ReturnShptLine.SETRANGE("Return Order No.",PurchLine."Document No.");
//                           ReturnShptLine.SETRANGE("Return Order Line No.",PurchLine."Line No.");
//                         END;
//                       "Document Type"::"Credit Memo":
//                         BEGIN
//                           ReturnShptLine.SETRANGE("Document No.",PurchLine."Return Shipment No.");
//                           ReturnShptLine.SETRANGE("Line No.",PurchLine."Return Shipment Line No.");
//                         END;
//                     END;
//                     ReturnShptLine.SETFILTER("Return Qty. Shipped Not Invd.",'<>0');
//                     IF ReturnShptLine.FINDSET(TRUE,FALSE) THEN BEGIN
//                       ItemJnlRollRndg := TRUE;
//                       REPEAT
//                         IF TrackingSpecificationExists THEN BEGIN  // Item Tracking
//                           ItemEntryRelation.GET(TempInvoicingSpecification."Item Ledger Entry No.");
//                           ReturnShptLine.GET(ItemEntryRelation."Source ID",ItemEntryRelation."Source Ref. No.");
//                         END ELSE
//                           ItemEntryRelation."Item Entry No." := ReturnShptLine."Item Shpt. Entry No.";
//                         ReturnShptLine.TESTFIELD("Buy-from Vendor No.",PurchLine."Buy-from Vendor No.");
//                         ReturnShptLine.TESTFIELD(Type,PurchLine.Type);
//                         ReturnShptLine.TESTFIELD("No.",PurchLine."No.");
//                         ReturnShptLine.TESTFIELD("Gen. Bus. Posting Group",PurchLine."Gen. Bus. Posting Group");
//                         ReturnShptLine.TESTFIELD("Gen. Prod. Posting Group",PurchLine."Gen. Prod. Posting Group");
//                         ReturnShptLine.TESTFIELD("Job No.",PurchLine."Job No.");
//                         ReturnShptLine.TESTFIELD("Unit of Measure Code",PurchLine."Unit of Measure Code");
//                         ReturnShptLine.TESTFIELD("Variant Code",PurchLine."Variant Code");
//                         ReturnShptLine.TESTFIELD("Prod. Order No.",PurchLine."Prod. Order No.");
//                         IF PurchLine."Qty. to Invoice" * ReturnShptLine.Quantity > 0 THEN
//                           PurchLine.FIELDERROR("Qty. to Invoice",Text028);
//                         IF TrackingSpecificationExists THEN BEGIN  // Item Tracking
//                           QtyToBeInvoiced := TempInvoicingSpecification."Qty. to Invoice";
//                           QtyToBeInvoicedBase := TempInvoicingSpecification."Qty. to Invoice (Base)";
//                         END ELSE BEGIN
//                           QtyToBeInvoiced := RemQtyToBeInvoiced - PurchLine."Return Qty. to Ship";
//                           QtyToBeInvoicedBase := RemQtyToBeInvoicedBase - PurchLine."Return Qty. to Ship (Base)";
//                         END;
//                         IF ABS(QtyToBeInvoiced) >
//                            ABS(ReturnShptLine.Quantity - ReturnShptLine."Quantity Invoiced")
//                         THEN BEGIN
//                           QtyToBeInvoiced := ReturnShptLine."Quantity Invoiced" - ReturnShptLine.Quantity;
//                           QtyToBeInvoicedBase := ReturnShptLine."Qty. Invoiced (Base)" - ReturnShptLine."Quantity (Base)";
//                         END;

//                         IF TrackingSpecificationExists THEN
//                           ItemTrackingMgt.AdjustQuantityRounding(
//                             RemQtyToBeInvoiced,QtyToBeInvoiced,
//                             RemQtyToBeInvoicedBase,QtyToBeInvoicedBase);

//                         RemQtyToBeInvoiced := RemQtyToBeInvoiced - QtyToBeInvoiced;
//                         RemQtyToBeInvoicedBase := RemQtyToBeInvoicedBase - QtyToBeInvoicedBase;
//                         ReturnShptLine."Quantity Invoiced" :=
//                           ReturnShptLine."Quantity Invoiced" - QtyToBeInvoiced;
//                         ReturnShptLine."Qty. Invoiced (Base)" :=
//                           ReturnShptLine."Qty. Invoiced (Base)" - QtyToBeInvoicedBase;
//                         ReturnShptLine."Return Qty. Shipped Not Invd." :=
//                           ReturnShptLine.Quantity - ReturnShptLine."Quantity Invoiced";
//                         ReturnShptLine.MODIFY;
//                         IF PurchLine.Type = PurchLine.Type::Item THEN
//                           PostItemJnlLine(
//                             PurchLine,
//                             0,0,
//                             QtyToBeInvoiced,QtyToBeInvoicedBase,
//                             ItemEntryRelation."Item Entry No.",'',TempInvoicingSpecification);
//                         IF TrackingSpecificationExists THEN
//                           EndLoop := (TempInvoicingSpecification.NEXT = 0)
//                         ELSE
//                           EndLoop :=
//                             (ReturnShptLine.NEXT = 0) OR (ABS(RemQtyToBeInvoiced) <= ABS(PurchLine."Return Qty. to Ship"));
//                       UNTIL EndLoop;
//                     END ELSE
//                       ERROR(
//                         Text029,
//                         PurchLine."Return Shipment Line No.",PurchLine."Return Shipment No.");
//                   END;

//                   IF ABS(RemQtyToBeInvoiced) > ABS(PurchLine."Return Qty. to Ship") THEN BEGIN
//                     IF "Document Type" = "Document Type"::"Credit Memo" THEN
//                       ERROR(
//                         Text039,
//                         ReturnShptLine."Document No.");
//                     ERROR(Text040);
//                   END;
//                 END ELSE BEGIN
//                   IF ABS(RemQtyToBeInvoiced) > ABS(PurchLine."Qty. to Receive") THEN BEGIN
//                     PurchRcptLine.RESET;
//                     CASE "Document Type" OF
//                       "Document Type"::Order:
//                         BEGIN
//                           PurchRcptLine.SETCURRENTKEY("Order No.","Order Line No.");
//                           PurchRcptLine.SETRANGE("Order No.",PurchLine."Document No.");
//                           PurchRcptLine.SETRANGE("Order Line No.",PurchLine."Line No.");
//                         END;
//                       "Document Type"::Invoice:
//                         BEGIN
//                           PurchRcptLine.SETRANGE("Document No.",PurchLine."Receipt No.");
//                           PurchRcptLine.SETRANGE("Line No.",PurchLine."Receipt Line No.");
//                         END;
//                     END;

//                     PurchRcptLine.SETFILTER("Qty. Rcd. Not Invoiced",'<>0');
//                     IF PurchRcptLine.FINDSET(TRUE,FALSE) THEN BEGIN
//                       ItemJnlRollRndg := TRUE;
//                       REPEAT
//                         IF TrackingSpecificationExists THEN BEGIN
//                           ItemEntryRelation.GET(TempInvoicingSpecification."Item Ledger Entry No.");
//                           PurchRcptLine.GET(ItemEntryRelation."Source ID",ItemEntryRelation."Source Ref. No.");
//                         END ELSE
//                           ItemEntryRelation."Item Entry No." := PurchRcptLine."Item Rcpt. Entry No.";
//                         PurchRcptLine.TESTFIELD("Buy-from Vendor No.",PurchLine."Buy-from Vendor No.");
//                         PurchRcptLine.TESTFIELD(Type,PurchLine.Type);
//                         PurchRcptLine.TESTFIELD("No.",PurchLine."No.");
//                         PurchRcptLine.TESTFIELD("Gen. Bus. Posting Group",PurchLine."Gen. Bus. Posting Group");
//                         PurchRcptLine.TESTFIELD("Gen. Prod. Posting Group",PurchLine."Gen. Prod. Posting Group");
//                         PurchRcptLine.TESTFIELD("Job No.",PurchLine."Job No.");
//                         PurchRcptLine.TESTFIELD("Unit of Measure Code",PurchLine."Unit of Measure Code");
//                         PurchRcptLine.TESTFIELD("Variant Code",PurchLine."Variant Code");
//                         PurchRcptLine.TESTFIELD("Prod. Order No.",PurchLine."Prod. Order No.");
//                         IF PurchLine."Qty. to Invoice" * PurchRcptLine.Quantity < 0 THEN
//                           PurchLine.FIELDERROR("Qty. to Invoice",Text012);
//                         IF TrackingSpecificationExists THEN BEGIN
//                           QtyToBeInvoiced := TempInvoicingSpecification."Qty. to Invoice";
//                           QtyToBeInvoicedBase := TempInvoicingSpecification."Qty. to Invoice (Base)";
//                         END ELSE BEGIN
//                           QtyToBeInvoiced := RemQtyToBeInvoiced - PurchLine."Qty. to Receive";
//                           QtyToBeInvoicedBase := RemQtyToBeInvoicedBase - PurchLine."Qty. to Receive (Base)";
//                         END;
//                         IF ABS(QtyToBeInvoiced) >
//                            ABS(PurchRcptLine.Quantity - PurchRcptLine."Quantity Invoiced")
//                         THEN BEGIN
//                           QtyToBeInvoiced := PurchRcptLine.Quantity - PurchRcptLine."Quantity Invoiced";
//                           QtyToBeInvoicedBase := PurchRcptLine."Quantity (Base)" - PurchRcptLine."Qty. Invoiced (Base)";
//                         END;
//                         IF TrackingSpecificationExists THEN
//                           ItemTrackingMgt.AdjustQuantityRounding(
//                             RemQtyToBeInvoiced,QtyToBeInvoiced,
//                             RemQtyToBeInvoicedBase,QtyToBeInvoicedBase);

//                         RemQtyToBeInvoiced := RemQtyToBeInvoiced - QtyToBeInvoiced;
//                         RemQtyToBeInvoicedBase := RemQtyToBeInvoicedBase - QtyToBeInvoicedBase;
//                         PurchRcptLine."Quantity Invoiced" := PurchRcptLine."Quantity Invoiced" + QtyToBeInvoiced;
//                         PurchRcptLine."Qty. Invoiced (Base)" := PurchRcptLine."Qty. Invoiced (Base)" + QtyToBeInvoicedBase;
//                         PurchRcptLine."Qty. Rcd. Not Invoiced" :=
//                           PurchRcptLine.Quantity - PurchRcptLine."Quantity Invoiced";
//                         PurchRcptLine.MODIFY;
//                         IF PurchLine.Type = PurchLine.Type::Item THEN
//                           PostItemJnlLine(
//                             PurchLine,
//                             0,0,
//                             QtyToBeInvoiced,QtyToBeInvoicedBase,
//                             ItemEntryRelation."Item Entry No.",'',TempInvoicingSpecification);
//                         IF TrackingSpecificationExists THEN
//                           EndLoop := (TempInvoicingSpecification.NEXT = 0)
//                         ELSE
//                           EndLoop :=
//                             (PurchRcptLine.NEXT = 0) OR (ABS(RemQtyToBeInvoiced) <= ABS(PurchLine."Qty. to Receive"));
//                       UNTIL EndLoop;
//                     END ELSE
//                       ERROR(
//                         Text030,
//                         PurchLine."Receipt Line No.",PurchLine."Receipt No.");
//                   END;

//                   IF ABS(RemQtyToBeInvoiced) > ABS(PurchLine."Qty. to Receive") THEN BEGIN
//                     IF "Document Type" = "Document Type"::Invoice THEN
//                       ERROR(
//                         Text031,
//                         PurchRcptLine."Document No.");
//                     ERROR(Text014);
//                   END;
//                 END;

//                 IF TrackingSpecificationExists THEN
//                   SaveInvoiceSpecification(TempInvoicingSpecification);
//               END;

//               CASE PurchLine.Type OF
//                 PurchLine.Type::"G/L Account":
//                   IF (PurchLine."No." <> '') AND NOT PurchLine."System-Created Entry" THEN BEGIN
//                     GLAcc.GET(PurchLine."No.");
//                     GLAcc.TESTFIELD("Direct Posting");
//                     IF (PurchLine."Job No." <> '') AND (PurchLine."Qty. to Invoice" <> 0) THEN BEGIN
//                       CreateJobPurchLine(JobPurchLine,PurchLine,"Prices Including VAT");
//                       JobPostLine.InsertPurchLine(PurchHeader,PurchInvHeader,PurchCrMemoHeader,JobPurchLine,SrcCode);
//                     END;
//                     IF (PurchLine."IC Partner Code" <> '') AND Invoice THEN
//                       InsertICGenJnlLine(TempPurchLine);
//                   END;
//                 PurchLine.Type::Item:
//                   BEGIN
//                     IF RemQtyToBeInvoiced <> 0 THEN
//                       ItemLedgShptEntryNo :=
//                         PostItemJnlLine(
//                           PurchLine,
//                           RemQtyToBeInvoiced,RemQtyToBeInvoicedBase,
//                           RemQtyToBeInvoiced,RemQtyToBeInvoicedBase,
//                           0,'',DummyTrackingSpecification);
//                     IF "Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"] THEN BEGIN
//                       IF ABS(PurchLine."Return Qty. to Ship") > ABS(RemQtyToBeInvoiced) THEN
//                         ItemLedgShptEntryNo :=
//                           PostItemJnlLine(
//                             PurchLine,
//                             PurchLine."Return Qty. to Ship" - RemQtyToBeInvoiced,
//                             PurchLine."Return Qty. to Ship (Base)" - RemQtyToBeInvoicedBase,
//                             0,0,0,'',DummyTrackingSpecification);
//                     END ELSE BEGIN
//                       IF ABS(PurchLine."Qty. to Receive") > ABS(RemQtyToBeInvoiced) THEN
//                         ItemLedgShptEntryNo :=
//                           PostItemJnlLine(
//                             PurchLine,
//                             PurchLine."Qty. to Receive" - RemQtyToBeInvoiced,
//                             PurchLine."Qty. to Receive (Base)" - RemQtyToBeInvoicedBase,
//                             0,0,0,'',DummyTrackingSpecification);
//                       IF (PurchLine."Qty. to Receive" <> 0) AND
//                          (PurchLine."Sales Order Line No." <> 0)
//                       THEN BEGIN
//                         DropShptPostBuffer."Order No." := PurchLine."Sales Order No.";
//                         DropShptPostBuffer."Order Line No." := PurchLine."Sales Order Line No.";
//                         DropShptPostBuffer.Quantity := PurchLine."Qty. to Receive";
//                         DropShptPostBuffer."Quantity (Base)" := PurchLine."Qty. to Receive (Base)";
//                         DropShptPostBuffer."Item Shpt. Entry No." :=
//                           PostAssocItemJnlLine(DropShptPostBuffer.Quantity,DropShptPostBuffer."Quantity (Base)");
//                         DropShptPostBuffer.INSERT;
//                       END;
//                     END;
//                   END;
//                 3:
//                   ERROR(Text015);
//                 PurchLine.Type::"Charge (Item)":
//                   IF Invoice OR ItemChargeAssgntOnly THEN BEGIN
//                     ItemJnlRollRndg := TRUE;
//                     ClearItemChargeAssgntFilter;
//                     TempItemChargeAssgntPurch.SETCURRENTKEY("Applies-to Doc. Type");
//                     TempItemChargeAssgntPurch.SETRANGE("Document Line No.",PurchLine."Line No.");
//                     IF TempItemChargeAssgntPurch.FINDSET THEN
//                       REPEAT
//                         IF ItemChargeAssgntOnly AND (GenJnlLineDocNo = '') THEN
//                           GenJnlLineDocNo := TempItemChargeAssgntPurch."Applies-to Doc. No.";
//                         CASE TempItemChargeAssgntPurch."Applies-to Doc. Type" OF
//                           TempItemChargeAssgntPurch."Applies-to Doc. Type"::Receipt:
//                             BEGIN
//                               PostItemChargePerRcpt(PurchLine);
//                               TempItemChargeAssgntPurch.MARK(TRUE);
//                             END;
//                           TempItemChargeAssgntPurch."Applies-to Doc. Type"::"Transfer Receipt":
//                             BEGIN
//                               PostItemChargePerTransfer(PurchLine);
//                               TempItemChargeAssgntPurch.MARK(TRUE);
//                             END;
//                           TempItemChargeAssgntPurch."Applies-to Doc. Type"::"Return Shipment":
//                             BEGIN
//                               PostItemChargePerRetShpt(PurchLine);
//                               TempItemChargeAssgntPurch.MARK(TRUE);
//                             END;
//                           TempItemChargeAssgntPurch."Applies-to Doc. Type"::"Sales Shipment":
//                             BEGIN
//                               PostItemChargePerSalesShpt(PurchLine);
//                               TempItemChargeAssgntPurch.MARK(TRUE);
//                             END;
//                           TempItemChargeAssgntPurch."Applies-to Doc. Type"::"Return Receipt":
//                             BEGIN
//                               PostItemChargePerRetRcpt(PurchLine);
//                               TempItemChargeAssgntPurch.MARK(TRUE);
//                             END;
//                           TempItemChargeAssgntPurch."Applies-to Doc. Type"::Order,
//                           TempItemChargeAssgntPurch."Applies-to Doc. Type"::Invoice,
//                           TempItemChargeAssgntPurch."Applies-to Doc. Type"::"Return Order",
//                           TempItemChargeAssgntPurch."Applies-to Doc. Type"::"Credit Memo":
//                             CheckItemCharge(TempItemChargeAssgntPurch);
//                         END;
//                       UNTIL TempItemChargeAssgntPurch.NEXT = 0;
//                   END;
//               END;

//               IF (PurchLine.Type >= PurchLine.Type::"G/L Account") AND (PurchLine."Qty. to Invoice" <> 0) THEN BEGIN
//                 AdjustPrepmtAmountLCY(PurchLine);
//                 // Copy purchase to buffer
//                 FillInvPostingBuffer(PurchLine,PurchLineACY);
//                 InsertPrepmtAdjInvPostingBuf(PurchLine);
//               END;

//               IF (PurchRcptHeader."No." <> '') AND (PurchLine."Receipt No." = '') AND
//                  NOT RoundingLineInserted AND NOT TempPurchLine."Prepayment Line"
//               THEN BEGIN
//                 // Insert receipt line
//                 PurchRcptLine.INIT;
//                 PurchRcptLine.TRANSFERFIELDS(TempPurchLine);
//                 PurchRcptLine."Posting Date" := "Posting Date";
//                 PurchRcptLine."Document No." := PurchRcptHeader."No.";
//                 PurchRcptLine.Quantity := TempPurchLine."Qty. to Receive";
//                 PurchRcptLine."Quantity (Base)" := TempPurchLine."Qty. to Receive (Base)";
//                 IF ABS(TempPurchLine."Qty. to Invoice") > ABS(TempPurchLine."Qty. to Receive") THEN BEGIN
//                   PurchRcptLine."Quantity Invoiced" := TempPurchLine."Qty. to Receive";
//                   PurchRcptLine."Qty. Invoiced (Base)" := TempPurchLine."Qty. to Receive (Base)";
//                 END ELSE BEGIN
//                   PurchRcptLine."Quantity Invoiced" := TempPurchLine."Qty. to Invoice";
//                   PurchRcptLine."Qty. Invoiced (Base)" := TempPurchLine."Qty. to Invoice (Base)";
//                 END;
//                 PurchRcptLine."Qty. Rcd. Not Invoiced" :=
//                   PurchRcptLine.Quantity - PurchRcptLine."Quantity Invoiced";
//                 IF "Document Type" = "Document Type"::Order THEN BEGIN
//                   PurchRcptLine."Order No." := TempPurchLine."Document No.";
//                   PurchRcptLine."Order Line No." := TempPurchLine."Line No.";
//                 END;
//                 IF (PurchLine.Type = PurchLine.Type::Item) AND (TempPurchLine."Qty. to Receive" <> 0) THEN BEGIN
//                   IF WhseReceive THEN BEGIN
//                     WhseRcptLine.SETCURRENTKEY(
//                       "No.","Source Type","Source Subtype","Source No.","Source Line No.");
//                     WhseRcptLine.SETRANGE("No.",WhseRcptHeader."No.");
//                     WhseRcptLine.SETRANGE("Source Type",DATABASE::"Purchase Line");
//                     WhseRcptLine.SETRANGE("Source Subtype",PurchLine."Document Type");
//                     WhseRcptLine.SETRANGE("Source No.",PurchLine."Document No.");
//                     WhseRcptLine.SETRANGE("Source Line No.",PurchLine."Line No.");
//                     WhseRcptLine.FINDFIRST;
//                     WhseRcptLine.TESTFIELD("Qty. to Receive",PurchRcptLine.Quantity);
//                     SaveTempWhseSplitSpec(PurchLine);
//                     WhsePostRcpt.CreatePostedRcptLine(
//                       WhseRcptLine,PostedWhseRcptHeader,PostedWhseRcptLine,TempWhseSplitSpecification);
//                   END;
//                   IF WhseShip THEN BEGIN
//                     WhseShptLine.SETCURRENTKEY(
//                       "No.","Source Type","Source Subtype","Source No.","Source Line No.");
//                     WhseShptLine.SETRANGE("No.",WhseShptHeader."No.");
//                     WhseShptLine.SETRANGE("Source Type",DATABASE::"Purchase Line");
//                     WhseShptLine.SETRANGE("Source Subtype",PurchLine."Document Type");
//                     WhseShptLine.SETRANGE("Source No.",PurchLine."Document No.");
//                     WhseShptLine.SETRANGE("Source Line No.",PurchLine."Line No.");
//                     WhseShptLine.FINDFIRST;
//                     WhseShptLine.TESTFIELD("Qty. to Ship",-PurchRcptLine.Quantity);
//                     SaveTempWhseSplitSpec(PurchLine);
//                     WhsePostShpt.CreatePostedShptLine(
//                       WhseShptLine,PostedWhseShptHeader,PostedWhseShptLine,TempWhseSplitSpecification);
//                   END;

//                   PurchRcptLine."Item Rcpt. Entry No." :=
//                     InsertRcptEntryRelation(PurchRcptLine); // ItemLedgShptEntryNo
//                   PurchRcptLine."Item Charge Base Amount" :=
//                     ROUND(CostBaseAmount / PurchLine.Quantity * PurchRcptLine.Quantity);
//                 END;
//                 PurchRcptLine.INSERT;
//               END;

//               IF (ReturnShptHeader."No." <> '') AND (PurchLine."Return Shipment No." = '') AND
//                  NOT RoundingLineInserted
//               THEN BEGIN
//                 // Insert return shipment line
//                 ReturnShptLine.INIT;
//                 ReturnShptLine.TRANSFERFIELDS(TempPurchLine);
//                 ReturnShptLine."Posting Date" := "Posting Date";
//                 ReturnShptLine."Document No." := ReturnShptHeader."No.";
//                 ReturnShptLine.Quantity := TempPurchLine."Return Qty. to Ship";
//                 ReturnShptLine."Quantity (Base)" := TempPurchLine."Return Qty. to Ship (Base)";
//                 IF ABS(TempPurchLine."Qty. to Invoice") > ABS(TempPurchLine."Return Qty. to Ship") THEN BEGIN
//                   ReturnShptLine."Quantity Invoiced" := TempPurchLine."Return Qty. to Ship";
//                   ReturnShptLine."Qty. Invoiced (Base)" := TempPurchLine."Return Qty. to Ship (Base)";
//                 END ELSE BEGIN
//                   ReturnShptLine."Quantity Invoiced" := TempPurchLine."Qty. to Invoice";
//                   ReturnShptLine."Qty. Invoiced (Base)" := TempPurchLine."Qty. to Invoice (Base)";
//                 END;
//                 ReturnShptLine."Return Qty. Shipped Not Invd." :=
//                   ReturnShptLine.Quantity - ReturnShptLine."Quantity Invoiced";
//                 IF "Document Type" = "Document Type"::"Return Order" THEN BEGIN
//                   ReturnShptLine."Return Order No." := TempPurchLine."Document No.";
//                   ReturnShptLine."Return Order Line No." := TempPurchLine."Line No.";
//                 END;
//                 IF (PurchLine.Type = PurchLine.Type::Item) AND (TempPurchLine."Return Qty. to Ship" <> 0) THEN BEGIN
//                   IF WhseShip THEN BEGIN
//                     WhseShptLine.SETCURRENTKEY(
//                       "No.","Source Type","Source Subtype","Source No.","Source Line No.");
//                     WhseShptLine.SETRANGE("No.",WhseShptHeader."No.");
//                     WhseShptLine.SETRANGE("Source Type",DATABASE::"Purchase Line");
//                     WhseShptLine.SETRANGE("Source Subtype",PurchLine."Document Type");
//                     WhseShptLine.SETRANGE("Source No.",PurchLine."Document No.");
//                     WhseShptLine.SETRANGE("Source Line No.",PurchLine."Line No.");
//                     WhseShptLine.FINDFIRST;
//                     WhseShptLine.TESTFIELD("Qty. to Ship",ReturnShptLine.Quantity);
//                     SaveTempWhseSplitSpec(PurchLine);
//                     WhsePostShpt.CreatePostedShptLine(
//                       WhseShptLine,PostedWhseShptHeader,PostedWhseShptLine,TempWhseSplitSpecification);
//                   END;
//                   IF WhseReceive THEN BEGIN
//                     WhseRcptLine.SETCURRENTKEY(
//                       "No.","Source Type","Source Subtype","Source No.","Source Line No.");
//                     WhseRcptLine.SETRANGE("No.",WhseRcptHeader."No.");
//                     WhseRcptLine.SETRANGE("Source Type",DATABASE::"Purchase Line");
//                     WhseRcptLine.SETRANGE("Source Subtype",PurchLine."Document Type");
//                     WhseRcptLine.SETRANGE("Source No.",PurchLine."Document No.");
//                     WhseRcptLine.SETRANGE("Source Line No.",PurchLine."Line No.");
//                     WhseRcptLine.FINDFIRST;
//                     WhseRcptLine.TESTFIELD("Qty. to Receive",-ReturnShptLine.Quantity);
//                     SaveTempWhseSplitSpec(PurchLine);
//                     WhsePostRcpt.CreatePostedRcptLine(
//                       WhseRcptLine,PostedWhseRcptHeader,PostedWhseRcptLine,TempWhseSplitSpecification);
//                   END;

//                   ReturnShptLine."Item Shpt. Entry No." :=
//                     InsertReturnEntryRelation(ReturnShptLine); // ItemLedgShptEntryNo;
//                   ReturnShptLine."Item Charge Base Amount" :=
//                     ROUND(CostBaseAmount / PurchLine.Quantity * ReturnShptLine.Quantity);
//                 END;
//                 ReturnShptLine.INSERT;
//                 CheckCertificateOfSupplyStatus(ReturnShptHeader,ReturnShptLine);
//               END;

//               IF Invoice THEN
//                 InsertInvoiceOrCrMemoLine;

//               IF NOT JobItem THEN
//                 JobItem := (PurchLine.Type = PurchLine.Type::Item) AND (PurchLine."Job No." <> '');

//               IF RoundingLineInserted THEN
//                 LastLineRetrieved := TRUE
//               ELSE BEGIN
//                 BiggestLineNo := MAX(BiggestLineNo,PurchLine."Line No.");
//                 LastLineRetrieved := GetNextPurchline(PurchLine);
//                 IF LastLineRetrieved AND PurchSetup."Invoice Rounding" THEN
//                   InvoiceRounding(FALSE,BiggestLineNo);
//               END;
//             UNTIL LastLineRetrieved;

//           IF "Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"] THEN BEGIN
//             ReverseAmount(TotalPurchLine);
//             ReverseAmount(TotalPurchLineLCY);
//           END;

//           // Post combine shipment of sales order
//           SalesSetup.GET;
//           IF DropShptPostBuffer.FINDSET THEN
//             REPEAT
//               SalesOrderHeader.GET(
//                 SalesOrderHeader."Document Type"::Order,
//                 DropShptPostBuffer."Order No.");
//               SalesShptHeader.INIT;
//               SalesShptHeader.TRANSFERFIELDS(SalesOrderHeader);
//               SalesShptHeader."No." := SalesOrderHeader."Shipping No.";
//               SalesShptHeader."Order No." := SalesOrderHeader."No.";
//               SalesShptHeader."Posting Date" := "Posting Date";
//               SalesShptHeader."Document Date" := "Document Date";
//               SalesShptHeader."No. Printed" := 0;
//               SalesShptHeader.INSERT(TRUE);

//               ApprovalMgt.MoveApprvalEntryToPosted(TempApprovalEntry,DATABASE::"Sales Shipment Header",SalesShptHeader."No.");

//               IF SalesSetup."Copy Comments Order to Shpt." THEN BEGIN
//                 CopySalesCommentLines(
//                   SalesOrderHeader."Document Type",SalesCommentLine."Document Type"::Shipment,
//                   SalesOrderHeader."No.",SalesShptHeader."No.");
//                 SalesShptHeader.COPYLINKS(Rec);
//               END;
//               DropShptPostBuffer.SETRANGE("Order No.",DropShptPostBuffer."Order No.");
//               REPEAT
//                 SalesOrderLine.GET(
//                   SalesOrderLine."Document Type"::Order,
//                   DropShptPostBuffer."Order No.",DropShptPostBuffer."Order Line No.");
//                 SalesShptLine.INIT;
//                 SalesShptLine.TRANSFERFIELDS(SalesOrderLine);
//                 SalesShptLine."Posting Date" := SalesShptHeader."Posting Date";
//                 SalesShptLine."Document No." := SalesShptHeader."No.";
//                 SalesShptLine.Quantity := DropShptPostBuffer.Quantity;
//                 SalesShptLine."Quantity (Base)" := DropShptPostBuffer."Quantity (Base)";
//                 SalesShptLine."Quantity Invoiced" := 0;
//                 SalesShptLine."Qty. Invoiced (Base)" := 0;
//                 SalesShptLine."Order No." := SalesOrderLine."Document No.";
//                 SalesShptLine."Order Line No." := SalesOrderLine."Line No.";
//                 SalesShptLine."Qty. Shipped Not Invoiced" :=
//                   SalesShptLine.Quantity - SalesShptLine."Quantity Invoiced";
//                 IF SalesShptLine.Quantity <> 0 THEN BEGIN
//                   SalesShptLine."Item Shpt. Entry No." := DropShptPostBuffer."Item Shpt. Entry No.";
//                   SalesShptLine."Item Charge Base Amount" := SalesOrderLine."Line Amount";
//                 END;
//                 SalesShptLine.INSERT;
//                 ServItemMgt.CreateServItemOnSalesLineShpt(SalesOrderHeader,SalesOrderLine,SalesShptLine);
//                 SalesOrderLine."Qty. to Ship" := SalesShptLine.Quantity;
//                 SalesOrderLine."Qty. to Ship (Base)" := SalesShptLine."Quantity (Base)";
//                 SalesPost.UpdateBlanketOrderLine(SalesOrderLine,TRUE,FALSE,FALSE);

//                 SalesOrderLine.SETRANGE("Document Type",SalesOrderLine."Document Type"::Order);
//                 SalesOrderLine.SETRANGE("Document No.",DropShptPostBuffer."Order No.");
//                 SalesOrderLine.SETRANGE("Attached to Line No.",DropShptPostBuffer."Order Line No.");
//                 SalesOrderLine.SETRANGE(Type,SalesOrderLine.Type::" ");
//                 IF SalesOrderLine.FINDSET THEN
//                   REPEAT
//                     SalesShptLine.INIT;
//                     SalesShptLine.TRANSFERFIELDS(SalesOrderLine);
//                     SalesShptLine."Document No." := SalesShptHeader."No.";
//                     SalesShptLine."Order No." := SalesOrderLine."Document No.";
//                     SalesShptLine."Order Line No." := SalesOrderLine."Line No.";
//                     SalesShptLine.INSERT;
//                   UNTIL SalesOrderLine.NEXT = 0;

//               UNTIL DropShptPostBuffer.NEXT = 0;
//               DropShptPostBuffer.SETRANGE("Order No.");
//             UNTIL DropShptPostBuffer.NEXT = 0;

//           InvtSetup.GET;
//           IF InvtSetup."Automatic Cost Adjustment" <>
//              InvtSetup."Automatic Cost Adjustment"::Never
//           THEN BEGIN
//             InvtAdjmt.SetProperties(TRUE,InvtSetup."Automatic Cost Posting");
//             InvtAdjmt.SetJobUpdateProperties(NOT JobItem);
//             InvtAdjmt.MakeMultiLevelAdjmt;
//           END;

//           IF Invoice THEN BEGIN
//             // Post purchase and VAT to G/L entries from buffer
//             LineCount := 0;
//             IF InvPostingBuffer[1].FIND('+') THEN
//               REPEAT
//                 LineCount := LineCount + 1;
//                 IF GUIALLOWED THEN
//                   Window.UPDATE(3,LineCount);

//                 CASE InvPostingBuffer[1]."VAT Calculation Type" OF
//                   InvPostingBuffer[1]."VAT Calculation Type"::"Reverse Charge VAT":
//                     BEGIN
//                       VATPostingSetup.GET(
//                         InvPostingBuffer[1]."VAT Bus. Posting Group",InvPostingBuffer[1]."VAT Prod. Posting Group");
//                       InvPostingBuffer[1]."VAT Amount" :=
//                         ROUND(
//                           InvPostingBuffer[1].Amount * VATPostingSetup."VAT %" / 100);
//                       InvPostingBuffer[1]."VAT Amount (ACY)" :=
//                         ROUND(
//                           InvPostingBuffer[1]."Amount (ACY)" * VATPostingSetup."VAT %" / 100,Currency."Amount Rounding Precision");
//                     END;
//                   InvPostingBuffer[1]."VAT Calculation Type"::"Sales Tax":
//                     BEGIN
//                       IF InvPostingBuffer[1]."Use Tax" THEN BEGIN
//                         InvPostingBuffer[1]."VAT Amount" :=
//                           ROUND(
//                             SalesTaxCalculate.CalculateTax(
//                               InvPostingBuffer[1]."Tax Area Code",InvPostingBuffer[1]."Tax Group Code",
//                               InvPostingBuffer[1]."Tax Liable","Posting Date",
//                               InvPostingBuffer[1].Amount,
//                               InvPostingBuffer[1].Quantity,0));
//                         IF GLSetup."Additional Reporting Currency" <> '' THEN
//                           InvPostingBuffer[1]."VAT Amount (ACY)" :=
//                             CurrExchRate.ExchangeAmtLCYToFCY(
//                               "Posting Date",GLSetup."Additional Reporting Currency",
//                               InvPostingBuffer[1]."VAT Amount",0);
//                       END;
//                     END;
//                 END;

//                 GenJnlLine.INIT;
//                 GenJnlLine."Posting Date" := "Posting Date";
//                 GenJnlLine."Document Date" := "Document Date";
//                 GenJnlLine.Description := "Posting Description";
//                 //DP.NCM TJC #449 04/04/2018
//                 IF InvPostingBuffer[1]."Line Description" <> '' THEN //DP.NCM TJC #461 20/06/2018
//                   GenJnlLine.Description := InvPostingBuffer[1]."Line Description";
//                 //DP.NCM TJC #449 04/04/2018
//                 GenJnlLine."Reason Code" := "Reason Code";
//                 GenJnlLine."Document Type" := GenJnlLineDocType;
//                 GenJnlLine."Document No." := GenJnlLineDocNo;
//                 GenJnlLine."External Document No." := GenJnlLineExtDocNo;
//                 GenJnlLine."Account No." := InvPostingBuffer[1]."G/L Account";
//                 GenJnlLine."System-Created Entry" := InvPostingBuffer[1]."System-Created Entry";
//                 GenJnlLine.Amount := InvPostingBuffer[1].Amount;
//                 GenJnlLine."Source Currency Code" := "Currency Code";
//                 GenJnlLine."Source Currency Amount" := InvPostingBuffer[1]."Amount (ACY)";
//                 GenJnlLine.Correction := Correction;
//                 IF InvPostingBuffer[1].Type <> InvPostingBuffer[1].Type::"Prepmt. Exch. Rate Difference" THEN
//                   GenJnlLine."Gen. Posting Type" := GenJnlLine."Gen. Posting Type"::Purchase;
//                 GenJnlLine."Gen. Bus. Posting Group" := InvPostingBuffer[1]."Gen. Bus. Posting Group";
//                 GenJnlLine."Gen. Prod. Posting Group" := InvPostingBuffer[1]."Gen. Prod. Posting Group";
//                 GenJnlLine."VAT Bus. Posting Group" := InvPostingBuffer[1]."VAT Bus. Posting Group";
//                 GenJnlLine."VAT Prod. Posting Group" := InvPostingBuffer[1]."VAT Prod. Posting Group";
//                 GenJnlLine."Tax Area Code" := InvPostingBuffer[1]."Tax Area Code";
//                 GenJnlLine."Tax Liable" := InvPostingBuffer[1]."Tax Liable";
//                 GenJnlLine."Tax Group Code" := InvPostingBuffer[1]."Tax Group Code";
//                 GenJnlLine."Use Tax" := InvPostingBuffer[1]."Use Tax";
//                 GenJnlLine.Quantity := InvPostingBuffer[1].Quantity;
//                 GenJnlLine."VAT Calculation Type" := InvPostingBuffer[1]."VAT Calculation Type";
//                 GenJnlLine."VAT Base Amount" := InvPostingBuffer[1]."VAT Base Amount";
//                 GenJnlLine."VAT Base Discount %" := "VAT Base Discount %";
//                 GenJnlLine."Source Curr. VAT Base Amount" := InvPostingBuffer[1]."VAT Base Amount (ACY)";
//                 GenJnlLine."VAT Amount" := InvPostingBuffer[1]."VAT Amount";
//                 GenJnlLine."Source Curr. VAT Amount" := InvPostingBuffer[1]."VAT Amount (ACY)";
//                 GenJnlLine."VAT Difference" := InvPostingBuffer[1]."VAT Difference";
//                 GenJnlLine."VAT Posting" := GenJnlLine."VAT Posting"::"Manual VAT Entry";
//                 GenJnlLine."Job No." := InvPostingBuffer[1]."Job No.";
//                 GenJnlLine."Shortcut Dimension 1 Code" := InvPostingBuffer[1]."Global Dimension 1 Code";
//                 GenJnlLine."Shortcut Dimension 2 Code" := InvPostingBuffer[1]."Global Dimension 2 Code";
//                 GenJnlLine."Dimension Set ID" := InvPostingBuffer[1]."Dimension Set ID";
//                 GenJnlLine."Source Code" := SrcCode;
//                 GenJnlLine."Sell-to/Buy-from No." := "Buy-from Vendor No.";
//                 GenJnlLine."Bill-to/Pay-to No." := "Pay-to Vendor No.";
//                 GenJnlLine."Country/Region Code" := "VAT Country/Region Code";
//                 GenJnlLine."VAT Registration No." := "VAT Registration No.";
//                 GenJnlLine."Source Type" := GenJnlLine."Source Type"::Vendor;
//                 GenJnlLine."Source No." := "Pay-to Vendor No.";
//                 GenJnlLine."Posting No. Series" := "Posting No. Series";
//                 GenJnlLine."IC Partner Code" := "Pay-to IC Partner Code";
//                 GenJnlLine."Ship-to/Order Address Code" := "Order Address Code";

//                 IF InvPostingBuffer[1].Type = InvPostingBuffer[1].Type::"Fixed Asset" THEN BEGIN
//                   GenJnlLine."Account Type" := GenJnlLine."Account Type"::"Fixed Asset";
//                   IF InvPostingBuffer[1]."FA Posting Type" =
//                      InvPostingBuffer[1]."FA Posting Type"::"Acquisition Cost"
//                   THEN
//                     GenJnlLine."FA Posting Type" := GenJnlLine."FA Posting Type"::"Acquisition Cost";
//                   IF InvPostingBuffer[1]."FA Posting Type" =
//                      InvPostingBuffer[1]."FA Posting Type"::Maintenance
//                   THEN
//                     GenJnlLine."FA Posting Type" := GenJnlLine."FA Posting Type"::Maintenance;
//                   GenJnlLine."FA Posting Date" := InvPostingBuffer[1]."FA Posting Date";
//                   GenJnlLine."Depreciation Book Code" := InvPostingBuffer[1]."Depreciation Book Code";
//                   GenJnlLine."Salvage Value" := InvPostingBuffer[1]."Salvage Value";
//                   GenJnlLine."Depr. until FA Posting Date" := InvPostingBuffer[1]."Depr. until FA Posting Date";
//                   GenJnlLine."Depr. Acquisition Cost" := InvPostingBuffer[1]."Depr. Acquisition Cost";
//                   GenJnlLine."Maintenance Code" := InvPostingBuffer[1]."Maintenance Code";
//                   GenJnlLine."Insurance No." := InvPostingBuffer[1]."Insurance No.";
//                   GenJnlLine."Budgeted FA No." := InvPostingBuffer[1]."Budgeted FA No.";
//                   GenJnlLine."Duplicate in Depreciation Book" := InvPostingBuffer[1]."Duplicate in Depreciation Book";
//                   GenJnlLine."Use Duplication List" := InvPostingBuffer[1]."Use Duplication List";
//                 END;

//                 GLEntryNo := RunGenJnlPostLine(GenJnlLine);

//                 IF (InvPostingBuffer[1]."Job No." <> '') AND (InvPostingBuffer[1].Type = InvPostingBuffer[1].Type::"G/L Account") THEN
//                   JobPostLine.SetGLEntryNoOnJobLedgerEntry(InvPostingBuffer[1],"Posting Date",GenJnlLineDocNo,GLEntryNo);

//               UNTIL InvPostingBuffer[1].NEXT(-1) = 0;

//             InvPostingBuffer[1].DELETEALL;

//             // Check External Document number
//             IF PurchSetup."Ext. Doc. No. Mandatory" OR
//                (GenJnlLineExtDocNo <> '')
//             THEN BEGIN
//               VendLedgEntry.RESET;
//               VendLedgEntry.SETCURRENTKEY("External Document No.");
//               VendLedgEntry.SETRANGE("Document Type",GenJnlLineDocType);
//               VendLedgEntry.SETRANGE("External Document No.",GenJnlLineExtDocNo);
//               VendLedgEntry.SETRANGE("Vendor No.","Pay-to Vendor No.");
//               IF VendLedgEntry.FINDFIRST THEN
//                 ERROR(
//                   Text016,
//                   VendLedgEntry."Document Type",GenJnlLineExtDocNo);
//             END;

//             // Post vendor entries
//             IF GUIALLOWED THEN
//               Window.UPDATE(4,1);
//             GenJnlLine.INIT;
//             GenJnlLine."Posting Date" := "Posting Date";
//             GenJnlLine."Document Date" := "Document Date";
//             GenJnlLine.Description := "Posting Description";
//             GenJnlLine."Shortcut Dimension 1 Code" := "Shortcut Dimension 1 Code";
//             GenJnlLine."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
//             GenJnlLine."Dimension Set ID" := "Dimension Set ID";
//             GenJnlLine."Reason Code" := "Reason Code";
//             GenJnlLine."Account Type" := GenJnlLine."Account Type"::Vendor;
//             GenJnlLine."Account No." := "Pay-to Vendor No.";
//             GenJnlLine."Document Type" := GenJnlLineDocType;
//             GenJnlLine."Document No." := GenJnlLineDocNo;
//             GenJnlLine."External Document No." := GenJnlLineExtDocNo;
//             GenJnlLine."Currency Code" := "Currency Code";
//             GenJnlLine.Amount := -TotalPurchLine."Amount Including VAT";
//             GenJnlLine."Source Currency Code" := "Currency Code";
//             GenJnlLine."Source Currency Amount" := -TotalPurchLine."Amount Including VAT";
//             GenJnlLine."Amount (LCY)" := -TotalPurchLineLCY."Amount Including VAT";
//             IF "Currency Code" = '' THEN
//               GenJnlLine."Currency Factor" := 1
//             ELSE
//               GenJnlLine."Currency Factor" := "Currency Factor";
//             GenJnlLine."Sales/Purch. (LCY)" := -TotalPurchLineLCY.Amount;
//             GenJnlLine.Correction := Correction;
//             GenJnlLine."Inv. Discount (LCY)" := -TotalPurchLineLCY."Inv. Discount Amount";
//             GenJnlLine."Sell-to/Buy-from No." := "Buy-from Vendor No.";
//             GenJnlLine."Bill-to/Pay-to No." := "Pay-to Vendor No.";
//             GenJnlLine."Salespers./Purch. Code" := "Purchaser Code";
//             GenJnlLine."System-Created Entry" := TRUE;
//             GenJnlLine."On Hold" := "On Hold";
//             GenJnlLine."Applies-to Doc. Type" := "Applies-to Doc. Type";
//             GenJnlLine."Applies-to Doc. No." := "Applies-to Doc. No.";
//             GenJnlLine."Applies-to ID" := "Applies-to ID";
//             GenJnlLine."Allow Application" := "Bal. Account No." = '';
//             GenJnlLine."Due Date" := "Due Date";
//             GenJnlLine."Payment Terms Code" := "Payment Terms Code";
//             GenJnlLine."Pmt. Discount Date" := "Pmt. Discount Date";
//             GenJnlLine."Payment Discount %" := "Payment Discount %";
//             GenJnlLine."Source Type" := GenJnlLine."Source Type"::Vendor;
//             GenJnlLine."Source No." := "Pay-to Vendor No.";
//             GenJnlLine."Source Code" := SrcCode;
//             GenJnlLine."Posting No. Series" := "Posting No. Series";
//             GenJnlLine."IC Partner Code" := "Pay-to IC Partner Code";
//             GenJnlLine."Creditor No." := "Creditor No.";
//             GenJnlLine."Payment Reference" := "Payment Reference";
//             GenJnlLine."Payment Method Code" := "Payment Method Code";

//             GenJnlPostLine.RunWithCheck(GenJnlLine);

//             UpdatePurchaseHeader(VendLedgEntry);

//             // Balancing account
//             IF "Bal. Account No." <> '' THEN BEGIN
//               IF GUIALLOWED THEN
//                 Window.UPDATE(5,1);
//               VendLedgEntry.FINDLAST;
//               GenJnlLine.INIT;
//               GenJnlLine."Posting Date" := "Posting Date";
//               GenJnlLine."Document Date" := "Document Date";
//               GenJnlLine.Description := "Posting Description";
//               GenJnlLine."Shortcut Dimension 1 Code" := "Shortcut Dimension 1 Code";
//               GenJnlLine."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
//               GenJnlLine."Dimension Set ID" := "Dimension Set ID";
//               GenJnlLine."Reason Code" := "Reason Code";
//               GenJnlLine."Account Type" := GenJnlLine."Account Type"::Vendor;
//               GenJnlLine."Account No." := "Pay-to Vendor No.";
//               IF "Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"] THEN
//                 GenJnlLine."Document Type" := GenJnlLine."Document Type"::Refund
//               ELSE
//                 GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
//               GenJnlLine."Document No." := GenJnlLineDocNo;
//               GenJnlLine."External Document No." := GenJnlLineExtDocNo;
//               IF "Bal. Account Type" = "Bal. Account Type"::"Bank Account" THEN
//                 GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"Bank Account";
//               GenJnlLine."Bal. Account No." := "Bal. Account No.";
//               GenJnlLine."Currency Code" := "Currency Code";
//               GenJnlLine.Amount := TotalPurchLine."Amount Including VAT" +
//                 VendLedgEntry."Remaining Pmt. Disc. Possible";
//               GenJnlLine.Correction := Correction;
//               GenJnlLine."Source Currency Code" := "Currency Code";
//               GenJnlLine."Source Currency Amount" := GenJnlLine.Amount;
//               VendLedgEntry.CALCFIELDS(Amount);
//               IF VendLedgEntry.Amount = 0 THEN
//                 GenJnlLine."Amount (LCY)" := TotalPurchLineLCY."Amount Including VAT"
//               ELSE
//                 GenJnlLine."Amount (LCY)" :=
//                   TotalPurchLineLCY."Amount Including VAT" +
//                   ROUND(
//                     VendLedgEntry."Remaining Pmt. Disc. Possible" /
//                     VendLedgEntry."Adjusted Currency Factor");
//               IF "Currency Code" = '' THEN
//                 GenJnlLine."Currency Factor" := 1
//               ELSE
//                 GenJnlLine."Currency Factor" := "Currency Factor";
//               GenJnlLine."Applies-to Doc. Type" := GenJnlLineDocType;
//               GenJnlLine."Applies-to Doc. No." := GenJnlLineDocNo;
//               GenJnlLine."Source Type" := GenJnlLine."Source Type"::Vendor;
//               GenJnlLine."Source No." := "Pay-to Vendor No.";
//               GenJnlLine."Source Code" := SrcCode;
//               GenJnlLine."Posting No. Series" := "Posting No. Series";
//               GenJnlLine."IC Partner Code" := "Pay-to IC Partner Code";
//               GenJnlLine."Allow Zero-Amount Posting" := TRUE;
//               GenJnlLine."Salespers./Purch. Code" := "Purchaser Code";
//               GenJnlPostLine.RunWithCheck(GenJnlLine);
//             END;
//           END;

//           IF ICGenJnlLineNo > 0 THEN
//             PostICGenJnl;

//           IF Receive THEN BEGIN
//             "Last Receiving No." := "Receiving No.";
//             "Receiving No." := '';
//           END;
//           IF Invoice THEN BEGIN
//             "Last Posting No." := "Posting No.";
//             "Posting No." := '';
//           END;
//           IF Ship THEN BEGIN
//             "Last Return Shipment No." := "Return Shipment No.";
//             "Return Shipment No." := '';
//           END;

//           IF ("Document Type" IN ["Document Type"::Order,"Document Type"::"Return Order"]) AND
//              (NOT EverythingInvoiced)
//           THEN BEGIN
//             MODIFY;
//             InsertTrackingSpecification;

//             IF PurchLine.FINDSET THEN
//               REPEAT
//                 IF PurchLine.Quantity <> 0 THEN BEGIN
//                   IF Receive THEN BEGIN
//                     PurchLine."Quantity Received" := PurchLine."Quantity Received" + PurchLine."Qty. to Receive";
//                     PurchLine."Qty. Received (Base)" := PurchLine."Qty. Received (Base)" + PurchLine."Qty. to Receive (Base)";
//                   END;
//                   IF Ship THEN BEGIN
//                     PurchLine."Return Qty. Shipped" := PurchLine."Return Qty. Shipped" + PurchLine."Return Qty. to Ship";
//                     PurchLine."Return Qty. Shipped (Base)" :=
//                       PurchLine."Return Qty. Shipped (Base)" + PurchLine."Return Qty. to Ship (Base)";
//                   END;
//                   IF Invoice THEN BEGIN
//                     IF "Document Type" = "Document Type"::Order THEN BEGIN
//                       IF ABS(PurchLine."Quantity Invoiced" + PurchLine."Qty. to Invoice") >
//                          ABS(PurchLine."Quantity Received")
//                       THEN BEGIN
//                         PurchLine.VALIDATE("Qty. to Invoice",
//                           PurchLine."Quantity Received" - PurchLine."Quantity Invoiced");
//                         PurchLine."Qty. to Invoice (Base)" :=
//                           PurchLine."Qty. Received (Base)" - PurchLine."Qty. Invoiced (Base)";
//                       END;
//                     END ELSE
//                       IF ABS(PurchLine."Quantity Invoiced" + PurchLine."Qty. to Invoice") >
//                          ABS(PurchLine."Return Qty. Shipped")
//                       THEN BEGIN
//                         PurchLine.VALIDATE("Qty. to Invoice",
//                           PurchLine."Return Qty. Shipped" - PurchLine."Quantity Invoiced");
//                         PurchLine."Qty. to Invoice (Base)" :=
//                           PurchLine."Return Qty. Shipped (Base)" - PurchLine."Qty. Invoiced (Base)";
//                       END;

//                     PurchLine."Quantity Invoiced" := PurchLine."Quantity Invoiced" + PurchLine."Qty. to Invoice";
//                     PurchLine."Qty. Invoiced (Base)" := PurchLine."Qty. Invoiced (Base)" + PurchLine."Qty. to Invoice (Base)";
//                     IF PurchLine."Qty. to Invoice" <> 0 THEN BEGIN
//                       PurchLine."Prepmt Amt Deducted" :=
//                         PurchLine."Prepmt Amt Deducted" + PurchLine."Prepmt Amt to Deduct";
//                       PurchLine."Prepmt VAT Diff. Deducted" :=
//                         PurchLine."Prepmt VAT Diff. Deducted" + PurchLine."Prepmt VAT Diff. to Deduct";
//                       DecrementPrepmtAmtInvLCY(
//                         PurchLine,PurchLine."Prepmt. Amount Inv. (LCY)",PurchLine."Prepmt. VAT Amount Inv. (LCY)");
//                       PurchLine."Prepmt Amt to Deduct" :=
//                         PurchLine."Prepmt. Amt. Inv." - PurchLine."Prepmt Amt Deducted";
//                       PurchLine."Prepmt VAT Diff. to Deduct" := 0;
//                     END;
//                   END;

//                   UpdateBlanketOrderLine(PurchLine,Receive,Ship,Invoice);
//                   PurchLine.InitOutstanding;

//                   IF WhseHandlingRequired OR
//                      (PurchSetup."Default Qty. to Receive" = PurchSetup."Default Qty. to Receive"::Blank)
//                   THEN BEGIN
//                     IF "Document Type" = "Document Type"::"Return Order" THEN BEGIN
//                       PurchLine."Return Qty. to Ship" := 0;
//                       PurchLine."Return Qty. to Ship (Base)" := 0;
//                     END ELSE BEGIN
//                       PurchLine."Qty. to Receive" := 0;
//                       PurchLine."Qty. to Receive (Base)" := 0;
//                     END;
//                     PurchLine.InitQtyToInvoice;
//                   END ELSE BEGIN
//                     IF "Document Type" = "Document Type"::"Return Order" THEN
//                       PurchLine.InitQtyToShip
//                     ELSE
//                       PurchLine.InitQtyToReceive2;
//                   END;
//                   PurchLine.SetDefaultQuantity;
//                   PurchLine.MODIFY;
//                 END;
//               UNTIL PurchLine.NEXT = 0;

//             UpdateAssocOrder;
//             IF WhseReceive THEN BEGIN
//               WhsePostRcpt.PostUpdateWhseDocuments(WhseRcptHeader);
//               TempWhseRcptHeader.DELETE;
//             END;
//             IF WhseShip THEN BEGIN
//               WhsePostShpt.PostUpdateWhseDocuments(WhseShptHeader);
//               TempWhseShptHeader.DELETE;
//             END;
//             WhsePurchRelease.Release(PurchHeader);
//             UpdateItemChargeAssgnt;
//           END ELSE BEGIN
//             CASE "Document Type" OF
//               "Document Type"::Invoice:
//                 BEGIN
//                   PurchLine.SETFILTER("Receipt No.",'<>%1','');
//                   IF PurchLine.FINDSET THEN
//                     REPEAT
//                       IF PurchLine.Type <> PurchLine.Type::" " THEN BEGIN
//                         PurchRcptLine.GET(PurchLine."Receipt No.",PurchLine."Receipt Line No.");
//                         TempPurchLine.GET(
//                           TempPurchLine."Document Type"::Order,
//                           PurchRcptLine."Order No.",PurchRcptLine."Order Line No.");
//                         IF PurchLine.Type = PurchLine.Type::"Charge (Item)" THEN
//                           UpdatePurchOrderChargeAssgnt(PurchLine,TempPurchLine);
//                         TempPurchLine."Quantity Invoiced" :=
//                           TempPurchLine."Quantity Invoiced" + PurchLine."Qty. to Invoice";
//                         TempPurchLine."Qty. Invoiced (Base)" :=
//                           TempPurchLine."Qty. Invoiced (Base)" + PurchLine."Qty. to Invoice (Base)";
//                         IF ABS(TempPurchLine."Quantity Invoiced") > ABS(TempPurchLine."Quantity Received") THEN
//                           ERROR(
//                             Text017,
//                             TempPurchLine."Document No.");
//                         IF TempPurchLine."Sales Order Line No." <> 0 THEN BEGIN // Drop Shipment
//                           SalesOrderLine.GET(
//                             SalesOrderLine."Document Type"::Order,
//                             TempPurchLine."Sales Order No.",TempPurchLine."Sales Order Line No.");
//                           IF ABS(TempPurchLine.Quantity - TempPurchLine."Quantity Invoiced") <
//                              ABS(SalesOrderLine.Quantity - SalesOrderLine."Quantity Invoiced")
//                           THEN
//                             ERROR(
//                               Text018 +
//                               Text99000000,
//                               TempPurchLine."Sales Order No.");
//                         END;
//                         TempPurchLine.InitQtyToInvoice;
//                         IF TempPurchLine."Prepayment %" <> 0 THEN BEGIN
//                           TempPurchLine."Prepmt Amt Deducted" := TempPurchLine."Prepmt Amt Deducted" + PurchLine."Prepmt Amt to Deduct";
//                           TempPurchLine."Prepmt VAT Diff. Deducted" :=
//                             TempPurchLine."Prepmt VAT Diff. Deducted" + PurchLine."Prepmt VAT Diff. to Deduct";
//                           DecrementPrepmtAmtInvLCY(
//                             PurchLine,TempPurchLine."Prepmt. Amount Inv. (LCY)",TempPurchLine."Prepmt. VAT Amount Inv. (LCY)");
//                           TempPurchLine."Prepmt Amt to Deduct" :=
//                             TempPurchLine."Prepmt. Amt. Inv." - TempPurchLine."Prepmt Amt Deducted";
//                           TempPurchLine."Prepmt VAT Diff. to Deduct" := 0;
//                         END;
//                         TempPurchLine.InitOutstanding;
//                         TempPurchLine.MODIFY;
//                       END;
//                     UNTIL PurchLine.NEXT = 0;
//                   InsertTrackingSpecification;

//                   PurchLine.SETRANGE("Receipt No.");
//                 END;
//               "Document Type"::"Credit Memo":
//                 BEGIN
//                   PurchLine.SETFILTER("Return Shipment No.",'<>%1','');
//                   IF PurchLine.FINDSET THEN
//                     REPEAT
//                       IF PurchLine.Type <> PurchLine.Type::" " THEN BEGIN
//                         ReturnShptLine.GET(PurchLine."Return Shipment No.",PurchLine."Return Shipment Line No.");
//                         TempPurchLine.GET(
//                           TempPurchLine."Document Type"::"Return Order",
//                           ReturnShptLine."Return Order No.",ReturnShptLine."Return Order Line No.");
//                         IF PurchLine.Type = PurchLine.Type::"Charge (Item)" THEN
//                           UpdatePurchOrderChargeAssgnt(PurchLine,TempPurchLine);
//                         TempPurchLine."Quantity Invoiced" :=
//                           TempPurchLine."Quantity Invoiced" + PurchLine."Qty. to Invoice";
//                         TempPurchLine."Qty. Invoiced (Base)" :=
//                           TempPurchLine."Qty. Invoiced (Base)" + PurchLine."Qty. to Invoice (Base)";
//                         IF ABS(TempPurchLine."Quantity Invoiced") > ABS(TempPurchLine."Return Qty. Shipped") THEN
//                           ERROR(
//                             Text041,
//                             TempPurchLine."Document No.");
//                         TempPurchLine.InitQtyToInvoice;
//                         TempPurchLine.InitOutstanding;
//                         TempPurchLine.MODIFY;
//                       END;
//                     UNTIL PurchLine.NEXT = 0;
//                   InsertTrackingSpecification;

//                   PurchLine.SETRANGE("Return Shipment No.");
//                 END;
//               ELSE
//                 IF PurchLine.FINDSET THEN
//                   REPEAT
//                     IF PurchLine."Prepayment %" <> 0 THEN
//                       DecrementPrepmtAmtInvLCY(
//                         PurchLine,PurchLine."Prepmt. Amount Inv. (LCY)",PurchLine."Prepmt. VAT Amount Inv. (LCY)");
//                   UNTIL PurchLine.NEXT = 0;
//             END;

//             PurchLine.SETFILTER("Blanket Order Line No.",'<>0');
//             IF PurchLine.FINDSET THEN
//               REPEAT
//                 UpdateBlanketOrderLine(PurchLine,Receive,Ship,Invoice);
//               UNTIL PurchLine.NEXT = 0;
//             PurchLine.SETRANGE("Blanket Order Line No.");

//             IF WhseReceive THEN BEGIN
//               WhsePostRcpt.PostUpdateWhseDocuments(WhseRcptHeader);
//               TempWhseRcptHeader.DELETE;
//             END;
//             IF WhseShip THEN BEGIN
//               WhsePostShpt.PostUpdateWhseDocuments(WhseShptHeader);
//               TempWhseShptHeader.DELETE;
//             END;

//             ApprovalMgt.DeleteApprovalEntry(DATABASE::"Purchase Header","Document Type","No.");

//             IF HASLINKS THEN
//               DELETELINKS;
//             DELETE;

//             ReservePurchLine.DeleteInvoiceSpecFromHeader(PurchHeader);
//             IF PurchLine.FINDFIRST THEN
//               REPEAT
//                 IF PurchLine.HASLINKS THEN
//                   PurchLine.DELETELINKS;
//               UNTIL PurchLine.NEXT = 0;
//             PurchLine.DELETEALL;
//             DeleteItemChargeAssgnt;

//             PurchCommentLine.SETRANGE("Document Type","Document Type");
//             PurchCommentLine.SETRANGE("No.","No.");
//             IF NOT PurchCommentLine.ISEMPTY THEN
//               PurchCommentLine.DELETEALL;
//             WhseRqst.SETCURRENTKEY("Source Type","Source Subtype","Source No.");
//             WhseRqst.SETRANGE("Source Type",DATABASE::"Purchase Line");
//             WhseRqst.SETRANGE("Source Subtype","Document Type");
//             WhseRqst.SETRANGE("Source No.","No.");
//             IF NOT WhseRqst.ISEMPTY THEN
//               WhseRqst.DELETEALL;
//           END;

//           InsertValueEntryRelation;
//           DeleteReservationEntryRelateJobNo(PurchLine."Document Type","No.",PurchLine."Line No.",PurchLine."Job No.");
//           IF NOT InvtPickPutaway THEN
//             COMMIT;
//           CLEAR(WhsePostRcpt);
//           CLEAR(WhsePostShpt);
//           CLEAR(GenJnlPostLine);
//           CLEAR(JobPostLine);
//           CLEAR(ItemJnlPostLine);
//           CLEAR(WhseJnlPostLine);
//           CLEAR(InvtAdjmt);
//           IF GUIALLOWED THEN
//             Window.CLOSE;
//         END;
//         Rec := PurchHeader;

//         IF NOT InvtPickPutaway THEN BEGIN
//           COMMIT;
//           UpdateAnalysisView.UpdateAll(0,TRUE);
//           UpdateItemAnalysisView.UpdateAll(0,TRUE);
//         END;
//     end;

//     var
//         Text001: Label 'There is nothing to post.';
//         Text002: Label 'A drop shipment from a purchase order cannot be received and invoiced at the same time.';
//         Text003: Label 'You cannot invoice this purchase order before the associated sales orders have been invoiced. ';
//         Text004: Label 'Please invoice sales order %1 before invoicing this purchase order.';
//         Text005: Label 'Posting lines              #2######\';
//         Text006: Label 'Posting purchases and VAT  #3######\';
//         Text007: Label 'Posting to vendors         #4######\';
//         Text008: Label 'Posting to bal. account    #5######';
//         Text009: Label 'Posting lines         #2######';
//         Text010: Label '%1 %2 -> Invoice %3';
//         Text011: Label '%1 %2 -> Credit Memo %3';
//         Text012: Label 'must have the same sign as the receipt';
//         Text014: Label 'Receipt lines have been deleted.';
//         Text015: Label 'You cannot purchase resources.';
//         Text016: Label 'Purchase %1 %2 already exists for this vendor.';
//         Text017: Label 'You cannot invoice order %1 for more than you have received.';
//         Text018: Label 'You cannot post this purchase order before the associated sales orders have been invoiced. ';
//         Text021: Label 'VAT Amount';
//         Text022: Label '%1% VAT';
//         Text023: Label 'in the associated blanket order must not be greater than %1';
//         Text024: Label 'in the associated blanket order must be reduced.';
//         Text025: Label 'Please enter "Yes" in %1 and/or %2 and/or %3.';
//         Text026: Label 'Warehouse handling is required for %1 = %2, %3 = %4, %5 = %6.';
//         Text028: Label 'must have the same sign as the return shipment';
//         Text029: Label 'Line %1 of the return shipment %2, which you are attempting to invoice, has already been invoiced.';
//         Text030: Label 'Line %1 of the receipt %2, which you are attempting to invoice, has already been invoiced.';
//         Text031: Label 'The quantity you are attempting to invoice is greater than the quantity in receipt %1';
//         Text032: Label 'The combination of dimensions used in %1 %2 is blocked. %3';
//         Text033: Label 'The combination of dimensions used in %1 %2, line no. %3 is blocked. %4';
//         Text034: Label 'The dimensions used in %1 %2 are invalid. %3';
//         Text035: Label 'The dimensions used in %1 %2, line no. %3 are invalid. %4';
//         Text036: Label 'You cannot assign more than %1 units in %2 = %3,%4 = %5,%6 = %7.';
//         Text037: Label 'You must assign all item charges, if you invoice everything.';
//         Text038: Label 'You cannot assign item charges to the %1 %2 = %3,%4 = %5, %6 = %7, because it has been invoiced.';
//         CurrExchRate: Record "330";
//         PurchSetup: Record "312";
//         GLSetup: Record "98";
//         InvtSetup: Record "313";
//         GLEntry: Record "17";
//         PurchHeader: Record "38";
//         PurchLine: Record "39";
//         PurchLine2: Record "39";
//         JobPurchLine: Record "39";
//         TotalPurchLine: Record "39";
//         TotalPurchLineLCY: Record "39";
//         TempPurchLine: Record "39";
//         PurchLineACY: Record "39";
//         TempPrepmtPurchLine: Record "39" temporary;
//         CombinedPurchLineTemp: Record "39" temporary;
//         PurchRcptHeader: Record "120";
//         PurchRcptLine: Record "121";
//         PurchInvHeader: Record "122";
//         PurchInvLine: Record "123";
//         PurchCrMemoHeader: Record "124";
//         PurchCrMemoLine: Record "125";
//         ReturnShptHeader: Record "6650";
//         ReturnShptLine: Record "6651";
//         SalesOrderHeader: Record "36";
//         SalesOrderLine: Record "37";
//         SalesShptHeader: Record "110";
//         SalesShptLine: Record "111";
//         ItemChargeAssgntPurch: Record "5805";
//         TempItemChargeAssgntPurch: Record "5805" temporary;
//         GenJnlLine: Record "81";
//         ItemJnlLine: Record "83";
//         VendPostingGr: Record "93";
//         SourceCodeSetup: Record "242";
//         SourceCode: Record "230";
//         PurchCommentLine: Record "43";
//         PurchCommentLine2: Record "43";
//         InvPostingBuffer: array [2] of Record "49" temporary;
//         DropShptPostBuffer: Record "223" temporary;
//         GenPostingSetup: Record "252";
//         VATPostingSetup: Record "325";
//         Currency: Record "4";
//         Vend: Record "23";
//         VendLedgEntry: Record "25";
//         FA: Record "5600";
//         FASetup: Record "5603";
//         DeprBook: Record "5611";
//         GLAcc: Record "15";
//         ApprovalEntry: Record "454";
//         TempApprovalEntry: Record "454" temporary;
//         WhseRqst: Record "5765";
//         WhseRcptHeader: Record "7316";
//         TempWhseRcptHeader: Record "7316" temporary;
//         WhseRcptLine: Record "7317";
//         WhseShptHeader: Record "7320";
//         TempWhseShptHeader: Record "7320" temporary;
//         WhseShptLine: Record "7321";
//         PostedWhseRcptHeader: Record "7318";
//         PostedWhseRcptLine: Record "7319";
//         PostedWhseShptHeader: Record "7322";
//         PostedWhseShptLine: Record "7323";
//         TempVATAmountLine: Record "290" temporary;
//         TempVATAmountLineRemainder: Record "290" temporary;
//         Location: Record "14";
//         TempHandlingSpecification: Record "336" temporary;
//         TempTrackingSpecification: Record "336" temporary;
//         TempTrackingSpecificationInv: Record "336" temporary;
//         TempWhseSplitSpecification: Record "336" temporary;
//         TempValueEntryRelation: Record "6508" temporary;
//         ReservationEntry2: Record "337";
//         ReservationEntry3: Record "337" temporary;
//         ItemJnlLine2: Record "83";
//         Job: Record "167";
//         TempICGenJnlLine: Record "81" temporary;
//         TempPrepmtDeductLCYPurchLine: Record "39" temporary;
//         TempSKU: Record "5700" temporary;
//         NoSeriesMgt: Codeunit "396";
//         GenJnlCheckLine: Codeunit "11";
//         GenJnlPostLine: Codeunit "12";
//         ItemJnlPostLine: Codeunit "22";
//         PurchCalcDisc: Codeunit "70";
//         SalesTaxCalculate: Codeunit "398";
//         ReservePurchLine: Codeunit "99000834";
//         DimMgt: Codeunit "408";
//         ApprovalMgt: Codeunit "439";
//         WhsePurchRelease: Codeunit "5772";
//         SalesPost: Codeunit "80";
//         ItemTrackingMgt: Codeunit "6500";
//         WMSMgmt: Codeunit "7302";
//         WhseJnlPostLine: Codeunit "7301";
//         WhsePostRcpt: Codeunit "5760";
//         WhsePostShpt: Codeunit "5763";
//         ICInOutBoxMgt: Codeunit "427";
//         InvtAdjmt: Codeunit "5895";
//         CostCalcMgt: Codeunit "5836";
//         JobPostLine: Codeunit "1001";
//         ReservePurchLine2: Codeunit "99000834";
//         ServItemMgt: Codeunit "5920";
//         Window: Dialog;
//         PostingDate: Date;
//         Usedate: Date;
//         GenJnlLineDocNo: Code[20];
//         GenJnlLineExtDocNo: Code[35];
//         SrcCode: Code[10];
//         ItemLedgShptEntryNo: Integer;
//         LineCount: Integer;
//         GenJnlLineDocType: Integer;
//         FALineNo: Integer;
//         RoundingLineNo: Integer;
//         WhseReference: Integer;
//         RemQtyToBeInvoiced: Decimal;
//         RemQtyToBeInvoicedBase: Decimal;
//         QtyToBeInvoiced: Decimal;
//         QtyToBeInvoicedBase: Decimal;
//         RemAmt: Decimal;
//         RemDiscAmt: Decimal;
//         EverythingInvoiced: Boolean;
//         LastLineRetrieved: Boolean;
//         RoundingLineInserted: Boolean;
//         DropShipOrder: Boolean;
//         PostingDateExists: Boolean;
//         ReplacePostingDate: Boolean;
//         ReplaceDocumentDate: Boolean;
//         ModifyHeader: Boolean;
//         TempInvoice: Boolean;
//         TempRcpt: Boolean;
//         TempReturn: Boolean;
//         GLSetupRead: Boolean;
//         Text039: Label 'The quantity you are attempting to invoice is greater than the quantity in return shipment %1';
//         Text040: Label 'Return shipment lines have been deleted.';
//         Text041: Label 'You cannot invoice return order %1 for more than you have shipped.';
//         Text99000000: Label 'Post sales order %1 before posting this purchase order.';
//         Text042: Label 'Related item ledger entries cannot be found.';
//         Text043: Label 'Item Tracking is signed wrongly.';
//         Text044: Label 'Item Tracking does not match.';
//         Text045: Label 'is not within your range of allowed posting dates.';
//         Text046: Label 'The %1 does not match the quantity defined in item tracking.';
//         Text047: Label 'cannot be more than %1.';
//         Text048: Label 'must be at least %1.';
//         ItemChargeAssgntOnly: Boolean;
//         ItemJnlRollRndg: Boolean;
//         WhseReceive: Boolean;
//         WhseShip: Boolean;
//         InvtPickPutaway: Boolean;
//         JobItem: Boolean;
//         PositiveWhseEntrycreated: Boolean;
//         ICGenJnlLineNo: Integer;
//         Text050: Label 'The total %1 cannot be more than %2.';
//         Text051: Label 'The total %1 must be at least %2.';
//         Text052: Label 'An unposted invoice for order %1 exists. To avoid duplicate postings, delete order %1 or invoice %2.\Do you still want to post order %1?';
//         Text053: Label 'An invoice for order %1 exists in the IC inbox. To avoid duplicate postings, cancel invoice %2 in the IC inbox.\Do you still want to post order %1?';
//         Text054: Label 'Posted invoice %1 already exists for order %2. To avoid duplicate postings, do not post order %2.\Do you still want to post order %2?';
//         Text055: Label 'Order %1 originates from the same IC transaction as invoice %2. To avoid duplicate postings, delete order %1 or invoice %2.\Do you still want to post invoice %2?';
//         Text056: Label 'A document originating from the same IC transaction as document %1 exists in the IC inbox. To avoid duplicate postings, cancel document %2 in the IC inbox.\Do you still want to post document %1?';
//         Text057: Label 'Posted invoice %1 originates from the same IC transaction as invoice %2. To avoid duplicate postings, do not post invoice %2.\Do you still want to post invoice %2?';
//         Text058: Label 'This is an IC document. If you post this document and the invoice you receive from your IC partner, it will result in duplicate postings.\Are you sure you want to post this document?';
//         TotalChargeAmt: Decimal;
//         TotalChargeAmtLCY: Decimal;
//         TotalChargeAmt2: Decimal;
//         TotalChargeAmtLCY2: Decimal;
//         Text059: Label 'You must assign item charge %1 if you want to invoice it.';
//         Text060: Label 'You can not invoice item charge %1 because there is no item ledger entry to assign it to.';
//         PurchaseLinesProcessed: Boolean;
//         Text061Qst: Label 'One or more reservation entries exist for the item with %1 = %2, %3 = %4, %5 = %6 which may be disrupted if you post this negative adjustment. Do you want to continue?', Comment='One or more reservation entries exist for the item with No. = 1000, Location Code = SILVER, Variant Code = NEW which may be disrupted if you post this negative adjustment. Do you want to continue?';
//         Text062Err: Label 'The order line that the item charge was originally assigned to has been fully posted. You must reassign the item charge to the posted receipt or shipment.';

//     procedure SetPostingDate(NewReplacePostingDate: Boolean;NewReplaceDocumentDate: Boolean;NewPostingDate: Date)
//     begin
//         PostingDateExists := TRUE;
//         ReplacePostingDate := NewReplacePostingDate;
//         ReplaceDocumentDate := NewReplaceDocumentDate;
//         PostingDate := NewPostingDate;
//     end;

//     local procedure PostItemJnlLine(PurchLine: Record "39";QtyToBeReceived: Decimal;QtyToBeReceivedBase: Decimal;QtyToBeInvoiced: Decimal;QtyToBeInvoicedBase: Decimal;ItemLedgShptEntryNo: Integer;ItemChargeNo: Code[20];TrackingSpecification: Record "336"): Integer
//     var
//         ItemChargePurchLine: Record "39";
//         OriginalItemJnlLine: Record "83";
//         TempWhseJnlLine: Record "7311" temporary;
//         TempWhseTrackingSpecification: Record "336" temporary;
//         TempWhseJnlLine2: Record "7311" temporary;
//         Factor: Decimal;
//         PostWhseJnlLine: Boolean;
//         CheckApplToItemEntry: Boolean;
//         PostJobConsumptionBeforePurch: Boolean;
//         NextReservationEntryNo: Integer;
//     begin
//         IF NOT ItemJnlRollRndg THEN BEGIN
//           RemAmt := 0;
//           RemDiscAmt := 0;
//         END;
//         WITH PurchLine DO BEGIN
//           ItemJnlLine.INIT;
//           ItemJnlLine."Posting Date" := PurchHeader."Posting Date";
//           ItemJnlLine."Document Date" := PurchHeader."Document Date";
//           ItemJnlLine."Source Posting Group" := PurchHeader."Vendor Posting Group";
//           ItemJnlLine."Salespers./Purch. Code" := PurchHeader."Purchaser Code";
//           ItemJnlLine."Country/Region Code" := PurchHeader."Buy-from Country/Region Code";
//           ItemJnlLine."Reason Code" := PurchHeader."Reason Code";
//           ItemJnlLine."Item No." := "No.";
//           ItemJnlLine.Description := Description;
//           ItemJnlLine."Shortcut Dimension 1 Code" := "Shortcut Dimension 1 Code";
//           ItemJnlLine."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
//           ItemJnlLine."Dimension Set ID" := "Dimension Set ID";
//           ItemJnlLine."Location Code" := "Location Code";
//           ItemJnlLine."Bin Code" := "Bin Code";
//           ItemJnlLine."Variant Code" := "Variant Code";
//           ItemJnlLine."Item Category Code" := "Item Category Code";
//           ItemJnlLine."Product Group Code" := "Product Group Code";
//           ItemJnlLine."Inventory Posting Group" := "Posting Group";
//           ItemJnlLine."Gen. Bus. Posting Group" := "Gen. Bus. Posting Group";
//           ItemJnlLine."Gen. Prod. Posting Group" := "Gen. Prod. Posting Group";
//           ItemJnlLine."Serial No." := TrackingSpecification."Serial No.";
//           ItemJnlLine."Lot No." := TrackingSpecification."Lot No.";
//           ItemJnlLine."Job No." := "Job No.";
//           ItemJnlLine."Job Task No." := "Job Task No.";
//           IF ItemJnlLine."Job No." <> '' THEN
//             ItemJnlLine."Job Purchase" := TRUE;
//           ItemJnlLine."Applies-to Entry" := "Appl.-to Item Entry";
//           ItemJnlLine."Transaction Type" := "Transaction Type";
//           ItemJnlLine."Transport Method" := "Transport Method";
//           ItemJnlLine."Entry/Exit Point" := "Entry Point";
//           ItemJnlLine.Area := Area;
//           ItemJnlLine."Transaction Specification" := "Transaction Specification";
//           ItemJnlLine."Drop Shipment" := "Drop Shipment";
//           ItemJnlLine."Entry Type" := ItemJnlLine."Entry Type"::Purchase;
//           IF "Prod. Order No." <> '' THEN BEGIN
//             ItemJnlLine."Order Type" := ItemJnlLine."Order Type"::Production;
//             ItemJnlLine."Order No." := "Prod. Order No.";
//             ItemJnlLine."Order Line No." := "Prod. Order Line No.";
//           END;
//           ItemJnlLine."Unit of Measure Code" := "Unit of Measure Code";
//           ItemJnlLine."Qty. per Unit of Measure" := "Qty. per Unit of Measure";
//           ItemJnlLine."Cross-Reference No." := "Cross-Reference No.";
//           IF QtyToBeReceived = 0 THEN BEGIN
//             IF "Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"] THEN
//               ItemJnlLine."Document Type" := ItemJnlLine."Document Type"::"Purchase Credit Memo"
//             ELSE
//               ItemJnlLine."Document Type" := ItemJnlLine."Document Type"::"Purchase Invoice";
//             ItemJnlLine."Document No." := GenJnlLineDocNo;
//             ItemJnlLine."External Document No." := GenJnlLineExtDocNo;
//             ItemJnlLine."Posting No. Series" := PurchHeader."Posting No. Series";
//             IF QtyToBeInvoiced <> 0 THEN
//               ItemJnlLine."Invoice No." := GenJnlLineDocNo;
//           END ELSE BEGIN
//             IF "Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"] THEN BEGIN
//               ItemJnlLine."Document Type" := ItemJnlLine."Document Type"::"Purchase Return Shipment";
//               ItemJnlLine."Document No." := ReturnShptHeader."No.";
//               ItemJnlLine."External Document No." := ReturnShptHeader."Vendor Authorization No.";
//               ItemJnlLine."Posting No. Series" := ReturnShptHeader."No. Series";
//             END ELSE BEGIN
//               ItemJnlLine."Document Type" := ItemJnlLine."Document Type"::"Purchase Receipt";
//               ItemJnlLine."Document No." := PurchRcptHeader."No.";
//               ItemJnlLine."External Document No." := PurchRcptHeader."Vendor Shipment No.";
//               ItemJnlLine."Posting No. Series" := PurchRcptHeader."No. Series";
//             END;
//             IF QtyToBeInvoiced <> 0 THEN BEGIN
//               ItemJnlLine."Invoice No." := GenJnlLineDocNo;
//               ItemJnlLine."External Document No." := GenJnlLineExtDocNo;
//               IF ItemJnlLine."Document No." = '' THEN BEGIN
//                 IF "Document Type" = "Document Type"::"Credit Memo" THEN
//                   ItemJnlLine."Document Type" := ItemJnlLine."Document Type"::"Purchase Credit Memo"
//                 ELSE
//                   ItemJnlLine."Document Type" := ItemJnlLine."Document Type"::"Purchase Invoice";
//                 ItemJnlLine."Document No." := GenJnlLineDocNo;
//               END;
//               ItemJnlLine."Posting No. Series" := PurchHeader."Posting No. Series";
//             END;
//           END;

//           ItemJnlLine."Document Line No." := "Line No.";
//           ItemJnlLine.Quantity := QtyToBeReceived;
//           ItemJnlLine."Quantity (Base)" := QtyToBeReceivedBase;
//           ItemJnlLine."Invoiced Quantity" := QtyToBeInvoiced;
//           ItemJnlLine."Invoiced Qty. (Base)" := QtyToBeInvoicedBase;
//           ItemJnlLine."Unit Cost" := "Unit Cost (LCY)";
//           ItemJnlLine."Source Currency Code" := PurchHeader."Currency Code";
//           ItemJnlLine."Unit Cost (ACY)" := "Unit Cost";
//           ItemJnlLine."Value Entry Type" := ItemJnlLine."Value Entry Type"::"Direct Cost";
//           IF ItemChargeNo <> '' THEN BEGIN
//             ItemJnlLine."Item Charge No." := ItemChargeNo;
//             "Qty. to Invoice" := QtyToBeInvoiced;
//           END;

//           IF QtyToBeInvoiced <> 0 THEN BEGIN
//             IF (QtyToBeInvoicedBase <> 0) AND (Type = Type::Item)THEN
//               Factor := QtyToBeInvoicedBase / "Qty. to Invoice (Base)"
//             ELSE
//               Factor := QtyToBeInvoiced / "Qty. to Invoice";
//             ItemJnlLine.Amount := Amount * Factor + RemAmt;
//             IF PurchHeader."Prices Including VAT" THEN
//               ItemJnlLine."Discount Amount" :=
//                 ("Line Discount Amount" + "Inv. Discount Amount") / (1 + "VAT %" / 100) * Factor + RemDiscAmt
//             ELSE
//               ItemJnlLine."Discount Amount" :=
//                 ("Line Discount Amount" + "Inv. Discount Amount") * Factor + RemDiscAmt;
//             RemAmt := ItemJnlLine.Amount - ROUND(ItemJnlLine.Amount);
//             RemDiscAmt := ItemJnlLine."Discount Amount" - ROUND(ItemJnlLine."Discount Amount");
//             ItemJnlLine.Amount := ROUND(ItemJnlLine.Amount);
//             ItemJnlLine."Discount Amount" := ROUND(ItemJnlLine."Discount Amount");
//           END ELSE BEGIN
//             IF PurchHeader."Prices Including VAT" THEN
//               ItemJnlLine.Amount :=
//                 (QtyToBeReceived * "Direct Unit Cost" * (1 - "Line Discount %" / 100) / (1 + "VAT %" / 100)) + RemAmt
//             ELSE
//               ItemJnlLine.Amount :=
//                 (QtyToBeReceived * "Direct Unit Cost" * (1 - "Line Discount %" / 100)) + RemAmt;
//             RemAmt := ItemJnlLine.Amount - ROUND(ItemJnlLine.Amount);
//             IF PurchHeader."Currency Code" <> '' THEN
//               ItemJnlLine.Amount :=
//                 ROUND(
//                   CurrExchRate.ExchangeAmtFCYToLCY(
//                     PurchHeader."Posting Date",PurchHeader."Currency Code",
//                     ItemJnlLine.Amount,PurchHeader."Currency Factor"))
//             ELSE
//               ItemJnlLine.Amount := ROUND(ItemJnlLine.Amount);
//           END;

//           ItemJnlLine."Source Type" := ItemJnlLine."Source Type"::Vendor;
//           ItemJnlLine."Source No." := "Buy-from Vendor No.";
//           ItemJnlLine."Invoice-to Source No." := "Pay-to Vendor No.";
//           ItemJnlLine."Source Code" := SrcCode;
//           ItemJnlLine."Purchasing Code" := "Purchasing Code";

//           IF "Prod. Order No." <> '' THEN BEGIN
//             ItemJnlLine.Subcontracting := TRUE;
//             ItemJnlLine."Quantity (Base)" := CalcBaseQty("No.","Unit of Measure Code",QtyToBeReceived);
//             ItemJnlLine."Invoiced Qty. (Base)" := CalcBaseQty("No.","Unit of Measure Code",QtyToBeInvoiced);
//             ItemJnlLine."Unit Cost" := "Unit Cost (LCY)";
//             ItemJnlLine."Unit Cost (ACY)" := "Unit Cost";
//             ItemJnlLine."Output Quantity (Base)" := ItemJnlLine."Quantity (Base)";
//             ItemJnlLine."Output Quantity" := QtyToBeReceived;
//             ItemJnlLine."Entry Type" := ItemJnlLine."Entry Type"::Output;
//             ItemJnlLine.Type := ItemJnlLine.Type::"Work Center";
//             ItemJnlLine."No." := "Work Center No.";
//             ItemJnlLine."Routing No." := "Routing No.";
//             ItemJnlLine."Routing Reference No." := "Routing Reference No.";
//             ItemJnlLine."Operation No." := "Operation No.";
//             ItemJnlLine."Work Center No." := "Work Center No.";
//             ItemJnlLine."Unit Cost Calculation" := ItemJnlLine."Unit Cost Calculation"::Units;
//             IF Finished THEN
//               ItemJnlLine.Finished := Finished;
//           END;

//           ItemJnlLine."Item Shpt. Entry No." := ItemLedgShptEntryNo;
//           ItemJnlLine."Indirect Cost %" := "Indirect Cost %";
//           ItemJnlLine."Overhead Rate" := "Overhead Rate";
//           ItemJnlLine."Return Reason Code" := "Return Reason Code";

//           CheckApplToItemEntry :=
//             PurchSetup."Exact Cost Reversing Mandatory" AND
//             (Type = Type::Item) AND
//             (((Quantity < 0) AND ("Document Type" IN ["Document Type"::Order,"Document Type"::Invoice])) OR
//              ((Quantity > 0) AND ("Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"]))) AND
//             ("Job No." = '');

//           IF ("Location Code" <> '') AND
//              (Type = Type::Item) AND
//              (ItemJnlLine.Quantity <> 0) AND
//              NOT ItemJnlLine.Subcontracting
//           THEN BEGIN
//             GetLocation("Location Code");
//             IF (("Document Type" IN ["Document Type"::Invoice,"Document Type"::"Credit Memo"]) AND
//                 Location."Directed Put-away and Pick") OR
//                (Location."Bin Mandatory" AND NOT (WhseReceive OR WhseShip OR InvtPickPutaway OR "Drop Shipment"))
//             THEN BEGIN
//               CreateWhseJnlLine(ItemJnlLine,PurchLine,TempWhseJnlLine);
//               PostWhseJnlLine := TRUE;
//             END;
//           END;
//           ReservationEntry3.DELETEALL;
//           CLEAR(ItemJnlLine2);
//           ItemJnlLine2 := ItemJnlLine;

//           IF "Job No." <> '' THEN BEGIN
//             ReservePurchLine2.FindReservEntry(PurchLine,ReservationEntry2);
//             IF ReservationEntry2.FIND('-') THEN
//               REPEAT
//                 ReservationEntry3 := ReservationEntry2;
//                 ReservationEntry3.INSERT;
//               UNTIL ReservationEntry2.NEXT = 0;
//           END;

//           IF QtyToBeReceivedBase <> 0 THEN BEGIN
//             IF "Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"] THEN
//               ReservePurchLine.TransferPurchLineToItemJnlLine(
//                 PurchLine,ItemJnlLine,-QtyToBeReceivedBase,CheckApplToItemEntry)
//             ELSE
//               ReservePurchLine.TransferPurchLineToItemJnlLine(
//                 PurchLine,ItemJnlLine,QtyToBeReceivedBase,CheckApplToItemEntry);

//             IF CheckApplToItemEntry THEN
//               TESTFIELD("Appl.-to Item Entry");
//           END;

//           OriginalItemJnlLine := ItemJnlLine;

//           IF "Job No." <> '' THEN BEGIN
//             PostJobConsumptionBeforePurch :=
//               (ItemJnlLine."Document Type" = ItemJnlLine."Document Type"::"Purchase Return Shipment") AND (ItemJnlLine.Quantity < 0);
//             IF PostJobConsumptionBeforePurch THEN
//               PostItemJrnlLineJobConsumption(PurchLine,
//                 NextReservationEntryNo,
//                 QtyToBeInvoiced,
//                 QtyToBeInvoicedBase,
//                 QtyToBeReceived,
//                 QtyToBeReceivedBase,
//                 CheckApplToItemEntry);
//           END;

//           ItemJnlPostLine.RunWithCheck(ItemJnlLine);

//           IF ItemJnlPostLine.CollectTrackingSpecification(TempHandlingSpecification) THEN BEGIN
//             IF ItemJnlLine.Subcontracting THEN
//               TempHandlingSpecification.DELETEALL;
//             IF TempHandlingSpecification.FIND('-') THEN
//               REPEAT
//                 TempTrackingSpecification := TempHandlingSpecification;
//                 TempTrackingSpecification."Source Type" := DATABASE::"Purchase Line";
//                 TempTrackingSpecification."Source Subtype" := "Document Type";
//                 TempTrackingSpecification."Source ID" := "Document No.";
//                 TempTrackingSpecification."Source Batch Name" := '';
//                 TempTrackingSpecification."Source Prod. Order Line" := 0;
//                 TempTrackingSpecification."Source Ref. No." := "Line No.";
//                 IF TempTrackingSpecification.INSERT THEN;
//                 IF QtyToBeInvoiced <> 0 THEN BEGIN
//                   TempTrackingSpecificationInv := TempTrackingSpecification;
//                   IF TempTrackingSpecificationInv.INSERT THEN;
//                 END;
//                 IF PostWhseJnlLine THEN BEGIN
//                   TempWhseTrackingSpecification := TempTrackingSpecification;
//                   IF TempWhseTrackingSpecification.INSERT THEN;
//                 END;
//               UNTIL TempHandlingSpecification.NEXT = 0;
//           END;

//           IF "Job No." <> '' THEN
//             IF NOT PostJobConsumptionBeforePurch THEN
//               PostItemJrnlLineJobConsumption(PurchLine,
//                 NextReservationEntryNo,
//                 QtyToBeInvoiced,
//                 QtyToBeInvoicedBase,
//                 QtyToBeReceived,
//                 QtyToBeReceivedBase,
//                 CheckApplToItemEntry);

//           IF PostWhseJnlLine THEN BEGIN
//             ItemTrackingMgt.SplitWhseJnlLine(TempWhseJnlLine,TempWhseJnlLine2,TempWhseTrackingSpecification,FALSE);
//             IF TempWhseJnlLine2.FIND('-') THEN
//               REPEAT
//                 IF "Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"] THEN
//                   CreatePositiveEntry(TempWhseJnlLine2,"Job No.",PostJobConsumptionBeforePurch);
//                 WhseJnlPostLine.RUN(TempWhseJnlLine2);
//                 IF RevertWarehouseEntry(TempWhseJnlLine2,"Job No.",PostJobConsumptionBeforePurch) THEN
//                   WhseJnlPostLine.RUN(TempWhseJnlLine2);
//               UNTIL TempWhseJnlLine2.NEXT = 0;
//             TempWhseTrackingSpecification.DELETEALL;
//           END;

//           IF (Type = Type::Item) AND PurchHeader.Invoice THEN BEGIN
//             ClearItemChargeAssgntFilter;
//             TempItemChargeAssgntPurch.SETCURRENTKEY(
//               "Applies-to Doc. Type","Applies-to Doc. No.","Applies-to Doc. Line No.");
//             TempItemChargeAssgntPurch.SETRANGE("Applies-to Doc. Type","Document Type");
//             TempItemChargeAssgntPurch.SETRANGE("Applies-to Doc. No.","Document No.");
//             TempItemChargeAssgntPurch.SETRANGE("Applies-to Doc. Line No.","Line No.");
//             IF TempItemChargeAssgntPurch.FIND('-') THEN
//               REPEAT
//                 TESTFIELD("Allow Item Charge Assignment");
//                 GetItemChargeLine(ItemChargePurchLine);
//                 ItemChargePurchLine.CALCFIELDS("Qty. Assigned");
//                 IF (ItemChargePurchLine."Qty. to Invoice" <> 0) OR
//                    (ABS(ItemChargePurchLine."Qty. Assigned") < ABS(ItemChargePurchLine."Quantity Invoiced"))
//                 THEN BEGIN
//                   OriginalItemJnlLine."Item Shpt. Entry No." := ItemJnlLine."Item Shpt. Entry No.";
//                   PostItemChargePerOrder(OriginalItemJnlLine,ItemChargePurchLine);
//                   TempItemChargeAssgntPurch.MARK(TRUE);
//                 END;
//               UNTIL TempItemChargeAssgntPurch.NEXT = 0;
//           END;
//         END;

//         EXIT(ItemJnlLine."Item Shpt. Entry No.");
//     end;

//     local procedure PostItemChargePerOrder(ItemJnlLine2: Record "83";ItemChargePurchLine: Record "39")
//     var
//         NonDistrItemJnlLine: Record "83";
//         OriginalAmt: Decimal;
//         OriginalAmtACY: Decimal;
//         OriginalDiscountAmt: Decimal;
//         OriginalQty: Decimal;
//         QtyToInvoice: Decimal;
//         Factor: Decimal;
//         SignFactor: Integer;
//     begin
//         WITH TempItemChargeAssgntPurch DO BEGIN
//           PurchLine.TESTFIELD("Allow Item Charge Assignment",TRUE);
//           ItemJnlLine2."Document No." := GenJnlLineDocNo;
//           ItemJnlLine2."External Document No." := GenJnlLineExtDocNo;
//           ItemJnlLine2."Item Charge No." := "Item Charge No.";
//           ItemJnlLine2.Description := ItemChargePurchLine.Description;
//           ItemJnlLine2."Document Line No." := ItemChargePurchLine."Line No.";
//           ItemJnlLine2."Unit of Measure Code" := '';
//           ItemJnlLine2."Qty. per Unit of Measure" := 1;
//           IF "Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"] THEN
//             QtyToInvoice :=
//               CalcQtyToInvoice(PurchLine."Return Qty. to Ship (Base)",PurchLine."Qty. to Invoice (Base)")
//           ELSE
//             QtyToInvoice :=
//               CalcQtyToInvoice(PurchLine."Qty. to Receive (Base)",PurchLine."Qty. to Invoice (Base)");
//           IF ItemJnlLine2."Invoiced Quantity" = 0 THEN BEGIN
//             ItemJnlLine2."Invoiced Quantity" := ItemJnlLine2.Quantity;
//             ItemJnlLine2."Invoiced Qty. (Base)" := ItemJnlLine2."Quantity (Base)";
//           END;
//           ItemJnlLine2.Amount := "Amount to Assign" * ItemJnlLine2."Invoiced Qty. (Base)" / QtyToInvoice;
//           IF "Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"] THEN
//             ItemJnlLine2.Amount := -ItemJnlLine2.Amount;
//           ItemJnlLine2."Unit Cost (ACY)" :=
//             ROUND(
//               ItemJnlLine2.Amount / ItemJnlLine2."Invoiced Qty. (Base)",
//               Currency."Unit-Amount Rounding Precision");

//           TotalChargeAmt2 := TotalChargeAmt2 + ItemJnlLine2.Amount;
//           IF PurchHeader."Currency Code" <> '' THEN BEGIN
//             ItemJnlLine2.Amount :=
//               CurrExchRate.ExchangeAmtFCYToLCY(
//                 Usedate,PurchHeader."Currency Code",TotalChargeAmt2 + TotalPurchLine.Amount,PurchHeader."Currency Factor") -
//               TotalChargeAmtLCY2 - TotalPurchLineLCY.Amount;
//           END ELSE
//             ItemJnlLine2.Amount := TotalChargeAmt2 - TotalChargeAmtLCY2;

//           ItemJnlLine2.Amount := ROUND(ItemJnlLine2.Amount);
//           TotalChargeAmtLCY2 := TotalChargeAmtLCY2 + ItemJnlLine2.Amount;
//           ItemJnlLine2."Unit Cost" := ROUND(
//               ItemJnlLine2.Amount / ItemJnlLine2."Invoiced Qty. (Base)",GLSetup."Unit-Amount Rounding Precision");
//           ItemJnlLine2."Applies-to Entry" := ItemJnlLine2."Item Shpt. Entry No.";
//           ItemJnlLine2."Overhead Rate" := 0;

//           IF PurchHeader."Currency Code" <> '' THEN
//             ItemJnlLine2."Discount Amount" := ROUND(
//                 CurrExchRate.ExchangeAmtFCYToLCY(
//                   Usedate,PurchHeader."Currency Code",(ItemChargePurchLine."Inv. Discount Amount" +
//                                                        ItemChargePurchLine."Line Discount Amount") *
//                   ItemJnlLine2."Invoiced Qty. (Base)" /
//                   ItemChargePurchLine."Quantity (Base)" * "Qty. to Assign" / QtyToInvoice,
//                   PurchHeader."Currency Factor"),GLSetup."Amount Rounding Precision")
//           ELSE
//             ItemJnlLine2."Discount Amount" := ROUND(
//                 (ItemChargePurchLine."Line Discount Amount" + ItemChargePurchLine."Inv. Discount Amount") *
//                 ItemJnlLine2."Invoiced Qty. (Base)" /
//                 ItemChargePurchLine."Quantity (Base)" * "Qty. to Assign" / QtyToInvoice,
//                 GLSetup."Amount Rounding Precision");

//           ItemJnlLine2."Shortcut Dimension 1 Code" := ItemChargePurchLine."Shortcut Dimension 1 Code";
//           ItemJnlLine2."Shortcut Dimension 2 Code" := ItemChargePurchLine."Shortcut Dimension 2 Code";
//           ItemJnlLine2."Dimension Set ID" := ItemChargePurchLine."Dimension Set ID";
//           ItemJnlLine2."Gen. Prod. Posting Group" := ItemChargePurchLine."Gen. Prod. Posting Group";
//         END;

//         WITH TempTrackingSpecificationInv DO BEGIN
//           RESET;
//           SETRANGE("Source Type",DATABASE::"Purchase Line");
//           SETRANGE("Source ID",TempItemChargeAssgntPurch."Applies-to Doc. No.");
//           SETRANGE("Source Ref. No.",TempItemChargeAssgntPurch ."Applies-to Doc. Line No.");
//           IF ISEMPTY THEN
//             ItemJnlPostLine.RunWithCheck(ItemJnlLine2)
//           ELSE BEGIN
//             FINDSET;
//             NonDistrItemJnlLine := ItemJnlLine2;
//             OriginalAmt := NonDistrItemJnlLine.Amount;
//             OriginalAmtACY := NonDistrItemJnlLine."Amount (ACY)";
//             OriginalDiscountAmt := NonDistrItemJnlLine."Discount Amount";
//             OriginalQty := NonDistrItemJnlLine."Quantity (Base)";
//             IF ("Quantity (Base)" / OriginalQty) > 0 THEN
//               SignFactor := 1
//             ELSE
//               SignFactor := -1;
//             REPEAT
//               Factor := "Quantity (Base)" / OriginalQty * SignFactor;
//               IF ABS("Quantity (Base)") < ABS(NonDistrItemJnlLine."Quantity (Base)") THEN BEGIN
//                 ItemJnlLine2."Quantity (Base)" := "Quantity (Base)";
//                 ItemJnlLine2."Invoiced Qty. (Base)" := ItemJnlLine2."Quantity (Base)";
//                 ItemJnlLine2."Amount (ACY)" :=
//                   ROUND(OriginalAmtACY * Factor,GLSetup."Amount Rounding Precision");
//                 ItemJnlLine2.Amount :=
//                   ROUND(OriginalAmt * Factor,GLSetup."Amount Rounding Precision");
//                 ItemJnlLine2."Unit Cost (ACY)" :=
//                   ROUND(ItemJnlLine2.Amount / ItemJnlLine2."Invoiced Qty. (Base)",
//                     Currency."Unit-Amount Rounding Precision") * SignFactor;
//                 ItemJnlLine2."Unit Cost" :=
//                   ROUND(ItemJnlLine2.Amount / ItemJnlLine2."Invoiced Qty. (Base)",
//                     GLSetup."Unit-Amount Rounding Precision") * SignFactor;
//                 ItemJnlLine2."Discount Amount" :=
//                   ROUND(OriginalDiscountAmt * Factor,GLSetup."Amount Rounding Precision");
//                 ItemJnlLine2."Item Shpt. Entry No." := "Item Ledger Entry No.";
//                 ItemJnlLine2."Applies-to Entry" := "Item Ledger Entry No.";
//                 ItemJnlLine2."Lot No." := "Lot No.";
//                 ItemJnlLine2."Serial No." := "Serial No.";
//                 ItemJnlPostLine.RunWithCheck(ItemJnlLine2);
//                 ItemJnlLine2."Location Code" := NonDistrItemJnlLine."Location Code";
//                 NonDistrItemJnlLine."Quantity (Base)" -= "Quantity (Base)";
//                 NonDistrItemJnlLine.Amount -= (ItemJnlLine2.Amount * SignFactor);
//                 NonDistrItemJnlLine."Amount (ACY)" -= (ItemJnlLine2."Amount (ACY)" * SignFactor);
//                 NonDistrItemJnlLine."Discount Amount" -= (ItemJnlLine2."Discount Amount" * SignFactor);
//               END ELSE BEGIN
//                 NonDistrItemJnlLine."Quantity (Base)" := "Quantity (Base)";
//                 NonDistrItemJnlLine."Invoiced Qty. (Base)" := "Quantity (Base)";
//                 NonDistrItemJnlLine."Unit Cost" :=
//                   ROUND(NonDistrItemJnlLine.Amount / NonDistrItemJnlLine."Invoiced Qty. (Base)",
//                     GLSetup."Unit-Amount Rounding Precision") * SignFactor;
//                 NonDistrItemJnlLine."Unit Cost (ACY)" :=
//                   ROUND(NonDistrItemJnlLine.Amount / NonDistrItemJnlLine."Invoiced Qty. (Base)",
//                     Currency."Unit-Amount Rounding Precision") * SignFactor;
//                 NonDistrItemJnlLine."Item Shpt. Entry No." := "Item Ledger Entry No.";
//                 NonDistrItemJnlLine."Applies-to Entry" := "Item Ledger Entry No.";
//                 NonDistrItemJnlLine."Lot No." := "Lot No.";
//                 NonDistrItemJnlLine."Serial No." := "Serial No.";
//                 ItemJnlPostLine.RunWithCheck(NonDistrItemJnlLine);
//                 NonDistrItemJnlLine."Location Code" := ItemJnlLine2."Location Code";
//               END;
//             UNTIL NEXT = 0;
//           END;
//         END;
//     end;

//     local procedure PostItemChargePerRcpt(var PurchLine: Record "39")
//     var
//         PurchRcptLine: Record "121";
//         TempItemLedgEntry: Record "32" temporary;
//         ItemTrackingMgt: Codeunit "6500";
//         Factor: Decimal;
//         NonDistrQuantity: Decimal;
//         NonDistrQtyToAssign: Decimal;
//         NonDistrAmountToAssign: Decimal;
//         QtyToAssign: Decimal;
//         AmountToAssign: Decimal;
//         Sign: Decimal;
//         DistributeCharge: Boolean;
//     begin
//         IF NOT PurchRcptLine.GET(
//              TempItemChargeAssgntPurch."Applies-to Doc. No.",TempItemChargeAssgntPurch."Applies-to Doc. Line No.")
//         THEN
//           ERROR(Text014);
//         IF PurchRcptLine."Quantity (Base)" > 0 THEN
//           Sign := 1
//         ELSE
//           Sign := -1;

//         IF PurchRcptLine."Item Rcpt. Entry No." <> 0 THEN
//           DistributeCharge :=
//             CostCalcMgt.SplitItemLedgerEntriesExist(
//               TempItemLedgEntry,PurchRcptLine."Quantity (Base)",PurchRcptLine."Item Rcpt. Entry No.")
//         ELSE BEGIN
//           DistributeCharge := TRUE;
//           ItemTrackingMgt.CollectItemEntryRelation(TempItemLedgEntry,
//             DATABASE::"Purch. Rcpt. Line",0,PurchRcptLine."Document No.",
//             '',0,PurchRcptLine."Line No.",PurchRcptLine."Quantity (Base)");
//         END;

//         IF DistributeCharge THEN
//           IF TempItemLedgEntry.FINDSET THEN BEGIN
//             NonDistrQuantity := PurchRcptLine."Quantity (Base)";
//             NonDistrQtyToAssign := TempItemChargeAssgntPurch."Qty. to Assign";
//             NonDistrAmountToAssign := TempItemChargeAssgntPurch."Amount to Assign";
//             REPEAT
//               Factor := TempItemLedgEntry.Quantity / NonDistrQuantity;
//               QtyToAssign := NonDistrQtyToAssign * Factor;
//               AmountToAssign := ROUND(NonDistrAmountToAssign * Factor,GLSetup."Amount Rounding Precision");
//               IF Factor < 1 THEN BEGIN
//                 PostItemCharge(PurchLine,
//                   TempItemLedgEntry."Entry No.",TempItemLedgEntry.Quantity,
//                   AmountToAssign * Sign,QtyToAssign,PurchRcptLine."Indirect Cost %");
//                 NonDistrQuantity := NonDistrQuantity - TempItemLedgEntry.Quantity;
//                 NonDistrQtyToAssign := NonDistrQtyToAssign - QtyToAssign;
//                 NonDistrAmountToAssign := NonDistrAmountToAssign - AmountToAssign;
//               END ELSE // the last time
//                 PostItemCharge(PurchLine,
//                   TempItemLedgEntry."Entry No.",TempItemLedgEntry.Quantity,
//                   NonDistrAmountToAssign * Sign,NonDistrQtyToAssign,PurchRcptLine."Indirect Cost %");
//             UNTIL TempItemLedgEntry.NEXT = 0;
//           END ELSE
//             ERROR(Text042)
//         ELSE
//           PostItemCharge(PurchLine,
//             PurchRcptLine."Item Rcpt. Entry No.",PurchRcptLine."Quantity (Base)",
//             TempItemChargeAssgntPurch."Amount to Assign" * Sign,
//             TempItemChargeAssgntPurch."Qty. to Assign",
//             PurchRcptLine."Indirect Cost %");
//     end;

//     local procedure PostItemChargePerRetShpt(var PurchLine: Record "39")
//     var
//         ReturnShptLine: Record "6651";
//         TempItemLedgEntry: Record "32" temporary;
//         ItemTrackingMgt: Codeunit "6500";
//         Factor: Decimal;
//         NonDistrQuantity: Decimal;
//         NonDistrQtyToAssign: Decimal;
//         NonDistrAmountToAssign: Decimal;
//         QtyToAssign: Decimal;
//         AmountToAssign: Decimal;
//         Sign: Decimal;
//         DistributeCharge: Boolean;
//     begin
//         ReturnShptLine.GET(
//           TempItemChargeAssgntPurch."Applies-to Doc. No.",TempItemChargeAssgntPurch."Applies-to Doc. Line No.");
//         ReturnShptLine.TESTFIELD("Job No.",'');
//         CASE PurchLine."Document Type" OF
//           PurchLine."Document Type"::"Return Order",PurchLine."Document Type"::"Credit Memo":
//             IF PurchLine."Line Amount" > 0 THEN
//               Sign := -1
//             ELSE
//               Sign := 1;
//           PurchLine."Document Type"::Order,PurchLine."Document Type"::Invoice:
//             IF PurchLine."Line Amount" > 0 THEN
//               Sign := 1
//             ELSE
//               Sign := -1;
//         END;

//         IF ReturnShptLine."Item Shpt. Entry No." <> 0 THEN
//           DistributeCharge :=
//             CostCalcMgt.SplitItemLedgerEntriesExist(
//               TempItemLedgEntry,-ReturnShptLine."Quantity (Base)",ReturnShptLine."Item Shpt. Entry No.")
//         ELSE BEGIN
//           DistributeCharge := TRUE;
//           ItemTrackingMgt.CollectItemEntryRelation(TempItemLedgEntry,
//             DATABASE::"Return Shipment Line",0,ReturnShptLine."Document No.",
//             '',0,ReturnShptLine."Line No.",ReturnShptLine."Quantity (Base)");
//         END;

//         IF DistributeCharge THEN
//           IF TempItemLedgEntry.FINDSET THEN BEGIN
//             NonDistrQuantity := -ReturnShptLine."Quantity (Base)";
//             NonDistrQtyToAssign := TempItemChargeAssgntPurch."Qty. to Assign";
//             NonDistrAmountToAssign := ABS(TempItemChargeAssgntPurch."Amount to Assign");
//             REPEAT
//               Factor := TempItemLedgEntry.Quantity / NonDistrQuantity;
//               QtyToAssign := NonDistrQtyToAssign * Factor;
//               AmountToAssign := ROUND(NonDistrAmountToAssign * Factor,GLSetup."Amount Rounding Precision");
//               IF Factor < 1 THEN BEGIN
//                 PostItemCharge(PurchLine,
//                   TempItemLedgEntry."Entry No.",TempItemLedgEntry.Quantity,
//                   AmountToAssign * Sign,QtyToAssign,ReturnShptLine."Indirect Cost %");
//                 NonDistrQuantity := NonDistrQuantity - TempItemLedgEntry.Quantity;
//                 NonDistrQtyToAssign := NonDistrQtyToAssign - QtyToAssign;
//                 NonDistrAmountToAssign := NonDistrAmountToAssign - AmountToAssign;
//               END ELSE // the last time
//                 PostItemCharge(PurchLine,
//                   TempItemLedgEntry."Entry No.",TempItemLedgEntry.Quantity,
//                   NonDistrAmountToAssign * Sign,NonDistrQtyToAssign,ReturnShptLine."Indirect Cost %");
//             UNTIL TempItemLedgEntry.NEXT = 0;
//           END ELSE
//             ERROR(Text042)
//         ELSE
//           PostItemCharge(PurchLine,
//             ReturnShptLine."Item Shpt. Entry No.",-ReturnShptLine."Quantity (Base)",
//             ABS(TempItemChargeAssgntPurch."Amount to Assign") * Sign,
//             TempItemChargeAssgntPurch."Qty. to Assign",
//             ReturnShptLine."Indirect Cost %");
//     end;

//     local procedure PostItemChargePerTransfer(var PurchLine: Record "39")
//     var
//         TransRcptLine: Record "5747";
//         ItemApplnEntry: Record "339";
//         DummyTrackingSpecification: Record "336";
//         PurchLine2: Record "39";
//         TotalAmountToPostFCY: Decimal;
//         TotalAmountToPostLCY: Decimal;
//         TotalDiscAmountToPost: Decimal;
//         AmountToPostFCY: Decimal;
//         AmountToPostLCY: Decimal;
//         DiscAmountToPost: Decimal;
//         RemAmountToPostFCY: Decimal;
//         RemAmountToPostLCY: Decimal;
//         RemDiscAmountToPost: Decimal;
//         CalcAmountToPostFCY: Decimal;
//         CalcAmountToPostLCY: Decimal;
//         CalcDiscAmountToPost: Decimal;
//     begin
//         WITH TempItemChargeAssgntPurch DO BEGIN
//           TransRcptLine.GET("Applies-to Doc. No.","Applies-to Doc. Line No.");
//           PurchLine2 := PurchLine;
//           PurchLine2."No." := "Item No.";
//           PurchLine2."Variant Code" := TransRcptLine."Variant Code";
//           PurchLine2."Location Code" := TransRcptLine."Transfer-to Code";
//           PurchLine2."Bin Code" := '';
//           PurchLine2."Line No." := "Document Line No.";

//           IF TransRcptLine."Item Rcpt. Entry No." = 0 THEN
//             PostItemChargePerITTransfer(PurchLine,TransRcptLine)
//           ELSE BEGIN
//             TotalAmountToPostFCY := "Amount to Assign";
//             IF PurchHeader."Currency Code" <> '' THEN
//               TotalAmountToPostLCY :=
//                 CurrExchRate.ExchangeAmtFCYToLCY(
//                   Usedate,PurchHeader."Currency Code",
//                   TotalAmountToPostFCY,PurchHeader."Currency Factor")
//             ELSE
//               TotalAmountToPostLCY := TotalAmountToPostFCY;

//             TotalDiscAmountToPost :=
//               ROUND(
//                 PurchLine2."Inv. Discount Amount" / PurchLine2.Quantity * "Qty. to Assign",
//                 GLSetup."Amount Rounding Precision");
//             TotalDiscAmountToPost :=
//               TotalDiscAmountToPost +
//               ROUND(
//                 PurchLine2."Line Discount Amount" * ("Qty. to Assign" / PurchLine2."Qty. to Invoice"),
//                 GLSetup."Amount Rounding Precision");

//             TotalAmountToPostLCY := ROUND(TotalAmountToPostLCY,GLSetup."Amount Rounding Precision");

//             ItemApplnEntry.SETCURRENTKEY("Outbound Item Entry No.","Item Ledger Entry No.","Cost Application");
//             ItemApplnEntry.SETRANGE("Outbound Item Entry No.",TransRcptLine."Item Rcpt. Entry No.");
//             ItemApplnEntry.SETFILTER("Item Ledger Entry No.",'<>%1',TransRcptLine."Item Rcpt. Entry No.");
//             ItemApplnEntry.SETRANGE("Cost Application",TRUE);
//             IF ItemApplnEntry.FINDSET THEN
//               REPEAT
//                 PurchLine2."Appl.-to Item Entry" := ItemApplnEntry."Item Ledger Entry No.";
//                 CalcAmountToPostFCY :=
//                   ((TotalAmountToPostFCY / TransRcptLine."Quantity (Base)") * ItemApplnEntry.Quantity) +
//                   RemAmountToPostFCY;
//                 AmountToPostFCY := ROUND(CalcAmountToPostFCY);
//                 RemAmountToPostFCY := CalcAmountToPostFCY - AmountToPostFCY;
//                 CalcAmountToPostLCY :=
//                   ((TotalAmountToPostLCY / TransRcptLine."Quantity (Base)") * ItemApplnEntry.Quantity) +
//                   RemAmountToPostLCY;
//                 AmountToPostLCY := ROUND(CalcAmountToPostLCY);
//                 RemAmountToPostLCY := CalcAmountToPostLCY - AmountToPostLCY;
//                 CalcDiscAmountToPost :=
//                   ((TotalDiscAmountToPost / TransRcptLine."Quantity (Base)") * ItemApplnEntry.Quantity) +
//                   RemDiscAmountToPost;
//                 DiscAmountToPost := ROUND(CalcDiscAmountToPost);
//                 RemDiscAmountToPost := CalcDiscAmountToPost - DiscAmountToPost;
//                 PurchLine2.Amount := AmountToPostLCY;
//                 PurchLine2."Inv. Discount Amount" := DiscAmountToPost;
//                 PurchLine2."Line Discount Amount" := 0;
//                 PurchLine2."Unit Cost" :=
//                   ROUND(AmountToPostFCY / ItemApplnEntry.Quantity,GLSetup."Unit-Amount Rounding Precision");
//                 PurchLine2."Unit Cost (LCY)" :=
//                   ROUND(AmountToPostLCY / ItemApplnEntry.Quantity,GLSetup."Unit-Amount Rounding Precision");
//                 IF "Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"] THEN
//                   PurchLine2.Amount := -PurchLine2.Amount;
//                 PostItemJnlLine(
//                   PurchLine2,
//                   0,0,
//                   ItemApplnEntry.Quantity,ItemApplnEntry.Quantity,
//                   PurchLine2."Appl.-to Item Entry","Item Charge No.",DummyTrackingSpecification);
//               UNTIL ItemApplnEntry.NEXT = 0;
//           END;
//         END;
//     end;

//     local procedure PostItemChargePerITTransfer(var PurchLine: Record "39";TransRcptLine: Record "5747")
//     var
//         TempItemLedgEntry: Record "32" temporary;
//         ItemTrackingMgt: Codeunit "6500";
//         Factor: Decimal;
//         NonDistrQuantity: Decimal;
//         NonDistrQtyToAssign: Decimal;
//         NonDistrAmountToAssign: Decimal;
//         QtyToAssign: Decimal;
//         AmountToAssign: Decimal;
//     begin
//         WITH TempItemChargeAssgntPurch DO BEGIN
//           ItemTrackingMgt.CollectItemEntryRelation(TempItemLedgEntry,
//             DATABASE::"Transfer Receipt Line",0,TransRcptLine."Document No.",
//             '',0,TransRcptLine."Line No.",TransRcptLine."Quantity (Base)");
//           IF TempItemLedgEntry.FINDSET THEN BEGIN
//             NonDistrQuantity := TransRcptLine."Quantity (Base)";
//             NonDistrQtyToAssign := "Qty. to Assign";
//             NonDistrAmountToAssign := "Amount to Assign";
//             REPEAT
//               Factor := TempItemLedgEntry.Quantity / NonDistrQuantity;
//               QtyToAssign := NonDistrQtyToAssign * Factor;
//               AmountToAssign := ROUND(NonDistrAmountToAssign * Factor,GLSetup."Amount Rounding Precision");
//               IF Factor < 1 THEN BEGIN
//                 PostItemCharge(PurchLine,
//                   TempItemLedgEntry."Entry No.",TempItemLedgEntry.Quantity,
//                   AmountToAssign,QtyToAssign,0);
//                 NonDistrQuantity := NonDistrQuantity - TempItemLedgEntry.Quantity;
//                 NonDistrQtyToAssign := NonDistrQtyToAssign - QtyToAssign;
//                 NonDistrAmountToAssign := NonDistrAmountToAssign - AmountToAssign;
//               END ELSE // the last time
//                 PostItemCharge(PurchLine,
//                   TempItemLedgEntry."Entry No.",TempItemLedgEntry.Quantity,
//                   NonDistrAmountToAssign,NonDistrQtyToAssign,0);
//             UNTIL TempItemLedgEntry.NEXT = 0;
//           END ELSE
//             ERROR(Text042);
//         END;
//     end;

//     local procedure PostItemChargePerSalesShpt(var PurchLine: Record "39")
//     var
//         SalesShptLine: Record "111";
//         TempItemLedgEntry: Record "32" temporary;
//         ItemTrackingMgt: Codeunit "6500";
//         Factor: Decimal;
//         NonDistrQuantity: Decimal;
//         NonDistrQtyToAssign: Decimal;
//         NonDistrAmountToAssign: Decimal;
//         QtyToAssign: Decimal;
//         AmountToAssign: Decimal;
//         Sign: Decimal;
//         DistributeCharge: Boolean;
//     begin
//         IF NOT SalesShptLine.GET(
//              TempItemChargeAssgntPurch."Applies-to Doc. No.",TempItemChargeAssgntPurch."Applies-to Doc. Line No.")
//         THEN
//           ERROR(Text042);
//         SalesShptLine.TESTFIELD("Job No.",'');
//         IF SalesShptLine."Quantity (Base)" < 0 THEN
//           Sign := -1
//         ELSE
//           Sign := 1;

//         IF SalesShptLine."Item Shpt. Entry No." <> 0 THEN
//           DistributeCharge :=
//             CostCalcMgt.SplitItemLedgerEntriesExist(
//               TempItemLedgEntry,-SalesShptLine."Quantity (Base)",SalesShptLine."Item Shpt. Entry No.")
//         ELSE BEGIN
//           DistributeCharge := TRUE;
//           ItemTrackingMgt.CollectItemEntryRelation(TempItemLedgEntry,
//             DATABASE::"Sales Shipment Line",0,SalesShptLine."Document No.",
//             '',0,SalesShptLine."Line No.",SalesShptLine."Quantity (Base)");
//         END;

//         IF DistributeCharge THEN
//           IF TempItemLedgEntry.FINDSET THEN BEGIN
//             NonDistrQuantity := -SalesShptLine."Quantity (Base)";
//             NonDistrQtyToAssign := TempItemChargeAssgntPurch."Qty. to Assign";
//             NonDistrAmountToAssign := TempItemChargeAssgntPurch."Amount to Assign";
//             REPEAT
//               Factor := TempItemLedgEntry.Quantity / NonDistrQuantity;
//               QtyToAssign := NonDistrQtyToAssign * Factor;
//               AmountToAssign := ROUND(NonDistrAmountToAssign * Factor,GLSetup."Amount Rounding Precision");
//               IF Factor < 1 THEN BEGIN
//                 PostItemCharge(PurchLine,
//                   TempItemLedgEntry."Entry No.",TempItemLedgEntry.Quantity,
//                   AmountToAssign * Sign,QtyToAssign,0);
//                 NonDistrQuantity := NonDistrQuantity - TempItemLedgEntry.Quantity;
//                 NonDistrQtyToAssign := NonDistrQtyToAssign - QtyToAssign;
//                 NonDistrAmountToAssign := NonDistrAmountToAssign - AmountToAssign;
//               END ELSE // the last time
//                 PostItemCharge(PurchLine,
//                   TempItemLedgEntry."Entry No.",TempItemLedgEntry.Quantity,
//                   NonDistrAmountToAssign * Sign,NonDistrQtyToAssign,0);
//             UNTIL TempItemLedgEntry.NEXT = 0;
//           END ELSE
//             ERROR(Text042)
//         ELSE
//           PostItemCharge(PurchLine,
//             SalesShptLine."Item Shpt. Entry No.",-SalesShptLine."Quantity (Base)",
//             TempItemChargeAssgntPurch."Amount to Assign" * Sign,
//             TempItemChargeAssgntPurch."Qty. to Assign",0)
//     end;

//     procedure PostItemChargePerRetRcpt(var PurchLine: Record "39")
//     var
//         ReturnRcptLine: Record "6661";
//         TempItemLedgEntry: Record "32" temporary;
//         ItemTrackingMgt: Codeunit "6500";
//         Factor: Decimal;
//         NonDistrQuantity: Decimal;
//         NonDistrQtyToAssign: Decimal;
//         NonDistrAmountToAssign: Decimal;
//         QtyToAssign: Decimal;
//         AmountToAssign: Decimal;
//         Sign: Decimal;
//         DistributeCharge: Boolean;
//     begin
//         IF NOT ReturnRcptLine.GET(
//              TempItemChargeAssgntPurch."Applies-to Doc. No.",TempItemChargeAssgntPurch."Applies-to Doc. Line No.")
//         THEN
//           ERROR(Text042);
//         ReturnRcptLine.TESTFIELD("Job No.",'');
//         IF ReturnRcptLine."Quantity (Base)" > 0 THEN
//           Sign := 1
//         ELSE
//           Sign := -1;

//         IF ReturnRcptLine."Item Rcpt. Entry No." <> 0 THEN
//           DistributeCharge :=
//             CostCalcMgt.SplitItemLedgerEntriesExist(
//               TempItemLedgEntry,ReturnRcptLine."Quantity (Base)",ReturnRcptLine."Item Rcpt. Entry No.")
//         ELSE BEGIN
//           DistributeCharge := TRUE;
//           ItemTrackingMgt.CollectItemEntryRelation(TempItemLedgEntry,
//             DATABASE::"Return Receipt Line",0,ReturnRcptLine."Document No.",
//             '',0,ReturnRcptLine."Line No.",ReturnRcptLine."Quantity (Base)");
//         END;

//         IF DistributeCharge THEN
//           IF TempItemLedgEntry.FINDSET THEN BEGIN
//             NonDistrQuantity := ReturnRcptLine."Quantity (Base)";
//             NonDistrQtyToAssign := TempItemChargeAssgntPurch."Qty. to Assign";
//             NonDistrAmountToAssign := TempItemChargeAssgntPurch."Amount to Assign";
//             REPEAT
//               Factor := TempItemLedgEntry.Quantity / NonDistrQuantity;
//               QtyToAssign := NonDistrQtyToAssign * Factor;
//               AmountToAssign := ROUND(NonDistrAmountToAssign * Factor,GLSetup."Amount Rounding Precision");
//               IF Factor < 1 THEN BEGIN
//                 PostItemCharge(PurchLine,
//                   TempItemLedgEntry."Entry No.",TempItemLedgEntry.Quantity,
//                   AmountToAssign * Sign,QtyToAssign,0);
//                 NonDistrQuantity := NonDistrQuantity - TempItemLedgEntry.Quantity;
//                 NonDistrQtyToAssign := NonDistrQtyToAssign - QtyToAssign;
//                 NonDistrAmountToAssign := NonDistrAmountToAssign - AmountToAssign;
//               END ELSE // the last time
//                 PostItemCharge(PurchLine,
//                   TempItemLedgEntry."Entry No.",TempItemLedgEntry.Quantity,
//                   NonDistrAmountToAssign * Sign,NonDistrQtyToAssign,0);
//             UNTIL TempItemLedgEntry.NEXT = 0;
//           END ELSE
//             ERROR(Text042)
//         ELSE
//           PostItemCharge(PurchLine,
//             ReturnRcptLine."Item Rcpt. Entry No.",ReturnRcptLine."Quantity (Base)",
//             TempItemChargeAssgntPurch."Amount to Assign" * Sign,
//             TempItemChargeAssgntPurch."Qty. to Assign",0)
//     end;

//     local procedure PostAssocItemJnlLine(QtyToBeShipped: Decimal;QtyToBeShippedBase: Decimal): Integer
//     var
//         TempHandlingSpecification2: Record "336" temporary;
//         ItemEntryRelation: Record "6507";
//     begin
//         SalesOrderHeader.GET(
//           SalesOrderHeader."Document Type"::Order,
//           PurchLine."Sales Order No.");
//         SalesOrderLine.GET(
//           SalesOrderLine."Document Type"::Order,
//           PurchLine."Sales Order No.",PurchLine."Sales Order Line No.");

//         ItemJnlLine.INIT;
//         ItemJnlLine."Source Posting Group" := SalesOrderHeader."Customer Posting Group";
//         ItemJnlLine."Salespers./Purch. Code" := SalesOrderHeader."Salesperson Code";
//         ItemJnlLine."Country/Region Code" := GetCountryCode(SalesOrderLine,SalesOrderHeader);
//         ItemJnlLine."Reason Code" := SalesOrderHeader."Reason Code";
//         ItemJnlLine."Posting No. Series" := SalesOrderHeader."Posting No. Series";
//         ItemJnlLine."Item No." := SalesOrderLine."No.";
//         ItemJnlLine.Description := SalesOrderLine.Description;
//         ItemJnlLine."Shortcut Dimension 1 Code" := SalesOrderLine."Shortcut Dimension 1 Code";
//         ItemJnlLine."Shortcut Dimension 2 Code" := SalesOrderLine."Shortcut Dimension 2 Code";
//         ItemJnlLine."Dimension Set ID" := SalesOrderLine."Dimension Set ID";
//         ItemJnlLine."Location Code" := SalesOrderLine."Location Code";
//         ItemJnlLine."Inventory Posting Group" := SalesOrderLine."Posting Group";
//         ItemJnlLine."Gen. Bus. Posting Group" := SalesOrderLine."Gen. Bus. Posting Group";
//         ItemJnlLine."Gen. Prod. Posting Group" := SalesOrderLine."Gen. Prod. Posting Group";
//         ItemJnlLine."Applies-to Entry" := SalesOrderLine."Appl.-to Item Entry";
//         ItemJnlLine."Transaction Type" := SalesOrderLine."Transaction Type";
//         ItemJnlLine."Transport Method" := SalesOrderLine."Transport Method";
//         ItemJnlLine."Entry/Exit Point" := SalesOrderLine."Exit Point";
//         ItemJnlLine.Area := SalesOrderLine.Area;
//         ItemJnlLine."Transaction Specification" := SalesOrderLine."Transaction Specification";
//         ItemJnlLine."Drop Shipment" := SalesOrderLine."Drop Shipment";
//         ItemJnlLine."Posting Date" := PurchHeader."Posting Date";
//         ItemJnlLine."Document Date" := PurchHeader."Document Date";
//         ItemJnlLine."Entry Type" := ItemJnlLine."Entry Type"::Sale;
//         ItemJnlLine."Document No." := SalesOrderHeader."Shipping No.";
//         ItemJnlLine."Document Type" := ItemJnlLine."Document Type"::"Sales Shipment";
//         ItemJnlLine."Document Line No." := SalesOrderLine."Line No.";
//         ItemJnlLine.Quantity := QtyToBeShipped;
//         ItemJnlLine."Quantity (Base)" := QtyToBeShippedBase;
//         ItemJnlLine."Invoiced Quantity" := 0;
//         ItemJnlLine."Invoiced Qty. (Base)" := 0;
//         ItemJnlLine."Unit Cost" := SalesOrderLine."Unit Cost (LCY)";
//         ItemJnlLine."Source Currency Code" := PurchHeader."Currency Code";
//         ItemJnlLine."Unit Cost (ACY)" := SalesOrderLine."Unit Cost";
//         ItemJnlLine.Amount := SalesOrderLine."Line Amount";
//         ItemJnlLine."Discount Amount" := SalesOrderLine."Line Discount Amount";
//         ItemJnlLine."Source Type" := ItemJnlLine."Source Type"::Customer;
//         ItemJnlLine."Source No." := SalesOrderLine."Sell-to Customer No.";
//         ItemJnlLine."Invoice-to Source No." := SalesOrderLine."Bill-to Customer No.";
//         ItemJnlLine."Source Code" := SrcCode;
//         ItemJnlLine."Variant Code" := SalesOrderLine."Variant Code";
//         ItemJnlLine."Item Category Code" := SalesOrderLine."Item Category Code";
//         ItemJnlLine."Product Group Code" := SalesOrderLine."Product Group Code";
//         ItemJnlLine."Bin Code" := SalesOrderLine."Bin Code";
//         ItemJnlLine."Unit of Measure Code" := SalesOrderLine."Unit of Measure Code";
//         ItemJnlLine."Purchasing Code" := SalesOrderLine."Purchasing Code";
//         ItemJnlLine."Qty. per Unit of Measure" := SalesOrderLine."Qty. per Unit of Measure";
//         ItemJnlLine."Derived from Blanket Order" := SalesOrderLine."Blanket Order No." <> '';
//         ItemJnlLine."Applies-to Entry" := ItemLedgShptEntryNo;

//         IF SalesOrderLine."Job Contract Entry No." = 0 THEN BEGIN
//           TransferReservToItemJnlLine(SalesOrderLine,ItemJnlLine,QtyToBeShippedBase,TRUE);
//           ItemJnlPostLine.RunWithCheck(ItemJnlLine);
//           // Handle Item Tracking
//           IF ItemJnlPostLine.CollectTrackingSpecification(TempHandlingSpecification2) THEN BEGIN
//             IF TempHandlingSpecification2.FINDSET THEN
//               REPEAT
//                 TempTrackingSpecification := TempHandlingSpecification2;
//                 TempTrackingSpecification."Source Type" := DATABASE::"Sales Line";
//                 TempTrackingSpecification."Source Subtype" := SalesOrderLine."Document Type";
//                 TempTrackingSpecification."Source ID" := SalesOrderLine."Document No.";
//                 TempTrackingSpecification."Source Batch Name" := '';
//                 TempTrackingSpecification."Source Prod. Order Line" := 0;
//                 TempTrackingSpecification."Source Ref. No." := SalesOrderLine."Line No.";
//                 IF TempTrackingSpecification.INSERT THEN;
//                 ItemEntryRelation.INIT;
//                 ItemEntryRelation."Item Entry No." := TempHandlingSpecification2."Entry No.";
//                 ItemEntryRelation."Serial No." := TempHandlingSpecification2."Serial No.";
//                 ItemEntryRelation."Lot No." := TempHandlingSpecification2."Lot No.";
//                 ItemEntryRelation."Source Type" := DATABASE::"Sales Shipment Line";
//                 ItemEntryRelation."Source ID" := SalesOrderHeader."Shipping No.";
//                 ItemEntryRelation."Source Ref. No." := SalesOrderLine."Line No.";
//                 ItemEntryRelation."Order No." := SalesOrderLine."Document No.";
//                 ItemEntryRelation."Order Line No." := SalesOrderLine."Line No.";
//                 ItemEntryRelation.INSERT;
//               UNTIL TempHandlingSpecification2.NEXT = 0;
//             EXIT(0);
//           END;
//         END;

//         EXIT(ItemJnlLine."Item Shpt. Entry No.");
//     end;

//     local procedure UpdateAssocOrder()
//     var
//         ReserveSalesLine: Codeunit "99000832";
//         SalesSetup: Record "311";
//     begin
//         DropShptPostBuffer.RESET;
//         IF DropShptPostBuffer.ISEMPTY THEN
//           EXIT;
//         SalesSetup.GET;
//         IF DropShptPostBuffer.FINDSET THEN BEGIN
//           REPEAT
//             SalesOrderHeader.GET(
//               SalesOrderHeader."Document Type"::Order,
//               DropShptPostBuffer."Order No.");
//             SalesOrderHeader."Last Shipping No." := SalesOrderHeader."Shipping No.";
//             SalesOrderHeader."Shipping No." := '';
//             SalesOrderHeader.MODIFY;
//             ReserveSalesLine.UpdateItemTrackingAfterPosting(SalesOrderHeader);
//             DropShptPostBuffer.SETRANGE("Order No.",DropShptPostBuffer."Order No.");
//             REPEAT
//               SalesOrderLine.GET(
//                 SalesOrderLine."Document Type"::Order,
//                 DropShptPostBuffer."Order No.",DropShptPostBuffer."Order Line No.");
//               SalesOrderLine."Quantity Shipped" := SalesOrderLine."Quantity Shipped" + DropShptPostBuffer.Quantity;
//               SalesOrderLine."Qty. Shipped (Base)" := SalesOrderLine."Qty. Shipped (Base)" + DropShptPostBuffer."Quantity (Base)";
//               SalesOrderLine.InitOutstanding;
//               IF SalesSetup."Default Quantity to Ship" <> SalesSetup."Default Quantity to Ship"::Blank THEN
//                 SalesOrderLine.InitQtyToShip
//               ELSE BEGIN
//                 SalesOrderLine."Qty. to Ship" := 0;
//                 SalesOrderLine."Qty. to Ship (Base)" := 0;
//               END;
//               SalesOrderLine.MODIFY;
//             UNTIL DropShptPostBuffer.NEXT = 0;
//             DropShptPostBuffer.SETRANGE("Order No.");
//           UNTIL DropShptPostBuffer.NEXT = 0;
//           DropShptPostBuffer.DELETEALL;
//         END;
//     end;

//     local procedure FillInvPostingBuffer(PurchLine: Record "39";PurchLineACY: Record "39")
//     var
//         TotalVAT: Decimal;
//         TotalVATACY: Decimal;
//         TotalAmount: Decimal;
//         TotalAmountACY: Decimal;
//     begin
//         IF (PurchLine."Gen. Bus. Posting Group" <> GenPostingSetup."Gen. Bus. Posting Group") OR
//            (PurchLine."Gen. Prod. Posting Group" <> GenPostingSetup."Gen. Prod. Posting Group")
//         THEN
//           GenPostingSetup.GET(PurchLine."Gen. Bus. Posting Group",PurchLine."Gen. Prod. Posting Group");

//         InvPostingBuffer[1].PreparePurchase(PurchLine);

//         TotalVAT := PurchLine."Amount Including VAT" - PurchLine.Amount;
//         TotalVATACY := PurchLineACY."Amount Including VAT" - PurchLineACY.Amount;
//         TotalAmount := PurchLine.Amount;
//         TotalAmountACY := PurchLineACY.Amount;

//         IF PurchSetup."Discount Posting" IN
//            [PurchSetup."Discount Posting"::"Invoice Discounts",PurchSetup."Discount Posting"::"All Discounts"]
//         THEN BEGIN
//           CASE PurchLine."VAT Calculation Type" OF
//             PurchLine."VAT Calculation Type"::"Normal VAT",PurchLine."VAT Calculation Type"::"Full VAT":
//               InvPostingBuffer[1].CalcDiscount(
//                 PurchHeader."Prices Including VAT",
//                 -PurchLine."Inv. Discount Amount",
//                 -PurchLineACY."Inv. Discount Amount");
//             PurchLine."VAT Calculation Type"::"Reverse Charge VAT":
//               InvPostingBuffer[1].CalcDiscountNoVAT(
//                 -PurchLine."Inv. Discount Amount",
//                 -PurchLineACY."Inv. Discount Amount");
//             PurchLine."VAT Calculation Type"::"Sales Tax":
//               IF NOT PurchLine."Use Tax" THEN // Use Tax is calculated later, based on totals
//                 InvPostingBuffer[1].CalcDiscount(
//                   PurchHeader."Prices Including VAT",
//                   -PurchLine."Inv. Discount Amount",
//                   -PurchLineACY."Inv. Discount Amount")
//               ELSE
//                 InvPostingBuffer[1].CalcDiscountNoVAT(
//                   -PurchLine."Inv. Discount Amount",
//                   -PurchLineACY."Inv. Discount Amount");
//           END;

//           IF PurchLine."VAT Calculation Type" = PurchLine."VAT Calculation Type"::"Sales Tax" THEN
//             InvPostingBuffer[1].SetSalesTax(PurchLine);

//           IF (InvPostingBuffer[1].Amount <> 0) OR
//              (InvPostingBuffer[1]."Amount (ACY)" <> 0)
//           THEN BEGIN
//             GenPostingSetup.TESTFIELD("Purch. Inv. Disc. Account");
//             IF InvPostingBuffer[1].Type = InvPostingBuffer[1].Type::"Fixed Asset" THEN BEGIN
//               IF DeprBook."Subtract Disc. in Purch. Inv." THEN BEGIN
//                 GenPostingSetup.TESTFIELD("Purch. FA Disc. Account");
//                 InvPostingBuffer[1].SetAccount(
//                   PurchLine."No.",
//                   TotalVAT,
//                   TotalVATACY,
//                   TotalAmount,
//                   TotalAmountACY);
//                 UpdInvPostingBuffer;
//                 InvPostingBuffer[1].ReverseAmounts;
//                 InvPostingBuffer[1].SetAccount(
//                   GenPostingSetup."Purch. FA Disc. Account",
//                   TotalVAT,
//                   TotalVATACY,
//                   TotalAmount,
//                   TotalAmountACY);
//                 InvPostingBuffer[1].Type := InvPostingBuffer[1].Type::"G/L Account";
//                 UpdInvPostingBuffer;
//                 InvPostingBuffer[1].ReverseAmounts;
//               END;
//               InvPostingBuffer[1].SetAccount(
//                 GenPostingSetup."Purch. Inv. Disc. Account",
//                 TotalVAT,
//                 TotalVATACY,
//                 TotalAmount,
//                 TotalAmountACY);
//               InvPostingBuffer[1].Type := InvPostingBuffer[1].Type::"G/L Account";
//               UpdInvPostingBuffer;
//               InvPostingBuffer[1].Type := InvPostingBuffer[1].Type::"Fixed Asset";
//             END ELSE BEGIN;
//               InvPostingBuffer[1].SetAccount(
//                 GenPostingSetup."Purch. Inv. Disc. Account",
//                 TotalVAT,
//                 TotalVATACY,
//                 TotalAmount,
//                 TotalAmountACY);
//               UpdInvPostingBuffer;
//             END;
//           END;
//         END;

//         IF PurchSetup."Discount Posting" IN
//            [PurchSetup."Discount Posting"::"Line Discounts",PurchSetup."Discount Posting"::"All Discounts"]
//         THEN BEGIN
//           CASE PurchLine."VAT Calculation Type" OF
//             PurchLine."VAT Calculation Type"::"Normal VAT",PurchLine."VAT Calculation Type"::"Full VAT":
//               InvPostingBuffer[1].CalcDiscount(
//                 PurchHeader."Prices Including VAT",
//                 -PurchLine."Line Discount Amount",
//                 -PurchLineACY."Line Discount Amount");
//             PurchLine."VAT Calculation Type"::"Reverse Charge VAT":
//               InvPostingBuffer[1].CalcDiscountNoVAT(
//                 -PurchLine."Line Discount Amount",
//                 -PurchLineACY."Line Discount Amount");
//             PurchLine."VAT Calculation Type"::"Sales Tax":
//               IF NOT PurchLine."Use Tax" THEN // Use Tax is calculated later, based on totals
//                 InvPostingBuffer[1].CalcDiscount(
//                   PurchHeader."Prices Including VAT",
//                   -PurchLine."Line Discount Amount",
//                   -PurchLineACY."Line Discount Amount")
//               ELSE
//                 InvPostingBuffer[1].CalcDiscountNoVAT(
//                   -PurchLine."Line Discount Amount",
//                   -PurchLineACY."Line Discount Amount");
//           END;

//           IF PurchLine."VAT Calculation Type" = PurchLine."VAT Calculation Type"::"Sales Tax" THEN
//             InvPostingBuffer[1].SetSalesTax(PurchLine);

//           IF (InvPostingBuffer[1].Amount <> 0) OR
//              (InvPostingBuffer[1]."Amount (ACY)" <> 0)
//           THEN BEGIN
//             GenPostingSetup.TESTFIELD("Purch. Line Disc. Account");
//             IF InvPostingBuffer[1].Type = InvPostingBuffer[1].Type::"Fixed Asset" THEN BEGIN
//               IF DeprBook."Subtract Disc. in Purch. Inv." THEN BEGIN
//                 GenPostingSetup.TESTFIELD("Purch. FA Disc. Account");
//                 InvPostingBuffer[1].SetAccount(
//                   PurchLine."No.",
//                   TotalVAT,
//                   TotalVATACY,
//                   TotalAmount,
//                   TotalAmountACY);
//                 UpdInvPostingBuffer;
//                 InvPostingBuffer[1].ReverseAmounts;
//                 InvPostingBuffer[1].SetAccount(
//                   GenPostingSetup."Purch. FA Disc. Account",
//                   TotalVAT,
//                   TotalVATACY,
//                   TotalAmount,
//                   TotalAmountACY);
//                 InvPostingBuffer[1].Type := InvPostingBuffer[1].Type::"G/L Account";
//                 UpdInvPostingBuffer;
//                 InvPostingBuffer[1].ReverseAmounts;
//               END;
//               InvPostingBuffer[1].SetAccount(
//                 GenPostingSetup."Purch. Line Disc. Account",
//                 TotalVAT,
//                 TotalVATACY,
//                 TotalAmount,
//                 TotalAmountACY);
//               InvPostingBuffer[1].Type := InvPostingBuffer[1].Type::"G/L Account";
//               UpdInvPostingBuffer;
//               InvPostingBuffer[1].Type := InvPostingBuffer[1].Type::"Fixed Asset";
//             END ELSE BEGIN;
//               InvPostingBuffer[1].SetAccount(
//                 GenPostingSetup."Purch. Line Disc. Account",
//                 TotalVAT,
//                 TotalVATACY,
//                 TotalAmount,
//                 TotalAmountACY);
//               UpdInvPostingBuffer;
//             END;
//           END;
//         END;

//         IF PurchLine."VAT Calculation Type" = PurchLine."VAT Calculation Type"::"Reverse Charge VAT" THEN
//           InvPostingBuffer[1].SetAmountsNoVAT(
//             TotalAmount,
//             TotalAmountACY,
//             PurchLine."VAT Difference")
//         ELSE
//           IF (NOT PurchLine."Use Tax") OR (PurchLine."VAT Calculation Type" <> PurchLine."VAT Calculation Type"::"Sales Tax") THEN BEGIN
//             InvPostingBuffer[1].SetAmounts(
//               TotalVAT,
//               TotalVATACY,
//               TotalAmount,
//               TotalAmountACY,
//               PurchLine."VAT Difference");
//           END ELSE
//             InvPostingBuffer[1].SetAmountsNoVAT(
//               TotalAmount,
//               TotalAmountACY,
//               PurchLine."VAT Difference");

//         IF PurchLine."VAT Calculation Type" = PurchLine."VAT Calculation Type"::"Sales Tax" THEN
//           InvPostingBuffer[1].SetSalesTax(PurchLine);

//         IF (PurchLine.Type = PurchLine.Type::"G/L Account") OR (PurchLine.Type = PurchLine.Type::"Fixed Asset") THEN
//           InvPostingBuffer[1].SetAccount(
//             PurchLine."No.",
//             TotalVAT,
//             TotalVATACY,
//             TotalAmount,
//             TotalAmountACY)
//         ELSE
//           IF PurchLine."Document Type" IN [PurchLine."Document Type"::"Return Order",PurchLine."Document Type"::"Credit Memo"] THEN
//             BEGIN
//             GenPostingSetup.TESTFIELD("Purch. Credit Memo Account");
//             InvPostingBuffer[1].SetAccount(
//               GenPostingSetup."Purch. Credit Memo Account",
//               TotalVAT,
//               TotalVATACY,
//               TotalAmount,
//               TotalAmountACY);
//           END ELSE BEGIN
//             GenPostingSetup.TESTFIELD("Purch. Account");
//             InvPostingBuffer[1].SetAccount(
//               GenPostingSetup."Purch. Account",
//               TotalVAT,
//               TotalVATACY,
//               TotalAmount,
//               TotalAmountACY);
//           END;
//         UpdInvPostingBuffer;
//     end;

//     local procedure UpdInvPostingBuffer()
//     begin
//         InvPostingBuffer[1]."Dimension Set ID" := PurchLine."Dimension Set ID";

//         DimMgt.UpdateGlobalDimFromDimSetID(InvPostingBuffer[1]."Dimension Set ID",
//           InvPostingBuffer[1]."Global Dimension 1 Code",InvPostingBuffer[1]."Global Dimension 2 Code");

//         IF InvPostingBuffer[1].Type = InvPostingBuffer[1].Type::"Fixed Asset" THEN BEGIN
//           FALineNo := FALineNo + 1;
//           InvPostingBuffer[1]."Fixed Asset Line No." := FALineNo;
//         END;
//         //DP.NCM TJC #449 04/04/2018
//         IF InvPostingBuffer[1].Type = InvPostingBuffer[1].Type::"G/L Account" THEN BEGIN
//           IF PurchLine.Description <> '' THEN //DP.NCM TJC #461 20/06/2018
//             InvPostingBuffer[1]."Line Description" := PurchLine.Description;
//         END;
//         //DP.NCM TJC #449 04/04/2018
//         IF PurchLine."Line Discount %" = 100 THEN BEGIN
//           InvPostingBuffer[1]."VAT Base Amount" := 0;
//           InvPostingBuffer[1]."VAT Base Amount (ACY)" := 0;
//           InvPostingBuffer[1]."VAT Amount" := 0;
//           InvPostingBuffer[1]."VAT Amount (ACY)" := 0;
//         END;
//         InvPostingBuffer[2] := InvPostingBuffer[1];
//         IF InvPostingBuffer[2].FIND THEN BEGIN
//           InvPostingBuffer[2].Amount :=
//             InvPostingBuffer[2].Amount + InvPostingBuffer[1].Amount;
//           InvPostingBuffer[2]."VAT Amount" :=
//             InvPostingBuffer[2]."VAT Amount" + InvPostingBuffer[1]."VAT Amount";
//           InvPostingBuffer[2]."VAT Base Amount" :=
//             InvPostingBuffer[2]."VAT Base Amount" + InvPostingBuffer[1]."VAT Base Amount";
//           InvPostingBuffer[2]."VAT Difference" :=
//             InvPostingBuffer[2]."VAT Difference" + InvPostingBuffer[1]."VAT Difference";
//           InvPostingBuffer[2]."Amount (ACY)" :=
//             InvPostingBuffer[2]."Amount (ACY)" + InvPostingBuffer[1]."Amount (ACY)";
//           InvPostingBuffer[2]."VAT Amount (ACY)" :=
//             InvPostingBuffer[2]."VAT Amount (ACY)" + InvPostingBuffer[1]."VAT Amount (ACY)";
//           InvPostingBuffer[2]."VAT Base Amount (ACY)" :=
//             InvPostingBuffer[2]."VAT Base Amount (ACY)" +
//             InvPostingBuffer[1]."VAT Base Amount (ACY)";
//           InvPostingBuffer[2].Quantity :=
//             InvPostingBuffer[2].Quantity + InvPostingBuffer[1].Quantity;
//           IF NOT InvPostingBuffer[1]."System-Created Entry" THEN
//             InvPostingBuffer[2]."System-Created Entry" := FALSE;
//           InvPostingBuffer[2].MODIFY;
//         END ELSE
//           InvPostingBuffer[1].INSERT;
//     end;

//     local procedure InsertPrepmtAdjInvPostingBuf(PrepmtPurchLine: Record "39")
//     var
//         PurchPostPrepayments: Codeunit "444";
//         AdjAmount: Decimal;
//     begin
//         WITH PrepmtPurchLine DO
//           IF "Prepayment Line" THEN
//             IF "Prepmt. Amount Inv. (LCY)" <> 0 THEN BEGIN
//               AdjAmount := -"Prepmt. Amount Inv. (LCY)";
//               FillPrepmtAdjInvPostingBuffer("No.",AdjAmount,PurchHeader."Currency Code" = '');
//               FillPrepmtAdjInvPostingBuffer(
//                 PurchPostPrepayments.GetCorrBalAccNo(PurchHeader,AdjAmount > 0),
//                 -AdjAmount,
//                 PurchHeader."Currency Code" = '');
//             END ELSE
//               IF ("Prepayment %" = 100) AND ("Prepmt. VAT Amount Inv. (LCY)" <> 0) THEN
//                 FillPrepmtAdjInvPostingBuffer(
//                   PurchPostPrepayments.GetInvRoundingAccNo(PurchHeader."Vendor Posting Group"),
//                   "Prepmt. VAT Amount Inv. (LCY)",PurchHeader."Currency Code" = '');
//     end;

//     local procedure FillPrepmtAdjInvPostingBuffer(GLAccountNo: Code[20];AdjAmount: Decimal;RoundingEntry: Boolean)
//     var
//         PrepmtAdjInvPostBuffer: Record "49";
//     begin
//         WITH PrepmtAdjInvPostBuffer DO BEGIN
//           INIT;
//           Type := Type::"Prepmt. Exch. Rate Difference";
//           "G/L Account" := GLAccountNo;
//           Amount := AdjAmount;
//           IF RoundingEntry THEN
//             "Amount (ACY)" := AdjAmount
//           ELSE
//             "Amount (ACY)" := 0;
//           "Dimension Set ID" := InvPostingBuffer[1]."Dimension Set ID";
//           "Global Dimension 1 Code" := InvPostingBuffer[1]."Global Dimension 1 Code";
//           "Global Dimension 2 Code" := InvPostingBuffer[1]."Global Dimension 2 Code";
//           "System-Created Entry" := TRUE;
//           InvPostingBuffer[1] := PrepmtAdjInvPostBuffer;

//           InvPostingBuffer[2] := InvPostingBuffer[1];
//           IF InvPostingBuffer[2].FIND THEN BEGIN
//             InvPostingBuffer[2].Amount := InvPostingBuffer[2].Amount + InvPostingBuffer[1].Amount;
//             InvPostingBuffer[2]."Amount (ACY)" :=
//               InvPostingBuffer[2]."Amount (ACY)" + InvPostingBuffer[1]."Amount (ACY)";
//             InvPostingBuffer[2].MODIFY;
//           END ELSE
//             InvPostingBuffer[1].INSERT;
//         END;
//     end;

//     local procedure GetCurrency()
//     begin
//         WITH PurchHeader DO
//           IF "Currency Code" = '' THEN
//             Currency.InitRoundingPrecision
//           ELSE BEGIN
//             Currency.GET("Currency Code");
//             Currency.TESTFIELD("Amount Rounding Precision");
//           END;
//     end;

//     local procedure DivideAmount(QtyType: Option General,Invoicing,Shipping;PurchLineQty: Decimal)
//     begin
//         IF RoundingLineInserted AND (RoundingLineNo = PurchLine."Line No.") THEN
//           EXIT;
//         WITH PurchLine DO
//           IF (PurchLineQty = 0) OR ("Direct Unit Cost" = 0) THEN BEGIN
//             "Line Amount" := 0;
//             "Line Discount Amount" := 0;
//             "Inv. Discount Amount" := 0;
//             "VAT Base Amount" := 0;
//             Amount := 0;
//             "Amount Including VAT" := 0;
//           END ELSE BEGIN
//             TempVATAmountLine.GET(
//               "VAT Identifier","VAT Calculation Type","Tax Group Code","Use Tax",
//               "Line Amount" >= 0);
//             IF "VAT Calculation Type" = "VAT Calculation Type"::"Sales Tax" THEN
//               "VAT %" := TempVATAmountLine."VAT %";
//             TempVATAmountLineRemainder := TempVATAmountLine;
//             IF NOT TempVATAmountLineRemainder.FIND THEN BEGIN
//               TempVATAmountLineRemainder.INIT;
//               TempVATAmountLineRemainder.INSERT;
//             END;
//             "Line Amount" := GetLineAmountToHandle(PurchLineQty) + GetPrepmtDiffToLineAmount(PurchLine);
//             IF PurchLineQty <> Quantity THEN
//               "Line Discount Amount" :=
//                 ROUND("Line Discount Amount" * PurchLineQty / Quantity,Currency."Amount Rounding Precision");

//             IF "Allow Invoice Disc." AND (TempVATAmountLine."Inv. Disc. Base Amount" <> 0) THEN
//               IF QtyType = QtyType::Invoicing THEN
//                 "Inv. Discount Amount" := "Inv. Disc. Amount to Invoice"
//               ELSE BEGIN
//                 TempVATAmountLineRemainder."Invoice Discount Amount" :=
//                   TempVATAmountLineRemainder."Invoice Discount Amount" +
//                   TempVATAmountLine."Invoice Discount Amount" * "Line Amount" /
//                   TempVATAmountLine."Inv. Disc. Base Amount";
//                 "Inv. Discount Amount" :=
//                   ROUND(
//                     TempVATAmountLineRemainder."Invoice Discount Amount",Currency."Amount Rounding Precision");
//                 TempVATAmountLineRemainder."Invoice Discount Amount" :=
//                   TempVATAmountLineRemainder."Invoice Discount Amount" - "Inv. Discount Amount";
//               END;

//             IF PurchHeader."Prices Including VAT" THEN BEGIN
//               IF (TempVATAmountLine."Line Amount" - TempVATAmountLine."Invoice Discount Amount" = 0) OR
//                  ("Line Amount" = 0)
//               THEN BEGIN
//                 TempVATAmountLineRemainder."VAT Amount" := 0;
//                 TempVATAmountLineRemainder."Amount Including VAT" := 0;
//               END ELSE BEGIN
//                 TempVATAmountLineRemainder."VAT Amount" :=
//                   TempVATAmountLineRemainder."VAT Amount" +
//                   TempVATAmountLine."VAT Amount" *
//                   ("Line Amount" - "Inv. Discount Amount") /
//                   (TempVATAmountLine."Line Amount" - TempVATAmountLine."Invoice Discount Amount");
//                 TempVATAmountLineRemainder."Amount Including VAT" :=
//                   TempVATAmountLineRemainder."Amount Including VAT" +
//                   TempVATAmountLine."Amount Including VAT" *
//                   ("Line Amount" - "Inv. Discount Amount") /
//                   (TempVATAmountLine."Line Amount" - TempVATAmountLine."Invoice Discount Amount");
//               END;
//               IF "Line Discount %" <> 100 THEN
//                 "Amount Including VAT" :=
//                   ROUND(TempVATAmountLineRemainder."Amount Including VAT",Currency."Amount Rounding Precision")
//               ELSE
//                 "Amount Including VAT" := 0;
//               Amount :=
//                 ROUND("Amount Including VAT",Currency."Amount Rounding Precision") -
//                 ROUND(TempVATAmountLineRemainder."VAT Amount",Currency."Amount Rounding Precision");
//               "VAT Base Amount" :=
//                 ROUND(
//                   Amount * (1 - PurchHeader."VAT Base Discount %" / 100),Currency."Amount Rounding Precision");
//               TempVATAmountLineRemainder."Amount Including VAT" :=
//                 TempVATAmountLineRemainder."Amount Including VAT" - "Amount Including VAT";
//               TempVATAmountLineRemainder."VAT Amount" :=
//                 TempVATAmountLineRemainder."VAT Amount" - "Amount Including VAT" + Amount;
//             END ELSE BEGIN
//               IF "VAT Calculation Type" = "VAT Calculation Type"::"Full VAT" THEN BEGIN
//                 IF "Line Discount %" <> 100 THEN
//                   "Amount Including VAT" := "Line Amount" - "Inv. Discount Amount"
//                 ELSE
//                   "Amount Including VAT" := 0;
//                 Amount := 0;
//                 "VAT Base Amount" := 0;
//               END ELSE BEGIN
//                 Amount := "Line Amount" - "Inv. Discount Amount";
//                 "VAT Base Amount" :=
//                   ROUND(
//                     Amount * (1 - PurchHeader."VAT Base Discount %" / 100),Currency."Amount Rounding Precision");
//                 IF TempVATAmountLine."VAT Base" = 0 THEN
//                   TempVATAmountLineRemainder."VAT Amount" := 0
//                 ELSE
//                   TempVATAmountLineRemainder."VAT Amount" :=
//                     TempVATAmountLineRemainder."VAT Amount" +
//                     TempVATAmountLine."VAT Amount" *
//                     ("Line Amount" - "Inv. Discount Amount") /
//                     (TempVATAmountLine."Line Amount" - TempVATAmountLine."Invoice Discount Amount");
//                 IF "Line Discount %" <> 100 THEN
//                   "Amount Including VAT" :=
//                     Amount + ROUND(TempVATAmountLineRemainder."VAT Amount",Currency."Amount Rounding Precision")
//                 ELSE
//                   "Amount Including VAT" := 0;
//                 TempVATAmountLineRemainder."VAT Amount" :=
//                   TempVATAmountLineRemainder."VAT Amount" - "Amount Including VAT" + Amount;
//               END;
//             END;

//             TempVATAmountLineRemainder.MODIFY;
//           END;
//     end;

//     local procedure RoundAmount(PurchLineQty: Decimal)
//     var
//         NoVAT: Boolean;
//     begin
//         WITH PurchLine DO BEGIN
//           IncrAmount(TotalPurchLine);
//           Increment(TotalPurchLine."Net Weight",ROUND(PurchLineQty * "Net Weight",0.00001));
//           Increment(TotalPurchLine."Gross Weight",ROUND(PurchLineQty * "Gross Weight",0.00001));
//           Increment(TotalPurchLine."Unit Volume",ROUND(PurchLineQty * "Unit Volume",0.00001));
//           Increment(TotalPurchLine.Quantity,PurchLineQty);
//           IF "Units per Parcel" > 0 THEN
//             Increment(
//               TotalPurchLine."Units per Parcel",
//               ROUND(PurchLineQty / "Units per Parcel",1,'>'));

//           TempPurchLine := PurchLine;
//           PurchLineACY := PurchLine;
//           IF PurchHeader."Currency Code" <> '' THEN BEGIN
//             IF PurchHeader."Posting Date" = 0D THEN
//               Usedate := WORKDATE
//             ELSE
//               Usedate := PurchHeader."Posting Date";

//             NoVAT := Amount = "Amount Including VAT";
//             "Amount Including VAT" :=
//               ROUND(
//                 CurrExchRate.ExchangeAmtFCYToLCY(
//                   Usedate,PurchHeader."Currency Code",
//                   TotalPurchLine."Amount Including VAT",PurchHeader."Currency Factor")) -
//               TotalPurchLineLCY."Amount Including VAT";
//             IF NoVAT THEN
//               Amount := "Amount Including VAT"
//             ELSE
//               Amount :=
//                 ROUND(
//                   CurrExchRate.ExchangeAmtFCYToLCY(
//                     Usedate,PurchHeader."Currency Code",
//                     TotalPurchLine.Amount,PurchHeader."Currency Factor")) -
//                 TotalPurchLineLCY.Amount;
//             "Line Amount" :=
//               ROUND(
//                 CurrExchRate.ExchangeAmtFCYToLCY(
//                   Usedate,PurchHeader."Currency Code",
//                   TotalPurchLine."Line Amount",PurchHeader."Currency Factor")) -
//               TotalPurchLineLCY."Line Amount";
//             "Line Discount Amount" :=
//               ROUND(
//                 CurrExchRate.ExchangeAmtFCYToLCY(
//                   Usedate,PurchHeader."Currency Code",
//                   TotalPurchLine."Line Discount Amount",PurchHeader."Currency Factor")) -
//               TotalPurchLineLCY."Line Discount Amount";
//             "Inv. Discount Amount" :=
//               ROUND(
//                 CurrExchRate.ExchangeAmtFCYToLCY(
//                   Usedate,PurchHeader."Currency Code",
//                   TotalPurchLine."Inv. Discount Amount",PurchHeader."Currency Factor")) -
//               TotalPurchLineLCY."Inv. Discount Amount";
//             "VAT Difference" :=
//               ROUND(
//                 CurrExchRate.ExchangeAmtFCYToLCY(
//                   Usedate,PurchHeader."Currency Code",
//                   TotalPurchLine."VAT Difference",PurchHeader."Currency Factor")) -
//               TotalPurchLineLCY."VAT Difference";
//           END;

//           IncrAmount(TotalPurchLineLCY);
//           Increment(TotalPurchLineLCY."Unit Cost (LCY)",ROUND(PurchLineQty * "Unit Cost (LCY)"));
//         END;
//     end;

//     local procedure ReverseAmount(var PurchLine: Record "39")
//     begin
//         WITH PurchLine DO BEGIN
//           "Qty. to Receive" := -"Qty. to Receive";
//           "Qty. to Receive (Base)" := -"Qty. to Receive (Base)";
//           "Return Qty. to Ship" := -"Return Qty. to Ship";
//           "Return Qty. to Ship (Base)" := -"Return Qty. to Ship (Base)";
//           "Qty. to Invoice" := -"Qty. to Invoice";
//           "Qty. to Invoice (Base)" := -"Qty. to Invoice (Base)";
//           "Line Amount" := -"Line Amount";
//           Amount := -Amount;
//           "VAT Base Amount" := -"VAT Base Amount";
//           "VAT Difference" := -"VAT Difference";
//           "Amount Including VAT" := -"Amount Including VAT";
//           "Line Discount Amount" := -"Line Discount Amount";
//           "Inv. Discount Amount" := -"Inv. Discount Amount";
//           "Salvage Value" := -"Salvage Value";
//         END;
//     end;

//     local procedure InvoiceRounding(UseTempData: Boolean;BiggestLineNo: Integer)
//     var
//         InvoiceRoundingAmount: Decimal;
//     begin
//         Currency.TESTFIELD("Invoice Rounding Precision");
//         InvoiceRoundingAmount :=
//           -ROUND(
//             TotalPurchLine."Amount Including VAT" -
//             ROUND(
//               TotalPurchLine."Amount Including VAT",
//               Currency."Invoice Rounding Precision",
//               Currency.InvoiceRoundingDirection),
//             Currency."Amount Rounding Precision");
//         IF InvoiceRoundingAmount <> 0 THEN BEGIN
//           VendPostingGr.GET(PurchHeader."Vendor Posting Group");
//           VendPostingGr.TESTFIELD("Invoice Rounding Account");
//           WITH PurchLine DO BEGIN
//             INIT;
//             BiggestLineNo := BiggestLineNo + 10000;
//             "System-Created Entry" := TRUE;
//             IF UseTempData THEN BEGIN
//               "Line No." := 0;
//               Type := Type::"G/L Account";
//             END ELSE BEGIN
//               "Line No." := BiggestLineNo;
//               VALIDATE(Type,Type::"G/L Account");
//             END;
//             VALIDATE("No.",VendPostingGr."Invoice Rounding Account");
//             VALIDATE(Quantity,1);
//             IF "Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"] THEN
//               VALIDATE("Return Qty. to Ship",Quantity)
//             ELSE
//               VALIDATE("Qty. to Receive",Quantity);
//             IF PurchHeader."Prices Including VAT" THEN
//               VALIDATE("Direct Unit Cost",InvoiceRoundingAmount)
//             ELSE
//               VALIDATE(
//                 "Direct Unit Cost",
//                 ROUND(
//                   InvoiceRoundingAmount /
//                   (1 + (1 - PurchHeader."VAT Base Discount %" / 100) * "VAT %" / 100),
//                   Currency."Amount Rounding Precision"));
//             VALIDATE("Amount Including VAT",InvoiceRoundingAmount);
//             "Line No." := BiggestLineNo;
//             LastLineRetrieved := FALSE;
//             RoundingLineInserted := TRUE;
//             RoundingLineNo := "Line No.";
//           END;
//         END;
//     end;

//     local procedure IncrAmount(var TotalPurchLine: Record "39")
//     begin
//         WITH PurchLine DO BEGIN
//           IF PurchHeader."Prices Including VAT" OR
//              ("VAT Calculation Type" <> "VAT Calculation Type"::"Full VAT")
//           THEN
//             Increment(TotalPurchLine."Line Amount","Line Amount");
//           Increment(TotalPurchLine.Amount,Amount);
//           Increment(TotalPurchLine."VAT Base Amount","VAT Base Amount");
//           Increment(TotalPurchLine."VAT Difference","VAT Difference");
//           Increment(TotalPurchLine."Amount Including VAT","Amount Including VAT");
//           Increment(TotalPurchLine."Line Discount Amount","Line Discount Amount");
//           Increment(TotalPurchLine."Inv. Discount Amount","Inv. Discount Amount");
//           Increment(TotalPurchLine."Inv. Disc. Amount to Invoice","Inv. Disc. Amount to Invoice");
//           Increment(TotalPurchLine."Prepmt. Line Amount","Prepmt. Line Amount");
//           Increment(TotalPurchLine."Prepmt. Amt. Inv.","Prepmt. Amt. Inv.");
//           Increment(TotalPurchLine."Prepmt Amt to Deduct","Prepmt Amt to Deduct");
//           Increment(TotalPurchLine."Prepmt Amt Deducted","Prepmt Amt Deducted");
//           Increment(TotalPurchLine."Prepayment VAT Difference","Prepayment VAT Difference");
//           Increment(TotalPurchLine."Prepmt VAT Diff. to Deduct","Prepmt VAT Diff. to Deduct");
//           Increment(TotalPurchLine."Prepmt VAT Diff. Deducted","Prepmt VAT Diff. Deducted");
//         END;
//     end;

//     local procedure Increment(var Number: Decimal;Number2: Decimal)
//     begin
//         Number := Number + Number2;
//     end;

//     procedure GetPurchLines(var NewPurchHeader: Record "38";var PurchLine: Record "39";QtyType: Option General,Invoicing,Shipping)
//     var
//         OldPurchLine: Record "39";
//         MergedPurchLines: Record "39" temporary;
//     begin
//         PurchHeader := NewPurchHeader;
//         IF QtyType = QtyType::Invoicing THEN BEGIN
//           CreatePrepmtLines(PurchHeader,TempPrepmtPurchLine,FALSE);
//           MergePurchLines(PurchHeader,OldPurchLine,TempPrepmtPurchLine,MergedPurchLines);
//           SumPurchLines2(PurchLine,MergedPurchLines,QtyType,TRUE);
//         END ELSE
//           SumPurchLines2(PurchLine,OldPurchLine,QtyType,TRUE);
//     end;

//     procedure SumPurchLines(var NewPurchHeader: Record "38";QtyType: Option General,Invoicing,Shipping;var NewTotalPurchLine: Record "39";var NewTotalPurchLineLCY: Record "39";var VATAmount: Decimal;var VATAmountText: Text[30])
//     var
//         OldPurchLine: Record "39";
//     begin
//         SumPurchLinesTemp(
//           NewPurchHeader,OldPurchLine,QtyType,NewTotalPurchLine,NewTotalPurchLineLCY,
//           VATAmount,VATAmountText);
//     end;

//     procedure SumPurchLinesTemp(var NewPurchHeader: Record "38";var OldPurchLine: Record "39";QtyType: Option General,Invoicing,Shipping;var NewTotalPurchLine: Record "39";var NewTotalPurchLineLCY: Record "39";var VATAmount: Decimal;var VATAmountText: Text[30])
//     var
//         PurchLine: Record "39";
//     begin
//         WITH PurchHeader DO BEGIN
//           PurchHeader := NewPurchHeader;
//           SumPurchLines2(PurchLine,OldPurchLine,QtyType,FALSE);
//           VATAmount := TotalPurchLine."Amount Including VAT" - TotalPurchLine.Amount;
//           IF TotalPurchLine."VAT %" = 0 THEN
//             VATAmountText := Text021
//           ELSE
//             VATAmountText := STRSUBSTNO(Text022,TotalPurchLine."VAT %");
//           NewTotalPurchLine := TotalPurchLine;
//           NewTotalPurchLineLCY := TotalPurchLineLCY;
//         END;
//     end;

//     local procedure SumPurchLines2(var NewPurchLine: Record "39";var OldPurchLine: Record "39";QtyType: Option General,Invoicing,Shipping;InsertPurchLine: Boolean)
//     var
//         PurchLineQty: Decimal;
//         BiggestLineNo: Integer;
//     begin
//         TempVATAmountLineRemainder.DELETEALL;
//         OldPurchLine.CalcVATAmountLines(QtyType,PurchHeader,OldPurchLine,TempVATAmountLine);
//         WITH PurchHeader DO BEGIN
//           GetGLSetup;
//           PurchSetup.GET;
//           GetCurrency;
//           OldPurchLine.SETRANGE("Document Type","Document Type");
//           OldPurchLine.SETRANGE("Document No.","No.");
//           RoundingLineInserted := FALSE;
//           IF OldPurchLine.FINDSET THEN
//             REPEAT
//               IF NOT RoundingLineInserted THEN
//                 PurchLine := OldPurchLine;
//               CASE QtyType OF
//                 QtyType::General:
//                   PurchLineQty := PurchLine.Quantity;
//                 QtyType::Invoicing:
//                   PurchLineQty := PurchLine."Qty. to Invoice";
//                 QtyType::Shipping:
//                   BEGIN
//                     IF "Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"] THEN
//                       PurchLineQty := PurchLine."Return Qty. to Ship"
//                     ELSE
//                       PurchLineQty := PurchLine."Qty. to Receive"
//                   END;
//               END;
//               DivideAmount(QtyType,PurchLineQty);
//               PurchLine.Quantity := PurchLineQty;
//               IF PurchLineQty <> 0 THEN BEGIN
//                 IF (PurchLine.Amount <> 0) AND NOT RoundingLineInserted THEN
//                   IF TotalPurchLine.Amount = 0 THEN
//                     TotalPurchLine."VAT %" := PurchLine."VAT %"
//                   ELSE
//                     IF TotalPurchLine."VAT %" <> PurchLine."VAT %" THEN
//                       TotalPurchLine."VAT %" := 0;
//                 RoundAmount(PurchLineQty);
//                 PurchLine := TempPurchLine;
//               END;
//               IF InsertPurchLine THEN BEGIN
//                 NewPurchLine := PurchLine;
//                 NewPurchLine.INSERT;
//               END;
//               IF RoundingLineInserted THEN
//                 LastLineRetrieved := TRUE
//               ELSE BEGIN
//                 BiggestLineNo := MAX(BiggestLineNo,OldPurchLine."Line No.");
//                 LastLineRetrieved := OldPurchLine.NEXT = 0;
//                 IF LastLineRetrieved AND PurchSetup."Invoice Rounding" THEN
//                   InvoiceRounding(TRUE,BiggestLineNo);
//               END;
//             UNTIL LastLineRetrieved;
//         END;
//     end;

//     procedure TestDeleteHeader(PurchHeader: Record "38";var PurchRcptHeader: Record "120";var PurchInvHeader: Record "122";var PurchCrMemoHeader: Record "124";var ReturnShptHeader: Record "6650";var PurchInvHeaderPrepmt: Record "122";var PurchCrMemoHeaderPrepmt: Record "124")
//     begin
//         WITH PurchHeader DO BEGIN
//           CLEAR(PurchRcptHeader);
//           CLEAR(PurchInvHeader);
//           CLEAR(PurchCrMemoHeader);
//           CLEAR(ReturnShptHeader);
//           PurchSetup.GET;

//           SourceCodeSetup.GET;
//           SourceCodeSetup.TESTFIELD("Deleted Document");
//           SourceCode.GET(SourceCodeSetup."Deleted Document");

//           IF ("Receiving No. Series" <> '') AND ("Receiving No." <> '') THEN BEGIN
//             PurchRcptHeader.TRANSFERFIELDS(PurchHeader);
//             PurchRcptHeader."No." := "Receiving No.";
//             PurchRcptHeader."Posting Date" := TODAY;
//             PurchRcptHeader."User ID" := USERID;
//             PurchRcptHeader."Source Code" := SourceCode.Code;
//           END;

//           IF ("Return Shipment No. Series" <> '') AND ("Return Shipment No." <> '') THEN BEGIN
//             ReturnShptHeader.TRANSFERFIELDS(PurchHeader);
//             ReturnShptHeader."No." := "Return Shipment No.";
//             ReturnShptHeader."Posting Date" := TODAY;
//             ReturnShptHeader."User ID" := USERID;
//             ReturnShptHeader."Source Code" := SourceCode.Code;
//           END;

//           IF ("Posting No. Series" <> '') AND
//              (("Document Type" IN ["Document Type"::Order,"Document Type"::Invoice]) AND
//               ("Posting No." <> '') OR
//               ("Document Type" = "Document Type"::Invoice) AND
//               ("No. Series" = "Posting No. Series"))
//           THEN BEGIN
//             PurchInvHeader.TRANSFERFIELDS(PurchHeader);
//             IF "Posting No." <> '' THEN
//               PurchInvHeader."No." := "Posting No.";
//             IF "Document Type" = "Document Type"::Invoice THEN BEGIN
//               PurchInvHeader."Pre-Assigned No. Series" := "No. Series";
//               PurchInvHeader."Pre-Assigned No." := "No.";
//             END ELSE BEGIN
//               PurchInvHeader."Pre-Assigned No. Series" := '';
//               PurchInvHeader."Pre-Assigned No." := '';
//               PurchInvHeader."Order No. Series" := "No. Series";
//               PurchInvHeader."Order No." := "No.";
//             END;
//             PurchInvHeader."Posting Date" := TODAY;
//             PurchInvHeader."User ID" := USERID;
//             PurchInvHeader."Source Code" := SourceCode.Code;
//           END;

//           IF ("Posting No. Series" <> '') AND
//              (("Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"]) AND
//               ("Posting No." <> '') OR
//               ("Document Type" = "Document Type"::"Credit Memo") AND
//               ("No. Series" = "Posting No. Series"))
//           THEN BEGIN
//             PurchCrMemoHeader.TRANSFERFIELDS(PurchHeader);
//             IF "Posting No." <> '' THEN
//               PurchCrMemoHeader."No." := "Posting No.";
//             PurchCrMemoHeader."Pre-Assigned No. Series" := "No. Series";
//             PurchCrMemoHeader."Pre-Assigned No." := "No.";
//             PurchCrMemoHeader."Posting Date" := TODAY;
//             PurchCrMemoHeader."User ID" := USERID;
//             PurchCrMemoHeader."Source Code" := SourceCode.Code;
//           END;

//           IF ("Prepayment No. Series" <> '') AND ("Prepayment No." <> '') THEN BEGIN
//             TESTFIELD("Document Type","Document Type"::Order);
//             PurchInvHeaderPrepmt.TRANSFERFIELDS(PurchHeader);
//             PurchInvHeaderPrepmt."No." := "Prepayment No.";
//             PurchInvHeaderPrepmt."Order No. Series" := "No. Series";
//             PurchInvHeaderPrepmt."Prepayment Order No." := "No.";
//             PurchInvHeaderPrepmt."Posting Date" := TODAY;
//             PurchInvHeaderPrepmt."Pre-Assigned No. Series" := '';
//             PurchInvHeaderPrepmt."Pre-Assigned No." := '';
//             PurchInvHeaderPrepmt."User ID" := USERID;
//             PurchInvHeaderPrepmt."Source Code" := SourceCode.Code;
//             PurchInvHeaderPrepmt."Prepayment Invoice" := TRUE;
//           END;

//           IF ("Prepmt. Cr. Memo No. Series" <> '') AND ("Prepmt. Cr. Memo No." <> '') THEN BEGIN
//             TESTFIELD("Document Type","Document Type"::Order);
//             PurchCrMemoHeaderPrepmt.TRANSFERFIELDS(PurchHeader);
//             PurchCrMemoHeaderPrepmt."No." := "Prepmt. Cr. Memo No.";
//             PurchCrMemoHeaderPrepmt."Prepayment Order No." := "No.";
//             PurchCrMemoHeaderPrepmt."Posting Date" := TODAY;
//             PurchCrMemoHeaderPrepmt."Pre-Assigned No. Series" := '';
//             PurchCrMemoHeaderPrepmt."Pre-Assigned No." := '';
//             PurchCrMemoHeaderPrepmt."User ID" := USERID;
//             PurchCrMemoHeaderPrepmt."Source Code" := SourceCode.Code;
//             PurchCrMemoHeaderPrepmt."Prepayment Credit Memo" := TRUE;
//           END;
//         END;
//     end;

//     procedure DeleteHeader(PurchHeader: Record "38";var PurchRcptHeader: Record "120";var PurchInvHeader: Record "122";var PurchCrMemoHeader: Record "124";var ReturnShptHeader: Record "6650";var PurchInvHeaderPrepmt: Record "122";var PurchCrMemoHeaderPrepmt: Record "124")
//     begin
//         WITH PurchHeader DO BEGIN
//           TestDeleteHeader(
//             PurchHeader,PurchRcptHeader,PurchInvHeader,PurchCrMemoHeader,
//             ReturnShptHeader,PurchInvHeaderPrepmt,PurchCrMemoHeaderPrepmt);
//           IF PurchRcptHeader."No." <> '' THEN BEGIN
//             PurchRcptHeader.INSERT;
//             PurchRcptLine.INIT;
//             PurchRcptLine."Document No." := PurchRcptHeader."No.";
//             PurchRcptLine."Line No." := 10000;
//             PurchRcptLine.Description := SourceCode.Description;
//             PurchRcptLine.INSERT;
//           END;

//           IF ReturnShptHeader."No." <> '' THEN BEGIN
//             ReturnShptHeader.INSERT;
//             ReturnShptLine.INIT;
//             ReturnShptLine."Document No." := ReturnShptHeader."No.";
//             ReturnShptLine."Line No." := 10000;
//             ReturnShptLine.Description := SourceCode.Description;
//             ReturnShptLine.INSERT;
//           END;

//           IF PurchInvHeader."No." <> '' THEN BEGIN
//             PurchInvHeader.INSERT;
//             PurchInvLine.INIT;
//             PurchInvLine."Document No." := PurchInvHeader."No.";
//             PurchInvLine."Line No." := 10000;
//             PurchInvLine.Description := SourceCode.Description;
//             PurchInvLine.INSERT;
//           END;

//           IF PurchCrMemoHeader."No." <> '' THEN BEGIN
//             PurchCrMemoHeader.INSERT(TRUE);
//             PurchCrMemoLine.INIT;
//             PurchCrMemoLine."Document No." := PurchCrMemoHeader."No.";
//             PurchCrMemoLine."Line No." := 10000;
//             PurchCrMemoLine.Description := SourceCode.Description;
//             PurchCrMemoLine.INSERT;
//           END;

//           IF PurchInvHeaderPrepmt."No." <> '' THEN BEGIN
//             PurchInvHeaderPrepmt.INSERT;
//             PurchInvLine."Document No." := PurchInvHeaderPrepmt."No.";
//             PurchInvLine."Line No." := 10000;
//             PurchInvLine.Description := SourceCode.Description;
//             PurchInvLine.INSERT;
//           END;

//           IF PurchCrMemoHeaderPrepmt."No." <> '' THEN BEGIN
//             PurchCrMemoHeaderPrepmt.INSERT;
//             PurchCrMemoLine.INIT;
//             PurchCrMemoLine."Document No." := PurchCrMemoHeaderPrepmt."No.";
//             PurchCrMemoLine."Line No." := 10000;
//             PurchCrMemoLine.Description := SourceCode.Description;
//             PurchCrMemoLine.INSERT;
//           END;
//         END;
//     end;

//     procedure UpdateBlanketOrderLine(PurchLine: Record "39";Receive: Boolean;Ship: Boolean;Invoice: Boolean)
//     var
//         BlanketOrderPurchLine: Record "39";
//         ModifyLine: Boolean;
//         Sign: Decimal;
//     begin
//         IF PurchLine."Document Type" IN [PurchLine."Document Type"::"Return Order",PurchLine."Document Type"::"Credit Memo"] THEN
//           EXIT;
//         IF (PurchLine."Blanket Order No." <> '') AND (PurchLine."Blanket Order Line No." <> 0) AND
//            ((Receive AND (PurchLine."Qty. to Receive" <> 0)) OR
//             (Ship AND (PurchLine."Return Qty. to Ship" <> 0)) OR
//             (Invoice AND (PurchLine."Qty. to Invoice" <> 0)))
//         THEN
//           IF BlanketOrderPurchLine.GET(
//                BlanketOrderPurchLine."Document Type"::"Blanket Order",PurchLine."Blanket Order No.",
//                PurchLine."Blanket Order Line No.")
//           THEN BEGIN
//             BlanketOrderPurchLine.TESTFIELD(Type,PurchLine.Type);
//             BlanketOrderPurchLine.TESTFIELD("No.",PurchLine."No.");
//             BlanketOrderPurchLine.TESTFIELD("Buy-from Vendor No.",PurchLine."Buy-from Vendor No.");

//             ModifyLine := FALSE;
//             CASE PurchLine."Document Type" OF
//               PurchLine."Document Type"::Order,
//               PurchLine."Document Type"::Invoice:
//                 Sign := 1;
//               PurchLine."Document Type"::"Return Order",
//               PurchLine."Document Type"::"Credit Memo":
//                 Sign := -1;
//             END;
//             IF Receive AND (PurchLine."Receipt No." = '') THEN BEGIN
//               IF BlanketOrderPurchLine."Qty. per Unit of Measure" =
//                  PurchLine."Qty. per Unit of Measure"
//               THEN
//                 BlanketOrderPurchLine."Quantity Received" :=
//                   BlanketOrderPurchLine."Quantity Received" + Sign * PurchLine."Qty. to Receive"
//               ELSE
//                 BlanketOrderPurchLine."Quantity Received" :=
//                   BlanketOrderPurchLine."Quantity Received" +
//                   Sign *
//                   ROUND(
//                     (PurchLine."Qty. per Unit of Measure" /
//                      BlanketOrderPurchLine."Qty. per Unit of Measure") *
//                     PurchLine."Qty. to Receive",0.00001);
//               BlanketOrderPurchLine."Qty. Received (Base)" :=
//                 BlanketOrderPurchLine."Qty. Received (Base)" + Sign * PurchLine."Qty. to Receive (Base)";
//               ModifyLine := TRUE;
//             END;
//             IF Ship AND (PurchLine."Return Shipment No." = '') THEN BEGIN
//               IF BlanketOrderPurchLine."Qty. per Unit of Measure" =
//                  PurchLine."Qty. per Unit of Measure"
//               THEN
//                 BlanketOrderPurchLine."Quantity Received" :=
//                   BlanketOrderPurchLine."Quantity Received" + Sign * PurchLine."Return Qty. to Ship"
//               ELSE
//                 BlanketOrderPurchLine."Quantity Received" :=
//                   BlanketOrderPurchLine."Quantity Received" +
//                   Sign *
//                   ROUND(
//                     (PurchLine."Qty. per Unit of Measure" /
//                      BlanketOrderPurchLine."Qty. per Unit of Measure") *
//                     PurchLine."Return Qty. to Ship",0.00001);
//               BlanketOrderPurchLine."Qty. Received (Base)" :=
//                 BlanketOrderPurchLine."Qty. Received (Base)" + Sign * PurchLine."Return Qty. to Ship (Base)";
//               ModifyLine := TRUE;
//             END;

//             IF Invoice THEN BEGIN
//               IF BlanketOrderPurchLine."Qty. per Unit of Measure" =
//                  PurchLine."Qty. per Unit of Measure"
//               THEN
//                 BlanketOrderPurchLine."Quantity Invoiced" :=
//                   BlanketOrderPurchLine."Quantity Invoiced" + Sign * PurchLine."Qty. to Invoice"
//               ELSE
//                 BlanketOrderPurchLine."Quantity Invoiced" :=
//                   BlanketOrderPurchLine."Quantity Invoiced" +
//                   Sign *
//                   ROUND(
//                     (PurchLine."Qty. per Unit of Measure" /
//                      BlanketOrderPurchLine."Qty. per Unit of Measure") *
//                     PurchLine."Qty. to Invoice",0.00001);
//               BlanketOrderPurchLine."Qty. Invoiced (Base)" :=
//                 BlanketOrderPurchLine."Qty. Invoiced (Base)" + Sign * PurchLine."Qty. to Invoice (Base)";
//               ModifyLine := TRUE;
//             END;

//             IF ModifyLine THEN BEGIN
//               BlanketOrderPurchLine.InitOutstanding;

//               IF (BlanketOrderPurchLine.Quantity *
//                   BlanketOrderPurchLine."Quantity Received" < 0) OR
//                  (ABS(BlanketOrderPurchLine.Quantity) <
//                   ABS(BlanketOrderPurchLine."Quantity Received"))
//               THEN
//                 BlanketOrderPurchLine.FIELDERROR(
//                   "Quantity Received",
//                   STRSUBSTNO(
//                     Text023,
//                     BlanketOrderPurchLine.FIELDCAPTION(Quantity)));

//               IF (BlanketOrderPurchLine."Quantity (Base)" *
//                   BlanketOrderPurchLine."Qty. Received (Base)" < 0) OR
//                  (ABS(BlanketOrderPurchLine."Quantity (Base)") <
//                   ABS(BlanketOrderPurchLine."Qty. Received (Base)"))
//               THEN
//                 BlanketOrderPurchLine.FIELDERROR(
//                   "Qty. Received (Base)",
//                   STRSUBSTNO(
//                     Text023,
//                     BlanketOrderPurchLine.FIELDCAPTION("Quantity Received")));

//               BlanketOrderPurchLine.CALCFIELDS("Reserved Qty. (Base)");
//               IF ABS(BlanketOrderPurchLine."Outstanding Qty. (Base)") <
//                  ABS(BlanketOrderPurchLine."Reserved Qty. (Base)")
//               THEN
//                 BlanketOrderPurchLine.FIELDERROR(
//                   "Reserved Qty. (Base)",Text024);

//               BlanketOrderPurchLine."Qty. to Invoice" :=
//                 BlanketOrderPurchLine.Quantity - BlanketOrderPurchLine."Quantity Invoiced";
//               BlanketOrderPurchLine."Qty. to Receive" :=
//                 BlanketOrderPurchLine.Quantity - BlanketOrderPurchLine."Quantity Received";
//               BlanketOrderPurchLine."Qty. to Invoice (Base)" :=
//                 BlanketOrderPurchLine."Quantity (Base)" - BlanketOrderPurchLine."Qty. Invoiced (Base)";
//               BlanketOrderPurchLine."Qty. to Receive (Base)" :=
//                 BlanketOrderPurchLine."Quantity (Base)" - BlanketOrderPurchLine."Qty. Received (Base)";

//               BlanketOrderPurchLine.MODIFY;
//             END;
//           END;
//     end;

//     local procedure UpdatePurchaseHeader(VendorLedgerEntry: Record "25")
//     begin
//         CASE GenJnlLineDocType OF
//           GenJnlLine."Document Type"::Invoice:
//             BEGIN
//               FindVendorLedgerEntry(GenJnlLineDocType,GenJnlLineDocNo,VendorLedgerEntry);
//               PurchInvHeader."Vendor Ledger Entry No." := VendorLedgerEntry."Entry No.";
//               PurchInvHeader.MODIFY;
//             END;
//           GenJnlLine."Document Type"::"Credit Memo":
//             BEGIN
//               FindVendorLedgerEntry(GenJnlLineDocType,GenJnlLineDocNo,VendorLedgerEntry);
//               PurchCrMemoHeader."Vendor Ledger Entry No." := VendorLedgerEntry."Entry No.";
//               PurchCrMemoHeader.MODIFY;
//             END;
//         END;
//     end;

//     local procedure FindVendorLedgerEntry(DocType: Option;DocNo: Code[20];var VendorLedgerEntry: Record "25")
//     begin
//         VendorLedgerEntry.SETRANGE("Document Type",DocType);
//         VendorLedgerEntry.SETRANGE("Document No.",DocNo);
//         VendorLedgerEntry.FINDLAST;
//     end;

//     local procedure CopyCommentLines(FromDocumentType: Integer;ToDocumentType: Integer;FromNumber: Code[20];ToNumber: Code[20])
//     begin
//         PurchCommentLine.SETRANGE("Document Type",FromDocumentType);
//         PurchCommentLine.SETRANGE("No.",FromNumber);
//         IF PurchCommentLine.FINDSET THEN
//           REPEAT
//             PurchCommentLine2 := PurchCommentLine;
//             PurchCommentLine2."Document Type" := ToDocumentType;
//             PurchCommentLine2."No." := ToNumber;
//             PurchCommentLine2.INSERT;
//           UNTIL PurchCommentLine.NEXT = 0;
//     end;

//     local procedure RunGenJnlPostLine(var GenJnlLine: Record "81"): Integer
//     begin
//         EXIT(GenJnlPostLine.RunWithCheck(GenJnlLine));
//     end;

//     local procedure CheckDim()
//     var
//         PurchLine2: Record "39";
//     begin
//         PurchLine2."Line No." := 0;
//         CheckDimComb(PurchLine2);
//         CheckDimValuePosting(PurchLine2);

//         PurchLine2.SETRANGE("Document Type",PurchHeader."Document Type");
//         PurchLine2.SETRANGE("Document No.",PurchHeader."No.");
//         PurchLine2.SETFILTER(Type,'<>%1',PurchLine2.Type::" ");
//         IF PurchLine2.FINDSET THEN
//           REPEAT
//             IF (PurchHeader.Receive AND (PurchLine2."Qty. to Receive" <> 0)) OR
//                (PurchHeader.Invoice AND (PurchLine2."Qty. to Invoice" <> 0)) OR
//                (PurchHeader.Ship AND (PurchLine2."Return Qty. to Ship" <> 0))
//             THEN BEGIN
//               CheckDimComb(PurchLine2);
//               CheckDimValuePosting(PurchLine2);
//             END
//           UNTIL PurchLine2.NEXT = 0;
//     end;

//     local procedure CheckDimComb(PurchLine: Record "39")
//     begin
//         IF PurchLine."Line No." = 0 THEN
//           IF NOT DimMgt.CheckDimIDComb(PurchHeader."Dimension Set ID") THEN
//             ERROR(
//               Text032,
//               PurchHeader."Document Type",PurchHeader."No.",DimMgt.GetDimCombErr);

//         IF PurchLine."Line No." <> 0 THEN
//           IF NOT DimMgt.CheckDimIDComb(PurchLine."Dimension Set ID") THEN
//             ERROR(
//               Text033,
//               PurchHeader."Document Type",PurchHeader."No.",PurchLine."Line No.",DimMgt.GetDimCombErr);
//     end;

//     local procedure CheckDimValuePosting(var PurchLine2: Record "39")
//     var
//         TableIDArr: array [10] of Integer;
//         NumberArr: array [10] of Code[20];
//     begin
//         IF PurchLine2."Line No." = 0 THEN BEGIN
//           TableIDArr[1] := DATABASE::Vendor;
//           NumberArr[1] := PurchHeader."Pay-to Vendor No.";
//           TableIDArr[2] := DATABASE::"Salesperson/Purchaser";
//           NumberArr[2] := PurchHeader."Purchaser Code";
//           TableIDArr[3] := DATABASE::Campaign;
//           NumberArr[3] := PurchHeader."Campaign No.";
//           TableIDArr[4] := DATABASE::"Responsibility Center";
//           NumberArr[4] := PurchHeader."Responsibility Center";
//           IF NOT DimMgt.CheckDimValuePosting(TableIDArr,NumberArr,PurchHeader."Dimension Set ID") THEN
//             ERROR(
//               Text034,
//               PurchHeader."Document Type",PurchHeader."No.",DimMgt.GetDimValuePostingErr);
//         END ELSE BEGIN
//           TableIDArr[1] := DimMgt.TypeToTableID3(PurchLine2.Type);
//           NumberArr[1] := PurchLine2."No.";
//           TableIDArr[2] := DATABASE::Job;
//           NumberArr[2] := PurchLine2."Job No.";
//           TableIDArr[3] := DATABASE::"Work Center";
//           NumberArr[3] := PurchLine2."Work Center No.";
//           IF NOT DimMgt.CheckDimValuePosting(TableIDArr,NumberArr,PurchLine2."Dimension Set ID") THEN
//             ERROR(
//               Text035,
//               PurchHeader."Document Type",PurchHeader."No.",PurchLine2."Line No.",DimMgt.GetDimValuePostingErr);
//         END;
//     end;

//     procedure CopyAprvlToTempApprvl()
//     begin
//         TempApprovalEntry.RESET;
//         TempApprovalEntry.DELETEALL;
//         ApprovalEntry.SETRANGE("Table ID",DATABASE::"Purchase Header");
//         ApprovalEntry.SETRANGE("Document Type",PurchHeader."Document Type");
//         ApprovalEntry.SETRANGE("Document No.",PurchHeader."No.");
//         IF ApprovalEntry.FIND('-') THEN
//           REPEAT
//             TempApprovalEntry.INIT;
//             TempApprovalEntry := ApprovalEntry;
//             TempApprovalEntry.INSERT;
//           UNTIL ApprovalEntry.NEXT = 0;
//     end;

//     local procedure DeleteItemChargeAssgnt()
//     var
//         ItemChargeAssgntPurch: Record "5805";
//     begin
//         ItemChargeAssgntPurch.SETRANGE("Document Type",PurchLine."Document Type");
//         ItemChargeAssgntPurch.SETRANGE("Document No.",PurchLine."Document No.");
//         IF NOT ItemChargeAssgntPurch.ISEMPTY THEN
//           ItemChargeAssgntPurch.DELETEALL;
//     end;

//     local procedure UpdateItemChargeAssgnt()
//     var
//         ItemChargeAssgntPurch: Record "5805";
//     begin
//         WITH TempItemChargeAssgntPurch DO BEGIN
//           ClearItemChargeAssgntFilter;
//           MARKEDONLY(TRUE);
//           IF FINDSET THEN
//             REPEAT
//               ItemChargeAssgntPurch.GET("Document Type","Document No.","Document Line No.","Line No.");
//               ItemChargeAssgntPurch."Qty. Assigned" :=
//                 ItemChargeAssgntPurch."Qty. Assigned" + "Qty. to Assign";
//               ItemChargeAssgntPurch."Qty. to Assign" := 0;
//               ItemChargeAssgntPurch."Amount to Assign" := 0;
//               ItemChargeAssgntPurch.MODIFY;
//             UNTIL NEXT = 0;
//         END;
//     end;

//     local procedure UpdatePurchOrderChargeAssgnt(PurchOrderInvLine: Record "39";PurchOrderLine: Record "39")
//     var
//         PurchOrderLine2: Record "39";
//         PurchOrderInvLine2: Record "39";
//         PurchRcptLine: Record "121";
//     begin
//         WITH PurchOrderInvLine DO BEGIN
//           ClearItemChargeAssgntFilter;
//           TempItemChargeAssgntPurch.SETRANGE("Document Type","Document Type");
//           TempItemChargeAssgntPurch.SETRANGE("Document No.","Document No.");
//           TempItemChargeAssgntPurch.SETRANGE("Document Line No.","Line No.");
//           TempItemChargeAssgntPurch.MARKEDONLY(TRUE);
//           IF TempItemChargeAssgntPurch.FINDSET THEN
//             REPEAT
//               IF TempItemChargeAssgntPurch."Applies-to Doc. Type" = "Document Type" THEN BEGIN
//                 PurchOrderInvLine2.GET(
//                   TempItemChargeAssgntPurch."Applies-to Doc. Type",
//                   TempItemChargeAssgntPurch."Applies-to Doc. No.",
//                   TempItemChargeAssgntPurch."Applies-to Doc. Line No.");
//                 IF ((PurchOrderLine."Document Type" = PurchOrderLine."Document Type"::Order) AND
//                     (PurchOrderInvLine2."Receipt No." = "Receipt No.")) OR
//                    ((PurchOrderLine."Document Type" = PurchOrderLine."Document Type"::"Return Order") AND
//                     (PurchOrderInvLine2."Return Shipment No." = "Return Shipment No."))
//                 THEN BEGIN
//                   IF PurchLine."Document Type" IN ["Document Type"::Order,"Document Type"::Invoice] THEN BEGIN
//                     IF NOT
//                        PurchRcptLine.GET(PurchOrderInvLine2."Receipt No.",PurchOrderInvLine2."Receipt Line No.")
//                     THEN
//                       ERROR(Text014);
//                     PurchOrderLine2.GET(
//                       PurchOrderLine2."Document Type"::Order,
//                       PurchRcptLine."Order No.",PurchRcptLine."Order Line No.");
//                   END ELSE BEGIN
//                     IF NOT
//                        ReturnShptLine.GET(PurchOrderInvLine2."Return Shipment No.",PurchOrderInvLine2."Return Shipment Line No.")
//                     THEN
//                       ERROR(Text040);
//                     PurchOrderLine2.GET(
//                       PurchOrderLine2."Document Type"::"Return Order",
//                       ReturnShptLine."Return Order No.",ReturnShptLine."Return Order Line No.");
//                   END;
//                   UpdatePurchChargeAssgntLines(
//                     PurchOrderLine,
//                     PurchOrderLine2."Document Type",
//                     PurchOrderLine2."Document No.",
//                     PurchOrderLine2."Line No.",
//                     TempItemChargeAssgntPurch."Qty. to Assign");
//                 END;
//               END ELSE
//                 UpdatePurchChargeAssgntLines(
//                   PurchOrderLine,
//                   TempItemChargeAssgntPurch."Applies-to Doc. Type",
//                   TempItemChargeAssgntPurch."Applies-to Doc. No.",
//                   TempItemChargeAssgntPurch."Applies-to Doc. Line No.",
//                   TempItemChargeAssgntPurch."Qty. to Assign");
//             UNTIL TempItemChargeAssgntPurch.NEXT = 0;
//         END;
//     end;

//     local procedure UpdatePurchChargeAssgntLines(PurchOrderLine: Record "39";ApplToDocType: Option;ApplToDocNo: Code[20];ApplToDocLineNo: Integer;QtytoAssign: Decimal)
//     var
//         ItemChargeAssgntPurch: Record "5805";
//         TempItemChargeAssgntPurch2: Record "5805";
//         LastLineNo: Integer;
//         TotalToAssign: Decimal;
//     begin
//         ItemChargeAssgntPurch.SETRANGE("Document Type",PurchOrderLine."Document Type");
//         ItemChargeAssgntPurch.SETRANGE("Document No.",PurchOrderLine."Document No.");
//         ItemChargeAssgntPurch.SETRANGE("Document Line No.",PurchOrderLine."Line No.");
//         ItemChargeAssgntPurch.SETRANGE("Applies-to Doc. Type",ApplToDocType);
//         ItemChargeAssgntPurch.SETRANGE("Applies-to Doc. No.",ApplToDocNo);
//         ItemChargeAssgntPurch.SETRANGE("Applies-to Doc. Line No.",ApplToDocLineNo);
//         IF ItemChargeAssgntPurch.FINDFIRST THEN BEGIN
//           ItemChargeAssgntPurch."Qty. Assigned" :=
//             ItemChargeAssgntPurch."Qty. Assigned" + QtytoAssign;
//           ItemChargeAssgntPurch."Qty. to Assign" := 0;
//           ItemChargeAssgntPurch."Amount to Assign" := 0;
//           ItemChargeAssgntPurch.MODIFY;
//         END ELSE BEGIN
//           ItemChargeAssgntPurch.SETRANGE("Applies-to Doc. Type");
//           ItemChargeAssgntPurch.SETRANGE("Applies-to Doc. No.");
//           ItemChargeAssgntPurch.SETRANGE("Applies-to Doc. Line No.");
//           ItemChargeAssgntPurch.CALCSUMS("Qty. to Assign");

//           TempItemChargeAssgntPurch2.SETRANGE("Document Type",TempItemChargeAssgntPurch."Document Type");
//           TempItemChargeAssgntPurch2.SETRANGE("Document No.",TempItemChargeAssgntPurch."Document No.");
//           TempItemChargeAssgntPurch2.SETRANGE("Document Line No.",TempItemChargeAssgntPurch."Document Line No.");
//           TempItemChargeAssgntPurch2.CALCSUMS("Qty. to Assign");

//           TotalToAssign := ItemChargeAssgntPurch."Qty. to Assign" +
//             TempItemChargeAssgntPurch2."Qty. to Assign";

//           IF ItemChargeAssgntPurch.FINDLAST THEN
//             LastLineNo := ItemChargeAssgntPurch."Line No.";

//           IF PurchOrderLine.Quantity < TotalToAssign THEN
//             REPEAT
//               TotalToAssign := TotalToAssign - ItemChargeAssgntPurch."Qty. to Assign";
//               ItemChargeAssgntPurch."Qty. to Assign" := 0;
//               ItemChargeAssgntPurch."Amount to Assign" := 0;
//               ItemChargeAssgntPurch.MODIFY;
//             UNTIL (ItemChargeAssgntPurch.NEXT(-1) = 0) OR
//                   (TotalToAssign = PurchOrderLine.Quantity);

//           InsertAssocOrderCharge(
//             PurchOrderLine,
//             ApplToDocType,
//             ApplToDocNo,
//             ApplToDocLineNo,
//             LastLineNo,
//             TempItemChargeAssgntPurch."Applies-to Doc. Line Amount");
//         END;
//     end;

//     local procedure InsertAssocOrderCharge(PurchOrderLine: Record "39";ApplToDocType: Option;ApplToDocNo: Code[20];ApplToDocLineNo: Integer;LastLineNo: Integer;ApplToDocLineAmt: Decimal)
//     var
//         NewItemChargeAssgntPurch: Record "5805";
//     begin
//         WITH NewItemChargeAssgntPurch DO BEGIN
//           INIT;
//           "Document Type" := PurchOrderLine."Document Type";
//           "Document No." := PurchOrderLine."Document No.";
//           "Document Line No." := PurchOrderLine."Line No.";
//           "Line No." := LastLineNo + 10000;
//           "Item Charge No." := TempItemChargeAssgntPurch."Item Charge No.";
//           "Item No." := TempItemChargeAssgntPurch."Item No.";
//           "Qty. Assigned" := TempItemChargeAssgntPurch."Qty. to Assign";
//           "Qty. to Assign" := 0;
//           "Amount to Assign" := 0;
//           Description := TempItemChargeAssgntPurch.Description;
//           "Unit Cost" := TempItemChargeAssgntPurch."Unit Cost";
//           "Applies-to Doc. Type" := ApplToDocType;
//           "Applies-to Doc. No." := ApplToDocNo;
//           "Applies-to Doc. Line No." := ApplToDocLineNo;
//           "Applies-to Doc. Line Amount" := ApplToDocLineAmt;
//           INSERT;
//         END;
//     end;

//     local procedure CopyAndCheckItemCharge(PurchHeader: Record "38")
//     var
//         PurchLine2: Record "39";
//         PurchLine3: Record "39";
//         InvoiceEverything: Boolean;
//         AssignError: Boolean;
//         QtyNeeded: Decimal;
//     begin
//         TempItemChargeAssgntPurch.RESET;
//         TempItemChargeAssgntPurch.DELETEALL;

//         // Check for max qty posting
//         PurchLine2.RESET;
//         PurchLine2.SETRANGE("Document Type",PurchHeader."Document Type");
//         PurchLine2.SETRANGE("Document No.",PurchHeader."No.");
//         PurchLine2.SETRANGE(Type,PurchLine2.Type::"Charge (Item)");
//         IF PurchLine2.ISEMPTY THEN
//           EXIT;

//         PurchLine2.FINDSET;
//         REPEAT
//           ItemChargeAssgntPurch.RESET;
//           ItemChargeAssgntPurch.SETRANGE("Document Type",PurchLine2."Document Type");
//           ItemChargeAssgntPurch.SETRANGE("Document No.",PurchLine2."Document No.");
//           ItemChargeAssgntPurch.SETRANGE("Document Line No.",PurchLine2."Line No.");
//           ItemChargeAssgntPurch.SETFILTER("Qty. to Assign",'<>0');
//           IF ItemChargeAssgntPurch.FINDSET THEN
//             REPEAT
//               TempItemChargeAssgntPurch.INIT;
//               TempItemChargeAssgntPurch := ItemChargeAssgntPurch;
//               TempItemChargeAssgntPurch.INSERT;
//             UNTIL ItemChargeAssgntPurch.NEXT = 0;

//           IF PurchLine2."Qty. to Invoice" <> 0 THEN BEGIN
//             PurchLine2.TESTFIELD("Job No.",'');
//             IF PurchHeader.Invoice AND
//                (PurchLine2."Qty. to Receive" + PurchLine2."Return Qty. to Ship" <> 0) AND
//                ((PurchHeader.Ship OR PurchHeader.Receive) OR
//                 (ABS(PurchLine2."Qty. to Invoice") >
//                  ABS(PurchLine2."Qty. Rcd. Not Invoiced" + PurchLine2."Qty. to Receive") +
//                  ABS(PurchLine2."Ret. Qty. Shpd Not Invd.(Base)" + PurchLine2."Return Qty. to Ship")))
//             THEN
//               PurchLine2.TESTFIELD("Line Amount");

//             IF NOT PurchHeader.Receive THEN
//               PurchLine2."Qty. to Receive" := 0;
//             IF NOT PurchHeader.Ship THEN
//               PurchLine2."Return Qty. to Ship" := 0;
//             IF ABS(PurchLine2."Qty. to Invoice") >
//                ABS(PurchLine2."Quantity Received" + PurchLine2."Qty. to Receive" +
//                  PurchLine2."Return Qty. Shipped" + PurchLine2."Return Qty. to Ship" -
//                  PurchLine2."Quantity Invoiced")
//             THEN
//               PurchLine2."Qty. to Invoice" :=
//                 PurchLine2."Quantity Received" + PurchLine2."Qty. to Receive" +
//                 PurchLine2."Return Qty. Shipped (Base)" + PurchLine2."Return Qty. to Ship (Base)" -
//                 PurchLine2."Quantity Invoiced";

//             PurchLine2.CALCFIELDS("Qty. to Assign","Qty. Assigned");
//             IF ABS(PurchLine2."Qty. to Assign" + PurchLine2."Qty. Assigned") >
//                ABS(PurchLine2."Qty. to Invoice" + PurchLine2."Quantity Invoiced")
//             THEN
//               ERROR(Text036,
//                 PurchLine2."Qty. to Invoice" + PurchLine2."Quantity Invoiced" -
//                 PurchLine2."Qty. Assigned",PurchLine2.FIELDCAPTION("Document Type"),
//                 PurchLine2."Document Type",PurchLine2.FIELDCAPTION("Document No."),
//                 PurchLine2."Document No.",PurchLine2.FIELDCAPTION("Line No."),
//                 PurchLine2."Line No.");
//             IF PurchLine2.Quantity =
//                PurchLine2."Qty. to Invoice" + PurchLine2."Quantity Invoiced"
//             THEN BEGIN
//               IF PurchLine2."Qty. to Assign" <> 0 THEN BEGIN
//                 IF PurchLine2.Quantity = PurchLine2."Quantity Invoiced" THEN BEGIN
//                   TempItemChargeAssgntPurch.SETRANGE("Document Line No.",PurchLine2."Line No.");
//                   TempItemChargeAssgntPurch.SETRANGE("Applies-to Doc. Type",PurchLine2."Document Type");
//                   IF TempItemChargeAssgntPurch.FINDSET THEN
//                     REPEAT
//                       PurchLine3.GET(
//                         TempItemChargeAssgntPurch."Applies-to Doc. Type",
//                         TempItemChargeAssgntPurch."Applies-to Doc. No.",
//                         TempItemChargeAssgntPurch."Applies-to Doc. Line No.");
//                       IF PurchLine3.Quantity = PurchLine3."Quantity Invoiced" THEN
//                         ERROR(Text038,PurchLine3.TABLECAPTION,
//                           PurchLine3.FIELDCAPTION("Document Type"),PurchLine3."Document Type",
//                           PurchLine3.FIELDCAPTION("Document No."),PurchLine3."Document No.",
//                           PurchLine3.FIELDCAPTION("Line No."),PurchLine3."Line No.");
//                     UNTIL TempItemChargeAssgntPurch.NEXT = 0;
//                 END;
//               END;
//               IF PurchLine2.Quantity <>
//                  PurchLine2."Qty. to Assign" + PurchLine2."Qty. Assigned"
//               THEN
//                 AssignError := TRUE;
//             END;

//             IF (PurchLine2."Qty. to Assign" + PurchLine2."Qty. Assigned") <
//                (PurchLine2."Qty. to Invoice" + PurchLine2."Quantity Invoiced")
//             THEN
//               ERROR(Text059,PurchLine2."No.");

//             // check if all ILEs exist
//             QtyNeeded := PurchLine2."Qty. to Assign";
//             TempItemChargeAssgntPurch.SETRANGE("Document Line No.",PurchLine2."Line No.");
//             IF TempItemChargeAssgntPurch.FINDSET THEN
//               REPEAT
//                 IF (TempItemChargeAssgntPurch."Applies-to Doc. Type" <> PurchLine2."Document Type") OR
//                    (TempItemChargeAssgntPurch."Applies-to Doc. No." <> PurchLine2."Document No.")
//                 THEN
//                   QtyNeeded := QtyNeeded - TempItemChargeAssgntPurch."Qty. to Assign"
//                 ELSE BEGIN
//                   PurchLine3.GET(
//                     TempItemChargeAssgntPurch."Applies-to Doc. Type",
//                     TempItemChargeAssgntPurch."Applies-to Doc. No.",
//                     TempItemChargeAssgntPurch."Applies-to Doc. Line No.");
//                   IF ItemLedgerEntryExist(PurchLine3) THEN
//                     QtyNeeded := QtyNeeded - TempItemChargeAssgntPurch."Qty. to Assign";
//                 END;
//               UNTIL TempItemChargeAssgntPurch.NEXT = 0;

//             IF QtyNeeded > 0 THEN
//               ERROR(Text060,PurchLine2."No.");
//           END;
//         UNTIL PurchLine2.NEXT = 0;

//         // Check purchlines
//         IF AssignError THEN
//           IF PurchHeader."Document Type" IN
//              [PurchHeader."Document Type"::Invoice,PurchHeader."Document Type"::"Credit Memo"]
//           THEN
//             InvoiceEverything := TRUE
//           ELSE BEGIN
//             PurchLine2.RESET;
//             PurchLine2.SETRANGE("Document Type",PurchHeader."Document Type");
//             PurchLine2.SETRANGE("Document No.",PurchHeader."No.");
//             PurchLine2.SETFILTER(Type,'%1|%2',PurchLine2.Type::Item,PurchLine2.Type::"Charge (Item)");
//             IF PurchLine2.FINDSET THEN
//               REPEAT
//                 IF PurchHeader.Ship OR PurchHeader.Receive THEN
//                   InvoiceEverything :=
//                     PurchLine2.Quantity = PurchLine2."Qty. to Invoice" + PurchLine2."Quantity Invoiced"
//                 ELSE
//                   InvoiceEverything :=
//                     (PurchLine2.Quantity = PurchLine2."Qty. to Invoice" + PurchLine2."Quantity Invoiced") AND
//                     (PurchLine2."Qty. to Invoice" =
//                      PurchLine2."Qty. Rcd. Not Invoiced" + PurchLine2."Return Qty. Shipped Not Invd.");
//               UNTIL (PurchLine2.NEXT = 0) OR (NOT InvoiceEverything);
//           END;

//         IF InvoiceEverything AND AssignError THEN
//           ERROR(Text037);
//     end;

//     local procedure ClearItemChargeAssgntFilter()
//     begin
//         TempItemChargeAssgntPurch.SETRANGE("Document Line No.");
//         TempItemChargeAssgntPurch.SETRANGE("Applies-to Doc. Type");
//         TempItemChargeAssgntPurch.SETRANGE("Applies-to Doc. No.");
//         TempItemChargeAssgntPurch.SETRANGE("Applies-to Doc. Line No.");
//         TempItemChargeAssgntPurch.MARKEDONLY(FALSE);
//     end;

//     local procedure GetItemChargeLine(var ItemChargePurchLine: Record "39")
//     begin
//         WITH TempItemChargeAssgntPurch DO BEGIN
//           IF (ItemChargePurchLine."Document Type" <> "Document Type") OR
//              (ItemChargePurchLine."Document No." <> "Document No.") OR
//              (ItemChargePurchLine."Line No." <> "Document Line No.")
//           THEN BEGIN
//             ItemChargePurchLine.GET("Document Type","Document No.","Document Line No.");
//             IF NOT PurchHeader.Receive THEN
//               PurchLine2."Qty. to Receive" := 0;
//             IF NOT PurchHeader.Ship THEN
//               PurchLine2."Return Qty. to Ship" := 0;
//             IF ABS(PurchLine2."Qty. to Invoice") >
//                ABS(PurchLine2."Quantity Received" + PurchLine2."Qty. to Receive" +
//                  PurchLine2."Return Qty. Shipped" + PurchLine2."Return Qty. to Ship" -
//                  PurchLine2."Quantity Invoiced")
//             THEN
//               PurchLine2."Qty. to Invoice" :=
//                 PurchLine2."Quantity Received" + PurchLine2."Qty. to Receive" +
//                 PurchLine2."Return Qty. Shipped (Base)" + PurchLine2."Return Qty. to Ship (Base)" -
//                 PurchLine2."Quantity Invoiced";
//           END;
//         END;
//     end;

//     local procedure OnlyAssgntPosting(): Boolean
//     var
//         PurchLine: Record "39";
//         QtyLeftToAssign: Boolean;
//     begin
//         WITH PurchHeader DO BEGIN
//           ItemChargeAssgntOnly := FALSE;
//           QtyLeftToAssign := FALSE;
//           PurchLine.SETRANGE("Document Type","Document Type");
//           PurchLine.SETRANGE("Document No.","No.");
//           PurchLine.SETRANGE(Type,PurchLine.Type::"Charge (Item)");
//           IF PurchLine.FINDSET THEN
//             REPEAT
//               PurchLine.CALCFIELDS("Qty. Assigned");
//               IF PurchLine."Quantity Invoiced" > PurchLine."Qty. Assigned" THEN
//                 QtyLeftToAssign := TRUE;
//             UNTIL PurchLine.NEXT = 0;

//           IF QtyLeftToAssign THEN
//             CopyAndCheckItemCharge(PurchHeader);
//           ClearItemChargeAssgntFilter;
//           TempItemChargeAssgntPurch.SETCURRENTKEY("Applies-to Doc. Type");
//           TempItemChargeAssgntPurch.SETFILTER("Applies-to Doc. Type",'<>%1',"Document Type");
//           PurchLine.SETRANGE(Type);
//           PurchLine.SETRANGE("Quantity Invoiced");
//           PurchLine.SETFILTER("Qty. to Assign",'<>0');
//           IF PurchLine.FINDSET THEN
//             REPEAT
//               TempItemChargeAssgntPurch.SETRANGE("Document Line No.",PurchLine."Line No.");
//               IF TempItemChargeAssgntPurch.FINDFIRST THEN
//                 ItemChargeAssgntOnly := TRUE;
//             UNTIL (PurchLine.NEXT = 0) OR ItemChargeAssgntOnly
//           ELSE
//             ItemChargeAssgntOnly := FALSE;
//         END;
//         EXIT(ItemChargeAssgntOnly);
//     end;

//     local procedure CalcQtyToInvoice(QtyToHandle: Decimal;QtyToInvoice: Decimal): Decimal
//     begin
//         IF ABS(QtyToHandle) > ABS(QtyToInvoice) THEN
//           EXIT(QtyToHandle);

//         EXIT(QtyToInvoice);
//     end;

//     local procedure GetGLSetup()
//     begin
//         IF NOT GLSetupRead THEN
//           GLSetup.GET;
//         GLSetupRead := TRUE;
//     end;

//     local procedure CheckWarehouse(var PurchLine: Record "39")
//     var
//         PurchLine2: Record "39";
//         WhseValidateSourceLine: Codeunit "5777";
//         ShowError: Boolean;
//     begin
//         PurchLine2.COPY(PurchLine);
//         IF PurchLine2."Prod. Order No." <> '' THEN
//           EXIT;
//         PurchLine2.SETRANGE(Type,PurchLine2.Type::Item);
//         PurchLine2.SETRANGE("Drop Shipment",FALSE);
//         IF PurchLine2.FINDSET THEN
//           REPEAT
//             GetLocation(PurchLine2."Location Code");
//             CASE PurchLine2."Document Type" OF
//               PurchLine2."Document Type"::Order:
//                 IF ((Location."Require Receive" OR Location."Require Put-away") AND
//                     (PurchLine2.Quantity >= 0)) OR
//                    ((Location."Require Shipment" OR Location."Require Pick") AND
//                     (PurchLine2.Quantity < 0))
//                 THEN BEGIN
//                   IF Location."Directed Put-away and Pick" THEN
//                     ShowError := TRUE
//                   ELSE
//                     IF WhseValidateSourceLine.WhseLinesExist(
//                          DATABASE::"Purchase Line",
//                          PurchLine2."Document Type",
//                          PurchLine2."Document No.",
//                          PurchLine2."Line No.",
//                          0,
//                          PurchLine2.Quantity)
//                     THEN
//                       ShowError := TRUE;
//                 END;
//               PurchLine2."Document Type"::"Return Order":
//                 IF ((Location."Require Receive" OR Location."Require Put-away") AND
//                     (PurchLine2.Quantity < 0)) OR
//                    ((Location."Require Shipment" OR Location."Require Pick") AND
//                     (PurchLine2.Quantity >= 0))
//                 THEN BEGIN
//                   IF Location."Directed Put-away and Pick" THEN
//                     ShowError := TRUE
//                   ELSE
//                     IF WhseValidateSourceLine.WhseLinesExist(
//                          DATABASE::"Purchase Line",
//                          PurchLine2."Document Type",
//                          PurchLine2."Document No.",
//                          PurchLine2."Line No.",
//                          0,
//                          PurchLine2.Quantity)
//                     THEN
//                       ShowError := TRUE;
//                 END;
//               PurchLine2."Document Type"::Invoice,PurchLine2."Document Type"::"Credit Memo":
//                 IF Location."Directed Put-away and Pick" THEN
//                   Location.TESTFIELD("Adjustment Bin Code");
//             END;
//             IF ShowError THEN
//               ERROR(
//                 Text026,
//                 PurchLine2.FIELDCAPTION("Document Type"),
//                 PurchLine2."Document Type",
//                 PurchLine2.FIELDCAPTION("Document No."),
//                 PurchLine2."Document No.",
//                 PurchLine2.FIELDCAPTION("Line No."),
//                 PurchLine2."Line No.");
//           UNTIL PurchLine2.NEXT = 0;
//     end;

//     local procedure CreateWhseJnlLine(ItemJnlLine: Record "83";PurchLine: Record "39";var TempWhseJnlLine: Record "7311" temporary)
//     var
//         WhseMgt: Codeunit "5775";
//     begin
//         WITH PurchLine DO BEGIN
//           WMSMgmt.CheckAdjmtBin(Location,ItemJnlLine.Quantity,TRUE);
//           WMSMgmt.CreateWhseJnlLine(ItemJnlLine,0,TempWhseJnlLine,FALSE);
//           TempWhseJnlLine."Source Type" := DATABASE::"Purchase Line";
//           TempWhseJnlLine."Source Subtype" := "Document Type";
//           TempWhseJnlLine."Source Document" := WhseMgt.GetSourceDocument(TempWhseJnlLine."Source Type",TempWhseJnlLine."Source Subtype");
//           TempWhseJnlLine."Source No." := "Document No.";
//           TempWhseJnlLine."Source Line No." := "Line No.";
//           TempWhseJnlLine."Source Code" := SrcCode;
//           CASE "Document Type" OF
//             "Document Type"::Order:
//               TempWhseJnlLine."Reference Document" :=
//                 TempWhseJnlLine."Reference Document"::"Posted Rcpt.";
//             "Document Type"::Invoice:
//               TempWhseJnlLine."Reference Document" :=
//                 TempWhseJnlLine."Reference Document"::"Posted P. Inv.";
//             "Document Type"::"Credit Memo":
//               TempWhseJnlLine."Reference Document" :=
//                 TempWhseJnlLine."Reference Document"::"Posted P. Cr. Memo";
//             "Document Type"::"Return Order":
//               TempWhseJnlLine."Reference Document" :=
//                 TempWhseJnlLine."Reference Document"::"Posted Rtrn. Rcpt.";
//           END;
//           TempWhseJnlLine."Reference No." := ItemJnlLine."Document No.";
//         END;
//     end;

//     local procedure WhseHandlingRequired(): Boolean
//     var
//         WhseSetup: Record "5769";
//     begin
//         IF (PurchLine.Type = PurchLine.Type::Item) AND
//            (NOT PurchLine."Drop Shipment")
//         THEN BEGIN
//           IF PurchLine."Location Code" = '' THEN BEGIN
//             WhseSetup.GET;
//             IF PurchLine."Document Type" = PurchLine."Document Type"::"Return Order" THEN
//               EXIT(WhseSetup."Require Pick");

//             EXIT(WhseSetup."Require Receive");
//           END;

//           GetLocation(PurchLine."Location Code");
//           IF PurchLine."Document Type" = PurchLine."Document Type"::"Return Order" THEN
//             EXIT(Location."Require Pick");

//           EXIT(Location."Require Receive");

//         END;
//         EXIT(FALSE);
//     end;

//     local procedure GetLocation(LocationCode: Code[10])
//     begin
//         IF LocationCode = '' THEN
//           Location.GetLocationSetup(LocationCode,Location)
//         ELSE
//           IF Location.Code <> LocationCode THEN
//             Location.GET(LocationCode);
//     end;

//     local procedure InsertRcptEntryRelation(var PurchRcptLine: Record "121"): Integer
//     var
//         ItemEntryRelation: Record "6507";
//     begin
//         TempTrackingSpecificationInv.RESET;
//         IF TempTrackingSpecificationInv.FINDSET THEN BEGIN
//           REPEAT
//             TempHandlingSpecification := TempTrackingSpecificationInv;
//             IF TempHandlingSpecification.INSERT THEN;
//           UNTIL TempTrackingSpecificationInv.NEXT = 0;
//           TempTrackingSpecificationInv.DELETEALL;
//         END;

//         TempHandlingSpecification.RESET;
//         IF TempHandlingSpecification.FINDSET THEN BEGIN
//           REPEAT
//             ItemEntryRelation.INIT;
//             ItemEntryRelation."Item Entry No." := TempHandlingSpecification."Entry No.";
//             ItemEntryRelation."Serial No." := TempHandlingSpecification."Serial No.";
//             ItemEntryRelation."Lot No." := TempHandlingSpecification."Lot No.";
//             ItemEntryRelation.TransferFieldsPurchRcptLine(PurchRcptLine);
//             ItemEntryRelation.INSERT;
//           UNTIL TempHandlingSpecification.NEXT = 0;
//           TempHandlingSpecification.DELETEALL;
//           EXIT(0);
//         END;
//         EXIT(ItemLedgShptEntryNo);
//     end;

//     local procedure InsertReturnEntryRelation(var ReturnShptLine: Record "6651"): Integer
//     var
//         ItemEntryRelation: Record "6507";
//     begin
//         TempTrackingSpecificationInv.RESET;
//         IF TempTrackingSpecificationInv.FINDSET THEN BEGIN
//           REPEAT
//             TempHandlingSpecification := TempTrackingSpecificationInv;
//             IF TempHandlingSpecification.INSERT THEN;
//           UNTIL TempTrackingSpecificationInv.NEXT = 0;
//           TempTrackingSpecificationInv.DELETEALL;
//         END;

//         TempHandlingSpecification.RESET;
//         IF TempHandlingSpecification.FINDSET THEN BEGIN
//           REPEAT
//             ItemEntryRelation.INIT;
//             ItemEntryRelation."Item Entry No." := TempHandlingSpecification."Entry No.";
//             ItemEntryRelation."Serial No." := TempHandlingSpecification."Serial No.";
//             ItemEntryRelation."Lot No." := TempHandlingSpecification."Lot No.";
//             ItemEntryRelation.TransferFieldsReturnShptLine(ReturnShptLine);
//             ItemEntryRelation.INSERT;
//           UNTIL TempHandlingSpecification.NEXT = 0;
//           TempHandlingSpecification.DELETEALL;
//           EXIT(0);
//         END;
//         EXIT(ItemLedgShptEntryNo);
//     end;

//     local procedure CheckTrackingSpecification(var PurchLine: Record "39")
//     var
//         PurchLineToCheck: Record "39";
//         ReservationEntry: Record "337";
//         Item: Record "27";
//         ItemTrackingCode: Record "6502";
//         CreateReservEntry: Codeunit "99000830";
//         ItemTrackingManagement: Codeunit "6500";
//         ErrorFieldCaption: Text[250];
//         SignFactor: Integer;
//         PurchLineQtyHandled: Decimal;
//         PurchLineQtyToHandle: Decimal;
//         TrackingQtyHandled: Decimal;
//         TrackingQtyToHandle: Decimal;
//         Inbound: Boolean;
//         SNRequired: Boolean;
//         LotRequired: Boolean;
//         SNInfoRequired: Boolean;
//         LotInfoReguired: Boolean;
//         CheckPurchLine: Boolean;
//     begin
//         // if a PurchaseLine is posted with ItemTracking then the whole quantity of
//         // the regarding PurchaseLine has to be post with Item-Tracking

//         IF PurchHeader."Document Type" IN
//            [PurchHeader."Document Type"::Order,PurchHeader."Document Type"::"Return Order"] = FALSE
//         THEN
//           EXIT;

//         TrackingQtyToHandle := 0;
//         TrackingQtyHandled := 0;

//         PurchLineToCheck.COPY(PurchLine);
//         PurchLineToCheck.SETRANGE(Type,PurchLineToCheck.Type::Item);
//         IF PurchHeader.Receive THEN BEGIN
//           PurchLineToCheck.SETFILTER("Quantity Received",'<>%1',0);
//           ErrorFieldCaption := PurchLineToCheck.FIELDCAPTION("Qty. to Receive");
//         END ELSE BEGIN
//           PurchLineToCheck.SETFILTER("Return Qty. Shipped",'<>%1',0);
//           ErrorFieldCaption := PurchLineToCheck.FIELDCAPTION("Return Qty. to Ship");
//         END;

//         IF PurchLineToCheck.FINDSET THEN BEGIN
//           ReservationEntry."Source Type" := DATABASE::"Purchase Line";
//           ReservationEntry."Source Subtype" := PurchHeader."Document Type";
//           SignFactor := CreateReservEntry.SignFactor(ReservationEntry);
//           REPEAT
//             // Only Item where no SerialNo or LotNo is required
//             Item.GET(PurchLineToCheck."No.");
//             IF Item."Item Tracking Code" <> '' THEN BEGIN
//               Inbound := (PurchLineToCheck.Quantity * SignFactor) > 0;
//               ItemTrackingCode.Code := Item."Item Tracking Code";
//               ItemTrackingManagement.GetItemTrackingSettings(ItemTrackingCode,
//                 ItemJnlLine."Entry Type"::Purchase,
//                 Inbound,
//                 SNRequired,
//                 LotRequired,
//                 SNInfoRequired,
//                 LotInfoReguired);
//               CheckPurchLine := (SNRequired = FALSE) AND (LotRequired = FALSE);
//               IF CheckPurchLine THEN
//                 CheckPurchLine := GetTrackingQuantities(PurchLineToCheck,0,TrackingQtyToHandle,TrackingQtyHandled);
//             END ELSE
//               CheckPurchLine := FALSE;

//             TrackingQtyToHandle := 0;
//             TrackingQtyHandled := 0;

//             IF CheckPurchLine THEN BEGIN
//               GetTrackingQuantities(PurchLineToCheck,1,TrackingQtyToHandle,TrackingQtyHandled);
//               TrackingQtyToHandle := TrackingQtyToHandle * SignFactor;
//               TrackingQtyHandled := TrackingQtyHandled * SignFactor;
//               IF PurchHeader.Receive THEN BEGIN
//                 PurchLineQtyToHandle := PurchLineToCheck."Qty. to Receive (Base)";
//                 PurchLineQtyHandled := PurchLineToCheck."Qty. Received (Base)";
//               END ELSE BEGIN
//                 PurchLineQtyToHandle := PurchLineToCheck."Return Qty. to Ship (Base)";
//                 PurchLineQtyHandled := PurchLineToCheck."Return Qty. Shipped (Base)";
//               END;
//               IF ((TrackingQtyHandled + TrackingQtyToHandle) <> (PurchLineQtyHandled + PurchLineQtyToHandle)) OR
//                  (TrackingQtyToHandle <> PurchLineQtyToHandle)
//               THEN
//                 ERROR(STRSUBSTNO(Text046,ErrorFieldCaption));
//             END;
//           UNTIL PurchLineToCheck.NEXT = 0;
//         END;
//     end;

//     local procedure GetTrackingQuantities(PurchLine: Record "39";FunctionType: Option CheckTrackingExists,GetQty;var TrackingQtyToHandle: Decimal;var TrackingQtyHandled: Decimal): Boolean
//     var
//         TrackingSpecification: Record "336";
//         ReservEntry: Record "337";
//     begin
//         WITH TrackingSpecification DO BEGIN
//           SETCURRENTKEY("Source ID","Source Type","Source Subtype","Source Batch Name",
//             "Source Prod. Order Line","Source Ref. No.");
//           SETRANGE("Source Type",DATABASE::"Purchase Line");
//           SETRANGE("Source Subtype",PurchLine."Document Type");
//           SETRANGE("Source ID",PurchLine."Document No.");
//           SETRANGE("Source Batch Name",'');
//           SETRANGE("Source Prod. Order Line",0);
//           SETRANGE("Source Ref. No.",PurchLine."Line No.");
//         END;
//         WITH ReservEntry DO BEGIN
//           SETCURRENTKEY(
//             "Source ID","Source Ref. No.","Source Type","Source Subtype",
//             "Source Batch Name","Source Prod. Order Line");
//           SETRANGE("Source ID",PurchLine."Document No.");
//           SETRANGE("Source Ref. No.",PurchLine."Line No.");
//           SETRANGE("Source Type",DATABASE::"Purchase Line");
//           SETRANGE("Source Subtype",PurchLine."Document Type");
//           SETRANGE("Source Batch Name",'');
//           SETRANGE("Source Prod. Order Line",0);
//         END;

//         CASE FunctionType OF
//           FunctionType::CheckTrackingExists:
//             BEGIN
//               TrackingSpecification.SETRANGE(Correction,FALSE);
//               IF NOT TrackingSpecification.ISEMPTY THEN
//                 EXIT(TRUE);
//               ReservEntry.SETFILTER("Serial No.",'<>%1','');
//               IF NOT ReservEntry.ISEMPTY THEN
//                 EXIT(TRUE);
//               ReservEntry.SETRANGE("Serial No.");
//               ReservEntry.SETFILTER("Lot No.",'<>%1','');
//               IF NOT ReservEntry.ISEMPTY THEN
//                 EXIT(TRUE);
//             END;
//           FunctionType::GetQty:
//             BEGIN
//               TrackingSpecification.CALCSUMS("Quantity Handled (Base)");
//               TrackingQtyHandled := TrackingSpecification."Quantity Handled (Base)";
//               IF ReservEntry.FINDSET THEN
//                 REPEAT
//                   IF (ReservEntry."Lot No." <> '') OR (ReservEntry."Serial No." <> '') THEN
//                     TrackingQtyToHandle := TrackingQtyToHandle + ReservEntry."Qty. to Handle (Base)";
//                 UNTIL ReservEntry.NEXT = 0;
//             END;
//         END;
//     end;

//     local procedure SaveInvoiceSpecification(var TempInvoicingSpecification: Record "336" temporary)
//     begin
//         TempInvoicingSpecification.RESET;
//         IF TempInvoicingSpecification.FINDSET THEN BEGIN
//           REPEAT
//             TempInvoicingSpecification."Quantity Invoiced (Base)" += TempInvoicingSpecification."Qty. to Invoice (Base)";
//             TempTrackingSpecification := TempInvoicingSpecification;
//             TempTrackingSpecification."Buffer Status" := TempTrackingSpecification."Buffer Status"::MODIFY;
//             IF NOT TempTrackingSpecification.INSERT THEN BEGIN
//               TempTrackingSpecification.GET(TempInvoicingSpecification."Entry No.");
//               TempTrackingSpecification."Qty. to Invoice (Base)" += TempInvoicingSpecification."Qty. to Invoice (Base)";
//               IF TempInvoicingSpecification."Qty. to Invoice (Base)" = TempInvoicingSpecification."Quantity Invoiced (Base)" THEN
//                 TempTrackingSpecification."Quantity Invoiced (Base)" += TempInvoicingSpecification."Quantity Invoiced (Base)"
//               ELSE
//                 TempTrackingSpecification."Quantity Invoiced (Base)" += TempInvoicingSpecification."Qty. to Invoice (Base)";
//               TempTrackingSpecification."Qty. to Invoice" += TempInvoicingSpecification."Qty. to Invoice";
//               TempTrackingSpecification.MODIFY;
//             END;
//           UNTIL TempInvoicingSpecification.NEXT = 0;
//           TempInvoicingSpecification.DELETEALL;
//         END;
//     end;

//     local procedure InsertTrackingSpecification()
//     var
//         TrackingSpecification: Record "336";
//     begin
//         TempTrackingSpecification.RESET;
//         IF TempTrackingSpecification.FINDSET THEN BEGIN
//           REPEAT
//             TrackingSpecification := TempTrackingSpecification;
//             TrackingSpecification."Buffer Status" := 0;
//             TrackingSpecification.InitQtyToShip;
//             TrackingSpecification.Correction := FALSE;
//             TrackingSpecification."Quantity actual Handled (Base)" := 0;
//             IF TempTrackingSpecification."Buffer Status" = TempTrackingSpecification."Buffer Status"::MODIFY THEN
//               TrackingSpecification.MODIFY
//             ELSE
//               TrackingSpecification.INSERT;
//           UNTIL TempTrackingSpecification.NEXT = 0;
//           TempTrackingSpecification.DELETEALL;
//         END;

//         ReservePurchLine.UpdateItemTrackingAfterPosting(PurchHeader);
//     end;

//     local procedure CalcBaseQty(ItemNo: Code[20];UOMCode: Code[10];Qty: Decimal): Decimal
//     var
//         UOMMgt: Codeunit "5402";
//         Item: Record "27";
//     begin
//         Item.GET(ItemNo);
//         EXIT(ROUND(Qty * UOMMgt.GetQtyPerUnitOfMeasure(Item,UOMCode),0.00001));
//     end;

//     local procedure InsertValueEntryRelation()
//     var
//         ValueEntryRelation: Record "6508";
//     begin
//         TempValueEntryRelation.RESET;
//         IF TempValueEntryRelation.FINDSET THEN BEGIN
//           REPEAT
//             ValueEntryRelation := TempValueEntryRelation;
//             ValueEntryRelation.INSERT;
//           UNTIL TempValueEntryRelation.NEXT = 0;
//           TempValueEntryRelation.DELETEALL;
//         END;
//     end;

//     local procedure PostItemCharge(var PurchLine: Record "39";ItemEntryNo: Integer;QuantityBase: Decimal;AmountToAssign: Decimal;QtyToAssign: Decimal;IndirectCostPct: Decimal)
//     var
//         DummyTrackingSpecification: Record "336";
//         PurchLineToPost: Record "39";
//     begin
//         WITH TempItemChargeAssgntPurch DO BEGIN
//           PurchLineToPost := PurchLine;
//           PurchLineToPost."No." := "Item No.";
//           PurchLineToPost."Line No." := "Document Line No.";
//           PurchLineToPost."Appl.-to Item Entry" := ItemEntryNo;
//           PurchLineToPost."Indirect Cost %" := IndirectCostPct;

//           PurchLineToPost.Amount := AmountToAssign;

//           IF "Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"] THEN
//             PurchLineToPost.Amount := -PurchLineToPost.Amount;

//           IF PurchLineToPost."Currency Code" <> '' THEN
//             PurchLineToPost."Unit Cost" := ROUND(
//                 PurchLineToPost.Amount / QuantityBase,Currency."Unit-Amount Rounding Precision")
//           ELSE
//             PurchLineToPost."Unit Cost" := ROUND(
//                 PurchLineToPost.Amount / QuantityBase,GLSetup."Unit-Amount Rounding Precision");

//           TotalChargeAmt := TotalChargeAmt + PurchLineToPost.Amount;
//           IF PurchHeader."Currency Code" <> '' THEN
//             PurchLineToPost.Amount :=
//               CurrExchRate.ExchangeAmtFCYToLCY(
//                 Usedate,PurchHeader."Currency Code",TotalChargeAmt,PurchHeader."Currency Factor");

//           PurchLineToPost.Amount := ROUND(PurchLineToPost.Amount,GLSetup."Amount Rounding Precision") - TotalChargeAmtLCY;
//           IF PurchHeader."Currency Code" <> '' THEN
//             TotalChargeAmtLCY := TotalChargeAmtLCY + PurchLineToPost.Amount;
//           PurchLineToPost."Unit Cost (LCY)" :=
//             ROUND(
//               PurchLineToPost.Amount / QuantityBase,GLSetup."Unit-Amount Rounding Precision");

//           PurchLineToPost."Inv. Discount Amount" := ROUND(
//               PurchLine."Inv. Discount Amount" / PurchLine.Quantity * QtyToAssign,
//               GLSetup."Amount Rounding Precision");

//           PurchLineToPost."Line Discount Amount" := ROUND(
//               PurchLine."Line Discount Amount" / PurchLine.Quantity * QtyToAssign,
//               GLSetup."Amount Rounding Precision");
//           PurchLineToPost."Line Amount" := ROUND(
//               PurchLine."Line Amount" / PurchLine.Quantity * QtyToAssign,
//               GLSetup."Amount Rounding Precision");
//           UpdatePurchLineDimSetIDFromAppliedEntry(PurchLineToPost,PurchLine);
//           PurchLine."Inv. Discount Amount" := PurchLine."Inv. Discount Amount" - PurchLineToPost."Inv. Discount Amount";
//           PurchLine."Line Discount Amount" := PurchLine."Line Discount Amount" - PurchLineToPost."Line Discount Amount";
//           PurchLine."Line Amount" := PurchLine."Line Amount" - PurchLineToPost."Line Amount";
//           PurchLine.Quantity := PurchLine.Quantity - QtyToAssign;
//           PostItemJnlLine(
//             PurchLineToPost,
//             0,0,
//             QuantityBase,QuantityBase,
//             PurchLineToPost."Appl.-to Item Entry","Item Charge No.",DummyTrackingSpecification);
//         END;
//     end;

//     procedure SaveTempWhseSplitSpec(PurchLine3: Record "39")
//     begin
//         TempWhseSplitSpecification.RESET;
//         TempWhseSplitSpecification.DELETEALL;
//         IF TempHandlingSpecification.FINDSET THEN
//           REPEAT
//             TempWhseSplitSpecification := TempHandlingSpecification;
//             TempWhseSplitSpecification."Source Type" := DATABASE::"Purchase Line";
//             TempWhseSplitSpecification."Source Subtype" := PurchLine3."Document Type";
//             TempWhseSplitSpecification."Source ID" := PurchLine3."Document No.";
//             TempWhseSplitSpecification."Source Ref. No." := PurchLine3."Line No.";
//             TempWhseSplitSpecification.INSERT;
//           UNTIL TempHandlingSpecification.NEXT = 0;
//     end;

//     procedure TransferReservToItemJnlLine(var SalesOrderLine: Record "37";var ItemJnlLine: Record "83";QtyToBeShippedBase: Decimal;ApplySpecificItemTracking: Boolean)
//     var
//         ReserveSalesLine: Codeunit "99000832";
//         RemainingQuantity: Decimal;
//         CheckApplFromItemEntry: Boolean;
//     begin
//         // Handle Item Tracking and reservations, also on drop shipment
//         IF QtyToBeShippedBase = 0 THEN
//           EXIT;

//         IF NOT ApplySpecificItemTracking THEN
//           ReserveSalesLine.TransferSalesLineToItemJnlLine(
//             SalesOrderLine,ItemJnlLine,QtyToBeShippedBase,CheckApplFromItemEntry,FALSE)
//         ELSE BEGIN
//           TempTrackingSpecification.RESET;
//           TempTrackingSpecification.SETRANGE("Source Type",DATABASE::"Purchase Line");
//           TempTrackingSpecification.SETRANGE("Source Subtype",PurchLine."Document Type");
//           TempTrackingSpecification.SETRANGE("Source ID",PurchLine."Document No.");
//           TempTrackingSpecification.SETRANGE("Source Batch Name",'');
//           TempTrackingSpecification.SETRANGE("Source Prod. Order Line",0);
//           TempTrackingSpecification.SETRANGE("Source Ref. No.",PurchLine."Line No.");
//           IF TempTrackingSpecification.ISEMPTY THEN
//             ReserveSalesLine.TransferSalesLineToItemJnlLine(
//               SalesOrderLine,ItemJnlLine,QtyToBeShippedBase,CheckApplFromItemEntry,FALSE)
//           ELSE BEGIN
//             ReserveSalesLine.SetApplySpecificItemTracking(TRUE);
//             ReserveSalesLine.SetOverruleItemTracking(TRUE);
//             TempTrackingSpecification.FINDSET;
//             IF TempTrackingSpecification."Quantity (Base)" / QtyToBeShippedBase < 0 THEN
//               ERROR(Text043);
//             REPEAT
//               ItemJnlLine."Serial No." := TempTrackingSpecification."Serial No.";
//               ItemJnlLine."Lot No." := TempTrackingSpecification."Lot No.";
//               ItemJnlLine."Applies-to Entry" := TempTrackingSpecification."Item Ledger Entry No.";
//               RemainingQuantity :=
//                 ReserveSalesLine.TransferSalesLineToItemJnlLine(
//                   SalesOrderLine,ItemJnlLine,TempTrackingSpecification."Quantity (Base)",CheckApplFromItemEntry,FALSE);
//               IF RemainingQuantity <> 0 THEN
//                 ERROR(Text044);
//             UNTIL TempTrackingSpecification.NEXT = 0;
//             ItemJnlLine."Serial No." := '';
//             ItemJnlLine."Lot No." := '';
//             ItemJnlLine."Applies-to Entry" := 0;
//           END;
//         END;
//     end;

//     procedure SetWhseRcptHeader(var WhseRcptHeader2: Record "7316")
//     begin
//         WhseRcptHeader := WhseRcptHeader2;
//         TempWhseRcptHeader := WhseRcptHeader;
//         TempWhseRcptHeader.INSERT;
//     end;

//     procedure SetWhseShptHeader(var WhseShptHeader2: Record "7320")
//     begin
//         WhseShptHeader := WhseShptHeader2;
//         TempWhseShptHeader := WhseShptHeader;
//         TempWhseShptHeader.INSERT;
//     end;

//     local procedure CopySalesCommentLines(FromDocumentType: Integer;ToDocumentType: Integer;FromNumber: Code[20];ToNumber: Code[20])
//     var
//         SalesCommentLine: Record "44";
//         SalesCommentLine2: Record "44";
//     begin
//         SalesCommentLine.SETRANGE("Document Type",FromDocumentType);
//         SalesCommentLine.SETRANGE("No.",FromNumber);
//         IF SalesCommentLine.FINDSET THEN
//           REPEAT
//             SalesCommentLine2 := SalesCommentLine;
//             SalesCommentLine2."Document Type" := ToDocumentType;
//             SalesCommentLine2."No." := ToNumber;
//             SalesCommentLine2.INSERT;
//           UNTIL SalesCommentLine.NEXT = 0;
//     end;

//     local procedure GetNextPurchline(var PurchLine: Record "39"): Boolean
//     begin
//         IF NOT PurchaseLinesProcessed THEN
//           IF PurchLine.NEXT = 1 THEN
//             EXIT(FALSE);
//         PurchaseLinesProcessed := TRUE;
//         IF TempPrepmtPurchLine.FIND('-') THEN BEGIN
//           PurchLine := TempPrepmtPurchLine;
//           TempPrepmtPurchLine.DELETE;
//           EXIT(FALSE);
//         END;
//         EXIT(TRUE);
//     end;

//     procedure CreatePrepmtLines(PurchHeader: Record "38";var TempPrepmtPurchLine: Record "39";CompleteFunctionality: Boolean)
//     var
//         GLAcc: Record "15";
//         PurchLine: Record "39";
//         TempExtTextLine: Record "280" temporary;
//         TransferExtText: Codeunit "378";
//         NextLineNo: Integer;
//         Fraction: Decimal;
//         VATDifference: Decimal;
//         TempLineFound: Boolean;
//         PrePmtTestRun: Boolean;
//         PrepmtAmtToDeduct: Decimal;
//     begin
//         GetGLSetup;
//         WITH PurchLine DO BEGIN
//           SETRANGE("Document Type",PurchHeader."Document Type");
//           SETRANGE("Document No.",PurchHeader."No.");
//           IF NOT FIND('+') THEN
//             EXIT;
//           NextLineNo := "Line No." + 10000;
//           SETFILTER(Quantity,'>0');
//           SETFILTER("Qty. to Invoice",'>0');
//           IF FIND('-') THEN
//             REPEAT
//               IF CompleteFunctionality THEN BEGIN
//                 IF PurchHeader."Document Type" <> PurchHeader."Document Type"::Invoice THEN BEGIN
//                   IF NOT PurchHeader.Receive AND ("Qty. to Invoice" = Quantity - "Quantity Invoiced") THEN
//                     IF "Qty. Rcd. Not Invoiced" < "Qty. to Invoice" THEN
//                       VALIDATE("Qty. to Invoice","Qty. Rcd. Not Invoiced");
//                   Fraction := ("Qty. to Invoice" + "Quantity Invoiced") / Quantity;

//                   IF "Prepayment %" <> 100 THEN
//                     CASE TRUE OF
//                       ("Prepmt Amt to Deduct" <> 0) AND
//                       (ROUND(Fraction * "Line Amount",Currency."Amount Rounding Precision") < "Prepmt Amt to Deduct"):
//                         FIELDERROR(
//                           "Prepmt Amt to Deduct",
//                           STRSUBSTNO(
//                             Text047,
//                             ROUND(Fraction * "Line Amount",Currency."Amount Rounding Precision")));
//                       ("Prepmt. Amt. Inv." <> 0) AND
//                       (ROUND((1 - Fraction) * "Line Amount",Currency."Amount Rounding Precision") <
//                        ROUND(
//                          ROUND(
//                            ROUND("Direct Unit Cost" * (Quantity - "Quantity Invoiced" - "Qty. to Invoice"),
//                              Currency."Amount Rounding Precision") *
//                            (1 - "Line Discount %" / 100),Currency."Amount Rounding Precision") *
//                          "Prepayment %" / 100,Currency."Amount Rounding Precision")):
//                         FIELDERROR(
//                           "Prepmt Amt to Deduct",
//                           STRSUBSTNO(
//                             Text048,
//                             ROUND(
//                               "Prepmt. Amt. Inv." - "Prepmt Amt Deducted" -
//                               (1 - Fraction) * "Line Amount",Currency."Amount Rounding Precision")));
//                     END;
//                 END ELSE
//                   IF NOT PrePmtTestRun THEN BEGIN
//                     TestGetRcptPPmtAmtToDeduct(PurchHeader);
//                     PrePmtTestRun := TRUE;
//                   END;
//               END;

//               IF "Prepmt Amt to Deduct" <> 0 THEN BEGIN
//                 IF ("Gen. Bus. Posting Group" <> GenPostingSetup."Gen. Bus. Posting Group") OR
//                    ("Gen. Prod. Posting Group" <> GenPostingSetup."Gen. Prod. Posting Group")
//                 THEN BEGIN
//                   GenPostingSetup.GET("Gen. Bus. Posting Group","Gen. Prod. Posting Group");
//                   GenPostingSetup.TESTFIELD("Purch. Prepayments Account");
//                 END;
//                 GLAcc.GET(GenPostingSetup."Purch. Prepayments Account");
//                 TempLineFound := FALSE;
//                 IF PurchHeader."Compress Prepayment" THEN BEGIN
//                   TempPrepmtPurchLine.SETRANGE("No.",GLAcc."No.");
//                   TempPrepmtPurchLine.SETRANGE("Job No.","Job No.");
//                   TempPrepmtPurchLine.SETRANGE("Dimension Set ID","Dimension Set ID");
//                   TempLineFound := TempPrepmtPurchLine.FINDFIRST;
//                 END;
//                 IF TempLineFound THEN BEGIN
//                   PrepmtAmtToDeduct :=
//                     TempPrepmtPurchLine."Prepmt Amt to Deduct" +
//                     InsertedPrepmtVATBaseToDeduct(PurchLine,TempPrepmtPurchLine."Line No.",TempPrepmtPurchLine."Direct Unit Cost");
//                   VATDifference := TempPrepmtPurchLine."VAT Difference";
//                   TempPrepmtPurchLine.VALIDATE(
//                     "Direct Unit Cost",TempPrepmtPurchLine."Direct Unit Cost" + "Prepmt Amt to Deduct");
//                   TempPrepmtPurchLine.VALIDATE("VAT Difference",VATDifference - "Prepmt VAT Diff. to Deduct");
//                   TempPrepmtPurchLine."Prepmt Amt to Deduct" := PrepmtAmtToDeduct;
//                   IF "Prepayment %" < TempPrepmtPurchLine."Prepayment %" THEN
//                     TempPrepmtPurchLine."Prepayment %" := "Prepayment %";
//                   TempPrepmtPurchLine.MODIFY;
//                 END ELSE BEGIN
//                   TempPrepmtPurchLine.INIT;
//                   TempPrepmtPurchLine."Document Type" := PurchHeader."Document Type";
//                   TempPrepmtPurchLine."Document No." := PurchHeader."No.";
//                   TempPrepmtPurchLine."Line No." := 0;
//                   TempPrepmtPurchLine."System-Created Entry" := TRUE;
//                   IF CompleteFunctionality THEN
//                     TempPrepmtPurchLine.VALIDATE(Type,TempPrepmtPurchLine.Type::"G/L Account")
//                   ELSE
//                     TempPrepmtPurchLine.Type := TempPrepmtPurchLine.Type::"G/L Account";
//                   TempPrepmtPurchLine.VALIDATE("No.",GenPostingSetup."Purch. Prepayments Account");
//                   TempPrepmtPurchLine.VALIDATE(Quantity,-1);
//                   TempPrepmtPurchLine."Qty. to Receive" := TempPrepmtPurchLine.Quantity;
//                   TempPrepmtPurchLine."Qty. to Invoice" := TempPrepmtPurchLine.Quantity;
//                   PrepmtAmtToDeduct := InsertedPrepmtVATBaseToDeduct(PurchLine,NextLineNo,0);
//                   TempPrepmtPurchLine.VALIDATE("Direct Unit Cost","Prepmt Amt to Deduct");
//                   TempPrepmtPurchLine.VALIDATE("VAT Difference",-"Prepmt VAT Diff. to Deduct");
//                   TempPrepmtPurchLine."Prepmt Amt to Deduct" := PrepmtAmtToDeduct;
//                   TempPrepmtPurchLine."Prepayment %" := "Prepayment %";
//                   TempPrepmtPurchLine."Prepayment Line" := TRUE;
//                   TempPrepmtPurchLine."Shortcut Dimension 1 Code" := "Shortcut Dimension 1 Code";
//                   TempPrepmtPurchLine."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
//                   TempPrepmtPurchLine."Dimension Set ID" := "Dimension Set ID";
//                   TempPrepmtPurchLine."Job No." := "Job No.";
//                   TempPrepmtPurchLine."Job Task No." := "Job Task No.";
//                   TempPrepmtPurchLine."Job Line Type" := "Job Line Type";
//                   TempPrepmtPurchLine."Line No." := NextLineNo;
//                   NextLineNo := NextLineNo + 10000;
//                   TempPrepmtPurchLine.INSERT;

//                   TransferExtText.PrepmtGetAnyExtText(
//                     TempPrepmtPurchLine."No.",DATABASE::"Purch. Inv. Line",
//                     PurchHeader."Document Date",PurchHeader."Language Code",TempExtTextLine);
//                   IF TempExtTextLine.FIND('-') THEN
//                     REPEAT
//                       TempPrepmtPurchLine.INIT;
//                       TempPrepmtPurchLine.Description := TempExtTextLine.Text;
//                       TempPrepmtPurchLine."System-Created Entry" := TRUE;
//                       TempPrepmtPurchLine."Prepayment Line" := TRUE;
//                       TempPrepmtPurchLine."Line No." := NextLineNo;
//                       NextLineNo := NextLineNo + 10000;
//                       TempPrepmtPurchLine.INSERT;
//                     UNTIL TempExtTextLine.NEXT = 0;
//                 END;
//               END;
//             UNTIL NEXT = 0
//         END;
//         DividePrepmtAmountLCY(TempPrepmtPurchLine,PurchHeader);
//     end;

//     local procedure InsertedPrepmtVATBaseToDeduct(PurchLine: Record "39";PrepmtLineNo: Integer;TotalPrepmtAmtToDeduct: Decimal): Decimal
//     var
//         PrepmtVATBaseToDeduct: Decimal;
//     begin
//         WITH PurchLine DO BEGIN
//           IF PurchHeader."Prices Including VAT" THEN
//             PrepmtVATBaseToDeduct :=
//               ROUND(
//                 (TotalPrepmtAmtToDeduct + "Prepmt Amt to Deduct") / (1 + "Prepayment VAT %" / 100),
//                 Currency."Amount Rounding Precision") -
//               ROUND(
//                 TotalPrepmtAmtToDeduct / (1 + "Prepayment VAT %" / 100),
//                 Currency."Amount Rounding Precision")
//           ELSE
//             PrepmtVATBaseToDeduct := "Prepmt Amt to Deduct";
//         END;
//         WITH TempPrepmtDeductLCYPurchLine DO BEGIN
//           TempPrepmtDeductLCYPurchLine := PurchLine;
//           IF "Document Type" = "Document Type"::Order THEN
//             "Qty. to Invoice" := GetQtyToInvoice(PurchLine)
//           ELSE
//             GetLineDataFromOrder(TempPrepmtDeductLCYPurchLine);
//           CalcPrepaymentToDeduct;
//           "Line Amount" := GetLineAmountToHandle("Qty. to Invoice");
//           "Attached to Line No." := PrepmtLineNo;
//           "VAT Base Amount" := PrepmtVATBaseToDeduct;
//           INSERT;
//         END;
//         EXIT(PrepmtVATBaseToDeduct);
//     end;

//     local procedure DividePrepmtAmountLCY(var PrepmtPurchLine: Record "39";PurchHeader: Record "38")
//     var
//         ActualCurrencyFactor: Decimal;
//     begin
//         WITH PrepmtPurchLine DO BEGIN
//           RESET;
//           SETFILTER(Type,'<>%1',Type::" ");
//           IF FINDSET THEN
//             REPEAT
//               IF PurchHeader."Currency Code" <> '' THEN
//                 ActualCurrencyFactor :=
//                   ROUND(
//                     CurrExchRate.ExchangeAmtFCYToLCY(
//                       PurchHeader."Posting Date",
//                       PurchHeader."Currency Code",
//                       "Prepmt Amt to Deduct",
//                       PurchHeader."Currency Factor")) /
//                   "Prepmt Amt to Deduct"
//               ELSE
//                 ActualCurrencyFactor := 1;

//               UpdatePrepmtAmountInvBuf("Line No.",ActualCurrencyFactor);
//             UNTIL NEXT = 0;
//         END;
//     end;

//     local procedure UpdatePrepmtAmountInvBuf(PrepmtSalesLineNo: Integer;CurrencyFactor: Decimal)
//     var
//         PrepmtAmtRemainder: Decimal;
//     begin
//         WITH TempPrepmtDeductLCYPurchLine DO BEGIN
//           RESET;
//           SETRANGE("Attached to Line No.",PrepmtSalesLineNo);
//           IF FINDSET(TRUE) THEN
//             REPEAT
//               "Prepmt. Amount Inv. (LCY)" :=
//                 CalcRoundedAmount(CurrencyFactor * "VAT Base Amount",PrepmtAmtRemainder);
//               MODIFY;
//             UNTIL NEXT = 0;
//         END;
//     end;

//     local procedure AdjustPrepmtAmountLCY(var PrepmtPurchLine: Record "39")
//     var
//         PurchLine: Record "39";
//         PurchInvoiceLine: Record "39";
//         DeductionFactor: Decimal;
//         PrepmtVATPart: Decimal;
//         PrepmtVATAmtRemainder: Decimal;
//         TotalRoundingAmount: array [2] of Decimal;
//         TotalPrepmtAmount: array [2] of Decimal;
//         FinalInvoice: Boolean;
//         PricesInclVATRoundingAmount: array [2] of Decimal;
//     begin
//         IF PrepmtPurchLine."Prepayment Line" THEN BEGIN
//           PrepmtVATPart :=
//             (PrepmtPurchLine."Amount Including VAT" - PrepmtPurchLine.Amount) / PrepmtPurchLine."Direct Unit Cost";

//           WITH TempPrepmtDeductLCYPurchLine DO BEGIN
//             RESET;
//             SETRANGE("Attached to Line No.",PrepmtPurchLine."Line No.");
//             IF FINDSET(TRUE) THEN BEGIN
//               FinalInvoice := IsFinalInvoice;
//               REPEAT
//                 PurchLine := TempPrepmtDeductLCYPurchLine;
//                 PurchLine.FIND;
//                 IF "Document Type" = "Document Type"::Invoice THEN BEGIN
//                   PurchInvoiceLine := PurchLine;
//                   GetPurchOrderLine(PurchLine,PurchInvoiceLine);
//                   PurchLine."Qty. to Invoice" := PurchInvoiceLine."Qty. to Invoice";
//                 END;
//                 PurchLine."Prepmt Amt to Deduct" := CalcPrepmtAmtToDeduct(PurchLine);
//                 DeductionFactor :=
//                   PurchLine."Prepmt Amt to Deduct" /
//                   (PurchLine."Prepmt. Amt. Inv." - PurchLine."Prepmt Amt Deducted");

//                 "Prepmt. VAT Amount Inv. (LCY)" :=
//                   -CalcRoundedAmount(PurchLine."Prepmt Amt to Deduct" * PrepmtVATPart,PrepmtVATAmtRemainder);
//                 IF ("Prepayment %" <> 100) OR IsFinalInvoice THEN
//                   CalcPrepmtRoundingAmounts(TempPrepmtDeductLCYPurchLine,PurchLine,DeductionFactor,TotalRoundingAmount);
//                 MODIFY;

//                 IF PurchHeader."Prices Including VAT" THEN
//                   IF (("Prepayment %" <> 100) OR IsFinalInvoice) AND (DeductionFactor = 1) THEN BEGIN
//                     PricesInclVATRoundingAmount[1] := TotalRoundingAmount[1];
//                     PricesInclVATRoundingAmount[2] := TotalRoundingAmount[2];
//                   END;

//                 TotalPrepmtAmount[1] += "Prepmt. Amount Inv. (LCY)";
//                 TotalPrepmtAmount[2] += "Prepmt. VAT Amount Inv. (LCY)";
//                 FinalInvoice := FinalInvoice AND IsFinalInvoice;
//               UNTIL NEXT = 0;
//             END;
//           END;

//           UpdatePrepmtPurchLineWithRounding(
//             PrepmtPurchLine,TotalRoundingAmount,TotalPrepmtAmount,
//             FinalInvoice,PricesInclVATRoundingAmount);
//         END;
//     end;

//     local procedure CalcPrepmtAmtToDeduct(PurchLine: Record "39"): Decimal
//     begin
//         WITH PurchLine DO BEGIN
//           "Qty. to Invoice" := GetQtyToInvoice(PurchLine);
//           CalcPrepaymentToDeduct;
//           EXIT("Prepmt Amt to Deduct");
//         END;
//     end;

//     local procedure GetQtyToInvoice(PurchLine: Record "39"): Decimal
//     var
//         AllowedQtyToInvoice: Decimal;
//     begin
//         WITH PurchLine DO BEGIN
//           AllowedQtyToInvoice := "Qty. Rcd. Not Invoiced";
//           IF PurchHeader.Receive THEN
//             AllowedQtyToInvoice := AllowedQtyToInvoice + "Qty. to Receive";
//           IF "Qty. to Invoice" > AllowedQtyToInvoice THEN
//             EXIT(AllowedQtyToInvoice);
//           EXIT("Qty. to Invoice");
//         END;
//     end;

//     local procedure GetLineDataFromOrder(var PurchLine: Record "39")
//     var
//         PurchRcptLine: Record "121";
//         PurchOrderLine: Record "39";
//     begin
//         WITH PurchLine DO BEGIN
//           PurchRcptLine.GET("Receipt No.","Receipt Line No.");
//           PurchOrderLine.GET("Document Type"::Order,PurchRcptLine."Order No.",PurchRcptLine."Order Line No.");

//           Quantity := PurchOrderLine.Quantity;
//           "Qty. Rcd. Not Invoiced" := PurchOrderLine."Qty. Rcd. Not Invoiced";
//           "Quantity Invoiced" := PurchOrderLine."Quantity Invoiced";
//           "Prepmt Amt Deducted" := PurchOrderLine."Prepmt Amt Deducted";
//           "Prepmt. Amt. Inv." := PurchOrderLine."Prepmt. Amt. Inv.";
//           "Line Discount Amount" := PurchOrderLine."Line Discount Amount";
//         END;
//     end;

//     local procedure CalcPrepmtRoundingAmounts(var PrepmtPurchLineBuf: Record "39";PurchLine: Record "39";DeductionFactor: Decimal;var TotalRoundingAmount: array [2] of Decimal)
//     var
//         RoundingAmount: array [2] of Decimal;
//     begin
//         WITH PrepmtPurchLineBuf DO BEGIN
//           RoundingAmount[1] :=
//             "Prepmt. Amount Inv. (LCY)" - ROUND(DeductionFactor * PurchLine."Prepmt. Amount Inv. (LCY)");
//           "Prepmt. Amount Inv. (LCY)" := "Prepmt. Amount Inv. (LCY)" - RoundingAmount[1];
//           TotalRoundingAmount[1] += RoundingAmount[1];

//           RoundingAmount[2] :=
//             "Prepmt. VAT Amount Inv. (LCY)" - ROUND(DeductionFactor * PurchLine."Prepmt. VAT Amount Inv. (LCY)");
//           "Prepmt. VAT Amount Inv. (LCY)" := "Prepmt. VAT Amount Inv. (LCY)" - RoundingAmount[2];
//           TotalRoundingAmount[2] += RoundingAmount[2];
//         END;
//     end;

//     local procedure UpdatePrepmtPurchLineWithRounding(var PrepmtPurchLine: Record "39";TotalRoundingAmount: array [2] of Decimal;TotalPrepmtAmount: array [2] of Decimal;FinalInvoice: Boolean;PricesInclVATRoundingAmount: array [2] of Decimal)
//     var
//         NewAmountIncludingVAT: Decimal;
//         Prepmt100PctVATRoundingAmt: Decimal;
//     begin
//         WITH PrepmtPurchLine DO BEGIN
//           IF ABS(TotalRoundingAmount[1]) <= GLSetup."Amount Rounding Precision" THEN BEGIN
//             IF "Prepayment %" = 100 THEN
//               Prepmt100PctVATRoundingAmt := TotalRoundingAmount[1];
//             TotalRoundingAmount[1] := 0;
//           END;
//           "Prepmt. Amount Inv. (LCY)" := -TotalRoundingAmount[1];
//           Amount := -(TotalPrepmtAmount[1] + TotalRoundingAmount[1]);

//           IF (PricesInclVATRoundingAmount[1] <> 0) AND (TotalRoundingAmount[1] = 0) THEN BEGIN
//             Prepmt100PctVATRoundingAmt := 0;
//             PricesInclVATRoundingAmount[1] := 0;
//           END;

//           IF (ABS(TotalRoundingAmount[2]) <= GLSetup."Amount Rounding Precision") OR
//              (FinalInvoice AND (TotalRoundingAmount[1] = 0))
//           THEN BEGIN
//             IF ("Prepayment %" = 100) AND ("Prepmt. Amount Inv. (LCY)" = 0) THEN
//               Prepmt100PctVATRoundingAmt += TotalRoundingAmount[2];
//             TotalRoundingAmount[2] := 0;
//           END;

//           IF (PricesInclVATRoundingAmount[2] <> 0) AND (TotalRoundingAmount[2] = 0) THEN BEGIN
//             Prepmt100PctVATRoundingAmt := 0;
//             PricesInclVATRoundingAmount[2] := 0;
//           END;

//           "Prepmt. VAT Amount Inv. (LCY)" := -(TotalRoundingAmount[2] + Prepmt100PctVATRoundingAmt);
//           NewAmountIncludingVAT := Amount - (TotalPrepmtAmount[2] + TotalRoundingAmount[2]);
//           IF (PricesInclVATRoundingAmount[1] = 0) AND (PricesInclVATRoundingAmount[2] = 0) THEN
//             Increment(
//               TotalPurchLineLCY."Amount Including VAT",
//               -("Amount Including VAT" - NewAmountIncludingVAT + Prepmt100PctVATRoundingAmt));
//           IF "Currency Code" = '' THEN
//             TotalPurchLine."Amount Including VAT" := TotalPurchLineLCY."Amount Including VAT";
//           "Amount Including VAT" := NewAmountIncludingVAT;
//         END;
//     end;

//     local procedure CalcRoundedAmount(Amount: Decimal;var Remainder: Decimal): Decimal
//     var
//         AmountRnded: Decimal;
//     begin
//         Amount := Amount + Remainder;
//         AmountRnded := ROUND(Amount,GLSetup."Amount Rounding Precision");
//         Remainder := Amount - AmountRnded;
//         EXIT(AmountRnded);
//     end;

//     local procedure GetPurchOrderLine(var PurchOrderLine: Record "39";PurchLine: Record "39")
//     begin
//         PurchRcptLine.GET(PurchLine."Receipt No.",PurchLine."Receipt Line No.");
//         PurchOrderLine.GET(
//           PurchOrderLine."Document Type"::Order,
//           PurchRcptLine."Order No.",PurchRcptLine."Order Line No.");
//         PurchOrderLine."Prepmt Amt to Deduct" := PurchLine."Prepmt Amt to Deduct";
//     end;

//     local procedure DecrementPrepmtAmtInvLCY(PurchLine: Record "39";var PrepmtAmountInvLCY: Decimal;var PrepmtVATAmountInvLCY: Decimal)
//     begin
//         TempPrepmtDeductLCYPurchLine.RESET;
//         TempPrepmtDeductLCYPurchLine := PurchLine;
//         IF TempPrepmtDeductLCYPurchLine.FIND THEN BEGIN
//           PrepmtAmountInvLCY := PrepmtAmountInvLCY - TempPrepmtDeductLCYPurchLine."Prepmt. Amount Inv. (LCY)";
//           PrepmtVATAmountInvLCY := PrepmtVATAmountInvLCY - TempPrepmtDeductLCYPurchLine."Prepmt. VAT Amount Inv. (LCY)";
//         END;
//     end;

//     local procedure AdjustFinalInvWith100PctPrepmt(var TempPurchLine: Record "39" temporary)
//     var
//         DiffToLineDiscAmt: Decimal;
//     begin
//         WITH TempPrepmtDeductLCYPurchLine DO BEGIN
//           RESET;
//           SETRANGE("Prepayment %",100);
//           IF FINDSET(TRUE) THEN
//             REPEAT
//               IF IsFinalInvoice THEN BEGIN
//                 DiffToLineDiscAmt := "Prepmt Amt to Deduct" - "Line Amount";
//                 IF "Document Type" = "Document Type"::Order THEN
//                   DiffToLineDiscAmt := DiffToLineDiscAmt * Quantity / "Qty. to Invoice";
//                 IF DiffToLineDiscAmt <> 0 THEN BEGIN
//                   TempPurchLine.GET("Document Type","Document No.","Line No.");
//                   TempPurchLine."Line Discount Amount" -= DiffToLineDiscAmt;
//                   TempPurchLine.MODIFY;

//                   "Line Discount Amount" := TempPurchLine."Line Discount Amount";
//                   MODIFY;
//                 END;
//               END;
//             UNTIL NEXT = 0;
//           RESET;
//         END;
//     end;

//     local procedure GetPrepmtDiffToLineAmount(PurchLine: Record "39"): Decimal
//     begin
//         WITH TempPrepmtDeductLCYPurchLine DO
//           IF PurchLine."Prepayment %" = 100 THEN
//             IF GET(PurchLine."Document Type",PurchLine."Document No.",PurchLine."Line No.") THEN
//               EXIT("Prepmt Amt to Deduct" - "Line Amount");
//         EXIT(0);
//     end;

//     procedure MergePurchLines(PurchHeader: Record "38";var PurchLine: Record "39";var PurchLine2: Record "39";var MergedPurchLine: Record "39")
//     begin
//         WITH PurchLine DO BEGIN
//           SETRANGE("Document Type",PurchHeader."Document Type");
//           SETRANGE("Document No.",PurchHeader."No.");
//           IF FIND('-') THEN
//             REPEAT
//               MergedPurchLine := PurchLine;
//               MergedPurchLine.INSERT;
//             UNTIL NEXT = 0;
//         END;
//         WITH PurchLine2 DO BEGIN
//           SETRANGE("Document Type",PurchHeader."Document Type");
//           SETRANGE("Document No.",PurchHeader."No.");
//           IF FIND('-') THEN
//             REPEAT
//               MergedPurchLine := PurchLine2;
//               MergedPurchLine.INSERT;
//             UNTIL NEXT = 0;
//         END;
//     end;

//     local procedure InsertICGenJnlLine(PurchLine: Record "39")
//     var
//         ICGLAccount: Record "410";
//         Cust: Record "18";
//         Currency: Record "4";
//         ICPartner: Record "413";
//     begin
//         PurchHeader.TESTFIELD("Buy-from IC Partner Code",'');
//         PurchHeader.TESTFIELD("Pay-to IC Partner Code",'');
//         PurchLine.TESTFIELD("IC Partner Ref. Type",PurchLine."IC Partner Ref. Type"::"G/L Account");
//         ICGLAccount.GET(PurchLine."IC Partner Reference");
//         ICGenJnlLineNo := ICGenJnlLineNo + 1;
//         TempICGenJnlLine.INIT;
//         TempICGenJnlLine."Line No." := ICGenJnlLineNo;
//         TempICGenJnlLine.VALIDATE("Posting Date",PurchHeader."Posting Date");
//         TempICGenJnlLine."Document Date" := PurchHeader."Document Date";
//         TempICGenJnlLine.Description := PurchHeader."Posting Description";
//         TempICGenJnlLine."Reason Code" := PurchHeader."Reason Code";
//         TempICGenJnlLine."Document Type" := GenJnlLineDocType;
//         TempICGenJnlLine."Document No." := GenJnlLineDocNo;
//         TempICGenJnlLine."External Document No." := GenJnlLineExtDocNo;
//         TempICGenJnlLine.VALIDATE("Account Type",TempICGenJnlLine."Account Type"::"IC Partner");
//         TempICGenJnlLine.VALIDATE("Account No.",PurchLine."IC Partner Code");
//         TempICGenJnlLine."Source Currency Code" := PurchHeader."Currency Code";
//         TempICGenJnlLine."Source Currency Amount" := TempICGenJnlLine.Amount;
//         TempICGenJnlLine.Correction := PurchHeader.Correction;
//         TempICGenJnlLine."Source Code" := SrcCode;
//         TempICGenJnlLine."Country/Region Code" := PurchHeader."VAT Country/Region Code";
//         TempICGenJnlLine."Source Type" := GenJnlLine."Source Type"::Vendor;
//         TempICGenJnlLine."Source No." := PurchHeader."Pay-to Vendor No.";
//         TempICGenJnlLine."Source Line No." := PurchLine."Line No.";
//         TempICGenJnlLine."Posting No. Series" := PurchHeader."Posting No. Series";
//         TempICGenJnlLine.VALIDATE("Bal. Account Type",TempICGenJnlLine."Bal. Account Type"::"G/L Account");
//         TempICGenJnlLine.VALIDATE("Bal. Account No.",PurchLine."No.");
//         TempICGenJnlLine."Shortcut Dimension 1 Code" := PurchLine."Shortcut Dimension 1 Code";
//         TempICGenJnlLine."Shortcut Dimension 2 Code" := PurchLine."Shortcut Dimension 2 Code";
//         TempICGenJnlLine."Dimension Set ID" := PurchLine."Dimension Set ID";
//         Cust.SETRANGE("IC Partner Code",PurchLine."IC Partner Code");
//         IF Cust.FINDFIRST THEN BEGIN
//           TempICGenJnlLine.VALIDATE("Bal. Gen. Bus. Posting Group",Cust."Gen. Bus. Posting Group");
//           TempICGenJnlLine.VALIDATE("Bal. VAT Bus. Posting Group",Cust."VAT Bus. Posting Group");
//         END;
//         TempICGenJnlLine.VALIDATE("Bal. VAT Prod. Posting Group",PurchLine."VAT Prod. Posting Group");
//         TempICGenJnlLine."IC Partner Code" := PurchLine."IC Partner Code";
//         TempICGenJnlLine."IC Partner G/L Acc. No." := PurchLine."IC Partner Reference";
//         TempICGenJnlLine."IC Direction" := TempICGenJnlLine."IC Direction"::Outgoing;
//         ICPartner.GET(PurchLine."IC Partner Code");
//         IF ICPartner."Cost Distribution in LCY" AND (PurchLine."Currency Code" <> '') THEN BEGIN
//           TempICGenJnlLine."Currency Code" := '';
//           TempICGenJnlLine."Currency Factor" := 0;
//           Currency.GET(PurchLine."Currency Code");
//           IF PurchHeader."Document Type" IN
//              [PurchHeader."Document Type"::"Return Order",PurchHeader."Document Type"::"Credit Memo"]
//           THEN
//             TempICGenJnlLine.Amount :=
//               -ROUND(
//                 CurrExchRate.ExchangeAmtFCYToLCY(
//                   PurchHeader."Posting Date",PurchLine."Currency Code",
//                   PurchLine.Amount,PurchHeader."Currency Factor"))
//           ELSE
//             TempICGenJnlLine.Amount :=
//               ROUND(
//                 CurrExchRate.ExchangeAmtFCYToLCY(
//                   PurchHeader."Posting Date",PurchLine."Currency Code",
//                   PurchLine.Amount,PurchHeader."Currency Factor"));
//         END ELSE BEGIN
//           Currency.InitRoundingPrecision;
//           TempICGenJnlLine."Currency Code" := PurchHeader."Currency Code";
//           TempICGenJnlLine."Currency Factor" := PurchHeader."Currency Factor";
//           IF PurchHeader."Document Type" IN
//              [PurchHeader."Document Type"::"Return Order",PurchHeader."Document Type"::"Credit Memo"]
//           THEN
//             TempICGenJnlLine.Amount := -PurchLine.Amount
//           ELSE
//             TempICGenJnlLine.Amount := PurchLine.Amount;
//         END;
//         IF TempICGenJnlLine."Bal. VAT %" <> 0 THEN
//           TempICGenJnlLine.Amount := ROUND(TempICGenJnlLine.Amount * (1 + TempICGenJnlLine."Bal. VAT %" / 100),
//               Currency."Amount Rounding Precision");
//         TempICGenJnlLine.VALIDATE(Amount);
//         TempICGenJnlLine.INSERT;
//     end;

//     local procedure PostICGenJnl()
//     var
//         ICTransactionNo: Integer;
//     begin
//         TempICGenJnlLine.RESET;
//         IF TempICGenJnlLine.FIND('-') THEN
//           REPEAT
//             ICTransactionNo := ICInOutBoxMgt.CreateOutboxJnlTransaction(TempICGenJnlLine,FALSE);
//             ICInOutBoxMgt.CreateOutboxJnlLine(ICTransactionNo,1,TempICGenJnlLine);
//             IF TempICGenJnlLine.Amount <> 0 THEN
//               GenJnlPostLine.RunWithCheck(TempICGenJnlLine);
//           UNTIL TempICGenJnlLine.NEXT = 0;
//     end;

//     procedure TestGetRcptPPmtAmtToDeduct(PurchHeader: Record "38")
//     var
//         PurchLine2: Record "39";
//         TempPurchLine3: Record "39" temporary;
//         TempTotalPurchLine: Record "39" temporary;
//         TempPurchRcptLine: Record "121" temporary;
//         MaxAmtToDeduct: Decimal;
//     begin
//         PurchLine2.SETRANGE("Document Type",PurchHeader."Document Type");
//         PurchLine2.SETRANGE("Document No.",PurchHeader."No.");
//         PurchLine2.SETFILTER(Quantity,'>0');
//         PurchLine2.SETFILTER("Qty. to Invoice",'>0');
//         PurchLine2.SETFILTER("Receipt No.",'<>%1','');
//         PurchLine2.SETFILTER("Prepmt Amt to Deduct",'<>0');
//         IF PurchLine2.ISEMPTY THEN
//           EXIT;
//         PurchLine2.SETRANGE("Prepmt Amt to Deduct");

//         IF PurchLine2.FINDSET THEN
//           REPEAT
//             IF PurchRcptLine.GET(PurchLine2."Receipt No.",PurchLine2."Receipt Line No.") THEN BEGIN
//               TempPurchLine3 := PurchLine2;
//               TempPurchLine3.INSERT;
//               TempPurchRcptLine := PurchRcptLine;
//               IF TempPurchRcptLine.INSERT THEN;

//               IF NOT TempTotalPurchLine.GET(PurchLine2."Document Type"::Order,PurchRcptLine."Order No.",PurchRcptLine."Order Line No.")
//               THEN BEGIN
//                 TempTotalPurchLine.INIT;
//                 TempTotalPurchLine."Document Type" := PurchLine2."Document Type"::Order;
//                 TempTotalPurchLine."Document No." := PurchRcptLine."Order No.";
//                 TempTotalPurchLine."Line No." := PurchRcptLine."Order Line No.";
//                 TempTotalPurchLine.INSERT;
//               END;
//               TempTotalPurchLine."Qty. to Invoice" := TempTotalPurchLine."Qty. to Invoice" + PurchLine2."Qty. to Invoice";
//               TempTotalPurchLine."Prepmt Amt to Deduct" := TempTotalPurchLine."Prepmt Amt to Deduct" + PurchLine2."Prepmt Amt to Deduct";
//               AdjustInvLineWith100PctPrepmt(PurchLine2,TempTotalPurchLine);
//               TempTotalPurchLine.MODIFY;
//             END;
//           UNTIL PurchLine2.NEXT = 0;

//         IF TempPurchLine3.FINDSET THEN
//           REPEAT
//             IF TempPurchRcptLine.GET(TempPurchLine3."Receipt No.",TempPurchLine3."Receipt Line No.") THEN BEGIN
//               IF PurchLine2.GET(TempPurchLine3."Document Type"::Order,TempPurchRcptLine."Order No.",TempPurchRcptLine."Order Line No.") THEN
//                 IF TempTotalPurchLine.GET(
//                      TempPurchLine3."Document Type"::Order,TempPurchRcptLine."Order No.",TempPurchRcptLine."Order Line No.")
//                 THEN BEGIN
//                   MaxAmtToDeduct := PurchLine2."Prepmt. Amt. Inv." - PurchLine2."Prepmt Amt Deducted";

//                   IF TempTotalPurchLine."Prepmt Amt to Deduct" > MaxAmtToDeduct THEN
//                     ERROR(STRSUBSTNO(Text050,PurchLine2.FIELDCAPTION("Prepmt Amt to Deduct"),MaxAmtToDeduct));

//                   IF (TempTotalPurchLine."Qty. to Invoice" = PurchLine2.Quantity - PurchLine2."Quantity Invoiced") AND
//                      (TempTotalPurchLine."Prepmt Amt to Deduct" <> MaxAmtToDeduct)
//                   THEN
//                     ERROR(STRSUBSTNO(Text051,PurchLine2.FIELDCAPTION("Prepmt Amt to Deduct"),MaxAmtToDeduct));
//                 END;
//             END;
//           UNTIL TempPurchLine3.NEXT = 0;
//     end;

//     local procedure AdjustInvLineWith100PctPrepmt(var PurchInvoiceLine: Record "39";var TempTotalPurchLine: Record "39" temporary)
//     var
//         PurchOrderLine: Record "39";
//         DiffAmtToDeduct: Decimal;
//     begin
//         IF PurchInvoiceLine."Prepayment %" = 100 THEN BEGIN
//           PurchOrderLine := TempTotalPurchLine;
//           PurchOrderLine.FIND;
//           IF TempTotalPurchLine."Qty. to Invoice" = PurchOrderLine.Quantity - PurchOrderLine."Quantity Invoiced" THEN BEGIN
//             DiffAmtToDeduct :=
//               PurchOrderLine."Prepmt. Amt. Inv." - PurchOrderLine."Prepmt Amt Deducted" - TempTotalPurchLine."Prepmt Amt to Deduct";
//             IF DiffAmtToDeduct <> 0 THEN BEGIN
//               PurchInvoiceLine."Prepmt Amt to Deduct" := PurchInvoiceLine."Prepmt Amt to Deduct" + DiffAmtToDeduct;
//               PurchInvoiceLine."Line Amount" := PurchInvoiceLine."Prepmt Amt to Deduct";
//               PurchInvoiceLine."Line Discount Amount" := PurchInvoiceLine."Line Discount Amount" - DiffAmtToDeduct;
//               PurchInvoiceLine.MODIFY;
//               TempTotalPurchLine."Prepmt Amt to Deduct" := TempTotalPurchLine."Prepmt Amt to Deduct" + DiffAmtToDeduct;
//             END;
//           END;
//         END;
//     end;

//     procedure ArchiveUnpostedOrder()
//     var
//         ArchiveManagement: Codeunit "5063";
//     begin
//         IF NOT PurchSetup."Archive Quotes and Orders" THEN
//           EXIT;
//         IF NOT (PurchHeader."Document Type" IN [PurchHeader."Document Type"::Order,PurchHeader."Document Type"::"Return Order"]) THEN
//           EXIT;
//         PurchLine.RESET;
//         PurchLine.SETRANGE("Document Type",PurchHeader."Document Type");
//         PurchLine.SETRANGE("Document No.",PurchHeader."No.");
//         PurchLine.SETFILTER(Quantity,'<>0');
//         IF PurchHeader."Document Type" = PurchHeader."Document Type"::Order THEN
//           PurchLine.SETFILTER("Qty. to Receive",'<>0')
//         ELSE
//           PurchLine.SETFILTER("Return Qty. to Ship",'<>0');
//         IF NOT PurchLine.ISEMPTY THEN BEGIN
//           ArchiveManagement.ArchPurchDocumentNoConfirm(PurchHeader);
//           COMMIT;
//         END;
//     end;

//     procedure PostItemJrnlLineJobConsumption(var PurchLine: Record "39";var NextReservationEntryNo: Integer;QtyToBeInvoiced: Decimal;var QtyToBeInvoicedBase: Decimal;QtyToBeReceived: Decimal;QtyToBeReceivedBase: Decimal;var CheckApplToItemEntry: Boolean)
//     var
//         ItemLedgEntry: Record "32";
//     begin
//         WITH PurchLine DO BEGIN
//           IF "Job No." <> '' THEN BEGIN
//             ItemJnlLine2."Entry Type" := ItemJnlLine2."Entry Type"::"Negative Adjmt.";
//             Job.GET("Job No.");
//             ItemJnlLine2."Source No." := Job."Bill-to Customer No.";
//             IF PurchHeader.Invoice THEN BEGIN
//               ItemLedgEntry.RESET;
//               ItemLedgEntry.SETRANGE("Document No.",ReturnShptLine."Document No.");
//               ItemLedgEntry.SETRANGE("Item No.",ReturnShptLine."No.");
//               ItemLedgEntry.SETRANGE("Entry Type",ItemLedgEntry."Entry Type"::"Negative Adjmt.");
//               ItemLedgEntry.SETRANGE("Completely Invoiced",FALSE);
//               IF ItemLedgEntry.FINDFIRST THEN
//                 ItemJnlLine2."Item Shpt. Entry No." := ItemLedgEntry."Entry No.";
//             END;
//             ItemJnlLine2."Source Type" := ItemJnlLine2."Source Type"::Customer;
//             ItemJnlLine2."Discount Amount" := 0;
//             IF "Quantity Received" <> 0 THEN
//               GetNextItemLedgEntryNo(ItemJnlLine2);

//             IF QtyToBeReceived <> 0 THEN BEGIN
//               // item tracking for consumption
//               ReservationEntry2.RESET;
//               IF ReservationEntry3.FIND('-') THEN BEGIN
//                 IF ReservationEntry2.FIND('+') THEN
//                   NextReservationEntryNo := ReservationEntry2."Entry No." + 1
//                 ELSE
//                   NextReservationEntryNo := 1;
//                 REPEAT
//                   ReservationEntry2 := ReservationEntry3;
//                   ReservationEntry2."Entry No." := NextReservationEntryNo;
//                   IF ReservationEntry2.Positive THEN
//                     ReservationEntry2.Positive := FALSE
//                   ELSE
//                     ReservationEntry2.Positive := TRUE;
//                   ReservationEntry2."Quantity (Base)" := ReservationEntry2."Quantity (Base)" * -1;
//                   ReservationEntry2."Shipment Date" := ReservationEntry2."Expected Receipt Date";
//                   ReservationEntry2."Expected Receipt Date" := 0D;
//                   ReservationEntry2.Quantity := ReservationEntry2.Quantity * -1;
//                   ReservationEntry2."Qty. to Handle (Base)" := ReservationEntry2."Qty. to Handle (Base)" * -1;
//                   ReservationEntry2."Qty. to Invoice (Base)" := ReservationEntry2."Qty. to Invoice (Base)" * -1;
//                   ReservationEntry2.INSERT;
//                   NextReservationEntryNo := NextReservationEntryNo + 1;
//                 UNTIL ReservationEntry3.NEXT = 0;
//                 IF QtyToBeReceivedBase <> 0 THEN
//                   IF "Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"] THEN
//                     ReservePurchLine.TransferPurchLineToItemJnlLine(PurchLine,ItemJnlLine2,QtyToBeReceivedBase,CheckApplToItemEntry)
//                   ELSE
//                     ReservePurchLine.TransferPurchLineToItemJnlLine(PurchLine,ItemJnlLine2,-QtyToBeReceivedBase,CheckApplToItemEntry);
//               END;
//             END;

//             ItemJnlPostLine.RunWithCheck(ItemJnlLine2);

//             IF QtyToBeInvoiced <> 0 THEN BEGIN
//               "Qty. to Invoice" := QtyToBeInvoiced;
//               JobPostLine.InsertPurchLine(PurchHeader,PurchInvHeader,PurchCrMemoHeader,PurchLine,SrcCode);
//             END;
//           END;
//         END;
//     end;

//     procedure GetNextItemLedgEntryNo(var ItemJnlLine: Record "83")
//     var
//         ItemApplicationEntry: Record "339";
//     begin
//         WITH ItemApplicationEntry DO BEGIN
//           SETRANGE("Inbound Item Entry No.",ItemJnlLine."Item Shpt. Entry No.");
//           IF FINDLAST THEN
//             ItemJnlLine."Item Shpt. Entry No." := "Outbound Item Entry No.";
//         END
//     end;

//     local procedure ItemLedgerEntryExist(PurchLine2: Record "39"): Boolean
//     var
//         HasItemLedgerEntry: Boolean;
//     begin
//         IF PurchHeader.Receive OR PurchHeader.Ship THEN
//           // item ledger entry will be created during posting in this transaction
//           HasItemLedgerEntry :=
//             ((PurchLine2."Qty. to Receive" + PurchLine2."Quantity Received") <> 0) OR
//             ((PurchLine2."Qty. to Invoice" + PurchLine2."Quantity Invoiced") <> 0) OR
//             ((PurchLine2."Return Qty. to Ship" + PurchLine2."Return Qty. Shipped") <> 0)
//         ELSE
//           // item ledger entry must already exist
//           HasItemLedgerEntry :=
//             (PurchLine2."Quantity Received" <> 0) OR
//             (PurchLine2."Return Qty. Shipped" <> 0);

//         EXIT(HasItemLedgerEntry);
//     end;

//     local procedure LockTables()
//     begin
//         PurchLine.LOCKTABLE;
//         SalesOrderLine.LOCKTABLE;
//         GetGLSetup;
//         IF NOT GLSetup.OptimGLEntLockForMultiuserEnv THEN BEGIN
//           GLEntry.LOCKTABLE;
//           IF GLEntry.FINDLAST THEN;
//         END;
//     end;

//     local procedure "MAX"(number1: Integer;number2: Integer): Integer
//     begin
//         IF number1 > number2 THEN
//           EXIT(number1);
//         EXIT(number2);
//     end;

//     local procedure SortLines(var PurchaseLine: Record "39")
//     begin
//         GetGLSetup;
//         IF GLSetup.OptimGLEntLockForMultiuserEnv THEN
//           PurchaseLine.SETCURRENTKEY("Document Type","Document No.",Type,"No.")
//         ELSE
//           PurchaseLine.SETCURRENTKEY("Document Type","Document No.","Line No.");
//     end;

//     procedure CreateJobPurchLine(var JobPurchLine2: Record "39";PurchLine2: Record "39";PricesIncludingVAT: Boolean)
//     begin
//         JobPurchLine2 := PurchLine2;
//         IF PricesIncludingVAT THEN
//           IF JobPurchLine2."VAT Calculation Type" = JobPurchLine2."VAT Calculation Type"::"Full VAT" THEN
//             JobPurchLine2."Direct Unit Cost" := 0
//           ELSE
//             JobPurchLine2."Direct Unit Cost" := JobPurchLine2."Direct Unit Cost" / (1 + JobPurchLine2."VAT %" / 100);
//     end;

//     local procedure RevertWarehouseEntry(var TempWhseJnlLine: Record "7311" temporary;JobNo: Code[20];PostJobConsumptionBeforePurch: Boolean): Boolean
//     begin
//         IF PostJobConsumptionBeforePurch OR (JobNo = '') OR PositiveWhseEntrycreated THEN
//           EXIT(FALSE);
//         WITH TempWhseJnlLine DO BEGIN
//           "Entry Type" := "Entry Type"::"Negative Adjmt.";
//           Quantity := -Quantity;
//           "Qty. (Base)" := -"Qty. (Base)";
//           "From Bin Code" := "To Bin Code";
//           "To Bin Code" := '';
//         END;
//         EXIT(TRUE);
//     end;

//     local procedure CreatePositiveEntry(WhseJnlLine: Record "7311";JobNo: Code[20];PostJobConsumptionBeforePurch: Boolean)
//     begin
//         IF PostJobConsumptionBeforePurch OR (JobNo <> '') THEN BEGIN
//           WITH WhseJnlLine DO BEGIN
//             Quantity := -Quantity;
//             "Qty. (Base)" := -"Qty. (Base)";
//             "Qty. (Absolute)" := -"Qty. (Absolute)";
//             "To Bin Code" := "From Bin Code";
//             "From Bin Code" := '';
//           END;
//           WhseJnlPostLine.RUN(WhseJnlLine);
//           PositiveWhseEntrycreated := TRUE;
//         END;
//     end;

//     local procedure UpdateIncomingDocument(IncomingDocNo: Integer;PostingDate: Date;GenJnlLineDocNo: Code[20])
//     var
//         IncomingDocument: Record "130";
//     begin
//         IncomingDocument.UpdateIncomingDocumentFromPosting(IncomingDocNo,PostingDate,GenJnlLineDocNo);
//     end;

//     local procedure CheckItemCharge(ItemChargeAssignmentPurch: Record "5805")
//     var
//         PurchLineForCharge: Record "39";
//     begin
//         WITH ItemChargeAssignmentPurch DO
//           CASE "Applies-to Doc. Type" OF
//             "Applies-to Doc. Type"::Order,
//             "Applies-to Doc. Type"::Invoice:
//               IF PurchLineForCharge.GET(
//                    "Applies-to Doc. Type",
//                    "Applies-to Doc. No.",
//                    "Applies-to Doc. Line No.")
//               THEN
//                 IF (PurchLineForCharge."Quantity (Base)" = PurchLineForCharge."Qty. Received (Base)") AND
//                    (PurchLineForCharge."Qty. Rcd. Not Invoiced (Base)" = 0)
//                 THEN
//                   ERROR(Text062Err);
//             "Applies-to Doc. Type"::"Return Order",
//             "Applies-to Doc. Type"::"Credit Memo":
//               IF PurchLineForCharge.GET(
//                    "Applies-to Doc. Type",
//                    "Applies-to Doc. No.",
//                    "Applies-to Doc. Line No.")
//               THEN
//                 IF (PurchLineForCharge."Quantity (Base)" = PurchLineForCharge."Return Qty. Shipped (Base)") AND
//                    (PurchLineForCharge."Ret. Qty. Shpd Not Invd.(Base)" = 0)
//                 THEN
//                   ERROR(Text062Err);
//           END;
//     end;

//     procedure InitProgressWindow(PurchHeader: Record "38")
//     begin
//         IF PurchHeader.Invoice THEN
//           Window.OPEN(
//             '#1#################################\\' +
//             Text005 +
//             Text006 +
//             Text007 +
//             Text008)
//         ELSE
//           Window.OPEN(
//             '#1############################\\' +
//             Text009);

//         Window.UPDATE(1,STRSUBSTNO('%1 %2',PurchHeader."Document Type",PurchHeader."No."));
//     end;

//     procedure UpdateQtyPerUnitOfMeasure(var PurchLine: Record "39")
//     var
//         ItemUnitOfMeasure: Record "5404";
//     begin
//         IF PurchLine."Qty. per Unit of Measure" = 0 THEN
//           IF (PurchLine.Type = PurchLine.Type::Item) AND
//              (PurchLine."Unit of Measure" <> '') AND
//              ItemUnitOfMeasure.GET(PurchLine."No.",PurchLine."Unit of Measure")
//           THEN
//             PurchLine."Qty. per Unit of Measure" := ItemUnitOfMeasure."Qty. per Unit of Measure"
//           ELSE
//             PurchLine."Qty. per Unit of Measure" := 1;
//     end;

//     local procedure GetCountryCode(SalesLine: Record "37";SalesHeader: Record "36"): Code[10]
//     var
//         SalesShipmentHeader: Record "110";
//     begin
//         IF SalesLine."Shipment No." <> '' THEN BEGIN
//           SalesShipmentHeader.GET(SalesLine."Shipment No.");
//           EXIT(
//             GetCountryRegionCode(
//               SalesLine."Sell-to Customer No.",
//               SalesShipmentHeader."Ship-to Code",
//               SalesShipmentHeader."Sell-to Country/Region Code"));
//         END;
//         EXIT(
//           GetCountryRegionCode(
//             SalesLine."Sell-to Customer No.",
//             SalesHeader."Ship-to Code",
//             SalesHeader."Sell-to Country/Region Code"));
//     end;

//     local procedure GetCountryRegionCode(CustNo: Code[20];ShipToCode: Code[10];SellToCountryRegionCode: Code[10]): Code[10]
//     var
//         ShipToAddress: Record "222";
//     begin
//         IF ShipToCode <> '' THEN BEGIN
//           ShipToAddress.GET(CustNo,ShipToCode);
//           EXIT(ShipToAddress."Country/Region Code");
//         END;
//         EXIT(SellToCountryRegionCode);
//     end;

//     local procedure CheckItemReservDisruption()
//     var
//         Item: Record "27";
//         AvailableQty: Decimal;
//     begin
//         WITH PurchLine DO BEGIN
//           IF NOT ("Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"]) OR
//              (Type <> Type::Item) OR
//              NOT ("Return Qty. to Ship (Base)" > 0)
//           THEN
//             EXIT;

//           IF Nonstock OR
//              "Special Order" OR
//              "Drop Shipment" OR
//              IsServiceItem OR
//              TempSKU.GET("Location Code","No.","Variant Code") // Warn against item
//           THEN
//             EXIT;

//           Item.GET("No.");
//           Item.SETFILTER("Location Filter","Location Code");
//           Item.SETFILTER("Variant Filter","Variant Code");
//           Item.CALCFIELDS("Reserved Qty. on Inventory","Net Change");
//           CALCFIELDS("Reserved Qty. (Base)");
//           AvailableQty := Item."Net Change" - (Item."Reserved Qty. on Inventory" - "Reserved Qty. (Base)");

//           IF (Item."Reserved Qty. on Inventory" > 0) AND
//              (AvailableQty < "Return Qty. to Ship (Base)") AND
//              (Item."Reserved Qty. on Inventory" > ABS("Reserved Qty. (Base)"))
//           THEN BEGIN
//             InsertTempSKU("Location Code","No.","Variant Code");
//             IF NOT CONFIRM(
//                  Text061Qst,FALSE,FIELDCAPTION("No."),Item."No.",FIELDCAPTION("Location Code"),
//                  "Location Code",FIELDCAPTION("Variant Code"),"Variant Code")
//             THEN
//               ERROR('');
//           END;
//         END;
//     end;

//     local procedure InsertTempSKU(LocationCode: Code[10];ItemNo: Code[20];VariantCode: Code[10])
//     begin
//         WITH TempSKU DO BEGIN
//           INIT;
//           "Location Code" := LocationCode;
//           "Item No." := ItemNo;
//           "Variant Code" := VariantCode;
//           INSERT;
//         END;
//     end;

//     local procedure InsertInvoiceOrCrMemoLine()
//     begin
//         WITH PurchHeader DO
//           // Insert invoice line or credit memo line
//           IF "Document Type" IN ["Document Type"::Order,"Document Type"::Invoice] THEN BEGIN
//             PurchInvLine.INIT;
//             PurchInvLine.TRANSFERFIELDS(TempPurchLine);
//             PurchInvLine."Posting Date" := "Posting Date";
//             PurchInvLine."Document No." := PurchInvHeader."No.";
//             PurchInvLine.Quantity := TempPurchLine."Qty. to Invoice";
//             PurchInvLine."Quantity (Base)" := TempPurchLine."Qty. to Invoice (Base)";
//             PurchInvLine.INSERT;
//             ItemJnlPostLine.CollectValueEntryRelation(TempValueEntryRelation,COPYSTR(PurchInvLine.RowID1,1,100));
//           END ELSE BEGIN // Credit Memo
//             PurchCrMemoLine.INIT;
//             PurchCrMemoLine.TRANSFERFIELDS(TempPurchLine);
//             PurchCrMemoLine."Posting Date" := "Posting Date";
//             PurchCrMemoLine."Document No." := PurchCrMemoHeader."No.";
//             PurchCrMemoLine.Quantity := TempPurchLine."Qty. to Invoice";
//             PurchCrMemoLine."Quantity (Base)" := TempPurchLine."Qty. to Invoice (Base)";
//             PurchCrMemoLine.INSERT;
//             ItemJnlPostLine.CollectValueEntryRelation(TempValueEntryRelation,COPYSTR(PurchCrMemoLine.RowID1,1,100));
//           END;
//     end;

//     local procedure DeleteReservationEntryRelateJobNo(DocumentType: Option;DocumentNo: Code[20];LineNo: Integer;JobNo: Code[20])
//     var
//         ReservationEntry: Record "337";
//     begin
//         IF JobNo = '' THEN
//           EXIT;

//         WITH ReservationEntry DO BEGIN
//           SETRANGE("Source ID",DocumentNo);
//           SETRANGE("Source Ref. No.",LineNo);
//           SETRANGE("Source Type",DATABASE::"Purchase Line");
//           SETRANGE("Source Subtype",DocumentType);
//           SETRANGE("Reservation Status","Reservation Status"::Surplus);
//           IF DocumentType = PurchLine."Document Type"::Order THEN
//             SETRANGE(Positive,FALSE);
//           IF DocumentType = PurchLine."Document Type"::"Return Order" THEN
//             SETRANGE(Positive,TRUE);
//           DELETEALL(TRUE);
//         END;
//     end;

//     local procedure UpdatePurchLineDimSetIDFromAppliedEntry(var PurchLineToPost: Record "39";PurchLine: Record "39")
//     var
//         ItemLedgEntry: Record "32";
//         DimensionMgt: Codeunit "408";
//         DimSetID: array [10] of Integer;
//     begin
//         DimSetID[1] := PurchLine."Dimension Set ID";
//         WITH PurchLineToPost DO BEGIN
//           IF "Appl.-to Item Entry" <> 0 THEN BEGIN
//             ItemLedgEntry.GET("Appl.-to Item Entry");
//             DimSetID[2] := ItemLedgEntry."Dimension Set ID";
//           END;
//           "Dimension Set ID" :=
//             DimensionMgt.GetCombinedDimensionSetID(DimSetID,"Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
//         END;
//     end;

//     local procedure CheckCertificateOfSupplyStatus(ReturnShptHeader: Record "6650";ReturnShptLine: Record "6651")
//     var
//         CertificateOfSupply: Record "780";
//         VATPostingSetup: Record "325";
//     begin
//         IF ReturnShptLine.Quantity <> 0 THEN
//           IF VATPostingSetup.GET(ReturnShptHeader."VAT Bus. Posting Group",ReturnShptLine."VAT Prod. Posting Group") AND
//              VATPostingSetup."Certificate of Supply Required"
//           THEN BEGIN
//             CertificateOfSupply.InitFromPurchase(ReturnShptHeader);
//             CertificateOfSupply.SetRequired(ReturnShptHeader."No.")
//           END;
//     end;
// }

