page 50027 "Clinic Visit Analysis"
{
    PageType = Worksheet;
    PromotedActionCategories = 'New,Tasks,Reports,Patient';
    SourceTable = "Patient Checkup Info";
    SourceTableView = SORTING("Visit Date");

    layout
    {
        area(content)
        {
            field(VisitDate; Rec."Visit Date")
            {
                Caption = 'Visit Date';

                trigger OnValidate()
                begin
                    Rec.SETRANGE("Visit Date");
                    IF VisitDate <> '' THEN
                        Rec.SETFILTER("Visit Date", VisitDate);
                    TotNo := Rec.COUNT;
                    VisitDateOnAfterValidate;
                end;
            }
            field(DoctorCode; Rec."Doctor Code")
            {
                Caption = 'Doctor Code';

                trigger OnLookup(var Text: Text): Boolean
                begin
                    Rec.SETRANGE("Doctor code");

                    //Note:  LookupUserID is BC discontinued procedure
                    //LoginMgt.LookupUserID(DoctorCode);
                    Text := DoctorCode;
                    IF DoctorCode <> '' THEN
                        Rec.SETRANGE("Doctor code", DoctorCode);
                    TotNo := Rec.COUNT;
                    CurrPage.UPDATE;
                end;

                trigger OnValidate()
                begin
                    Rec.SETRANGE("Doctor code");
                    IF DoctorCode <> '' THEN
                        Rec.SETRANGE("Doctor code", DoctorCode);
                    TotNo := Rec.COUNT;
                    DoctorCodeOnAfterValidate;
                end;
            }
            field(LocationCode; LocationCode)
            {
                Caption = 'Location Code';
                TableRelation = Location.Code;

                trigger OnValidate()
                begin
                    Rec.SETRANGE("Location Code");
                    IF LocationCode <> '' THEN
                        Rec.SETRANGE("Location Code", LocationCode);
                    TotNo := Rec.COUNT;
                    LocationCodeOnAfterValidate;
                end;
            }
            repeater(control1)
            {
                Editable = false;
                field("Contact No."; Rec."Contact No.")
                {
                    Caption = 'Patient No.';
                }
                field("History No."; Rec."History No.")
                {
                }
                field(EnglishName; EnglishName)
                {
                    Caption = 'Patient English Name';
                }
                field(ChineseName; ChineseName)
                {
                    Caption = 'Patient Chinese Name';
                }
                field("Visit Date"; Rec."Visit Date")
                {
                }
                field("Doctor code"; Rec."Doctor code")
                {
                }
                field("Doctor Name"; Rec."Doctor Name")
                {
                }
                field("Location Code"; Rec."Location Code")
                {
                }
            }
            field(TotNo; TotNo)
            {
                Caption = 'Total No.';
                Editable = false;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(View)
            {
                Ellipsis = true;
                Image = View;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                RunObject = Page 50083;
                RunPageLink = "Contact No." = FIELD("Contact No."),
                              "History No." = FIELD("History No.");
                RunPageMode = View;
                RunPageView = SORTING("Contact No.", "History No.")
                              ORDER(Ascending);
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        IF Contact.GET(Rec."Contact No.") THEN BEGIN
            ChineseName := Contact."Chinese Name";
            EnglishName := Contact.Name;
        END;
    end;

    trigger OnOpenPage()
    begin
        TotNo := Rec.COUNT;
    end;

    var
        LoginMgt: Codeunit "User Management";
        Contact: Record Contact;
        VisitDate: Text[100];
        DoctorCode: Code[20];
        LocationCode: Code[10];
        TotNo: Integer;
        EnglishName: Text[50];
        ChineseName: Text[10];

    local procedure VisitDateOnAfterValidate()
    begin
        CurrPage.UPDATE;
    end;

    local procedure DoctorCodeOnAfterValidate()
    begin
        CurrPage.UPDATE;
    end;

    local procedure LocationCodeOnAfterValidate()
    begin
        CurrPage.UPDATE;
    end;
}

