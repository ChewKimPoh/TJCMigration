table 50000 "Temp Table"
{
    // TJCSG1.00
    //  1. 07/09/2011  dpt.ds
    //     - Inserted new key:
    //       - "Name Code,Customer Code,Document No"
    // 
    //  2. 31/05/2014 DP.AYD DP.AYD DD#123 https://dptech.mydonedone.com/issuetracker/projects/4350/issues/123
    //     - Insert New Key :
    //       Name Code,Document Type
    //     - Purpose to fix CU 50000
    //       - Function : AddCommToTable


    fields
    {
        field(1;"Entry No";Integer)
        {
        }
        field(2;"Name Code";Text[20])
        {
        }
        field(3;"Name Description";Text[100])
        {
        }
        field(4;"Customer Code";Text[20])
        {
        }
        field(5;"Customer Description";Text[100])
        {
        }
        field(6;"Item Code";Text[20])
        {
        }
        field(7;"Item Description";Text[100])
        {
        }
        field(8;"Sales Qty";Decimal)
        {
        }
        field(9;"Line Amount";Decimal)
        {
        }
        field(10;"Invoice Date";Date)
        {
        }
        field(11;"Closing Date";Date)
        {
        }
        field(12;"Product Group Code";Text[30])
        {
        }
        field(13;"Product Group Description";Text[100])
        {
        }
        field(14;"Item Category Code";Text[30])
        {
        }
        field(15;"Item category Description";Text[100])
        {
        }
        field(16;"Document No";Code[20])
        {
        }
        field(17;"Report Type";Option)
        {
            OptionCaption = 'SaleComm,MgtComm,ProdComm,PromoterComm';
            OptionMembers = SaleComm,MgtComm,ProdComm,PromoterComm;
        }
        field(18;Type;Option)
        {
            OptionCaption = 'Salesperson,Management,Production,Promoter';
            OptionMembers = Salesperson,Management,Production,Promoter;
        }
        field(19;"Unit Price";Decimal)
        {
        }
        field(20;"Cost Price";Decimal)
        {
        }
        field(21;"Sales Margin";Decimal)
        {
        }
        field(22;"Comm (Paid)";Decimal)
        {
        }
        field(23;"Comm (Unpaid)";Decimal)
        {
        }
        field(24;"Customer Point";Decimal)
        {
        }
        field(25;"Production Comm (Paid)";Decimal)
        {
        }
        field(26;"Production Comm (Unpaid)";Decimal)
        {
        }
        field(27;"Document Type";Option)
        {
            OptionCaption = 'Invoice,CreditMemo,NA,Opening';
            OptionMembers = Invoice,CreditMemo,NA,Opening;
        }
        field(28;DocEntryNo;Integer)
        {
            Description = 'for test will remove';
        }
        field(29;LineNo;Integer)
        {
            Description = 'for test will remove';
        }
    }

    keys
    {
        key(Key1;"Entry No","Document No","Document Type")
        {
        }
        key(Key2;Type,"Name Code","Name Description","Customer Code","Document No")
        {
        }
        key(Key3;"Entry No","Document Type")
        {
        }
        key(Key4;"Name Description",Type)
        {
        }
        key(Key5;"Customer Code","Document No")
        {
        }
        key(Key6;"Name Description","Document No")
        {
        }
        key(Key7;"Customer Code","Product Group Code")
        {
        }
        key(Key8;"Item Code","Report Type")
        {
        }
        key(Key9;"Document No","Document Type")
        {
        }
        key(Key10;"Document Type")
        {
        }
        key(Key11;"Name Code","Customer Code","Document No")
        {
        }
        key(Key12;"Name Code","Document Type")
        {
        }
        key(Key13;"Name Code")
        {
        }
        key(Key14;"Document No","Document Type","Item Code")
        {
        }
    }

    fieldgroups
    {
    }

    var
        "Customer Point Table": Record "50001";
}

