// codeunit 6500 "Item Tracking Management"
// {
//     // TJCSG1.00
//     //  1. 05/09/2014  dp.dst
//     //     Last Change Date: 08/09/2014.
//     //     - Enhanced the logic of all the Auto Assign Lot No. functions to get the correct Base Qty for:
//     //       - Sales Order (AutoAssignLotNo)
//     //       - Transfer Order (AutoAssignTransferAllLotNo)
//     //  2. DP.NCM 21012015 DD 289 - Fix issue in AutoAssignTransferAllLotNo function
//     //  3. DP.NCM 21012015 DD 298 - Update filter to get Oldest Expire Date first
//     //  4. DP.NCM 14/03/2016 - Fix issue with Item Tracking Line populated with negative quantity

//     Permissions = TableData 6507=rd,
//                   TableData 6508=rd,
//                   TableData 6550=rimd;

//     trigger OnRun()
//     var
//         ItemTrackingForm: Page "6510";
//     begin
//         SourceSpecification.TESTFIELD("Source Type");
//         ItemTrackingForm.RegisterItemTrackingLines(
//           SourceSpecification,DueDate,TempTrackingSpecification)
//     end;

//     var
//         Text001: Label 'The quantity to %1 does not match the quantity defined in item tracking.';
//         Text002: Label 'Cannot match item tracking.';
//         Text003: Label 'No information exists for %1 %2.';
//         Text004: Label 'Counting records...';
//         Text005: Label 'Warehouse item tracking is not enabled for %1 %2.';
//         SourceSpecification: Record "336" temporary;
//         TempTrackingSpecification: Record "336" temporary;
//         TempGlobalWhseItemTrkgLine: Record "6550" temporary;
//         DueDate: Date;
//         Text006: Label 'Synchronization cancelled.';
//         Registering: Boolean;
//         Text007: Label 'There are multiple expiration dates registered for lot %1.';
//         text008: Label '%1 already exists for %2 %3. Do you want to overwrite the existing information?';
//         Text009: Label 'Table %1 is not supported.';
//         IsConsume: Boolean;
//         Text010: Label 'invoice';
//         Text011: Label '%1 must not be %2.';
//         Text012: Label 'Only one expiration date is allowed per lot number.\%1 currently has two different expiration dates: %2 and %3.';
//         IsPick: Boolean;
//         RetrieveAsmItemTracking: Boolean;
//         DeleteReservationEntries: Boolean;
//         Text50000: Label 'Qty defined in Item Tracking for Line No. %1 is not completed.';

//     procedure SetPointerFilter(var TrackingSpecification: Record "336")
//     begin
//         WITH TrackingSpecification DO BEGIN
//           SETCURRENTKEY("Source ID","Source Type","Source Subtype","Source Batch Name",
//             "Source Prod. Order Line","Source Ref. No.");
//           SETRANGE("Source Type","Source Type");
//           SETRANGE("Source Subtype","Source Subtype");
//           SETRANGE("Source ID","Source ID");
//           SETRANGE("Source Batch Name","Source Batch Name");
//           SETRANGE("Source Prod. Order Line","Source Prod. Order Line");
//           SETRANGE("Source Ref. No.","Source Ref. No.");
//         END;
//     end;

//     procedure LookupLotSerialNoInfo(ItemNo: Code[20];Variant: Code[20];LookupType: Option "Serial No.","Lot No.";LookupNo: Code[20])
//     var
//         LotNoInfo: Record "6505";
//         SerialNoInfo: Record "6504";
//     begin
//         CASE LookupType OF
//           LookupType::"Serial No.":
//             BEGIN
//               IF NOT SerialNoInfo.GET(ItemNo,Variant,LookupNo) THEN
//                 ERROR(Text003,SerialNoInfo.FIELDCAPTION("Serial No."),LookupNo);
//               PAGE.RUNMODAL(0,SerialNoInfo);
//             END;
//           LookupType::"Lot No.":
//             BEGIN
//               IF NOT LotNoInfo.GET(ItemNo,Variant,LookupNo) THEN
//                 ERROR(Text003,LotNoInfo.FIELDCAPTION("Lot No."),LookupNo);
//               PAGE.RUNMODAL(0,LotNoInfo);
//             END;
//         END;
//     end;

//     procedure CreateTrackingSpecification(var FromReservEntry: Record "337";var ToTrackingSpecification: Record "336")
//     begin
//         ToTrackingSpecification.INIT;
//         ToTrackingSpecification.TRANSFERFIELDS(FromReservEntry);
//         ToTrackingSpecification."Qty. to Handle (Base)" := 0;
//         ToTrackingSpecification."Qty. to Invoice (Base)" := 0;
//         ToTrackingSpecification."Quantity Handled (Base)" := FromReservEntry."Qty. to Handle (Base)";
//         ToTrackingSpecification."Quantity Invoiced (Base)" := FromReservEntry."Qty. to Invoice (Base)";
//     end;

//     procedure InsertTrackingSpecification(var TrackingSpecification: Record "336")
//     var
//         TrackingSpecification2: Record "336";
//     begin
//         IF TrackingSpecification2.FINDLAST THEN
//           TrackingSpecification."Entry No." := TrackingSpecification2."Entry No." + 1
//         ELSE
//           TrackingSpecification."Entry No." := 1;
//         TrackingSpecification.INSERT;
//     end;

//     procedure DeleteRelatedTrkgSpecification(ReservEntry: Record "337")
//     var
//         TrackingSpecification: Record "336";
//     begin
//         TrackingSpecification.SETCURRENTKEY("Source ID");
//         TrackingSpecification.TRANSFERFIELDS(ReservEntry);
//         SetPointerFilter(TrackingSpecification);
//         TrackingSpecification.DELETEALL;
//     end;

//     procedure GetItemTrackingSettings(var ItemTrackingCode: Record "6502";EntryType: Option Purchase,Sale,"Positive Adjmt.","Negative Adjmt.",Transfer,Consumption,Output," ","Assembly Consumption","Assembly Output";Inbound: Boolean;var SNRequired: Boolean;var LotRequired: Boolean;var SNInfoRequired: Boolean;var LotInfoRequired: Boolean)
//     begin
//         SNRequired := FALSE;
//         LotRequired := FALSE;
//         SNInfoRequired := FALSE;
//         LotInfoRequired := FALSE;

//         IF ItemTrackingCode.Code = '' THEN BEGIN
//           CLEAR(ItemTrackingCode);
//           EXIT;
//         END;
//         ItemTrackingCode.GET(ItemTrackingCode.Code);

//         SNInfoRequired := (Inbound AND ItemTrackingCode."SN Info. Inbound Must Exist") OR
//           (NOT Inbound AND ItemTrackingCode."SN Info. Outbound Must Exist");

//         LotInfoRequired := (Inbound AND ItemTrackingCode."Lot Info. Inbound Must Exist") OR
//           (NOT Inbound AND ItemTrackingCode."Lot Info. Outbound Must Exist");

//         IF ItemTrackingCode."SN Specific Tracking" THEN BEGIN
//           SNRequired := TRUE;
//         END ELSE
//           CASE EntryType OF
//             EntryType::Purchase:
//               IF Inbound THEN
//                 SNRequired := ItemTrackingCode."SN Purchase Inbound Tracking"
//               ELSE
//                 SNRequired := ItemTrackingCode."SN Purchase Outbound Tracking";
//             EntryType::Sale:
//               IF Inbound THEN
//                 SNRequired := ItemTrackingCode."SN Sales Inbound Tracking"
//               ELSE
//                 SNRequired := ItemTrackingCode."SN Sales Outbound Tracking";
//             EntryType::"Positive Adjmt.":
//               IF Inbound THEN
//                 SNRequired := ItemTrackingCode."SN Pos. Adjmt. Inb. Tracking"
//               ELSE
//                 SNRequired := ItemTrackingCode."SN Pos. Adjmt. Outb. Tracking";
//             EntryType::"Negative Adjmt.":
//               IF Inbound THEN
//                 SNRequired := ItemTrackingCode."SN Neg. Adjmt. Inb. Tracking"
//               ELSE
//                 SNRequired := ItemTrackingCode."SN Neg. Adjmt. Outb. Tracking";
//             EntryType::Transfer:
//               SNRequired := ItemTrackingCode."SN Transfer Tracking";
//             EntryType::Consumption,EntryType::Output:
//               IF Inbound THEN
//                 SNRequired := ItemTrackingCode."SN Manuf. Inbound Tracking"
//               ELSE
//                 SNRequired := ItemTrackingCode."SN Manuf. Outbound Tracking";
//             EntryType::"Assembly Consumption",EntryType::"Assembly Output":
//               IF Inbound THEN
//                 SNRequired := ItemTrackingCode."SN Assembly Inbound Tracking"
//               ELSE
//                 SNRequired := ItemTrackingCode."SN Assembly Outbound Tracking";
//           END;

//         IF ItemTrackingCode."Lot Specific Tracking" THEN BEGIN
//           LotRequired := TRUE;
//         END ELSE
//           CASE EntryType OF
//             EntryType::Purchase:
//               IF Inbound THEN
//                 LotRequired := ItemTrackingCode."Lot Purchase Inbound Tracking"
//               ELSE
//                 LotRequired := ItemTrackingCode."Lot Purchase Outbound Tracking";
//             EntryType::Sale:
//               IF Inbound THEN
//                 LotRequired := ItemTrackingCode."Lot Sales Inbound Tracking"
//               ELSE
//                 LotRequired := ItemTrackingCode."Lot Sales Outbound Tracking";
//             EntryType::"Positive Adjmt.":
//               IF Inbound THEN
//                 LotRequired := ItemTrackingCode."Lot Pos. Adjmt. Inb. Tracking"
//               ELSE
//                 LotRequired := ItemTrackingCode."Lot Pos. Adjmt. Outb. Tracking";
//             EntryType::"Negative Adjmt.":
//               IF Inbound THEN
//                 LotRequired := ItemTrackingCode."Lot Neg. Adjmt. Inb. Tracking"
//               ELSE
//                 LotRequired := ItemTrackingCode."Lot Neg. Adjmt. Outb. Tracking";
//             EntryType::Transfer:
//               LotRequired := ItemTrackingCode."Lot Transfer Tracking";
//             EntryType::Consumption,EntryType::Output:
//               IF Inbound THEN
//                 LotRequired := ItemTrackingCode."Lot Manuf. Inbound Tracking"
//               ELSE
//                 LotRequired := ItemTrackingCode."Lot Manuf. Outbound Tracking";
//             EntryType::"Assembly Consumption",EntryType::"Assembly Output":
//               IF Inbound THEN
//                 LotRequired := ItemTrackingCode."Lot Assembly Inbound Tracking"
//               ELSE
//                 LotRequired := ItemTrackingCode."Lot Assembly Outbound Tracking";
//           END;
//     end;

//     procedure RetrieveInvoiceSpecification(SourceSpecification: Record "336";var TempInvoicingSpecification: Record "336" temporary) OK: Boolean
//     var
//         T336: Record "336";
//         TotalQtyToInvoiceBase: Decimal;
//     begin
//         OK := FALSE;
//         TempInvoicingSpecification.RESET;
//         TempInvoicingSpecification.DELETEALL;

//         // T336 contains information about lines that should be invoiced:

//         T336.SETCURRENTKEY("Source ID","Source Type","Source Subtype",
//           "Source Batch Name","Source Prod. Order Line","Source Ref. No.");

//         T336.SETRANGE("Source Type",SourceSpecification."Source Type");
//         T336.SETRANGE("Source Subtype",SourceSpecification."Source Subtype");
//         T336.SETRANGE("Source ID",SourceSpecification."Source ID");
//         T336.SETRANGE("Source Batch Name",SourceSpecification."Source Batch Name");
//         T336.SETRANGE("Source Prod. Order Line",SourceSpecification."Source Prod. Order Line");
//         T336.SETRANGE("Source Ref. No.",SourceSpecification."Source Ref. No.");
//         IF T336.FINDSET THEN
//           REPEAT
//             T336.TESTFIELD("Qty. to Handle (Base)",0);
//             T336.TESTFIELD("Qty. to Handle",0);
//             IF NOT T336.Correction THEN BEGIN
//               TempInvoicingSpecification := T336;
//               TempInvoicingSpecification."Qty. to Invoice" :=
//                 ROUND(TempInvoicingSpecification."Qty. to Invoice (Base)" /
//                   SourceSpecification."Qty. per Unit of Measure",0.00001);
//               TotalQtyToInvoiceBase += TempInvoicingSpecification."Qty. to Invoice (Base)";
//               TempInvoicingSpecification.INSERT;
//             END;
//           UNTIL T336.NEXT = 0;

//         IF SourceSpecification."Qty. to Invoice (Base)" <> 0 THEN BEGIN
//           IF TempInvoicingSpecification.FINDFIRST THEN BEGIN
//             IF (TotalQtyToInvoiceBase <>
//                 SourceSpecification."Qty. to Invoice (Base)" - SourceSpecification."Qty. to Handle (Base)") AND
//                (TotalQtyToInvoiceBase <> 0) AND
//                NOT IsConsume
//             THEN
//               ERROR(Text001,Text010);
//             OK := TRUE;
//           END;
//         END;
//         TempInvoicingSpecification.SETFILTER("Qty. to Invoice (Base)",'<>0');
//         IF NOT TempInvoicingSpecification.FINDFIRST THEN
//           TempInvoicingSpecification.INIT;
//     end;

//     procedure RetrieveInvoiceSpecWithService(SourceSpecification: Record "336";var TempInvoicingSpecification: Record "336" temporary;Consume: Boolean) OK: Boolean
//     begin
//         IsConsume := Consume;
//         OK := RetrieveInvoiceSpecification(SourceSpecification,TempInvoicingSpecification);
//     end;

//     procedure RetrieveItemTracking(ItemJnlLine: Record "83";var TempHandlingSpecification: Record "336" temporary): Boolean
//     var
//         T337: Record "337";
//     begin
//         IF ItemJnlLine.Subcontracting THEN
//           EXIT(RetrieveSubcontrItemTracking(ItemJnlLine,TempHandlingSpecification));

//         T337.SETCURRENTKEY(
//           "Source ID","Source Ref. No.","Source Type","Source Subtype",
//           "Source Batch Name","Source Prod. Order Line");
//         T337.SETRANGE("Source ID",ItemJnlLine."Journal Template Name");
//         T337.SETRANGE("Source Ref. No.",ItemJnlLine."Line No.");
//         T337.SETRANGE("Source Type",DATABASE::"Item Journal Line");
//         T337.SETRANGE("Source Subtype",ItemJnlLine."Entry Type");
//         T337.SETRANGE("Source Batch Name",ItemJnlLine."Journal Batch Name");
//         T337.SETRANGE("Source Prod. Order Line",0);
//         T337.SETFILTER("Qty. to Handle (Base)",'<>0');

//         IF SumUpItemTracking(T337,TempHandlingSpecification,FALSE,TRUE) THEN BEGIN
//           T337.SETRANGE("Reservation Status",T337."Reservation Status"::Prospect);
//           IF NOT T337.ISEMPTY THEN
//             T337.DELETEALL;
//           EXIT(TRUE);
//         END;
//         EXIT(FALSE);
//     end;

//     procedure RetrieveSubcontrItemTracking(ItemJnlLine: Record "83";var TempHandlingSpecification: Record "336" temporary): Boolean
//     var
//         T337: Record "337";
//         ProdOrderRtngLine: Record "5409";
//     begin
//         IF NOT ItemJnlLine.Subcontracting THEN
//           EXIT(FALSE);

//         IF ItemJnlLine."Operation No." = '' THEN
//           EXIT(FALSE);

//         ItemJnlLine.TESTFIELD("Routing No.");
//         ItemJnlLine.TESTFIELD("Order Type",ItemJnlLine."Order Type"::Production);
//         IF NOT ProdOrderRtngLine.GET(
//              ProdOrderRtngLine.Status::Released,ItemJnlLine."Order No.",
//              ItemJnlLine."Routing Reference No.",ItemJnlLine."Routing No.",ItemJnlLine."Operation No.")
//         THEN
//           EXIT(FALSE);
//         IF NOT (ProdOrderRtngLine."Next Operation No." = '') THEN
//           EXIT(FALSE);

//         T337.SETCURRENTKEY(
//           "Source ID","Source Ref. No.","Source Type","Source Subtype",
//           "Source Batch Name","Source Prod. Order Line");
//         T337.SETRANGE("Source ID",ItemJnlLine."Order No.");
//         T337.SETRANGE("Source Ref. No.",0);
//         T337.SETRANGE("Source Type",DATABASE::"Prod. Order Line");
//         T337.SETRANGE("Source Subtype",3);
//         T337.SETRANGE("Source Batch Name",'');
//         T337.SETRANGE("Source Prod. Order Line",ItemJnlLine."Order Line No.");
//         T337.SETFILTER("Qty. to Handle (Base)",'<>0');

//         IF SumUpItemTracking(T337,TempHandlingSpecification,FALSE,TRUE) THEN BEGIN
//           T337.SETRANGE("Reservation Status",T337."Reservation Status"::Prospect);
//           IF NOT T337.ISEMPTY THEN
//             T337.DELETEALL;
//           EXIT(TRUE);
//         END;
//         EXIT(FALSE);
//     end;

//     procedure RetrieveConsumpItemTracking(ItemJnlLine: Record "83";var TempHandlingSpecification: Record "336" temporary): Boolean
//     var
//         T337: Record "337";
//     begin
//         ItemJnlLine.TESTFIELD("Order Type",ItemJnlLine."Order Type"::Production);
//         T337.SETCURRENTKEY(
//           "Source ID","Source Ref. No.","Source Type","Source Subtype",
//           "Source Batch Name","Source Prod. Order Line");
//         T337.SETRANGE("Source ID",ItemJnlLine."Order No.");
//         IF ItemJnlLine."Prod. Order Comp. Line No." <> 0 THEN
//           T337.SETRANGE("Source Ref. No.",ItemJnlLine."Prod. Order Comp. Line No.");
//         T337.SETRANGE("Source Type",DATABASE::"Prod. Order Component");
//         T337.SETRANGE("Source Subtype",3); // Released
//         T337.SETRANGE("Source Batch Name",'');
//         T337.SETRANGE("Source Prod. Order Line",ItemJnlLine."Order Line No.");
//         T337.SETFILTER("Qty. to Handle (Base)",'<>0');

//         // Sum up in a temporary table per component line:
//         EXIT(SumUpItemTracking(T337,TempHandlingSpecification,TRUE,TRUE));
//     end;

//     procedure SumUpItemTracking(var T337: Record "337";var TempHandlingSpecification: Record "336" temporary;SumPerLine: Boolean;SumPerLotSN: Boolean): Boolean
//     var
//         NextEntryNo: Integer;
//         ExpDate: Date;
//         EntriesExist: Boolean;
//     begin
//         // Sum up Item Tracking in a temporary table (to defragment the T337 records)
//         TempHandlingSpecification.RESET;
//         TempHandlingSpecification.DELETEALL;
//         IF SumPerLotSN THEN
//           TempHandlingSpecification.SETCURRENTKEY("Lot No.","Serial No.");

//         IF T337.FINDSET THEN
//           REPEAT
//             IF (T337."Lot No." <> '') OR (T337."Serial No." <> '') THEN BEGIN
//               IF SumPerLine THEN
//                 TempHandlingSpecification.SETRANGE("Source Ref. No.",T337."Source Ref. No."); // Sum up line per line
//               IF SumPerLotSN THEN BEGIN
//                 TempHandlingSpecification.SETRANGE("Serial No.",T337."Serial No.");
//                 TempHandlingSpecification.SETRANGE("Lot No.",T337."Lot No.");
//                 IF T337."New Serial No." <> '' THEN
//                   TempHandlingSpecification.SETRANGE("New Serial No.",T337."New Serial No." );
//                 IF T337."New Lot No." <> '' THEN
//                   TempHandlingSpecification.SETRANGE("New Lot No.",T337."New Lot No.");
//               END;
//               IF TempHandlingSpecification.FINDFIRST THEN BEGIN
//                 TempHandlingSpecification."Quantity (Base)" += T337."Quantity (Base)";
//                 TempHandlingSpecification."Qty. to Handle (Base)" += T337."Qty. to Handle (Base)";
//                 TempHandlingSpecification."Qty. to Invoice (Base)" += T337."Qty. to Invoice (Base)";
//                 TempHandlingSpecification."Quantity Invoiced (Base)" += T337."Quantity Invoiced (Base)";
//                 TempHandlingSpecification."Qty. to Handle" :=
//                   TempHandlingSpecification."Qty. to Handle (Base)" /
//                   T337."Qty. per Unit of Measure";
//                 TempHandlingSpecification."Qty. to Invoice" :=
//                   TempHandlingSpecification."Qty. to Invoice (Base)" /
//                   T337."Qty. per Unit of Measure";
//                 IF T337."Reservation Status" > T337."Reservation Status"::Tracking THEN
//                   TempHandlingSpecification."Buffer Value1" += // Late Binding
//                     TempHandlingSpecification."Qty. to Handle (Base)";
//                 TempHandlingSpecification.MODIFY;
//               END ELSE BEGIN
//                 TempHandlingSpecification.INIT;
//                 TempHandlingSpecification.TRANSFERFIELDS(T337);
//                 NextEntryNo += 1;
//                 TempHandlingSpecification."Entry No." := NextEntryNo;
//                 TempHandlingSpecification."Qty. to Handle" :=
//                   TempHandlingSpecification."Qty. to Handle (Base)" /
//                   T337."Qty. per Unit of Measure";
//                 TempHandlingSpecification."Qty. to Invoice" :=
//                   TempHandlingSpecification."Qty. to Invoice (Base)" /
//                   T337."Qty. per Unit of Measure";
//                 IF T337."Reservation Status" > T337."Reservation Status"::Tracking THEN
//                   TempHandlingSpecification."Buffer Value1" += // Late Binding
//                     TempHandlingSpecification."Qty. to Handle (Base)";
//                 ExpDate :=
//                   ExistingExpirationDate(T337."Item No.",T337."Variant Code",T337."Lot No.",T337."Serial No.",FALSE,EntriesExist);
//                 IF EntriesExist THEN
//                   TempHandlingSpecification."Expiration Date" := ExpDate;
//                 TempHandlingSpecification.INSERT;
//               END;
//             END;
//           UNTIL T337.NEXT = 0;

//         TempHandlingSpecification.RESET;
//         EXIT(TempHandlingSpecification.FINDFIRST);
//     end;

//     procedure SumUpItemTrackingOnlyInventoryOrATO(var ReservationEntry: Record "337";var TrackingSpecification: Record "336";SumPerLine: Boolean;SumPerLotSN: Boolean): Boolean
//     var
//         TempReservationEntry: Record "337" temporary;
//     begin
//         IF ReservationEntry.FINDSET THEN
//           REPEAT
//             IF (ReservationEntry."Reservation Status" <> ReservationEntry."Reservation Status"::Reservation) OR
//                IsResEntryReservedAgainstInventory(ReservationEntry)
//             THEN BEGIN
//               TempReservationEntry := ReservationEntry;
//               TempReservationEntry.INSERT;
//             END;
//           UNTIL ReservationEntry.NEXT = 0;

//         EXIT(SumUpItemTracking(TempReservationEntry,TrackingSpecification,SumPerLine,SumPerLotSN));
//     end;

//     local procedure IsResEntryReservedAgainstInventory(ReservationEntry: Record "337"): Boolean
//     var
//         ReservationEntry2: Record "337";
//     begin
//         IF (ReservationEntry."Reservation Status" <> ReservationEntry."Reservation Status"::Reservation) OR
//            ReservationEntry.Positive
//         THEN
//           EXIT(FALSE);

//         ReservationEntry2.GET(ReservationEntry."Entry No.",NOT ReservationEntry.Positive);
//         IF ReservationEntry2."Source Type" = DATABASE::"Item Ledger Entry" THEN
//           EXIT(TRUE);

//         EXIT(IsResEntryReservedAgainstATO(ReservationEntry));
//     end;

//     local procedure IsResEntryReservedAgainstATO(ReservationEntry: Record "337"): Boolean
//     var
//         ReservationEntry2: Record "337";
//         SalesLine: Record "37";
//         AssembleToOrderLink: Record "904";
//     begin
//         IF (ReservationEntry."Source Type" <> DATABASE::"Sales Line") OR
//            (ReservationEntry."Source Subtype" <> SalesLine."Document Type"::Order) OR
//            (NOT SalesLine.GET(ReservationEntry."Source Subtype",ReservationEntry."Source ID",ReservationEntry."Source Ref. No.")) OR
//            (NOT AssembleToOrderLink.AsmExistsForSalesLine(SalesLine))
//         THEN
//           EXIT(FALSE);

//         ReservationEntry2.GET(ReservationEntry."Entry No.",NOT ReservationEntry.Positive);
//         IF (ReservationEntry2."Source Type" <> DATABASE::"Assembly Header") OR
//            (ReservationEntry2."Source Subtype" <> AssembleToOrderLink."Assembly Document Type") OR
//            (ReservationEntry2."Source ID" <> AssembleToOrderLink."Assembly Document No.")
//         THEN
//           EXIT(FALSE);

//         EXIT(TRUE);
//     end;

//     procedure DecomposeRowID(IDtext: Text[250];var StrArray: array [6] of Text[100])
//     var
//         Len: Integer;
//         Pos: Integer;
//         ArrayIndex: Integer;
//         "Count": Integer;
//         Char: Text[1];
//         NoWriteSinceLastNext: Boolean;
//         Write: Boolean;
//         Next: Boolean;
//     begin
//         FOR ArrayIndex := 1 TO 6 DO
//           StrArray[ArrayIndex] := '';
//         Len := STRLEN(IDtext);
//         Pos := 1;
//         ArrayIndex := 1;

//         WHILE NOT (Pos > Len) DO BEGIN
//           Char := COPYSTR(IDtext,Pos,1);
//           IF Char = '"' THEN BEGIN
//             Write := FALSE;
//             Count += 1;
//           END ELSE BEGIN
//             IF Count = 0 THEN
//               Write := TRUE
//             ELSE BEGIN
//               IF Count MOD 2 = 1 THEN BEGIN
//                 Next := (Char = ';');
//                 Count -= 1;
//               END ELSE
//                 IF NoWriteSinceLastNext AND (Char = ';') THEN BEGIN
//                   Count -= 2;
//                   Next := TRUE;
//                 END;
//               Count /= 2;
//               WHILE Count > 0 DO BEGIN
//                 StrArray[ArrayIndex] += '"';
//                 Count -= 1;
//               END;
//               Write := NOT Next;
//             END;
//             NoWriteSinceLastNext := Next;
//           END;

//           IF Next THEN BEGIN
//             ArrayIndex += 1;
//             Next := FALSE
//           END;

//           IF Write THEN
//             StrArray[ArrayIndex] += Char;
//           Pos += 1;
//         END;
//     end;

//     procedure ComposeRowID(Type: Integer;Subtype: Integer;ID: Code[20];BatchName: Code[10];ProdOrderLine: Integer;RefNo: Integer): Text[250]
//     var
//         StrArray: array [2] of Text[100];
//         Pos: Integer;
//         Len: Integer;
//         T: Integer;
//     begin
//         StrArray[1] := ID;
//         StrArray[2] := BatchName;
//         FOR T := 1 TO 2 DO BEGIN
//           IF STRPOS(StrArray[T],'"') > 0 THEN BEGIN
//             Len := STRLEN(StrArray[T]);
//             Pos := 1;
//             REPEAT
//               IF COPYSTR(StrArray[T],Pos,1) = '"' THEN BEGIN
//                 StrArray[T] := INSSTR(StrArray[T],'"',Pos + 1);
//                 Len += 1;
//                 Pos += 1;
//               END;
//               Pos += 1;
//             UNTIL Pos > Len;
//           END;
//         END;
//         EXIT(STRSUBSTNO('"%1";"%2";"%3";"%4";"%5";"%6"',Type,Subtype,StrArray[1],StrArray[2],ProdOrderLine,RefNo));
//     end;

//     procedure CallPostedItemTrackingForm(Type: Integer;Subtype: Integer;ID: Code[20];BatchName: Code[10];ProdOrderLine: Integer;RefNo: Integer): Boolean
//     var
//         TempItemLedgEntry: Record "32" temporary;
//     begin
//         // Used when calling Item Tracking from Posted Shipments/Receipts:

//         RetrieveILEFromShptRcpt(TempItemLedgEntry,Type,Subtype,ID,BatchName,ProdOrderLine,RefNo);
//         IF NOT TempItemLedgEntry.ISEMPTY THEN BEGIN
//           PAGE.RUNMODAL(PAGE::"Posted Item Tracking Lines",TempItemLedgEntry);
//           EXIT(TRUE);
//         END;
//         EXIT(FALSE);
//     end;

//     procedure CallPostedItemTrackingForm2(Type: Integer;Subtype: Integer;ID: Code[20];RefNo: Integer): Boolean
//     var
//         ItemEntryRelation: Record "6507";
//         ItemLedgEntry: Record "32";
//         TempItemLedgEntry: Record "32" temporary;
//         SignFactor: Integer;
//     begin
//         // Used when calling Item Tracking from Posted Whse Activity Lines:

//         CASE Type OF
//           DATABASE::"Sales Line":
//             Type := DATABASE::"Sales Shipment Line";
//           DATABASE::"Purchase Line":
//             Type := DATABASE::"Purch. Rcpt. Line";
//           DATABASE::"Prod. Order Component":
//             ;
//           DATABASE::"Transfer Line":
//             IF Subtype = 0 THEN
//               Type := DATABASE::"Transfer Shipment Line"
//             ELSE
//               Type := DATABASE::"Transfer Receipt Line";
//         END;

//         ItemEntryRelation.SETCURRENTKEY("Order No.","Order Line No.");
//         ItemEntryRelation.SETRANGE("Source Type",Type);
//         ItemEntryRelation.SETRANGE("Order No.",ID);
//         ItemEntryRelation.SETRANGE("Order Line No.",RefNo);
//         IF ItemEntryRelation.FINDSET THEN BEGIN
//           SignFactor := TableSignFactor(Type);
//           REPEAT
//             ItemLedgEntry.GET(ItemEntryRelation."Item Entry No.");
//             TempItemLedgEntry := ItemLedgEntry;
//             AddTempRecordToSet(TempItemLedgEntry,SignFactor);
//           UNTIL ItemEntryRelation.NEXT = 0;
//           PAGE.RUNMODAL(PAGE::"Posted Item Tracking Lines",TempItemLedgEntry);
//           EXIT(TRUE);
//         END;
//         EXIT(FALSE);
//     end;

//     procedure CallPostedItemTrackingForm3(InvoiceRowID: Text[100]): Boolean
//     var
//         TempItemLedgEntry: Record "32" temporary;
//     begin
//         // Used when calling Item Tracking from invoiced documents:

//         RetrieveILEFromPostedInv(TempItemLedgEntry,InvoiceRowID);
//         IF NOT TempItemLedgEntry.ISEMPTY THEN BEGIN
//           PAGE.RUNMODAL(PAGE::"Posted Item Tracking Lines",TempItemLedgEntry);
//           EXIT(TRUE);
//         END;
//         EXIT(FALSE);
//     end;

//     procedure CallPostedItemTrackingForm4(Type: Integer;ID: Code[20];ProdOrderLine: Integer;RefNo: Integer): Boolean
//     var
//         ItemLedgEntry: Record "32";
//         TempItemLedgEntry: Record "32" temporary;
//         Window: Dialog;
//     begin
//         // Used when calling Item Tracking from finished prod. order and component:
//         Window.OPEN(Text004);
//         ItemLedgEntry.SETCURRENTKEY("Order Type","Order No.","Order Line No.",
//           "Entry Type","Prod. Order Comp. Line No.");

//         ItemLedgEntry.SETRANGE("Order Type",ItemLedgEntry."Order Type"::Production);
//         ItemLedgEntry.SETRANGE("Order No.",ID);
//         ItemLedgEntry.SETRANGE("Order Line No.",ProdOrderLine);

//         CASE Type OF
//           DATABASE::"Prod. Order Line":
//             BEGIN
//               ItemLedgEntry.SETRANGE("Entry Type",ItemLedgEntry."Entry Type"::Output);
//               ItemLedgEntry.SETRANGE("Prod. Order Comp. Line No.",0);
//             END;
//           DATABASE::"Prod. Order Component":
//             BEGIN
//               ItemLedgEntry.SETRANGE("Entry Type",ItemLedgEntry."Entry Type"::Consumption);
//               ItemLedgEntry.SETRANGE("Prod. Order Comp. Line No.",RefNo);
//             END;
//           ELSE
//             EXIT(FALSE);
//         END;

//         IF ItemLedgEntry.FINDSET THEN
//           REPEAT
//             IF (ItemLedgEntry."Serial No." <> '') OR (ItemLedgEntry."Lot No." <> '') THEN BEGIN
//               TempItemLedgEntry := ItemLedgEntry;
//               TempItemLedgEntry.INSERT;
//             END
//           UNTIL ItemLedgEntry.NEXT = 0;
//         Window.CLOSE;
//         IF TempItemLedgEntry.ISEMPTY THEN
//           EXIT(FALSE);

//         PAGE.RUNMODAL(PAGE::"Posted Item Tracking Lines",TempItemLedgEntry);
//         EXIT(TRUE);
//     end;

//     procedure CallItemTrackingEntryForm(SourceType: Option " ",Customer,Vendor,Item;SourceNo: Code[20];ItemNo: Code[20];VariantCode: Code[20];SerialNo: Code[20];LotNo: Code[20];LocationCode: Code[10])
//     var
//         ItemLedgEntry: Record "32";
//         TempItemLedgEntry: Record "32" temporary;
//         Item: Record "27";
//         Window: Dialog;
//     begin
//         // Used when calling Item Tracking from Item, Stockkeeping Unit, Customer, Vendor and information card:
//         Window.OPEN(Text004);

//         IF SourceNo <> '' THEN BEGIN
//           ItemLedgEntry.SETCURRENTKEY("Source Type","Source No.","Item No.","Variant Code");
//           ItemLedgEntry.SETRANGE("Source No.",SourceNo);
//           ItemLedgEntry.SETRANGE("Source Type",SourceType);
//         END ELSE
//           ItemLedgEntry.SETCURRENTKEY("Item No.",Open,"Variant Code");

//         IF LocationCode <> '' THEN
//           ItemLedgEntry.SETRANGE("Location Code",LocationCode);

//         IF ItemNo <> '' THEN BEGIN
//           Item.GET(ItemNo);
//           Item.TESTFIELD("Item Tracking Code");
//           ItemLedgEntry.SETRANGE("Item No.",ItemNo);
//         END;
//         IF SourceType = 0 THEN
//           ItemLedgEntry.SETRANGE("Variant Code",VariantCode);
//         IF SerialNo <> '' THEN
//           ItemLedgEntry.SETRANGE("Serial No.",SerialNo);
//         IF LotNo <> '' THEN
//           ItemLedgEntry.SETRANGE("Lot No.",LotNo);

//         IF ItemLedgEntry.FINDSET THEN
//           REPEAT
//             IF (ItemLedgEntry."Serial No." <> '') OR (ItemLedgEntry."Lot No." <> '') THEN BEGIN
//               TempItemLedgEntry := ItemLedgEntry;
//               TempItemLedgEntry.INSERT;
//             END
//           UNTIL ItemLedgEntry.NEXT = 0;
//         Window.CLOSE;
//         PAGE.RUNMODAL(PAGE::"Item Tracking Entries",TempItemLedgEntry);
//     end;

//     procedure CopyItemTracking(FromRowID: Text[250];ToRowID: Text[250];SwapSign: Boolean)
//     begin
//         CopyItemTracking2(FromRowID,ToRowID,SwapSign,FALSE);
//     end;

//     procedure CopyItemTracking2(FromRowID: Text[250];ToRowID: Text[250];SwapSign: Boolean;SkipReservation: Boolean)
//     var
//         ReservEntry: Record "337";
//         ReservMgt: Codeunit "99000845";
//     begin
//         ReservEntry.SetPointer(FromRowID);
//         ReservMgt.SetPointerFilter(ReservEntry);
//         CopyItemTracking3(ReservEntry,ToRowID,SwapSign,SkipReservation);
//     end;

//     procedure CopyItemTracking3(var ReservEntry: Record "337";ToRowID: Text[250];SwapSign: Boolean;SkipReservation: Boolean)
//     var
//         ReservEntry1: Record "337";
//         TempReservEntry: Record "337" temporary;
//     begin
//         IF SkipReservation THEN
//           ReservEntry.SETFILTER("Reservation Status",'<>%1',ReservEntry."Reservation Status"::Reservation);
//         IF ReservEntry.FINDSET THEN BEGIN
//           REPEAT
//             IF (ReservEntry."Lot No." <> '') OR (ReservEntry."Serial No." <> '') THEN BEGIN
//               TempReservEntry := ReservEntry;
//               TempReservEntry."Reservation Status" := TempReservEntry."Reservation Status"::Prospect;
//               TempReservEntry.SetPointer(ToRowID);
//               IF SwapSign THEN BEGIN
//                 TempReservEntry."Quantity (Base)" := -TempReservEntry."Quantity (Base)";
//                 TempReservEntry.Quantity := -TempReservEntry.Quantity;
//                 TempReservEntry."Qty. to Handle (Base)" := -TempReservEntry."Qty. to Handle (Base)";
//                 TempReservEntry."Qty. to Invoice (Base)" := -TempReservEntry."Qty. to Invoice (Base)";
//                 TempReservEntry."Quantity Invoiced (Base)" := -TempReservEntry."Quantity Invoiced (Base)";
//                 TempReservEntry.Positive := TempReservEntry."Quantity (Base)" > 0;
//               END;
//               TempReservEntry.INSERT;
//             END;
//           UNTIL ReservEntry.NEXT = 0;

//           ModifyTemp337SetIfTransfer(TempReservEntry);

//           IF TempReservEntry.FINDSET THEN BEGIN
//             ReservEntry1.RESET;
//             REPEAT
//               ReservEntry1 := TempReservEntry;
//               ReservEntry1."Entry No." := 0;
//               ReservEntry1.INSERT;
//             UNTIL TempReservEntry.NEXT = 0;
//           END;
//         END;
//     end;

//     procedure CopyHandledItemTrkgToInvLine(FromSalesLine: Record "37";ToSalesInvLine: Record "37")
//     var
//         ReservEntry: Record "337";
//         TrackingSpecification: Record "336";
//         ItemEntryRelation: Record "6507";
//         QtyBase: Decimal;
//     begin
//         // Used for combined shipment/returns:
//         IF FromSalesLine.Type <> FromSalesLine.Type::Item THEN
//           EXIT;

//         ItemEntryRelation.SETCURRENTKEY("Source ID","Source Type","Source Subtype","Source Ref. No.");
//         ItemEntryRelation.SETRANGE("Source Subtype",0);
//         ItemEntryRelation.SETRANGE("Source Batch Name",'');
//         ItemEntryRelation.SETRANGE("Source Prod. Order Line",0);

//         CASE ToSalesInvLine."Document Type" OF
//           ToSalesInvLine."Document Type"::Invoice:
//             BEGIN
//               ItemEntryRelation.SETRANGE("Source Type",DATABASE::"Sales Shipment Line");
//               ItemEntryRelation.SETRANGE("Source ID",ToSalesInvLine."Shipment No.");
//               ItemEntryRelation.SETRANGE("Source Ref. No.",ToSalesInvLine."Shipment Line No.");
//             END;
//           ToSalesInvLine."Document Type"::"Credit Memo":
//             BEGIN
//               ItemEntryRelation.SETRANGE("Source Type",DATABASE::"Return Receipt Line");
//               ItemEntryRelation.SETRANGE("Source ID",ToSalesInvLine."Return Receipt No.");
//               ItemEntryRelation.SETRANGE("Source Ref. No.",ToSalesInvLine."Return Receipt Line No.");
//             END;
//           ELSE
//             ToSalesInvLine.FIELDERROR("Document Type",FORMAT(ToSalesInvLine."Document Type"));
//         END;

//         IF NOT ItemEntryRelation.FINDSET THEN
//           EXIT;

//         REPEAT
//           TrackingSpecification.GET(ItemEntryRelation."Item Entry No.");
//           QtyBase := TrackingSpecification."Quantity (Base)" - TrackingSpecification."Quantity Invoiced (Base)";
//           IF QtyBase <> 0 THEN BEGIN
//             ReservEntry.INIT;
//             ReservEntry.TRANSFERFIELDS(TrackingSpecification);
//             ReservEntry."Source Subtype" := ToSalesInvLine."Document Type";
//             ReservEntry."Source ID" := ToSalesInvLine."Document No.";
//             ReservEntry."Source Ref. No." := ToSalesInvLine."Line No.";
//             ReservEntry."Reservation Status" := ReservEntry."Reservation Status"::Prospect;
//             ReservEntry."Quantity Invoiced (Base)" := 0;
//             ReservEntry.VALIDATE("Quantity (Base)",QtyBase);
//             ReservEntry.Positive := (ReservEntry."Quantity (Base)" > 0);
//             ReservEntry."Entry No." := 0;
//             ReservEntry.INSERT;
//           END;
//         UNTIL ItemEntryRelation.NEXT = 0;
//     end;

//     procedure CopyHandledItemTrkgToInvLine2(FromPurchLine: Record "39";ToPurchInvLine: Record "39")
//     var
//         ReservEntry: Record "337";
//         TrackingSpecification: Record "336";
//         ItemEntryRelation: Record "6507";
//         QtyBase: Decimal;
//     begin
//         // Used for combined receipts/returns:
//         IF FromPurchLine.Type <> FromPurchLine.Type::Item THEN
//           EXIT;

//         ItemEntryRelation.SETCURRENTKEY("Source ID","Source Type","Source Subtype","Source Ref. No.");
//         ItemEntryRelation.SETRANGE("Source Subtype",0);
//         ItemEntryRelation.SETRANGE("Source Batch Name",'');
//         ItemEntryRelation.SETRANGE("Source Prod. Order Line",0);

//         CASE ToPurchInvLine."Document Type" OF
//           ToPurchInvLine."Document Type"::Invoice:
//             BEGIN
//               ItemEntryRelation.SETRANGE("Source Type",DATABASE::"Purch. Rcpt. Line");
//               ItemEntryRelation.SETRANGE("Source ID",ToPurchInvLine."Receipt No.");
//               ItemEntryRelation.SETRANGE("Source Ref. No.",ToPurchInvLine."Receipt Line No.");
//             END;
//           ToPurchInvLine."Document Type"::"Credit Memo":
//             BEGIN
//               ItemEntryRelation.SETRANGE("Source Type",DATABASE::"Return Shipment Line");
//               ItemEntryRelation.SETRANGE("Source ID",ToPurchInvLine."Return Shipment No.");
//               ItemEntryRelation.SETRANGE("Source Ref. No.",ToPurchInvLine."Return Shipment Line No.");
//             END;
//           ELSE
//             ToPurchInvLine.FIELDERROR("Document Type",FORMAT(ToPurchInvLine."Document Type"));
//         END;

//         IF NOT ItemEntryRelation.FINDSET THEN
//           EXIT;

//         REPEAT
//           TrackingSpecification.GET(ItemEntryRelation."Item Entry No.");
//           QtyBase := TrackingSpecification."Quantity (Base)" - TrackingSpecification."Quantity Invoiced (Base)";
//           IF QtyBase <> 0 THEN BEGIN
//             ReservEntry.INIT;
//             ReservEntry.TRANSFERFIELDS(TrackingSpecification);
//             ReservEntry."Source Subtype" := ToPurchInvLine."Document Type";
//             ReservEntry."Source ID" := ToPurchInvLine."Document No.";
//             ReservEntry."Source Ref. No." := ToPurchInvLine."Line No.";
//             ReservEntry."Reservation Status" := ReservEntry."Reservation Status"::Prospect;
//             ReservEntry."Quantity Invoiced (Base)" := 0;
//             ReservEntry.VALIDATE("Quantity (Base)",QtyBase);
//             ReservEntry.Positive := (ReservEntry."Quantity (Base)" > 0);
//             ReservEntry."Entry No." := 0;
//             ReservEntry.INSERT;
//           END;
//         UNTIL ItemEntryRelation.NEXT = 0;
//     end;

//     procedure CopyHandledItemTrkgToServLine(FromServLine: Record "5902";ToServLine: Record "5902")
//     var
//         ReservEntry: Record "337";
//         TrackingSpecification: Record "336";
//         ItemEntryRelation: Record "6507";
//         QtyBase: Decimal;
//     begin
//         // Used for combined shipment/returns:
//         IF FromServLine.Type <> FromServLine.Type::Item THEN
//           EXIT;

//         ItemEntryRelation.SETCURRENTKEY("Source ID","Source Type","Source Subtype","Source Ref. No.");
//         ItemEntryRelation.SETRANGE("Source Subtype",0);
//         ItemEntryRelation.SETRANGE("Source Batch Name",'');
//         ItemEntryRelation.SETRANGE("Source Prod. Order Line",0);

//         CASE ToServLine."Document Type" OF
//           ToServLine."Document Type"::Invoice:
//             BEGIN
//               ItemEntryRelation.SETRANGE("Source Type",DATABASE::"Service Shipment Line");
//               ItemEntryRelation.SETRANGE("Source ID",ToServLine."Shipment No.");
//               ItemEntryRelation.SETRANGE("Source Ref. No.",ToServLine."Shipment Line No.");
//             END;
//           ELSE
//             ToServLine.FIELDERROR("Document Type",FORMAT(ToServLine."Document Type"));
//         END;

//         IF NOT ItemEntryRelation.FINDSET THEN
//           EXIT;

//         REPEAT
//           TrackingSpecification.GET(ItemEntryRelation."Item Entry No.");
//           QtyBase := TrackingSpecification."Quantity (Base)" - TrackingSpecification."Quantity Invoiced (Base)";
//           IF QtyBase <> 0 THEN BEGIN
//             ReservEntry.INIT;
//             ReservEntry.TRANSFERFIELDS(TrackingSpecification);
//             ReservEntry."Source Subtype" := ToServLine."Document Type";
//             ReservEntry."Source ID" := ToServLine."Document No.";
//             ReservEntry."Source Ref. No." := ToServLine."Line No.";
//             ReservEntry."Reservation Status" := ReservEntry."Reservation Status"::Prospect;
//             ReservEntry."Quantity Invoiced (Base)" := 0;
//             ReservEntry.VALIDATE("Quantity (Base)",QtyBase);
//             ReservEntry.Positive := (ReservEntry."Quantity (Base)" > 0);
//             ReservEntry."Entry No." := 0;
//             ReservEntry.INSERT;
//           END;
//         UNTIL ItemEntryRelation.NEXT = 0;
//     end;

//     procedure CollectItemEntryRelation(var TempItemLedgEntry: Record "32" temporary;SourceType: Integer;SourceSubtype: Option "0","1","2","3","4","5","6","7","8","9","10";SourceID: Code[20];SourceBatchName: Code[10];SourceProdOrderLine: Integer;SourceRefNo: Integer;TotalQty: Decimal): Boolean
//     var
//         ItemLedgEntry: Record "32";
//         ItemEntryRelation: Record "6507";
//         Quantity: Decimal;
//     begin
//         Quantity := 0;
//         TempItemLedgEntry.RESET;
//         TempItemLedgEntry.DELETEALL;
//         ItemEntryRelation.SETCURRENTKEY("Source ID","Source Type");
//         ItemEntryRelation.SETRANGE("Source Type",SourceType);
//         ItemEntryRelation.SETRANGE("Source Subtype",SourceSubtype);
//         ItemEntryRelation.SETRANGE("Source ID",SourceID);
//         ItemEntryRelation.SETRANGE("Source Batch Name",SourceBatchName);
//         ItemEntryRelation.SETRANGE("Source Prod. Order Line",SourceProdOrderLine);
//         ItemEntryRelation.SETRANGE("Source Ref. No.",SourceRefNo);
//         IF ItemEntryRelation.FINDSET THEN
//           REPEAT
//             ItemLedgEntry.GET(ItemEntryRelation."Item Entry No.");
//             TempItemLedgEntry := ItemLedgEntry;
//             TempItemLedgEntry.INSERT;
//             Quantity := Quantity + ItemLedgEntry.Quantity;
//           UNTIL ItemEntryRelation.NEXT = 0;
//         EXIT(Quantity = TotalQty);
//     end;

//     local procedure AddTempRecordToSet(var TempItemLedgEntry: Record "32" temporary;SignFactor: Integer)
//     var
//         TempItemLedgEntry2: Record "32" temporary;
//     begin
//         IF SignFactor <> 1 THEN BEGIN
//           TempItemLedgEntry.Quantity *= SignFactor;
//           TempItemLedgEntry."Remaining Quantity" *= SignFactor;
//           TempItemLedgEntry."Invoiced Quantity" *= SignFactor;
//         END;
//         RetrieveAppliedExpirationDate(TempItemLedgEntry);
//         TempItemLedgEntry2 := TempItemLedgEntry;
//         TempItemLedgEntry.RESET;
//         TempItemLedgEntry.SETRANGE("Serial No.",TempItemLedgEntry2."Serial No.");
//         TempItemLedgEntry.SETRANGE("Lot No.",TempItemLedgEntry2."Lot No.");
//         TempItemLedgEntry.SETRANGE("Warranty Date",TempItemLedgEntry2."Warranty Date");
//         TempItemLedgEntry.SETRANGE("Expiration Date",TempItemLedgEntry2."Expiration Date");
//         IF TempItemLedgEntry.FINDFIRST THEN BEGIN
//           TempItemLedgEntry.Quantity += TempItemLedgEntry2.Quantity;
//           TempItemLedgEntry."Remaining Quantity" += TempItemLedgEntry2."Remaining Quantity";
//           TempItemLedgEntry."Invoiced Quantity" += TempItemLedgEntry2."Invoiced Quantity";
//           TempItemLedgEntry.MODIFY;
//         END ELSE
//           TempItemLedgEntry.INSERT;

//         TempItemLedgEntry.RESET;
//     end;

//     local procedure TableSignFactor(TableNo: Integer): Integer
//     begin
//         IF TableNo IN [
//                        DATABASE::"Sales Line",
//                        DATABASE::"Sales Shipment Line",
//                        DATABASE::"Sales Invoice Line",
//                        DATABASE::"Purch. Cr. Memo Line",
//                        DATABASE::"Prod. Order Component",
//                        DATABASE::"Transfer Shipment Line",
//                        DATABASE::"Return Shipment Line",
//                        DATABASE::"Planning Component",
//                        DATABASE::"Posted Assembly Line",
//                        DATABASE::"Service Line",
//                        DATABASE::"Service Shipment Line",
//                        DATABASE::"Service Invoice Line"]
//         THEN
//           EXIT(-1);

//         EXIT(1);
//     end;

//     local procedure TableSignFactor2(RowID: Text[250]): Integer
//     var
//         TableNo: Integer;
//     begin
//         RowID := DELCHR(RowID,'<','"');
//         RowID := COPYSTR(RowID,1,STRPOS(RowID,'"') - 1);
//         IF EVALUATE(TableNo,RowID) THEN
//           EXIT(TableSignFactor(TableNo));

//         EXIT(1);
//     end;

//     procedure IsOrderNetworkEntity(Type: Integer;Subtype: Integer): Boolean
//     begin
//         CASE Type OF
//           DATABASE::"Sales Line":
//             EXIT(Subtype IN [1,5]);
//           DATABASE::"Purchase Line":
//             EXIT(Subtype IN [1,5]);
//           DATABASE::"Prod. Order Line":
//             EXIT(Subtype IN [2,3]);
//           DATABASE::"Prod. Order Component":
//             EXIT(Subtype IN [2,3]);
//           DATABASE::"Assembly Header":
//             EXIT(Subtype IN [1]);
//           DATABASE::"Assembly Line":
//             EXIT(Subtype IN [1]);
//           DATABASE::"Transfer Line":
//             EXIT(TRUE);
//           DATABASE::"Service Line":
//             EXIT(Subtype IN [1]);
//           ELSE
//             EXIT(FALSE);
//         END;
//     end;

//     procedure DeleteItemEntryRelation(SourceType: Integer;SourceSubtype: Integer;SourceID: Code[20];SourceBatchName: Code[10];SourceProdOrderLine: Integer;SourceRefNo: Integer;DeleteAllDocLines: Boolean)
//     var
//         ItemEntryRelation: Record "6507";
//     begin
//         ItemEntryRelation.SETCURRENTKEY("Source ID","Source Type");
//         ItemEntryRelation.SETRANGE("Source Type",SourceType);
//         ItemEntryRelation.SETRANGE("Source Subtype",SourceSubtype);
//         ItemEntryRelation.SETRANGE("Source ID",SourceID);
//         ItemEntryRelation.SETRANGE("Source Batch Name",SourceBatchName);
//         ItemEntryRelation.SETRANGE("Source Prod. Order Line",SourceProdOrderLine);
//         IF NOT DeleteAllDocLines THEN
//           ItemEntryRelation.SETRANGE("Source Ref. No.",SourceRefNo);
//         IF NOT ItemEntryRelation.ISEMPTY THEN
//           ItemEntryRelation.DELETEALL;
//     end;

//     procedure DeleteValueEntryRelation(RowID: Text[100])
//     var
//         ValueEntryRelation: Record "6508";
//     begin
//         ValueEntryRelation.SETCURRENTKEY("Source RowId");
//         ValueEntryRelation.SETRANGE("Source RowId",RowID);
//         IF NOT ValueEntryRelation.ISEMPTY THEN
//           ValueEntryRelation.DELETEALL;
//     end;

//     procedure FindInInventory(ItemNo: Code[20];VariantCode: Code[20];SerialNo: Code[20]): Boolean
//     var
//         ItemLedgerEntry: Record "32";
//     begin
//         ItemLedgerEntry.RESET;
//         ItemLedgerEntry.SETCURRENTKEY("Item No.",Open,"Variant Code",Positive);
//         ItemLedgerEntry.SETRANGE("Item No.",ItemNo);
//         ItemLedgerEntry.SETRANGE(Open,TRUE);
//         ItemLedgerEntry.SETRANGE("Variant Code",VariantCode);
//         ItemLedgerEntry.SETRANGE(Positive,TRUE);
//         IF SerialNo <> '' THEN
//           ItemLedgerEntry.SETRANGE("Serial No.",SerialNo);
//         EXIT(ItemLedgerEntry.FINDFIRST);
//     end;

//     procedure SplitWhseJnlLine(TempWhseJnlLine: Record "7311" temporary;var TempWhseJnlLine2: Record "7311" temporary;var TempWhseSplitSpecification: Record "336" temporary;ToTransfer: Boolean)
//     var
//         NonDistrQtyBase: Decimal;
//         NonDistrCubage: Decimal;
//         NonDistrWeight: Decimal;
//         SplitFactor: Decimal;
//         LineNo: Integer;
//         WhseSNRequired: Boolean;
//         WhseLNRequired: Boolean;
//     begin
//         TempWhseJnlLine2.DELETEALL;

//         CheckWhseItemTrkgSetup(TempWhseJnlLine."Item No.",WhseSNRequired,WhseLNRequired,FALSE);
//         IF NOT (WhseSNRequired OR WhseLNRequired) THEN BEGIN
//           TempWhseJnlLine2 := TempWhseJnlLine;
//           TempWhseJnlLine2.INSERT;
//           EXIT;
//         END;

//         LineNo := TempWhseJnlLine."Line No.";
//         WITH TempWhseSplitSpecification DO BEGIN
//           RESET;
//           SETCURRENTKEY(
//             "Source ID","Source Type","Source Subtype","Source Batch Name",
//             "Source Prod. Order Line","Source Ref. No.");
//           CASE TempWhseJnlLine."Source Type" OF
//             DATABASE::"Item Journal Line",
//             DATABASE::"Job Journal Line":
//               BEGIN
//                 SETRANGE("Source Type",TempWhseJnlLine."Source Type");
//                 SETRANGE("Source ID",TempWhseJnlLine."Journal Template Name");
//                 SETRANGE("Source Ref. No.",TempWhseJnlLine."Source Line No.");
//               END;
//             0: // Whse. journal line
//               BEGIN
//                 SETRANGE("Source Type",DATABASE::"Warehouse Journal Line");
//                 SETRANGE("Source ID",TempWhseJnlLine."Journal Batch Name");
//                 SETRANGE("Source Ref. No.",TempWhseJnlLine."Line No.");
//               END;
//             ELSE BEGIN
//               SETRANGE("Source Type",TempWhseJnlLine."Source Type");
//               SETRANGE("Source ID",TempWhseJnlLine."Source No.");
//               SETRANGE("Source Ref. No.",TempWhseJnlLine."Source Line No.");
//             END;
//           END;
//           SETFILTER("Quantity actual Handled (Base)",'<>%1',0);
//           NonDistrQtyBase := TempWhseJnlLine."Qty. (Absolute, Base)";
//           NonDistrCubage := TempWhseJnlLine.Cubage;
//           NonDistrWeight := TempWhseJnlLine.Weight;
//           IF FINDSET THEN
//             REPEAT
//               LineNo += 10000;
//               TempWhseJnlLine2 := TempWhseJnlLine;
//               TempWhseJnlLine2."Line No." := LineNo;
//               IF "Serial No." <> '' THEN
//                 TESTFIELD("Qty. per Unit of Measure",1);
//               IF ToTransfer THEN BEGIN
//                 TempWhseJnlLine2."Serial No." := "New Serial No.";
//                 TempWhseJnlLine2."Lot No." := "New Lot No.";
//                 IF "New Expiration Date" <> 0D THEN
//                   TempWhseJnlLine2."Expiration Date" := "New Expiration Date"
//               END ELSE BEGIN
//                 TempWhseJnlLine2."Serial No." := "Serial No.";
//                 TempWhseJnlLine2."Lot No." := "Lot No.";
//                 TempWhseJnlLine2."Expiration Date" := "Expiration Date";
//               END;
//               TempWhseJnlLine2."New Serial No." := "New Serial No.";
//               TempWhseJnlLine2."New Lot No." := "New Lot No.";
//               TempWhseJnlLine2."New Expiration Date" := "New Expiration Date";
//               TempWhseJnlLine2."Warranty Date" := "Warranty Date";
//               TempWhseJnlLine2."Qty. (Absolute, Base)" := ABS("Quantity (Base)");
//               TempWhseJnlLine2."Qty. (Absolute)" :=
//                 ROUND(TempWhseJnlLine2."Qty. (Absolute, Base)" / TempWhseJnlLine."Qty. per Unit of Measure",0.00001);
//               IF TempWhseJnlLine.Quantity > 0 THEN BEGIN
//                 TempWhseJnlLine2."Qty. (Base)" := TempWhseJnlLine2."Qty. (Absolute, Base)";
//                 TempWhseJnlLine2.Quantity := TempWhseJnlLine2."Qty. (Absolute)";
//               END ELSE BEGIN
//                 TempWhseJnlLine2."Qty. (Base)" := -TempWhseJnlLine2."Qty. (Absolute, Base)";
//                 TempWhseJnlLine2.Quantity := -TempWhseJnlLine2."Qty. (Absolute)";
//               END;
//               SplitFactor := "Quantity (Base)" / NonDistrQtyBase;
//               IF SplitFactor < 1 THEN BEGIN
//                 TempWhseJnlLine2.Cubage := ROUND(NonDistrCubage * SplitFactor,0.00001);
//                 TempWhseJnlLine2.Weight := ROUND(NonDistrWeight * SplitFactor,0.00001);
//                 NonDistrQtyBase -= "Quantity (Base)";
//                 NonDistrCubage -= TempWhseJnlLine2.Cubage;
//                 NonDistrWeight -= TempWhseJnlLine2.Weight;
//               END ELSE BEGIN // the last record
//                 TempWhseJnlLine2.Cubage := NonDistrCubage;
//                 TempWhseJnlLine2.Weight := NonDistrWeight;
//               END;
//               TempWhseJnlLine2.INSERT;
//             UNTIL NEXT = 0
//           ELSE BEGIN
//             TempWhseJnlLine2 := TempWhseJnlLine;
//             TempWhseJnlLine2.INSERT;
//           END;
//         END;
//     end;

//     procedure SplitPostedWhseRcptLine(PostedWhseRcptLine: Record "7319";var TempPostedWhseRcptlLine: Record "7319" temporary)
//     var
//         WhseItemEntryRelation: Record "6509";
//         ItemLedgEntry: Record "32";
//         LineNo: Integer;
//         WhseSNRequired: Boolean;
//         WhseLNRequired: Boolean;
//         CrossDockQty: Decimal;
//         CrossDockQtyBase: Decimal;
//     begin
//         TempPostedWhseRcptlLine.RESET;
//         TempPostedWhseRcptlLine.DELETEALL;

//         CheckWhseItemTrkgSetup(PostedWhseRcptLine."Item No.",WhseSNRequired,WhseLNRequired,FALSE);
//         IF NOT (WhseSNRequired OR WhseLNRequired) THEN BEGIN
//           TempPostedWhseRcptlLine := PostedWhseRcptLine;
//           TempPostedWhseRcptlLine.INSERT;
//           EXIT;
//         END;

//         WhseItemEntryRelation.RESET;
//         WhseItemEntryRelation.SETCURRENTKEY(
//           "Source ID","Source Type","Source Subtype","Source Ref. No.");
//         WhseItemEntryRelation.SETRANGE("Source ID",PostedWhseRcptLine."No.");
//         WhseItemEntryRelation.SETRANGE("Source Type",DATABASE::"Posted Whse. Receipt Line");
//         WhseItemEntryRelation.SETRANGE("Source Subtype",0);
//         WhseItemEntryRelation.SETRANGE("Source Ref. No.",PostedWhseRcptLine."Line No.");
//         IF WhseItemEntryRelation.FINDSET THEN BEGIN
//           REPEAT
//             ItemLedgEntry.GET(WhseItemEntryRelation."Item Entry No.");
//             TempPostedWhseRcptlLine.SETRANGE("Serial No.",ItemLedgEntry."Serial No.");
//             TempPostedWhseRcptlLine.SETRANGE("Lot No.",ItemLedgEntry."Lot No.");
//             TempPostedWhseRcptlLine.SETRANGE("Warranty Date",ItemLedgEntry."Warranty Date");
//             TempPostedWhseRcptlLine.SETRANGE("Expiration Date",ItemLedgEntry."Expiration Date");
//             IF TempPostedWhseRcptlLine.FINDFIRST THEN BEGIN
//               TempPostedWhseRcptlLine."Qty. (Base)" += ItemLedgEntry.Quantity;
//               TempPostedWhseRcptlLine.Quantity :=
//                 ROUND(TempPostedWhseRcptlLine."Qty. (Base)" / TempPostedWhseRcptlLine."Qty. per Unit of Measure",0.00001);
//               TempPostedWhseRcptlLine.MODIFY;

//               CrossDockQty := CrossDockQty - TempPostedWhseRcptlLine."Qty. Cross-Docked";
//               CrossDockQtyBase := CrossDockQtyBase - TempPostedWhseRcptlLine."Qty. Cross-Docked (Base)";
//             END ELSE BEGIN
//               LineNo += 10000;
//               TempPostedWhseRcptlLine.RESET;
//               TempPostedWhseRcptlLine := PostedWhseRcptLine;
//               TempPostedWhseRcptlLine."Line No." := LineNo;
//               TempPostedWhseRcptlLine."Serial No." := WhseItemEntryRelation."Serial No.";
//               TempPostedWhseRcptlLine."Lot No." := WhseItemEntryRelation."Lot No.";
//               TempPostedWhseRcptlLine."Warranty Date" := ItemLedgEntry."Warranty Date";
//               TempPostedWhseRcptlLine."Expiration Date" := ItemLedgEntry."Expiration Date";
//               TempPostedWhseRcptlLine."Qty. (Base)" := ItemLedgEntry.Quantity;
//               TempPostedWhseRcptlLine.Quantity :=
//                 ROUND(TempPostedWhseRcptlLine."Qty. (Base)" / TempPostedWhseRcptlLine."Qty. per Unit of Measure",0.00001);
//               TempPostedWhseRcptlLine.INSERT;
//             END;

//             IF WhseSNRequired THEN BEGIN
//               IF CrossDockQty < PostedWhseRcptLine."Qty. Cross-Docked" THEN BEGIN
//                 TempPostedWhseRcptlLine."Qty. Cross-Docked" := TempPostedWhseRcptlLine.Quantity;
//                 TempPostedWhseRcptlLine."Qty. Cross-Docked (Base)" := TempPostedWhseRcptlLine."Qty. (Base)";
//               END ELSE BEGIN
//                 TempPostedWhseRcptlLine."Qty. Cross-Docked" := 0;
//                 TempPostedWhseRcptlLine."Qty. Cross-Docked (Base)" := 0;
//               END;
//               CrossDockQty := CrossDockQty + TempPostedWhseRcptlLine.Quantity;
//             END ELSE
//               IF PostedWhseRcptLine."Qty. Cross-Docked" > 0 THEN BEGIN
//                 IF TempPostedWhseRcptlLine.Quantity <=
//                    PostedWhseRcptLine."Qty. Cross-Docked" - CrossDockQty
//                 THEN BEGIN
//                   TempPostedWhseRcptlLine."Qty. Cross-Docked" := TempPostedWhseRcptlLine.Quantity;
//                   TempPostedWhseRcptlLine."Qty. Cross-Docked (Base)" := TempPostedWhseRcptlLine."Qty. (Base)";
//                 END ELSE BEGIN
//                   TempPostedWhseRcptlLine."Qty. Cross-Docked" := PostedWhseRcptLine."Qty. Cross-Docked" - CrossDockQty;
//                   TempPostedWhseRcptlLine."Qty. Cross-Docked (Base)" :=
//                     PostedWhseRcptLine."Qty. Cross-Docked (Base)" - CrossDockQtyBase;
//                 END;
//                 CrossDockQty := CrossDockQty + TempPostedWhseRcptlLine."Qty. Cross-Docked";
//                 CrossDockQtyBase := CrossDockQtyBase + TempPostedWhseRcptlLine."Qty. Cross-Docked (Base)";
//                 IF CrossDockQty >= PostedWhseRcptLine."Qty. Cross-Docked" THEN BEGIN
//                   PostedWhseRcptLine."Qty. Cross-Docked" := 0;
//                   PostedWhseRcptLine."Qty. Cross-Docked (Base)" := 0;
//                 END;
//               END;
//             TempPostedWhseRcptlLine.MODIFY;
//           UNTIL WhseItemEntryRelation.NEXT = 0;
//         END ELSE BEGIN
//           TempPostedWhseRcptlLine := PostedWhseRcptLine;
//           TempPostedWhseRcptlLine.INSERT;
//         END
//     end;

//     procedure SplitInternalPutAwayLine(PostedWhseRcptLine: Record "7319";var TempPostedWhseRcptlLine: Record "7319" temporary)
//     var
//         WhseItemTrackingLine: Record "6550";
//         LineNo: Integer;
//         WhseSNRequired: Boolean;
//         WhseLNRequired: Boolean;
//     begin
//         TempPostedWhseRcptlLine.DELETEALL;

//         CheckWhseItemTrkgSetup(PostedWhseRcptLine."Item No.",WhseSNRequired,WhseLNRequired,FALSE);
//         IF NOT (WhseSNRequired OR WhseLNRequired) THEN BEGIN
//           TempPostedWhseRcptlLine := PostedWhseRcptLine;
//           TempPostedWhseRcptlLine.INSERT;
//           EXIT;
//         END;

//         WhseItemTrackingLine.RESET;
//         WhseItemTrackingLine.SETCURRENTKEY(
//           "Source ID","Source Type","Source Subtype","Source Batch Name",
//           "Source Prod. Order Line","Source Ref. No.");
//         WhseItemTrackingLine.SETRANGE("Source Type",DATABASE::"Whse. Internal Put-away Line");
//         WhseItemTrackingLine.SETRANGE("Source ID",PostedWhseRcptLine."No.");
//         WhseItemTrackingLine.SETRANGE("Source Subtype",0);
//         WhseItemTrackingLine.SETRANGE("Source Batch Name",'');
//         WhseItemTrackingLine.SETRANGE("Source Prod. Order Line",0);
//         WhseItemTrackingLine.SETRANGE("Source Ref. No.",PostedWhseRcptLine."Line No.");
//         WhseItemTrackingLine.SETFILTER("Qty. to Handle (Base)",'<>0');
//         IF WhseItemTrackingLine.FINDSET THEN
//           REPEAT
//             LineNo += 10000;
//             TempPostedWhseRcptlLine := PostedWhseRcptLine;
//             TempPostedWhseRcptlLine."Line No." := LineNo;
//             TempPostedWhseRcptlLine."Serial No." := WhseItemTrackingLine."Serial No.";
//             TempPostedWhseRcptlLine."Lot No." := WhseItemTrackingLine."Lot No.";
//             TempPostedWhseRcptlLine."Warranty Date" := WhseItemTrackingLine."Warranty Date";
//             TempPostedWhseRcptlLine."Expiration Date" := WhseItemTrackingLine."Expiration Date";
//             TempPostedWhseRcptlLine."Qty. (Base)" := WhseItemTrackingLine."Qty. to Handle (Base)";
//             TempPostedWhseRcptlLine.Quantity :=
//               ROUND(TempPostedWhseRcptlLine."Qty. (Base)" / TempPostedWhseRcptlLine."Qty. per Unit of Measure",0.00001);
//             TempPostedWhseRcptlLine.INSERT;
//           UNTIL WhseItemTrackingLine.NEXT = 0
//         ELSE BEGIN
//           TempPostedWhseRcptlLine := PostedWhseRcptLine;
//           TempPostedWhseRcptlLine.INSERT;
//         END
//     end;

//     procedure DeleteWhseItemTrkgLines(SourceType: Integer;SourceSubtype: Integer;SourceID: Code[20];SourceBatchName: Code[10];SourceProdOrderLine: Integer;SourceRefNo: Integer;LocationCode: Code[10];RelatedToLine: Boolean)
//     var
//         WhseItemTrkgLine: Record "6550";
//     begin
//         WITH WhseItemTrkgLine DO BEGIN
//           RESET;
//           SETCURRENTKEY(
//             "Source ID","Source Type","Source Subtype","Source Batch Name",
//             "Source Prod. Order Line","Source Ref. No.","Location Code");
//           SETRANGE("Source Type",SourceType);
//           SETRANGE("Source Subtype",SourceSubtype);
//           SETRANGE("Source ID",SourceID);
//           IF RelatedToLine THEN BEGIN
//             SETRANGE("Source Prod. Order Line",SourceProdOrderLine);
//             SETRANGE("Source Ref. No.",SourceRefNo);
//             SETRANGE("Source Batch Name",SourceBatchName);
//             SETRANGE("Location Code",LocationCode);
//           END;

//           IF FINDSET THEN
//             REPEAT
//               // If the item tracking information was added through a pick registration, the reservation entry needs to
//               // be modified/deleted as well in order to remove this item tracking information again.
//               IF DeleteReservationEntries AND
//                  "Created by Whse. Activity Line" AND
//                  ("Source Type" = DATABASE::"Warehouse Shipment Line")
//               THEN
//                 RemoveItemTrkgFromReservEntry("Source ID","Source Ref. No.","Quantity (Base)","Serial No.","Lot No.");
//               DELETE;
//             UNTIL NEXT = 0;
//         END;
//     end;

//     local procedure RemoveItemTrkgFromReservEntry(SourceID: Code[20];SourceRefNo: Integer;QuantityBase: Decimal;SerialNo: Code[20];LotNo: Code[20])
//     var
//         ReservEntry: Record "337";
//         WarehouseShipmentLine: Record "7321";
//     begin
//         WarehouseShipmentLine.SETRANGE("No.",SourceID);
//         WarehouseShipmentLine.SETRANGE("Line No.",SourceRefNo);
//         IF WarehouseShipmentLine.FINDFIRST THEN
//           WITH ReservEntry DO BEGIN
//             SETCURRENTKEY("Source ID","Source Ref. No.","Source Type","Source Subtype");
//             SETRANGE("Source Type",WarehouseShipmentLine."Source Type");
//             SETRANGE("Source Subtype",WarehouseShipmentLine."Source Subtype");
//             SETRANGE("Source ID",WarehouseShipmentLine."Source No.");
//             SETRANGE("Source Ref. No.",WarehouseShipmentLine."Source Line No.");
//             SETRANGE("Quantity (Base)",-QuantityBase);
//             SETRANGE("Serial No.",SerialNo);
//             SETRANGE("Lot No.",LotNo);
//             IF FINDFIRST THEN
//               CASE "Reservation Status" OF
//                 "Reservation Status"::Surplus:
//                   DELETE(TRUE);
//                 ELSE BEGIN
//                   ClearItemTrackingFields;
//                   MODIFY(TRUE);
//                 END;
//               END;
//           END;
//     end;

//     procedure SetDeleteReservationEntries(DeleteEntries: Boolean)
//     begin
//         DeleteReservationEntries := DeleteEntries;
//     end;

//     procedure InitTrackingSpecification(WhseWkshLine: Record "7326")
//     var
//         WhseItemTrkgLine: Record "6550";
//         PostedWhseReceiptLine: Record "7319";
//         TempWhseItemTrkgLine: Record "6550" temporary;
//         WhseManagement: Codeunit "5775";
//         SourceType: Integer;
//     begin
//         SourceType := WhseManagement.GetSourceType(WhseWkshLine);
//         WITH WhseWkshLine DO BEGIN
//           IF "Whse. Document Type" = "Whse. Document Type"::Receipt THEN BEGIN
//             PostedWhseReceiptLine.SETRANGE("No.","Whse. Document No.");
//             IF PostedWhseReceiptLine.FINDSET THEN
//               REPEAT
//                 InsertWhseItemTrkgLines(PostedWhseReceiptLine,SourceType);
//               UNTIL PostedWhseReceiptLine.NEXT = 0;
//           END;

//           WhseItemTrkgLine.SETCURRENTKEY(
//             "Source ID","Source Type","Source Subtype","Source Batch Name","Source Prod. Order Line","Source Ref. No.");

//           WhseItemTrkgLine.SETRANGE("Source Type",SourceType);
//           IF SourceType = DATABASE::"Prod. Order Component" THEN BEGIN
//             WhseItemTrkgLine.SETRANGE("Source Subtype","Source Subtype");
//             WhseItemTrkgLine.SETRANGE("Source ID","Source No.");
//             WhseItemTrkgLine.SETRANGE("Source Prod. Order Line","Source Line No.");
//             WhseItemTrkgLine.SETRANGE("Source Ref. No.","Source Subline No.");
//           END ELSE BEGIN
//             WhseItemTrkgLine.SETRANGE("Source ID","Whse. Document No.");
//             WhseItemTrkgLine.SETRANGE("Source Ref. No.","Whse. Document Line No.");
//           END;

//           WhseItemTrkgLine.LOCKTABLE;
//           IF WhseItemTrkgLine.FINDSET THEN BEGIN
//             REPEAT
//               CalcWhseItemTrkgLine(WhseItemTrkgLine);
//               WhseItemTrkgLine.MODIFY;
//               IF SourceType IN [DATABASE::"Prod. Order Component",DATABASE::"Assembly Line"] THEN BEGIN
//                 TempWhseItemTrkgLine := WhseItemTrkgLine;
//                 TempWhseItemTrkgLine.INSERT;
//               END;
//             UNTIL WhseItemTrkgLine.NEXT = 0;
//             IF NOT TempWhseItemTrkgLine.ISEMPTY THEN
//               CheckWhseItemTrkg(TempWhseItemTrkgLine,WhseWkshLine);
//           END ELSE
//             CASE SourceType OF
//               DATABASE::"Posted Whse. Receipt Line":
//                 CreateWhseItemTrkgForReceipt(WhseWkshLine);
//               DATABASE::"Warehouse Shipment Line":
//                 CreateWhseItemTrkgBatch(WhseWkshLine);
//               DATABASE::"Prod. Order Component":
//                 CreateWhseItemTrkgBatch(WhseWkshLine);
//               DATABASE::"Assembly Line":
//                 CreateWhseItemTrkgBatch(WhseWkshLine);
//             END;
//         END;
//     end;

//     local procedure CreateWhseItemTrkgForReceipt(WhseWkshLine: Record "7326")
//     var
//         ItemLedgEntry: Record "32";
//         WhseItemEntryRelation: Record "6509";
//         WhseItemTrackingLine: Record "6550";
//         EntryNo: Integer;
//     begin
//         WITH WhseWkshLine DO BEGIN
//           WhseItemTrackingLine.RESET;
//           IF WhseItemTrackingLine.FINDLAST THEN
//             EntryNo := WhseItemTrackingLine."Entry No.";

//           WhseItemEntryRelation.SETCURRENTKEY(
//             "Source ID","Source Type","Source Subtype","Source Ref. No.");
//           WhseItemEntryRelation.SETRANGE("Source ID","Whse. Document No.");
//           WhseItemEntryRelation.SETRANGE("Source Type",DATABASE::"Posted Whse. Receipt Line");
//           WhseItemEntryRelation.SETRANGE("Source Subtype",0);
//           WhseItemEntryRelation.SETRANGE("Source Ref. No.","Whse. Document Line No.");
//           IF WhseItemEntryRelation.FINDSET THEN
//             REPEAT
//               WhseItemTrackingLine.INIT;
//               EntryNo += 1;
//               WhseItemTrackingLine."Entry No." := EntryNo;
//               WhseItemTrackingLine."Item No." := "Item No.";
//               WhseItemTrackingLine."Variant Code" := "Variant Code";
//               WhseItemTrackingLine."Location Code" := "Location Code";
//               WhseItemTrackingLine.Description := Description;
//               WhseItemTrackingLine."Qty. per Unit of Measure" := "Qty. per From Unit of Measure";
//               WhseItemTrackingLine."Source Type" := DATABASE::"Posted Whse. Receipt Line";
//               WhseItemTrackingLine."Source ID" := "Whse. Document No.";
//               WhseItemTrackingLine."Source Ref. No." := "Whse. Document Line No.";
//               ItemLedgEntry.GET(WhseItemEntryRelation."Item Entry No.");
//               WhseItemTrackingLine."Serial No." := ItemLedgEntry."Serial No.";
//               WhseItemTrackingLine."Lot No." := ItemLedgEntry."Lot No.";
//               WhseItemTrackingLine."Warranty Date" := ItemLedgEntry."Warranty Date";
//               WhseItemTrackingLine."Expiration Date" := ItemLedgEntry."Expiration Date";
//               WhseItemTrackingLine."Quantity (Base)" := ItemLedgEntry.Quantity;
//               IF "Qty. (Base)" = "Qty. to Handle (Base)" THEN
//                 WhseItemTrackingLine."Qty. to Handle (Base)" := WhseItemTrackingLine."Quantity (Base)";
//               WhseItemTrackingLine."Qty. to Handle" :=
//                 ROUND(WhseItemTrackingLine."Qty. to Handle (Base)" / WhseItemTrackingLine."Qty. per Unit of Measure",0.00001);
//               WhseItemTrackingLine.INSERT;
//             UNTIL WhseItemEntryRelation.NEXT = 0;
//         END;
//     end;

//     local procedure CreateWhseItemTrkgBatch(WhseWkshLine: Record "7326")
//     var
//         SourceItemTrackingLine: Record "337";
//         WhseManagement: Codeunit "5775";
//         SourceType: Integer;
//     begin
//         SourceType := WhseManagement.GetSourceType(WhseWkshLine);

//         WITH WhseWkshLine DO BEGIN
//           SourceItemTrackingLine.SETCURRENTKEY(
//             "Source ID","Source Ref. No.","Source Type","Source Subtype",
//             "Source Batch Name","Source Prod. Order Line");
//           SourceItemTrackingLine.SETRANGE("Source ID","Source No.");
//           SourceItemTrackingLine.SETRANGE("Source Type","Source Type");
//           SourceItemTrackingLine.SETRANGE("Source Subtype","Source Subtype");
//           SourceItemTrackingLine.SETRANGE("Source Batch Name",'');
//           CASE SourceType OF
//             DATABASE::"Prod. Order Component":
//               BEGIN
//                 SourceItemTrackingLine.SETRANGE("Source Ref. No.","Source Subline No.");
//                 SourceItemTrackingLine.SETRANGE("Source Prod. Order Line","Source Line No.");
//               END;
//             ELSE BEGIN
//               SourceItemTrackingLine.SETRANGE("Source Ref. No.","Source Line No.");
//               SourceItemTrackingLine.SETRANGE("Source Prod. Order Line",0);
//             END;
//           END;
//           IF SourceItemTrackingLine.FINDSET THEN
//             REPEAT
//               CreateWhseItemTrkgForResEntry(SourceItemTrackingLine,WhseWkshLine);
//             UNTIL SourceItemTrackingLine.NEXT = 0;
//         END;
//     end;

//     procedure CreateWhseItemTrkgForResEntry(SourceItemTrackingLine: Record "337";WhseWkshLine: Record "7326")
//     var
//         WhseItemTrackingLine: Record "6550";
//         WhseManagement: Codeunit "5775";
//         EntryNo: Integer;
//         SourceType: Integer;
//     begin
//         IF NOT ((SourceItemTrackingLine."Reservation Status" <> SourceItemTrackingLine."Reservation Status"::Reservation) OR
//                 IsResEntryReservedAgainstInventory(SourceItemTrackingLine))
//         THEN
//           EXIT;

//         IF (SourceItemTrackingLine."Serial No." = '') AND
//            (SourceItemTrackingLine."Lot No." = '')
//         THEN
//           EXIT;

//         SourceType := WhseManagement.GetSourceType(WhseWkshLine);

//         IF WhseItemTrackingLine.FINDLAST THEN
//           EntryNo := WhseItemTrackingLine."Entry No.";

//         WhseItemTrackingLine.INIT;

//         WITH WhseWkshLine DO
//           CASE SourceType OF
//             DATABASE::"Posted Whse. Receipt Line":
//               BEGIN
//                 WhseItemTrackingLine."Source Type" := DATABASE::"Posted Whse. Receipt Line";
//                 WhseItemTrackingLine."Source ID" := "Whse. Document No.";
//                 WhseItemTrackingLine."Source Ref. No." := "Whse. Document Line No.";
//               END;
//             DATABASE::"Warehouse Shipment Line":
//               BEGIN
//                 WhseItemTrackingLine."Source Type" := DATABASE::"Warehouse Shipment Line";
//                 WhseItemTrackingLine."Source ID" := "Whse. Document No.";
//                 WhseItemTrackingLine."Source Ref. No." := "Whse. Document Line No.";
//               END;
//             DATABASE::"Assembly Line":
//               BEGIN
//                 WhseItemTrackingLine."Source Type" := DATABASE::"Assembly Line";
//                 WhseItemTrackingLine."Source ID" := "Whse. Document No.";
//                 WhseItemTrackingLine."Source Ref. No." := "Whse. Document Line No.";
//                 WhseItemTrackingLine."Source Subtype" := "Source Subtype";
//               END;
//             DATABASE::"Prod. Order Component":
//               BEGIN
//                 WhseItemTrackingLine."Source Type" := "Source Type";
//                 WhseItemTrackingLine."Source Subtype" := "Source Subtype";
//                 WhseItemTrackingLine."Source ID" := "Source No.";
//                 WhseItemTrackingLine."Source Prod. Order Line" := "Source Line No.";
//                 WhseItemTrackingLine."Source Ref. No." := "Source Subline No.";
//               END;
//           END;

//         WhseItemTrackingLine."Entry No." := EntryNo + 1;
//         WhseItemTrackingLine."Item No." := SourceItemTrackingLine."Item No.";
//         WhseItemTrackingLine."Variant Code" := SourceItemTrackingLine."Variant Code";
//         WhseItemTrackingLine."Location Code" := SourceItemTrackingLine."Location Code";
//         WhseItemTrackingLine.Description := SourceItemTrackingLine.Description;
//         WhseItemTrackingLine."Qty. per Unit of Measure" := SourceItemTrackingLine."Qty. per Unit of Measure";
//         WhseItemTrackingLine."Serial No." := SourceItemTrackingLine."Serial No.";
//         WhseItemTrackingLine."Lot No." := SourceItemTrackingLine."Lot No.";
//         WhseItemTrackingLine."Warranty Date" := SourceItemTrackingLine."Warranty Date";
//         WhseItemTrackingLine."Expiration Date" := SourceItemTrackingLine."Expiration Date";
//         WhseItemTrackingLine."Quantity (Base)" := -SourceItemTrackingLine."Quantity (Base)";
//         IF WhseWkshLine."Qty. (Base)" = WhseWkshLine."Qty. to Handle (Base)" THEN BEGIN
//           WhseItemTrackingLine."Qty. to Handle (Base)" := WhseItemTrackingLine."Quantity (Base)";
//           WhseItemTrackingLine."Qty. to Handle" := -SourceItemTrackingLine.Quantity;
//         END;
//         WhseItemTrackingLine.INSERT;
//     end;

//     procedure CalcWhseItemTrkgLine(var WhseItemTrkgLine: Record "6550")
//     var
//         WhseActivQtyBase: Decimal;
//     begin
//         CASE WhseItemTrkgLine."Source Type" OF
//           DATABASE::"Posted Whse. Receipt Line":
//             WhseItemTrkgLine."Source Type Filter" := WhseItemTrkgLine."Source Type Filter"::Receipt;
//           DATABASE::"Whse. Internal Put-away Line":
//             WhseItemTrkgLine."Source Type Filter" := WhseItemTrkgLine."Source Type Filter"::"Internal Put-away";
//           DATABASE::"Warehouse Shipment Line":
//             WhseItemTrkgLine."Source Type Filter" := WhseItemTrkgLine."Source Type Filter"::Shipment;
//           DATABASE::"Whse. Internal Pick Line":
//             WhseItemTrkgLine."Source Type Filter" := WhseItemTrkgLine."Source Type Filter"::"Internal Pick";
//           DATABASE::"Prod. Order Component":
//             WhseItemTrkgLine."Source Type Filter" := WhseItemTrkgLine."Source Type Filter"::Production;
//           DATABASE::"Assembly Line":
//             WhseItemTrkgLine."Source Type Filter" := WhseItemTrkgLine."Source Type Filter"::Assembly;
//           DATABASE::"Whse. Worksheet Line":
//             WhseItemTrkgLine."Source Type Filter" := WhseItemTrkgLine."Source Type Filter"::"Movement Worksheet";
//         END;
//         WhseItemTrkgLine.CALCFIELDS("Put-away Qty. (Base)","Pick Qty. (Base)");

//         IF WhseItemTrkgLine."Put-away Qty. (Base)" > 0 THEN
//           WhseActivQtyBase := WhseItemTrkgLine."Put-away Qty. (Base)";
//         IF WhseItemTrkgLine."Pick Qty. (Base)" > 0 THEN
//           WhseActivQtyBase := WhseItemTrkgLine."Pick Qty. (Base)";

//         IF NOT Registering THEN
//           WhseItemTrkgLine.VALIDATE("Quantity Handled (Base)",
//             WhseActivQtyBase + WhseItemTrkgLine."Qty. Registered (Base)")
//         ELSE
//           WhseItemTrkgLine.VALIDATE("Quantity Handled (Base)",
//             WhseItemTrkgLine."Qty. Registered (Base)");

//         IF WhseItemTrkgLine."Quantity (Base)" >= WhseItemTrkgLine."Quantity Handled (Base)" THEN
//           WhseItemTrkgLine.VALIDATE("Qty. to Handle (Base)",
//             WhseItemTrkgLine."Quantity (Base)" - WhseItemTrkgLine."Quantity Handled (Base)");
//     end;

//     procedure InitItemTrkgForTempWkshLine(WhseDocType: Option;WhseDocNo: Code[20];WhseDocLineNo: Integer;SourceType: Integer;SourceSubtype: Option "0","1","2","3","4","5","6","7","8","9","10";SourceNo: Code[20];SourceLineNo: Integer;SourceSublineNo: Integer)
//     var
//         TempWhseWkshLine: Record "7326";
//     begin
//         InitWhseWkshLine(TempWhseWkshLine,WhseDocType,WhseDocNo,WhseDocLineNo,SourceType,SourceSubtype,SourceNo,
//           SourceLineNo,SourceSublineNo);
//         InitTrackingSpecification(TempWhseWkshLine);
//     end;

//     procedure InitWhseWkshLine(var WhseWkshLine: Record "7326";WhseDocType: Option;WhseDocNo: Code[20];WhseDocLineNo: Integer;SourceType: Integer;SourceSubtype: Option "0","1","2","3","4","5","6","7","8","9","10";SourceNo: Code[20];SourceLineNo: Integer;SourceSublineNo: Integer)
//     begin
//         WhseWkshLine.INIT;
//         WhseWkshLine."Whse. Document Type" := WhseDocType;
//         WhseWkshLine."Whse. Document No." := WhseDocNo;
//         WhseWkshLine."Whse. Document Line No." := WhseDocLineNo;
//         WhseWkshLine."Source Type" := SourceType;
//         WhseWkshLine."Source Subtype" := SourceSubtype;
//         WhseWkshLine."Source No." := SourceNo;
//         WhseWkshLine."Source Line No." := SourceLineNo;
//         WhseWkshLine."Source Subline No." := SourceSublineNo;
//     end;

//     procedure UpdateWhseItemTrkgLines(var TempWhseItemTrkgLine: Record "6550" temporary)
//     var
//         WhseItemTrkgLine: Record "6550";
//     begin
//         IF TempWhseItemTrkgLine.FINDSET THEN
//           REPEAT
//             WhseItemTrkgLine.SETCURRENTKEY("Serial No.","Lot No.");
//             WhseItemTrkgLine.SETRANGE("Serial No.",TempWhseItemTrkgLine."Serial No.");
//             WhseItemTrkgLine.SETRANGE("Lot No.",TempWhseItemTrkgLine."Lot No.");
//             WhseItemTrkgLine.SETRANGE("Source Type",TempWhseItemTrkgLine."Source Type");
//             WhseItemTrkgLine.SETRANGE("Source Subtype",TempWhseItemTrkgLine."Source Subtype");
//             WhseItemTrkgLine.SETRANGE("Source ID",TempWhseItemTrkgLine."Source ID");
//             WhseItemTrkgLine.SETRANGE("Source Batch Name",TempWhseItemTrkgLine."Source Batch Name");
//             WhseItemTrkgLine.SETRANGE("Source Prod. Order Line",TempWhseItemTrkgLine."Source Prod. Order Line");
//             WhseItemTrkgLine.SETRANGE("Source Ref. No.",TempWhseItemTrkgLine."Source Ref. No.");
//             WhseItemTrkgLine.LOCKTABLE;
//             IF WhseItemTrkgLine.FINDFIRST THEN BEGIN
//               CalcWhseItemTrkgLine(WhseItemTrkgLine);
//               WhseItemTrkgLine.MODIFY;
//             END;
//           UNTIL TempWhseItemTrkgLine.NEXT = 0
//     end;

//     local procedure InsertWhseItemTrkgLines(PostedWhseReceiptLine: Record "7319";SourceType: Integer)
//     var
//         WhseItemTrkgLine: Record "6550";
//         WhseItemEntryRelation: Record "6509";
//         ItemLedgEntry: Record "32";
//         EntryNo: Integer;
//         QtyHandledBase: Decimal;
//     begin
//         IF WhseItemTrkgLine.FINDLAST THEN
//           EntryNo := WhseItemTrkgLine."Entry No." + 1
//         ELSE
//           EntryNo := 1;

//         WITH PostedWhseReceiptLine DO BEGIN
//           WhseItemEntryRelation.RESET;
//           WhseItemEntryRelation.SETCURRENTKEY(
//             "Source ID","Source Type","Source Subtype","Source Ref. No.");
//           WhseItemEntryRelation.SETRANGE("Source ID","No.");
//           WhseItemEntryRelation.SETRANGE("Source Type",SourceType);
//           WhseItemEntryRelation.SETRANGE("Source Subtype",0);
//           WhseItemEntryRelation.SETRANGE("Source Ref. No.","Line No.");
//           IF WhseItemEntryRelation.FINDSET THEN BEGIN
//             WhseItemTrkgLine.SETCURRENTKEY("Source ID","Source Type","Source Subtype");
//             WhseItemTrkgLine.SETRANGE("Source ID","No.");
//             WhseItemTrkgLine.SETRANGE("Source Type",SourceType);
//             WhseItemTrkgLine.SETRANGE("Source Subtype",0);
//             WhseItemTrkgLine.SETRANGE("Source Ref. No.","Line No.");
//             WhseItemTrkgLine.DELETEALL;
//             WhseItemTrkgLine.SETCURRENTKEY("Serial No.","Lot No.");
//             REPEAT
//               WhseItemTrkgLine.SETRANGE("Serial No.",WhseItemEntryRelation."Serial No.");
//               WhseItemTrkgLine.SETRANGE("Lot No.",WhseItemEntryRelation."Lot No.");
//               ItemLedgEntry.GET(WhseItemEntryRelation."Item Entry No.");
//               QtyHandledBase := RegisteredPutAwayQtyBase(PostedWhseReceiptLine,WhseItemEntryRelation);

//               IF NOT WhseItemTrkgLine.FINDFIRST THEN BEGIN
//                 WhseItemTrkgLine.INIT;
//                 WhseItemTrkgLine."Entry No." := EntryNo;
//                 EntryNo := EntryNo + 1;

//                 WhseItemTrkgLine."Item No." := ItemLedgEntry."Item No.";
//                 WhseItemTrkgLine."Location Code" := ItemLedgEntry."Location Code";
//                 WhseItemTrkgLine.Description := ItemLedgEntry.Description;
//                 WhseItemTrkgLine."Source Type" := WhseItemEntryRelation."Source Type";
//                 WhseItemTrkgLine."Source Subtype" := WhseItemEntryRelation."Source Subtype";
//                 WhseItemTrkgLine."Source ID" := WhseItemEntryRelation."Source ID";
//                 WhseItemTrkgLine."Source Batch Name" := WhseItemEntryRelation."Source Batch Name";
//                 WhseItemTrkgLine."Source Prod. Order Line" := WhseItemEntryRelation."Source Prod. Order Line";
//                 WhseItemTrkgLine."Source Ref. No." := WhseItemEntryRelation."Source Ref. No.";
//                 WhseItemTrkgLine."Serial No." := WhseItemEntryRelation."Serial No.";
//                 WhseItemTrkgLine."Lot No." := WhseItemEntryRelation."Lot No.";
//                 WhseItemTrkgLine."Qty. per Unit of Measure" := ItemLedgEntry."Qty. per Unit of Measure";
//                 WhseItemTrkgLine."Warranty Date" := ItemLedgEntry."Warranty Date";
//                 WhseItemTrkgLine."Expiration Date" := ItemLedgEntry."Expiration Date";
//                 WhseItemTrkgLine."Quantity Handled (Base)" := QtyHandledBase;
//                 WhseItemTrkgLine."Qty. Registered (Base)" := QtyHandledBase;
//                 WhseItemTrkgLine.VALIDATE("Quantity (Base)",ItemLedgEntry.Quantity);
//                 WhseItemTrkgLine.INSERT;
//               END ELSE BEGIN
//                 WhseItemTrkgLine.VALIDATE("Quantity (Base)",WhseItemTrkgLine."Quantity (Base)" + ItemLedgEntry.Quantity);
//                 WhseItemTrkgLine."Quantity Handled (Base)" += QtyHandledBase;
//                 WhseItemTrkgLine."Qty. Registered (Base)" += QtyHandledBase;
//                 WhseItemTrkgLine.MODIFY;
//               END;
//             UNTIL WhseItemEntryRelation.NEXT = 0;
//           END;
//         END;
//     end;

//     local procedure RegisteredPutAwayQtyBase(PostedWhseReceiptLine: Record "7319";WhseItemEntryRelation: Record "6509"): Decimal
//     var
//         RegisteredWhseActivityLine: Record "5773";
//     begin
//         WITH PostedWhseReceiptLine DO BEGIN
//           RegisteredWhseActivityLine.RESET;
//           RegisteredWhseActivityLine.SETCURRENTKEY(
//             "Source Type","Source Subtype","Source No.","Source Line No.","Source Subline No.",
//             "Whse. Document No.","Serial No.","Lot No.","Action Type");
//           RegisteredWhseActivityLine.SETRANGE("Source Type","Source Type");
//           RegisteredWhseActivityLine.SETRANGE("Source Subtype","Source Subtype");
//           RegisteredWhseActivityLine.SETRANGE("Source No.","Source No.");
//           RegisteredWhseActivityLine.SETRANGE("Source Line No.","Source Line No.");
//           RegisteredWhseActivityLine.SETRANGE("Whse. Document No.","No.");
//           RegisteredWhseActivityLine.SETRANGE("Serial No.",WhseItemEntryRelation."Serial No.");
//           RegisteredWhseActivityLine.SETRANGE("Lot No.",WhseItemEntryRelation."Lot No.");
//           RegisteredWhseActivityLine.SETRANGE("Action Type",RegisteredWhseActivityLine."Action Type"::Take);
//           RegisteredWhseActivityLine.CALCSUMS("Qty. (Base)");
//         END;

//         EXIT(RegisteredWhseActivityLine."Qty. (Base)");
//     end;

//     procedure ItemTrkgIsManagedByWhse(Type: Integer;Subtype: Integer;ID: Code[20];ProdOrderLine: Integer;RefNo: Integer;LocationCode: Code[10];ItemNo: Code[20]): Boolean
//     var
//         WhseShipmentLine: Record "7321";
//         WhseWkshLine: Record "7326";
//         WhseActivLine: Record "5767";
//         WhseWkshTemplate: Record "7328";
//         Location: Record "14";
//         SNRequired: Boolean;
//         LNRequired: Boolean;
//     begin
//         IF NOT (Type IN [DATABASE::"Sales Line",
//                          DATABASE::"Purchase Line",
//                          DATABASE::"Transfer Line",
//                          DATABASE::"Assembly Header",
//                          DATABASE::"Assembly Line",
//                          DATABASE::"Prod. Order Line",
//                          DATABASE::"Prod. Order Component"])
//         THEN
//           EXIT(FALSE);

//         IF NOT (Location.RequirePicking(LocationCode) OR Location.RequirePutaway(LocationCode)) THEN
//           EXIT(FALSE);

//         CheckWhseItemTrkgSetup(ItemNo,SNRequired,LNRequired,FALSE);
//         IF NOT (SNRequired OR LNRequired) THEN
//           EXIT(FALSE);

//         WhseShipmentLine.SETCURRENTKEY(
//           "Source Type","Source Subtype","Source No.","Source Line No.");
//         WhseShipmentLine.SETRANGE("Source Type",Type);
//         WhseShipmentLine.SETRANGE("Source Subtype",Subtype);
//         WhseShipmentLine.SETRANGE("Source No.",ID);
//         WhseShipmentLine.SETRANGE("Source Line No.",RefNo);
//         IF NOT WhseShipmentLine.ISEMPTY THEN
//           EXIT(TRUE);

//         WhseWkshLine.SETCURRENTKEY(
//           "Source Type","Source Subtype","Source No.","Source Line No.","Source Subline No.");
//         WhseWkshLine.SETRANGE("Source Type",Type);
//         WhseWkshLine.SETRANGE("Source Subtype",Subtype);
//         WhseWkshLine.SETRANGE("Source No.",ID);
//         IF Type IN [DATABASE::"Prod. Order Component",DATABASE::"Prod. Order Line"] THEN BEGIN
//           WhseWkshLine.SETRANGE("Source Line No.",ProdOrderLine);
//           WhseWkshLine.SETRANGE("Source Subline No.",RefNo);
//         END ELSE
//           WhseWkshLine.SETRANGE("Source Line No.",RefNo);
//         IF WhseWkshLine.FINDFIRST THEN
//           IF WhseWkshTemplate.GET(WhseWkshLine."Worksheet Template Name") THEN
//             IF WhseWkshTemplate.Type = WhseWkshTemplate.Type::Pick THEN
//               EXIT(TRUE);

//         WhseActivLine.SETCURRENTKEY(
//           "Source Type","Source Subtype","Source No.","Source Line No.","Source Subline No.");
//         WhseActivLine.SETRANGE("Source Type",Type);
//         WhseActivLine.SETRANGE("Source Subtype",Subtype);
//         WhseActivLine.SETRANGE("Source No.",ID);
//         IF Type IN [DATABASE::"Prod. Order Component",DATABASE::"Prod. Order Line"] THEN BEGIN
//           WhseActivLine.SETRANGE("Source Line No.",ProdOrderLine);
//           WhseActivLine.SETRANGE("Source Subline No.",RefNo);
//         END ELSE
//           WhseActivLine.SETRANGE("Source Line No.",RefNo);
//         IF WhseActivLine.FINDFIRST THEN
//           IF WhseActivLine."Activity Type" IN [WhseActivLine."Activity Type"::Pick,
//                                                WhseActivLine."Activity Type"::"Invt. Put-away",
//                                                WhseActivLine."Activity Type"::"Invt. Pick"]
//           THEN
//             EXIT(TRUE);

//         EXIT(FALSE);
//     end;

//     procedure CheckWhseItemTrkgSetup(ItemNo: Code[20];var SNRequired: Boolean;var LNRequired: Boolean;ShowError: Boolean)
//     var
//         ItemTrackingCode: Record "6502";
//         Item: Record "27";
//     begin
//         SNRequired := FALSE;
//         LNRequired := FALSE;
//         IF Item."No." <> ItemNo THEN
//           Item.GET(ItemNo);
//         IF Item."Item Tracking Code" <> '' THEN BEGIN
//           IF ItemTrackingCode.Code <> Item."Item Tracking Code" THEN
//             ItemTrackingCode.GET(Item."Item Tracking Code");
//           SNRequired := ItemTrackingCode."SN Warehouse Tracking";
//           LNRequired := ItemTrackingCode."Lot Warehouse Tracking";
//         END;
//         IF NOT (SNRequired OR LNRequired) AND ShowError THEN
//           ERROR(Text005,Item.FIELDCAPTION("No."),ItemNo);
//     end;

//     procedure SetGlobalParameters(SourceSpecification2: Record "336" temporary;var TempTrackingSpecification2: Record "336" temporary;DueDate2: Date)
//     begin
//         SourceSpecification := SourceSpecification2;
//         DueDate := DueDate2;
//         IF TempTrackingSpecification2.FINDSET THEN
//           REPEAT
//             TempTrackingSpecification := TempTrackingSpecification2;
//             TempTrackingSpecification.INSERT;
//           UNTIL TempTrackingSpecification2.NEXT = 0;
//     end;

//     procedure AdjustQuantityRounding(NonDistrQuantity: Decimal;var QtyToBeHandled: Decimal;NonDistrQuantityBase: Decimal;QtyToBeHandledBase: Decimal)
//     var
//         FloatingFactor: Decimal;
//     begin
//         // Used by CU80/90 for handling rounding differences during invoicing

//         FloatingFactor := QtyToBeHandledBase / NonDistrQuantityBase;

//         IF FloatingFactor < 1 THEN
//           QtyToBeHandled := ROUND(FloatingFactor * NonDistrQuantity,0.00001)
//         ELSE
//           QtyToBeHandled := NonDistrQuantity;
//     end;

//     procedure SynchronizeItemTracking(FromRowID: Text[100];ToRowID: Text[100];DialogText: Text[250])
//     var
//         ReservEntry1: Record "337";
//         ReservMgt: Codeunit "99000845";
//     begin
//         // Used for syncronizing between orders linked via Drop Shipment
//         ReservEntry1.SetPointer(FromRowID);
//         ReservMgt.SetPointerFilter(ReservEntry1);
//         SynchronizeItemTracking2(ReservEntry1,ToRowID,DialogText);
//     end;

//     procedure SynchronizeItemTracking2(var FromReservEntry: Record "337";ToRowID: Text[250];DialogText: Text[250])
//     var
//         ReservEntry2: Record "337";
//         TempTrkgSpec1: Record "336" temporary;
//         TempTrkgSpec2: Record "336" temporary;
//         TempTrkgSpec3: Record "336" temporary;
//         TempSourceSpec: Record "336" temporary;
//         ItemTrackingForm: Page "6510";
//         ItemTrackingMgt: Codeunit "6500";
//         ReservMgt: Codeunit "99000845";
//         CreateReservEntry: Codeunit "99000830";
//         AvailabilityDate: Date;
//         LastEntryNo: Integer;
//         SignFactor1: Integer;
//         SignFactor2: Integer;
//         SecondSourceRowID: Text[250];
//     begin
//         // Used for synchronizing between orders linked via Drop Shipment and for
//         // synchronizing between invt. pick/put-away and parent line.
//         ReservEntry2.SetPointer(ToRowID);
//         SignFactor1 := CreateReservEntry.SignFactor(FromReservEntry);
//         SignFactor2 := CreateReservEntry.SignFactor(ReservEntry2);
//         ReservMgt.SetPointerFilter(ReservEntry2);

//         IF ReservEntry2.ISEMPTY THEN BEGIN
//           IF FromReservEntry.ISEMPTY THEN
//             EXIT;
//           IF DialogText <> '' THEN
//             IF NOT CONFIRM(DialogText) THEN BEGIN
//               MESSAGE(Text006);
//               EXIT;
//             END;
//           CopyItemTracking3(FromReservEntry,ToRowID,SignFactor1 <> SignFactor2,FALSE);

//           // Copy to inbound part of transfer.
//           IF (FromReservEntry."Source Type" = DATABASE::"Transfer Line") AND
//              (FromReservEntry."Source Subtype" = 0)
//           THEN BEGIN
//             SecondSourceRowID :=
//               ItemTrackingMgt.ComposeRowID(FromReservEntry."Source Type",
//                 1,FromReservEntry."Source ID",
//                 FromReservEntry."Source Batch Name",FromReservEntry."Source Prod. Order Line",
//                 FromReservEntry."Source Ref. No.");
//             IF ToRowID <> SecondSourceRowID THEN // Avoid copying to the line itself
//               CopyItemTracking(ToRowID,SecondSourceRowID,TRUE);
//           END;
//         END ELSE BEGIN
//           IF (FromReservEntry."Source Type" = DATABASE::"Transfer Line") AND
//              (FromReservEntry."Source Subtype" = 0)
//           THEN
//             SynchronizeItemTrkgTransfer(ReservEntry2);    // synchronize transfer

//           IF SumUpItemTracking(ReservEntry2,TempTrkgSpec2,FALSE,TRUE) THEN
//             TempSourceSpec := TempTrkgSpec2 // TempSourceSpec is used for conveying source information to Form6510.
//           ELSE
//             TempSourceSpec.TRANSFERFIELDS(ReservEntry2);

//           IF ReservEntry2."Quantity (Base)" > 0 THEN
//             AvailabilityDate := ReservEntry2."Expected Receipt Date"
//           ELSE
//             AvailabilityDate := ReservEntry2."Shipment Date";

//           SumUpItemTracking(FromReservEntry,TempTrkgSpec1,FALSE,TRUE);

//           TempTrkgSpec1.RESET;
//           TempTrkgSpec2.RESET;
//           TempTrkgSpec1.SETCURRENTKEY("Lot No.","Serial No.");
//           TempTrkgSpec2.SETCURRENTKEY("Lot No.","Serial No.");
//           IF TempTrkgSpec1.FINDSET THEN
//             REPEAT
//               TempTrkgSpec2.SETRANGE("Lot No.",TempTrkgSpec1."Lot No.");
//               TempTrkgSpec2.SETRANGE("Serial No.",TempTrkgSpec1."Serial No.");
//               IF TempTrkgSpec2.FINDFIRST THEN BEGIN
//                 IF TempTrkgSpec2."Quantity (Base)" * SignFactor2 <> TempTrkgSpec1."Quantity (Base)" * SignFactor1 THEN BEGIN
//                   TempTrkgSpec3 := TempTrkgSpec2;
//                   TempTrkgSpec3.VALIDATE("Quantity (Base)",
//                     (TempTrkgSpec1."Quantity (Base)" * SignFactor1 - TempTrkgSpec2."Quantity (Base)" * SignFactor2));
//                   TempTrkgSpec3."Entry No." := LastEntryNo + 1;
//                   TempTrkgSpec3.INSERT;
//                 END;
//                 TempTrkgSpec2.DELETE;
//               END ELSE BEGIN
//                 TempTrkgSpec3 := TempTrkgSpec1;
//                 TempTrkgSpec3.VALIDATE("Quantity (Base)",TempTrkgSpec1."Quantity (Base)" * SignFactor1);
//                 TempTrkgSpec3."Entry No." := LastEntryNo + 1;
//                 TempTrkgSpec3.INSERT;
//               END;
//               LastEntryNo := TempTrkgSpec3."Entry No.";
//               TempTrkgSpec1.DELETE;
//             UNTIL TempTrkgSpec1.NEXT = 0;

//           TempTrkgSpec2.RESET;

//           IF TempTrkgSpec2.FINDFIRST THEN
//             REPEAT
//               TempTrkgSpec3 := TempTrkgSpec2;
//               TempTrkgSpec3.VALIDATE("Quantity (Base)",-TempTrkgSpec2."Quantity (Base)" * SignFactor2);
//               TempTrkgSpec3."Entry No." := LastEntryNo + 1;
//               TempTrkgSpec3.INSERT;
//               LastEntryNo := TempTrkgSpec3."Entry No.";
//             UNTIL TempTrkgSpec2.NEXT = 0;

//           TempTrkgSpec3.RESET;

//           IF NOT TempTrkgSpec3.ISEMPTY THEN BEGIN
//             IF DialogText <> '' THEN
//               IF NOT CONFIRM(DialogText) THEN BEGIN
//                 MESSAGE(Text006);
//                 EXIT;
//               END;
//             TempSourceSpec."Quantity (Base)" := ReservMgt.GetSourceRecordValue(ReservEntry2,FALSE,1);
//             IF TempTrkgSpec3."Source Type" = DATABASE::"Transfer Line" THEN BEGIN
//               TempTrkgSpec3.MODIFYALL("Location Code",ReservEntry2."Location Code");
//               ItemTrackingForm.SetFormRunMode(4);
//             END ELSE
//               IF FromReservEntry."Source Type" <> ReservEntry2."Source Type" THEN // If different it is drop shipment
//                 ItemTrackingForm.SetFormRunMode(3);
//             ItemTrackingForm.RegisterItemTrackingLines(TempSourceSpec,AvailabilityDate,TempTrkgSpec3);
//           END;
//         END;
//     end;

//     procedure SetRegistering(Registering2: Boolean)
//     begin
//         Registering := Registering2;
//     end;

//     procedure ModifyTemp337SetIfTransfer(var TempReservEntry: Record "337" temporary)
//     var
//         TransLine: Record "5741";
//     begin
//         IF TempReservEntry."Source Type" = DATABASE::"Transfer Line" THEN BEGIN
//           TransLine.GET(TempReservEntry."Source ID",TempReservEntry."Source Ref. No.");
//           TempReservEntry.MODIFYALL("Reservation Status",TempReservEntry."Reservation Status"::Surplus);
//           IF TempReservEntry."Source Subtype" = 0 THEN BEGIN
//             TempReservEntry.MODIFYALL("Location Code",TransLine."Transfer-from Code");
//             TempReservEntry.MODIFYALL("Expected Receipt Date",0D);
//             TempReservEntry.MODIFYALL("Shipment Date",TransLine."Shipment Date");
//           END ELSE BEGIN
//             TempReservEntry.MODIFYALL("Location Code",TransLine."Transfer-to Code");
//             TempReservEntry.MODIFYALL("Expected Receipt Date",TransLine."Receipt Date");
//             TempReservEntry.MODIFYALL("Shipment Date",0D);
//           END;
//         END;
//     end;

//     procedure SynchronizeWhseItemTracking(var TempTrackingSpecification: Record "336" temporary;RegPickNo: Code[20])
//     var
//         SourceSpec: Record "336";
//         ReservEntry: Record "337";
//         RegisteredWhseActLine: Record "5773";
//         WhseShipmentLine: Record "7321";
//         ItemTrackingForm: Page "6510";
//         Qty: Decimal;
//         ZeroQtyToHandle: Boolean;
//     begin
//         IF TempTrackingSpecification.FINDSET THEN
//           REPEAT
//             IF TempTrackingSpecification.Correction THEN BEGIN
//               IF IsPick THEN BEGIN
//                 ZeroQtyToHandle := FALSE;
//                 Qty := -TempTrackingSpecification."Qty. to Handle (Base)";
//                 IF RegPickNo <> '' THEN BEGIN
//                   RegisteredWhseActLine.SETCURRENTKEY(
//                     "Source Type","Source Subtype","Source No.","Source Line No.","Source Subline No.",
//                     "Whse. Document No.","Serial No.","Lot No.","Action Type");
//                   RegisteredWhseActLine.SETRANGE("Activity Type",RegisteredWhseActLine."Activity Type"::Pick);
//                   RegisteredWhseActLine.SETRANGE("Source No.",TempTrackingSpecification."Source ID");
//                   RegisteredWhseActLine.SETRANGE("Source Line No.",TempTrackingSpecification."Source Ref. No.");
//                   RegisteredWhseActLine.SETRANGE("Source Type",TempTrackingSpecification."Source Type");
//                   RegisteredWhseActLine.SETRANGE("Source Subtype",TempTrackingSpecification."Source Subtype");
//                   RegisteredWhseActLine.SETRANGE("Lot No.",TempTrackingSpecification."Lot No.");
//                   RegisteredWhseActLine.SETRANGE("Serial No.",TempTrackingSpecification."Serial No.");
//                   RegisteredWhseActLine.SETFILTER("No.",'<> %1',RegPickNo);

//                   IF NOT RegisteredWhseActLine.FINDFIRST THEN
//                     ZeroQtyToHandle := TRUE
//                   ELSE
//                     IF RegisteredWhseActLine."Whse. Document Type" = RegisteredWhseActLine."Whse. Document Type"::Shipment THEN
//                       IF WhseShipmentLine.GET(RegisteredWhseActLine."Whse. Document No.",
//                            RegisteredWhseActLine."Whse. Document Line No.")
//                       THEN BEGIN
//                         ZeroQtyToHandle := TRUE;
//                         IF WhseShipmentLine."Qty. to Ship (Base)" <> TempTrackingSpecification."Qty. to Handle (Base)" THEN
//                           Qty := -WhseShipmentLine."Qty. to Ship (Base)";
//                       END;
//                 END;

//                 ReservEntry.SETCURRENTKEY(
//                   "Source ID","Source Ref. No.","Source Type","Source Subtype",
//                   "Source Batch Name","Source Prod. Order Line");

//                 ReservEntry.SETRANGE("Source ID",TempTrackingSpecification."Source ID");
//                 ReservEntry.SETRANGE("Source Ref. No.",TempTrackingSpecification."Source Ref. No.");
//                 ReservEntry.SETRANGE("Source Type",TempTrackingSpecification."Source Type");
//                 ReservEntry.SETRANGE("Source Subtype",TempTrackingSpecification."Source Subtype");
//                 ReservEntry.SETRANGE("Source Batch Name",'');
//                 ReservEntry.SETRANGE("Source Prod. Order Line",TempTrackingSpecification."Source Prod. Order Line");
//                 ReservEntry.SETRANGE("Lot No.",TempTrackingSpecification."Lot No.");
//                 ReservEntry.SETRANGE("Serial No.",TempTrackingSpecification."Serial No.");

//                 IF ReservEntry.FINDSET(TRUE) THEN
//                   REPEAT
//                     IF ZeroQtyToHandle THEN BEGIN
//                       ReservEntry."Qty. to Handle (Base)" := 0;
//                       ReservEntry."Qty. to Invoice (Base)" := 0;
//                       ReservEntry.MODIFY;
//                     END;
//                   UNTIL ReservEntry.NEXT = 0;

//                 IF ReservEntry.FINDSET(TRUE) THEN
//                   REPEAT
//                     IF RegPickNo <> '' THEN BEGIN
//                       ReservEntry."Qty. to Handle (Base)" += Qty;
//                       ReservEntry."Qty. to Invoice (Base)" += Qty;
//                     END;
//                     IF ABS(ReservEntry."Qty. to Handle (Base)") > ABS(ReservEntry."Quantity (Base)") THEN BEGIN
//                       Qty := ReservEntry."Qty. to Handle (Base)" - ReservEntry."Quantity (Base)";
//                       ReservEntry."Qty. to Handle (Base)" := ReservEntry."Quantity (Base)";
//                       ReservEntry."Qty. to Invoice (Base)" := ReservEntry."Quantity (Base)";
//                     END ELSE
//                       Qty := 0;
//                     ReservEntry.MODIFY;
//                   UNTIL (ReservEntry.NEXT = 0) OR (Qty = 0);
//               END;
//               TempTrackingSpecification.DELETE;
//             END;
//           UNTIL TempTrackingSpecification.NEXT = 0;

//         IF TempTrackingSpecification.FINDSET THEN
//           REPEAT
//             TempTrackingSpecification.SETRANGE("Source ID",TempTrackingSpecification."Source ID");
//             TempTrackingSpecification.SETRANGE("Source Type",TempTrackingSpecification."Source Type");
//             TempTrackingSpecification.SETRANGE("Source Subtype",TempTrackingSpecification."Source Subtype");
//             TempTrackingSpecification.SETRANGE("Source Prod. Order Line",TempTrackingSpecification."Source Prod. Order Line");
//             TempTrackingSpecification.SETRANGE("Source Ref. No.",TempTrackingSpecification."Source Ref. No.");
//             SourceSpec := TempTrackingSpecification;
//             TempTrackingSpecification.CALCSUMS("Qty. to Handle (Base)");
//             SourceSpec."Quantity (Base)" :=
//               TempTrackingSpecification."Qty. to Handle (Base)" +
//               ABS(ItemTrkgQtyPostedOnSource(SourceSpec));
//             CLEAR(ItemTrackingForm);
//             ItemTrackingForm.SetCalledFromSynchWhseItemTrkg(TRUE);
//             ItemTrackingForm.SetPick(IsPick);
//             ItemTrackingForm.RegisterItemTrackingLines(
//               SourceSpec,
//               SourceSpec."Creation Date",
//               TempTrackingSpecification);
//             TempTrackingSpecification.SETRANGE("Source ID");
//             TempTrackingSpecification.SETRANGE("Source Type");
//             TempTrackingSpecification.SETRANGE("Source Subtype");
//             TempTrackingSpecification.SETRANGE("Source Prod. Order Line");
//             TempTrackingSpecification.SETRANGE("Source Ref. No.");
//           UNTIL TempTrackingSpecification.NEXT = 0;
//     end;

//     local procedure CheckWhseItemTrkg(var TempWhseItemTrkgLine: Record "6550";WhseWkshLine: Record "7326")
//     var
//         SourceItemTrkgLine: Record "337";
//         WhseItemTrackingLine: Record "6550";
//         EntryNo: Integer;
//     begin
//         WITH WhseWkshLine DO BEGIN
//           IF WhseItemTrackingLine.FINDLAST THEN
//             EntryNo := WhseItemTrackingLine."Entry No.";

//           SourceItemTrkgLine.SETCURRENTKEY(
//             "Source ID","Source Ref. No.","Source Type","Source Subtype",
//             "Source Batch Name","Source Prod. Order Line");
//           SourceItemTrkgLine.SETRANGE("Source ID","Source No.");
//           SourceItemTrkgLine.SETRANGE("Source Type","Source Type");
//           SourceItemTrkgLine.SETRANGE("Source Subtype","Source Subtype");
//           SourceItemTrkgLine.SETRANGE("Source Batch Name",'');
//           IF "Source Type" = DATABASE::"Prod. Order Component" THEN BEGIN
//             SourceItemTrkgLine.SETRANGE("Source Ref. No.","Source Subline No.");
//             SourceItemTrkgLine.SETRANGE("Source Prod. Order Line","Source Line No.");
//           END ELSE BEGIN
//             SourceItemTrkgLine.SETRANGE("Source Ref. No.","Source Line No.");
//             SourceItemTrkgLine.SETRANGE("Source Prod. Order Line",0);
//           END;
//           IF SourceItemTrkgLine.FINDSET THEN
//             REPEAT
//               IF (SourceItemTrkgLine."Serial No." <> '') OR
//                  (SourceItemTrkgLine."Lot No." <> '')
//               THEN BEGIN
//                 TempWhseItemTrkgLine.SETCURRENTKEY(
//                   "Source ID","Source Type","Source Subtype","Source Batch Name","Source Prod. Order Line","Source Ref. No.");
//                 TempWhseItemTrkgLine.SETRANGE("Source Type","Source Type");
//                 TempWhseItemTrkgLine.SETRANGE("Source Subtype","Source Subtype");
//                 TempWhseItemTrkgLine.SETRANGE("Source ID","Source No.");
//                 TempWhseItemTrkgLine.SETRANGE("Serial No.",SourceItemTrkgLine."Serial No.");
//                 TempWhseItemTrkgLine.SETRANGE("Lot No.",SourceItemTrkgLine."Lot No.");
//                 IF "Source Type" = DATABASE::"Prod. Order Component" THEN BEGIN
//                   TempWhseItemTrkgLine.SETRANGE("Source Prod. Order Line","Source Line No.");
//                   TempWhseItemTrkgLine.SETRANGE("Source Ref. No.","Source Subline No.");
//                 END ELSE BEGIN
//                   TempWhseItemTrkgLine.SETRANGE("Source Ref. No.","Source Line No.");
//                   TempWhseItemTrkgLine.SETRANGE("Source Prod. Order Line",0);
//                 END;

//                 IF TempWhseItemTrkgLine.FINDFIRST THEN
//                   TempWhseItemTrkgLine.DELETE
//                 ELSE BEGIN
//                   WhseItemTrackingLine.INIT;
//                   EntryNo += 1;
//                   WhseItemTrackingLine."Entry No." := EntryNo;
//                   WhseItemTrackingLine."Item No." := SourceItemTrkgLine."Item No.";
//                   WhseItemTrackingLine."Variant Code" := SourceItemTrkgLine."Variant Code";
//                   WhseItemTrackingLine."Location Code" := SourceItemTrkgLine."Location Code";
//                   WhseItemTrackingLine.Description := SourceItemTrkgLine.Description;
//                   WhseItemTrackingLine."Qty. per Unit of Measure" := SourceItemTrkgLine."Qty. per Unit of Measure";
//                   WhseItemTrackingLine."Source Type" := "Source Type";
//                   WhseItemTrackingLine."Source Subtype" := "Source Subtype";
//                   WhseItemTrackingLine."Source ID" := "Source No.";
//                   IF "Source Type" = DATABASE::"Prod. Order Component" THEN BEGIN
//                     WhseItemTrackingLine."Source Prod. Order Line" := "Source Line No.";
//                     WhseItemTrackingLine."Source Ref. No." := "Source Subline No.";
//                   END ELSE BEGIN
//                     WhseItemTrackingLine."Source Prod. Order Line" := 0;
//                     WhseItemTrackingLine."Source Ref. No." := "Source Line No.";
//                   END;
//                   WhseItemTrackingLine."Serial No." := SourceItemTrkgLine."Serial No.";
//                   WhseItemTrackingLine."Lot No." := SourceItemTrkgLine."Lot No.";
//                   WhseItemTrackingLine."Warranty Date" := SourceItemTrkgLine."Warranty Date";
//                   WhseItemTrackingLine."Expiration Date" := SourceItemTrkgLine."Expiration Date";
//                   WhseItemTrackingLine."Quantity (Base)" := -SourceItemTrkgLine."Quantity (Base)";
//                   IF "Qty. (Base)" = "Qty. to Handle (Base)" THEN
//                     WhseItemTrackingLine."Qty. to Handle (Base)" := WhseItemTrackingLine."Quantity (Base)";
//                   WhseItemTrackingLine."Qty. to Handle" :=
//                     ROUND(WhseItemTrackingLine."Qty. to Handle (Base)" / WhseItemTrackingLine."Qty. per Unit of Measure",0.00001);
//                   WhseItemTrackingLine.INSERT;
//                 END;
//               END;
//             UNTIL SourceItemTrkgLine.NEXT = 0;

//           TempWhseItemTrkgLine.RESET;
//           IF TempWhseItemTrkgLine.FINDSET THEN
//             REPEAT
//               IF ((TempWhseItemTrkgLine."Serial No." <> '') OR
//                   (TempWhseItemTrkgLine."Lot No." <> '')) AND
//                  (TempWhseItemTrkgLine."Quantity Handled (Base)" = 0)
//               THEN BEGIN
//                 WhseItemTrackingLine.GET(TempWhseItemTrkgLine."Entry No.");
//                 WhseItemTrackingLine.DELETE;
//               END;
//             UNTIL TempWhseItemTrkgLine.NEXT = 0;
//         END;
//     end;

//     procedure CopyLotNoInformation(LotNoInfo: Record "6505";NewLotNo: Code[20])
//     var
//         NewLotNoInfo: Record "6505";
//         CommentType: Option " ","Serial No.","Lot No.";
//     begin
//         IF NewLotNoInfo.GET(LotNoInfo."Item No.",LotNoInfo."Variant Code",NewLotNo) THEN BEGIN
//           IF NOT CONFIRM(text008,FALSE,LotNoInfo.TABLECAPTION,LotNoInfo.FIELDCAPTION("Lot No."),NewLotNo) THEN
//             ERROR('');
//           NewLotNoInfo.TRANSFERFIELDS(LotNoInfo,FALSE);
//           NewLotNoInfo.MODIFY;
//         END ELSE BEGIN
//           NewLotNoInfo := LotNoInfo;
//           NewLotNoInfo."Lot No." := NewLotNo;
//           NewLotNoInfo.INSERT;
//         END;

//         CopyInfoComment(
//           CommentType::"Lot No.",
//           LotNoInfo."Item No.",
//           LotNoInfo."Variant Code",
//           LotNoInfo."Lot No.",
//           NewLotNo);
//     end;

//     procedure CopySerialNoInformation(SerialNoInfo: Record "6504";NewSerialNo: Code[20])
//     var
//         NewSerialNoInfo: Record "6504";
//         CommentType: Option " ","Serial No.","Lot No.";
//     begin
//         IF NewSerialNoInfo.GET(SerialNoInfo."Item No.",SerialNoInfo."Variant Code",NewSerialNo) THEN BEGIN
//           IF NOT CONFIRM(text008,FALSE,SerialNoInfo.TABLECAPTION,SerialNoInfo.FIELDCAPTION("Serial No."),NewSerialNo) THEN
//             ERROR('');
//           NewSerialNoInfo.TRANSFERFIELDS(SerialNoInfo,FALSE);
//           NewSerialNoInfo.MODIFY;
//         END ELSE BEGIN
//           NewSerialNoInfo := SerialNoInfo;
//           NewSerialNoInfo."Serial No." := NewSerialNo;
//           NewSerialNoInfo.INSERT;
//         END;

//         CopyInfoComment(
//           CommentType::"Serial No.",
//           SerialNoInfo."Item No.",
//           SerialNoInfo."Variant Code",
//           SerialNoInfo."Serial No.",
//           NewSerialNo);
//     end;

//     procedure CopyInfoComment(InfoType: Option " ","Serial No.","Lot No.";ItemNo: Code[20];VariantCode: Code[10];SerialLotNo: Code[20];NewSerialLotNo: Code[20])
//     var
//         ItemTrackingComment: Record "6506";
//         ItemTrackingComment1: Record "6506";
//     begin
//         IF SerialLotNo = NewSerialLotNo THEN
//           EXIT;

//         ItemTrackingComment1.SETRANGE(Type,InfoType);
//         ItemTrackingComment1.SETRANGE("Item No.",ItemNo);
//         ItemTrackingComment1.SETRANGE("Variant Code",VariantCode);
//         ItemTrackingComment1.SETRANGE("Serial/Lot No.",NewSerialLotNo);

//         IF NOT ItemTrackingComment1.ISEMPTY THEN
//           ItemTrackingComment1.DELETEALL;

//         ItemTrackingComment.SETRANGE(Type,InfoType);
//         ItemTrackingComment.SETRANGE("Item No.",ItemNo);
//         ItemTrackingComment.SETRANGE("Variant Code",VariantCode);
//         ItemTrackingComment.SETRANGE("Serial/Lot No.",SerialLotNo);

//         IF ItemTrackingComment.ISEMPTY THEN
//           EXIT;

//         IF ItemTrackingComment.FINDSET THEN BEGIN
//           REPEAT
//             ItemTrackingComment1 := ItemTrackingComment;
//             ItemTrackingComment1."Serial/Lot No." := NewSerialLotNo;
//             ItemTrackingComment1.INSERT;
//           UNTIL ItemTrackingComment.NEXT = 0
//         END;
//     end;

//     local procedure GetLotSNDataSet(ItemNo: Code[20];Variant: Code[20];LotNo: Code[20];SerialNo: Code[20];var ItemLedgEntry: Record "32") OK: Boolean
//     begin
//         ItemLedgEntry.RESET;
//         ItemLedgEntry.SETCURRENTKEY("Item No.",Open,"Variant Code",Positive,"Expiration Date");

//         ItemLedgEntry.SETRANGE("Item No.",ItemNo);
//         ItemLedgEntry.SETRANGE(Open,TRUE);
//         ItemLedgEntry.SETRANGE("Variant Code",Variant);
//         IF LotNo <> '' THEN
//           ItemLedgEntry.SETRANGE("Lot No.",LotNo)
//         ELSE
//           IF SerialNo <> '' THEN
//             ItemLedgEntry.SETRANGE("Serial No.",SerialNo);
//         ItemLedgEntry.SETRANGE(Positive,TRUE);

//         IF ItemLedgEntry.ISEMPTY THEN BEGIN
//           ItemLedgEntry.SETRANGE(Open);
//           IF ItemLedgEntry.ISEMPTY THEN
//             EXIT;
//         END;

//         ItemLedgEntry.FINDSET;
//         OK := TRUE;
//     end;

//     procedure ExistingExpirationDate(ItemNo: Code[20];Variant: Code[20];LotNo: Code[20];SerialNo: Code[20];TestMultiple: Boolean;var EntriesExist: Boolean) ExpDate: Date
//     var
//         ItemLedgEntry: Record "32";
//         ItemTracingMgt: Codeunit "6520";
//     begin
//         IF NOT GetLotSNDataSet(ItemNo,Variant,LotNo,SerialNo,ItemLedgEntry) THEN BEGIN
//           EntriesExist := FALSE;
//           EXIT;
//         END;

//         EntriesExist := TRUE;

//         ExpDate := ItemLedgEntry."Expiration Date";

//         IF TestMultiple AND ItemTracingMgt.SpecificTracking(ItemNo,SerialNo,LotNo) THEN BEGIN
//           ItemLedgEntry.SETFILTER("Expiration Date",'<>%1',ItemLedgEntry."Expiration Date");
//           IF NOT ItemLedgEntry.ISEMPTY THEN
//             ERROR(Text007,LotNo);
//         END;
//     end;

//     procedure ExistingExpirationDateAndQty(ItemNo: Code[20];Variant: Code[20];LotNo: Code[20];SerialNo: Code[20];var SumOfEntries: Decimal) ExpDate: Date
//     var
//         ItemLedgEntry: Record "32";
//     begin
//         SumOfEntries := 0;
//         IF NOT GetLotSNDataSet(ItemNo,Variant,LotNo,SerialNo,ItemLedgEntry) THEN
//           EXIT;

//         ExpDate := ItemLedgEntry."Expiration Date";
//         IF ItemLedgEntry.FINDSET THEN
//           REPEAT
//             SumOfEntries += ItemLedgEntry."Remaining Quantity";
//           UNTIL ItemLedgEntry.NEXT = 0;
//     end;

//     procedure ExistingWarrantyDate(ItemNo: Code[20];Variant: Code[20];LotNo: Code[20];SerialNo: Code[20];var EntriesExist: Boolean) WarDate: Date
//     var
//         ItemLedgEntry: Record "32";
//     begin
//         IF NOT GetLotSNDataSet(ItemNo,Variant,LotNo,SerialNo,ItemLedgEntry) THEN
//           EXIT;
//         ItemLedgEntry.FINDFIRST;
//         EntriesExist := TRUE;
//         WarDate := ItemLedgEntry."Warranty Date";
//     end;

//     procedure WhseExistingExpirationDate(ItemNo: Code[20];VariantCode: Code[20];Location: Record "14";LotNo: Code[20];SerialNo: Code[20];var EntriesExist: Boolean) ExpDate: Date
//     var
//         WhseEntry: Record "7312";
//         SumOfEntries: Decimal;
//     begin
//         ExpDate := 0D;
//         SumOfEntries := 0;

//         IF Location."Adjustment Bin Code" = '' THEN
//           EXIT;

//         WITH WhseEntry DO BEGIN
//           RESET;
//           SETCURRENTKEY("Item No.","Bin Code","Location Code","Variant Code","Unit of Measure Code","Lot No.","Serial No.");
//           SETRANGE("Item No.",ItemNo);
//           SETRANGE("Bin Code",Location."Adjustment Bin Code");
//           SETRANGE("Location Code",Location.Code);
//           SETRANGE("Variant Code",VariantCode);
//           IF LotNo <> '' THEN
//             SETRANGE("Lot No.",LotNo)
//           ELSE
//             IF SerialNo <> '' THEN
//               SETRANGE("Serial No.",SerialNo);
//           IF ISEMPTY THEN
//             EXIT;

//           IF FINDSET THEN
//             REPEAT
//               SumOfEntries += "Qty. (Base)";
//               IF ("Expiration Date" <> 0D) AND (("Expiration Date" < ExpDate) OR (ExpDate = 0D)) THEN
//                 ExpDate := "Expiration Date";
//             UNTIL NEXT = 0;
//         END;

//         EntriesExist := SumOfEntries < 0;
//     end;

//     procedure WhseExistingWarrantyDate(ItemNo: Code[20];VariantCode: Code[20];Location: Record "14";LotNo: Code[20];SerialNo: Code[20];var EntriesExist: Boolean) WarDate: Date
//     var
//         WhseEntry: Record "7312";
//         SumOfEntries: Decimal;
//     begin
//         WarDate := 0D;
//         SumOfEntries := 0;

//         IF Location."Adjustment Bin Code" = '' THEN
//           EXIT;

//         WITH WhseEntry DO BEGIN
//           RESET;
//           SETCURRENTKEY("Item No.","Bin Code","Location Code","Variant Code","Unit of Measure Code","Lot No.","Serial No.");
//           SETRANGE("Item No.",ItemNo);
//           SETRANGE("Bin Code",Location."Adjustment Bin Code");
//           SETRANGE("Location Code",Location.Code);
//           SETRANGE("Variant Code",VariantCode);
//           IF LotNo <> '' THEN
//             SETRANGE("Lot No.",LotNo)
//           ELSE
//             IF SerialNo <> '' THEN
//               SETRANGE("Serial No.",SerialNo);
//           IF ISEMPTY THEN
//             EXIT;

//           IF FINDSET THEN
//             REPEAT
//               SumOfEntries += "Qty. (Base)";
//               IF ("Warranty Date" <> 0D) AND (("Warranty Date" < WarDate) OR (WarDate = 0D)) THEN
//                 WarDate := "Warranty Date";
//             UNTIL NEXT = 0;
//         END;

//         EntriesExist := SumOfEntries < 0;
//     end;

//     procedure GetWhseExpirationDate(ItemNo: Code[20];VariantCode: Code[20];Location: Record "14";LotNo: Code[20];SerialNo: Code[20];var ExpDate: Date): Boolean
//     var
//         EntriesExist: Boolean;
//     begin
//         ExpDate := ExistingExpirationDate(ItemNo,VariantCode,LotNo,SerialNo,FALSE,EntriesExist);
//         IF EntriesExist THEN
//           EXIT(TRUE);

//         ExpDate := WhseExistingExpirationDate(ItemNo,VariantCode,Location,LotNo,SerialNo,EntriesExist);
//         IF EntriesExist THEN
//           EXIT(TRUE);

//         ExpDate := 0D;
//         EXIT(FALSE);
//     end;

//     procedure GetWhseWarrantyDate(ItemNo: Code[20];VariantCode: Code[20];Location: Record "14";LotNo: Code[20];SerialNo: Code[20];var Wardate: Date): Boolean
//     var
//         EntriesExist: Boolean;
//     begin
//         Wardate := ExistingWarrantyDate(ItemNo,VariantCode,LotNo,SerialNo,EntriesExist);
//         IF EntriesExist THEN
//           EXIT(TRUE);

//         Wardate := WhseExistingWarrantyDate(ItemNo,VariantCode,Location,LotNo,SerialNo,EntriesExist);
//         IF EntriesExist THEN
//           EXIT(TRUE);

//         Wardate := 0D;
//         EXIT(FALSE);
//     end;

//     procedure SumNewLotOnTrackingSpec(var TempTrackingSpecification: Record "336" temporary): Decimal
//     var
//         TempTrackingSpecification2: Record "336";
//         SumLot: Decimal;
//     begin
//         SumLot := 0;
//         TempTrackingSpecification2 := TempTrackingSpecification;
//         TempTrackingSpecification.SETRANGE("New Lot No.",TempTrackingSpecification."New Lot No.");
//         IF TempTrackingSpecification.FINDSET THEN
//           REPEAT
//             SumLot += TempTrackingSpecification."Quantity (Base)";
//           UNTIL TempTrackingSpecification.NEXT = 0;
//         TempTrackingSpecification := TempTrackingSpecification2;
//         EXIT(SumLot);
//     end;

//     procedure TestExpDateOnTrackingSpec(var TempTrackingSpecification: Record "336" temporary)
//     begin
//         IF (TempTrackingSpecification."Lot No." = '') OR (TempTrackingSpecification."Serial No." = '') THEN
//           EXIT;
//         TempTrackingSpecification.SETRANGE("Lot No.",TempTrackingSpecification."Lot No.");
//         TempTrackingSpecification.SETFILTER("Expiration Date",'<>%1',TempTrackingSpecification."Expiration Date");
//         IF NOT TempTrackingSpecification.ISEMPTY THEN
//           ERROR(Text007,TempTrackingSpecification."Lot No.");
//         TempTrackingSpecification.SETRANGE("Lot No.");
//         TempTrackingSpecification.SETRANGE("Expiration Date");
//     end;

//     procedure TestExpDateOnTrackingSpecNew(var TempTrackingSpecification: Record "336" temporary)
//     begin
//         IF TempTrackingSpecification."New Lot No." = '' THEN
//           EXIT;
//         TempTrackingSpecification.SETRANGE("New Lot No.",TempTrackingSpecification."New Lot No.");
//         TempTrackingSpecification.SETFILTER("New Expiration Date",'<>%1',TempTrackingSpecification."New Expiration Date");
//         IF NOT TempTrackingSpecification.ISEMPTY THEN
//           ERROR(Text007,TempTrackingSpecification."New Lot No.");
//         TempTrackingSpecification.SETRANGE("New Lot No.");
//         TempTrackingSpecification.SETRANGE("New Expiration Date");
//     end;

//     procedure ItemTrackingOption(LotNo: Code[20];SerialNo: Code[20]) OptionValue: Integer
//     begin
//         IF LotNo <> '' THEN
//           OptionValue := 1;

//         IF SerialNo <> '' THEN BEGIN
//           IF LotNo <> '' THEN
//             OptionValue := 2
//           ELSE
//             OptionValue := 3;
//         END;
//     end;

//     procedure RetrieveDocumentItemTracking(var TrackingSpecBuffer: Record "336" temporary;SourceID: Code[20];SourceType: Integer;SourceSubType: Option): Integer
//     begin
//         // retrieves Item Tracking for Purchase Header, Sales Header, Sales Shipment Header, Sales Invoice Header

//         TrackingSpecBuffer.DELETEALL;

//         CASE SourceType OF
//           DATABASE::"Purchase Header":
//             RDITPurchase(TrackingSpecBuffer,SourceID,SourceSubType);
//           DATABASE::"Sales Header":
//             RDITSales(TrackingSpecBuffer,SourceID,SourceSubType);
//           DATABASE::"Service Header":
//             RDITService(TrackingSpecBuffer,SourceID,SourceSubType);
//           DATABASE::"Sales Shipment Header":
//             RDITSalesShipment(TrackingSpecBuffer,SourceID);
//           DATABASE::"Sales Invoice Header":
//             RDITSalesInvoice(TrackingSpecBuffer,SourceID);
//           DATABASE::"Service Shipment Header":
//             RDITServiceShipment(TrackingSpecBuffer,SourceID);
//           DATABASE::"Service Invoice Header":
//             RDITServiceInvoice(TrackingSpecBuffer,SourceID);
//           ELSE
//             ERROR(Text009,SourceType);
//         END;

//         TrackingSpecBuffer.RESET;
//         EXIT(TrackingSpecBuffer.COUNT);
//     end;

//     local procedure RDITPurchase(var TempTrackingSpecBuffer: Record "336" temporary;SourceID: Code[20];SourceSubType: Option)
//     var
//         PurchaseLine: Record "39";
//         Item: Record "27";
//         Descr: Text[50];
//     begin
//         PurchaseLine.SETRANGE("Document Type",SourceSubType);
//         PurchaseLine.SETRANGE("Document No.",SourceID);
//         IF NOT PurchaseLine.ISEMPTY THEN BEGIN
//           PurchaseLine.FINDSET;
//           REPEAT
//             IF (PurchaseLine.Type = PurchaseLine.Type::Item) AND
//                (PurchaseLine."Quantity (Base)" <> 0)
//             THEN BEGIN
//               IF Item.GET(PurchaseLine."No.") THEN
//                 Descr := Item.Description;
//               FindReservEntries(TempTrackingSpecBuffer,DATABASE::"Purchase Line",PurchaseLine."Document Type",
//                 PurchaseLine."Document No.",'',0,PurchaseLine."Line No.",Descr);
//               FindTrackingEntries(TempTrackingSpecBuffer,DATABASE::"Purchase Line",PurchaseLine."Document Type",
//                 PurchaseLine."Document No.",'',0,PurchaseLine."Line No.",Descr);
//             END;
//           UNTIL PurchaseLine.NEXT = 0;
//         END;
//     end;

//     local procedure RDITSales(var TempTrackingSpecBuffer: Record "336" temporary;SourceID: Code[20];SourceSubType: Option)
//     var
//         SalesLine: Record "37";
//         Item: Record "27";
//         Descr: Text[50];
//     begin
//         SalesLine.SETRANGE("Document Type",SourceSubType);
//         SalesLine.SETRANGE("Document No.",SourceID);
//         IF NOT SalesLine.ISEMPTY THEN BEGIN
//           SalesLine.FINDSET;
//           REPEAT
//             IF (SalesLine.Type = SalesLine.Type::Item) AND
//                (SalesLine."No." <> '') AND
//                (SalesLine."Quantity (Base)" <> 0)
//             THEN BEGIN
//               IF Item.GET(SalesLine."No.") THEN
//                 Descr := Item.Description;
//               FindReservEntries(TempTrackingSpecBuffer,DATABASE::"Sales Line",SalesLine."Document Type",
//                 SalesLine."Document No.",'',0,SalesLine."Line No.",Descr);
//               FindTrackingEntries(TempTrackingSpecBuffer,DATABASE::"Sales Line",SalesLine."Document Type",
//                 SalesLine."Document No.",'',0,SalesLine."Line No.",Descr);
//             END;
//           UNTIL SalesLine.NEXT = 0;
//         END;
//     end;

//     local procedure RDITService(var TempTrackingSpecBuffer: Record "336" temporary;SourceID: Code[20];SourceSubType: Option)
//     var
//         ServLine: Record "5902";
//         Item: Record "27";
//         Descr: Text[50];
//     begin
//         ServLine.SETRANGE("Document Type",SourceSubType);
//         ServLine.SETRANGE("Document No.",SourceID);
//         IF NOT ServLine.ISEMPTY THEN BEGIN
//           ServLine.FINDSET;
//           REPEAT
//             IF (ServLine.Type = ServLine.Type::Item) AND
//                (ServLine."No." <> '') AND
//                (ServLine."Quantity (Base)" <> 0)
//             THEN BEGIN
//               IF Item.GET(ServLine."No.") THEN
//                 Descr := Item.Description;
//               FindReservEntries(TempTrackingSpecBuffer,DATABASE::"Service Line",ServLine."Document Type",
//                 ServLine."Document No.",'',0,ServLine."Line No.",Descr);
//               FindTrackingEntries(TempTrackingSpecBuffer,DATABASE::"Service Line",ServLine."Document Type",
//                 ServLine."Document No.",'',0,ServLine."Line No.",Descr);
//             END;
//           UNTIL ServLine.NEXT = 0;
//         END;
//     end;

//     local procedure RDITSalesShipment(var TempTrackingSpecBuffer: Record "336" temporary;SourceID: Code[20])
//     var
//         SalesShipmentLine: Record "111";
//         Item: Record "27";
//         PostedAsmHeader: Record "910";
//         PostedAsmLine: Record "911";
//         Descr: Text[50];
//     begin
//         SalesShipmentLine.SETRANGE("Document No.",SourceID);
//         IF NOT SalesShipmentLine.ISEMPTY THEN BEGIN
//           SalesShipmentLine.FINDSET;
//           REPEAT
//             IF (SalesShipmentLine.Type = SalesShipmentLine.Type::Item) AND
//                (SalesShipmentLine."No." <> '') AND
//                (SalesShipmentLine."Quantity (Base)" <> 0)
//             THEN BEGIN
//               IF Item.GET(SalesShipmentLine."No.") THEN
//                 Descr := Item.Description;
//               FindItemEntries(TempTrackingSpecBuffer,DATABASE::"Sales Shipment Line",
//                 0,SalesShipmentLine."Document No.",'',0,SalesShipmentLine."Line No.",Descr);
//               IF RetrieveAsmItemTracking THEN
//                 IF SalesShipmentLine.AsmToShipmentExists(PostedAsmHeader) THEN BEGIN
//                   PostedAsmLine.SETRANGE("Document No.",PostedAsmHeader."No.");
//                   IF PostedAsmLine.FINDSET THEN
//                     REPEAT
//                       Descr := PostedAsmLine.Description;
//                       FindItemEntries(TempTrackingSpecBuffer,DATABASE::"Posted Assembly Line",
//                         0,PostedAsmLine."Document No.",'',0,PostedAsmLine."Line No.",Descr);
//                     UNTIL PostedAsmLine.NEXT = 0;
//                 END;
//             END;
//           UNTIL SalesShipmentLine.NEXT = 0;
//         END;
//     end;

//     local procedure RDITSalesInvoice(var TempTrackingSpecBuffer: Record "336" temporary;SourceID: Code[20])
//     var
//         SalesInvoiceLine: Record "113";
//         Item: Record "27";
//         Descr: Text[50];
//     begin
//         SalesInvoiceLine.SETRANGE("Document No.",SourceID);
//         IF NOT SalesInvoiceLine.ISEMPTY THEN BEGIN
//           SalesInvoiceLine.FINDSET;
//           REPEAT
//             IF (SalesInvoiceLine.Type = SalesInvoiceLine.Type::Item) AND
//                (SalesInvoiceLine."No." <> '') AND
//                (SalesInvoiceLine."Quantity (Base)" <> 0)
//             THEN BEGIN
//               IF Item.GET(SalesInvoiceLine."No.") THEN
//                 Descr := Item.Description;
//               FindValueEntries(TempTrackingSpecBuffer,DATABASE::"Sales Invoice Line",
//                 0,SalesInvoiceLine."Document No.",'',0,SalesInvoiceLine."Line No.",Descr);
//             END;
//           UNTIL SalesInvoiceLine.NEXT = 0;
//         END;
//     end;

//     local procedure RDITServiceShipment(var TempTrackingSpecBuffer: Record "336" temporary;SourceID: Code[20])
//     var
//         ServShptLine: Record "5991";
//         Item: Record "27";
//         Descr: Text[50];
//     begin
//         ServShptLine.SETRANGE("Document No.",SourceID);
//         IF NOT ServShptLine.ISEMPTY THEN BEGIN
//           ServShptLine.FINDSET;
//           REPEAT
//             IF (ServShptLine.Type = ServShptLine.Type::Item) AND
//                (ServShptLine."No." <> '') AND
//                (ServShptLine."Quantity (Base)" <> 0)
//             THEN BEGIN
//               IF Item.GET(ServShptLine."No.") THEN
//                 Descr := Item.Description;
//               FindItemEntries(TempTrackingSpecBuffer,DATABASE::"Service Shipment Line",
//                 0,ServShptLine."Document No.",'',0,ServShptLine."Line No.",Descr);
//             END;
//           UNTIL ServShptLine.NEXT = 0;
//         END;
//     end;

//     local procedure RDITServiceInvoice(var TempTrackingSpecBuffer: Record "336" temporary;SourceID: Code[20])
//     var
//         ServInvLine: Record "5993";
//         Item: Record "27";
//         Descr: Text[50];
//     begin
//         ServInvLine.SETRANGE("Document No.",SourceID);
//         IF NOT ServInvLine.ISEMPTY THEN BEGIN
//           ServInvLine.FINDSET;
//           REPEAT
//             IF (ServInvLine.Type = ServInvLine.Type::Item) AND
//                (ServInvLine."No." <> '') AND
//                (ServInvLine."Quantity (Base)" <> 0)
//             THEN BEGIN
//               IF Item.GET(ServInvLine."No.") THEN
//                 Descr := Item.Description;
//               FindValueEntries(TempTrackingSpecBuffer,DATABASE::"Service Invoice Line",
//                 0,ServInvLine."Document No.",'',0,ServInvLine."Line No.",Descr);
//             END;
//           UNTIL ServInvLine.NEXT = 0;
//         END;
//     end;

//     procedure FindReservEntries(var TempTrackingSpecBuffer: Record "336" temporary;Type: Integer;Subtype: Integer;ID: Code[20];BatchName: Code[10];ProdOrderLine: Integer;RefNo: Integer;Description: Text[50])
//     var
//         ReservEntry: Record "337";
//     begin
//         // finds Item Tracking for Quote, Order, Invoice, Credit Memo, Return Order

//         FilterReservEntries(ReservEntry,Type,Subtype,ID,BatchName,ProdOrderLine,RefNo);
//         IF ReservEntry.FINDSET THEN
//           REPEAT
//             IF (ReservEntry."Lot No." <> '') OR (ReservEntry."Serial No." <> '') THEN
//               FillTrackingSpecBuffer(TempTrackingSpecBuffer,Type,Subtype,ID,BatchName,
//                 ProdOrderLine,RefNo,Description,ReservEntry."Item No.",ReservEntry."Lot No.",
//                 ReservEntry."Serial No.",ReservEntry."Quantity (Base)",ReservEntry.Correction);
//           UNTIL ReservEntry.NEXT = 0;
//     end;

//     procedure FindTrackingEntries(var TempTrackingSpecBuffer: Record "336" temporary;Type: Integer;Subtype: Integer;ID: Code[20];BatchName: Code[10];ProdOrderLine: Integer;RefNo: Integer;Description: Text[50])
//     var
//         TrackingSpec: Record "336";
//     begin
//         // finds Item Tracking for Quote, Order, Invoice, Credit Memo, Return Order when shipped/received

//         FilterTrackingEntries(TrackingSpec,Type,Subtype,ID,BatchName,ProdOrderLine,RefNo);
//         IF TrackingSpec.FINDSET THEN
//           REPEAT
//             IF (TrackingSpec."Lot No." <> '') OR (TrackingSpec."Serial No." <> '') THEN
//               FillTrackingSpecBuffer(TempTrackingSpecBuffer,Type,Subtype,ID,BatchName,
//                 ProdOrderLine,RefNo,Description,TrackingSpec."Item No.",TrackingSpec."Lot No.",
//                 TrackingSpec."Serial No.",TrackingSpec."Quantity (Base)",TrackingSpec.Correction);
//           UNTIL TrackingSpec.NEXT = 0;
//     end;

//     procedure FindItemEntries(var TempTrackingSpecBuffer: Record "336" temporary;Type: Integer;Subtype: Integer;ID: Code[20];BatchName: Code[10];ProdOrderLine: Integer;RefNo: Integer;Description: Text[50])
//     var
//         TempItemLedgEntry: Record "32" temporary;
//     begin
//         // finds Item Tracking for Posted Shipments/Receipts

//         RetrieveILEFromShptRcpt(TempItemLedgEntry,Type,Subtype,ID,BatchName,ProdOrderLine,RefNo);
//         FillTrackingSpecBufferFromILE(
//           TempItemLedgEntry,TempTrackingSpecBuffer,Type,Subtype,ID,BatchName,ProdOrderLine,RefNo,Description);
//     end;

//     procedure FindValueEntries(var TempTrackingSpecBuffer: Record "336" temporary;Type: Integer;Subtype: Integer;ID: Code[20];BatchName: Code[10];ProdOrderLine: Integer;RefNo: Integer;Description: Text[50])
//     var
//         TempItemLedgEntry: Record "32" temporary;
//         InvoiceRowID: Text[250];
//     begin
//         // finds Item Tracking for Posted Invoices

//         InvoiceRowID := ComposeRowID(Type,Subtype,ID,BatchName,ProdOrderLine,RefNo);
//         RetrieveILEFromPostedInv(TempItemLedgEntry,InvoiceRowID);
//         FillTrackingSpecBufferFromILE(
//           TempItemLedgEntry,TempTrackingSpecBuffer,Type,Subtype,ID,BatchName,ProdOrderLine,RefNo,Description);
//     end;

//     local procedure ItemTrackingExistsInBuffer(var TempTrackingSpecBuffer: Record "336" temporary;Type: Integer;Subtype: Integer;ID: Code[20];BatchName: Code[10];ProdOrderLine: Integer;RefNo: Integer;LN: Code[20];SN: Code[20]): Boolean
//     begin
//         // searches after existing record in TempTrackingSpecBuffer

//         TempTrackingSpecBuffer.SETCURRENTKEY("Source ID","Source Type","Source Subtype",
//           "Source Batch Name","Source Prod. Order Line","Source Ref. No.");
//         TempTrackingSpecBuffer.SETRANGE("Source ID",ID);
//         TempTrackingSpecBuffer.SETRANGE("Source Type",Type);
//         TempTrackingSpecBuffer.SETRANGE("Source Subtype",Subtype);
//         TempTrackingSpecBuffer.SETRANGE("Source Batch Name",BatchName);
//         TempTrackingSpecBuffer.SETRANGE("Source Prod. Order Line",ProdOrderLine);
//         TempTrackingSpecBuffer.SETRANGE("Source Ref. No.",RefNo);
//         TempTrackingSpecBuffer.SETRANGE("Serial No.",SN);
//         TempTrackingSpecBuffer.SETRANGE("Lot No.",LN);

//         IF NOT TempTrackingSpecBuffer.ISEMPTY THEN BEGIN
//           TempTrackingSpecBuffer.FINDFIRST;
//           EXIT(TRUE);
//         END;
//         EXIT(FALSE);
//     end;

//     local procedure InitTrackingSpecBuffer(var TempTrackingSpecBuffer: Record "336" temporary;EntryNo: Integer;Type: Integer;Subtype: Integer;ID: Code[20];BatchName: Code[10];ProdOrderLine: Integer;RefNo: Integer;Description: Text[50];ItemNo: Code[20];LN: Code[20];SN: Code[20];Correction: Boolean)
//     begin
//         // initializes a new record for TempTrackingSpecBuffer

//         TempTrackingSpecBuffer.INIT;
//         TempTrackingSpecBuffer."Source Type" := Type;
//         TempTrackingSpecBuffer."Entry No." := EntryNo;
//         TempTrackingSpecBuffer."Item No." := ItemNo;
//         TempTrackingSpecBuffer.Description := Description;
//         TempTrackingSpecBuffer."Source Subtype" := Subtype;
//         TempTrackingSpecBuffer."Source ID" := ID;
//         TempTrackingSpecBuffer."Source Batch Name" := BatchName;
//         TempTrackingSpecBuffer."Source Prod. Order Line" := ProdOrderLine;
//         TempTrackingSpecBuffer."Source Ref. No." := RefNo;
//         TempTrackingSpecBuffer."Lot No." := LN;
//         TempTrackingSpecBuffer."Serial No." := SN;
//         TempTrackingSpecBuffer.Correction := Correction;
//     end;

//     local procedure FillTrackingSpecBuffer(var TempTrackingSpecBuffer: Record "336" temporary;Type: Integer;Subtype: Integer;ID: Code[20];BatchName: Code[10];ProdOrderLine: Integer;RefNo: Integer;Description: Text[50];ItemNo: Code[20];LN: Code[20];SN: Code[20];Qty: Decimal;Correction: Boolean)
//     var
//         LastEntryNo: Integer;
//     begin
//         // creates or sums up a record in TempTrackingSpecBuffer

//         TempTrackingSpecBuffer.RESET;
//         IF TempTrackingSpecBuffer.FINDLAST THEN
//           LastEntryNo := TempTrackingSpecBuffer."Entry No.";

//         IF ItemTrackingExistsInBuffer(TempTrackingSpecBuffer,Type,Subtype,ID,BatchName,ProdOrderLine,RefNo,LN,SN) THEN BEGIN
//           TempTrackingSpecBuffer."Quantity (Base)" += ABS(Qty);                      // Sum up Qty
//           TempTrackingSpecBuffer.MODIFY;
//         END
//         ELSE BEGIN
//           LastEntryNo += 1;
//           InitTrackingSpecBuffer(TempTrackingSpecBuffer,LastEntryNo,Type,Subtype,ID,BatchName,
//             ProdOrderLine,RefNo,Description,ItemNo,LN,SN,Correction);
//           TempTrackingSpecBuffer."Quantity (Base)" := ABS(Qty);
//           TempTrackingSpecBuffer.INSERT;
//         END;
//     end;

//     local procedure FillTrackingSpecBufferFromILE(var TempItemLedgEntry: Record "32" temporary;var TempTrackingSpecBuffer: Record "336" temporary;Type: Integer;Subtype: Integer;ID: Code[20];BatchName: Code[10];ProdOrderLine: Integer;RefNo: Integer;Description: Text[50])
//     begin
//         // creates a new record in TempTrackingSpecBuffer (used for Posted Shipments/Receipts/Invoices)

//         IF TempItemLedgEntry.FINDSET THEN
//           REPEAT
//             IF (TempItemLedgEntry."Lot No." <> '') OR (TempItemLedgEntry."Serial No." <> '') THEN
//               FillTrackingSpecBuffer(TempTrackingSpecBuffer,Type,Subtype,ID,BatchName,
//                 ProdOrderLine,RefNo,Description,TempItemLedgEntry."Item No.",TempItemLedgEntry."Lot No.",
//                 TempItemLedgEntry."Serial No.",TempItemLedgEntry.Quantity,TempItemLedgEntry.Correction);
//           UNTIL TempItemLedgEntry.NEXT = 0;
//     end;

//     local procedure FilterReservEntries(var ReservEntry: Record "337";Type: Integer;Subtype: Integer;ID: Code[20];BatchName: Code[10];ProdOrderLine: Integer;RefNo: Integer)
//     begin
//         // retrieves a data set of Reservation Entries

//         ReservEntry.SETCURRENTKEY("Source ID","Source Ref. No.","Source Type","Source Subtype","Source Batch Name",
//           "Source Prod. Order Line","Reservation Status","Shipment Date","Expected Receipt Date");
//         ReservEntry.SETRANGE("Source ID",ID);
//         ReservEntry.SETRANGE("Source Ref. No.",RefNo);
//         ReservEntry.SETRANGE("Source Type",Type);
//         ReservEntry.SETRANGE("Source Subtype",Subtype);
//         ReservEntry.SETRANGE("Source Batch Name",BatchName);
//         ReservEntry.SETRANGE("Source Prod. Order Line",ProdOrderLine);
//     end;

//     local procedure FilterTrackingEntries(var TrackingSpec: Record "336";Type: Integer;Subtype: Integer;ID: Code[20];BatchName: Code[10];ProdOrderLine: Integer;RefNo: Integer)
//     begin
//         // retrieves a data set of Tracking Specification Entries

//         TrackingSpec.SETCURRENTKEY("Source ID","Source Type","Source Subtype","Source Batch Name",
//           "Source Prod. Order Line","Source Ref. No.");
//         TrackingSpec.SETRANGE("Source ID",ID);
//         TrackingSpec.SETRANGE("Source Type",Type);
//         TrackingSpec.SETRANGE("Source Subtype",Subtype);
//         TrackingSpec.SETRANGE("Source Batch Name",BatchName);
//         TrackingSpec.SETRANGE("Source Prod. Order Line",ProdOrderLine);
//         TrackingSpec.SETRANGE("Source Ref. No.",RefNo);
//     end;

//     local procedure RetrieveILEFromShptRcpt(var TempItemLedgEntry: Record "32" temporary;Type: Integer;Subtype: Integer;ID: Code[20];BatchName: Code[10];ProdOrderLine: Integer;RefNo: Integer)
//     var
//         ItemEntryRelation: Record "6507";
//         ItemLedgEntry: Record "32";
//         SignFactor: Integer;
//     begin
//         // retrieves a data set of Item Ledger Entries (Posted Shipments/Receipts)

//         ItemEntryRelation.SETCURRENTKEY("Source ID","Source Type");
//         ItemEntryRelation.SETRANGE("Source Type",Type);
//         ItemEntryRelation.SETRANGE("Source Subtype",Subtype);
//         ItemEntryRelation.SETRANGE("Source ID",ID);
//         ItemEntryRelation.SETRANGE("Source Batch Name",BatchName);
//         ItemEntryRelation.SETRANGE("Source Prod. Order Line",ProdOrderLine);
//         ItemEntryRelation.SETRANGE("Source Ref. No.",RefNo);
//         IF ItemEntryRelation.FINDSET THEN BEGIN
//           SignFactor := TableSignFactor(Type);
//           REPEAT
//             ItemLedgEntry.GET(ItemEntryRelation."Item Entry No.");
//             TempItemLedgEntry := ItemLedgEntry;
//             AddTempRecordToSet(TempItemLedgEntry,SignFactor);
//           UNTIL ItemEntryRelation.NEXT = 0;
//         END;
//     end;

//     local procedure RetrieveILEFromPostedInv(var TempItemLedgEntry: Record "32" temporary;InvoiceRowID: Text[250])
//     var
//         ValueEntryRelation: Record "6508";
//         ValueEntry: Record "5802";
//         ItemLedgEntry: Record "32";
//         SignFactor: Integer;
//     begin
//         // retrieves a data set of Item Ledger Entries (Posted Invoices)

//         ValueEntryRelation.SETCURRENTKEY("Source RowId");
//         ValueEntryRelation.SETRANGE("Source RowId",InvoiceRowID);
//         IF ValueEntryRelation.FIND('-') THEN BEGIN
//           SignFactor := TableSignFactor2(InvoiceRowID);
//           REPEAT
//             ValueEntry.GET(ValueEntryRelation."Value Entry No.");
//             ItemLedgEntry.GET(ValueEntry."Item Ledger Entry No.");
//             TempItemLedgEntry := ItemLedgEntry;
//             TempItemLedgEntry.Quantity := ValueEntry."Invoiced Quantity";
//             IF TempItemLedgEntry."Entry Type" IN [TempItemLedgEntry."Entry Type"::Purchase,TempItemLedgEntry."Entry Type"::Sale] THEN
//               IF TempItemLedgEntry.Quantity <> 0 THEN
//                 AddTempRecordToSet(TempItemLedgEntry,SignFactor);
//           UNTIL ValueEntryRelation.NEXT = 0;
//         END;
//     end;

//     procedure CopyItemLedgEntryTrkgToSalesLn(var ItemLedgEntryBuf: Record "32" temporary;ToSalesLine: Record "37";FillExactCostRevLink: Boolean;var MissingExCostRevLink: Boolean;FromPricesInclVAT: Boolean;ToPricesInclVAT: Boolean;FromShptOrRcpt: Boolean)
//     var
//         TempReservEntry: Record "337" temporary;
//         ReservEntry: Record "337";
//         CopyDocMgt: Codeunit "6620";
//         ReservMgt: Codeunit "99000845";
//         ReservEngineMgt: Codeunit "99000831";
//         TotalCostLCY: Decimal;
//         ItemLedgEntryQty: Decimal;
//         SignFactor: Integer;
//         LinkThisEntry: Boolean;
//         EntriesExist: Boolean;
//     begin
//         IF (ToSalesLine.Type <> ToSalesLine.Type::Item) OR
//            (ToSalesLine.Quantity = 0)
//         THEN
//           EXIT;

//         IF FillExactCostRevLink THEN
//           FillExactCostRevLink := NOT ToSalesLine.IsShipment;

//         WITH ItemLedgEntryBuf DO
//           IF FINDSET THEN BEGIN
//             IF Quantity / ToSalesLine.Quantity < 0 THEN
//               SignFactor := 1
//             ELSE
//               SignFactor := -1;
//             IF ToSalesLine."Document Type" IN
//                [ToSalesLine."Document Type"::"Return Order",ToSalesLine."Document Type"::"Credit Memo"]
//             THEN
//               SignFactor := -SignFactor;

//             ReservMgt.SetSalesLine(ToSalesLine);
//             ReservMgt.DeleteReservEntries(TRUE,0);

//             REPEAT
//               LinkThisEntry := "Entry No." > 0;
//               ReservEntry.INIT;
//               ReservEntry."Item No." := "Item No.";
//               ReservEntry."Location Code" := "Location Code";
//               ReservEntry."Serial No." := "Serial No.";
//               ReservEntry."Qty. per Unit of Measure" := "Qty. per Unit of Measure";
//               ReservEntry."Lot No." := "Lot No.";
//               ReservEntry."Variant Code" := "Variant Code";
//               ReservEntry."Source Type" := DATABASE::"Sales Line";
//               ReservEntry."Source Subtype" := ToSalesLine."Document Type";
//               ReservEntry."Source ID" := ToSalesLine."Document No.";
//               ReservEntry."Source Ref. No." := ToSalesLine."Line No.";
//               IF ToSalesLine."Document Type" IN
//                  [ToSalesLine."Document Type"::Order,ToSalesLine."Document Type"::"Return Order"]
//               THEN
//                 ReservEntry."Reservation Status" := ReservEntry."Reservation Status"::Surplus
//               ELSE
//                 ReservEntry."Reservation Status" := ReservEntry."Reservation Status"::Prospect;
//               ReservEntry."Quantity Invoiced (Base)" := 0;
//               IF FillExactCostRevLink THEN
//                 ReservEntry.VALIDATE("Quantity (Base)","Shipped Qty. Not Returned" * SignFactor)
//               ELSE
//                 ReservEntry.VALIDATE("Quantity (Base)",Quantity * SignFactor);
//               ReservEntry.Positive := (ReservEntry."Quantity (Base)" > 0);
//               ReservEntry."Entry No." := 0;
//               IF ReservEntry.Positive THEN BEGIN
//                 ReservEntry."Warranty Date" := "Warranty Date";
//                 ReservEntry."Expiration Date" :=
//                   ExistingExpirationDate("Item No.","Variant Code","Lot No.","Serial No.",FALSE,EntriesExist);
//                 ReservEntry."Expected Receipt Date" := ToSalesLine."Shipment Date"
//               END ELSE
//                 ReservEntry."Shipment Date" := ToSalesLine."Shipment Date";

//               IF FillExactCostRevLink THEN BEGIN
//                 IF LinkThisEntry THEN BEGIN
//                   ReservEntry."Appl.-from Item Entry" := "Entry No.";
//                   IF NOT MissingExCostRevLink THEN BEGIN
//                     CALCFIELDS("Cost Amount (Actual)","Cost Amount (Expected)");
//                     TotalCostLCY :=
//                       TotalCostLCY + "Cost Amount (Expected)" + "Cost Amount (Actual)";
//                     ItemLedgEntryQty := ItemLedgEntryQty - Quantity;
//                   END;
//                 END ELSE
//                   MissingExCostRevLink := TRUE;
//               END;

//               ReservEntry.Description := ToSalesLine.Description;
//               ReservEntry."Creation Date" := WORKDATE;
//               ReservEntry."Created By" := USERID;
//               ReservEntry.UpdateItemTracking;
//               ReservEntry.INSERT;
//               TempReservEntry := ReservEntry;
//               TempReservEntry.INSERT;
//             UNTIL NEXT = 0;
//             ReservEngineMgt.UpdateOrderTracking(TempReservEntry);

//             IF FillExactCostRevLink AND NOT MissingExCostRevLink THEN BEGIN
//               ToSalesLine.VALIDATE(
//                 "Unit Cost (LCY)",
//                 ABS(TotalCostLCY / ItemLedgEntryQty) * ToSalesLine."Qty. per Unit of Measure");
//               IF NOT FromShptOrRcpt THEN
//                 CopyDocMgt.CalculateRevSalesLineAmount(
//                   ToSalesLine,ItemLedgEntryQty,FromPricesInclVAT,ToPricesInclVAT);

//               ToSalesLine.MODIFY;
//             END;
//           END;
//     end;

//     procedure CopyItemLedgEntryTrkgToPurchLn(var ItemLedgEntryBuf: Record "32";ToPurchLine: Record "39";FillExactCostRevLink: Boolean;var MissingExCostRevLink: Boolean;FromPricesInclVAT: Boolean;ToPricesInclVAT: Boolean;FromShptOrRcpt: Boolean)
//     var
//         ReservEntry: Record "337";
//         ItemLedgEntry: Record "32";
//         CopyDocMgt: Codeunit "6620";
//         ReservMgt: Codeunit "99000845";
//         TotalCostLCY: Decimal;
//         ItemLedgEntryQty: Decimal;
//         SignFactor: Integer;
//         LinkThisEntry: Boolean;
//         EntriesExist: Boolean;
//     begin
//         IF (ToPurchLine.Type <> ToPurchLine.Type::Item) OR
//            (ToPurchLine.Quantity = 0)
//         THEN
//           EXIT;

//         IF FillExactCostRevLink THEN
//           FillExactCostRevLink := ToPurchLine.Signed(ToPurchLine."Quantity (Base)") < 0;

//         IF FillExactCostRevLink THEN
//           IF ToPurchLine."Document Type" IN
//              [ToPurchLine."Document Type"::Invoice,ToPurchLine."Document Type"::"Credit Memo"]
//           THEN
//             FillExactCostRevLink := FALSE;

//         WITH ItemLedgEntryBuf DO
//           IF FINDSET THEN BEGIN
//             IF Quantity / ToPurchLine.Quantity > 0 THEN
//               SignFactor := 1
//             ELSE
//               SignFactor := -1;
//             IF ToPurchLine."Document Type" IN
//                [ToPurchLine."Document Type"::"Return Order",ToPurchLine."Document Type"::"Credit Memo"]
//             THEN
//               SignFactor := -SignFactor;

//             IF ToPurchLine."Expected Receipt Date" = 0D THEN
//               ToPurchLine."Expected Receipt Date" := WORKDATE;
//             ToPurchLine."Outstanding Qty. (Base)" := ToPurchLine."Quantity (Base)";
//             ReservMgt.SetPurchLine(ToPurchLine);
//             ReservMgt.DeleteReservEntries(TRUE,0);

//             REPEAT
//               LinkThisEntry := "Entry No." > 0;
//               ReservEntry.INIT;
//               ReservEntry."Item No." := "Item No.";
//               ReservEntry."Location Code" := "Location Code";
//               ReservEntry."Serial No." := "Serial No.";
//               ReservEntry."Qty. per Unit of Measure" := "Qty. per Unit of Measure";
//               ReservEntry."Lot No." := "Lot No.";
//               ReservEntry."Variant Code" := "Variant Code";
//               ReservEntry."Source Type" := DATABASE::"Purchase Line";
//               ReservEntry."Source Subtype" := ToPurchLine."Document Type";
//               ReservEntry."Source ID" := ToPurchLine."Document No.";
//               ReservEntry."Source Ref. No." := ToPurchLine."Line No.";
//               IF ToPurchLine."Document Type" IN
//                  [ToPurchLine."Document Type"::Order,ToPurchLine."Document Type"::"Return Order"]
//               THEN
//                 ReservEntry."Reservation Status" := ReservEntry."Reservation Status"::Surplus
//               ELSE
//                 ReservEntry."Reservation Status" := ReservEntry."Reservation Status"::Prospect;
//               ReservEntry."Quantity Invoiced (Base)" := 0;
//               IF LinkThisEntry AND ("Lot No." = '') THEN
//                 // The check for Lot No = '' is to avoid changing the remaining quantity for partly sold Lots
//                 // because this will cause undefined quantities in the item tracking
//                 "Remaining Quantity" := Quantity;
//               IF ToPurchLine."Job No." = '' THEN
//                 ReservEntry.VALIDATE("Quantity (Base)","Remaining Quantity" * SignFactor)
//               ELSE BEGIN
//                 ItemLedgEntry.GET("Entry No.");
//                 ReservEntry.VALIDATE("Quantity (Base)",ABS(ItemLedgEntry.Quantity) * SignFactor);
//               END;
//               ReservEntry.Positive := (ReservEntry."Quantity (Base)" > 0);
//               ReservEntry."Entry No." := 0;
//               IF ReservEntry.Positive THEN BEGIN
//                 ReservEntry."Warranty Date" := "Warranty Date";
//                 ReservEntry."Expiration Date" :=
//                   ExistingExpirationDate("Item No.","Variant Code","Lot No.","Serial No.",FALSE,EntriesExist);
//                 ReservEntry."Expected Receipt Date" := ToPurchLine."Expected Receipt Date"
//               END ELSE
//                 ReservEntry."Shipment Date" := ToPurchLine."Expected Receipt Date";

//               IF FillExactCostRevLink THEN BEGIN
//                 IF LinkThisEntry THEN BEGIN
//                   ReservEntry."Appl.-to Item Entry" := "Entry No.";
//                   IF NOT MissingExCostRevLink THEN BEGIN
//                     CALCFIELDS("Cost Amount (Actual)","Cost Amount (Expected)");
//                     TotalCostLCY :=
//                       TotalCostLCY + "Cost Amount (Expected)" + "Cost Amount (Actual)";
//                     ItemLedgEntryQty := ItemLedgEntryQty - Quantity;
//                   END;
//                 END ELSE
//                   MissingExCostRevLink := TRUE;
//               END;

//               ReservEntry.Description := ToPurchLine.Description;
//               ReservEntry."Creation Date" := WORKDATE;
//               ReservEntry."Created By" := USERID;
//               ReservEntry.UpdateItemTracking;
//               ReservEntry.INSERT;

//               IF FillExactCostRevLink AND NOT LinkThisEntry THEN
//                 MissingExCostRevLink := TRUE;
//             UNTIL NEXT = 0;

//             IF FillExactCostRevLink AND NOT MissingExCostRevLink THEN BEGIN
//               ToPurchLine.VALIDATE(
//                 "Unit Cost (LCY)",
//                 ABS(TotalCostLCY / ItemLedgEntryQty) * ToPurchLine."Qty. per Unit of Measure");
//               IF NOT FromShptOrRcpt THEN
//                 CopyDocMgt.CalculateRevPurchLineAmount(
//                   ToPurchLine,ItemLedgEntryQty,FromPricesInclVAT,ToPricesInclVAT);

//               ToPurchLine.MODIFY;
//             END;
//           END;
//     end;

//     procedure CollectItemTrkgPerPstdDocLine(var TempItemLedgEntry: Record "32" temporary;var ItemLedgEntry: Record "32")
//     begin
//         TempItemLedgEntry.RESET;
//         TempItemLedgEntry.DELETEALL;

//         IF ItemLedgEntry.FINDSET THEN
//           REPEAT
//             TempItemLedgEntry := ItemLedgEntry;
//             AddTempRecordToSet(TempItemLedgEntry,1);
//           UNTIL ItemLedgEntry.NEXT = 0;

//         TempItemLedgEntry.RESET;
//     end;

//     procedure SynchronizeWhseActivItemTrkg(WhseActivLine: Record "5767")
//     var
//         TempTrackingSpec: Record "336" temporary;
//         TempReservEntry: Record "337" temporary;
//         ReservEntry: Record "337";
//         ATOSalesLine: Record "37";
//         AsmHeader: Record "900";
//         ItemTrackingMgt: Codeunit "6500";
//         ReservMgt: Codeunit "99000845";
//         SignFactor: Integer;
//         ToRowID: Text[250];
//         IsTransferReceipt: Boolean;
//         IsATOPosting: Boolean;
//     begin
//         // Used for carrying the item tracking from the invt. pick/put-away to the parent line.
//         WITH WhseActivLine DO BEGIN
//           RESET;
//           SETCURRENTKEY(
//             "Source Type","Source Subtype","Source No.","Source Line No.","Source Subline No.");
//           SETRANGE("Source Type","Source Type");
//           SETRANGE("Source Subtype","Source Subtype");
//           SETRANGE("Source No.","Source No.");
//           SETRANGE("Source Line No.","Source Line No.");
//           SETRANGE("Source Subline No.","Source Subline No.");
//           SETRANGE("Source Document","Source Document");
//           SETRANGE("Assemble to Order","Assemble to Order");
//           IF FINDSET THEN BEGIN
//             // Transfer receipt needs special treatment:
//             IsTransferReceipt := ("Source Type" = DATABASE::"Transfer Line") AND ("Source Subtype" = 1);
//             IsATOPosting := ("Source Type" = DATABASE::"Sales Line") AND "Assemble to Order";
//             IF ("Source Type" IN [DATABASE::"Prod. Order Line",DATABASE::"Prod. Order Component"]) OR IsTransferReceipt THEN
//               ToRowID :=
//                 ItemTrackingMgt.ComposeRowID(
//                   "Source Type","Source Subtype","Source No.",'',"Source Line No.","Source Subline No.")
//             ELSE BEGIN
//               IF IsATOPosting THEN BEGIN
//                 ATOSalesLine.GET("Source Subtype","Source No.","Source Line No.");
//                 ATOSalesLine.AsmToOrderExists(AsmHeader);
//                 ToRowID :=
//                   ItemTrackingMgt.ComposeRowID(
//                     DATABASE::"Assembly Header",AsmHeader."Document Type",AsmHeader."No.",'',0,0);
//               END ELSE
//                 ToRowID :=
//                   ItemTrackingMgt.ComposeRowID(
//                     "Source Type","Source Subtype","Source No.",'',"Source Subline No.","Source Line No.");
//             END;
//             TempReservEntry.SetPointer(ToRowID);
//             SignFactor := WhseActivitySignFactor(WhseActivLine);
//             REPEAT
//               IF ("Serial No." <> '') OR ("Lot No." <> '') THEN BEGIN
//                 TempReservEntry."Entry No." += 1;
//                 IF SignFactor > 0 THEN
//                   TempReservEntry.Positive := TRUE
//                 ELSE
//                   TempReservEntry.Positive := FALSE;
//                 TempReservEntry."Item No." := "Item No.";
//                 TempReservEntry."Location Code" := "Location Code";
//                 TempReservEntry.Description := Description;
//                 TempReservEntry."Variant Code" := "Variant Code";
//                 TempReservEntry."Quantity (Base)" := "Qty. Outstanding (Base)" * SignFactor;
//                 TempReservEntry.Quantity := "Qty. Outstanding" * SignFactor;
//                 TempReservEntry."Qty. to Handle (Base)" := "Qty. to Handle (Base)" * SignFactor;
//                 TempReservEntry."Qty. to Invoice (Base)" := "Qty. to Handle (Base)" * SignFactor;
//                 TempReservEntry."Qty. per Unit of Measure" := "Qty. per Unit of Measure";
//                 TempReservEntry."Lot No." := "Lot No.";
//                 TempReservEntry."Serial No." := "Serial No.";
//                 TempReservEntry."Expiration Date" := "Expiration Date";
//                 TempReservEntry.INSERT;
//               END;
//             UNTIL NEXT = 0;

//             IF TempReservEntry.ISEMPTY THEN
//               EXIT;
//           END;
//         END;

//         SumUpItemTracking(TempReservEntry,TempTrackingSpec,FALSE,TRUE);
//         IF NOT IsTransferReceipt THEN // Item Tracking on transfer receipt cannot be changed
//           SynchronizeItemTracking2(TempReservEntry,ToRowID,'');
//         ReservEntry.SetPointer(ToRowID);
//         ReservMgt.SetPointerFilter(ReservEntry);

//         IF IsTransferReceipt THEN
//           ReservEntry.SETRANGE("Source Ref. No.");

//         IF ReservEntry.FINDSET THEN
//           REPEAT
//             TempTrackingSpec.SETRANGE("Lot No.",ReservEntry."Lot No.");
//             TempTrackingSpec.SETRANGE("Serial No.",ReservEntry."Serial No.");
//             IF TempTrackingSpec.FINDFIRST THEN BEGIN
//               IF ABS(TempTrackingSpec."Qty. to Handle (Base)") > ABS(ReservEntry."Quantity (Base)") THEN
//                 ReservEntry.VALIDATE("Qty. to Handle (Base)",ReservEntry."Quantity (Base)")
//               ELSE
//                 ReservEntry.VALIDATE("Qty. to Handle (Base)",TempTrackingSpec."Qty. to Handle (Base)");

//               IF ABS(TempTrackingSpec."Qty. to Invoice (Base)") > ABS(ReservEntry."Quantity (Base)") THEN
//                 ReservEntry.VALIDATE("Qty. to Invoice (Base)",ReservEntry."Quantity (Base)")
//               ELSE
//                 ReservEntry.VALIDATE("Qty. to Invoice (Base)",TempTrackingSpec."Qty. to Invoice (Base)");

//               TempTrackingSpec."Qty. to Handle (Base)" -= ReservEntry."Qty. to Handle (Base)";
//               TempTrackingSpec."Qty. to Invoice (Base)" -= ReservEntry."Qty. to Invoice (Base)";
//               TempTrackingSpec.MODIFY;

//               WITH WhseActivLine DO BEGIN
//                 RESET;
//                 SETCURRENTKEY("Source Type","Source Subtype","Source No.","Source Line No.","Source Subline No.");
//                 SETRANGE("Source Type","Source Type");
//                 SETRANGE("Source Subtype","Source Subtype");
//                 SETRANGE("Source No.","Source No.");
//                 SETRANGE("Source Line No.","Source Line No.");
//                 SETRANGE("Source Subline No.","Source Subline No.");
//                 SETRANGE("Source Document","Source Document");
//                 SETRANGE("Lot No.",ReservEntry."Lot No.");
//                 SETRANGE("Serial No.",ReservEntry."Serial No.");
//                 IF FINDFIRST THEN
//                   ReservEntry."Expiration Date" := "Expiration Date";
//               END;

//               ReservEntry.MODIFY;
//             END ELSE BEGIN
//               IF IsTransferReceipt THEN BEGIN
//                 ReservEntry.VALIDATE("Qty. to Handle (Base)",0);
//                 ReservEntry.VALIDATE("Qty. to Invoice (Base)",0);
//                 ReservEntry.MODIFY;
//               END;
//             END;
//           UNTIL ReservEntry.NEXT = 0;

//         TempTrackingSpec.RESET;
//         TempTrackingSpec.CALCSUMS("Qty. to Handle (Base)","Qty. to Invoice (Base)");
//         IF (TempTrackingSpec."Qty. to Handle (Base)" <> 0) OR (TempTrackingSpec."Qty. to Invoice (Base)" <> 0) THEN
//           ERROR(Text002);
//     end;

//     local procedure WhseActivitySignFactor(WhseActivityLine: Record "5767"): Integer
//     begin
//         IF WhseActivityLine."Activity Type" = WhseActivityLine."Activity Type"::"Invt. Pick" THEN BEGIN
//           IF WhseActivityLine."Assemble to Order" THEN
//             EXIT(1);
//           EXIT(-1);
//         END;
//         IF WhseActivityLine."Activity Type" = WhseActivityLine."Activity Type"::"Invt. Put-away" THEN
//           EXIT(1);

//         ERROR(Text011,WhseActivityLine.FIELDCAPTION("Activity Type"),WhseActivityLine."Activity Type");
//     end;

//     procedure RetrieveAppliedExpirationDate(var TempItemLedgEntry: Record "32" temporary)
//     var
//         ItemLedgEntry: Record "32";
//         ItemApplnEntry: Record "339";
//     begin
//         WITH TempItemLedgEntry DO BEGIN
//           IF Positive THEN
//             EXIT;

//           ItemApplnEntry.RESET;
//           ItemApplnEntry.SETCURRENTKEY("Outbound Item Entry No.","Item Ledger Entry No.","Cost Application");
//           ItemApplnEntry.SETRANGE("Outbound Item Entry No.","Entry No.");
//           ItemApplnEntry.SETRANGE("Item Ledger Entry No.","Entry No.");
//           IF ItemApplnEntry.FINDFIRST THEN BEGIN
//             ItemLedgEntry.GET(ItemApplnEntry."Inbound Item Entry No.");
//             "Expiration Date" := ItemLedgEntry."Expiration Date";
//           END;
//         END;
//     end;

//     procedure ItemTrkgQtyPostedOnSource(SourceTrackingSpec: Record "336") Qty: Decimal
//     var
//         TrackingSpecification: Record "336";
//         ReservEntry: Record "337";
//         TransferLine: Record "5741";
//     begin
//         WITH SourceTrackingSpec DO BEGIN
//           TrackingSpecification.SETCURRENTKEY(
//             "Source ID","Source Type","Source Subtype",
//             "Source Batch Name","Source Prod. Order Line","Source Ref. No.");

//           TrackingSpecification.SETRANGE("Source ID","Source ID");
//           TrackingSpecification.SETRANGE("Source Type","Source Type");
//           TrackingSpecification.SETRANGE("Source Subtype","Source Subtype");
//           TrackingSpecification.SETRANGE("Source Batch Name","Source Batch Name");
//           TrackingSpecification.SETRANGE("Source Prod. Order Line","Source Prod. Order Line");
//           TrackingSpecification.SETRANGE("Source Ref. No.","Source Ref. No.");
//           IF NOT TrackingSpecification.ISEMPTY THEN BEGIN
//             TrackingSpecification.FINDSET;
//             REPEAT
//               Qty += TrackingSpecification."Quantity (Base)";
//             UNTIL TrackingSpecification.NEXT = 0;
//           END;

//           ReservEntry.SETRANGE("Source ID","Source ID");
//           ReservEntry.SETRANGE("Source Ref. No.","Source Ref. No.");
//           ReservEntry.SETRANGE("Source Type","Source Type");
//           ReservEntry.SETRANGE("Source Subtype","Source Subtype");
//           ReservEntry.SETRANGE("Source Batch Name",'');
//           ReservEntry.SETRANGE("Source Prod. Order Line","Source Prod. Order Line");
//           IF NOT ReservEntry.ISEMPTY THEN BEGIN
//             ReservEntry.FINDSET;
//             REPEAT
//               Qty += ReservEntry."Qty. to Handle (Base)";
//             UNTIL ReservEntry.NEXT = 0;
//           END;
//           IF "Source Type" = DATABASE::"Transfer Line" THEN BEGIN
//             TransferLine.GET("Source ID","Source Ref. No.");
//             Qty -= TransferLine."Qty. Shipped (Base)";
//           END;
//         END;
//     end;

//     procedure SynchronizeItemTrkgTransfer(var ToReservEntry: Record "337")
//     var
//         FromReservEntry: Record "337";
//         TempReservEntry: Record "337" temporary;
//         QtyToHandleBase: Decimal;
//         QtyToInvoiceBase: Decimal;
//         QtyBase: Decimal;
//     begin
//         FromReservEntry.COPY(ToReservEntry);
//         FromReservEntry.SETRANGE("Source Subtype",0);
//         IF ToReservEntry.FINDSET THEN
//           REPEAT
//             TempReservEntry := ToReservEntry;
//             TempReservEntry.INSERT;
//           UNTIL ToReservEntry.NEXT = 0;

//         TempReservEntry.SETCURRENTKEY(
//           "Item No.","Variant Code","Location Code","Item Tracking","Reservation Status","Lot No.","Serial No.");
//         IF TempReservEntry.FIND('-') THEN
//           REPEAT
//             FromReservEntry.SETRANGE("Lot No.",TempReservEntry."Lot No.");
//             FromReservEntry.SETRANGE("Serial No.",TempReservEntry."Serial No.");

//             QtyToHandleBase := 0;
//             QtyToInvoiceBase := 0;
//             QtyBase := 0;
//             IF FromReservEntry.FIND('-') THEN
//               // due to Order Tracking there can be more than 1 record
//               REPEAT
//                 QtyToHandleBase += FromReservEntry."Qty. to Handle (Base)";
//                 QtyToInvoiceBase += FromReservEntry."Qty. to Invoice (Base)";
//                 QtyBase += FromReservEntry."Quantity (Base)";
//               UNTIL FromReservEntry.NEXT = 0;

//             TempReservEntry.SETRANGE("Lot No.",TempReservEntry."Lot No.");
//             TempReservEntry.SETRANGE("Serial No.",TempReservEntry."Serial No.");
//             REPEAT
//               // remove already synchronized qty (can be also more than 1 record)
//               QtyToHandleBase += TempReservEntry."Qty. to Handle (Base)";
//               QtyToInvoiceBase += TempReservEntry."Qty. to Invoice (Base)";
//               QtyBase += TempReservEntry."Quantity (Base)";
//               TempReservEntry.DELETE;
//             UNTIL TempReservEntry.NEXT = 0;
//             TempReservEntry.SETRANGE("Lot No.");
//             TempReservEntry.SETRANGE("Serial No.");

//             IF QtyToHandleBase <> 0 THEN BEGIN
//               // remaining qty will be added to the last record
//               ToReservEntry := TempReservEntry;
//               IF QtyBase <> 0 THEN BEGIN
//                 ToReservEntry."Qty. to Handle (Base)" := -QtyToHandleBase;
//                 ToReservEntry."Qty. to Invoice (Base)" := -QtyToInvoiceBase;
//               END ELSE BEGIN
//                 ToReservEntry."Qty. to Handle (Base)" -= QtyToHandleBase;
//                 ToReservEntry."Qty. to Invoice (Base)" -= QtyToInvoiceBase;
//               END;
//               ToReservEntry.MODIFY;
//             END;
//           UNTIL TempReservEntry.NEXT = 0;
//     end;

//     procedure InitCollectItemTrkgInformation()
//     begin
//         TempGlobalWhseItemTrkgLine.DELETEALL;
//     end;

//     procedure CollectItemTrkgInfWhseJnlLine(WhseJnlLine: Record "7311")
//     var
//         WhseItemTrkgLinLocal: Record "6550";
//     begin
//         CLEAR(WhseItemTrkgLinLocal);
//         WhseItemTrkgLinLocal.SETCURRENTKEY(
//           "Source ID",
//           "Source Type",
//           "Source Subtype",
//           "Source Batch Name",
//           "Source Prod. Order Line",
//           "Source Ref. No.",
//           "Location Code");
//         WhseItemTrkgLinLocal.SETRANGE("Source ID",WhseJnlLine."Journal Batch Name");
//         WhseItemTrkgLinLocal.SETRANGE("Source Type",DATABASE::"Warehouse Journal Line");
//         WhseItemTrkgLinLocal.SETRANGE("Source Batch Name",WhseJnlLine."Journal Template Name");
//         WhseItemTrkgLinLocal.SETRANGE("Source Ref. No.",WhseJnlLine."Line No.");
//         WhseItemTrkgLinLocal.SETRANGE("Location Code",WhseJnlLine."Location Code");
//         WhseItemTrkgLinLocal.SETRANGE("Item No.",WhseJnlLine."Item No.");
//         WhseItemTrkgLinLocal.SETRANGE("Variant Code",WhseJnlLine."Variant Code");
//         WhseItemTrkgLinLocal.SETRANGE("Qty. per Unit of Measure",WhseJnlLine."Qty. per Unit of Measure");

//         IF WhseItemTrkgLinLocal.FINDSET THEN
//           REPEAT
//             CLEAR(TempGlobalWhseItemTrkgLine);
//             TempGlobalWhseItemTrkgLine := WhseItemTrkgLinLocal;
//             IF TempGlobalWhseItemTrkgLine.INSERT THEN;
//           UNTIL WhseItemTrkgLinLocal.NEXT = 0;
//     end;

//     procedure CheckItemTrkgInfBeforePost()
//     var
//         TempItemLotInfo: Record "6505" temporary;
//         CheckExpDate: Date;
//         ErrorFound: Boolean;
//         EndLoop: Boolean;
//         ErrMsgTxt: Text[160];
//     begin
//         // Check for different expiration dates within one Lot no.
//         IF TempGlobalWhseItemTrkgLine.FIND('-') THEN BEGIN
//           TempItemLotInfo.DELETEALL;
//           REPEAT
//             IF TempGlobalWhseItemTrkgLine."New Lot No." <> '' THEN BEGIN
//               CLEAR(TempItemLotInfo);
//               TempItemLotInfo."Item No." := TempGlobalWhseItemTrkgLine."Item No.";
//               TempItemLotInfo."Variant Code" := TempGlobalWhseItemTrkgLine."Variant Code";
//               TempItemLotInfo."Lot No." := TempGlobalWhseItemTrkgLine."New Lot No.";
//               IF TempItemLotInfo.INSERT THEN;
//             END;
//           UNTIL TempGlobalWhseItemTrkgLine.NEXT = 0;

//           IF TempItemLotInfo.FIND('-') THEN
//             REPEAT
//               ErrorFound := FALSE;
//               EndLoop := FALSE;
//               IF TempGlobalWhseItemTrkgLine.FIND('-') THEN BEGIN
//                 CheckExpDate := 0D;
//                 REPEAT
//                   IF (TempGlobalWhseItemTrkgLine."Item No." = TempItemLotInfo."Item No.") AND
//                      (TempGlobalWhseItemTrkgLine."Variant Code" = TempItemLotInfo."Variant Code") AND
//                      (TempGlobalWhseItemTrkgLine."New Lot No." = TempItemLotInfo."Lot No.")
//                   THEN BEGIN
//                     IF CheckExpDate = 0D THEN
//                       CheckExpDate := TempGlobalWhseItemTrkgLine."New Expiration Date"
//                     ELSE
//                       IF TempGlobalWhseItemTrkgLine."New Expiration Date" <> CheckExpDate THEN BEGIN
//                         ErrorFound := TRUE;
//                         ErrMsgTxt :=
//                           STRSUBSTNO(Text012,
//                             TempGlobalWhseItemTrkgLine."Lot No.",
//                             TempGlobalWhseItemTrkgLine."New Expiration Date",
//                             CheckExpDate);
//                       END;
//                   END;
//                   IF NOT ErrorFound THEN
//                     IF TempGlobalWhseItemTrkgLine.NEXT = 0 THEN
//                       EndLoop := TRUE;
//                 UNTIL EndLoop OR ErrorFound;
//               END;
//             UNTIL (TempItemLotInfo.NEXT = 0) OR ErrorFound;
//           IF ErrorFound THEN
//             ERROR(ErrMsgTxt);
//         END;
//     end;

//     procedure SetPick(IsPick2: Boolean)
//     begin
//         IsPick := IsPick2;
//     end;

//     procedure StrictExpirationPosting(ItemNo: Code[20]): Boolean
//     var
//         Item: Record "27";
//         ItemTrackingCode: Record "6502";
//     begin
//         Item.GET(ItemNo);
//         IF Item."Item Tracking Code" = '' THEN
//           EXIT(FALSE);
//         ItemTrackingCode.GET(Item."Item Tracking Code");
//         EXIT(ItemTrackingCode."Strict Expiration Posting");
//     end;

//     procedure SetRetrieveAsmItemTracking(RetrieveAsmItemTracking2: Boolean)
//     begin
//         RetrieveAsmItemTracking := RetrieveAsmItemTracking2;
//     end;

//     procedure WhseItemTrkgLineExists(SourceId: Code[20];SourceType: Integer;SourceSubtype: Option "0","1","2","3","4","5","6","7","8","9","10";SourceBatchName: Code[10];SourceProdOrderLine: Integer;SourceRefNo: Integer;LocationCode: Code[10];SerialNo: Code[20];LotNo: Code[20]): Boolean
//     var
//         WhseItemTrkgLine: Record "6550";
//     begin
//         WITH WhseItemTrkgLine DO BEGIN
//           SETCURRENTKEY(
//             "Source ID","Source Type","Source Subtype","Source Batch Name",
//             "Source Prod. Order Line","Source Ref. No.","Location Code");
//           SETRANGE("Source ID",SourceId);
//           SETRANGE("Source Type",SourceType);
//           SETRANGE("Source Subtype",SourceSubtype);
//           SETRANGE("Source Batch Name",SourceBatchName);
//           SETRANGE("Source Prod. Order Line",SourceProdOrderLine);
//           SETRANGE("Source Ref. No.",SourceRefNo);
//           SETRANGE("Location Code",LocationCode);
//           IF SerialNo <> '' THEN
//             SETRANGE("Serial No.",SerialNo);
//           IF LotNo <> '' THEN
//             SETRANGE("Lot No.",LotNo);
//           EXIT(NOT ISEMPTY);
//         END;
//     end;

//     procedure AutoAssignLotNo(var SalesLine: Record "37" temporary;SourceType: Integer): Boolean
//     var
//         ItemLedgEntry: Record "32";
//         ItemLedgEntry2: Record "32";
//         ReservEntry: Record "337";
//         TempReservEntry: Record "337" temporary;
//         TempEntrySummary: Record "338" temporary;
//         WarehouseEntry: Record "7312";
//         Item: Record "27";
//         ItemTrackingCode: Record "6502";
//         ItemTrackingSummaryForm: Page "6500";
//         LastEntryNo: Integer;
//         Window: Dialog;
//         InsertRec: Boolean;
//         UseWarehouseEntries: Boolean;
//         QtyOrder: Decimal;
//         lReservEntry: Record "337";
//         EntryNo: Integer;
//         ItemUnitofMeasure: Record "5404";
//         T_Item: Record "27";
//     begin
//         Window.OPEN(Text004);

//         //Delete the existing lot no.
//         lReservEntry.RESET;
//         /*Start: TJCSG1.00 #1*/
//         lReservEntry.SETCURRENTKEY(
//           "Item No.","Source Type","Source Subtype","Reservation Status","Location Code","Variant Code","Shipment Date",
//           "Expected Receipt Date","Serial No.","Lot No.");
//         /*End: TJCSG1.00 #1*/

//         lReservEntry.SETRANGE("Item No.",SalesLine."No.");
//         lReservEntry.SETRANGE("Source Type",DATABASE::"Sales Line");
//         lReservEntry.SETRANGE("Source Subtype",SourceType);
//         lReservEntry.SETRANGE("Source ID",SalesLine."Document No.");
//         lReservEntry.SETRANGE("Source Ref. No.",SalesLine."Line No.");
//         /*Start: TJCSG1.00 #1*/
//         /*
//         IF lReservEntry.FIND('-') THEN
//         REPEAT
//           lReservEntry.DELETE;
//         UNTIL lReservEntry.NEXT = 0;
//         */
//         lReservEntry.DELETEALL;
//         /*End: TJCSG1.00 #1*/

//         //Copy from AssistEditLotSerialNo
//         TempReservEntry.RESET;
//         TempReservEntry.DELETEALL;
//         ReservEntry.RESET;
//         ReservEntry.SETCURRENTKEY("Item No.","Variant Code","Location Code","Reservation Status");
//         ReservEntry.SETRANGE("Item No.",SalesLine."No.");
//         ReservEntry.SETRANGE("Variant Code",SalesLine."Variant Code");
//         ReservEntry.SETRANGE("Location Code",SalesLine."Location Code");
//         ReservEntry.SETRANGE("Reservation Status",
//           ReservEntry."Reservation Status"::Reservation,ReservEntry."Reservation Status"::Surplus);

//         ItemLedgEntry.RESET;
//         ItemLedgEntry.SETCURRENTKEY("Item No.",Open,"Variant Code",Positive,"Location Code");
//         ItemLedgEntry.SETRANGE("Item No.",SalesLine."No.");
//         ItemLedgEntry.SETRANGE(Open,TRUE);
//         ItemLedgEntry.SETRANGE("Variant Code",SalesLine."Variant Code");
//         ItemLedgEntry.SETRANGE("Location Code",SalesLine."Location Code");

//         IF SalesLine."Bin Code" <> '' THEN BEGIN
//           UseWarehouseEntries := TRUE;
//           Item.GET(SalesLine."No.");
//           IF Item."Item Tracking Code" <> '' THEN
//             ItemTrackingCode.GET(Item."Item Tracking Code");
//         END;

//         ItemLedgEntry.SETFILTER("Lot No.",'<>%1','');
//         ReservEntry.SETFILTER("Lot No.",'<>%1','');
//         IF UseWarehouseEntries THEN
//            UseWarehouseEntries := ItemTrackingCode."Lot Warehouse Tracking";

//         IF ItemLedgEntry.FIND('-') THEN
//           REPEAT
//             ItemLedgEntry2.COPY(ItemLedgEntry);
//             IF UseWarehouseEntries THEN BEGIN
//               ItemLedgEntry2.SETRANGE("Serial No.",ItemLedgEntry."Serial No.");
//               ItemLedgEntry2.SETRANGE("Lot No.",ItemLedgEntry."Lot No.");
//               ItemLedgEntry2.CALCSUMS("Remaining Quantity");

//               InsertRec := FALSE;
//               WarehouseEntry.RESET;
//               WarehouseEntry.SETCURRENTKEY(
//                 "Item No.","Bin Code","Location Code","Variant Code",
//                 "Unit of Measure Code","Lot No.","Serial No.");
//               WarehouseEntry.SETRANGE("Item No.",SalesLine."No.");
//               WarehouseEntry.SETRANGE("Bin Code",SalesLine."Bin Code");
//               WarehouseEntry.SETRANGE("Location Code",SalesLine."Location Code");
//               WarehouseEntry.SETRANGE("Variant Code",SalesLine."Variant Code");
//               WarehouseEntry.SETRANGE("Lot No.",ItemLedgEntry."Lot No.");
//               WarehouseEntry.CALCSUMS("Qty. (Base)");
//               IF WarehouseEntry."Qty. (Base)" > 0 THEN BEGIN
//                 InsertRec := TRUE;
//                 IF ItemLedgEntry2."Remaining Quantity" > WarehouseEntry."Qty. (Base)" THEN
//                   ItemLedgEntry2."Remaining Quantity" := WarehouseEntry."Qty. (Base)";
//               END;
//             END ELSE
//               InsertRec := TRUE;

//             IF UseWarehouseEntries THEN BEGIN
//               TempReservEntry.SETRANGE("Serial No.",ItemLedgEntry."Serial No.");
//               TempReservEntry.SETRANGE("Lot No.",ItemLedgEntry."Lot No.");
//               IF TempReservEntry.FIND('-') THEN
//                 InsertRec := FALSE;
//             END;
//             TempReservEntry.INIT;
//             TempReservEntry."Entry No." := -ItemLedgEntry."Entry No.";
//             TempReservEntry."Reservation Status" := ReservEntry."Reservation Status"::Surplus;
//             TempReservEntry.Positive := ItemLedgEntry.Positive;
//             TempReservEntry."Item No." := ItemLedgEntry."Item No.";
//             TempReservEntry."Location Code" := ItemLedgEntry."Location Code";
//             TempReservEntry."Quantity (Base)" := ItemLedgEntry2."Remaining Quantity";
//             TempReservEntry."Source Type" := DATABASE::"Item Ledger Entry";
//             TempReservEntry."Source Ref. No." := ItemLedgEntry."Entry No.";
//             TempReservEntry."Serial No." := ItemLedgEntry."Serial No.";
//             TempReservEntry."Lot No." := ItemLedgEntry."Lot No.";
//             TempReservEntry."Variant Code" := ItemLedgEntry."Variant Code";
//             IF TempReservEntry.Positive THEN BEGIN
//               TempReservEntry."Warranty Date" := ItemLedgEntry."Warranty Date";
//               TempReservEntry."Expiration Date" := ItemLedgEntry."Expiration Date";
//               //TempReservEntry."Expiration Date" := ItemLedgEntry."Posting Date";
//               TempReservEntry."Expected Receipt Date" := 0D
//             END ELSE BEGIN
//               TempReservEntry."Shipment Date" := 12319999D;
//               //TempReservEntry."Expiration Date" := ItemLedgEntry."Posting Date";
//               TempReservEntry."Expiration Date" := ItemLedgEntry."Expiration Date";
//             END;
//             IF InsertRec THEN
//               TempReservEntry.INSERT;
//           UNTIL ItemLedgEntry.NEXT = 0;

//         IF ReservEntry.FIND('-') THEN REPEAT
//           IF IsValidBinCode(ReservEntry,SalesLine."Bin Code") OR
//              NOT UseWarehouseEntries
//           THEN BEGIN
//             TempReservEntry := ReservEntry;
//             TempReservEntry.INSERT;
//           END;
//         UNTIL ReservEntry.NEXT = 0;

//         TempReservEntry.RESET;
//         IF TempReservEntry.FIND('-') THEN
//           REPEAT
//             TempEntrySummary.SETRANGE("Lot No.",TempReservEntry."Lot No.");
//             IF NOT TempEntrySummary.FIND('-') THEN BEGIN
//               TempEntrySummary.INIT;
//               TempEntrySummary."Entry No." := LastEntryNo + 1;
//               LastEntryNo := TempEntrySummary."Entry No.";
//               TempEntrySummary."Table ID" := TempReservEntry."Source Type";
//               TempEntrySummary."Summary Type" := '';
//               TempEntrySummary."Lot No." := TempReservEntry."Lot No.";
//               TempEntrySummary.INSERT;
//             END;

//             IF TempReservEntry.Positive THEN BEGIN
//               TempEntrySummary."Warranty Date" := TempReservEntry."Warranty Date";
//               TempEntrySummary."Expiration Date" := TempReservEntry."Expiration Date";
//               IF TempReservEntry."Entry No." < 0 THEN
//                 TempEntrySummary."Total Quantity" += TempReservEntry."Quantity (Base)";
//               IF TempReservEntry."Reservation Status" = TempReservEntry."Reservation Status"::Reservation THEN
//                 TempEntrySummary."Total Reserved Quantity" += TempReservEntry."Quantity (Base)";
//             END ELSE BEGIN
//               TempEntrySummary."Total Requested Quantity" -= TempReservEntry."Quantity (Base)";
//               IF (TempReservEntry."Reservation Status" = TempReservEntry."Reservation Status"::Reservation) AND
//                  (TempReservEntry."Source Type" = DATABASE::"Sales Line") AND
//                  (TempReservEntry."Source Subtype" = 1) AND
//                  (TempReservEntry."Source ID" = SalesLine."Document No.") AND
//                  (TempReservEntry."Source Batch Name" = '') AND
//                  (TempReservEntry."Source Prod. Order Line" = 0) AND
//                  (TempReservEntry."Source Ref. No." = SalesLine."Line No.")
//                THEN
//                 TempEntrySummary."Current Reserved Quantity" -= TempReservEntry."Quantity (Base)";
//             END;

//             TempEntrySummary."Total Available Quantity" :=
//               TempEntrySummary."Total Quantity" -
//               TempEntrySummary."Total Requested Quantity" +
//               TempEntrySummary."Current Reserved Quantity";
//             TempEntrySummary.MODIFY;
//           UNTIL TempReservEntry.NEXT = 0;

//         //Start FIFO
//         lReservEntry.RESET;
//         IF lReservEntry.FIND('+') THEN EntryNo := lReservEntry."Entry No." + 1
//         ELSE EntryNo := 1;

//         QtyOrder := SalesLine."Qty. to Ship";
//         T_Item.RESET;
//         T_Item.GET(SalesLine."No.");
//         // IF SalesLine."Unit of Measure" <> T_Item."Base Unit of Measure" THEN    // TJCSG1.00 #1
//         IF SalesLine."Unit of Measure Code" <> T_Item."Base Unit of Measure" THEN
//         BEGIN
//           ItemUnitofMeasure.RESET;
//           /*Start: TJCSG1.00 #1*/
//           /*
//           ItemUnitofMeasure.SETRANGE("Item No.", SalesLine."No.");
//           ItemUnitofMeasure.SETRANGE(Code, SalesLine."Unit of Measure");
//           IF ItemUnitofMeasure.FIND('-') THEN
//           BEGIN
//             QtyOrder := QtyOrder * ItemUnitofMeasure."Qty. per Unit of Measure";
//           END;
//           */
//           IF ItemUnitofMeasure.GET(SalesLine."No.",SalesLine."Unit of Measure Code") THEN
//             QtyOrder := QtyOrder * ItemUnitofMeasure."Qty. per Unit of Measure";
//           /*End: TJCSG1.00 #1*/
//         END;

//         TempEntrySummary.RESET;
//         TempEntrySummary.SETCURRENTKEY("Expiration Date");
//         //DP.NCM 21012015 DD 298 - Sort for Expiration Date not blank
//         TempEntrySummary.SETFILTER("Expiration Date",'<>%1',0D);
//         TempEntrySummary.ASCENDING(TRUE);
//         //DP.NCM 21012015 DD 298
//         TempEntrySummary.SETFILTER("Total Available Quantity",'>%1',0);
//         //MESSAGE(FORMAT(TempEntrySummary.COUNT));
//         IF TempEntrySummary.FIND('-') THEN
//         REPEAT
//           IF TempEntrySummary."Total Available Quantity" - QtyOrder >= 0 THEN
//           BEGIN
//               lReservEntry.INIT;
//               lReservEntry."Entry No." := EntryNo;
//               lReservEntry."Item No."  := SalesLine."No.";
//               lReservEntry."Location Code" := SalesLine."Location Code";
//               lReservEntry."Quantity (Base)" := QtyOrder * -1;
//               lReservEntry.VALIDATE(lReservEntry."Quantity (Base)");
//               lReservEntry."Reservation Status" := lReservEntry."Reservation Status"::Surplus;
//               lReservEntry."Creation Date" := WORKDATE;
//               lReservEntry."Source Type" := DATABASE::"Sales Line";
//               lReservEntry."Source Subtype" := SalesLine."Document Type";
//               lReservEntry."Source ID" := SalesLine."Document No.";
//               lReservEntry."Source Ref. No." := SalesLine."Line No.";
//               lReservEntry."Created By" := USERID;
//               lReservEntry."Qty. per Unit of Measure" := SalesLine."Qty. per Unit of Measure";
//               lReservEntry."Lot No." := TempEntrySummary."Lot No.";
//               lReservEntry."Expiration Date" := TempEntrySummary."Expiration Date";
//               lReservEntry."Shipment Date" := SalesLine."Shipment Date";
//               IF QtyOrder < 0 THEN
//                 lReservEntry.Positive := TRUE
//               ELSE
//                 lReservEntry.Positive := FALSE;

//               lReservEntry.INSERT;
//               QtyOrder := 0;
//           END
//           ELSE BEGIN
//               QtyOrder := QtyOrder - TempEntrySummary."Total Available Quantity";
//               lReservEntry.INIT;
//               lReservEntry."Entry No." := EntryNo;
//               lReservEntry."Item No."  := SalesLine."No.";
//               lReservEntry."Location Code" := SalesLine."Location Code";
//               lReservEntry."Quantity (Base)" := TempEntrySummary."Total Available Quantity" * -1;
//               lReservEntry.VALIDATE(lReservEntry."Quantity (Base)");
//               lReservEntry."Reservation Status" := lReservEntry."Reservation Status"::Surplus;
//               lReservEntry."Creation Date" := WORKDATE;
//               lReservEntry."Source Type" := DATABASE::"Sales Line";
//               lReservEntry."Source Subtype" := SalesLine."Document Type";
//               lReservEntry."Source ID" := SalesLine."Document No.";
//               lReservEntry."Source Ref. No." := SalesLine."Line No.";
//               lReservEntry."Created By" := USERID;
//               lReservEntry."Qty. per Unit of Measure" := SalesLine."Qty. per Unit of Measure";
//               lReservEntry."Lot No." := TempEntrySummary."Lot No.";
//               lReservEntry."Expiration Date" := TempEntrySummary."Expiration Date";
//               lReservEntry."Shipment Date" := SalesLine."Shipment Date";
//               IF QtyOrder < 0 THEN
//                 lReservEntry.Positive := TRUE
//               ELSE
//                 lReservEntry.Positive := FALSE;

//               lReservEntry.INSERT;
//           END;
//           EntryNo += 1;
//         UNTIL (QtyOrder <= 0) OR (TempEntrySummary.NEXT = 0);

//         TempEntrySummary.RESET;
//         TempEntrySummary.SETCURRENTKEY("Expiration Date");
//         //DP.NCM 21012015 DD 298 - Sort for blank expiration Date
//         TempEntrySummary.SETFILTER("Expiration Date",'%1',0D);
//         //DP.NCM 21012015 DD 298
//         TempEntrySummary.SETFILTER("Total Available Quantity",'>%1',0);
//         IF TempEntrySummary.FIND('-') AND (QtyOrder > 0) THEN
//         REPEAT
//           IF TempEntrySummary."Total Available Quantity" - QtyOrder >= 0 THEN
//           BEGIN
//               lReservEntry.INIT;
//               lReservEntry."Entry No." := EntryNo;
//               lReservEntry."Item No."  := SalesLine."No.";
//               lReservEntry."Location Code" := SalesLine."Location Code";
//               lReservEntry."Quantity (Base)" := QtyOrder * -1;
//               lReservEntry.VALIDATE(lReservEntry."Quantity (Base)");
//               lReservEntry."Reservation Status" := lReservEntry."Reservation Status"::Surplus;
//               lReservEntry."Creation Date" := WORKDATE;
//               lReservEntry."Source Type" := DATABASE::"Sales Line";
//               lReservEntry."Source Subtype" := SalesLine."Document Type";
//               lReservEntry."Source ID" := SalesLine."Document No.";
//               lReservEntry."Source Ref. No." := SalesLine."Line No.";
//               lReservEntry."Created By" := USERID;
//               lReservEntry."Qty. per Unit of Measure" := SalesLine."Qty. per Unit of Measure";
//               lReservEntry."Lot No." := TempEntrySummary."Lot No.";
//               lReservEntry."Expiration Date" := TempEntrySummary."Expiration Date";
//               lReservEntry."Shipment Date" := SalesLine."Shipment Date";
//               IF QtyOrder < 0 THEN
//                 lReservEntry.Positive := TRUE
//               ELSE
//                 lReservEntry.Positive := FALSE;

//               lReservEntry.INSERT;
//               QtyOrder := 0;
//           END
//           ELSE BEGIN
//               QtyOrder := QtyOrder - TempEntrySummary."Total Available Quantity";
//               lReservEntry.INIT;
//               lReservEntry."Entry No." := EntryNo;
//               lReservEntry."Item No."  := SalesLine."No.";
//               lReservEntry."Location Code" := SalesLine."Location Code";
//               lReservEntry."Quantity (Base)" := TempEntrySummary."Total Available Quantity" * -1;
//               lReservEntry.VALIDATE(lReservEntry."Quantity (Base)");
//               lReservEntry."Reservation Status" := lReservEntry."Reservation Status"::Surplus;
//               lReservEntry."Creation Date" := WORKDATE;
//               lReservEntry."Source Type" := DATABASE::"Sales Line";
//               lReservEntry."Source Subtype" := SalesLine."Document Type";
//               lReservEntry."Source ID" := SalesLine."Document No.";
//               lReservEntry."Source Ref. No." := SalesLine."Line No.";
//               lReservEntry."Created By" := USERID;
//               lReservEntry."Qty. per Unit of Measure" := SalesLine."Qty. per Unit of Measure";
//               lReservEntry."Lot No." := TempEntrySummary."Lot No.";
//               lReservEntry."Expiration Date" := TempEntrySummary."Expiration Date";
//               lReservEntry."Shipment Date" := SalesLine."Shipment Date";
//               IF QtyOrder < 0 THEN
//                 lReservEntry.Positive := TRUE
//               ELSE
//                 lReservEntry.Positive := FALSE;

//               lReservEntry.INSERT;
//           END;
//           EntryNo += 1;
//         UNTIL (QtyOrder <= 0) OR (TempEntrySummary.NEXT = 0);


//         IF (QtyOrder <> 0) THEN
//           MESSAGE(Text50000,SalesLine."Line No.");

//     end;

//     procedure AutoAssignAllLotNo(ProdOrderComponent: Record "5407")
//     var
//         TrackingSpecification: Record "336";
//         "Prod. Order Line-Reserve": Codeunit "99000838";
//         lReservEntry: Record "337";
//         EntryNo: Integer;
//         QtyOrder: Decimal;
//         TempEntrySummary: Record "338" temporary;
//         ItemLedgEntry: Record "32";
//         ItemLedgEntry2: Record "32";
//         ReservEntry: Record "337";
//         TempReservEntry: Record "337" temporary;
//         WarehouseEntry: Record "7312";
//         Item: Record "27";
//         ItemTrackingCode: Record "6502";
//         ItemTrackingSummaryForm: Page "6500";
//         LastEntryNo: Integer;
//         Window: Dialog;
//         InsertRec: Boolean;
//         UseWarehouseEntries: Boolean;
//     begin

//         //Delete the existing lot no.
//         lReservEntry.RESET;
//         lReservEntry.SETRANGE("Source Type",DATABASE::"Prod. Order Component");
//         lReservEntry.SETRANGE("Source Subtype",2);
//         lReservEntry.SETRANGE("Source ID", ProdOrderComponent."Prod. Order No.");
//         lReservEntry.SETRANGE("Item No.", ProdOrderComponent."Item No.");
//         lReservEntry.SETRANGE("Source Prod. Order Line", ProdOrderComponent."Prod. Order Line No.");
//         IF lReservEntry.FIND('-') THEN
//         REPEAT
//           lReservEntry.DELETE;
//         UNTIL lReservEntry.NEXT = 0;

//         "Prod. Order Line-Reserve".InitTrackingSpecification( ProdOrderComponent, TrackingSpecification);

//         TempReservEntry.RESET;
//         TempReservEntry.DELETEALL;
//         ReservEntry.RESET;
//         ReservEntry.SETCURRENTKEY("Item No.","Variant Code","Location Code","Reservation Status");
//         ReservEntry.SETRANGE("Item No.",TrackingSpecification."Item No.");
//         ReservEntry.SETRANGE("Variant Code",TrackingSpecification."Variant Code");
//         ReservEntry.SETRANGE("Location Code",TrackingSpecification."Location Code");
//         ReservEntry.SETRANGE("Reservation Status",
//           ReservEntry."Reservation Status"::Reservation,ReservEntry."Reservation Status"::Surplus);

//         ItemLedgEntry.RESET;
//         ItemLedgEntry.SETCURRENTKEY("Item No.",Open,"Variant Code",Positive,"Location Code");
//         ItemLedgEntry.SETRANGE("Item No.",TrackingSpecification."Item No.");
//         ItemLedgEntry.SETRANGE("Variant Code",TrackingSpecification."Variant Code");
//         ItemLedgEntry.SETRANGE(Open,TRUE);
//         ItemLedgEntry.SETRANGE("Location Code",TrackingSpecification."Location Code");

//         IF TrackingSpecification."Bin Code" <> '' THEN BEGIN
//           UseWarehouseEntries := TRUE;
//           Item.GET(TrackingSpecification."Item No.");
//           IF Item."Item Tracking Code" <> '' THEN
//             ItemTrackingCode.GET(Item."Item Tracking Code");
//         END;

//         ItemLedgEntry.SETFILTER("Lot No.",'<>%1','');
//         ReservEntry.SETFILTER("Lot No.",'<>%1','');
//         IF UseWarehouseEntries THEN
//             UseWarehouseEntries := ItemTrackingCode."Lot Warehouse Tracking";

//         IF ItemLedgEntry.FIND('-') THEN
//           REPEAT
//             ItemLedgEntry2.COPY(ItemLedgEntry);
//             IF UseWarehouseEntries THEN BEGIN
//               ItemLedgEntry2.SETRANGE("Serial No.",ItemLedgEntry."Serial No.");
//               ItemLedgEntry2.SETRANGE("Lot No.",ItemLedgEntry."Lot No.");
//               ItemLedgEntry2.CALCSUMS("Remaining Quantity");

//               InsertRec := FALSE;
//               WarehouseEntry.RESET;
//               WarehouseEntry.SETCURRENTKEY(
//                 "Item No.","Bin Code","Location Code","Variant Code",
//                 "Unit of Measure Code","Lot No.","Serial No.");
//               WarehouseEntry.SETRANGE("Item No.",TrackingSpecification."Item No.");
//               WarehouseEntry.SETRANGE("Bin Code",TrackingSpecification."Bin Code");
//               WarehouseEntry.SETRANGE("Location Code",TrackingSpecification."Location Code");
//               WarehouseEntry.SETRANGE("Variant Code",TrackingSpecification."Variant Code");
//               WarehouseEntry.SETRANGE("Lot No.",ItemLedgEntry."Lot No.");
//               WarehouseEntry.CALCSUMS("Qty. (Base)");
//               IF WarehouseEntry."Qty. (Base)" > 0 THEN BEGIN
//                 InsertRec := TRUE;
//                 IF ItemLedgEntry2."Remaining Quantity" > WarehouseEntry."Qty. (Base)" THEN
//                   ItemLedgEntry2."Remaining Quantity" := WarehouseEntry."Qty. (Base)";
//               END;
//             END ELSE
//               InsertRec := TRUE;

//             IF UseWarehouseEntries THEN BEGIN
//               TempReservEntry.SETRANGE("Serial No.",ItemLedgEntry."Serial No.");
//               TempReservEntry.SETRANGE("Lot No.",ItemLedgEntry."Lot No.");
//               IF TempReservEntry.FIND('-') THEN
//                 InsertRec := FALSE;
//             END;
//             TempReservEntry.INIT;
//             TempReservEntry."Entry No." := -ItemLedgEntry."Entry No.";
//             TempReservEntry."Reservation Status" := ReservEntry."Reservation Status"::Surplus;
//             TempReservEntry.Positive := ItemLedgEntry.Positive;
//             TempReservEntry."Item No." := ItemLedgEntry."Item No.";
//             TempReservEntry."Location Code" := ItemLedgEntry."Location Code";
//             TempReservEntry."Quantity (Base)" := ItemLedgEntry2."Remaining Quantity";
//             TempReservEntry."Source Type" := DATABASE::"Item Ledger Entry";
//             TempReservEntry."Source Ref. No." := ItemLedgEntry."Entry No.";
//             TempReservEntry."Serial No." := ItemLedgEntry."Serial No.";
//             TempReservEntry."Lot No." := ItemLedgEntry."Lot No.";
//             TempReservEntry."Variant Code" := ItemLedgEntry."Variant Code";
//             IF TempReservEntry.Positive THEN BEGIN
//               TempReservEntry."Warranty Date" := ItemLedgEntry."Warranty Date";
//               //TempReservEntry."Expiration Date" := ItemLedgEntry."Expiration Date";
//               TempReservEntry."Expiration Date" := ItemLedgEntry."Posting Date";
//               TempReservEntry."Expected Receipt Date" := 0D
//             END ELSE BEGIN
//               TempReservEntry."Shipment Date" := 12319999D;
//               TempReservEntry."Expiration Date" := ItemLedgEntry."Posting Date";
//             END;

//             IF InsertRec THEN
//               TempReservEntry.INSERT;
//           UNTIL ItemLedgEntry.NEXT = 0;

//         IF ReservEntry.FIND('-') THEN REPEAT
//           IF IsValidBinCode(ReservEntry,TrackingSpecification."Bin Code") OR
//              NOT UseWarehouseEntries
//           THEN BEGIN
//             TempReservEntry := ReservEntry;
//             TempReservEntry.INSERT;
//           END;
//         UNTIL ReservEntry.NEXT = 0;

//         TempReservEntry.RESET;
//         IF TempReservEntry.FIND('-') THEN
//           REPEAT
//             TempEntrySummary.SETRANGE("Lot No.",TempReservEntry."Lot No.");

//             IF NOT TempEntrySummary.FIND('-') THEN BEGIN
//               TempEntrySummary.INIT;
//               TempEntrySummary."Entry No." := LastEntryNo + 1;
//               LastEntryNo := TempEntrySummary."Entry No.";
//               TempEntrySummary."Table ID" := TempReservEntry."Source Type";
//               TempEntrySummary."Summary Type" := '';
//               TempEntrySummary."Lot No." := TempReservEntry."Lot No.";
//               TempEntrySummary.INSERT;
//             END;

//             IF TempReservEntry.Positive THEN BEGIN
//               TempEntrySummary."Warranty Date" := TempReservEntry."Warranty Date";
//               TempEntrySummary."Expiration Date" := TempReservEntry."Expiration Date";
//               IF TempReservEntry."Entry No." < 0 THEN
//                 TempEntrySummary."Total Quantity" += TempReservEntry."Quantity (Base)";
//               IF TempReservEntry."Reservation Status" = TempReservEntry."Reservation Status"::Reservation THEN
//                 TempEntrySummary."Total Reserved Quantity" += TempReservEntry."Quantity (Base)";
//             END ELSE BEGIN
//               TempEntrySummary."Total Requested Quantity" -= TempReservEntry."Quantity (Base)";
//               IF (TempReservEntry."Reservation Status" = TempReservEntry."Reservation Status"::Reservation) AND
//                  (TempReservEntry."Source Type" = TrackingSpecification."Source Type") AND
//                  (TempReservEntry."Source Subtype" = TrackingSpecification."Source Subtype") AND
//                  (TempReservEntry."Source ID" = TrackingSpecification."Source ID") AND
//                  (TempReservEntry."Source Batch Name" = TrackingSpecification."Source Batch Name") AND
//                  (TempReservEntry."Source Prod. Order Line" = TrackingSpecification."Source Prod. Order Line") AND
//                  (TempReservEntry."Source Ref. No." = TrackingSpecification."Source Ref. No.")
//                THEN
//                 TempEntrySummary."Current Reserved Quantity" -= TempReservEntry."Quantity (Base)";
//             END;

//             TempEntrySummary."Total Available Quantity" :=
//               TempEntrySummary."Total Quantity" -
//               TempEntrySummary."Total Requested Quantity" +
//               TempEntrySummary."Current Reserved Quantity";
//             TempEntrySummary.MODIFY;
//           UNTIL TempReservEntry.NEXT = 0;

//         //Start FIFO
//         lReservEntry.RESET;
//         IF lReservEntry.FIND('+') THEN EntryNo := lReservEntry."Entry No." + 1
//         ELSE EntryNo := 1;

//         QtyOrder := ProdOrderComponent."Expected Qty. (Base)";

//         TempEntrySummary.RESET;
//         TempEntrySummary.SETCURRENTKEY("Expiration Date");
//               TempEntrySummary.SETFILTER("Total Available Quantity",'>%1',0);
//               IF TempEntrySummary.FIND('-') THEN
//               REPEAT
//                 IF TempEntrySummary."Total Available Quantity" - QtyOrder >= 0 THEN
//                 BEGIN
//                     lReservEntry.INIT;
//                     lReservEntry."Entry No." := EntryNo;
//                     lReservEntry."Item No."  := ProdOrderComponent."Item No.";
//                     lReservEntry."Location Code" := ProdOrderComponent."Location Code";
//                     lReservEntry."Quantity (Base)" := QtyOrder * -1;
//                     lReservEntry.VALIDATE(lReservEntry."Quantity (Base)");
//                     lReservEntry."Reservation Status" := lReservEntry."Reservation Status"::Surplus;
//                     lReservEntry."Creation Date" := WORKDATE;
//                     lReservEntry."Source Type" := DATABASE::"Prod. Order Component";
//                     lReservEntry."Source Subtype" := 2;
//                     lReservEntry."Source ID" := ProdOrderComponent."Prod. Order No.";
//                     lReservEntry."Source Ref. No." := ProdOrderComponent."Line No.";
//                     lReservEntry."Created By" := USERID;
//                     lReservEntry."Qty. per Unit of Measure" := ProdOrderComponent."Qty. per Unit of Measure";
//                     lReservEntry."Lot No." := TempEntrySummary."Lot No.";
//                     lReservEntry."Expiration Date" := TempEntrySummary."Expiration Date";
//                     lReservEntry."Source Prod. Order Line" := ProdOrderComponent."Prod. Order Line No.";
//                     lReservEntry.INSERT;
//                     QtyOrder := 0;
//                 END
//                 ELSE BEGIN
//                     QtyOrder := QtyOrder - TempEntrySummary."Total Available Quantity";
//                     lReservEntry.INIT;
//                     lReservEntry."Entry No." := EntryNo;
//                     lReservEntry."Item No."  := ProdOrderComponent."Item No.";
//                     lReservEntry."Location Code" := ProdOrderComponent."Location Code";
//                     lReservEntry."Quantity (Base)" := TempEntrySummary."Total Available Quantity" * -1;
//                     lReservEntry.VALIDATE(lReservEntry."Quantity (Base)");
//                     lReservEntry."Reservation Status" := lReservEntry."Reservation Status"::Surplus;
//                     lReservEntry."Creation Date" := WORKDATE;
//                     lReservEntry."Source Type" := DATABASE::"Prod. Order Component";
//                     lReservEntry."Source Subtype" := 2;
//                     lReservEntry."Source ID" := ProdOrderComponent."Prod. Order No.";
//                     lReservEntry."Source Ref. No." := ProdOrderComponent."Line No.";
//                     lReservEntry."Created By" := USERID;
//                     lReservEntry."Qty. per Unit of Measure" := ProdOrderComponent."Qty. per Unit of Measure";
//                     lReservEntry."Lot No." := TempEntrySummary."Lot No.";
//                     lReservEntry."Expiration Date" := TempEntrySummary."Expiration Date";
//                     lReservEntry."Source Prod. Order Line" := ProdOrderComponent."Prod. Order Line No.";
//                     lReservEntry.INSERT;
//                 END;
//                 EntryNo += 1;
//               UNTIL (QtyOrder <= 0) OR (TempEntrySummary.NEXT = 0);
//     end;

//     procedure AutoAssignTransferAllLotNo(TransLine: Record "5741")
//     var
//         TrackingSpecification: Record "336";
//         lReservEntry: Record "337";
//         TempEntrySummary: Record "338" temporary;
//         ItemLedgEntry: Record "32";
//         ItemLedgEntry2: Record "32";
//         ReservEntry: Record "337";
//         TempReservEntry: Record "337" temporary;
//         WarehouseEntry: Record "7312";
//         Item: Record "27";
//         ItemTrackingCode: Record "6502";
//         ItemUnitOfMeasure: Record "5404";
//         ItemTrackingSummaryForm: Page "6500";
//         "transfer Line-Reserve": Codeunit "99000836";
//         QtyOrder: Decimal;
//         EntryNo: Integer;
//         LastEntryNo: Integer;
//         Direction: Option Outbound,Inbound;
//         AvalabilityDate: Date;
//         InsertRec: Boolean;
//         UseWarehouseEntries: Boolean;
//         Window: Dialog;
//     begin
//         //Delete the existing lot no.
//         lReservEntry.RESET;
//         /*Start: TJCSG1.00 #1*/
//         lReservEntry.SETCURRENTKEY(
//           "Item No.","Source Type","Source Subtype","Reservation Status","Location Code","Variant Code","Shipment Date",
//           "Expected Receipt Date","Serial No.","Lot No.");
//         /*End: TJCSG1.00 #1*/

//         lReservEntry.SETRANGE("Item No.", TransLine."Item No.");
//         lReservEntry.SETRANGE("Source Type",DATABASE::"Transfer Line");
//         //lReservEntry.SETRANGE("Source Subtype",2);
//         lReservEntry.SETRANGE("Source ID",TransLine."Document No.");
//         //DP.NCM 21012015 DD 289
//         //lReservEntry.SETRANGE("Source Prod. Order Line",TransLine."Derived From Line No.");
//         IF TransLine."Derived From Line No." <> 0 THEN
//           lReservEntry.SETRANGE("Source Prod. Order Line",TransLine."Derived From Line No.")
//         ELSE
//           lReservEntry.SETFILTER("Source Ref. No.",'%1',TransLine."Line No.");
//         //DP.NCM 21012015 DD 289

//         /*Start: TJCSG1.00 #1*/
//         /*
//         IF lReservEntry.FIND('-') THEN
//         REPEAT
//           lReservEntry.DELETE;
//         UNTIL lReservEntry.NEXT = 0;
//         */
//         lReservEntry.DELETEALL;
//         /*End: TJCSG1.00 #1*/

//         Direction := Direction::Outbound;
//         "transfer Line-Reserve".InitTrackingSpecification(TransLine,TrackingSpecification,AvalabilityDate,Direction);

//         TempReservEntry.RESET;
//         TempReservEntry.DELETEALL;
//         ReservEntry.RESET;
//         ReservEntry.SETCURRENTKEY("Item No.","Variant Code","Location Code","Reservation Status");
//         ReservEntry.SETRANGE("Item No.",TrackingSpecification."Item No.");
//         ReservEntry.SETRANGE("Variant Code",TrackingSpecification."Variant Code");
//         ReservEntry.SETRANGE("Location Code",TrackingSpecification."Location Code");
//         ReservEntry.SETRANGE("Reservation Status",
//           ReservEntry."Reservation Status"::Reservation,ReservEntry."Reservation Status"::Surplus);

//         ItemLedgEntry.RESET;
//         ItemLedgEntry.SETCURRENTKEY("Item No.",Open,"Variant Code",Positive,"Location Code");
//         ItemLedgEntry.SETRANGE("Item No.",TrackingSpecification."Item No.");
//         ItemLedgEntry.SETRANGE(Open,TRUE);
//         ItemLedgEntry.SETRANGE("Variant Code",TrackingSpecification."Variant Code");
//         ItemLedgEntry.SETRANGE("Location Code",TrackingSpecification."Location Code");

//         IF TrackingSpecification."Bin Code" <> '' THEN BEGIN
//           UseWarehouseEntries := TRUE;
//           Item.GET(TrackingSpecification."Item No.");
//           IF Item."Item Tracking Code" <> '' THEN
//             ItemTrackingCode.GET(Item."Item Tracking Code");
//         END;

//         ItemLedgEntry.SETFILTER("Lot No.",'<>%1','');
//         ReservEntry.SETFILTER("Lot No.",'<>%1','');
//         IF UseWarehouseEntries THEN
//             UseWarehouseEntries := ItemTrackingCode."Lot Warehouse Tracking";

//         IF ItemLedgEntry.FIND('-') THEN
//           REPEAT
//             ItemLedgEntry2.COPY(ItemLedgEntry);
//             IF UseWarehouseEntries THEN BEGIN
//               ItemLedgEntry2.SETRANGE("Serial No.",ItemLedgEntry."Serial No.");
//               ItemLedgEntry2.SETRANGE("Lot No.",ItemLedgEntry."Lot No.");
//               ItemLedgEntry2.CALCSUMS("Remaining Quantity");

//               InsertRec := FALSE;
//               WarehouseEntry.RESET;
//               WarehouseEntry.SETCURRENTKEY(
//                 "Item No.","Bin Code","Location Code","Variant Code",
//                 "Unit of Measure Code","Lot No.","Serial No.");
//               WarehouseEntry.SETRANGE("Item No.",TrackingSpecification."Item No.");
//               WarehouseEntry.SETRANGE("Bin Code",TrackingSpecification."Bin Code");
//               WarehouseEntry.SETRANGE("Location Code",TrackingSpecification."Location Code");
//               WarehouseEntry.SETRANGE("Variant Code",TrackingSpecification."Variant Code");
//               WarehouseEntry.SETRANGE("Lot No.",ItemLedgEntry."Lot No.");
//               WarehouseEntry.CALCSUMS("Qty. (Base)");
//               IF WarehouseEntry."Qty. (Base)" > 0 THEN BEGIN
//                 InsertRec := TRUE;
//                 IF ItemLedgEntry2."Remaining Quantity" > WarehouseEntry."Qty. (Base)" THEN
//                   ItemLedgEntry2."Remaining Quantity" := WarehouseEntry."Qty. (Base)";
//               END;
//             END ELSE
//               InsertRec := TRUE;

//             IF UseWarehouseEntries THEN BEGIN
//               TempReservEntry.SETRANGE("Serial No.",ItemLedgEntry."Serial No.");
//               TempReservEntry.SETRANGE("Lot No.",ItemLedgEntry."Lot No.");
//               IF TempReservEntry.FIND('-') THEN
//                 InsertRec := FALSE;
//             END;
//             TempReservEntry.INIT;
//             TempReservEntry."Entry No." := -ItemLedgEntry."Entry No.";
//             TempReservEntry."Reservation Status" := ReservEntry."Reservation Status"::Surplus;
//             TempReservEntry.Positive := ItemLedgEntry.Positive;
//             TempReservEntry."Item No." := ItemLedgEntry."Item No.";
//             TempReservEntry."Location Code" := ItemLedgEntry."Location Code";
//             TempReservEntry."Quantity (Base)" := ItemLedgEntry2."Remaining Quantity";
//             TempReservEntry."Source Type" := DATABASE::"Item Ledger Entry";
//             TempReservEntry."Source Ref. No." := ItemLedgEntry."Entry No.";
//             TempReservEntry."Serial No." := ItemLedgEntry."Serial No.";
//             TempReservEntry."Lot No." := ItemLedgEntry."Lot No.";
//             TempReservEntry."Variant Code" := ItemLedgEntry."Variant Code";
//             IF TempReservEntry.Positive THEN BEGIN
//               TempReservEntry."Warranty Date" := ItemLedgEntry."Warranty Date";
//               TempReservEntry."Expiration Date" := ItemLedgEntry."Expiration Date";
//               //TempReservEntry."Expiration Date" := ItemLedgEntry."Posting Date";
//               TempReservEntry."Expected Receipt Date" := 0D
//             END ELSE BEGIN
//               TempReservEntry."Shipment Date" := 12319999D;
//               //TempReservEntry."Expiration Date" := ItemLedgEntry."Posting Date";
//               TempReservEntry."Expiration Date" := ItemLedgEntry."Expiration Date";
//             END;

//             IF InsertRec THEN
//               TempReservEntry.INSERT;
//           UNTIL ItemLedgEntry.NEXT = 0;

//         IF ReservEntry.FIND('-') THEN REPEAT
//           IF IsValidBinCode(ReservEntry,TrackingSpecification."Bin Code") OR
//              NOT UseWarehouseEntries
//           THEN BEGIN
//             TempReservEntry := ReservEntry;
//             TempReservEntry.INSERT;
//           END;
//         UNTIL ReservEntry.NEXT = 0;

//         TempReservEntry.RESET;
//         IF TempReservEntry.FIND('-') THEN
//           REPEAT
//             TempEntrySummary.SETRANGE("Lot No.",TempReservEntry."Lot No.");

//             IF NOT TempEntrySummary.FIND('-') THEN BEGIN
//               TempEntrySummary.INIT;
//               TempEntrySummary."Entry No." := LastEntryNo + 1;
//               LastEntryNo := TempEntrySummary."Entry No.";
//               TempEntrySummary."Table ID" := TempReservEntry."Source Type";
//               TempEntrySummary."Summary Type" := '';
//               TempEntrySummary."Lot No." := TempReservEntry."Lot No.";
//               TempEntrySummary.INSERT;
//             END;

//             IF TempReservEntry.Positive THEN BEGIN
//               TempEntrySummary."Warranty Date" := TempReservEntry."Warranty Date";
//               TempEntrySummary."Expiration Date" := TempReservEntry."Expiration Date";
//               IF TempReservEntry."Entry No." < 0 THEN
//                 TempEntrySummary."Total Quantity" += TempReservEntry."Quantity (Base)";
//               IF TempReservEntry."Reservation Status" = TempReservEntry."Reservation Status"::Reservation THEN
//                 TempEntrySummary."Total Reserved Quantity" += TempReservEntry."Quantity (Base)";
//             END ELSE BEGIN
//               TempEntrySummary."Total Requested Quantity" -= TempReservEntry."Quantity (Base)";
//               //IF (TempEntrySummary."Total Requested Quantity" = 12) THEN
//               //  MESSAGE('Entry No. %1, Document No. %2',TempReservEntry."Entry No.",TempReservEntry."Source ID");
//               /*
//                 MESSAGE('Lot %1 Avai Qty is %2, Total Qty is %3, Total Requested Qty %4, Current reserved qty %5'
//                 ,TempEntrySummary."Lot No.",TempEntrySummary."Total Available Quantity",TempEntrySummary."Total Quantity",
//                 TempEntrySummary."Total Requested Quantity",TempEntrySummary."Current Reserved Quantity");
//               */
//               IF (TempReservEntry."Reservation Status" = TempReservEntry."Reservation Status"::Reservation) AND
//                  (TempReservEntry."Source Type" = TrackingSpecification."Source Type") AND
//                  (TempReservEntry."Source Subtype" = TrackingSpecification."Source Subtype") AND
//                  (TempReservEntry."Source ID" = TrackingSpecification."Source ID") AND
//                  (TempReservEntry."Source Batch Name" = TrackingSpecification."Source Batch Name") AND
//                  (TempReservEntry."Source Prod. Order Line" = TrackingSpecification."Source Prod. Order Line") AND
//                  (TempReservEntry."Source Ref. No." = TrackingSpecification."Source Ref. No.")
//                THEN
//                 TempEntrySummary."Current Reserved Quantity" -= TempReservEntry."Quantity (Base)";
//             END;

//             TempEntrySummary."Total Available Quantity" :=
//               TempEntrySummary."Total Quantity" -
//               TempEntrySummary."Total Requested Quantity" +
//               TempEntrySummary."Current Reserved Quantity";
//             TempEntrySummary.MODIFY;
//           UNTIL TempReservEntry.NEXT = 0;

//         //Start FIFO
//         lReservEntry.RESET;
//         IF lReservEntry.FIND('+') THEN EntryNo := lReservEntry."Entry No." + 1
//         ELSE EntryNo := 1;

//         QtyOrder := TransLine."Qty. to Ship";

//         /*Start: TJCSG1.00 #1*/
//         Item.RESET;
//         IF Item.GET(TransLine."Item No.") THEN;
//         IF TransLine."Unit of Measure Code" <> Item."Base Unit of Measure" THEN
//         BEGIN
//           ItemUnitOfMeasure.RESET;
//           IF ItemUnitOfMeasure.GET(TransLine."Item No.",TransLine."Unit of Measure Code") THEN
//             QtyOrder := QtyOrder * ItemUnitOfMeasure."Qty. per Unit of Measure";
//         END;
//         /*End: TJCSG1.00 #1*/

//         /*
//         TempEntrySummary.RESET;
//         TempEntrySummary.SETFILTER("Total Available Quantity",'>%1',0);
//         IF TempEntrySummary.FINDFIRST THEN REPEAT
//           //MESSAGE(TempEntrySummary."Lot No.");
//           MESSAGE('Lot %1 Avai Qty is %2, Total Qty is %3, Total Requested Qty %4, Current reserved qty %5'
//           ,TempEntrySummary."Lot No.",TempEntrySummary."Total Available Quantity",TempEntrySummary."Total Quantity",
//           TempEntrySummary."Total Requested Quantity",TempEntrySummary."Current Reserved Quantity");
//         UNTIL TempEntrySummary.NEXT = 0;
//         */
//         TempEntrySummary.RESET;
//         TempEntrySummary.SETCURRENTKEY("Expiration Date");
//         //DP.NCM 21012015 DD 298 - Sort for Expiration Date not blank
//         TempEntrySummary.SETFILTER("Expiration Date",'<>%1',0D);
//         TempEntrySummary.ASCENDING(TRUE);
//         //DP.NCM 21012015 DD 298
//         TempEntrySummary.SETFILTER("Total Available Quantity",'>%1',0);
//         IF TempEntrySummary.FIND('-') THEN
//         REPEAT
//           IF TempEntrySummary."Total Available Quantity" - QtyOrder >= 0 THEN
//           BEGIN
//               EntryNo += 1;
//               lReservEntry.INIT;
//               lReservEntry."Entry No." := EntryNo;
//               lReservEntry."Item No."  := TransLine."Item No.";
//               lReservEntry."Location Code" := TransLine."Transfer-from Code";
//               lReservEntry."Quantity (Base)" := QtyOrder * -1;
//               lReservEntry.VALIDATE(lReservEntry."Quantity (Base)");
//               lReservEntry."Reservation Status" := lReservEntry."Reservation Status"::Surplus;
//               lReservEntry."Creation Date" := WORKDATE;
//               lReservEntry."Source Type" := DATABASE::"Transfer Line";
//               lReservEntry."Source Subtype" := 0;
//               lReservEntry.Positive := FALSE;
//               lReservEntry."Source ID" := TransLine."Document No.";
//               lReservEntry."Source Ref. No." := TransLine."Line No.";
//               lReservEntry."Created By" := USERID;
//               lReservEntry."Qty. per Unit of Measure" := TransLine."Qty. per Unit of Measure";
//               lReservEntry."Lot No." := TempEntrySummary."Lot No.";
//               lReservEntry."Expiration Date" := TempEntrySummary."Expiration Date";
//               lReservEntry."Source Prod. Order Line" := TransLine."Derived From Line No.";
//               lReservEntry.INSERT;

//               EntryNo += 1;
//               lReservEntry.INIT;
//               lReservEntry."Entry No." := EntryNo;
//               lReservEntry."Item No."  := TransLine."Item No.";
//               lReservEntry."Location Code" := TransLine."Transfer-to Code";
//               lReservEntry."Quantity (Base)" := QtyOrder;
//               lReservEntry.VALIDATE(lReservEntry."Quantity (Base)");
//               lReservEntry."Reservation Status" := lReservEntry."Reservation Status"::Surplus;
//               lReservEntry."Creation Date" := WORKDATE;
//               lReservEntry."Source Type" := DATABASE::"Transfer Line";
//               lReservEntry."Source Subtype" := 1;
//               lReservEntry.Positive := TRUE;
//               lReservEntry."Source ID" := TransLine."Document No.";
//               lReservEntry."Source Ref. No." := TransLine."Line No.";
//               lReservEntry."Created By" := USERID;
//               lReservEntry."Qty. per Unit of Measure" := TransLine."Qty. per Unit of Measure";
//               lReservEntry."Lot No." := TempEntrySummary."Lot No.";
//               lReservEntry."Expiration Date" := TempEntrySummary."Expiration Date";
//               lReservEntry."Source Prod. Order Line" := TransLine."Derived From Line No.";
//               lReservEntry.INSERT;
//               QtyOrder := 0;

//           END
//           ELSE BEGIN
//               EntryNo += 1;
//               QtyOrder := QtyOrder - TempEntrySummary."Total Available Quantity";
//               lReservEntry.INIT;
//               lReservEntry."Entry No." := EntryNo;
//               lReservEntry."Item No."  := TransLine."Item No.";
//               lReservEntry."Location Code" := TransLine."Transfer-from Code";
//               lReservEntry."Quantity (Base)" := TempEntrySummary."Total Available Quantity" * -1;
//               lReservEntry.VALIDATE(lReservEntry."Quantity (Base)");
//               lReservEntry."Reservation Status" := lReservEntry."Reservation Status"::Surplus;
//               lReservEntry."Creation Date" := WORKDATE;
//               lReservEntry."Source Type" := DATABASE::"Transfer Line";
//               lReservEntry."Source Subtype" := 0;
//               lReservEntry.Positive := FALSE;
//               lReservEntry."Source ID" := TransLine."Document No.";
//               lReservEntry."Source Ref. No." := TransLine."Line No.";
//               lReservEntry."Created By" := USERID;
//               lReservEntry."Qty. per Unit of Measure" := TransLine."Qty. per Unit of Measure";
//               lReservEntry."Lot No." := TempEntrySummary."Lot No.";
//               lReservEntry."Expiration Date" := TempEntrySummary."Expiration Date";
//               lReservEntry."Source Prod. Order Line" := TransLine."Derived From Line No.";
//               lReservEntry.INSERT;

//               EntryNo += 1;
//               lReservEntry.INIT;
//               lReservEntry."Entry No." := EntryNo;
//               lReservEntry."Item No."  := TransLine."Item No.";
//               lReservEntry."Location Code" := TransLine."Transfer-to Code";
//               lReservEntry."Quantity (Base)" := TempEntrySummary."Total Available Quantity";
//               lReservEntry.VALIDATE(lReservEntry."Quantity (Base)");
//               lReservEntry."Reservation Status" := lReservEntry."Reservation Status"::Surplus;
//               lReservEntry."Creation Date" := WORKDATE;
//               lReservEntry."Source Type" := DATABASE::"Transfer Line";
//               lReservEntry."Source Subtype" := 1;
//               lReservEntry.Positive := TRUE;
//               lReservEntry."Source ID" := TransLine."Document No.";
//               lReservEntry."Source Ref. No." := TransLine."Line No.";
//               lReservEntry."Created By" := USERID;
//               lReservEntry."Qty. per Unit of Measure" := TransLine."Qty. per Unit of Measure";
//               lReservEntry."Lot No." := TempEntrySummary."Lot No.";
//               lReservEntry."Expiration Date" := TempEntrySummary."Expiration Date";
//               lReservEntry."Source Prod. Order Line" := TransLine."Derived From Line No.";
//               lReservEntry.INSERT;
//           END;
//           EntryNo += 1;
//         UNTIL (QtyOrder <= 0) OR (TempEntrySummary.NEXT = 0);

//         TempEntrySummary.RESET;
//         TempEntrySummary.SETCURRENTKEY("Expiration Date");
//         //DP.NCM 21012015 DD 298 - Sort for Expiration Date blank
//         TempEntrySummary.SETFILTER("Expiration Date",'%1',0D);
//         //DP.NCM 21012015 DD 298
//         TempEntrySummary.SETFILTER("Total Available Quantity",'>%1',0);
//         IF TempEntrySummary.FIND('-') AND (QtyOrder > 0) THEN
//         REPEAT
//           IF TempEntrySummary."Total Available Quantity" - QtyOrder >= 0 THEN
//           BEGIN
//               EntryNo += 1;
//               lReservEntry.INIT;
//               lReservEntry."Entry No." := EntryNo;
//               lReservEntry."Item No."  := TransLine."Item No.";
//               lReservEntry."Location Code" := TransLine."Transfer-from Code";
//               lReservEntry."Quantity (Base)" := QtyOrder * -1;
//               lReservEntry.VALIDATE(lReservEntry."Quantity (Base)");
//               lReservEntry."Reservation Status" := lReservEntry."Reservation Status"::Surplus;
//               lReservEntry."Creation Date" := WORKDATE;
//               lReservEntry."Source Type" := DATABASE::"Transfer Line";
//               lReservEntry."Source Subtype" := 0;
//               lReservEntry.Positive := FALSE;
//               lReservEntry."Source ID" := TransLine."Document No.";
//               lReservEntry."Source Ref. No." := TransLine."Line No.";
//               lReservEntry."Created By" := USERID;
//               lReservEntry."Qty. per Unit of Measure" := TransLine."Qty. per Unit of Measure";
//               lReservEntry."Lot No." := TempEntrySummary."Lot No.";
//               lReservEntry."Expiration Date" := TempEntrySummary."Expiration Date";
//               lReservEntry."Source Prod. Order Line" := TransLine."Derived From Line No.";
//               lReservEntry.INSERT;

//               EntryNo += 1;
//               lReservEntry.INIT;
//               lReservEntry."Entry No." := EntryNo;
//               lReservEntry."Item No."  := TransLine."Item No.";
//               lReservEntry."Location Code" := TransLine."Transfer-to Code";
//               lReservEntry."Quantity (Base)" := QtyOrder;
//               lReservEntry.VALIDATE(lReservEntry."Quantity (Base)");
//               lReservEntry."Reservation Status" := lReservEntry."Reservation Status"::Surplus;
//               lReservEntry."Creation Date" := WORKDATE;
//               lReservEntry."Source Type" := DATABASE::"Transfer Line";
//               lReservEntry."Source Subtype" := 1;
//               lReservEntry.Positive := TRUE;
//               lReservEntry."Source ID" := TransLine."Document No.";
//               lReservEntry."Source Ref. No." := TransLine."Line No.";
//               lReservEntry."Created By" := USERID;
//               lReservEntry."Qty. per Unit of Measure" := TransLine."Qty. per Unit of Measure";
//               lReservEntry."Lot No." := TempEntrySummary."Lot No.";
//               lReservEntry."Expiration Date" := TempEntrySummary."Expiration Date";
//               lReservEntry."Source Prod. Order Line" := TransLine."Derived From Line No.";
//               lReservEntry.INSERT;

//               QtyOrder := 0;
//           END
//           ELSE BEGIN
//               EntryNo += 1;
//               QtyOrder := QtyOrder - TempEntrySummary."Total Available Quantity";
//               lReservEntry.INIT;
//               lReservEntry."Entry No." := EntryNo;
//               lReservEntry."Item No."  := TransLine."Item No.";
//               lReservEntry."Location Code" := TransLine."Transfer-from Code";
//               lReservEntry."Quantity (Base)" := TempEntrySummary."Total Available Quantity" * -1;
//               lReservEntry.VALIDATE(lReservEntry."Quantity (Base)");
//               lReservEntry."Reservation Status" := lReservEntry."Reservation Status"::Surplus;
//               lReservEntry."Creation Date" := WORKDATE;
//               lReservEntry."Source Type" := DATABASE::"Transfer Line";
//               lReservEntry."Source Subtype" := 0;
//               lReservEntry."Source ID" := TransLine."Document No.";
//               lReservEntry."Source Ref. No." := TransLine."Line No.";
//               lReservEntry."Created By" := USERID;
//               lReservEntry."Qty. per Unit of Measure" := TransLine."Qty. per Unit of Measure";
//               lReservEntry."Lot No." := TempEntrySummary."Lot No.";
//               lReservEntry."Expiration Date" := TempEntrySummary."Expiration Date";
//               lReservEntry."Source Prod. Order Line" := TransLine."Derived From Line No.";
//               lReservEntry.INSERT;

//               EntryNo += 1;
//               lReservEntry.INIT;
//               lReservEntry."Entry No." := EntryNo;
//               lReservEntry."Item No."  := TransLine."Item No.";
//               lReservEntry."Location Code" := TransLine."Transfer-to Code";
//               //DP.NCM 14/03/2016
//               //lReservEntry."Quantity (Base)" := TempEntrySummary."Total Available Quantity" * -1;
//               lReservEntry."Quantity (Base)" := TempEntrySummary."Total Available Quantity";
//               //DP.NCM 14/03/2016
//               lReservEntry.VALIDATE(lReservEntry."Quantity (Base)");
//               lReservEntry."Reservation Status" := lReservEntry."Reservation Status"::Surplus;
//               lReservEntry."Creation Date" := WORKDATE;
//               lReservEntry."Source Type" := DATABASE::"Transfer Line";
//               lReservEntry."Source Subtype" := 1;
//               lReservEntry.Positive := TRUE;
//               lReservEntry."Source ID" := TransLine."Document No.";
//               lReservEntry."Source Ref. No." := TransLine."Line No.";
//               lReservEntry."Created By" := USERID;
//               lReservEntry."Qty. per Unit of Measure" := TransLine."Qty. per Unit of Measure";
//               lReservEntry."Lot No." := TempEntrySummary."Lot No.";
//               lReservEntry."Expiration Date" := TempEntrySummary."Expiration Date";
//               lReservEntry."Source Prod. Order Line" := TransLine."Derived From Line No.";
//               lReservEntry.INSERT;
//           END;
//           EntryNo += 1;
//         UNTIL (QtyOrder <= 0) OR (TempEntrySummary.NEXT = 0);

//     end;

//     local procedure IsValidBinCode(ReservEntry: Record "337";BinCode: Code[20]): Boolean
//     var
//         RecRef: RecordRef;
//         FieldRef: FieldRef;
//         RecordID: RecordID;
//     begin
//         WITH ReservEntry DO BEGIN
//           IF Positive THEN BEGIN
//             SETRANGE("Entry No.","Entry No.");
//             SETRANGE(Positive,FALSE);
//             IF FIND('-') THEN;
//           END;

//           RecRef.OPEN("Source Type");
//           EVALUATE(RecordID,GetRecordID(ReservEntry));
//           IF RecRef.GET(RecordID) THEN BEGIN
//             FieldRef := RecRef.FIELD(GetFieldNo("Source Type"));
//             IF BinCode = FORMAT(FieldRef.VALUE) THEN
//               EXIT(TRUE);
//           END;
//         END;
//     end;

//     local procedure GetRecordID(ReservEntry: Record "337"): Text[250]
//     begin
//         WITH ReservEntry DO BEGIN
//           CASE "Source Type" OF
//             DATABASE::"Item Journal Line":
//               EXIT(STRSUBSTNO('%1:%2,%3,%4',"Source Type","Source ID","Source Batch Name","Source Ref. No."));
//             DATABASE::"Planning Component":
//               EXIT(
//                 STRSUBSTNO(
//                   '%1:%2,%3,%4',"Source Type","Source ID","Source Batch Name","Source Prod. Order Line","Source Ref. No."));
//             DATABASE::"Transfer Line":
//               EXIT(STRSUBSTNO('%1:%2,%3',"Source Type","Source ID","Source Ref. No."));
//             DATABASE::"Prod. Order Component":
//               EXIT(
//                 STRSUBSTNO(
//                   '%1:%2,%3,%4,%5',"Source Type","Source Subtype","Source ID","Source Prod. Order Line","Source Ref. No."));
//             DATABASE::"Prod. Order Line":
//               EXIT(
//                 STRSUBSTNO(
//                   '%1:%2,%3,%4',"Source Type","Source Subtype","Source ID","Source Prod. Order Line"));
//             ELSE
//               EXIT(STRSUBSTNO('%1:%2,%3,%4',"Source Type","Source Subtype","Source ID","Source Ref. No."));
//           END;
//         END;
//     end;

//     local procedure GetFieldNo(SourceType: Integer): Integer
//     begin
//         CASE SourceType OF
//           DATABASE::"Transfer Line": EXIT(7300);
//           DATABASE::"Prod. Order Component",DATABASE::"Planning Component": EXIT(33);
//           DATABASE::"Prod. Order Line": EXIT(23);
//           ELSE
//             EXIT(5403);
//         END;
//     end;
// }

