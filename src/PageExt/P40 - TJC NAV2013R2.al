// page 40 "Item Journal"
// {
//     AutoSplitKey = true;
//     Caption = 'Item Journal';
//     DataCaptionFields = "Journal Batch Name";
//     DelayedInsert = true;
//     PageType = Worksheet;
//     SaveValues = true;
//     SourceTable = Table83;

//     layout
//     {
//         area(content)
//         {
//             field(CurrentJnlBatchName;CurrentJnlBatchName)
//             {
//                 Caption = 'Batch Name';
//                 Lookup = true;

//                 trigger OnLookup(var Text: Text): Boolean
//                 begin
//                     CurrPage.SAVERECORD;
//                     ItemJnlMgt.LookupName(CurrentJnlBatchName,Rec);
//                     CurrPage.UPDATE(FALSE);
//                 end;

//                 trigger OnValidate()
//                 begin
//                     ItemJnlMgt.CheckName(CurrentJnlBatchName,Rec);
//                     CurrentJnlBatchNameOnAfterVali;
//                 end;
//             }
//             repeater()
//             {
//                 field("Line No.";"Line No.")
//                 {
//                 }
//                 field("Posting Date";"Posting Date")
//                 {
//                 }
//                 field("Document Date";"Document Date")
//                 {
//                     Visible = false;
//                 }
//                 field("Entry Type";"Entry Type")
//                 {
//                     OptionCaption = 'Purchase,Sale,Positive Adjmt.,Negative Adjmt.';
//                 }
//                 field("Document No.";"Document No.")
//                 {
//                 }
//                 field("External Document No.";"External Document No.")
//                 {
//                     Visible = false;
//                 }
//                 field("Item No.";"Item No.")
//                 {

//                     trigger OnValidate()
//                     begin
//                         ItemJnlMgt.GetItem("Item No.",ItemDescription);
//                         ShowShortcutDimCode(ShortcutDimCode);
//                     end;
//                 }
//                 field("Variant Code";"Variant Code")
//                 {
//                     Visible = false;
//                 }
//                 field(Description;Description)
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
//                 field("Location Code";"Location Code")
//                 {
//                     Visible = true;

//                     trigger OnValidate()
//                     var
//                         WMSManagement: Codeunit "7302";
//                     begin
//                         WMSManagement.CheckItemJnlLineLocation(Rec,xRec);
//                     end;
//                 }
//                 field("Bin Code";"Bin Code")
//                 {
//                     Visible = true;
//                 }
//                 field("Salespers./Purch. Code";"Salespers./Purch. Code")
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
//                 field(Quantity;Quantity)
//                 {
//                 }
//                 field("Unit of Measure Code";"Unit of Measure Code")
//                 {
//                 }
//                 field("Unit Amount";"Unit Amount")
//                 {
//                 }
//                 field(Amount;Amount)
//                 {
//                 }
//                 field("Discount Amount";"Discount Amount")
//                 {
//                 }
//                 field("Indirect Cost %";"Indirect Cost %")
//                 {
//                     Visible = false;
//                 }
//                 field("Unit Cost";"Unit Cost")
//                 {
//                 }
//                 field("Applies-to Entry";"Applies-to Entry")
//                 {
//                 }
//                 field("Applies-from Entry";"Applies-from Entry")
//                 {
//                     Visible = false;
//                 }
//                 field("Transaction Type";"Transaction Type")
//                 {
//                     Visible = false;
//                 }
//                 field("Transport Method";"Transport Method")
//                 {
//                     Visible = false;
//                 }
//                 field("Country/Region Code";"Country/Region Code")
//                 {
//                     Visible = false;
//                 }
//                 field("Reason Code";"Reason Code")
//                 {
//                     Visible = false;
//                 }
//             }
//             group()
//             {
//                 fixed()
//                 {
//                     group("Item Description")
//                     {
//                         Caption = 'Item Description';
//                         field(ItemDescription;ItemDescription)
//                         {
//                             Editable = false;
//                         }
//                     }
//                 }
//             }
//         }
//         area(factboxes)
//         {
//             part(;9090)
//             {
//                 SubPageLink = No.=FIELD(Item No.);
//                 Visible = false;
//             }
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
//                     Promoted = true;
//                     PromotedCategory = Process;
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
//                     Promoted = true;
//                     PromotedCategory = Process;
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
//                     RunPageView = SORTING(Location Code,Item No.,Variant Code);
//                 }
//                 separator("-")
//                 {
//                     Caption = '-';
//                 }
//                 action("&Recalculate Unit Amount")
//                 {
//                     Caption = '&Recalculate Unit Amount';
//                     Image = UpdateUnitCost;

//                     trigger OnAction()
//                     begin
//                         RecalculateUnitAmount;
//                         CurrPage.SAVERECORD;
//                     end;
//                 }
//             }
//             group("&Item")
//             {
//                 Caption = '&Item';
//                 Image = Item;
//                 action(Card)
//                 {
//                     Caption = 'Card';
//                     Image = EditLines;
//                     RunObject = Page 30;
//                     RunPageLink = No.=FIELD(Item No.);
//                     ShortCutKey = 'Shift+F7';
//                 }
//                 action("Ledger E&ntries")
//                 {
//                     Caption = 'Ledger E&ntries';
//                     Image = ItemLedger;
//                     Promoted = false;
//                     //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
//                     //PromotedCategory = Process;
//                     RunObject = Page 38;
//                     RunPageLink = Item No.=FIELD(Item No.);
//                     RunPageView = SORTING(Item No.);
//                     ShortCutKey = 'Ctrl+F7';
//                 }
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
//                             ItemAvailFormsMgt.ShowItemAvailFromItemJnlLine(Rec,ItemAvailFormsMgt.ByEvent)
//                         end;
//                     }
//                     action(Period)
//                     {
//                         Caption = 'Period';
//                         Image = Period;

//                         trigger OnAction()
//                         begin
//                             ItemAvailFormsMgt.ShowItemAvailFromItemJnlLine(Rec,ItemAvailFormsMgt.ByPeriod)
//                         end;
//                     }
//                     action(Variant)
//                     {
//                         Caption = 'Variant';
//                         Image = ItemVariant;

//                         trigger OnAction()
//                         begin
//                             ItemAvailFormsMgt.ShowItemAvailFromItemJnlLine(Rec,ItemAvailFormsMgt.ByVariant)
//                         end;
//                     }
//                     action(Location)
//                     {
//                         Caption = 'Location';
//                         Image = Warehouse;

//                         trigger OnAction()
//                         begin
//                             ItemAvailFormsMgt.ShowItemAvailFromItemJnlLine(Rec,ItemAvailFormsMgt.ByLocation)
//                         end;
//                     }
//                     action("BOM Level")
//                     {
//                         Caption = 'BOM Level';
//                         Image = BOMLevel;

//                         trigger OnAction()
//                         begin
//                             ItemAvailFormsMgt.ShowItemAvailFromItemJnlLine(Rec,ItemAvailFormsMgt.ByBOM)
//                         end;
//                     }
//                 }
//             }
//         }
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
//                     Promoted = true;
//                     PromotedCategory = Process;
//                     RunObject = Codeunit 246;
//                 }
//                 action("&Calculate Whse. Adjustment")
//                 {
//                     Caption = '&Calculate Whse. Adjustment';
//                     Ellipsis = true;
//                     Image = CalculateWarehouseAdjustment;

//                     trigger OnAction()
//                     begin
//                         CalcWhseAdjmt.SetItemJnlLine(Rec);
//                         CalcWhseAdjmt.RUNMODAL;
//                         CLEAR(CalcWhseAdjmt);
//                     end;
//                 }
//                 separator("-")
//                 {
//                     Caption = '-';
//                 }
//                 action("&Get Standard Journals")
//                 {
//                     Caption = '&Get Standard Journals';
//                     Ellipsis = true;
//                     Image = GetStandardJournal;
//                     Promoted = true;
//                     PromotedCategory = Process;

//                     trigger OnAction()
//                     var
//                         StdItemJnl: Record "752";
//                     begin
//                         StdItemJnl.FILTERGROUP := 2;
//                         StdItemJnl.SETRANGE("Journal Template Name","Journal Template Name");
//                         StdItemJnl.FILTERGROUP := 0;
//                         IF PAGE.RUNMODAL(PAGE::"Standard Item Journals",StdItemJnl) = ACTION::LookupOK THEN BEGIN
//                           StdItemJnl.CreateItemJnlFromStdJnl(StdItemJnl,CurrentJnlBatchName);
//                           MESSAGE(Text001,StdItemJnl.Code);
//                         END
//                     end;
//                 }
//                 action("&Save as Standard Journal")
//                 {
//                     Caption = '&Save as Standard Journal';
//                     Ellipsis = true;
//                     Image = SaveasStandardJournal;

//                     trigger OnAction()
//                     var
//                         ItemJnlBatch: Record "233";
//                         ItemJnlLines: Record "83";
//                         StdItemJnl: Record "752";
//                         SaveAsStdItemJnl: Report "751";
//                     begin
//                         ItemJnlLines.SETFILTER("Journal Template Name","Journal Template Name");
//                         ItemJnlLines.SETFILTER("Journal Batch Name",CurrentJnlBatchName);
//                         CurrPage.SETSELECTIONFILTER(ItemJnlLines);
//                         ItemJnlLines.COPYFILTERS(Rec);

//                         ItemJnlBatch.GET("Journal Template Name",CurrentJnlBatchName);
//                         SaveAsStdItemJnl.Initialise(ItemJnlLines,ItemJnlBatch);
//                         SaveAsStdItemJnl.RUNMODAL;
//                         IF NOT SaveAsStdItemJnl.GetStdItemJournal(StdItemJnl) THEN
//                           EXIT;

//                         MESSAGE(Text002,StdItemJnl.Code);
//                     end;
//                 }
//             }
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
//                         CODEUNIT.RUN(CODEUNIT::"Item Jnl.-Post",Rec);
//                         CurrentJnlBatchName := GETRANGEMAX("Journal Batch Name");
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
//                         CODEUNIT.RUN(CODEUNIT::"Item Jnl.-Post+Print",Rec);
//                         CurrentJnlBatchName := GETRANGEMAX("Journal Batch Name");
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
//             action("Negative Adjustment")
//             {
//                 Caption = 'Negative Adjustment';
//                 Promoted = true;
//                 PromotedCategory = Process;
//                 PromotedIsBig = true;
//                 RunObject = Report 50003;
//             }
//         }
//     }

//     trigger OnAfterGetCurrRecord()
//     begin
//         ItemJnlMgt.GetItem("Item No.",ItemDescription);
//     end;

//     trigger OnAfterGetRecord()
//     begin
//         ShowShortcutDimCode(ShortcutDimCode);
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

//     trigger OnInsertRecord(BelowxRec: Boolean): Boolean
//     begin
//         IF "Entry Type" > "Entry Type"::"Negative Adjmt." THEN
//           ERROR(Text000,"Entry Type");
//     end;

//     trigger OnNewRecord(BelowxRec: Boolean)
//     begin
//         SetUpNewLine(xRec);
//         CLEAR(ShortcutDimCode);
//     end;

//     trigger OnOpenPage()
//     var
//         JnlSelected: Boolean;
//     begin
//         OpenedFromBatch := ("Journal Batch Name" <> '') AND ("Journal Template Name" = '');
//         IF OpenedFromBatch THEN BEGIN
//           CurrentJnlBatchName := "Journal Batch Name";
//           ItemJnlMgt.OpenJnl(CurrentJnlBatchName,Rec);
//           EXIT;
//         END;
//         ItemJnlMgt.TemplateSelection(PAGE::"Item Journal",0,FALSE,Rec,JnlSelected);
//         IF NOT JnlSelected THEN
//           ERROR('');
//         ItemJnlMgt.OpenJnl(CurrentJnlBatchName,Rec);
//     end;

//     var
//         Text000: Label 'You cannot use entry type %1 in this journal.';
//         ItemJnlMgt: Codeunit "240";
//         ReportPrint: Codeunit "228";
//         ItemAvailFormsMgt: Codeunit "353";
//         CalcWhseAdjmt: Report "7315";
//         CurrentJnlBatchName: Code[10];
//         ItemDescription: Text[50];
//         ShortcutDimCode: array [8] of Code[20];
//         Text001: Label 'Item Journal lines have been successfully inserted from Standard Item Journal %1.';
//         Text002: Label 'Standard Item Journal %1 has been successfully created.';
//         OpenedFromBatch: Boolean;

//     local procedure CurrentJnlBatchNameOnAfterVali()
//     begin
//         CurrPage.SAVERECORD;
//         ItemJnlMgt.SetName(CurrentJnlBatchName,Rec);
//         CurrPage.UPDATE(FALSE);
//     end;
// }

