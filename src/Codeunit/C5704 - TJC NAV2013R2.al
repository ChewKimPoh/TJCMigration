// codeunit 5704 "TransferOrder-Post Shipment"
// {
//     // DP.NCM 12/05/2017 TJC 390

//     Permissions = TableData 6507=i;
//     TableNo = 5740;

//     trigger OnRun()
//     var
//         Item: Record "27";
//         SourceCodeSetup: Record "242";
//         InvtSetup: Record "313";
//         InventoryPostingSetup: Record "5813";
//         NoSeriesMgt: Codeunit "396";
//         UpdateAnalysisView: Codeunit "410";
//         UpdateItemAnalysisView: Codeunit "7150";
//         CreateReservEntry: Codeunit "99000830";
//         Window: Dialog;
//         LineCount: Integer;
//         NextLineNo: Integer;
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
//           IF rTempLocation.COUNT > 1 THEN ERROR('You cannot have more than 1 Transfer-to Bin Code in the lines');
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

//           IF "Shipping Advice" = "Shipping Advice"::Complete THEN
//             IF NOT GetShippingAdvice THEN
//               ERROR(Text008);

//           CheckDim;

//           TransLine.RESET;
//           TransLine.SETRANGE("Document No.","No.");
//           TransLine.SETRANGE("Derived From Line No.",0);
//           TransLine.SETFILTER(Quantity,'<>0');
//           TransLine.SETFILTER("Qty. to Ship",'<>0');
//           IF NOT TransLine.FIND('-') THEN
//             ERROR(Text001);

//           CheckItemInInventory(TransLine);

//           WhseShip := TempWhseShptHeader.FINDFIRST;
//           InvtPickPutaway := WhseReference <> 0;
//           IF NOT (WhseShip OR InvtPickPutaway) THEN
//             CheckWarehouse(TransLine);

//           GetLocation("Transfer-from Code");
//           IF Location."Bin Mandatory" AND NOT (WhseShip OR InvtPickPutaway) THEN
//             WhsePosting := TRUE;

//           Window.OPEN(
//             '#1#################################\\' +
//             Text003);

//           Window.UPDATE(1,STRSUBSTNO(Text004,"No."));

//           SourceCodeSetup.GET;
//           SourceCode := SourceCodeSetup.Transfer;
//           InvtSetup.GET;
//           InvtSetup.TESTFIELD("Posted Transfer Shpt. Nos.");
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

//           // Insert shipment header
//           PostedWhseShptHeader.LOCKTABLE;
//           TransShptHeader.LOCKTABLE;
//           TransShptHeader.INIT;
//           TransShptHeader."Transfer-from Code" := "Transfer-from Code";
//           TransShptHeader."Transfer-from Name" := "Transfer-from Name";
//           TransShptHeader."Transfer-from Name 2" := "Transfer-from Name 2";
//           TransShptHeader."Transfer-from Address" := "Transfer-from Address";
//           TransShptHeader."Transfer-from Address 2" := "Transfer-from Address 2";
//           TransShptHeader."Transfer-from Post Code" := "Transfer-from Post Code";
//           TransShptHeader."Transfer-from City" := "Transfer-from City";
//           TransShptHeader."Transfer-from County" := "Transfer-from County";
//           TransShptHeader."Trsf.-from Country/Region Code" := "Trsf.-from Country/Region Code";
//           TransShptHeader."Transfer-from Contact" := "Transfer-from Contact";
//           TransShptHeader."Transfer-to Code" := "Transfer-to Code";
//           TransShptHeader."Transfer-to Name" := "Transfer-to Name";
//           TransShptHeader."Transfer-to Name 2" := "Transfer-to Name 2";
//           TransShptHeader."Transfer-to Address" := "Transfer-to Address";
//           TransShptHeader."Transfer-to Address 2" := "Transfer-to Address 2";
//           TransShptHeader."Transfer-to Post Code" := "Transfer-to Post Code";
//           TransShptHeader."Transfer-to City" := "Transfer-to City";
//           TransShptHeader."Transfer-to County" := "Transfer-to County";
//           TransShptHeader."Trsf.-to Country/Region Code" := "Trsf.-to Country/Region Code";
//           TransShptHeader."Transfer-to Contact" := "Transfer-to Contact";
//           TransShptHeader."Transfer Order Date" := "Posting Date";
//           TransShptHeader."Posting Date" := "Posting Date";
//           TransShptHeader."Shipment Date" := "Shipment Date";
//           TransShptHeader."Receipt Date" := "Receipt Date";
//           TransShptHeader."Shortcut Dimension 1 Code" := "Shortcut Dimension 1 Code";
//           TransShptHeader."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
//           TransShptHeader."Dimension Set ID" := "Dimension Set ID";
//           TransShptHeader."Transfer Order No." := "No.";
//           TransShptHeader."External Document No." := "External Document No.";
//           TransShptHeader."In-Transit Code" := "In-Transit Code";
//           TransShptHeader."Shipping Agent Code" := "Shipping Agent Code";
//           TransShptHeader."Shipping Agent Service Code" := "Shipping Agent Service Code";
//           TransShptHeader."Shipment Method Code" := "Shipment Method Code";
//           TransShptHeader."Transaction Type" := "Transaction Type";
//           TransShptHeader."Transport Method" := "Transport Method";
//           TransShptHeader."Entry/Exit Point" := "Entry/Exit Point";
//           TransShptHeader.Area := Area;
//           TransShptHeader."Transaction Specification" := "Transaction Specification";
//           TransShptHeader."No. Series" := InvtSetup."Posted Transfer Shpt. Nos.";
//           TransShptHeader."No." :=
//             NoSeriesMgt.GetNextNo(
//               InvtSetup."Posted Transfer Shpt. Nos.","Posting Date",TRUE);
//           TransShptHeader.INSERT;

//           IF InvtSetup."Copy Comments Order to Shpt." THEN BEGIN
//             CopyCommentLines(1,2,"No.",TransShptHeader."No.");
//             TransShptHeader.COPYLINKS(Rec);
//           END;

//           IF WhseShip THEN BEGIN
//             WhseShptHeader.GET(TempWhseShptHeader."No.");
//             WhsePostShpt.CreatePostedShptHeader(PostedWhseShptHeader,WhseShptHeader,TransShptHeader."No.","Posting Date");
//           END;

//           // Insert shipment lines
//           LineCount := 0;
//           IF WhseShip THEN
//             PostedWhseShptLine.LOCKTABLE;
//           IF InvtPickPutaway THEN
//             WhseRqst.LOCKTABLE;
//           TransShptLine.LOCKTABLE;
//           TransLine.SETRANGE(Quantity);
//           TransLine.SETRANGE("Qty. to Ship");
//           IF TransLine.FIND('-') THEN
//             REPEAT
//               LineCount := LineCount + 1;
//               Window.UPDATE(2,LineCount);

//               IF TransLine."Item No." <> '' THEN BEGIN
//                 Item.GET(TransLine."Item No.");
//                 Item.TESTFIELD(Blocked,FALSE);
//               END;

//               TransShptLine.INIT;
//               TransShptLine."Document No." := TransShptHeader."No.";
//               TransShptLine."Line No." := TransLine."Line No.";
//               TransShptLine."Item No." := TransLine."Item No.";
//               TransShptLine.Description := TransLine.Description;
//               TransShptLine.Quantity := TransLine."Qty. to Ship";
//               TransShptLine."Unit of Measure" := TransLine."Unit of Measure";
//               TransShptLine."Shortcut Dimension 1 Code" := TransLine."Shortcut Dimension 1 Code";
//               TransShptLine."Shortcut Dimension 2 Code" := TransLine."Shortcut Dimension 2 Code";
//               TransShptLine."Dimension Set ID" := TransLine."Dimension Set ID";
//               TransShptLine."Gen. Prod. Posting Group" := TransLine."Gen. Prod. Posting Group";
//               TransShptLine."Inventory Posting Group" := TransLine."Inventory Posting Group";
//               TransShptLine."Quantity (Base)" := TransLine."Qty. to Ship (Base)";
//               TransShptLine."Qty. per Unit of Measure" := TransLine."Qty. per Unit of Measure";
//               TransShptLine."Unit of Measure Code" := TransLine."Unit of Measure Code";
//               TransShptLine."Gross Weight" := TransLine."Gross Weight";
//               TransShptLine."Net Weight" := TransLine."Net Weight";
//               TransShptLine."Unit Volume" := TransLine."Unit Volume";
//               TransShptLine."Variant Code" := TransLine."Variant Code";
//               TransShptLine."Units per Parcel" := TransLine."Units per Parcel";
//               TransShptLine."Description 2" := TransLine."Description 2";
//               TransShptLine."Transfer Order No." := TransLine."Document No.";
//               TransShptLine."Shipment Date" := TransLine."Shipment Date";
//               TransShptLine."Shipping Agent Code" := TransLine."Shipping Agent Code";
//               TransShptLine."Shipping Agent Service Code" := TransLine."Shipping Agent Service Code";
//               TransShptLine."In-Transit Code" := TransLine."In-Transit Code";
//               TransShptLine."Transfer-from Code" := TransLine."Transfer-from Code";
//               TransShptLine."Transfer-to Code" := TransLine."Transfer-to Code";
//               TransShptLine."Transfer-from Bin Code" := TransLine."Transfer-from Bin Code";
//               TransShptLine."Shipping Time" := TransLine."Shipping Time";
//               TransShptLine."Item Category Code" := TransLine."Item Category Code";
//               TransShptLine."Product Group Code" := TransLine."Product Group Code";

//               IF TransLine."Qty. to Ship" > 0 THEN BEGIN
//                 OriginalQuantity := TransLine."Qty. to Ship";
//                 OriginalQuantityBase := TransLine."Qty. to Ship (Base)";
//                 PostItemJnlLine(TransLine,TransShptHeader,TransShptLine);
//                 TransShptLine."Item Shpt. Entry No." := InsertShptEntryRelation(TransShptLine);
//                 IF WhseShip THEN BEGIN
//                   WhseShptLine.SETCURRENTKEY(
//                     "No.","Source Type","Source Subtype","Source No.","Source Line No.");
//                   WhseShptLine.SETRANGE("No.",WhseShptHeader."No.");
//                   WhseShptLine.SETRANGE("Source Type",DATABASE::"Transfer Line");
//                   WhseShptLine.SETRANGE("Source No.",TransLine."Document No.");
//                   WhseShptLine.SETRANGE("Source Line No.",TransLine."Line No.");
//                   WhseShptLine.FINDFIRST;
//                   WhseShptLine.TESTFIELD("Qty. to Ship",TransShptLine.Quantity);
//                   WhsePostShpt.CreatePostedShptLine(
//                     WhseShptLine,PostedWhseShptHeader,PostedWhseShptLine,TempWhseSplitSpecification);
//                 END;
//                 IF WhsePosting THEN
//                   PostWhseJnlLine(ItemJnlLine,OriginalQuantity,OriginalQuantityBase);
//               END;
//               TransShptLine.INSERT;
//             UNTIL TransLine.NEXT = 0;

//           InvtSetup.GET;
//           IF InvtSetup."Automatic Cost Adjustment" <>
//              InvtSetup."Automatic Cost Adjustment"::Never
//           THEN BEGIN
//             InvtAdjmt.SetProperties(TRUE,InvtSetup."Automatic Cost Posting");
//             InvtAdjmt.MakeMultiLevelAdjmt;
//           END;

//           IF WhseShip THEN
//             WhseShptLine.LOCKTABLE;
//           TransLine.LOCKTABLE;
//           TransLine.SETFILTER(Quantity,'<>0');
//           TransLine.SETFILTER("Qty. to Ship",'<>0');
//           IF TransLine.FIND('-') THEN BEGIN
//             NextLineNo := AssignLineNo(TransLine."Document No.");
//             REPEAT
//               TransLine2.INIT;
//               TransLine2 := TransLine;
//               TransLine2."Transfer-from Code" := TransLine."In-Transit Code";
//               TransLine2."In-Transit Code" := '';
//               TransLine2."Derived From Line No." := TransLine."Line No.";
//               TransLine2."Line No." := NextLineNo;
//               NextLineNo := NextLineNo + 10000;
//               TransLine2.Quantity := TransLine."Qty. to Ship";
//               TransLine2."Quantity (Base)" := TransLine."Qty. to Ship (Base)";
//               TransLine2."Qty. to Ship" := TransLine2.Quantity;
//               TransLine2."Qty. to Ship (Base)" := TransLine2."Quantity (Base)";
//               TransLine2."Qty. to Receive" := TransLine2.Quantity;
//               TransLine2."Qty. to Receive (Base)" := TransLine2."Quantity (Base)";
//               TransLine2."Quantity Shipped" := 0;
//               TransLine2."Qty. Shipped (Base)" := 0;
//               TransLine2."Quantity Received" := 0;
//               TransLine2."Qty. Received (Base)" := 0;
//               TransLine2."Qty. in Transit" := 0;
//               TransLine2."Qty. in Transit (Base)" := 0;
//               TransLine2."Outstanding Quantity" := TransLine2.Quantity;
//               TransLine2."Outstanding Qty. (Base)" := TransLine2."Quantity (Base)";
//               TransLine2.INSERT;

//               TransferTracking(TransLine,TransLine2,TransLine."Qty. to Ship (Base)");

//               TransLine.VALIDATE("Quantity Shipped",TransLine."Quantity Shipped" + TransLine."Qty. to Ship");

//               TransLine.UpdateWithWarehouseShipReceive;

//               TransLine.MODIFY;
//             UNTIL TransLine.NEXT = 0;
//           END;

//           IF WhseShip THEN
//             WhseShptLine.LOCKTABLE;
//           LOCKTABLE;
//           IF WhseShip THEN BEGIN
//             WhsePostShpt.PostUpdateWhseDocuments(WhseShptHeader);
//             TempWhseShptHeader.DELETE;
//           END;

//           "Last Shipment No." := TransShptHeader."No.";
//           MODIFY;

//           TransLine.SETRANGE(Quantity);
//           TransLine.SETRANGE("Qty. to Ship");
//           HeaderDeleted := DeleteOneTransferOrder(TransHeader,TransLine);
//           IF NOT HeaderDeleted THEN BEGIN
//             WhseTransferRelease.Release(TransHeader);
//             ReserveTransLine.UpdateItemTrackingAfterPosting(TransHeader,0);
//             CreateReservEntry.UpdReservEntryAfterPostingPick(TransHeader);
//           END;

//           IF NOT InvtPickPutaway THEN
//             COMMIT;
//           CLEAR(WhsePostShpt);
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
//         Text002: Label 'Warehouse handling is required for Transfer order = %1, %2 = %3.';
//         Text003: Label 'Posting transfer lines     #2######';
//         Text004: Label 'Transfer Order %1';
//         Text005: Label 'The combination of dimensions used in transfer order %1 is blocked. %2';
//         Text006: Label 'The combination of dimensions used in transfer order %1, line no. %2 is blocked. %3';
//         Text007: Label 'The dimensions that are used in transfer order %1, line no. %2 are not valid. %3.';
//         TransShptHeader: Record "5744";
//         TransShptLine: Record "5745";
//         TransHeader: Record "5740";
//         TransLine: Record "5741";
//         TransLine2: Record "5741";
//         Location: Record "14";
//         ItemJnlLine: Record "83";
//         WhseRqst: Record "5765";
//         WhseShptHeader: Record "7320";
//         TempWhseShptHeader: Record "7320" temporary;
//         WhseShptLine: Record "7321";
//         PostedWhseShptHeader: Record "7322";
//         PostedWhseShptLine: Record "7323";
//         TempWhseSplitSpecification: Record "336" temporary;
//         TempHandlingSpecification: Record "336" temporary;
//         NoSeriesLine: Record "309";
//         GLEntry: Record "17";
//         ItemJnlPostLine: Codeunit "22";
//         DimMgt: Codeunit "408";
//         WhseTransferRelease: Codeunit "5773";
//         ReserveTransLine: Codeunit "99000836";
//         WhsePostShpt: Codeunit "5763";
//         InvtAdjmt: Codeunit "5895";
//         SourceCode: Code[10];
//         HideValidationDialog: Boolean;
//         HeaderDeleted: Boolean;
//         WhseShip: Boolean;
//         WhsePosting: Boolean;
//         InvtPickPutaway: Boolean;
//         WhseReference: Integer;
//         OriginalQuantity: Decimal;
//         OriginalQuantityBase: Decimal;
//         Text008: Label 'This order must be a complete shipment.';
//         Text009: Label 'Item %1 is not in inventory.';

//     local procedure PostItemJnlLine(var TransLine3: Record "5741";TransShptHeader2: Record "5744";TransShptLine2: Record "5745")
//     begin
//         ItemJnlLine.INIT;
//         ItemJnlLine."Posting Date" := TransShptHeader2."Posting Date";
//         ItemJnlLine."Document Date" := TransShptHeader2."Posting Date";
//         ItemJnlLine."Document No." := TransShptHeader2."No.";
//         ItemJnlLine."Document Type" := ItemJnlLine."Document Type"::"Transfer Shipment";
//         ItemJnlLine."Document Line No." := TransShptLine2."Line No.";
//         ItemJnlLine."Order Type" := ItemJnlLine."Order Type"::Transfer;
//         ItemJnlLine."Order No." := TransShptHeader2."Transfer Order No.";
//         ItemJnlLine."Order Line No." := TransLine3."Line No.";
//         ItemJnlLine."External Document No." := TransShptHeader2."External Document No.";
//         ItemJnlLine."Entry Type" := ItemJnlLine."Entry Type"::Transfer;
//         ItemJnlLine."Item No." := TransShptLine2."Item No.";
//         ItemJnlLine.Description := TransShptLine2.Description;
//         ItemJnlLine."Shortcut Dimension 1 Code" := TransShptLine2."Shortcut Dimension 1 Code";
//         ItemJnlLine."New Shortcut Dimension 1 Code" := TransShptLine2."Shortcut Dimension 1 Code";
//         ItemJnlLine."Shortcut Dimension 2 Code" := TransShptLine2."Shortcut Dimension 2 Code";
//         ItemJnlLine."New Shortcut Dimension 2 Code" := TransShptLine2."Shortcut Dimension 2 Code";
//         ItemJnlLine."Dimension Set ID" := TransShptLine2."Dimension Set ID";
//         ItemJnlLine."New Dimension Set ID" := TransShptLine2."Dimension Set ID";
//         ItemJnlLine."Location Code" := TransShptHeader2."Transfer-from Code";
//         ItemJnlLine."New Location Code" := TransHeader."In-Transit Code";
//         ItemJnlLine.Quantity := TransShptLine2.Quantity;
//         ItemJnlLine."Invoiced Quantity" := TransShptLine2.Quantity;
//         ItemJnlLine."Quantity (Base)" := TransShptLine2."Quantity (Base)";
//         ItemJnlLine."Invoiced Qty. (Base)" := TransShptLine2."Quantity (Base)";
//         ItemJnlLine."Source Code" := SourceCode;
//         ItemJnlLine."Gen. Prod. Posting Group" := TransShptLine2."Gen. Prod. Posting Group";
//         ItemJnlLine."Inventory Posting Group" := TransShptLine2."Inventory Posting Group";
//         ItemJnlLine."Unit of Measure Code" := TransShptLine2."Unit of Measure Code";
//         ItemJnlLine."Qty. per Unit of Measure" := TransShptLine2."Qty. per Unit of Measure";
//         ItemJnlLine."Variant Code" := TransShptLine2."Variant Code";
//         ItemJnlLine."Bin Code" := TransLine."Transfer-from Bin Code";
//         ItemJnlLine."Country/Region Code" := TransShptHeader2."Trsf.-from Country/Region Code";
//         ItemJnlLine."Transaction Type" := TransShptHeader2."Transaction Type";
//         ItemJnlLine."Transport Method" := TransShptHeader2."Transport Method";
//         ItemJnlLine."Entry/Exit Point" := TransShptHeader2."Entry/Exit Point";
//         ItemJnlLine.Area := TransShptHeader2.Area;
//         ItemJnlLine."Transaction Specification" := TransShptHeader2."Transaction Specification";
//         ItemJnlLine."Product Group Code" := TransLine."Product Group Code";
//         ItemJnlLine."Item Category Code" := TransLine."Item Category Code";

//         ReserveTransLine.TransferTransferToItemJnlLine(TransLine3,
//           ItemJnlLine,ItemJnlLine."Quantity (Base)",0);

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
//             ERROR(Text007,TransHeader."No.",TransferLine."Line No.",DimMgt.GetDimValuePostingErr);

//         IF TransferLine."Line No." <> 0 THEN
//           IF NOT DimMgt.CheckDimValuePosting(TableIDArr,NumberArr,TransferLine."Dimension Set ID") THEN
//             ERROR(Text007,TransHeader."No.",TransferLine."Line No.",DimMgt.GetDimValuePostingErr);
//     end;

//     procedure SetHideValidationDialog(NewHideValidationDialog: Boolean)
//     begin
//         HideValidationDialog := NewHideValidationDialog;
//     end;

//     local procedure AssignLineNo(FromDocNo: Code[20]): Integer
//     var
//         TransLine3: Record "5741";
//     begin
//         TransLine3.SETRANGE("Document No.",FromDocNo);
//         IF TransLine3.FINDLAST THEN
//           EXIT(TransLine3."Line No." + 10000);
//     end;

//     local procedure InsertShptEntryRelation(var TransShptLine: Record "5745"): Integer
//     var
//         TempHandlingSpecification2: Record "336" temporary;
//         ItemEntryRelation: Record "6507";
//         ItemTrackingMgt: Codeunit "6500";
//         WhseSNRequired: Boolean;
//         WhseLNRequired: Boolean;
//     begin
//         IF WhsePosting THEN BEGIN
//           TempWhseSplitSpecification.RESET;
//           TempWhseSplitSpecification.DELETEALL;
//         END;

//         TempHandlingSpecification2.RESET;
//         IF ItemJnlPostLine.CollectTrackingSpecification(TempHandlingSpecification2) THEN BEGIN
//           TempHandlingSpecification2.SETRANGE("Buffer Status",0);
//           IF TempHandlingSpecification2.FIND('-') THEN BEGIN
//             REPEAT
//               IF WhsePosting OR WhseShip OR InvtPickPutaway THEN BEGIN
//                 ItemTrackingMgt.CheckWhseItemTrkgSetup(
//                   TransShptLine."Item No.",WhseSNRequired,WhseLNRequired,FALSE);
//                 IF WhseSNRequired OR WhseLNRequired THEN BEGIN
//                   TempWhseSplitSpecification := TempHandlingSpecification2;
//                   TempWhseSplitSpecification."Source Type" := DATABASE::"Transfer Line";
//                   TempWhseSplitSpecification."Source ID" := TransLine."Document No.";
//                   TempWhseSplitSpecification."Source Ref. No." := TransLine."Line No.";
//                   TempWhseSplitSpecification.INSERT;
//                 END;
//               END;

//               ItemEntryRelation.INIT;
//               ItemEntryRelation."Item Entry No." := TempHandlingSpecification2."Entry No.";
//               ItemEntryRelation."Serial No." := TempHandlingSpecification2."Serial No.";
//               ItemEntryRelation."Lot No." := TempHandlingSpecification2."Lot No.";
//               ItemEntryRelation.TransferFieldsTransShptLine(TransShptLine);
//               ItemEntryRelation.INSERT;
//               TempHandlingSpecification := TempHandlingSpecification2;
//               TempHandlingSpecification."Source Prod. Order Line" := TransShptLine."Line No.";
//               TempHandlingSpecification."Buffer Status" := TempHandlingSpecification."Buffer Status"::MODIFY;
//               TempHandlingSpecification.INSERT;
//             UNTIL TempHandlingSpecification2.NEXT = 0;
//             EXIT(0);
//           END;
//         END ELSE
//           EXIT(ItemJnlLine."Item Shpt. Entry No.");
//     end;

//     procedure TransferTracking(var FromTransLine: Record "5741";var ToTransLine: Record "5741";TransferQty: Decimal)
//     var
//         DummySpecification: Record "336";
//     begin
//         TempHandlingSpecification.RESET;
//         TempHandlingSpecification.SETRANGE("Source Prod. Order Line",ToTransLine."Derived From Line No.");
//         IF TempHandlingSpecification.FIND('-') THEN BEGIN
//           REPEAT
//             ReserveTransLine.TransferTransferToTransfer(
//               FromTransLine,ToTransLine,-TempHandlingSpecification."Quantity (Base)",1,TempHandlingSpecification);
//             TransferQty += TempHandlingSpecification."Quantity (Base)";
//           UNTIL TempHandlingSpecification.NEXT = 0;
//           TempHandlingSpecification.DELETEALL;
//         END;

//         IF TransferQty > 0 THEN
//           ReserveTransLine.TransferTransferToTransfer(
//             FromTransLine,ToTransLine,TransferQty,1,DummySpecification);
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
//             GetLocation(TransLine2."Transfer-from Code");
//             IF Location."Require Pick" OR Location."Require Shipment" THEN BEGIN
//               IF Location."Bin Mandatory" THEN
//                 ShowError := TRUE
//               ELSE
//                 IF WhseValidateSourceLine.WhseLinesExist(
//                      DATABASE::"Transfer Line",
//                      0,// Out
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

//     local procedure GetLocation(LocationCode: Code[10])
//     begin
//         IF LocationCode = '' THEN
//           Location.GetLocationSetup(LocationCode,Location)
//         ELSE
//           IF Location.Code <> LocationCode THEN
//             Location.GET(LocationCode);
//     end;

//     local procedure PostWhseJnlLine(ItemJnlLine: Record "83";OriginalQuantity: Decimal;OriginalQuantityBase: Decimal)
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
//           GetLocation("Location Code");
//           IF Location."Bin Mandatory" THEN
//             IF WMSMgmt.CreateWhseJnlLine(ItemJnlLine,1,WhseJnlLine,FALSE) THEN BEGIN
//               WMSMgmt.SetTransferLine(TransLine,WhseJnlLine,0,TransShptHeader."No.");
//               ItemTrackingMgt.SplitWhseJnlLine(
//                 WhseJnlLine,TempWhseJnlLine2,TempWhseSplitSpecification,TRUE);
//               IF TempWhseJnlLine2.FIND('-') THEN
//                 REPEAT
//                   WMSMgmt.CheckWhseJnlLine(TempWhseJnlLine2,1,0,TRUE);
//                   WhseJnlPostLine.RUN(TempWhseJnlLine2);
//                 UNTIL TempWhseJnlLine2.NEXT = 0;
//             END;
//         END;
//     end;

//     procedure SetWhseShptHeader(var WhseShptHeader2: Record "7320")
//     begin
//         WhseShptHeader := WhseShptHeader2;
//         TempWhseShptHeader := WhseShptHeader;
//         TempWhseShptHeader.INSERT;
//     end;

//     local procedure GetShippingAdvice(): Boolean
//     var
//         TransLine: Record "5741";
//     begin
//         TransLine.SETRANGE("Document No.",TransHeader."No.");
//         IF TransLine.FIND('-') THEN
//           REPEAT
//             IF TransLine."Quantity (Base)" <>
//                TransLine."Qty. to Ship (Base)" + TransLine."Qty. Shipped (Base)"
//             THEN
//               EXIT(FALSE);
//           UNTIL TransLine.NEXT = 0;
//         EXIT(TRUE);
//     end;

//     local procedure CheckItemInInventory(TransLine: Record "5741")
//     var
//         Item: Record "27";
//     begin
//         WITH Item DO BEGIN
//           GET(TransLine."Item No.");
//           SETFILTER("Variant Filter",TransLine."Variant Code");
//           SETFILTER("Location Filter",TransLine."Transfer-from Code");
//           CALCFIELDS(Inventory);
//           IF Inventory <= 0 THEN
//             ERROR(Text009,TransLine."Item No.");
//         END;
//     end;
// }

