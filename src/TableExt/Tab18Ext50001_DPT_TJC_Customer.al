tableextension 50001 "Customer" extends Customer
{
    // TJCSG1.00: NAV 2013 R2 Upgrade.
    //  1. 30/07/2014  dp.dst
    //      - Changed the DropDownList from:
    //        Old: "No.,Name,City,Post Code,Phone No.,Contact"
    //        New: "No.,Name,Name 2,Address"

    fields
    {
        field(50000; "Customer Point"; Decimal)
        {
            CalcFormula = Sum("Customer Point & Commission"."Customer Points" WHERE("No." = FIELD("No."),
                Redeemed = CONST(false), Date = FIELD("Date Filter")));
            FieldClass = FlowField;
        }
        field(50001; "Promoter Price Group"; Code[20])
        {
            TableRelation = "Customer Price Group".Code;
        }
        field(50002; "Exclude from Prod. Comm."; Boolean)
        {
        }
    }
}

