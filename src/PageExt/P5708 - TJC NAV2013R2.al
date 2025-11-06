// page 5708 "Get Shipment Lines"
// {
//     Caption = 'Get Shipment Lines';
//     Editable = false;
//     PageType = List;
//     SourceTable = Table111;
//     SourceTableTemporary = true;

//     layout
//     {
//         area(content)
//         {
//             repeater()
//             {
//                 field("Shipment Date";"Shipment Date")
//                 {
//                 }
//                 field("Document No.";"Document No.")
//                 {
//                     HideValue = "Document No.HideValue";
//                     StyleExpr = 'Strong';
//                 }
//                 field("Order No.";"Order No.")
//                 {
//                 }
//                 field("Bill-to Customer No.";"Bill-to Customer No.")
//                 {
//                     Visible = true;
//                 }
//                 field("Sell-to Customer No.";"Sell-to Customer No.")
//                 {
//                     Visible = false;
//                 }
//                 field(Type;Type)
//                 {
//                 }
//                 field("No.";"No.")
//                 {
//                 }
//                 field("Variant Code";"Variant Code")
//                 {
//                     Visible = false;
//                 }
//                 field(Description;Description)
//                 {
//                 }
//                 field("Currency Code";"Currency Code")
//                 {
//                     DrillDown = false;
//                     Lookup = false;
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
//                 field("Location Code";"Location Code")
//                 {
//                     Visible = false;
//                 }
//                 field("Unit of Measure Code";"Unit of Measure Code")
//                 {
//                 }
//                 field(Quantity;Quantity)
//                 {
//                 }
//                 field("Unit of Measure";"Unit of Measure")
//                 {
//                     Visible = false;
//                 }
//                 field("Appl.-to Item Entry";"Appl.-to Item Entry")
//                 {
//                     Visible = false;
//                 }
//                 field("Job No.";"Job No.")
//                 {
//                     Visible = false;
//                 }
//                 field("Quantity Invoiced";"Quantity Invoiced")
//                 {
//                 }
//                 field("Qty. Shipped Not Invoiced";"Qty. Shipped Not Invoiced")
//                 {
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
//             group("&Line")
//             {
//                 Caption = '&Line';
//                 Image = Line;
//                 action("Show Document")
//                 {
//                     Caption = 'Show Document';
//                     Image = View;
//                     ShortCutKey = 'Shift+F7';

//                     trigger OnAction()
//                     begin
//                         SalesShptHeader.GET("Document No.");
//                         PAGE.RUN(PAGE::"Posted Sales Shipment",SalesShptHeader);
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
//                         CurrPage.SAVERECORD;
//                     end;
//                 }
//                 action("Item &Tracking Entries")
//                 {
//                     Caption = 'Item &Tracking Entries';
//                     Image = ItemTrackingLedger;

//                     trigger OnAction()
//                     begin
//                         ShowItemTrackingLines;
//                     end;
//                 }
//             }
//         }
//     }

//     trigger OnAfterGetRecord()
//     begin
//         "Document No.HideValue" := FALSE;
//         DocumentNoOnFormat;
//     end;

//     trigger OnQueryClosePage(CloseAction: Action): Boolean
//     begin
//         IF CloseAction IN [ACTION::OK,ACTION::LookupOK] THEN
//           CreateLines;
//     end;

//     var
//         SalesShptHeader: Record "110";
//         SalesHeader: Record "36";
//         TempSalesShptLine: Record "111" temporary;
//         SalesGetShpt: Codeunit "64";
//         [InDataSet]
//         "Document No.HideValue": Boolean;

//     procedure SetSalesHeader(var SalesHeader2: Record "36")
//     begin
//         SalesHeader.GET(SalesHeader2."Document Type",SalesHeader2."No.");
//         SalesHeader.TESTFIELD("Document Type",SalesHeader."Document Type"::Invoice);
//     end;

//     local procedure IsFirstDocLine(): Boolean
//     var
//         SalesShptLine: Record "111";
//     begin
//         TempSalesShptLine.RESET;
//         TempSalesShptLine.COPYFILTERS(Rec);
//         TempSalesShptLine.SETRANGE("Document No.","Document No.");
//         IF NOT TempSalesShptLine.FINDFIRST THEN BEGIN
//           SalesShptLine.COPYFILTERS(Rec);
//           SalesShptLine.SETRANGE("Document No.","Document No.");
//           SalesShptLine.SETFILTER("Qty. Shipped Not Invoiced",'<>0');
//           IF SalesShptLine.FINDFIRST THEN BEGIN
//             TempSalesShptLine := SalesShptLine;
//             TempSalesShptLine.INSERT;
//           END;
//         END;
//         IF "Line No." = TempSalesShptLine."Line No." THEN
//           EXIT(TRUE);
//     end;

//     procedure CreateLines()
//     begin
//         CurrPage.SETSELECTIONFILTER(Rec);
//         SalesGetShpt.SetSalesHeader(SalesHeader);
//         SalesGetShpt.CreateInvLines(Rec);
//     end;

//     local procedure DocumentNoOnFormat()
//     begin
//         IF NOT IsFirstDocLine THEN
//           "Document No.HideValue" := TRUE;
//     end;

//     procedure SetSource(var SalesShptLine: Record "111")
//     begin
//         DELETEALL;
//         IF SalesShptLine.FINDSET THEN
//           REPEAT
//             Rec := SalesShptLine;
//             INSERT;
//           UNTIL SalesShptLine.NEXT = 0;
//     end;
// }

