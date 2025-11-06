// page 46 "Sales Order Subform"
// {
//     AutoSplitKey = true;
//     Caption = 'Lines';
//     DelayedInsert = true;
//     LinksAllowed = false;
//     MultipleNewLines = true;
//     PageType = ListPart;
//     SourceTable = Table37;
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

//                     trigger OnValidate()
//                     begin
//                         VariantCodeOnAfterValidate;
//                     end;
//                 }
//                 field("Substitution Available";"Substitution Available")
//                 {
//                     Visible = false;
//                 }
//                 field("Purchasing Code";"Purchasing Code")
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
//                 field("Gen. Prod. Posting Group";"Gen. Prod. Posting Group")
//                 {
//                     Visible = false;
//                 }
//                 field(Description;Description)
//                 {
//                     QuickEntry = false;
//                 }
//                 field("Drop Shipment";"Drop Shipment")
//                 {
//                     Visible = false;
//                 }
//                 field("Special Order";"Special Order")
//                 {
//                     Visible = false;
//                 }
//                 field("Return Reason Code";"Return Reason Code")
//                 {
//                     Visible = false;
//                 }
//                 field("Location Code";"Location Code")
//                 {

//                     trigger OnValidate()
//                     begin
//                         LocationCodeOnAfterValidate;
//                     end;
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
//                 field("Qty. to Assemble to Order";"Qty. to Assemble to Order")
//                 {
//                     BlankZero = true;
//                     Visible = false;

//                     trigger OnDrillDown()
//                     begin
//                         ShowAsmToOrderLines;
//                     end;

//                     trigger OnValidate()
//                     begin
//                         QtyToAsmToOrderOnAfterValidate;
//                     end;
//                 }
//                 field("Unit of Measure Code";"Unit of Measure Code")
//                 {
//                     QuickEntry = false;

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
//                 field(SalesPriceExist;PriceExists)
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
//                 field(SalesLineDiscExists;LineDiscExists)
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
//                 field("Disc. Reason Code";"Disc. Reason Code")
//                 {
//                 }
//                 field("Cashier Code";"Cashier Code")
//                 {
//                 }
//                 field("Doctor Code";"Doctor Code")
//                 {
//                 }
//                 field("Inv. Discount Amount";"Inv. Discount Amount")
//                 {
//                     Visible = false;
//                 }
//                 field("Qty. to Ship";"Qty. to Ship")
//                 {
//                     BlankZero = true;

//                     trigger OnValidate()
//                     begin
//                         IF "Qty. to Asm. to Order (Base)" <> 0 THEN BEGIN
//                           CurrPage.SAVERECORD;
//                           CurrPage.UPDATE(FALSE);
//                         END;
//                     end;
//                 }
//                 field("Quantity Shipped";"Quantity Shipped")
//                 {
//                     BlankZero = true;
//                     QuickEntry = false;
//                 }
//                 field("Shipment No.";"Shipment No.")
//                 {
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
//                     QuickEntry = false;

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
//                     QuickEntry = false;

//                     trigger OnDrillDown()
//                     begin
//                         CurrPage.SAVERECORD;
//                         ShowItemChargeAssgnt;
//                         CurrPage.UPDATE(FALSE);
//                     end;
//                 }
//                 field("Requested Delivery Date";"Requested Delivery Date")
//                 {
//                     Visible = false;
//                 }
//                 field("Promised Delivery Date";"Promised Delivery Date")
//                 {
//                     Visible = false;
//                 }
//                 field("Planned Delivery Date";"Planned Delivery Date")
//                 {
//                     QuickEntry = false;
//                 }
//                 field("Planned Shipment Date";"Planned Shipment Date")
//                 {
//                 }
//                 field("Shipment Date";"Shipment Date")
//                 {
//                     QuickEntry = false;

//                     trigger OnValidate()
//                     begin
//                         ShipmentDateOnAfterValidate;
//                     end;
//                 }
//                 field("Shipping Agent Code";"Shipping Agent Code")
//                 {
//                     Visible = false;
//                 }
//                 field("Shipping Agent Service Code";"Shipping Agent Service Code")
//                 {
//                     Visible = false;
//                 }
//                 field("Shipping Time";"Shipping Time")
//                 {
//                     Visible = false;
//                 }
//                 field("Work Type Code";"Work Type Code")
//                 {
//                     Visible = false;
//                 }
//                 field("Whse. Outstanding Qty.";"Whse. Outstanding Qty.")
//                 {
//                     Visible = false;
//                 }
//                 field("Whse. Outstanding Qty. (Base)";"Whse. Outstanding Qty. (Base)")
//                 {
//                     Visible = false;
//                 }
//                 field("ATO Whse. Outstanding Qty.";"ATO Whse. Outstanding Qty.")
//                 {
//                     Visible = false;
//                 }
//                 field("ATO Whse. Outstd. Qty. (Base)";"ATO Whse. Outstd. Qty. (Base)")
//                 {
//                     Visible = false;
//                 }
//                 field("Outbound Whse. Handling Time";"Outbound Whse. Handling Time")
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
//                 field("FA Posting Date";"FA Posting Date")
//                 {
//                     Visible = false;
//                 }
//                 field("Depr. until FA Posting Date";"Depr. until FA Posting Date")
//                 {
//                     Visible = false;
//                 }
//                 field("Depreciation Book Code";"Depreciation Book Code")
//                 {
//                     Visible = false;
//                 }
//                 field("Use Duplication List";"Use Duplication List")
//                 {
//                     Visible = false;
//                 }
//                 field("Duplicate in Depreciation Book";"Duplicate in Depreciation Book")
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
//                     Style = StrongAccent;
//                     StyleExpr = TRUE;
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
//                 field("Document No.";"Document No.")
//                 {
//                     Editable = false;
//                     Visible = false;
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
//                     action("<Action3>")
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
//                 action("Reservation Entries")
//                 {
//                     Caption = 'Reservation Entries';
//                     Image = ReservationLedger;

//                     trigger OnAction()
//                     begin
//                         ShowReservationEntries(TRUE);
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
//                 action(OrderPromising)
//                 {
//                     Caption = 'Order &Promising';
//                     Image = OrderPromising;

//                     trigger OnAction()
//                     begin
//                         OrderPromisingLine;
//                     end;
//                 }
//                 group("Assemble to Order")
//                 {
//                     Caption = 'Assemble to Order';
//                     Image = AssemblyBOM;
//                     action(AssembleToOrderLines)
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
//                 action(GetPrice)
//                 {
//                     Caption = 'Get Price';
//                     Ellipsis = true;
//                     Image = Price;

//                     trigger OnAction()
//                     begin
//                         ShowPrices;
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
//                 action(ExplodeBOM_Functions)
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
//             group("O&rder")
//             {
//                 Caption = 'O&rder';
//                 Image = "Order";
//                 group("Dr&op Shipment")
//                 {
//                     Caption = 'Dr&op Shipment';
//                     Image = Delivery;
//                     action("Purchase &Order")
//                     {
//                         Caption = 'Purchase &Order';
//                         Image = Document;

//                         trigger OnAction()
//                         begin
//                             OpenPurchOrderForm;
//                         end;
//                     }
//                 }
//                 group("Speci&al Order")
//                 {
//                     Caption = 'Speci&al Order';
//                     Image = SpecialOrder;
//                     action(OpenSpecialPurchaseOrder)
//                     {
//                         Caption = 'Purchase &Order';
//                         Image = Document;

//                         trigger OnAction()
//                         begin
//                             OpenSpecialPurchOrderForm;
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
//         SalesPriceCalcMgt: Codeunit "7000";
//         TransferExtendedText: Codeunit "378";
//         ItemAvailFormsMgt: Codeunit "353";
//         ShortcutDimCode: array [8] of Code[20];
//         Text001: Label 'You cannot use the Explode BOM function because a prepayment of the sales order has been invoiced.';
//         [InDataSet]
//         ItemPanelVisible: Boolean;

//     procedure ApproveCalcInvDisc()
//     begin
//         CODEUNIT.RUN(CODEUNIT::"Sales-Disc. (Yes/No)",Rec);
//     end;

//     procedure AssignLotNo()
//     begin
//         Rec.AssignLotNo;
//     end;

//     procedure CalcInvDisc()
//     begin
//         CODEUNIT.RUN(CODEUNIT::"Sales-Calc. Discount",Rec);
//     end;

//     procedure ExplodeBOM()
//     begin
//         IF "Prepmt. Amt. Inv." <> 0 THEN
//           ERROR(Text001);
//         CODEUNIT.RUN(CODEUNIT::"Sales-Explode BOM",Rec);
//     end;

//     procedure OpenPurchOrderForm()
//     var
//         PurchHeader: Record "38";
//         PurchOrder: Page "50";
//     begin
//         TESTFIELD("Purchase Order No.");
//         PurchHeader.SETRANGE("No.","Purchase Order No.");
//         PurchOrder.SETTABLEVIEW(PurchHeader);
//         PurchOrder.EDITABLE := FALSE;
//         PurchOrder.RUN;
//     end;

//     procedure OpenSpecialPurchOrderForm()
//     var
//         PurchHeader: Record "38";
//         PurchRcptHeader: Record "120";
//         PurchOrder: Page "50";
//     begin
//         TESTFIELD("Special Order Purchase No.");
//         PurchHeader.SETRANGE("No.","Special Order Purchase No.");
//         IF NOT PurchHeader.ISEMPTY THEN BEGIN
//           PurchOrder.SETTABLEVIEW(PurchHeader);
//           PurchOrder.EDITABLE := FALSE;
//           PurchOrder.RUN;
//         END ELSE BEGIN
//           PurchRcptHeader.SETRANGE("Order No.","Special Order Purchase No.");
//           IF PurchRcptHeader.COUNT = 1 THEN
//             PAGE.RUN(PAGE::"Posted Purchase Receipt",PurchRcptHeader)
//           ELSE
//             PAGE.RUN(PAGE::"Posted Purchase Receipts",PurchRcptHeader);
//         END;
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

//     procedure ShowNonstockItems()
//     begin
//         ShowNonstock;
//     end;

//     procedure ShowTracking()
//     var
//         TrackingForm: Page "99000822";
//     begin
//         TrackingForm.SetSalesLine(Rec);
//         TrackingForm.RUNMODAL;
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

//     procedure OrderPromisingLine()
//     var
//         OrderPromisingLine: Record "99000880" temporary;
//         OrderPromisingLines: Page "99000959";
//     begin
//         OrderPromisingLine.SETRANGE("Source Type","Document Type");
//         OrderPromisingLine.SETRANGE("Source ID","Document No.");
//         OrderPromisingLine.SETRANGE("Source Line No.","Line No.");

//         OrderPromisingLines.SetSourceType(OrderPromisingLine."Source Type"::Sales);
//         OrderPromisingLines.SETTABLEVIEW(OrderPromisingLine);
//         OrderPromisingLines.RUNMODAL;
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

//         IF (Reserve = Reserve::Always) AND
//            ("Outstanding Qty. (Base)" <> 0) AND
//            ("No." <> xRec."No.")
//         THEN BEGIN
//           CurrPage.SAVERECORD;
//           AutoReserve;
//           CurrPage.UPDATE(FALSE);
//         END;
//     end;

//     local procedure CrossReferenceNoOnAfterValidat()
//     begin
//         InsertExtendedText(FALSE);
//     end;

//     local procedure VariantCodeOnAfterValidate()
//     begin
//         SaveAndAutoAsmToOrder;
//     end;

//     local procedure LocationCodeOnAfterValidate()
//     begin
//         SaveAndAutoAsmToOrder;

//         IF (Reserve = Reserve::Always) AND
//            ("Outstanding Qty. (Base)" <> 0) AND
//            ("Location Code" <> xRec."Location Code")
//         THEN BEGIN
//           CurrPage.SAVERECORD;
//           AutoReserve;
//           CurrPage.UPDATE(FALSE);
//         END;
//     end;

//     local procedure ReserveOnAfterValidate()
//     begin
//         IF (Reserve = Reserve::Always) AND ("Outstanding Qty. (Base)" <> 0) THEN BEGIN
//           CurrPage.SAVERECORD;
//           AutoReserve;
//           CurrPage.UPDATE(FALSE);
//         END;
//     end;

//     local procedure QuantityOnAfterValidate()
//     var
//         UpdateIsDone: Boolean;
//     begin
//         IF Type = Type::Item THEN
//           CASE Reserve OF
//             Reserve::Always:
//               BEGIN
//                 CurrPage.SAVERECORD;
//                 AutoReserve;
//                 CurrPage.UPDATE(FALSE);
//                 UpdateIsDone := TRUE;
//               END;
//             Reserve::Optional:
//               IF (Quantity < xRec.Quantity) AND (xRec.Quantity > 0) THEN BEGIN
//                 CurrPage.SAVERECORD;
//                 CurrPage.UPDATE(FALSE);
//                 UpdateIsDone := TRUE;
//               END;
//           END;

//         IF (Type = Type::Item) AND
//            (Quantity <> xRec.Quantity) AND
//            NOT UpdateIsDone
//         THEN
//           CurrPage.UPDATE(TRUE);
//     end;

//     local procedure QtyToAsmToOrderOnAfterValidate()
//     begin
//         CurrPage.SAVERECORD;
//         IF Reserve = Reserve::Always THEN
//           AutoReserve;
//         CurrPage.UPDATE(TRUE);
//     end;

//     local procedure UnitofMeasureCodeOnAfterValida()
//     begin
//         IF Reserve = Reserve::Always THEN BEGIN
//           CurrPage.SAVERECORD;
//           AutoReserve;
//           CurrPage.UPDATE(FALSE);
//         END;
//     end;

//     local procedure ShipmentDateOnAfterValidate()
//     begin
//         IF (Reserve = Reserve::Always) AND
//            ("Outstanding Qty. (Base)" <> 0) AND
//            ("Shipment Date" <> xRec."Shipment Date")
//         THEN BEGIN
//           CurrPage.SAVERECORD;
//           AutoReserve;
//           CurrPage.UPDATE(FALSE);
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

