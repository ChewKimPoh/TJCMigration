// page 6510 "Item Tracking Lines"
// {
//     // In order to provide F6 invoked lookup from availability bitmap columns, a menu button has been hidden behind control 1.
//     // Function buttons Line and Function both exist in two overlayed versions to make dynamic show/hide/enable of
//     // individual menu items possible.
//     // 
//     // TJCSG1.00
//     //  1. 19/06/2014  dp.dst
//     //     - Inserted codes in function "RegisterChange" when system calls the function CreateReservEntryFor from Codeunit
//     //       "Create Reserv. Entry" to pass on 1 more parameter "Expiration Date".

//     Caption = 'Item Tracking Lines';
//     DataCaptionFields = "Item No.","Variant Code",Description;
//     PageType = Worksheet;
//     PopulateAllFields = true;
//     SourceTable = Table336;
//     SourceTableTemporary = true;

//     layout
//     {
//         area(content)
//         {
//             group()
//             {
//                 fixed()
//                 {
//                     group(Source)
//                     {
//                         Caption = 'Source';
//                         field(CurrentSourceCaption;CurrentSourceCaption)
//                         {
//                             Editable = false;
//                         }
//                         field(SourceQuantityArray[1];SourceQuantityArray[1])
//                         {
//                             Caption = 'Quantity';
//                             DecimalPlaces = 0:5;
//                             Editable = false;
//                         }
//                         field("Bin Code";"Bin Code")
//                         {
//                             Caption = 'Bin Code';
//                             Editable = false;
//                         }
//                         field(Handle1;SourceQuantityArray[2])
//                         {
//                             Caption = 'Qty. to Handle';
//                             DecimalPlaces = 0:5;
//                             Editable = false;
//                             Visible = Handle1Visible;
//                         }
//                         field(Invoice1;SourceQuantityArray[3])
//                         {
//                             Caption = 'Qty. to Invoice';
//                             DecimalPlaces = 0:5;
//                             Editable = false;
//                             Visible = Invoice1Visible;
//                         }
//                     }
//                     group("Item Tracking")
//                     {
//                         Caption = 'Item Tracking';
//                         field(Text020;Text020)
//                         {
//                             Visible = false;
//                         }
//                         field(Quantity_ItemTracking;TotalItemTrackingLine."Quantity (Base)")
//                         {
//                             Caption = 'Quantity';
//                             DecimalPlaces = 0:5;
//                             Editable = false;
//                         }
//                         field(Handle2;TotalItemTrackingLine."Qty. to Handle (Base)")
//                         {
//                             Caption = 'Qty. to Handle';
//                             DecimalPlaces = 0:5;
//                             Editable = false;
//                             Visible = Handle2Visible;
//                         }
//                         field(Invoice2;TotalItemTrackingLine."Qty. to Invoice (Base)")
//                         {
//                             Caption = 'Qty. to Invoice';
//                             DecimalPlaces = 0:5;
//                             Editable = false;
//                             Visible = Invoice2Visible;
//                         }
//                     }
//                     group(Undefined)
//                     {
//                         Caption = 'Undefined';
//                         field(Text020;Text020)
//                         {
//                             Visible = false;
//                         }
//                         field(Quantity3;UndefinedQtyArray[1])
//                         {
//                             BlankZero = true;
//                             Caption = 'Undefined Quantity';
//                             DecimalPlaces = 2:5;
//                             Editable = false;
//                         }
//                         field(Handle3;UndefinedQtyArray[2])
//                         {
//                             BlankZero = true;
//                             Caption = 'Undefined Quantity to Handle';
//                             DecimalPlaces = 2:5;
//                             Editable = false;
//                             Visible = Handle3Visible;
//                         }
//                         field(Invoice3;UndefinedQtyArray[3])
//                         {
//                             BlankZero = true;
//                             Caption = 'Undefined Quantity to Invoice';
//                             DecimalPlaces = 2:5;
//                             Editable = false;
//                             Visible = Invoice3Visible;
//                         }
//                     }
//                 }
//             }
//             group()
//             {
//                 field(ItemTrackingCode.Code;ItemTrackingCode.Code)
//                 {
//                     Caption = 'Item Tracking Code';
//                     Editable = false;
//                     Lookup = true;

//                     trigger OnLookup(var Text: Text): Boolean
//                     begin
//                         PAGE.RUNMODAL(0,ItemTrackingCode);
//                     end;
//                 }
//                 field(ItemTrackingCode.Description;ItemTrackingCode.Description)
//                 {
//                     Caption = 'Description';
//                     Editable = false;
//                 }
//             }
//             repeater()
//             {
//                 field(AvailabilitySerialNo;LotSnAvailable(Rec,0))
//                 {
//                     Caption = 'Availability, Serial No.';
//                     Editable = false;
//                     OptionCaption = 'Bitmap45';
//                     ToolTip = 'Serial No. Availability';

//                     trigger OnDrillDown()
//                     begin
//                         LookupAvailable(0);
//                     end;
//                 }
//                 field("Serial No.";"Serial No.")
//                 {
//                     Editable = "Serial No.Editable";
//                     Visible = false;

//                     trigger OnAssistEdit()
//                     var
//                         MaxQuantity: Decimal;
//                     begin
//                         MaxQuantity := UndefinedQtyArray[1];

//                         "Bin Code" := ForBinCode;
//                         ItemTrackingDataCollection.AssistEditLotSerialNo(Rec,
//                           (CurrentSignFactor * SourceQuantityArray[1] < 0) AND NOT
//                           InsertIsBlocked,CurrentSignFactor,0,MaxQuantity);
//                         "Bin Code" := '';
//                         CurrPage.UPDATE;
//                     end;

//                     trigger OnValidate()
//                     begin
//                         SerialNoOnAfterValidate;
//                     end;
//                 }
//                 field("New Serial No.";"New Serial No.")
//                 {
//                     Editable = "New Serial No.Editable";
//                     Visible = "New Serial No.Visible";
//                 }
//                 field(AvailabilityLotNo;LotSnAvailable(Rec,1))
//                 {
//                     Caption = 'Availability, Lot No.';
//                     Editable = false;
//                     OptionCaption = 'Bitmap45';
//                     ToolTip = 'Lot No. Availability';

//                     trigger OnDrillDown()
//                     begin
//                         LookupAvailable(1);
//                     end;
//                 }
//                 field("Lot No.";"Lot No.")
//                 {
//                     Editable = "Lot No.Editable";

//                     trigger OnAssistEdit()
//                     var
//                         MaxQuantity: Decimal;
//                     begin
//                         MaxQuantity := UndefinedQtyArray[1];

//                         "Bin Code" := ForBinCode;
//                         ItemTrackingDataCollection.AssistEditLotSerialNo(Rec,
//                           (CurrentSignFactor * SourceQuantityArray[1] < 0) AND NOT
//                           InsertIsBlocked,CurrentSignFactor,1,MaxQuantity);
//                         "Bin Code" := '';
//                         CurrPage.UPDATE;
//                     end;

//                     trigger OnValidate()
//                     begin
//                         LotNoOnAfterValidate;
//                     end;
//                 }
//                 field("New Lot No.";"New Lot No.")
//                 {
//                     Editable = "New Lot No.Editable";
//                     Visible = "New Lot No.Visible";
//                 }
//                 field("Expiration Date";"Expiration Date")
//                 {
//                     Editable = "Expiration DateEditable";
//                     Style = StrongAccent;
//                     StyleExpr = TRUE;
//                     Visible = false;
//                 }
//                 field("New Expiration Date";"New Expiration Date")
//                 {
//                     Editable = "New Expiration DateEditable";
//                     Visible = "New Expiration DateVisible";
//                 }
//                 field("Warranty Date";"Warranty Date")
//                 {
//                     Editable = "Warranty DateEditable";
//                     Visible = false;
//                 }
//                 field("Item No.";"Item No.")
//                 {
//                     Editable = "Item No.Editable";
//                     Visible = false;
//                 }
//                 field("Variant Code";"Variant Code")
//                 {
//                     Editable = "Variant CodeEditable";
//                     Visible = false;
//                 }
//                 field(Description;Description)
//                 {
//                     Editable = DescriptionEditable;
//                     Visible = false;
//                 }
//                 field("Location Code";"Location Code")
//                 {
//                     Editable = "Location CodeEditable";
//                     Visible = false;
//                 }
//                 field("Quantity (Base)";"Quantity (Base)")
//                 {
//                     Editable = "Quantity (Base)Editable";

//                     trigger OnValidate()
//                     begin
//                         QuantityBaseOnValidate;
//                         QuantityBaseOnAfterValidate;
//                     end;
//                 }
//                 field("Qty. to Handle (Base)";"Qty. to Handle (Base)")
//                 {
//                     Editable = "Qty. to Handle (Base)Editable";
//                     Visible = "Qty. to Handle (Base)Visible";

//                     trigger OnValidate()
//                     begin
//                         QtytoHandleBaseOnAfterValidate;
//                     end;
//                 }
//                 field("Qty. to Invoice (Base)";"Qty. to Invoice (Base)")
//                 {
//                     Editable = "Qty. to Invoice (Base)Editable";
//                     Visible = "Qty. to Invoice (Base)Visible";

//                     trigger OnValidate()
//                     begin
//                         QtytoInvoiceBaseOnAfterValidat;
//                     end;
//                 }
//                 field("Quantity Handled (Base)";"Quantity Handled (Base)")
//                 {
//                     Visible = false;
//                 }
//                 field("Quantity Invoiced (Base)";"Quantity Invoiced (Base)")
//                 {
//                     Visible = false;
//                 }
//                 field("Appl.-to Item Entry";"Appl.-to Item Entry")
//                 {
//                     Visible = ApplToItemEntryVisible;
//                 }
//                 field("Appl.-from Item Entry";"Appl.-from Item Entry")
//                 {
//                     Visible = ApplFromItemEntryVisible;
//                 }
//             }
//         }
//     }

//     actions
//     {
//         area(navigation)
//         {
//             group(ButtonLineReclass)
//             {
//                 Caption = '&Line';
//                 Image = Line;
//                 Visible = ButtonLineReclassVisible;
//                 action("Serial No. Information Card")
//                 {
//                     Caption = 'Serial No. Information Card';
//                     Image = SNInfo;
//                     RunObject = Page 6509;
//                     RunPageLink = Item No.=FIELD(Item No.),
//                                   Variant Code=FIELD(Variant Code),
//                                   Serial No.=FIELD(Serial No.);

//                     trigger OnAction()
//                     begin
//                         TESTFIELD("Serial No.");
//                     end;
//                 }
//                 action("Lot No. Information Card")
//                 {
//                     Caption = 'Lot No. Information Card';
//                     Image = LotInfo;
//                     RunObject = Page 6508;
//                     RunPageLink = Item No.=FIELD(Item No.),
//                                   Variant Code=FIELD(Variant Code),
//                                   Lot No.=FIELD(Lot No.);

//                     trigger OnAction()
//                     begin
//                         TESTFIELD("Lot No.");
//                     end;
//                 }
//                 separator()
//                 {
//                 }
//                 action(NewSerialNoInformation)
//                 {
//                     Caption = 'New S&erial No. Information';
//                     Image = NewSerialNoProperties;

//                     trigger OnAction()
//                     var
//                         SerialNoInfoForm: Page "6504";
//                         SerialNoInfoNew: Record "6504";
//                     begin
//                         TESTFIELD("New Serial No.");

//                         CLEAR(SerialNoInfoForm);
//                         SerialNoInfoForm.Init(Rec);

//                         SerialNoInfoNew.SETRANGE("Item No.","Item No.");
//                         SerialNoInfoNew.SETRANGE("Variant Code","Variant Code");
//                         SerialNoInfoNew.SETRANGE("Serial No.","New Serial No.");

//                         SerialNoInfoForm.SETTABLEVIEW(SerialNoInfoNew);
//                         SerialNoInfoForm.RUN;
//                     end;
//                 }
//                 action(NewLotNoInformation)
//                 {
//                     Caption = 'New L&ot No. Information';
//                     Image = NewLotProperties;
//                     RunPageOnRec = false;

//                     trigger OnAction()
//                     var
//                         LotNoInfoForm: Page "6505";
//                         LotNoInfoNew: Record "6505";
//                     begin
//                         TESTFIELD("New Lot No.");

//                         CLEAR(LotNoInfoForm);
//                         LotNoInfoForm.Init(Rec);

//                         LotNoInfoNew.SETRANGE("Item No.","Item No.");
//                         LotNoInfoNew.SETRANGE("Variant Code","Variant Code");
//                         LotNoInfoNew.SETRANGE("Lot No.","New Lot No.");

//                         LotNoInfoForm.SETTABLEVIEW(LotNoInfoNew);
//                         LotNoInfoForm.RUN;
//                     end;
//                 }
//             }
//             group(ButtonLine)
//             {
//                 Caption = '&Line';
//                 Image = Line;
//                 Visible = ButtonLineVisible;
//                 action("Serial No. Information Card")
//                 {
//                     Caption = 'Serial No. Information Card';
//                     Image = SNInfo;
//                     RunObject = Page 6509;
//                     RunPageLink = Item No.=FIELD(Item No.),
//                                   Variant Code=FIELD(Variant Code),
//                                   Serial No.=FIELD(Serial No.);

//                     trigger OnAction()
//                     begin
//                         TESTFIELD("Serial No.");
//                     end;
//                 }
//                 action("Lot No. Information Card")
//                 {
//                     Caption = 'Lot No. Information Card';
//                     Image = LotInfo;
//                     RunObject = Page 6508;
//                     RunPageLink = Item No.=FIELD(Item No.),
//                                   Variant Code=FIELD(Variant Code),
//                                   Lot No.=FIELD(Lot No.);

//                     trigger OnAction()
//                     begin
//                         TESTFIELD("Lot No.");
//                     end;
//                 }
//             }
//         }
//         area(processing)
//         {
//             group(FunctionsSupply)
//             {
//                 Caption = 'F&unctions';
//                 Image = "Action";
//                 Visible = FunctionsSupplyVisible;
//                 action("Assign Serial No.")
//                 {
//                     Caption = 'Assign &Serial No.';
//                     Image = SerialNo;

//                     trigger OnAction()
//                     begin
//                         IF InsertIsBlocked THEN
//                           EXIT;
//                         AssignSerialNo;
//                     end;
//                 }
//                 action("Assign Lot No.")
//                 {
//                     Caption = 'Assign &Lot No.';
//                     Image = Lot;

//                     trigger OnAction()
//                     begin
//                         IF InsertIsBlocked THEN
//                           EXIT;
//                         AssignLotNo;
//                     end;
//                 }
//                 action("Create Customized SN")
//                 {
//                     Caption = 'Create Customized SN';
//                     Image = CreateSerialNo;

//                     trigger OnAction()
//                     begin
//                         IF InsertIsBlocked THEN
//                           EXIT;
//                         CreateCustomizedSN;
//                     end;
//                 }
//                 action("Refresh Availability")
//                 {
//                     Caption = 'Refresh Availability';
//                     Image = Refresh;

//                     trigger OnAction()
//                     begin
//                         ItemTrackingDataCollection.RefreshLotSNAvailability(Rec,TRUE);
//                     end;
//                 }
//             }
//             group(FunctionsDemand)
//             {
//                 Caption = 'F&unctions';
//                 Image = "Action";
//                 Visible = FunctionsDemandVisible;
//                 action("Assign &Serial No.")
//                 {
//                     Caption = 'Assign &Serial No.';
//                     Image = SerialNo;

//                     trigger OnAction()
//                     begin
//                         IF InsertIsBlocked THEN
//                           EXIT;
//                         AssignSerialNo;
//                     end;
//                 }
//                 action("Assign &Lot No.")
//                 {
//                     Caption = 'Assign &Lot No.';
//                     Image = Lot;

//                     trigger OnAction()
//                     begin
//                         IF InsertIsBlocked THEN
//                           EXIT;
//                         AssignLotNo;
//                     end;
//                 }
//                 action(CreateCustomizedSN)
//                 {
//                     Caption = 'Create Customized SN';
//                     Image = CreateSerialNo;

//                     trigger OnAction()
//                     begin
//                         IF InsertIsBlocked THEN
//                           EXIT;
//                         CreateCustomizedSN;
//                     end;
//                 }
//                 action("Select Entries")
//                 {
//                     Caption = 'Select &Entries';
//                     Image = SelectEntries;
//                     Promoted = true;
//                     PromotedCategory = Process;
//                     PromotedIsBig = true;

//                     trigger OnAction()
//                     begin
//                         IF InsertIsBlocked THEN
//                           EXIT;

//                         SelectEntries;
//                     end;
//                 }
//                 action("Refresh Availability")
//                 {
//                     Caption = 'Refresh Availability';
//                     Image = Refresh;
//                     Promoted = true;
//                     PromotedCategory = Process;
//                     PromotedIsBig = true;

//                     trigger OnAction()
//                     begin
//                         ItemTrackingDataCollection.RefreshLotSNAvailability(Rec,TRUE);
//                     end;
//                 }
//             }
//         }
//     }

//     trigger OnAfterGetCurrRecord()
//     begin
//         UpdateExpDateEditable;
//     end;

//     trigger OnAfterGetRecord()
//     begin
//         ExpirationDateOnFormat;
//     end;

//     trigger OnClosePage()
//     begin
//         IF UpdateUndefinedQty THEN
//           WriteToDatabase;
//         IF FormRunMode = FormRunMode::"Drop Shipment" THEN
//           CASE CurrentSourceType OF
//             DATABASE::"Sales Line":
//               SynchronizeLinkedSources(STRSUBSTNO(Text015,Text016));
//             DATABASE::"Purchase Line":
//               SynchronizeLinkedSources(STRSUBSTNO(Text015,Text017));
//           END;
//         IF FormRunMode = FormRunMode::Transfer THEN
//           SynchronizeLinkedSources('');
//     end;

//     trigger OnDeleteRecord(): Boolean
//     var
//         TrackingSpec: Record "336";
//         WMSManagement: Codeunit "7302";
//         AlreadyDeleted: Boolean;
//     begin
//         TrackingSpec."Item No." := "Item No.";
//         TrackingSpec."Location Code" := "Location Code";
//         TrackingSpec."Source Type" := "Source Type";
//         TrackingSpec."Source Subtype" := "Source Subtype";
//         WMSManagement.CheckItemTrackingChange(TrackingSpec,Rec);

//         IF NOT DeleteIsBlocked THEN BEGIN
//           AlreadyDeleted := TempItemTrackLineDelete.GET("Entry No.");
//           TempItemTrackLineDelete.TRANSFERFIELDS(Rec);
//           DELETE(TRUE);

//           IF NOT AlreadyDeleted THEN
//             TempItemTrackLineDelete.INSERT;
//           ItemTrackingDataCollection.UpdateLotSNDataSetWithChange(
//             TempItemTrackLineDelete,CurrentSignFactor * SourceQuantityArray[1] < 0,CurrentSignFactor,2);
//           IF TempItemTrackLineInsert.GET("Entry No.") THEN
//             TempItemTrackLineInsert.DELETE;
//           IF TempItemTrackLineModify.GET("Entry No.") THEN
//             TempItemTrackLineModify.DELETE;
//         END;
//         CalculateSums;

//         EXIT(FALSE);
//     end;

//     trigger OnInit()
//     begin
//         "Warranty DateEditable" := TRUE;
//         "Expiration DateEditable" := TRUE;
//         "New Expiration DateEditable" := TRUE;
//         "New Lot No.Editable" := TRUE;
//         "New Serial No.Editable" := TRUE;
//         DescriptionEditable := TRUE;
//         "Lot No.Editable" := TRUE;
//         "Serial No.Editable" := TRUE;
//         "Quantity (Base)Editable" := TRUE;
//         "Qty. to Invoice (Base)Editable" := TRUE;
//         "Qty. to Handle (Base)Editable" := TRUE;
//         FunctionsDemandVisible := TRUE;
//         FunctionsSupplyVisible := TRUE;
//         ButtonLineVisible := TRUE;
//         "Qty. to Invoice (Base)Visible" := TRUE;
//         Invoice3Visible := TRUE;
//         Invoice2Visible := TRUE;
//         Invoice1Visible := TRUE;
//         "Qty. to Handle (Base)Visible" := TRUE;
//         Handle3Visible := TRUE;
//         Handle2Visible := TRUE;
//         Handle1Visible := TRUE;
//         "Location CodeEditable" := TRUE;
//         "Variant CodeEditable" := TRUE;
//         "Item No.Editable" := TRUE;
//         InboundIsSet := FALSE;
//         ApplFromItemEntryVisible := FALSE;
//         ApplToItemEntryVisible := FALSE;
//     end;

//     trigger OnInsertRecord(BelowxRec: Boolean): Boolean
//     begin
//         IF "Entry No." <> 0 THEN
//           EXIT(FALSE);
//         "Entry No." := NextEntryNo;
//         IF (NOT InsertIsBlocked) AND (NOT ZeroLineExists) THEN
//           IF NOT TestTempSpecificationExists THEN BEGIN
//             TempItemTrackLineInsert.TRANSFERFIELDS(Rec);
//             TempItemTrackLineInsert.INSERT;
//             INSERT;
//             ItemTrackingDataCollection.UpdateLotSNDataSetWithChange(
//               TempItemTrackLineInsert,CurrentSignFactor * SourceQuantityArray[1] < 0,CurrentSignFactor,0);
//           END;
//         CalculateSums;

//         EXIT(FALSE);
//     end;

//     trigger OnModifyRecord(): Boolean
//     var
//         xTempTrackingSpec: Record "336" temporary;
//     begin
//         IF InsertIsBlocked THEN
//           IF (xRec."Lot No." <> "Lot No.") OR
//              (xRec."Serial No." <> "Serial No.") OR
//              (xRec."Quantity (Base)" <> "Quantity (Base)")
//           THEN
//             EXIT(FALSE);

//         IF NOT TestTempSpecificationExists THEN BEGIN
//           MODIFY;

//           IF (xRec."Lot No." <> "Lot No.") OR (xRec."Serial No." <> "Serial No.") THEN BEGIN
//             xTempTrackingSpec := xRec;
//             ItemTrackingDataCollection.UpdateLotSNDataSetWithChange(
//               xTempTrackingSpec,CurrentSignFactor * SourceQuantityArray[1] < 0,CurrentSignFactor,2);
//           END;

//           IF TempItemTrackLineModify.GET("Entry No.") THEN
//             TempItemTrackLineModify.DELETE;
//           IF TempItemTrackLineInsert.GET("Entry No.") THEN BEGIN
//             TempItemTrackLineInsert.TRANSFERFIELDS(Rec);
//             TempItemTrackLineInsert.MODIFY;
//             ItemTrackingDataCollection.UpdateLotSNDataSetWithChange(
//               TempItemTrackLineInsert,CurrentSignFactor * SourceQuantityArray[1] < 0,CurrentSignFactor,1);
//           END ELSE BEGIN
//             TempItemTrackLineModify.TRANSFERFIELDS(Rec);
//             TempItemTrackLineModify.INSERT;
//             ItemTrackingDataCollection.UpdateLotSNDataSetWithChange(
//               TempItemTrackLineModify,CurrentSignFactor * SourceQuantityArray[1] < 0,CurrentSignFactor,1);
//           END;
//         END;
//         CalculateSums;

//         EXIT(FALSE);
//     end;

//     trigger OnNewRecord(BelowxRec: Boolean)
//     begin
//         "Qty. per Unit of Measure" := QtyPerUOM;
//     end;

//     trigger OnOpenPage()
//     begin
//         "Item No.Editable" := FALSE;
//         "Variant CodeEditable" := FALSE;
//         "Location CodeEditable" := FALSE;
//         IF InboundIsSet THEN BEGIN
//           ApplFromItemEntryVisible := Inbound;
//           ApplToItemEntryVisible := NOT Inbound;
//         END;

//         UpdateUndefinedQtyArray;

//         CurrentFormIsOpen := TRUE;
//     end;

//     trigger OnQueryClosePage(CloseAction: Action): Boolean
//     begin
//         IF NOT UpdateUndefinedQty THEN
//           EXIT(CONFIRM(Text006));

//         IF NOT ItemTrackingDataCollection.RefreshLotSNAvailability(Rec,FALSE) THEN BEGIN
//           CurrPage.UPDATE;
//           EXIT(CONFIRM(Text019,TRUE));
//         END;
//     end;

//     var
//         xTempItemTrackingLine: Record "336" temporary;
//         TotalItemTrackingLine: Record "336";
//         TempItemTrackLineInsert: Record "336" temporary;
//         TempItemTrackLineModify: Record "336" temporary;
//         TempItemTrackLineDelete: Record "336" temporary;
//         TempItemTrackLineReserv: Record "336" temporary;
//         Item: Record "27";
//         ItemTrackingCode: Record "6502";
//         TempReservEntry: Record "337" temporary;
//         NoSeriesMgt: Codeunit "396";
//         ItemTrackingMgt: Codeunit "6500";
//         ReservEngineMgt: Codeunit "99000831";
//         ItemTrackingDataCollection: Codeunit "6501";
//         UndefinedQtyArray: array [3] of Decimal;
//         SourceQuantityArray: array [5] of Decimal;
//         QtyPerUOM: Decimal;
//         QtyToAddAsBlank: Decimal;
//         CurrentSignFactor: Integer;
//         Text002: Label 'Quantity must be %1.';
//         Text003: Label 'negative';
//         Text004: Label 'positive';
//         LastEntryNo: Integer;
//         CurrentSourceType: Integer;
//         ExpectedReceiptDate: Date;
//         ShipmentDate: Date;
//         Text005: Label 'Error when writing to database.';
//         Text006: Label 'The corrections cannot be saved as excess quantity has been defined.\Close the form anyway?';
//         Text007: Label 'Another user has modified the item tracking data since it was retrieved from the database.\Start again.';
//         CurrentEntryStatus: Option Reservation,Tracking,Surplus,Prospect;
//         FormRunMode: Option ,Reclass,"Combined Ship/Rcpt","Drop Shipment",Transfer;
//         InsertIsBlocked: Boolean;
//         Text008: Label 'The quantity to create must be an integer.';
//         Text009: Label 'The quantity to create must be positive.';
//         Text011: Label 'Tracking specification with Serial No. %1 and Lot No. %2 already exists.';
//         Text012: Label 'Tracking specification with Serial No. %1 already exists.';
//         Text013: Label 'The string %1 contains no number and cannot be incremented.';
//         DeleteIsBlocked: Boolean;
//         Text014: Label 'The total item tracking quantity %1 exceeds the %2 quantity %3.\The changes cannot be saved to the database.';
//         Text015: Label 'Do you want to synchronize item tracking on the line with item tracking on the related drop shipment %1?';
//         BlockCommit: Boolean;
//         IsCorrection: Boolean;
//         CurrentFormIsOpen: Boolean;
//         CalledFromSynchWhseItemTrkg: Boolean;
//         SNAvailabilityActive: Boolean;
//         LotAvailabilityActive: Boolean;
//         Inbound: Boolean;
//         CurrentSourceCaption: Text[255];
//         CurrentSourceRowID: Text[100];
//         SecondSourceRowID: Text[100];
//         Text016: Label 'purchase order line';
//         Text017: Label 'sales order line';
//         Text018: Label 'Saving item tracking line changes';
//         ForBinCode: Code[20];
//         Text019: Label 'There are availability warnings on one or more lines.\Close the form anyway?';
//         Text020: Label 'Placeholder';
//         IsPick: Boolean;
//         [InDataSet]
//         ApplFromItemEntryVisible: Boolean;
//         [InDataSet]
//         ApplToItemEntryVisible: Boolean;
//         [InDataSet]
//         "Item No.Editable": Boolean;
//         [InDataSet]
//         "Variant CodeEditable": Boolean;
//         [InDataSet]
//         "Location CodeEditable": Boolean;
//         [InDataSet]
//         Handle1Visible: Boolean;
//         [InDataSet]
//         Handle2Visible: Boolean;
//         [InDataSet]
//         Handle3Visible: Boolean;
//         [InDataSet]
//         "Qty. to Handle (Base)Visible": Boolean;
//         [InDataSet]
//         Invoice1Visible: Boolean;
//         [InDataSet]
//         Invoice2Visible: Boolean;
//         [InDataSet]
//         Invoice3Visible: Boolean;
//         [InDataSet]
//         "Qty. to Invoice (Base)Visible": Boolean;
//         [InDataSet]
//         "New Serial No.Visible": Boolean;
//         [InDataSet]
//         "New Lot No.Visible": Boolean;
//         [InDataSet]
//         "New Expiration DateVisible": Boolean;
//         [InDataSet]
//         ButtonLineReclassVisible: Boolean;
//         [InDataSet]
//         ButtonLineVisible: Boolean;
//         [InDataSet]
//         FunctionsSupplyVisible: Boolean;
//         [InDataSet]
//         FunctionsDemandVisible: Boolean;
//         InboundIsSet: Boolean;
//         [InDataSet]
//         "Qty. to Handle (Base)Editable": Boolean;
//         [InDataSet]
//         "Qty. to Invoice (Base)Editable": Boolean;
//         [InDataSet]
//         "Quantity (Base)Editable": Boolean;
//         [InDataSet]
//         "Serial No.Editable": Boolean;
//         [InDataSet]
//         "Lot No.Editable": Boolean;
//         [InDataSet]
//         DescriptionEditable: Boolean;
//         [InDataSet]
//         "New Serial No.Editable": Boolean;
//         [InDataSet]
//         "New Lot No.Editable": Boolean;
//         [InDataSet]
//         "New Expiration DateEditable": Boolean;
//         [InDataSet]
//         "Expiration DateEditable": Boolean;
//         [InDataSet]
//         "Warranty DateEditable": Boolean;
//         ExcludePostedEntries: Boolean;
//         ProdOrderLineHandling: Boolean;

//     procedure SetFormRunMode(Mode: Option ,Reclass,"Combined Ship/Rcpt","Drop Shipment")
//     begin
//         FormRunMode := Mode;
//     end;

//     procedure SetSource(TrackingSpecification: Record "336";AvailabilityDate: Date)
//     var
//         ReservEntry: Record "337";
//         TempTrackingSpecification: Record "336" temporary;
//         TempTrackingSpecification2: Record "336" temporary;
//         CreateReservEntry: Codeunit "99000830";
//         Controls: Option Handle,Invoice,Quantity,Reclass,LotSN;
//     begin
//         GetItem(TrackingSpecification."Item No.");
//         ForBinCode := TrackingSpecification."Bin Code";
//         SetFilters(TrackingSpecification);
//         TempTrackingSpecification.DELETEALL;
//         TempItemTrackLineInsert.DELETEALL;
//         TempItemTrackLineModify.DELETEALL;
//         TempItemTrackLineDelete.DELETEALL;

//         TempReservEntry.DELETEALL;
//         LastEntryNo := 0;
//         IF ItemTrackingMgt.IsOrderNetworkEntity(TrackingSpecification."Source Type",
//              TrackingSpecification."Source Subtype") AND NOT (FormRunMode = FormRunMode::"Drop Shipment")
//         THEN
//           CurrentEntryStatus := CurrentEntryStatus::Surplus
//         ELSE
//           CurrentEntryStatus := CurrentEntryStatus::Prospect;

//         // Set controls for Qty to handle:
//         SetControls(Controls::Handle,GetHandleSource(TrackingSpecification));
//         // Set controls for Qty to Invoice:
//         SetControls(Controls::Invoice,GetInvoiceSource(TrackingSpecification));

//         SetControls(Controls::Reclass,FormRunMode = FormRunMode::Reclass);

//         IF FormRunMode = FormRunMode::"Combined Ship/Rcpt" THEN
//           SetControls(Controls::LotSN,FALSE);
//         IF ItemTrackingMgt.ItemTrkgIsManagedByWhse(
//              TrackingSpecification."Source Type",
//              TrackingSpecification."Source Subtype",
//              TrackingSpecification."Source ID",
//              TrackingSpecification."Source Prod. Order Line",
//              TrackingSpecification."Source Ref. No.",
//              TrackingSpecification."Location Code",
//              TrackingSpecification."Item No.")
//         THEN BEGIN
//           SetControls(Controls::Quantity,FALSE);
//           "Qty. to Handle (Base)Editable" := TRUE;
//           DeleteIsBlocked := TRUE;
//         END;

//         ReservEntry."Source Type" := TrackingSpecification."Source Type";
//         ReservEntry."Source Subtype" := TrackingSpecification."Source Subtype";
//         CurrentSignFactor := CreateReservEntry.SignFactor(ReservEntry);
//         CurrentSourceCaption := ReservEntry.TextCaption;
//         CurrentSourceType := ReservEntry."Source Type";

//         IF CurrentSignFactor < 0 THEN BEGIN
//           ExpectedReceiptDate := 0D;
//           ShipmentDate := AvailabilityDate;
//         END ELSE BEGIN
//           ExpectedReceiptDate := AvailabilityDate;
//           ShipmentDate := 0D;
//         END;

//         SourceQuantityArray[1] := TrackingSpecification."Quantity (Base)";
//         SourceQuantityArray[2] := TrackingSpecification."Qty. to Handle (Base)";
//         SourceQuantityArray[3] := TrackingSpecification."Qty. to Invoice (Base)";
//         SourceQuantityArray[4] := TrackingSpecification."Quantity Handled (Base)";
//         SourceQuantityArray[5] := TrackingSpecification."Quantity Invoiced (Base)";
//         QtyPerUOM := TrackingSpecification."Qty. per Unit of Measure";

//         ReservEntry.SETCURRENTKEY(
//           "Source ID","Source Ref. No.","Source Type","Source Subtype",
//           "Source Batch Name","Source Prod. Order Line","Reservation Status");

//         ReservEntry.SETRANGE("Source ID",TrackingSpecification."Source ID");
//         ReservEntry.SETRANGE("Source Ref. No.",TrackingSpecification."Source Ref. No.");
//         ReservEntry.SETRANGE("Source Type",TrackingSpecification."Source Type");
//         ReservEntry.SETRANGE("Source Subtype",TrackingSpecification."Source Subtype");
//         ReservEntry.SETRANGE("Source Batch Name",TrackingSpecification."Source Batch Name");
//         ReservEntry.SETRANGE("Source Prod. Order Line",TrackingSpecification."Source Prod. Order Line");

//         // Transfer Receipt gets special treatment:
//         IF (TrackingSpecification."Source Type" = DATABASE::"Transfer Line") AND
//            (FormRunMode <> FormRunMode::Transfer) AND
//            (TrackingSpecification."Source Subtype" = 1)
//         THEN BEGIN
//           ReservEntry.SETRANGE("Source Subtype",0);
//           AddReservEntriesToTempRecSet(ReservEntry,TempTrackingSpecification2,TRUE,8421504);
//           ReservEntry.SETRANGE("Source Subtype",1);
//           ReservEntry.SETRANGE("Source Prod. Order Line",TrackingSpecification."Source Ref. No.");
//           ReservEntry.SETRANGE("Source Ref. No.");
//           DeleteIsBlocked := TRUE;
//           SetControls(Controls::Quantity,FALSE);
//         END;

//         AddReservEntriesToTempRecSet(ReservEntry,TempTrackingSpecification,FALSE,0);

//         TempReservEntry.COPYFILTERS(ReservEntry);

//         TrackingSpecification.SETCURRENTKEY(
//           "Source ID","Source Type","Source Subtype",
//           "Source Batch Name","Source Prod. Order Line","Source Ref. No.");

//         TrackingSpecification.SETRANGE("Source ID",TrackingSpecification."Source ID");
//         TrackingSpecification.SETRANGE("Source Type",TrackingSpecification."Source Type");
//         TrackingSpecification.SETRANGE("Source Subtype",TrackingSpecification."Source Subtype");
//         TrackingSpecification.SETRANGE("Source Batch Name",TrackingSpecification."Source Batch Name");
//         TrackingSpecification.SETRANGE("Source Prod. Order Line",TrackingSpecification."Source Prod. Order Line");
//         TrackingSpecification.SETRANGE("Source Ref. No.",TrackingSpecification."Source Ref. No.");

//         IF TrackingSpecification.FINDSET THEN
//           REPEAT
//             TempTrackingSpecification := TrackingSpecification;
//             TempTrackingSpecification.INSERT;
//           UNTIL TrackingSpecification.NEXT = 0;

//         // Data regarding posted quantities on transfers is collected from Item Ledger Entries:
//         IF TrackingSpecification."Source Type" = DATABASE::"Transfer Line" THEN
//           CollectPostedTransferEntries(TrackingSpecification,TempTrackingSpecification);

//         // Data regarding posted quantities on assembly orders is collected from Item Ledger Entries:
//         IF NOT ExcludePostedEntries THEN
//           IF (TrackingSpecification."Source Type" = DATABASE::"Assembly Line") OR
//              (TrackingSpecification."Source Type" = DATABASE::"Assembly Header")
//           THEN
//             CollectPostedAssemblyEntries(TrackingSpecification,TempTrackingSpecification);

//         // Data regarding posted output quantities on prod.orders is collected from Item Ledger Entries:
//         IF TrackingSpecification."Source Type" = DATABASE::"Prod. Order Line" THEN
//           IF TrackingSpecification."Source Subtype" = 3 THEN
//             CollectPostedOutputEntries(TrackingSpecification,TempTrackingSpecification);

//         // If run for Drop Shipment a RowID is prepared for synchronisation:
//         IF FormRunMode = FormRunMode::"Drop Shipment" THEN
//           CurrentSourceRowID := ItemTrackingMgt.ComposeRowID(TrackingSpecification."Source Type",
//               TrackingSpecification."Source Subtype",TrackingSpecification."Source ID",
//               TrackingSpecification."Source Batch Name",TrackingSpecification."Source Prod. Order Line",
//               TrackingSpecification."Source Ref. No.");

//         // Synchronization of outbound transfer order:
//         IF (TrackingSpecification."Source Type" = DATABASE::"Transfer Line") AND
//            (TrackingSpecification."Source Subtype" = 0)
//         THEN BEGIN
//           BlockCommit := TRUE;
//           CurrentSourceRowID := ItemTrackingMgt.ComposeRowID(TrackingSpecification."Source Type",
//               TrackingSpecification."Source Subtype",TrackingSpecification."Source ID",
//               TrackingSpecification."Source Batch Name",TrackingSpecification."Source Prod. Order Line",
//               TrackingSpecification."Source Ref. No.");
//           SecondSourceRowID := ItemTrackingMgt.ComposeRowID(TrackingSpecification."Source Type",
//               1,TrackingSpecification."Source ID",
//               TrackingSpecification."Source Batch Name",TrackingSpecification."Source Prod. Order Line",
//               TrackingSpecification."Source Ref. No.");
//           FormRunMode := FormRunMode::Transfer;
//         END;

//         AddToGlobalRecordSet(TempTrackingSpecification);
//         AddToGlobalRecordSet(TempTrackingSpecification2);
//         CalculateSums;

//         ItemTrackingDataCollection.SetCurrentBinAndItemTrkgCode(ForBinCode,ItemTrackingCode);
//         ItemTrackingDataCollection.RetrieveLookupData(Rec,FALSE);

//         FunctionsDemandVisible := CurrentSignFactor * SourceQuantityArray[1] < 0;
//         FunctionsSupplyVisible := NOT FunctionsDemandVisible;
//     end;

//     procedure SetSecondSourceQuantity(SecondSourceQuantityArray: array [3] of Decimal)
//     var
//         Controls: Option Handle,Invoice;
//     begin
//         CASE SecondSourceQuantityArray[1] OF
//           DATABASE::"Warehouse Receipt Line",DATABASE::"Warehouse Shipment Line":
//             BEGIN
//               SourceQuantityArray[2] := SecondSourceQuantityArray[2]; // "Qty. to Handle (Base)"
//               SourceQuantityArray[3] := SecondSourceQuantityArray[3]; // "Qty. to Invoice (Base)"
//               SetControls(Controls::Invoice,FALSE);
//             END;
//           ELSE
//             EXIT;
//         END;
//         CalculateSums;
//     end;

//     procedure SetSecondSourceRowID(RowID: Text[100])
//     begin
//         SecondSourceRowID := RowID;
//     end;

//     local procedure AddReservEntriesToTempRecSet(var ReservEntry: Record "337";var TempTrackingSpecification: Record "336" temporary;SwapSign: Boolean;Color: Integer)
//     begin
//         IF ReservEntry.FINDSET THEN
//           REPEAT
//             IF Color = 0 THEN BEGIN
//               TempReservEntry := ReservEntry;
//               TempReservEntry.INSERT;
//             END;
//             IF (ReservEntry."Lot No." <> '') OR (ReservEntry."Serial No." <> '') THEN BEGIN
//               TempTrackingSpecification.TRANSFERFIELDS(ReservEntry);
//               // Ensure uniqueness of Entry No. by making it negative:
//               TempTrackingSpecification."Entry No." *= -1;
//               IF SwapSign THEN
//                 TempTrackingSpecification."Quantity (Base)" *= -1;
//               IF Color <> 0 THEN BEGIN
//                 TempTrackingSpecification."Quantity Handled (Base)" :=
//                   TempTrackingSpecification."Quantity (Base)";
//                 TempTrackingSpecification."Quantity Invoiced (Base)" :=
//                   TempTrackingSpecification."Quantity (Base)";
//                 TempTrackingSpecification."Qty. to Handle (Base)" := 0;
//                 TempTrackingSpecification."Qty. to Invoice (Base)" := 0;
//               END;
//               TempTrackingSpecification."Buffer Status" := Color;
//               TempTrackingSpecification.INSERT;
//             END;
//           UNTIL ReservEntry.NEXT = 0;
//     end;

//     local procedure AddToGlobalRecordSet(var TempTrackingSpecification: Record "336" temporary)
//     var
//         ExpDate: Date;
//         EntriesExist: Boolean;
//     begin
//         TempTrackingSpecification.SETCURRENTKEY("Lot No.","Serial No.");
//         IF TempTrackingSpecification.FIND('-') THEN
//           REPEAT
//             TempTrackingSpecification.SETRANGE("Lot No.",TempTrackingSpecification."Lot No.");
//             TempTrackingSpecification.SETRANGE("Serial No.",TempTrackingSpecification."Serial No.");
//             TempTrackingSpecification.CALCSUMS("Quantity (Base)","Qty. to Handle (Base)",
//               "Qty. to Invoice (Base)","Quantity Handled (Base)","Quantity Invoiced (Base)");
//             IF TempTrackingSpecification."Quantity (Base)" <> 0 THEN BEGIN
//               Rec := TempTrackingSpecification;
//               "Quantity (Base)" *= CurrentSignFactor;
//               "Qty. to Handle (Base)" *= CurrentSignFactor;
//               "Qty. to Invoice (Base)" *= CurrentSignFactor;
//               "Quantity Handled (Base)" *= CurrentSignFactor;
//               "Quantity Invoiced (Base)" *= CurrentSignFactor;
//               "Qty. to Handle" :=
//                 CalcQty("Qty. to Handle (Base)");
//               "Qty. to Invoice" :=
//                 CalcQty("Qty. to Invoice (Base)");
//               "Entry No." := NextEntryNo;

//               ExpDate := ItemTrackingMgt.ExistingExpirationDate(
//                   "Item No.","Variant Code",
//                   "Lot No.","Serial No.",FALSE,EntriesExist);

//               IF ExpDate <> 0D THEN BEGIN
//                 "Expiration Date" := ExpDate;
//                 "Buffer Status2" := "Buffer Status2"::"ExpDate blocked";
//               END;

//               INSERT;

//               IF "Buffer Status" = 0 THEN BEGIN
//                 xTempItemTrackingLine := Rec;
//                 xTempItemTrackingLine.INSERT;
//               END;
//             END;

//             TempTrackingSpecification.FIND('+');
//             TempTrackingSpecification.SETRANGE("Lot No.");
//             TempTrackingSpecification.SETRANGE("Serial No.");
//           UNTIL TempTrackingSpecification.NEXT = 0;
//     end;

//     local procedure SetControls(Controls: Option Handle,Invoice,Quantity,Reclass,LotSN;SetAccess: Boolean)
//     begin
//         CASE Controls OF
//           Controls::Handle:
//             BEGIN
//               Handle1Visible := SetAccess;
//               Handle2Visible := SetAccess;
//               Handle3Visible := SetAccess;
//               "Qty. to Handle (Base)Visible" := SetAccess;
//               "Qty. to Handle (Base)Editable" := SetAccess;
//             END;
//           Controls::Invoice:
//             BEGIN
//               Invoice1Visible := SetAccess;
//               Invoice2Visible := SetAccess;
//               Invoice3Visible := SetAccess;
//               "Qty. to Invoice (Base)Visible" := SetAccess;
//               "Qty. to Invoice (Base)Editable" := SetAccess;
//             END;
//           Controls::Quantity:
//             BEGIN
//               "Quantity (Base)Editable" := SetAccess;
//               "Serial No.Editable" := SetAccess;
//               "Lot No.Editable" := SetAccess;
//               DescriptionEditable := SetAccess;
//               InsertIsBlocked := TRUE;
//             END;
//           Controls::Reclass:
//             BEGIN
//               "New Serial No.Visible" := SetAccess;
//               "New Serial No.Editable" := SetAccess;
//               "New Lot No.Visible" := SetAccess;
//               "New Lot No.Editable" := SetAccess;
//               "New Expiration DateVisible" := SetAccess;
//               "New Expiration DateEditable" := SetAccess;
//               ButtonLineReclassVisible := SetAccess;
//               ButtonLineVisible := NOT SetAccess;
//             END;
//           Controls::LotSN:
//             BEGIN
//               "Serial No.Editable" := SetAccess;
//               "Lot No.Editable" := SetAccess;
//               "Expiration DateEditable" := SetAccess;
//               "Warranty DateEditable" := SetAccess;
//               InsertIsBlocked := SetAccess;
//             END;
//         END;
//     end;

//     local procedure GetItem(ItemNo: Code[20])
//     begin
//         IF Item."No." <> ItemNo THEN BEGIN
//           Item.GET(ItemNo);
//           Item.TESTFIELD("Item Tracking Code");
//           IF ItemTrackingCode.Code <> Item."Item Tracking Code" THEN
//             ItemTrackingCode.GET(Item."Item Tracking Code");
//         END;
//     end;

//     local procedure SetFilters(TrackingSpecification: Record "336")
//     begin
//         FILTERGROUP := 2;
//         SETCURRENTKEY("Source ID","Source Type","Source Subtype","Source Batch Name","Source Prod. Order Line","Source Ref. No.");
//         SETRANGE("Source ID",TrackingSpecification."Source ID");
//         SETRANGE("Source Type",TrackingSpecification."Source Type");
//         SETRANGE("Source Subtype",TrackingSpecification."Source Subtype");
//         SETRANGE("Source Batch Name",TrackingSpecification."Source Batch Name");
//         IF (TrackingSpecification."Source Type" = DATABASE::"Transfer Line") AND
//            (TrackingSpecification."Source Subtype" = 1)
//         THEN BEGIN
//           SETFILTER("Source Prod. Order Line",'0 | ' + FORMAT(TrackingSpecification."Source Ref. No."));
//           SETRANGE("Source Ref. No.");
//         END ELSE BEGIN
//           SETRANGE("Source Prod. Order Line",TrackingSpecification."Source Prod. Order Line");
//           SETRANGE("Source Ref. No.",TrackingSpecification."Source Ref. No.");
//         END;
//         SETRANGE("Item No.",TrackingSpecification."Item No.");
//         SETRANGE("Location Code",TrackingSpecification."Location Code");
//         SETRANGE("Variant Code",TrackingSpecification."Variant Code");
//         FILTERGROUP := 0;
//     end;

//     local procedure CheckLine(TrackingLine: Record "336"): Boolean
//     begin
//         IF TrackingLine."Quantity (Base)" * SourceQuantityArray[1] < 0 THEN
//           IF SourceQuantityArray[1] < 0 THEN
//             ERROR(Text002,Text003)
//           ELSE
//             ERROR(Text002,Text004);
//     end;

//     local procedure CalculateSums()
//     var
//         xTrackingSpec: Record "336";
//     begin
//         xTrackingSpec.COPY(Rec);
//         RESET;
//         CALCSUMS("Quantity (Base)",
//           "Qty. to Handle (Base)",
//           "Qty. to Invoice (Base)");
//         TotalItemTrackingLine := Rec;
//         COPY(xTrackingSpec);

//         UpdateUndefinedQtyArray;
//     end;

//     local procedure UpdateUndefinedQty(): Boolean
//     begin
//         UpdateUndefinedQtyArray;
//         IF ProdOrderLineHandling THEN // Avoid check for prod.journal lines
//           EXIT(TRUE);
//         EXIT(ABS(SourceQuantityArray[1]) >= ABS(TotalItemTrackingLine."Quantity (Base)"));
//     end;

//     local procedure UpdateUndefinedQtyArray()
//     begin
//         UndefinedQtyArray[1] := SourceQuantityArray[1] - TotalItemTrackingLine."Quantity (Base)";
//         UndefinedQtyArray[2] := SourceQuantityArray[2] - TotalItemTrackingLine."Qty. to Handle (Base)";
//         UndefinedQtyArray[3] := SourceQuantityArray[3] - TotalItemTrackingLine."Qty. to Invoice (Base)";
//     end;

//     local procedure TempRecIsValid() OK: Boolean
//     var
//         ReservEntry: Record "337";
//         RecordCount: Integer;
//         IdenticalArray: array [2] of Boolean;
//     begin
//         OK := FALSE;
//         TempReservEntry.SETCURRENTKEY("Entry No.",Positive);
//         ReservEntry.SETCURRENTKEY("Source ID","Source Ref. No.","Source Type",
//           "Source Subtype","Source Batch Name","Source Prod. Order Line");

//         ReservEntry.COPYFILTERS(TempReservEntry);

//         IF ReservEntry.FINDSET THEN
//           REPEAT
//             IF NOT TempReservEntry.GET(ReservEntry."Entry No.",ReservEntry.Positive) THEN
//               EXIT(FALSE);
//             IF NOT EntriesAreIdentical(ReservEntry,TempReservEntry,IdenticalArray) THEN
//               EXIT(FALSE);
//             RecordCount += 1;
//           UNTIL ReservEntry.NEXT = 0;

//         OK := RecordCount = TempReservEntry.COUNT;
//     end;

//     local procedure EntriesAreIdentical(var ReservEntry1: Record "337";var ReservEntry2: Record "337";var IdenticalArray: array [2] of Boolean): Boolean
//     begin
//         IdenticalArray[1] := (
//                               (ReservEntry1."Entry No." = ReservEntry2."Entry No.") AND
//                               (ReservEntry1."Item No." = ReservEntry2."Item No.") AND
//                               (ReservEntry1."Location Code" = ReservEntry2."Location Code") AND
//                               (ReservEntry1."Quantity (Base)" = ReservEntry2."Quantity (Base)") AND
//                               (ReservEntry1."Reservation Status" = ReservEntry2."Reservation Status") AND
//                               (ReservEntry1."Creation Date" = ReservEntry2."Creation Date") AND
//                               (ReservEntry1."Transferred from Entry No." = ReservEntry2."Transferred from Entry No.") AND
//                               (ReservEntry1."Source Type" = ReservEntry2."Source Type") AND
//                               (ReservEntry1."Source Subtype" = ReservEntry2."Source Subtype") AND
//                               (ReservEntry1."Source ID" = ReservEntry2."Source ID") AND
//                               (ReservEntry1."Source Batch Name" = ReservEntry2."Source Batch Name") AND
//                               (ReservEntry1."Source Prod. Order Line" = ReservEntry2."Source Prod. Order Line") AND
//                               (ReservEntry1."Source Ref. No." = ReservEntry2."Source Ref. No.") AND
//                               (ReservEntry1."Expected Receipt Date" = ReservEntry2."Expected Receipt Date") AND
//                               (ReservEntry1."Shipment Date" = ReservEntry2."Shipment Date") AND
//                               (ReservEntry1."Serial No." = ReservEntry2."Serial No.") AND
//                               (ReservEntry1."Created By" = ReservEntry2."Created By") AND
//                               (ReservEntry1."Changed By" = ReservEntry2."Changed By") AND
//                               (ReservEntry1.Positive = ReservEntry2.Positive) AND
//                               (ReservEntry1."Qty. per Unit of Measure" = ReservEntry2."Qty. per Unit of Measure") AND
//                               (ReservEntry1.Quantity = ReservEntry2.Quantity) AND
//                               (ReservEntry1."Action Message Adjustment" = ReservEntry2."Action Message Adjustment") AND
//                               (ReservEntry1.Binding = ReservEntry2.Binding) AND
//                               (ReservEntry1."Suppressed Action Msg." = ReservEntry2."Suppressed Action Msg.") AND
//                               (ReservEntry1."Planning Flexibility" = ReservEntry2."Planning Flexibility") AND
//                               (ReservEntry1."Lot No." = ReservEntry2."Lot No.") AND
//                               (ReservEntry1."Variant Code" = ReservEntry2."Variant Code") AND
//                               (ReservEntry1."Quantity Invoiced (Base)" = ReservEntry2."Quantity Invoiced (Base)"));

//         IdenticalArray[2] := (
//                               (ReservEntry1.Description = ReservEntry2.Description) AND
//                               (ReservEntry1."New Serial No." = ReservEntry2."New Serial No.") AND
//                               (ReservEntry1."New Lot No." = ReservEntry2."New Lot No.") AND
//                               (ReservEntry1."Expiration Date" = ReservEntry2."Expiration Date") AND
//                               (ReservEntry1."Warranty Date" = ReservEntry2."Warranty Date") AND
//                               (ReservEntry1."New Expiration Date" = ReservEntry2."New Expiration Date"));

//         EXIT(IdenticalArray[1] AND IdenticalArray[2]);
//     end;

//     local procedure QtyToHandleAndInvoiceChanged(var ReservEntry1: Record "337";var ReservEntry2: Record "337"): Boolean
//     begin
//         EXIT(
//           (ReservEntry1."Qty. to Handle (Base)" <> ReservEntry2."Qty. to Handle (Base)") OR
//           (ReservEntry1."Qty. to Invoice (Base)" <> ReservEntry2."Qty. to Invoice (Base)"));
//     end;

//     local procedure NextEntryNo(): Integer
//     begin
//         LastEntryNo += 1;
//         EXIT(LastEntryNo);
//     end;

//     local procedure WriteToDatabase()
//     var
//         Window: Dialog;
//         ChangeType: Option Insert,Modify,Delete;
//         EntryNo: Integer;
//         NoOfLines: Integer;
//         i: Integer;
//         ModifyLoop: Integer;
//         Decrease: Boolean;
//     begin
//         IF CurrentFormIsOpen THEN BEGIN
//           TempReservEntry.LOCKTABLE;
//           TempRecValid;

//           IF Item."Order Tracking Policy" = Item."Order Tracking Policy"::None THEN
//             QtyToAddAsBlank := 0
//           ELSE
//             QtyToAddAsBlank := UndefinedQtyArray[1] * CurrentSignFactor;

//           RESET;
//           DELETEALL;

//           Window.OPEN('#1############# @2@@@@@@@@@@@@@@@@@@@@@');
//           Window.UPDATE(1,Text018);
//           NoOfLines := TempItemTrackLineInsert.COUNT + TempItemTrackLineModify.COUNT + TempItemTrackLineDelete.COUNT;
//           IF TempItemTrackLineDelete.FIND('-') THEN BEGIN
//             REPEAT
//               i := i + 1;
//               IF i MOD 100 = 0 THEN
//                 Window.UPDATE(2,ROUND(i / NoOfLines * 10000,1));
//               RegisterChange(TempItemTrackLineDelete,TempItemTrackLineDelete,ChangeType::Delete,FALSE);
//               IF TempItemTrackLineModify.GET(TempItemTrackLineDelete."Entry No.") THEN
//                 TempItemTrackLineModify.DELETE;
//             UNTIL TempItemTrackLineDelete.NEXT = 0;
//             TempItemTrackLineDelete.DELETEALL;
//           END;

//           FOR ModifyLoop := 1 TO 2 DO BEGIN
//             IF TempItemTrackLineModify.FIND('-') THEN
//               REPEAT
//                 IF xTempItemTrackingLine.GET(TempItemTrackLineModify."Entry No.") THEN BEGIN
//                   // Process decreases before increases
//                   Decrease := (xTempItemTrackingLine."Quantity (Base)" > TempItemTrackLineModify."Quantity (Base)");
//                   IF ((ModifyLoop = 1) AND Decrease) OR ((ModifyLoop = 2) AND NOT Decrease) THEN BEGIN
//                     i := i + 1;
//                     IF (xTempItemTrackingLine."Serial No." <> TempItemTrackLineModify."Serial No.") OR
//                        (xTempItemTrackingLine."Lot No." <> TempItemTrackLineModify."Lot No.") OR
//                        (xTempItemTrackingLine."Appl.-from Item Entry" <> TempItemTrackLineModify."Appl.-from Item Entry") OR
//                        (xTempItemTrackingLine."Appl.-to Item Entry" <> TempItemTrackLineModify."Appl.-to Item Entry")
//                     THEN BEGIN
//                       RegisterChange(xTempItemTrackingLine,xTempItemTrackingLine,ChangeType::Delete,FALSE);
//                       RegisterChange(TempItemTrackLineModify,TempItemTrackLineModify,ChangeType::Insert,FALSE);
//                       IF (TempItemTrackLineInsert."Quantity (Base)" <> TempItemTrackLineInsert."Qty. to Handle (Base)") OR
//                          (TempItemTrackLineInsert."Quantity (Base)" <> TempItemTrackLineInsert."Qty. to Invoice (Base)")
//                       THEN
//                         SetQtyToHandleAndInvoice(TempItemTrackLineInsert);
//                     END ELSE
//                       IF NOT ChangeAlreadyNonSpecificReservations(
//                            TempItemTrackLineModify,TempItemTrackLineModify."Quantity (Base)" - xTempItemTrackingLine."Quantity (Base)")
//                       THEN BEGIN
//                         RegisterChange(xTempItemTrackingLine,TempItemTrackLineModify,ChangeType::Modify,FALSE);
//                         SetQtyToHandleAndInvoice(TempItemTrackLineModify);
//                       END;
//                     TempItemTrackLineModify.DELETE;
//                   END;
//                 END ELSE BEGIN
//                   i := i + 1;
//                   TempItemTrackLineModify.DELETE;
//                 END;
//                 IF i MOD 100 = 0 THEN
//                   Window.UPDATE(2,ROUND(i / NoOfLines * 10000,1));
//               UNTIL TempItemTrackLineModify.NEXT = 0;
//           END;

//           IF TempItemTrackLineInsert.FIND('-') THEN BEGIN
//             REPEAT
//               i := i + 1;
//               IF i MOD 100 = 0 THEN
//                 Window.UPDATE(2,ROUND(i / NoOfLines * 10000,1));
//               IF TempItemTrackLineModify.GET(TempItemTrackLineInsert."Entry No.") THEN
//                 TempItemTrackLineInsert.TRANSFERFIELDS(TempItemTrackLineModify);
//               IF NOT ChangeAlreadyNonSpecificReservations(TempItemTrackLineInsert,TempItemTrackLineInsert."Quantity (Base)") THEN BEGIN
//                 IF NOT RegisterChange(TempItemTrackLineInsert,TempItemTrackLineInsert,ChangeType::Insert,FALSE) THEN
//                   ERROR(Text005);
//                 IF (TempItemTrackLineInsert."Quantity (Base)" <> TempItemTrackLineInsert."Qty. to Handle (Base)") OR
//                    (TempItemTrackLineInsert."Quantity (Base)" <> TempItemTrackLineInsert."Qty. to Invoice (Base)")
//                 THEN
//                   SetQtyToHandleAndInvoice(TempItemTrackLineInsert);
//               END;
//             UNTIL TempItemTrackLineInsert.NEXT = 0;
//             TempItemTrackLineInsert.DELETEALL;
//           END;
//           Window.CLOSE;
//         END ELSE BEGIN
//           TempReservEntry.LOCKTABLE;
//           TempRecValid;

//           IF Item."Order Tracking Policy" = Item."Order Tracking Policy"::None THEN
//             QtyToAddAsBlank := 0
//           ELSE
//             QtyToAddAsBlank := UndefinedQtyArray[1] * CurrentSignFactor;

//           RESET;
//           SETFILTER("Buffer Status",'<>%1',0);
//           DELETEALL;
//           RESET;

//           xTempItemTrackingLine.RESET;
//           SETCURRENTKEY("Entry No.");
//           xTempItemTrackingLine.SETCURRENTKEY("Entry No.");
//           IF xTempItemTrackingLine.FIND('-') THEN
//             REPEAT
//               SETRANGE("Lot No.",xTempItemTrackingLine."Lot No.");
//               SETRANGE("Serial No.",xTempItemTrackingLine."Serial No.");
//               IF FIND('-') THEN BEGIN
//                 IF RegisterChange(xTempItemTrackingLine,Rec,ChangeType::Modify,FALSE) THEN BEGIN
//                   EntryNo := xTempItemTrackingLine."Entry No.";
//                   xTempItemTrackingLine := Rec;
//                   xTempItemTrackingLine."Entry No." := EntryNo;
//                   xTempItemTrackingLine.MODIFY;
//                 END;
//                 SetQtyToHandleAndInvoice(Rec);
//                 DELETE;
//               END ELSE BEGIN
//                 RegisterChange(xTempItemTrackingLine,xTempItemTrackingLine,ChangeType::Delete,FALSE);
//                 xTempItemTrackingLine.DELETE;
//               END;
//             UNTIL xTempItemTrackingLine.NEXT = 0;

//           RESET;

//           IF FIND('-') THEN
//             REPEAT
//               IF RegisterChange(Rec,Rec,ChangeType::Insert,FALSE) THEN BEGIN
//                 xTempItemTrackingLine := Rec;
//                 xTempItemTrackingLine.INSERT;
//               END ELSE
//                 ERROR(Text005);
//               SetQtyToHandleAndInvoice(Rec);
//               DELETE;
//             UNTIL NEXT = 0;
//         END;

//         UpdateOrderTracking;
//         ReestablishReservations; // Late Binding

//         IF NOT BlockCommit THEN
//           COMMIT;
//     end;

//     local procedure RegisterChange(var OldTrackingSpecification: Record "336";var NewTrackingSpecification: Record "336";ChangeType: Option Insert,Modify,FullDelete,PartDelete,ModifyAll;ModifySharedFields: Boolean) OK: Boolean
//     var
//         ReservEntry1: Record "337";
//         ReservEntry2: Record "337";
//         CreateReservEntry: Codeunit "99000830";
//         ReservationMgt: Codeunit "99000845";
//         QtyToAdd: Decimal;
//         LostReservQty: Decimal;
//         IdenticalArray: array [2] of Boolean;
//     begin
//         OK := FALSE;
//         ReservEngineMgt.SetPick(IsPick);

//         IF ((CurrentSignFactor * NewTrackingSpecification."Qty. to Handle") < 0) AND
//            (FormRunMode <> FormRunMode::"Drop Shipment")
//         THEN BEGIN
//           NewTrackingSpecification."Expiration Date" := 0D;
//           OldTrackingSpecification."Expiration Date" := 0D;
//         END;

//         CASE ChangeType OF
//           ChangeType::Insert:
//             BEGIN
//               IF (OldTrackingSpecification."Quantity (Base)" = 0) OR
//                  ((OldTrackingSpecification."Lot No." = '') AND
//                   (OldTrackingSpecification."Serial No." = ''))
//               THEN
//                 EXIT(TRUE);
//               TempReservEntry.SETRANGE("Serial No.",'');
//               TempReservEntry.SETRANGE("Lot No.",'');
//               OldTrackingSpecification."Quantity (Base)" :=
//                 CurrentSignFactor *
//                 ReservEngineMgt.AddItemTrackingToTempRecSet(
//                   TempReservEntry,NewTrackingSpecification,
//                   CurrentSignFactor * OldTrackingSpecification."Quantity (Base)",QtyToAddAsBlank,
//                   ItemTrackingCode."SN Specific Tracking",ItemTrackingCode."Lot Specific Tracking");
//               TempReservEntry.SETRANGE("Serial No.");
//               TempReservEntry.SETRANGE("Lot No.");

//               // Late Binding
//               IF ReservEngineMgt.RetrieveLostReservQty(LostReservQty) THEN BEGIN
//                 TempItemTrackLineReserv := NewTrackingSpecification;
//                 TempItemTrackLineReserv."Quantity (Base)" := LostReservQty * CurrentSignFactor;
//                 TempItemTrackLineReserv.INSERT;
//               END;

//               IF OldTrackingSpecification."Quantity (Base)" = 0 THEN
//                 EXIT(TRUE);

//               IF FormRunMode = FormRunMode::Reclass THEN BEGIN
//                 CreateReservEntry.SetNewSerialLotNo(
//                   OldTrackingSpecification."New Serial No.",OldTrackingSpecification."New Lot No.");
//                 CreateReservEntry.SetNewExpirationDate(OldTrackingSpecification."New Expiration Date");
//               END;
//               CreateReservEntry.SetDates(
//                 NewTrackingSpecification."Warranty Date",NewTrackingSpecification."Expiration Date");
//               CreateReservEntry.SetApplyFromEntryNo(NewTrackingSpecification."Appl.-from Item Entry");
//               CreateReservEntry.SetApplyToEntryNo(NewTrackingSpecification."Appl.-to Item Entry");
//               CreateReservEntry.CreateReservEntryFor(
//                 OldTrackingSpecification."Source Type",
//                 OldTrackingSpecification."Source Subtype",
//                 OldTrackingSpecification."Source ID",
//                 OldTrackingSpecification."Source Batch Name",
//                 OldTrackingSpecification."Source Prod. Order Line",
//                 OldTrackingSpecification."Source Ref. No.",
//                 OldTrackingSpecification."Qty. per Unit of Measure",
//                 0,
//                 OldTrackingSpecification."Quantity (Base)",
//                 OldTrackingSpecification."Serial No.",
//                 /*Start: TJCSG1.00 #1*/
//                 // OldTrackingSpecification."Lot No.");
//                 OldTrackingSpecification."Lot No.",
//                 OldTrackingSpecification."Expiration Date");
//                 /*End: TJCSG1.00 #1*/
//               CreateReservEntry.CreateEntry(OldTrackingSpecification."Item No.",
//                 OldTrackingSpecification."Variant Code",
//                 OldTrackingSpecification."Location Code",
//                 OldTrackingSpecification.Description,
//                 ExpectedReceiptDate,
//                 ShipmentDate,0,CurrentEntryStatus);
//               CreateReservEntry.GetLastEntry(ReservEntry1);
//               IF Item."Order Tracking Policy" = Item."Order Tracking Policy"::"Tracking & Action Msg." THEN
//                 ReservEngineMgt.UpdateActionMessages(ReservEntry1);

//               IF ModifySharedFields THEN BEGIN
//                 ReservationMgt.SetPointerFilter(ReservEntry1);
//                 ReservEntry1.SETRANGE("Lot No.",ReservEntry1."Lot No.");
//                 ReservEntry1.SETRANGE("Serial No.",ReservEntry1."Serial No.");
//                 ReservEntry1.SETFILTER("Entry No.",'<>%1',ReservEntry1."Entry No.");
//                 ModifyFieldsWithinFilter(ReservEntry1,NewTrackingSpecification);
//               END;

//               OK := TRUE;
//             END;
//           ChangeType::Modify:
//             BEGIN
//               ReservEntry1.TRANSFERFIELDS(OldTrackingSpecification);
//               ReservEntry2.TRANSFERFIELDS(NewTrackingSpecification);

//               ReservEntry1."Entry No." := ReservEntry2."Entry No."; // If only entry no. has changed it should not trigger
//               IF EntriesAreIdentical(ReservEntry1,ReservEntry2,IdenticalArray) THEN
//                 EXIT(QtyToHandleAndInvoiceChanged(ReservEntry1,ReservEntry2));

//               IF ABS(OldTrackingSpecification."Quantity (Base)") < ABS(NewTrackingSpecification."Quantity (Base)") THEN
//                 BEGIN
//                 // Item Tracking is added to any blank reservation entries:
//                 TempReservEntry.SETRANGE("Serial No.",'');
//                 TempReservEntry.SETRANGE("Lot No.",'');
//                 QtyToAdd :=
//                   CurrentSignFactor *
//                   ReservEngineMgt.AddItemTrackingToTempRecSet(
//                     TempReservEntry,NewTrackingSpecification,
//                     CurrentSignFactor * (NewTrackingSpecification."Quantity (Base)" -
//                                          OldTrackingSpecification."Quantity (Base)"),QtyToAddAsBlank,
//                     ItemTrackingCode."SN Specific Tracking",ItemTrackingCode."Lot Specific Tracking");
//                 TempReservEntry.SETRANGE("Serial No.");
//                 TempReservEntry.SETRANGE("Lot No.");

//                 // Late Binding
//                 IF ReservEngineMgt.RetrieveLostReservQty(LostReservQty) THEN BEGIN
//                   TempItemTrackLineReserv := NewTrackingSpecification;
//                   TempItemTrackLineReserv."Quantity (Base)" := LostReservQty * CurrentSignFactor;
//                   TempItemTrackLineReserv.INSERT;
//                 END;

//                 OldTrackingSpecification."Quantity (Base)" := QtyToAdd;
//                 OldTrackingSpecification."Warranty Date" := NewTrackingSpecification."Warranty Date";
//                 OldTrackingSpecification."Expiration Date" := NewTrackingSpecification."Expiration Date";
//                 OldTrackingSpecification.Description := NewTrackingSpecification.Description;
//                 RegisterChange(OldTrackingSpecification,OldTrackingSpecification,
//                   ChangeType::Insert,NOT IdenticalArray[2]);
//               END ELSE BEGIN
//                 TempReservEntry.SETRANGE("Serial No.",OldTrackingSpecification."Serial No.");
//                 TempReservEntry.SETRANGE("Lot No.",OldTrackingSpecification."Lot No.");
//                 OldTrackingSpecification."Serial No." := '';
//                 OldTrackingSpecification."Lot No." := '';
//                 OldTrackingSpecification."Warranty Date" := 0D;
//                 OldTrackingSpecification."Expiration Date" := 0D;
//                 QtyToAdd :=
//                   CurrentSignFactor *
//                   ReservEngineMgt.AddItemTrackingToTempRecSet(
//                     TempReservEntry,OldTrackingSpecification,
//                     CurrentSignFactor * (OldTrackingSpecification."Quantity (Base)" -
//                                          NewTrackingSpecification."Quantity (Base)"),QtyToAddAsBlank,
//                     ItemTrackingCode."SN Specific Tracking",ItemTrackingCode."Lot Specific Tracking");
//                 TempReservEntry.SETRANGE("Serial No.");
//                 TempReservEntry.SETRANGE("Lot No.");
//                 RegisterChange(NewTrackingSpecification,NewTrackingSpecification,
//                   ChangeType::PartDelete,NOT IdenticalArray[2]);
//               END;
//               OK := TRUE;
//             END;
//           ChangeType::FullDelete,ChangeType::PartDelete:
//             BEGIN
//               ReservationMgt.SetItemTrackingHandling(1); // Allow deletion of Item Tracking
//               ReservEntry1.TRANSFERFIELDS(OldTrackingSpecification);
//               ReservationMgt.SetPointerFilter(ReservEntry1);
//               ReservEntry1.SETRANGE("Lot No.",ReservEntry1."Lot No.");
//               ReservEntry1.SETRANGE("Serial No.",ReservEntry1."Serial No.");
//               IF ChangeType = ChangeType::FullDelete THEN BEGIN
//                 TempReservEntry.SETRANGE("Serial No.",OldTrackingSpecification."Serial No.");
//                 TempReservEntry.SETRANGE("Lot No.",OldTrackingSpecification."Lot No.");
//                 OldTrackingSpecification."Serial No." := '';
//                 OldTrackingSpecification."Lot No." := '';
//                 OldTrackingSpecification."Warranty Date" := 0D;
//                 OldTrackingSpecification."Expiration Date" := 0D;
//                 QtyToAdd :=
//                   CurrentSignFactor *
//                   ReservEngineMgt.AddItemTrackingToTempRecSet(
//                     TempReservEntry,OldTrackingSpecification,
//                     CurrentSignFactor * OldTrackingSpecification."Quantity (Base)",QtyToAddAsBlank,
//                     ItemTrackingCode."SN Specific Tracking",ItemTrackingCode."Lot Specific Tracking");
//                 TempReservEntry.SETRANGE("Serial No.");
//                 TempReservEntry.SETRANGE("Lot No.");
//                 ReservationMgt.DeleteReservEntries2(TRUE,0,ReservEntry1)
//               END ELSE BEGIN
//                 ReservationMgt.DeleteReservEntries2(FALSE,ReservEntry1."Quantity (Base)" -
//                   OldTrackingSpecification."Quantity Handled (Base)",ReservEntry1);
//                 IF ModifySharedFields THEN BEGIN
//                   ReservEntry1.SETRANGE("Reservation Status");
//                   ModifyFieldsWithinFilter(ReservEntry1,OldTrackingSpecification);
//                 END;
//               END;
//               OK := TRUE;
//             END;
//         END;
//         SetQtyToHandleAndInvoice(NewTrackingSpecification);

//     end;

//     local procedure UpdateOrderTracking()
//     var
//         TempReservEntry: Record "337" temporary;
//     begin
//         IF NOT ReservEngineMgt.CollectAffectedSurplusEntries(TempReservEntry) THEN
//           EXIT;
//         IF Item."Order Tracking Policy" = Item."Order Tracking Policy"::None THEN
//           EXIT;
//         ReservEngineMgt.UpdateOrderTracking(TempReservEntry);
//     end;

//     procedure ModifyFieldsWithinFilter(var ReservEntry1: Record "337";var TrackingSpecification: Record "336")
//     begin
//         // Used to ensure that field values that are common to a SN/Lot are copied to all entries.
//         IF ReservEntry1.FIND('-') THEN
//           REPEAT
//             ReservEntry1.Description := TrackingSpecification.Description;
//             ReservEntry1."Warranty Date" := TrackingSpecification."Warranty Date";
//             ReservEntry1."Expiration Date" := TrackingSpecification."Expiration Date";
//             ReservEntry1."New Serial No." := TrackingSpecification."New Serial No.";
//             ReservEntry1."New Lot No." := TrackingSpecification."New Lot No.";
//             ReservEntry1."New Expiration Date" := TrackingSpecification."New Expiration Date";
//             ReservEntry1.MODIFY;
//           UNTIL ReservEntry1.NEXT = 0;
//     end;

//     local procedure SetQtyToHandleAndInvoice(TrackingSpecification: Record "336") OK: Boolean
//     var
//         ReservEntry1: Record "337";
//         ReservationMgt: Codeunit "99000845";
//         TotalQtyToHandle: Decimal;
//         TotalQtyToInvoice: Decimal;
//         QtyAlreadyHandledToInvoice: Decimal;
//         QtyToHandleThisLine: Decimal;
//         QtyToInvoiceThisLine: Decimal;
//     begin
//         IF IsCorrection THEN
//           EXIT;
//         OK := FALSE;

//         TotalQtyToHandle := TrackingSpecification."Qty. to Handle (Base)" * CurrentSignFactor;
//         TotalQtyToInvoice := TrackingSpecification."Qty. to Invoice (Base)" * CurrentSignFactor;

//         IF ABS(TotalQtyToHandle) > ABS(TotalQtyToInvoice) THEN
//           QtyAlreadyHandledToInvoice := 0
//         ELSE
//           QtyAlreadyHandledToInvoice := TotalQtyToInvoice - TotalQtyToHandle;

//         ReservEntry1.TRANSFERFIELDS(TrackingSpecification);
//         ReservationMgt.SetPointerFilter(ReservEntry1);
//         ReservEntry1.SETRANGE("Lot No.",ReservEntry1."Lot No.");
//         ReservEntry1.SETRANGE("Serial No.",ReservEntry1."Serial No.");
//         IF (TrackingSpecification."Lot No." <> '') OR
//            (TrackingSpecification."Serial No." <> '')
//         THEN BEGIN
//           ItemTrackingMgt.SetPointerFilter(TrackingSpecification);
//           TrackingSpecification.SETRANGE("Lot No.",TrackingSpecification."Lot No.");
//           TrackingSpecification.SETRANGE("Serial No.",TrackingSpecification."Serial No.");

//           IF TrackingSpecification.FIND('-') THEN
//             REPEAT
//               IF NOT TrackingSpecification.Correction THEN BEGIN
//                 QtyToInvoiceThisLine :=
//                   TrackingSpecification."Quantity Handled (Base)" - TrackingSpecification."Quantity Invoiced (Base)";
//                 IF ABS(QtyToInvoiceThisLine) > ABS(TotalQtyToInvoice) THEN
//                   QtyToInvoiceThisLine := TotalQtyToInvoice;

//                 IF ABS(QtyToInvoiceThisLine) > ABS(QtyAlreadyHandledToInvoice) THEN BEGIN
//                   QtyToInvoiceThisLine := QtyAlreadyHandledToInvoice;
//                   QtyAlreadyHandledToInvoice := 0;
//                 END ELSE
//                   QtyAlreadyHandledToInvoice -= QtyToInvoiceThisLine;

//                 IF TrackingSpecification."Qty. to Invoice (Base)" <> QtyToInvoiceThisLine THEN BEGIN
//                   TrackingSpecification."Qty. to Invoice (Base)" := QtyToInvoiceThisLine;
//                   TrackingSpecification.MODIFY;
//                 END;

//                 TotalQtyToInvoice -= QtyToInvoiceThisLine;
//               END;
//             UNTIL (TrackingSpecification.NEXT = 0);

//           OK := ((TotalQtyToHandle = 0) AND (TotalQtyToInvoice = 0));
//         END;

//         IF TrackingSpecification."Lot No." <> '' THEN BEGIN
//           FOR ReservEntry1."Reservation Status" := ReservEntry1."Reservation Status"::Reservation TO
//               ReservEntry1."Reservation Status"::Prospect
//           DO BEGIN
//             ReservEntry1.SETRANGE("Reservation Status",ReservEntry1."Reservation Status");
//             IF ReservEntry1.FIND('-') THEN
//               REPEAT
//                 QtyToHandleThisLine := ReservEntry1."Quantity (Base)";
//                 QtyToInvoiceThisLine := QtyToHandleThisLine;

//                 IF ABS(QtyToHandleThisLine) > ABS(TotalQtyToHandle) THEN
//                   QtyToHandleThisLine := TotalQtyToHandle;
//                 IF ABS(QtyToInvoiceThisLine) > ABS(TotalQtyToInvoice) THEN
//                   QtyToInvoiceThisLine := TotalQtyToInvoice;

//                 IF (ReservEntry1."Qty. to Handle (Base)" <> QtyToHandleThisLine) OR
//                    (ReservEntry1."Qty. to Invoice (Base)" <> QtyToInvoiceThisLine) AND NOT ReservEntry1.Correction
//                 THEN BEGIN
//                   ReservEntry1."Qty. to Handle (Base)" := QtyToHandleThisLine;
//                   ReservEntry1."Qty. to Invoice (Base)" := QtyToInvoiceThisLine;
//                   ReservEntry1.MODIFY;
//                 END;

//                 TotalQtyToHandle -= QtyToHandleThisLine;
//                 TotalQtyToInvoice -= QtyToInvoiceThisLine;

//               UNTIL (ReservEntry1.NEXT = 0);
//           END;

//           OK := ((TotalQtyToHandle = 0) AND (TotalQtyToInvoice = 0));
//         END ELSE
//           IF ReservEntry1.FIND('-') THEN
//             IF (ReservEntry1."Qty. to Handle (Base)" <> TotalQtyToHandle) OR
//                (ReservEntry1."Qty. to Invoice (Base)" <> TotalQtyToInvoice) AND NOT ReservEntry1.Correction
//             THEN BEGIN
//               ReservEntry1."Qty. to Handle (Base)" := TotalQtyToHandle;
//               ReservEntry1."Qty. to Invoice (Base)" := TotalQtyToInvoice;
//               ReservEntry1.MODIFY;
//             END;
//     end;

//     local procedure CollectPostedTransferEntries(TrackingSpecification: Record "336";var TempTrackingSpecification: Record "336" temporary)
//     var
//         ItemEntryRelation: Record "6507";
//         ItemLedgerEntry: Record "32";
//     begin
//         // Used for collecting information about posted Transfer Shipments from the created Item Ledger Entries.
//         IF TrackingSpecification."Source Type" <> DATABASE::"Transfer Line" THEN
//           EXIT;

//         ItemEntryRelation.SETCURRENTKEY("Order No.","Order Line No.");
//         ItemEntryRelation.SETRANGE("Order No.",TrackingSpecification."Source ID");
//         ItemEntryRelation.SETRANGE("Order Line No.",TrackingSpecification."Source Ref. No.");

//         CASE TrackingSpecification."Source Subtype" OF
//           0: // Outbound
//             ItemEntryRelation.SETRANGE("Source Type",DATABASE::"Transfer Shipment Line");
//           1: // Inbound
//             ItemEntryRelation.SETRANGE("Source Type",DATABASE::"Transfer Receipt Line");
//         END;

//         IF ItemEntryRelation.FIND('-') THEN
//           REPEAT
//             ItemLedgerEntry.GET(ItemEntryRelation."Item Entry No.");
//             TempTrackingSpecification := TrackingSpecification;
//             TempTrackingSpecification."Entry No." := ItemLedgerEntry."Entry No.";
//             TempTrackingSpecification."Item No." := ItemLedgerEntry."Item No.";
//             TempTrackingSpecification."Serial No." := ItemLedgerEntry."Serial No.";
//             TempTrackingSpecification."Lot No." := ItemLedgerEntry."Lot No.";
//             TempTrackingSpecification."Quantity (Base)" := ItemLedgerEntry.Quantity;
//             TempTrackingSpecification."Quantity Handled (Base)" := ItemLedgerEntry.Quantity;
//             TempTrackingSpecification."Quantity Invoiced (Base)" := ItemLedgerEntry.Quantity;
//             TempTrackingSpecification."Qty. per Unit of Measure" := ItemLedgerEntry."Qty. per Unit of Measure";
//             TempTrackingSpecification.InitQtyToShip;
//             TempTrackingSpecification.INSERT;
//           UNTIL ItemEntryRelation.NEXT = 0;
//     end;

//     local procedure CollectPostedAssemblyEntries(TrackingSpecification: Record "336";var TempTrackingSpecification: Record "336" temporary)
//     var
//         ItemEntryRelation: Record "6507";
//         ItemLedgerEntry: Record "32";
//     begin
//         // Used for collecting information about posted Assembly Lines from the created Item Ledger Entries.
//         IF (TrackingSpecification."Source Type" <> DATABASE::"Assembly Line") AND
//            (TrackingSpecification."Source Type" <> DATABASE::"Assembly Header")
//         THEN
//           EXIT;

//         ItemEntryRelation.SETCURRENTKEY("Order No.","Order Line No.");
//         ItemEntryRelation.SETRANGE("Order No.",TrackingSpecification."Source ID");
//         ItemEntryRelation.SETRANGE("Order Line No.",TrackingSpecification."Source Ref. No.");
//         IF TrackingSpecification."Source Type" = DATABASE::"Assembly Line" THEN
//           ItemEntryRelation.SETRANGE("Source Type",DATABASE::"Posted Assembly Line")
//         ELSE
//           ItemEntryRelation.SETRANGE("Source Type",DATABASE::"Posted Assembly Header");

//         IF ItemEntryRelation.FIND('-') THEN
//           REPEAT
//             ItemLedgerEntry.GET(ItemEntryRelation."Item Entry No.");
//             TempTrackingSpecification := TrackingSpecification;
//             TempTrackingSpecification."Entry No." := ItemLedgerEntry."Entry No.";
//             TempTrackingSpecification."Item No." := ItemLedgerEntry."Item No.";
//             TempTrackingSpecification."Serial No." := ItemLedgerEntry."Serial No.";
//             TempTrackingSpecification."Lot No." := ItemLedgerEntry."Lot No.";
//             TempTrackingSpecification."Quantity (Base)" := ItemLedgerEntry.Quantity;
//             TempTrackingSpecification."Quantity Handled (Base)" := ItemLedgerEntry.Quantity;
//             TempTrackingSpecification."Quantity Invoiced (Base)" := ItemLedgerEntry.Quantity;
//             TempTrackingSpecification."Qty. per Unit of Measure" := ItemLedgerEntry."Qty. per Unit of Measure";
//             TempTrackingSpecification.InitQtyToShip;
//             TempTrackingSpecification.INSERT;
//           UNTIL ItemEntryRelation.NEXT = 0;
//     end;

//     local procedure CollectPostedOutputEntries(TrackingSpecification: Record "336";var TempTrackingSpecification: Record "336" temporary)
//     var
//         ItemLedgerEntry: Record "32";
//         ProdOrderRoutingLine: Record "5409";
//         BackwardFlushing: Boolean;
//     begin
//         // Used for collecting information about posted prod. order output from the created Item Ledger Entries.
//         IF TrackingSpecification."Source Type" <> DATABASE::"Prod. Order Line" THEN
//           EXIT;

//         IF (TrackingSpecification."Source Type" = DATABASE::"Prod. Order Line") AND
//            (TrackingSpecification."Source Subtype" = 3)
//         THEN BEGIN
//           ProdOrderRoutingLine.SETRANGE(Status,TrackingSpecification."Source Subtype");
//           ProdOrderRoutingLine.SETRANGE("Prod. Order No.",TrackingSpecification."Source ID");
//           ProdOrderRoutingLine.SETRANGE("Routing Reference No.",TrackingSpecification."Source Prod. Order Line");
//           IF ProdOrderRoutingLine.FINDLAST THEN
//             BackwardFlushing :=
//               ProdOrderRoutingLine."Flushing Method" = ProdOrderRoutingLine."Flushing Method"::Backward;
//         END;

//         ItemLedgerEntry.SETCURRENTKEY("Order Type","Order No.","Order Line No.","Entry Type");
//         ItemLedgerEntry.SETRANGE("Order Type",ItemLedgerEntry."Order Type"::Production);
//         ItemLedgerEntry.SETRANGE("Order No.",TrackingSpecification."Source ID");
//         ItemLedgerEntry.SETRANGE("Order Line No.",TrackingSpecification."Source Prod. Order Line");
//         ItemLedgerEntry.SETRANGE("Entry Type",ItemLedgerEntry."Entry Type"::Output);

//         IF ItemLedgerEntry.FIND('-') THEN
//           REPEAT
//             TempTrackingSpecification := TrackingSpecification;
//             TempTrackingSpecification."Entry No." := ItemLedgerEntry."Entry No.";
//             TempTrackingSpecification."Item No." := ItemLedgerEntry."Item No.";
//             TempTrackingSpecification."Serial No." := ItemLedgerEntry."Serial No.";
//             TempTrackingSpecification."Lot No." := ItemLedgerEntry."Lot No.";
//             TempTrackingSpecification."Quantity (Base)" := ItemLedgerEntry.Quantity;
//             TempTrackingSpecification."Quantity Handled (Base)" := ItemLedgerEntry.Quantity;
//             TempTrackingSpecification."Quantity Invoiced (Base)" := ItemLedgerEntry.Quantity;
//             TempTrackingSpecification."Qty. per Unit of Measure" := ItemLedgerEntry."Qty. per Unit of Measure";
//             TempTrackingSpecification.InitQtyToShip;
//             TempTrackingSpecification.INSERT;

//             IF BackwardFlushing THEN BEGIN
//               SourceQuantityArray[1] += ItemLedgerEntry.Quantity;
//               SourceQuantityArray[2] += ItemLedgerEntry.Quantity;
//               SourceQuantityArray[3] += ItemLedgerEntry.Quantity;
//             END;

//           UNTIL ItemLedgerEntry.NEXT = 0;
//     end;

//     local procedure ZeroLineExists() OK: Boolean
//     var
//         xTrackingSpec: Record "336";
//     begin
//         IF ("Quantity (Base)" <> 0) OR ("Serial No." <> '') OR ("Lot No." <> '') THEN
//           EXIT(FALSE);
//         xTrackingSpec.COPY(Rec);
//         RESET;
//         SETRANGE("Quantity (Base)",0);
//         SETRANGE("Serial No.",'');
//         SETRANGE("Lot No.",'');
//         OK := NOT ISEMPTY;
//         COPY(xTrackingSpec);
//     end;

//     local procedure AssignSerialNo()
//     var
//         EnterQuantityToCreate: Page "6513";
//         QtyToCreate: Decimal;
//         QtyToCreateInt: Integer;
//         CreateLotNo: Boolean;
//     begin
//         IF ZeroLineExists THEN
//           DELETE;

//         QtyToCreate := UndefinedQtyArray[1] * QtySignFactor;
//         IF QtyToCreate < 0 THEN
//           QtyToCreate := 0;

//         IF QtyToCreate MOD 1 <> 0 THEN
//           ERROR(Text008);

//         QtyToCreateInt := QtyToCreate;

//         CLEAR(EnterQuantityToCreate);
//         EnterQuantityToCreate.SetFields("Item No.","Variant Code",QtyToCreate,FALSE);
//         IF EnterQuantityToCreate.RUNMODAL = ACTION::OK THEN BEGIN
//           EnterQuantityToCreate.GetFields(QtyToCreateInt,CreateLotNo);
//           AssignSerialNoBatch(QtyToCreateInt,CreateLotNo);
//         END;
//     end;

//     local procedure AssignSerialNoBatch(QtyToCreate: Integer;CreateLotNo: Boolean)
//     var
//         i: Integer;
//     begin
//         IF QtyToCreate <= 0 THEN
//           ERROR(Text009);
//         IF QtyToCreate MOD 1 <> 0 THEN
//           ERROR(Text008);

//         GetItem("Item No.");

//         IF CreateLotNo THEN BEGIN
//           TESTFIELD("Lot No.",'');
//           Item.TESTFIELD("Lot Nos.");
//           VALIDATE("Lot No.",NoSeriesMgt.GetNextNo(Item."Lot Nos.",WORKDATE,TRUE));
//         END;

//         Item.TESTFIELD("Serial Nos.");
//         ItemTrackingDataCollection.SetSkipLot(TRUE);
//         FOR i := 1 TO QtyToCreate DO BEGIN
//           VALIDATE("Quantity Handled (Base)",0);
//           VALIDATE("Quantity Invoiced (Base)",0);
//           VALIDATE("Serial No.",NoSeriesMgt.GetNextNo(Item."Serial Nos.",WORKDATE,TRUE));
//           VALIDATE("Quantity (Base)",QtySignFactor);
//           "Entry No." := NextEntryNo;
//           IF TestTempSpecificationExists THEN
//             ERROR('');
//           INSERT;
//           TempItemTrackLineInsert.TRANSFERFIELDS(Rec);
//           TempItemTrackLineInsert.INSERT;
//           IF i = QtyToCreate THEN
//             ItemTrackingDataCollection.SetSkipLot(FALSE);
//           ItemTrackingDataCollection.UpdateLotSNDataSetWithChange(
//             TempItemTrackLineInsert,CurrentSignFactor * SourceQuantityArray[1] < 0,CurrentSignFactor,0);
//         END;
//         CalculateSums;
//     end;

//     local procedure AssignLotNo()
//     var
//         QtyToCreate: Decimal;
//     begin
//         IF ZeroLineExists THEN
//           DELETE;

//         IF (SourceQuantityArray[1] * UndefinedQtyArray[1] <= 0) OR
//            (ABS(SourceQuantityArray[1]) < ABS(UndefinedQtyArray[1]))
//         THEN
//           QtyToCreate := 0
//         ELSE
//           QtyToCreate := UndefinedQtyArray[1];

//         GetItem("Item No.");

//         Item.TESTFIELD("Lot Nos.");
//         VALIDATE("Quantity Handled (Base)",0);
//         VALIDATE("Quantity Invoiced (Base)",0);
//         VALIDATE("Lot No.",NoSeriesMgt.GetNextNo(Item."Lot Nos.",WORKDATE,TRUE));
//         "Qty. per Unit of Measure" := QtyPerUOM;
//         VALIDATE("Quantity (Base)",QtyToCreate);
//         "Entry No." := NextEntryNo;
//         TestTempSpecificationExists;
//         INSERT;
//         TempItemTrackLineInsert.TRANSFERFIELDS(Rec);
//         TempItemTrackLineInsert.INSERT;
//         ItemTrackingDataCollection.UpdateLotSNDataSetWithChange(
//           TempItemTrackLineInsert,CurrentSignFactor * SourceQuantityArray[1] < 0,CurrentSignFactor,0);
//         CalculateSums;
//     end;

//     local procedure CreateCustomizedSN()
//     var
//         EnterCustomizedSN: Page "6515";
//         QtyToCreate: Decimal;
//         QtyToCreateInt: Integer;
//         Increment: Integer;
//         CreateLotNo: Boolean;
//         CustomizedSN: Code[20];
//     begin
//         IF ZeroLineExists THEN
//           DELETE;

//         QtyToCreate := UndefinedQtyArray[1] * QtySignFactor;
//         IF QtyToCreate < 0 THEN
//           QtyToCreate := 0;

//         IF QtyToCreate MOD 1 <> 0 THEN
//           ERROR(Text008);

//         QtyToCreateInt := QtyToCreate;

//         CLEAR(EnterCustomizedSN);
//         EnterCustomizedSN.SetFields("Item No.","Variant Code",QtyToCreate,FALSE);
//         IF EnterCustomizedSN.RUNMODAL = ACTION::OK THEN BEGIN
//           EnterCustomizedSN.GetFields(QtyToCreateInt,CreateLotNo,CustomizedSN,Increment);
//           CreateCustomizedSNBatch(QtyToCreateInt,CreateLotNo,CustomizedSN,Increment);
//         END;
//         CalculateSums;
//     end;

//     local procedure CreateCustomizedSNBatch(QtyToCreate: Decimal;CreateLotNo: Boolean;CustomizedSN: Code[20];Increment: Integer)
//     var
//         i: Integer;
//         Counter: Integer;
//     begin
//         IF INCSTR(CustomizedSN) = '' THEN
//           ERROR(Text013,CustomizedSN);
//         NoSeriesMgt.TestManual(Item."Serial Nos.");

//         IF QtyToCreate <= 0 THEN
//           ERROR(Text009);
//         IF QtyToCreate MOD 1 <> 0 THEN
//           ERROR(Text008);

//         IF CreateLotNo THEN BEGIN
//           TESTFIELD("Lot No.",'');
//           Item.TESTFIELD("Lot Nos.");
//           VALIDATE("Lot No.",NoSeriesMgt.GetNextNo(Item."Lot Nos.",WORKDATE,TRUE));
//         END;

//         FOR i := 1 TO QtyToCreate DO BEGIN
//           VALIDATE("Quantity Handled (Base)",0);
//           VALIDATE("Quantity Invoiced (Base)",0);
//           VALIDATE("Serial No.",CustomizedSN);
//           VALIDATE("Quantity (Base)",QtySignFactor);
//           "Entry No." := NextEntryNo;
//           IF TestTempSpecificationExists THEN
//             ERROR('');
//           INSERT;
//           TempItemTrackLineInsert.TRANSFERFIELDS(Rec);
//           TempItemTrackLineInsert.INSERT;
//           ItemTrackingDataCollection.UpdateLotSNDataSetWithChange(
//             TempItemTrackLineInsert,CurrentSignFactor * SourceQuantityArray[1] < 0,CurrentSignFactor,0);
//           IF i < QtyToCreate THEN BEGIN
//             Counter := Increment;
//             REPEAT
//               CustomizedSN := INCSTR(CustomizedSN);
//               Counter := Counter - 1;
//             UNTIL Counter <= 0;
//           END;
//         END;
//         CalculateSums;
//     end;

//     local procedure TestTempSpecificationExists() Exists: Boolean
//     var
//         TempSpecification: Record "336" temporary;
//     begin
//         TempSpecification.COPY(Rec);
//         SETCURRENTKEY("Lot No.","Serial No.");
//         SETRANGE("Serial No.","Serial No.");
//         IF "Serial No." = '' THEN
//           SETRANGE("Lot No.","Lot No.");
//         SETFILTER("Entry No.",'<>%1',"Entry No.");
//         SETRANGE("Buffer Status",0);
//         Exists := NOT ISEMPTY;
//         COPY(TempSpecification);
//         IF Exists AND CurrentFormIsOpen THEN
//           IF "Serial No." = '' THEN
//             MESSAGE(
//               Text011,
//               "Serial No.",
//               "Lot No.")
//           ELSE
//             MESSAGE(
//               Text012,
//               "Serial No.");
//     end;

//     local procedure QtySignFactor(): Integer
//     begin
//         IF SourceQuantityArray[1] < 0 THEN
//           EXIT(-1);

//         EXIT(1)
//     end;

//     procedure RegisterItemTrackingLines(SourceSpecification: Record "336";AvailabilityDate: Date;var TempSpecification: Record "336" temporary)
//     begin
//         SourceSpecification.TESTFIELD("Source Type"); // Check if source has been set.
//         IF NOT CalledFromSynchWhseItemTrkg THEN
//           TempSpecification.RESET;
//         IF NOT TempSpecification.FIND('-') THEN
//           EXIT;

//         IsCorrection := SourceSpecification.Correction;
//         ExcludePostedEntries := TRUE;
//         SetSource(SourceSpecification,AvailabilityDate);
//         RESET;
//         SETCURRENTKEY("Lot No.","Serial No.");

//         REPEAT
//           SETRANGE("Lot No.",TempSpecification."Lot No.");
//           SETRANGE("Serial No.",TempSpecification."Serial No.");
//           IF FIND('-') THEN BEGIN
//             IF IsCorrection THEN BEGIN
//               "Quantity (Base)" :=
//                 "Quantity (Base)" + TempSpecification."Quantity (Base)";
//               "Qty. to Handle (Base)" :=
//                 "Qty. to Handle (Base)" + TempSpecification."Qty. to Handle (Base)";
//               "Qty. to Invoice (Base)" :=
//                 "Qty. to Invoice (Base)" + TempSpecification."Qty. to Invoice (Base)";
//             END ELSE
//               VALIDATE("Quantity (Base)",
//                 "Quantity (Base)" + TempSpecification."Quantity (Base)");
//             MODIFY;
//           END ELSE BEGIN
//             TRANSFERFIELDS(SourceSpecification);
//             "Serial No." := TempSpecification."Serial No.";
//             "Lot No." := TempSpecification."Lot No.";
//             "Warranty Date" := TempSpecification."Warranty Date";
//             "Expiration Date" := TempSpecification."Expiration Date";
//             IF FormRunMode = FormRunMode::Reclass THEN BEGIN
//               "New Serial No." := TempSpecification."New Serial No.";
//               "New Lot No." := TempSpecification."New Lot No.";
//               "New Expiration Date" := TempSpecification."New Expiration Date"
//             END;
//             VALIDATE("Quantity (Base)",TempSpecification."Quantity (Base)");
//             "Entry No." := NextEntryNo;
//             INSERT;
//           END;
//         UNTIL TempSpecification.NEXT = 0;
//         RESET;
//         IF FIND('-') THEN
//           REPEAT
//             CheckLine(Rec);
//           UNTIL NEXT = 0;

//         SETRANGE("Lot No.",SourceSpecification."Lot No.");
//         SETRANGE("Serial No.",SourceSpecification."Serial No.");

//         CalculateSums;
//         IF UpdateUndefinedQty THEN
//           WriteToDatabase
//         ELSE
//           ERROR(Text014,TotalItemTrackingLine."Quantity (Base)",
//             LOWERCASE(TempReservEntry.TextCaption),SourceQuantityArray[1]);

//         // Copy to inbound part of transfer
//         IF FormRunMode = FormRunMode::Transfer THEN
//           SynchronizeLinkedSources('');
//     end;

//     procedure SynchronizeLinkedSources(DialogText: Text[250]): Boolean
//     begin
//         IF CurrentSourceRowID = '' THEN
//           EXIT(FALSE);
//         IF SecondSourceRowID = '' THEN
//           EXIT(FALSE);

//         ItemTrackingMgt.SynchronizeItemTracking(CurrentSourceRowID,SecondSourceRowID,DialogText);
//         EXIT(TRUE);
//     end;

//     procedure SetBlockCommit(NewBlockCommit: Boolean)
//     begin
//         BlockCommit := NewBlockCommit;
//     end;

//     procedure TempItemTrackingDef(NewTrackingSpecification: Record "336")
//     begin
//         Rec := NewTrackingSpecification;
//         "Entry No." := NextEntryNo;
//         IF (NOT InsertIsBlocked) AND (NOT ZeroLineExists) THEN
//           IF NOT TestTempSpecificationExists THEN
//             INSERT
//           ELSE
//             ModifyTrackingSpecification(NewTrackingSpecification);
//         WriteToDatabase;
//     end;

//     procedure SetCalledFromSynchWhseItemTrkg(CalledFromSynchWhseItemTrkg2: Boolean)
//     begin
//         CalledFromSynchWhseItemTrkg := CalledFromSynchWhseItemTrkg2;
//     end;

//     procedure ModifyTrackingSpecification(NewTrackingSpecification: Record "336")
//     var
//         CrntTempTrackingSpec: Record "336" temporary;
//     begin
//         CrntTempTrackingSpec.COPY(Rec);
//         SETCURRENTKEY("Lot No.","Serial No.");
//         SETRANGE("Lot No.",NewTrackingSpecification."Lot No.");
//         SETRANGE("Serial No.",NewTrackingSpecification."Serial No.");
//         SETFILTER("Entry No.",'<>%1',"Entry No.");
//         SETRANGE("Buffer Status",0);
//         IF FIND('-') THEN BEGIN
//           VALIDATE("Quantity (Base)",
//             "Quantity (Base)" + NewTrackingSpecification."Quantity (Base)");
//           MODIFY;
//         END;
//         COPY(CrntTempTrackingSpec);
//     end;

//     local procedure UpdateExpDateColor()
//     begin
//         IF ("Buffer Status2" = "Buffer Status2"::"ExpDate blocked") OR (CurrentSignFactor < 0) THEN;
//     end;

//     local procedure UpdateExpDateEditable()
//     begin
//         "Expiration DateEditable" :=
//           NOT (("Buffer Status2" = "Buffer Status2"::"ExpDate blocked") OR (CurrentSignFactor < 0));
//     end;

//     procedure LookupAvailable(LookupMode: Option "Serial No.","Lot No.")
//     begin
//         "Bin Code" := ForBinCode;
//         ItemTrackingDataCollection.LookupLotSerialNoAvailability(Rec,LookupMode);
//         "Bin Code" := '';
//         CurrPage.UPDATE;
//     end;

//     procedure F6LookupAvailable()
//     begin
//         IF SNAvailabilityActive THEN
//           LookupAvailable(0);
//         IF LotAvailabilityActive THEN
//           LookupAvailable(1);
//     end;

//     procedure LotSnAvailable(var TrackingSpecification: Record "336";LookupMode: Option "Serial No.","Lot No."): Boolean
//     begin
//         EXIT(ItemTrackingDataCollection.LotSNAvailable(TrackingSpecification,LookupMode));
//     end;

//     procedure SelectEntries()
//     var
//         xTrackingSpec: Record "336";
//         MaxQuantity: Decimal;
//     begin
//         xTrackingSpec.COPYFILTERS(Rec);
//         MaxQuantity := UndefinedQtyArray[1];
//         IF MaxQuantity * CurrentSignFactor > 0 THEN
//           MaxQuantity := 0;
//         "Bin Code" := ForBinCode;
//         ItemTrackingDataCollection.SelectMultipleLotSerialNo(Rec,MaxQuantity,CurrentSignFactor);
//         "Bin Code" := '';
//         IF FINDSET THEN
//           REPEAT
//             CASE "Buffer Status" OF
//               "Buffer Status"::MODIFY:
//                 BEGIN
//                   IF TempItemTrackLineModify.GET("Entry No.") THEN
//                     TempItemTrackLineModify.DELETE;
//                   IF TempItemTrackLineInsert.GET("Entry No.") THEN BEGIN
//                     TempItemTrackLineInsert.TRANSFERFIELDS(Rec);
//                     TempItemTrackLineInsert.MODIFY;
//                   END ELSE BEGIN
//                     TempItemTrackLineModify.TRANSFERFIELDS(Rec);
//                     TempItemTrackLineModify.INSERT;
//                   END;
//                 END;
//               "Buffer Status"::INSERT:
//                 BEGIN
//                   TempItemTrackLineInsert.TRANSFERFIELDS(Rec);
//                   TempItemTrackLineInsert.INSERT;
//                 END;
//             END;
//             "Buffer Status" := 0;
//             MODIFY;
//           UNTIL NEXT = 0;
//         LastEntryNo := "Entry No.";
//         CalculateSums;
//         UpdateUndefinedQtyArray;
//         COPYFILTERS(xTrackingSpec);
//         CurrPage.UPDATE(FALSE);
//     end;

//     procedure ReserveItemTrackingLine()
//     var
//         LateBindingMgt: Codeunit "6502";
//     begin
//         LateBindingMgt.ReserveItemTrackingLine(Rec);
//     end;

//     procedure ReestablishReservations()
//     var
//         LateBindingMgt: Codeunit "6502";
//     begin
//         IF TempItemTrackLineReserv.FINDSET THEN
//           REPEAT
//             LateBindingMgt.ReserveItemTrackingLine2(TempItemTrackLineReserv,0,TempItemTrackLineReserv."Quantity (Base)");
//             SetQtyToHandleAndInvoice(TempItemTrackLineReserv);
//           UNTIL TempItemTrackLineReserv.NEXT = 0;
//         TempItemTrackLineReserv.DELETEALL;
//     end;

//     procedure SetInbound(NewInbound: Boolean)
//     begin
//         InboundIsSet := TRUE;
//         Inbound := NewInbound;
//     end;

//     procedure SetPick(IsPick2: Boolean)
//     begin
//         IsPick := IsPick2;
//     end;

//     local procedure SerialNoOnAfterValidate()
//     begin
//         UpdateExpDateEditable;
//         CurrPage.UPDATE;
//     end;

//     local procedure LotNoOnAfterValidate()
//     begin
//         UpdateExpDateEditable;
//         CurrPage.UPDATE;
//     end;

//     local procedure QuantityBaseOnAfterValidate()
//     begin
//         CurrPage.UPDATE;
//     end;

//     local procedure QuantityBaseOnValidate()
//     begin
//         IF NOT CheckLine(Rec) THEN
//           EXIT;
//     end;

//     local procedure QtytoHandleBaseOnAfterValidate()
//     begin
//         CurrPage.UPDATE;
//     end;

//     local procedure QtytoInvoiceBaseOnAfterValidat()
//     begin
//         CurrPage.UPDATE;
//     end;

//     local procedure ExpirationDateOnFormat()
//     begin
//         UpdateExpDateColor;
//     end;

//     local procedure ChangeAlreadyNonSpecificReservations(var TempTrackingSpecification: Record "336" temporary;QuantityBase: Decimal): Boolean
//     var
//         ReservEntry: Record "337";
//         ReservEntry2: Record "337";
//         RemainingQtyBase: Decimal;
//         EntryNo: Integer;
//     begin
//         // Checks if there is already a non specific reservation pointing on the chosen SN/LN,
//         // and makes the reservation specific in that case
//         WITH TempTrackingSpecification DO BEGIN
//           IF Positive THEN
//             EXIT(FALSE);

//           IF QuantityBase <= 0 THEN
//             EXIT(FALSE);

//           ReservEntry.SETRANGE("Reservation Status",ReservEntry."Reservation Status"::Reservation);
//           ReservEntry.SETRANGE("Source Type",DATABASE::"Item Ledger Entry");
//           ReservEntry.SETRANGE("Item No.","Item No.");
//           ReservEntry.SETRANGE("Serial No.","Serial No.");
//           ReservEntry.SETRANGE("Lot No.","Lot No.");
//           ReservEntry.SETRANGE(Positive,NOT Positive);

//           IF ReservEntry.FINDSET THEN BEGIN
//             IF "Serial No." <> '' THEN BEGIN
//               IF CompareToReservationEntry(TempTrackingSpecification,ReservEntry2,ReservEntry."Entry No.",ReservEntry.Positive) THEN BEGIN
//                 ModifyReservationEntry(ReservEntry2,"Serial No.","Lot No.",0);
//                 EXIT(TRUE);
//               END;
//               EXIT(FALSE);
//             END;

//             IF "Lot No." <> '' THEN BEGIN
//               RemainingQtyBase := QuantityBase;

//               REPEAT
//                 IF CompareToReservationEntry(TempTrackingSpecification,ReservEntry2,ReservEntry."Entry No.",ReservEntry.Positive) THEN BEGIN
//                   IF ReservEntry."Quantity (Base)" = RemainingQtyBase THEN BEGIN
//                     ModifyReservationEntry(ReservEntry2,'',"Lot No.",0);
//                     EXIT(TRUE);
//                   END;

//                   IF ReservEntry."Quantity (Base)" > RemainingQtyBase THEN BEGIN
//                     // Modify existing reservation pair, and create new reservation pair for the quantity exceeding the needed quantity
//                     EntryNo := TransferToNewReservation(ReservEntry,ReservEntry."Quantity (Base)" - RemainingQtyBase,0);
//                     TransferToNewReservation(ReservEntry2,ReservEntry."Quantity (Base)" - RemainingQtyBase,EntryNo);

//                     ReservEntry.VALIDATE("Quantity (Base)",RemainingQtyBase);
//                     ReservEntry.MODIFY;

//                     ModifyReservationEntry(ReservEntry2,'',"Lot No.",-RemainingQtyBase);
//                     EXIT(TRUE);
//                   END;

//                   IF ReservEntry."Quantity (Base)" < RemainingQtyBase THEN BEGIN
//                     ModifyReservationEntry(ReservEntry2,'',"Lot No.",0);
//                     RemainingQtyBase -= ReservEntry."Quantity (Base)";
//                   END;
//                 END;
//               UNTIL (ReservEntry.NEXT = 0) OR (RemainingQtyBase = 0);

//               IF RemainingQtyBase > 0 THEN BEGIN
//                 VALIDATE("Quantity (Base)",RemainingQtyBase);
//                 MODIFY;
//               END;

//               EXIT(FALSE);
//             END;
//           END;
//         END;
//     end;

//     local procedure TransferToNewReservation(ReservEntry: Record "337";QtyBase: Decimal;EntryNo: Integer): Integer
//     var
//         ReservEntry2: Record "337";
//         SignFactor: Integer;
//     begin
//         IF ReservEntry.Positive THEN
//           SignFactor := 1
//         ELSE
//           SignFactor := -1;

//         ReservEntry2.INIT;
//         ReservEntry2.TRANSFERFIELDS(ReservEntry,FALSE);
//         ReservEntry2.VALIDATE("Quantity (Base)",SignFactor * QtyBase);
//         IF EntryNo <> 0 THEN
//           ReservEntry2."Entry No." := EntryNo;
//         ReservEntry2.Positive := ReservEntry.Positive;
//         ReservEntry2.INSERT;

//         EXIT(ReservEntry2."Entry No.");
//     end;

//     procedure CompareToReservationEntry(TempTrackingSpecification: Record "336" temporary;var ReservEntry: Record "337";EntryNo: Integer;Pos: Boolean): Boolean
//     begin
//         WITH TempTrackingSpecification DO BEGIN
//           ReservEntry.GET(EntryNo,NOT Pos);
//           IF (ReservEntry."Source ID" = "Source ID") AND
//              (ReservEntry."Source Ref. No." = "Source Ref. No.") AND
//              (ReservEntry."Source Type" = "Source Type") AND
//              (ReservEntry."Source Subtype" = "Source Subtype") AND
//              (ReservEntry."Source Prod. Order Line" = "Source Prod. Order Line") AND
//              (ReservEntry."Serial No." = '') AND
//              (ReservEntry."Lot No." = '')
//           THEN
//             EXIT(TRUE);

//           EXIT(FALSE);
//         END;
//     end;

//     procedure ModifyReservationEntry(var ReservEntry: Record "337";SerialNo: Code[20];LotNo: Code[20];QuantityBase: Decimal)
//     begin
//         ReservEntry.VALIDATE("Serial No.",SerialNo);
//         ReservEntry.VALIDATE("Lot No.",LotNo);
//         ReservEntry.UpdateItemTracking;
//         IF QuantityBase <> 0 THEN
//           ReservEntry.VALIDATE("Quantity (Base)",QuantityBase);
//         ReservEntry.MODIFY;
//     end;

//     local procedure TempRecValid()
//     begin
//         IF NOT TempRecIsValid THEN
//           ERROR(Text007);
//     end;

//     local procedure GetHandleSource(TrackingSpecification: Record "336"): Boolean
//     var
//         QtyToHandleColumnIsHidden: Boolean;
//     begin
//         WITH TrackingSpecification DO BEGIN
//           IF ("Source Type" = DATABASE::"Item Journal Line") AND ("Source Subtype" = 6) THEN BEGIN // 6 => Prod.order line
//             ProdOrderLineHandling := TRUE;
//             EXIT(TRUE);  // Display Handle column for prod. orders
//           END;
//           QtyToHandleColumnIsHidden :=
//             ("Source Type" IN
//              [DATABASE::"Item Ledger Entry",
//               DATABASE::"Item Journal Line",
//               DATABASE::"Job Journal Line",
//               DATABASE::"Requisition Line"]) OR
//             (("Source Type" IN [DATABASE::"Sales Line",DATABASE::"Purchase Line",DATABASE::"Service Line"]) AND
//              ("Source Subtype" IN [0,2,3])) OR
//             (("Source Type" = DATABASE::"Assembly Line") AND ("Source Subtype" = 0));
//         END;
//         EXIT(NOT QtyToHandleColumnIsHidden);
//     end;

//     local procedure GetInvoiceSource(TrackingSpecification: Record "336"): Boolean
//     var
//         QtyToInvoiceColumnIsHidden: Boolean;
//     begin
//         WITH TrackingSpecification DO BEGIN
//           QtyToInvoiceColumnIsHidden :=
//             ("Source Type" IN
//              [DATABASE::"Item Ledger Entry",
//               DATABASE::"Item Journal Line",
//               DATABASE::"Job Journal Line",
//               DATABASE::"Requisition Line",
//               DATABASE::"Transfer Line",
//               DATABASE::"Assembly Line",
//               DATABASE::"Assembly Header",
//               DATABASE::"Prod. Order Line",
//               DATABASE::"Prod. Order Component"]) OR
//             (("Source Type" IN [DATABASE::"Sales Line",DATABASE::"Purchase Line",DATABASE::"Service Line"]) AND
//              ("Source Subtype" IN [0,2,3,4]))
//         END;
//         EXIT(NOT QtyToInvoiceColumnIsHidden);
//     end;
// }

