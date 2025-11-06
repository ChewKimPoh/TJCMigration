table 6635 "Return Reason"
{
    Caption = 'Return Reason';
    DrillDownPageID = 6635;
    LookupPageID = 6635;

    fields
    {
        field(1;"Code";Code[10])
        {
            Caption = 'Code';
        }
        field(2;Description;Text[50])
        {
            Caption = 'Description';
        }
        field(3;"Default Location Code";Code[10])
        {
            Caption = 'Default Location Code';
            TableRelation = Location WHERE (Use As In-Transit=CONST(No));
        }
        field(4;"Inventory Value Zero";Boolean)
        {
            Caption = 'Inventory Value Zero';
        }
        field(50000;"Deduct Penalty";Boolean)
        {
        }
    }

    keys
    {
        key(Key1;"Code")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown;"Code",Description,"Default Location Code","Inventory Value Zero")
        {
        }
    }
}

