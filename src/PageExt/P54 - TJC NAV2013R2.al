// page 54 "Purchase Order Subform"
// {
//     AutoSplitKey = true;
//     Caption = 'Lines';
//     DelayedInsert = true;
//     LinksAllowed = false;
//     MultipleNewLines = true;
//     PageType = ListPart;
//     SourceTable = Table39;
//     SourceTableView = WHERE(Document Type=FILTER(Order));

//     layout
//     {
//         area(content)
//         {
//             repeater()
//             {
//                 field("Line No.";"Line No.")
//                 {
//                 }
//                 field(Type;Type)
//                 {

//                     trigger OnValidate()
//                     begin
//                         NoOnAfterValidate;
//                     end;
//                 }
//                 field("No.";"No.")
//                 {

//                     trigger OnValidate()
//                     begin
//                         ShowShortcutDimCode(ShortcutDimCode);
//                         NoOnAfterValidate;
//                     end;
//                 }
//                 field("Gen. Prod. Posting Group";"Gen. Prod. Posting Group")
//                 {
//                 }
//                 field("Cross-Reference No.";"Cross-Reference No.")
//                 {
//                     Visible = false;

//                     trigger OnLookup(var Text: Text): Boolean
//                     begin
//                         CrossReferenceNoLookUp;
//                         InsertExtendedText(FALSE);
//                         NoOnAfterValidate;
//                     end;

//                     trigger OnValidate()
//                     begin
//                         CrossReferenceNoOnAfterValidat;
//                         NoOnAfterValidate;
//                     end;
//                 }
//                 field("IC Partner Code";"IC Partner Code")
//                 {
//                     Visible = false;
//                 }
//                 field("IC Partner Ref. Type";"IC Partner Ref. Type")
//                 {
//                     Visible = false;
//                 }
//                 field("IC Partner Reference";"IC Partner Reference")
//                 {
//                     Visible = false;
//                 }
//                 field("Variant Code";"Variant Code")
//                 {
//                     Visible = false;
//                 }
//                 field(Nonstock;Nonstock)
//                 {
//                     Visible = false;
//                 }
//                 field("VAT Prod. Posting Group";"VAT Prod. Posting Group")
//                 {
//                     Visible = false;
//                 }
//                 field(Description;Description)
//                 {
//                 }
//                 field("Description 2";"Description 2")
//                 {
//                 }
//                 field("Drop Shipment";"Drop Shipment")
//                 {
//                     Visible = false;
//                 }
//                 field("Return Reason Code";"Return Reason Code")
//                 {
//                     Visible = false;
//                 }
//                 field("Location Code";"Location Code")
//                 {
//                 }
//                 field("Bin Code";"Bin Code")
//                 {
//                     Visible = true;
//                 }
//                 field(Quantity;Quantity)
//                 {
//                     BlankZero = true;
//                 }
//                 field("Reserved Quantity";"Reserved Quantity")
//                 {
//                     BlankZero = true;
//                 }
//                 field("Job Remaining Qty.";"Job Remaining Qty.")
//                 {
//                     BlankZero = true;
//                     Visible = false;
//                 }
//                 field("Unit of Measure Code";"Unit of Measure Code")
//                 {
//                 }
//                 field("Unit of Measure";"Unit of Measure")
//                 {
//                     Visible = false;
//                 }
//                 field("Direct Unit Cost";"Direct Unit Cost")
//                 {
//                     BlankZero = true;
//                 }
//                 field("Indirect Cost %";"Indirect Cost %")
//                 {
//                     Visible = false;
//                 }
//                 field("Unit Cost (LCY)";"Unit Cost (LCY)")
//                 {
//                     Visible = false;
//                 }
//                 field("Unit Price (LCY)";"Unit Price (LCY)")
//                 {
//                     BlankZero = true;
//                     Visible = false;
//                 }
//                 field("Line Amount";"Line Amount")
//                 {
//                     BlankZero = true;
//                 }
//                 field("Line Discount %";"Line Discount %")
//                 {
//                     BlankZero = true;
//                 }
//                 field("Line Discount Amount";"Line Discount Amount")
//                 {
//                     Visible = false;
//                 }
//                 field("Prepayment %";"Prepayment %")
//                 {
//                     Visible = false;
//                 }
//                 field("Prepmt. Line Amount";"Prepmt. Line Amount")
//                 {
//                     Visible = false;
//                 }
//                 field("Prepmt. Amt. Inv.";"Prepmt. Amt. Inv.")
//                 {
//                     Visible = false;
//                 }
//                 field("Allow Invoice Disc.";"Allow Invoice Disc.")
//                 {
//                     Visible = false;
//                 }
//                 field("Inv. Discount Amount";"Inv. Discount Amount")
//                 {
//                     Visible = false;
//                 }
//                 field("Qty. to Receive";"Qty. to Receive")
//                 {
//                     BlankZero = true;
//                 }
//                 field("Quantity Received";"Quantity Received")
//                 {
//                     BlankZero = true;
//                 }
//                 field("Qty. to Invoice";"Qty. to Invoice")
//                 {
//                     BlankZero = true;
//                 }
//                 field("Quantity Invoiced";"Quantity Invoiced")
//                 {
//                     BlankZero = true;
//                 }
//                 field("Prepmt Amt to Deduct";"Prepmt Amt to Deduct")
//                 {
//                     Visible = false;
//                 }
//                 field("Prepmt Amt Deducted";"Prepmt Amt Deducted")
//                 {
//                     Visible = false;
//                 }
//                 field("Allow Item Charge Assignment";"Allow Item Charge Assignment")
//                 {
//                     Visible = false;
//                 }
//                 field("Qty. to Assign";"Qty. to Assign")
//                 {
//                     BlankZero = true;

//                     trigger OnDrillDown()
//                     begin
//                         CurrPage.SAVERECORD;
//                         ShowItemChargeAssgnt;
//                         UpdateForm(FALSE);
//                     end;
//                 }
//                 field("Qty. Assigned";"Qty. Assigned")
//                 {
//                     BlankZero = true;

//                     trigger OnDrillDown()
//                     begin
//                         CurrPage.SAVERECORD;
//                         ShowItemChargeAssgnt;
//                         UpdateForm(FALSE);
//                     end;
//                 }
//                 field("Job No.";"Job No.")
//                 {
//                     Visible = false;
//                 }
//                 field("Job Task No.";"Job Task No.")
//                 {
//                     Visible = false;
//                 }
//                 field("Job Planning Line No.";"Job Planning Line No.")
//                 {
//                     Visible = false;
//                 }
//                 field("Job Line Type";"Job Line Type")
//                 {
//                     Visible = false;
//                 }
//                 field("Job Unit Price";"Job Unit Price")
//                 {
//                     Visible = false;
//                 }
//                 field("Job Line Amount";"Job Line Amount")
//                 {
//                     Visible = false;
//                 }
//                 field("Job Line Discount Amount";"Job Line Discount Amount")
//                 {
//                     Visible = false;
//                 }
//                 field("Job Line Discount %";"Job Line Discount %")
//                 {
//                     Visible = false;
//                 }
//                 field("Job Total Price";"Job Total Price")
//                 {
//                     Visible = false;
//                 }
//                 field("Job Unit Price (LCY)";"Job Unit Price (LCY)")
//                 {
//                     Visible = false;
//                 }
//                 field("Job Total Price (LCY)";"Job Total Price (LCY)")
//                 {
//                     Visible = false;
//                 }
//                 field("Job Line Amount (LCY)";"Job Line Amount (LCY)")
//                 {
//                     Visible = false;
//                 }
//                 field("Job Line Disc. Amount (LCY)";"Job Line Disc. Amount (LCY)")
//                 {
//                     Visible = false;
//                 }
//                 field("Requested Receipt Date";"Requested Receipt Date")
//                 {
//                     Visible = false;
//                 }
//                 field("Promised Receipt Date";"Promised Receipt Date")
//                 {
//                     Visible = false;
//                 }
//                 field("Planned Receipt Date";"Planned Receipt Date")
//                 {
//                 }
//                 field("Expected Receipt Date";"Expected Receipt Date")
//                 {
//                 }
//                 field("Order Date";"Order Date")
//                 {
//                 }
//                 field("Lead Time Calculation";"Lead Time Calculation")
//                 {
//                     Visible = false;
//                 }
//                 field("Planning Flexibility";"Planning Flexibility")
//                 {
//                     Visible = false;
//                 }
//                 field("Prod. Order No.";"Prod. Order No.")
//                 {
//                     Visible = false;
//                 }
//                 field("Prod. Order Line No.";"Prod. Order Line No.")
//                 {
//                     Visible = false;
//                 }
//                 field("Operation No.";"Operation No.")
//                 {
//                     Visible = false;
//                 }
//                 field("Work Center No.";"Work Center No.")
//                 {
//                     Visible = false;
//                 }
//                 field(Finished;Finished)
//                 {
//                     Visible = false;
//                 }
//                 field("Whse. Outstanding Qty. (Base)";"Whse. Outstanding Qty. (Base)")
//                 {
//                     Visible = false;
//                 }
//                 field("Inbound Whse. Handling Time";"Inbound Whse. Handling Time")
//                 {
//                     Visible = false;
//                 }
//                 field("Blanket Order No.";"Blanket Order No.")
//                 {
//                     Visible = false;
//                 }
//                 field("Blanket Order Line No.";"Blanket Order Line No.")
//                 {
//                     Visible = false;
//                 }
//                 field("Appl.-to Item Entry";"Appl.-to Item Entry")
//                 {
//                     Visible = false;
//                 }
//                 field("Shortcut Dimension 1 Code";"Shortcut Dimension 1 Code")
//                 {
//                     Visible = false;
//                 }
//                 field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
//                 {
//                     Visible = false;
//                 }
//                 field(ShortcutDimCode[3];ShortcutDimCode[3])
//                 {
//                     CaptionClass = '1,2,3';
//                     Visible = false;

//                     trigger OnLookup(var Text: Text): Boolean
//                     begin
//                         LookupShortcutDimCode(3,ShortcutDimCode[3]);
//                     end;

//                     trigger OnValidate()
//                     begin
//                         ValidateShortcutDimCode(3,ShortcutDimCode[3]);
//                     end;
//                 }
//                 field(ShortcutDimCode[4];ShortcutDimCode[4])
//                 {
//                     CaptionClass = '1,2,4';
//                     Visible = false;

//                     trigger OnLookup(var Text: Text): Boolean
//                     begin
//                         LookupShortcutDimCode(4,ShortcutDimCode[4]);
//                     end;

//                     trigger OnValidate()
//                     begin
//                         ValidateShortcutDimCode(4,ShortcutDimCode[4]);
//                     end;
//                 }
//                 field(ShortcutDimCode[5];ShortcutDimCode[5])
//                 {
//                     CaptionClass = '1,2,5';
//                     Visible = false;

//                     trigger OnLookup(var Text: Text): Boolean
//                     begin
//                         LookupShortcutDimCode(5,ShortcutDimCode[5]);
//                     end;

//                     trigger OnValidate()
//                     begin
//                         ValidateShortcutDimCode(5,ShortcutDimCode[5]);
//                     end;
//                 }
//                 field(ShortcutDimCode[6];ShortcutDimCode[6])
//                 {
//                     CaptionClass = '1,2,6';
//                     Visible = false;

//                     trigger OnLookup(var Text: Text): Boolean
//                     begin
//                         LookupShortcutDimCode(6,ShortcutDimCode[6]);
//                     end;

//                     trigger OnValidate()
//                     begin
//                         ValidateShortcutDimCode(6,ShortcutDimCode[6]);
//                     end;
//                 }
//                 field(ShortcutDimCode[7];ShortcutDimCode[7])
//                 {
//                     CaptionClass = '1,2,7';
//                     Visible = false;

//                     trigger OnLookup(var Text: Text): Boolean
//                     begin
//                         LookupShortcutDimCode(7,ShortcutDimCode[7]);
//                     end;

//                     trigger OnValidate()
//                     begin
//                         ValidateShortcutDimCode(7,ShortcutDimCode[7]);
//                     end;
//                 }
//                 field(ShortcutDimCode[8];ShortcutDimCode[8])
//                 {
//                     CaptionClass = '1,2,8';
//                     Visible = false;

//                     trigger OnLookup(var Text: Text): Boolean
//                     begin
//                         LookupShortcutDimCode(8,ShortcutDimCode[8]);
//                     end;

//                     trigger OnValidate()
//                     begin
//                         ValidateShortcutDimCode(8,ShortcutDimCode[8]);
//                     end;
//                 }
//             }
//         }
//     }

//     actions
//     {
//         area(processing)
//         {
//             group("&Line")
//             {
//                 Caption = '&Line';
//                 Image = Line;
//                 group("Item Availability by")
//                 {
//                     Caption = 'Item Availability by';
//                     Image = ItemAvailability;
//                     action("Event")
//                     {
//                         Caption = 'Event';
//                         Image = "Event";

//                         trigger OnAction()
//                         begin
//                             ItemAvailFormsMgt.ShowItemAvailFromPurchLine(Rec,ItemAvailFormsMgt.ByEvent)
//                         end;
//                     }
//                     action(Period)
//                     {
//                         Caption = 'Period';
//                         Image = Period;

//                         trigger OnAction()
//                         begin
//                             ItemAvailFormsMgt.ShowItemAvailFromPurchLine(Rec,ItemAvailFormsMgt.ByPeriod)
//                         end;
//                     }
//                     action(Variant)
//                     {
//                         Caption = 'Variant';
//                         Image = ItemVariant;

//                         trigger OnAction()
//                         begin
//                             ItemAvailFormsMgt.ShowItemAvailFromPurchLine(Rec,ItemAvailFormsMgt.ByVariant)
//                         end;
//                     }
//                     action(Location)
//                     {
//                         Caption = 'Location';
//                         Image = Warehouse;

//                         trigger OnAction()
//                         begin
//                             ItemAvailFormsMgt.ShowItemAvailFromPurchLine(Rec,ItemAvailFormsMgt.ByLocation)
//                         end;
//                     }
//                     action("BOM Level")
//                     {
//                         Caption = 'BOM Level';
//                         Image = BOMLevel;

//                         trigger OnAction()
//                         begin
//                             ItemAvailFormsMgt.ShowItemAvailFromPurchLine(Rec,ItemAvailFormsMgt.ByBOM)
//                         end;
//                     }
//                 }
//                 action("Reservation Entries")
//                 {
//                     Caption = 'Reservation Entries';
//                     Image = ReservationLedger;

//                     trigger OnAction()
//                     begin
//                         ShowReservationEntries(TRUE);
//                     end;
//                 }
//                 action("Item Tracking Lines")
//                 {
//                     Caption = 'Item &Tracking Lines';
//                     Image = ItemTrackingLines;
//                     ShortCutKey = 'Shift+Ctrl+I';

//                     trigger OnAction()
//                     begin
//                         OpenItemTrackingLines;
//                     end;
//                 }
//                 action(Dimensions)
//                 {
//                     Caption = 'Dimensions';
//                     Image = Dimensions;
//                     ShortCutKey = 'Shift+Ctrl+D';

//                     trigger OnAction()
//                     begin
//                         ShowDimensions;
//                     end;
//                 }
//                 action("Co&mments")
//                 {
//                     Caption = 'Co&mments';
//                     Image = ViewComments;

//                     trigger OnAction()
//                     begin
//                         ShowLineComments;
//                     end;
//                 }
//                 action(ItemChargeAssignment)
//                 {
//                     Caption = 'Item Charge &Assignment';

//                     trigger OnAction()
//                     begin
//                         ShowItemChargeAssgnt;
//                     end;
//                 }
//             }
//             group("F&unctions")
//             {
//                 Caption = 'F&unctions';
//                 Image = "Action";
//                 action("E&xplode BOM")
//                 {
//                     Caption = 'E&xplode BOM';
//                     Image = ExplodeBOM;

//                     trigger OnAction()
//                     begin
//                         ExplodeBOM;
//                     end;
//                 }
//                 action("Insert Ext. Texts")
//                 {
//                     Caption = 'Insert &Ext. Text';
//                     Image = Text;

//                     trigger OnAction()
//                     begin
//                         InsertExtendedText(TRUE);
//                     end;
//                 }
//                 action(Reserve)
//                 {
//                     Caption = '&Reserve';
//                     Ellipsis = true;
//                     Image = Reserve;

//                     trigger OnAction()
//                     begin
//                         FIND;
//                         ShowReservation;
//                     end;
//                 }
//                 action(OrderTracking)
//                 {
//                     Caption = 'Order &Tracking';
//                     Image = OrderTracking;

//                     trigger OnAction()
//                     begin
//                         ShowTracking;
//                     end;
//                 }
//             }
//             group("O&rder")
//             {
//                 Caption = 'O&rder';
//                 Image = "Order";
//                 group("Dr&op Shipment")
//                 {
//                     Caption = 'Dr&op Shipment';
//                     Image = Delivery;
//                     action("Sales &Order")
//                     {
//                         Caption = 'Sales &Order';
//                         Image = Document;

//                         trigger OnAction()
//                         begin
//                             OpenSalesOrderForm;
//                         end;
//                     }
//                 }
//                 group("Speci&al Order")
//                 {
//                     Caption = 'Speci&al Order';
//                     Image = SpecialOrder;
//                     action("Sales &Order")
//                     {
//                         Caption = 'Sales &Order';
//                         Image = Document;

//                         trigger OnAction()
//                         begin
//                             OpenSpecOrderSalesOrderForm;
//                         end;
//                     }
//                 }
//             }
//         }
//     }

//     trigger OnAfterGetRecord()
//     begin
//         ShowShortcutDimCode(ShortcutDimCode);
//     end;

//     trigger OnDeleteRecord(): Boolean
//     var
//         ReservePurchLine: Codeunit "99000834";
//     begin
//         IF (Quantity <> 0) AND ItemExists("No.") THEN BEGIN
//           COMMIT;
//           IF NOT ReservePurchLine.DeleteLineConfirm(Rec) THEN
//             EXIT(FALSE);
//           ReservePurchLine.DeleteLine(Rec);
//         END;
//     end;

//     trigger OnNewRecord(BelowxRec: Boolean)
//     begin
//         InitType;
//         CLEAR(ShortcutDimCode);
//     end;

//     var
//         TransferExtendedText: Codeunit "378";
//         ItemAvailFormsMgt: Codeunit "353";
//         ShortcutDimCode: array [8] of Code[20];
//         UpdateAllowedVar: Boolean;
//         Text000: Label 'Unable to execute this function while in view only mode.';
//         PurchHeader: Record "38";
//         PurchPriceCalcMgt: Codeunit "7010";
//         Text001: Label 'You cannot use the Explode BOM function because a prepayment of the purchase order has been invoiced.';

//     procedure ApproveCalcInvDisc()
//     begin
//         CODEUNIT.RUN(CODEUNIT::"Purch.-Disc. (Yes/No)",Rec);
//     end;

//     procedure CalcInvDisc()
//     begin
//         CODEUNIT.RUN(CODEUNIT::"Purch.-Calc.Discount",Rec);
//     end;

//     procedure ExplodeBOM()
//     begin
//         IF "Prepmt. Amt. Inv." <> 0 THEN
//           ERROR(Text001);
//         CODEUNIT.RUN(CODEUNIT::"Purch.-Explode BOM",Rec);
//     end;

//     procedure OpenSalesOrderForm()
//     var
//         SalesHeader: Record "36";
//         SalesOrder: Page "42";
//     begin
//         TESTFIELD("Sales Order No.");
//         SalesHeader.SETRANGE("No.","Sales Order No.");
//         SalesOrder.SETTABLEVIEW(SalesHeader);
//         SalesOrder.EDITABLE := FALSE;
//         SalesOrder.RUN;
//     end;

//     procedure InsertExtendedText(Unconditionally: Boolean)
//     begin
//         IF TransferExtendedText.PurchCheckIfAnyExtText(Rec,Unconditionally) THEN BEGIN
//           CurrPage.SAVERECORD;
//           TransferExtendedText.InsertPurchExtText(Rec);
//         END;
//         IF TransferExtendedText.MakeUpdate THEN
//           UpdateForm(TRUE);
//     end;

//     procedure ShowTracking()
//     var
//         TrackingForm: Page "99000822";
//     begin
//         TrackingForm.SetPurchLine(Rec);
//         TrackingForm.RUNMODAL;
//     end;

//     procedure OpenSpecOrderSalesOrderForm()
//     var
//         SalesHeader: Record "36";
//         SalesOrder: Page "42";
//     begin
//         TESTFIELD("Special Order Sales No.");
//         SalesHeader.SETRANGE("No.","Special Order Sales No.");
//         SalesOrder.SETTABLEVIEW(SalesHeader);
//         SalesOrder.EDITABLE := FALSE;
//         SalesOrder.RUN;
//     end;

//     procedure UpdateForm(SetSaveRecord: Boolean)
//     begin
//         CurrPage.UPDATE(SetSaveRecord);
//     end;

//     procedure SetUpdateAllowed(UpdateAllowed: Boolean)
//     begin
//         UpdateAllowedVar := UpdateAllowed;
//     end;

//     procedure UpdateAllowed(): Boolean
//     begin
//         IF UpdateAllowedVar = FALSE THEN BEGIN
//           MESSAGE(Text000);
//           EXIT(FALSE);
//         END;
//         EXIT(TRUE);
//     end;

//     procedure ShowPrices()
//     begin
//         PurchHeader.GET("Document Type","Document No.");
//         CLEAR(PurchPriceCalcMgt);
//         PurchPriceCalcMgt.GetPurchLinePrice(PurchHeader,Rec);
//     end;

//     procedure ShowLineDisc()
//     begin
//         PurchHeader.GET("Document Type","Document No.");
//         CLEAR(PurchPriceCalcMgt);
//         PurchPriceCalcMgt.GetPurchLineLineDisc(PurchHeader,Rec);
//     end;

//     local procedure NoOnAfterValidate()
//     begin
//         InsertExtendedText(FALSE);
//         IF (Type = Type::"Charge (Item)") AND ("No." <> xRec."No.") AND
//            (xRec."No." <> '')
//         THEN
//           CurrPage.SAVERECORD;
//     end;

//     local procedure CrossReferenceNoOnAfterValidat()
//     begin
//         InsertExtendedText(FALSE);
//     end;
// }

