page 50007 "TJC Bin List with Comm"
{
    // DP.NCM TJC #803 01/09/2025 Created this page

    PageType = List;
    SourceTable = "Bar Code";

    layout
    {
        area(content)
        {
            repeater(Group)
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
                field("Commission Rate"; Rec."Commission Rate")
                {
                }
            }
        }
    }

    actions
    {
    }
}

