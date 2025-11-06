// codeunit 5705 "TransferOrder-Post Receipt"
// {
//     // DP.NCM 12/05/2017 TJC #390

//     Permissions = TableData 6507=i;
//     TableNo = 5740;

//     trigger OnRun()
//     var
//         Item: Record "27";
//         SourceCodeSetup: Record "242";
//         InvtSetup: Record "313";
//         InventoryPostingSetup: Record "5813";
//         ValueEntry: Record "5802";
//         ItemLedgEntry: Record "32";
//         ItemApplnEntry: Record "339";
//         ItemReg: Record "46";
//         NoSeriesMgt: Codeunit "396";
//         UpdateAnalysisView: Codeunit "410";
//         UpdateItemAnalysisView: Codeunit "7150";
//         ReservMgt: Codeunit "99000845";
//         Window: Dialog;
//         LineCount: Integer;
//         lrTransferLine: Record "5741";
//         rTempLocation: Record "14" temporary;
//     begin
//         IF Status = Status::Open THEN BEGIN
//           CODEUNIT.RUN(CODEUNIT::"Release Transfer Document",Rec);
//           Status := Status::Open;
//           MODIFY;
//           COMMIT;
//           Status := Status::Released;
//         END;
//         TransHeader := Rec;
//         TransHeader.SetHideValidationDialog(HideValidationDialog);

//         WITH TransHeader DO BEGIN
//           //DP.NCM 12/05/2017 TJC #390
//           rTempLocation.RESET;rTempLocation.DELETEALL;
//           lrTransferLine.RESET;
//           lrTransferLine.SETRANGE("Document No.","No.");
//           lrTransferLine.SETRANGE("Derived From Line No.",0);
//           lrTransferLine.SETFILTER(Quantity,'<>0');
//           IF lrTransferLine.FIND('-') THEN REPEAT
//             rTempLocation.INIT;rTempLocation.Code := lrTransferLine."Transfer-To Bin Code";
//             IF rTempLocation.INSERT THEN;
//           UNTIL lrTransferLine.NEXT = 0;
//           rTempLocation.RESET;
//           //DP.NCM 12/05/2017 TJC #390

//           TESTFIELD("Transfer-from Code");
//           TESTFIELD("Transfer-to Code");
//           IF "Transfer-from Code" = "Transfer-to Code" THEN
//             ERROR
//             (Text000,
//               "No.",FIELDCAPTION("Transfer-from Code"),FIELDCAPTION("Transfer-to Code"));
//           TESTFIELD("In-Transit Code");
//           TESTFIELD(Status,Status::Released);
//           TESTFIELD("Posting Date");

//           WhseReference := "Posting from Whse. Ref.";
//           "Posting from Whse. Ref." := 0;

//           CheckDim;

//           TransLine.RESET;
//           TransLine.SETRANGE("Document No.","No.");
//           TransLine.SETRANGE("Derived From Line No.",0);
//           TransLine.SETFILTER(Quantity,'<>0');
//           TransLine.SETFILTER("Qty. to Receive",'<>0');
//           IF NOT TransLine.FIND('-') THEN
//             ERROR(Text001);

//           WhseReceive := TempWhseRcptHeader.FINDFIRST;
//           InvtPickPutaway := WhseReference <> 0;
//           IF NOT (WhseReceive OR InvtPickPutaway) THEN
//             CheckWarehouse(TransLine);

//           GetLocation("Transfer-to Code");
//           IF Location."Bin Mandatory" AND NOT (WhseReceive OR InvtPickPutaway) THEN
//             WhsePosting := TRUE;

//           Window.OPEN(
//             '#1#################################\\' +
//             Text003);

//           Window.UPDATE(1,STRSUBSTNO(Text004,"No."));

//           SourceCodeSetup.GET;
//           SourceCode := SourceCodeSetup.Transfer;
//           InvtSetup.GET;
//           InvtSetup.TESTFIELD("Posted Transfer Rcpt. Nos.");
//           InventoryPostingSetup.SETRANGE("Location Code","Transfer-from Code");
//           InventoryPostingSetup.FINDFIRST;
//           InventoryPostingSetup.SETRANGE("Location Code","Transfer-to Code");
//           InventoryPostingSetup.FINDFIRST;

//           NoSeriesLine.LOCKTABLE;
//           IF NoSeriesLine.FINDLAST THEN;
//           IF InvtSetup."Automatic Cost Posting" THEN BEGIN
//             GLEntry.LOCKTABLE;
//             IF GLEntry.FINDLAST THEN;
//           END;

//           // Insert receipt header
//           IF WhseReceive THEN
//             PostedWhseRcptHeader.LOCKTABLE;
//           TransRcptHeader.LOCKTABLE;
//           TransRcptHeader.INIT;
//           TransRcptHeader."Transfer-from Code" := "Transfer-from Code";
//           TransRcptHeader."Transfer-from Name" := "Transfer-from Name";
//           TransRcptHeader."Transfer-from Name 2" := "Transfer-from Name 2";
//           TransRcptHeader."Transfer-from Address" := "Transfer-from Address";
//           TransRcptHeader."Transfer-from Address 2" := "Transfer-from Address 2";
//           TransRcptHeader."Transfer-from Post Code" := "Transfer-from Post Code";
//           TransRcptHeader."Transfer-from City" := "Transfer-from City";
//           TransRcptHeader."Transfer-from County" := "Transfer-from County";
//           TransRcptHeader."Trsf.-from Country/Region Code" := "Trsf.-from Country/Region Code";
//           TransRcptHeader."Transfer-from Contact" := "Transfer-from Contact";
//           TransRcptHeader."Transfer-to Code" := "Transfer-to Code";
//           TransRcptHeader."Transfer-to Name" := "Transfer-to Name";
//           TransRcptHeader."Transfer-to Name 2" := "Transfer-to Name 2";
//           TransRcptHeader."Transfer-to Address" := "Transfer-to Address";
//           TransRcptHeader."Transfer-to Address 2" := "Transfer-to Address 2";
//           TransRcptHeader."Transfer-to Post Code" := "Transfer-to Post Code";
//           TransRcptHeader."Transfer-to City" := "Transfer-to City";
//           TransRcptHeader."Transfer-to County" := "Transfer-to County";
//           TransRcptHeader."Trsf.-to Country/Region Code" := "Trsf.-to Country/Region Code";
//           TransRcptHeader."Transfer-to Contact" := "Transfer-to Contact";
//           TransRcptHeader."Transfer Order Date" := "Posting Date";
//           TransRcptHeader."Posting Date" := "Posting Date";
//           TransRcptHeader."Shipment Date" := "Shipment Date";
//           TransRcptHeader."Receipt Date" := "Receipt Date";
//           TransRcptHeader."Shortcut Dimension 1 Code" := "Shortcut Dimension 1 Code";
//           TransRcptHeader."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
//           TransRcptHeader."Dimension Set ID" := "Dimension Set ID";
//           TransRcptHeader."Transfer Order No." := "No.";
//           TransRcptHeader."External Document No." := "External Document No.";
//           TransRcptHeader."In-Transit Code" := "In-Transit Code";
//           TransRcptHeader."Shipping Agent Code" := "Shipping Agent Code";
//           TransRcptHeader."Shipping Agent Service Code" := "Shipping Agent Service Code";
//           TransRcptHeader."Shipment Method Code" := "Shipment Method Code";
//           TransRcptHeader."Transaction Type" := "Transaction Type";
//           TransRcptHeader."Transport Method" := "Transport Method";
//           TransRcptHeader."Entry/Exit Point" := "Entry/Exit Point";
//           TransRcptHeader.Area := Area;
//           TransRcptHeader."Transaction Specification" := "Transaction Specification";
//           TransRcptHeader."No. Series" := InvtSetup."Posted Transfer Rcpt. Nos.";
//           TransRcptHeader."No." :=
//             NoSeriesMgt.GetNextNo(
//               InvtSetup."Posted Transfer Rcpt. Nos.","Posting Date",TRUE);
//           TransRcptHeader.INSERT;

//           IF InvtSetup."Copy Comments Order to Rcpt." THEN BEGIN
//             CopyCommentLines(1,3,"No.",TransRcptHeader."No.");
//             TransRcptHeader.COPYLINKS(Rec);
//           END;

//           IF WhseReceive THEN BEGIN
//             WhseRcptHeader.GET(TempWhseRcptHeader."No.");
//             WhsePostRcpt.CreatePostedRcptHeader(PostedWhseRcptHeader,WhseRcptHeader,TransRcptHeader."No.","Posting Date");
//           END;

//           // Insert receipt lines
//           LineCount := 0;
//           IF WhseReceive THEN
//             PostedWhseRcptLine.LOCKTABLE;
//           IF InvtPickPutaway THEN
//             WhseRqst.LOCKTABLE;
//           TransRcptLine.LOCKTABLE;
//           TransLine.SETRANGE(Quantity);
//           TransLine.SETRANGE("Qty. to Receive");
//           IF TransLine.FIND('-') THEN
//             REPEAT
//               LineCount := LineCount + 1;
//               Window.UPDATE(2,LineCount);

//               IF TransLine."Item No." <> '' THEN BEGIN
//                 Item.GET(TransLine."Item No.");
//                 Item.TESTFIELD(Blocked,FALSE);
//               END;

//               TransRcptLine.INIT;
//               TransRcptLine."Document No." := TransRcptHeader."No.";
//               TransRcptLine."Line No." := TransLine."Line No.";
//               TransRcptLine."Item No." := TransLine."Item No.";
//               TransRcptLine.Description := TransLine.Description;
//               TransRcptLine.Quantity := TransLine."Qty. to Receive";
//               TransRcptLine."Unit of Measure" := TransLine."Unit of Measure";
//               TransRcptLine."Shortcut Dimension 1 Code" := TransLine."Shortcut Dimension 1 Code";
//               TransRcptLine."Shortcut Dimension 2 Code" := TransLine."Shortcut Dimension 2 Code";
//               TransRcptLine."Dimension Set ID" := TransLine."Dimension Set ID";
//               TransRcptLine."Gen. Prod. Posting Group" := TransLine."Gen. Prod. Posting Group";
//               TransRcptLine."Inventory Posting Group" := TransLine."Inventory Posting Group";
//               TransRcptLine."Quantity (Base)" := TransLine."Qty. to Receive (Base)";
//               TransRcptLine."Qty. per Unit of Measure" := TransLine."Qty. per Unit of Measure";
//               TransRcptLine."Unit of Measure Code" := TransLine."Unit of Measure Code";
//               TransRcptLine."Gross Weight" := TransLine."Gross Weight";
//               TransRcptLine."Net Weight" := TransLine."Net Weight";
//               TransRcptLine."Unit Volume" := TransLine."Unit Volume";
//               TransRcptLine."Variant Code" := TransLine."Variant Code";
//               TransRcptLine."Units per Parcel" := TransLine."Units per Parcel";
//               TransRcptLine."Description 2" := TransLine."Description 2";
//               TransRcptLine."Transfer Order No." := TransLine."Document No.";
//               TransRcptLine."Receipt Date" := TransLine."Receipt Date";
//               TransRcptLine."Shipping Agent Code" := TransLine."Shipping Agent Code";
//               TransRcptLine."Shipping Agent Service Code" := TransLine."Shipping Agent Service Code";
//               TransRcptLine."In-Transit Code" := TransLine."In-Transit Code";
//               TransRcptLine."Transfer-from Code" := TransLine."Transfer-from Code";
//               TransRcptLine."Transfer-to Code" := TransLine."Transfer-to Code";
//               TransRcptLine."Transfer-To Bin Code" := TransLine."Transfer-To Bin Code";
//               TransRcptLine."Shipping Time" := TransLine."Shipping Time";
//               TransRcptLine."Item Category Code" := TransLine."Item Category Code";
//               TransRcptLine."Product Group Code" := TransLine."Product Group Code";

//               TransRcptLine.INSERT;

//               IF TransLine."Qty. to Receive" > 0 THEN BEGIN
//                 OriginalQuantity := TransLine."Qty. to Receive";
//                 OriginalQuantityBase := TransLine."Qty. to Receive (Base)";
//                 PostItemJnlLine(TransLine,TransRcptHeader,TransRcptLine);
//                 TransRcptLine."Item Rcpt. Entry No." := InsertRcptEntryRelation(TransRcptLine);
//                 TransRcptLine.MODIFY;
//                 SaveTempWhseSplitSpec(TransLine);
//                 IF WhseReceive THEN BEGIN
//                   WhseRcptLine.SETCURRENTKEY(
//                     "No.","Source Type","Source Subtype","Source No.","Source Line No.");
//                   WhseRcptLine.SETRANGE("No.",WhseRcptHeader."No.");
//                   WhseRcptLine.SETRANGE("Source Type",DATABASE::"Transfer Line");
//                   WhseRcptLine.SETRANGE("Source No.",TransLine."Document No.");
//                   WhseRcptLine.SETRANGE("Source Line No.",TransLine."Line No.");
//                   WhseRcptLine.FINDFIRST;
//                   WhseRcptLine.TESTFIELD("Qty. to Receive",TransRcptLine.Quantity);
//                   WhsePostRcpt.SetItemEntryRelation(PostedWhseRcptHeader,PostedWhseRcptLine,TempItemEntryRelation2);
//                   WhsePostRcpt.CreatePostedRcptLine(
//                     WhseRcptLine,PostedWhseRcptHeader,PostedWhseRcptLine,TempWhseSplitSpecification);
//                 END;
//                 IF WhsePosting THEN
//                   PostWhseJnlLine(ItemJnlLine,OriginalQuantity,OriginalQuantityBase,TempWhseSplitSpecification);
//               END;
//             UNTIL TransLine.NEXT = 0;

//           InvtSetup.GET;
//           IF InvtSetup."Automatic Cost Adjustment" <>
//              InvtSetup."Automatic Cost Adjustment"::Never
//           THEN BEGIN
//             InvtAdjmt.SetProperties(TRUE,InvtSetup."Automatic Cost Posting");
//             InvtAdjmt.MakeMultiLevelAdjmt;
//           END;

//           ValueEntry.LOCKTABLE;
//           ItemLedgEntry.LOCKTABLE;
//           ItemApplnEntry.LOCKTABLE;
//           ItemReg.LOCKTABLE;
//           TransLine.LOCKTABLE;
//           IF WhsePosting THEN
//             WhseEntry.LOCKTABLE;

//           TransLine.SETFILTER(Quantity,'<>0');
//           TransLine.SETFILTER("Qty. to Receive",'<>0');
//           IF TransLine.FIND('-') THEN
//             REPEAT
//               TransLine.VALIDATE("Quantity Received",TransLine."Quantity Received" + TransLine."Qty. to Receive");
//               TransLine.UpdateWithWarehouseShipReceive;
//               ReservMgt.SetItemJnlLine(ItemJnlLine);
//               ReservMgt.SetItemTrackingHandling(1); // Allow deletion
//               ReservMgt.DeleteReservEntries(TRUE,0);
//               TransLine.MODIFY;
//             UNTIL TransLine.NEXT = 0;

//           IF WhseReceive THEN
//             WhseRcptLine.LOCKTABLE;
//           LOCKTABLE;
//           IF WhseReceive THEN BEGIN
//             WhsePostRcpt.PostUpdateWhseDocuments(WhseRcptHeader);
//             TempWhseRcptHeader.DELETE;
//           END;

//           "Last Receipt No." := TransRcptHeader."No.";
//           MODIFY;

//           TransLine.SETRANGE(Quantity);
//           TransLine.SETRANGE("Qty. to Receive");
//           HeaderDeleted := DeleteOneTransferOrder(TransHeader,TransLine);
//           IF NOT HeaderDeleted THEN BEGIN
//             WhseTransferRelease.Release(TransHeader);
//             ReserveTransLine.UpdateItemTrackingAfterPosting(TransHeader,1);
//           END;

//           IF NOT InvtPickPutaway THEN
//             COMMIT;
//           CLEAR(WhsePostRcpt);
//           CLEAR(InvtAdjmt);
//           Window.CLOSE;
//         END;
//         UpdateAnalysisView.UpdateAll(0,TRUE);
//         UpdateItemAnalysisView.UpdateAll(0,TRUE);
//         Rec := TransHeader;
//     end;

//     var
//         Text000: Label 'Transfer order %2 cannot be posted because %3 and %4 are the same.';
//         Text001: Label 'There is nothing to post.';
//         Text002: Label 'Warehouse handling is required for Transfer order = %1, %2 = %3.', Comment='1%=TransLine2."Document No."; 2%=TransLine2.FIELDCAPTION("Line No."); 3%=TransLine2."Line No.");';
//         Text003: Label 'Posting transfer lines     #2######';
//         Text004: Label 'Transfer Order %1';
//         Text005: Label 'The combination of dimensions used in transfer order %1 is blocked. %2.';
//         Text006: Label 'The combination of dimensions used in transfer order %1, line no. %2 is blocked. %3.';
//         Text007: Label 'The dimensions that are used in transfer order %1, line no. %2 are not valid. %3.';
//         Text008: Label 'Base Qty. to Receive must be 0.';
//         TransRcptHeader: Record "5746";
//         TransRcptLine: Record "5747";
//         TransHeader: Record "5740";
//         TransLine: Record "5741";
//         ItemJnlLine: Record "83";
//         Location: Record "14";
//         NewLocation: Record "14";
//         WhseRqst: Record "5765";
//         WhseRcptHeader: Record "7316";
//         TempWhseRcptHeader: Record "7316" temporary;
//         WhseRcptLine: Record "7317";
//         PostedWhseRcptHeader: Record "7318";
//         PostedWhseRcptLine: Record "7319";
//         TempWhseSplitSpecification: Record "336" temporary;
//         WhseEntry: Record "7312";
//         TempItemEntryRelation2: Record "6507" temporary;
//         NoSeriesLine: Record "309";
//         GLEntry: Record "17";
//         ItemJnlPostLine: Codeunit "22";
//         DimMgt: Codeunit "408";
//         WhseTransferRelease: Codeunit "5773";
//         ReserveTransLine: Codeunit "99000836";
//         WhsePostRcpt: Codeunit "5760";
//         InvtAdjmt: Codeunit "5895";
//         SourceCode: Code[10];
//         HideValidationDialog: Boolean;
//         HeaderDeleted: Boolean;
//         WhsePosting: Boolean;
//         WhseReference: Integer;
//         OriginalQuantity: Decimal;
//         OriginalQuantityBase: Decimal;
//         WhseReceive: Boolean;
//         InvtPickPutaway: Boolean;

//     local procedure PostItemJnlLine(var TransLine3: Record "5741";TransRcptHeader2: Record "5746";TransRcptLine2: Record "5747")
//     begin
//         ItemJnlLine.INIT;
//         ItemJnlLine."Posting Date" := TransRcptHeader2."Posting Date";
//         ItemJnlLine."Document Date" := TransRcptHeader2."Posting Date";
//         ItemJnlLine."Document No." := TransRcptHeader2."No.";
//         ItemJnlLine."Document Type" := ItemJnlLine."Document Type"::"Transfer Receipt";
//         ItemJnlLine."Document Line No." := TransRcptLine2."Line No.";
//         ItemJnlLine."Order Type" := ItemJnlLine."Order Type"::Transfer;
//         ItemJnlLine."Order No." := TransRcptHeader2."Transfer Order No.";
//         ItemJnlLine."Order Line No." := TransLine3."Line No.";
//         ItemJnlLine."External Document No." := TransRcptHeader2."External Document No.";
//         ItemJnlLine."Entry Type" := ItemJnlLine."Entry Type"::Transfer;
//         ItemJnlLine."Item No." := TransRcptLine2."Item No.";
//         ItemJnlLine.Description := TransRcptLine2.Description;
//         ItemJnlLine."Shortcut Dimension 1 Code" := TransRcptLine2."Shortcut Dimension 1 Code";
//         ItemJnlLine."New Shortcut Dimension 1 Code" := TransRcptLine2."Shortcut Dimension 1 Code";
//         ItemJnlLine."Shortcut Dimension 2 Code" := TransRcptLine2."Shortcut Dimension 2 Code";
//         ItemJnlLine."New Shortcut Dimension 2 Code" := TransRcptLine2."Shortcut Dimension 2 Code";
//         ItemJnlLine."Dimension Set ID" := TransRcptLine2."Dimension Set ID";
//         ItemJnlLine."New Dimension Set ID" := TransRcptLine2."Dimension Set ID";
//         ItemJnlLine."Location Code" := TransHeader."In-Transit Code";
//         ItemJnlLine."New Location Code" := TransRcptHeader2."Transfer-to Code";
//         ItemJnlLine.Quantity := TransRcptLine2.Quantity;
//         ItemJnlLine."Invoiced Quantity" := TransRcptLine2.Quantity;
//         ItemJnlLine."Quantity (Base)" := TransRcptLine2."Quantity (Base)";
//         ItemJnlLine."Invoiced Qty. (Base)" := TransRcptLine2."Quantity (Base)";
//         ItemJnlLine."Source Code" := SourceCode;
//         ItemJnlLine."Gen. Prod. Posting Group" := TransRcptLine2."Gen. Prod. Posting Group";
//         ItemJnlLine."Inventory Posting Group" := TransRcptLine2."Inventory Posting Group";
//         ItemJnlLine."Unit of Measure Code" := TransRcptLine2."Unit of Measure Code";
//         ItemJnlLine."Qty. per Unit of Measure" := TransRcptLine2."Qty. per Unit of Measure";
//         ItemJnlLine."Variant Code" := TransRcptLine2."Variant Code";
//         ItemJnlLine."New Bin Code" := TransLine."Transfer-To Bin Code";
//         ItemJnlLine."Product Group Code" := TransLine."Product Group Code";
//         ItemJnlLine."Item Category Code" := TransLine."Item Category Code";
//         IF TransHeader."In-Transit Code" <> '' THEN BEGIN
//           IF NewLocation.Code <> TransHeader."In-Transit Code" THEN
//             NewLocation.GET(TransHeader."In-Transit Code");
//           ItemJnlLine."Country/Region Code" := NewLocation."Country/Region Code";
//         END;
//         ItemJnlLine."Transaction Type" := TransRcptHeader2."Transaction Type";
//         ItemJnlLine."Transport Method" := TransRcptHeader2."Transport Method";
//         ItemJnlLine."Entry/Exit Point" := TransRcptHeader2."Entry/Exit Point";
//         ItemJnlLine.Area := TransRcptHeader2.Area;
//         ItemJnlLine."Transaction Specification" := TransRcptHeader2."Transaction Specification";
//         WriteDownDerivedLines(TransLine3);
//         ItemJnlPostLine.SetPostponeReservationHandling(TRUE);

//         ItemJnlPostLine.RunWithCheck(ItemJnlLine);
//     end;

//     local procedure CopyCommentLines(FromDocumentType: Integer;ToDocumentType: Integer;FromNumber: Code[20];ToNumber: Code[20])
//     var
//         InvtCommentLine: Record "5748";
//         InvtCommentLine2: Record "5748";
//     begin
//         InvtCommentLine.SETRANGE("Document Type",FromDocumentType);
//         InvtCommentLine.SETRANGE("No.",FromNumber);
//         IF InvtCommentLine.FIND('-') THEN
//           REPEAT
//             InvtCommentLine2 := InvtCommentLine;
//             InvtCommentLine2."Document Type" := ToDocumentType;
//             InvtCommentLine2."No." := ToNumber;
//             InvtCommentLine2.INSERT;
//           UNTIL InvtCommentLine.NEXT = 0;
//     end;

//     local procedure CheckDim()
//     begin
//         TransLine."Line No." := 0;
//         CheckDimComb(TransHeader,TransLine);
//         CheckDimValuePosting(TransHeader,TransLine);

//         TransLine.SETRANGE("Document No.",TransHeader."No.");
//         IF TransLine.FINDFIRST THEN BEGIN
//           CheckDimComb(TransHeader,TransLine);
//           CheckDimValuePosting(TransHeader,TransLine);
//         END;
//     end;

//     local procedure CheckDimComb(TransferHeader: Record "5740";TransferLine: Record "5741")
//     begin
//         IF TransferLine."Line No." = 0 THEN
//           IF NOT DimMgt.CheckDimIDComb(TransferHeader."Dimension Set ID") THEN
//             ERROR(
//               Text005,
//               TransHeader."No.",DimMgt.GetDimCombErr);
//         IF TransferLine."Line No." <> 0 THEN
//           IF NOT DimMgt.CheckDimIDComb(TransferLine."Dimension Set ID") THEN
//             ERROR(
//               Text006,
//               TransHeader."No.",TransferLine."Line No.",DimMgt.GetDimCombErr);
//     end;

//     local procedure CheckDimValuePosting(TransferHeader: Record "5740";TransferLine: Record "5741")
//     var
//         TableIDArr: array [10] of Integer;
//         NumberArr: array [10] of Code[20];
//     begin
//         TableIDArr[1] := DATABASE::Item;
//         NumberArr[1] := TransferLine."Item No.";
//         IF TransferLine."Line No." = 0 THEN
//           IF NOT DimMgt.CheckDimValuePosting(TableIDArr,NumberArr,TransferHeader."Dimension Set ID") THEN
//             ERROR(
//               Text007,
//               TransHeader."No.",TransferLine."Line No.",DimMgt.GetDimValuePostingErr);

//         IF TransferLine."Line No." <> 0 THEN
//           IF NOT DimMgt.CheckDimValuePosting(TableIDArr,NumberArr,TransferLine."Dimension Set ID") THEN
//             ERROR(
//               Text007,
//               TransHeader."No.",TransferLine."Line No.",DimMgt.GetDimValuePostingErr);
//     end;

//     procedure SetHideValidationDialog(NewHideValidationDialog: Boolean)
//     begin
//         HideValidationDialog := NewHideValidationDialog;
//     end;

//     procedure WriteDownDerivedLines(var TransLine3: Record "5741")
//     var
//         TransLine4: Record "5741";
//         T337: Record "337";
//         TempDerivedSpecification: Record "336" temporary;
//         ItemTrackingMgt: Codeunit "6500";
//         QtyToReceive: Decimal;
//         BaseQtyToReceive: Decimal;
//         TrackingSpecificationExists: Boolean;
//     begin
//         IF TransLine3."Item No." = 'TJDPTY' THEN
//           MESSAGE('stop');

//         TransLine4.SETRANGE("Document No.",TransLine3."Document No.");
//         TransLine4.SETRANGE("Derived From Line No.",TransLine3."Line No.");
//         IF TransLine4.FIND('-') THEN BEGIN
//           QtyToReceive := TransLine3."Qty. to Receive";
//           BaseQtyToReceive := TransLine3."Qty. to Receive (Base)";

//           T337.SETCURRENTKEY(
//             "Source ID","Source Ref. No.","Source Type","Source Subtype",
//             "Source Batch Name","Source Prod. Order Line");
//           T337.SETRANGE("Source ID",TransLine3."Document No.");
//           T337.SETRANGE("Source Ref. No.");
//           T337.SETRANGE("Source Type",DATABASE::"Transfer Line");
//           T337.SETRANGE("Source Subtype",1);
//           T337.SETRANGE("Source Batch Name",'');
//           T337.SETRANGE("Source Prod. Order Line",TransLine3."Line No.");
//           T337.SETFILTER("Qty. to Handle (Base)",'<>0');

//           TrackingSpecificationExists :=
//             ItemTrackingMgt.SumUpItemTracking(T337,TempDerivedSpecification,TRUE,FALSE);

//           REPEAT
//             IF TrackingSpecificationExists THEN BEGIN
//               TempDerivedSpecification.SETRANGE("Source Ref. No.",TransLine4."Line No.");
//               IF TempDerivedSpecification.FINDFIRST THEN BEGIN
//                 TransLine4."Qty. to Receive (Base)" := TempDerivedSpecification."Qty. to Handle (Base)";
//                 TransLine4."Qty. to Receive" := TempDerivedSpecification."Qty. to Handle";
//               END ELSE BEGIN
//                 TransLine4."Qty. to Receive (Base)" := 0;
//                 TransLine4."Qty. to Receive" := 0;
//               END;
//             END;
//             IF TransLine4."Qty. to Receive (Base)" <= BaseQtyToReceive THEN BEGIN
//               ReserveTransLine.TransferTransferToItemJnlLine(
//                 TransLine4,ItemJnlLine,TransLine4."Qty. to Receive (Base)",1);
//               TransLine4."Quantity (Base)" :=
//                 TransLine4."Quantity (Base)" - TransLine4."Qty. to Receive (Base)";
//               TransLine4.Quantity :=
//                 TransLine4.Quantity - TransLine4."Qty. to Receive";
//               BaseQtyToReceive := BaseQtyToReceive - TransLine4."Qty. to Receive (Base)";
//               QtyToReceive := QtyToReceive - TransLine4."Qty. to Receive";
//             END ELSE BEGIN
//               ReserveTransLine.TransferTransferToItemJnlLine(
//                 TransLine4,ItemJnlLine,BaseQtyToReceive,1);
//               TransLine4.Quantity := TransLine4.Quantity - QtyToReceive;
//               TransLine4."Quantity (Base)" := TransLine4."Quantity (Base)" - BaseQtyToReceive;
//               BaseQtyToReceive := 0;
//               QtyToReceive := 0;
//             END;
//             IF TransLine4."Quantity (Base)" = 0 THEN
//               TransLine4.DELETE
//             ELSE BEGIN
//               TransLine4."Qty. to Ship" := TransLine4.Quantity;
//               TransLine4."Qty. to Ship (Base)" := TransLine4."Quantity (Base)";
//               TransLine4."Qty. to Receive" := TransLine4.Quantity;
//               TransLine4."Qty. to Receive (Base)" := TransLine4."Quantity (Base)";
//               TransLine4."Quantity Shipped" := 0;
//               TransLine4."Qty. Shipped (Base)" := 0;
//               TransLine4."Quantity Received" := 0;
//               TransLine4."Qty. Received (Base)" := 0;
//               TransLine4."Qty. in Transit" := 0;
//               TransLine4."Qty. in Transit (Base)" := 0;
//               TransLine4."Outstanding Quantity" := TransLine4.Quantity;
//               TransLine4."Outstanding Qty. (Base)" := TransLine4."Quantity (Base)";
//               TransLine4.MODIFY;
//             END;
//           UNTIL (TransLine4.NEXT = 0) OR (BaseQtyToReceive = 0);
//         END;

//         IF BaseQtyToReceive <> 0 THEN
//           ERROR(Text008);
//     end;

//     local procedure InsertRcptEntryRelation(var TransRcptLine: Record "5747"): Integer
//     var
//         ItemEntryRelation: Record "6507";
//         TempItemEntryRelation: Record "6507" temporary;
//     begin
//         TempItemEntryRelation2.RESET;
//         TempItemEntryRelation2.DELETEALL;

//         IF ItemJnlPostLine.CollectItemEntryRelation(TempItemEntryRelation) THEN BEGIN
//           IF TempItemEntryRelation.FIND('-') THEN BEGIN
//             REPEAT
//               ItemEntryRelation := TempItemEntryRelation;
//               ItemEntryRelation.TransferFieldsTransRcptLine(TransRcptLine);
//               ItemEntryRelation.INSERT;
//               TempItemEntryRelation2 := TempItemEntryRelation;
//               TempItemEntryRelation2.INSERT;
//             UNTIL TempItemEntryRelation.NEXT = 0;
//             EXIT(0);
//           END;
//         END ELSE
//           EXIT(ItemJnlLine."Item Shpt. Entry No.");
//     end;

//     local procedure CheckWarehouse(var TransLine: Record "5741")
//     var
//         TransLine2: Record "5741";
//         WhseValidateSourceLine: Codeunit "5777";
//         ShowError: Boolean;
//     begin
//         TransLine2.COPY(TransLine);
//         IF TransLine2.FIND('-') THEN
//           REPEAT
//             GetLocation(TransLine2."Transfer-to Code");
//             IF Location."Require Receive" OR Location."Require Put-away" THEN BEGIN
//               IF Location."Bin Mandatory" THEN
//                 ShowError := TRUE
//               ELSE
//                 IF WhseValidateSourceLine.WhseLinesExist(
//                      DATABASE::"Transfer Line",
//                      1,// In
//                      TransLine2."Document No.",
//                      TransLine2."Line No.",
//                      0,
//                      TransLine2.Quantity)
//                 THEN
//                   ShowError := TRUE;

//               IF ShowError THEN
//                 ERROR(
//                   Text002,
//                   TransLine2."Document No.",
//                   TransLine2.FIELDCAPTION("Line No."),
//                   TransLine2."Line No.");
//             END;
//           UNTIL TransLine2.NEXT = 0;
//     end;

//     local procedure SaveTempWhseSplitSpec(TransLine: Record "5741")
//     var
//         TempHandlingSpecification: Record "336" temporary;
//     begin
//         TempWhseSplitSpecification.RESET;
//         TempWhseSplitSpecification.DELETEALL;
//         IF ItemJnlPostLine.CollectTrackingSpecification(TempHandlingSpecification) THEN
//           IF TempHandlingSpecification.FIND('-') THEN
//             REPEAT
//               TempWhseSplitSpecification := TempHandlingSpecification;
//               TempWhseSplitSpecification."Entry No." := TempHandlingSpecification."Transfer Item Entry No.";
//               TempWhseSplitSpecification."Source Type" := DATABASE::"Transfer Line";
//               TempWhseSplitSpecification."Source Subtype" := 1;
//               TempWhseSplitSpecification."Source ID" := TransLine."Document No.";
//               TempWhseSplitSpecification."Source Ref. No." := TransLine."Line No.";
//               TempWhseSplitSpecification.INSERT;
//             UNTIL TempHandlingSpecification.NEXT = 0;
//     end;

//     local procedure GetLocation(LocationCode: Code[10])
//     begin
//         IF LocationCode = '' THEN
//           Location.GetLocationSetup(LocationCode,Location)
//         ELSE
//           IF Location.Code <> LocationCode THEN
//             Location.GET(LocationCode);
//     end;

//     local procedure PostWhseJnlLine(ItemJnlLine: Record "83";OriginalQuantity: Decimal;OriginalQuantityBase: Decimal;var TempHandlingSpecification: Record "336" temporary)
//     var
//         WhseJnlLine: Record "7311";
//         TempWhseJnlLine2: Record "7311" temporary;
//         ItemTrackingMgt: Codeunit "6500";
//         WMSMgmt: Codeunit "7302";
//         WhseJnlPostLine: Codeunit "7301";
//     begin
//         WITH ItemJnlLine DO BEGIN
//           Quantity := OriginalQuantity;
//           "Quantity (Base)" := OriginalQuantityBase;
//           GetLocation("New Location Code");
//           IF Location."Bin Mandatory" THEN
//             IF WMSMgmt.CreateWhseJnlLine(ItemJnlLine,1,WhseJnlLine,TRUE) THEN BEGIN
//               WMSMgmt.SetTransferLine(TransLine,WhseJnlLine,1,TransRcptHeader."No.");
//               ItemTrackingMgt.SplitWhseJnlLine(WhseJnlLine,TempWhseJnlLine2,TempHandlingSpecification,TRUE);
//               IF TempWhseJnlLine2.FIND('-') THEN
//                 REPEAT
//                   WMSMgmt.CheckWhseJnlLine(TempWhseJnlLine2,1,0,TRUE);
//                   WhseJnlPostLine.RUN(TempWhseJnlLine2);
//                 UNTIL TempWhseJnlLine2.NEXT = 0;
//             END;
//         END;
//     end;

//     procedure SetWhseRcptHeader(var WhseRcptHeader2: Record "7316")
//     begin
//         WhseRcptHeader := WhseRcptHeader2;
//         TempWhseRcptHeader := WhseRcptHeader;
//         TempWhseRcptHeader.INSERT;
//     end;
// }

