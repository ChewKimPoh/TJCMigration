tableextension 50005 "Sales Line" extends "Sales Line"
{
    fields
    {
        field(50000; "Disc. Reason Code"; Code[10])
        {
            TableRelation = "Return Reason";
        }
        field(50001; "Cashier Code"; Code[10])
        {
            TableRelation = "Salesperson/Purchaser".Code WHERE(Type = CONST(Others));
        }
        field(50002; "Doctor Code"; Code[10])
        {
            TableRelation = "Salesperson/Purchaser".Code WHERE(Type = CONST(Others));
        }
        field(58040; "_WHT Business Posting Group"; Code[10])
        {
            Caption = 'WHT Business Posting Group';
            Description = 'NAV2013R2 Localization Customization Relic';
        }
        field(58041; "_WHT Product Posting Group"; Code[10])
        {
            Caption = 'WHT Product Posting Group';
            Description = 'NAV2013R2 Localization Customization Relic';
        }
        field(58042; "_WHT Absorb Base"; Decimal)
        {
            Caption = 'WHT Absorb Base';
            Description = 'NAV2013R2 Localization Customization Relic';
        }
    }
}

