tableextension 50019 "Sales & Receivables Setup" extends "Sales & Receivables Setup"
{
    // DP.RWP - Add new fields BarCode1,BarCode3,BarCode5,BarCode7 and "Allow Edit" for Patient Management System

    fields
    {
        field(50000; BarCode3; Code[20])
        {
            Description = 'For Patient System';
            TableRelation = Item;
        }
        field(50001; BarCode5; Code[20])
        {
            Description = 'For Patient System';
            TableRelation = Item;
        }
        field(50002; "Allow Edit"; Boolean)
        {
            Description = 'For Patient System';
        }
        field(50003; BarCode7; Code[20])
        {
            Description = 'For Patient System';
            TableRelation = Item;
        }
        field(50004; BarCode1; Code[20])
        {
            Description = 'For Patient System';
            TableRelation = Item;
        }
        field(51610; "_Pre-GST Prod. Posting Group"; Code[10])
        {
            Caption = 'Pre-GST Prod. Posting Group';
            TableRelation = "VAT Posting Setup"."VAT Prod. Posting Group";
            Description = 'NAV2013R2 Localization Customization Relic';
        }
        field(51611; "_Payment Discount Reason Code"; Code[10])
        {
            Caption = 'Payment Discount Reason Code';
            TableRelation = "Reason Code".Code;
            Description = 'NAV2013R2 Localization Customization Relic';
        }
        field(58040; "_Print WHT on Credit Memo"; Boolean)
        {
            Caption = 'Print WHT on Credit Memo';
            Description = 'NAV2013R2 Localization Customization Relic';
        }
        field(58041; "_Print Dialog"; Boolean)
        {
            Caption = 'Print Dialog';
            Description = 'NAV2013R2 Localization Customization Relic';
        }
        field(58070; "_Posted Tax Invoice Nos."; Code[10])
        {
            Caption = 'Posted Tax Invoice Nos.';
            TableRelation = "No. Series";
            Description = 'NAV2013R2 Localization Customization Relic';
        }
        field(58071; "_Posted Tax Credit Memo Nos"; Code[10])
        {
            Caption = 'Posted Tax Credit Memo Nos';
            TableRelation = "No. Series";
            Description = 'NAV2013R2 Localization Customization Relic';
        }
        field(58072; "_Posted Non Tax Invoice Nos."; Code[10])
        {
            Caption = 'Posted Non Tax Invoice Nos.';
            TableRelation = "No. Series";
            Description = 'NAV2013R2 Localization Customization Relic';
        }
        field(58073; "_Posted Non Tax Cr. Memo Nos"; Code[10])
        {
            Caption = 'Posted Non Tax Credit Memo Nos';
            TableRelation = "No. Series";
            Description = 'NAV2013R2 Localization Customization Relic';
        }
        field(58090; "_Post Dated Check Template"; Code[20])
        {
            Caption = 'Post Dated Check Template';
            TableRelation = "Gen. Journal Template";
            Description = 'NAV2013R2 Localization Customization Relic';
        }
        field(58091; "_Post Dated Check Batch"; Code[20])
        {
            Caption = 'Post Dated Check Batch';
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("_Post Dated Check Template"));
            Description = 'NAV2013R2 Localization Customization Relic';
        }
        field(58092; "_Incl. PDC in Cr. Limit Check"; Boolean)
        {
            Caption = 'Incl. PDC in Cr. Limit Check';
            Description = 'NAV2013R2 Localization Customization Relic';
        }
    }
}