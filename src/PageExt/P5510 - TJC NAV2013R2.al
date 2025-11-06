// page 5510 "Production Journal"
// {
//     // TJCSG1.00
//     //  1. 21/07/2014  dp.dst
//     //     - Changed the Editable property of "Location Code" to TRUE to enable the editing.

//     Caption = 'Production Journal';
//     DataCaptionExpression = GetCaption;
//     InsertAllowed = false;
//     PageType = Worksheet;
//     SourceTable = Table83;

//     layout
//     {
//         area(content)
//         {
//             group(General)
//             {
//                 Caption = 'General';
//                 field(PostingDate;PostingDate)
//                 {
//                     Caption = 'Posting Date';

//                     trigger OnValidate()
//                     begin
//                         PostingDateOnAfterValidate;
//                     end;
//                 }
//                 field(FlushingFilter;FlushingFilter)
//                 {
//                     Caption = 'Flushing Method Filter';
//                     OptionCaption = 'Manual,Forward,Backward,Pick + Forward,Pick + Backward,All Methods';

//                     trigger OnValidate()
//                     begin
//                         FlushingFilterOnAfterValidate;
//                     end;
//                 }
//             }
//             repeater()
//             {
//                 IndentationColumn = DescriptionIndent;
//                 IndentationControls = Description;
//                 field("Entry Type";"Entry Type")
//                 {
//                     Editable = false;
//                 }
//                 field("Posting Date";"Posting Date")
//                 {
//                     Visible = false;
//                 }
//                 field("Order Line No.";"Order Line No.")
//                 {
//                     Editable = false;
//                     Visible = false;
//                 }
//                 field("Document No.";"Document No.")
//                 {
//                     Editable = false;
//                     Visible = false;
//                 }
//                 field("Item No.";"Item No.")
//                 {
//                     Editable = false;

//                     trigger OnLookup(var Text: Text): Boolean
//                     begin
//                         IF Item.GET("Item No.") THEN
//                           PAGE.RUNMODAL(PAGE::"Item List",Item);
//                     end;
//                 }
//                 field("Location Code";"Location Code")
//                 {
//                 }
//                 field("Bin Code";"Bin Code")
//                 {
//                 }
//                 field("Operation No.";"Operation No.")
//                 {
//                     Editable = false;
//                 }
//                 field(Type;Type)
//                 {
//                     Visible = true;
//                 }
//                 field("Flushing Method";"Flushing Method")
//                 {
//                     Visible = false;
//                 }
//                 field("No.";"No.")
//                 {
//                 }
//                 field("Reason Code";"Reason Code")
//                 {
//                     Editable = false;
//                     Visible = true;
//                 }
//                 field("Variant Code";"Variant Code")
//                 {
//                     Visible = false;
//                 }
//                 field(Description;Description)
//                 {
//                     Editable = false;
//                     StyleExpr = DescriptionEmphasize;
//                 }
//                 field(Quantity;Quantity)
//                 {
//                     Caption = 'Consumption Quantity';
//                     Editable = QuantityEditable;
//                     HideValue = QuantityHideValue;
//                 }
//                 field("Unit of Measure Code";"Unit of Measure Code")
//                 {
//                     Visible = false;
//                 }
//                 field("Unit Cost";"Unit Cost")
//                 {
//                     Visible = true;
//                 }
//                 field("Work Shift Code";"Work Shift Code")
//                 {
//                     Editable = "Work Shift CodeEditable";
//                     Visible = false;
//                 }
//                 field("Shortcut Dimension 1 Code";"Shortcut Dimension 1 Code")
//                 {
//                     Visible = false;
//                 }
//                 field("Gen. Bus. Posting Group";"Gen. Bus. Posting Group")
//                 {
//                     Visible = false;
//                 }
//                 field("Gen. Prod. Posting Group";"Gen. Prod. Posting Group")
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
//                 field("Starting Time";"Starting Time")
//                 {
//                     Editable = "Starting TimeEditable";
//                     Visible = false;
//                 }
//                 field("Ending Time";"Ending Time")
//                 {
//                     Editable = "Ending TimeEditable";
//                     Visible = false;
//                 }
//                 field("Concurrent Capacity";"Concurrent Capacity")
//                 {
//                     Editable = "Concurrent CapacityEditable";
//                     Visible = false;
//                 }
//                 field("Setup Time";"Setup Time")
//                 {
//                     Editable = "Setup TimeEditable";
//                     HideValue = "Setup TimeHideValue";
//                 }
//                 field("Run Time";"Run Time")
//                 {
//                     Editable = "Run TimeEditable";
//                     HideValue = "Run TimeHideValue";
//                 }
//                 field("Cap. Unit of Measure Code";"Cap. Unit of Measure Code")
//                 {
//                     Editable = CapUnitofMeasureCodeEditable;
//                     Visible = false;
//                 }
//                 field("Scrap Code";"Scrap Code")
//                 {
//                     Editable = "Scrap CodeEditable";
//                     Visible = false;
//                 }
//                 field("Output Quantity";"Output Quantity")
//                 {
//                     Editable = "Output QuantityEditable";
//                     HideValue = "Output QuantityHideValue";
//                 }
//                 field("Scrap Quantity";"Scrap Quantity")
//                 {
//                     Editable = "Scrap QuantityEditable";
//                     HideValue = "Scrap QuantityHideValue";
//                 }
//                 field(Finished;Finished)
//                 {
//                     Editable = FinishedEditable;
//                 }
//                 field("Applies-to Entry";"Applies-to Entry")
//                 {
//                     Visible = false;
//                 }
//                 field("Applies-from Entry";"Applies-from Entry")
//                 {
//                     Editable = "Applies-from EntryEditable";
//                     Visible = false;
//                 }
//                 field("Document Date";"Document Date")
//                 {
//                     Editable = false;
//                     Visible = false;
//                 }
//                 field("External Document No.";"External Document No.")
//                 {
//                     Visible = false;
//                 }
//             }
//             group(Actual)
//             {
//                 Caption = 'Actual';
//                 fixed()
//                 {
//                     group("Consump. Qty.")
//                     {
//                         Caption = 'Consump. Qty.';
//                         field(ActualConsumpQty;ActualConsumpQty)
//                         {
//                             DecimalPlaces = 0:5;
//                             Editable = false;
//                             HideValue = ActualConsumpQtyHideValue;
//                         }
//                     }
//                     group("Setup Time")
//                     {
//                         Caption = 'Setup Time';
//                         field(ActualSetupTime;ActualSetupTime)
//                         {
//                             Caption = 'Setup Time';
//                             DecimalPlaces = 0:5;
//                             Editable = false;
//                             HideValue = ActualSetupTimeHideValue;
//                         }
//                     }
//                     group("Run Time")
//                     {
//                         Caption = 'Run Time';
//                         field(ActualRunTime;ActualRunTime)
//                         {
//                             Caption = 'Run Time';
//                             DecimalPlaces = 0:5;
//                             Editable = false;
//                             HideValue = ActualRunTimeHideValue;
//                         }
//                     }
//                     group("Output Qty.")
//                     {
//                         Caption = 'Output Qty.';
//                         field(ActualOutputQty;ActualOutputQty)
//                         {
//                             Caption = 'Output Qty.';
//                             DecimalPlaces = 0:5;
//                             Editable = false;
//                             HideValue = ActualOutputQtyHideValue;
//                         }
//                     }
//                     group("Scrap Qty.")
//                     {
//                         Caption = 'Scrap Qty.';
//                         field(ActualScrapQty;ActualScrapQty)
//                         {
//                             Caption = 'Scrap Qty.';
//                             DecimalPlaces = 0:5;
//                             Editable = false;
//                             HideValue = ActualScrapQtyHideValue;
//                         }
//                     }
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
//                 action(ItemTrackingLines)
//                 {
//                     Caption = 'Item &Tracking Lines';
//                     Image = ItemTrackingLines;
//                     ShortCutKey = 'Shift+Ctrl+I';

//                     trigger OnAction()
//                     begin
//                         OpenItemTrackingLines(FALSE);
//                     end;
//                 }
//                 action("Bin Contents")
//                 {
//                     Caption = 'Bin Contents';
//                     Image = BinContent;
//                     RunObject = Page 7305;
//                     RunPageLink = Location Code=FIELD(Location Code),
//                                   Item No.=FIELD(Item No.),
//                                   Variant Code=FIELD(Variant Code);
//                     RunPageView = SORTING(Location Code,Bin Code,Item No.,Variant Code);
//                 }
//             }
//             group("Pro&d. Order")
//             {
//                 Caption = 'Pro&d. Order';
//                 Image = "Order";
//                 action(Card)
//                 {
//                     Caption = 'Card';
//                     Image = EditLines;
//                     RunObject = Page 99000831;
//                     RunPageLink = No.=FIELD(Order No.);
//                     ShortCutKey = 'Shift+F7';
//                 }
//                 group("Ledger E&ntries")
//                 {
//                     Caption = 'Ledger E&ntries';
//                     Image = Entries;
//                     action("Item Ledger E&ntries")
//                     {
//                         Caption = 'Item Ledger E&ntries';
//                         Image = ItemLedger;
//                         RunObject = Page 38;
//                         RunPageLink = Order Type=CONST(Production),
//                                       Order No.=FIELD(Order No.);
//                         RunPageView = SORTING(Order Type,Order No.);
//                         ShortCutKey = 'Ctrl+F7';
//                     }
//                     action("Capacity Ledger Entries")
//                     {
//                         Caption = 'Capacity Ledger Entries';
//                         Image = CapacityLedger;
//                         RunObject = Page 5832;
//                         RunPageLink = Order Type=CONST(Production),
//                                       Order No.=FIELD(Order No.);
//                         RunPageView = SORTING(Order Type,Order No.);
//                     }
//                     action("Value Entries")
//                     {
//                         Caption = 'Value Entries';
//                         Image = ValueLedger;
//                         RunObject = Page 5802;
//                         RunPageLink = Order Type=CONST(Production),
//                                       Order No.=FIELD(Order No.);
//                         RunPageView = SORTING(Order Type,Order No.);
//                     }
//                 }
//             }
//         }
//         area(processing)
//         {
//             group("P&osting")
//             {
//                 Caption = 'P&osting';
//                 Image = Post;
//                 action("Test Report")
//                 {
//                     Caption = 'Test Report';
//                     Ellipsis = true;
//                     Image = TestReport;

//                     trigger OnAction()
//                     begin
//                         ReportPrint.PrintItemJnlLine(Rec);
//                     end;
//                 }
//                 action(Post)
//                 {
//                     Caption = 'P&ost';
//                     Image = PostOrder;
//                     Promoted = true;
//                     PromotedCategory = Process;
//                     PromotedIsBig = true;
//                     ShortCutKey = 'F9';

//                     trigger OnAction()
//                     begin
//                         DeleteRecTemp;

//                         PostingItemJnlFromProduction(FALSE);

//                         InsertTempRec;

//                         SetFilterGroup;
//                         CurrPage.UPDATE(FALSE);
//                     end;
//                 }
//                 action("Post and &Print")
//                 {
//                     Caption = 'Post and &Print';
//                     Image = PostPrint;
//                     Promoted = true;
//                     PromotedCategory = Process;
//                     PromotedIsBig = true;
//                     ShortCutKey = 'Shift+F9';

//                     trigger OnAction()
//                     begin
//                         DeleteRecTemp;

//                         PostingItemJnlFromProduction(TRUE);

//                         InsertTempRec;

//                         SetFilterGroup;
//                         CurrPage.UPDATE(FALSE);
//                     end;
//                 }
//             }
//             action("&Print")
//             {
//                 Caption = '&Print';
//                 Ellipsis = true;
//                 Image = Print;
//                 Promoted = true;
//                 PromotedCategory = Process;

//                 trigger OnAction()
//                 var
//                     ItemJnlLine: Record "83";
//                 begin
//                     ItemJnlLine.COPY(Rec);
//                     ItemJnlLine.SETRANGE("Journal Template Name","Journal Template Name");
//                     ItemJnlLine.SETRANGE("Journal Batch Name","Journal Batch Name");
//                     REPORT.RUNMODAL(REPORT::"Inventory Movement",TRUE,TRUE,ItemJnlLine);
//                 end;
//             }
//         }
//     }

//     trigger OnAfterGetCurrRecord()
//     begin
//         GetActTimeAndQtyBase;

//         ControlsMngt;
//     end;

//     trigger OnAfterGetRecord()
//     begin
//         ActualScrapQtyHideValue := FALSE;
//         ActualOutputQtyHideValue := FALSE;
//         ActualRunTimeHideValue := FALSE;
//         ActualSetupTimeHideValue := FALSE;
//         ActualConsumpQtyHideValue := FALSE;
//         "Scrap QuantityHideValue" := FALSE;
//         "Output QuantityHideValue" := FALSE;
//         "Run TimeHideValue" := FALSE;
//         "Setup TimeHideValue" := FALSE;
//         QuantityHideValue := FALSE;
//         DescriptionIndent := 0;
//         ShowShortcutDimCode(ShortcutDimCode);
//         DescriptionOnFormat;
//         QuantityOnFormat;
//         SetupTimeOnFormat;
//         RunTimeOnFormat;
//         OutputQuantityOnFormat;
//         ScrapQuantityOnFormat;
//         ActualConsumpQtyOnFormat;
//         ActualSetupTimeOnFormat;
//         ActualRunTimeOnFormat;
//         ActualOutputQtyOnFormat;
//         ActualScrapQtyOnFormat;
//     end;

//     trigger OnDeleteRecord(): Boolean
//     var
//         ReserveItemJnlLine: Codeunit "99000835";
//     begin
//         COMMIT;
//         IF NOT ReserveItemJnlLine.DeleteLineConfirm(Rec) THEN
//           EXIT(FALSE);
//         ReserveItemJnlLine.DeleteLine(Rec);
//     end;

//     trigger OnInit()
//     begin
//         "Applies-from EntryEditable" := TRUE;
//         QuantityEditable := TRUE;
//         "Output QuantityEditable" := TRUE;
//         "Scrap QuantityEditable" := TRUE;
//         "Scrap CodeEditable" := TRUE;
//         FinishedEditable := TRUE;
//         "Work Shift CodeEditable" := TRUE;
//         "Run TimeEditable" := TRUE;
//         "Setup TimeEditable" := TRUE;
//         CapUnitofMeasureCodeEditable := TRUE;
//         "Concurrent CapacityEditable" := TRUE;
//         "Ending TimeEditable" := TRUE;
//         "Starting TimeEditable" := TRUE;
//     end;

//     trigger OnModifyRecord(): Boolean
//     begin
//         "Changed by User" := TRUE;
//     end;

//     trigger OnOpenPage()
//     begin
//         SetFilterGroup;

//         IF ProdOrderLineNo <> 0 THEN
//           ProdOrderLine.GET(ProdOrder.Status,ProdOrder."No.",ProdOrderLineNo);
//     end;

//     var
//         Item: Record "27";
//         ProdOrder: Record "5405";
//         ProdOrderLine: Record "5406";
//         ProdOrderComp: Record "5407";
//         TempItemJrnlLine: Record "83" temporary;
//         CostCalcMgt: Codeunit "5836";
//         ReportPrint: Codeunit "228";
//         PostingDate: Date;
//         xPostingDate: Date;
//         ProdOrderLineNo: Integer;
//         ShortcutDimCode: array [8] of Code[20];
//         ToTemplateName: Code[10];
//         ToBatchName: Code[10];
//         ActualRunTime: Decimal;
//         ActualSetupTime: Decimal;
//         ActualOutputQty: Decimal;
//         ActualScrapQty: Decimal;
//         ActualConsumpQty: Decimal;
//         FlushingFilter: Option Manual,Forward,Backward,"Pick + Forward","Pick + Backward","All Methods";
//         [InDataSet]
//         DescriptionIndent: Integer;
//         [InDataSet]
//         QuantityHideValue: Boolean;
//         [InDataSet]
//         "Setup TimeHideValue": Boolean;
//         [InDataSet]
//         "Run TimeHideValue": Boolean;
//         [InDataSet]
//         "Output QuantityHideValue": Boolean;
//         [InDataSet]
//         "Scrap QuantityHideValue": Boolean;
//         [InDataSet]
//         ActualConsumpQtyHideValue: Boolean;
//         [InDataSet]
//         ActualSetupTimeHideValue: Boolean;
//         [InDataSet]
//         ActualRunTimeHideValue: Boolean;
//         [InDataSet]
//         ActualOutputQtyHideValue: Boolean;
//         [InDataSet]
//         ActualScrapQtyHideValue: Boolean;
//         [InDataSet]
//         "Starting TimeEditable": Boolean;
//         [InDataSet]
//         "Ending TimeEditable": Boolean;
//         [InDataSet]
//         "Concurrent CapacityEditable": Boolean;
//         [InDataSet]
//         CapUnitofMeasureCodeEditable: Boolean;
//         [InDataSet]
//         "Setup TimeEditable": Boolean;
//         [InDataSet]
//         "Run TimeEditable": Boolean;
//         [InDataSet]
//         "Work Shift CodeEditable": Boolean;
//         [InDataSet]
//         FinishedEditable: Boolean;
//         [InDataSet]
//         "Scrap CodeEditable": Boolean;
//         [InDataSet]
//         "Scrap QuantityEditable": Boolean;
//         [InDataSet]
//         "Output QuantityEditable": Boolean;
//         [InDataSet]
//         QuantityEditable: Boolean;
//         [InDataSet]
//         "Applies-from EntryEditable": Boolean;
//         [InDataSet]
//         DescriptionEmphasize: Text;

//     procedure Setup(TemplateName: Code[10];BatchName: Code[10];ProductionOrder: Record "5405";ProdLineNo: Integer;PostDate: Date)
//     begin
//         ToTemplateName := TemplateName;
//         ToBatchName := BatchName;
//         ProdOrder := ProductionOrder;
//         ProdOrderLineNo := ProdLineNo;
//         PostingDate := PostDate;
//         xPostingDate := PostingDate;

//         FlushingFilter := FlushingFilter::Manual;
//     end;

//     procedure GetActTimeAndQtyBase()
//     begin
//         ActualSetupTime := 0;
//         ActualRunTime := 0;
//         ActualOutputQty := 0;
//         ActualScrapQty := 0;
//         ActualConsumpQty := 0;

//         IF "Qty. per Unit of Measure" = 0 THEN
//           "Qty. per Unit of Measure" := 1;
//         IF "Qty. per Cap. Unit of Measure" = 0 THEN
//           "Qty. per Cap. Unit of Measure" := 1;

//         IF Item.GET("Item No.") THEN
//           CASE "Entry Type" OF
//             "Entry Type"::Consumption:
//               IF ProdOrderComp.GET(
//                    ProdOrder.Status,
//                    "Order No.",
//                    "Order Line No.",
//                    "Prod. Order Comp. Line No.")
//               THEN BEGIN
//                 ProdOrderComp.CALCFIELDS("Act. Consumption (Qty)"); // Base Unit
//                 ActualConsumpQty :=
//                   ProdOrderComp."Act. Consumption (Qty)" / "Qty. per Unit of Measure";
//                 IF Item."Rounding Precision" > 0 THEN
//                   ActualConsumpQty := ROUND(ActualConsumpQty,Item."Rounding Precision",'>')
//                 ELSE
//                   ActualConsumpQty := ROUND(ActualConsumpQty,0.00001);
//               END;
//             "Entry Type"::Output:
//               BEGIN
//                 IF ProdOrderLineNo = 0 THEN
//                   IF NOT ProdOrderLine.GET(ProdOrder.Status,ProdOrder."No.","Order Line No.") THEN
//                     CLEAR(ProdOrderLine);
//                 IF ProdOrderLine."Prod. Order No." <> '' THEN BEGIN
//                   CostCalcMgt.CalcActTimeAndQtyBase(
//                     ProdOrderLine,"Operation No.",ActualRunTime,ActualSetupTime,ActualOutputQty,ActualScrapQty);
//                   ActualSetupTime :=
//                     ROUND(ActualSetupTime / "Qty. per Cap. Unit of Measure",0.00001);
//                   ActualRunTime :=
//                     ROUND(ActualRunTime / "Qty. per Cap. Unit of Measure",0.00001);

//                   ActualOutputQty := ActualOutputQty / "Qty. per Unit of Measure";
//                   ActualScrapQty := ActualScrapQty / "Qty. per Unit of Measure";
//                   IF Item."Rounding Precision" > 0 THEN BEGIN
//                     ActualOutputQty := ROUND(ActualOutputQty,Item."Rounding Precision",'>');
//                     ActualScrapQty := ROUND(ActualScrapQty,Item."Rounding Precision",'>');
//                   END ELSE BEGIN
//                     ActualOutputQty := ROUND(ActualOutputQty,0.00001);
//                     ActualScrapQty := ROUND(ActualScrapQty,0.00001);
//                   END;
//                 END;
//               END;
//           END;
//     end;

//     local procedure ControlsMngt()
//     var
//         OperationExist: Boolean;
//     begin
//         IF ("Entry Type" = "Entry Type"::Output) AND
//            ("Operation No." <> '')
//         THEN
//           OperationExist := TRUE
//         ELSE
//           OperationExist := FALSE;

//         "Starting TimeEditable" := OperationExist;
//         "Ending TimeEditable" := OperationExist;
//         "Concurrent CapacityEditable" := OperationExist;
//         CapUnitofMeasureCodeEditable := OperationExist;
//         "Setup TimeEditable" := OperationExist;
//         "Run TimeEditable" := OperationExist;
//         "Work Shift CodeEditable" := OperationExist;

//         FinishedEditable := "Entry Type" = "Entry Type"::Output;
//         "Scrap CodeEditable" := "Entry Type" = "Entry Type"::Output;
//         "Scrap QuantityEditable" := "Entry Type" = "Entry Type"::Output;
//         "Output QuantityEditable" := "Entry Type" = "Entry Type"::Output;

//         QuantityEditable := "Entry Type" = "Entry Type"::Consumption;
//         "Applies-from EntryEditable" := "Entry Type" = "Entry Type"::Consumption;
//     end;

//     procedure DeleteRecTemp()
//     begin
//         TempItemJrnlLine.DELETEALL;

//         IF FIND('-') THEN
//           REPEAT
//             CASE "Entry Type" OF
//               "Entry Type"::Consumption:
//                 IF "Quantity (Base)" = 0 THEN BEGIN
//                   TempItemJrnlLine := Rec;
//                   TempItemJrnlLine.INSERT;

//                   DELETE;
//                 END;
//               "Entry Type"::Output:
//                 IF TimeIsEmpty AND
//                    ("Output Quantity (Base)" = 0) AND ("Scrap Quantity (Base)" = 0)
//                 THEN BEGIN
//                   TempItemJrnlLine := Rec;
//                   TempItemJrnlLine.INSERT;

//                   DELETE;
//                 END;
//             END;
//           UNTIL NEXT = 0;
//     end;

//     procedure InsertTempRec()
//     begin
//         IF TempItemJrnlLine.FIND('-') THEN
//           REPEAT
//             Rec := TempItemJrnlLine;
//             "Changed by User" := FALSE;
//             INSERT;
//           UNTIL TempItemJrnlLine.NEXT = 0;
//         TempItemJrnlLine.DELETEALL;
//     end;

//     procedure SetFilterGroup()
//     begin
//         FILTERGROUP(2);
//         SETRANGE("Journal Template Name",ToTemplateName);
//         SETRANGE("Journal Batch Name",ToBatchName);
//         SETRANGE("Order Type","Order Type"::Production);
//         SETRANGE("Order No.",ProdOrder."No.");
//         IF ProdOrderLineNo <> 0 THEN
//           SETRANGE("Order Line No.",ProdOrderLineNo);
//         SetFlushingFilter;
//         FILTERGROUP(0);
//     end;

//     procedure SetFlushingFilter()
//     begin
//         IF FlushingFilter <> FlushingFilter::"All Methods" THEN
//           SETRANGE("Flushing Method",FlushingFilter)
//         ELSE
//           SETRANGE("Flushing Method");
//     end;

//     procedure GetCaption(): Text[250]
//     var
//         ObjTransl: Record "377";
//         SourceTableName: Text[100];
//         Descrip: Text[100];
//     begin
//         SourceTableName := ObjTransl.TranslateObject(ObjTransl."Object Type"::Table,5405);
//         IF ProdOrderLineNo <> 0 THEN
//           Descrip := ProdOrderLine.Description
//         ELSE
//           Descrip := ProdOrder.Description;

//         EXIT(STRSUBSTNO('%1 %2 %3',SourceTableName,ProdOrder."No.",Descrip));
//     end;

//     local procedure PostingDateOnAfterValidate()
//     begin
//         IF PostingDate = 0D THEN
//           PostingDate := xPostingDate;

//         IF PostingDate <> xPostingDate THEN BEGIN
//           MODIFYALL("Posting Date",PostingDate);
//           xPostingDate := PostingDate;
//           CurrPage.UPDATE(FALSE);
//         END;
//     end;

//     local procedure FlushingFilterOnAfterValidate()
//     begin
//         SetFilterGroup;
//         CurrPage.UPDATE(FALSE);
//     end;

//     local procedure DescriptionOnFormat()
//     begin
//         DescriptionIndent := Level;
//         IF "Entry Type" = "Entry Type"::Output THEN
//           DescriptionEmphasize := 'Strong'
//         ELSE
//           DescriptionEmphasize := '';
//     end;

//     local procedure QuantityOnFormat()
//     begin
//         IF "Entry Type" = "Entry Type"::Output THEN
//           QuantityHideValue := TRUE;
//     end;

//     local procedure SetupTimeOnFormat()
//     begin
//         IF ("Entry Type" = "Entry Type"::Consumption) OR
//            ("Operation No." = '')
//         THEN
//           "Setup TimeHideValue" := TRUE;
//     end;

//     local procedure RunTimeOnFormat()
//     begin
//         IF ("Entry Type" = "Entry Type"::Consumption) OR
//            ("Operation No." = '')
//         THEN
//           "Run TimeHideValue" := TRUE;
//     end;

//     local procedure OutputQuantityOnFormat()
//     begin
//         IF "Entry Type" = "Entry Type"::Consumption THEN
//           "Output QuantityHideValue" := TRUE;
//     end;

//     local procedure ScrapQuantityOnFormat()
//     begin
//         IF "Entry Type" = "Entry Type"::Consumption THEN
//           "Scrap QuantityHideValue" := TRUE;
//     end;

//     local procedure ActualConsumpQtyOnFormat()
//     begin
//         IF "Entry Type" = "Entry Type"::Output THEN
//           ActualConsumpQtyHideValue := TRUE;
//     end;

//     local procedure ActualSetupTimeOnFormat()
//     begin
//         IF ("Entry Type" = "Entry Type"::Consumption) OR
//            ("Operation No." = '')
//         THEN
//           ActualSetupTimeHideValue := TRUE;
//     end;

//     local procedure ActualRunTimeOnFormat()
//     begin
//         IF ("Entry Type" = "Entry Type"::Consumption) OR
//            ("Operation No." = '')
//         THEN
//           ActualRunTimeHideValue := TRUE;
//     end;

//     local procedure ActualOutputQtyOnFormat()
//     begin
//         IF "Entry Type" = "Entry Type"::Consumption THEN
//           ActualOutputQtyHideValue := TRUE;
//     end;

//     local procedure ActualScrapQtyOnFormat()
//     begin
//         IF "Entry Type" = "Entry Type"::Consumption THEN
//           ActualScrapQtyHideValue := TRUE;
//     end;
// }

