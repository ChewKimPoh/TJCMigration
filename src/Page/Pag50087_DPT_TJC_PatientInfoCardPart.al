page 50087 "Patient Info Card Part"
{
    // Version No.         : TJCSG1.00
    // Developer           : DP.AYD
    // Init. DEV. Date     : 27/6/2014
    // Date of last Change : 27/6/2014
    // Description         : Based on DD#166

    PageType = CardPart;
    SourceTable = Contact;

    layout
    {
        area(content)
        {
            field("No."; Rec."No.")
            {

                trigger OnDrillDown()
                begin
                    PAGE.RUNMODAL(50080, Rec);
                end;
            }
            field("Chinese Name"; Rec."Chinese Name")
            {

                trigger OnDrillDown()
                begin
                    PAGE.RUNMODAL(50080, Rec);
                end;
            }
            field(Name; Rec.Name)
            {

                trigger OnDrillDown()
                begin
                    PAGE.RUNMODAL(50080, Rec);
                end;
            }
            field("NRIC No."; Rec."NRIC No.")
            {

                trigger OnDrillDown()
                begin
                    PAGE.RUNMODAL(50080, Rec);
                end;
            }
            field(Age; Rec.Age)
            {

                trigger OnDrillDown()
                begin
                    PAGE.RUNMODAL(50080, Rec);
                end;
            }
        }
    }

    actions
    {
    }
}

