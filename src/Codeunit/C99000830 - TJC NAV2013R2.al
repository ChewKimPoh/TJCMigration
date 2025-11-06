// codeunit 99000830 "Create Reserv. Entry"
// {
//     Permissions = TableData 337=rim;

//     trigger OnRun()
//     begin
//     end;

//     var
//         Text000: Label 'You cannot reserve this entry because it is not a true demand or supply.';
//         InsertReservEntry: Record "337";
//         InsertReservEntry2: Record "337";
//         LastReservEntry: Record "337";
//         TempTrkgSpec1: Record "336" temporary;
//         TempTrkgSpec2: Record "336" temporary;
//         Text001: Label 'Cannot match item tracking.';
//         OverruleItemTracking: Boolean;
//         Inbound: Boolean;
//         UseQtyToInvoice: Boolean;
//         QtyToHandleAndInvoiceIsSet: Boolean;

//     procedure CreateEntry(ItemNo: Code[20];VariantCode: Code[10];LocationCode: Code[10];Description: Text[50];ExpectedReceiptDate: Date;ShipmentDate: Date;TransferredFromEntryNo: Integer;Status: Option Reservation,Tracking,Surplus,Prospect)
//     var
//         ReservEntry: Record "337";
//         ReservEntry2: Record "337";
//         ReservMgt: Codeunit "99000845";
//         TrackingSpecificationExists: Boolean;
//         FirstSplit: Boolean;
//     begin
//         TempTrkgSpec1.RESET;
//         TempTrkgSpec2.RESET;
//         TempTrkgSpec1.DELETEALL;
//         TempTrkgSpec2.DELETEALL;

//         // Status Surplus gets special treatment.

//         IF Status < Status::Surplus THEN
//           IF InsertReservEntry."Quantity (Base)" = 0 THEN
//             EXIT;

//         InsertReservEntry.TESTFIELD("Source Type");

//         ReservEntry := InsertReservEntry;
//         ReservEntry."Reservation Status" := Status;
//         ReservEntry."Item No." := ItemNo;
//         ReservEntry."Variant Code" := VariantCode;
//         ReservEntry."Location Code" := LocationCode;
//         ReservEntry.Description := Description;
//         ReservEntry."Creation Date" := WORKDATE;
//         ReservEntry."Created By" := USERID;
//         ReservEntry."Expected Receipt Date" := ExpectedReceiptDate;
//         ReservEntry."Shipment Date" := ShipmentDate;
//         ReservEntry."Transferred from Entry No." := TransferredFromEntryNo;
//         ReservEntry.Positive := (ReservEntry."Quantity (Base)" > 0);
//         IF (ReservEntry."Quantity (Base)" <> 0) AND (ReservEntry.Quantity = 0) THEN
//           ReservEntry.Quantity := ROUND(ReservEntry."Quantity (Base)" / ReservEntry."Qty. per Unit of Measure",0.00001);
//         IF NOT QtyToHandleAndInvoiceIsSet THEN BEGIN
//           ReservEntry."Qty. to Handle (Base)" := ReservEntry."Quantity (Base)";
//           ReservEntry."Qty. to Invoice (Base)" := ReservEntry."Quantity (Base)";
//         END;

//         IF Status < Status::Surplus THEN BEGIN
//           InsertReservEntry2.TESTFIELD("Source Type");

//           ReservEntry2 := ReservEntry;
//           ReservEntry2."Quantity (Base)" := -ReservEntry."Quantity (Base)";
//           ReservEntry2.Quantity := ROUND(ReservEntry2."Quantity (Base)" / InsertReservEntry2."Qty. per Unit of Measure",0.00001);
//           ReservEntry2."Qty. to Handle (Base)" := -ReservEntry."Qty. to Handle (Base)";
//           ReservEntry2."Qty. to Invoice (Base)" := -ReservEntry."Qty. to Invoice (Base)";
//           ReservEntry2.Positive := (ReservEntry2."Quantity (Base)" > 0);
//           ReservEntry2."Source Type" := InsertReservEntry2."Source Type";
//           ReservEntry2."Source Subtype" := InsertReservEntry2."Source Subtype";
//           ReservEntry2."Source ID" := InsertReservEntry2."Source ID";
//           ReservEntry2."Source Batch Name" := InsertReservEntry2."Source Batch Name";
//           ReservEntry2."Source Prod. Order Line" := InsertReservEntry2."Source Prod. Order Line";
//           ReservEntry2."Source Ref. No." := InsertReservEntry2."Source Ref. No.";
//           ReservEntry2."Serial No." := InsertReservEntry2."Serial No.";
//           ReservEntry2."Lot No." := InsertReservEntry2."Lot No.";
//           ReservEntry2."Qty. per Unit of Measure" := InsertReservEntry2."Qty. per Unit of Measure";
//           IF NOT QtyToHandleAndInvoiceIsSet THEN BEGIN
//             ReservEntry2."Qty. to Handle (Base)" := ReservEntry2."Quantity (Base)";
//             ReservEntry2."Qty. to Invoice (Base)" := ReservEntry2."Quantity (Base)";
//           END;

//           IF NOT ReservEntry2.Positive THEN
//             ReservEntry2."Appl.-from Item Entry" := 0
//           ELSE
//             ReservEntry2."Appl.-to Item Entry" := 0;

//           IF Status = Status::Reservation THEN
//             IF TransferredFromEntryNo = 0 THEN BEGIN
//               ReservMgt.MakeRoomForReservation(ReservEntry2);
//               TrackingSpecificationExists :=
//                 ReservMgt.CollectTrackingSpecification(TempTrkgSpec2);
//             END;
//           CheckValidity(ReservEntry2);
//           AdjustDateIfItemLedgerEntry(ReservEntry2);
//         END;

//         IF NOT ReservEntry.Positive THEN
//           ReservEntry."Appl.-from Item Entry" := 0
//         ELSE
//           ReservEntry."Appl.-to Item Entry" := 0;

//         CheckValidity(ReservEntry);
//         AdjustDateIfItemLedgerEntry(ReservEntry);
//         IF Status = Status::Reservation THEN
//           IF TransferredFromEntryNo = 0 THEN BEGIN
//             ReservMgt.MakeRoomForReservation(ReservEntry);
//             TrackingSpecificationExists := TrackingSpecificationExists OR
//               ReservMgt.CollectTrackingSpecification(TempTrkgSpec1);
//           END;

//         IF TrackingSpecificationExists THEN
//           SetupSplitReservEntry(ReservEntry,ReservEntry2);

//         FirstSplit := TRUE;
//         WHILE SplitReservEntry(ReservEntry,ReservEntry2,TrackingSpecificationExists,FirstSplit) DO BEGIN
//           ReservEntry."Entry No." := 0;
//           ReservEntry.UpdateItemTracking;
//           ReservEntry.INSERT;
//           IF Status < Status::Surplus THEN BEGIN
//             ReservEntry2."Entry No." := ReservEntry."Entry No.";
//             ReservEntry2.UpdateItemTracking;
//             ReservEntry2.INSERT;
//           END;
//         END;

//         LastReservEntry := ReservEntry;

//         CLEAR(InsertReservEntry);
//         CLEAR(InsertReservEntry2);
//         CLEAR(QtyToHandleAndInvoiceIsSet);
//     end;

//     procedure CreateReservEntry(ItemNo: Code[20];VariantCode: Code[10];LocationCode: Code[10];Description: Text[50];ExpectedReceiptDate: Date;ShipmentDate: Date)
//     begin
//         CreateEntry(ItemNo,VariantCode,LocationCode,Description,
//           ExpectedReceiptDate,ShipmentDate,0,0);
//     end;

//     procedure CreateReservEntryFor(ForType: Option;ForSubtype: Integer;ForID: Code[20];ForBatchName: Code[10];ForProdOrderLine: Integer;ForRefNo: Integer;ForQtyPerUOM: Decimal;Quantity: Decimal;QuantityBase: Decimal;ForSerialNo: Code[20];ForLotNo: Code[20];ForExpirationDate: Date)
//     var
//         sign: Integer;
//     begin
//         InsertReservEntry."Source Type" := ForType;
//         InsertReservEntry."Source Subtype" := ForSubtype;
//         InsertReservEntry."Source ID" := ForID;
//         InsertReservEntry."Source Batch Name" := ForBatchName;
//         InsertReservEntry."Source Prod. Order Line" := ForProdOrderLine;
//         InsertReservEntry."Source Ref. No." := ForRefNo;
//         sign := SignFactor(InsertReservEntry);
//         InsertReservEntry.Quantity := sign * Quantity;
//         InsertReservEntry."Quantity (Base)" := sign * QuantityBase;
//         InsertReservEntry."Qty. per Unit of Measure" := ForQtyPerUOM;
//         InsertReservEntry."Serial No." := ForSerialNo;
//         InsertReservEntry."Lot No." := ForLotNo;
//         InsertReservEntry."Expiration Date" := ForExpirationDate;

//         InsertReservEntry.TESTFIELD("Qty. per Unit of Measure");
//     end;

//     procedure CreateReservEntryFrom(FromType: Option;FromSubtype: Integer;FromID: Code[20];FromBatchName: Code[10];FromProdOrderLine: Integer;FromRefNo: Integer;FromQtyPerUOM: Decimal;FromSerialNo: Code[20];FromLotNo: Code[20])
//     begin
//         InsertReservEntry2."Source Type" := FromType;
//         InsertReservEntry2."Source Subtype" := FromSubtype;
//         InsertReservEntry2."Source ID" := FromID;
//         InsertReservEntry2."Source Batch Name" := FromBatchName;
//         InsertReservEntry2."Source Prod. Order Line" := FromProdOrderLine;
//         InsertReservEntry2."Source Ref. No." := FromRefNo;
//         InsertReservEntry2."Qty. per Unit of Measure" := FromQtyPerUOM;
//         InsertReservEntry2."Serial No." := FromSerialNo;
//         InsertReservEntry2."Lot No." := FromLotNo;

//         InsertReservEntry2.TESTFIELD("Qty. per Unit of Measure");
//     end;

//     procedure SetBinding(Binding: Option " ","Order-to-Order")
//     begin
//         InsertReservEntry.Binding := Binding;
//         InsertReservEntry2.Binding := Binding;
//     end;

//     procedure SetPlanningFlexibility(Flexibility: Option Unlimited,"None")
//     begin
//         InsertReservEntry."Planning Flexibility" := Flexibility;
//         InsertReservEntry2."Planning Flexibility" := Flexibility;
//     end;

//     procedure SetDates(WarrantyDate: Date;ExpirationDate: Date)
//     begin
//         InsertReservEntry."Warranty Date" := WarrantyDate;
//         InsertReservEntry."Expiration Date" := ExpirationDate;
//     end;

//     procedure SetQtyToHandleAndInvoice(QtyToHandleBase: Decimal;QtyToInvoiceBase: Decimal)
//     begin
//         InsertReservEntry."Qty. to Handle (Base)" := QtyToHandleBase;
//         InsertReservEntry."Qty. to Invoice (Base)" := QtyToInvoiceBase;
//         QtyToHandleAndInvoiceIsSet := TRUE;
//     end;

//     procedure SetNewSerialLotNo(NewSerialNo: Code[20];NewLotNo: Code[20])
//     begin
//         InsertReservEntry."New Serial No." := NewSerialNo;
//         InsertReservEntry."New Lot No." := NewLotNo;
//     end;

//     procedure SetNewExpirationDate(NewExpirationDate: Date)
//     begin
//         InsertReservEntry."New Expiration Date" := NewExpirationDate;
//     end;

//     procedure SetDisallowCancellation(NewDisallowCancellation: Boolean)
//     begin
//         InsertReservEntry."Disallow Cancellation" := NewDisallowCancellation;
//     end;

//     procedure CreateRemainingReservEntry(var OldReservEntry: Record "337";RemainingQuantity: Decimal;RemainingQuantityBase: Decimal)
//     var
//         OldReservEntry2: Record "337";
//     begin
//         CreateReservEntryFor(
//           OldReservEntry."Source Type",OldReservEntry."Source Subtype",
//           OldReservEntry."Source ID",OldReservEntry."Source Batch Name",
//           OldReservEntry."Source Prod. Order Line",OldReservEntry."Source Ref. No.",
//           OldReservEntry."Qty. per Unit of Measure",RemainingQuantity,RemainingQuantityBase,
//           OldReservEntry."Serial No.",OldReservEntry."Lot No.",OldReservEntry."Expiration Date");
//         //InsertReservEntry."Warranty Date" := OldReservEntry."Warranty Date";
//         //InsertReservEntry."Expiration Date" := OldReservEntry."Expiration Date";

//         IF OldReservEntry."Reservation Status" < OldReservEntry."Reservation Status"::Surplus THEN
//           IF OldReservEntry2.GET(OldReservEntry."Entry No.",NOT OldReservEntry.Positive) THEN BEGIN // Get the related entry
//             CreateReservEntryFrom(
//               OldReservEntry2."Source Type",OldReservEntry2."Source Subtype",
//               OldReservEntry2."Source ID",OldReservEntry2."Source Batch Name",
//               OldReservEntry2."Source Prod. Order Line",OldReservEntry2."Source Ref. No.",OldReservEntry2."Qty. per Unit of Measure",
//               OldReservEntry2."Serial No.",OldReservEntry2."Lot No.");
//             InsertReservEntry2."Warranty Date" := OldReservEntry2."Warranty Date";
//             InsertReservEntry2."Expiration Date" := OldReservEntry2."Expiration Date";
//           END;
//         CreateEntry(
//           OldReservEntry."Item No.",OldReservEntry."Variant Code",
//           OldReservEntry."Location Code",OldReservEntry.Description,
//           OldReservEntry."Expected Receipt Date",OldReservEntry."Shipment Date",
//           OldReservEntry."Entry No.",OldReservEntry."Reservation Status");
//     end;

//     procedure TransferReservEntry(NewType: Option;NewSubtype: Integer;NewID: Code[20];NewBatchName: Code[10];NewProdOrderLine: Integer;NewRefNo: Integer;QtyPerUOM: Decimal;OldReservEntry: Record "337";TransferQty: Decimal): Decimal
//     var
//         NewReservEntry: Record "337";
//         ReservEntry: Record "337";
//         Location: Record "14";
//         ItemTrkgMgt: Codeunit "6500";
//         CurrSignFactor: Integer;
//         xTransferQty: Decimal;
//         QtyToHandleThisLine: Decimal;
//         QtyToInvoiceThisLine: Decimal;
//         QtyInvoiced: Decimal;
//         CarriedSerialNo: Code[20];
//         CarriedLotNo: Code[20];
//         UseQtyToHandle: Boolean;
//         SNRequired: Boolean;
//         LNRequired: Boolean;
//     begin
//         IF TransferQty = 0 THEN
//           EXIT;

//         UseQtyToHandle :=
//           ((OldReservEntry."Serial No." <> '') OR (OldReservEntry."Lot No." <> '')) AND
//           NOT OverruleItemTracking;

//         CurrSignFactor := SignFactor(OldReservEntry);
//         TransferQty := TransferQty * CurrSignFactor;
//         xTransferQty := TransferQty;

//         IF UseQtyToHandle THEN BEGIN // Used when handling Item Tracking
//           QtyToHandleThisLine := OldReservEntry."Qty. to Handle (Base)";
//           QtyToInvoiceThisLine := OldReservEntry."Qty. to Invoice (Base)";
//           IF ABS(TransferQty) > ABS(QtyToHandleThisLine) THEN
//             TransferQty := QtyToHandleThisLine;
//           IF UseQtyToInvoice THEN BEGIN // Used when posting sales and purchase
//             IF ABS(TransferQty) > ABS(QtyToInvoiceThisLine) THEN
//               TransferQty := QtyToInvoiceThisLine;
//           END;
//         END ELSE
//           QtyToHandleThisLine := OldReservEntry."Quantity (Base)";

//         IF QtyToHandleThisLine = 0 THEN
//           EXIT(xTransferQty * CurrSignFactor);

//         NewReservEntry.TRANSFERFIELDS(OldReservEntry,FALSE);

//         NewReservEntry."Entry No." := OldReservEntry."Entry No.";
//         NewReservEntry.Positive := OldReservEntry.Positive;
//         NewReservEntry."Source Type" := NewType;
//         NewReservEntry."Source Subtype" := NewSubtype;
//         NewReservEntry."Source ID" := NewID;
//         NewReservEntry."Source Batch Name" := NewBatchName;
//         NewReservEntry."Source Prod. Order Line" := NewProdOrderLine;
//         NewReservEntry."Source Ref. No." := NewRefNo;
//         NewReservEntry."Qty. per Unit of Measure" := QtyPerUOM;

//         // Item Tracking on consumption, output and drop shipment:
//         IF (NewType = DATABASE::"Item Journal Line") AND (NewSubtype IN [3,5,6]) OR OverruleItemTracking THEN
//           IF (InsertReservEntry."New Serial No." <> '') OR (InsertReservEntry."New Lot No." <> '') THEN BEGIN
//             NewReservEntry."Serial No." := InsertReservEntry."New Serial No.";
//             NewReservEntry."Lot No." := InsertReservEntry."New Lot No.";
//             IF NewReservEntry."Qty. to Handle (Base)" = 0 THEN
//               NewReservEntry."Qty. to Handle (Base)" := NewReservEntry."Quantity (Base)";
//             InsertReservEntry."New Serial No." := '';
//             InsertReservEntry."New Lot No." := '';

//             // If an order-to-order supply is being posted, item tracking must be carried to the related demand:
//             IF (TransferQty >= 0) AND (NewReservEntry.Binding = NewReservEntry.Binding::"Order-to-Order") THEN BEGIN
//               CarriedSerialNo := NewReservEntry."Serial No.";
//               CarriedLotNo := NewReservEntry."Lot No.";
//               IF NOT UseQtyToHandle THEN
//                 // the IT is set only in Consumption/Output Journal and we need to update all fields properly
//                 QtyToInvoiceThisLine := NewReservEntry."Quantity (Base)";
//             END;
//           END;

//         IF InsertReservEntry."Item Ledger Entry No." <> 0 THEN BEGIN
//           NewReservEntry."Item Ledger Entry No." := InsertReservEntry."Item Ledger Entry No.";
//           InsertReservEntry."Item Ledger Entry No." := 0;
//         END;

//         IF NewReservEntry."Source Type" = DATABASE::"Item Ledger Entry" THEN
//           IF NewReservEntry."Quantity (Base)" > 0 THEN
//             NewReservEntry."Expected Receipt Date" := 0D
//           ELSE
//             NewReservEntry."Shipment Date" := 12319999D;

//         NewReservEntry.UpdateItemTracking;

//         IF (TransferQty >= 0) <> OldReservEntry.Positive THEN BEGIN // If sign has swapped due to negative posting
//           // Create a new but unchanged version of the original reserventry:
//           SetQtyToHandleAndInvoice(QtyToHandleThisLine,QtyToInvoiceThisLine);
//           CreateRemainingReservEntry(OldReservEntry,
//             OldReservEntry.Quantity * CurrSignFactor,
//             OldReservEntry."Quantity (Base)" * CurrSignFactor);
//           NewReservEntry.VALIDATE("Quantity (Base)",TransferQty);
//           // Correct primary key - swap "Positive":
//           NewReservEntry.Positive := NOT NewReservEntry.Positive;

//           IF NOT ReservEntry.GET(NewReservEntry."Entry No.",NewReservEntry.Positive) THEN BEGIN
//             // Means that only one record exists = surplus or prospect
//             NewReservEntry.INSERT;
//             // Delete the original record:
//             NewReservEntry.Positive := NOT NewReservEntry.Positive;
//             NewReservEntry.DELETE;
//           END ELSE BEGIN // A set of records exist = reservation or tracking
//             NewReservEntry.MODIFY;
//             // Get the original record and modify quantity:
//             NewReservEntry.GET(NewReservEntry."Entry No.",NOT NewReservEntry.Positive); // Get partner-record
//             NewReservEntry.VALIDATE("Quantity (Base)",-TransferQty);
//             NewReservEntry.MODIFY;
//           END;
//         END ELSE
//           IF ABS(TransferQty) < ABS(OldReservEntry."Quantity (Base)") THEN BEGIN
//             IF OldReservEntry.Binding = OldReservEntry.Binding::"Order-to-Order" THEN
//               SetBinding(OldReservEntry.Binding::"Order-to-Order");
//             IF OldReservEntry."Disallow Cancellation" THEN
//               SetDisallowCancellation(OldReservEntry."Disallow Cancellation");
//             IF ABS(QtyToInvoiceThisLine) > ABS(TransferQty) THEN
//               QtyInvoiced := TransferQty
//             ELSE
//               QtyInvoiced := QtyToInvoiceThisLine;
//             SetQtyToHandleAndInvoice(QtyToHandleThisLine - TransferQty,QtyToInvoiceThisLine - QtyInvoiced);
//             CreateRemainingReservEntry(OldReservEntry,
//               0,(OldReservEntry."Quantity (Base)" - TransferQty) * CurrSignFactor);
//             NewReservEntry.VALIDATE("Quantity (Base)",TransferQty);
//             NewReservEntry.MODIFY;
//             IF NewReservEntry.GET(NewReservEntry."Entry No.",NOT NewReservEntry.Positive) THEN BEGIN // Get partner-record
//               NewReservEntry.VALIDATE("Quantity (Base)",-TransferQty);
//               NewReservEntry.MODIFY;
//             END;
//           END ELSE BEGIN
//             NewReservEntry.MODIFY;
//             TransferQty := NewReservEntry."Quantity (Base)";
//             IF NewReservEntry."Source Type" = DATABASE::"Item Ledger Entry" THEN BEGIN
//               IF NewReservEntry.GET(NewReservEntry."Entry No.",NOT NewReservEntry.Positive) THEN BEGIN // Get partner-record
//                 IF NewReservEntry."Quantity (Base)" < 0 THEN
//                   NewReservEntry."Expected Receipt Date" := 0D
//                 ELSE
//                   NewReservEntry."Shipment Date" := 12319999D;
//                 NewReservEntry.MODIFY;
//               END;

//               // If necessary create Whse. Item Tracking Lines
//               IF (NewReservEntry."Source Type" = DATABASE::"Sales Line") AND
//                  (OldReservEntry."Source Type" = DATABASE::"Item Journal Line") AND
//                  (OldReservEntry."Reservation Status" = OldReservEntry."Reservation Status"::Reservation)
//               THEN BEGIN
//                 ItemTrkgMgt.CheckWhseItemTrkgSetup(OldReservEntry."Item No.",SNRequired,LNRequired,FALSE);
//                 IF (SNRequired OR LNRequired) AND
//                    Location.RequireShipment(OldReservEntry."Location Code")
//                 THEN
//                   CreateWhseItemTrkgLines(NewReservEntry);
//               END;
//             END ELSE
//               IF (CarriedSerialNo + CarriedLotNo) <> '' THEN
//                 NewReservEntry.GET(NewReservEntry."Entry No.",NOT NewReservEntry.Positive); // Get partner-record
//           END;

//         IF (CarriedSerialNo + CarriedLotNo) <> '' THEN BEGIN
//           IF NewReservEntry."Qty. to Handle (Base)" = 0 THEN
//             NewReservEntry.VALIDATE("Quantity (Base)");
//           NewReservEntry."Serial No." := CarriedSerialNo;
//           NewReservEntry."Lot No." := CarriedLotNo;
//           NewReservEntry.UpdateItemTracking;
//           IF NewReservEntry.MODIFY THEN ;
//         END;

//         xTransferQty -= TransferQty;
//         EXIT(xTransferQty * CurrSignFactor);
//     end;

//     procedure SignFactor(var ReservEntry: Record "337"): Integer
//     begin
//         // Demand is regarded as negative, supply is regarded as positive.
//         CASE ReservEntry."Source Type" OF
//           DATABASE::"Sales Line":
//             IF ReservEntry."Source Subtype" IN [3,5] THEN // Credit memo, Return Order = supply
//               EXIT(1)
//             ELSE
//               EXIT(-1);
//           DATABASE::"Requisition Line":
//             IF ReservEntry."Source Subtype" = 1 THEN
//               EXIT(-1)
//             ELSE
//               EXIT(1);
//           DATABASE::"Purchase Line":
//             IF ReservEntry."Source Subtype" IN [3,5] THEN // Credit memo, Return Order = demand
//               EXIT(-1)
//             ELSE
//               EXIT(1);
//           DATABASE::"Item Journal Line":
//             IF (ReservEntry."Source Subtype" = 4) AND Inbound THEN
//               EXIT(1)
//             ELSE
//               IF ReservEntry."Source Subtype" IN [1,3,4,5] THEN // Sale, Negative Adjmt., Transfer, Consumption
//                 EXIT(-1)
//               ELSE
//                 EXIT(1);
//           DATABASE::"Job Journal Line":
//             EXIT(-1);
//           DATABASE::"Item Ledger Entry":
//             EXIT(1);
//           DATABASE::"Prod. Order Line":
//             EXIT(1);
//           DATABASE::"Prod. Order Component":
//             EXIT(-1);
//           DATABASE::"Assembly Header":
//             EXIT(1);
//           DATABASE::"Assembly Line":
//             EXIT(-1);
//           DATABASE::"Planning Component":
//             EXIT(-1);
//           DATABASE::"Transfer Line":
//             IF ReservEntry."Source Subtype" = 0 THEN // Outbound
//               EXIT(-1)
//             ELSE
//               EXIT(1);
//           DATABASE::"Service Line":
//             IF ReservEntry."Source Subtype" IN [3] THEN // Credit memo
//               EXIT(1)
//             ELSE
//               EXIT(-1);
//           DATABASE::"Job Planning Line":
//             EXIT(-1);
//         END;
//     end;

//     procedure CheckValidity(var ReservEntry: Record "337")
//     var
//         IsError: Boolean;
//     begin
//         IF ReservEntry."Reservation Status" <> ReservEntry."Reservation Status"::Reservation THEN
//           EXIT;

//         CASE ReservEntry."Source Type" OF
//           DATABASE::"Sales Line":
//             IsError := NOT (ReservEntry."Source Subtype" IN [1,5]);
//           DATABASE::"Purchase Line":
//             IsError := NOT (ReservEntry."Source Subtype" IN [1,5]);
//           DATABASE::"Prod. Order Line",
//           DATABASE::"Prod. Order Component":
//             IsError := (ReservEntry."Source Subtype" = 4) OR
//               ((ReservEntry."Source Subtype" = 1) AND (ReservEntry.Binding = ReservEntry.Binding::" "));
//           DATABASE::"Assembly Header",
//           DATABASE::"Assembly Line":
//             IsError := NOT (ReservEntry."Source Subtype" = 1); // Only Assembly Order supported
//           DATABASE::"Requisition Line",
//           DATABASE::"Planning Component":
//             IsError := ReservEntry.Binding = ReservEntry.Binding::" ";
//           DATABASE::"Item Journal Line":
//             // Item Journal Lines with Entry Type Transfer can carry reservations during posting:
//             IsError := (ReservEntry."Source Subtype" <> 4) AND
//               (ReservEntry."Source Ref. No." <> 0);
//           DATABASE::"Job Journal Line":
//             IsError := ReservEntry.Binding = ReservEntry.Binding::"Order-to-Order";
//           DATABASE::"Job Planning Line":
//             IsError := ReservEntry."Source Subtype" <> 2;
//         END;

//         IF IsError THEN
//           ERROR(Text000);
//     end;

//     procedure GetLastEntry(var ReservEntry: Record "337")
//     begin
//         ReservEntry := LastReservEntry;
//     end;

//     procedure HasSamePointer(var ReservEntry: Record "337";var Reserventry2: Record "337"): Boolean
//     begin
//         EXIT
//         ((ReservEntry."Source Type" = Reserventry2."Source Type") AND
//           (ReservEntry."Source Subtype" = Reserventry2."Source Subtype") AND
//           (ReservEntry."Source ID" = Reserventry2."Source ID") AND
//           (ReservEntry."Source Batch Name" = Reserventry2."Source Batch Name") AND
//           (ReservEntry."Source Prod. Order Line" = Reserventry2."Source Prod. Order Line") AND
//           (ReservEntry."Source Ref. No." = Reserventry2."Source Ref. No."));
//     end;

//     procedure AdjustDateIfItemLedgerEntry(var ReservEntry: Record "337")
//     begin
//         IF ReservEntry."Source Type" = DATABASE::"Item Ledger Entry" THEN
//           IF ReservEntry."Quantity (Base)" > 0 THEN
//             ReservEntry."Expected Receipt Date" := 0D
//           ELSE
//             ReservEntry."Shipment Date" := 12319999D;
//     end;

//     local procedure SetupSplitReservEntry(var ReservEntry: Record "337";var ReservEntry2: Record "337")
//     var
//         NonReleasedQty: Decimal;
//     begin
//         // Preparing the looping through Item Tracking.

//         // Ensure that the full quantity is represented in the list of Tracking Specifications:
//         NonReleasedQty := ReservEntry."Quantity (Base)";
//         IF TempTrkgSpec1.FINDSET THEN
//           REPEAT
//             NonReleasedQty -= TempTrkgSpec1."Quantity (Base)";
//           UNTIL TempTrkgSpec1.NEXT = 0;

//         IF NonReleasedQty <> 0 THEN BEGIN
//           TempTrkgSpec1.INIT;
//           TempTrkgSpec1.TRANSFERFIELDS(ReservEntry);
//           TempTrkgSpec1.VALIDATE("Quantity (Base)",NonReleasedQty);
//           IF TempTrkgSpec1."Source Type" <> DATABASE::"Item Ledger Entry" THEN BEGIN
//             TempTrkgSpec1."Serial No." := '';
//             TempTrkgSpec1."Lot No." := '';
//           END;
//           TempTrkgSpec1.INSERT;
//         END;

//         IF NOT (ReservEntry."Reservation Status" < ReservEntry."Reservation Status"::Surplus) THEN
//           EXIT;

//         NonReleasedQty := ReservEntry2."Quantity (Base)";
//         IF TempTrkgSpec2.FINDSET THEN
//           REPEAT
//             NonReleasedQty -= TempTrkgSpec2."Quantity (Base)";
//           UNTIL TempTrkgSpec2.NEXT = 0;

//         IF NonReleasedQty <> 0 THEN BEGIN
//           TempTrkgSpec2.INIT;
//           TempTrkgSpec2.TRANSFERFIELDS(ReservEntry2);
//           TempTrkgSpec2.VALIDATE("Quantity (Base)",NonReleasedQty);
//           IF TempTrkgSpec2."Source Type" <> DATABASE::"Item Ledger Entry" THEN BEGIN
//             TempTrkgSpec2."Serial No." := '';
//             TempTrkgSpec2."Lot No." := '';
//           END;
//           TempTrkgSpec2.INSERT;
//         END;

//         BalanceLists;
//     end;

//     local procedure BalanceLists()
//     var
//         TempTrkgSpec3: Record "336" temporary;
//         TempTrkgSpec4: Record "336" temporary;
//         LastEntryNo: Integer;
//         NextState: Option SetFilter1,SetFilter2,LoosenFilter1,LoosenFilter2,Split,Error,Finish;
//     begin
//         TempTrkgSpec1.RESET;
//         TempTrkgSpec2.RESET;
//         TempTrkgSpec1.SETCURRENTKEY("Lot No.","Serial No.");
//         TempTrkgSpec2.SETCURRENTKEY("Lot No.","Serial No.");

//         IF NOT TempTrkgSpec1.FINDLAST THEN
//           EXIT;

//         REPEAT
//           CASE NextState OF
//             NextState::SetFilter1:
//               BEGIN
//                 TempTrkgSpec1.SETRANGE("Serial No.",TempTrkgSpec2."Serial No.");
//                 TempTrkgSpec1.SETRANGE("Lot No.",TempTrkgSpec2."Lot No.");
//                 IF TempTrkgSpec1.FINDLAST THEN
//                   NextState := NextState::Split
//                 ELSE
//                   NextState := NextState::LoosenFilter1;
//               END;
//             NextState::LoosenFilter1:
//               BEGIN
//                 IF TempTrkgSpec2."Quantity (Base)" > 0 THEN BEGIN
//                   TempTrkgSpec1.SETRANGE("Serial No.",'');
//                   TempTrkgSpec1.SETRANGE("Lot No.",'');
//                 END ELSE BEGIN
//                   IF TempTrkgSpec2."Serial No." = '' THEN
//                     TempTrkgSpec1.SETRANGE("Serial No.");
//                   IF TempTrkgSpec2."Lot No." = '' THEN
//                     TempTrkgSpec1.SETRANGE("Lot No.");
//                 END;
//                 IF TempTrkgSpec1.FINDLAST THEN
//                   NextState := NextState::Split
//                 ELSE
//                   NextState := NextState::Error;
//               END;
//             NextState::SetFilter2:
//               BEGIN
//                 TempTrkgSpec2.SETRANGE("Serial No.",TempTrkgSpec1."Serial No.");
//                 TempTrkgSpec2.SETRANGE("Lot No.",TempTrkgSpec1."Lot No.");
//                 IF TempTrkgSpec2.FINDLAST THEN
//                   NextState := NextState::Split
//                 ELSE
//                   NextState := NextState::LoosenFilter2;
//               END;
//             NextState::LoosenFilter2:
//               BEGIN
//                 IF TempTrkgSpec1."Quantity (Base)" > 0 THEN BEGIN
//                   TempTrkgSpec2.SETRANGE("Serial No.",'');
//                   TempTrkgSpec2.SETRANGE("Lot No.",'');
//                 END ELSE BEGIN
//                   IF TempTrkgSpec1."Serial No." = '' THEN
//                     TempTrkgSpec2.SETRANGE("Serial No.");
//                   IF TempTrkgSpec1."Lot No." = '' THEN
//                     TempTrkgSpec2.SETRANGE("Lot No.");
//                 END;
//                 IF TempTrkgSpec2.FINDLAST THEN
//                   NextState := NextState::Split
//                 ELSE
//                   NextState := NextState::Error;
//               END;
//             NextState::Split:
//               BEGIN
//                 TempTrkgSpec3 := TempTrkgSpec1;
//                 TempTrkgSpec4 := TempTrkgSpec2;
//                 IF ABS(TempTrkgSpec1."Quantity (Base)") = ABS(TempTrkgSpec2."Quantity (Base)") THEN BEGIN
//                   TempTrkgSpec1.DELETE;
//                   TempTrkgSpec2.DELETE;
//                   TempTrkgSpec1.SETRANGE("Serial No.");
//                   TempTrkgSpec1.SETRANGE("Lot No.");
//                   IF TempTrkgSpec1.FINDLAST THEN
//                     NextState := NextState::SetFilter2
//                   ELSE BEGIN
//                     TempTrkgSpec2.RESET;
//                     IF TempTrkgSpec2.FINDLAST THEN
//                       NextState := NextState::Error
//                     ELSE
//                       NextState := NextState::Finish;
//                   END;
//                 END ELSE
//                   IF ABS(TempTrkgSpec1."Quantity (Base)") < ABS(TempTrkgSpec2."Quantity (Base)") THEN BEGIN
//                     TempTrkgSpec2.VALIDATE("Quantity (Base)",TempTrkgSpec2."Quantity (Base)" +
//                       TempTrkgSpec1."Quantity (Base)");
//                     TempTrkgSpec4.VALIDATE("Quantity (Base)",-TempTrkgSpec1."Quantity (Base)");
//                     TempTrkgSpec1.DELETE;
//                     TempTrkgSpec2.MODIFY;
//                     NextState := NextState::SetFilter1;
//                   END ELSE BEGIN
//                     TempTrkgSpec1.VALIDATE("Quantity (Base)",TempTrkgSpec1."Quantity (Base)" +
//                       TempTrkgSpec2."Quantity (Base)");
//                     TempTrkgSpec3.VALIDATE("Quantity (Base)",-TempTrkgSpec2."Quantity (Base)");
//                     TempTrkgSpec2.DELETE;
//                     TempTrkgSpec1.MODIFY;
//                     NextState := NextState::SetFilter2;
//                   END;
//                 TempTrkgSpec3."Entry No." := LastEntryNo + 1;
//                 TempTrkgSpec4."Entry No." := LastEntryNo + 1;
//                 TempTrkgSpec3.INSERT;
//                 TempTrkgSpec4.INSERT;
//                 LastEntryNo := TempTrkgSpec3."Entry No.";
//               END;
//             NextState::Error:
//               ERROR(Text001);
//           END;
//         UNTIL NextState = NextState::Finish;

//         TempTrkgSpec1.RESET;
//         TempTrkgSpec2.RESET;
//         TempTrkgSpec3.RESET;
//         TempTrkgSpec4.RESET;

//         IF TempTrkgSpec3.FINDSET THEN
//           REPEAT
//             TempTrkgSpec1 := TempTrkgSpec3;
//             TempTrkgSpec1.INSERT;
//           UNTIL TempTrkgSpec3.NEXT = 0;

//         IF TempTrkgSpec4.FINDSET THEN
//           REPEAT
//             TempTrkgSpec2 := TempTrkgSpec4;
//             TempTrkgSpec2.INSERT;
//           UNTIL TempTrkgSpec4.NEXT = 0;
//     end;

//     local procedure SplitReservEntry(var ReservEntry: Record "337";var ReservEntry2: Record "337";TrackingSpecificationExists: Boolean;var FirstSplit: Boolean): Boolean
//     var
//         SalesSetup: Record "311";
//         OldReservEntryQty: Decimal;
//     begin
//         IF NOT TrackingSpecificationExists THEN
//           IF NOT FirstSplit THEN
//             EXIT(FALSE)
//           ELSE BEGIN
//             FirstSplit := FALSE;
//             EXIT(TRUE);
//           END;

//         SalesSetup.GET;
//         TempTrkgSpec1.RESET;
//         IF NOT TempTrkgSpec1.FINDFIRST THEN
//           EXIT(FALSE);

//         ReservEntry."Serial No." := TempTrkgSpec1."Serial No.";
//         ReservEntry."Lot No." := TempTrkgSpec1."Lot No.";
//         ReservEntry."Warranty Date" := TempTrkgSpec1."Warranty Date";
//         ReservEntry."Expiration Date" := TempTrkgSpec1."Expiration Date";
//         OldReservEntryQty := ReservEntry.Quantity;
//         ReservEntry.VALIDATE("Quantity (Base)",TempTrkgSpec1."Quantity (Base)");
//         IF ABS(ReservEntry.Quantity - OldReservEntryQty) <= 0.00001 THEN
//           ReservEntry.Quantity := OldReservEntryQty;
//         TempTrkgSpec1.DELETE;

//         IF ReservEntry."Reservation Status" < ReservEntry."Reservation Status"::Surplus THEN BEGIN
//           TempTrkgSpec2.GET(TempTrkgSpec1."Entry No.");
//           ReservEntry2."Serial No." := TempTrkgSpec2."Serial No.";
//           ReservEntry2."Lot No." := TempTrkgSpec2."Lot No.";
//           ReservEntry2."Warranty Date" := TempTrkgSpec2."Warranty Date";
//           ReservEntry2."Expiration Date" := TempTrkgSpec2."Expiration Date";
//           OldReservEntryQty := ReservEntry2.Quantity;
//           ReservEntry2.VALIDATE("Quantity (Base)",TempTrkgSpec2."Quantity (Base)");
//           IF ABS(ReservEntry2.Quantity - OldReservEntryQty) <= 0.00001 THEN
//             ReservEntry2.Quantity := OldReservEntryQty;
//           IF ReservEntry2.Positive AND SalesSetup."Exact Cost Reversing Mandatory" THEN
//             ReservEntry2."Appl.-from Item Entry" := TempTrkgSpec2."Appl.-from Item Entry";
//           TempTrkgSpec2.DELETE;
//         END;

//         EXIT(TRUE);
//     end;

//     procedure CreateWhseItemTrkgLines(ReservEntry: Record "337")
//     var
//         WhseShipmentLine: Record "7321";
//         WhseWkshLine: Record "7326";
//         ItemTrkgMgt: Codeunit "6500";
//     begin
//         WITH WhseShipmentLine DO BEGIN
//           SETCURRENTKEY("Source Type","Source Subtype","Source No.","Source Line No.");
//           SETRANGE("Source Type",ReservEntry."Source Type");
//           SETRANGE("Source Subtype",ReservEntry."Source Subtype");
//           SETRANGE("Source No.",ReservEntry."Source ID");
//           SETRANGE("Source Line No.",ReservEntry."Source Ref. No.");
//           IF FINDFIRST THEN
//             IF NOT ItemTrkgMgt.WhseItemTrkgLineExists("No.",DATABASE::"Warehouse Shipment Line",0,'',0,
//                  "Source Line No.","Location Code",ReservEntry."Serial No.",ReservEntry."Lot No.")
//             THEN BEGIN
//               ItemTrkgMgt.InitWhseWkshLine(WhseWkshLine,
//                 2,"No.","Line No.","Source Type","Source Subtype","Source No.","Source Line No.",0);
//               ItemTrkgMgt.CreateWhseItemTrkgForResEntry(ReservEntry,WhseWkshLine);
//             END;
//         END;
//     end;

//     procedure SetItemLedgEntryNo(EntryNo: Integer)
//     begin
//         InsertReservEntry."Item Ledger Entry No." := EntryNo;
//     end;

//     procedure SetApplyToEntryNo(EntryNo: Integer)
//     begin
//         InsertReservEntry."Appl.-to Item Entry" := EntryNo;
//     end;

//     procedure SetApplyFromEntryNo(EntryNo: Integer)
//     begin
//         InsertReservEntry."Appl.-from Item Entry" := EntryNo;
//     end;

//     procedure SetOverruleItemTracking(Overrule: Boolean)
//     begin
//         OverruleItemTracking := Overrule;
//     end;

//     procedure SetInbound(NewInbound: Boolean)
//     begin
//         Inbound := NewInbound;
//     end;

//     procedure SetUseQtyToInvoice(UseQtyToInvoice2: Boolean)
//     begin
//         UseQtyToInvoice := UseQtyToInvoice2;
//     end;

//     procedure UpdateItemTrackingAfterPosting(var ReservEntry: Record "337")
//     var
//         CurrSourceRefNo: Integer;
//         ReachedEndOfResvEntries: Boolean;
//     begin
//         IF NOT ReservEntry.FINDSET(TRUE) THEN
//           EXIT;

//         REPEAT
//           CurrSourceRefNo := ReservEntry."Source Ref. No.";

//           REPEAT
//             ReservEntry."Qty. to Handle (Base)" := ReservEntry."Quantity (Base)";
//             ReservEntry."Qty. to Invoice (Base)" := ReservEntry."Quantity (Base)";
//             ReservEntry.MODIFY;
//             IF ReservEntry.NEXT = 0 THEN
//               ReachedEndOfResvEntries := TRUE;
//           UNTIL ReachedEndOfResvEntries OR (ReservEntry."Source Ref. No." <> CurrSourceRefNo);

//           // iterate over each set of Source Ref No.
//         UNTIL ReservEntry."Source Ref. No." = CurrSourceRefNo;
//     end;

//     procedure UpdReservEntryAfterPostingPick(TransHeader: Record "5740")
//     var
//         ReservEntry: Record "337";
//         ReservEntryFrom: Record "337";
//         SurplusReservEntry: Record "337";
//         ReservEntryTo: Record "337";
//         ReservMgt: Codeunit "99000845";
//         LastEntryNo: Integer;
//         TrackingSpecificationExists: Boolean;
//         FirstSplit: Boolean;
//     begin
//         ReservEntryFrom.RESET;
//         ReservEntryFrom.SETRANGE("Source Type",DATABASE::"Transfer Line");
//         ReservEntryFrom.SETRANGE("Source ID",TransHeader."No.");
//         ReservEntryFrom.SETRANGE("Source Batch Name",'');
//         ReservEntryFrom.SETRANGE("Source Prod. Order Line",0);
//         ReservEntryFrom.SETRANGE("Source Subtype",1);
//         ReservEntryFrom.SETRANGE("Lot No.",ReservEntryFrom."Lot No.");
//         ReservEntryFrom.SETRANGE("Serial No.",ReservEntryFrom."Serial No.");
//         IF ReservEntryFrom.FINDSET THEN
//           REPEAT
//             IF ReservEntry.FINDLAST THEN
//               LastEntryNo := ReservEntry."Entry No.";
//             ReservEntry := ReservEntryFrom;
//             WITH SurplusReservEntry DO BEGIN
//               SETRANGE(Positive,ReservEntry.Positive);
//               SETRANGE("Item No.",ReservEntry."Item No.");
//               SETRANGE("Location Code",ReservEntry."Location Code");
//               SETRANGE("Source Type",ReservEntry."Source Type");
//               SETRANGE("Source Subtype",ReservEntry."Source Subtype");
//               SETRANGE("Source ID",ReservEntry."Source ID");
//               SETRANGE("Reservation Status","Reservation Status"::Surplus);
//               IF FINDFIRST AND ReservEntryTo.GET(ReservEntry."Entry No.",NOT ReservEntry.Positive) THEN BEGIN
//                 ReservEntry."Source Prod. Order Line" := "Source Prod. Order Line";
//                 ReservEntry."Source Ref. No." := "Source Ref. No.";
//                 IF ReservEntry."Quantity (Base)" = "Quantity (Base)" THEN BEGIN
//                   ReservEntry."Lot No." := "Lot No.";
//                   ReservEntry."Serial No." := "Serial No.";
//                   ReservEntry.UpdateItemTracking;
//                   ReservEntry.MODIFY;
//                   DELETE;
//                 END ELSE
//                   IF ReservEntry."Quantity (Base)" < "Quantity (Base)" THEN BEGIN
//                     ReservEntry."Lot No." := "Lot No.";
//                     ReservEntry."Serial No." := "Serial No.";
//                     ReservEntry.UpdateItemTracking;
//                     ReservEntry.MODIFY;
//                     VALIDATE("Quantity (Base)","Quantity (Base)" - ReservEntry."Quantity (Base)");
//                     MODIFY;
//                   END ELSE BEGIN
//                     ReservMgt.MakeRoomForReservation(ReservEntry);
//                     ReservMgt.CollectTrackingSpecification(TempTrkgSpec2);
//                     ReservMgt.MakeRoomForReservation(ReservEntryTo);
//                     ReservMgt.CollectTrackingSpecification(TempTrkgSpec1);
//                     SetupSplitReservEntry(ReservEntryTo,ReservEntry);
//                     FirstSplit := TRUE;
//                     TrackingSpecificationExists := TRUE;
//                     WHILE SplitReservEntry(ReservEntryTo,ReservEntry,TrackingSpecificationExists,FirstSplit) DO BEGIN
//                       ReservEntry."Entry No." := LastEntryNo + 1;
//                       ReservEntry.UpdateItemTracking;
//                       ReservEntry.INSERT;
//                       ReservEntryTo."Entry No." := ReservEntry."Entry No.";
//                       ReservEntryTo.UpdateItemTracking;
//                       ReservEntryTo.INSERT;
//                       LastEntryNo := ReservEntry."Entry No.";
//                     END;
//                   END;
//               END;
//             END;
//           UNTIL ReservEntryFrom.NEXT = 0;
//     end;
// }

