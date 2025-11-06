// page 5740 "Transfer Order"
// {
//     // TJCSG1.00
//     // NAV 2013 R2 Upgrade.
//     // Last Changes: 30/06/2014.
//     //  1. 18.02.2010  DP.HERRY
//     //     - If Status = 'RELEASED', prompt a message when click Auto Assign Lot No
//     //  2  27/01/2011  dp.ds
//     //     - Created new menu item Functions->Create Transfer Lines to automatically generate transfer
//     //       order lines from Item card.
//     //  3. 07/04/2014 DP.JL DD#86
//     //     - Temp commented out report

//     Caption = 'Transfer Order';
//     PageType = Document;
//     RefreshOnActivate = true;
//     SourceTable = Table5740;

//     layout
//     {
//         area(content)
//         {
//             group(General)
//             {
//                 Caption = 'General';
//                 field("No.";"No.")
//                 {
//                     Importance = Promoted;

//                     trigger OnAssistEdit()
//                     begin
//                         IF AssistEdit(xRec) THEN
//                           CurrPage.UPDATE;
//                     end;
//                 }
//                 field("Transfer-from Code";"Transfer-from Code")
//                 {
//                     Importance = Promoted;
//                 }
//                 field("Transfer-to Code";"Transfer-to Code")
//                 {
//                     Importance = Promoted;
//                 }
//                 field("In-Transit Code";"In-Transit Code")
//                 {
//                 }
//                 field("Posting Date";"Posting Date")
//                 {

//                     trigger OnValidate()
//                     begin
//                         PostingDateOnAfterValidate;
//                     end;
//                 }
//                 field("Shortcut Dimension 1 Code";"Shortcut Dimension 1 Code")
//                 {
//                 }
//                 field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
//                 {
//                 }
//                 field("Assigned User ID";"Assigned User ID")
//                 {
//                 }
//                 field("External Document No.";"External Document No.")
//                 {
//                 }
//                 field(Status;Status)
//                 {
//                     Importance = Promoted;
//                 }
//             }
//             part(TransferLines;5741)
//             {
//                 SubPageLink = Document No.=FIELD(No.),
//                               Derived From Line No.=CONST(0);
//             }
//             group("Transfer-from")
//             {
//                 Caption = 'Transfer-from';
//                 field("Transfer-from Name";"Transfer-from Name")
//                 {
//                 }
//                 field("Transfer-from Name 2";"Transfer-from Name 2")
//                 {
//                 }
//                 field("Transfer-from Address";"Transfer-from Address")
//                 {
//                 }
//                 field("Transfer-from Address 2";"Transfer-from Address 2")
//                 {
//                 }
//                 field("Transfer-from Post Code";"Transfer-from Post Code")
//                 {
//                 }
//                 field("Transfer-from City";"Transfer-from City")
//                 {
//                 }
//                 field("Transfer-from Contact";"Transfer-from Contact")
//                 {
//                 }
//                 field("Shipment Date";"Shipment Date")
//                 {
//                     Importance = Promoted;

//                     trigger OnValidate()
//                     begin
//                         ShipmentDateOnAfterValidate;
//                     end;
//                 }
//                 field("Outbound Whse. Handling Time";"Outbound Whse. Handling Time")
//                 {

//                     trigger OnValidate()
//                     begin
//                         OutboundWhseHandlingTimeOnAfte;
//                     end;
//                 }
//                 field("Shipment Method Code";"Shipment Method Code")
//                 {
//                 }
//                 field("Shipping Agent Code";"Shipping Agent Code")
//                 {
//                     Importance = Promoted;

//                     trigger OnValidate()
//                     begin
//                         ShippingAgentCodeOnAfterValida;
//                     end;
//                 }
//                 field("Shipping Agent Service Code";"Shipping Agent Service Code")
//                 {

//                     trigger OnValidate()
//                     begin
//                         ShippingAgentServiceCodeOnAfte;
//                     end;
//                 }
//                 field("Shipping Time";"Shipping Time")
//                 {

//                     trigger OnValidate()
//                     begin
//                         ShippingTimeOnAfterValidate;
//                     end;
//                 }
//                 field("Shipping Advice";"Shipping Advice")
//                 {
//                     Importance = Promoted;

//                     trigger OnValidate()
//                     begin
//                         IF "Shipping Advice" <> xRec."Shipping Advice" THEN
//                           IF NOT CONFIRM(Text000,FALSE,FIELDCAPTION("Shipping Advice")) THEN
//                             ERROR('');
//                     end;
//                 }
//             }
//             group("Transfer-to")
//             {
//                 Caption = 'Transfer-to';
//                 field("Transfer-to Name";"Transfer-to Name")
//                 {
//                 }
//                 field("Transfer-to Name 2";"Transfer-to Name 2")
//                 {
//                 }
//                 field("Transfer-to Address";"Transfer-to Address")
//                 {
//                 }
//                 field("Transfer-to Address 2";"Transfer-to Address 2")
//                 {
//                 }
//                 field("Transfer-to Post Code";"Transfer-to Post Code")
//                 {
//                 }
//                 field("Transfer-to City";"Transfer-to City")
//                 {
//                 }
//                 field("Transfer-to Contact";"Transfer-to Contact")
//                 {
//                 }
//                 field("Receipt Date";"Receipt Date")
//                 {

//                     trigger OnValidate()
//                     begin
//                         ReceiptDateOnAfterValidate;
//                     end;
//                 }
//                 field("Inbound Whse. Handling Time";"Inbound Whse. Handling Time")
//                 {

//                     trigger OnValidate()
//                     begin
//                         InboundWhseHandlingTimeOnAfter;
//                     end;
//                 }
//             }
//             group("Foreign Trade")
//             {
//                 Caption = 'Foreign Trade';
//                 field("Transaction Type";"Transaction Type")
//                 {
//                     Importance = Promoted;
//                 }
//                 field("Transaction Specification";"Transaction Specification")
//                 {
//                 }
//                 field("Transport Method";"Transport Method")
//                 {
//                     Importance = Promoted;
//                 }
//                 field(Area;Area)
//                 {
//                 }
//                 field("Entry/Exit Point";"Entry/Exit Point")
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
//                 Visible = true;
//             }
//         }
//     }

//     actions
//     {
//         area(navigation)
//         {
//             group("O&rder")
//             {
//                 Caption = 'O&rder';
//                 Image = "Order";
//                 action(Statistics)
//                 {
//                     Caption = 'Statistics';
//                     Image = Statistics;
//                     Promoted = true;
//                     PromotedCategory = Process;
//                     RunObject = Page 5755;
//                     RunPageLink = No.=FIELD(No.);
//                     ShortCutKey = 'F7';
//                 }
//                 action("Co&mments")
//                 {
//                     Caption = 'Co&mments';
//                     Image = ViewComments;
//                     RunObject = Page 5750;
//                     RunPageLink = Document Type=CONST(Transfer Order),
//                                   No.=FIELD(No.);
//                 }
//                 action(Dimensions)
//                 {
//                     Caption = 'Dimensions';
//                     Image = Dimensions;
//                     ShortCutKey = 'Shift+Ctrl+D';

//                     trigger OnAction()
//                     begin
//                         ShowDocDim;
//                         CurrPage.SAVERECORD;
//                     end;
//                 }
//             }
//             group(Documents)
//             {
//                 Caption = 'Documents';
//                 Image = Documents;
//                 action("S&hipments")
//                 {
//                     Caption = 'S&hipments';
//                     Image = Shipment;
//                     RunObject = Page 5752;
//                     RunPageLink = Transfer Order No.=FIELD(No.);
//                 }
//                 action("Re&ceipts")
//                 {
//                     Caption = 'Re&ceipts';
//                     Image = PostedReceipts;
//                     RunObject = Page 5753;
//                     RunPageLink = Transfer Order No.=FIELD(No.);
//                 }
//             }
//             group(Warehouse)
//             {
//                 Caption = 'Warehouse';
//                 Image = Warehouse;
//                 action("Whse. Shi&pments")
//                 {
//                     Caption = 'Whse. Shi&pments';
//                     Image = Shipment;
//                     RunObject = Page 7341;
//                     RunPageLink = Source Type=CONST(5741),
//                                   Source Subtype=CONST(0),
//                                   Source No.=FIELD(No.);
//                     RunPageView = SORTING(Source Type,Source Subtype,Source No.,Source Line No.);
//                 }
//                 action("&Whse. Receipts")
//                 {
//                     Caption = '&Whse. Receipts';
//                     Image = Receipt;
//                     RunObject = Page 7342;
//                     RunPageLink = Source Type=CONST(5741),
//                                   Source Subtype=CONST(1),
//                                   Source No.=FIELD(No.);
//                     RunPageView = SORTING(Source Type,Source Subtype,Source No.,Source Line No.);
//                 }
//                 action("In&vt. Put-away/Pick Lines")
//                 {
//                     Caption = 'In&vt. Put-away/Pick Lines';
//                     Image = PickLines;
//                     RunObject = Page 5774;
//                     RunPageLink = Source Document=FILTER(Inbound Transfer|Outbound Transfer),
//                                   Source No.=FIELD(No.);
//                     RunPageView = SORTING(Source Document,Source No.,Location Code);
//                 }
//             }
//         }
//         area(processing)
//         {
//             action("&Print")
//             {
//                 Caption = '&Print';
//                 Ellipsis = true;
//                 Image = Print;
//                 Promoted = true;
//                 PromotedCategory = Process;

//                 trigger OnAction()
//                 var
//                     DocPrint: Codeunit "229";
//                 begin
//                     DocPrint.PrintTransferHeader(Rec);
//                 end;
//             }
//             action("Transfer Order TJC")
//             {
//                 Caption = 'Transfer Order TJC';
//                 Image = "Report";
//                 Promoted = true;
//                 PromotedCategory = Process;

//                 trigger OnAction()
//                 begin
//                     recTransferHeader.RESET;
//                     recTransferHeader.SETRANGE("No.","No.");
//                     IF recTransferHeader.FINDFIRST THEN
//                       REPORT.RUNMODAL(50037,TRUE,FALSE,recTransferHeader);
//                 end;
//             }
//             group(Release)
//             {
//                 Caption = 'Release';
//                 Image = ReleaseDoc;
//                 action("Re&lease")
//                 {
//                     Caption = 'Re&lease';
//                     Image = ReleaseDoc;
//                     Promoted = true;
//                     PromotedCategory = Process;
//                     RunObject = Codeunit 5708;
//                     ShortCutKey = 'Ctrl+F9';
//                 }
//                 action("Reo&pen")
//                 {
//                     Caption = 'Reo&pen';
//                     Image = ReOpen;
//                     Promoted = true;
//                     PromotedCategory = Process;

//                     trigger OnAction()
//                     var
//                         ReleaseTransferDoc: Codeunit "5708";
//                     begin
//                         ReleaseTransferDoc.Reopen(Rec);
//                     end;
//                 }
//                 action("Auto Assign Lot No")
//                 {
//                     Caption = 'Auto Assign Lot No';
//                     Image = ReOpen;
//                     Promoted = true;
//                     PromotedCategory = Process;

//                     trigger OnAction()
//                     var
//                         TransLine: Record "5741";
//                         LCanAssign: Boolean;
//                     begin
//                         LCanAssign := TRUE;

//                         /*START: #1  DP.HERRY*/
//                         /*
//                         TransLine.SETRANGE("Document No.","No.");
//                         IF TransLine.FIND('-') THEN
//                           IF (TransLine."Quantity Shipped" > TransLine."Qty. to Ship") THEN
//                                  MESSAGE('Cannot Auto Assign Lot No. for the item '+TransLine."Item No.")
//                           ELSE BEGIN
//                                   AssignAllLotNo("No.");
//                                   MESSAGE('Auto assign finished.');
//                           END;
//                         */
//                         /*END: #1  DP.HERRY*/

//                         TransLine.RESET;
//                         TransLine.SETRANGE("Document No.","No.");
//                         IF TransLine.FINDFIRST THEN
//                           REPEAT
//                             IF (TransLine."Qty. to Ship"=0) THEN BEGIN
//                                    MESSAGE('Cannot Auto Assign Lot No. for the item '+TransLine."Item No.");
//                                    LCanAssign := FALSE;
//                             END;
//                           UNTIL TransLine.NEXT=0;

//                         IF LCanAssign = TRUE THEN BEGIN
//                           AssignAllLotNo("No.");
//                           MESSAGE('Auto assign finished.');
//                         END ELSE
//                           MESSAGE('Auto assign cannot be finished.');

//                     end;
//                 }
//                 action("Create Transfer Lines")
//                 {
//                     Caption = 'Create Transfer Lines';
//                     Image = ReOpen;
//                     Promoted = true;
//                     PromotedCategory = Process;

//                     trigger OnAction()
//                     var
//                         LCreateTrfLines: Report "50005";
//                     begin
//                         // Start: TJCSG1.00 #1
//                         IF NOT CONFIRM(TJCSG_Text000,FALSE) THEN
//                           EXIT;

//                         CLEAR(LCreateTrfLines);
//                         LCreateTrfLines.GetTransferOrderNo("No.");
//                         LCreateTrfLines.RUNMODAL;
//                         // End: TJCSG1.00 #1
//                     end;
//                 }
//             }
//             group("F&unctions")
//             {
//                 Caption = 'F&unctions';
//                 Image = "Action";
//                 action("Create Whse. S&hipment")
//                 {
//                     Caption = 'Create Whse. S&hipment';
//                     Image = NewShipment;

//                     trigger OnAction()
//                     var
//                         GetSourceDocOutbound: Codeunit "5752";
//                     begin
//                         GetSourceDocOutbound.CreateFromOutbndTransferOrder(Rec);
//                     end;
//                 }
//                 action("Create &Whse. Receipt")
//                 {
//                     Caption = 'Create &Whse. Receipt';
//                     Image = NewReceipt;

//                     trigger OnAction()
//                     var
//                         GetSourceDocInbound: Codeunit "5751";
//                     begin
//                         GetSourceDocInbound.CreateFromInbndTransferOrder(Rec);
//                     end;
//                 }
//                 action("Create Inventor&y Put-away / Pick")
//                 {
//                     Caption = 'Create Inventor&y Put-away / Pick';
//                     Ellipsis = true;
//                     Image = CreateInventoryPickup;

//                     trigger OnAction()
//                     begin
//                         CreateInvtPutAwayPick;
//                     end;
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
//                         BinContent.SETRANGE("Location Code","Transfer-from Code");
//                         GetBinContent.SETTABLEVIEW(BinContent);
//                         GetBinContent.InitializeTransferHeader(Rec);
//                         GetBinContent.RUNMODAL;
//                     end;
//                 }
//             }
//             group("P&osting")
//             {
//                 Caption = 'P&osting';
//                 Image = Post;
//                 action("P&ost")
//                 {
//                     Caption = 'P&ost';
//                     Ellipsis = true;
//                     Image = PostOrder;
//                     Promoted = true;
//                     PromotedCategory = Process;
//                     PromotedIsBig = true;
//                     RunObject = Codeunit 5706;
//                     ShortCutKey = 'F9';
//                 }
//                 action("Post and &Print")
//                 {
//                     Caption = 'Post and &Print';
//                     Image = PostPrint;
//                     Promoted = true;
//                     PromotedCategory = Process;
//                     PromotedIsBig = true;
//                     RunObject = Codeunit 5707;
//                     ShortCutKey = 'Shift+F9';
//                 }
//             }
//         }
//         area(reporting)
//         {
//             action("Inventory - Inbound Transfer")
//             {
//                 Caption = 'Inventory - Inbound Transfer';
//                 Image = "Report";
//                 Promoted = true;
//                 PromotedCategory = "Report";
//                 RunObject = Report 5702;
//             }
//         }
//     }

//     trigger OnDeleteRecord(): Boolean
//     begin
//         TESTFIELD(Status,Status::Open);
//     end;

//     var
//         Text000: Label 'Do you want to change %1 in all related records in the warehouse?';
//         TJCSG_Text000: Label 'Are you sure you wish to create Transfer Order lines automatically?';
//         recTransferHeader: Record "5740";

//     procedure AssignAllLotNo(No: Text[30])
//     var
//         T_TransferLine: Record "5741";
//         ItemTrackingMgmt: Codeunit "6500";
//     begin
//             T_TransferLine.RESET;
//         T_TransferLine.SETRANGE("Document No." , No);
//         IF T_TransferLine.FIND('-') THEN
//         REPEAT
//         IF T_TransferLine."Item No." <> '' THEN
//         BEGIN
//             T_TransferLine.TESTFIELD("Quantity (Base)");
//             T_TransferLine.TESTFIELD("Unit of Measure");
//             //T_TransferLine.TESTFIELD("Transfer-from Bin Code");
//            // T_TransferLine.TESTFIELD("Transfer-To Bin Code");

//             ItemTrackingMgmt.AutoAssignTransferAllLotNo(T_TransferLine);
//         END;
//         UNTIL T_TransferLine.NEXT = 0;
//     end;

//     local procedure PostingDateOnAfterValidate()
//     begin
//         CurrPage.TransferLines.PAGE.UpdateForm(TRUE);
//     end;

//     local procedure ShipmentDateOnAfterValidate()
//     begin
//         CurrPage.TransferLines.PAGE.UpdateForm(TRUE);
//     end;

//     local procedure ShippingAgentServiceCodeOnAfte()
//     begin
//         CurrPage.TransferLines.PAGE.UpdateForm(TRUE);
//     end;

//     local procedure ShippingAgentCodeOnAfterValida()
//     begin
//         CurrPage.TransferLines.PAGE.UpdateForm(TRUE);
//     end;

//     local procedure ShippingTimeOnAfterValidate()
//     begin
//         CurrPage.TransferLines.PAGE.UpdateForm(TRUE);
//     end;

//     local procedure OutboundWhseHandlingTimeOnAfte()
//     begin
//         CurrPage.TransferLines.PAGE.UpdateForm(TRUE);
//     end;

//     local procedure ReceiptDateOnAfterValidate()
//     begin
//         CurrPage.TransferLines.PAGE.UpdateForm(TRUE);
//     end;

//     local procedure InboundWhseHandlingTimeOnAfter()
//     begin
//         CurrPage.TransferLines.PAGE.UpdateForm(TRUE);
//     end;
// }

