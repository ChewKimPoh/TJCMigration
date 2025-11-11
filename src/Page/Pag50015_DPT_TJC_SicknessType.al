page 50015 "Sickness Type"
{
    PageType = List;
    SourceTable = "Sickness Type";

    layout
    {
        area(content)
        {
            repeater(control1)
            {
                field("Type EntryNo"; Rec."Type EntryNo")
                {
                }
                field("Type Name"; Rec."Type Name")
                {
                }
                field(Description; Rec.Description)
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        rSicknessType: Record "Sickness Type";
        LineNo: Integer;
    begin
        rSicknessType.RESET;
        rSicknessType.SETRANGE(rSicknessType."Category EntryNo", Rec."Category EntryNo");
        rSicknessType.SETRANGE(rSicknessType."Sickness EntryNo", Rec."Sickness EntryNo");
        IF rSicknessType.FINDLAST THEN
            LineNo := rSicknessType."Type EntryNo";

        Rec."Type EntryNo" := LineNo + 1;
    end;
}

