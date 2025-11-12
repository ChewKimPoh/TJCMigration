page 50082 "Check Up Part"
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
            field(Tongue1; Rec.Tongue1)
            {
            }
            field(Tongue2; Rec.Tongue2)
            {
            }
            field("Left Pulse"; Rec."Left Pulse")
            {
            }
            field("Right Pulse"; Rec."Right Pulse")
            {
            }
            field("Low Blood Pressure"; Rec."Low Blood Pressure")
            {
            }
            field("High Blood Pressure"; Rec."High Blood Pressure")
            {
            }
        }
    }

    actions
    {
    }
}

