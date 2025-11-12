page 50002 "Cust Point / Comm Transaction"
{
    PageType = List;
    SourceTable = "Customer Point & Commission";

    layout
    {
        area(content)
        {
            repeater(control1)
            {
                field("Entry No"; Rec."Entry No")
                {
                }
                field(Adjustment; Rec.Adjustment)
                {
                }
                field(Date; Rec.Date)
                {
                }
                field(Type; Rec.Type)
                {
                }
                field("No."; Rec."No.")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("Customer Points"; Rec."Customer Points")
                {
                }
                field("Comm (Paid)"; Rec."Comm (Paid)")
                {
                }
                field("Comm (Unpaid)"; Rec."Comm (Unpaid)")
                {
                }
                field(Redeemed; Rec.Redeemed)
                {
                }
            }
        }
    }

    actions
    {
    }
}

