page 50020 "Patient List"
{
    ApplicationArea = All;
    Caption = 'Patient List';
    CardPageID = "Patient Cards.";
    DataCaptionFields = "Company No.";
    Editable = false;
    PageType = List;
    UsageCategory = Lists;
    PromotedActionCategories = 'New,Tasks,Reports,Patient';
    SourceTable = Contact;
    SourceTableView = SORTING("No.") WHERE(Type = CONST(Person));

    layout
    {
        area(content)
        {
            repeater(control1)
            {
                Editable = false;
                IndentationColumn = NameIndent;
                IndentationControls = Name;
                field("No."; Rec."No.")
                {
                }
                field(Name; Rec.Name)
                {
                }
                field("Chinese Name"; Rec."Chinese Name")
                {
                }
                field("NRIC No."; Rec."NRIC No.")
                {
                    Caption = 'NRIC';
                }
                field("Location Code"; Rec."Location Code")
                {
                }
                field("Home Phone No."; Rec."Home Phone No.")
                {
                }
                field("Phone No."; Rec."Phone No.")
                {
                    Caption = 'Office Phone No.';
                }
                field("Mobile Phone No."; Rec."Mobile Phone No.")
                {
                    Visible = false;
                }
                field(Gender; Rec.Gender)
                {
                }
                field(Birthday; Rec.Birthday)
                {
                }
            }
        }
        area(factboxes)
        {
            part(PatientCheckupList; "Check Up List.")
            {
                Caption = 'Check Up List';
                SubPageLink = "Contact No." = FIELD("No.");
                SubPageView = SORTING("Contact No.", "History No.")
                              ORDER(Ascending);
            }
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
            part("Comment List"; 50086)
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
                RunObject = Page 50080;
                RunPageMode = Create;
                RunPageView = SORTING("No.")
                              ORDER(Ascending)
                              WHERE(Type = CONST(Person));
            }
            action(Edit)
            {
                Ellipsis = true;
                Image = Edit;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                RunObject = Page 50080;
                RunPageLink = "No." = FIELD("No.");
                RunPageMode = Edit;
                RunPageView = SORTING("No.")
                              ORDER(Ascending)
                              WHERE(Type = CONST(Person));
            }
            action(View)
            {
                Ellipsis = true;
                Image = View;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                RunObject = Page 50080;
                RunPageLink = "No." = FIELD("No.");
                RunPageMode = View;
                RunPageView = SORTING("No.")
                              ORDER(Ascending)
                              WHERE(Type = CONST(Person));
            }
            action("Co&mments")
            {
                Caption = 'Co&mments';
                Image = ViewComments;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                RunObject = Page 50086;
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
        NameIndent := 0;
        NoOnFormat;
        NameOnFormat;
    end;

    trigger OnOpenPage()
    begin
        //SETFILTER("NRIC No.",'<>%1','');

        //DD-415 Removal of filters by the user's Location Code
        //UserSetup.GET(USERID);
        //SETRANGE("Location Code", UserSetup."Location Code");
    end;

    var
        Cont: Record Contact;
        UserSetup: Record "User Setup";
        //[InDataSet]
        "No.Emphasize": Boolean;
        //[InDataSet]
        NameEmphasize: Boolean;
        //[InDataSet]
        NameIndent: Integer;

    local procedure NoOnFormat()
    begin
        IF Rec.Type = Rec.Type::Company THEN
            "No.Emphasize" := TRUE;
    end;

    local procedure NameOnFormat()
    begin
        IF Rec.Type = Rec.Type::Company THEN
            NameEmphasize := TRUE
        ELSE BEGIN
            Cont.SETCURRENTKEY("Company Name", "Company No.", Type, Name);
            IF (Rec."Company No." <> '') AND (NOT Rec.HASFILTER) AND (NOT Rec.MARKEDONLY) AND (Rec.CURRENTKEY = Cont.CURRENTKEY)
            THEN
                NameIndent := 1;
        END;
    end;
}

