page 50081 "Check Up List."
{
    // Version No.         : TJCSG1.00
    // Developer           : DP.AYD
    // Init. DEV. Date     : 27/6/2014
    // Date of last Change : 27/6/2014
    // Description         : Based on DD#166
    // 
    // TJCSG1.00
    //  2. 04/07/2014  dp.dst
    //     Last Changes: 08/07/2014.
    //     - Added new Action "Close Check-up Card" to set the status of this Check-up Card to Closed.
    //     - Closed card cannot be edited or deleted.
    //     - Moved it to card level, changed the Visible property to FALSE.

    AutoSplitKey = true;
    CardPageID = "Check Up Card";
    MultipleNewLines = true;
    PageType = ListPart;
    //PromotedActionCategories = 'New,Tasks,Reports,Patient Checkup';
    RefreshOnActivate = true;
    ShowFilter = false;
    SourceTable = "Patient Checkup Info";

    layout
    {
        area(content)
        {
            repeater("Patient Lines")
            {
                Caption = 'Patient Lines';
                Editable = false;
                field("Contact No."; Rec."Contact No.")
                {
                    Visible = false;
                }
                field("History No."; Rec."History No.")
                {
                }
                field("Visit Date"; Rec."Visit Date")
                {
                }
                field("Doctor Name"; Rec."Doctor Name")
                {
                }
                field(Category; Rec.Category)
                {
                }
                field(Sickness; Rec.Sickness)
                {
                }
                field(Type; Rec.Type)
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(View)
            {
                Image = View;
                // Promoted = true;
                // PromotedCategory = Category4;
                // PromotedIsBig = true;
                RunObject = Page "Check Up Card";
                RunPageLink = "Contact No." = FIELD("Contact No."),
                              "History No." = FIELD("History No.");
                RunPageMode = View;
                RunPageView = SORTING("Contact No.", "History No.")
                              ORDER(Ascending);
            }
            action(Edit)
            {
                Image = Edit;
                // Promoted = true;
                // PromotedCategory = Category4;
                // PromotedIsBig = true;
                RunObject = Page "Check Up Card";
                RunPageLink = "Contact No." = FIELD("Contact No."),
                              "History No." = FIELD("History No.");
                RunPageMode = Edit;
                RunPageView = SORTING("Contact No.", "History No.")
                              ORDER(Ascending);
            }
            action(New)
            {
                Image = NewDocument;
                // Promoted = true;
                // PromotedCategory = Category4;
                // PromotedIsBig = true;
                RunObject = Page "Check Up Card";
                RunPageLink = "Contact No." = FIELD("Contact No.");
                RunPageMode = Create;
                RunPageView = SORTING("Contact No.", "History No.")
                              ORDER(Ascending);
            }
            action(Cancel)
            {
                Enabled = false;
                Image = Cancel;
                // Promoted = true;
                // PromotedCategory = Category4;
                // PromotedIsBig = true;
                Visible = false;

                trigger OnAction()
                var
                    LPatientInfo: Record "Patient Checkup Info";
                    LPatientInfoDetaill: Record "Patient Prescription Detail";
                    Answer: Boolean;
                begin
                    IF CONFIRM('Do you want to cancel record ', TRUE) THEN BEGIN
                        LPatientInfoDetaill.SETRANGE("Contact No.", Rec."Contact No.");
                        LPatientInfoDetaill.SETRANGE("History No.", Rec."History No.");
                        IF LPatientInfoDetaill.FIND('-') THEN BEGIN
                            Answer := CONFIRM('This Record contains Patient Prescription Detail, do you still want to delete?', TRUE);
                            IF Answer THEN BEGIN
                                REPEAT
                                    LPatientInfoDetaill.DELETE;
                                UNTIL LPatientInfoDetaill.NEXT = 0;
                                IF LPatientInfo.GET(Rec."Contact No.", Rec."History No.") THEN
                                    LPatientInfo.DELETE;
                            END;
                        END
                        ELSE
                            IF LPatientInfo.GET(Rec."Contact No.", Rec."History No.") THEN
                                LPatientInfo.DELETE;

                        CurrPage.UPDATE(FALSE);
                    END;
                end;
            }
            action("Co&mments")
            {
                Caption = 'Co&mments';
                Image = ViewComments;
                // Promoted = true;
                // PromotedCategory = Category4;
                // PromotedIsBig = true;
                RunObject = Page "Patient Comment List";
                RunPageLink = "No." = FIELD("Contact No.");
                RunPageView = SORTING("Table Name", "No.", "Sub No.", "Line No.")
                              ORDER(Ascending)
                              WHERE("Table Name" = CONST(Contact),
                                    "Sub No." = CONST(0));
            }
            action(MedicineSticker)
            {
                Caption = 'Medicine &Sticker';
                Image = PrintDocument;
                // Promoted = true;
                // PromotedCategory = "Report";
                // PromotedIsBig = true;

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
            action(MedicinePrescription)
            {
                Caption = 'Medicine &Prescription';
                Image = PrintDocument;
                // Promoted = true;
                // PromotedCategory = "Report";
                // PromotedIsBig = true;

                trigger OnAction()
                var
                    PPDetail: Record "Patient Checkup Info";
                    Medicine: Report "Medicine Prescription";
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
                // Promoted = true;
                // PromotedCategory = Process;
                // PromotedIsBig = true;

                trigger OnAction()
                var
                    CopyMedicine: Report "Copy Medicine";
                begin
                    CopyMedicine.SetValue(Rec."Contact No.", Rec."History No.");
                    CopyMedicine.RUN;
                end;
            }
            action("Close Check-up Card")
            {
                Image = CloseDocument;
                // Promoted = true;
                // PromotedCategory = Process;
                // PromotedIsBig = true;
                Visible = false;

                trigger OnAction()
                begin
                    /*Start: TJCSG1.00 #2*/
                    IF Rec.Status = Rec.Status::Open THEN BEGIN
                        Rec.Status := Rec.Status::Closed;
                        Rec.MODIFY;
                    END ELSE
                        ERROR(TJCSG_Text000);
                    /*End: TJCSG1.00 #2*/

                end;
            }
        }
    }

    var
        TJCSG_Text000: Label 'The status is already Closed.';
}

