table 50005 "Sickness Type"
{
    // TJCSG1.00
    //  1. 16/06/2014  dp.dst
    //     - Created new Fields Group used for default look-up comprising the following fields:
    //       - Category Entry No.
    //       - Sickness Entry No.
    //       - Sickness Type Entry No.
    //       - Sickness Type Name
    //  2. 27/6/2014 DP.AYD
    //     - Change field group from : Category EntryNo,Sickness EntryNo,Type EntryNo,Type Name
    //                          to   : Type EntryNo,Type Name
    //       based on DD #166

    LookupPageID = 50015;

    fields
    {
        field(1;"Category EntryNo";Integer)
        {
            BlankZero = true;
            MinValue = 1;
            NotBlank = true;
            TableRelation = "Sickness Category";
        }
        field(2;"Sickness EntryNo";Integer)
        {
            BlankZero = true;
            MinValue = 1;
            NotBlank = true;
            TableRelation = Sickness."Sickness EntryNo" WHERE (Category EntryNo=FIELD(Category EntryNo));
        }
        field(3;"Type EntryNo";Integer)
        {
            BlankZero = true;
            MinValue = 1;
            NotBlank = true;
        }
        field(4;"Type Name";Text[80])
        {
        }
        field(5;Description;Text[50])
        {
        }
    }

    keys
    {
        key(Key1;"Category EntryNo","Sickness EntryNo","Type EntryNo")
        {
        }
        key(Key2;"Type Name")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown;"Type EntryNo","Type Name")
        {
        }
    }
}

