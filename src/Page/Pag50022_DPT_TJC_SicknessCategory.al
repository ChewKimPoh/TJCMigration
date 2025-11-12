page 50022 "Sickness Category"
{
    ApplicationArea = All;
    PageType = List;
    SourceTable = "Sickness Category";

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
        area(processing)
        {
            group(clinic)
            {
                action(Sickness)
                {
                    Caption = 'Sickness';
                    Image = AbsenceCategories;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page 50016;
                    RunPageLink = "Category EntryNo" = FIELD(EntryNo);
                }
            }
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        rCategory: Record "Sickness Category";
        LineNo: Integer;
    begin

        rCategory.RESET;
        IF rCategory.FINDLAST THEN
            LineNo := rCategory.EntryNo
        ELSE
            LineNo := 0;
        Rec.EntryNo := LineNo + 1;
    end;
}

