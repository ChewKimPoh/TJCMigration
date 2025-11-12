page 50029 "Bar Code"
{
    // DP.RWP - New form to input info for barcode items

    PageType = List;
    SourceTable = "Bar Code";

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
                field("How Many Days"; Rec."How Many Days")
                {
                }
                field("Print Medicine Sticker"; Rec."Print Medicine Sticker")
                {
                }
            }
        }
    }

    actions
    {
    }
}

