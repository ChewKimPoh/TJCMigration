table 50013 "TJC Web Users"
{

    fields
    {
        field(1;UserID;Text[30])
        {
        }
        field(2;"Full Name";Text[50])
        {
        }
        field(3;Password;Text[50])
        {

            trigger OnValidate()
            var
                MD5Hash: Automation ;
            begin

                //CREATE(MD5Hash);
                //Password :=  MD5Hash.CalculateMD5(Password);
                //CLEAR(MD5Hash);


                //Password := Password +'ssss'
            end;
        }
        field(4;Email;Code[30])
        {
        }
        field(5;SalesPerson;Code[10])
        {
            TableRelation = Salesperson/Purchaser;
        }
    }

    keys
    {
        key(Key1;UserID)
        {
        }
    }

    fieldgroups
    {
    }
}

