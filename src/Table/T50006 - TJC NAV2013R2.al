table 50006 Sickness
{
    // TJCSG1.00
    //  1. 16/06/2014  dp.dst
    //     - Created the new FieldGroup used for default look-up:
    //       - Category Entry No
    //       - Sickness Entry No
    //       - Sickness Name
    //  2. 27/6/2014 DP.AYD
    //     - Change field group from : Category EntryNo,Sickness EntryNo,Sickness Name
    //                          to   : Sickness EntryNo,Sickness Name
    //       based on DD #166

    LookupPageID = 50016;

    fields
    {
        field(1;"Category EntryNo";Integer)
        {
            BlankZero = true;
            MinValue = 1;
            NotBlank = true;
            TableRelation = "Sickness Category".EntryNo;
        }
        field(2;"Sickness EntryNo";Integer)
        {
            AutoIncrement = false;
            BlankZero = true;
            MinValue = 1;
            NotBlank = true;
        }
        field(3;"Sickness Name";Text[50])
        {
        }
        field(4;Description;Text[50])
        {
        }
    }

    keys
    {
        key(Key1;"Category EntryNo","Sickness EntryNo")
        {
        }
        key(Key2;"Sickness Name")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown;"Sickness EntryNo","Sickness Name")
        {
        }
    }
}

