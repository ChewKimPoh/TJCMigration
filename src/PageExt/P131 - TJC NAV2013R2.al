// page 131 "Posted Sales Shpt. Subform"
// {
//     AutoSplitKey = true;
//     Caption = 'Lines';
//     Editable = false;
//     LinksAllowed = false;
//     PageType = ListPart;
//     SourceTable = Table111;

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
//                 }
//                 field("No.";"No.")
//                 {
//                 }
//                 field("Cross-Reference No.";"Cross-Reference No.")
//                 {
//                     Visible = false;
//                 }
//                 field("Variant Code";"Variant Code")
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
//                 }
//                 field("Bin Code";"Bin Code")
//                 {
//                     Visible = false;
//                 }
//                 field(Quantity;Quantity)
//                 {
//                     BlankZero = true;
//                 }
//                 field("Order No.";"Order No.")
//                 {
//                 }
//                 field("Unit of Measure Code";"Unit of Measure Code")
//                 {
//                 }
//                 field("Unit of Measure";"Unit of Measure")
//                 {
//                     Visible = false;
//                 }
//                 field("Quantity Invoiced";"Quantity Invoiced")
//                 {
//                     BlankZero = true;
//                 }
//                 field("Qty. Shipped Not Invoiced";"Qty. Shipped Not Invoiced")
//                 {
//                     Editable = false;
//                     Visible = false;
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
//                 }
//                 field("Planned Shipment Date";"Planned Shipment Date")
//                 {
//                 }
//                 field("Shipment Date";"Shipment Date")
//                 {
//                     Visible = true;
//                 }
//                 field("Shipping Time";"Shipping Time")
//                 {
//                     Visible = false;
//                 }
//                 field("Job No.";"Job No.")
//                 {
//                     Visible = false;
//                 }
//                 field("Outbound Whse. Handling Time";"Outbound Whse. Handling Time")
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
//                 field(Correction;Correction)
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
//             group("F&unctions")
//             {
//                 Caption = 'F&unctions';
//                 Image = "Action";
//                 action("Order Tra&cking")
//                 {
//                     Caption = 'Order Tra&cking';
//                     Image = OrderTracking;

//                     trigger OnAction()
//                     begin
//                         ShowTracking;
//                     end;
//                 }
//                 action(UndoShipment)
//                 {
//                     Caption = '&Undo Shipment';
//                     Image = UndoShipment;

//                     trigger OnAction()
//                     begin
//                         UndoShipmentPosting;
//                     end;
//                 }
//             }
//             group("&Line")
//             {
//                 Caption = '&Line';
//                 Image = Line;
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
//                 action(ItemTrackingEntries)
//                 {
//                     Caption = 'Item &Tracking Entries';
//                     Image = ItemTrackingLedger;

//                     trigger OnAction()
//                     begin
//                         ShowItemTrackingLines;
//                     end;
//                 }
//                 action("Assemble-to-Order")
//                 {
//                     Caption = 'Assemble-to-Order';

//                     trigger OnAction()
//                     begin
//                         ShowAsmToOrder;
//                     end;
//                 }
//                 action("Item Invoice &Lines")
//                 {
//                     Caption = 'Item Invoice &Lines';
//                     Image = ItemInvoice;

//                     trigger OnAction()
//                     begin
//                         ShowItemSalesInvLines;
//                     end;
//                 }
//             }
//         }
//     }

//     local procedure ShowTracking()
//     var
//         ItemLedgEntry: Record "32";
//         TempItemLedgEntry: Record "32" temporary;
//         TrackingForm: Page "99000822";
//     begin
//         TESTFIELD(Type,Type::Item);
//         IF "Item Shpt. Entry No." <> 0 THEN BEGIN
//           ItemLedgEntry.GET("Item Shpt. Entry No.");
//           TrackingForm.SetItemLedgEntry(ItemLedgEntry);
//         END ELSE
//           TrackingForm.SetMultipleItemLedgEntries(TempItemLedgEntry,
//             DATABASE::"Sales Shipment Line",0,"Document No.",'',0,"Line No.");

//         TrackingForm.RUNMODAL;
//     end;

//     local procedure UndoShipmentPosting()
//     var
//         SalesShptLine: Record "111";
//     begin
//         SalesShptLine.COPY(Rec);
//         CurrPage.SETSELECTIONFILTER(SalesShptLine);
//         CODEUNIT.RUN(CODEUNIT::"Undo Sales Shipment Line",SalesShptLine);
//     end;

//     local procedure ShowItemSalesInvLines()
//     begin
//         TESTFIELD(Type,Type::Item);
//         ShowItemSalesInvLines;
//     end;
// }

