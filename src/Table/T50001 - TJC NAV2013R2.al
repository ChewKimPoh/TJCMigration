table 50001 "Customer Point & Commission"
{
    DrillDownPageID = 50002;
    LookupPageID = 50002;

    fields
    {
        field(1;"Entry No";Integer)
        {
        }
        field(2;Adjustment;Option)
        {
            OptionCaption = 'Positive,Negative';
            OptionMembers = Positive,Negative;
        }
        field(3;"No.";Code[20])
        {
        }
        field(4;Date;Date)
        {
        }
        field(5;"Customer Points";Decimal)
        {
        }
        field(6;"Time Stamp";Date)
        {
        }
        field(7;Type;Text[30])
        {
        }
        field(8;"Comm (Paid)";Decimal)
        {
        }
        field(9;"Comm (Unpaid)";Decimal)
        {
        }
        field(10;Description;Text[100])
        {
        }
        field(11;Redeemed;Boolean)
        {
            Description = '081113';
        }
    }

    keys
    {
        key(Key1;"Entry No")
        {
        }
        key(Key2;"No.",Redeemed)
        {
            SumIndexFields = "Customer Points";
        }
        key(Key3;"No.",Redeemed,Date)
        {
            SumIndexFields = "Customer Points";
        }
    }

    fieldgroups
    {
    }

    procedure GetEntryNo() EntryNumber: Integer
    begin
        
        /*
        //get next entry no
        
        TransactionTable.RESET;
        IF TransactionTable.FIND('+') THEN
           EntryNumber:=TransactionTable."Entry No"+1
        ELSE
           EntryNumber:=1;
        EXIT(EntryNumber);
        */

    end;
}

