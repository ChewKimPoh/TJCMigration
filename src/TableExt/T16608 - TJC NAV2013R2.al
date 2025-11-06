table 16608 "Temp WHT Entry - EFiling"
{
    Caption = 'Temp WHT Entry - EFiling';

    fields
    {
        field(1;"Entry No.";Integer)
        {
            Caption = 'Entry No.';
            Editable = false;
        }
        field(2;"Gen. Bus. Posting Group";Code[10])
        {
            Caption = 'Gen. Bus. Posting Group';
            Editable = false;
            TableRelation = "Gen. Business Posting Group";
        }
        field(3;"Gen. Prod. Posting Group";Code[10])
        {
            Caption = 'Gen. Prod. Posting Group';
            Editable = false;
            TableRelation = "Gen. Product Posting Group";
        }
        field(4;"Posting Date";Date)
        {
            Caption = 'Posting Date';
            Editable = false;
        }
        field(5;"Document No.";Code[20])
        {
            Caption = 'Document No.';
            Editable = false;
        }
        field(6;"Document Type";Option)
        {
            Caption = 'Document Type';
            Editable = false;
            OptionCaption = ' ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund';
            OptionMembers = " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund;
        }
        field(8;Base;Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Base';
            Editable = false;
        }
        field(9;Amount;Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Amount';
            Editable = false;
        }
        field(10;"WHT Calculation Type";Option)
        {
            Caption = 'WHT Calculation Type';
            Editable = false;
            OptionCaption = 'Normal WHT,Full WHT';
            OptionMembers = "Normal WHT","Full WHT";
        }
        field(11;"Currency Code";Code[10])
        {
            Caption = 'Currency Code';
        }
        field(12;"Bill-to/Pay-to No.";Code[20])
        {
            Caption = 'Bill-to/Pay-to No.';
            TableRelation = IF (Transaction Type=CONST(Purchase)) Vendor
                            ELSE IF (Transaction Type=CONST(Sale)) Customer;
        }
        field(14;"User ID";Code[20])
        {
            Caption = 'User ID';
            Editable = false;
            TableRelation = Table2000000002;
            //This property is currently not supported
            //TestTableRelation = false;

            trigger OnLookup()
            var
                LoginMgt: Codeunit "418";
            begin
                LoginMgt.LookupUserID("User ID");
            end;
        }
        field(15;"Source Code";Code[10])
        {
            Caption = 'Source Code';
            Editable = false;
            TableRelation = "Source Code";
        }
        field(16;"Reason Code";Code[10])
        {
            Caption = 'Reason Code';
            Editable = false;
            TableRelation = "Reason Code";
        }
        field(17;"Closed by Entry No.";Integer)
        {
            Caption = 'Closed by Entry No.';
            Editable = false;
            TableRelation = "Temp WHT Entry - EFiling";
        }
        field(18;Closed;Boolean)
        {
            Caption = 'Closed';
            Editable = false;
        }
        field(19;"Country/Region Code";Code[10])
        {
            Caption = 'Country/Region Code';
            TableRelation = Country/Region;

            trigger OnValidate()
            begin
                VALIDATE("Transaction Type");
            end;
        }
        field(21;"Transaction No.";Integer)
        {
            Caption = 'Transaction No.';
            Editable = false;
        }
        field(22;"Unrealized Amount";Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Unrealised Amount';
            Editable = false;
        }
        field(23;"Unrealized Base";Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Unrealised Base';
            Editable = false;
        }
        field(24;"Remaining Unrealized Amount";Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Remaining Unrealised Amount';
            Editable = false;
        }
        field(25;"Remaining Unrealized Base";Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Remaining Unrealised Base';
            Editable = false;
        }
        field(26;"External Document No.";Code[20])
        {
            Caption = 'External Document No.';
            Editable = false;
        }
        field(27;"Transaction Type";Option)
        {
            Caption = 'Transaction Type';
            OptionCaption = ' ,Purchase,Sale,Settlement';
            OptionMembers = " ",Purchase,Sale,Settlement;
        }
        field(28;"No. Series";Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(29;"Unrealized WHT Entry No.";Integer)
        {
            Caption = 'Unrealised WHT Entry No.';
            Editable = false;
            TableRelation = "Temp WHT Entry - EFiling";
        }
        field(30;"WHT Bus. Posting Group";Code[10])
        {
            Caption = 'WHT Bus. Posting Group';
            Editable = false;
            TableRelation = "WHT Business Posting Group";
        }
        field(31;"WHT Prod. Posting Group";Code[10])
        {
            Caption = 'WHT Prod. Posting Group';
            Editable = false;
            TableRelation = "WHT Product Posting Group";
        }
        field(32;"Base (LCY)";Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Base (LCY)';
            Editable = false;
        }
        field(33;"Amount (LCY)";Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Amount (LCY)';
            Editable = false;
        }
        field(34;"Unrealized Amount (LCY)";Decimal)
        {
            AutoFormatExpression = GetCurrencyCode;
            AutoFormatType = 1;
            Caption = 'Unrealised Amount (LCY)';
            Editable = false;
        }
        field(35;"Unrealized Base (LCY)";Decimal)
        {
            AutoFormatExpression = GetCurrencyCode;
            AutoFormatType = 1;
            Caption = 'Unrealised Base (LCY)';
            Editable = false;
        }
        field(36;"WHT %";Decimal)
        {
            Caption = 'WHT %';
            DecimalPlaces = 0:5;
            Editable = false;
            MaxValue = 100;
            MinValue = 0;
        }
        field(37;"Rem Unrealized Amount (LCY)";Decimal)
        {
            AutoFormatExpression = GetCurrencyCode;
            AutoFormatType = 1;
            Caption = 'Rem Unrealised Amount (LCY)';
            Editable = false;
        }
        field(38;"Rem Unrealized Base (LCY)";Decimal)
        {
            AutoFormatExpression = GetCurrencyCode;
            AutoFormatType = 1;
            Caption = 'Rem Unrealised Base (LCY)';
            Editable = false;
        }
        field(39;"WHT Difference";Decimal)
        {
            AutoFormatType = 1;
            Caption = 'WHT Difference';
            Editable = false;
        }
        field(41;"Ship-to/Order Address Code";Code[10])
        {
            Caption = 'Ship-to/Order Address Code';
            TableRelation = IF (Transaction Type=CONST(Purchase)) "Order Address".Code WHERE (Vendor No.=FIELD(Bill-to/Pay-to No.))
                            ELSE IF (Transaction Type=CONST(Sale)) "Ship-to Address".Code WHERE (Customer No.=FIELD(Bill-to/Pay-to No.));
        }
        field(42;"Document Date";Date)
        {
            Caption = 'Document Date';
            Editable = false;
        }
        field(44;"Actual Vendor No.";Code[20])
        {
            Caption = 'Actual Vendor No.';
        }
        field(45;"WHT Certificate No.";Code[20])
        {
            Caption = 'WHT Certificate No.';
        }
        field(47;"Void Check";Boolean)
        {
            Caption = 'Void Check';
        }
        field(48;"Original Document No.";Code[20])
        {
            Caption = 'Original Document No.';
        }
        field(49;"Void Payment Entry No.";Integer)
        {
            Caption = 'Void Payment Entry No.';
        }
        field(50;"WHT Report Line No";Code[10])
        {
            Caption = 'WHT Report Line No';
        }
        field(51;"WHT Report";Option)
        {
            Caption = 'WHT Report';
            OptionCaption = ' ,Por Ngor Dor 1,Por Ngor Dor 2,Por Ngor Dor 3,Por Ngor Dor 53,Por Ngor Dor 54';
            OptionMembers = " ","Por Ngor Dor 1","Por Ngor Dor 2","Por Ngor Dor 3","Por Ngor Dor 53","Por Ngor Dor 54";
        }
        field(52;"Applies-to Doc. Type";Option)
        {
            Caption = 'Applies-to Doc. Type';
            OptionCaption = ' ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund';
            OptionMembers = " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund;
        }
        field(53;"Applies-to Doc. No.";Code[20])
        {
            Caption = 'Applies-to Doc. No.';
        }
        field(54;"Applies-to Entry No.";Integer)
        {
            Caption = 'Applies-to Entry No.';
        }
        field(55;"WHT Revenue Type";Code[10])
        {
            Caption = 'WHT Revenue Type';
        }
    }

    keys
    {
        key(Key1;"Entry No.")
        {
        }
        key(Key2;"Transaction Type",Closed,"WHT Difference","Amount (LCY)","Base (LCY)","Posting Date")
        {
            SumIndexFields = Base,Amount,"Unrealized Amount","Unrealized Base";
        }
        key(Key3;"Transaction Type","Country/Region Code","WHT Difference","Posting Date")
        {
            SumIndexFields = Base;
        }
        key(Key4;"Document No.","Posting Date")
        {
        }
        key(Key5;"Transaction No.")
        {
        }
        key(Key6;"Amount (LCY)","Unrealized Amount (LCY)","Unrealized Base (LCY)","Base (LCY)","Posting Date")
        {
        }
        key(Key7;"Document Type","Document No.")
        {
            SumIndexFields = Base,Amount,"Unrealized Amount","Unrealized Base","Remaining Unrealized Amount","Remaining Unrealized Base","Base (LCY)","Amount (LCY)","Unrealized Amount (LCY)","Unrealized Base (LCY)";
        }
        key(Key8;"Transaction Type","Document No.","Document Type","Bill-to/Pay-to No.")
        {
        }
        key(Key9;"Applies-to Entry No.")
        {
            SumIndexFields = Base,Amount,"Unrealized Amount","Unrealized Base","Remaining Unrealized Amount","Remaining Unrealized Base","Base (LCY)","Amount (LCY)","Unrealized Amount (LCY)","Unrealized Base (LCY)";
        }
        key(Key10;"Bill-to/Pay-to No.","Original Document No.","WHT Revenue Type")
        {
        }
        key(Key11;"Bill-to/Pay-to No.","WHT Revenue Type","WHT Prod. Posting Group")
        {
        }
        key(Key12;"Bill-to/Pay-to No.","WHT Bus. Posting Group","WHT Revenue Type")
        {
        }
        key(Key13;"Posting Date")
        {
        }
        key(Key14;"WHT Revenue Type","Posting Date")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown;"Entry No.","Posting Date","Document No.",Amount)
        {
        }
    }

    var
        Cust: Record "18";
        Vend: Record "23";
        GLSetup: Record "98";
        GLSetupRead: Boolean;
        Text000: Label 'You cannot change the contents of this field when %1 is %2.';

    procedure GetCurrencyCode(): Code[10]
    begin
        IF NOT GLSetupRead THEN BEGIN
          GLSetup.GET;
          GLSetupRead := TRUE;
        END;
        EXIT(GLSetup."Additional Reporting Currency");
    end;
}

