page 50021 Pulse
{
    ApplicationArea = All;
    PageType = List;
    SourceTable = Pulse;

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
        rPulse: Record Pulse;
        LineNo: Integer;
    begin
        rPulse.RESET;
        IF rPulse.FINDLAST THEN
            LineNo := rPulse.EntryNo
        ELSE
            LineNo := 0;
        Rec.EntryNo := LineNo + 1;
    end;
}

