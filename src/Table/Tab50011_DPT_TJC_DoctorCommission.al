table 50011 "Doctor Commission"
{

    fields
    {
        field(10;"Document No.";Code[20])
        {
        }
        field(20;"Line No.";Integer)
        {
        }
        field(30;"Posting Date";Date)
        {
        }
        field(40;"Document Date";Date)
        {
        }
        field(50;"Doctor Code";Code[20])
        {
            TableRelation = User;
        }
        field(60;"Location Code";Code[10])
        {
        }
        field(70;Type;Option)
        {
            OptionCaption = ',G/L Account,Item,Resource,Fixed Asset,Charge (Item)';
            OptionMembers = ,"G/L Account",Item,Resource,"Fixed Asset","Charge (Item)";
        }
        field(80;"No.";Code[20])
        {
        }
        field(90;Quantity;Decimal)
        {
        }
        field(100;"Line Discount %";Decimal)
        {
        }
        field(110;Commission;Decimal)
        {
        }
        field(120;"Medicine Course";Integer)
        {
        }
        field(130;"Line Amount";Decimal)
        {
        }
    }

    keys
    {
        key(Key1;"Document No.","Line No.")
        {
        }
        key(Key2;"Doctor Code","Posting Date")
        {
        }
        key(Key3;"Location Code","Doctor Code","No.","Posting Date")
        {
        }
    }

    fieldgroups
    {
    }
}

