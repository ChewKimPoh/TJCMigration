table 50010 "Sickness Category"
{
    LookupPageID = 50022;

    fields
    {
        field(1;EntryNo;Integer)
        {
            AutoIncrement = true;
            BlankZero = true;
            MinValue = 1;
            NotBlank = true;
        }
        field(2;Name;Text[10])
        {
        }
    }

    keys
    {
        key(Key1;Name,EntryNo)
        {
        }
        key(Key2;EntryNo)
        {
        }
    }

    fieldgroups
    {
    }
}

