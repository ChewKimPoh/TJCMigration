tableextension 50008 "User Setup" extends "User Setup"
{
    fields
    {
        field(50000; "Commission Rate"; Decimal)
        {
        }
        field(50001; "Staff Level"; Option)
        {
            OptionCaption = 'Management,Production,TJC,Sale';
            OptionMembers = Management,Production,TJC,Sale;
        }
        field(50003; "Location Code"; Code[10])
        {
            Description = 'For Patient System';
            TableRelation = Location;
        }
    }
}