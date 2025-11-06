// page 393 "Item Reclass. Journal"
// {
//     AutoSplitKey = true;
//     Caption = 'Item Reclass. Journal';
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
//                 field("Posting Date";"Posting Date")
//                 {
//                 }
//                 field("Document Date";"Document Date")
//                 {
//                     Visible = false;
//                 }
//                 field("Document No.";"Document No.")
//                 {
//                 }
//                 field("Item No.";"Item No.")
//                 {

//                     trigger OnValidate()
//                     begin
//                         ItemJnlMgt.GetItem("Item No.",ItemDescription);
//                         ShowShortcutDimCode(ShortcutDimCode);
//                         ShowNewShortcutDimCode(NewShortcutDimCode);
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
//                 field("New Shortcut Dimension 1 Code";"New Shortcut Dimension 1 Code")
//                 {
//                     Visible = false;
//                 }
//                 field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
//                 {
//                     Visible = false;
//                 }
//                 field("New Shortcut Dimension 2 Code";"New Shortcut Dimension 2 Code")
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
//                 field(NewShortcutDimCode[3];NewShortcutDimCode[3])
//                 {
//                     CaptionClass = Text000;
//                     Visible = false;

//                     trigger OnLookup(var Text: Text): Boolean
//                     begin
//                         LookupNewShortcutDimCode(3,NewShortcutDimCode[3]);
//                     end;

//                     trigger OnValidate()
//                     begin
//                         TESTFIELD("Entry Type","Entry Type"::Transfer);
//                         ValidateNewShortcutDimCode(3,NewShortcutDimCode[3]);
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
//                 field(NewShortcutDimCode[4];NewShortcutDimCode[4])
//                 {
//                     CaptionClass = Text001;
//                     Visible = false;

//                     trigger OnLookup(var Text: Text): Boolean
//                     begin
//                         LookupNewShortcutDimCode(4,NewShortcutDimCode[4]);
//                     end;

//                     trigger OnValidate()
//                     begin
//                         TESTFIELD("Entry Type","Entry Type"::Transfer);
//                         ValidateNewShortcutDimCode(4,NewShortcutDimCode[4]);
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
//                 field(NewShortcutDimCode[5];NewShortcutDimCode[5])
//                 {
//                     CaptionClass = Text002;
//                     Visible = false;

//                     trigger OnLookup(var Text: Text): Boolean
//                     begin
//                         LookupNewShortcutDimCode(5,NewShortcutDimCode[5]);
//                     end;

//                     trigger OnValidate()
//                     begin
//                         TESTFIELD("Entry Type","Entry Type"::Transfer);
//                         ValidateNewShortcutDimCode(5,NewShortcutDimCode[5]);
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
//                 field(NewShortcutDimCode[6];NewShortcutDimCode[6])
//                 {
//                     CaptionClass = Text003;
//                     Visible = false;

//                     trigger OnLookup(var Text: Text): Boolean
//                     begin
//                         LookupNewShortcutDimCode(6,NewShortcutDimCode[6]);
//                     end;

//                     trigger OnValidate()
//                     begin
//                         TESTFIELD("Entry Type","Entry Type"::Transfer);
//                         ValidateNewShortcutDimCode(6,NewShortcutDimCode[6]);
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
//                 field(NewShortcutDimCode[7];NewShortcutDimCode[7])
//                 {
//                     CaptionClass = Text004;
//                     Visible = false;

//                     trigger OnLookup(var Text: Text): Boolean
//                     begin
//                         LookupNewShortcutDimCode(7,NewShortcutDimCode[7]);
//                     end;

//                     trigger OnValidate()
//                     begin
//                         TESTFIELD("Entry Type","Entry Type"::Transfer);
//                         ValidateNewShortcutDimCode(7,NewShortcutDimCode[7]);
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
//                 field(NewShortcutDimCode[8];NewShortcutDimCode[8])
//                 {
//                     CaptionClass = Text005;
//                     Visible = false;

//                     trigger OnLookup(var Text: Text): Boolean
//                     begin
//                         LookupNewShortcutDimCode(8,NewShortcutDimCode[8]);
//                     end;

//                     trigger OnValidate()
//                     begin
//                         TESTFIELD("Entry Type","Entry Type"::Transfer);
//                         ValidateNewShortcutDimCode(8,NewShortcutDimCode[8]);
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
//                     Visible = false;
//                 }
//                 field("New Location Code";"New Location Code")
//                 {
//                     Visible = false;

//                     trigger OnValidate()
//                     var
//                         WMSManagement: Codeunit "7302";
//                     begin
//                         WMSManagement.CheckItemJnlLineLocation(Rec,xRec);
//                     end;
//                 }
//                 field("New Bin Code";"New Bin Code")
//                 {
//                     Visible = false;
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
//                     Visible = false;
//                 }
//                 field(Amount;Amount)
//                 {
//                     Visible = false;
//                 }
//                 field("Indirect Cost %";"Indirect Cost %")
//                 {
//                     Visible = false;
//                 }
//                 field("Unit Cost";"Unit Cost")
//                 {
//                     Visible = false;
//                 }
//                 field("Applies-to Entry";"Applies-to Entry")
//                 {
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
//                         ShowReclasDimensions;
//                         CurrPage.SAVERECORD;
//                     end;
//                 }
//                 action("Item &Tracking Lines")
//                 {
//                     Caption = 'Item &Tracking Lines';
//                     Image = ItemTrackingLines;
//                     ShortCutKey = 'Shift+Ctrl+I';

//                     trigger OnAction()
//                     begin
//                         OpenItemTrackingLines(TRUE);
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
//                     RunObject = Codeunit 246;
//                 }
//                 separator()
//                 {
//                 }
//                 action("Get Bin Content")
//                 {
//                     Caption = 'Get Bin Content';
//                     Ellipsis = true;
//                     Image = GetBinContent;

//                     trigger OnAction()
//                     var
//                         BinContent: Record "7302";
//                         GetBinContent: Report "7391";
//                     begin
//                         BinContent.SETRANGE("Location Code","Location Code");
//                         GetBinContent.SETTABLEVIEW(BinContent);
//                         GetBinContent.InitializeItemJournalLine(Rec);
//                         GetBinContent.RUNMODAL;
//                         CurrPage.UPDATE(FALSE);
//                     end;
//                 }
//                 action("Generate Line")
//                 {
//                     Image = CreateWarehousePick;
//                     Promoted = true;
//                     PromotedCategory = Process;
//                     PromotedIsBig = true;

//                     trigger OnAction()
//                     var
//                         r50016: Report "50016";
//                     begin
//                         CLEAR(r50016);
//                         r50016.SetParameter(CurrentJnlBatchName);
//                         r50016.RUN;
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
//         }
//     }

//     trigger OnAfterGetCurrRecord()
//     begin
//         ItemJnlMgt.GetItem("Item No.",ItemDescription);
//     end;

//     trigger OnAfterGetRecord()
//     begin
//         ShowShortcutDimCode(ShortcutDimCode);
//         ShowNewShortcutDimCode(NewShortcutDimCode);
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

//     trigger OnNewRecord(BelowxRec: Boolean)
//     begin
//         SetUpNewLine(xRec);
//         CLEAR(ShortcutDimCode);
//         CLEAR(NewShortcutDimCode);
//         "Entry Type" := "Entry Type"::Transfer;
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
//         ItemJnlMgt.TemplateSelection(PAGE::"Item Reclass. Journal",1,FALSE,Rec,JnlSelected);
//         IF NOT JnlSelected THEN
//           ERROR('');
//         ItemJnlMgt.OpenJnl(CurrentJnlBatchName,Rec);
//     end;

//     var
//         Text000: Label '1,2,3,New ';
//         Text001: Label '1,2,4,New ';
//         Text002: Label '1,2,5,New ';
//         Text003: Label '1,2,6,New ';
//         Text004: Label '1,2,7,New ';
//         Text005: Label '1,2,8,New ';
//         ItemJnlMgt: Codeunit "240";
//         ReportPrint: Codeunit "228";
//         ItemAvailFormsMgt: Codeunit "353";
//         CurrentJnlBatchName: Code[10];
//         ItemDescription: Text[50];
//         ShortcutDimCode: array [8] of Code[20];
//         NewShortcutDimCode: array [8] of Code[20];
//         OpenedFromBatch: Boolean;

//     local procedure CurrentJnlBatchNameOnAfterVali()
//     begin
//         CurrPage.SAVERECORD;
//         ItemJnlMgt.SetName(CurrentJnlBatchName,Rec);
//         CurrPage.UPDATE(FALSE);
//     end;
// }

