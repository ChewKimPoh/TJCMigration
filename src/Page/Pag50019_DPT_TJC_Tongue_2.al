page 50019 "Tongue 2"
{
    PageType = List;
    SourceTable = "Tongue 2";

    layout
    {
        area(content)
        {
            repeater(control1)
            {
                field(EntryNo; Rec.EntryNo)
                {
                }
                field(Name; Rec.Name)
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        rTongue2: Record "Tongue 2";
        LineNo: Integer;
    begin
        rTongue2.RESET;
        IF rTongue2.FINDLAST THEN
            LineNo := rTongue2.EntryNo
        ELSE
            LineNo := 0;
        Rec.EntryNo := LineNo + 1;
    end;
}

