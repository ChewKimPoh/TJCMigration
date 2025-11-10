tableextension 50006 "Purchase Header" extends "Purchase Header"
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
            Description = 'NAV2013R2 Localization Customization Relic';
        }
        field(58044; "_Actual Vendor No."; Code[20])
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
        field(58072; "_Tax Document Posting Date"; Date)
        {
            Caption = 'Tax Document Posting Date';
            Editable = false;
            Description = 'NAV2013R2 Localization Customization Relic';
        }
        field(58087; "_Vendor Exchange Rate (ACY)"; Decimal)
        {
            Caption = 'Vendor Exchange Rate (ACY)';
            DecimalPlaces = 0 : 15;
            Description = 'NAV2013R2 Localization Customization Relic';
        }
    }
}

