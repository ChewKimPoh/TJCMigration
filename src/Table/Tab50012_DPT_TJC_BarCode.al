table 50012 "Bar Code"
{
    // DP.RWP - New table to store Barcode Items
    // DP.NCM TJC #803 01/09/2025 Add Commission Rate field

    LookupPageID = 50029;

    fields
    {
        field(10; "Code"; Code[20])
        {
            NotBlank = true;
            TableRelation = Item;

            trigger OnValidate()
            begin
                Item.GET(Code);
                Description := Item.Description;
            end;
        }
        field(20; Description; Text[30])
        {
        }
        field(30; "How Many Days"; Option)
        {
            OptionCaption = '3,5,7,1';
            OptionMembers = "3","5","7","1";
        }
        field(40; "Print Medicine Sticker"; Boolean)
        {
        }
        field(50; "Commission Rate"; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; "Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        "Print Medicine Sticker" := TRUE;
    end;

    var
        Item: Record Item;
}

