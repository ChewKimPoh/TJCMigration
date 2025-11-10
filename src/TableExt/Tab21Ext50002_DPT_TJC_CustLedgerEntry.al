tableextension 50002 "Cust. Ledger Entry" extends "Cust. Ledger Entry"
{
    fields
    {
        field(51620; _Adjustment; Boolean)
        {
            Caption = 'Adjustment';
            Description = 'NAV2013R2 Localization Customization Relic';
        }
        field(51621; "_BAS Adjustment"; Boolean)
        {
            Caption = 'BAS Adjustment';
            Description = 'NAV2013R2 Localization Customization Relic';
        }
        field(51626; "_Adjustment Applies-to"; Code[20])
        {
            Caption = 'Adjustment Applies-to';
            Description = 'NAV2013R2 Localization Customization Relic';
        }
        field(51628; "_Pre Adjmt. Reason Code"; Code[10])
        {
            Caption = 'Pre Adjmt. Reason Code';
            TableRelation = "Reason Code";
            Description = 'NAV2013R2 Localization Customization Relic';
        }
        field(58040; "_Rem. Amt for WHT"; Decimal)
        {
            Caption = 'Rem. Amt for WHT';
            Description = 'NAV2013R2 Localization Customization Relic';
        }
        field(58041; "_Rem. Amt"; Decimal)
        {
            Caption = 'Rem. Amt';
            Description = 'NAV2013R2 Localization Customization Relic';
        }
        field(58042; "_WHT Amount"; Decimal)
        {
            Caption = 'WHT Amount';
            Editable = false;
            Description = 'NAV2013R2 Localization Customization Relic';
        }
        field(58043; "_WHT Amount (LCY)"; Decimal)
        {
            Caption = 'WHT Amount (LCY)';
            Editable = false;
            Description = 'NAV2013R2 Localization Customization Relic';
        }
        field(58044; "_WHT Payment"; Boolean)
        {
            Caption = 'WHT Payment';
            Description = 'NAV2013R2 Localization Customization Relic';
        }
    }
}