table 5723 "Product Group"
{
    Caption = 'Product Group';
    LookupPageID = 5731;

    fields
    {
        field(1;"Item Category Code";Code[10])
        {
            Caption = 'Item Category Code';
            TableRelation = "Item Category".Code;
        }
        field(2;"Code";Code[10])
        {
            Caption = 'Code';
        }
        field(3;Description;Text[50])
        {
            Caption = 'Description';
        }
        field(7300;"Warehouse Class Code";Code[10])
        {
            Caption = 'Warehouse Class Code';
            TableRelation = "Warehouse Class";
        }
        field(50000;"Customer Point (%)";Decimal)
        {
        }
        field(50001;"Commission Rate";Decimal)
        {
        }
        field(50002;"Penalty Cust. Point Rate";Decimal)
        {
        }
    }

    keys
    {
        key(Key1;"Item Category Code","Code")
        {
        }
    }

    fieldgroups
    {
    }
}

