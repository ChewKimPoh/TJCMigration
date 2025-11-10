page 50004 "Outstanding AR"
{
    PageType = List;
    SourceTable = "Temp Table";
    SourceTableView = WHERE("Document Type" = CONST(Opening));

    layout
    {
        area(content)
        {
            repeater(control1)
            {
                field("Document No"; Rec."Document No")
                {
                }
                field("Item Code"; Rec."Item Code")
                {
                }
                field("Item Description"; Rec."Item Description")
                {
                }
                field("Unit Price"; Rec."Unit Price")
                {
                }
                field("Sales Qty"; Rec."Sales Qty")
                {
                }
                field("Line Amount"; Rec."Line Amount")
                {
                }
            }
        }
    }

    actions
    {
    }
}

