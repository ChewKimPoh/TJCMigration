page 50083 "Check Up Card"
{
    // Version No.         : TJCSG1.00
    // Developer           : DP.AYD
    // Init. DEV. Date     : 27/6/2014
    // Description         : Based on DD#166
    // 
    // TJCSG1.00
    //  2. 04/07/2014  dp.dst
    //     TJC DD #178
    //     Last Changes: 08/07/2014.
    //     - Inserted codes on OnAfterGetRecord() to change the page mode to non-editable if the Status is Closed.
    //     - Inserted codes on OnModifyRecord() and OnDeleteRecord() to prevent users from modifing or deleting the record
    //       if the Status is Closed.
    //     - Inserted codes on Cancel - OnAction() to disallow the deletion if the Checkup Info's status is Closed.
    //     - Created new action "Close Check-up Card" to change the status to Closed (moved from Patient Check-up List).

    PageType = Document;
    PromotedActionCategories = 'New,Proces,Report,Patient Checkup,Reports,Tasks';
    RefreshOnActivate = true;
    SourceTable = "Patient Checkup Info";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Contact No."; Rec."Contact No.")
                {
                    Editable = false;
                    Importance = Promoted;
                }
                field("History No."; Rec."History No.")
                {
                    Editable = false;
                    Importance = Promoted;
                }
                field("Visit Date"; Rec."Visit Date")
                {
                    Importance = Promoted;
                }
                field("Doctor code"; Rec."Doctor code")
                {
                    Importance = Additional;
                }
                field("Doctor Name"; Rec."Doctor Name")
                {
                    Importance = Promoted;
                }
                field("Location Code"; Rec."Location Code")
                {
                    Importance = Additional;
                }
                field(Tongue1; Rec.Tongue1)
                {
                }
                field(Tongue2; Rec.Tongue2)
                {
                    Importance = Additional;
                }
                field("Left Pulse"; Rec."Left Pulse")
                {
                    Importance = Promoted;
                }
                field("Right Pulse"; Rec."Right Pulse")
                {
                    Importance = Additional;
                }
                field(Status; Rec.Status)
                {
                    Editable = false;
                }
                field("Low Blood Pressure"; Rec."Low Blood Pressure")
                {
                    Importance = Promoted;
                }
                field("High Blood Pressure"; Rec."High Blood Pressure")
                {
                    Importance = Promoted;
                }
                field("Category No."; Rec."Category No.")
                {
                    Importance = Additional;
                }
                field(Category; Rec.Category)
                {
                    Editable = false;
                    Importance = Promoted;
                }
                field("Sickness No."; Rec."Sickness No.")
                {
                    Importance = Additional;
                }
                field(Sickness; Rec.Sickness)
                {
                    Editable = false;
                    Importance = Promoted;
                }
                field("Type No."; Rec."Type No.")
                {
                    Importance = Additional;
                }
                field(Type; Rec.Type)
                {
                    Editable = false;
                    Importance = Promoted;
                }
                field("Diagnosis Info"; Rec."Diagnosis Info")
                {
                    Importance = Promoted;
                    MultiLine = true;
                    RowSpan = 10;
                }
            }
            part("Patient Medical History List"; 50084)
            {
                ShowFilter = false;
                SubPageLink = "Contact No." = FIELD("Contact No."),
                              "History No." = FIELD("History No.");
                SubPageView = SORTING("Contact No.", "History No.", "Line No.")
                              ORDER(Ascending);
            }
        }
        area(factboxes)
        {
            part("Patient Info"; "Patient Info Card Part")
            {
                Caption = 'Patient Info';
                SubPageLink = "No." = FIELD("Contact No.");
                SubPageView = SORTING("No.")
                              ORDER(Ascending)
                              WHERE(Type = CONST(Person));
            }
            part(PatientCommentSheet; "Patient Comment List")
            {
                Caption = 'Comment Sheet';
                Editable = false;
                SubPageLink = "No." = FIELD("Contact No.");
                SubPageView = SORTING("Table Name", "No.", "Sub No.", "Line No.")
                              ORDER(Ascending)
                              WHERE("Table Name" = CONST(Contact),
                                    "Sub No." = CONST(0));
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action(View)
            {
                Image = View;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
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
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                RunObject = Page "Check Up Card";
                RunPageLink = "Contact No." = FIELD("Contact No."),
                              "History No." = FIELD("History No.");
                RunPageMode = Edit;
                RunPageView = SORTING("Contact No.", "History No.")
                              ORDER(Ascending);
            }
            action(New)
            {
                Ellipsis = true;
                Image = NewDocument;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                RunObject = Page "Check Up Card";
                RunPageLink = "Contact No." = FIELD("Contact No.");
                RunPageMode = Create;
                RunPageView = SORTING("Contact No.", "History No.")
                              ORDER(Ascending);
            }
            action(Cancel)
            {
                Image = Cancel;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    LPatientInfo: Record "Patient Checkup Info";
                    LPatientInfoDetaill: Record "Patient Prescription Detail";
                    Answer: Boolean;
                begin
                    /*Start: TJCSG1.00 #2*/
                    IF Rec.Status = Rec.Status::Closed THEN
                        ERROR(TJCSG_Text001, Rec."Contact No.");
                    /*End: TJCSG1.00 #2*/

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
            action(Comments)
            {
                Caption = 'Co&mments';
                Ellipsis = true;
                Image = ViewComments;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                RunObject = Page "Patient Comment List";
                RunPageLink = "No." = FIELD("Contact No.");
                RunPageMode = Edit;
                RunPageView = SORTING("Table Name", "No.", "Sub No.", "Line No.")
                              ORDER(Ascending)
                              WHERE("Table Name" = CONST(Contact),
                                    "Sub No." = CONST(0));
            }
            action(MedicineSticker)
            {
                Caption = 'Medicine &Sticker';
                Ellipsis = true;
                Image = PrintDocument;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;

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
                Ellipsis = true;
                Image = PrintDocument;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;

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
                Ellipsis = true;
                Image = Copy;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;

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
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    /*Start: TJCSG1.00 #2*/
                    IF Rec.Status = Rec.Status::Open THEN BEGIN
                        Rec.Status := Rec.Status::Closed;
                        Rec.MODIFY;
                    END ELSE
                        ERROR(TJCSG_Text002);
                    /*End: TJCSG1.00 #2*/

                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        /*Start: TJCSG1.00 #2*/
        /*
        IF Status = Status::Closed THEN
          CurrPage.EDITABLE := FALSE
        ELSE
          CurrPage.EDITABLE := TRUE;

        CurrPage.UPDATE(False);
        */
        /*End: TJCSG1.00 #2*/

    end;

    trigger OnDeleteRecord(): Boolean
    begin
        /*Start: TJCSG1.00 #2*/
        IF Rec.Status = Rec.Status::Closed THEN
            ERROR(TJCSG_Text001, Rec."Contact No.");
        /*End: TJCSG1.00 #2*/

    end;

    trigger OnModifyRecord(): Boolean
    begin
        /*Start: TJCSG1.00 #2*/
        IF Rec.Status = Rec.Status::Closed THEN
            ERROR(TJCSG_Text000, Rec."Contact No.");
        /*End: TJCSG1.00 #2*/

    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        PatientInfo: Record "Patient Checkup Info";
        tblUser: Record User;
        UserSetup: Record "User Setup";
    begin
        PatientInfo.RESET;
        PatientInfo.SETRANGE("Contact No.", Rec."Contact No.");
        IF PatientInfo.FIND('+') THEN
            Rec."History No." := PatientInfo."History No." + 1
        ELSE
            Rec."History No." := 1;

        Rec."Visit Date" := TODAY;

        Rec."Doctor code" := USERID;
        tblUser.SETRANGE("User Name", USERID);
        IF tblUser.FIND('-') THEN
            Rec."Doctor Name" := tblUser."Full Name";

        IF UserSetup.GET(USERID) THEN
            Rec."Location Code" := UserSetup."Location Code";
    end;

    var
        TJCSG_Text000: Label 'The status of this Check Up info for this Patient %1 is closed. \You cannot make any changes on it.';
        TJCSG_Text001: Label 'The status of this Check Up info for this Patient %1 is closed. \You cannot delete it.';
        TJCSG_Text002: Label 'The status of this Check Up info for this Patient is already CLOSED.';
}

