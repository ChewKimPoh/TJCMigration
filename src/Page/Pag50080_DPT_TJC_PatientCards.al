//page 50080 "Patient Cards."
page 50080 "Patient Cards."
{
    // Version No.         : TJCSG1.00
    // Developer           : DP.AYD
    // Init. DEV. Date     : 27/6/2014
    // Date of last Change : 27/6/2014
    // Description         : Based on DD#166

    ApplicationArea = All;
    Editable = true;
    PageType = Document;
    PromotedActionCategories = 'New,Tasks,Reports,Patient Checkup';
    RefreshOnActivate = true;
    SourceTable = Contact;
    SourceTableView = SORTING("No.")
                      ORDER(Ascending)
                      WHERE(Type = FILTER(Person));

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; Rec."No.")
                {
                    Caption = 'Patient No.';
                    Importance = Promoted;

                    trigger OnValidate()
                    begin
                        Contact.SETCURRENTKEY("No.");
                        Contact.SETRANGE("No.", Rec."No.");
                        IF Contact.FIND('-') THEN BEGIN
                            MESSAGE(Text010, Rec."No.");
                            IF CONFIRM(Text005, FALSE) THEN
                                PAGE.RUN(Page::"Patient Cards.", Contact);
                            ERROR(Text010);
                        END;
                    end;
                }
                field("Chinese Name"; Rec."Chinese Name")
                {
                    Importance = Promoted;
                }
                field(Birthday; Rec.Birthday)
                {
                    Importance = Additional;
                }
                field(Age; Rec.Age)
                {
                    Editable = false;
                    Importance = Promoted;
                }
                field("Location Code"; Rec."Location Code")
                {
                    Importance = Additional;
                }
                field("Marital Status"; Rec."Marital Status")
                {
                    Importance = Additional;
                }
                field(Gender; Rec.Gender)
                {
                    Importance = Additional;
                }
                field(Occupation; Rec.Occupation)
                {
                    Importance = Additional;
                }
                field("NRIC No."; Rec."NRIC No.")
                {
                    Importance = Promoted;

                    trigger OnValidate()
                    begin
                        IF Rec."NRIC No." = '' THEN
                            ERROR(Text001);

                        Contact.SETCURRENTKEY("NRIC No.");
                        Contact.SETRANGE("NRIC No.", Rec."NRIC No.");
                        IF Contact.FIND('-') THEN BEGIN
                            MESSAGE(Text003, Rec."NRIC No.");
                            IF CONFIRM(Text005, FALSE) THEN
                                PAGE.RUN(Page::"Patient Cards.", Contact);
                            ERROR(Text003);
                        END;
                    end;
                }
                field(Name; Rec.Name)
                {
                    Caption = 'English Name';
                    Importance = Promoted;

                    trigger OnValidate()
                    begin
                        IF Rec.Name = '' THEN
                            ERROR(Text001);
                    end;
                }
                field("Home Phone No."; Rec."Home Phone No.")
                {
                    Importance = Additional;
                }
                field("Phone No."; Rec."Phone No.")
                {
                    Caption = 'Office Phone No.';
                    Importance = Additional;
                }
                field("Mobile Phone No."; Rec."Mobile Phone No.")
                {
                    Importance = Additional;
                }
                field(Address; Rec.Address)
                {
                    Importance = Additional;
                }
                field("Address 2"; Rec."Address 2")
                {
                    Importance = Additional;
                }
            }
            part(PatientCheckupList; "Check Up List.")
            {
                Caption = 'Check Up List';
                Editable = false;
                SubPageLink = "Contact No." = FIELD("No.");
                SubPageView = SORTING("Contact No.", "History No.")
                              ORDER(Ascending);
            }
            part("Patient Medical History List"; "Patient Medical History List")
            {
                Caption = 'Patient Medical History List';
                Editable = false;
                Provider = PatientCheckupList;
                SubPageLink = "Contact No." = FIELD("Contact No."),
                              "History No." = FIELD("History No.");
                SubPageView = SORTING("Contact No.", "History No.", "Line No.")
                              ORDER(Ascending);
            }
        }
        area(factboxes)
        {
            part("Check Up Data"; "Check Up Part")
            {
                Caption = 'Check Up Data';
                Editable = false;
                Provider = PatientCheckupList;
                SubPageLink = "Contact No." = FIELD("Contact No."),
                              "History No." = FIELD("History No.");
            }
            part(Diagnosis; "Diagnosis Part.")
            {
                Caption = 'Diagnosis';
                Editable = false;
                Provider = PatientCheckupList;
                SubPageLink = "Contact No." = FIELD("Contact No."),
                              "History No." = FIELD("History No.");
            }
            part("Comment List"; "Patient Comment List")
            {
                Caption = 'Comment List';
                SubPageLink = "No." = FIELD("No.");
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
            action(New)
            {
                Ellipsis = true;
                Image = NewDocument;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                RunObject = Page 50083;
                RunPageLink = "Contact No." = FIELD("No.");
                RunPageMode = Create;
                RunPageView = SORTING("Contact No.", "History No.")
                              ORDER(Ascending);
            }
            action("Co&mments")
            {
                Caption = 'Co&mments';
                Image = ViewComments;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                RunObject = Page "Patient Comment List";
                RunPageLink = "No." = FIELD("No.");
                RunPageView = SORTING("Table Name", "No.", "Sub No.", "Line No.")
                              ORDER(Ascending)
                              WHERE("Table Name" = CONST(Contact),
                                    "Sub No." = CONST(0));
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        IF Rec.Birthday <> 0D THEN BEGIN
            Rec.Age := DATE2DMY(TODAY, 3) - DATE2DMY(Rec.Birthday, 3);
            CurrPage.UPDATE(FALSE);
        END;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        IF UserSetup.GET(USERID) THEN
            Rec."Location Code" := UserSetup."Location Code";
        Rec.Type := Rec.Type::Person;
    end;

    var
        Text001: Label 'PatientNo/NRIC/ EnglishName cannot be empty!';
        Text002: Label 'Do you want to create a new Patient Card?';
        Text003: Label 'Contact No with  NRIC %1 has already existed! ';
        Text004: Label 'Patient card with NRIC %1 has already existed! ';
        Text005: Label 'Do you want to use the existing Patient Card?';
        Text006: Label 'Do you want to use the existing empty patient Card with this NRIC?';
        Text007: Label 'A new patient card cannot be created in View status.';
        Text008: Label 'Cannot edit previous record!';
        Text009: Label 'No history record exists. Please click new!';
        NoSeriesManagement: Codeunit NoSeriesManagement;
        RelationshipMgtSetup: Record "Marketing Setup";
        Contact: Record Contact;
        CheckupInfo: Record "Patient Checkup Info";
        SalesSetup: Record "Sales & Receivables Setup";
        UserSetup: Record "User Setup";
        Text010: Label 'Contact No  %1 has already existed! ';
}

