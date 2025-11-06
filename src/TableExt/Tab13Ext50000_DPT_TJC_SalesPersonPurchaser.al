//table 13 "Salesperson/Purchaser"
tableextension 50000 "Salesperson/Purchaser" extends "Salesperson/Purchaser"
{
    Caption = 'Salesperson/Purchaser';
    DataCaptionFields = "Code", Name;
    LookupPageID = 14;

    fields
    {
        field(50000; Type; Option)
        {
            OptionMembers = Others,Salesperson;

        }
    }
}

