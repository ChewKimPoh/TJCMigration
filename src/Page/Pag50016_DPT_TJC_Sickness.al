page 50016 Sickness
{
    PageType = List;
    SourceTable = Sickness;

    layout
    {
        area(content)
        {
            repeater(control1)
            {
                field("Sickness EntryNo"; Rec."Sickness EntryNo")
                {
                }
                field("Sickness Name"; Rec."Sickness Name")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(sickness)
            {
                action("Sickness &Type")
                {
                    Caption = 'Sickness &Type';
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Sickness Type";
                    RunPageLink = "Category EntryNo" = FIELD("Category EntryNo"),
                                  "Sickness EntryNo" = FIELD("Sickness EntryNo");
                }
            }
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        rSickness: Record Sickness;
        LineNo: Integer;
    begin
        rSickness.RESET;
        rSickness.SETRANGE(rSickness."Category EntryNo", Rec."Category EntryNo");
        IF rSickness.FINDLAST THEN
            LineNo := rSickness."Sickness EntryNo";

        Rec."Sickness EntryNo" := LineNo + 1;
    end;
}

