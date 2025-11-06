// page 392 "Phys. Inventory Journal"
// {
//     // TCJSG1.00 Upgrade
//     //   1. 07/04/2014 DP.JL DD#86
//     //     - Temp COmmented out report
//     //       NameDataTypeSubtypeLength
//     //       CalcQtyOnHandByLotNoReportReport50003

//     AutoSplitKey = true;
//     Caption = 'Phys. Inventory Journal';
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
//                 field("Entry Type";"Entry Type")
//                 {
//                     OptionCaption = 'Purchase,Sale,Positive Adjmt.,Negative Adjmt.';
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
//                     end;
//                 }
//                 field("Variant Code";"Variant Code")
//                 {
//                     Visible = false;
//                 }
//                 field(Description;Description)
//                 {
//                 }
//                 field("Lot No.";"Lot No.")
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
//                         /*START TJCSG1.00 #1*/
//                         //NameDataTypeSubtypeLength
//                         //BIZLayerCodeunitCodeunit50002
//                         //WMSManagement.CheckItemJnlLineLocation(Rec,xRec);
//                         /*END TJCSG1.00 #1*/

//                     end;
//                 }
//                 field("Bin Code";"Bin Code")
//                 {
//                     Visible = false;
//                 }
//                 field("Salespers./Purch. Code";"Salespers./Purch. Code")
//                 {
//                 }
//                 field("Gen. Bus. Posting Group";"Gen. Bus. Posting Group")
//                 {
//                     Visible = false;
//                 }
//                 field("Gen. Prod. Posting Group";"Gen. Prod. Posting Group")
//                 {
//                     Visible = false;
//                 }
//                 field("Qty. (Calculated)";"Qty. (Calculated)")
//                 {
//                 }
//                 field("Qty. (Phys. Inventory)";"Qty. (Phys. Inventory)")
//                 {
//                 }
//                 field(Quantity;Quantity)
//                 {
//                     Editable = false;
//                 }
//                 field("Unit of Measure Code";"Unit of Measure Code")
//                 {
//                     Visible = false;
//                 }
//                 field("Unit Amount";"Unit Amount")
//                 {
//                 }
//                 field(Amount;Amount)
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
//                     Promoted = true;
//                     PromotedCategory = Process;
//                     ShortCutKey = 'Shift+Ctrl+D';

//                     trigger OnAction()
//                     begin
//                         ShowDimensions;
//                         CurrPage.SAVERECORD;
//                     end;
//                 }
//                 action("Item &Tracking Lines")
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
//                     Image = CustomerLedger;
//                     Promoted = false;
//                     //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
//                     //PromotedCategory = Process;
//                     RunObject = Page 38;
//                     RunPageLink = Item No.=FIELD(Item No.);
//                     RunPageView = SORTING(Item No.);
//                     ShortCutKey = 'Ctrl+F7';
//                 }
//                 action("Phys. In&ventory Ledger Entries")
//                 {
//                     Caption = 'Phys. In&ventory Ledger Entries';
//                     Image = PhysicalInventoryLedger;
//                     RunObject = Page 390;
//                     RunPageLink = Item No.=FIELD(Item No.);
//                     RunPageView = SORTING(Item No.);
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
//                 action(CalculateInventory)
//                 {
//                     Caption = 'Calculate &Inventory';
//                     Ellipsis = true;
//                     Image = CalculateInventory;
//                     Promoted = true;
//                     PromotedCategory = Process;

//                     trigger OnAction()
//                     begin
//                         CalcQtyOnHand.SetItemJnlLine(Rec);
//                         CalcQtyOnHand.RUNMODAL;
//                         CLEAR(CalcQtyOnHand);
//                     end;
//                 }
//                 action(CalculateCountingPeriod)
//                 {
//                     Caption = '&Calculate Counting Period';
//                     Ellipsis = true;
//                     Image = CalculateCalendar;

//                     trigger OnAction()
//                     var
//                         PhysInvtCountMgt: Codeunit "7380";
//                     begin
//                         PhysInvtCountMgt.InitFromItemJnl(Rec);
//                         PhysInvtCountMgt.RUN;
//                         CLEAR(PhysInvtCountMgt);
//                     end;
//                 }
//                 action(CalculateCountingPeriod1)
//                 {
//                     Caption = 'Calc. Invty. By Lot No.';
//                     Ellipsis = true;
//                     Image = "Action";
//                     Promoted = true;

//                     trigger OnAction()
//                     begin
//                         /*START TJCSG1.00 #1*/
//                         //CalcQtyOnHandByLotNo.SetItemJnlLine(Rec);
//                         //CalcQtyOnHandByLotNo.RUNMODAL;
//                         //CLEAR(CalcQtyOnHandByLotNo);
//                         /*END TJCSG1.00 #1*/

//                     end;
//                 }
//                 action("Compare Stock Inventory")
//                 {
//                     Caption = 'Calc. Invty. By Lot No.';
//                     Ellipsis = true;
//                     Image = "Action";
//                     Promoted = true;

//                     trigger OnAction()
//                     var
//                         "Stock Table": Record "50002";
//                         ItemJournalLine: Record "83";
//                         Inventory: Decimal;
//                     begin
//                         /*START TJCSG1.00 #1*/
//                         //BIZLayer."Compare Stock Inventory"(CurrentJnlBatchName);
//                         //CurrPage.UPDATE;
//                         /*END TJCSG1.00 #1*/

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
//                 begin
//                     ItemJournalBatch.SETRANGE("Journal Template Name","Journal Template Name");
//                     ItemJournalBatch.SETRANGE(Name,"Journal Batch Name");
//                     PhysInventoryList.SETTABLEVIEW(ItemJournalBatch);
//                     PhysInventoryList.RUNMODAL;
//                     CLEAR(PhysInventoryList);
//                 end;
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
//                 action("P&ost")
//                 {
//                     Caption = 'P&ost';
//                     Image = PostOrder;
//                     Promoted = true;
//                     PromotedCategory = Process;
//                     PromotedIsBig = true;
//                     ShortCutKey = 'F9';

//                     trigger OnAction()
//                     begin
//                                             //TJC1.00
//                                             SetLotTrackingQty(Rec);
//                                                         //TJC1.00
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
//                                             //TJC1.00
//                                             SetLotTrackingQty(Rec);
//                                                         //TJC1.00
//                         CODEUNIT.RUN(CODEUNIT::"Item Jnl.-Post+Print",Rec);
//                         CurrentJnlBatchName := GETRANGEMAX("Journal Batch Name");
//                         CurrPage.UPDATE(FALSE);
//                     end;
//                 }
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
//         ItemJnlMgt.TemplateSelection(PAGE::"Phys. Inventory Journal",2,FALSE,Rec,JnlSelected);
//         IF NOT JnlSelected THEN
//           ERROR('');
//         ItemJnlMgt.OpenJnl(CurrentJnlBatchName,Rec);
//     end;

//     var
//         ItemJournalBatch: Record "233";
//         CalcQtyOnHand: Report "790";
//         PhysInventoryList: Report "722";
//         ItemJnlMgt: Codeunit "240";
//         ReportPrint: Codeunit "228";
//         ItemAvailFormsMgt: Codeunit "353";
//         CurrentJnlBatchName: Code[10];
//         ItemDescription: Text[50];
//         ShortcutDimCode: array [8] of Code[20];
//         OpenedFromBatch: Boolean;

//     procedure SetLotTrackingQty(itemjentry: Record "83")
//     begin
//         //  CheckRec.COPYFILTERS(Rec);
//         itemjentry.SETFILTER(itemjentry.Quantity,'<>%1',0);
//         itemjentry.SETFILTER(itemjentry."Lot No.",'<>%1','');
//         IF itemjentry.FIND('-')THEN
//               BEGIN
//               REPEAT
//                 /*START TJCSG1.00 #1*/
//                 //BIZLayer.CreateReservationEntry(itemjentry);
//                 /*END TJCSG1.00 #1*/
//                 itemjentry."Lot No.":='';
//                 itemjentry.MODIFY;
//               UNTIL itemjentry.NEXT=0;
//               END;

//     end;

//     procedure CreateReservationEntry(itemjentry: Record "83")
//     var
//         "Reservation Entry": Record "337";
//         "Reservation Entry1": Record "337";
//         "Entry No": Integer;
//         Inventory: Integer;
//     begin
//         /*

//         //update lot no into reservation entry


//         "Reservation Entry".RESET;
//         "Reservation Entry".SETRANGE("Reservation Entry"."Source ID",'PHYS. INVE');
//         "Reservation Entry".SETRANGE("Reservation Entry"."Source Ref. No.","Line No.");
//         "Reservation Entry".SETRANGE("Reservation Entry"."Source Type",DATABASE::"Item Journal Line") ;

//         //030807 delete any old reservation caused by revert shipment
//         IF "Reservation Entry".FIND('-')THEN
//             "Reservation Entry".DELETE;

//             IF "Reservation Entry1".FIND('+') THEN
//                  "Entry No":="Reservation Entry1"."Entry No."+1
//             ELSE
//                  "Entry No":=1;

//               "Reservation Entry".INIT;

//               //populate fields
//              "Reservation Entry"."Entry No.":="Entry No";
//              "Reservation Entry"."Item No.":=itemjentry."Item No.";
//              "Reservation Entry"."Location Code" :=itemjentry."Location Code";
//              "Reservation Entry"."Reservation Status":="Reservation Entry"."Reservation Status"::Prospect;
//              "Reservation Entry"."Creation Date":=TODAY;
//              "Reservation Entry"."Source ID":= 'PHYS. INVE';
//              "Reservation Entry"."Source Ref. No.":=itemjentry."Line No.";
//              "Reservation Entry"."Created By":=USERID;
//              "Reservation Entry"."Qty. per Unit of Measure" :=itemjentry."Qty. per Unit of Measure";
//              "Reservation Entry"."Lot No.":=  itemjentry."Lot No.";
//              "Reservation Entry"."Source Subtype":=3;
//              "Reservation Entry"."Source Type":=DATABASE::"Item Journal Line";
//              "Reservation Entry"."Source Batch Name":=CurrentJnlBatchName;
//                 IF itemjentry."Entry Type"=itemjentry."Entry Type"::"Positive Adjmt." THEN
//                     BEGIN
//                        "Reservation Entry".Quantity:=itemjentry.Quantity;
//                        "Reservation Entry"."Quantity (Base)":=itemjentry.Quantity*itemjentry."Qty. per Unit of Measure";
//                        "Reservation Entry".VALIDATE("Quantity (Base)");
//                        "Reservation Entry".Positive:=TRUE;
//                     END
//                 ELSE
//                     BEGIN

//                        "Reservation Entry"."Shipment Date":=TODAY;
//                       "Reservation Entry".Quantity:=(-1)*itemjentry.Quantity;

//                        "Reservation Entry"."Quantity (Base)":=(-1)*itemjentry.Quantity*itemjentry."Qty. per Unit of Measure";
//                        "Reservation Entry".VALIDATE("Quantity (Base)");
//                        "Reservation Entry".Positive:=FALSE
//                     END;

//         "Reservation Entry".INSERT;

//         //END;
//         */

//     end;

//     procedure UpdateLotToReservationEntry(Type: Text[30];"Item No": Code[20];Location: Code[20];"Lot No": Code[20];Bin: Code[20];"Docu No": Code[20];"Line No": Integer;Quantity: Integer;Date: Date;QUOM: Decimal)
//     var
//         "Reservation Entry": Record "337";
//         "Entry No": Integer;
//         Inventory: Integer;
//         "Reservation Entry1": Record "337";
//     begin
//         /*
//         //call function to update location and bin code
//         //MESSAGE('PO '+"Docu No");
//         //UpdatePOLineLocationBin("Docu No",Location,Bin);


//         //update lot no into reservation entry


//         "Reservation Entry".RESET;
//         "Reservation Entry".SETRANGE("Reservation Entry"."Source ID","Docu No");
//         "Reservation Entry".SETRANGE("Reservation Entry"."Source Ref. No.","Line No");
//         IF Type='Receive' THEN
//             "Reservation Entry".SETRANGE("Reservation Entry"."Source Type",DATABASE::"Purchase Line")
//         ELSE
//             "Reservation Entry".SETRANGE("Reservation Entry"."Source Type",DATABASE::"Sales Line");

//         //030807 delete any old reservation caused by revert shipment
//         IF "Reservation Entry".FIND('-')THEN
//             "Reservation Entry".DELETE;

//         //IF NOT "Reservation Entry".FIND('-')THEN
//         //BEGIN


//             IF "Reservation Entry1".FIND('+') THEN
//                  "Entry No":="Reservation Entry1"."Entry No."+1
//             ELSE
//                  "Entry No":=1;

//               "Reservation Entry".INIT;

//               //populate fields
//              "Reservation Entry"."Entry No.":="Entry No";
//              "Reservation Entry"."Item No.":="Item No";
//              "Reservation Entry"."Location Code" :=Location;
//              "Reservation Entry"."Reservation Status":="Reservation Entry"."Reservation Status"::Surplus;
//              "Reservation Entry"."Creation Date":=TODAY;
//              "Reservation Entry"."Source ID":= "Docu No";
//              "Reservation Entry"."Source Ref. No.":="Line No";
//              "Reservation Entry"."Created By":=USERID;
//              "Reservation Entry"."Qty. per Unit of Measure" :=QUOM;
//              "Reservation Entry"."Lot No.":=  "Lot No";
//              "Reservation Entry"."Source Subtype":=1;

//                 IF Type='Receive' THEN
//                     BEGIN
//                        "Reservation Entry"."Source Type":=DATABASE::"Purchase Line";
//                        "Reservation Entry"."Expected Receipt Date":=Date;
//                        "Reservation Entry".Quantity:=Quantity;
//                        "Reservation Entry"."Quantity (Base)":=Quantity*QUOM;
//                        "Reservation Entry".VALIDATE("Quantity (Base)");
//                        "Reservation Entry".Positive:=TRUE;
//                     END
//                 ELSE
//                     BEGIN
//                        "Reservation Entry"."Source Type":=DATABASE::"Sales Line";
//                        "Reservation Entry"."Shipment Date":=Date;
//                         GetCurrentQtyByLotNoRes("Lot No",Inventory);
//                        "Reservation Entry".Quantity:=(-1)*Inventory;

//                        "Reservation Entry"."Quantity (Base)":=(-1)*Quantity*QUOM;
//                        "Reservation Entry".VALIDATE("Quantity (Base)");
//                            IF Quantity>0 THEN
//                               "Reservation Entry".Positive:=FALSE
//                            ELSE
//                                "Reservation Entry".Positive:=TRUE;
//                     END;

//         "Reservation Entry".INSERT;

//         //END;
//          */

//     end;

//     local procedure CurrentJnlBatchNameOnAfterVali()
//     begin
//         CurrPage.SAVERECORD;
//         ItemJnlMgt.SetName(CurrentJnlBatchName,Rec);
//         CurrPage.UPDATE(FALSE);
//     end;
// }

