page 50018 "Tongue 1"
{
    PageType = List;
    SourceTable = "Tongue 1";

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
        rTongue1: Record "Tongue 1";
        LineNo: Integer;
    begin
        rTongue1.RESET;
        IF rTongue1.FINDLAST THEN
            LineNo := rTongue1.EntryNo
        ELSE
            LineNo := 0;
        Rec.EntryNo := LineNo + 1;
    end;
}

