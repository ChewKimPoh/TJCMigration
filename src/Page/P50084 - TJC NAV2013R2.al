// page 50084 "Patient Medical History List"
// {
//     // Version No.         : TJCSG1.00
//     // Developer           : DP.AYD
//     // Init. DEV. Date     : 27/6/2014
//     // Date of last Change : 27/6/2014
//     // Description         : Based on DD#166

//     AutoSplitKey = true;
//     Caption = 'Lines';
//     DelayedInsert = true;
//     LinksAllowed = false;
//     MultipleNewLines = true;
//     PageType = ListPart;
//     ShowFilter = false;
//     SourceTable = Table50004;
//     SourceTableView = SORTING(Contact No.,History No.,Line No.)
//                       ORDER(Ascending);

//     layout
//     {
//         area(content)
//         {
//             repeater(Group)
//             {
//                 field("Contact No.";"Contact No.")
//                 {
//                     Visible = false;
//                 }
//                 field("History No.";"History No.")
//                 {
//                     Visible = false;
//                 }
//                 field("Line No.";"Line No.")
//                 {
//                     Visible = false;
//                 }
//                 field("Clinic Item Category Code";"Clinic Item Category Code")
//                 {
//                     Visible = false;
//                 }
//                 field("Clinic Product Category Code";"Clinic Product Category Code")
//                 {
//                     Visible = false;
//                 }
//                 field("Medicine Code";"Medicine Code")
//                 {
//                     TableRelation = Item.No. WHERE (Clinic Item Category Code=FIELD(Clinic Item Category Code),
//                                                     Clinic Product Category Code=FIELD(Clinic Product Category Code));

//                     trigger OnLookup(var Text: Text): Boolean
//                     var
//                         rItem: Record "27";
//                         MedicineList: Page "50024";
//                     begin
//                         rItem.RESET;
//                         CLEAR(MedicineList);
//                         IF ("Clinic Item Category Code"='') AND ("Clinic Product Category Code" ='') THEN BEGIN
//                         END
//                         ELSE BEGIN
//                           rItem.SETRANGE("Clinic Item Category Code","Clinic Item Category Code");
//                           rItem.SETRANGE("Clinic Product Category Code","Clinic Product Category Code");
//                         END;
//                         MedicineList.SETTABLEVIEW(rItem);
//                         MedicineList.LOOKUPMODE(TRUE);
//                         IF MedicineList.RUNMODAL = ACTION::LookupOK THEN BEGIN
//                           MedicineList.GETRECORD(rItem);
//                           VALIDATE("Medicine Code", rItem."No.");
//                         END;
//                     end;

//                     trigger OnValidate()
//                     var
//                         isInvValueZero: Boolean;
//                         linefound: Boolean;
//                     begin
//                         isInvValueZero := TRUE;
//                         IF rItem.GET("Medicine Code") THEN
//                           isInvValueZero := rItem."Inventory Value Zero";
//                         IF (NOT isInvValueZero) AND (Qty = 0) THEN BEGIN
//                           linefound := FALSE;
//                           rMedHistLine.SETRANGE("Contact No.","Contact No.");
//                           rMedHistLine.SETRANGE("History No.","History No.");
//                           rMedHistLine.ASCENDING(FALSE);
//                           IF rMedHistLine.FINDFIRST THEN REPEAT
//                             IF rItem.GET(rMedHistLine."Medicine Code") THEN
//                               linefound := NOT rItem."Inventory Value Zero";
//                             IF linefound THEN BEGIN
//                               //"Dosage Per Time" := rMedHistLine."Dosage Per Time";
//                               "Times Per Day" := rMedHistLine."Times Per Day";
//                               "How Many Days" := rMedHistLine."How Many Days";
//                               Multiply := rMedHistLine.Multiply;
//                               CalcQty;
//                             END;
//                           UNTIL (rMedHistLine.NEXT = 0) OR linefound;
//                         END;
//                     end;
//                 }
//                 field("Medicine Name";"Medicine Name")
//                 {
//                 }
//                 field("Dosage Per Time";"Dosage Per Time")
//                 {
//                 }
//                 field("Dosage UOM";"Dosage UOM")
//                 {
//                 }
//                 field("Times Per Day";"Times Per Day")
//                 {
//                 }
//                 field(BarCode;BarCode)
//                 {
//                 }
//                 field("How Many Days";"How Many Days")
//                 {
//                 }
//                 field(Multiply;Multiply)
//                 {
//                 }
//                 field(Qty;Qty)
//                 {
//                 }
//                 field("Duration Hour";"Duration Hour")
//                 {
//                 }
//                 field("When To Take";"When To Take")
//                 {
//                 }
//                 field(Remark;Remark)
//                 {
//                 }
//             }
//         }
//     }

//     actions
//     {
//         area(processing)
//         {
//             action(MedicineSticker)
//             {
//                 Caption = 'Medicine &Sticker';
//                 Image = PrintDocument;
//                 Visible = false;

//                 trigger OnAction()
//                 var
//                     PPDetail: Record "50004";
//                     Medicine: Report "50030";
//                 begin
//                     PPDetail.RESET;
//                     PPDetail.SETRANGE("Contact No.","Contact No.");
//                     PPDetail.SETRANGE(PPDetail."History No.","History No.");
//                     Medicine.SETTABLEVIEW(PPDetail);
//                     Medicine.RUN;
//                 end;
//             }
//             action(CopyMedicine)
//             {
//                 Caption = '&Copy Medicine';
//                 Image = Copy;
//                 Visible = false;

//                 trigger OnAction()
//                 var
//                     CopyMedicine: Report "50031";
//                 begin
//                     CopyMedicine.SetValue("Contact No.","History No.");
//                     CopyMedicine.RUN;
//                 end;
//             }
//         }
//     }

//     trigger OnDeleteRecord(): Boolean
//     var
//         ReserveSalesLine: Codeunit "99000832";
//     begin
//     end;

//     trigger OnNewRecord(BelowxRec: Boolean)
//     var
//         UserSetup: Record "91";
//     begin
//         IF UserSetup.GET(USERID) THEN
//           "Location Code":=UserSetup."Location Code";
//     end;

//     var
//         Text012: Label 'Change %1 from %2 to %3?';
//         HistoryNo: Integer;
//         Item: Record "27";
//         ItemAvailByDate: Page "157";
//         ItemAvailByVar: Page "5414";
//         ItemAvailByLoc: Page "492";
//         rMedHistLine: Record "50004";
//         rItem: Record "27";

//     procedure SetRecord(pHistoryNo: Integer)
//     begin
//         SETRANGE("History No.", pHistoryNo);
//         HistoryNo := pHistoryNo;
//     end;

//     procedure CalcAvailability(var pMedicine: Record "50004"): Decimal
//     var
//         AvailableToPromise: Codeunit "5790";
//         rItem: Record "27";
//         GrossRequirement: Decimal;
//         ScheduledReceipt: Decimal;
//         PeriodType: Option Day,Week,Month,Quarter,Year;
//         AvailabilityDate: Date;
//         LookaheadDateformula: DateFormula;
//     begin
//         IF Item.GET(pMedicine."Medicine Code") THEN BEGIN
//           AvailabilityDate := WORKDATE;

//           Item.RESET;
//           Item.SETRANGE("Date Filter",0D,AvailabilityDate);

//           Item.SETRANGE("Location Filter",pMedicine."Location Code");
//           Item.SETRANGE("Drop Shipment Filter",FALSE);

//           EXIT(
//             AvailableToPromise.QtyAvailabletoPromise(
//               Item,
//               GrossRequirement,
//               ScheduledReceipt,
//               AvailabilityDate,
//               PeriodType,
//               LookaheadDateformula));
//         END;
//     end;

//     procedure ItemCommentExists(pMedicine: Record "50004"): Boolean
//     begin
//         IF Item.GET(pMedicine."Medicine Code") THEN BEGIN
//           Item.CALCFIELDS(Comment);
//           EXIT(Item.Comment);
//         END;
//     end;

//     procedure LookupItemComment(pMedicine: Record "50004")
//     var
//         CommentLine: Record "97";
//     begin
//         IF Item.GET("Medicine Code") THEN BEGIN
//           CommentLine.SETRANGE("Table Name",CommentLine."Table Name"::Item);
//           CommentLine.SETRANGE("No.",pMedicine."Medicine Code");
//           PAGE.RUNMODAL(PAGE::"Comment Sheet",CommentLine);
//         END;
//     end;

//     procedure LookupItem(pMedicine: Record "50004")
//     begin
//         pMedicine.TESTFIELD("Medicine Code");

//         Item.GET("Medicine Code");
//         PAGE.RUNMODAL(PAGE::"Item Card",Item);
//     end;

//     procedure ItemAvailability(AvailabilityType: Option Date,Variant,Location,Bin)
//     begin
//         CASE AvailabilityType OF
//           AvailabilityType::Date:
//             BEGIN
//               Item.SETRANGE("Location Filter","Location Code");
//               CLEAR(ItemAvailByDate);
//               ItemAvailByDate.LOOKUPMODE(TRUE);
//               ItemAvailByDate.SETRECORD(Item);
//               ItemAvailByDate.SETTABLEVIEW(Item);
//               IF ItemAvailByDate.RUNMODAL = ACTION::LookupOK THEN
//                 IF TODAY <> ItemAvailByDate.GetLastDate THEN
//                   IF CONFIRM(
//                        Text012,TRUE,'Visist Day',TODAY,
//                        ItemAvailByDate.GetLastDate)
//                   THEN;
//             END;
//         END;
//     end;
// }

