page 50024 "Medicine List"
{
    Editable = false;
    PageType = List;
    SourceTable = Item;
    SourceTableView = SORTING("No.")
                      WHERE(Clinic = CONST(true));

    layout
    {
        area(content)
        {
            repeater(control1)
            {
                Editable = true;
                field("Clinic Item Category Code"; Rec."Clinic Item Category Code")
                {
                }
                field("Clinic Product Category Code"; Rec."Clinic Product Category Code")
                {
                }
                field("No."; Rec."No.")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("Description 2"; Rec."Description 2")
                {
                }
                field(Usage; Rec.Usage)
                {
                }
                field(Blocked; Rec.Blocked)
                {
                }
            }
        }
    }

    actions
    {
    }
}

