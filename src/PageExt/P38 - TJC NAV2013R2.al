// page 38 "Item Ledger Entries"
// {
//     Caption = 'Item Ledger Entries';
//     DataCaptionExpression = GetCaption;
//     DataCaptionFields = "Item No.";
//     Editable = false;
//     PageType = List;
//     SourceTable = Table32;

//     layout
//     {
//         area(content)
//         {
//             repeater()
//             {
//                 field("Posting Date";"Posting Date")
//                 {
//                 }
//                 field("Entry Type";"Entry Type")
//                 {
//                 }
//                 field("Global Dimension 1 Code";"Global Dimension 1 Code")
//                 {
//                 }
//                 field("Source No.";"Source No.")
//                 {
//                 }
//                 field("External Document No.";"External Document No.")
//                 {
//                 }
//                 field("Lot No.";"Lot No.")
//                 {
//                 }
//                 field("Document Type";"Document Type")
//                 {
//                 }
//                 field("Document No.";"Document No.")
//                 {
//                 }
//                 field("Document Line No.";"Document Line No.")
//                 {
//                     Visible = false;
//                 }
//                 field("Item No.";"Item No.")
//                 {
//                 }
//                 field("Location Code";"Location Code")
//                 {
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
//                 field("Global Dimension 2 Code";"Global Dimension 2 Code")
//                 {
//                     Visible = false;
//                 }
//                 field("Expiration Date";"Expiration Date")
//                 {
//                     Visible = false;
//                 }
//                 field("Serial No.";"Serial No.")
//                 {
//                     Visible = false;
//                 }
//                 field(Quantity;Quantity)
//                 {
//                 }
//                 field("Invoiced Quantity";"Invoiced Quantity")
//                 {
//                     Visible = true;
//                 }
//                 field("Remaining Quantity";"Remaining Quantity")
//                 {
//                     Visible = true;
//                 }
//                 field("Shipped Qty. Not Returned";"Shipped Qty. Not Returned")
//                 {
//                     Visible = false;
//                 }
//                 field("Reserved Quantity";"Reserved Quantity")
//                 {
//                     Visible = false;
//                 }
//                 field("Qty. per Unit of Measure";"Qty. per Unit of Measure")
//                 {
//                     Visible = false;
//                 }
//                 field("Sales Amount (Expected)";"Sales Amount (Expected)")
//                 {
//                     Visible = false;
//                 }
//                 field("Sales Amount (Actual)";"Sales Amount (Actual)")
//                 {
//                 }
//                 field("Cost Amount (Expected)";"Cost Amount (Expected)")
//                 {
//                     Visible = false;
//                 }
//                 field("Cost Amount (Actual)";"Cost Amount (Actual)")
//                 {
//                 }
//                 field("Cost Amount (Non-Invtbl.)";"Cost Amount (Non-Invtbl.)")
//                 {
//                 }
//                 field("Cost Amount (Expected) (ACY)";"Cost Amount (Expected) (ACY)")
//                 {
//                     Visible = false;
//                 }
//                 field("Cost Amount (Actual) (ACY)";"Cost Amount (Actual) (ACY)")
//                 {
//                     Visible = false;
//                 }
//                 field("Cost Amount (Non-Invtbl.)(ACY)";"Cost Amount (Non-Invtbl.)(ACY)")
//                 {
//                     Visible = false;
//                 }
//                 field("Completely Invoiced";"Completely Invoiced")
//                 {
//                     Visible = false;
//                 }
//                 field(Open;Open)
//                 {
//                 }
//                 field("Drop Shipment";"Drop Shipment")
//                 {
//                     Visible = false;
//                 }
//                 field("Assemble to Order";"Assemble to Order")
//                 {
//                     Visible = false;
//                 }
//                 field("Applied Entry to Adjust";"Applied Entry to Adjust")
//                 {
//                     Visible = false;
//                 }
//                 field("Order Type";"Order Type")
//                 {
//                 }
//                 field("Order No.";"Order No.")
//                 {
//                     Visible = false;
//                 }
//                 field("Order Line No.";"Order Line No.")
//                 {
//                     Visible = false;
//                 }
//                 field("Prod. Order Comp. Line No.";"Prod. Order Comp. Line No.")
//                 {
//                     Visible = false;
//                 }
//                 field("Entry No.";"Entry No.")
//                 {
//                 }
//                 field("Job No.";"Job No.")
//                 {
//                     Visible = false;
//                 }
//                 field("Job Task No.";"Job Task No.")
//                 {
//                     Visible = false;
//                 }
//             }
//         }
//         area(factboxes)
//         {
//             systempart(;Links)
//             {
//                 Visible = false;
//             }
//             systempart(;Notes)
//             {
//                 Visible = false;
//             }
//         }
//     }

//     actions
//     {
//         area(navigation)
//         {
//             group("Ent&ry")
//             {
//                 Caption = 'Ent&ry';
//                 Image = Entry;
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
//                 action("&Value Entries")
//                 {
//                     Caption = '&Value Entries';
//                     Image = ValueLedger;
//                     RunObject = Page 5802;
//                     RunPageLink = Item Ledger Entry No.=FIELD(Entry No.);
//                     RunPageView = SORTING(Item Ledger Entry No.);
//                     ShortCutKey = 'Ctrl+F7';
//                 }
//             }
//             group("&Application")
//             {
//                 Caption = '&Application';
//                 Image = Apply;
//                 action("Applied E&ntries")
//                 {
//                     Caption = 'Applied E&ntries';
//                     Image = Approve;

//                     trigger OnAction()
//                     begin
//                         CODEUNIT.RUN(CODEUNIT::"Show Applied Entries",Rec);
//                     end;
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
//                 action("Application Worksheet")
//                 {
//                     Caption = 'Application Worksheet';
//                     Image = ApplicationWorksheet;

//                     trigger OnAction()
//                     var
//                         Worksheet: Page "521";
//                     begin
//                         CLEAR(Worksheet);
//                         Worksheet.SetRecordToShow(Rec);
//                         Worksheet.RUN;
//                     end;
//                 }
//             }
//         }
//         area(processing)
//         {
//             group("F&unctions")
//             {
//                 Caption = 'F&unctions';
//                 Image = "Action";
//                 action("Order &Tracking")
//                 {
//                     Caption = 'Order &Tracking';
//                     Image = OrderTracking;

//                     trigger OnAction()
//                     var
//                         TrackingForm: Page "99000822";
//                     begin
//                         TrackingForm.SetItemLedgEntry(Rec);
//                         TrackingForm.RUNMODAL;
//                     end;
//                 }
//             }
//             action("&Navigate")
//             {
//                 Caption = '&Navigate';
//                 Image = Navigate;
//                 Promoted = true;
//                 PromotedCategory = Process;

//                 trigger OnAction()
//                 begin
//                     Navigate.SetDoc("Posting Date","Document No.");
//                     Navigate.RUN;
//                 end;
//             }
//         }
//     }

//     var
//         Navigate: Page "344";

//     procedure GetCaption(): Text[250]
//     var
//         GLSetup: Record "98";
//         ObjTransl: Record "377";
//         Item: Record "27";
//         ProdOrder: Record "5405";
//         Cust: Record "18";
//         Vend: Record "23";
//         Dimension: Record "348";
//         DimValue: Record "349";
//         SourceTableName: Text[100];
//         SourceFilter: Text[200];
//         Description: Text[100];
//     begin
//         Description := '';

//         CASE TRUE OF
//           GETFILTER("Item No.") <> '':
//             BEGIN
//               SourceTableName := ObjTransl.TranslateObject(ObjTransl."Object Type"::Table,27);
//               SourceFilter := GETFILTER("Item No.");
//               IF MAXSTRLEN(Item."No.") >= STRLEN(SourceFilter) THEN
//                 IF Item.GET(SourceFilter) THEN
//                   Description := Item.Description;
//             END;
//           (GETFILTER("Order No.") <> '') AND ("Order Type" = "Order Type"::Production):
//             BEGIN
//               SourceTableName := ObjTransl.TranslateObject(ObjTransl."Object Type"::Table,5405);
//               SourceFilter := GETFILTER("Order No.");
//               IF MAXSTRLEN(ProdOrder."No.") >= STRLEN(SourceFilter) THEN
//                 IF ProdOrder.GET(ProdOrder.Status::Released,SourceFilter) OR
//                    ProdOrder.GET(ProdOrder.Status::Finished,SourceFilter)
//                 THEN BEGIN
//                   SourceTableName := STRSUBSTNO('%1 %2',ProdOrder.Status,SourceTableName);
//                   Description := ProdOrder.Description;
//                 END;
//             END;
//           GETFILTER("Source No.") <> '':
//             CASE "Source Type" OF
//               "Source Type"::Customer:
//                 BEGIN
//                   SourceTableName :=
//                     ObjTransl.TranslateObject(ObjTransl."Object Type"::Table,18);
//                   SourceFilter := GETFILTER("Source No.");
//                   IF MAXSTRLEN(Cust."No.") >= STRLEN(SourceFilter) THEN
//                     IF Cust.GET(SourceFilter) THEN
//                       Description := Cust.Name;
//                 END;
//               "Source Type"::Vendor:
//                 BEGIN
//                   SourceTableName :=
//                     ObjTransl.TranslateObject(ObjTransl."Object Type"::Table,23);
//                   SourceFilter := GETFILTER("Source No.");
//                   IF MAXSTRLEN(Vend."No.") >= STRLEN(SourceFilter) THEN
//                     IF Vend.GET(SourceFilter) THEN
//                       Description := Vend.Name;
//                 END;
//             END;
//           GETFILTER("Global Dimension 1 Code") <> '':
//             BEGIN
//               GLSetup.GET;
//               Dimension.Code := GLSetup."Global Dimension 1 Code";
//               SourceFilter := GETFILTER("Global Dimension 1 Code");
//               SourceTableName := Dimension.GetMLName(GLOBALLANGUAGE);
//               IF MAXSTRLEN(DimValue.Code) >= STRLEN(SourceFilter) THEN
//                 IF DimValue.GET(GLSetup."Global Dimension 1 Code",SourceFilter) THEN
//                   Description := DimValue.Name;
//             END;
//           GETFILTER("Global Dimension 2 Code") <> '':
//             BEGIN
//               GLSetup.GET;
//               Dimension.Code := GLSetup."Global Dimension 2 Code";
//               SourceFilter := GETFILTER("Global Dimension 2 Code");
//               SourceTableName := Dimension.GetMLName(GLOBALLANGUAGE);
//               IF MAXSTRLEN(DimValue.Code) >= STRLEN(SourceFilter) THEN
//                 IF DimValue.GET(GLSetup."Global Dimension 2 Code",SourceFilter) THEN
//                   Description := DimValue.Name;
//             END;
//           GETFILTER("Document Type") <> '':
//             BEGIN
//               SourceTableName := GETFILTER("Document Type");
//               SourceFilter := GETFILTER("Document No.");
//               Description := GETFILTER("Document Line No.");
//             END;
//         END;
//         EXIT(STRSUBSTNO('%1 %2 %3',SourceTableName,SourceFilter,Description));
//     end;
// }

