table 50008 "Tongue 2"
{
    LookupPageID = 50019;

    fields
    {
        field(1;EntryNo;Integer)
        {
            BlankZero = true;
            MinValue = 1;
            NotBlank = true;
        }
        field(2;Name;Text[30])
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
        fieldgroup(DropDown;EntryNo,Name)
        {
        }
    }
}

