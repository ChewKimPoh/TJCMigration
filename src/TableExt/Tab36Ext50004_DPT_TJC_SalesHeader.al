tableextension 50004 "Sales Header" extends "Sales Header"
{
    fields
    {
        field(50001; "No Picking List"; Boolean)
        {
        }
        field(51612; _Adjustment; Boolean)
        {
            Caption = 'Adjustment';
            Editable = false;
            Description = 'NAV2013R2 Localization Customization Relic';
        }
        field(51613; "_BAS Adjustment"; Boolean)
        {
            Caption = 'BAS Adjustment';
            Editable = false;
            Description = 'NAV2013R2 Localization Customization Relic';
        }
        field(51614; "_Adjustment Applies-to"; Code[20])
        {
            Caption = 'Adjustment Applies-to';
            Description = 'NAV2013R2 Localization Customization Relic';
        }
        field(58040; "_WHT Business Posting Group"; Code[10])
        {
            Caption = 'WHT Business Posting Group';
            Description = 'NAV2013R2 Localization Customization Relic';
        }
        field(58070; "_Tax Document Type"; Option)
        {
            Caption = 'Tax Document Type';
            OptionCaption = ' ,Document Post,Group Batch,Prompt';
            OptionMembers = " ","Document Post","Group Batch",Prompt;
            Description = 'NAV2013R2 Localization Customization Relic';
        }
        field(58071; "_Printed Tax Document"; Boolean)
        {
            Caption = 'Printed Tax Document';
            Editable = false;
            Description = 'NAV2013R2 Localization Customization Relic';
        }
        field(58072; "_Posted Tax Document"; Boolean)
        {
            Caption = 'Posted Tax Document';
            Editable = false;
            Description = 'NAV2013R2 Localization Customization Relic';
        }
        field(58073; "_Tax Document Marked"; Boolean)
        {
            Caption = 'Tax Document Marked';
            Editable = false;
            Description = 'NAV2013R2 Localization Customization Relic';
        }
    }
}

