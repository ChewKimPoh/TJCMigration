page 50084 "Patient Medical History List"
{
    // Version No.         : TJCSG1.00
    // Developer           : DP.AYD
    // Init. DEV. Date     : 27/6/2014
    // Date of last Change : 27/6/2014
    // Description         : Based on DD#166

    AutoSplitKey = true;
    Caption = 'Lines';
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = ListPart;
    ShowFilter = false;
    SourceTable = "Patient Prescription Detail";
    SourceTableView = SORTING("Contact No.", "History No.", "Line No.")
                      ORDER(Ascending);

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Contact No."; Rec."Contact No.")
                {
                    Visible = false;
                }
                field("History No."; Rec."History No.")
                {
                    Visible = false;
                }
                field("Line No."; Rec."Line No.")
                {
                    Visible = false;
                }
                field("Clinic Item Category Code"; Rec."Clinic Item Category Code")
                {
                    Visible = false;
                }
                field("Clinic Product Category Code"; Rec."Clinic Product Category Code")
                {
                    Visible = false;
                }
                field("Medicine Code"; Rec."Medicine Code")
                {
                    TableRelation = Item."No." WHERE("Clinic Item Category Code" = FIELD("Clinic Item Category Code"),
                                                    "Clinic Product Category Code" = FIELD("Clinic Product Category Code"));

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        rItem: Record Item;
                        MedicineList: Page "Medicine List";
                    begin
                        rItem.RESET;
                        CLEAR(MedicineList);
                        IF (Rec."Clinic Item Category Code" = '') AND (Rec."Clinic Product Category Code" = '') THEN BEGIN
                        END
                        ELSE BEGIN
                            rItem.SETRANGE("Clinic Item Category Code", Rec."Clinic Item Category Code");
                            rItem.SETRANGE("Clinic Product Category Code", Rec."Clinic Product Category Code");
                        END;
                        MedicineList.SETTABLEVIEW(rItem);
                        MedicineList.LOOKUPMODE(TRUE);
                        IF MedicineList.RUNMODAL = ACTION::LookupOK THEN BEGIN
                            MedicineList.GETRECORD(rItem);
                            Rec.VALIDATE("Medicine Code", rItem."No.");
                        END;
                    end;

                    trigger OnValidate()
                    var
                        isInvValueZero: Boolean;
                        linefound: Boolean;
                    begin
                        isInvValueZero := TRUE;
                        IF rItem.GET(Rec."Medicine Code") THEN
                            isInvValueZero := rItem."Inventory Value Zero";
                        IF (NOT isInvValueZero) AND (Rec.Qty = 0) THEN BEGIN
                            linefound := FALSE;
                            rMedHistLine.SETRANGE("Contact No.", Rec."Contact No.");
                            rMedHistLine.SETRANGE("History No.", Rec."History No.");
                            rMedHistLine.ASCENDING(FALSE);
                            IF rMedHistLine.FINDFIRST THEN
                                REPEAT
                                    IF rItem.GET(rMedHistLine."Medicine Code") THEN
                                        linefound := NOT rItem."Inventory Value Zero";
                                    IF linefound THEN BEGIN
                                        //"Dosage Per Time" := rMedHistLine."Dosage Per Time";
                                        Rec."Times Per Day" := rMedHistLine."Times Per Day";
                                        Rec."How Many Days" := rMedHistLine."How Many Days";
                                        Rec.Multiply := rMedHistLine.Multiply;
                                        Rec.CalcQty;
                                    END;
                                UNTIL (rMedHistLine.NEXT = 0) OR linefound;
                        END;
                    end;
                }
                field("Medicine Name"; Rec."Medicine Name")
                {
                }
                field("Dosage Per Time"; Rec."Dosage Per Time")
                {
                }
                field("Dosage UOM"; Rec."Dosage UOM")
                {
                }
                field("Times Per Day"; Rec."Times Per Day")
                {
                }
                field(BarCode; Rec.BarCode)
                {
                }
                field("How Many Days"; Rec."How Many Days")
                {
                }
                field(Multiply; Rec.Multiply)
                {
                }
                field(Qty; Rec.Qty)
                {
                }
                field("Duration Hour"; Rec."Duration Hour")
                {
                }
                field("When To Take"; Rec."When To Take")
                {
                }
                field(Remark; Rec.Remark)
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(MedicineSticker)
            {
                Caption = 'Medicine &Sticker';
                Image = PrintDocument;
                Visible = false;

                trigger OnAction()
                var
                    PPDetail: Record "Patient Prescription Detail";
                    Medicine: Report "Medicine Sticker";
                begin
                    PPDetail.RESET;
                    PPDetail.SETRANGE("Contact No.", Rec."Contact No.");
                    PPDetail.SETRANGE(PPDetail."History No.", Rec."History No.");
                    Medicine.SETTABLEVIEW(PPDetail);
                    Medicine.RUN;
                end;
            }
            action(CopyMedicine)
            {
                Caption = '&Copy Medicine';
                Image = Copy;
                Visible = false;

                trigger OnAction()
                var
                    CopyMedicine: Report "Copy Medicine";
                begin
                    CopyMedicine.SetValue(Rec."Contact No.", Rec."History No.");
                    CopyMedicine.RUN;
                end;
            }
        }
    }

    trigger OnDeleteRecord(): Boolean
    var
        ReserveSalesLine: Codeunit "Sales Line-Reserve";
    begin
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        UserSetup: Record "User Setup";
    begin
        IF UserSetup.GET(USERID) THEN
            Rec."Location Code" := UserSetup."Location Code";
    end;

    var
        Text012: Label 'Change %1 from %2 to %3?';
        HistoryNo: Integer;
        Item: Record Item;
        ItemAvailByDate: Page "Item Availability by Periods";
        ItemAvailByVar: Page "Item Availability by Variant";
        ItemAvailByLoc: Page "Item Availability by Location";
        rMedHistLine: Record "Patient Prescription Detail";
        rItem: Record Item;

    procedure SetRecord(pHistoryNo: Integer)
    begin
        Rec.SETRANGE("History No.", pHistoryNo);
        HistoryNo := pHistoryNo;
    end;

    procedure CalcAvailability(var pMedicine: Record "Patient Prescription Detail"): Decimal
    var
        AvailableToPromise: Codeunit "Available to Promise";
        rItem: Record Item;
        GrossRequirement: Decimal;
        ScheduledReceipt: Decimal;
        PeriodType: Option Day,Week,Month,Quarter,Year;
        AvailabilityDate: Date;
        LookaheadDateformula: DateFormula;
    begin
        IF Item.GET(pMedicine."Medicine Code") THEN BEGIN
            AvailabilityDate := WORKDATE;

            Item.RESET;
            Item.SETRANGE("Date Filter", 0D, AvailabilityDate);

            Item.SETRANGE("Location Filter", pMedicine."Location Code");
            Item.SETRANGE("Drop Shipment Filter", FALSE);

            // Note: QtyAvailabletoPromise procedure is BC Discontinued in AvailableToPromise codeunit
            // EXIT(
            //   AvailableToPromise.QtyAvailabletoPromise(
            //     Item,
            //     GrossRequirement,
            //     ScheduledReceipt,
            //     AvailabilityDate,
            //     PeriodType,
            //     LookaheadDateformula));
        END;
    end;

    procedure ItemCommentExists(pMedicine: Record "Patient Prescription Detail"): Boolean
    begin
        IF Item.GET(pMedicine."Medicine Code") THEN BEGIN
            Item.CALCFIELDS(Comment);
            EXIT(Item.Comment);
        END;
    end;

    procedure LookupItemComment(pMedicine: Record "Patient Prescription Detail")
    var
        CommentLine: Record "Comment Line";
    begin
        IF Item.GET(Rec."Medicine Code") THEN BEGIN
            CommentLine.SETRANGE("Table Name", CommentLine."Table Name"::Item);
            CommentLine.SETRANGE("No.", pMedicine."Medicine Code");
            PAGE.RUNMODAL(PAGE::"Comment Sheet", CommentLine);
        END;
    end;

    procedure LookupItem(pMedicine: Record "Patient Prescription Detail")
    begin
        pMedicine.TESTFIELD("Medicine Code");

        Item.GET(Rec."Medicine Code");
        PAGE.RUNMODAL(PAGE::"Item Card", Item);
    end;

    procedure ItemAvailability(AvailabilityType: Option Date,Variant,Location,Bin)
    begin
        CASE AvailabilityType OF
            AvailabilityType::Date:
                BEGIN
                    Item.SETRANGE("Location Filter", Rec."Location Code");
                    CLEAR(ItemAvailByDate);
                    ItemAvailByDate.LOOKUPMODE(TRUE);
                    ItemAvailByDate.SETRECORD(Item);
                    ItemAvailByDate.SETTABLEVIEW(Item);
                    IF ItemAvailByDate.RUNMODAL = ACTION::LookupOK THEN
                        IF TODAY <> ItemAvailByDate.GetLastDate THEN
                            IF CONFIRM(
                                 Text012, TRUE, 'Visist Day', TODAY,
                                 ItemAvailByDate.GetLastDate)
                            THEN;
                END;
        END;
    end;
}

