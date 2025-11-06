// page 96 "Sales Cr. Memo Subform"
// {
//     AutoSplitKey = true;
//     Caption = 'Lines';
//     DelayedInsert = true;
//     LinksAllowed = false;
//     MultipleNewLines = true;
//     PageType = ListPart;
//     SourceTable = Table37;
//     SourceTableView = WHERE(Document Type=FILTER(Credit Memo));

//     layout
//     {
//         area(content)
//         {
//             repeater()
//             {
//                 field("Line No.";"Line No.")
//                 {
//                     Visible = false;
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
//                 field("Return Reason Code";"Return Reason Code")
//                 {
//                     Visible = false;
//                 }
//                 field("Location Code";"Location Code")
//                 {
//                     Visible = true;
//                 }
//                 field("Bin Code";"Bin Code")
//                 {
//                     Visible = true;
//                 }
//                 field(Reserve;Reserve)
//                 {
//                     Visible = false;

//                     trigger OnValidate()
//                     begin
//                         ReserveOnAfterValidate;
//                     end;
//                 }
//                 field(Quantity;Quantity)
//                 {
//                     BlankZero = true;

//                     trigger OnValidate()
//                     begin
//                         QuantityOnAfterValidate;
//                     end;
//                 }
//                 field("Reserved Quantity";"Reserved Quantity")
//                 {
//                     BlankZero = true;
//                     Visible = false;

//                     trigger OnDrillDown()
//                     begin
//                         CurrPage.SAVERECORD;
//                         COMMIT;
//                         ShowReservationEntries(TRUE);
//                         UpdateForm(TRUE);
//                     end;
//                 }
//                 field("Unit of Measure Code";"Unit of Measure Code")
//                 {

//                     trigger OnValidate()
//                     begin
//                         UnitofMeasureCodeOnAfterValida;
//                     end;
//                 }
//                 field("Unit of Measure";"Unit of Measure")
//                 {
//                     Visible = false;
//                 }
//                 field("Unit Cost (LCY)";"Unit Cost (LCY)")
//                 {
//                     Visible = false;
//                 }
//                 field("Unit Price";"Unit Price")
//                 {
//                     BlankZero = true;
//                 }
//                 field("Line Amount";"Line Amount")
//                 {
//                 }
//                 field("Line Discount %";"Line Discount %")
//                 {
//                     BlankZero = true;
//                 }
//                 field("Line Discount Amount";"Line Discount Amount")
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

//                     trigger OnValidate()
//                     begin
//                         ShowShortcutDimCode(ShortcutDimCode);
//                     end;
//                 }
//                 field("Job Task No.";"Job Task No.")
//                 {
//                     Visible = false;
//                 }
//                 field("Work Type Code";"Work Type Code")
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
//                 field("Appl.-from Item Entry";"Appl.-from Item Entry")
//                 {
//                     Visible = false;
//                 }
//                 field("Appl.-to Item Entry";"Appl.-to Item Entry")
//                 {
//                     Visible = false;
//                 }
//                 field("Gen. Prod. Posting Group";"Gen. Prod. Posting Group")
//                 {
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
//                 action("Insert &Ext. Texts")
//                 {
//                     Caption = 'Insert &Ext. Texts';
//                     Image = Text;

//                     trigger OnAction()
//                     begin
//                         InsertExtendedText(TRUE);
//                     end;
//                 }
//                 action("Get Return &Receipt Lines")
//                 {
//                     Caption = 'Get Return &Receipt Lines';
//                     Ellipsis = true;
//                     Image = ReturnReceipt;

//                     trigger OnAction()
//                     begin
//                         GetReturnReceipt;
//                     end;
//                 }
//             }
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
//                             ItemAvailFormsMgt.ShowItemAvailFromSalesLine(Rec,ItemAvailFormsMgt.ByEvent)
//                         end;
//                     }
//                     action(Period)
//                     {
//                         Caption = 'Period';
//                         Image = Period;

//                         trigger OnAction()
//                         begin
//                             ItemAvailFormsMgt.ShowItemAvailFromSalesLine(Rec,ItemAvailFormsMgt.ByPeriod)
//                         end;
//                     }
//                     action(Variant)
//                     {
//                         Caption = 'Variant';
//                         Image = ItemVariant;

//                         trigger OnAction()
//                         begin
//                             ItemAvailFormsMgt.ShowItemAvailFromSalesLine(Rec,ItemAvailFormsMgt.ByVariant)
//                         end;
//                     }
//                     action(Location)
//                     {
//                         Caption = 'Location';
//                         Image = Warehouse;

//                         trigger OnAction()
//                         begin
//                             ItemAvailFormsMgt.ShowItemAvailFromSalesLine(Rec,ItemAvailFormsMgt.ByLocation)
//                         end;
//                     }
//                     action("BOM Level")
//                     {
//                         Caption = 'BOM Level';
//                         Image = BOMLevel;

//                         trigger OnAction()
//                         begin
//                             ItemAvailFormsMgt.ShowItemAvailFromSalesLine(Rec,ItemAvailFormsMgt.ByBOM)
//                         end;
//                     }
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
//                 action("Item Charge &Assignment")
//                 {
//                     Caption = 'Item Charge &Assignment';

//                     trigger OnAction()
//                     begin
//                         ItemChargeAssgnt;
//                     end;
//                 }
//                 action(ItemTrackingLines)
//                 {
//                     Caption = 'Item &Tracking Lines';
//                     Image = ItemTrackingLines;
//                     ShortCutKey = 'Shift+Ctrl+I';

//                     trigger OnAction()
//                     begin
//                         OpenItemTrackingLines;
//                     end;
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
//         ReserveSalesLine: Codeunit "99000832";
//     begin
//         IF (Quantity <> 0) AND ItemExists("No.") THEN BEGIN
//           COMMIT;
//           IF NOT ReserveSalesLine.DeleteLineConfirm(Rec) THEN
//             EXIT(FALSE);
//           ReserveSalesLine.DeleteLine(Rec);
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

//     procedure ApproveCalcInvDisc()
//     begin
//         CODEUNIT.RUN(CODEUNIT::"Sales-Disc. (Yes/No)",Rec);
//     end;

//     procedure CalcInvDisc()
//     begin
//         CODEUNIT.RUN(CODEUNIT::"Sales-Calc. Discount",Rec);
//     end;

//     procedure ExplodeBOM()
//     begin
//         CODEUNIT.RUN(CODEUNIT::"Sales-Explode BOM",Rec);
//     end;

//     procedure GetReturnReceipt()
//     begin
//         CODEUNIT.RUN(CODEUNIT::"Sales-Get Return Receipts",Rec);
//     end;

//     procedure InsertExtendedText(Unconditionally: Boolean)
//     begin
//         IF TransferExtendedText.SalesCheckIfAnyExtText(Rec,Unconditionally) THEN BEGIN
//           CurrPage.SAVERECORD;
//           COMMIT;
//           TransferExtendedText.InsertSalesExtText(Rec);
//         END;
//         IF TransferExtendedText.MakeUpdate THEN
//           UpdateForm(TRUE);
//     end;

//     procedure OpenItemTrackingLines()
//     begin
//         OpenItemTrackingLines;
//     end;

//     procedure ItemChargeAssgnt()
//     begin
//         ShowItemChargeAssgnt;
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

//     procedure ShowLineComments()
//     begin
//         ShowLineComments;
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

//     local procedure ReserveOnAfterValidate()
//     begin
//         IF (Reserve = Reserve::Always) AND ("Outstanding Qty. (Base)" <> 0) THEN BEGIN
//           CurrPage.SAVERECORD;
//           AutoReserve;
//         END;
//     end;

//     local procedure QuantityOnAfterValidate()
//     begin
//         IF Reserve = Reserve::Always THEN BEGIN
//           CurrPage.SAVERECORD;
//           AutoReserve;
//         END;
//     end;

//     local procedure UnitofMeasureCodeOnAfterValida()
//     begin
//         IF Reserve = Reserve::Always THEN BEGIN
//           CurrPage.SAVERECORD;
//           AutoReserve;
//         END;
//     end;
// }

