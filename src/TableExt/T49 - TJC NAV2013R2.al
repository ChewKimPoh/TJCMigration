table 49 "Invoice Post. Buffer"
{
    // DP.NCM TJC #449 04/04/2018 - Add field 50000 Line Description

    Caption = 'Invoice Post. Buffer';

    fields
    {
        field(1;Type;Option)
        {
            Caption = 'Type';
            OptionCaption = 'Prepmt. Exch. Rate Difference,G/L Account,Item,Resource,Fixed Asset';
            OptionMembers = "Prepmt. Exch. Rate Difference","G/L Account",Item,Resource,"Fixed Asset";
        }
        field(2;"G/L Account";Code[20])
        {
            Caption = 'G/L Account';
            TableRelation = "G/L Account";
        }
        field(4;"Global Dimension 1 Code";Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
        }
        field(5;"Global Dimension 2 Code";Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
        }
        field(6;"Job No.";Code[20])
        {
            Caption = 'Job No.';
            TableRelation = Job;
        }
        field(7;Amount;Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Amount';
        }
        field(8;"VAT Amount";Decimal)
        {
            AutoFormatType = 1;
            Caption = 'VAT Amount';
        }
        field(10;"Gen. Bus. Posting Group";Code[10])
        {
            Caption = 'Gen. Bus. Posting Group';
            TableRelation = "Gen. Business Posting Group";
        }
        field(11;"Gen. Prod. Posting Group";Code[10])
        {
            Caption = 'Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group";
        }
        field(12;"VAT Calculation Type";Option)
        {
            Caption = 'VAT Calculation Type';
            OptionCaption = 'Normal VAT,Reverse Charge VAT,Full VAT,Sales Tax';
            OptionMembers = "Normal VAT","Reverse Charge VAT","Full VAT","Sales Tax";
        }
        field(14;"VAT Base Amount";Decimal)
        {
            AutoFormatType = 1;
            Caption = 'VAT Base Amount';
        }
        field(17;"System-Created Entry";Boolean)
        {
            Caption = 'System-Created Entry';
        }
        field(18;"Tax Area Code";Code[20])
        {
            Caption = 'Tax Area Code';
            TableRelation = "Tax Area";
        }
        field(19;"Tax Liable";Boolean)
        {
            Caption = 'Tax Liable';
        }
        field(20;"Tax Group Code";Code[10])
        {
            Caption = 'Tax Group Code';
            TableRelation = "Tax Group";
        }
        field(21;Quantity;Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 1:5;
        }
        field(22;"Use Tax";Boolean)
        {
            Caption = 'Use Tax';
        }
        field(23;"VAT Bus. Posting Group";Code[10])
        {
            Caption = 'VAT Bus. Posting Group';
            TableRelation = "VAT Business Posting Group";
        }
        field(24;"VAT Prod. Posting Group";Code[10])
        {
            Caption = 'VAT Prod. Posting Group';
            TableRelation = "VAT Product Posting Group";
        }
        field(25;"Amount (ACY)";Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Amount (ACY)';
        }
        field(26;"VAT Amount (ACY)";Decimal)
        {
            AutoFormatType = 1;
            Caption = 'VAT Amount (ACY)';
        }
        field(29;"VAT Base Amount (ACY)";Decimal)
        {
            AutoFormatType = 1;
            Caption = 'VAT Base Amount (ACY)';
        }
        field(31;"VAT Difference";Decimal)
        {
            AutoFormatType = 1;
            Caption = 'VAT Difference';
        }
        field(32;"VAT %";Decimal)
        {
            Caption = 'VAT %';
            DecimalPlaces = 1:1;
        }
        field(480;"Dimension Set ID";Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";
        }
        field(5600;"FA Posting Date";Date)
        {
            Caption = 'FA Posting Date';
        }
        field(5601;"FA Posting Type";Option)
        {
            Caption = 'FA Posting Type';
            OptionCaption = ' ,Acquisition Cost,Maintenance';
            OptionMembers = " ","Acquisition Cost",Maintenance;
        }
        field(5602;"Depreciation Book Code";Code[10])
        {
            Caption = 'Depreciation Book Code';
            TableRelation = "Depreciation Book";
        }
        field(5603;"Salvage Value";Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Salvage Value';
        }
        field(5605;"Depr. until FA Posting Date";Boolean)
        {
            Caption = 'Depr. until FA Posting Date';
        }
        field(5606;"Depr. Acquisition Cost";Boolean)
        {
            Caption = 'Depr. Acquisition Cost';
        }
        field(5609;"Maintenance Code";Code[10])
        {
            Caption = 'Maintenance Code';
            TableRelation = Maintenance;
        }
        field(5610;"Insurance No.";Code[20])
        {
            Caption = 'Insurance No.';
            TableRelation = Insurance;
        }
        field(5611;"Budgeted FA No.";Code[20])
        {
            Caption = 'Budgeted FA No.';
            TableRelation = "Fixed Asset";
        }
        field(5612;"Duplicate in Depreciation Book";Code[10])
        {
            Caption = 'Duplicate in Depreciation Book';
            TableRelation = "Depreciation Book";
        }
        field(5613;"Use Duplication List";Boolean)
        {
            Caption = 'Use Duplication List';
        }
        field(5614;"Fixed Asset Line No.";Integer)
        {
            Caption = 'Fixed Asset Line No.';
        }
        field(50000;"Line Description";Text[250])
        {
        }
    }

    keys
    {
        key(Key1;Type,"G/L Account","Gen. Bus. Posting Group","Gen. Prod. Posting Group","VAT Bus. Posting Group","VAT Prod. Posting Group","Tax Area Code","Tax Group Code","Tax Liable","Use Tax","Dimension Set ID","Job No.","Fixed Asset Line No.")
        {
        }
    }

    fieldgroups
    {
    }

    procedure PrepareSales(var SalesLine: Record "37")
    begin
        CLEAR(Rec);
        Type := SalesLine.Type;
        "System-Created Entry" := TRUE;
        "Gen. Bus. Posting Group" := SalesLine."Gen. Bus. Posting Group";
        "Gen. Prod. Posting Group" := SalesLine."Gen. Prod. Posting Group";
        "VAT Bus. Posting Group" := SalesLine."VAT Bus. Posting Group";
        "VAT Prod. Posting Group" := SalesLine."VAT Prod. Posting Group";
        "VAT Calculation Type" := SalesLine."VAT Calculation Type";
        "Global Dimension 1 Code" := SalesLine."Shortcut Dimension 1 Code";
        "Global Dimension 2 Code" := SalesLine."Shortcut Dimension 2 Code";
        "Dimension Set ID" := SalesLine."Dimension Set ID";
        "Job No." := SalesLine."Job No.";
        "VAT %" := SalesLine."VAT %";
        "VAT Difference" := SalesLine."VAT Difference";
        IF Type = Type::"Fixed Asset" THEN BEGIN
          "FA Posting Date" := SalesLine."FA Posting Date";
          "Depreciation Book Code" := SalesLine."Depreciation Book Code";
          "Depr. until FA Posting Date" := SalesLine."Depr. until FA Posting Date";
          "Duplicate in Depreciation Book" := SalesLine."Duplicate in Depreciation Book";
          "Use Duplication List" := SalesLine."Use Duplication List";
        END;

        IF "VAT Calculation Type" = "VAT Calculation Type"::"Sales Tax" THEN BEGIN
          "Tax Area Code" := SalesLine."Tax Area Code";
          "Tax Group Code" := SalesLine."Tax Group Code";
          "Tax Liable" := SalesLine."Tax Liable";
          "Use Tax" := FALSE;
          Quantity := SalesLine."Qty. to Invoice (Base)";
        END;
    end;

    procedure CalcDiscount(PricesInclVAT: Boolean;DiscountAmount: Decimal;DiscountAmountACY: Decimal)
    var
        CurrencyLCY: Record "4";
        CurrencyACY: Record "4";
        GLSetup: Record "98";
    begin
        CurrencyLCY.InitRoundingPrecision;
        GLSetup.GET;
        IF GLSetup."Additional Reporting Currency" <> '' THEN
          CurrencyACY.GET(GLSetup."Additional Reporting Currency")
        ELSE
          CurrencyACY := CurrencyLCY;
        "VAT Amount" := ROUND(
            CalcVATAmount(PricesInclVAT,DiscountAmount,"VAT %"),
            CurrencyLCY."Amount Rounding Precision",
            CurrencyLCY.VATRoundingDirection);
        "VAT Amount (ACY)" := ROUND(
            CalcVATAmount(PricesInclVAT,DiscountAmountACY,"VAT %"),
            CurrencyACY."Amount Rounding Precision",
            CurrencyACY.VATRoundingDirection);

        IF PricesInclVAT AND ("VAT %" <> 0) THEN BEGIN
          "VAT Base Amount" := DiscountAmount - "VAT Amount";
          "VAT Base Amount (ACY)" := DiscountAmountACY - "VAT Amount (ACY)";
        END ELSE BEGIN
          "VAT Base Amount" := DiscountAmount;
          "VAT Base Amount (ACY)" := DiscountAmountACY;
        END;
        Amount := "VAT Base Amount";
        "Amount (ACY)" := "VAT Base Amount (ACY)";
    end;

    local procedure CalcVATAmount(ValueInclVAT: Boolean;Value: Decimal;"VAT%": Decimal): Decimal
    begin
        IF "VAT%" = 0 THEN
          EXIT(0);
        IF ValueInclVAT THEN
          EXIT(Value / (1 + ("VAT%" / 100)) * ("VAT%" / 100));

        EXIT(Value * ("VAT%" / 100));
    end;

    procedure SetAccount(Account: Code[20];var TotalVAT: Decimal;var TotalVATACY: Decimal;var TotalAmount: Decimal;var TotalAmountACY: Decimal)
    begin
        TotalVAT := TotalVAT - "VAT Amount";
        TotalVATACY := TotalVATACY - "VAT Amount (ACY)";
        TotalAmount := TotalAmount - Amount;
        TotalAmountACY := TotalAmountACY - "Amount (ACY)";
        "G/L Account" := Account;
    end;

    procedure SetAmounts(TotalVAT: Decimal;TotalVATACY: Decimal;TotalAmount: Decimal;TotalAmountACY: Decimal;VATDifference: Decimal)
    begin
        Amount := TotalAmount;
        "VAT Base Amount" := TotalAmount;
        "VAT Amount" := TotalVAT;
        "Amount (ACY)" := TotalAmountACY;
        "VAT Base Amount (ACY)" := TotalAmountACY;
        "VAT Amount (ACY)" := TotalVATACY;
        "VAT Difference" := "VAT Difference";
    end;

    procedure PreparePurchase(var PurchLine: Record "39")
    begin
        CLEAR(Rec);
        Type := PurchLine.Type;
        "System-Created Entry" := TRUE;
        "Gen. Bus. Posting Group" := PurchLine."Gen. Bus. Posting Group";
        "Gen. Prod. Posting Group" := PurchLine."Gen. Prod. Posting Group";
        "VAT Bus. Posting Group" := PurchLine."VAT Bus. Posting Group";
        "VAT Prod. Posting Group" := PurchLine."VAT Prod. Posting Group";
        "VAT Calculation Type" := PurchLine."VAT Calculation Type";
        "Global Dimension 1 Code" := PurchLine."Shortcut Dimension 1 Code";
        "Global Dimension 2 Code" := PurchLine."Shortcut Dimension 2 Code";
        "Dimension Set ID" := PurchLine."Dimension Set ID";
        "Job No." := PurchLine."Job No.";
        "VAT %" := PurchLine."VAT %";
        "VAT Difference" := PurchLine."VAT Difference";
        IF Type = Type::"Fixed Asset" THEN BEGIN
          "FA Posting Date" := PurchLine."FA Posting Date";
          "Depreciation Book Code" := PurchLine."Depreciation Book Code";
          "Depr. until FA Posting Date" := PurchLine."Depr. until FA Posting Date";
          "Duplicate in Depreciation Book" := PurchLine."Duplicate in Depreciation Book";
          "Use Duplication List" := PurchLine."Use Duplication List";
          "FA Posting Type" := PurchLine."FA Posting Type";
          "Depreciation Book Code" := PurchLine."Depreciation Book Code";
          "Salvage Value" := PurchLine."Salvage Value";
          "Depr. Acquisition Cost" := PurchLine."Depr. Acquisition Cost";
          "Maintenance Code" := PurchLine."Maintenance Code";
          "Insurance No." := PurchLine."Insurance No.";
          "Budgeted FA No." := PurchLine."Budgeted FA No.";
        END;

        IF "VAT Calculation Type" = "VAT Calculation Type"::"Sales Tax" THEN BEGIN
          "Tax Area Code" := PurchLine."Tax Area Code";
          "Tax Group Code" := PurchLine."Tax Group Code";
          "Tax Liable" := PurchLine."Tax Liable";
          "Use Tax" := FALSE;
          Quantity := PurchLine."Qty. to Invoice (Base)";
        END;
    end;

    procedure CalcDiscountNoVAT(DiscountAmount: Decimal;DiscountAmountACY: Decimal)
    begin
        "VAT Base Amount" := DiscountAmount;
        "VAT Base Amount (ACY)" := DiscountAmountACY;
        Amount := "VAT Base Amount";
        "Amount (ACY)" := "VAT Base Amount (ACY)";
    end;

    procedure SetSalesTax(PurchaseLine: Record "39")
    begin
        "Tax Area Code" := PurchaseLine."Tax Area Code";
        "Tax Liable" := PurchaseLine."Tax Liable";
        "Tax Group Code" := PurchaseLine."Tax Group Code";
        "Use Tax" := PurchaseLine."Use Tax";
        Quantity := PurchaseLine."Qty. to Invoice (Base)";
    end;

    procedure ReverseAmounts()
    begin
        Amount := -Amount;
        "VAT Base Amount" := -"VAT Base Amount";
        "Amount (ACY)" := -"Amount (ACY)";
        "VAT Base Amount (ACY)" := -"VAT Base Amount (ACY)";
        "VAT Amount" := -"VAT Amount";
        "VAT Amount (ACY)" := -"VAT Amount (ACY)";
    end;

    procedure SetAmountsNoVAT(TotalAmount: Decimal;TotalAmountACY: Decimal;VATDifference: Decimal)
    begin
        Amount := TotalAmount;
        "VAT Base Amount" := TotalAmount;
        "VAT Amount" := 0;
        "Amount (ACY)" := TotalAmountACY;
        "VAT Base Amount (ACY)" := TotalAmountACY;
        "VAT Amount (ACY)" := 0;
        "VAT Difference" := "VAT Difference";
    end;

    procedure PrepareService(var ServiceLine: Record "5902")
    begin
        CLEAR(Rec);
        CASE ServiceLine.Type OF
          ServiceLine.Type::Item:
            Type := Type::Item;
          ServiceLine.Type::Resource:
            Type := Type::Resource;
          ServiceLine.Type::"G/L Account":
            Type := Type::"G/L Account";
        END;
        "System-Created Entry" := TRUE;
        "Gen. Bus. Posting Group" := ServiceLine."Gen. Bus. Posting Group";
        "Gen. Prod. Posting Group" := ServiceLine."Gen. Prod. Posting Group";
        "VAT Bus. Posting Group" := ServiceLine."VAT Bus. Posting Group";
        "VAT Prod. Posting Group" := ServiceLine."VAT Prod. Posting Group";
        "VAT Calculation Type" := ServiceLine."VAT Calculation Type";
        "Global Dimension 1 Code" := ServiceLine."Shortcut Dimension 1 Code";
        "Global Dimension 2 Code" := ServiceLine."Shortcut Dimension 2 Code";
        "Dimension Set ID" := ServiceLine."Dimension Set ID";
        "Job No." := ServiceLine."Job No.";
        "VAT %" := ServiceLine."VAT %";
        "VAT Difference" := ServiceLine."VAT Difference";
        IF "VAT Calculation Type" = "VAT Calculation Type"::"Sales Tax" THEN BEGIN
          "Tax Area Code" := ServiceLine."Tax Area Code";
          "Tax Group Code" := ServiceLine."Tax Group Code";
          "Tax Liable" := ServiceLine."Tax Liable";
          "Use Tax" := FALSE;
          Quantity := ServiceLine."Qty. to Invoice (Base)";
        END;
    end;
}

