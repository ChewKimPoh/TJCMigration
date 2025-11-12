page 50017 "Patient Comment Sheet"
{
    ApplicationArea = All;
    AutoSplitKey = true;
    Caption = 'Rlshp. Mgt. Comment Sheet';
    DataCaptionFields = "No.";
    DelayedInsert = true;
    PageType = List;
    ShowFilter = false;
    SourceTable = "Rlshp. Mgt. Comment Line";
    SourceTableView = WHERE("Table Name" = CONST(Contact),
                            "Sub No." = CONST(0));

    layout
    {
        area(content)
        {
            repeater(control1)
            {
                field(Date; Rec.Date)
                {
                }
                field(Comment; Rec.Comment)
                {
                }
                field(Code; Rec.Code)
                {
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.SetUpNewLine;
    end;

    var
        ContactNo: Code[20];

    procedure setcontactcomment(pContactNo: Code[20])
    begin

        Rec.SETRANGE("No.", pContactNo);
        CurrPage.UPDATE;
    end;
}

