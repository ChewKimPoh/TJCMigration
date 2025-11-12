page 50025 "Clinic Item Categories"
{
    ApplicationArea = All;
    Caption = 'Clinic Item Categories';
    PageType = List;
    SourceTable = "Item Category";
    SourceTableView = SORTING(Code)
                      WHERE(Clinic = CONST(true));

    layout
    {
        area(content)
        {
            repeater(control1)
            {
                field(Code; Rec.Code)
                {
                }
                field(Description; Rec.Description)
                {
                }
                field(Clinic; Rec.Clinic)
                {
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("&Prod. Groups")
            {
                Caption = '&Prod. Groups';
                Promoted = true;
                PromotedCategory = Process;
                // RunObject = Page::"Clinic Product Groups";
                // RunPageLink = "Item Category Code" = FIELD(Code);
            }
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec.Clinic := TRUE;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.Clinic := TRUE;
    end;
}

