// codeunit 80 "Sales-Post"
// {
//     // DP.NCM TJC #449 04/04/2018 - Bring description in line over to posted document
//     // DP.NCM TJC #461 20/06/2018 - Add condition to bring only if description is not blank
//     // DP.NCM TJC# 561 and 427 3103/2020

//     Permissions = TableData 37=imd,
//                   TableData 38=m,
//                   TableData 39=m,
//                   TableData 49=imd,
//                   TableData 110=imd,
//                   TableData 111=imd,
//                   TableData 112=imd,
//                   TableData 113=imd,
//                   TableData 114=imd,
//                   TableData 115=imd,
//                   TableData 120=imd,
//                   TableData 121=imd,
//                   TableData 223=imd,
//                   TableData 252=imd,
//                   TableData 914=i,
//                   TableData 6507=ri,
//                   TableData 6508=rid,
//                   TableData 6660=imd,
//                   TableData 6661=imd;
//     TableNo = 36;

//     trigger OnRun()
//     var
//         ItemEntryRelation: Record "6507";
//         TempInvoicingSpecification: Record "336" temporary;
//         DummyTrackingSpecification: Record "336";
//         ICHandledInboxTransaction: Record "420";
//         Cust: Record "18";
//         ICPartner: Record "413";
//         PurchSetup: Record "312";
//         PurchCommentLine: Record "43";
//         TempAsmHeader: Record "900" temporary;
//         TempItemLedgEntryNotInvoiced: Record "32" temporary;
//         TempPostedATOLink: Record "914" temporary;
//         CustLedgEntry: Record "21";
//         UpdateAnalysisView: Codeunit "410";
//         UpdateItemAnalysisView: Codeunit "7150";
//         ICInOutBoxMgt: Codeunit "427";
//         CostBaseAmount: Decimal;
//         TrackingSpecificationExists: Boolean;
//         HasATOShippedNotInvoiced: Boolean;
//         EndLoop: Boolean;
//         GLEntryNo: Integer;
//         BiggestLineNo: Integer;
//         TransactionLogEntryNo: Integer;
//     begin
//         IF ("Document Type" = "Document Type"::Invoice) AND ("Salesperson Code" = '') THEN //DP.NCM TJC# 561 and 427 3103/2020
//           ERROR('DP: Salesperson cannot be blank.');

//         IF PostingDateExists AND (ReplacePostingDate OR ("Posting Date" = 0D)) THEN BEGIN
//           "Posting Date" := PostingDate;
//           VALIDATE("Currency Code");
//         END;

//         IF PostingDateExists AND (ReplaceDocumentDate OR ("Document Date" = 0D)) THEN
//           VALIDATE("Document Date",PostingDate);

//         CLEARALL;
//         SalesHeader := Rec;
//         ServiceItemTmp2.DELETEALL;
//         ServiceItemCmpTmp2.DELETEALL;
//         WITH SalesHeader DO BEGIN
//           TESTFIELD("Document Type");
//           TESTFIELD("Sell-to Customer No.");
//           TESTFIELD("Bill-to Customer No.");
//           TESTFIELD("Posting Date");
//           TESTFIELD("Document Date");
//           IF GenJnlCheckLine.DateNotAllowed("Posting Date") THEN
//             FIELDERROR("Posting Date",Text045);

//           CASE "Document Type" OF
//             "Document Type"::Order:
//               Receive := FALSE;
//             "Document Type"::Invoice:
//               BEGIN
//                 Ship := TRUE;
//                 Invoice := TRUE;
//                 Receive := FALSE;
//               END;
//             "Document Type"::"Return Order":
//               Ship := FALSE;
//             "Document Type"::"Credit Memo":
//               BEGIN
//                 Ship := FALSE;
//                 Invoice := TRUE;
//                 Receive := TRUE;
//               END;
//           END;

//           IF NOT (Ship OR Invoice OR Receive) THEN
//             ERROR(
//               Text020,
//               FIELDCAPTION(Ship),FIELDCAPTION(Invoice),FIELDCAPTION(Receive));

//           WhseReference := "Posting from Whse. Ref.";
//           "Posting from Whse. Ref." := 0;

//           IF Invoice THEN
//             CreatePrepaymentLines(SalesHeader,TempPrepaymentSalesLine,TRUE);

//           CheckDim;

//           CopyAprvlToTempApprvl;

//           SalesSetup.GET;
//           CheckCustBlockage("Sell-to Customer No.",TRUE);
//           IF "Bill-to Customer No." <> "Sell-to Customer No." THEN
//             CheckCustBlockage("Bill-to Customer No.",FALSE);

//           IF Invoice THEN BEGIN
//             //TJC 603 DP.NCM
//             SalesLine.RESET;
//             SalesLine.SETRANGE("Document Type","Document Type");
//             SalesLine.SETRANGE("Document No.","No.");
//             SalesLine.SETFILTER(Type,'Item|G/L Account');
//             SalesLine.SETFILTER("No.",'<>%1','');
//             SalesLine.SETRANGE(Quantity,0);
//             IF SalesLine.FINDFIRST THEN BEGIN
//               ERROR('This invoice cannot be posted because line %1, Item %2 is with zero quantity.',SalesLine."Line No.",SalesLine."No.");
//             END;
//             //TJC 603 DP.NCM
//             SalesLine.RESET;
//             SalesLine.SETRANGE("Document Type","Document Type");
//             SalesLine.SETRANGE("Document No.","No.");
//             SalesLine.SETFILTER(Quantity,'<>0');
//             IF "Document Type" IN ["Document Type"::Order,"Document Type"::"Return Order"] THEN
//               SalesLine.SETFILTER("Qty. to Invoice",'<>0');
//             Invoice := NOT SalesLine.ISEMPTY;
//             IF Invoice AND (NOT Ship) AND ("Document Type" = "Document Type"::Order) THEN BEGIN
//               SalesLine.FINDSET;
//               Invoice := FALSE;
//               REPEAT
//                 Invoice := SalesLine."Quantity Shipped" - SalesLine."Quantity Invoiced" <> 0;
//               UNTIL Invoice OR (SalesLine.NEXT = 0);
//             END ELSE
//               IF Invoice AND (NOT Receive) AND ("Document Type" = "Document Type"::"Return Order") THEN BEGIN
//                 SalesLine.FINDSET;
//                 Invoice := FALSE;
//                 REPEAT
//                   Invoice := SalesLine."Return Qty. Received" - SalesLine."Quantity Invoiced" <> 0;
//                 UNTIL Invoice OR (SalesLine.NEXT = 0);
//               END;
//           END;
//           IF Invoice THEN
//             CopyAndCheckItemCharge(SalesHeader);

//           IF Invoice AND NOT ("Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"]) THEN
//             TESTFIELD("Due Date");

//           IF Ship THEN BEGIN
//             SalesLine.RESET;
//             SalesLine.SETRANGE("Document Type","Document Type");
//             SalesLine.SETRANGE("Document No.","No.");
//             SalesLine.SETFILTER(Quantity,'<>0');
//             IF "Document Type" = "Document Type"::Order THEN
//               SalesLine.SETFILTER("Qty. to Ship",'<>0');
//             SalesLine.SETRANGE("Shipment No.",'');

//             SalesLine.SETFILTER("Qty. to Assemble to Order",'<>0');
//             IF SalesLine.FINDSET THEN
//               REPEAT
//                 InitPostATO(SalesLine);
//               UNTIL SalesLine.NEXT = 0;
//             SalesLine.SETRANGE("Qty. to Assemble to Order");

//             Ship := SalesLine.FINDFIRST;
//             WhseShip := TempWhseShptHeader.FINDFIRST;
//             WhseReceive := TempWhseRcptHeader.FINDFIRST;
//             InvtPickPutaway := WhseReference <> 0;
//             IF Ship THEN
//               CheckTrackingSpecification(SalesLine);
//             IF Ship AND NOT (WhseShip OR WhseReceive OR InvtPickPutaway) THEN
//               CheckWarehouse(SalesLine);
//           END;

//           IF Receive THEN BEGIN
//             SalesLine.RESET;
//             SalesLine.SETRANGE("Document Type","Document Type");
//             SalesLine.SETRANGE("Document No.","No.");
//             SalesLine.SETFILTER(Quantity,'<>0');
//             SalesLine.SETFILTER("Return Qty. to Receive",'<>0');
//             SalesLine.SETRANGE("Return Receipt No.",'');
//             Receive := SalesLine.FINDFIRST;
//             WhseShip := TempWhseShptHeader.FINDFIRST;
//             WhseReceive := TempWhseRcptHeader.FINDFIRST;
//             InvtPickPutaway := WhseReference <> 0;
//             IF Receive THEN
//               CheckTrackingSpecification(SalesLine);
//             IF Receive AND NOT (WhseReceive OR WhseShip OR InvtPickPutaway) THEN
//               CheckWarehouse(SalesLine);
//           END;

//           IF NOT (Ship OR Invoice OR Receive) THEN
//             IF NOT OnlyAssgntPosting THEN
//               ERROR(Text001);

//           IF "Shipping Advice" = "Shipping Advice"::Complete THEN
//             CheckShippingAdvice;

//           InitProgressWindow(SalesHeader);

//           GetGLSetup;
//           GetCurrency;

//           IF Ship AND ("Shipping No." = '') THEN
//             IF ("Document Type" = "Document Type"::Order) OR
//                (("Document Type" = "Document Type"::Invoice) AND SalesSetup."Shipment on Invoice")
//             THEN BEGIN
//               TESTFIELD("Shipping No. Series");
//               "Shipping No." := NoSeriesMgt.GetNextNo("Shipping No. Series","Posting Date",TRUE);
//               ModifyHeader := TRUE;
//             END;

//           IF Receive AND ("Return Receipt No." = '') THEN
//             IF ("Document Type" = "Document Type"::"Return Order") OR
//                (("Document Type" = "Document Type"::"Credit Memo") AND SalesSetup."Return Receipt on Credit Memo")
//             THEN BEGIN
//               TESTFIELD("Return Receipt No. Series");
//               "Return Receipt No." := NoSeriesMgt.GetNextNo("Return Receipt No. Series","Posting Date",TRUE);
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
//             SalesLine.RESET;
//             SalesLine.SETRANGE("Document Type","Document Type");
//             SalesLine.SETRANGE("Document No.","No.");
//             SalesLine.SETFILTER("Purch. Order Line No.",'<>0');
//             IF NOT SalesLine.ISEMPTY THEN BEGIN
//               DropShipOrder := TRUE;
//               IF Ship THEN BEGIN
//                 SalesLine.FINDSET;
//                 REPEAT
//                   IF PurchOrderHeader."No." <> SalesLine."Purchase Order No." THEN BEGIN
//                     PurchOrderHeader.GET(
//                       PurchOrderHeader."Document Type"::Order,
//                       SalesLine."Purchase Order No.");
//                     PurchOrderHeader.TESTFIELD("Pay-to Vendor No.");
//                     PurchOrderHeader.Receive := TRUE;
//                     CODEUNIT.RUN(CODEUNIT::"Release Purchase Document",PurchOrderHeader);
//                     IF PurchOrderHeader."Receiving No." = '' THEN BEGIN
//                       PurchOrderHeader.TESTFIELD("Receiving No. Series");
//                       PurchOrderHeader."Receiving No." :=
//                         NoSeriesMgt.GetNextNo(PurchOrderHeader."Receiving No. Series","Posting Date",TRUE);
//                       PurchOrderHeader.MODIFY;
//                       ModifyHeader := TRUE;
//                     END;
//                   END;
//                 UNTIL SalesLine.NEXT = 0;
//               END;
//             END;
//           END;
//           IF ModifyHeader THEN BEGIN
//             MODIFY;
//             COMMIT;
//           END;

//           IF SalesSetup."Calc. Inv. Discount" AND
//              (Status <> Status::Open) AND
//              NOT ItemChargeAssgntOnly
//           THEN BEGIN
//             SalesLine.RESET;
//             SalesLine.SETRANGE("Document Type","Document Type");
//             SalesLine.SETRANGE("Document No.","No.");
//             SalesLine.FINDFIRST;
//             TempInvoice := Invoice;
//             TempShpt := Ship;
//             TempReturn := Receive;
//             SalesCalcDisc.RUN(SalesLine);
//             GET("Document Type","No.");
//             Invoice := TempInvoice;
//             Ship := TempShpt;
//             Receive := TempReturn;
//             COMMIT;
//           END;

//           IF (Status = Status::Open) OR (Status = Status::"Pending Prepayment") THEN BEGIN
//             TempInvoice := Invoice;
//             TempShpt := Ship;
//             TempReturn := Receive;
//             GetOpenLinkedATOs(TempAsmHeader);
//             CODEUNIT.RUN(CODEUNIT::"Release Sales Document",SalesHeader);
//             TESTFIELD(Status,Status::Released);
//             Status := Status::Open;
//             Invoice := TempInvoice;
//             Ship := TempShpt;
//             Receive := TempReturn;
//             ReopenAsmOrders(TempAsmHeader);
//             MODIFY;
//             COMMIT;
//             Status := Status::Released;
//           END;

//           TransactionLogEntryNo := AuthorizeCreditCard("Authorization Required");

//           IF Ship OR Receive THEN
//             ArchiveUnpostedOrder; // has a COMMIT;

//           IF ("Sell-to IC Partner Code" <> '') AND ICPartner.GET("Sell-to IC Partner Code") THEN
//             ICPartner.TESTFIELD(Blocked,FALSE);
//           IF ("Bill-to IC Partner Code" <> '') AND ICPartner.GET("Bill-to IC Partner Code") THEN
//             ICPartner.TESTFIELD(Blocked,FALSE);
//           IF "Send IC Document" AND ("IC Status" = "IC Status"::New) AND ("IC Direction" = "IC Direction"::Outgoing) AND
//              ("Document Type" IN ["Document Type"::Order,"Document Type"::"Return Order"])
//           THEN BEGIN
//             ICInOutBoxMgt.SendSalesDoc(Rec,TRUE);
//             "IC Status" := "IC Status"::Pending;
//             ModifyHeader := TRUE;
//           END;
//           IF "IC Direction" = "IC Direction"::Incoming THEN BEGIN
//             ICHandledInboxTransaction.SETRANGE("Document No.","External Document No.");
//             Cust.GET("Sell-to Customer No.");
//             ICHandledInboxTransaction.SETRANGE("IC Partner Code",Cust."IC Partner Code");
//             ICHandledInboxTransaction.LOCKTABLE;
//             IF ICHandledInboxTransaction.FINDFIRST THEN BEGIN
//               ICHandledInboxTransaction.Status := ICHandledInboxTransaction.Status::Posted;
//               ICHandledInboxTransaction.MODIFY;
//             END;
//           END;

//           LockTables;

//           SourceCodeSetup.GET;
//           SrcCode := SourceCodeSetup.Sales;

//           // Insert shipment header
//           IF Ship THEN BEGIN
//             IF ("Document Type" = "Document Type"::Order) OR
//                (("Document Type" = "Document Type"::Invoice) AND SalesSetup."Shipment on Invoice")
//             THEN BEGIN
//               IF DropShipOrder THEN BEGIN
//                 PurchRcptHeader.LOCKTABLE;
//                 PurchRcptLine.LOCKTABLE;
//                 SalesShptHeader.LOCKTABLE;
//                 SalesShptLine.LOCKTABLE;
//               END;
//               SalesShptHeader.INIT;
//               SalesShptHeader.TRANSFERFIELDS(SalesHeader);

//               SalesShptHeader."No." := "Shipping No.";
//               IF "Document Type" = "Document Type"::Order THEN BEGIN
//                 SalesShptHeader."Order No. Series" := "No. Series";
//                 SalesShptHeader."Order No." := "No.";
//                 IF SalesSetup."Ext. Doc. No. Mandatory" THEN
//                   TESTFIELD("External Document No.");
//               END;
//               SalesShptHeader."Source Code" := SrcCode;
//               SalesShptHeader."User ID" := USERID;
//               SalesShptHeader."No. Printed" := 0;
//               SalesShptHeader.INSERT;

//               ApprovalMgt.MoveApprvalEntryToPosted(TempApprovalEntry,DATABASE::"Sales Shipment Header",SalesShptHeader."No.");

//               IF SalesSetup."Copy Comments Order to Shpt." THEN BEGIN
//                 CopyCommentLines(
//                   "Document Type",SalesCommentLine."Document Type"::Shipment,
//                   "No.",SalesShptHeader."No.");
//                 SalesShptHeader.COPYLINKS(Rec);
//               END;
//               IF WhseShip THEN BEGIN
//                 WhseShptHeader.GET(TempWhseShptHeader."No.");
//                 WhsePostShpt.CreatePostedShptHeader(
//                   PostedWhseShptHeader,WhseShptHeader,"Shipping No.","Posting Date");
//               END;
//               IF WhseReceive THEN BEGIN
//                 WhseRcptHeader.GET(TempWhseRcptHeader."No.");
//                 WhsePostRcpt.CreatePostedRcptHeader(
//                   PostedWhseRcptHeader,WhseRcptHeader,"Shipping No.","Posting Date");
//               END;
//             END;

//             ServItemMgt.CopyReservationEntry(SalesHeader);

//             IF ("Document Type" = "Document Type"::Invoice) AND
//                (NOT SalesSetup."Shipment on Invoice")
//             THEN
//               ServItemMgt.CreateServItemOnSalesInvoice(SalesHeader);
//           END;

//           ServItemMgt.DeleteServItemOnSaleCreditMemo(SalesHeader);

//           // Insert return receipt header
//           IF Receive THEN
//             IF ("Document Type" = "Document Type"::"Return Order") OR
//                (("Document Type" = "Document Type"::"Credit Memo") AND SalesSetup."Return Receipt on Credit Memo")
//             THEN BEGIN
//               ReturnRcptHeader.INIT;
//               ReturnRcptHeader.TRANSFERFIELDS(SalesHeader);
//               ReturnRcptHeader."No." := "Return Receipt No.";
//               IF "Document Type" = "Document Type"::"Return Order" THEN BEGIN
//                 ReturnRcptHeader."Return Order No. Series" := "No. Series";
//                 ReturnRcptHeader."Return Order No." := "No.";
//                 IF SalesSetup."Ext. Doc. No. Mandatory" THEN
//                   TESTFIELD("External Document No.");
//               END;
//               ReturnRcptHeader."No. Series" := "Return Receipt No. Series";
//               ReturnRcptHeader."Source Code" := SrcCode;
//               ReturnRcptHeader."User ID" := USERID;
//               ReturnRcptHeader."No. Printed" := 0;
//               ReturnRcptHeader.INSERT(TRUE);

//               ApprovalMgt.MoveApprvalEntryToPosted(TempApprovalEntry,DATABASE::"Return Receipt Header",ReturnRcptHeader."No.");

//               IF SalesSetup."Copy Cmts Ret.Ord. to Ret.Rcpt" THEN BEGIN
//                 CopyCommentLines(
//                   "Document Type",SalesCommentLine."Document Type"::"Posted Return Receipt",
//                   "No.",ReturnRcptHeader."No.");
//                 ReturnRcptHeader.COPYLINKS(Rec);
//               END;
//               IF WhseReceive THEN BEGIN
//                 WhseRcptHeader.GET(TempWhseRcptHeader."No.");
//                 WhsePostRcpt.CreatePostedRcptHeader(PostedWhseRcptHeader,WhseRcptHeader,"Return Receipt No.","Posting Date");
//               END;
//               IF WhseShip THEN BEGIN
//                 WhseShptHeader.GET(TempWhseShptHeader."No.");
//                 WhsePostShpt.CreatePostedShptHeader(PostedWhseShptHeader,WhseShptHeader,"Return Receipt No.","Posting Date");
//               END;
//             END;

//           // Insert invoice header or credit memo header
//           IF Invoice THEN
//             IF "Document Type" IN ["Document Type"::Order,"Document Type"::Invoice] THEN BEGIN
//               SalesInvHeader.INIT;
//               SalesInvHeader.TRANSFERFIELDS(SalesHeader);

//               IF "Document Type" = "Document Type"::Order THEN BEGIN
//                 SalesInvHeader."No." := "Posting No.";
//                 IF SalesSetup."Ext. Doc. No. Mandatory" THEN
//                   TESTFIELD("External Document No.");
//                 SalesInvHeader."Pre-Assigned No. Series" := '';
//                 SalesInvHeader."Order No. Series" := "No. Series";
//                 SalesInvHeader."Order No." := "No.";
//                 Window.UPDATE(1,STRSUBSTNO(Text007,"Document Type","No.",SalesInvHeader."No."));
//               END ELSE BEGIN
//                 SalesInvHeader."Pre-Assigned No. Series" := "No. Series";
//                 SalesInvHeader."Pre-Assigned No." := "No.";
//                 IF "Posting No." <> '' THEN BEGIN
//                   SalesInvHeader."No." := "Posting No.";
//                   Window.UPDATE(1,STRSUBSTNO(Text007,"Document Type","No.",SalesInvHeader."No."));
//                 END;
//               END;
//               SalesInvHeader."Source Code" := SrcCode;
//               SalesInvHeader."User ID" := USERID;
//               SalesInvHeader."No. Printed" := 0;
//               SalesInvHeader.INSERT;

//               UpdateWonOpportunities(Rec);

//               ApprovalMgt.MoveApprvalEntryToPosted(TempApprovalEntry,DATABASE::"Sales Invoice Header",SalesInvHeader."No.");

//               IF SalesSetup."Copy Comments Order to Invoice" THEN BEGIN
//                 CopyCommentLines(
//                   "Document Type",SalesCommentLine."Document Type"::"Posted Invoice",
//                   "No.",SalesInvHeader."No.");
//                 SalesInvHeader.COPYLINKS(Rec);
//               END;
//               GenJnlLineDocType := GenJnlLine."Document Type"::Invoice;
//               GenJnlLineDocNo := SalesInvHeader."No.";
//               GenJnlLineExtDocNo := SalesInvHeader."External Document No.";
//             END ELSE BEGIN // Credit Memo
//               SalesCrMemoHeader.INIT;
//               SalesCrMemoHeader.TRANSFERFIELDS(SalesHeader);
//               IF "Document Type" = "Document Type"::"Return Order" THEN BEGIN
//                 SalesCrMemoHeader."No." := "Posting No.";
//                 IF SalesSetup."Ext. Doc. No. Mandatory" THEN
//                   TESTFIELD("External Document No.");
//                 SalesCrMemoHeader."Pre-Assigned No. Series" := '';
//                 SalesCrMemoHeader."Return Order No. Series" := "No. Series";
//                 SalesCrMemoHeader."Return Order No." := "No.";
//                 Window.UPDATE(1,STRSUBSTNO(Text008,"Document Type","No.",SalesCrMemoHeader."No."));
//               END ELSE BEGIN
//                 SalesCrMemoHeader."Pre-Assigned No. Series" := "No. Series";
//                 SalesCrMemoHeader."Pre-Assigned No." := "No.";
//                 IF "Posting No." <> '' THEN BEGIN
//                   SalesCrMemoHeader."No." := "Posting No.";
//                   Window.UPDATE(1,STRSUBSTNO(Text008,"Document Type","No.",SalesCrMemoHeader."No."));
//                 END;
//               END;
//               SalesCrMemoHeader."Source Code" := SrcCode;
//               SalesCrMemoHeader."User ID" := USERID;
//               SalesCrMemoHeader."No. Printed" := 0;
//               SalesCrMemoHeader.INSERT;

//               ApprovalMgt.MoveApprvalEntryToPosted(TempApprovalEntry,DATABASE::"Sales Cr.Memo Header",SalesCrMemoHeader."No.");

//               IF SalesSetup."Copy Cmts Ret.Ord. to Cr. Memo" THEN BEGIN
//                 CopyCommentLines(
//                   "Document Type",SalesCommentLine."Document Type"::"Posted Credit Memo",
//                   "No.",SalesCrMemoHeader."No.");
//                 SalesCrMemoHeader.COPYLINKS(Rec);
//               END;
//               GenJnlLineDocType := GenJnlLine."Document Type"::"Credit Memo";
//               GenJnlLineDocNo := SalesCrMemoHeader."No.";
//               GenJnlLineExtDocNo := SalesCrMemoHeader."External Document No.";
//             END;

//           UpdateIncomingDocument("Incoming Document Entry No.","Posting Date",GenJnlLineDocNo);

//           // Lines
//           InvPostingBuffer[1].DELETEALL;
//           DropShipPostBuffer.DELETEALL;
//           EverythingInvoiced := TRUE;

//           SalesLine.RESET;
//           SalesLine.SETRANGE("Document Type","Document Type");
//           SalesLine.SETRANGE("Document No.","No.");
//           LineCount := 0;
//           RoundingLineInserted := FALSE;
//           MergeSaleslines(SalesHeader,SalesLine,TempPrepaymentSalesLine,CombinedSalesLineTemp);
//           AdjustFinalInvWith100PctPrepmt(CombinedSalesLineTemp);

//           TempVATAmountLineRemainder.DELETEALL;
//           SalesLine.CalcVATAmountLines(1,SalesHeader,CombinedSalesLineTemp,TempVATAmountLine);

//           SortLines(SalesLine);
//           SalesLinesProcessed := FALSE;
//           IF SalesLine.FINDSET THEN
//             REPEAT
//               IF SalesLine.Type = SalesLine.Type::Item THEN
//                 DummyTrackingSpecification.CheckItemTrackingQuantity(
//                   DATABASE::"Sales Line",SalesLine."Document Type",SalesLine."Document No.",SalesLine."Line No.",
//                   SalesLine."Qty. to Ship (Base)",SalesLine."Qty. to Invoice (Base)",Ship,Invoice);
//               ItemJnlRollRndg := FALSE;
//               LineCount := LineCount + 1;
//               Window.UPDATE(2,LineCount);
//               IF SalesLine.Type = SalesLine.Type::"Charge (Item)" THEN BEGIN
//                 SalesLine.TESTFIELD(Amount);
//                 SalesLine.TESTFIELD("Job No.",'');
//                 SalesLine.TESTFIELD("Job Contract Entry No.",0);
//               END;
//               IF SalesLine.Type = SalesLine.Type::Item THEN
//                 CostBaseAmount := SalesLine."Line Amount";
//               IF SalesLine."Qty. per Unit of Measure" = 0 THEN
//                 SalesLine."Qty. per Unit of Measure" := 1;
//               CASE "Document Type" OF
//                 "Document Type"::Order:
//                   SalesLine.TESTFIELD("Return Qty. to Receive",0);
//                 "Document Type"::Invoice:
//                   BEGIN
//                     IF SalesLine."Shipment No." = '' THEN
//                       SalesLine.TESTFIELD("Qty. to Ship",SalesLine.Quantity);
//                     SalesLine.TESTFIELD("Return Qty. to Receive",0);
//                     SalesLine.TESTFIELD("Qty. to Invoice",SalesLine.Quantity);
//                   END;
//                 "Document Type"::"Return Order":
//                   SalesLine.TESTFIELD("Qty. to Ship",0);
//                 "Document Type"::"Credit Memo":
//                   BEGIN
//                     IF SalesLine."Return Receipt No." = '' THEN
//                       SalesLine.TESTFIELD("Return Qty. to Receive",SalesLine.Quantity);
//                     SalesLine.TESTFIELD("Qty. to Ship",0);
//                     SalesLine.TESTFIELD("Qty. to Invoice",SalesLine.Quantity);
//                   END;
//               END;

//               TempPostedATOLink.RESET;
//               TempPostedATOLink.DELETEALL;
//               IF Ship THEN
//                 PostATO(SalesLine,TempPostedATOLink);

//               IF NOT (Ship OR RoundingLineInserted) THEN BEGIN
//                 SalesLine."Qty. to Ship" := 0;
//                 SalesLine."Qty. to Ship (Base)" := 0;
//               END;
//               IF NOT (Receive OR RoundingLineInserted) THEN BEGIN
//                 SalesLine."Return Qty. to Receive" := 0;
//                 SalesLine."Return Qty. to Receive (Base)" := 0;
//               END;

//               JobContractLine := FALSE;
//               IF (SalesLine.Type = SalesLine.Type::Item) OR
//                  (SalesLine.Type = SalesLine.Type::"G/L Account") OR
//                  (SalesLine.Type = SalesLine.Type::" ")
//               THEN
//                 IF SalesLine."Job Contract Entry No." > 0 THEN
//                   PostJobContractLine(SalesLine);
//               IF SalesLine.Type = SalesLine.Type::Resource THEN
//                 JobTaskSalesLine := SalesLine;

//               IF SalesLine.Type = SalesLine.Type::"Fixed Asset" THEN BEGIN
//                 SalesLine.TESTFIELD("Job No.",'');
//                 SalesLine.TESTFIELD("Depreciation Book Code");
//                 DeprBook.GET(SalesLine."Depreciation Book Code");
//                 DeprBook.TESTFIELD("G/L Integration - Disposal",TRUE);
//                 FA.GET(SalesLine."No.");
//                 FA.TESTFIELD("Budgeted Asset",FALSE);
//               END ELSE BEGIN
//                 SalesLine.TESTFIELD("Depreciation Book Code",'');
//                 SalesLine.TESTFIELD("Depr. until FA Posting Date",FALSE);
//                 SalesLine.TESTFIELD("FA Posting Date",0D);
//                 SalesLine.TESTFIELD("Duplicate in Depreciation Book",'');
//                 SalesLine.TESTFIELD("Use Duplication List",FALSE);
//               END;

//               IF ("Document Type" = "Document Type"::Invoice) AND (SalesLine."Shipment No." <> '') THEN BEGIN
//                 SalesLine."Quantity Shipped" := SalesLine.Quantity;
//                 SalesLine."Qty. Shipped (Base)" := SalesLine."Quantity (Base)";
//                 SalesLine."Qty. to Ship" := 0;
//                 SalesLine."Qty. to Ship (Base)" := 0;
//               END;

//               IF ("Document Type" = "Document Type"::"Credit Memo") AND (SalesLine."Return Receipt No." <> '') THEN BEGIN
//                 SalesLine."Return Qty. Received" := SalesLine.Quantity;
//                 SalesLine."Return Qty. Received (Base)" := SalesLine."Quantity (Base)";
//                 SalesLine."Return Qty. to Receive" := 0;
//                 SalesLine."Return Qty. to Receive (Base)" := 0;
//               END;

//               IF Invoice THEN BEGIN
//                 IF ABS(SalesLine."Qty. to Invoice") > ABS(SalesLine.MaxQtyToInvoice) THEN
//                   SalesLine.InitQtyToInvoice;
//               END ELSE BEGIN
//                 SalesLine."Qty. to Invoice" := 0;
//                 SalesLine."Qty. to Invoice (Base)" := 0;
//               END;

//               IF (SalesLine.Type = SalesLine.Type::Item) AND (SalesLine."No." <> '') THEN BEGIN
//                 GetItem(SalesLine);
//                 IF (Item."Costing Method" = Item."Costing Method"::Standard) AND NOT SalesLine.IsShipment THEN
//                   SalesLine.GetUnitCost;
//               END;

//               IF SalesLine."Qty. to Invoice" + SalesLine."Quantity Invoiced" <> SalesLine.Quantity THEN
//                 EverythingInvoiced := FALSE;

//               IF SalesLine.Quantity = 0 THEN
//                 SalesLine.TESTFIELD(Amount,0)
//               ELSE BEGIN
//                 SalesLine.TESTFIELD("No.");
//                 SalesLine.TESTFIELD(Type);
//                 SalesLine.TESTFIELD("Gen. Bus. Posting Group");
//                 SalesLine.TESTFIELD("Gen. Prod. Posting Group");
//                 DivideAmount(1,SalesLine."Qty. to Invoice");
//               END;

//               IF SalesLine."Drop Shipment" THEN BEGIN
//                 IF SalesLine.Type <> SalesLine.Type::Item THEN
//                   SalesLine.TESTFIELD("Drop Shipment",FALSE);
//                 IF (SalesLine."Qty. to Ship" <> 0) AND (SalesLine."Purch. Order Line No." = 0) THEN
//                   ERROR(
//                     Text009 +
//                     Text010,
//                     SalesLine."Line No.");
//               END;

//               CheckItemReservDisruption;
//               RoundAmount(SalesLine."Qty. to Invoice");

//               IF NOT ("Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"]) THEN BEGIN
//                 ReverseAmount(SalesLine);
//                 ReverseAmount(SalesLineACY);
//               END;

//               RemQtyToBeInvoiced := SalesLine."Qty. to Invoice";
//               RemQtyToBeInvoicedBase := SalesLine."Qty. to Invoice (Base)";

//               // Item Tracking:
//               IF NOT SalesLine."Prepayment Line" THEN BEGIN
//                 IF Invoice THEN
//                   IF SalesLine."Qty. to Invoice" = 0 THEN
//                     TrackingSpecificationExists := FALSE
//                   ELSE
//                     TrackingSpecificationExists :=
//                       ReserveSalesLine.RetrieveInvoiceSpecification(SalesLine,TempInvoicingSpecification);
//                 EndLoop := FALSE;

//                 IF "Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"] THEN BEGIN
//                   IF ABS(RemQtyToBeInvoiced) > ABS(SalesLine."Return Qty. to Receive") THEN BEGIN
//                     ReturnRcptLine.RESET;
//                     CASE "Document Type" OF
//                       "Document Type"::"Return Order":
//                         BEGIN
//                           ReturnRcptLine.SETCURRENTKEY("Return Order No.","Return Order Line No.");
//                           ReturnRcptLine.SETRANGE("Return Order No.",SalesLine."Document No.");
//                           ReturnRcptLine.SETRANGE("Return Order Line No.",SalesLine."Line No.");
//                         END;
//                       "Document Type"::"Credit Memo":
//                         BEGIN
//                           ReturnRcptLine.SETRANGE("Document No.",SalesLine."Return Receipt No.");
//                           ReturnRcptLine.SETRANGE("Line No.",SalesLine."Return Receipt Line No.");
//                         END;
//                     END;
//                     ReturnRcptLine.SETFILTER("Return Qty. Rcd. Not Invd.",'<>0');
//                     IF ReturnRcptLine.FIND('-') THEN BEGIN
//                       ItemJnlRollRndg := TRUE;
//                       REPEAT
//                         IF TrackingSpecificationExists THEN BEGIN  // Item Tracking
//                           ItemEntryRelation.GET(TempInvoicingSpecification."Item Ledger Entry No.");
//                           ReturnRcptLine.GET(ItemEntryRelation."Source ID",ItemEntryRelation."Source Ref. No.");
//                         END ELSE
//                           ItemEntryRelation."Item Entry No." := ReturnRcptLine."Item Rcpt. Entry No.";
//                         ReturnRcptLine.TESTFIELD("Sell-to Customer No.",SalesLine."Sell-to Customer No.");
//                         ReturnRcptLine.TESTFIELD(Type,SalesLine.Type);
//                         ReturnRcptLine.TESTFIELD("No.",SalesLine."No.");
//                         ReturnRcptLine.TESTFIELD("Gen. Bus. Posting Group",SalesLine."Gen. Bus. Posting Group");
//                         ReturnRcptLine.TESTFIELD("Gen. Prod. Posting Group",SalesLine."Gen. Prod. Posting Group");
//                         ReturnRcptLine.TESTFIELD("Job No.",SalesLine."Job No.");
//                         ReturnRcptLine.TESTFIELD("Unit of Measure Code",SalesLine."Unit of Measure Code");
//                         ReturnRcptLine.TESTFIELD("Variant Code",SalesLine."Variant Code");
//                         IF SalesLine."Qty. to Invoice" * ReturnRcptLine.Quantity < 0 THEN
//                           SalesLine.FIELDERROR("Qty. to Invoice",Text024);
//                         IF TrackingSpecificationExists THEN BEGIN  // Item Tracking
//                           QtyToBeInvoiced := TempInvoicingSpecification."Qty. to Invoice";
//                           QtyToBeInvoicedBase := TempInvoicingSpecification."Qty. to Invoice (Base)";
//                         END ELSE BEGIN
//                           QtyToBeInvoiced := RemQtyToBeInvoiced - SalesLine."Return Qty. to Receive";
//                           QtyToBeInvoicedBase := RemQtyToBeInvoicedBase - SalesLine."Return Qty. to Receive (Base)";
//                         END;
//                         IF ABS(QtyToBeInvoiced) >
//                            ABS(ReturnRcptLine.Quantity - ReturnRcptLine."Quantity Invoiced")
//                         THEN BEGIN
//                           QtyToBeInvoiced := ReturnRcptLine.Quantity - ReturnRcptLine."Quantity Invoiced";
//                           QtyToBeInvoicedBase := ReturnRcptLine."Quantity (Base)" - ReturnRcptLine."Qty. Invoiced (Base)";
//                         END;

//                         IF TrackingSpecificationExists THEN
//                           ItemTrackingMgt.AdjustQuantityRounding(
//                             RemQtyToBeInvoiced,QtyToBeInvoiced,
//                             RemQtyToBeInvoicedBase,QtyToBeInvoicedBase);

//                         RemQtyToBeInvoiced := RemQtyToBeInvoiced - QtyToBeInvoiced;
//                         RemQtyToBeInvoicedBase := RemQtyToBeInvoicedBase - QtyToBeInvoicedBase;
//                         ReturnRcptLine."Quantity Invoiced" :=
//                           ReturnRcptLine."Quantity Invoiced" + QtyToBeInvoiced;
//                         ReturnRcptLine."Qty. Invoiced (Base)" :=
//                           ReturnRcptLine."Qty. Invoiced (Base)" + QtyToBeInvoicedBase;
//                         ReturnRcptLine."Return Qty. Rcd. Not Invd." :=
//                           ReturnRcptLine.Quantity - ReturnRcptLine."Quantity Invoiced";
//                         ReturnRcptLine.MODIFY;
//                         IF SalesLine.Type = SalesLine.Type::Item THEN
//                           PostItemJnlLine(
//                             SalesLine,
//                             0,0,
//                             QtyToBeInvoiced,
//                             QtyToBeInvoicedBase,
//                             // ReturnRcptLine."Item Rcpt. Entry No."
//                             ItemEntryRelation."Item Entry No.",'',TempInvoicingSpecification,FALSE);
//                         IF TrackingSpecificationExists THEN
//                           EndLoop := (TempInvoicingSpecification.NEXT = 0)
//                         ELSE
//                           EndLoop :=
//                             (ReturnRcptLine.NEXT = 0) OR (ABS(RemQtyToBeInvoiced) <= ABS(SalesLine."Return Qty. to Receive"));
//                       UNTIL EndLoop;
//                     END ELSE
//                       ERROR(
//                         Text025,
//                         SalesLine."Return Receipt Line No.",SalesLine."Return Receipt No.");
//                   END;

//                   IF ABS(RemQtyToBeInvoiced) > ABS(SalesLine."Return Qty. to Receive") THEN BEGIN
//                     IF "Document Type" = "Document Type"::"Credit Memo" THEN
//                       ERROR(
//                         Text038,
//                         ReturnRcptLine."Document No.");
//                     ERROR(Text037);
//                   END;
//                 END ELSE BEGIN
//                   IF ABS(RemQtyToBeInvoiced) > ABS(SalesLine."Qty. to Ship") THEN BEGIN
//                     SalesShptLine.RESET;
//                     CASE "Document Type" OF
//                       "Document Type"::Order:
//                         BEGIN
//                           SalesShptLine.SETCURRENTKEY("Order No.","Order Line No.");
//                           SalesShptLine.SETRANGE("Order No.",SalesLine."Document No.");
//                           SalesShptLine.SETRANGE("Order Line No.",SalesLine."Line No.");
//                         END;
//                       "Document Type"::Invoice:
//                         BEGIN
//                           SalesShptLine.SETRANGE("Document No.",SalesLine."Shipment No.");
//                           SalesShptLine.SETRANGE("Line No.",SalesLine."Shipment Line No.");
//                         END;
//                     END;

//                     IF NOT TrackingSpecificationExists THEN
//                       HasATOShippedNotInvoiced := GetATOItemLedgEntriesNotInvoiced(SalesLine,TempItemLedgEntryNotInvoiced);

//                     SalesShptLine.SETFILTER("Qty. Shipped Not Invoiced",'<>0');
//                     IF SalesShptLine.FINDFIRST THEN BEGIN
//                       ItemJnlRollRndg := TRUE;
//                       REPEAT
//                         SetItemEntryRelation(
//                           ItemEntryRelation,SalesShptLine,
//                           TempInvoicingSpecification,TempItemLedgEntryNotInvoiced,
//                           TrackingSpecificationExists,HasATOShippedNotInvoiced);

//                         SalesShptLine.TESTFIELD("Sell-to Customer No.",SalesLine."Sell-to Customer No.");
//                         SalesShptLine.TESTFIELD(Type,SalesLine.Type);
//                         SalesShptLine.TESTFIELD("No.",SalesLine."No.");
//                         SalesShptLine.TESTFIELD("Gen. Bus. Posting Group",SalesLine."Gen. Bus. Posting Group");
//                         SalesShptLine.TESTFIELD("Gen. Prod. Posting Group",SalesLine."Gen. Prod. Posting Group");
//                         SalesShptLine.TESTFIELD("Job No.",SalesLine."Job No.");
//                         SalesShptLine.TESTFIELD("Unit of Measure Code",SalesLine."Unit of Measure Code");
//                         SalesShptLine.TESTFIELD("Variant Code",SalesLine."Variant Code");
//                         IF -SalesLine."Qty. to Invoice" * SalesShptLine.Quantity < 0 THEN
//                           SalesLine.FIELDERROR("Qty. to Invoice",Text011);

//                         UpdateQtyToBeInvoiced(
//                           QtyToBeInvoiced,QtyToBeInvoicedBase,
//                           TrackingSpecificationExists,HasATOShippedNotInvoiced,
//                           SalesLine,SalesShptLine,
//                           TempInvoicingSpecification,TempItemLedgEntryNotInvoiced);

//                         IF TrackingSpecificationExists OR HasATOShippedNotInvoiced THEN
//                           ItemTrackingMgt.AdjustQuantityRounding(
//                             RemQtyToBeInvoiced,QtyToBeInvoiced,
//                             RemQtyToBeInvoicedBase,QtyToBeInvoicedBase);

//                         RemQtyToBeInvoiced := RemQtyToBeInvoiced - QtyToBeInvoiced;
//                         RemQtyToBeInvoicedBase := RemQtyToBeInvoicedBase - QtyToBeInvoicedBase;
//                         SalesShptLine."Quantity Invoiced" :=
//                           SalesShptLine."Quantity Invoiced" - QtyToBeInvoiced;
//                         SalesShptLine."Qty. Invoiced (Base)" :=
//                           SalesShptLine."Qty. Invoiced (Base)" - QtyToBeInvoicedBase;
//                         SalesShptLine."Qty. Shipped Not Invoiced" :=
//                           SalesShptLine.Quantity - SalesShptLine."Quantity Invoiced";
//                         SalesShptLine.MODIFY;
//                         IF SalesLine.Type = SalesLine.Type::Item THEN
//                           PostItemJnlLine(
//                             SalesLine,
//                             0,0,
//                             QtyToBeInvoiced,
//                             QtyToBeInvoicedBase,
//                             // SalesShptLine."Item Shpt. Entry No."
//                             ItemEntryRelation."Item Entry No.",'',TempInvoicingSpecification,FALSE);
//                       UNTIL IsEndLoopForShippedNotInvoiced(
//                               RemQtyToBeInvoiced,TrackingSpecificationExists,HasATOShippedNotInvoiced,
//                               SalesShptLine,TempInvoicingSpecification,TempItemLedgEntryNotInvoiced,SalesLine);
//                     END ELSE
//                       ERROR(
//                         Text026,
//                         SalesLine."Shipment Line No.",SalesLine."Shipment No.");
//                   END;

//                   IF ABS(RemQtyToBeInvoiced) > ABS(SalesLine."Qty. to Ship") THEN BEGIN
//                     IF "Document Type" = "Document Type"::Invoice THEN
//                       ERROR(
//                         Text027,
//                         SalesShptLine."Document No.");
//                     ERROR(Text013);
//                   END;
//                 END;

//                 IF TrackingSpecificationExists THEN
//                   SaveInvoiceSpecification(TempInvoicingSpecification);
//               END;

//               CASE SalesLine.Type OF
//                 SalesLine.Type::"G/L Account":
//                   IF (SalesLine."No." <> '') AND NOT SalesLine."System-Created Entry" THEN BEGIN
//                     GLAcc.GET(SalesLine."No.");
//                     GLAcc.TESTFIELD("Direct Posting",TRUE);
//                     IF (SalesLine."IC Partner Code" <> '') AND Invoice THEN
//                       InsertICGenJnlLine(TempSalesLine);
//                   END;
//                 SalesLine.Type::Item:
//                   BEGIN
//                     IF (SalesLine."Qty. to Ship" <> 0) AND (SalesLine."Purch. Order Line No." <> 0) THEN BEGIN
//                       DropShipPostBuffer."Order No." := SalesLine."Purchase Order No.";
//                       DropShipPostBuffer."Order Line No." := SalesLine."Purch. Order Line No.";
//                       DropShipPostBuffer.Quantity := -SalesLine."Qty. to Ship";
//                       DropShipPostBuffer."Quantity (Base)" := -SalesLine."Qty. to Ship (Base)";
//                       DropShipPostBuffer."Item Shpt. Entry No." :=
//                         PostAssocItemJnlLine(DropShipPostBuffer.Quantity,DropShipPostBuffer."Quantity (Base)");
//                       DropShipPostBuffer.INSERT;
//                       SalesLine."Appl.-to Item Entry" := DropShipPostBuffer."Item Shpt. Entry No.";
//                     END;

//                     CLEAR(TempPostedATOLink);
//                     TempPostedATOLink.SETRANGE("Order No.",SalesLine."Document No.");
//                     TempPostedATOLink.SETRANGE("Order Line No.",SalesLine."Line No.");
//                     IF TempPostedATOLink.FINDFIRST THEN
//                       PostATOAssocItemJnlLine(SalesLine,TempPostedATOLink,RemQtyToBeInvoiced,RemQtyToBeInvoicedBase);

//                     IF RemQtyToBeInvoiced <> 0 THEN
//                       ItemLedgShptEntryNo :=
//                         PostItemJnlLine(
//                           SalesLine,
//                           RemQtyToBeInvoiced,RemQtyToBeInvoicedBase,
//                           RemQtyToBeInvoiced,RemQtyToBeInvoicedBase,
//                           0,'',DummyTrackingSpecification,FALSE);

//                     IF "Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"] THEN BEGIN
//                       IF ABS(SalesLine."Return Qty. to Receive") > ABS(RemQtyToBeInvoiced) THEN
//                         ItemLedgShptEntryNo :=
//                           PostItemJnlLine(
//                             SalesLine,
//                             SalesLine."Return Qty. to Receive" - RemQtyToBeInvoiced,
//                             SalesLine."Return Qty. to Receive (Base)" - RemQtyToBeInvoicedBase,
//                             0,0,0,'',DummyTrackingSpecification,FALSE);
//                     END ELSE BEGIN
//                       IF ABS(SalesLine."Qty. to Ship") > ABS(RemQtyToBeInvoiced) + ABS(TempPostedATOLink."Assembled Quantity") THEN
//                         ItemLedgShptEntryNo :=
//                           PostItemJnlLine(
//                             SalesLine,
//                             SalesLine."Qty. to Ship" - TempPostedATOLink."Assembled Quantity" - RemQtyToBeInvoiced,
//                             SalesLine."Qty. to Ship (Base)" - TempPostedATOLink."Assembled Quantity (Base)" - RemQtyToBeInvoicedBase,
//                             0,0,0,'',DummyTrackingSpecification,FALSE);
//                     END;
//                   END;
//                 SalesLine.Type::Resource:
//                   IF SalesLine."Qty. to Invoice" <> 0 THEN BEGIN
//                     ResJnlLine.INIT;
//                     ResJnlLine."Posting Date" := "Posting Date";
//                     ResJnlLine."Document Date" := "Document Date";
//                     ResJnlLine."Reason Code" := "Reason Code";
//                     ResJnlLine."Resource No." := SalesLine."No.";
//                     ResJnlLine.Description := SalesLine.Description;
//                     ResJnlLine."Source Type" := ResJnlLine."Source Type"::Customer;
//                     ResJnlLine."Source No." := SalesLine."Sell-to Customer No.";
//                     ResJnlLine."Work Type Code" := SalesLine."Work Type Code";
//                     ResJnlLine."Job No." := SalesLine."Job No.";
//                     ResJnlLine."Unit of Measure Code" := SalesLine."Unit of Measure Code";
//                     ResJnlLine."Shortcut Dimension 1 Code" := SalesLine."Shortcut Dimension 1 Code";
//                     ResJnlLine."Shortcut Dimension 2 Code" := SalesLine."Shortcut Dimension 2 Code";
//                     ResJnlLine."Dimension Set ID" := SalesLine."Dimension Set ID";
//                     ResJnlLine."Gen. Bus. Posting Group" := SalesLine."Gen. Bus. Posting Group";
//                     ResJnlLine."Gen. Prod. Posting Group" := SalesLine."Gen. Prod. Posting Group";
//                     ResJnlLine."Entry Type" := ResJnlLine."Entry Type"::Sale;
//                     ResJnlLine."Document No." := GenJnlLineDocNo;
//                     ResJnlLine."External Document No." := GenJnlLineExtDocNo;
//                     ResJnlLine.Quantity := -SalesLine."Qty. to Invoice";
//                     ResJnlLine."Unit Cost" := SalesLine."Unit Cost (LCY)";
//                     ResJnlLine."Total Cost" := SalesLine."Unit Cost (LCY)" * ResJnlLine.Quantity;
//                     ResJnlLine."Unit Price" := -SalesLine.Amount / SalesLine.Quantity;
//                     ResJnlLine."Total Price" := -SalesLine.Amount;
//                     ResJnlLine."Source Code" := SrcCode;
//                     ResJnlLine."Posting No. Series" := "Posting No. Series";
//                     ResJnlLine."Qty. per Unit of Measure" := SalesLine."Qty. per Unit of Measure";
//                     ResJnlPostLine.RunWithCheck(ResJnlLine);
//                     IF JobTaskSalesLine."Job Contract Entry No." > 0 THEN
//                       PostJobContractLine(JobTaskSalesLine);
//                   END;
//                 SalesLine.Type::"Charge (Item)":
//                   IF Invoice OR ItemChargeAssgntOnly THEN BEGIN
//                     ItemJnlRollRndg := TRUE;
//                     ClearItemChargeAssgntFilter;
//                     TempItemChargeAssgntSales.SETCURRENTKEY("Applies-to Doc. Type");
//                     TempItemChargeAssgntSales.SETRANGE("Document Line No.",SalesLine."Line No.");
//                     IF TempItemChargeAssgntSales.FINDSET THEN
//                       REPEAT
//                         IF ItemChargeAssgntOnly AND (GenJnlLineDocNo = '') THEN
//                           GenJnlLineDocNo := TempItemChargeAssgntSales."Applies-to Doc. No.";
//                         CASE TempItemChargeAssgntSales."Applies-to Doc. Type" OF
//                           TempItemChargeAssgntSales."Applies-to Doc. Type"::Shipment:
//                             BEGIN
//                               PostItemChargePerShpt(SalesLine);
//                               TempItemChargeAssgntSales.MARK(TRUE);
//                             END;
//                           TempItemChargeAssgntSales."Applies-to Doc. Type"::"Return Receipt":
//                             BEGIN
//                               PostItemChargePerRetRcpt(SalesLine);
//                               TempItemChargeAssgntSales.MARK(TRUE);
//                             END;
//                           TempItemChargeAssgntSales."Applies-to Doc. Type"::Order,
//                           TempItemChargeAssgntSales."Applies-to Doc. Type"::Invoice,
//                           TempItemChargeAssgntSales."Applies-to Doc. Type"::"Return Order",
//                           TempItemChargeAssgntSales."Applies-to Doc. Type"::"Credit Memo":
//                             CheckItemCharge(TempItemChargeAssgntSales);
//                         END;
//                       UNTIL TempItemChargeAssgntSales.NEXT = 0;
//                   END;
//               END;

//               IF (SalesLine.Type >= SalesLine.Type::"G/L Account") AND (SalesLine."Qty. to Invoice" <> 0) THEN BEGIN
//                 AdjustPrepmtAmountLCY(SalesLine);
//                 // Copy sales to buffer
//                 FillInvPostingBuffer(SalesLine,SalesLineACY);
//                 InsertPrepmtAdjInvPostingBuf(SalesLine);
//               END;

//               IF NOT ("Document Type" IN ["Document Type"::Invoice,"Document Type"::"Credit Memo"]) THEN
//                 SalesLine.TESTFIELD("Job No.",'');

//               IF (SalesShptHeader."No." <> '') AND (SalesLine."Shipment No." = '') AND
//                  NOT RoundingLineInserted AND NOT TempSalesLine."Prepayment Line"
//               THEN BEGIN
//                 // Insert shipment line
//                 SalesShptLine.INIT;
//                 SalesShptLine.TRANSFERFIELDS(TempSalesLine);
//                 SalesShptLine."Posting Date" := "Posting Date";
//                 SalesShptLine."Document No." := SalesShptHeader."No.";
//                 SalesShptLine.Quantity := TempSalesLine."Qty. to Ship";
//                 SalesShptLine."Quantity (Base)" := TempSalesLine."Qty. to Ship (Base)";
//                 IF ABS(TempSalesLine."Qty. to Invoice") > ABS(TempSalesLine."Qty. to Ship") THEN BEGIN
//                   SalesShptLine."Quantity Invoiced" := TempSalesLine."Qty. to Ship";
//                   SalesShptLine."Qty. Invoiced (Base)" := TempSalesLine."Qty. to Ship (Base)";
//                 END ELSE BEGIN
//                   SalesShptLine."Quantity Invoiced" := TempSalesLine."Qty. to Invoice";
//                   SalesShptLine."Qty. Invoiced (Base)" := TempSalesLine."Qty. to Invoice (Base)";
//                 END;
//                 SalesShptLine."Qty. Shipped Not Invoiced" :=
//                   SalesShptLine.Quantity - SalesShptLine."Quantity Invoiced";
//                 IF "Document Type" = "Document Type"::Order THEN BEGIN
//                   SalesShptLine."Order No." := TempSalesLine."Document No.";
//                   SalesShptLine."Order Line No." := TempSalesLine."Line No.";
//                 END;

//                 IF (SalesLine.Type = SalesLine.Type::Item) AND (TempSalesLine."Qty. to Ship" <> 0) THEN BEGIN
//                   IF WhseShip THEN BEGIN
//                     WhseShptLine.SETCURRENTKEY(
//                       "No.","Source Type","Source Subtype","Source No.","Source Line No.");
//                     WhseShptLine.SETRANGE("No.",WhseShptHeader."No.");
//                     WhseShptLine.SETRANGE("Source Type",DATABASE::"Sales Line");
//                     WhseShptLine.SETRANGE("Source Subtype",SalesLine."Document Type");
//                     WhseShptLine.SETRANGE("Source No.",SalesLine."Document No.");
//                     WhseShptLine.SETRANGE("Source Line No.",SalesLine."Line No.");
//                     WhseShptLine.FINDFIRST;

//                     PostWhseShptLines(WhseShptLine,SalesShptLine,SalesLine);
//                   END;
//                   IF WhseReceive THEN BEGIN
//                     WhseRcptLine.SETCURRENTKEY(
//                       "No.","Source Type","Source Subtype","Source No.","Source Line No.");
//                     WhseRcptLine.SETRANGE("No.",WhseRcptHeader."No.");
//                     WhseRcptLine.SETRANGE("Source Type",DATABASE::"Sales Line");
//                     WhseRcptLine.SETRANGE("Source Subtype",SalesLine."Document Type");
//                     WhseRcptLine.SETRANGE("Source No.",SalesLine."Document No.");
//                     WhseRcptLine.SETRANGE("Source Line No.",SalesLine."Line No.");
//                     WhseRcptLine.FINDFIRST;
//                     WhseRcptLine.TESTFIELD("Qty. to Receive",-SalesShptLine.Quantity);
//                     SaveTempWhseSplitSpec(SalesLine);
//                     WhsePostRcpt.CreatePostedRcptLine(
//                       WhseRcptLine,PostedWhseRcptHeader,PostedWhseRcptLine,TempWhseSplitSpecification);
//                   END;

//                   SalesShptLine."Item Shpt. Entry No." :=
//                     InsertShptEntryRelation(SalesShptLine); // ItemLedgShptEntryNo
//                   SalesShptLine."Item Charge Base Amount" :=
//                     ROUND(CostBaseAmount / SalesLine.Quantity * SalesShptLine.Quantity);
//                 END;
//                 SalesShptLine."Authorized for Credit Card" := IsAuthorized(TransactionLogEntryNo);
//                 SalesShptLine.INSERT;

//                 CheckCertificateOfSupplyStatus(SalesShptHeader,SalesShptLine);

//                 ServItemMgt.CreateServItemOnSalesLineShpt(Rec,TempSalesLine,SalesShptLine);

//                 IF SalesLine."BOM Item No." <> '' THEN BEGIN
//                   ServItemMgt.ReturnServItemComp(ServiceItemTmp1,ServiceItemCmpTmp1);
//                   IF ServiceItemTmp1.FIND('-') THEN
//                     REPEAT
//                       ServiceItemTmp2 := ServiceItemTmp1;
//                       IF ServiceItemTmp2.INSERT THEN;
//                     UNTIL ServiceItemTmp1.NEXT = 0;
//                   IF ServiceItemCmpTmp1.FIND('-') THEN
//                     REPEAT
//                       ServiceItemCmpTmp2 := ServiceItemCmpTmp1;
//                       IF ServiceItemCmpTmp2.INSERT THEN;
//                     UNTIL ServiceItemCmpTmp1.NEXT = 0;
//                 END;
//               END;

//               IF (ReturnRcptHeader."No." <> '') AND (SalesLine."Return Receipt No." = '') AND
//                  NOT RoundingLineInserted
//               THEN BEGIN
//                 // Insert return receipt line
//                 ReturnRcptLine.INIT;
//                 ReturnRcptLine.TRANSFERFIELDS(TempSalesLine);
//                 ReturnRcptLine."Document No." := ReturnRcptHeader."No.";
//                 ReturnRcptLine."Posting Date" := ReturnRcptHeader."Posting Date";
//                 ReturnRcptLine.Quantity := TempSalesLine."Return Qty. to Receive";
//                 ReturnRcptLine."Quantity (Base)" := TempSalesLine."Return Qty. to Receive (Base)";
//                 IF ABS(TempSalesLine."Qty. to Invoice") > ABS(TempSalesLine."Return Qty. to Receive") THEN BEGIN
//                   ReturnRcptLine."Quantity Invoiced" := TempSalesLine."Return Qty. to Receive";
//                   ReturnRcptLine."Qty. Invoiced (Base)" := TempSalesLine."Return Qty. to Receive (Base)";
//                 END ELSE BEGIN
//                   ReturnRcptLine."Quantity Invoiced" := TempSalesLine."Qty. to Invoice";
//                   ReturnRcptLine."Qty. Invoiced (Base)" := TempSalesLine."Qty. to Invoice (Base)";
//                 END;
//                 ReturnRcptLine."Return Qty. Rcd. Not Invd." :=
//                   ReturnRcptLine.Quantity - ReturnRcptLine."Quantity Invoiced";
//                 IF "Document Type" = "Document Type"::"Return Order" THEN BEGIN
//                   ReturnRcptLine."Return Order No." := TempSalesLine."Document No.";
//                   ReturnRcptLine."Return Order Line No." := TempSalesLine."Line No.";
//                 END;
//                 IF (SalesLine.Type = SalesLine.Type::Item) AND (TempSalesLine."Return Qty. to Receive" <> 0) THEN BEGIN
//                   IF WhseReceive THEN BEGIN
//                     WhseRcptLine.SETCURRENTKEY(
//                       "No.","Source Type","Source Subtype","Source No.","Source Line No.");
//                     WhseRcptLine.SETRANGE("No.",WhseRcptHeader."No.");
//                     WhseRcptLine.SETRANGE("Source Type",DATABASE::"Sales Line");
//                     WhseRcptLine.SETRANGE("Source Subtype",SalesLine."Document Type");
//                     WhseRcptLine.SETRANGE("Source No.",SalesLine."Document No.");
//                     WhseRcptLine.SETRANGE("Source Line No.",SalesLine."Line No.");
//                     WhseRcptLine.FINDFIRST;
//                     WhseRcptLine.TESTFIELD("Qty. to Receive",ReturnRcptLine.Quantity);
//                     SaveTempWhseSplitSpec(SalesLine);
//                     WhsePostRcpt.CreatePostedRcptLine(
//                       WhseRcptLine,PostedWhseRcptHeader,PostedWhseRcptLine,TempWhseSplitSpecification);
//                   END;
//                   IF WhseShip THEN BEGIN
//                     WhseShptLine.SETCURRENTKEY(
//                       "No.","Source Type","Source Subtype","Source No.","Source Line No.");
//                     WhseShptLine.SETRANGE("No.",WhseShptHeader."No.");
//                     WhseShptLine.SETRANGE("Source Type",DATABASE::"Sales Line");
//                     WhseShptLine.SETRANGE("Source Subtype",SalesLine."Document Type");
//                     WhseShptLine.SETRANGE("Source No.",SalesLine."Document No.");
//                     WhseShptLine.SETRANGE("Source Line No.",SalesLine."Line No.");
//                     WhseShptLine.FINDFIRST;
//                     WhseShptLine.TESTFIELD("Qty. to Ship",-ReturnRcptLine.Quantity);
//                     SaveTempWhseSplitSpec(SalesLine);
//                     WhsePostShpt.SetWhseJnlRegisterCU(WhseJnlPostLine);
//                     WhsePostShpt.CreatePostedShptLine(
//                       WhseShptLine,PostedWhseShptHeader,PostedWhseShptLine,TempWhseSplitSpecification);
//                   END;

//                   ReturnRcptLine."Item Rcpt. Entry No." :=
//                     InsertReturnEntryRelation(ReturnRcptLine); // ItemLedgShptEntryNo;
//                   ReturnRcptLine."Item Charge Base Amount" :=
//                     ROUND(CostBaseAmount / SalesLine.Quantity * ReturnRcptLine.Quantity);
//                 END;
//                 ReturnRcptLine.INSERT;
//               END;

//               IF Invoice THEN BEGIN
//                 // Insert invoice line or credit memo line
//                 IF "Document Type" IN ["Document Type"::Order,"Document Type"::Invoice] THEN BEGIN
//                   SalesInvLine.INIT;
//                   SalesInvLine.TRANSFERFIELDS(TempSalesLine);
//                   SalesInvLine."Posting Date" := "Posting Date";
//                   SalesInvLine."Document No." := SalesInvHeader."No.";
//                   SalesInvLine.Quantity := TempSalesLine."Qty. to Invoice";
//                   SalesInvLine."Quantity (Base)" := TempSalesLine."Qty. to Invoice (Base)";
//                   SalesInvLine.INSERT;
//                   ItemJnlPostLine.CollectValueEntryRelation(TempValueEntryRelation,SalesInvLine.RowID1);
//                 END ELSE BEGIN // Credit Memo
//                   SalesCrMemoLine.INIT;
//                   SalesCrMemoLine.TRANSFERFIELDS(TempSalesLine);
//                   SalesCrMemoLine."Posting Date" := "Posting Date";
//                   SalesCrMemoLine."Document No." := SalesCrMemoHeader."No.";
//                   SalesCrMemoLine.Quantity := TempSalesLine."Qty. to Invoice";
//                   SalesCrMemoLine."Quantity (Base)" := TempSalesLine."Qty. to Invoice (Base)";
//                   SalesCrMemoLine.INSERT;
//                   ItemJnlPostLine.CollectValueEntryRelation(TempValueEntryRelation,SalesCrMemoLine.RowID1);
//                 END;
//               END;

//               IF RoundingLineInserted THEN
//                 LastLineRetrieved := TRUE
//               ELSE BEGIN
//                 BiggestLineNo := MAX(BiggestLineNo,SalesLine."Line No.");
//                 LastLineRetrieved := GetNextSalesline(SalesLine);
//                 IF LastLineRetrieved AND SalesSetup."Invoice Rounding" THEN
//                   InvoiceRounding(FALSE,BiggestLineNo);
//               END;
//             UNTIL LastLineRetrieved;

//           IF NOT ("Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"]) THEN BEGIN
//             ReverseAmount(TotalSalesLine);
//             ReverseAmount(TotalSalesLineLCY);
//             TotalSalesLineLCY."Unit Cost (LCY)" := -TotalSalesLineLCY."Unit Cost (LCY)";
//           END;

//           // Post drop shipment of purchase order
//           PurchSetup.GET;
//           IF DropShipPostBuffer.FIND('-') THEN
//             REPEAT
//               PurchOrderHeader.GET(
//                 PurchOrderHeader."Document Type"::Order,
//                 DropShipPostBuffer."Order No.");
//               PurchRcptHeader.INIT;
//               PurchRcptHeader.TRANSFERFIELDS(PurchOrderHeader);
//               PurchRcptHeader."No." := PurchOrderHeader."Receiving No.";
//               PurchRcptHeader."Order No." := PurchOrderHeader."No.";
//               PurchRcptHeader."Posting Date" := "Posting Date";
//               PurchRcptHeader."Document Date" := "Document Date";
//               PurchRcptHeader."No. Printed" := 0;
//               PurchRcptHeader.INSERT;

//               ApprovalMgt.MoveApprvalEntryToPosted(TempApprovalEntry,DATABASE::"Purch. Rcpt. Header",PurchRcptHeader."No.");

//               IF PurchSetup."Copy Comments Order to Receipt" THEN BEGIN
//                 CopyPurchCommentLines(
//                   PurchOrderHeader."Document Type",PurchCommentLine."Document Type"::Receipt,
//                   PurchOrderHeader."No.",PurchRcptHeader."No.");
//                 PurchRcptHeader.COPYLINKS(Rec);
//               END;
//               DropShipPostBuffer.SETRANGE("Order No.",DropShipPostBuffer."Order No.");
//               REPEAT
//                 PurchOrderLine.GET(
//                   PurchOrderLine."Document Type"::Order,
//                   DropShipPostBuffer."Order No.",DropShipPostBuffer."Order Line No.");
//                 PurchRcptLine.INIT;
//                 PurchRcptLine.TRANSFERFIELDS(PurchOrderLine);
//                 PurchRcptLine."Posting Date" := PurchRcptHeader."Posting Date";
//                 PurchRcptLine."Document No." := PurchRcptHeader."No.";
//                 PurchRcptLine.Quantity := DropShipPostBuffer.Quantity;
//                 PurchRcptLine."Quantity (Base)" := DropShipPostBuffer."Quantity (Base)";
//                 PurchRcptLine."Quantity Invoiced" := 0;
//                 PurchRcptLine."Qty. Invoiced (Base)" := 0;
//                 PurchRcptLine."Order No." := PurchOrderLine."Document No.";
//                 PurchRcptLine."Order Line No." := PurchOrderLine."Line No.";
//                 PurchRcptLine."Qty. Rcd. Not Invoiced" :=
//                   PurchRcptLine.Quantity - PurchRcptLine."Quantity Invoiced";

//                 IF PurchRcptLine.Quantity <> 0 THEN BEGIN
//                   PurchRcptLine."Item Rcpt. Entry No." := DropShipPostBuffer."Item Shpt. Entry No.";
//                   PurchRcptLine."Item Charge Base Amount" := PurchOrderLine."Line Amount"
//                 END;
//                 PurchRcptLine.INSERT;
//                 PurchOrderLine."Qty. to Receive" := DropShipPostBuffer.Quantity;
//                 PurchOrderLine."Qty. to Receive (Base)" := DropShipPostBuffer."Quantity (Base)";
//                 PurchPost.UpdateBlanketOrderLine(PurchOrderLine,TRUE,FALSE,FALSE);
//               UNTIL DropShipPostBuffer.NEXT = 0;
//               DropShipPostBuffer.SETRANGE("Order No.");
//             UNTIL DropShipPostBuffer.NEXT = 0;

//           InvtSetup.GET;
//           IF InvtSetup."Automatic Cost Adjustment" <>
//              InvtSetup."Automatic Cost Adjustment"::Never
//           THEN BEGIN
//             InvtAdjmt.SetProperties(TRUE,InvtSetup."Automatic Cost Posting");
//             InvtAdjmt.SetJobUpdateProperties(TRUE);
//             InvtAdjmt.MakeMultiLevelAdjmt;
//           END;

//           IF Invoice THEN BEGIN
//             // Post sales and VAT to G/L entries from posting buffer
//             LineCount := 0;
//             IF InvPostingBuffer[1].FIND('+') THEN
//               REPEAT
//                 LineCount := LineCount + 1;
//                 Window.UPDATE(3,LineCount);

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
//                   GenJnlLine."Gen. Posting Type" := GenJnlLine."Gen. Posting Type"::Sale;
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
//                 GenJnlLine."EU 3-Party Trade" := "EU 3-Party Trade";
//                 GenJnlLine."Sell-to/Buy-from No." := "Sell-to Customer No.";
//                 GenJnlLine."Bill-to/Pay-to No." := "Bill-to Customer No.";
//                 GenJnlLine."Country/Region Code" := "VAT Country/Region Code";
//                 GenJnlLine."VAT Registration No." := "VAT Registration No.";
//                 GenJnlLine."Source Type" := GenJnlLine."Source Type"::Customer;
//                 GenJnlLine."Source No." := "Bill-to Customer No.";
//                 GenJnlLine."Posting No. Series" := "Posting No. Series";
//                 GenJnlLine."Ship-to/Order Address Code" := "Ship-to Code";
//                 IF InvPostingBuffer[1].Type = InvPostingBuffer[1].Type::"Fixed Asset" THEN BEGIN
//                   GenJnlLine."Account Type" := GenJnlLine."Account Type"::"Fixed Asset";
//                   GenJnlLine."FA Posting Type" := GenJnlLine."FA Posting Type"::Disposal;
//                   GenJnlLine."FA Posting Date" := InvPostingBuffer[1]."FA Posting Date";
//                   GenJnlLine."Depreciation Book Code" := InvPostingBuffer[1]."Depreciation Book Code";
//                   GenJnlLine."Depr. until FA Posting Date" := InvPostingBuffer[1]."Depr. until FA Posting Date";
//                   GenJnlLine."Duplicate in Depreciation Book" := InvPostingBuffer[1]."Duplicate in Depreciation Book";
//                   GenJnlLine."Use Duplication List" := InvPostingBuffer[1]."Use Duplication List";
//                 END;
//                 GenJnlLine."IC Partner Code" := "Sell-to IC Partner Code";
//                 GLEntryNo := RunGenJnlPostLine(GenJnlLine);
//                 GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
//                 GenJnlLine.VALIDATE("FA Posting Type",GenJnlLine."FA Posting Type"::" ");

//                 IF (InvPostingBuffer[1]."Job No." <> '') AND (InvPostingBuffer[1].Type = InvPostingBuffer[1].Type::"G/L Account") THEN
//                   JobPostLine.SetGLEntryNoOnJobLedgerEntry(InvPostingBuffer[1],"Posting Date",GenJnlLineDocNo,GLEntryNo);

//               UNTIL InvPostingBuffer[1].NEXT(-1) = 0;

//             InvPostingBuffer[1].DELETEALL;

//             // Post customer entry
//             Window.UPDATE(4,1);
//             PostCustomerEntry(
//               SalesHeader,TotalSalesLine,TotalSalesLineLCY,
//               GenJnlLineDocType,GenJnlLineDocNo,GenJnlLineExtDocNo,SrcCode);

//             UpdateSalesHeader(CustLedgEntry);

//             // Balancing account
//             IF "Bal. Account No." <> '' THEN BEGIN
//               Window.UPDATE(5,1);
//               IF NOT IsOnlinePayment(SalesHeader) THEN
//                 PostBalanceEntry(
//                   0,SalesHeader,TotalSalesLine,TotalSalesLineLCY,
//                   GenJnlLineDocType,GenJnlLineDocNo,GenJnlLineExtDocNo,SrcCode);
//             END;
//           END;

//           IF ICGenJnlLineNo > 0 THEN
//             PostICGenJnl;

//           IF Ship THEN BEGIN
//             "Last Shipping No." := "Shipping No.";
//             "Shipping No." := '';
//           END;
//           IF Invoice THEN BEGIN
//             "Last Posting No." := "Posting No.";
//             "Posting No." := '';
//           END;
//           IF Receive THEN BEGIN
//             "Last Return Receipt No." := "Return Receipt No.";
//             "Return Receipt No." := '';
//           END;

//           IF ("Document Type" IN ["Document Type"::Order,"Document Type"::"Return Order"]) AND
//              (NOT EverythingInvoiced)
//           THEN BEGIN
//             MODIFY;
//             // Insert T336 records
//             InsertTrackingSpecification;

//             IF SalesLine.FINDSET THEN
//               REPEAT
//                 IF SalesLine.Quantity <> 0 THEN BEGIN
//                   IF Ship THEN BEGIN
//                     SalesLine."Quantity Shipped" :=
//                       SalesLine."Quantity Shipped" +
//                       SalesLine."Qty. to Ship";
//                     SalesLine."Qty. Shipped (Base)" :=
//                       SalesLine."Qty. Shipped (Base)" +
//                       SalesLine."Qty. to Ship (Base)";
//                   END;
//                   IF Receive THEN BEGIN
//                     SalesLine."Return Qty. Received" :=
//                       SalesLine."Return Qty. Received" + SalesLine."Return Qty. to Receive";
//                     SalesLine."Return Qty. Received (Base)" :=
//                       SalesLine."Return Qty. Received (Base)" +
//                       SalesLine."Return Qty. to Receive (Base)";
//                   END;
//                   IF Invoice THEN BEGIN
//                     IF "Document Type" = "Document Type"::Order THEN BEGIN
//                       IF ABS(SalesLine."Quantity Invoiced" + SalesLine."Qty. to Invoice") >
//                          ABS(SalesLine."Quantity Shipped")
//                       THEN BEGIN
//                         SalesLine.VALIDATE("Qty. to Invoice",
//                           SalesLine."Quantity Shipped" - SalesLine."Quantity Invoiced");
//                         SalesLine."Qty. to Invoice (Base)" :=
//                           SalesLine."Qty. Shipped (Base)" - SalesLine."Qty. Invoiced (Base)";
//                       END;
//                     END ELSE
//                       IF ABS(SalesLine."Quantity Invoiced" + SalesLine."Qty. to Invoice") >
//                          ABS(SalesLine."Return Qty. Received")
//                       THEN BEGIN
//                         SalesLine.VALIDATE("Qty. to Invoice",
//                           SalesLine."Return Qty. Received" - SalesLine."Quantity Invoiced");
//                         SalesLine."Qty. to Invoice (Base)" :=
//                           SalesLine."Return Qty. Received (Base)" - SalesLine."Qty. Invoiced (Base)";
//                       END;

//                     SalesLine."Quantity Invoiced" := SalesLine."Quantity Invoiced" + SalesLine."Qty. to Invoice";
//                     SalesLine."Qty. Invoiced (Base)" := SalesLine."Qty. Invoiced (Base)" + SalesLine."Qty. to Invoice (Base)";
//                     IF SalesLine."Qty. to Invoice" <> 0 THEN BEGIN
//                       SalesLine."Prepmt Amt Deducted" :=
//                         SalesLine."Prepmt Amt Deducted" + SalesLine."Prepmt Amt to Deduct";
//                       SalesLine."Prepmt VAT Diff. Deducted" :=
//                         SalesLine."Prepmt VAT Diff. Deducted" + SalesLine."Prepmt VAT Diff. to Deduct";
//                       DecrementPrepmtAmtInvLCY(
//                         SalesLine,SalesLine."Prepmt. Amount Inv. (LCY)",SalesLine."Prepmt. VAT Amount Inv. (LCY)");
//                       SalesLine."Prepmt Amt to Deduct" :=
//                         SalesLine."Prepmt. Amt. Inv." - SalesLine."Prepmt Amt Deducted";
//                       SalesLine."Prepmt VAT Diff. to Deduct" := 0;
//                     END;
//                   END;

//                   UpdateBlanketOrderLine(SalesLine,Ship,Receive,Invoice);
//                   SalesLine.InitOutstanding;
//                   CheckATOLink(SalesLine);
//                   IF WhseHandlingRequired OR (SalesSetup."Default Quantity to Ship" = SalesSetup."Default Quantity to Ship"::Blank)
//                   THEN BEGIN
//                     IF "Document Type" = "Document Type"::"Return Order" THEN BEGIN
//                       SalesLine."Return Qty. to Receive" := 0;
//                       SalesLine."Return Qty. to Receive (Base)" := 0;
//                     END ELSE BEGIN
//                       SalesLine."Qty. to Ship" := 0;
//                       SalesLine."Qty. to Ship (Base)" := 0;
//                     END;
//                     SalesLine.InitQtyToInvoice;
//                   END ELSE BEGIN
//                     IF "Document Type" = "Document Type"::"Return Order" THEN
//                       SalesLine.InitQtyToReceive
//                     ELSE
//                       SalesLine.InitQtyToShip2;
//                   END;

//                   IF (SalesLine."Purch. Order Line No." <> 0) AND
//                      (SalesLine.Quantity = SalesLine."Quantity Invoiced")
//                   THEN
//                     UpdateAssocLines(SalesLine);
//                   SalesLine.SetDefaultQuantity;
//                   SalesLine.MODIFY;
//                 END;
//               UNTIL SalesLine.NEXT = 0;

//             UpdateAssocOrder;

//             IF WhseReceive THEN BEGIN
//               WhsePostRcpt.PostUpdateWhseDocuments(WhseRcptHeader);
//               TempWhseRcptHeader.DELETE;
//             END;
//             IF WhseShip THEN BEGIN
//               WhsePostShpt.PostUpdateWhseDocuments(WhseShptHeader);
//               TempWhseShptHeader.DELETE;
//             END;

//             WhseSalesRelease.Release(SalesHeader);
//             UpdateItemChargeAssgnt;
//           END ELSE BEGIN
//             CASE "Document Type" OF
//               "Document Type"::Invoice:
//                 BEGIN
//                   SalesLine.SETFILTER("Shipment No.",'<>%1','');
//                   IF SalesLine.FINDSET THEN
//                     REPEAT
//                       IF SalesLine.Type <> SalesLine.Type::" " THEN BEGIN
//                         SalesShptLine.GET(SalesLine."Shipment No.",SalesLine."Shipment Line No.");
//                         TempSalesLine.GET(
//                           TempSalesLine."Document Type"::Order,
//                           SalesShptLine."Order No.",SalesShptLine."Order Line No.");
//                         IF SalesLine.Type = SalesLine.Type::"Charge (Item)" THEN
//                           UpdateSalesOrderChargeAssgnt(SalesLine,TempSalesLine);
//                         TempSalesLine."Quantity Invoiced" :=
//                           TempSalesLine."Quantity Invoiced" + SalesLine."Qty. to Invoice";
//                         TempSalesLine."Qty. Invoiced (Base)" :=
//                           TempSalesLine."Qty. Invoiced (Base)" + SalesLine."Qty. to Invoice (Base)";
//                         IF ABS(TempSalesLine."Quantity Invoiced") > ABS(TempSalesLine."Quantity Shipped") THEN
//                           ERROR(
//                             Text014,
//                             TempSalesLine."Document No.");
//                         TempSalesLine.InitQtyToInvoice;
//                         IF TempSalesLine."Prepayment %" <> 0 THEN BEGIN
//                           TempSalesLine."Prepmt Amt Deducted" := TempSalesLine."Prepmt Amt Deducted" + SalesLine."Prepmt Amt to Deduct";
//                           TempSalesLine."Prepmt VAT Diff. Deducted" :=
//                             TempSalesLine."Prepmt VAT Diff. Deducted" + SalesLine."Prepmt VAT Diff. to Deduct";
//                           DecrementPrepmtAmtInvLCY(
//                             SalesLine,TempSalesLine."Prepmt. Amount Inv. (LCY)",TempSalesLine."Prepmt. VAT Amount Inv. (LCY)");
//                           TempSalesLine."Prepmt Amt to Deduct" :=
//                             TempSalesLine."Prepmt. Amt. Inv." - TempSalesLine."Prepmt Amt Deducted";
//                           TempSalesLine."Prepmt VAT Diff. to Deduct" := 0;
//                         END;
//                         TempSalesLine.InitOutstanding;
//                         IF (TempSalesLine."Purch. Order Line No." <> 0) AND
//                            (TempSalesLine.Quantity = TempSalesLine."Quantity Invoiced")
//                         THEN
//                           UpdateAssocLines(TempSalesLine);
//                         TempSalesLine.MODIFY;
//                       END;
//                     UNTIL SalesLine.NEXT = 0;
//                   InsertTrackingSpecification;

//                   SalesLine.SETRANGE("Shipment No.");
//                 END;
//               "Document Type"::"Credit Memo":
//                 BEGIN
//                   SalesLine.SETFILTER("Return Receipt No.",'<>%1','');
//                   IF SalesLine.FINDSET THEN
//                     REPEAT
//                       IF SalesLine.Type <> SalesLine.Type::" " THEN BEGIN
//                         ReturnRcptLine.GET(SalesLine."Return Receipt No.",SalesLine."Return Receipt Line No.");
//                         TempSalesLine.GET(
//                           TempSalesLine."Document Type"::"Return Order",
//                           ReturnRcptLine."Return Order No.",ReturnRcptLine."Return Order Line No.");
//                         IF SalesLine.Type = SalesLine.Type::"Charge (Item)" THEN
//                           UpdateSalesOrderChargeAssgnt(SalesLine,TempSalesLine);
//                         TempSalesLine."Quantity Invoiced" :=
//                           TempSalesLine."Quantity Invoiced" + SalesLine."Qty. to Invoice";
//                         TempSalesLine."Qty. Invoiced (Base)" :=
//                           TempSalesLine."Qty. Invoiced (Base)" + SalesLine."Qty. to Invoice (Base)";
//                         IF ABS(TempSalesLine."Quantity Invoiced") > ABS(TempSalesLine."Return Qty. Received") THEN
//                           ERROR(
//                             Text036,
//                             TempSalesLine."Document No.");
//                         TempSalesLine.InitQtyToInvoice;
//                         TempSalesLine.InitOutstanding;
//                         TempSalesLine.MODIFY;
//                       END;
//                     UNTIL SalesLine.NEXT = 0;
//                   InsertTrackingSpecification;

//                   SalesLine.SETRANGE("Return Receipt No.");
//                 END;
//               ELSE BEGIN
//                 UpdateAssocOrder;
//                 IF DropShipOrder THEN
//                   InsertTrackingSpecification;
//                 IF SalesLine.FINDSET THEN
//                   REPEAT
//                     IF SalesLine."Purch. Order Line No." <> 0 THEN
//                       UpdateAssocLines(SalesLine);
//                     IF SalesLine."Prepayment %" <> 0 THEN
//                       DecrementPrepmtAmtInvLCY(
//                         SalesLine,SalesLine."Prepmt. Amount Inv. (LCY)",SalesLine."Prepmt. VAT Amount Inv. (LCY)");
//                   UNTIL SalesLine.NEXT = 0;
//               END;
//             END;

//             SalesLine.SETFILTER("Qty. to Assemble to Order",'<>0');
//             IF SalesLine.FINDSET THEN
//               REPEAT
//                 FinalizePostATO(SalesLine);
//               UNTIL SalesLine.NEXT = 0;
//             SalesLine.SETRANGE("Qty. to Assemble to Order");

//             SalesLine.SETFILTER("Blanket Order Line No.",'<>0');
//             IF SalesLine.FINDSET THEN
//               REPEAT
//                 UpdateBlanketOrderLine(SalesLine,Ship,Receive,Invoice);
//               UNTIL SalesLine.NEXT = 0;
//             SalesLine.SETRANGE("Blanket Order Line No.");

//             IF WhseReceive THEN BEGIN
//               WhsePostRcpt.PostUpdateWhseDocuments(WhseRcptHeader);
//               TempWhseRcptHeader.DELETE;
//             END;
//             IF WhseShip THEN BEGIN
//               WhsePostShpt.PostUpdateWhseDocuments(WhseShptHeader);
//               TempWhseShptHeader.DELETE;
//             END;

//             ApprovalMgt.DeleteApprovalEntry(DATABASE::"Sales Header","Document Type","No.");

//             IF HASLINKS THEN
//               DELETELINKS;
//             DELETE;
//             ReserveSalesLine.DeleteInvoiceSpecFromHeader(SalesHeader);
//             DeleteATOLinks(SalesHeader);
//             IF SalesLine.FINDFIRST THEN
//               REPEAT
//                 IF SalesLine.HASLINKS THEN
//                   SalesLine.DELETELINKS;
//               UNTIL SalesLine.NEXT = 0;
//             SalesLine.DELETEALL;
//             DeleteItemChargeAssgnt;
//             SalesCommentLine.SETRANGE("Document Type","Document Type");
//             SalesCommentLine.SETRANGE("No.","No.");
//             IF NOT SalesCommentLine.ISEMPTY THEN
//               SalesCommentLine.DELETEALL;
//             WhseRqst.SETCURRENTKEY("Source Type","Source Subtype","Source No.");
//             WhseRqst.SETRANGE("Source Type",DATABASE::"Sales Line");
//             WhseRqst.SETRANGE("Source Subtype","Document Type");
//             WhseRqst.SETRANGE("Source No.","No.");
//             IF NOT WhseRqst.ISEMPTY THEN
//               WhseRqst.DELETEALL;
//           END;

//           InsertValueEntryRelation;
//           IF NOT InvtPickPutaway THEN
//             COMMIT;
//           CLEAR(WhsePostRcpt);
//           CLEAR(WhsePostShpt);
//           CLEAR(GenJnlPostLine);
//           CLEAR(ResJnlPostLine);
//           CLEAR(JobPostLine);
//           CLEAR(ItemJnlPostLine);
//           CLEAR(WhseJnlPostLine);
//           CLEAR(InvtAdjmt);
//           Window.CLOSE;
//           IF Invoice AND ("Bill-to IC Partner Code" <> '') THEN
//             IF "Document Type" IN ["Document Type"::Order,"Document Type"::Invoice] THEN
//               ICInOutBoxMgt.CreateOutboxSalesInvTrans(SalesInvHeader)
//             ELSE
//               ICInOutBoxMgt.CreateOutboxSalesCrMemoTrans(SalesCrMemoHeader);
//         END;

//         TransactionLogEntryNo := CaptureOrRefundCreditCardPmnt(CustLedgEntry);

//         Rec := SalesHeader;
//         SynchBOMSerialNo(ServiceItemTmp2,ServiceItemCmpTmp2);
//         IF NOT InvtPickPutaway THEN BEGIN
//           COMMIT;
//           UpdateAnalysisView.UpdateAll(0,TRUE);
//           UpdateItemAnalysisView.UpdateAll(0,TRUE);
//         END;

//         // Balancing account - online payment
//         IF ("Bal. Account No." <> '') AND IsOnlinePayment(SalesHeader) AND Invoice THEN
//           PostBalanceEntry(
//             TransactionLogEntryNo,SalesHeader,TotalSalesLine,TotalSalesLineLCY,
//             GenJnlLineDocType,GenJnlLineDocNo,GenJnlLineExtDocNo,SrcCode);
//     end;

//     var
//         Text001: Label 'There is nothing to post.';
//         Text002: Label 'Posting lines              #2######\';
//         Text003: Label 'Posting sales and VAT      #3######\';
//         Text004: Label 'Posting to customers       #4######\';
//         Text005: Label 'Posting to bal. account    #5######';
//         Text006: Label 'Posting lines              #2######';
//         Text007: Label '%1 %2 -> Invoice %3';
//         Text008: Label '%1 %2 -> Credit Memo %3';
//         Text009: Label 'You cannot ship sales order line %1. ';
//         Text010: Label 'The line is marked as a drop shipment and is not yet associated with a purchase order.';
//         Text011: Label 'must have the same sign as the shipment';
//         Text013: Label 'The shipment lines have been deleted.';
//         Text014: Label 'You cannot invoice more than you have shipped for order %1.';
//         Text016: Label 'VAT Amount';
//         Text017: Label '%1% VAT';
//         Text018: Label 'in the associated blanket order must not be greater than %1';
//         Text019: Label 'in the associated blanket order must not be reduced.';
//         Text020: Label 'Please enter "Yes" in %1 and/or %2 and/or %3.';
//         Text021: Label 'Warehouse handling is required for %1 = %2, %3 = %4, %5 = %6.';
//         Text024: Label 'must have the same sign as the return receipt';
//         Text025: Label 'Line %1 of the return receipt %2, which you are attempting to invoice, has already been invoiced.';
//         Text026: Label 'Line %1 of the shipment %2, which you are attempting to invoice, has already been invoiced.';
//         Text027: Label 'The quantity you are attempting to invoice is greater than the quantity in shipment %1.';
//         Text028: Label 'The combination of dimensions used in %1 %2 is blocked. %3';
//         Text029: Label 'The combination of dimensions used in %1 %2, line no. %3 is blocked. %4';
//         Text030: Label 'The dimensions used in %1 %2 are invalid. %3';
//         Text031: Label 'The dimensions used in %1 %2, line no. %3 are invalid. %4';
//         Text032: Label 'You cannot assign more than %1 units in %2 = %3, %4 = %5,%6 = %7.';
//         Text033: Label 'You must assign all item charges, if you invoice everything.';
//         Item: Record "27";
//         CurrExchRate: Record "330";
//         SalesSetup: Record "311";
//         GLSetup: Record "98";
//         InvtSetup: Record "313";
//         GLEntry: Record "17";
//         SalesHeader: Record "36";
//         SalesLine: Record "37";
//         TempSalesLine: Record "37";
//         SalesLineACY: Record "37";
//         TotalSalesLine: Record "37";
//         TotalSalesLineLCY: Record "37";
//         TempPrepaymentSalesLine: Record "37" temporary;
//         CombinedSalesLineTemp: Record "37" temporary;
//         SalesShptHeader: Record "110";
//         SalesShptLine: Record "111";
//         SalesInvHeader: Record "112";
//         SalesInvLine: Record "113";
//         SalesCrMemoHeader: Record "114";
//         SalesCrMemoLine: Record "115";
//         ReturnRcptHeader: Record "6660";
//         ReturnRcptLine: Record "6661";
//         PurchOrderHeader: Record "38";
//         PurchOrderLine: Record "39";
//         PurchRcptHeader: Record "120";
//         PurchRcptLine: Record "121";
//         ItemChargeAssgntSales: Record "5809";
//         TempItemChargeAssgntSales: Record "5809" temporary;
//         GenJnlLine: Record "81";
//         ItemJnlLine: Record "83";
//         ResJnlLine: Record "207";
//         CustPostingGr: Record "92";
//         SourceCodeSetup: Record "242";
//         SourceCode: Record "230";
//         SalesCommentLine: Record "44";
//         SalesCommentLine2: Record "44";
//         GenPostingSetup: Record "252";
//         Currency: Record "4";
//         InvPostingBuffer: array [2] of Record "49" temporary;
//         DropShipPostBuffer: Record "223" temporary;
//         GLAcc: Record "15";
//         ApprovalEntry: Record "454";
//         TempApprovalEntry: Record "454" temporary;
//         FA: Record "5600";
//         DeprBook: Record "5611";
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
//         JobTaskSalesLine: Record "37";
//         TempICGenJnlLine: Record "81" temporary;
//         TempPrepmtDeductLCYSalesLine: Record "37" temporary;
//         ServiceItemTmp1: Record "5940" temporary;
//         ServiceItemTmp2: Record "5940" temporary;
//         ServiceItemCmpTmp1: Record "5941" temporary;
//         ServiceItemCmpTmp2: Record "5941" temporary;
//         TempSKU: Record "5700" temporary;
//         NoSeriesMgt: Codeunit "396";
//         GenJnlCheckLine: Codeunit "11";
//         GenJnlPostLine: Codeunit "12";
//         ResJnlPostLine: Codeunit "212";
//         ItemJnlPostLine: Codeunit "22";
//         InvtAdjmt: Codeunit "5895";
//         ReserveSalesLine: Codeunit "99000832";
//         SalesCalcDisc: Codeunit "60";
//         DimMgt: Codeunit "408";
//         ApprovalMgt: Codeunit "439";
//         WhseSalesRelease: Codeunit "5771";
//         ItemTrackingMgt: Codeunit "6500";
//         WMSMgmt: Codeunit "7302";
//         WhseJnlPostLine: Codeunit "7301";
//         WhsePostRcpt: Codeunit "5760";
//         WhsePostShpt: Codeunit "5763";
//         PurchPost: Codeunit "90";
//         CostCalcMgt: Codeunit "5836";
//         JobPostLine: Codeunit "1001";
//         ServItemMgt: Codeunit "5920";
//         AsmPost: Codeunit "900";
//         Window: Dialog;
//         PostingDate: Date;
//         UseDate: Date;
//         GenJnlLineDocNo: Code[20];
//         GenJnlLineExtDocNo: Code[35];
//         SrcCode: Code[10];
//         GenJnlLineDocType: Integer;
//         ItemLedgShptEntryNo: Integer;
//         LineCount: Integer;
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
//         ModifyHeader: Boolean;
//         DropShipOrder: Boolean;
//         PostingDateExists: Boolean;
//         ReplacePostingDate: Boolean;
//         ReplaceDocumentDate: Boolean;
//         TempInvoice: Boolean;
//         TempShpt: Boolean;
//         TempReturn: Boolean;
//         Text034: Label 'You cannot assign item charges to the %1 %2 = %3,%4 = %5, %6 = %7, because it has been invoiced.';
//         Text036: Label 'You cannot invoice more than you have received for return order %1.';
//         Text037: Label 'The return receipt lines have been deleted.';
//         Text038: Label 'The quantity you are attempting to invoice is greater than the quantity in return receipt %1.';
//         ItemChargeAssgntOnly: Boolean;
//         ItemJnlRollRndg: Boolean;
//         Text040: Label 'Related item ledger entries cannot be found.';
//         Text043: Label 'Item Tracking is signed wrongly.';
//         Text044: Label 'Item Tracking does not match.';
//         WhseShip: Boolean;
//         WhseReceive: Boolean;
//         InvtPickPutaway: Boolean;
//         Text045: Label 'is not within your range of allowed posting dates.';
//         Text046: Label 'The %1 does not match the quantity defined in item tracking.';
//         Text047: Label 'cannot be more than %1.';
//         Text048: Label 'must be at least %1.';
//         JobContractLine: Boolean;
//         GLSetupRead: Boolean;
//         ICGenJnlLineNo: Integer;
//         ItemTrkgAlreadyOverruled: Boolean;
//         Text050: Label 'The total %1 cannot be more than %2.';
//         Text051: Label 'The total %1 must be at least %2.';
//         TotalChargeAmt: Decimal;
//         TotalChargeAmtLCY: Decimal;
//         TotalChargeAmt2: Decimal;
//         TotalChargeAmtLCY2: Decimal;
//         Text052: Label 'You must assign item charge %1 if you want to invoice it.';
//         Text053: Label 'You can not invoice item charge %1 because there is no item ledger entry to assign it to.';
//         SalesLinesProcessed: Boolean;
//         Text055: Label '#1#################################\\Checking Assembly #2###########';
//         Text056: Label '#1#################################\\Posting Assembly #2###########';
//         Text057: Label '#1#################################\\Finalizing Assembly #2###########';
//         Text059: Label '%1 %2 %3 %4', Comment='%1 = SalesLine."Document Type". %2 = SalesLine."Document No.". %3 = SalesLine.FIELDCAPTION("Line No."). %4 = SalesLine."Line No.". This is used in a progress window.';
//         Text060: Label '%1 %2', Comment='%1 = "Document Type". %2 = AsmHeader."No.". Used in a progress window.';
//         Text061Err: Label 'The order line that the item charge was originally assigned to has been fully posted. You must reassign the item charge to the posted receipt or shipment.';
//         Text062Qst: Label 'One or more reservation entries exist for the item with %1 = %2, %3 = %4, %5 = %6 which may be disrupted if you post this negative adjustment. Do you want to continue?', Comment='One or more reservation entries exist for the item with No. = 1000, Location Code = SILVER, Variant Code = NEW which may be disrupted if you post this negative adjustment. Do you want to continue?';

//     procedure SetPostingDate(NewReplacePostingDate: Boolean;NewReplaceDocumentDate: Boolean;NewPostingDate: Date)
//     begin
//         PostingDateExists := TRUE;
//         ReplacePostingDate := NewReplacePostingDate;
//         ReplaceDocumentDate := NewReplaceDocumentDate;
//         PostingDate := NewPostingDate;
//     end;

//     local procedure PostItemJnlLine(SalesLine: Record "37";QtyToBeShipped: Decimal;QtyToBeShippedBase: Decimal;QtyToBeInvoiced: Decimal;QtyToBeInvoicedBase: Decimal;ItemLedgShptEntryNo: Integer;ItemChargeNo: Code[20];TrackingSpecification: Record "336";IsATO: Boolean): Integer
//     var
//         ItemChargeSalesLine: Record "37";
//         TempWhseJnlLine: Record "7311" temporary;
//         TempWhseJnlLine2: Record "7311" temporary;
//         OriginalItemJnlLine: Record "83";
//         TempWhseTrackingSpecification: Record "336" temporary;
//         PostWhseJnlLine: Boolean;
//         CheckApplFromItemEntry: Boolean;
//     begin
//         IF NOT ItemJnlRollRndg THEN BEGIN
//           RemAmt := 0;
//           RemDiscAmt := 0;
//         END;
//         WITH SalesLine DO BEGIN
//           ItemJnlLine.INIT;
//           ItemJnlLine."Posting Date" := SalesHeader."Posting Date";
//           ItemJnlLine."Document Date" := SalesHeader."Document Date";
//           ItemJnlLine."Source Posting Group" := SalesHeader."Customer Posting Group";
//           ItemJnlLine."Salespers./Purch. Code" := SalesHeader."Salesperson Code";
//           ItemJnlLine."Country/Region Code" := GetCountryCode(SalesLine,SalesHeader);
//           ItemJnlLine."Reason Code" := SalesHeader."Reason Code";
//           ItemJnlLine."Item No." := "No.";
//           ItemJnlLine.Description := Description;
//           ItemJnlLine."Shortcut Dimension 1 Code" := "Shortcut Dimension 1 Code";
//           ItemJnlLine."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
//           ItemJnlLine."Dimension Set ID" := "Dimension Set ID";
//           ItemJnlLine."Location Code" := "Location Code";
//           ItemJnlLine."Bin Code" := "Bin Code";
//           ItemJnlLine."Variant Code" := "Variant Code";
//           ItemJnlLine."Inventory Posting Group" := "Posting Group";
//           ItemJnlLine."Gen. Bus. Posting Group" := "Gen. Bus. Posting Group";
//           ItemJnlLine."Gen. Prod. Posting Group" := "Gen. Prod. Posting Group";
//           IF IsATO THEN
//             ItemJnlLine."Applies-to Entry" := FindOpenATOEntry('','')
//           ELSE
//             ItemJnlLine."Applies-to Entry" := "Appl.-to Item Entry";
//           ItemJnlLine."Transaction Type" := "Transaction Type";
//           ItemJnlLine."Transport Method" := "Transport Method";
//           ItemJnlLine."Entry/Exit Point" := "Exit Point";
//           ItemJnlLine.Area := Area;
//           ItemJnlLine."Transaction Specification" := "Transaction Specification";
//           ItemJnlLine."Drop Shipment" := "Drop Shipment";
//           ItemJnlLine."Assemble to Order" := IsATO;
//           ItemJnlLine."Entry Type" := ItemJnlLine."Entry Type"::Sale;
//           ItemJnlLine."Unit of Measure Code" := "Unit of Measure Code";
//           ItemJnlLine."Qty. per Unit of Measure" := "Qty. per Unit of Measure";
//           ItemJnlLine."Derived from Blanket Order" := "Blanket Order No." <> '';
//           ItemJnlLine."Cross-Reference No." := "Cross-Reference No.";
//           ItemJnlLine."Originally Ordered No." := "Originally Ordered No.";
//           ItemJnlLine."Originally Ordered Var. Code" := "Originally Ordered Var. Code";
//           ItemJnlLine."Out-of-Stock Substitution" := "Out-of-Stock Substitution";
//           ItemJnlLine."Item Category Code" := "Item Category Code";
//           ItemJnlLine.Nonstock := Nonstock;
//           ItemJnlLine."Purchasing Code" := "Purchasing Code";
//           ItemJnlLine."Product Group Code" := "Product Group Code";
//           ItemJnlLine."Return Reason Code" := "Return Reason Code";

//           ItemJnlLine."Planned Delivery Date" := "Planned Delivery Date";
//           ItemJnlLine."Order Date" := SalesHeader."Order Date";

//           ItemJnlLine."Serial No." := TrackingSpecification."Serial No.";
//           ItemJnlLine."Lot No." := TrackingSpecification."Lot No.";

//           IF QtyToBeShipped = 0 THEN BEGIN
//             IF "Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"] THEN
//               ItemJnlLine."Document Type" := ItemJnlLine."Document Type"::"Sales Credit Memo"
//             ELSE
//               ItemJnlLine."Document Type" := ItemJnlLine."Document Type"::"Sales Invoice";
//             ItemJnlLine."Document No." := GenJnlLineDocNo;
//             ItemJnlLine."External Document No." := GenJnlLineExtDocNo;
//             ItemJnlLine."Posting No. Series" := SalesHeader."Posting No. Series";
//             IF QtyToBeInvoiced <> 0 THEN
//               ItemJnlLine."Invoice No." := GenJnlLineDocNo;
//           END ELSE BEGIN
//             IF "Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"] THEN BEGIN
//               ItemJnlLine."Document Type" := ItemJnlLine."Document Type"::"Sales Return Receipt";
//               ItemJnlLine."Document No." := ReturnRcptHeader."No.";
//               ItemJnlLine."External Document No." := ReturnRcptHeader."External Document No.";
//               ItemJnlLine."Posting No. Series" := ReturnRcptHeader."No. Series";
//             END ELSE BEGIN
//               ItemJnlLine."Document Type" := ItemJnlLine."Document Type"::"Sales Shipment";
//               ItemJnlLine."Document No." := SalesShptHeader."No.";
//               ItemJnlLine."External Document No." := SalesShptHeader."External Document No.";
//               ItemJnlLine."Posting No. Series" := SalesShptHeader."No. Series";
//             END;
//             IF QtyToBeInvoiced <> 0 THEN BEGIN
//               ItemJnlLine."Invoice No." := GenJnlLineDocNo;
//               ItemJnlLine."External Document No." := GenJnlLineExtDocNo;
//               IF ItemJnlLine."Document No." = '' THEN BEGIN
//                 IF "Document Type" = "Document Type"::"Credit Memo" THEN
//                   ItemJnlLine."Document Type" := ItemJnlLine."Document Type"::"Sales Credit Memo"
//                 ELSE
//                   ItemJnlLine."Document Type" := ItemJnlLine."Document Type"::"Sales Invoice";
//                 ItemJnlLine."Document No." := GenJnlLineDocNo;
//               END;
//               ItemJnlLine."Posting No. Series" := SalesHeader."Posting No. Series";
//             END;
//           END;

//           ItemJnlLine."Document Line No." := "Line No.";
//           ItemJnlLine.Quantity := -QtyToBeShipped;
//           ItemJnlLine."Quantity (Base)" := -QtyToBeShippedBase;
//           ItemJnlLine."Invoiced Quantity" := -QtyToBeInvoiced;
//           ItemJnlLine."Invoiced Qty. (Base)" := -QtyToBeInvoicedBase;
//           ItemJnlLine."Unit Cost" := "Unit Cost (LCY)";
//           ItemJnlLine."Source Currency Code" := SalesHeader."Currency Code";
//           ItemJnlLine."Unit Cost (ACY)" := "Unit Cost";
//           ItemJnlLine."Value Entry Type" := ItemJnlLine."Value Entry Type"::"Direct Cost";

//           IF ItemChargeNo <> '' THEN BEGIN
//             ItemJnlLine."Item Charge No." := ItemChargeNo;
//             "Qty. to Invoice" := QtyToBeInvoiced;
//           END ELSE
//             ItemJnlLine."Applies-from Entry" := "Appl.-from Item Entry";

//           IF QtyToBeInvoiced <> 0 THEN BEGIN
//             ItemJnlLine.Amount := -(Amount * (QtyToBeInvoiced / "Qty. to Invoice") - RemAmt);
//             IF SalesHeader."Prices Including VAT" THEN
//               ItemJnlLine."Discount Amount" :=
//                 -(("Line Discount Amount" + "Inv. Discount Amount") / (1 + "VAT %" / 100) *
//                   (QtyToBeInvoiced / "Qty. to Invoice") - RemDiscAmt)
//             ELSE
//               ItemJnlLine."Discount Amount" :=
//                 -(("Line Discount Amount" + "Inv. Discount Amount") * (QtyToBeInvoiced / "Qty. to Invoice") - RemDiscAmt);
//             RemAmt := ItemJnlLine.Amount - ROUND(ItemJnlLine.Amount);
//             RemDiscAmt := ItemJnlLine."Discount Amount" - ROUND(ItemJnlLine."Discount Amount");
//             ItemJnlLine.Amount := ROUND(ItemJnlLine.Amount);
//             ItemJnlLine."Discount Amount" := ROUND(ItemJnlLine."Discount Amount");
//           END ELSE BEGIN
//             IF SalesHeader."Prices Including VAT" THEN
//               ItemJnlLine.Amount :=
//                 -((QtyToBeShipped * "Unit Price" * (1 - "Line Discount %" / 100) / (1 + "VAT %" / 100)) - RemAmt)
//             ELSE
//               ItemJnlLine.Amount :=
//                 -((QtyToBeShipped * "Unit Price" * (1 - "Line Discount %" / 100)) - RemAmt);
//             RemAmt := ItemJnlLine.Amount - ROUND(ItemJnlLine.Amount);
//             IF SalesHeader."Currency Code" <> '' THEN
//               ItemJnlLine.Amount :=
//                 ROUND(
//                   CurrExchRate.ExchangeAmtFCYToLCY(
//                     SalesHeader."Posting Date",SalesHeader."Currency Code",
//                     ItemJnlLine.Amount,SalesHeader."Currency Factor"))
//             ELSE
//               ItemJnlLine.Amount := ROUND(ItemJnlLine.Amount);
//           END;

//           ItemJnlLine."Source Type" := ItemJnlLine."Source Type"::Customer;
//           ItemJnlLine."Source No." := "Sell-to Customer No.";
//           ItemJnlLine."Invoice-to Source No." := "Bill-to Customer No.";
//           ItemJnlLine."Source Code" := SrcCode;
//           ItemJnlLine."Item Shpt. Entry No." := ItemLedgShptEntryNo;

//           IF NOT JobContractLine THEN BEGIN
//             IF SalesSetup."Exact Cost Reversing Mandatory" AND (Type = Type::Item) THEN
//               IF "Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"] THEN
//                 CheckApplFromItemEntry := Quantity > 0
//               ELSE
//                 CheckApplFromItemEntry := Quantity < 0;

//             IF ("Location Code" <> '') AND (Type = Type::Item) AND (ItemJnlLine.Quantity <> 0) THEN
//               IF ShouldPostWhseJnlLine(SalesLine) THEN BEGIN
//                 CreateWhseJnlLine(ItemJnlLine,SalesLine,TempWhseJnlLine);
//                 PostWhseJnlLine := TRUE;
//               END;

//             IF QtyToBeShippedBase <> 0 THEN BEGIN
//               IF "Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"] THEN
//                 ReserveSalesLine.TransferSalesLineToItemJnlLine(SalesLine,ItemJnlLine,QtyToBeShippedBase,CheckApplFromItemEntry,FALSE)
//               ELSE
//                 TransferReservToItemJnlLine(
//                   SalesLine,ItemJnlLine,-QtyToBeShippedBase,TempTrackingSpecification,CheckApplFromItemEntry);

//               IF CheckApplFromItemEntry THEN
//                 TESTFIELD("Appl.-from Item Entry");
//             END;

//             OriginalItemJnlLine := ItemJnlLine;
//             ItemJnlPostLine.RunWithCheck(ItemJnlLine);
//             IF ItemJnlPostLine.CollectTrackingSpecification(TempHandlingSpecification) THEN
//               IF TempHandlingSpecification.FINDSET THEN
//                 REPEAT
//                   TempTrackingSpecification := TempHandlingSpecification;
//                   TempTrackingSpecification."Source Type" := DATABASE::"Sales Line";
//                   TempTrackingSpecification."Source Subtype" := "Document Type";
//                   TempTrackingSpecification."Source ID" := "Document No.";
//                   TempTrackingSpecification."Source Batch Name" := '';
//                   TempTrackingSpecification."Source Prod. Order Line" := 0;
//                   TempTrackingSpecification."Source Ref. No." := "Line No.";
//                   IF TempTrackingSpecification.INSERT THEN;
//                   IF QtyToBeInvoiced <> 0 THEN BEGIN
//                     TempTrackingSpecificationInv := TempTrackingSpecification;
//                     IF TempTrackingSpecificationInv.INSERT THEN;
//                   END;
//                   IF PostWhseJnlLine THEN BEGIN
//                     TempWhseTrackingSpecification := TempTrackingSpecification;
//                     IF TempWhseTrackingSpecification.INSERT THEN;
//                   END;
//                 UNTIL TempHandlingSpecification.NEXT = 0;
//             IF PostWhseJnlLine THEN BEGIN
//               ItemTrackingMgt.SplitWhseJnlLine(TempWhseJnlLine,TempWhseJnlLine2,TempWhseTrackingSpecification,FALSE);
//               IF TempWhseJnlLine2.FINDSET THEN
//                 REPEAT
//                   WhseJnlPostLine.RUN(TempWhseJnlLine2);
//                 UNTIL TempWhseJnlLine2.NEXT = 0;
//               TempWhseTrackingSpecification.DELETEALL;
//             END;

//             IF (Type = Type::Item) AND SalesHeader.Invoice THEN BEGIN
//               ClearItemChargeAssgntFilter;
//               TempItemChargeAssgntSales.SETCURRENTKEY(
//                 "Applies-to Doc. Type","Applies-to Doc. No.","Applies-to Doc. Line No.");
//               TempItemChargeAssgntSales.SETRANGE("Applies-to Doc. Type","Document Type");
//               TempItemChargeAssgntSales.SETRANGE("Applies-to Doc. No.","Document No.");
//               TempItemChargeAssgntSales.SETRANGE("Applies-to Doc. Line No.","Line No.");
//               IF TempItemChargeAssgntSales.FINDSET THEN
//                 REPEAT
//                   TESTFIELD("Allow Item Charge Assignment");
//                   GetItemChargeLine(ItemChargeSalesLine);
//                   ItemChargeSalesLine.CALCFIELDS("Qty. Assigned");
//                   IF (ItemChargeSalesLine."Qty. to Invoice" <> 0) OR
//                      (ABS(ItemChargeSalesLine."Qty. Assigned") < ABS(ItemChargeSalesLine."Quantity Invoiced"))
//                   THEN BEGIN
//                     OriginalItemJnlLine."Item Shpt. Entry No." := ItemJnlLine."Item Shpt. Entry No.";
//                     PostItemChargePerOrder(OriginalItemJnlLine,ItemChargeSalesLine);
//                     TempItemChargeAssgntSales.MARK(TRUE);
//                   END;
//                 UNTIL TempItemChargeAssgntSales.NEXT = 0;
//             END;
//           END;
//         END;

//         EXIT(ItemJnlLine."Item Shpt. Entry No.");
//     end;

//     local procedure ShouldPostWhseJnlLine(SalesLine: Record "37"): Boolean
//     begin
//         WITH SalesLine DO BEGIN
//           GetLocation("Location Code");
//           IF (("Document Type" IN ["Document Type"::Invoice,"Document Type"::"Credit Memo"]) AND
//               Location."Directed Put-away and Pick") OR
//              (Location."Bin Mandatory" AND NOT (WhseShip OR WhseReceive OR InvtPickPutaway OR "Drop Shipment"))
//           THEN
//             EXIT(TRUE);
//         END;
//         EXIT(FALSE);
//     end;

//     local procedure PostItemChargePerOrder(ItemJnlLine2: Record "83";ItemChargeSalesLine: Record "37")
//     var
//         NonDistrItemJnlLine: Record "83";
//         QtyToInvoice: Decimal;
//         Factor: Decimal;
//         OriginalAmt: Decimal;
//         OriginalDiscountAmt: Decimal;
//         OriginalQty: Decimal;
//         SignFactor: Integer;
//     begin
//         WITH TempItemChargeAssgntSales DO BEGIN
//           SalesLine.TESTFIELD("Job No.",'');
//           SalesLine.TESTFIELD("Allow Item Charge Assignment",TRUE);
//           ItemJnlLine2."Document No." := GenJnlLineDocNo;
//           ItemJnlLine2."External Document No." := GenJnlLineExtDocNo;
//           ItemJnlLine2."Item Charge No." := "Item Charge No.";
//           ItemJnlLine2.Description := ItemChargeSalesLine.Description;
//           ItemJnlLine2."Unit of Measure Code" := '';
//           ItemJnlLine2."Qty. per Unit of Measure" := 1;
//           ItemJnlLine2."Applies-from Entry" := 0;
//           IF "Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"] THEN
//             QtyToInvoice :=
//               CalcQtyToInvoice(SalesLine."Return Qty. to Receive (Base)",SalesLine."Qty. to Invoice (Base)")
//           ELSE
//             QtyToInvoice :=
//               CalcQtyToInvoice(SalesLine."Qty. to Ship (Base)",SalesLine."Qty. to Invoice (Base)");
//           IF ItemJnlLine2."Invoiced Quantity" = 0 THEN BEGIN
//             ItemJnlLine2."Invoiced Quantity" := ItemJnlLine2.Quantity;
//             ItemJnlLine2."Invoiced Qty. (Base)" := ItemJnlLine2."Quantity (Base)";
//           END;
//           ItemJnlLine2."Document Line No." := ItemChargeSalesLine."Line No.";

//           ItemJnlLine2.Amount := "Amount to Assign" * ItemJnlLine2."Invoiced Qty. (Base)" / QtyToInvoice;
//           IF "Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"] THEN
//             ItemJnlLine2.Amount := -ItemJnlLine2.Amount;
//           ItemJnlLine2."Unit Cost (ACY)" :=
//             ROUND(ItemJnlLine2.Amount / ItemJnlLine2."Invoiced Qty. (Base)",
//               Currency."Unit-Amount Rounding Precision");

//           TotalChargeAmt2 := TotalChargeAmt2 + ItemJnlLine2.Amount;
//           IF SalesHeader."Currency Code" <> '' THEN BEGIN
//             ItemJnlLine2.Amount :=
//               CurrExchRate.ExchangeAmtFCYToLCY(
//                 UseDate,SalesHeader."Currency Code",TotalChargeAmt2 + TotalSalesLine.Amount,SalesHeader."Currency Factor") -
//               TotalChargeAmtLCY2 - TotalSalesLineLCY.Amount;
//           END ELSE
//             ItemJnlLine2.Amount := TotalChargeAmt2 - TotalChargeAmtLCY2;

//           ItemJnlLine2.Amount := ROUND(ItemJnlLine2.Amount);
//           TotalChargeAmtLCY2 := TotalChargeAmtLCY2 + ItemJnlLine2.Amount;
//           ItemJnlLine2."Unit Cost" := ROUND(
//               ItemJnlLine2.Amount / ItemJnlLine2."Invoiced Qty. (Base)",GLSetup."Unit-Amount Rounding Precision");
//           ItemJnlLine2."Applies-to Entry" := ItemJnlLine2."Item Shpt. Entry No.";

//           IF SalesHeader."Currency Code" <> '' THEN
//             ItemJnlLine2."Discount Amount" := ROUND(
//                 CurrExchRate.ExchangeAmtFCYToLCY(
//                   UseDate,SalesHeader."Currency Code",
//                   ItemChargeSalesLine."Inv. Discount Amount" * ItemJnlLine2."Invoiced Qty. (Base)" /
//                   ItemChargeSalesLine."Quantity (Base)" * "Qty. to Assign" / QtyToInvoice,
//                   SalesHeader."Currency Factor"),GLSetup."Amount Rounding Precision")
//           ELSE
//             ItemJnlLine2."Discount Amount" := ROUND(
//                 ItemChargeSalesLine."Inv. Discount Amount" * ItemJnlLine2."Invoiced Qty. (Base)" /
//                 ItemChargeSalesLine."Quantity (Base)" * "Qty. to Assign" / QtyToInvoice,
//                 GLSetup."Amount Rounding Precision");

//           IF "Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"] THEN
//             ItemJnlLine2."Discount Amount" := -ItemJnlLine2."Discount Amount";
//           ItemJnlLine2."Shortcut Dimension 1 Code" := ItemChargeSalesLine."Shortcut Dimension 1 Code";
//           ItemJnlLine2."Shortcut Dimension 2 Code" := ItemChargeSalesLine."Shortcut Dimension 2 Code";
//           ItemJnlLine2."Dimension Set ID" := ItemChargeSalesLine."Dimension Set ID";
//           ItemJnlLine2."Gen. Prod. Posting Group" := ItemChargeSalesLine."Gen. Prod. Posting Group";
//         END;

//         WITH TempTrackingSpecificationInv DO BEGIN
//           RESET;
//           SETRANGE("Source Type",DATABASE::"Sales Line");
//           SETRANGE("Source ID",TempItemChargeAssgntSales."Applies-to Doc. No.");
//           SETRANGE("Source Ref. No.",TempItemChargeAssgntSales."Applies-to Doc. Line No.");
//           IF ISEMPTY THEN
//             ItemJnlPostLine.RunWithCheck(ItemJnlLine2)
//           ELSE BEGIN
//             FINDSET;
//             NonDistrItemJnlLine := ItemJnlLine2;
//             OriginalAmt := NonDistrItemJnlLine.Amount;
//             OriginalDiscountAmt := NonDistrItemJnlLine."Discount Amount";
//             OriginalQty := NonDistrItemJnlLine."Quantity (Base)";
//             IF ("Quantity (Base)" / OriginalQty) > 0 THEN
//               SignFactor := 1
//             ELSE
//               SignFactor := -1;
//             REPEAT
//               Factor := "Quantity (Base)" / OriginalQty * SignFactor;
//               IF ABS("Quantity (Base)") < ABS(NonDistrItemJnlLine."Quantity (Base)") THEN BEGIN
//                 ItemJnlLine2."Quantity (Base)" := -"Quantity (Base)";
//                 ItemJnlLine2."Invoiced Qty. (Base)" := ItemJnlLine2."Quantity (Base)";
//                 ItemJnlLine2.Amount :=
//                   ROUND(OriginalAmt * Factor,GLSetup."Amount Rounding Precision");
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
//                 NonDistrItemJnlLine."Quantity (Base)" -= ItemJnlLine2."Quantity (Base)";
//                 NonDistrItemJnlLine.Amount -= ItemJnlLine2.Amount;
//                 NonDistrItemJnlLine."Discount Amount" -= ItemJnlLine2."Discount Amount";
//               END ELSE BEGIN // the last time
//                 NonDistrItemJnlLine."Quantity (Base)" := -"Quantity (Base)";
//                 NonDistrItemJnlLine."Invoiced Qty. (Base)" := -"Quantity (Base)";
//                 NonDistrItemJnlLine."Unit Cost" :=
//                   ROUND(NonDistrItemJnlLine.Amount / NonDistrItemJnlLine."Invoiced Qty. (Base)",
//                     GLSetup."Unit-Amount Rounding Precision");
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

//     local procedure PostItemChargePerShpt(var SalesLine: Record "37")
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
//         DistributeCharge: Boolean;
//     begin
//         IF NOT SalesShptLine.GET(
//              TempItemChargeAssgntSales."Applies-to Doc. No.",TempItemChargeAssgntSales."Applies-to Doc. Line No.")
//         THEN
//           ERROR(Text013);
//         SalesShptLine.TESTFIELD("Job No.",'');

//         IF SalesShptLine."Item Shpt. Entry No." <> 0 THEN
//           DistributeCharge :=
//             CostCalcMgt.SplitItemLedgerEntriesExist(
//               TempItemLedgEntry,-SalesShptLine."Quantity (Base)",SalesShptLine."Item Shpt. Entry No.")
//         ELSE BEGIN
//           DistributeCharge := TRUE;
//           IF NOT ItemTrackingMgt.CollectItemEntryRelation(TempItemLedgEntry,
//                DATABASE::"Sales Shipment Line",0,SalesShptLine."Document No.",
//                '',0,SalesShptLine."Line No.",-SalesShptLine."Quantity (Base)")
//           THEN
//             ERROR(Text040);
//         END;

//         IF DistributeCharge THEN BEGIN
//           TempItemLedgEntry.FINDSET;
//           NonDistrQuantity := SalesShptLine."Quantity (Base)";
//           NonDistrQtyToAssign := TempItemChargeAssgntSales."Qty. to Assign";
//           NonDistrAmountToAssign := TempItemChargeAssgntSales."Amount to Assign";
//           REPEAT
//             Factor := ABS(TempItemLedgEntry.Quantity) / NonDistrQuantity;
//             QtyToAssign := NonDistrQtyToAssign * Factor;
//             AmountToAssign := ROUND(NonDistrAmountToAssign * Factor,GLSetup."Amount Rounding Precision");
//             IF Factor < 1 THEN BEGIN
//               PostItemCharge(SalesLine,
//                 TempItemLedgEntry."Entry No.",ABS(TempItemLedgEntry.Quantity),
//                 AmountToAssign,QtyToAssign);
//               NonDistrQuantity := NonDistrQuantity - ABS(TempItemLedgEntry.Quantity);
//               NonDistrQtyToAssign := NonDistrQtyToAssign - QtyToAssign;
//               NonDistrAmountToAssign := NonDistrAmountToAssign - AmountToAssign;
//             END ELSE // the last time
//               PostItemCharge(SalesLine,
//                 TempItemLedgEntry."Entry No.",ABS(TempItemLedgEntry.Quantity),
//                 NonDistrAmountToAssign,NonDistrQtyToAssign);
//           UNTIL TempItemLedgEntry.NEXT = 0;
//         END ELSE
//           PostItemCharge(SalesLine,
//             SalesShptLine."Item Shpt. Entry No.",SalesShptLine."Quantity (Base)",
//             TempItemChargeAssgntSales."Amount to Assign",
//             TempItemChargeAssgntSales."Qty. to Assign");
//     end;

//     local procedure PostItemChargePerRetRcpt(var SalesLine: Record "37")
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
//         DistributeCharge: Boolean;
//     begin
//         IF NOT ReturnRcptLine.GET(
//              TempItemChargeAssgntSales."Applies-to Doc. No.",TempItemChargeAssgntSales."Applies-to Doc. Line No.")
//         THEN
//           ERROR(Text013);
//         ReturnRcptLine.TESTFIELD("Job No.",'');

//         IF ReturnRcptLine."Item Rcpt. Entry No." <> 0 THEN
//           DistributeCharge :=
//             CostCalcMgt.SplitItemLedgerEntriesExist(
//               TempItemLedgEntry,ReturnRcptLine."Quantity (Base)",ReturnRcptLine."Item Rcpt. Entry No.")
//         ELSE BEGIN
//           DistributeCharge := TRUE;
//           IF NOT ItemTrackingMgt.CollectItemEntryRelation(TempItemLedgEntry,
//                DATABASE::"Return Receipt Line",0,ReturnRcptLine."Document No.",
//                '',0,ReturnRcptLine."Line No.",ReturnRcptLine."Quantity (Base)")
//           THEN
//             ERROR(Text040);
//         END;

//         IF DistributeCharge THEN BEGIN
//           TempItemLedgEntry.FINDSET;
//           NonDistrQuantity := ReturnRcptLine."Quantity (Base)";
//           NonDistrQtyToAssign := TempItemChargeAssgntSales."Qty. to Assign";
//           NonDistrAmountToAssign := TempItemChargeAssgntSales."Amount to Assign";
//           REPEAT
//             Factor := ABS(TempItemLedgEntry.Quantity) / NonDistrQuantity;
//             QtyToAssign := NonDistrQtyToAssign * Factor;
//             AmountToAssign := ROUND(NonDistrAmountToAssign * Factor,GLSetup."Amount Rounding Precision");
//             IF Factor < 1 THEN BEGIN
//               PostItemCharge(SalesLine,
//                 TempItemLedgEntry."Entry No.",ABS(TempItemLedgEntry.Quantity),
//                 AmountToAssign,QtyToAssign);
//               NonDistrQuantity := NonDistrQuantity - ABS(TempItemLedgEntry.Quantity);
//               NonDistrQtyToAssign := NonDistrQtyToAssign - QtyToAssign;
//               NonDistrAmountToAssign := NonDistrAmountToAssign - AmountToAssign;
//             END ELSE // the last time
//               PostItemCharge(SalesLine,
//                 TempItemLedgEntry."Entry No.",ABS(TempItemLedgEntry.Quantity),
//                 NonDistrAmountToAssign,NonDistrQtyToAssign);
//           UNTIL TempItemLedgEntry.NEXT = 0;
//         END ELSE
//           PostItemCharge(SalesLine,
//             ReturnRcptLine."Item Rcpt. Entry No.",ReturnRcptLine."Quantity (Base)",
//             TempItemChargeAssgntSales."Amount to Assign",
//             TempItemChargeAssgntSales."Qty. to Assign")
//     end;

//     local procedure PostAssocItemJnlLine(QtyToBeShipped: Decimal;QtyToBeShippedBase: Decimal): Integer
//     var
//         TempHandlingSpecification2: Record "336" temporary;
//         ItemEntryRelation: Record "6507";
//     begin
//         PurchOrderHeader.GET(
//           PurchOrderHeader."Document Type"::Order,
//           SalesLine."Purchase Order No.");
//         PurchOrderLine.GET(
//           PurchOrderLine."Document Type"::Order,
//           SalesLine."Purchase Order No.",SalesLine."Purch. Order Line No.");

//         ItemJnlLine.INIT;
//         ItemJnlLine."Source Posting Group" := PurchOrderHeader."Vendor Posting Group";
//         ItemJnlLine."Salespers./Purch. Code" := PurchOrderHeader."Purchaser Code";
//         ItemJnlLine."Country/Region Code" := PurchOrderHeader."VAT Country/Region Code";
//         ItemJnlLine."Reason Code" := PurchOrderHeader."Reason Code";
//         ItemJnlLine."Posting No. Series" := PurchOrderHeader."Posting No. Series";
//         ItemJnlLine."Item No." := PurchOrderLine."No.";
//         ItemJnlLine.Description := PurchOrderLine.Description;
//         ItemJnlLine."Shortcut Dimension 1 Code" := PurchOrderLine."Shortcut Dimension 1 Code";
//         ItemJnlLine."Shortcut Dimension 2 Code" := PurchOrderLine."Shortcut Dimension 2 Code";
//         ItemJnlLine."Dimension Set ID" := PurchOrderLine."Dimension Set ID";
//         ItemJnlLine."Location Code" := PurchOrderLine."Location Code";
//         ItemJnlLine."Inventory Posting Group" := PurchOrderLine."Posting Group";
//         ItemJnlLine."Gen. Bus. Posting Group" := PurchOrderLine."Gen. Bus. Posting Group";
//         ItemJnlLine."Gen. Prod. Posting Group" := PurchOrderLine."Gen. Prod. Posting Group";
//         ItemJnlLine."Applies-to Entry" := PurchOrderLine."Appl.-to Item Entry";
//         ItemJnlLine."Transaction Type" := PurchOrderLine."Transaction Type";
//         ItemJnlLine."Transport Method" := PurchOrderLine."Transport Method";
//         ItemJnlLine."Entry/Exit Point" := PurchOrderLine."Entry Point";
//         ItemJnlLine.Area := PurchOrderLine.Area;
//         ItemJnlLine."Transaction Specification" := PurchOrderLine."Transaction Specification";
//         ItemJnlLine."Drop Shipment" := PurchOrderLine."Drop Shipment";
//         ItemJnlLine."Posting Date" := SalesHeader."Posting Date";
//         ItemJnlLine."Document Date" := SalesHeader."Document Date";
//         ItemJnlLine."Entry Type" := ItemJnlLine."Entry Type"::Purchase;
//         ItemJnlLine."Document No." := PurchOrderHeader."Receiving No.";
//         ItemJnlLine."External Document No." := PurchOrderHeader."No.";
//         ItemJnlLine."Document Type" := ItemJnlLine."Document Type"::"Purchase Receipt";
//         ItemJnlLine."Document Line No." := PurchOrderLine."Line No.";
//         ItemJnlLine.Quantity := QtyToBeShipped;
//         ItemJnlLine."Quantity (Base)" := QtyToBeShippedBase;
//         ItemJnlLine."Invoiced Quantity" := 0;
//         ItemJnlLine."Invoiced Qty. (Base)" := 0;
//         ItemJnlLine."Unit Cost" := PurchOrderLine."Unit Cost (LCY)";
//         ItemJnlLine."Source Currency Code" := SalesHeader."Currency Code";
//         ItemJnlLine."Unit Cost (ACY)" := PurchOrderLine."Unit Cost";
//         ItemJnlLine.Amount := PurchOrderLine."Line Amount";
//         ItemJnlLine."Discount Amount" := PurchOrderLine."Line Discount Amount";
//         ItemJnlLine."Source Type" := ItemJnlLine."Source Type"::Vendor;
//         ItemJnlLine."Source No." := PurchOrderLine."Buy-from Vendor No.";
//         ItemJnlLine."Invoice-to Source No." := PurchOrderLine."Pay-to Vendor No.";
//         ItemJnlLine."Source Code" := SrcCode;
//         ItemJnlLine."Variant Code" := PurchOrderLine."Variant Code";
//         ItemJnlLine."Item Category Code" := PurchOrderLine."Item Category Code";
//         ItemJnlLine."Product Group Code" := PurchOrderLine."Product Group Code";
//         ItemJnlLine."Bin Code" := PurchOrderLine."Bin Code";
//         ItemJnlLine."Purchasing Code" := PurchOrderLine."Purchasing Code";
//         IF PurchOrderLine."Prod. Order No." <> '' THEN BEGIN
//           ItemJnlLine."Order Type" := ItemJnlLine."Order Type"::Production;
//           ItemJnlLine."Order No." := PurchOrderLine."Prod. Order No.";
//           ItemJnlLine."Order Line No." := PurchOrderLine."Prod. Order Line No.";
//         END;
//         ItemJnlLine."Unit of Measure Code" := PurchOrderLine."Unit of Measure Code";
//         ItemJnlLine."Qty. per Unit of Measure" := PurchOrderLine."Qty. per Unit of Measure";
//         ItemJnlLine."Applies-to Entry" := 0;

//         IF PurchOrderLine."Job No." = '' THEN BEGIN
//           TransferReservFromPurchLine(PurchOrderLine,ItemJnlLine,QtyToBeShippedBase);
//           ItemJnlPostLine.RunWithCheck(ItemJnlLine);

//           // Handle Item Tracking
//           IF ItemJnlPostLine.CollectTrackingSpecification(TempHandlingSpecification2) THEN BEGIN
//             IF TempHandlingSpecification2.FINDSET THEN
//               REPEAT
//                 TempTrackingSpecification := TempHandlingSpecification2;
//                 TempTrackingSpecification."Source Type" := DATABASE::"Purchase Line";
//                 TempTrackingSpecification."Source Subtype" := PurchOrderLine."Document Type";
//                 TempTrackingSpecification."Source ID" := PurchOrderLine."Document No.";
//                 TempTrackingSpecification."Source Batch Name" := '';
//                 TempTrackingSpecification."Source Prod. Order Line" := 0;
//                 TempTrackingSpecification."Source Ref. No." := PurchOrderLine."Line No.";
//                 IF TempTrackingSpecification.INSERT THEN;
//                 ItemEntryRelation.INIT;
//                 ItemEntryRelation."Item Entry No." := TempHandlingSpecification2."Entry No.";
//                 ItemEntryRelation."Serial No." := TempHandlingSpecification2."Serial No.";
//                 ItemEntryRelation."Lot No." := TempHandlingSpecification2."Lot No.";
//                 ItemEntryRelation."Source Type" := DATABASE::"Purch. Rcpt. Line";
//                 ItemEntryRelation."Source ID" := PurchOrderHeader."Receiving No.";
//                 ItemEntryRelation."Source Ref. No." := PurchOrderLine."Line No.";
//                 ItemEntryRelation."Order No." := PurchOrderLine."Document No.";
//                 ItemEntryRelation."Order Line No." := PurchOrderLine."Line No.";
//                 ItemEntryRelation.INSERT;
//               UNTIL TempHandlingSpecification2.NEXT = 0;
//             EXIT(0);
//           END;
//         END;

//         EXIT(ItemJnlLine."Item Shpt. Entry No.");
//     end;

//     local procedure UpdateAssocOrder()
//     var
//         ReservePurchLine: Codeunit "99000834";
//     begin
//         DropShipPostBuffer.RESET;
//         IF DropShipPostBuffer.ISEMPTY THEN
//           EXIT;
//         CLEAR(PurchOrderHeader);
//         DropShipPostBuffer.FINDSET;
//         REPEAT
//           IF PurchOrderHeader."No." <> DropShipPostBuffer."Order No." THEN BEGIN
//             PurchOrderHeader.GET(
//               PurchOrderHeader."Document Type"::Order,
//               DropShipPostBuffer."Order No.");
//             PurchOrderHeader."Last Receiving No." := PurchOrderHeader."Receiving No.";
//             PurchOrderHeader."Receiving No." := '';
//             PurchOrderHeader.MODIFY;
//             ReservePurchLine.UpdateItemTrackingAfterPosting(PurchOrderHeader);
//           END;
//           PurchOrderLine.GET(
//             PurchOrderLine."Document Type"::Order,
//             DropShipPostBuffer."Order No.",DropShipPostBuffer."Order Line No.");
//           PurchOrderLine."Quantity Received" := PurchOrderLine."Quantity Received" + DropShipPostBuffer.Quantity;
//           PurchOrderLine."Qty. Received (Base)" := PurchOrderLine."Qty. Received (Base)" + DropShipPostBuffer."Quantity (Base)";
//           PurchOrderLine.InitOutstanding;
//           PurchOrderLine.InitQtyToReceive;
//           PurchOrderLine.MODIFY;
//         UNTIL DropShipPostBuffer.NEXT = 0;
//         DropShipPostBuffer.DELETEALL;
//     end;

//     local procedure UpdateAssocLines(var SalesOrderLine: Record "37")
//     begin
//         PurchOrderLine.GET(
//           PurchOrderLine."Document Type"::Order,
//           SalesOrderLine."Purchase Order No.",SalesOrderLine."Purch. Order Line No.");
//         PurchOrderLine."Sales Order No." := '';
//         PurchOrderLine."Sales Order Line No." := 0;
//         PurchOrderLine.MODIFY;
//         SalesOrderLine."Purchase Order No." := '';
//         SalesOrderLine."Purch. Order Line No." := 0;
//     end;

//     local procedure FillInvPostingBuffer(SalesLine: Record "37";SalesLineACY: Record "37")
//     var
//         TotalVAT: Decimal;
//         TotalVATACY: Decimal;
//         TotalAmount: Decimal;
//         TotalAmountACY: Decimal;
//     begin
//         IF (SalesLine."Gen. Bus. Posting Group" <> GenPostingSetup."Gen. Bus. Posting Group") OR
//            (SalesLine."Gen. Prod. Posting Group" <> GenPostingSetup."Gen. Prod. Posting Group")
//         THEN
//           GenPostingSetup.GET(SalesLine."Gen. Bus. Posting Group",SalesLine."Gen. Prod. Posting Group");

//         InvPostingBuffer[1].PrepareSales(SalesLine);

//         TotalVAT := SalesLine."Amount Including VAT" - SalesLine.Amount;
//         TotalVATACY := SalesLineACY."Amount Including VAT" - SalesLineACY.Amount;
//         TotalAmount := SalesLine.Amount;
//         TotalAmountACY := SalesLineACY.Amount;

//         IF SalesSetup."Discount Posting" IN
//            [SalesSetup."Discount Posting"::"Invoice Discounts",SalesSetup."Discount Posting"::"All Discounts"]
//         THEN BEGIN
//           IF SalesLine."VAT Calculation Type" = SalesLine."VAT Calculation Type"::"Reverse Charge VAT" THEN
//             InvPostingBuffer[1].CalcDiscountNoVAT(
//               -SalesLine."Inv. Discount Amount",
//               -SalesLineACY."Inv. Discount Amount")
//           ELSE
//             InvPostingBuffer[1].CalcDiscount(
//               SalesHeader."Prices Including VAT",
//               -SalesLine."Inv. Discount Amount",
//               -SalesLineACY."Inv. Discount Amount");
//           IF (InvPostingBuffer[1].Amount <> 0) OR
//              (InvPostingBuffer[1]."Amount (ACY)" <> 0)
//           THEN BEGIN
//             GenPostingSetup.TESTFIELD("Sales Inv. Disc. Account");
//             InvPostingBuffer[1].SetAccount(
//               GenPostingSetup."Sales Inv. Disc. Account",
//               TotalVAT,
//               TotalVATACY,
//               TotalAmount,
//               TotalAmountACY);
//             UpdInvPostingBuffer(TRUE);
//           END;
//         END;

//         IF SalesSetup."Discount Posting" IN
//            [SalesSetup."Discount Posting"::"Line Discounts",SalesSetup."Discount Posting"::"All Discounts"]
//         THEN BEGIN
//           IF SalesLine."VAT Calculation Type" = SalesLine."VAT Calculation Type"::"Reverse Charge VAT" THEN
//             InvPostingBuffer[1].CalcDiscountNoVAT(
//               -SalesLine."Line Discount Amount",
//               -SalesLineACY."Line Discount Amount")
//           ELSE
//             InvPostingBuffer[1].CalcDiscount(
//               SalesHeader."Prices Including VAT",
//               -SalesLine."Line Discount Amount",
//               -SalesLineACY."Line Discount Amount");
//           IF (InvPostingBuffer[1].Amount <> 0) OR
//              (InvPostingBuffer[1]."Amount (ACY)" <> 0)
//           THEN BEGIN
//             GenPostingSetup.TESTFIELD("Sales Line Disc. Account");
//             InvPostingBuffer[1].SetAccount(
//               GenPostingSetup."Sales Line Disc. Account",
//               TotalVAT,
//               TotalVATACY,
//               TotalAmount,
//               TotalAmountACY);
//             UpdInvPostingBuffer(TRUE);
//           END;
//         END;

//         InvPostingBuffer[1].SetAmounts(
//           TotalVAT,
//           TotalVATACY,
//           TotalAmount,
//           TotalAmountACY,
//           SalesLine."VAT Difference");

//         IF (SalesLine.Type = SalesLine.Type::"G/L Account") OR (SalesLine.Type = SalesLine.Type::"Fixed Asset") THEN
//           InvPostingBuffer[1].SetAccount(
//             SalesLine."No.",
//             TotalVAT,
//             TotalVATACY,
//             TotalAmount,
//             TotalAmountACY)
//         ELSE
//           IF SalesLine."Document Type" IN [SalesLine."Document Type"::"Return Order",SalesLine."Document Type"::"Credit Memo"] THEN BEGIN
//             GenPostingSetup.TESTFIELD("Sales Credit Memo Account");
//             InvPostingBuffer[1].SetAccount(
//               GenPostingSetup."Sales Credit Memo Account",
//               TotalVAT,
//               TotalVATACY,
//               TotalAmount,
//               TotalAmountACY);
//           END ELSE BEGIN
//             GenPostingSetup.TESTFIELD("Sales Account");
//             InvPostingBuffer[1].SetAccount(
//               GenPostingSetup."Sales Account",
//               TotalVAT,
//               TotalVATACY,
//               TotalAmount,
//               TotalAmountACY);
//           END;
//         UpdInvPostingBuffer(FALSE);
//     end;

//     local procedure UpdInvPostingBuffer(ForceGLAccountType: Boolean)
//     var
//         RestoreFAType: Boolean;
//     begin
//         InvPostingBuffer[1]."Dimension Set ID" := SalesLine."Dimension Set ID";

//         DimMgt.UpdateGlobalDimFromDimSetID(InvPostingBuffer[1]."Dimension Set ID",
//           InvPostingBuffer[1]."Global Dimension 1 Code",InvPostingBuffer[1]."Global Dimension 2 Code");

//         IF InvPostingBuffer[1].Type = InvPostingBuffer[1].Type::"Fixed Asset" THEN BEGIN
//           FALineNo := FALineNo + 1;
//           InvPostingBuffer[1]."Fixed Asset Line No." := FALineNo;
//           IF ForceGLAccountType THEN BEGIN
//             RestoreFAType := TRUE;
//             InvPostingBuffer[1].Type := InvPostingBuffer[1].Type::"G/L Account";
//           END;
//         END;

//         //DP.NCM TJC #449 04/04/2018
//         IF InvPostingBuffer[1].Type = InvPostingBuffer[1].Type::"G/L Account" THEN BEGIN
//           IF SalesLine.Description <> '' THEN //DP.NCM TJC #461 20/06/2018
//             InvPostingBuffer[1]."Line Description" := SalesLine.Description;
//         END;
//         //DP.NCM TJC #449 04/04/2018

//         IF SalesLine."Line Discount %" = 100 THEN BEGIN
//           InvPostingBuffer[1]."VAT Base Amount" := 0;
//           InvPostingBuffer[1]."VAT Base Amount (ACY)" := 0;
//           InvPostingBuffer[1]."VAT Amount" := 0;
//           InvPostingBuffer[1]."VAT Amount (ACY)" := 0;
//         END;
//         InvPostingBuffer[2] := InvPostingBuffer[1];
//         IF InvPostingBuffer[2].FIND THEN BEGIN
//           InvPostingBuffer[2].Amount := InvPostingBuffer[2].Amount + InvPostingBuffer[1].Amount;
//           InvPostingBuffer[2]."VAT Amount" :=
//             InvPostingBuffer[2]."VAT Amount" + InvPostingBuffer[1]."VAT Amount";
//           InvPostingBuffer[2]."VAT Base Amount" :=
//             InvPostingBuffer[2]."VAT Base Amount" + InvPostingBuffer[1]."VAT Base Amount";
//           InvPostingBuffer[2]."Amount (ACY)" :=
//             InvPostingBuffer[2]."Amount (ACY)" + InvPostingBuffer[1]."Amount (ACY)";
//           InvPostingBuffer[2]."VAT Amount (ACY)" :=
//             InvPostingBuffer[2]."VAT Amount (ACY)" + InvPostingBuffer[1]."VAT Amount (ACY)";
//           InvPostingBuffer[2]."VAT Difference" :=
//             InvPostingBuffer[2]."VAT Difference" + InvPostingBuffer[1]."VAT Difference";
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

//         IF RestoreFAType THEN
//           InvPostingBuffer[1].Type := InvPostingBuffer[1].Type::"Fixed Asset";
//     end;

//     local procedure InsertPrepmtAdjInvPostingBuf(PrepmtSalesLine: Record "37")
//     var
//         SalesPostPrepayments: Codeunit "442";
//         AdjAmount: Decimal;
//     begin
//         WITH PrepmtSalesLine DO
//           IF "Prepayment Line" THEN
//             IF "Prepmt. Amount Inv. (LCY)" <> 0 THEN BEGIN
//               AdjAmount := -"Prepmt. Amount Inv. (LCY)";
//               FillPrepmtAdjInvPostingBuffer("No.",AdjAmount,SalesHeader."Currency Code" = '');
//               FillPrepmtAdjInvPostingBuffer(
//                 SalesPostPrepayments.GetCorrBalAccNo(SalesHeader,AdjAmount > 0),
//                 -AdjAmount,
//                 SalesHeader."Currency Code" = '');
//             END ELSE
//               IF ("Prepayment %" = 100) AND ("Prepmt. VAT Amount Inv. (LCY)" <> 0) THEN
//                 FillPrepmtAdjInvPostingBuffer(
//                   SalesPostPrepayments.GetInvRoundingAccNo(SalesHeader."Customer Posting Group"),
//                   "Prepmt. VAT Amount Inv. (LCY)",SalesHeader."Currency Code" = '');
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
//         WITH SalesHeader DO
//           IF "Currency Code" = '' THEN
//             Currency.InitRoundingPrecision
//           ELSE BEGIN
//             Currency.GET("Currency Code");
//             Currency.TESTFIELD("Amount Rounding Precision");
//           END;
//     end;

//     local procedure DivideAmount(QtyType: Option General,Invoicing,Shipping;SalesLineQty: Decimal)
//     begin
//         IF RoundingLineInserted AND (RoundingLineNo = SalesLine."Line No.") THEN
//           EXIT;
//         WITH SalesLine DO
//           IF (SalesLineQty = 0) OR ("Unit Price" = 0) THEN BEGIN
//             "Line Amount" := 0;
//             "Line Discount Amount" := 0;
//             "Inv. Discount Amount" := 0;
//             "VAT Base Amount" := 0;
//             Amount := 0;
//             "Amount Including VAT" := 0;
//           END ELSE BEGIN
//             TempVATAmountLine.GET("VAT Identifier","VAT Calculation Type","Tax Group Code",FALSE,"Line Amount" >= 0);
//             IF "VAT Calculation Type" = "VAT Calculation Type"::"Sales Tax" THEN
//               "VAT %" := TempVATAmountLine."VAT %";
//             TempVATAmountLineRemainder := TempVATAmountLine;
//             IF NOT TempVATAmountLineRemainder.FIND THEN BEGIN
//               TempVATAmountLineRemainder.INIT;
//               TempVATAmountLineRemainder.INSERT;
//             END;
//             "Line Amount" := GetLineAmountToHandle(SalesLineQty) + GetPrepmtDiffToLineAmount(SalesLine);
//             IF SalesLineQty <> Quantity THEN
//               "Line Discount Amount" :=
//                 ROUND("Line Discount Amount" * SalesLineQty / Quantity,Currency."Amount Rounding Precision");

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

//             IF SalesHeader."Prices Including VAT" THEN BEGIN
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
//                   Amount * (1 - SalesHeader."VAT Base Discount %" / 100),Currency."Amount Rounding Precision");
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
//                     Amount * (1 - SalesHeader."VAT Base Discount %" / 100),Currency."Amount Rounding Precision");
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

//     local procedure RoundAmount(SalesLineQty: Decimal)
//     var
//         NoVAT: Boolean;
//     begin
//         WITH SalesLine DO BEGIN
//           IncrAmount(TotalSalesLine);
//           Increment(TotalSalesLine."Net Weight",ROUND(SalesLineQty * "Net Weight",0.00001));
//           Increment(TotalSalesLine."Gross Weight",ROUND(SalesLineQty * "Gross Weight",0.00001));
//           Increment(TotalSalesLine."Unit Volume",ROUND(SalesLineQty * "Unit Volume",0.00001));
//           Increment(TotalSalesLine.Quantity,SalesLineQty);
//           IF "Units per Parcel" > 0 THEN
//             Increment(
//               TotalSalesLine."Units per Parcel",
//               ROUND(SalesLineQty / "Units per Parcel",1,'>'));

//           TempSalesLine := SalesLine;
//           SalesLineACY := SalesLine;

//           IF SalesHeader."Currency Code" <> '' THEN BEGIN
//             IF SalesHeader."Posting Date" = 0D THEN
//               UseDate := WORKDATE
//             ELSE
//               UseDate := SalesHeader."Posting Date";

//             NoVAT := Amount = "Amount Including VAT";
//             "Amount Including VAT" :=
//               ROUND(
//                 CurrExchRate.ExchangeAmtFCYToLCY(
//                   UseDate,SalesHeader."Currency Code",
//                   TotalSalesLine."Amount Including VAT",SalesHeader."Currency Factor")) -
//               TotalSalesLineLCY."Amount Including VAT";
//             IF NoVAT THEN
//               Amount := "Amount Including VAT"
//             ELSE
//               Amount :=
//                 ROUND(
//                   CurrExchRate.ExchangeAmtFCYToLCY(
//                     UseDate,SalesHeader."Currency Code",
//                     TotalSalesLine.Amount,SalesHeader."Currency Factor")) -
//                 TotalSalesLineLCY.Amount;
//             "Line Amount" :=
//               ROUND(
//                 CurrExchRate.ExchangeAmtFCYToLCY(
//                   UseDate,SalesHeader."Currency Code",
//                   TotalSalesLine."Line Amount",SalesHeader."Currency Factor")) -
//               TotalSalesLineLCY."Line Amount";
//             "Line Discount Amount" :=
//               ROUND(
//                 CurrExchRate.ExchangeAmtFCYToLCY(
//                   UseDate,SalesHeader."Currency Code",
//                   TotalSalesLine."Line Discount Amount",SalesHeader."Currency Factor")) -
//               TotalSalesLineLCY."Line Discount Amount";
//             "Inv. Discount Amount" :=
//               ROUND(
//                 CurrExchRate.ExchangeAmtFCYToLCY(
//                   UseDate,SalesHeader."Currency Code",
//                   TotalSalesLine."Inv. Discount Amount",SalesHeader."Currency Factor")) -
//               TotalSalesLineLCY."Inv. Discount Amount";
//             "VAT Difference" :=
//               ROUND(
//                 CurrExchRate.ExchangeAmtFCYToLCY(
//                   UseDate,SalesHeader."Currency Code",
//                   TotalSalesLine."VAT Difference",SalesHeader."Currency Factor")) -
//               TotalSalesLineLCY."VAT Difference";
//           END;

//           IncrAmount(TotalSalesLineLCY);
//           Increment(TotalSalesLineLCY."Unit Cost (LCY)",ROUND(SalesLineQty * "Unit Cost (LCY)"));
//         END;
//     end;

//     local procedure ReverseAmount(var SalesLine: Record "37")
//     begin
//         WITH SalesLine DO BEGIN
//           "Qty. to Ship" := -"Qty. to Ship";
//           "Qty. to Ship (Base)" := -"Qty. to Ship (Base)";
//           "Return Qty. to Receive" := -"Return Qty. to Receive";
//           "Return Qty. to Receive (Base)" := -"Return Qty. to Receive (Base)";
//           "Qty. to Invoice" := -"Qty. to Invoice";
//           "Qty. to Invoice (Base)" := -"Qty. to Invoice (Base)";
//           "Line Amount" := -"Line Amount";
//           Amount := -Amount;
//           "VAT Base Amount" := -"VAT Base Amount";
//           "VAT Difference" := -"VAT Difference";
//           "Amount Including VAT" := -"Amount Including VAT";
//           "Line Discount Amount" := -"Line Discount Amount";
//           "Inv. Discount Amount" := -"Inv. Discount Amount";
//         END;
//     end;

//     local procedure InvoiceRounding(UseTempData: Boolean;BiggestLineNo: Integer)
//     var
//         InvoiceRoundingAmount: Decimal;
//     begin
//         Currency.TESTFIELD("Invoice Rounding Precision");
//         InvoiceRoundingAmount :=
//           -ROUND(
//             TotalSalesLine."Amount Including VAT" -
//             ROUND(
//               TotalSalesLine."Amount Including VAT",
//               Currency."Invoice Rounding Precision",
//               Currency.InvoiceRoundingDirection),
//             Currency."Amount Rounding Precision");
//         IF InvoiceRoundingAmount <> 0 THEN BEGIN
//           CustPostingGr.GET(SalesHeader."Customer Posting Group");
//           CustPostingGr.TESTFIELD("Invoice Rounding Account");
//           WITH SalesLine DO BEGIN
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
//             VALIDATE("No.",CustPostingGr."Invoice Rounding Account");
//             VALIDATE(Quantity,1);
//             IF "Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"] THEN
//               VALIDATE("Return Qty. to Receive",Quantity)
//             ELSE
//               VALIDATE("Qty. to Ship",Quantity);
//             IF SalesHeader."Prices Including VAT" THEN
//               VALIDATE("Unit Price",InvoiceRoundingAmount)
//             ELSE
//               VALIDATE(
//                 "Unit Price",
//                 ROUND(
//                   InvoiceRoundingAmount /
//                   (1 + (1 - SalesHeader."VAT Base Discount %" / 100) * "VAT %" / 100),
//                   Currency."Amount Rounding Precision"));
//             VALIDATE("Amount Including VAT",InvoiceRoundingAmount);
//             "Line No." := BiggestLineNo;
//             IF NOT UseTempData THEN
//               ;
//             LastLineRetrieved := FALSE;
//             RoundingLineInserted := TRUE;
//             RoundingLineNo := "Line No.";
//           END;
//         END;
//     end;

//     local procedure IncrAmount(var TotalSalesLine: Record "37")
//     begin
//         WITH SalesLine DO BEGIN
//           IF SalesHeader."Prices Including VAT" OR
//              ("VAT Calculation Type" <> "VAT Calculation Type"::"Full VAT")
//           THEN
//             Increment(TotalSalesLine."Line Amount","Line Amount");
//           Increment(TotalSalesLine.Amount,Amount);
//           Increment(TotalSalesLine."VAT Base Amount","VAT Base Amount");
//           Increment(TotalSalesLine."VAT Difference","VAT Difference");
//           Increment(TotalSalesLine."Amount Including VAT","Amount Including VAT");
//           Increment(TotalSalesLine."Line Discount Amount","Line Discount Amount");
//           Increment(TotalSalesLine."Inv. Discount Amount","Inv. Discount Amount");
//           Increment(TotalSalesLine."Inv. Disc. Amount to Invoice","Inv. Disc. Amount to Invoice");
//           Increment(TotalSalesLine."Prepmt. Line Amount","Prepmt. Line Amount");
//           Increment(TotalSalesLine."Prepmt. Amt. Inv.","Prepmt. Amt. Inv.");
//           Increment(TotalSalesLine."Prepmt Amt to Deduct","Prepmt Amt to Deduct");
//           Increment(TotalSalesLine."Prepmt Amt Deducted","Prepmt Amt Deducted");
//           Increment(TotalSalesLine."Prepayment VAT Difference","Prepayment VAT Difference");
//           Increment(TotalSalesLine."Prepmt VAT Diff. to Deduct","Prepmt VAT Diff. to Deduct");
//           Increment(TotalSalesLine."Prepmt VAT Diff. Deducted","Prepmt VAT Diff. Deducted");
//         END;
//     end;

//     local procedure Increment(var Number: Decimal;Number2: Decimal)
//     begin
//         Number := Number + Number2;
//     end;

//     procedure GetSalesLines(var NewSalesHeader: Record "36";var NewSalesLine: Record "37";QtyType: Option General,Invoicing,Shipping)
//     var
//         OldSalesLine: Record "37";
//         MergedSalesLines: Record "37" temporary;
//         TotalAdjCostLCY: Decimal;
//     begin
//         SalesHeader := NewSalesHeader;
//         IF QtyType = QtyType::Invoicing THEN BEGIN
//           CreatePrepaymentLines(SalesHeader,TempPrepaymentSalesLine,FALSE);
//           MergeSaleslines(SalesHeader,OldSalesLine,TempPrepaymentSalesLine,MergedSalesLines);
//           SumSalesLines2(NewSalesLine,MergedSalesLines,QtyType,TRUE,FALSE,TotalAdjCostLCY);
//         END ELSE
//           SumSalesLines2(NewSalesLine,OldSalesLine,QtyType,TRUE,FALSE,TotalAdjCostLCY);
//     end;

//     procedure GetSalesLinesTemp(var NewSalesHeader: Record "36";var NewSalesLine: Record "37";var OldSalesLine: Record "37";QtyType: Option General,Invoicing,Shipping)
//     var
//         TotalAdjCostLCY: Decimal;
//     begin
//         SalesHeader := NewSalesHeader;
//         OldSalesLine.SetSalesHeader(NewSalesHeader);
//         SumSalesLines2(NewSalesLine,OldSalesLine,QtyType,TRUE,FALSE,TotalAdjCostLCY);
//     end;

//     procedure SumSalesLines(var NewSalesHeader: Record "36";QtyType: Option General,Invoicing,Shipping;var NewTotalSalesLine: Record "37";var NewTotalSalesLineLCY: Record "37";var VATAmount: Decimal;var VATAmountText: Text[30];var ProfitLCY: Decimal;var ProfitPct: Decimal;var TotalAdjCostLCY: Decimal)
//     var
//         OldSalesLine: Record "37";
//     begin
//         SumSalesLinesTemp(
//           NewSalesHeader,OldSalesLine,QtyType,NewTotalSalesLine,NewTotalSalesLineLCY,
//           VATAmount,VATAmountText,ProfitLCY,ProfitPct,TotalAdjCostLCY);
//     end;

//     procedure SumSalesLinesTemp(var NewSalesHeader: Record "36";var OldSalesLine: Record "37";QtyType: Option General,Invoicing,Shipping;var NewTotalSalesLine: Record "37";var NewTotalSalesLineLCY: Record "37";var VATAmount: Decimal;var VATAmountText: Text[30];var ProfitLCY: Decimal;var ProfitPct: Decimal;var TotalAdjCostLCY: Decimal)
//     var
//         SalesLine: Record "37";
//     begin
//         WITH SalesHeader DO BEGIN
//           SalesHeader := NewSalesHeader;
//           SumSalesLines2(SalesLine,OldSalesLine,QtyType,FALSE,TRUE,TotalAdjCostLCY);
//           ProfitLCY := TotalSalesLineLCY.Amount - TotalSalesLineLCY."Unit Cost (LCY)";
//           IF TotalSalesLineLCY.Amount = 0 THEN
//             ProfitPct := 0
//           ELSE
//             ProfitPct := ROUND(ProfitLCY / TotalSalesLineLCY.Amount * 100,0.1);
//           VATAmount := TotalSalesLine."Amount Including VAT" - TotalSalesLine.Amount;
//           IF TotalSalesLine."VAT %" = 0 THEN
//             VATAmountText := Text016
//           ELSE
//             VATAmountText := STRSUBSTNO(Text017,TotalSalesLine."VAT %");
//           NewTotalSalesLine := TotalSalesLine;
//           NewTotalSalesLineLCY := TotalSalesLineLCY;
//         END;
//     end;

//     local procedure SumSalesLines2(var NewSalesLine: Record "37";var OldSalesLine: Record "37";QtyType: Option General,Invoicing,Shipping;InsertSalesLine: Boolean;CalcAdCostLCY: Boolean;var TotalAdjCostLCY: Decimal)
//     var
//         SalesLineQty: Decimal;
//         AdjCostLCY: Decimal;
//         BiggestLineNo: Integer;
//     begin
//         TotalAdjCostLCY := 0;
//         TempVATAmountLineRemainder.DELETEALL;
//         OldSalesLine.CalcVATAmountLines(QtyType,SalesHeader,OldSalesLine,TempVATAmountLine);
//         WITH SalesHeader DO BEGIN
//           GetGLSetup;
//           SalesSetup.GET;
//           GetCurrency;
//           OldSalesLine.SETRANGE("Document Type","Document Type");
//           OldSalesLine.SETRANGE("Document No.","No.");
//           RoundingLineInserted := FALSE;
//           IF OldSalesLine.FINDSET THEN
//             REPEAT
//               IF NOT RoundingLineInserted THEN
//                 SalesLine := OldSalesLine;
//               CASE QtyType OF
//                 QtyType::General:
//                   SalesLineQty := SalesLine.Quantity;
//                 QtyType::Invoicing:
//                   SalesLineQty := SalesLine."Qty. to Invoice";
//                 QtyType::Shipping:
//                   BEGIN
//                     IF "Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"] THEN
//                       SalesLineQty := SalesLine."Return Qty. to Receive"
//                     ELSE
//                       SalesLineQty := SalesLine."Qty. to Ship";
//                   END;
//               END;
//               DivideAmount(QtyType,SalesLineQty);
//               SalesLine.Quantity := SalesLineQty;
//               IF SalesLineQty <> 0 THEN BEGIN
//                 IF (SalesLine.Amount <> 0) AND NOT RoundingLineInserted THEN
//                   IF TotalSalesLine.Amount = 0 THEN
//                     TotalSalesLine."VAT %" := SalesLine."VAT %"
//                   ELSE
//                     IF TotalSalesLine."VAT %" <> SalesLine."VAT %" THEN
//                       TotalSalesLine."VAT %" := 0;
//                 RoundAmount(SalesLineQty);

//                 IF (QtyType IN [QtyType::General,QtyType::Invoicing]) AND
//                    NOT InsertSalesLine AND CalcAdCostLCY
//                 THEN BEGIN
//                   AdjCostLCY := CostCalcMgt.CalcSalesLineCostLCY(SalesLine,QtyType);
//                   TotalAdjCostLCY := TotalAdjCostLCY + GetSalesLineAdjCostLCY(SalesLine,QtyType,AdjCostLCY);
//                 END;

//                 SalesLine := TempSalesLine;
//               END;
//               IF InsertSalesLine THEN BEGIN
//                 NewSalesLine := SalesLine;
//                 NewSalesLine.INSERT;
//               END;
//               IF RoundingLineInserted THEN
//                 LastLineRetrieved := TRUE
//               ELSE BEGIN
//                 BiggestLineNo := MAX(BiggestLineNo,OldSalesLine."Line No.");
//                 LastLineRetrieved := OldSalesLine.NEXT = 0;
//                 IF LastLineRetrieved AND SalesSetup."Invoice Rounding" THEN
//                   InvoiceRounding(TRUE,BiggestLineNo);
//               END;
//             UNTIL LastLineRetrieved;
//         END;
//     end;

//     local procedure GetSalesLineAdjCostLCY(SalesLine2: Record "37";QtyType: Option General,Invoicing,Shipping;AdjCostLCY: Decimal): Decimal
//     begin
//         WITH SalesLine2 DO BEGIN
//           IF "Document Type" IN ["Document Type"::Order,"Document Type"::Invoice] THEN
//             AdjCostLCY := -AdjCostLCY;

//           CASE TRUE OF
//             "Shipment No." <> '',"Return Receipt No." <> '':
//               EXIT(AdjCostLCY);
//             QtyType = QtyType::General:
//               EXIT(ROUND("Outstanding Quantity" * "Unit Cost (LCY)") + AdjCostLCY);
//             "Document Type" IN ["Document Type"::Order,"Document Type"::Invoice]:
//               BEGIN
//                 IF "Qty. to Invoice" > "Qty. to Ship" THEN
//                   EXIT(ROUND("Qty. to Ship" * "Unit Cost (LCY)") + AdjCostLCY);
//                 EXIT(ROUND("Qty. to Invoice" * "Unit Cost (LCY)"));
//               END;
//             "Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"]:
//               BEGIN
//                 IF "Qty. to Invoice" > "Return Qty. to Receive" THEN
//                   EXIT(ROUND("Return Qty. to Receive" * "Unit Cost (LCY)") + AdjCostLCY);
//                 EXIT(ROUND("Qty. to Invoice" * "Unit Cost (LCY)"));
//               END;
//           END;
//         END;
//     end;

//     procedure TestDeleteHeader(SalesHeader: Record "36";var SalesShptHeader: Record "110";var SalesInvHeader: Record "112";var SalesCrMemoHeader: Record "114";var ReturnRcptHeader: Record "6660";var SalesInvHeaderPrePmt: Record "112";var SalesCrMemoHeaderPrePmt: Record "114")
//     begin
//         WITH SalesHeader DO BEGIN
//           CLEAR(SalesShptHeader);
//           CLEAR(SalesInvHeader);
//           CLEAR(SalesCrMemoHeader);
//           CLEAR(ReturnRcptHeader);
//           SalesSetup.GET;

//           SourceCodeSetup.GET;
//           SourceCodeSetup.TESTFIELD("Deleted Document");
//           SourceCode.GET(SourceCodeSetup."Deleted Document");

//           IF ("Shipping No. Series" <> '') AND ("Shipping No." <> '') THEN BEGIN
//             SalesShptHeader.TRANSFERFIELDS(SalesHeader);
//             SalesShptHeader."No." := "Shipping No.";
//             SalesShptHeader."Posting Date" := TODAY;
//             SalesShptHeader."User ID" := USERID;
//             SalesShptHeader."Source Code" := SourceCode.Code;
//           END;

//           IF ("Return Receipt No. Series" <> '') AND ("Return Receipt No." <> '') THEN BEGIN
//             ReturnRcptHeader.TRANSFERFIELDS(SalesHeader);
//             ReturnRcptHeader."No." := "Return Receipt No.";
//             ReturnRcptHeader."Posting Date" := TODAY;
//             ReturnRcptHeader."User ID" := USERID;
//             ReturnRcptHeader."Source Code" := SourceCode.Code;
//           END;

//           IF ("Posting No. Series" <> '') AND
//              (("Document Type" IN ["Document Type"::Order,"Document Type"::Invoice]) AND
//               ("Posting No." <> '') OR
//               ("Document Type" = "Document Type"::Invoice) AND
//               ("No. Series" = "Posting No. Series"))
//           THEN BEGIN
//             SalesInvHeader.TRANSFERFIELDS(SalesHeader);
//             IF "Posting No." <> '' THEN
//               SalesInvHeader."No." := "Posting No.";
//             IF "Document Type" = "Document Type"::Invoice THEN BEGIN
//               SalesInvHeader."Pre-Assigned No. Series" := "No. Series";
//               SalesInvHeader."Pre-Assigned No." := "No.";
//             END ELSE BEGIN
//               SalesInvHeader."Pre-Assigned No. Series" := '';
//               SalesInvHeader."Pre-Assigned No." := '';
//               SalesInvHeader."Order No. Series" := "No. Series";
//               SalesInvHeader."Order No." := "No.";
//             END;
//             SalesInvHeader."Posting Date" := TODAY;
//             SalesInvHeader."User ID" := USERID;
//             SalesInvHeader."Source Code" := SourceCode.Code;
//           END;

//           IF ("Posting No. Series" <> '') AND
//              (("Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"]) AND
//               ("Posting No." <> '') OR
//               ("Document Type" = "Document Type"::"Credit Memo") AND
//               ("No. Series" = "Posting No. Series"))
//           THEN BEGIN
//             SalesCrMemoHeader.TRANSFERFIELDS(SalesHeader);
//             IF "Posting No." <> '' THEN
//               SalesCrMemoHeader."No." := "Posting No.";
//             SalesCrMemoHeader."Pre-Assigned No. Series" := "No. Series";
//             SalesCrMemoHeader."Pre-Assigned No." := "No.";
//             SalesCrMemoHeader."Posting Date" := TODAY;
//             SalesCrMemoHeader."User ID" := USERID;
//             SalesCrMemoHeader."Source Code" := SourceCode.Code;
//           END;
//           IF ("Prepayment No. Series" <> '') AND ("Prepayment No." <> '') THEN BEGIN
//             TESTFIELD("Document Type","Document Type"::Order);
//             SalesInvHeaderPrePmt.TRANSFERFIELDS(SalesHeader);
//             SalesInvHeaderPrePmt."No." := "Prepayment No.";
//             SalesInvHeaderPrePmt."Order No. Series" := "No. Series";
//             SalesInvHeaderPrePmt."Prepayment Order No." := "No.";
//             SalesInvHeaderPrePmt."Posting Date" := TODAY;
//             SalesInvHeaderPrePmt."Pre-Assigned No. Series" := '';
//             SalesInvHeaderPrePmt."Pre-Assigned No." := '';
//             SalesInvHeaderPrePmt."User ID" := USERID;
//             SalesInvHeaderPrePmt."Source Code" := SourceCode.Code;
//             SalesInvHeaderPrePmt."Prepayment Invoice" := TRUE;
//           END;

//           IF ("Prepmt. Cr. Memo No. Series" <> '') AND ("Prepmt. Cr. Memo No." <> '') THEN BEGIN
//             TESTFIELD("Document Type","Document Type"::Order);
//             SalesCrMemoHeaderPrePmt.TRANSFERFIELDS(SalesHeader);
//             SalesCrMemoHeaderPrePmt."No." := "Prepmt. Cr. Memo No.";
//             SalesCrMemoHeaderPrePmt."Prepayment Order No." := "No.";
//             SalesCrMemoHeaderPrePmt."Posting Date" := TODAY;
//             SalesCrMemoHeaderPrePmt."Pre-Assigned No. Series" := '';
//             SalesCrMemoHeaderPrePmt."Pre-Assigned No." := '';
//             SalesCrMemoHeaderPrePmt."User ID" := USERID;
//             SalesCrMemoHeaderPrePmt."Source Code" := SourceCode.Code;
//             SalesCrMemoHeaderPrePmt."Prepayment Credit Memo" := TRUE;
//           END;
//         END;
//     end;

//     procedure DeleteHeader(SalesHeader: Record "36";var SalesShptHeader: Record "110";var SalesInvHeader: Record "112";var SalesCrMemoHeader: Record "114";var ReturnRcptHeader: Record "6660";var SalesInvHeaderPrePmt: Record "112";var SalesCrMemoHeaderPrePmt: Record "114")
//     begin
//         WITH SalesHeader DO BEGIN
//           TestDeleteHeader(
//             SalesHeader,SalesShptHeader,SalesInvHeader,SalesCrMemoHeader,
//             ReturnRcptHeader,SalesInvHeaderPrePmt,SalesCrMemoHeaderPrePmt);
//           IF SalesShptHeader."No." <> '' THEN BEGIN
//             SalesShptHeader.INSERT;
//             SalesShptLine.INIT;
//             SalesShptLine."Document No." := SalesShptHeader."No.";
//             SalesShptLine."Line No." := 10000;
//             SalesShptLine.Description := SourceCode.Description;
//             SalesShptLine.INSERT;
//           END;

//           IF ReturnRcptHeader."No." <> '' THEN BEGIN
//             ReturnRcptHeader.INSERT;
//             ReturnRcptLine.INIT;
//             ReturnRcptLine."Document No." := ReturnRcptHeader."No.";
//             ReturnRcptLine."Line No." := 10000;
//             ReturnRcptLine.Description := SourceCode.Description;
//             ReturnRcptLine.INSERT;
//           END;

//           IF SalesInvHeader."No." <> '' THEN BEGIN
//             SalesInvHeader.INSERT;
//             SalesInvLine.INIT;
//             SalesInvLine."Document No." := SalesInvHeader."No.";
//             SalesInvLine."Line No." := 10000;
//             SalesInvLine.Description := SourceCode.Description;
//             SalesInvLine.INSERT;
//           END;

//           IF SalesCrMemoHeader."No." <> '' THEN BEGIN
//             SalesCrMemoHeader.INSERT;
//             SalesCrMemoLine.INIT;
//             SalesCrMemoLine."Document No." := SalesCrMemoHeader."No.";
//             SalesCrMemoLine."Line No." := 10000;
//             SalesCrMemoLine.Description := SourceCode.Description;
//             SalesCrMemoLine.INSERT;
//           END;

//           IF SalesInvHeaderPrePmt."No." <> '' THEN BEGIN
//             SalesInvHeaderPrePmt.INSERT;
//             SalesInvLine."Document No." := SalesInvHeaderPrePmt."No.";
//             SalesInvLine."Line No." := 10000;
//             SalesInvLine.Description := SourceCode.Description;
//             SalesInvLine.INSERT;
//           END;

//           IF SalesCrMemoHeaderPrePmt."No." <> '' THEN BEGIN
//             SalesCrMemoHeaderPrePmt.INSERT;
//             SalesCrMemoLine.INIT;
//             SalesCrMemoLine."Document No." := SalesCrMemoHeaderPrePmt."No.";
//             SalesCrMemoLine."Line No." := 10000;
//             SalesCrMemoLine.Description := SourceCode.Description;
//             SalesCrMemoLine.INSERT;
//           END;
//         END;
//     end;

//     procedure UpdateBlanketOrderLine(SalesLine: Record "37";Ship: Boolean;Receive: Boolean;Invoice: Boolean)
//     var
//         BlanketOrderSalesLine: Record "37";
//         ModifyLine: Boolean;
//         Sign: Decimal;
//     begin
//         IF SalesLine."Document Type" IN [SalesLine."Document Type"::"Return Order",SalesLine."Document Type"::"Credit Memo"] THEN
//           EXIT;
//         IF (SalesLine."Blanket Order No." <> '') AND (SalesLine."Blanket Order Line No." <> 0) AND
//            ((Ship AND (SalesLine."Qty. to Ship" <> 0)) OR
//             (Receive AND (SalesLine."Return Qty. to Receive" <> 0)) OR
//             (Invoice AND (SalesLine."Qty. to Invoice" <> 0)))
//         THEN
//           IF BlanketOrderSalesLine.GET(
//                BlanketOrderSalesLine."Document Type"::"Blanket Order",SalesLine."Blanket Order No.",
//                SalesLine."Blanket Order Line No.")
//           THEN BEGIN
//             BlanketOrderSalesLine.TESTFIELD(Type,SalesLine.Type);
//             BlanketOrderSalesLine.TESTFIELD("No.",SalesLine."No.");
//             BlanketOrderSalesLine.TESTFIELD("Sell-to Customer No.",SalesLine."Sell-to Customer No.");

//             ModifyLine := FALSE;
//             CASE SalesLine."Document Type" OF
//               SalesLine."Document Type"::Order,
//               SalesLine."Document Type"::Invoice:
//                 Sign := 1;
//               SalesLine."Document Type"::"Return Order",
//               SalesLine."Document Type"::"Credit Memo":
//                 Sign := -1;
//             END;
//             IF Ship AND (SalesLine."Shipment No." = '') THEN BEGIN
//               IF BlanketOrderSalesLine."Qty. per Unit of Measure" =
//                  SalesLine."Qty. per Unit of Measure"
//               THEN
//                 BlanketOrderSalesLine."Quantity Shipped" :=
//                   BlanketOrderSalesLine."Quantity Shipped" + Sign * SalesLine."Qty. to Ship"
//               ELSE
//                 BlanketOrderSalesLine."Quantity Shipped" :=
//                   BlanketOrderSalesLine."Quantity Shipped" +
//                   Sign *
//                   ROUND(
//                     (SalesLine."Qty. per Unit of Measure" /
//                      BlanketOrderSalesLine."Qty. per Unit of Measure") *
//                     SalesLine."Qty. to Ship",0.00001);
//               BlanketOrderSalesLine."Qty. Shipped (Base)" :=
//                 BlanketOrderSalesLine."Qty. Shipped (Base)" + Sign * SalesLine."Qty. to Ship (Base)";
//               ModifyLine := TRUE;
//             END;
//             IF Receive AND (SalesLine."Return Receipt No." = '') THEN BEGIN
//               IF BlanketOrderSalesLine."Qty. per Unit of Measure" =
//                  SalesLine."Qty. per Unit of Measure"
//               THEN
//                 BlanketOrderSalesLine."Quantity Shipped" :=
//                   BlanketOrderSalesLine."Quantity Shipped" + Sign * SalesLine."Return Qty. to Receive"
//               ELSE
//                 BlanketOrderSalesLine."Quantity Shipped" :=
//                   BlanketOrderSalesLine."Quantity Shipped" +
//                   Sign *
//                   ROUND(
//                     (SalesLine."Qty. per Unit of Measure" /
//                      BlanketOrderSalesLine."Qty. per Unit of Measure") *
//                     SalesLine."Return Qty. to Receive",0.00001);
//               BlanketOrderSalesLine."Qty. Shipped (Base)" :=
//                 BlanketOrderSalesLine."Qty. Shipped (Base)" + Sign * SalesLine."Return Qty. to Receive (Base)";
//               ModifyLine := TRUE;
//             END;
//             IF Invoice THEN BEGIN
//               IF BlanketOrderSalesLine."Qty. per Unit of Measure" =
//                  SalesLine."Qty. per Unit of Measure"
//               THEN
//                 BlanketOrderSalesLine."Quantity Invoiced" :=
//                   BlanketOrderSalesLine."Quantity Invoiced" + Sign * SalesLine."Qty. to Invoice"
//               ELSE
//                 BlanketOrderSalesLine."Quantity Invoiced" :=
//                   BlanketOrderSalesLine."Quantity Invoiced" +
//                   Sign *
//                   ROUND(
//                     (SalesLine."Qty. per Unit of Measure" /
//                      BlanketOrderSalesLine."Qty. per Unit of Measure") *
//                     SalesLine."Qty. to Invoice",0.00001);
//               BlanketOrderSalesLine."Qty. Invoiced (Base)" :=
//                 BlanketOrderSalesLine."Qty. Invoiced (Base)" + Sign * SalesLine."Qty. to Invoice (Base)";
//               ModifyLine := TRUE;
//             END;

//             IF ModifyLine THEN BEGIN
//               BlanketOrderSalesLine.InitOutstanding;
//               IF (BlanketOrderSalesLine.Quantity * BlanketOrderSalesLine."Quantity Shipped" < 0) OR
//                  (ABS(BlanketOrderSalesLine.Quantity) < ABS(BlanketOrderSalesLine."Quantity Shipped"))
//               THEN
//                 BlanketOrderSalesLine.FIELDERROR(
//                   "Quantity Shipped",STRSUBSTNO(
//                     Text018,
//                     BlanketOrderSalesLine.FIELDCAPTION(Quantity)));

//               IF (BlanketOrderSalesLine."Quantity (Base)" *
//                   BlanketOrderSalesLine."Qty. Shipped (Base)" < 0) OR
//                  (ABS(BlanketOrderSalesLine."Quantity (Base)") <
//                   ABS(BlanketOrderSalesLine."Qty. Shipped (Base)"))
//               THEN
//                 BlanketOrderSalesLine.FIELDERROR(
//                   "Qty. Shipped (Base)",
//                   STRSUBSTNO(
//                     Text018,
//                     BlanketOrderSalesLine.FIELDCAPTION("Quantity (Base)")));

//               BlanketOrderSalesLine.CALCFIELDS("Reserved Qty. (Base)");
//               IF ABS(BlanketOrderSalesLine."Outstanding Qty. (Base)") <
//                  ABS(BlanketOrderSalesLine."Reserved Qty. (Base)")
//               THEN
//                 BlanketOrderSalesLine.FIELDERROR(
//                   "Reserved Qty. (Base)",
//                   Text019);

//               BlanketOrderSalesLine."Qty. to Invoice" :=
//                 BlanketOrderSalesLine.Quantity - BlanketOrderSalesLine."Quantity Invoiced";
//               BlanketOrderSalesLine."Qty. to Ship" :=
//                 BlanketOrderSalesLine.Quantity - BlanketOrderSalesLine."Quantity Shipped";
//               BlanketOrderSalesLine."Qty. to Invoice (Base)" :=
//                 BlanketOrderSalesLine."Quantity (Base)" - BlanketOrderSalesLine."Qty. Invoiced (Base)";
//               BlanketOrderSalesLine."Qty. to Ship (Base)" :=
//                 BlanketOrderSalesLine."Quantity (Base)" - BlanketOrderSalesLine."Qty. Shipped (Base)";

//               BlanketOrderSalesLine.MODIFY;
//             END;
//           END;
//     end;

//     local procedure CopyCommentLines(FromDocumentType: Integer;ToDocumentType: Integer;FromNumber: Code[20];ToNumber: Code[20])
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

//     local procedure RunGenJnlPostLine(var GenJnlLine: Record "81"): Integer
//     begin
//         EXIT(GenJnlPostLine.RunWithCheck(GenJnlLine));
//     end;

//     local procedure CheckDim()
//     var
//         SalesLine2: Record "37";
//     begin
//         SalesLine2."Line No." := 0;
//         CheckDimValuePosting(SalesLine2);
//         CheckDimComb(SalesLine2);

//         SalesLine2.SETRANGE("Document Type",SalesHeader."Document Type");
//         SalesLine2.SETRANGE("Document No.",SalesHeader."No.");
//         SalesLine2.SETFILTER(Type,'<>%1',SalesLine2.Type::" ");
//         IF SalesLine2.FINDSET THEN
//           REPEAT
//             IF (SalesHeader.Invoice AND (SalesLine2."Qty. to Invoice" <> 0)) OR
//                (SalesHeader.Ship AND (SalesLine2."Qty. to Ship" <> 0)) OR
//                (SalesHeader.Receive AND (SalesLine2."Return Qty. to Receive" <> 0))
//             THEN BEGIN
//               CheckDimComb(SalesLine2);
//               CheckDimValuePosting(SalesLine2);
//             END
//           UNTIL SalesLine2.NEXT = 0;
//     end;

//     local procedure CheckDimComb(SalesLine: Record "37")
//     begin
//         IF SalesLine."Line No." = 0 THEN
//           IF NOT DimMgt.CheckDimIDComb(SalesHeader."Dimension Set ID") THEN
//             ERROR(
//               Text028,
//               SalesHeader."Document Type",SalesHeader."No.",DimMgt.GetDimCombErr);

//         IF SalesLine."Line No." <> 0 THEN
//           IF NOT DimMgt.CheckDimIDComb(SalesLine."Dimension Set ID") THEN
//             ERROR(
//               Text029,
//               SalesHeader."Document Type",SalesHeader."No.",SalesLine."Line No.",DimMgt.GetDimCombErr);
//     end;

//     local procedure CheckDimValuePosting(var SalesLine2: Record "37")
//     var
//         TableIDArr: array [10] of Integer;
//         NumberArr: array [10] of Code[20];
//     begin
//         IF SalesLine2."Line No." = 0 THEN BEGIN
//           TableIDArr[1] := DATABASE::Customer;
//           NumberArr[1] := SalesHeader."Bill-to Customer No.";
//           TableIDArr[2] := DATABASE::"Salesperson/Purchaser";
//           NumberArr[2] := SalesHeader."Salesperson Code";
//           TableIDArr[3] := DATABASE::Campaign;
//           NumberArr[3] := SalesHeader."Campaign No.";
//           TableIDArr[4] := DATABASE::"Responsibility Center";
//           NumberArr[4] := SalesHeader."Responsibility Center";
//           IF NOT DimMgt.CheckDimValuePosting(TableIDArr,NumberArr,SalesHeader."Dimension Set ID") THEN
//             ERROR(
//               Text030,
//               SalesHeader."Document Type",SalesHeader."No.",DimMgt.GetDimValuePostingErr);
//         END ELSE BEGIN
//           TableIDArr[1] := DimMgt.TypeToTableID3(SalesLine2.Type);
//           NumberArr[1] := SalesLine2."No.";
//           TableIDArr[2] := DATABASE::Job;
//           NumberArr[2] := SalesLine2."Job No.";
//           IF NOT DimMgt.CheckDimValuePosting(TableIDArr,NumberArr,SalesLine2."Dimension Set ID") THEN
//             ERROR(
//               Text031,
//               SalesHeader."Document Type",SalesHeader."No.",SalesLine2."Line No.",DimMgt.GetDimValuePostingErr);
//         END;
//     end;

//     procedure CopyAprvlToTempApprvl()
//     begin
//         TempApprovalEntry.RESET;
//         TempApprovalEntry.DELETEALL;
//         ApprovalEntry.SETRANGE("Table ID",DATABASE::"Sales Header");
//         ApprovalEntry.SETRANGE("Document Type",SalesHeader."Document Type");
//         ApprovalEntry.SETRANGE("Document No.",SalesHeader."No.");
//         IF ApprovalEntry.FINDSET THEN
//           REPEAT
//             TempApprovalEntry.INIT;
//             TempApprovalEntry := ApprovalEntry;
//             TempApprovalEntry.INSERT;
//           UNTIL ApprovalEntry.NEXT = 0;
//     end;

//     local procedure DeleteItemChargeAssgnt()
//     var
//         ItemChargeAssgntSales: Record "5809";
//     begin
//         ItemChargeAssgntSales.SETRANGE("Document Type",SalesLine."Document Type");
//         ItemChargeAssgntSales.SETRANGE("Document No.",SalesLine."Document No.");
//         IF NOT ItemChargeAssgntSales.ISEMPTY THEN
//           ItemChargeAssgntSales.DELETEALL;
//     end;

//     local procedure UpdateItemChargeAssgnt()
//     var
//         ItemChargeAssgntSales: Record "5809";
//     begin
//         WITH TempItemChargeAssgntSales DO BEGIN
//           ClearItemChargeAssgntFilter;
//           MARKEDONLY(TRUE);
//           IF FINDSET THEN
//             REPEAT
//               ItemChargeAssgntSales.GET("Document Type","Document No.","Document Line No.","Line No.");
//               ItemChargeAssgntSales."Qty. Assigned" :=
//                 ItemChargeAssgntSales."Qty. Assigned" + "Qty. to Assign";
//               ItemChargeAssgntSales."Qty. to Assign" := 0;
//               ItemChargeAssgntSales."Amount to Assign" := 0;
//               ItemChargeAssgntSales.MODIFY;
//             UNTIL NEXT = 0;
//         END;
//     end;

//     local procedure UpdateSalesOrderChargeAssgnt(SalesOrderInvLine: Record "37";SalesOrderLine: Record "37")
//     var
//         SalesOrderLine2: Record "37";
//         SalesOrderInvLine2: Record "37";
//         SalesShptLine: Record "111";
//     begin
//         WITH SalesOrderInvLine DO BEGIN
//           ClearItemChargeAssgntFilter;
//           TempItemChargeAssgntSales.SETRANGE("Document Type","Document Type");
//           TempItemChargeAssgntSales.SETRANGE("Document No.","Document No.");
//           TempItemChargeAssgntSales.SETRANGE("Document Line No.","Line No.");
//           TempItemChargeAssgntSales.MARKEDONLY(TRUE);
//           IF TempItemChargeAssgntSales.FINDSET THEN
//             REPEAT
//               IF TempItemChargeAssgntSales."Applies-to Doc. Type" = "Document Type" THEN BEGIN
//                 SalesOrderInvLine2.GET(
//                   TempItemChargeAssgntSales."Applies-to Doc. Type",
//                   TempItemChargeAssgntSales."Applies-to Doc. No.",
//                   TempItemChargeAssgntSales."Applies-to Doc. Line No.");
//                 IF ((SalesOrderLine."Document Type" = SalesOrderLine."Document Type"::Order) AND
//                     (SalesOrderInvLine2."Shipment No." = "Shipment No.")) OR
//                    ((SalesOrderLine."Document Type" = SalesOrderLine."Document Type"::"Return Order") AND
//                     (SalesOrderInvLine2."Return Receipt No." = "Return Receipt No."))
//                 THEN BEGIN
//                   IF SalesOrderLine."Document Type" = SalesOrderLine."Document Type"::Order THEN BEGIN
//                     IF NOT
//                        SalesShptLine.GET(SalesOrderInvLine2."Shipment No.",SalesOrderInvLine2."Shipment Line No.")
//                     THEN
//                       ERROR(Text013);
//                     SalesOrderLine2.GET(
//                       SalesOrderLine2."Document Type"::Order,
//                       SalesShptLine."Order No.",SalesShptLine."Order Line No.");
//                   END ELSE BEGIN
//                     IF NOT
//                        ReturnRcptLine.GET(SalesOrderInvLine2."Return Receipt No.",SalesOrderInvLine2."Return Receipt Line No.")
//                     THEN
//                       ERROR(Text037);
//                     SalesOrderLine2.GET(
//                       SalesOrderLine2."Document Type"::"Return Order",
//                       ReturnRcptLine."Return Order No.",ReturnRcptLine."Return Order Line No.");
//                   END;
//                   UpdateSalesChargeAssgntLines(
//                     SalesOrderLine,
//                     SalesOrderLine2."Document Type",
//                     SalesOrderLine2."Document No.",
//                     SalesOrderLine2."Line No.",
//                     TempItemChargeAssgntSales."Qty. to Assign");
//                 END;
//               END ELSE
//                 UpdateSalesChargeAssgntLines(
//                   SalesOrderLine,
//                   TempItemChargeAssgntSales."Applies-to Doc. Type",
//                   TempItemChargeAssgntSales."Applies-to Doc. No.",
//                   TempItemChargeAssgntSales."Applies-to Doc. Line No.",
//                   TempItemChargeAssgntSales."Qty. to Assign");
//             UNTIL TempItemChargeAssgntSales.NEXT = 0;
//         END;
//     end;

//     local procedure UpdateSalesChargeAssgntLines(SalesOrderLine: Record "37";ApplToDocType: Option;ApplToDocNo: Code[20];ApplToDocLineNo: Integer;QtyToAssign: Decimal)
//     var
//         ItemChargeAssgntSales: Record "5809";
//         TempItemChargeAssgntSales2: Record "5809";
//         LastLineNo: Integer;
//         TotalToAssign: Decimal;
//     begin
//         ItemChargeAssgntSales.SETRANGE("Document Type",SalesOrderLine."Document Type");
//         ItemChargeAssgntSales.SETRANGE("Document No.",SalesOrderLine."Document No.");
//         ItemChargeAssgntSales.SETRANGE("Document Line No.",SalesOrderLine."Line No.");
//         ItemChargeAssgntSales.SETRANGE("Applies-to Doc. Type",ApplToDocType);
//         ItemChargeAssgntSales.SETRANGE("Applies-to Doc. No.",ApplToDocNo);
//         ItemChargeAssgntSales.SETRANGE("Applies-to Doc. Line No.",ApplToDocLineNo);
//         IF ItemChargeAssgntSales.FINDFIRST THEN BEGIN
//           ItemChargeAssgntSales."Qty. Assigned" := ItemChargeAssgntSales."Qty. Assigned" + QtyToAssign;
//           ItemChargeAssgntSales."Qty. to Assign" := 0;
//           ItemChargeAssgntSales."Amount to Assign" := 0;
//           ItemChargeAssgntSales.MODIFY;
//         END ELSE BEGIN
//           ItemChargeAssgntSales.SETRANGE("Applies-to Doc. Type");
//           ItemChargeAssgntSales.SETRANGE("Applies-to Doc. No.");
//           ItemChargeAssgntSales.SETRANGE("Applies-to Doc. Line No.");
//           ItemChargeAssgntSales.CALCSUMS("Qty. to Assign");

//           // calculate total qty. to assign of the invoice charge line
//           TempItemChargeAssgntSales2.SETRANGE("Document Type",TempItemChargeAssgntSales."Document Type");
//           TempItemChargeAssgntSales2.SETRANGE("Document No.",TempItemChargeAssgntSales."Document No.");
//           TempItemChargeAssgntSales2.SETRANGE("Document Line No.",TempItemChargeAssgntSales."Document Line No.");
//           TempItemChargeAssgntSales2.CALCSUMS("Qty. to Assign");

//           TotalToAssign := ItemChargeAssgntSales."Qty. to Assign" +
//             TempItemChargeAssgntSales2."Qty. to Assign";

//           IF ItemChargeAssgntSales.FINDLAST THEN
//             LastLineNo := ItemChargeAssgntSales."Line No.";

//           IF SalesOrderLine.Quantity < TotalToAssign THEN
//             REPEAT
//               TotalToAssign := TotalToAssign - ItemChargeAssgntSales."Qty. to Assign";
//               ItemChargeAssgntSales."Qty. to Assign" := 0;
//               ItemChargeAssgntSales."Amount to Assign" := 0;
//               ItemChargeAssgntSales.MODIFY;
//             UNTIL (ItemChargeAssgntSales.NEXT(-1) = 0) OR
//                   (TotalToAssign = SalesOrderLine.Quantity);

//           InsertAssocOrderCharge(
//             SalesOrderLine,
//             ApplToDocType,
//             ApplToDocNo,
//             ApplToDocLineNo,
//             LastLineNo,
//             TempItemChargeAssgntSales."Applies-to Doc. Line Amount");
//         END;
//     end;

//     local procedure InsertAssocOrderCharge(SalesOrderLine: Record "37";ApplToDocType: Option;ApplToDocNo: Code[20];ApplToDocLineNo: Integer;LastLineNo: Integer;ApplToDocLineAmt: Decimal)
//     var
//         NewItemChargeAssgntSales: Record "5809";
//     begin
//         WITH NewItemChargeAssgntSales DO BEGIN
//           INIT;
//           "Document Type" := SalesOrderLine."Document Type";
//           "Document No." := SalesOrderLine."Document No.";
//           "Document Line No." := SalesOrderLine."Line No.";
//           "Line No." := LastLineNo + 10000;
//           "Item Charge No." := TempItemChargeAssgntSales."Item Charge No.";
//           "Item No." := TempItemChargeAssgntSales."Item No.";
//           "Qty. Assigned" := TempItemChargeAssgntSales."Qty. to Assign";
//           "Qty. to Assign" := 0;
//           "Amount to Assign" := 0;
//           Description := TempItemChargeAssgntSales.Description;
//           "Unit Cost" := TempItemChargeAssgntSales."Unit Cost";
//           "Applies-to Doc. Type" := ApplToDocType;
//           "Applies-to Doc. No." := ApplToDocNo;
//           "Applies-to Doc. Line No." := ApplToDocLineNo;
//           "Applies-to Doc. Line Amount" := ApplToDocLineAmt;
//           INSERT;
//         END;
//     end;

//     local procedure CopyAndCheckItemCharge(SalesHeader: Record "36")
//     var
//         SalesLine2: Record "37";
//         SalesLine3: Record "37";
//         InvoiceEverything: Boolean;
//         AssignError: Boolean;
//         QtyNeeded: Decimal;
//     begin
//         TempItemChargeAssgntSales.RESET;
//         TempItemChargeAssgntSales.DELETEALL;

//         // Check for max qty posting
//         SalesLine2.RESET;
//         SalesLine2.SETRANGE("Document Type",SalesHeader."Document Type");
//         SalesLine2.SETRANGE("Document No.",SalesHeader."No.");
//         SalesLine2.SETRANGE(Type,SalesLine2.Type::"Charge (Item)");
//         IF SalesLine2.ISEMPTY THEN
//           EXIT;

//         SalesLine2.FINDSET;
//         REPEAT
//           ItemChargeAssgntSales.RESET;
//           ItemChargeAssgntSales.SETRANGE("Document Type",SalesLine2."Document Type");
//           ItemChargeAssgntSales.SETRANGE("Document No.",SalesLine2."Document No.");
//           ItemChargeAssgntSales.SETRANGE("Document Line No.",SalesLine2."Line No.");
//           ItemChargeAssgntSales.SETFILTER("Qty. to Assign",'<>0');
//           IF ItemChargeAssgntSales.FINDSET THEN
//             REPEAT
//               TempItemChargeAssgntSales.INIT;
//               TempItemChargeAssgntSales := ItemChargeAssgntSales;
//               TempItemChargeAssgntSales.INSERT;
//             UNTIL ItemChargeAssgntSales.NEXT = 0;

//           IF SalesLine2."Qty. to Invoice" <> 0 THEN BEGIN
//             SalesLine.TESTFIELD("Job No.",'');
//             SalesLine2.TESTFIELD("Job Contract Entry No.",0);
//             IF (SalesLine2."Qty. to Ship" + SalesLine2."Return Qty. to Receive" <> 0) AND
//                ((SalesHeader.Ship OR SalesHeader.Receive) OR
//                 (ABS(SalesLine2."Qty. to Invoice") >
//                  ABS(SalesLine2."Qty. Shipped Not Invoiced" + SalesLine2."Qty. to Ship") +
//                  ABS(SalesLine2."Ret. Qty. Rcd. Not Invd.(Base)" + SalesLine2."Return Qty. to Receive")))
//             THEN
//               SalesLine2.TESTFIELD("Line Amount");

//             IF NOT SalesHeader.Ship THEN
//               SalesLine2."Qty. to Ship" := 0;
//             IF NOT SalesHeader.Receive THEN
//               SalesLine2."Return Qty. to Receive" := 0;
//             IF ABS(SalesLine2."Qty. to Invoice") >
//                ABS(SalesLine2."Quantity Shipped" + SalesLine2."Qty. to Ship" +
//                  SalesLine2."Return Qty. Received" + SalesLine2."Return Qty. to Receive" -
//                  SalesLine2."Quantity Invoiced")
//             THEN
//               SalesLine2."Qty. to Invoice" :=
//                 SalesLine2."Quantity Shipped" + SalesLine2."Qty. to Ship" +
//                 SalesLine2."Return Qty. Received" + SalesLine2."Return Qty. to Receive" -
//                 SalesLine2."Quantity Invoiced";

//             SalesLine2.CALCFIELDS("Qty. to Assign","Qty. Assigned");
//             IF ABS(SalesLine2."Qty. to Assign" + SalesLine2."Qty. Assigned") >
//                ABS(SalesLine2."Qty. to Invoice" + SalesLine2."Quantity Invoiced")
//             THEN
//               ERROR(Text032,
//                 SalesLine2."Qty. to Invoice" + SalesLine2."Quantity Invoiced" -
//                 SalesLine2."Qty. Assigned",SalesLine2.FIELDCAPTION("Document Type"),
//                 SalesLine2."Document Type",SalesLine2.FIELDCAPTION("Document No."),
//                 SalesLine2."Document No.",SalesLine2.FIELDCAPTION("Line No."),
//                 SalesLine2."Line No.");
//             IF SalesLine2.Quantity =
//                SalesLine2."Qty. to Invoice" + SalesLine2."Quantity Invoiced"
//             THEN BEGIN
//               IF SalesLine2."Qty. to Assign" <> 0 THEN BEGIN
//                 IF SalesLine2.Quantity = SalesLine2."Quantity Invoiced" THEN BEGIN
//                   TempItemChargeAssgntSales.SETRANGE("Document Line No.",SalesLine2."Line No.");
//                   TempItemChargeAssgntSales.SETRANGE("Applies-to Doc. Type",SalesLine2."Document Type");
//                   IF TempItemChargeAssgntSales.FINDSET THEN
//                     REPEAT
//                       SalesLine3.GET(
//                         TempItemChargeAssgntSales."Applies-to Doc. Type",
//                         TempItemChargeAssgntSales."Applies-to Doc. No.",
//                         TempItemChargeAssgntSales."Applies-to Doc. Line No.");
//                       IF SalesLine3.Quantity = SalesLine3."Quantity Invoiced" THEN
//                         ERROR(Text034,SalesLine3.TABLECAPTION,
//                           SalesLine3.FIELDCAPTION("Document Type"),SalesLine3."Document Type",
//                           SalesLine3.FIELDCAPTION("Document No."),SalesLine3."Document No.",
//                           SalesLine3.FIELDCAPTION("Line No."),SalesLine3."Line No.");
//                     UNTIL TempItemChargeAssgntSales.NEXT = 0;
//                 END;
//               END;
//               IF SalesLine2.Quantity <> SalesLine2."Qty. to Assign" + SalesLine2."Qty. Assigned" THEN
//                 AssignError := TRUE;
//             END;

//             IF (SalesLine2."Qty. to Assign" + SalesLine2."Qty. Assigned") <
//                (SalesLine2."Qty. to Invoice" + SalesLine2."Quantity Invoiced")
//             THEN
//               ERROR(Text052,SalesLine2."No.");

//             // check if all ILEs exist
//             QtyNeeded := SalesLine2."Qty. to Assign";
//             TempItemChargeAssgntSales.SETRANGE("Document Line No.",SalesLine2."Line No.");
//             IF TempItemChargeAssgntSales.FINDSET THEN
//               REPEAT
//                 IF (TempItemChargeAssgntSales."Applies-to Doc. Type" <> SalesLine2."Document Type") OR
//                    (TempItemChargeAssgntSales."Applies-to Doc. No." <> SalesLine2."Document No.")
//                 THEN
//                   QtyNeeded := QtyNeeded - TempItemChargeAssgntSales."Qty. to Assign"
//                 ELSE BEGIN
//                   SalesLine3.GET(
//                     TempItemChargeAssgntSales."Applies-to Doc. Type",
//                     TempItemChargeAssgntSales."Applies-to Doc. No.",
//                     TempItemChargeAssgntSales."Applies-to Doc. Line No.");
//                   IF ItemLedgerEntryExist(SalesLine3) THEN
//                     QtyNeeded := QtyNeeded - TempItemChargeAssgntSales."Qty. to Assign";
//                 END;
//               UNTIL TempItemChargeAssgntSales.NEXT = 0;

//             IF QtyNeeded > 0 THEN
//               ERROR(Text053,SalesLine2."No.");
//           END;
//         UNTIL SalesLine2.NEXT = 0;

//         // Check saleslines
//         IF AssignError THEN
//           IF SalesHeader."Document Type" IN
//              [SalesHeader."Document Type"::Invoice,SalesHeader."Document Type"::"Credit Memo"]
//           THEN
//             InvoiceEverything := TRUE
//           ELSE BEGIN
//             SalesLine2.RESET;
//             SalesLine2.SETRANGE("Document Type",SalesHeader."Document Type");
//             SalesLine2.SETRANGE("Document No.",SalesHeader."No.");
//             SalesLine2.SETFILTER(Type,'%1|%2',SalesLine2.Type::Item,SalesLine2.Type::"Charge (Item)");
//             IF SalesLine2.FINDSET THEN
//               REPEAT
//                 IF SalesHeader.Ship OR SalesHeader.Receive THEN
//                   InvoiceEverything :=
//                     SalesLine2.Quantity = SalesLine2."Qty. to Invoice" + SalesLine2."Quantity Invoiced"
//                 ELSE
//                   InvoiceEverything :=
//                     (SalesLine2.Quantity = SalesLine2."Qty. to Invoice" + SalesLine2."Quantity Invoiced") AND
//                     (SalesLine2."Qty. to Invoice" =
//                      SalesLine2."Qty. Shipped Not Invoiced" + SalesLine2."Ret. Qty. Rcd. Not Invd.(Base)");
//               UNTIL (SalesLine2.NEXT = 0) OR (NOT InvoiceEverything);
//           END;

//         IF InvoiceEverything AND AssignError THEN
//           ERROR(Text033);
//     end;

//     local procedure ClearItemChargeAssgntFilter()
//     begin
//         TempItemChargeAssgntSales.SETRANGE("Document Line No.");
//         TempItemChargeAssgntSales.SETRANGE("Applies-to Doc. Type");
//         TempItemChargeAssgntSales.SETRANGE("Applies-to Doc. No.");
//         TempItemChargeAssgntSales.SETRANGE("Applies-to Doc. Line No.");
//         TempItemChargeAssgntSales.MARKEDONLY(FALSE);
//     end;

//     local procedure GetItemChargeLine(var ItemChargeSalesLine: Record "37")
//     var
//         SalesShptLine: Record "111";
//         ReturnReceiptLine: Record "6661";
//         QtyShippedNotInvd: Decimal;
//         QtyReceivedNotInvd: Decimal;
//     begin
//         WITH TempItemChargeAssgntSales DO BEGIN
//           IF (ItemChargeSalesLine."Document Type" <> "Document Type") OR
//              (ItemChargeSalesLine."Document No." <> "Document No.") OR
//              (ItemChargeSalesLine."Line No." <> "Document Line No.")
//           THEN BEGIN
//             ItemChargeSalesLine.GET("Document Type","Document No.","Document Line No.");
//             IF NOT SalesHeader.Ship THEN
//               ItemChargeSalesLine."Qty. to Ship" := 0;
//             IF NOT SalesHeader.Receive THEN
//               ItemChargeSalesLine."Return Qty. to Receive" := 0;
//             IF ItemChargeSalesLine."Shipment No." <> '' THEN BEGIN
//               SalesShptLine.GET(ItemChargeSalesLine."Shipment No.",ItemChargeSalesLine."Shipment Line No.");
//               QtyShippedNotInvd := "Qty. to Assign" - "Qty. Assigned";
//             END ELSE
//               QtyShippedNotInvd := ItemChargeSalesLine."Quantity Shipped";
//             IF ItemChargeSalesLine."Return Receipt No." <> '' THEN BEGIN
//               ReturnReceiptLine.GET(ItemChargeSalesLine."Return Receipt No.",ItemChargeSalesLine."Return Receipt Line No.");
//               QtyReceivedNotInvd := "Qty. to Assign" - "Qty. Assigned";
//             END ELSE
//               QtyReceivedNotInvd := ItemChargeSalesLine."Return Qty. Received";
//             IF ABS(ItemChargeSalesLine."Qty. to Invoice") >
//                ABS(QtyShippedNotInvd + ItemChargeSalesLine."Qty. to Ship" +
//                  QtyReceivedNotInvd + ItemChargeSalesLine."Return Qty. to Receive" -
//                  ItemChargeSalesLine."Quantity Invoiced")
//             THEN
//               ItemChargeSalesLine."Qty. to Invoice" :=
//                 QtyShippedNotInvd + ItemChargeSalesLine."Qty. to Ship" +
//                 QtyReceivedNotInvd + ItemChargeSalesLine."Return Qty. to Receive" -
//                 ItemChargeSalesLine."Quantity Invoiced";
//           END;
//         END;
//     end;

//     local procedure OnlyAssgntPosting(): Boolean
//     var
//         SalesLine: Record "37";
//         QtyLeftToAssign: Boolean;
//     begin
//         WITH SalesHeader DO BEGIN
//           ItemChargeAssgntOnly := FALSE;
//           QtyLeftToAssign := FALSE;
//           SalesLine.SETRANGE("Document Type","Document Type");
//           SalesLine.SETRANGE("Document No.","No.");
//           SalesLine.SETRANGE(Type,SalesLine.Type::"Charge (Item)");
//           IF SalesLine.FINDSET THEN
//             REPEAT
//               SalesLine.CALCFIELDS("Qty. Assigned");
//               IF SalesLine."Quantity Invoiced" > SalesLine."Qty. Assigned" THEN
//                 QtyLeftToAssign := TRUE;
//             UNTIL SalesLine.NEXT = 0;

//           IF QtyLeftToAssign THEN
//             CopyAndCheckItemCharge(SalesHeader);
//           ClearItemChargeAssgntFilter;
//           TempItemChargeAssgntSales.SETCURRENTKEY("Applies-to Doc. Type");
//           TempItemChargeAssgntSales.SETFILTER("Applies-to Doc. Type",'<>%1',"Document Type");
//           SalesLine.SETRANGE(Type);
//           SalesLine.SETRANGE("Quantity Invoiced");
//           SalesLine.SETFILTER("Qty. to Assign",'<>0');
//           IF SalesLine.FINDSET THEN
//             REPEAT
//               TempItemChargeAssgntSales.SETRANGE("Document Line No.",SalesLine."Line No.");
//               ItemChargeAssgntOnly := NOT TempItemChargeAssgntSales.ISEMPTY;
//             UNTIL (SalesLine.NEXT = 0) OR ItemChargeAssgntOnly
//           ELSE
//             ItemChargeAssgntOnly := FALSE;
//         END;
//         EXIT(ItemChargeAssgntOnly);
//     end;

//     procedure CalcQtyToInvoice(QtyToHandle: Decimal;QtyToInvoice: Decimal): Decimal
//     begin
//         IF ABS(QtyToHandle) > ABS(QtyToInvoice) THEN
//           EXIT(-QtyToHandle);

//         EXIT(-QtyToInvoice);
//     end;

//     local procedure CheckWarehouse(var SalesLine: Record "37")
//     var
//         SalesLine2: Record "37";
//         WhseValidateSourceLine: Codeunit "5777";
//         ShowError: Boolean;
//     begin
//         SalesLine2.COPY(SalesLine);
//         SalesLine2.SETRANGE(Type,SalesLine2.Type::Item);
//         SalesLine2.SETRANGE("Drop Shipment",FALSE);
//         IF SalesLine2.FINDSET THEN
//           REPEAT
//             GetLocation(SalesLine2."Location Code");
//             CASE SalesLine2."Document Type" OF
//               SalesLine2."Document Type"::Order:
//                 IF ((Location."Require Receive" OR Location."Require Put-away") AND
//                     (SalesLine2.Quantity < 0)) OR
//                    ((Location."Require Shipment" OR Location."Require Pick") AND
//                     (SalesLine2.Quantity >= 0))
//                 THEN BEGIN
//                   IF Location."Directed Put-away and Pick" THEN
//                     ShowError := TRUE
//                   ELSE
//                     IF WhseValidateSourceLine.WhseLinesExist(
//                          DATABASE::"Sales Line",
//                          SalesLine2."Document Type",
//                          SalesLine2."Document No.",
//                          SalesLine2."Line No.",
//                          0,
//                          SalesLine2.Quantity)
//                     THEN
//                       ShowError := TRUE;
//                 END;
//               SalesLine2."Document Type"::"Return Order":
//                 IF ((Location."Require Receive" OR Location."Require Put-away") AND
//                     (SalesLine2.Quantity >= 0)) OR
//                    ((Location."Require Shipment" OR Location."Require Pick") AND
//                     (SalesLine2.Quantity < 0))
//                 THEN BEGIN
//                   IF Location."Directed Put-away and Pick" THEN
//                     ShowError := TRUE
//                   ELSE
//                     IF WhseValidateSourceLine.WhseLinesExist(
//                          DATABASE::"Sales Line",
//                          SalesLine2."Document Type",
//                          SalesLine2."Document No.",
//                          SalesLine2."Line No.",
//                          0,
//                          SalesLine2.Quantity)
//                     THEN
//                       ShowError := TRUE;
//                 END;
//               SalesLine2."Document Type"::Invoice,SalesLine2."Document Type"::"Credit Memo":
//                 IF Location."Directed Put-away and Pick" THEN
//                   Location.TESTFIELD("Adjustment Bin Code");
//             END;
//             IF ShowError THEN
//               ERROR(
//                 Text021,
//                 SalesLine2.FIELDCAPTION("Document Type"),
//                 SalesLine2."Document Type",
//                 SalesLine2.FIELDCAPTION("Document No."),
//                 SalesLine2."Document No.",
//                 SalesLine2.FIELDCAPTION("Line No."),
//                 SalesLine2."Line No.");
//           UNTIL SalesLine2.NEXT = 0;
//     end;

//     local procedure CreateWhseJnlLine(ItemJnlLine: Record "83";SalesLine: Record "37";var TempWhseJnlLine: Record "7311" temporary)
//     var
//         WhseMgt: Codeunit "5775";
//     begin
//         WITH SalesLine DO BEGIN
//           WMSMgmt.CheckAdjmtBin(Location,ItemJnlLine.Quantity,TRUE);
//           WMSMgmt.CreateWhseJnlLine(ItemJnlLine,0,TempWhseJnlLine,FALSE);
//           TempWhseJnlLine."Source Type" := DATABASE::"Sales Line";
//           TempWhseJnlLine."Source Subtype" := "Document Type";
//           TempWhseJnlLine."Source Code" := SrcCode;
//           TempWhseJnlLine."Source Document" := WhseMgt.GetSourceDocument(TempWhseJnlLine."Source Type",TempWhseJnlLine."Source Subtype");
//           TempWhseJnlLine."Source No." := "Document No.";
//           TempWhseJnlLine."Source Line No." := "Line No.";
//           CASE "Document Type" OF
//             "Document Type"::Order:
//               TempWhseJnlLine."Reference Document" :=
//                 TempWhseJnlLine."Reference Document"::"Posted Shipment";
//             "Document Type"::Invoice:
//               TempWhseJnlLine."Reference Document" :=
//                 TempWhseJnlLine."Reference Document"::"Posted S. Inv.";
//             "Document Type"::"Credit Memo":
//               TempWhseJnlLine."Reference Document" :=
//                 TempWhseJnlLine."Reference Document"::"Posted S. Cr. Memo";
//             "Document Type"::"Return Order":
//               TempWhseJnlLine."Reference Document" :=
//                 TempWhseJnlLine."Reference Document"::"Posted Rtrn. Shipment";
//           END;
//           TempWhseJnlLine."Reference No." := ItemJnlLine."Document No.";
//         END;
//     end;

//     local procedure WhseHandlingRequired(): Boolean
//     var
//         WhseSetup: Record "5769";
//     begin
//         IF (SalesLine.Type = SalesLine.Type::Item) AND
//            (NOT SalesLine."Drop Shipment")
//         THEN BEGIN
//           IF SalesLine."Location Code" = '' THEN BEGIN
//             WhseSetup.GET;
//             IF SalesLine."Document Type" = SalesLine."Document Type"::"Return Order" THEN
//               EXIT(WhseSetup."Require Receive");

//             EXIT(WhseSetup."Require Shipment");
//           END;

//           GetLocation(SalesLine."Location Code");
//           IF SalesLine."Document Type" = SalesLine."Document Type"::"Return Order" THEN
//             EXIT(Location."Require Receive");

//           EXIT(Location."Require Shipment");

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

//     local procedure InsertShptEntryRelation(var SalesShptLine: Record "111"): Integer
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
//             ItemEntryRelation.TransferFieldsSalesShptLine(SalesShptLine);
//             ItemEntryRelation.INSERT;
//           UNTIL TempHandlingSpecification.NEXT = 0;
//           TempHandlingSpecification.DELETEALL;
//           EXIT(0);
//         END;
//         EXIT(ItemLedgShptEntryNo);
//     end;

//     local procedure InsertReturnEntryRelation(var ReturnRcptLine: Record "6661"): Integer
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
//             ItemEntryRelation.TransferFieldsReturnRcptLine(ReturnRcptLine);
//             ItemEntryRelation.INSERT;
//           UNTIL TempHandlingSpecification.NEXT = 0;
//           TempHandlingSpecification.DELETEALL;
//           EXIT(0);
//         END;
//         EXIT(ItemLedgShptEntryNo);
//     end;

//     local procedure CheckTrackingSpecification(var SalesLine: Record "37")
//     var
//         SalesLineToCheck: Record "37";
//         ReservationEntry: Record "337";
//         ItemTrackingCode: Record "6502";
//         CreateReservEntry: Codeunit "99000830";
//         ItemTrackingManagement: Codeunit "6500";
//         ErrorFieldCaption: Text[250];
//         SignFactor: Integer;
//         SalesLineQtyHandled: Decimal;
//         SalesLineQtyToHandle: Decimal;
//         TrackingQtyHandled: Decimal;
//         TrackingQtyToHandle: Decimal;
//         Inbound: Boolean;
//         SNRequired: Boolean;
//         LotRequired: Boolean;
//         SNInfoRequired: Boolean;
//         LotInfoReguired: Boolean;
//         CheckSalesLine: Boolean;
//     begin
//         // if a SalesLine is posted with ItemTracking then the whole quantity of
//         // the regarding SalesLine has to be post with Item-Tracking

//         IF SalesHeader."Document Type" IN
//            [SalesHeader."Document Type"::Order,SalesHeader."Document Type"::"Return Order"] = FALSE
//         THEN
//           EXIT;

//         TrackingQtyToHandle := 0;
//         TrackingQtyHandled := 0;

//         SalesLineToCheck.COPY(SalesLine);
//         SalesLineToCheck.SETRANGE(Type,SalesLineToCheck.Type::Item);
//         IF SalesHeader.Ship THEN BEGIN
//           SalesLineToCheck.SETFILTER("Quantity Shipped",'<>%1',0);
//           ErrorFieldCaption := SalesLineToCheck.FIELDCAPTION("Qty. to Ship");
//         END ELSE BEGIN
//           SalesLineToCheck.SETFILTER("Return Qty. Received",'<>%1',0);
//           ErrorFieldCaption := SalesLineToCheck.FIELDCAPTION("Return Qty. to Receive");
//         END;

//         IF SalesLineToCheck.FINDSET THEN BEGIN
//           ReservationEntry."Source Type" := DATABASE::"Sales Line";
//           ReservationEntry."Source Subtype" := SalesHeader."Document Type";
//           SignFactor := CreateReservEntry.SignFactor(ReservationEntry);
//           REPEAT
//             // Only Item where no SerialNo or LotNo is required
//             GetItem(SalesLineToCheck);
//             IF Item."Item Tracking Code" <> '' THEN BEGIN
//               Inbound := (SalesLineToCheck.Quantity * SignFactor) > 0;
//               ItemTrackingCode.Code := Item."Item Tracking Code";
//               ItemTrackingManagement.GetItemTrackingSettings(ItemTrackingCode,
//                 ItemJnlLine."Entry Type"::Sale,
//                 Inbound,
//                 SNRequired,
//                 LotRequired,
//                 SNInfoRequired,
//                 LotInfoReguired);
//               CheckSalesLine := (SNRequired = FALSE) AND (LotRequired = FALSE);
//               IF CheckSalesLine THEN
//                 CheckSalesLine := GetTrackingQuantities(SalesLineToCheck,0,TrackingQtyToHandle,TrackingQtyHandled);
//             END ELSE
//               CheckSalesLine := FALSE;

//             TrackingQtyToHandle := 0;
//             TrackingQtyHandled := 0;

//             IF CheckSalesLine THEN BEGIN
//               GetTrackingQuantities(SalesLineToCheck,1,TrackingQtyToHandle,TrackingQtyHandled);
//               TrackingQtyToHandle := TrackingQtyToHandle * SignFactor;
//               TrackingQtyHandled := TrackingQtyHandled * SignFactor;
//               IF SalesHeader.Ship THEN BEGIN
//                 SalesLineQtyToHandle := SalesLineToCheck."Qty. to Ship (Base)";
//                 SalesLineQtyHandled := SalesLineToCheck."Qty. Shipped (Base)";
//               END ELSE BEGIN
//                 SalesLineQtyToHandle := SalesLineToCheck."Return Qty. to Receive (Base)";
//                 SalesLineQtyHandled := SalesLineToCheck."Return Qty. Received (Base)";
//               END;
//               IF ((TrackingQtyHandled + TrackingQtyToHandle) <> (SalesLineQtyHandled + SalesLineQtyToHandle)) OR
//                  (TrackingQtyToHandle <> SalesLineQtyToHandle)
//               THEN
//                 ERROR(STRSUBSTNO(Text046,ErrorFieldCaption));
//             END;
//           UNTIL SalesLineToCheck.NEXT = 0;
//         END;
//     end;

//     local procedure GetTrackingQuantities(SalesLine: Record "37";FunctionType: Option CheckTrackingExists,GetQty;var TrackingQtyToHandle: Decimal;var TrackingQtyHandled: Decimal): Boolean
//     var
//         TrackingSpecification: Record "336";
//         ReservEntry: Record "337";
//     begin
//         WITH TrackingSpecification DO BEGIN
//           SETCURRENTKEY("Source ID","Source Type","Source Subtype","Source Batch Name",
//             "Source Prod. Order Line","Source Ref. No.");
//           SETRANGE("Source Type",DATABASE::"Sales Line");
//           SETRANGE("Source Subtype",SalesLine."Document Type");
//           SETRANGE("Source ID",SalesLine."Document No.");
//           SETRANGE("Source Batch Name",'');
//           SETRANGE("Source Prod. Order Line",0);
//           SETRANGE("Source Ref. No.",SalesLine."Line No.");
//         END;
//         WITH ReservEntry DO BEGIN
//           SETCURRENTKEY(
//             "Source ID","Source Ref. No.","Source Type","Source Subtype",
//             "Source Batch Name","Source Prod. Order Line");
//           SETRANGE("Source ID",SalesLine."Document No.");
//           SETRANGE("Source Ref. No.",SalesLine."Line No.");
//           SETRANGE("Source Type",DATABASE::"Sales Line");
//           SETRANGE("Source Subtype",SalesLine."Document Type");
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
//             TrackingSpecification.Correction := FALSE;
//             TrackingSpecification.InitQtyToShip;
//             TrackingSpecification."Quantity actual Handled (Base)" := 0;
//             IF TempTrackingSpecification."Buffer Status" = TempTrackingSpecification."Buffer Status"::MODIFY THEN
//               TrackingSpecification.MODIFY
//             ELSE
//               TrackingSpecification.INSERT;
//           UNTIL TempTrackingSpecification.NEXT = 0;
//           TempTrackingSpecification.DELETEALL;
//         END;

//         ReserveSalesLine.UpdateItemTrackingAfterPosting(SalesHeader);
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

//     procedure PostItemCharge(var SalesLine: Record "37";ItemEntryNo: Integer;QuantityBase: Decimal;AmountToAssign: Decimal;QtyToAssign: Decimal)
//     var
//         DummyTrackingSpecification: Record "336";
//         SalesLineToPost: Record "37";
//     begin
//         WITH TempItemChargeAssgntSales DO BEGIN
//           SalesLineToPost := SalesLine;
//           SalesLineToPost."No." := "Item No.";
//           SalesLineToPost."Appl.-to Item Entry" := ItemEntryNo;
//           IF NOT ("Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"]) THEN
//             SalesLineToPost.Amount := -AmountToAssign
//           ELSE
//             SalesLineToPost.Amount := AmountToAssign;

//           IF SalesLineToPost."Currency Code" <> '' THEN
//             SalesLineToPost."Unit Cost" := ROUND(
//                 -SalesLineToPost.Amount / QuantityBase,Currency."Unit-Amount Rounding Precision")
//           ELSE
//             SalesLineToPost."Unit Cost" := ROUND(
//                 -SalesLineToPost.Amount / QuantityBase,GLSetup."Unit-Amount Rounding Precision");
//           TotalChargeAmt := TotalChargeAmt + SalesLineToPost.Amount;

//           IF SalesHeader."Currency Code" <> '' THEN
//             SalesLineToPost.Amount :=
//               CurrExchRate.ExchangeAmtFCYToLCY(
//                 UseDate,SalesHeader."Currency Code",TotalChargeAmt,SalesHeader."Currency Factor");
//           SalesLineToPost."Inv. Discount Amount" := ROUND(
//               SalesLine."Inv. Discount Amount" / SalesLine.Quantity * QtyToAssign,
//               GLSetup."Amount Rounding Precision");
//           SalesLineToPost."Line Discount Amount" := ROUND(
//               SalesLine."Line Discount Amount" / SalesLine.Quantity * QtyToAssign,
//               GLSetup."Amount Rounding Precision");
//           SalesLineToPost."Line Amount" := ROUND(
//               SalesLine."Line Amount" / SalesLine.Quantity * QtyToAssign,
//               GLSetup."Amount Rounding Precision");
//           UpdateSalesLineDimSetIDFromAppliedEntry(SalesLineToPost,SalesLine);
//           SalesLine."Inv. Discount Amount" := SalesLine."Inv. Discount Amount" - SalesLineToPost."Inv. Discount Amount";
//           SalesLine."Line Discount Amount" := SalesLine."Line Discount Amount" - SalesLineToPost."Line Discount Amount";
//           SalesLine."Line Amount" := SalesLine."Line Amount" - SalesLineToPost."Line Amount";
//           SalesLine.Quantity := SalesLine.Quantity - QtyToAssign;
//           SalesLineToPost.Amount := ROUND(SalesLineToPost.Amount,GLSetup."Amount Rounding Precision") - TotalChargeAmtLCY;
//           IF SalesHeader."Currency Code" <> '' THEN
//             TotalChargeAmtLCY := TotalChargeAmtLCY + SalesLineToPost.Amount;
//           SalesLineToPost."Unit Cost (LCY)" := ROUND(
//               SalesLineToPost.Amount / QuantityBase,GLSetup."Unit-Amount Rounding Precision");
//           SalesLineToPost."Line No." := "Document Line No.";
//           PostItemJnlLine(
//             SalesLineToPost,
//             0,0,-QuantityBase,-QuantityBase,
//             SalesLineToPost."Appl.-to Item Entry",
//             "Item Charge No.",DummyTrackingSpecification,FALSE);
//         END;
//     end;

//     local procedure SaveTempWhseSplitSpec(var SalesLine3: Record "37")
//     begin
//         TempWhseSplitSpecification.RESET;
//         TempWhseSplitSpecification.DELETEALL;
//         IF TempHandlingSpecification.FINDSET THEN
//           REPEAT
//             TempWhseSplitSpecification := TempHandlingSpecification;
//             TempWhseSplitSpecification."Source Type" := DATABASE::"Sales Line";
//             TempWhseSplitSpecification."Source Subtype" := SalesLine3."Document Type";
//             TempWhseSplitSpecification."Source ID" := SalesLine3."Document No.";
//             TempWhseSplitSpecification."Source Ref. No." := SalesLine3."Line No.";
//             TempWhseSplitSpecification.INSERT;
//           UNTIL TempHandlingSpecification.NEXT = 0;
//     end;

//     procedure TransferReservToItemJnlLine(var SalesOrderLine: Record "37";var ItemJnlLine: Record "83";QtyToBeShippedBase: Decimal;var TempTrackingSpecification2: Record "336" temporary;var CheckApplFromItemEntry: Boolean)
//     begin
//         // Handle Item Tracking and reservations, also on drop shipment
//         IF QtyToBeShippedBase = 0 THEN
//           EXIT;

//         CLEAR(ReserveSalesLine);
//         IF NOT SalesOrderLine."Drop Shipment" THEN
//           IF NOT HasSpecificTracking(SalesOrderLine."No.") AND HasInvtPickLine(SalesOrderLine) THEN
//             ReserveSalesLine.TransferSalesLineToItemJnlLine(
//               SalesOrderLine,ItemJnlLine,QtyToBeShippedBase,CheckApplFromItemEntry,TRUE)
//           ELSE
//             ReserveSalesLine.TransferSalesLineToItemJnlLine(
//               SalesOrderLine,ItemJnlLine,QtyToBeShippedBase,CheckApplFromItemEntry,FALSE)
//         ELSE BEGIN
//           TempTrackingSpecification2.RESET;
//           TempTrackingSpecification2.SETRANGE("Source Type",DATABASE::"Purchase Line");
//           TempTrackingSpecification2.SETRANGE("Source Subtype",1);
//           TempTrackingSpecification2.SETRANGE("Source ID",SalesOrderLine."Purchase Order No.");
//           TempTrackingSpecification2.SETRANGE("Source Batch Name",'');
//           TempTrackingSpecification2.SETRANGE("Source Prod. Order Line",0);
//           TempTrackingSpecification2.SETRANGE("Source Ref. No.",SalesOrderLine."Purch. Order Line No.");
//           IF TempTrackingSpecification2.ISEMPTY THEN
//             ReserveSalesLine.TransferSalesLineToItemJnlLine(
//               SalesOrderLine,ItemJnlLine,QtyToBeShippedBase,CheckApplFromItemEntry,FALSE)
//           ELSE BEGIN
//             ReserveSalesLine.SetApplySpecificItemTracking(TRUE);
//             ReserveSalesLine.SetOverruleItemTracking(TRUE);
//             ReserveSalesLine.SetItemTrkgAlreadyOverruled(ItemTrkgAlreadyOverruled);
//             TempTrackingSpecification2.FINDSET;
//             IF TempTrackingSpecification2."Quantity (Base)" / QtyToBeShippedBase < 0 THEN
//               ERROR(Text043);
//             REPEAT
//               ItemJnlLine."Serial No." := TempTrackingSpecification2."Serial No.";
//               ItemJnlLine."Lot No." := TempTrackingSpecification2."Lot No.";
//               ItemJnlLine."Applies-to Entry" := TempTrackingSpecification2."Item Ledger Entry No.";
//               ReserveSalesLine.TransferSalesLineToItemJnlLine(SalesOrderLine,ItemJnlLine,
//                 TempTrackingSpecification2."Quantity (Base)",CheckApplFromItemEntry,FALSE);
//             UNTIL TempTrackingSpecification2.NEXT = 0;
//             ItemJnlLine."Serial No." := '';
//             ItemJnlLine."Lot No." := '';
//             ItemJnlLine."Applies-to Entry" := 0;
//           END;
//         END;
//     end;

//     procedure TransferReservFromPurchLine(var PurchOrderLine: Record "39";var ItemJnlLine: Record "83";QtyToBeShippedBase: Decimal)
//     var
//         ReservEntry: Record "337";
//         TempTrackingSpecification2: Record "336" temporary;
//         ReservePurchLine: Codeunit "99000834";
//         RemainingQuantity: Decimal;
//         CheckApplToItemEntry: Boolean;
//     begin
//         // Handle Item Tracking on Drop Shipment
//         ItemTrkgAlreadyOverruled := FALSE;
//         IF QtyToBeShippedBase = 0 THEN
//           EXIT;

//         ReservEntry.SETCURRENTKEY(
//           "Source ID","Source Ref. No.","Source Type","Source Subtype",
//           "Source Batch Name","Source Prod. Order Line");
//         ReservEntry.SETRANGE("Source ID",SalesLine."Document No.");
//         ReservEntry.SETRANGE("Source Ref. No.",SalesLine."Line No.");
//         ReservEntry.SETRANGE("Source Type",DATABASE::"Sales Line");
//         ReservEntry.SETRANGE("Source Subtype",SalesLine."Document Type");
//         ReservEntry.SETRANGE("Source Batch Name",'');
//         ReservEntry.SETRANGE("Source Prod. Order Line",0);
//         ReservEntry.SETFILTER("Qty. to Handle (Base)",'<>0');
//         IF NOT ReservEntry.ISEMPTY THEN
//           ItemTrackingMgt.SumUpItemTracking(ReservEntry,TempTrackingSpecification2,FALSE,TRUE);
//         TempTrackingSpecification2.SETFILTER("Qty. to Handle (Base)",'<>0');
//         IF TempTrackingSpecification2.ISEMPTY THEN
//           ReservePurchLine.TransferPurchLineToItemJnlLine(
//             PurchOrderLine,ItemJnlLine,QtyToBeShippedBase,CheckApplToItemEntry)
//         ELSE BEGIN
//           ReservePurchLine.SetOverruleItemTracking(TRUE);
//           ItemTrkgAlreadyOverruled := TRUE;
//           TempTrackingSpecification2.FINDSET;
//           IF -TempTrackingSpecification2."Quantity (Base)" / QtyToBeShippedBase < 0 THEN
//             ERROR(Text043);
//           REPEAT
//             ItemJnlLine."Serial No." := TempTrackingSpecification2."Serial No.";
//             ItemJnlLine."Lot No." := TempTrackingSpecification2."Lot No.";
//             RemainingQuantity :=
//               ReservePurchLine.TransferPurchLineToItemJnlLine(
//                 PurchOrderLine,ItemJnlLine,
//                 -TempTrackingSpecification2."Qty. to Handle (Base)",CheckApplToItemEntry);
//             IF RemainingQuantity <> 0 THEN
//               ERROR(Text044);
//           UNTIL TempTrackingSpecification2.NEXT = 0;
//           ItemJnlLine."Serial No." := '';
//           ItemJnlLine."Lot No." := '';
//           ItemJnlLine."Applies-to Entry" := 0;
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

//     local procedure CopyPurchCommentLines(FromDocumentType: Integer;ToDocumentType: Integer;FromNumber: Code[20];ToNumber: Code[20])
//     var
//         PurchCommentLine: Record "43";
//         PurchCommentLine2: Record "43";
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

//     local procedure GetItem(SalesLine: Record "37")
//     begin
//         WITH SalesLine DO BEGIN
//           TESTFIELD(Type,Type::Item);
//           TESTFIELD("No.");
//           IF "No." <> Item."No." THEN
//             Item.GET("No.");
//         END;
//     end;

//     local procedure GetNextSalesline(var SalesLine: Record "37"): Boolean
//     begin
//         IF NOT SalesLinesProcessed THEN
//           IF SalesLine.NEXT = 1 THEN
//             EXIT(FALSE);
//         SalesLinesProcessed := TRUE;
//         IF TempPrepaymentSalesLine.FIND('-') THEN BEGIN
//           SalesLine := TempPrepaymentSalesLine;
//           TempPrepaymentSalesLine.DELETE;
//           EXIT(FALSE);
//         END;
//         EXIT(TRUE);
//     end;

//     procedure CreatePrepaymentLines(SalesHeader: Record "36";var TempPrepmtSalesLine: Record "37";CompleteFunctionality: Boolean)
//     var
//         GLAcc: Record "15";
//         SalesLine: Record "37";
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
//         WITH SalesLine DO BEGIN
//           SETRANGE("Document Type",SalesHeader."Document Type");
//           SETRANGE("Document No.",SalesHeader."No.");
//           IF NOT FIND('+') THEN
//             EXIT;
//           NextLineNo := "Line No." + 10000;
//           SETFILTER(Quantity,'>0');
//           SETFILTER("Qty. to Invoice",'>0');
//           TempPrepmtSalesLine.SetHasBeenShown;
//           IF FIND('-') THEN
//             REPEAT
//               IF CompleteFunctionality THEN BEGIN
//                 IF SalesHeader."Document Type" <> SalesHeader."Document Type"::Invoice THEN BEGIN
//                   IF NOT SalesHeader.Ship AND ("Qty. to Invoice" = Quantity - "Quantity Invoiced") THEN
//                     IF "Qty. Shipped Not Invoiced" < "Qty. to Invoice" THEN
//                       VALIDATE("Qty. to Invoice","Qty. Shipped Not Invoiced");
//                   Fraction := ("Qty. to Invoice" + "Quantity Invoiced") / Quantity;

//                   IF "Prepayment %" <> 100 THEN
//                     CASE TRUE OF
//                       ("Prepmt Amt to Deduct" <> 0) AND
//                       ("Prepmt Amt to Deduct" > ROUND(Fraction * "Line Amount",Currency."Amount Rounding Precision")):
//                         FIELDERROR(
//                           "Prepmt Amt to Deduct",
//                           STRSUBSTNO(Text047,
//                             ROUND(Fraction * "Line Amount",Currency."Amount Rounding Precision")));
//                       ("Prepmt. Amt. Inv." <> 0) AND
//                       (ROUND((1 - Fraction) * "Line Amount",Currency."Amount Rounding Precision") <
//                        ROUND(
//                          ROUND(
//                            ROUND("Unit Price" * (Quantity - "Quantity Invoiced" - "Qty. to Invoice"),Currency."Amount Rounding Precision") *
//                            (1 - ("Line Discount %" / 100)),Currency."Amount Rounding Precision") *
//                          "Prepayment %" / 100,Currency."Amount Rounding Precision")):
//                         FIELDERROR(
//                           "Prepmt Amt to Deduct",
//                           STRSUBSTNO(Text048,
//                             ROUND(
//                               "Prepmt. Amt. Inv." - "Prepmt Amt Deducted" - (1 - Fraction) * "Line Amount",
//                               Currency."Amount Rounding Precision")));
//                     END;
//                 END ELSE
//                   IF NOT PrePmtTestRun THEN BEGIN
//                     TestGetShipmentPPmtAmtToDeduct(SalesHeader);
//                     PrePmtTestRun := TRUE;
//                   END;
//               END;
//               IF "Prepmt Amt to Deduct" <> 0 THEN BEGIN
//                 IF ("Gen. Bus. Posting Group" <> GenPostingSetup."Gen. Bus. Posting Group") OR
//                    ("Gen. Prod. Posting Group" <> GenPostingSetup."Gen. Prod. Posting Group")
//                 THEN BEGIN
//                   GenPostingSetup.GET("Gen. Bus. Posting Group","Gen. Prod. Posting Group");
//                   GenPostingSetup.TESTFIELD("Sales Prepayments Account");
//                 END;
//                 GLAcc.GET(GenPostingSetup."Sales Prepayments Account");
//                 TempLineFound := FALSE;
//                 IF SalesHeader."Compress Prepayment" THEN BEGIN
//                   TempPrepmtSalesLine.SETRANGE("No.",GLAcc."No.");
//                   TempPrepmtSalesLine.SETRANGE("Dimension Set ID","Dimension Set ID");
//                   TempLineFound := TempPrepmtSalesLine.FINDFIRST;
//                 END;
//                 IF TempLineFound THEN BEGIN
//                   PrepmtAmtToDeduct :=
//                     TempPrepmtSalesLine."Prepmt Amt to Deduct" +
//                     InsertedPrepmtVATBaseToDeduct(SalesLine,TempPrepmtSalesLine."Line No.",TempPrepmtSalesLine."Unit Price");
//                   VATDifference := TempPrepmtSalesLine."VAT Difference";
//                   TempPrepmtSalesLine.VALIDATE(
//                     "Unit Price",TempPrepmtSalesLine."Unit Price" + "Prepmt Amt to Deduct");
//                   TempPrepmtSalesLine.VALIDATE("VAT Difference",VATDifference - "Prepmt VAT Diff. to Deduct");
//                   TempPrepmtSalesLine."Prepmt Amt to Deduct" := PrepmtAmtToDeduct;
//                   IF "Prepayment %" < TempPrepmtSalesLine."Prepayment %" THEN
//                     TempPrepmtSalesLine."Prepayment %" := "Prepayment %";
//                   TempPrepmtSalesLine.MODIFY;
//                 END ELSE BEGIN
//                   TempPrepmtSalesLine.INIT;
//                   TempPrepmtSalesLine."Document Type" := SalesHeader."Document Type";
//                   TempPrepmtSalesLine."Document No." := SalesHeader."No.";
//                   TempPrepmtSalesLine."Line No." := 0;
//                   TempPrepmtSalesLine."System-Created Entry" := TRUE;
//                   IF CompleteFunctionality THEN
//                     TempPrepmtSalesLine.VALIDATE(Type,TempPrepmtSalesLine.Type::"G/L Account")
//                   ELSE
//                     TempPrepmtSalesLine.Type := TempPrepmtSalesLine.Type::"G/L Account";
//                   TempPrepmtSalesLine.VALIDATE("No.",GenPostingSetup."Sales Prepayments Account");
//                   TempPrepmtSalesLine.VALIDATE(Quantity,-1);
//                   TempPrepmtSalesLine."Qty. to Ship" := TempPrepmtSalesLine.Quantity;
//                   TempPrepmtSalesLine."Qty. to Invoice" := TempPrepmtSalesLine.Quantity;
//                   PrepmtAmtToDeduct := InsertedPrepmtVATBaseToDeduct(SalesLine,NextLineNo,0);
//                   TempPrepmtSalesLine.VALIDATE("Unit Price","Prepmt Amt to Deduct");
//                   TempPrepmtSalesLine.VALIDATE("VAT Difference",-"Prepmt VAT Diff. to Deduct");
//                   TempPrepmtSalesLine."Prepmt Amt to Deduct" := PrepmtAmtToDeduct;
//                   TempPrepmtSalesLine."Prepayment %" := "Prepayment %";
//                   TempPrepmtSalesLine."Prepayment Line" := TRUE;
//                   TempPrepmtSalesLine."Shortcut Dimension 1 Code" := "Shortcut Dimension 1 Code";
//                   TempPrepmtSalesLine."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
//                   TempPrepmtSalesLine."Dimension Set ID" := "Dimension Set ID";
//                   TempPrepmtSalesLine."Line No." := NextLineNo;
//                   NextLineNo := NextLineNo + 10000;
//                   TempPrepmtSalesLine.INSERT;

//                   TransferExtText.PrepmtGetAnyExtText(
//                     TempPrepmtSalesLine."No.",DATABASE::"Sales Invoice Line",
//                     SalesHeader."Document Date",SalesHeader."Language Code",TempExtTextLine);
//                   IF TempExtTextLine.FIND('-') THEN
//                     REPEAT
//                       TempPrepmtSalesLine.INIT;
//                       TempPrepmtSalesLine.Description := TempExtTextLine.Text;
//                       TempPrepmtSalesLine."System-Created Entry" := TRUE;
//                       TempPrepmtSalesLine."Prepayment Line" := TRUE;
//                       TempPrepmtSalesLine."Line No." := NextLineNo;
//                       NextLineNo := NextLineNo + 10000;
//                       TempPrepmtSalesLine.INSERT;
//                     UNTIL TempExtTextLine.NEXT = 0;
//                 END;
//               END;
//             UNTIL NEXT = 0
//         END;
//         DividePrepmtAmountLCY(TempPrepmtSalesLine,SalesHeader);
//     end;

//     local procedure InsertedPrepmtVATBaseToDeduct(SalesLine: Record "37";PrepmtLineNo: Integer;TotalPrepmtAmtToDeduct: Decimal): Decimal
//     var
//         PrepmtVATBaseToDeduct: Decimal;
//     begin
//         WITH SalesLine DO BEGIN
//           IF SalesHeader."Prices Including VAT" THEN
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
//         WITH TempPrepmtDeductLCYSalesLine DO BEGIN
//           TempPrepmtDeductLCYSalesLine := SalesLine;
//           IF "Document Type" = "Document Type"::Order THEN
//             "Qty. to Invoice" := GetQtyToInvoice(SalesLine)
//           ELSE
//             GetLineDataFromOrder(TempPrepmtDeductLCYSalesLine);
//           CalcPrepaymentToDeduct;
//           "Line Amount" := GetLineAmountToHandle("Qty. to Invoice");
//           "Attached to Line No." := PrepmtLineNo;
//           "VAT Base Amount" := PrepmtVATBaseToDeduct;
//           INSERT;
//         END;
//         EXIT(PrepmtVATBaseToDeduct);
//     end;

//     local procedure DividePrepmtAmountLCY(var PrepmtSalesLine: Record "37";SalesHeader: Record "36")
//     var
//         ActualCurrencyFactor: Decimal;
//     begin
//         WITH PrepmtSalesLine DO BEGIN
//           RESET;
//           SETFILTER(Type,'<>%1',Type::" ");
//           IF FINDSET THEN
//             REPEAT
//               IF SalesHeader."Currency Code" <> '' THEN
//                 ActualCurrencyFactor :=
//                   ROUND(
//                     CurrExchRate.ExchangeAmtFCYToLCY(
//                       SalesHeader."Posting Date",
//                       SalesHeader."Currency Code",
//                       "Prepmt Amt to Deduct",
//                       SalesHeader."Currency Factor")) /
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
//         WITH TempPrepmtDeductLCYSalesLine DO BEGIN
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

//     local procedure AdjustPrepmtAmountLCY(var PrepmtSalesLine: Record "37")
//     var
//         SalesLine: Record "37";
//         SalesInvoiceLine: Record "37";
//         DeductionFactor: Decimal;
//         PrepmtVATPart: Decimal;
//         PrepmtVATAmtRemainder: Decimal;
//         TotalRoundingAmount: array [2] of Decimal;
//         TotalPrepmtAmount: array [2] of Decimal;
//         FinalInvoice: Boolean;
//         PricesInclVATRoundingAmount: array [2] of Decimal;
//     begin
//         IF PrepmtSalesLine."Prepayment Line" THEN BEGIN
//           PrepmtVATPart :=
//             (PrepmtSalesLine."Amount Including VAT" - PrepmtSalesLine.Amount) / PrepmtSalesLine."Unit Price";

//           WITH TempPrepmtDeductLCYSalesLine DO BEGIN
//             RESET;
//             SETRANGE("Attached to Line No.",PrepmtSalesLine."Line No.");
//             IF FINDSET(TRUE) THEN BEGIN
//               FinalInvoice := IsFinalInvoice;
//               REPEAT
//                 SalesLine := TempPrepmtDeductLCYSalesLine;
//                 SalesLine.FIND;
//                 IF "Document Type" = "Document Type"::Invoice THEN BEGIN
//                   SalesInvoiceLine := SalesLine;
//                   GetSalesOrderLine(SalesLine,SalesInvoiceLine);
//                   SalesLine."Qty. to Invoice" := SalesInvoiceLine."Qty. to Invoice";
//                 END;
//                 SalesLine."Prepmt Amt to Deduct" := CalcPrepmtAmtToDeduct(SalesLine);
//                 DeductionFactor :=
//                   SalesLine."Prepmt Amt to Deduct" /
//                   (SalesLine."Prepmt. Amt. Inv." - SalesLine."Prepmt Amt Deducted");

//                 "Prepmt. VAT Amount Inv. (LCY)" :=
//                   CalcRoundedAmount(SalesLine."Prepmt Amt to Deduct" * PrepmtVATPart,PrepmtVATAmtRemainder);
//                 IF ("Prepayment %" <> 100) OR IsFinalInvoice THEN
//                   CalcPrepmtRoundingAmounts(TempPrepmtDeductLCYSalesLine,SalesLine,DeductionFactor,TotalRoundingAmount);
//                 MODIFY;

//                 IF SalesHeader."Prices Including VAT" THEN
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

//           UpdatePrepmtSalesLineWithRounding(
//             PrepmtSalesLine,TotalRoundingAmount,TotalPrepmtAmount,
//             FinalInvoice,PricesInclVATRoundingAmount);
//         END;
//     end;

//     procedure CalcPrepmtAmtToDeduct(SalesLine: Record "37"): Decimal
//     begin
//         WITH SalesLine DO BEGIN
//           "Qty. to Invoice" := GetQtyToInvoice(SalesLine);
//           CalcPrepaymentToDeduct;
//           EXIT("Prepmt Amt to Deduct");
//         END;
//     end;

//     local procedure GetQtyToInvoice(SalesLine: Record "37"): Decimal
//     var
//         AllowedQtyToInvoice: Decimal;
//     begin
//         WITH SalesLine DO BEGIN
//           AllowedQtyToInvoice := "Qty. Shipped Not Invoiced";
//           IF SalesHeader.Ship THEN
//             AllowedQtyToInvoice := AllowedQtyToInvoice + "Qty. to Ship";
//           IF "Qty. to Invoice" > AllowedQtyToInvoice THEN
//             EXIT(AllowedQtyToInvoice);
//           EXIT("Qty. to Invoice");
//         END;
//     end;

//     local procedure GetLineDataFromOrder(var SalesLine: Record "37")
//     var
//         SalesShptLine: Record "111";
//         SalesOrderLine: Record "37";
//     begin
//         WITH SalesLine DO BEGIN
//           SalesShptLine.GET("Shipment No.","Shipment Line No.");
//           SalesOrderLine.GET("Document Type"::Order,SalesShptLine."Order No.",SalesShptLine."Order Line No.");

//           Quantity := SalesOrderLine.Quantity;
//           "Qty. Shipped Not Invoiced" := SalesOrderLine."Qty. Shipped Not Invoiced";
//           "Quantity Invoiced" := SalesOrderLine."Quantity Invoiced";
//           "Prepmt Amt Deducted" := SalesOrderLine."Prepmt Amt Deducted";
//           "Prepmt. Amt. Inv." := SalesOrderLine."Prepmt. Amt. Inv.";
//           "Line Discount Amount" := SalesOrderLine."Line Discount Amount";
//         END;
//     end;

//     local procedure CalcPrepmtRoundingAmounts(var PrepmtSalesLineBuf: Record "37";SalesLine: Record "37";DeductionFactor: Decimal;var TotalRoundingAmount: array [2] of Decimal)
//     var
//         RoundingAmount: array [2] of Decimal;
//     begin
//         WITH PrepmtSalesLineBuf DO BEGIN
//           RoundingAmount[1] :=
//             "Prepmt. Amount Inv. (LCY)" - ROUND(DeductionFactor * SalesLine."Prepmt. Amount Inv. (LCY)");
//           "Prepmt. Amount Inv. (LCY)" := "Prepmt. Amount Inv. (LCY)" - RoundingAmount[1];
//           TotalRoundingAmount[1] += RoundingAmount[1];

//           RoundingAmount[2] :=
//             "Prepmt. VAT Amount Inv. (LCY)" - ROUND(DeductionFactor * SalesLine."Prepmt. VAT Amount Inv. (LCY)");
//           "Prepmt. VAT Amount Inv. (LCY)" := "Prepmt. VAT Amount Inv. (LCY)" - RoundingAmount[2];
//           TotalRoundingAmount[2] += RoundingAmount[2];
//         END;
//     end;

//     local procedure UpdatePrepmtSalesLineWithRounding(var PrepmtSalesLine: Record "37";TotalRoundingAmount: array [2] of Decimal;TotalPrepmtAmount: array [2] of Decimal;FinalInvoice: Boolean;PricesInclVATRoundingAmount: array [2] of Decimal)
//     var
//         NewAmountIncludingVAT: Decimal;
//         Prepmt100PctVATRoundingAmt: Decimal;
//     begin
//         WITH PrepmtSalesLine DO BEGIN
//           IF ABS(TotalRoundingAmount[1]) <= GLSetup."Amount Rounding Precision" THEN BEGIN
//             IF "Prepayment %" = 100 THEN
//               Prepmt100PctVATRoundingAmt := TotalRoundingAmount[1];
//             TotalRoundingAmount[1] := 0;
//           END;
//           "Prepmt. Amount Inv. (LCY)" := TotalRoundingAmount[1];
//           Amount := TotalPrepmtAmount[1] + TotalRoundingAmount[1];

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

//           "Prepmt. VAT Amount Inv. (LCY)" := TotalRoundingAmount[2] + Prepmt100PctVATRoundingAmt;
//           NewAmountIncludingVAT := Amount + TotalPrepmtAmount[2] + TotalRoundingAmount[2];
//           IF (PricesInclVATRoundingAmount[1] = 0) AND (PricesInclVATRoundingAmount[2] = 0) THEN
//             Increment(
//               TotalSalesLineLCY."Amount Including VAT",
//               "Amount Including VAT" - NewAmountIncludingVAT - Prepmt100PctVATRoundingAmt);
//           IF "Currency Code" = '' THEN
//             TotalSalesLine."Amount Including VAT" := TotalSalesLineLCY."Amount Including VAT";
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

//     local procedure GetSalesOrderLine(var SalesOrderLine: Record "37";SalesLine: Record "37")
//     begin
//         SalesShptLine.GET(SalesLine."Shipment No.",SalesLine."Shipment Line No.");
//         SalesOrderLine.GET(
//           SalesOrderLine."Document Type"::Order,
//           SalesShptLine."Order No.",SalesShptLine."Order Line No.");
//         SalesOrderLine."Prepmt Amt to Deduct" := SalesLine."Prepmt Amt to Deduct";
//     end;

//     local procedure DecrementPrepmtAmtInvLCY(SalesLine: Record "37";var PrepmtAmountInvLCY: Decimal;var PrepmtVATAmountInvLCY: Decimal)
//     begin
//         TempPrepmtDeductLCYSalesLine.RESET;
//         TempPrepmtDeductLCYSalesLine := SalesLine;
//         IF TempPrepmtDeductLCYSalesLine.FIND THEN BEGIN
//           PrepmtAmountInvLCY := PrepmtAmountInvLCY - TempPrepmtDeductLCYSalesLine."Prepmt. Amount Inv. (LCY)";
//           PrepmtVATAmountInvLCY := PrepmtVATAmountInvLCY - TempPrepmtDeductLCYSalesLine."Prepmt. VAT Amount Inv. (LCY)";
//         END;
//     end;

//     local procedure AdjustFinalInvWith100PctPrepmt(var TempSalesLine: Record "37" temporary)
//     var
//         DiffToLineDiscAmt: Decimal;
//     begin
//         WITH TempPrepmtDeductLCYSalesLine DO BEGIN
//           RESET;
//           SETRANGE("Prepayment %",100);
//           IF FINDSET(TRUE) THEN
//             REPEAT
//               IF IsFinalInvoice THEN BEGIN
//                 DiffToLineDiscAmt := "Prepmt Amt to Deduct" - "Line Amount";
//                 IF "Document Type" = "Document Type"::Order THEN
//                   DiffToLineDiscAmt := DiffToLineDiscAmt * Quantity / "Qty. to Invoice";
//                 IF DiffToLineDiscAmt <> 0 THEN BEGIN
//                   TempSalesLine.GET("Document Type","Document No.","Line No.");
//                   TempSalesLine."Line Discount Amount" -= DiffToLineDiscAmt;
//                   TempSalesLine.MODIFY;

//                   "Line Discount Amount" := TempSalesLine."Line Discount Amount";
//                   MODIFY;
//                 END;
//               END;
//             UNTIL NEXT = 0;
//           RESET;
//         END;
//     end;

//     local procedure GetPrepmtDiffToLineAmount(SalesLine: Record "37"): Decimal
//     begin
//         WITH TempPrepmtDeductLCYSalesLine DO
//           IF SalesLine."Prepayment %" = 100 THEN
//             IF GET(SalesLine."Document Type",SalesLine."Document No.",SalesLine."Line No.") THEN
//               EXIT("Prepmt Amt to Deduct" - "Line Amount");
//         EXIT(0);
//     end;

//     procedure MergeSaleslines(SalesHeader: Record "36";var Salesline: Record "37";var Salesline2: Record "37";var MergedSalesline: Record "37")
//     begin
//         WITH Salesline DO BEGIN
//           SETRANGE("Document Type",SalesHeader."Document Type");
//           SETRANGE("Document No.",SalesHeader."No.");
//           IF FIND('-') THEN
//             REPEAT
//               MergedSalesline := Salesline;
//               MergedSalesline.INSERT;
//             UNTIL NEXT = 0;
//         END;
//         WITH Salesline2 DO BEGIN
//           SETRANGE("Document Type",SalesHeader."Document Type");
//           SETRANGE("Document No.",SalesHeader."No.");
//           IF FIND('-') THEN
//             REPEAT
//               MergedSalesline := Salesline2;
//               MergedSalesline.INSERT;
//             UNTIL NEXT = 0;
//         END;
//     end;

//     procedure PostJobContractLine(SalesLine: Record "37"): Integer
//     begin
//         IF SalesLine."Job Contract Entry No." = 0 THEN
//           EXIT;
//         IF (SalesHeader."Document Type" <> SalesHeader."Document Type"::Invoice) AND
//            (SalesHeader."Document Type" <> SalesHeader."Document Type"::"Credit Memo")
//         THEN
//           SalesLine.TESTFIELD("Job Contract Entry No.",0);

//         SalesLine.TESTFIELD("Job No.");
//         SalesLine.TESTFIELD("Job Task No.");

//         IF SalesHeader."Document Type" = SalesHeader."Document Type"::Invoice THEN
//           SalesLine."Document No." := SalesInvHeader."No.";
//         IF SalesHeader."Document Type" = SalesHeader."Document Type"::"Credit Memo" THEN
//           SalesLine."Document No." := SalesCrMemoHeader."No.";
//         JobContractLine := TRUE;
//         EXIT(JobPostLine.PostInvoiceContractLine(SalesHeader,SalesLine));
//     end;

//     local procedure InsertICGenJnlLine(SalesLine: Record "37")
//     var
//         ICGLAccount: Record "410";
//         Vend: Record "23";
//         ICPartner: Record "413";
//     begin
//         SalesHeader.TESTFIELD("Sell-to IC Partner Code",'');
//         SalesHeader.TESTFIELD("Bill-to IC Partner Code",'');
//         SalesLine.TESTFIELD("IC Partner Ref. Type",SalesLine."IC Partner Ref. Type"::"G/L Account");
//         ICGLAccount.GET(SalesLine."IC Partner Reference");
//         ICGenJnlLineNo := ICGenJnlLineNo + 1;
//         TempICGenJnlLine.INIT;
//         TempICGenJnlLine."Line No." := ICGenJnlLineNo;
//         TempICGenJnlLine.VALIDATE("Posting Date",SalesHeader."Posting Date");
//         TempICGenJnlLine."Document Date" := SalesHeader."Document Date";
//         TempICGenJnlLine.Description := SalesHeader."Posting Description";
//         TempICGenJnlLine."Reason Code" := SalesHeader."Reason Code";
//         TempICGenJnlLine."Document Type" := GenJnlLineDocType;
//         TempICGenJnlLine."Document No." := GenJnlLineDocNo;
//         TempICGenJnlLine."External Document No." := GenJnlLineExtDocNo;
//         TempICGenJnlLine.VALIDATE("Account Type",TempICGenJnlLine."Account Type"::"IC Partner");
//         TempICGenJnlLine.VALIDATE("Account No.",SalesLine."IC Partner Code");
//         TempICGenJnlLine."Source Currency Code" := SalesHeader."Currency Code";
//         TempICGenJnlLine."Source Currency Amount" := TempICGenJnlLine.Amount;
//         TempICGenJnlLine.Correction := SalesHeader.Correction;
//         TempICGenJnlLine."Source Code" := SrcCode;
//         TempICGenJnlLine."Country/Region Code" := SalesHeader."VAT Country/Region Code";
//         TempICGenJnlLine."Source Type" := GenJnlLine."Source Type"::Customer;
//         TempICGenJnlLine."Source No." := SalesHeader."Bill-to Customer No.";
//         TempICGenJnlLine."Source Line No." := SalesLine."Line No.";
//         TempICGenJnlLine."Posting No. Series" := SalesHeader."Posting No. Series";
//         TempICGenJnlLine.VALIDATE("Bal. Account Type",TempICGenJnlLine."Bal. Account Type"::"G/L Account");
//         TempICGenJnlLine.VALIDATE("Bal. Account No.",SalesLine."No.");
//         TempICGenJnlLine."Shortcut Dimension 1 Code" := SalesLine."Shortcut Dimension 1 Code";
//         TempICGenJnlLine."Shortcut Dimension 2 Code" := SalesLine."Shortcut Dimension 2 Code";
//         TempICGenJnlLine."Dimension Set ID" := SalesLine."Dimension Set ID";
//         Vend.SETRANGE("IC Partner Code",SalesLine."IC Partner Code");
//         IF Vend.FINDFIRST THEN BEGIN
//           TempICGenJnlLine.VALIDATE("Bal. Gen. Bus. Posting Group",Vend."Gen. Bus. Posting Group");
//           TempICGenJnlLine.VALIDATE("Bal. VAT Bus. Posting Group",Vend."VAT Bus. Posting Group");
//         END;
//         TempICGenJnlLine.VALIDATE("Bal. VAT Prod. Posting Group",SalesLine."VAT Prod. Posting Group");
//         TempICGenJnlLine."IC Partner Code" := SalesLine."IC Partner Code";
//         TempICGenJnlLine."IC Partner G/L Acc. No." := SalesLine."IC Partner Reference";
//         TempICGenJnlLine."IC Direction" := TempICGenJnlLine."IC Direction"::Outgoing;
//         ICPartner.GET(SalesLine."IC Partner Code");
//         IF ICPartner."Cost Distribution in LCY" AND (SalesLine."Currency Code" <> '') THEN BEGIN
//           TempICGenJnlLine."Currency Code" := '';
//           TempICGenJnlLine."Currency Factor" := 0;
//           Currency.GET(SalesLine."Currency Code");
//           IF SalesHeader."Document Type" IN
//              [SalesHeader."Document Type"::"Return Order",SalesHeader."Document Type"::"Credit Memo"]
//           THEN
//             TempICGenJnlLine.Amount :=
//               ROUND(
//                 CurrExchRate.ExchangeAmtFCYToLCY(
//                   SalesHeader."Posting Date",SalesLine."Currency Code",
//                   SalesLine.Amount,SalesHeader."Currency Factor"))
//           ELSE
//             TempICGenJnlLine.Amount :=
//               -ROUND(
//                 CurrExchRate.ExchangeAmtFCYToLCY(
//                   SalesHeader."Posting Date",SalesLine."Currency Code",
//                   SalesLine.Amount,SalesHeader."Currency Factor"));
//         END ELSE BEGIN
//           Currency.InitRoundingPrecision;
//           TempICGenJnlLine."Currency Code" := SalesHeader."Currency Code";
//           TempICGenJnlLine."Currency Factor" := SalesHeader."Currency Factor";
//           IF SalesHeader."Document Type" IN [SalesHeader."Document Type"::"Return Order",SalesHeader."Document Type"::"Credit Memo"] THEN
//             TempICGenJnlLine.Amount := SalesLine.Amount
//           ELSE
//             TempICGenJnlLine.Amount := -SalesLine.Amount;
//         END;
//         IF TempICGenJnlLine."Bal. VAT %" <> 0 THEN
//           TempICGenJnlLine.Amount := ROUND(TempICGenJnlLine.Amount * (1 + TempICGenJnlLine."Bal. VAT %" / 100),
//               Currency."Amount Rounding Precision");
//         TempICGenJnlLine.VALIDATE(Amount);
//         TempICGenJnlLine.INSERT;
//     end;

//     local procedure PostICGenJnl()
//     var
//         ICInOutBoxMgt: Codeunit "427";
//         ICTransactionNo: Integer;
//     begin
//         TempICGenJnlLine.RESET;
//         TempICGenJnlLine.SETFILTER(Amount,'<>%1',0);
//         IF TempICGenJnlLine.FIND('-') THEN
//           REPEAT
//             ICTransactionNo := ICInOutBoxMgt.CreateOutboxJnlTransaction(TempICGenJnlLine,FALSE);
//             ICInOutBoxMgt.CreateOutboxJnlLine(ICTransactionNo,1,TempICGenJnlLine);
//             IF TempICGenJnlLine.Amount <> 0 THEN
//               GenJnlPostLine.RunWithCheck(TempICGenJnlLine);
//           UNTIL TempICGenJnlLine.NEXT = 0;
//     end;

//     local procedure TestGetShipmentPPmtAmtToDeduct(var SalesHeader: Record "36")
//     var
//         SalesLine2: Record "37";
//         TempSalesLine3: Record "37" temporary;
//         TempTotalSalesLine: Record "37" temporary;
//         TempSalesShptLine: Record "111" temporary;
//         MaxAmtToDeduct: Decimal;
//     begin
//         SalesLine2.SETRANGE("Document Type",SalesHeader."Document Type");
//         SalesLine2.SETRANGE("Document No.",SalesHeader."No.");
//         SalesLine2.SETFILTER(Quantity,'>0');
//         SalesLine2.SETFILTER("Qty. to Invoice",'>0');
//         SalesLine2.SETFILTER("Shipment No.",'<>%1','');
//         SalesLine2.SETFILTER("Prepmt Amt to Deduct",'<>0');
//         IF SalesLine2.ISEMPTY THEN
//           EXIT;
//         SalesLine2.SETRANGE("Prepmt Amt to Deduct");

//         IF SalesLine2.FINDSET THEN
//           REPEAT
//             IF SalesShptLine.GET(SalesLine2."Shipment No.",SalesLine2."Shipment Line No.") THEN BEGIN
//               TempSalesLine3 := SalesLine2;
//               TempSalesLine3.INSERT;
//               TempSalesShptLine := SalesShptLine;
//               IF TempSalesShptLine.INSERT THEN;

//               IF NOT TempTotalSalesLine.GET(SalesLine2."Document Type"::Order,SalesShptLine."Order No.",SalesShptLine."Order Line No.") THEN BEGIN
//                 TempTotalSalesLine.INIT;
//                 TempTotalSalesLine."Document Type" := SalesLine2."Document Type"::Order;
//                 TempTotalSalesLine."Document No." := SalesShptLine."Order No.";
//                 TempTotalSalesLine."Line No." := SalesShptLine."Order Line No.";
//                 TempTotalSalesLine.INSERT;
//               END;
//               TempTotalSalesLine."Qty. to Invoice" := TempTotalSalesLine."Qty. to Invoice" + SalesLine2."Qty. to Invoice";
//               TempTotalSalesLine."Prepmt Amt to Deduct" := TempTotalSalesLine."Prepmt Amt to Deduct" + SalesLine2."Prepmt Amt to Deduct";
//               AdjustInvLineWith100PctPrepmt(SalesLine2,TempTotalSalesLine);
//               TempTotalSalesLine.MODIFY;
//             END;
//           UNTIL SalesLine2.NEXT = 0;

//         IF TempSalesLine3.FINDSET THEN
//           REPEAT
//             IF TempSalesShptLine.GET(TempSalesLine3."Shipment No.",TempSalesLine3."Shipment Line No.") THEN BEGIN
//               IF SalesLine2.GET(TempSalesLine3."Document Type"::Order,TempSalesShptLine."Order No.",TempSalesShptLine."Order Line No.") THEN
//                 IF TempTotalSalesLine.GET(
//                      TempSalesLine3."Document Type"::Order,TempSalesShptLine."Order No.",TempSalesShptLine."Order Line No.")
//                 THEN BEGIN
//                   MaxAmtToDeduct := SalesLine2."Prepmt. Amt. Inv." - SalesLine2."Prepmt Amt Deducted";

//                   IF TempTotalSalesLine."Prepmt Amt to Deduct" > MaxAmtToDeduct THEN
//                     ERROR(STRSUBSTNO(Text050,SalesLine2.FIELDCAPTION("Prepmt Amt to Deduct"),MaxAmtToDeduct));

//                   IF (TempTotalSalesLine."Qty. to Invoice" = SalesLine2.Quantity - SalesLine2."Quantity Invoiced") AND
//                      (TempTotalSalesLine."Prepmt Amt to Deduct" <> MaxAmtToDeduct)
//                   THEN
//                     ERROR(STRSUBSTNO(Text051,SalesLine2.FIELDCAPTION("Prepmt Amt to Deduct"),MaxAmtToDeduct));
//                 END;
//             END;
//           UNTIL TempSalesLine3.NEXT = 0;
//     end;

//     local procedure AdjustInvLineWith100PctPrepmt(var SalesInvoiceLine: Record "37";var TempTotalSalesLine: Record "37" temporary)
//     var
//         SalesOrderLine: Record "37";
//         DiffAmtToDeduct: Decimal;
//     begin
//         IF SalesInvoiceLine."Prepayment %" = 100 THEN BEGIN
//           SalesOrderLine := TempTotalSalesLine;
//           SalesOrderLine.FIND;
//           IF TempTotalSalesLine."Qty. to Invoice" = SalesOrderLine.Quantity - SalesOrderLine."Quantity Invoiced" THEN BEGIN
//             DiffAmtToDeduct :=
//               SalesOrderLine."Prepmt. Amt. Inv." - SalesOrderLine."Prepmt Amt Deducted" - TempTotalSalesLine."Prepmt Amt to Deduct";
//             IF DiffAmtToDeduct <> 0 THEN BEGIN
//               SalesInvoiceLine."Prepmt Amt to Deduct" := SalesInvoiceLine."Prepmt Amt to Deduct" + DiffAmtToDeduct;
//               SalesInvoiceLine."Line Amount" := SalesInvoiceLine."Prepmt Amt to Deduct";
//               SalesInvoiceLine."Line Discount Amount" := SalesInvoiceLine."Line Discount Amount" - DiffAmtToDeduct;
//               SalesInvoiceLine.MODIFY;
//               TempTotalSalesLine."Prepmt Amt to Deduct" := TempTotalSalesLine."Prepmt Amt to Deduct" + DiffAmtToDeduct;
//             END;
//           END;
//         END;
//     end;

//     procedure ArchiveUnpostedOrder()
//     var
//         ArchiveManagement: Codeunit "5063";
//     begin
//         IF NOT SalesSetup."Archive Quotes and Orders" THEN
//           EXIT;
//         IF NOT (SalesHeader."Document Type" IN [SalesHeader."Document Type"::Order,SalesHeader."Document Type"::"Return Order"]) THEN
//           EXIT;
//         SalesLine.RESET;
//         SalesLine.SETRANGE("Document Type",SalesHeader."Document Type");
//         SalesLine.SETRANGE("Document No.",SalesHeader."No.");
//         SalesLine.SETFILTER(Quantity,'<>0');
//         IF SalesHeader."Document Type" = SalesHeader."Document Type"::Order THEN
//           SalesLine.SETFILTER("Qty. to Ship",'<>0')
//         ELSE
//           SalesLine.SETFILTER("Return Qty. to Receive",'<>0');
//         IF NOT SalesLine.ISEMPTY THEN BEGIN
//           ArchiveManagement.ArchSalesDocumentNoConfirm(SalesHeader);
//           COMMIT;
//         END;
//     end;

//     local procedure SynchBOMSerialNo(var ServItemTmp3: Record "5940" temporary;var ServItemTmpCmp3: Record "5941" temporary)
//     var
//         ItemLedgEntry: Record "32";
//         ItemLedgEntry2: Record "32";
//         TempSalesShipMntLine: Record "111" temporary;
//         ServItemTmpCmp4: Record "5941" temporary;
//         ServItemCompLocal: Record "5941";
//         TempItemLedgEntry2: Record "32" temporary;
//         ChildCount: Integer;
//         EndLoop: Boolean;
//     begin
//         IF NOT ServItemTmpCmp3.FIND('-') THEN
//           EXIT;

//         IF NOT ServItemTmp3.FIND('-') THEN
//           EXIT;

//         TempSalesShipMntLine.DELETEALL;
//         REPEAT
//           CLEAR(TempSalesShipMntLine);
//           TempSalesShipMntLine."Document No." := ServItemTmp3."Sales/Serv. Shpt. Document No.";
//           TempSalesShipMntLine."Line No." := ServItemTmp3."Sales/Serv. Shpt. Line No.";
//           IF TempSalesShipMntLine.INSERT THEN;
//         UNTIL ServItemTmp3.NEXT = 0;

//         IF NOT TempSalesShipMntLine.FIND('-') THEN
//           EXIT;

//         ServItemTmp3.SETCURRENTKEY("Sales/Serv. Shpt. Document No.","Sales/Serv. Shpt. Line No.");
//         CLEAR(ItemLedgEntry);
//         ItemLedgEntry.SETCURRENTKEY("Document No.","Document Type","Document Line No.");

//         REPEAT
//           ChildCount := 0;
//           ServItemTmpCmp4.DELETEALL;
//           ServItemTmp3.SETRANGE("Sales/Serv. Shpt. Document No.",TempSalesShipMntLine."Document No.");
//           ServItemTmp3.SETRANGE("Sales/Serv. Shpt. Line No.",TempSalesShipMntLine."Line No.");
//           IF ServItemTmp3.FIND('-') THEN
//             REPEAT
//               ServItemTmpCmp3.SETRANGE(Active,TRUE);
//               ServItemTmpCmp3.SETRANGE("Parent Service Item No.",ServItemTmp3."No.");
//               IF ServItemTmpCmp3.FIND('-') THEN
//                 REPEAT
//                   ChildCount += 1;
//                   ServItemTmpCmp4 := ServItemTmpCmp3;
//                   ServItemTmpCmp4.INSERT;
//                 UNTIL ServItemTmpCmp3.NEXT = 0;
//             UNTIL ServItemTmp3.NEXT = 0;
//           ItemLedgEntry.SETRANGE("Document No.",TempSalesShipMntLine."Document No.");
//           ItemLedgEntry.SETRANGE("Document Type",ItemLedgEntry."Document Type"::"Sales Shipment");
//           ItemLedgEntry.SETRANGE("Document Line No.",TempSalesShipMntLine."Line No.");
//           IF ItemLedgEntry.FINDFIRST AND ServItemTmpCmp4.FIND('-') THEN BEGIN
//             CLEAR(ItemLedgEntry2);
//             ItemLedgEntry2.GET(ItemLedgEntry."Entry No.");
//             EndLoop := FALSE;
//             REPEAT
//               IF ItemLedgEntry2."Item No." = ServItemTmpCmp4."No." THEN
//                 EndLoop := TRUE
//               ELSE
//                 IF ItemLedgEntry2.NEXT = 0 THEN
//                   EndLoop := TRUE;
//             UNTIL EndLoop;
//             ItemLedgEntry2.SETRANGE("Entry No.",ItemLedgEntry2."Entry No.",ItemLedgEntry2."Entry No." + ChildCount - 1);
//             IF ItemLedgEntry2.FINDSET THEN
//               REPEAT
//                 TempItemLedgEntry2 := ItemLedgEntry2;
//                 TempItemLedgEntry2.INSERT;
//               UNTIL ItemLedgEntry2.NEXT = 0;
//             REPEAT
//               IF ServItemCompLocal.GET(
//                    ServItemTmpCmp4.Active,
//                    ServItemTmpCmp4."Parent Service Item No.",
//                    ServItemTmpCmp4."Line No.")
//               THEN BEGIN
//                 TempItemLedgEntry2.SETRANGE("Item No.",ServItemCompLocal."No.");
//                 IF TempItemLedgEntry2.FINDFIRST THEN BEGIN
//                   ServItemCompLocal."Serial No." := TempItemLedgEntry2."Serial No.";
//                   ServItemCompLocal.MODIFY;
//                   TempItemLedgEntry2.DELETE;
//                 END;
//               END;
//             UNTIL ServItemTmpCmp4.NEXT = 0;
//           END;
//         UNTIL TempSalesShipMntLine.NEXT = 0;
//     end;

//     local procedure GetGLSetup()
//     begin
//         IF NOT GLSetupRead THEN
//           GLSetup.GET;
//         GLSetupRead := TRUE;
//     end;

//     local procedure LockTables()
//     begin
//         SalesLine.LOCKTABLE;
//         ItemChargeAssgntSales.LOCKTABLE;
//         PurchOrderLine.LOCKTABLE;
//         PurchOrderHeader.LOCKTABLE;
//         GetGLSetup;
//         IF NOT GLSetup.OptimGLEntLockForMultiuserEnv THEN BEGIN
//           GLEntry.LOCKTABLE;
//           IF GLEntry.FINDLAST THEN;
//         END;
//     end;

//     local procedure PostCustomerEntry(SalesHeader2: Record "36";TotalSalesLine2: Record "37";TotalSalesLineLCY2: Record "37";DocType: Option;DocNo: Code[20];ExtDocNo: Code[35];SourceCode: Code[10])
//     var
//         GenJnlLine2: Record "81";
//     begin
//         WITH SalesHeader2 DO BEGIN
//           GenJnlLine2.INIT;
//           GenJnlLine2."Posting Date" := "Posting Date";
//           GenJnlLine2."Document Date" := "Document Date";
//           GenJnlLine2.Description := "Posting Description";
//           GenJnlLine2."Shortcut Dimension 1 Code" := "Shortcut Dimension 1 Code";
//           GenJnlLine2."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
//           GenJnlLine2."Dimension Set ID" := "Dimension Set ID";
//           GenJnlLine2."Reason Code" := "Reason Code";
//           GenJnlLine2."Account Type" := GenJnlLine2."Account Type"::Customer;
//           GenJnlLine2."Account No." := "Bill-to Customer No.";
//           GenJnlLine2."Document Type" := DocType;
//           GenJnlLine2."Document No." := DocNo;
//           GenJnlLine2."External Document No." := ExtDocNo;
//           GenJnlLine2."Currency Code" := "Currency Code";
//           GenJnlLine2.Amount := -TotalSalesLine2."Amount Including VAT";
//           GenJnlLine2."Source Currency Code" := "Currency Code";
//           GenJnlLine2."Source Currency Amount" := -TotalSalesLine2."Amount Including VAT";
//           GenJnlLine2."Amount (LCY)" := -TotalSalesLineLCY2."Amount Including VAT";
//           IF "Currency Code" = '' THEN
//             GenJnlLine2."Currency Factor" := 1
//           ELSE
//             GenJnlLine2."Currency Factor" := "Currency Factor";
//           GenJnlLine2.Correction := Correction;
//           GenJnlLine2."Sales/Purch. (LCY)" := -TotalSalesLineLCY2.Amount;
//           GenJnlLine2."Profit (LCY)" := -(TotalSalesLineLCY2.Amount - TotalSalesLineLCY2."Unit Cost (LCY)");
//           GenJnlLine2."Inv. Discount (LCY)" := -TotalSalesLineLCY2."Inv. Discount Amount";
//           IF (GenJnlLine2."Currency Code" <> '') AND ("Prepayment %" = 100) AND (GenJnlLine2.Amount = 0) THEN BEGIN
//             GenJnlLine2."Amount (LCY)" := 0;
//             GenJnlLine2."Sales/Purch. (LCY)" := 0;
//             GenJnlLine2."Profit (LCY)" := 0;
//             GenJnlLine2."Inv. Discount (LCY)" := 0;
//           END;
//           GenJnlLine2."Sell-to/Buy-from No." := "Sell-to Customer No.";
//           GenJnlLine2."Bill-to/Pay-to No." := "Bill-to Customer No.";
//           GenJnlLine2."Salespers./Purch. Code" := "Salesperson Code";
//           GenJnlLine2."System-Created Entry" := TRUE;
//           GenJnlLine2."On Hold" := "On Hold";
//           GenJnlLine2."Applies-to Doc. Type" := "Applies-to Doc. Type";
//           GenJnlLine2."Applies-to Doc. No." := "Applies-to Doc. No.";
//           GenJnlLine2."Applies-to ID" := "Applies-to ID";
//           GenJnlLine2."Allow Application" := "Bal. Account No." = '';
//           GenJnlLine2."Due Date" := "Due Date";
//           GenJnlLine2."Direct Debit Mandate ID" := "Direct Debit Mandate ID";
//           GenJnlLine2."Payment Terms Code" := "Payment Terms Code";
//           GenJnlLine2."Payment Method Code" := "Payment Method Code";
//           GenJnlLine2."Pmt. Discount Date" := "Pmt. Discount Date";
//           GenJnlLine2."Payment Discount %" := "Payment Discount %";
//           GenJnlLine2."Source Type" := GenJnlLine2."Source Type"::Customer;
//           GenJnlLine2."Source No." := "Bill-to Customer No.";
//           GenJnlLine2."Source Code" := SourceCode;
//           GenJnlLine2."Posting No. Series" := "Posting No. Series";
//           GenJnlLine2."IC Partner Code" := "Sell-to IC Partner Code";
//           GenJnlPostLine.RunWithCheck(GenJnlLine2);
//         END;
//     end;

//     local procedure UpdateSalesHeader(var CustLedgerEntry: Record "21")
//     begin
//         CASE GenJnlLineDocType OF
//           GenJnlLine."Document Type"::Invoice:
//             BEGIN
//               FindCustLedgEntry(GenJnlLineDocType,GenJnlLineDocNo,CustLedgerEntry);
//               SalesInvHeader."Cust. Ledger Entry No." := CustLedgerEntry."Entry No.";
//               SalesInvHeader.MODIFY;
//             END;
//           GenJnlLine."Document Type"::"Credit Memo":
//             BEGIN
//               FindCustLedgEntry(GenJnlLineDocType,GenJnlLineDocNo,CustLedgerEntry);
//               SalesCrMemoHeader."Cust. Ledger Entry No." := CustLedgerEntry."Entry No.";
//               SalesCrMemoHeader.MODIFY;
//             END;
//         END;
//     end;

//     local procedure CaptureOrRefundCreditCardPmnt(CustLedgEntry: Record "21"): Integer
//     var
//         DOPaymentMgt: Codeunit "825";
//     begin
//         WITH SalesHeader DO BEGIN
//           IF NOT IsOnlinePayment(SalesHeader) THEN
//             EXIT(0);

//           IF NOT Invoice THEN
//             EXIT(0);

//           IF "Document Type" = "Document Type"::"Credit Memo" THEN
//             EXIT(DOPaymentMgt.RefundSalesDoc(SalesHeader,CustLedgEntry."Entry No."));

//           EXIT(DOPaymentMgt.CaptureSalesDoc(SalesHeader,CustLedgEntry."Entry No."));
//         END;
//     end;

//     local procedure AuthorizeCreditCard(AuthorizationRequired: Boolean): Integer
//     var
//         DOPaymentMgt: Codeunit "825";
//     begin
//         WITH SalesHeader DO BEGIN
//           IF ("Document Type" = "Document Type"::Order) AND Ship OR
//              ("Document Type" = "Document Type"::Invoice) AND Invoice
//           THEN
//             IF DOPaymentMgt.IsValidPaymentMethod("Payment Method Code") THEN BEGIN
//               IF DOPaymentMgt.IsAuthorizationRequired OR AuthorizationRequired THEN
//                 EXIT(DOPaymentMgt.AuthorizeSalesDoc(SalesHeader,0,TRUE));
//               TESTFIELD("Credit Card No.");
//             END;
//         END;
//         EXIT(0);
//     end;

//     local procedure "MAX"(number1: Integer;number2: Integer): Integer
//     begin
//         IF number1 > number2 THEN
//           EXIT(number1);
//         EXIT(number2);
//     end;

//     local procedure PostBalanceEntry(TransactionLogEntryNo: Integer;SalesHeader2: Record "36";TotalSalesLine2: Record "37";TotalSalesLineLCY2: Record "37";DocType: Option;DocNo: Code[20];ExtDocNo: Code[35];SourceCode: Code[10])
//     var
//         CustLedgEntry: Record "21";
//         DOPaymentMgt: Codeunit "825";
//         CrCardDocumentType: Option Payment,Refund;
//     begin
//         WITH SalesHeader2 DO BEGIN
//           FindCustLedgEntry(DocType,DocNo,CustLedgEntry);

//           GenJnlLine.INIT;
//           GenJnlLine."Posting Date" := "Posting Date";
//           GenJnlLine."Document Date" := "Document Date";
//           GenJnlLine.Description := "Posting Description";
//           GenJnlLine."Shortcut Dimension 1 Code" := "Shortcut Dimension 1 Code";
//           GenJnlLine."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
//           GenJnlLine."Dimension Set ID" := "Dimension Set ID";
//           GenJnlLine."Reason Code" := "Reason Code";
//           GenJnlLine."Account Type" := GenJnlLine."Account Type"::Customer;
//           GenJnlLine."Account No." := "Bill-to Customer No.";
//           IF "Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"] THEN
//             GenJnlLine."Document Type" := GenJnlLine."Document Type"::Refund
//           ELSE
//             GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
//           GenJnlLine."Document No." := DocNo;
//           GenJnlLine."External Document No." := ExtDocNo;
//           IF "Bal. Account Type" = "Bal. Account Type"::"Bank Account" THEN
//             GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"Bank Account";
//           GenJnlLine."Bal. Account No." := "Bal. Account No.";
//           GenJnlLine."Currency Code" := "Currency Code";
//           GenJnlLine.Amount :=
//             TotalSalesLine2."Amount Including VAT" + CustLedgEntry."Remaining Pmt. Disc. Possible";
//           GenJnlLine."Source Currency Code" := "Currency Code";
//           GenJnlLine."Source Currency Amount" := GenJnlLine.Amount;
//           GenJnlLine.Correction := Correction;
//           CustLedgEntry.CALCFIELDS(Amount);
//           IF CustLedgEntry.Amount = 0 THEN
//             GenJnlLine."Amount (LCY)" := TotalSalesLineLCY2."Amount Including VAT"
//           ELSE
//             GenJnlLine."Amount (LCY)" :=
//               TotalSalesLineLCY2."Amount Including VAT" +
//               ROUND(
//                 CustLedgEntry."Remaining Pmt. Disc. Possible" /
//                 CustLedgEntry."Adjusted Currency Factor");
//           IF "Currency Code" = '' THEN
//             GenJnlLine."Currency Factor" := 1
//           ELSE
//             GenJnlLine."Currency Factor" := "Currency Factor";
//           GenJnlLine."Applies-to Doc. Type" := DocType;
//           GenJnlLine."Applies-to Doc. No." := DocNo;
//           GenJnlLine."Source Type" := GenJnlLine."Source Type"::Customer;
//           GenJnlLine."Source No." := "Bill-to Customer No.";
//           GenJnlLine."Source Code" := SourceCode;
//           GenJnlLine."Posting No. Series" := "Posting No. Series";
//           GenJnlLine."IC Partner Code" := "Sell-to IC Partner Code";
//           GenJnlLine."Salespers./Purch. Code" := "Salesperson Code";
//           GenJnlLine."Allow Zero-Amount Posting" := TRUE;
//           GenJnlPostLine.RunWithCheck(GenJnlLine);

//           IF TransactionLogEntryNo <> 0 THEN BEGIN
//             CASE "Document Type" OF
//               GenJnlLine."Document Type"::Payment:
//                 CrCardDocumentType := CrCardDocumentType::Payment;
//               "Document Type"::"Credit Memo":
//                 CrCardDocumentType := CrCardDocumentType::Refund;
//             END;
//             DOPaymentMgt.UpdateTransactEntryAfterPost(TransactionLogEntryNo,CustLedgEntry."Entry No.",CrCardDocumentType);
//           END;
//         END;
//     end;

//     local procedure FindCustLedgEntry(DocType: Option;DocNo: Code[20];var CustLedgEntry: Record "21")
//     begin
//         CustLedgEntry.SETRANGE("Document Type",DocType);
//         CustLedgEntry.SETRANGE("Document No.",DocNo);
//         CustLedgEntry.FINDLAST;
//     end;

//     procedure IsOnlinePayment(var SalesHeader: Record "36"): Boolean
//     var
//         DOPaymentMgt: Codeunit "825";
//     begin
//         IF DOPaymentMgt.IsValidPaymentMethod(SalesHeader."Payment Method Code") THEN
//           EXIT(TRUE);
//         EXIT(FALSE);
//     end;

//     local procedure SortLines(var SalesLine: Record "37")
//     begin
//         GetGLSetup;
//         IF GLSetup.OptimGLEntLockForMultiuserEnv THEN
//           SalesLine.SETCURRENTKEY("Document Type","Document No.",Type,"No.")
//         ELSE
//           SalesLine.SETCURRENTKEY("Document Type","Document No.","Line No.")
//     end;

//     local procedure IsAuthorized(TransactionLogEntryNo: Integer): Boolean
//     begin
//         EXIT(TransactionLogEntryNo <> 0);
//     end;

//     local procedure ItemLedgerEntryExist(SalesLine2: Record "37"): Boolean
//     var
//         HasItemLedgerEntry: Boolean;
//     begin
//         IF SalesHeader.Ship OR SalesHeader.Receive THEN
//           // item ledger entry will be created during posting in this transaction
//           HasItemLedgerEntry :=
//             ((SalesLine2."Qty. to Ship" + SalesLine2."Quantity Shipped") <> 0) OR
//             ((SalesLine2."Qty. to Invoice" + SalesLine2."Quantity Invoiced") <> 0) OR
//             ((SalesLine2."Return Qty. to Receive" + SalesLine2."Return Qty. Received") <> 0)
//         ELSE
//           // item ledger entry must already exist
//           HasItemLedgerEntry :=
//             (SalesLine2."Quantity Shipped" <> 0) OR
//             (SalesLine2."Return Qty. Received" <> 0);

//         EXIT(HasItemLedgerEntry);
//     end;

//     procedure CheckCustBlockage(CustCode: Code[20];ExecuteDocCheck: Boolean)
//     var
//         Cust: Record "18";
//     begin
//         Cust.GET(CustCode);
//         IF SalesHeader.Receive THEN
//           Cust.CheckBlockedCustOnDocs(Cust,SalesHeader."Document Type",FALSE,TRUE)
//         ELSE BEGIN
//           IF SalesHeader.Ship AND CheckDocumentType(ExecuteDocCheck) THEN BEGIN
//             SalesLine.RESET;
//             SalesLine.SETRANGE("Document Type",SalesHeader."Document Type");
//             SalesLine.SETRANGE("Document No.",SalesHeader."No.");
//             SalesLine.SETFILTER("Qty. to Ship",'<>0');
//             SalesLine.SETRANGE("Shipment No.",'');
//             IF NOT SalesLine.ISEMPTY THEN
//               Cust.CheckBlockedCustOnDocs(Cust,SalesHeader."Document Type",TRUE,TRUE);
//           END ELSE
//             Cust.CheckBlockedCustOnDocs(Cust,SalesHeader."Document Type",FALSE,TRUE);
//         END;
//     end;

//     procedure CheckDocumentType(ExecuteDocCheck: Boolean): Boolean
//     begin
//         WITH SalesHeader DO
//           EXIT(
//             ExecuteDocCheck AND ("Document Type" IN ["Document Type"::Order,"Document Type"::Invoice]));
//     end;

//     local procedure UpdateWonOpportunities(var SalesHeader: Record "36")
//     var
//         Opp: Record "5092";
//         OpportunityEntry: Record "5093";
//     begin
//         WITH SalesHeader DO
//           IF "Document Type" = "Document Type"::Order THEN BEGIN
//             Opp.RESET;
//             Opp.SETCURRENTKEY("Sales Document Type","Sales Document No.");
//             Opp.SETRANGE("Sales Document Type",Opp."Sales Document Type"::Order);
//             Opp.SETRANGE("Sales Document No.","No.");
//             Opp.SETRANGE(Status,Opp.Status::Won);
//             IF Opp.FINDFIRST THEN BEGIN
//               Opp."Sales Document Type" := Opp."Sales Document Type"::"Posted Invoice";
//               Opp."Sales Document No." := SalesInvHeader."No.";
//               Opp.MODIFY;
//               OpportunityEntry.RESET;
//               OpportunityEntry.SETCURRENTKEY(Active,"Opportunity No.");
//               OpportunityEntry.SETRANGE(Active,TRUE);
//               OpportunityEntry.SETRANGE("Opportunity No.",Opp."No.");
//               IF OpportunityEntry.FINDFIRST THEN BEGIN
//                 OpportunityEntry."Calcd. Current Value (LCY)" := OpportunityEntry.GetSalesDocValue(SalesHeader);
//                 OpportunityEntry.MODIFY;
//               END;
//             END;
//           END;
//     end;

//     procedure UpdateQtyToBeInvoiced(var QtyToBeInvoiced: Decimal;var QtyToBeInvoicedBase: Decimal;TrackingSpecificationExists: Boolean;HasATOShippedNotInvoiced: Boolean;SalesLine: Record "37";SalesShptLine: Record "111";InvoicingTrackingSpecification: Record "336";ItemLedgEntryNotInvoiced: Record "32")
//     begin
//         IF TrackingSpecificationExists THEN BEGIN
//           QtyToBeInvoiced := InvoicingTrackingSpecification."Qty. to Invoice";
//           QtyToBeInvoicedBase := InvoicingTrackingSpecification."Qty. to Invoice (Base)";
//         END ELSE
//           IF HasATOShippedNotInvoiced THEN BEGIN
//             QtyToBeInvoicedBase := ItemLedgEntryNotInvoiced.Quantity - ItemLedgEntryNotInvoiced."Invoiced Quantity";
//             IF ABS(QtyToBeInvoicedBase) > ABS(RemQtyToBeInvoicedBase) THEN
//               QtyToBeInvoicedBase := RemQtyToBeInvoicedBase - SalesLine."Qty. to Ship (Base)";
//             QtyToBeInvoiced := ROUND(QtyToBeInvoicedBase / SalesShptLine."Qty. per Unit of Measure",0.00001);
//           END ELSE BEGIN
//             QtyToBeInvoiced := RemQtyToBeInvoiced - SalesLine."Qty. to Ship";
//             QtyToBeInvoicedBase := RemQtyToBeInvoicedBase - SalesLine."Qty. to Ship (Base)";
//           END;

//         IF ABS(QtyToBeInvoiced) > ABS(SalesShptLine.Quantity - SalesShptLine."Quantity Invoiced") THEN BEGIN
//           QtyToBeInvoiced := -(SalesShptLine.Quantity - SalesShptLine."Quantity Invoiced");
//           QtyToBeInvoicedBase := -(SalesShptLine."Quantity (Base)" - SalesShptLine."Qty. Invoiced (Base)");
//         END;
//     end;

//     procedure IsEndLoopForShippedNotInvoiced(RemQtyToBeInvoiced: Decimal;TrackingSpecificationExists: Boolean;var HasATOShippedNotInvoiced: Boolean;var SalesShptLine: Record "111";var InvoicingTrackingSpecification: Record "336";var ItemLedgEntryNotInvoiced: Record "32";SalesLine: Record "37"): Boolean
//     begin
//         IF TrackingSpecificationExists THEN
//           EXIT(InvoicingTrackingSpecification.NEXT = 0);

//         IF HasATOShippedNotInvoiced THEN BEGIN
//           HasATOShippedNotInvoiced := ItemLedgEntryNotInvoiced.NEXT <> 0;
//           IF NOT HasATOShippedNotInvoiced THEN
//             EXIT(NOT SalesShptLine.FINDSET OR (ABS(RemQtyToBeInvoiced) <= ABS(SalesLine."Qty. to Ship")));
//           EXIT(ABS(RemQtyToBeInvoiced) <= ABS(SalesLine."Qty. to Ship"));
//         END;

//         EXIT((SalesShptLine.NEXT = 0) OR (ABS(RemQtyToBeInvoiced) <= ABS(SalesLine."Qty. to Ship")));
//     end;

//     procedure SetItemEntryRelation(var ItemEntryRelation: Record "6507";var SalesShptLine: Record "111";var InvoicingTrackingSpecification: Record "336";var ItemLedgEntryNotInvoiced: Record "32";TrackingSpecificationExists: Boolean;HasATOShippedNotInvoiced: Boolean)
//     begin
//         IF TrackingSpecificationExists THEN BEGIN
//           ItemEntryRelation.GET(InvoicingTrackingSpecification."Item Ledger Entry No.");
//           SalesShptLine.GET(ItemEntryRelation."Source ID",ItemEntryRelation."Source Ref. No.");
//         END ELSE
//           IF HasATOShippedNotInvoiced THEN BEGIN
//             ItemEntryRelation."Item Entry No." := ItemLedgEntryNotInvoiced."Entry No.";
//             SalesShptLine.GET(ItemLedgEntryNotInvoiced."Document No.",ItemLedgEntryNotInvoiced."Document Line No.");
//           END ELSE
//             ItemEntryRelation."Item Entry No." := SalesShptLine."Item Shpt. Entry No.";
//     end;

//     local procedure PostATOAssocItemJnlLine(SalesLine: Record "37";var PostedATOLink: Record "914";var RemQtyToBeInvoiced: Decimal;var RemQtyToBeInvoicedBase: Decimal)
//     var
//         DummyTrackingSpecification: Record "336";
//     begin
//         WITH PostedATOLink DO BEGIN
//           DummyTrackingSpecification.INIT;
//           IF SalesLine."Document Type" = SalesLine."Document Type"::Order THEN BEGIN
//             "Assembled Quantity" := -"Assembled Quantity";
//             "Assembled Quantity (Base)" := -"Assembled Quantity (Base)";
//             IF ABS(RemQtyToBeInvoiced) >= ABS("Assembled Quantity") THEN BEGIN
//               ItemLedgShptEntryNo :=
//                 PostItemJnlLine(
//                   SalesLine,
//                   "Assembled Quantity","Assembled Quantity (Base)",
//                   "Assembled Quantity","Assembled Quantity (Base)",
//                   0,'',DummyTrackingSpecification,TRUE);
//               RemQtyToBeInvoiced -= "Assembled Quantity";
//               RemQtyToBeInvoicedBase -= "Assembled Quantity (Base)";
//             END ELSE BEGIN
//               IF RemQtyToBeInvoiced <> 0 THEN
//                 ItemLedgShptEntryNo :=
//                   PostItemJnlLine(
//                     SalesLine,
//                     RemQtyToBeInvoiced,
//                     RemQtyToBeInvoicedBase,
//                     RemQtyToBeInvoiced,
//                     RemQtyToBeInvoicedBase,
//                     0,'',DummyTrackingSpecification,TRUE);

//               ItemLedgShptEntryNo :=
//                 PostItemJnlLine(
//                   SalesLine,
//                   "Assembled Quantity" - RemQtyToBeInvoiced,
//                   "Assembled Quantity (Base)" - RemQtyToBeInvoicedBase,
//                   0,0,
//                   0,'',DummyTrackingSpecification,TRUE);

//               RemQtyToBeInvoiced := 0;
//               RemQtyToBeInvoicedBase := 0;
//             END;
//           END;
//         END;
//     end;

//     local procedure GetOpenLinkedATOs(var TempAsmHeader: Record "900" temporary)
//     var
//         SalesLine2: Record "37";
//         AsmHeader: Record "900";
//     begin
//         SalesLine2.SETRANGE("Document Type",SalesHeader."Document Type");
//         SalesLine2.SETRANGE("Document No.",SalesHeader."No.");
//         IF SalesLine2.FIND('-') THEN
//           REPEAT
//             IF SalesLine2.AsmToOrderExists(AsmHeader) THEN
//               IF AsmHeader.Status = AsmHeader.Status::Open THEN BEGIN
//                 TempAsmHeader.TRANSFERFIELDS(AsmHeader);
//                 TempAsmHeader.INSERT;
//               END;
//           UNTIL SalesLine2.NEXT = 0;
//     end;

//     local procedure ReopenAsmOrders(var TempAsmHeader: Record "900" temporary)
//     var
//         AsmHeader: Record "900";
//     begin
//         IF TempAsmHeader.FIND('-') THEN
//           REPEAT
//             AsmHeader.GET(TempAsmHeader."Document Type",TempAsmHeader."No.");
//             AsmHeader.Status := AsmHeader.Status::Open;
//             AsmHeader.MODIFY;
//           UNTIL TempAsmHeader.NEXT = 0;
//     end;

//     local procedure InitPostATO(var SalesLine: Record "37")
//     var
//         AsmHeader: Record "900";
//         Window: Dialog;
//     begin
//         IF SalesLine.AsmToOrderExists(AsmHeader) THEN BEGIN
//           Window.OPEN(Text055);
//           Window.UPDATE(1,
//             STRSUBSTNO(Text059,
//               SalesLine."Document Type",SalesLine."Document No.",SalesLine.FIELDCAPTION("Line No."),SalesLine."Line No."));
//           Window.UPDATE(2,STRSUBSTNO(Text060,AsmHeader."Document Type",AsmHeader."No."));

//           SalesLine.CheckAsmToOrder(AsmHeader);
//           IF NOT HasQtyToAsm(SalesLine,AsmHeader) THEN
//             EXIT;

//           AsmPost.SetPostingDate(TRUE,SalesHeader."Posting Date");
//           AsmPost.InitPostATO(AsmHeader);

//           Window.CLOSE;
//         END;
//     end;

//     local procedure PostATO(var SalesLine: Record "37";var TempPostedATOLink: Record "914" temporary)
//     var
//         AsmHeader: Record "900";
//         PostedATOLink: Record "914";
//         Window: Dialog;
//     begin
//         IF SalesLine.AsmToOrderExists(AsmHeader) THEN BEGIN
//           Window.OPEN(Text056);
//           Window.UPDATE(1,
//             STRSUBSTNO(Text059,
//               SalesLine."Document Type",SalesLine."Document No.",SalesLine.FIELDCAPTION("Line No."),SalesLine."Line No."));
//           Window.UPDATE(2,STRSUBSTNO(Text060,AsmHeader."Document Type",AsmHeader."No."));

//           SalesLine.CheckAsmToOrder(AsmHeader);
//           IF NOT HasQtyToAsm(SalesLine,AsmHeader) THEN
//             EXIT;
//           IF AsmHeader."Remaining Quantity (Base)" = 0 THEN
//             EXIT;

//           PostedATOLink.INIT;
//           PostedATOLink."Assembly Document Type" := PostedATOLink."Assembly Document Type"::Assembly;
//           PostedATOLink."Assembly Document No." := AsmHeader."Posting No.";
//           PostedATOLink."Document Type" := PostedATOLink."Document Type"::"Sales Shipment";
//           PostedATOLink."Document No." := SalesHeader."Shipping No.";
//           PostedATOLink."Document Line No." := SalesLine."Line No.";

//           PostedATOLink."Assembly Order No." := AsmHeader."No.";
//           PostedATOLink."Order No." := SalesLine."Document No.";
//           PostedATOLink."Order Line No." := SalesLine."Line No.";

//           PostedATOLink."Assembled Quantity" := AsmHeader."Quantity to Assemble";
//           PostedATOLink."Assembled Quantity (Base)" := AsmHeader."Quantity to Assemble (Base)";
//           PostedATOLink.INSERT;

//           TempPostedATOLink := PostedATOLink;
//           TempPostedATOLink.INSERT;

//           AsmPost.PostATO(AsmHeader,ItemJnlPostLine,ResJnlPostLine,WhseJnlPostLine);

//           Window.CLOSE;
//         END;
//     end;

//     local procedure FinalizePostATO(var SalesLine: Record "37")
//     var
//         ATOLink: Record "904";
//         AsmHeader: Record "900";
//         Window: Dialog;
//     begin
//         IF SalesLine.AsmToOrderExists(AsmHeader) THEN BEGIN
//           Window.OPEN(Text057);
//           Window.UPDATE(1,
//             STRSUBSTNO(Text059,
//               SalesLine."Document Type",SalesLine."Document No.",SalesLine.FIELDCAPTION("Line No."),SalesLine."Line No."));
//           Window.UPDATE(2,STRSUBSTNO(Text060,AsmHeader."Document Type",AsmHeader."No."));

//           SalesLine.CheckAsmToOrder(AsmHeader);
//           AsmHeader.TESTFIELD("Remaining Quantity (Base)",0);
//           AsmPost.FinalizePostATO(AsmHeader);
//           ATOLink.GET(AsmHeader."Document Type",AsmHeader."No.");
//           ATOLink.DELETE;

//           Window.CLOSE;
//         END;
//     end;

//     local procedure CheckATOLink(SalesLine: Record "37")
//     var
//         AsmHeader: Record "900";
//     begin
//         IF SalesLine."Qty. to Asm. to Order (Base)" = 0 THEN
//           EXIT;
//         IF SalesLine.AsmToOrderExists(AsmHeader) THEN
//           SalesLine.CheckAsmToOrder(AsmHeader);
//     end;

//     local procedure DeleteATOLinks(SalesHeader: Record "36")
//     var
//         ATOLink: Record "904";
//     begin
//         WITH ATOLink DO BEGIN
//           SETCURRENTKEY(Type,"Document Type","Document No.");
//           SETRANGE(Type,Type::Sale);
//           SETRANGE("Document Type",SalesHeader."Document Type");
//           SETRANGE("Document No.",SalesHeader."No.");
//           IF NOT ISEMPTY THEN
//             DELETEALL;
//         END;
//     end;

//     local procedure HasQtyToAsm(SalesLine: Record "37";AsmHeader: Record "900"): Boolean
//     begin
//         IF SalesLine."Qty. to Asm. to Order (Base)" = 0 THEN
//           EXIT(FALSE);
//         IF SalesLine."Qty. to Ship (Base)" = 0 THEN
//           EXIT(FALSE);
//         IF AsmHeader."Quantity to Assemble (Base)" = 0 THEN
//           EXIT(FALSE);
//         EXIT(TRUE);
//     end;

//     local procedure GetATOItemLedgEntriesNotInvoiced(SalesLine: Record "37";var ItemLedgEntryNotInvoiced: Record "32"): Boolean
//     var
//         PostedATOLink: Record "914";
//         ItemLedgEntry: Record "32";
//     begin
//         ItemLedgEntryNotInvoiced.RESET;
//         ItemLedgEntryNotInvoiced.DELETEALL;
//         IF PostedATOLink.FindLinksFromSalesLine(SalesLine) THEN
//           REPEAT
//             ItemLedgEntry.SETCURRENTKEY("Document No.","Document Type","Document Line No.");
//             ItemLedgEntry.SETRANGE("Document Type",ItemLedgEntry."Document Type"::"Sales Shipment");
//             ItemLedgEntry.SETRANGE("Document No.",PostedATOLink."Document No.");
//             ItemLedgEntry.SETRANGE("Document Line No.",PostedATOLink."Document Line No.");
//             ItemLedgEntry.SETRANGE("Assemble to Order",TRUE);
//             ItemLedgEntry.SETRANGE("Completely Invoiced",FALSE);
//             IF ItemLedgEntry.FINDSET THEN
//               REPEAT
//                 IF ItemLedgEntry.Quantity <> ItemLedgEntry."Invoiced Quantity" THEN BEGIN
//                   ItemLedgEntryNotInvoiced := ItemLedgEntry;
//                   ItemLedgEntryNotInvoiced.INSERT;
//                 END;
//               UNTIL ItemLedgEntry.NEXT = 0;
//           UNTIL PostedATOLink.NEXT = 0;

//         EXIT(ItemLedgEntryNotInvoiced.FINDSET);
//     end;

//     procedure SetWhseJnlRegisterCU(var WhseJnlRegisterLine: Codeunit "7301")
//     begin
//         WhseJnlPostLine := WhseJnlRegisterLine;
//     end;

//     local procedure PostWhseShptLines(var WhseShptLine2: Record "7321";SalesShptLine2: Record "111";var SalesLine2: Record "37")
//     var
//         ATOWhseShptLine: Record "7321";
//         NonATOWhseShptLine: Record "7321";
//         ATOLineFound: Boolean;
//         NonATOLineFound: Boolean;
//         TotalSalesShptLineQty: Decimal;
//     begin
//         WhseShptLine2.GetATOAndNonATOLines(ATOWhseShptLine,NonATOWhseShptLine,ATOLineFound,NonATOLineFound);
//         IF ATOLineFound THEN
//           TotalSalesShptLineQty += ATOWhseShptLine."Qty. to Ship";
//         IF NonATOLineFound THEN
//           TotalSalesShptLineQty += NonATOWhseShptLine."Qty. to Ship";
//         SalesShptLine2.TESTFIELD(Quantity,TotalSalesShptLineQty);

//         SaveTempWhseSplitSpec(SalesLine2);

//         WhsePostShpt.SetWhseJnlRegisterCU(WhseJnlPostLine);
//         IF ATOLineFound AND (ATOWhseShptLine."Qty. to Ship (Base)" > 0) THEN
//           WhsePostShpt.CreatePostedShptLine(
//             ATOWhseShptLine,PostedWhseShptHeader,PostedWhseShptLine,TempWhseSplitSpecification);
//         IF NonATOLineFound AND (NonATOWhseShptLine."Qty. to Ship (Base)" > 0) THEN
//           WhsePostShpt.CreatePostedShptLine(
//             NonATOWhseShptLine,PostedWhseShptHeader,PostedWhseShptLine,TempWhseSplitSpecification);
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

//     local procedure UpdateIncomingDocument(IncomingDocNo: Integer;PostingDate: Date;GenJnlLineDocNo: Code[20])
//     var
//         IncomingDocument: Record "130";
//     begin
//         IncomingDocument.UpdateIncomingDocumentFromPosting(IncomingDocNo,PostingDate,GenJnlLineDocNo);
//     end;

//     local procedure CheckItemCharge(ItemChargeAssgntSales: Record "5809")
//     var
//         SalesLineForCharge: Record "37";
//     begin
//         WITH ItemChargeAssgntSales DO
//           CASE "Applies-to Doc. Type" OF
//             "Applies-to Doc. Type"::Order,
//             "Applies-to Doc. Type"::Invoice:
//               IF SalesLineForCharge.GET(
//                    "Applies-to Doc. Type",
//                    "Applies-to Doc. No.",
//                    "Applies-to Doc. Line No.")
//               THEN
//                 IF (SalesLineForCharge."Quantity (Base)" = SalesLineForCharge."Qty. Shipped (Base)") AND
//                    (SalesLineForCharge."Qty. Shipped Not Invd. (Base)" = 0)
//                 THEN
//                   ERROR(Text061Err);
//             "Applies-to Doc. Type"::"Return Order",
//             "Applies-to Doc. Type"::"Credit Memo":
//               IF SalesLineForCharge.GET(
//                    "Applies-to Doc. Type",
//                    "Applies-to Doc. No.",
//                    "Applies-to Doc. Line No.")
//               THEN
//                 IF (SalesLineForCharge."Quantity (Base)" = SalesLineForCharge."Return Qty. Received (Base)") AND
//                    (SalesLineForCharge."Ret. Qty. Rcd. Not Invd.(Base)" = 0)
//                 THEN
//                   ERROR(Text061Err);
//           END;
//     end;

//     local procedure CheckItemReservDisruption()
//     var
//         AvailableQty: Decimal;
//     begin
//         WITH SalesLine DO BEGIN
//           IF NOT ("Document Type" IN ["Document Type"::Order,"Document Type"::Invoice]) OR
//              (Type <> Type::Item) OR
//              NOT ("Qty. to Ship (Base)" > 0)
//           THEN
//             EXIT;
//           IF ("Job Contract Entry No." <> 0) OR
//              Nonstock OR
//              "Special Order" OR
//              "Drop Shipment" OR
//              IsServiceItem OR
//              FullQtyIsForAsmToOrder OR
//              TempSKU.GET("Location Code","No.","Variant Code") // Warn against item
//           THEN
//             EXIT;

//           Item.SETFILTER("Location Filter","Location Code");
//           Item.SETFILTER("Variant Filter","Variant Code");
//           Item.CALCFIELDS("Reserved Qty. on Inventory","Net Change");
//           CALCFIELDS("Reserved Qty. (Base)");
//           AvailableQty := Item."Net Change" - (Item."Reserved Qty. on Inventory" - "Reserved Qty. (Base)");

//           IF (Item."Reserved Qty. on Inventory" > 0) AND
//              (AvailableQty < "Qty. to Ship (Base)") AND
//              (Item."Reserved Qty. on Inventory" > "Reserved Qty. (Base)")
//           THEN BEGIN
//             InsertTempSKU("Location Code","No.","Variant Code");
//             IF NOT CONFIRM(
//                  Text062Qst,FALSE,FIELDCAPTION("No."),Item."No.",FIELDCAPTION("Location Code"),
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

//     procedure InitProgressWindow(SalesHeader: Record "36")
//     begin
//         IF SalesHeader.Invoice THEN
//           Window.OPEN(
//             '#1#################################\\' +
//             Text002 +
//             Text003 +
//             Text004 +
//             Text005)
//         ELSE
//           Window.OPEN(
//             '#1#################################\\' +
//             Text006);

//         Window.UPDATE(1,STRSUBSTNO('%1 %2',SalesHeader."Document Type",SalesHeader."No."));
//     end;

//     local procedure CheckCertificateOfSupplyStatus(SalesShptHeader: Record "110";SalesShptLine: Record "111")
//     var
//         CertificateOfSupply: Record "780";
//         VATPostingSetup: Record "325";
//     begin
//         IF SalesShptLine.Quantity <> 0 THEN
//           IF VATPostingSetup.GET(SalesShptHeader."VAT Bus. Posting Group",SalesShptLine."VAT Prod. Posting Group") AND
//              VATPostingSetup."Certificate of Supply Required"
//           THEN BEGIN
//             CertificateOfSupply.InitFromSales(SalesShptHeader);
//             CertificateOfSupply.SetRequired(SalesShptHeader."No.");
//           END;
//     end;

//     local procedure HasSpecificTracking(ItemNo: Code[20]): Boolean
//     var
//         Item: Record "27";
//         ItemTrackingCode: Record "6502";
//     begin
//         Item.GET(ItemNo);
//         IF Item."Item Tracking Code" <> '' THEN BEGIN
//           ItemTrackingCode.GET(Item."Item Tracking Code");
//           EXIT(ItemTrackingCode."SN Specific Tracking" OR ItemTrackingCode."Lot Specific Tracking");
//         END;
//     end;

//     local procedure HasInvtPickLine(SalesLine: Record "37"): Boolean
//     var
//         WhseActivityLine: Record "5767";
//     begin
//         WITH WhseActivityLine DO BEGIN
//           SETRANGE("Activity Type","Activity Type"::"Invt. Pick");
//           SETRANGE("Source Type",DATABASE::"Sales Line");
//           SETRANGE("Source Subtype",SalesLine."Document Type");
//           SETRANGE("Source No.",SalesLine."Document No.");
//           SETRANGE("Source Line No.",SalesLine."Line No.");
//           EXIT(NOT ISEMPTY);
//         END;
//     end;

//     local procedure UpdateSalesLineDimSetIDFromAppliedEntry(var SalesLineToPost: Record "37";SalesLine: Record "37")
//     var
//         ItemLedgEntry: Record "32";
//         DimensionMgt: Codeunit "408";
//         DimSetID: array [10] of Integer;
//     begin
//         DimSetID[1] := SalesLine."Dimension Set ID";
//         WITH SalesLineToPost DO BEGIN
//           IF "Appl.-to Item Entry" <> 0 THEN BEGIN
//             ItemLedgEntry.GET("Appl.-to Item Entry");
//             DimSetID[2] := ItemLedgEntry."Dimension Set ID";
//           END;
//           "Dimension Set ID" :=
//             DimensionMgt.GetCombinedDimensionSetID(DimSetID,"Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
//         END;
//     end;
// }

