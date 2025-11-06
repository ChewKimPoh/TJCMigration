// page 5741 "Transfer Order Subform"
// {
//     // //TJC#391 Add unitprice into subform 02/03/17
//     // //TJC#434 DP.NCM calculate unit price for other UOM

//     AutoSplitKey = true;
//     Caption = 'Lines';
//     DelayedInsert = true;
//     LinksAllowed = false;
//     MultipleNewLines = true;
//     PageType = ListPart;
//     SourceTable = Table5741;

//     layout
//     {
//         area(content)
//         {
//             repeater()
//             {
//                 field("Line No.";"Line No.")
//                 {
//                 }
//                 field("Item No.";"Item No.")
//                 {

//                     trigger OnValidate()
//                     begin
//                         CalcUnitPrice;
//                     end;
//                 }
//                 field("Variant Code";"Variant Code")
//                 {
//                     Visible = false;
//                 }
//                 field("Planning Flexibility";"Planning Flexibility")
//                 {
//                     Visible = false;
//                 }
//                 field(Description;Description)
//                 {
//                 }
//                 field("Transfer-from Bin Code";"Transfer-from Bin Code")
//                 {
//                     Visible = true;
//                 }
//                 field("Transfer-To Bin Code";"Transfer-To Bin Code")
//                 {
//                     Visible = true;
//                 }
//                 field(Quantity;Quantity)
//                 {
//                     BlankZero = true;
//                 }
//                 field("Reserved Quantity Inbnd.";"Reserved Quantity Inbnd.")
//                 {
//                     BlankZero = true;
//                 }
//                 field("Reserved Quantity Shipped";"Reserved Quantity Shipped")
//                 {
//                     BlankZero = true;
//                 }
//                 field("Reserved Quantity Outbnd.";"Reserved Quantity Outbnd.")
//                 {
//                     BlankZero = true;
//                 }
//                 field("Unit of Measure Code";"Unit of Measure Code")
//                 {

//                     trigger OnValidate()
//                     begin
//                         CalcUnitPrice;
//                     end;
//                 }
//                 field("Unit of Measure";"Unit of Measure")
//                 {
//                     Visible = false;
//                 }
//                 field("Unit Price";varUnitPrice)
//                 {
//                 }
//                 field("Qty. to Ship";"Qty. to Ship")
//                 {
//                     BlankZero = true;
//                 }
//                 field("Quantity Shipped";"Quantity Shipped")
//                 {
//                     BlankZero = true;

//                     trigger OnDrillDown()
//                     var
//                         TransShptLine: Record "5745";
//                     begin
//                         TESTFIELD("Document No.");
//                         TESTFIELD("Item No.");
//                         TransShptLine.SETCURRENTKEY("Transfer Order No.","Item No.","Shipment Date");
//                         TransShptLine.SETRANGE("Transfer Order No.","Document No.");
//                         TransShptLine.SETRANGE("Item No.","Item No.");
//                         PAGE.RUNMODAL(0,TransShptLine);
//                     end;
//                 }
//                 field("Qty. to Receive";"Qty. to Receive")
//                 {
//                     BlankZero = true;
//                 }
//                 field("Quantity Received";"Quantity Received")
//                 {
//                     BlankZero = true;

//                     trigger OnDrillDown()
//                     var
//                         TransRcptLine: Record "5747";
//                     begin
//                         TESTFIELD("Document No.");
//                         TESTFIELD("Item No.");
//                         TransRcptLine.SETCURRENTKEY("Transfer Order No.","Item No.","Receipt Date");
//                         TransRcptLine.SETRANGE("Transfer Order No.","Document No.");
//                         TransRcptLine.SETRANGE("Item No.","Item No.");
//                         PAGE.RUNMODAL(0,TransRcptLine);
//                     end;
//                 }
//                 field("Shipment Date";"Shipment Date")
//                 {
//                 }
//                 field("Receipt Date";"Receipt Date")
//                 {
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
//                 field("Outbound Whse. Handling Time";"Outbound Whse. Handling Time")
//                 {
//                     Visible = false;
//                 }
//                 field("Inbound Whse. Handling Time";"Inbound Whse. Handling Time")
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
//             group("F&unctions")
//             {
//                 Caption = 'F&unctions';
//                 Image = "Action";
//                 action(Reserve)
//                 {
//                     Caption = '&Reserve';
//                     Image = Reserve;

//                     trigger OnAction()
//                     begin
//                         FIND;
//                         ShowReservation;
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
//                             ItemAvailFormsMgt.ShowItemAvailFromTransLine(Rec,ItemAvailFormsMgt.ByEvent);
//                         end;
//                     }
//                     action(Period)
//                     {
//                         Caption = 'Period';
//                         Image = Period;

//                         trigger OnAction()
//                         begin
//                             ItemAvailFormsMgt.ShowItemAvailFromTransLine(Rec,ItemAvailFormsMgt.ByPeriod);
//                         end;
//                     }
//                     action(Variant)
//                     {
//                         Caption = 'Variant';
//                         Image = ItemVariant;

//                         trigger OnAction()
//                         begin
//                             ItemAvailFormsMgt.ShowItemAvailFromTransLine(Rec,ItemAvailFormsMgt.ByVariant);
//                         end;
//                     }
//                     action(Location)
//                     {
//                         Caption = 'Location';
//                         Image = Warehouse;

//                         trigger OnAction()
//                         begin
//                             ItemAvailFormsMgt.ShowItemAvailFromTransLine(Rec,ItemAvailFormsMgt.ByLocation);
//                         end;
//                     }
//                     action("BOM Level")
//                     {
//                         Caption = 'BOM Level';
//                         Image = BOMLevel;

//                         trigger OnAction()
//                         begin
//                             ItemAvailFormsMgt.ShowItemAvailFromTransLine(Rec,ItemAvailFormsMgt.ByBOM);
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
//                 group("Item &Tracking Lines")
//                 {
//                     Caption = 'Item &Tracking Lines';
//                     Image = AllLines;
//                     action(Shipment)
//                     {
//                         Caption = 'Shipment';
//                         Image = Shipment;

//                         trigger OnAction()
//                         begin
//                             OpenItemTrackingLines(0);
//                         end;
//                     }
//                     action(Receipt)
//                     {
//                         Caption = 'Receipt';
//                         Image = Receipt;

//                         trigger OnAction()
//                         begin
//                             OpenItemTrackingLines(1);
//                         end;
//                     }
//                 }
//             }
//         }
//     }

//     trigger OnAfterGetRecord()
//     begin
//         ShowShortcutDimCode(ShortcutDimCode);
//         CalcUnitPrice;
//     end;

//     trigger OnDeleteRecord(): Boolean
//     var
//         ReserveTransferLine: Codeunit "99000836";
//     begin
//         COMMIT;
//         IF NOT ReserveTransferLine.DeleteLineConfirm(Rec) THEN
//           EXIT(FALSE);
//         ReserveTransferLine.DeleteLine(Rec);
//     end;

//     trigger OnNewRecord(BelowxRec: Boolean)
//     begin
//         CLEAR(ShortcutDimCode);
//         CLEAR(varUnitPrice);
//     end;

//     var
//         ItemAvailFormsMgt: Codeunit "353";
//         ShortcutDimCode: array [8] of Code[20];
//         recItem: Record "27";
//         varUnitPrice: Decimal;
//         recItemUOM: Record "5404";

//     procedure UpdateForm(SetSaveRecord: Boolean)
//     begin
//         CurrPage.UPDATE(SetSaveRecord);
//     end;

//     procedure CalcUnitPrice()
//     begin
//         //TJC#391
//         CLEAR(varUnitPrice);
//         recItem.RESET;
//         recItem.SETRANGE("No.","Item No.");
//         IF recItem.FINDFIRST THEN
//           varUnitPrice := recItem."Unit Price";
//         //TJC#391

//         //TJC#434
//         recItemUOM.RESET;
//         recItemUOM.SETRANGE("Item No.","Item No.");
//         recItemUOM.SETRANGE(Code,"Unit of Measure Code");
//         IF recItemUOM.FINDFIRST THEN
//           varUnitPrice := varUnitPrice * recItemUOM."Qty. per Unit of Measure";
//         //TJC#434
//     end;
// }

