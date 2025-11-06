// page 95 "Sales Quote Subform"
// {
//     AutoSplitKey = true;
//     Caption = 'Lines';
//     DelayedInsert = true;
//     LinksAllowed = false;
//     MultipleNewLines = true;
//     PageType = ListPart;
//     SourceTable = Table37;
//     SourceTableView = WHERE(Document Type=FILTER(Quote));

//     layout
//     {
//         area(content)
//         {
//             repeater()
//             {
//                 field(Type;Type)
//                 {

//                     trigger OnValidate()
//                     begin
//                         TypeOnAfterValidate;
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
//                 field("Variant Code";"Variant Code")
//                 {
//                     Visible = false;

//                     trigger OnValidate()
//                     begin
//                         VariantCodeOnAfterValidate
//                     end;
//                 }
//                 field("Substitution Available";"Substitution Available")
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
//                 field("Location Code";"Location Code")
//                 {

//                     trigger OnValidate()
//                     begin
//                         LocationCodeOnAfterValidate;
//                     end;
//                 }
//                 field("Return Reason Code";"Return Reason Code")
//                 {
//                 }
//                 field(Quantity;Quantity)
//                 {
//                     BlankZero = true;

//                     trigger OnValidate()
//                     begin
//                         QuantityOnAfterValidate;
//                     end;
//                 }
//                 field("Qty. to Assemble to Order";"Qty. to Assemble to Order")
//                 {
//                     Visible = false;

//                     trigger OnDrillDown()
//                     begin
//                         ShowAsmToOrderLines;
//                     end;

//                     trigger OnValidate()
//                     begin
//                         CurrPage.SAVERECORD;
//                         CurrPage.UPDATE(TRUE);
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
//                 field(PriceExists;PriceExists)
//                 {
//                     Caption = 'Sales Price Exists';
//                     Editable = false;
//                     Visible = false;
//                 }
//                 field("Unit Price";"Unit Price")
//                 {
//                     BlankZero = true;
//                 }
//                 field("Line Amount";"Line Amount")
//                 {
//                     BlankZero = true;
//                 }
//                 field(LineDiscExists;LineDiscExists)
//                 {
//                     Caption = 'Sales Line Disc. Exists';
//                     Editable = false;
//                     Visible = false;
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
//                 action("Select Item Substitution")
//                 {
//                     Caption = 'Select Item Substitution';
//                     Image = SelectItemSubstitution;

//                     trigger OnAction()
//                     begin
//                         ShowItemSub;
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
//                 action("Item Charge &Assignment")
//                 {
//                     Caption = 'Item Charge &Assignment';

//                     trigger OnAction()
//                     begin
//                         ItemChargeAssgnt;
//                     end;
//                 }
//                 action("Item &Tracking Lines")
//                 {
//                     Caption = 'Item &Tracking Lines';
//                     Image = ItemTrackingLines;
//                     ShortCutKey = 'Shift+Ctrl+I';

//                     trigger OnAction()
//                     var
//                         Item: Record "27";
//                     begin
//                         Item.GET("No.");
//                         Item.TESTFIELD("Assembly Policy",Item."Assembly Policy"::"Assemble-to-Stock");
//                         TESTFIELD("Qty. to Asm. to Order (Base)",0);
//                         OpenItemTrackingLines;
//                     end;
//                 }
//                 group("Assemble to Order")
//                 {
//                     Caption = 'Assemble to Order';
//                     Image = AssemblyBOM;
//                     action("Assemble-to-Order Lines")
//                     {
//                         Caption = 'Assemble-to-Order Lines';

//                         trigger OnAction()
//                         begin
//                             ShowAsmToOrderLines;
//                         end;
//                     }
//                     action("Roll Up &Price")
//                     {
//                         Caption = 'Roll Up &Price';
//                         Ellipsis = true;

//                         trigger OnAction()
//                         begin
//                             RollupAsmPrice;
//                         end;
//                     }
//                     action("Roll Up &Cost")
//                     {
//                         Caption = 'Roll Up &Cost';
//                         Ellipsis = true;

//                         trigger OnAction()
//                         begin
//                             RollUpAsmCost;
//                         end;
//                     }
//                 }
//             }
//             group("F&unctions")
//             {
//                 Caption = 'F&unctions';
//                 Image = "Action";
//                 action("Get &Price")
//                 {
//                     Caption = 'Get &Price';
//                     Ellipsis = true;
//                     Image = Price;

//                     trigger OnAction()
//                     begin
//                         ShowPrices
//                     end;
//                 }
//                 action("Get Li&ne Discount")
//                 {
//                     Caption = 'Get Li&ne Discount';
//                     Ellipsis = true;
//                     Image = LineDiscount;

//                     trigger OnAction()
//                     begin
//                         ShowLineDisc
//                     end;
//                 }
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
//                 action("Nonstoc&k Items")
//                 {
//                     Caption = 'Nonstoc&k Items';
//                     Image = NonStockItem;

//                     trigger OnAction()
//                     begin
//                         ShowNonstockItems;
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
//         SalesHeader: Record "36";
//         TransferExtendedText: Codeunit "378";
//         SalesPriceCalcMgt: Codeunit "7000";
//         ItemAvailFormsMgt: Codeunit "353";
//         ShortcutDimCode: array [8] of Code[20];
//         [InDataSet]
//         ItemPanelVisible: Boolean;

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

//     procedure ShowItemSub()
//     begin
//         ShowItemSub;
//     end;

//     procedure ShowNonstockItems()
//     begin
//         ShowNonstock;
//     end;

//     procedure ItemChargeAssgnt()
//     begin
//         ShowItemChargeAssgnt;
//     end;

//     procedure UpdateForm(SetSaveRecord: Boolean)
//     begin
//         CurrPage.UPDATE(SetSaveRecord);
//     end;

//     procedure ShowPrices()
//     begin
//         SalesHeader.GET("Document Type","Document No.");
//         CLEAR(SalesPriceCalcMgt);
//         SalesPriceCalcMgt.GetSalesLinePrice(SalesHeader,Rec);
//     end;

//     procedure ShowLineDisc()
//     begin
//         SalesHeader.GET("Document Type","Document No.");
//         CLEAR(SalesPriceCalcMgt);
//         SalesPriceCalcMgt.GetSalesLineLineDisc(SalesHeader,Rec);
//     end;

//     procedure ShowLineComments()
//     begin
//         ShowLineComments;
//     end;

//     local procedure TypeOnAfterValidate()
//     begin
//         ItemPanelVisible := Type = Type::Item;
//     end;

//     local procedure NoOnAfterValidate()
//     begin
//         InsertExtendedText(FALSE);
//         IF (Type = Type::"Charge (Item)") AND ("No." <> xRec."No.") AND
//            (xRec."No." <> '')
//         THEN
//           CurrPage.SAVERECORD;

//         SaveAndAutoAsmToOrder;
//     end;

//     local procedure LocationCodeOnAfterValidate()
//     begin
//         SaveAndAutoAsmToOrder;
//     end;

//     local procedure VariantCodeOnAfterValidate()
//     begin
//         SaveAndAutoAsmToOrder;
//     end;

//     local procedure CrossReferenceNoOnAfterValidat()
//     begin
//         InsertExtendedText(FALSE);
//     end;

//     local procedure QuantityOnAfterValidate()
//     begin
//         IF Reserve = Reserve::Always THEN BEGIN
//           CurrPage.SAVERECORD;
//           AutoReserve;
//         END;

//         IF (Type = Type::Item) AND
//            (Quantity <> xRec.Quantity)
//         THEN
//           CurrPage.UPDATE(TRUE);
//     end;

//     local procedure UnitofMeasureCodeOnAfterValida()
//     begin
//         IF Reserve = Reserve::Always THEN BEGIN
//           CurrPage.SAVERECORD;
//           AutoReserve;
//         END;
//     end;

//     local procedure SaveAndAutoAsmToOrder()
//     begin
//         IF (Type = Type::Item) AND IsAsmToOrderRequired THEN BEGIN
//           CurrPage.SAVERECORD;
//           AutoAsmToOrder;
//           CurrPage.UPDATE(FALSE);
//         END;
//     end;
// }

