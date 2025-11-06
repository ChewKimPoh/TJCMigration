// page 6500 "Item Tracking Summary"
// {
//     Caption = 'Item Tracking Summary';
//     DeleteAllowed = false;
//     InsertAllowed = false;
//     PageType = Worksheet;
//     SourceTable = Table338;
//     SourceTableTemporary = true;

//     layout
//     {
//         area(content)
//         {
//             repeater()
//             {
//                 field("Lot No.";"Lot No.")
//                 {
//                     Editable = false;
//                 }
//                 field("Expiration Date";"Expiration Date")
//                 {
//                     Editable = false;
//                 }
//                 field("Serial No.";"Serial No.")
//                 {
//                     Editable = false;
//                 }
//                 field("Warranty Date";"Warranty Date")
//                 {
//                     Editable = false;
//                     Visible = false;
//                 }
//                 field("Total Quantity";"Total Quantity")
//                 {
//                     DrillDown = true;
//                     Editable = false;

//                     trigger OnDrillDown()
//                     begin
//                         DrillDownEntries(FIELDNO("Total Quantity"));
//                     end;
//                 }
//                 field("Total Requested Quantity";"Total Requested Quantity")
//                 {
//                     DrillDown = true;
//                     Editable = false;

//                     trigger OnDrillDown()
//                     begin
//                         DrillDownEntries(FIELDNO("Total Requested Quantity"));
//                     end;
//                 }
//                 field("Current Pending Quantity";"Current Pending Quantity")
//                 {
//                     Editable = false;
//                 }
//                 field("Total Available Quantity";"Total Available Quantity")
//                 {
//                     Editable = false;
//                 }
//                 field("Current Reserved Quantity";"Current Reserved Quantity")
//                 {
//                     Editable = false;
//                     Visible = false;
//                 }
//                 field("Total Reserved Quantity";"Total Reserved Quantity")
//                 {
//                     Editable = false;
//                     Visible = false;
//                 }
//                 field("Bin Content";"Bin Content")
//                 {
//                     Visible = "Bin ContentVisible";

//                     trigger OnDrillDown()
//                     begin
//                         DrillDownBinContent(FIELDNO("Bin Content"));
//                     end;
//                 }
//                 field("Selected Quantity";"Selected Quantity")
//                 {
//                     Editable = "Selected QuantityEditable";
//                     Style = Strong;
//                     StyleExpr = TRUE;
//                     Visible = "Selected QuantityVisible";

//                     trigger OnValidate()
//                     begin
//                         SelectedQuantityOnAfterValidat;
//                     end;
//                 }
//             }
//             group()
//             {
//                 fixed()
//                 {
//                     group(Selectable)
//                     {
//                         Caption = 'Selectable';
//                         field(MaxQuantity1;MaxQuantity)
//                         {
//                             Caption = 'Selectable';
//                             DecimalPlaces = 0:5;
//                             Editable = false;
//                             Visible = MaxQuantity1Visible;
//                         }
//                     }
//                     group(Selected)
//                     {
//                         Caption = 'Selected';
//                         field(Selected1;SelectedQuantity)
//                         {
//                             Caption = 'Selected';
//                             DecimalPlaces = 0:5;
//                             Editable = false;
//                             Visible = Selected1Visible;
//                         }
//                     }
//                     group(Undefined)
//                     {
//                         Caption = 'Undefined';
//                         field(Undefined1;MaxQuantity - SelectedQuantity)
//                         {
//                             BlankZero = true;
//                             Caption = 'Undefined';
//                             DecimalPlaces = 2:5;
//                             Editable = false;
//                             Visible = Undefined1Visible;
//                         }
//                     }
//                 }
//             }
//         }
//     }

//     actions
//     {
//     }

//     trigger OnAfterGetCurrRecord()
//     begin
//         UpdateIfFiltersHaveChanged;
//     end;

//     trigger OnInit()
//     begin
//         Undefined1Visible := TRUE;
//         Selected1Visible := TRUE;
//         MaxQuantity1Visible := TRUE;
//         "Bin ContentVisible" := TRUE;
//     end;

//     trigger OnOpenPage()
//     begin
//         UpdateSelectedQuantity;

//         "Bin ContentVisible" := CurrBinCode <> '';

//         IF "Selected QuantityVisible" THEN BEGIN
//         END
//         ELSE
//           IF "Serial No." <> '' THEN;
//     end;

//     var
//         TempReservEntry: Record "337" temporary;
//         ItemTrackingDataCollection: Codeunit "6501";
//         CurrItemTrackingCode: Record "6502";
//         MaxQuantity: Decimal;
//         SelectedQuantity: Decimal;
//         CurrBinCode: Code[20];
//         xFilterRec: Record "338";
//         [InDataSet]
//         "Selected QuantityVisible": Boolean;
//         [InDataSet]
//         "Bin ContentVisible": Boolean;
//         [InDataSet]
//         MaxQuantity1Visible: Boolean;
//         [InDataSet]
//         Selected1Visible: Boolean;
//         [InDataSet]
//         Undefined1Visible: Boolean;
//         [InDataSet]
//         "Selected QuantityEditable": Boolean;

//     procedure SetSources(var ReservEntry: Record "337";var EntrySummary: Record "338")
//     var
//         xEntrySummary: Record "338";
//     begin
//         TempReservEntry.RESET;
//         TempReservEntry.DELETEALL;
//         IF ReservEntry.FIND('-') THEN
//           REPEAT
//             TempReservEntry := ReservEntry;
//             TempReservEntry.INSERT;
//           UNTIL ReservEntry.NEXT = 0;

//         xEntrySummary.SETVIEW(GETVIEW);
//         RESET;
//         DELETEALL;
//         IF EntrySummary.FINDSET THEN
//           REPEAT
//             IF EntrySummary.HasQuantity THEN BEGIN
//               Rec := EntrySummary;
//               INSERT;
//             END;
//           UNTIL EntrySummary.NEXT = 0;
//         SETVIEW(xEntrySummary.GETVIEW);
//         UpdateSelectedQuantity;
//     end;

//     procedure SetSelectionMode(SelectionMode: Boolean)
//     begin
//         "Selected QuantityVisible" := SelectionMode;
//         "Selected QuantityEditable" := SelectionMode;
//         MaxQuantity1Visible := SelectionMode;
//         Selected1Visible := SelectionMode;
//         Undefined1Visible := SelectionMode;
//     end;

//     procedure SetMaxQuantity(MaxQty: Decimal)
//     begin
//         MaxQuantity := MaxQty;
//     end;

//     procedure SetCurrentBinAndItemTrkgCode(BinCode: Code[20];ItemTrackingCode: Record "6502")
//     begin
//         ItemTrackingDataCollection.SetCurrentBinAndItemTrkgCode(BinCode,ItemTrackingCode);
//         "Bin ContentVisible" := BinCode <> '';
//         CurrBinCode := BinCode;
//         CurrItemTrackingCode := ItemTrackingCode;
//     end;

//     procedure AutoSelectLotSerialNo()
//     begin
//         ItemTrackingDataCollection.AutoSelectLotSerialNo(Rec,MaxQuantity);
//     end;

//     procedure UpdateSelectedQuantity()
//     var
//         xEntrySummary: Record "338";
//     begin
//         IF NOT "Selected QuantityVisible" THEN
//           EXIT;
//         IF MODIFY THEN; // Ensure that changes to current rec are included in CALCSUMS
//         xEntrySummary := Rec;
//         CALCSUMS("Selected Quantity");
//         SelectedQuantity := "Selected Quantity";
//         Rec := xEntrySummary;
//     end;

//     procedure GetSelected(var EntrySummary: Record "338")
//     begin
//         EntrySummary.RESET;
//         EntrySummary.DELETEALL;
//         SETFILTER("Selected Quantity",'<>%1',0);
//         IF FINDSET THEN
//           REPEAT
//             EntrySummary := Rec;
//             EntrySummary.INSERT;
//           UNTIL NEXT = 0;
//     end;

//     procedure DrillDownEntries(FieldNumber: Integer)
//     var
//         TempReservEntry2: Record "337" temporary;
//     begin
//         TempReservEntry.RESET;
//         TempReservEntry.SETCURRENTKEY(
//           "Item No.","Source Type","Source Subtype","Reservation Status",
//           "Location Code","Variant Code","Shipment Date","Expected Receipt Date","Serial No.","Lot No.");

//         TempReservEntry.SETRANGE("Lot No.","Lot No.");
//         IF "Serial No." <> '' THEN
//           TempReservEntry.SETRANGE("Serial No.","Serial No.");

//         CASE FieldNumber OF
//           FIELDNO("Total Quantity"):
//             BEGIN
//               // An Item Ledger Entry will in itself be represented with a surplus TempReservEntry. Order tracking
//               // and reservations against Item Ledger Entries are therefore kept out, as these quantities would
//               // otherwise be represented twice in the drill down.

//               TempReservEntry.SETRANGE(Positive,TRUE);
//               TempReservEntry2.COPY(TempReservEntry);  // Copy key
//               IF TempReservEntry.FINDSET THEN
//                 REPEAT
//                   TempReservEntry2 := TempReservEntry;
//                   IF TempReservEntry."Source Type" = DATABASE::"Item Ledger Entry" THEN BEGIN
//                     IF TempReservEntry."Reservation Status" = TempReservEntry."Reservation Status"::Surplus THEN
//                       TempReservEntry2.INSERT;
//                   END ELSE
//                     TempReservEntry2.INSERT;
//                 UNTIL TempReservEntry.NEXT = 0;
//               TempReservEntry2.ASCENDING(FALSE);
//               PAGE.RUNMODAL(PAGE::"Avail. - Item Tracking Lines",TempReservEntry2);
//             END;
//           FIELDNO("Total Requested Quantity"):
//             BEGIN
//               TempReservEntry.SETRANGE(Positive,FALSE);
//               TempReservEntry.ASCENDING(FALSE);
//               PAGE.RUNMODAL(PAGE::"Avail. - Item Tracking Lines",TempReservEntry);
//             END;
//         END;
//     end;

//     procedure DrillDownBinContent(FieldNumber: Integer)
//     var
//         BinContent: Record "7302";
//         BinContentForm: Page "7304";
//     begin
//         IF CurrBinCode = '' THEN
//           EXIT;
//         TempReservEntry.RESET;
//         IF NOT TempReservEntry.FINDFIRST THEN
//           EXIT;

//         CurrItemTrackingCode.TESTFIELD(Code);

//         BinContent.SETRANGE("Location Code",TempReservEntry."Location Code");
//         BinContent.SETRANGE("Item No.",TempReservEntry."Item No.");
//         BinContent.SETRANGE("Variant Code",TempReservEntry."Variant Code");
//         IF CurrItemTrackingCode."Lot Warehouse Tracking" THEN
//           IF "Lot No." <> '' THEN
//             BinContent.SETRANGE("Lot No. Filter","Lot No.");
//         IF CurrItemTrackingCode."SN Warehouse Tracking" THEN
//           IF "Serial No." <> '' THEN
//             BinContent.SETRANGE("Serial No. Filter","Serial No.");

//         IF FieldNumber = FIELDNO("Bin Content") THEN
//           BinContent.SETRANGE("Bin Code",CurrBinCode);

//         BinContentForm.SETTABLEVIEW(BinContent);
//         BinContentForm.RUNMODAL;
//     end;

//     local procedure UpdateIfFiltersHaveChanged()
//     begin
//         // In order to update Selected Quantity when filters have been changed on the form.
//         IF GETFILTERS = xFilterRec.GETFILTERS THEN
//           EXIT;

//         UpdateSelectedQuantity;
//         xFilterRec.COPY(Rec);
//     end;

//     local procedure SelectedQuantityOnAfterValidat()
//     begin
//         UpdateSelectedQuantity;
//         CurrPage.UPDATE;
//     end;
// }

