tableextension 50017 "Purch. Cr. Memo Hdr." extends "Purch. Cr. Memo Hdr."
{
    fields
    {
        field(50001; "Printing Version"; Code[20])
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
        field(51620; _ABN; Text[14])
        {
            Caption = 'ABN';
            Editable = false;
            Numeric = true;
            Description = 'NAV2013R2 Localization Customization Relic';
        }
        field(51622; "_ABN Division Part No."; Text[3])
        {
            Caption = 'ABN Division Part No.';
            Description = 'NAV2013R2 Localization Customization Relic';
        }
        field(58040; "_WHT Business Posting Group"; Code[10])
        {
            Caption = 'WHT Business Posting Group';
            TableRelation = "No. Series";
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
        field(58045; "_Actual Vendor No."; Code[20])
        {
            Caption = 'Actual Vendor No.';
            TableRelation = Vendor;
            Description = 'NAV2013R2 Localization Customization Relic';
        }
        field(58070; "_Printed Tax Document"; Boolean)
        {
            Caption = 'Printed Tax Document';
            Editable = false;
            Description = 'NAV2013R2 Localization Customization Relic';
        }
        field(58071; "_Posted Tax Document"; Boolean)
        {
            Caption = 'Posted Tax Document';
            Editable = false;
            Description = 'NAV2013R2 Localization Customization Relic';
        }
        field(58073; "_Tax Date Filter"; Date)
        {
            Caption = 'Tax Date Filter';
            FieldClass = FlowFilter;
            Description = 'NAV2013R2 Localization Customization Relic';
        }
        field(58074; "_Tax Document Marked"; Boolean)
        {
            Caption = 'Tax Document Marked';
            Editable = false;
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