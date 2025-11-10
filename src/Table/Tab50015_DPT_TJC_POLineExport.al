table 50015 "PO Line Export"
{

    fields
    {
        field(1;"Entry No.";Integer)
        {
        }
        field(2;"Document No.";Code[20])
        {
        }
        field(3;"Document Line No.";Integer)
        {
        }
        field(4;"Sell-to Customer No.";Code[20])
        {
        }
        field(5;"Item No.";Code[20])
        {
        }
        field(6;Description;Text[50])
        {
        }
        field(7;"Lot No.";Code[20])
        {
        }
        field(8;"Expiry date";Date)
        {
        }
        field(9;Quantity;Decimal)
        {
        }
        field(10;"Packing unit price";Decimal)
        {
        }
        field(11;"Discount %";Decimal)
        {
        }
        field(12;"Sell-to Customer Name";Text[100])
        {
        }
        field(13;"External Document No.";Code[50])
        {
        }
    }

    keys
    {
        key(Key1;"Entry No.")
        {
        }
    }

    fieldgroups
    {
    }
}

