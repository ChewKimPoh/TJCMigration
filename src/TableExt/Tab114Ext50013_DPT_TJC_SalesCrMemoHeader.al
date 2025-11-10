tableextension 50013 "Sales Cr.Memo Header" extends "Sales Cr.Memo Header"
{
    fields
    {
        field(58040; "_WHT Business Posting Group"; Code[10])
        {
            Caption = 'WHT Business Posting Group';
            Description = 'NAV2013R2 Localization Customization Relic';
        }
        field(58041; "_Rem. WHT Prepaid Amount (LCY)"; Decimal)
        {
            Caption = 'Rem. WHT Prepaid Amount (LCY)';
            FieldClass = Normal;
            Description = 'NAV2013R2 Localization Customization Relic';
        }
        field(58042; "_Paid WHT Prepaid Amount (LCY)"; Decimal)
        {
            Caption = 'Paid WHT Prepaid Amount (LCY)';
            FieldClass = Normal;
            Description = 'NAV2013R2 Localization Customization Relic';
        }
        field(58043; "_Total WHT Prepaid Amt. (LCY)"; Decimal)
        {
            Caption = 'Total WHT Prepaid Amount (LCY)';
            FieldClass = Normal;
            Description = 'NAV2013R2 Localization Customization Relic';
        }
        field(58070; "_Tax Document Type"; Option)
        {
            Caption = 'Tax Document Type';
            Editable = false;
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
        field(58074; "_Tax Date Filter"; Date)
        {
            Caption = 'Tax Date Filter';
            FieldClass = FlowFilter;
            Description = 'NAV2013R2 Localization Customization Relic';
        }
        field(58075; "_Invoice Print Type"; Option)
        {
            Caption = 'Invoice Print Type';
            Editable = false;
            OptionCaption = 'Invoice,Tax Invoice (Items),Tax Invoice (Services)';
            OptionMembers = Invoice,"Tax Invoice (Items)","Tax Invoice (Services)";
            Description = 'NAV2013R2 Localization Customization Relic';
        }
    }
}