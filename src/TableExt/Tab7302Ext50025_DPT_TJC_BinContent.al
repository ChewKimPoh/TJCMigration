tableextension 50025 "Bin Content" extends "Bin Content"
{
    fields
    {
        field(50015; "Item Desc1"; Text[100])
        {
            CalcFormula = Lookup(Item.Description WHERE("No." = FIELD("Item No.")));
            FieldClass = FlowField;
        }
        field(50016; "Item Desc2"; Text[100])
        {
            CalcFormula = Lookup(Item."Description 2" WHERE("No." = FIELD("Item No.")));
            FieldClass = FlowField;
        }
    }
}

