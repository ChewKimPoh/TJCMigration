page 50085 "Diagnosis Part."
{
    // Version No.         : TJCSG1.00
    // Developer           : DP.AYD
    // Init. DEV. Date     : 27/6/2014
    // Date of last Change : 27/6/2014
    // Description         : Based on DD#166

    Editable = false;
    PageType = CardPart;
    SourceTable = "Patient Checkup Info";

    layout
    {
        area(content)
        {
            field("History No."; Rec."History No.")
            {

                trigger OnDrillDown()
                begin
                    PAGE.RUNMODAL(50083, Rec);
                end;
            }
            field(Category; Rec.Category)
            {
            }
            field(Sickness; Rec.Sickness)
            {
            }
            field(Type; Rec.Type)
            {
            }
            field("Diagnosis Info"; Rec."Diagnosis Info")
            {
                MultiLine = true;
            }
        }
    }

    actions
    {
    }
}

