table 50007 "Tongue 1"
{
    LookupPageID = "Tongue 1";

    fields
    {
        field(1; EntryNo; Integer)
        {
            AutoIncrement = true;
            BlankZero = true;
            MinValue = 1;
            NotBlank = true;
        }
        field(2; Name; Text[30])
        {
        }
    }

    keys
    {
        key(Key1; Name, EntryNo)
        {
        }
        key(Key2; EntryNo)
        {
        }
    }

    fieldgroups
    {
    }
}

