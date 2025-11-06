// page 5802 "Value Entries"
// {
//     Caption = 'Value Entries';
//     DataCaptionExpression = GetCaption;
//     Editable = false;
//     PageType = List;
//     SourceTable = Table5802;

//     layout
//     {
//         area(content)
//         {
//             repeater()
//             {
//                 field("Posting Date";"Posting Date")
//                 {
//                 }
//                 field("Valuation Date";"Valuation Date")
//                 {
//                     Visible = false;
//                 }
//                 field("Item Ledger Entry Type";"Item Ledger Entry Type")
//                 {
//                 }
//                 field("Entry Type";"Entry Type")
//                 {
//                 }
//                 field("Variance Type";"Variance Type")
//                 {
//                     Visible = false;
//                 }
//                 field(Adjustment;Adjustment)
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
//                 field("Item Charge No.";"Item Charge No.")
//                 {
//                 }
//                 field(Description;Description)
//                 {
//                 }
//                 field("Return Reason Code";"Return Reason Code")
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
//                 }
//                 field("Cost Amount (Actual)";"Cost Amount (Actual)")
//                 {
//                 }
//                 field("Cost Amount (Non-Invtbl.)";"Cost Amount (Non-Invtbl.)")
//                 {
//                 }
//                 field("Cost Posted to G/L";"Cost Posted to G/L")
//                 {
//                 }
//                 field("Expected Cost Posted to G/L";"Expected Cost Posted to G/L")
//                 {
//                     Visible = false;
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
//                 field("Cost Posted to G/L (ACY)";"Cost Posted to G/L (ACY)")
//                 {
//                     Visible = false;
//                 }
//                 field("Item Ledger Entry Quantity";"Item Ledger Entry Quantity")
//                 {
//                 }
//                 field("Valued Quantity";"Valued Quantity")
//                 {
//                 }
//                 field("Invoiced Quantity";"Invoiced Quantity")
//                 {
//                 }
//                 field("Cost per Unit";"Cost per Unit")
//                 {
//                 }
//                 field("Cost per Unit (ACY)";"Cost per Unit (ACY)")
//                 {
//                 }
//                 field("Item No.";"Item No.")
//                 {
//                 }
//                 field("Location Code";"Location Code")
//                 {
//                     Visible = false;
//                 }
//                 field(Type;Type)
//                 {
//                     Visible = false;
//                 }
//                 field("No.";"No.")
//                 {
//                     Visible = false;
//                 }
//                 field("Discount Amount";"Discount Amount")
//                 {
//                     Visible = false;
//                 }
//                 field("Salespers./Purch. Code";"Salespers./Purch. Code")
//                 {
//                     Visible = false;
//                 }
//                 field("User ID";"User ID")
//                 {
//                     Visible = false;
//                 }
//                 field("Source Posting Group";"Source Posting Group")
//                 {
//                     Visible = false;
//                 }
//                 field("Source Code";"Source Code")
//                 {
//                     Visible = false;
//                 }
//                 field("Gen. Bus. Posting Group";"Gen. Bus. Posting Group")
//                 {
//                 }
//                 field("Gen. Prod. Posting Group";"Gen. Prod. Posting Group")
//                 {
//                 }
//                 field("Global Dimension 1 Code";"Global Dimension 1 Code")
//                 {
//                     Visible = false;
//                 }
//                 field("Global Dimension 2 Code";"Global Dimension 2 Code")
//                 {
//                     Visible = false;
//                 }
//                 field("Source Type";"Source Type")
//                 {
//                 }
//                 field("Source No.";"Source No.")
//                 {
//                 }
//                 field("Document Date";"Document Date")
//                 {
//                     Visible = false;
//                 }
//                 field("External Document No.";"External Document No.")
//                 {
//                 }
//                 field("Order Type";"Order Type")
//                 {
//                 }
//                 field("Order No.";"Order No.")
//                 {
//                     Visible = false;
//                 }
//                 field("Valued By Average Cost";"Valued By Average Cost")
//                 {
//                 }
//                 field("Item Ledger Entry No.";"Item Ledger Entry No.")
//                 {
//                 }
//                 field("Capacity Ledger Entry No.";"Capacity Ledger Entry No.")
//                 {
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
//                 field("Job Ledger Entry No.";"Job Ledger Entry No.")
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
//                 action("General Ledger")
//                 {
//                     Caption = 'General Ledger';
//                     Image = GLRegisters;

//                     trigger OnAction()
//                     begin
//                         ShowGL;
//                     end;
//                 }
//             }
//         }
//         area(processing)
//         {
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

//     trigger OnOpenPage()
//     begin
//         FilterGroupNo := FILTERGROUP; // Trick: FILTERGROUP is used to transfer an integer value
//     end;

//     var
//         Navigate: Page "344";
//         FilterGroupNo: Integer;

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
//           GETFILTER("Item Ledger Entry No.") <> '':
//             BEGIN
//               SourceTableName := ObjTransl.TranslateObject(ObjTransl."Object Type"::Table,32);
//               SourceFilter := GETFILTER("Item Ledger Entry No.");
//             END;
//           GETFILTER("Capacity Ledger Entry No.") <> '':
//             BEGIN
//               SourceTableName := ObjTransl.TranslateObject(ObjTransl."Object Type"::Table,5832);
//               SourceFilter := GETFILTER("Capacity Ledger Entry No.");
//             END;
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
//           FilterGroupNo = DATABASE::"Item Analysis View Entry":
//             BEGIN
//               IF Item."No." <> "Item No." THEN
//                 IF NOT Item.GET("Item No.") THEN
//                   CLEAR(Item);
//               SourceTableName := ObjTransl.TranslateObject(ObjTransl."Object Type"::Table,DATABASE::"Item Analysis View Entry");
//               SourceFilter := Item."No.";
//               Description := Item.Description;
//             END;
//         END;

//         EXIT(STRSUBSTNO('%1 %2 %3',SourceTableName,SourceFilter,Description));
//     end;
// }

