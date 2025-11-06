table 311 "Sales & Receivables Setup"
{
    // DP.RWP - Add new fields BarCode1,BarCode3,BarCode5,BarCode7 and "Allow Edit" for Patient Management System

    Caption = 'Sales & Receivables Setup';

    fields
    {
        field(1;"Primary Key";Code[10])
        {
            Caption = 'Primary Key';
        }
        field(2;"Discount Posting";Option)
        {
            Caption = 'Discount Posting';
            OptionCaption = 'No Discounts,Invoice Discounts,Line Discounts,All Discounts';
            OptionMembers = "No Discounts","Invoice Discounts","Line Discounts","All Discounts";
        }
        field(4;"Credit Warnings";Option)
        {
            Caption = 'Credit Warnings';
            OptionCaption = 'Both Warnings,Credit Limit,Overdue Balance,No Warning';
            OptionMembers = "Both Warnings","Credit Limit","Overdue Balance","No Warning";
        }
        field(5;"Stockout Warning";Boolean)
        {
            Caption = 'Stockout Warning';
            InitValue = true;
        }
        field(6;"Shipment on Invoice";Boolean)
        {
            Caption = 'Shipment on Invoice';
        }
        field(7;"Invoice Rounding";Boolean)
        {
            Caption = 'Invoice Rounding';
        }
        field(8;"Ext. Doc. No. Mandatory";Boolean)
        {
            Caption = 'Ext. Doc. No. Mandatory';
        }
        field(9;"Customer Nos.";Code[10])
        {
            Caption = 'Customer Nos.';
            TableRelation = "No. Series";
        }
        field(10;"Quote Nos.";Code[10])
        {
            Caption = 'Quote Nos.';
            TableRelation = "No. Series";
        }
        field(11;"Order Nos.";Code[10])
        {
            Caption = 'Order Nos.';
            TableRelation = "No. Series";
        }
        field(12;"Invoice Nos.";Code[10])
        {
            Caption = 'Invoice Nos.';
            TableRelation = "No. Series";
        }
        field(13;"Posted Invoice Nos.";Code[10])
        {
            Caption = 'Posted Invoice Nos.';
            TableRelation = "No. Series";
        }
        field(14;"Credit Memo Nos.";Code[10])
        {
            Caption = 'Credit Memo Nos.';
            TableRelation = "No. Series";
        }
        field(15;"Posted Credit Memo Nos.";Code[10])
        {
            Caption = 'Posted Credit Memo Nos.';
            TableRelation = "No. Series";
        }
        field(16;"Posted Shipment Nos.";Code[10])
        {
            Caption = 'Posted Shipment Nos.';
            TableRelation = "No. Series";
        }
        field(17;"Reminder Nos.";Code[10])
        {
            Caption = 'Reminder Nos.';
            TableRelation = "No. Series";
        }
        field(18;"Issued Reminder Nos.";Code[10])
        {
            Caption = 'Issued Reminder Nos.';
            TableRelation = "No. Series";
        }
        field(19;"Fin. Chrg. Memo Nos.";Code[10])
        {
            Caption = 'Fin. Chrg. Memo Nos.';
            TableRelation = "No. Series";
        }
        field(20;"Issued Fin. Chrg. M. Nos.";Code[10])
        {
            Caption = 'Issued Fin. Chrg. M. Nos.';
            TableRelation = "No. Series";
        }
        field(21;"Posted Prepmt. Inv. Nos.";Code[10])
        {
            Caption = 'Posted Prepmt. Inv. Nos.';
            TableRelation = "No. Series";
        }
        field(22;"Posted Prepmt. Cr. Memo Nos.";Code[10])
        {
            Caption = 'Posted Prepmt. Cr. Memo Nos.';
            TableRelation = "No. Series";
        }
        field(23;"Blanket Order Nos.";Code[10])
        {
            Caption = 'Blanket Order Nos.';
            TableRelation = "No. Series";
        }
        field(24;"Calc. Inv. Discount";Boolean)
        {
            Caption = 'Calc. Inv. Discount';
        }
        field(25;"Appln. between Currencies";Option)
        {
            Caption = 'Appln. between Currencies';
            OptionCaption = 'None,EMU,All';
            OptionMembers = "None",EMU,All;
        }
        field(26;"Copy Comments Blanket to Order";Boolean)
        {
            Caption = 'Copy Comments Blanket to Order';
            InitValue = true;
        }
        field(27;"Copy Comments Order to Invoice";Boolean)
        {
            Caption = 'Copy Comments Order to Invoice';
            InitValue = true;
        }
        field(28;"Copy Comments Order to Shpt.";Boolean)
        {
            Caption = 'Copy Comments Order to Shpt.';
            InitValue = true;
        }
        field(29;"Allow VAT Difference";Boolean)
        {
            Caption = 'Allow VAT Difference';
        }
        field(30;"Calc. Inv. Disc. per VAT ID";Boolean)
        {
            Caption = 'Calc. Inv. Disc. per VAT ID';
        }
        field(31;"Logo Position on Documents";Option)
        {
            Caption = 'Logo Position on Documents';
            OptionCaption = 'No Logo,Left,Center,Right';
            OptionMembers = "No Logo",Left,Center,Right;
        }
        field(32;"Check Prepmt. when Posting";Boolean)
        {
            Caption = 'Check Prepmt. when Posting';
        }
        field(35;"Default Posting Date";Option)
        {
            Caption = 'Default Posting Date';
            OptionCaption = 'Work Date,No Date';
            OptionMembers = "Work Date","No Date";
        }
        field(36;"Default Quantity to Ship";Option)
        {
            Caption = 'Default Quantity to Ship';
            OptionCaption = 'Remainder,Blank';
            OptionMembers = Remainder,Blank;
        }
        field(37;"Archive Quotes and Orders";Boolean)
        {
            Caption = 'Archive Quotes and Orders';
        }
        field(38;"Post with Job Queue";Boolean)
        {
            Caption = 'Post with Job Queue';
        }
        field(39;"Job Queue Category Code";Code[10])
        {
            Caption = 'Job Queue Category Code';
            TableRelation = "Job Queue Category";
        }
        field(40;"Job Queue Priority for Post";Integer)
        {
            Caption = 'Job Queue Priority for Post';
            InitValue = 1000;
            MinValue = 0;

            trigger OnValidate()
            begin
                IF "Job Queue Priority for Post" < 0 THEN
                  ERROR(Text001);
            end;
        }
        field(41;"Post & Print with Job Queue";Boolean)
        {
            Caption = 'Post & Print with Job Queue';
        }
        field(42;"Job Q. Prio. for Post & Print";Integer)
        {
            Caption = 'Job Queue Priority for Post & Print';
            InitValue = 1000;
            MinValue = 0;

            trigger OnValidate()
            begin
                IF "Job Queue Priority for Post" < 0 THEN
                  ERROR(Text001);
            end;
        }
        field(43;"Notify On Success";Boolean)
        {
            Caption = 'Notify On Success';
        }
        field(44;"VAT Bus. Posting Gr. (Price)";Code[10])
        {
            Caption = 'VAT Bus. Posting Gr. (Price)';
            TableRelation = "VAT Business Posting Group";
        }
        field(45;"Direct Debit Mandate Nos.";Code[10])
        {
            Caption = 'Direct Debit Mandate Nos.';
            TableRelation = "No. Series";
        }
        field(5800;"Posted Return Receipt Nos.";Code[10])
        {
            Caption = 'Posted Return Receipt Nos.';
            TableRelation = "No. Series";
        }
        field(5801;"Copy Cmts Ret.Ord. to Ret.Rcpt";Boolean)
        {
            Caption = 'Copy Cmts Ret.Ord. to Ret.Rcpt';
            InitValue = true;
        }
        field(5802;"Copy Cmts Ret.Ord. to Cr. Memo";Boolean)
        {
            Caption = 'Copy Cmts Ret.Ord. to Cr. Memo';
            InitValue = true;
        }
        field(6600;"Return Order Nos.";Code[10])
        {
            Caption = 'Return Order Nos.';
            TableRelation = "No. Series";
        }
        field(6601;"Return Receipt on Credit Memo";Boolean)
        {
            Caption = 'Return Receipt on Credit Memo';
        }
        field(6602;"Exact Cost Reversing Mandatory";Boolean)
        {
            Caption = 'Exact Cost Reversing Mandatory';
        }
        field(7101;"Customer Group Dimension Code";Code[20])
        {
            Caption = 'Customer Group Dimension Code';
            TableRelation = Dimension;
        }
        field(7102;"Salesperson Dimension Code";Code[20])
        {
            Caption = 'Salesperson Dimension Code';
            TableRelation = Dimension;
        }
        field(50000;BarCode3;Code[20])
        {
            Description = 'For Patient System';
            TableRelation = Item;
        }
        field(50001;BarCode5;Code[20])
        {
            Description = 'For Patient System';
            TableRelation = Item;
        }
        field(50002;"Allow Edit";Boolean)
        {
            Description = 'For Patient System';
        }
        field(50003;BarCode7;Code[20])
        {
            Description = 'For Patient System';
            TableRelation = Item;
        }
        field(50004;BarCode1;Code[20])
        {
            Description = 'For Patient System';
            TableRelation = Item;
        }
        field(51610;"_Pre-GST Prod. Posting Group";Code[10])
        {
            Caption = 'Pre-GST Prod. Posting Group';
            TableRelation = "VAT Posting Setup"."VAT Prod. Posting Group";
        }
        field(51611;"_Payment Discount Reason Code";Code[10])
        {
            Caption = 'Payment Discount Reason Code';
            TableRelation = "Reason Code".Code;
        }
        field(58040;"_Print WHT on Credit Memo";Boolean)
        {
            Caption = 'Print WHT on Credit Memo';
        }
        field(58041;"_Print Dialog";Boolean)
        {
            Caption = 'Print Dialog';
        }
        field(58070;"_Posted Tax Invoice Nos.";Code[10])
        {
            Caption = 'Posted Tax Invoice Nos.';
            TableRelation = "No. Series";
        }
        field(58071;"_Posted Tax Credit Memo Nos";Code[10])
        {
            Caption = 'Posted Tax Credit Memo Nos';
            TableRelation = "No. Series";
        }
        field(58072;"_Posted Non Tax Invoice Nos.";Code[10])
        {
            Caption = 'Posted Non Tax Invoice Nos.';
            TableRelation = "No. Series";
        }
        field(58073;"_Posted Non Tax Cr. Memo Nos";Code[10])
        {
            Caption = 'Posted Non Tax Credit Memo Nos';
            TableRelation = "No. Series";
        }
        field(58090;"_Post Dated Check Template";Code[20])
        {
            Caption = 'Post Dated Check Template';
            TableRelation = "Gen. Journal Template";
        }
        field(58091;"_Post Dated Check Batch";Code[20])
        {
            Caption = 'Post Dated Check Batch';
            TableRelation = "Gen. Journal Batch".Name WHERE (Journal Template Name=FIELD(_Post Dated Check Template));
        }
        field(58092;"_Incl. PDC in Cr. Limit Check";Boolean)
        {
            Caption = 'Incl. PDC in Cr. Limit Check';
        }
    }

    keys
    {
        key(Key1;"Primary Key")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Text001: Label 'Job Queue Priority must be zero or positive.';

    procedure JobQueueActive(): Boolean
    begin
        GET;
        EXIT("Post with Job Queue" OR "Post & Print with Job Queue");
    end;
}

