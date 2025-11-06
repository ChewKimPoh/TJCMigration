table 113 "Sales Invoice Line"
{
    // TJCRMS1.00
    // #1 26/03/2009  DP.SWJ
    //    - Populate three fields from Sales Line to Sales Invoice Line
    // 
    // 
    // 
    // Version No.         : TJCSG1.00
    // Developer           : DP.AYD
    // Init. DEV. Date     : 03/06/2014
    // Date of last Change : 03/06/2014
    // Description         : Based on DD#125 https://dptech.mydonedone.com/issuetracker/projects/4350/issues/125
    // 
    // 1. Add Keys :
    //    - Document No.,No.,Doctor Code

    Caption = 'Sales Invoice Line';
    DrillDownPageID = 526;
    LookupPageID = 526;
    Permissions = TableData 32=r,
                  TableData 5802=r;

    fields
    {
        field(2;"Sell-to Customer No.";Code[20])
        {
            Caption = 'Sell-to Customer No.';
            Editable = false;
            TableRelation = Customer;
        }
        field(3;"Document No.";Code[20])
        {
            Caption = 'Document No.';
            TableRelation = "Sales Invoice Header";
        }
        field(4;"Line No.";Integer)
        {
            Caption = 'Line No.';
        }
        field(5;Type;Option)
        {
            Caption = 'Type';
            OptionCaption = ' ,G/L Account,Item,Resource,Fixed Asset,Charge (Item)';
            OptionMembers = " ","G/L Account",Item,Resource,"Fixed Asset","Charge (Item)";
        }
        field(6;"No.";Code[20])
        {
            Caption = 'No.';
            TableRelation = IF (Type=CONST(G/L Account)) "G/L Account"
                            ELSE IF (Type=CONST(Item)) Item
                            ELSE IF (Type=CONST(Resource)) Resource
                            ELSE IF (Type=CONST(Fixed Asset)) "Fixed Asset"
                            ELSE IF (Type=CONST("Charge (Item)")) "Item Charge";
        }
        field(7;"Location Code";Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location WHERE (Use As In-Transit=CONST(No));
        }
        field(8;"Posting Group";Code[10])
        {
            Caption = 'Posting Group';
            Editable = false;
            TableRelation = IF (Type=CONST(Item)) "Inventory Posting Group"
                            ELSE IF (Type=CONST(Fixed Asset)) "FA Posting Group";
        }
        field(10;"Shipment Date";Date)
        {
            Caption = 'Shipment Date';
        }
        field(11;Description;Text[50])
        {
            Caption = 'Description';
        }
        field(12;"Description 2";Text[50])
        {
            Caption = 'Description 2';
        }
        field(13;"Unit of Measure";Text[10])
        {
            Caption = 'Unit of Measure';
        }
        field(15;Quantity;Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0:5;
        }
        field(22;"Unit Price";Decimal)
        {
            AutoFormatExpression = GetCurrencyCode;
            AutoFormatType = 2;
            CaptionClass = GetCaptionClass(FIELDNO("Unit Price"));
            Caption = 'Unit Price';
        }
        field(23;"Unit Cost (LCY)";Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Unit Cost (LCY)';
        }
        field(25;"VAT %";Decimal)
        {
            Caption = 'VAT %';
            DecimalPlaces = 0:5;
            Editable = false;
        }
        field(27;"Line Discount %";Decimal)
        {
            Caption = 'Line Discount %';
            DecimalPlaces = 0:5;
            MaxValue = 100;
            MinValue = 0;
        }
        field(28;"Line Discount Amount";Decimal)
        {
            AutoFormatExpression = GetCurrencyCode;
            AutoFormatType = 1;
            Caption = 'Line Discount Amount';
        }
        field(29;Amount;Decimal)
        {
            AutoFormatExpression = GetCurrencyCode;
            AutoFormatType = 1;
            Caption = 'Amount';
        }
        field(30;"Amount Including VAT";Decimal)
        {
            AutoFormatExpression = GetCurrencyCode;
            AutoFormatType = 1;
            Caption = 'Amount Including VAT';
        }
        field(32;"Allow Invoice Disc.";Boolean)
        {
            Caption = 'Allow Invoice Disc.';
            InitValue = true;
        }
        field(34;"Gross Weight";Decimal)
        {
            Caption = 'Gross Weight';
            DecimalPlaces = 0:5;
        }
        field(35;"Net Weight";Decimal)
        {
            Caption = 'Net Weight';
            DecimalPlaces = 0:5;
        }
        field(36;"Units per Parcel";Decimal)
        {
            Caption = 'Units per Parcel';
            DecimalPlaces = 0:5;
        }
        field(37;"Unit Volume";Decimal)
        {
            Caption = 'Unit Volume';
            DecimalPlaces = 0:5;
        }
        field(38;"Appl.-to Item Entry";Integer)
        {
            Caption = 'Appl.-to Item Entry';
        }
        field(40;"Shortcut Dimension 1 Code";Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
        }
        field(41;"Shortcut Dimension 2 Code";Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
        }
        field(42;"Customer Price Group";Code[10])
        {
            Caption = 'Customer Price Group';
            TableRelation = "Customer Price Group";
        }
        field(45;"Job No.";Code[20])
        {
            Caption = 'Job No.';
            TableRelation = Job;
        }
        field(52;"Work Type Code";Code[10])
        {
            Caption = 'Work Type Code';
            TableRelation = "Work Type";
        }
        field(63;"Shipment No.";Code[20])
        {
            Caption = 'Shipment No.';
            Editable = false;
        }
        field(64;"Shipment Line No.";Integer)
        {
            Caption = 'Shipment Line No.';
            Editable = false;
        }
        field(68;"Bill-to Customer No.";Code[20])
        {
            Caption = 'Bill-to Customer No.';
            Editable = false;
            TableRelation = Customer;
        }
        field(69;"Inv. Discount Amount";Decimal)
        {
            AutoFormatExpression = GetCurrencyCode;
            AutoFormatType = 1;
            Caption = 'Inv. Discount Amount';
        }
        field(73;"Drop Shipment";Boolean)
        {
            Caption = 'Drop Shipment';
        }
        field(74;"Gen. Bus. Posting Group";Code[10])
        {
            Caption = 'Gen. Bus. Posting Group';
            TableRelation = "Gen. Business Posting Group";
        }
        field(75;"Gen. Prod. Posting Group";Code[10])
        {
            Caption = 'Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group";
        }
        field(77;"VAT Calculation Type";Option)
        {
            Caption = 'VAT Calculation Type';
            OptionCaption = 'Normal VAT,Reverse Charge VAT,Full VAT,Sales Tax';
            OptionMembers = "Normal VAT","Reverse Charge VAT","Full VAT","Sales Tax";
        }
        field(78;"Transaction Type";Code[10])
        {
            Caption = 'Transaction Type';
            TableRelation = "Transaction Type";
        }
        field(79;"Transport Method";Code[10])
        {
            Caption = 'Transport Method';
            TableRelation = "Transport Method";
        }
        field(80;"Attached to Line No.";Integer)
        {
            Caption = 'Attached to Line No.';
            TableRelation = "Sales Invoice Line"."Line No." WHERE (Document No.=FIELD(Document No.));
        }
        field(81;"Exit Point";Code[10])
        {
            Caption = 'Exit Point';
            TableRelation = "Entry/Exit Point";
        }
        field(82;"Area";Code[10])
        {
            Caption = 'Area';
            TableRelation = Area;
        }
        field(83;"Transaction Specification";Code[10])
        {
            Caption = 'Transaction Specification';
            TableRelation = "Transaction Specification";
        }
        field(85;"Tax Area Code";Code[20])
        {
            Caption = 'Tax Area Code';
            TableRelation = "Tax Area";
        }
        field(86;"Tax Liable";Boolean)
        {
            Caption = 'Tax Liable';
        }
        field(87;"Tax Group Code";Code[10])
        {
            Caption = 'Tax Group Code';
            TableRelation = "Tax Group";
        }
        field(88;"VAT Clause Code";Code[10])
        {
            Caption = 'VAT Clause Code';
            TableRelation = "VAT Clause";
        }
        field(89;"VAT Bus. Posting Group";Code[10])
        {
            Caption = 'VAT Bus. Posting Group';
            TableRelation = "VAT Business Posting Group";
        }
        field(90;"VAT Prod. Posting Group";Code[10])
        {
            Caption = 'VAT Prod. Posting Group';
            TableRelation = "VAT Product Posting Group";
        }
        field(97;"Blanket Order No.";Code[20])
        {
            Caption = 'Blanket Order No.';
            TableRelation = "Sales Header".No. WHERE (Document Type=CONST(Blanket Order));
            //This property is currently not supported
            //TestTableRelation = false;
        }
        field(98;"Blanket Order Line No.";Integer)
        {
            Caption = 'Blanket Order Line No.';
            TableRelation = "Sales Line"."Line No." WHERE (Document Type=CONST(Blanket Order),
                                                           Document No.=FIELD(Blanket Order No.));
            //This property is currently not supported
            //TestTableRelation = false;
        }
        field(99;"VAT Base Amount";Decimal)
        {
            AutoFormatExpression = GetCurrencyCode;
            AutoFormatType = 1;
            Caption = 'VAT Base Amount';
            Editable = false;
        }
        field(100;"Unit Cost";Decimal)
        {
            AutoFormatExpression = GetCurrencyCode;
            AutoFormatType = 2;
            Caption = 'Unit Cost';
            Editable = false;
        }
        field(101;"System-Created Entry";Boolean)
        {
            Caption = 'System-Created Entry';
            Editable = false;
        }
        field(103;"Line Amount";Decimal)
        {
            AutoFormatExpression = GetCurrencyCode;
            AutoFormatType = 1;
            CaptionClass = GetCaptionClass(FIELDNO("Line Amount"));
            Caption = 'Line Amount';
        }
        field(104;"VAT Difference";Decimal)
        {
            AutoFormatExpression = GetCurrencyCode;
            AutoFormatType = 1;
            Caption = 'VAT Difference';
        }
        field(106;"VAT Identifier";Code[10])
        {
            Caption = 'VAT Identifier';
            Editable = false;
        }
        field(107;"IC Partner Ref. Type";Option)
        {
            Caption = 'IC Partner Ref. Type';
            OptionCaption = ' ,G/L Account,Item,,,Charge (Item),Cross reference,Common Item No.';
            OptionMembers = " ","G/L Account",Item,,,"Charge (Item)","Cross reference","Common Item No.";
        }
        field(108;"IC Partner Reference";Code[20])
        {
            Caption = 'IC Partner Reference';
        }
        field(123;"Prepayment Line";Boolean)
        {
            Caption = 'Prepayment Line';
            Editable = false;
        }
        field(130;"IC Partner Code";Code[20])
        {
            Caption = 'IC Partner Code';
            TableRelation = "IC Partner";
        }
        field(131;"Posting Date";Date)
        {
            Caption = 'Posting Date';
        }
        field(480;"Dimension Set ID";Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup()
            begin
                ShowDimensions;
            end;
        }
        field(1001;"Job Task No.";Code[20])
        {
            Caption = 'Job Task No.';
            Editable = false;
            TableRelation = "Job Task"."Job Task No." WHERE (Job No.=FIELD(Job No.));
        }
        field(1002;"Job Contract Entry No.";Integer)
        {
            Caption = 'Job Contract Entry No.';
            Editable = false;
        }
        field(5402;"Variant Code";Code[10])
        {
            Caption = 'Variant Code';
            TableRelation = IF (Type=CONST(Item)) "Item Variant".Code WHERE (Item No.=FIELD(No.));
        }
        field(5403;"Bin Code";Code[20])
        {
            Caption = 'Bin Code';
            TableRelation = Bin.Code WHERE (Location Code=FIELD(Location Code),
                                            Item Filter=FIELD(No.),
                                            Variant Filter=FIELD(Variant Code));
        }
        field(5404;"Qty. per Unit of Measure";Decimal)
        {
            Caption = 'Qty. per Unit of Measure';
            DecimalPlaces = 0:5;
            Editable = false;
        }
        field(5407;"Unit of Measure Code";Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = IF (Type=CONST(Item)) "Item Unit of Measure".Code WHERE (Item No.=FIELD(No.))
                            ELSE "Unit of Measure";
        }
        field(5415;"Quantity (Base)";Decimal)
        {
            Caption = 'Quantity (Base)';
            DecimalPlaces = 0:5;
        }
        field(5600;"FA Posting Date";Date)
        {
            Caption = 'FA Posting Date';
        }
        field(5602;"Depreciation Book Code";Code[10])
        {
            Caption = 'Depreciation Book Code';
            TableRelation = "Depreciation Book";
        }
        field(5605;"Depr. until FA Posting Date";Boolean)
        {
            Caption = 'Depr. until FA Posting Date';
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
        field(5700;"Responsibility Center";Code[10])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility Center";
        }
        field(5705;"Cross-Reference No.";Code[20])
        {
            Caption = 'Cross-Reference No.';
        }
        field(5706;"Unit of Measure (Cross Ref.)";Code[10])
        {
            Caption = 'Unit of Measure (Cross Ref.)';
            TableRelation = IF (Type=CONST(Item)) "Item Unit of Measure".Code WHERE (Item No.=FIELD(No.));
        }
        field(5707;"Cross-Reference Type";Option)
        {
            Caption = 'Cross-Reference Type';
            OptionCaption = ' ,Customer,Vendor,Bar Code';
            OptionMembers = " ",Customer,Vendor,"Bar Code";
        }
        field(5708;"Cross-Reference Type No.";Code[30])
        {
            Caption = 'Cross-Reference Type No.';
        }
        field(5709;"Item Category Code";Code[10])
        {
            Caption = 'Item Category Code';
            TableRelation = IF (Type=CONST(Item)) "Item Category";
        }
        field(5710;Nonstock;Boolean)
        {
            Caption = 'Nonstock';
        }
        field(5711;"Purchasing Code";Code[10])
        {
            Caption = 'Purchasing Code';
            TableRelation = Purchasing;
        }
        field(5712;"Product Group Code";Code[10])
        {
            Caption = 'Product Group Code';
            TableRelation = "Product Group".Code WHERE (Item Category Code=FIELD(Item Category Code));
        }
        field(5811;"Appl.-from Item Entry";Integer)
        {
            Caption = 'Appl.-from Item Entry';
            MinValue = 0;
        }
        field(6608;"Return Reason Code";Code[10])
        {
            Caption = 'Return Reason Code';
        }
        field(7001;"Allow Line Disc.";Boolean)
        {
            Caption = 'Allow Line Disc.';
            InitValue = true;
        }
        field(7002;"Customer Disc. Group";Code[20])
        {
            Caption = 'Customer Disc. Group';
            TableRelation = "Customer Discount Group";
        }
        field(50000;"Disc. Reason Code";Code[10])
        {
            TableRelation = "Return Reason";
        }
        field(50001;"Cashier Code";Code[10])
        {
            TableRelation = Salesperson/Purchaser.Code WHERE (Type=CONST(Others));
        }
        field(50002;"Doctor Code";Code[10])
        {
            TableRelation = Salesperson/Purchaser.Code WHERE (Type=CONST(Others));
        }
    }

    keys
    {
        key(Key1;"Document No.","Line No.")
        {
            MaintainSIFTIndex = false;
            SumIndexFields = Amount,"Amount Including VAT";
        }
        key(Key2;"Blanket Order No.","Blanket Order Line No.")
        {
        }
        key(Key3;"Sell-to Customer No.")
        {
        }
        key(Key4;"Sell-to Customer No.",Type,"Document No.")
        {
            MaintainSQLIndex = false;
        }
        key(Key5;"Shipment No.","Shipment Line No.")
        {
        }
        key(Key6;"Job Contract Entry No.")
        {
        }
        key(Key7;"Bill-to Customer No.")
        {
        }
        key(Key8;"Document No.",Type)
        {
        }
        key(Key9;"Document No.","No.","Doctor Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        SalesDocLineComments: Record "44";
    begin
        SalesDocLineComments.SETRANGE("Document Type",SalesDocLineComments."Document Type"::"Posted Invoice");
        SalesDocLineComments.SETRANGE("No.","Document No.");
        SalesDocLineComments.SETRANGE("Document Line No.","Line No.");
        IF NOT SalesDocLineComments.ISEMPTY THEN
          SalesDocLineComments.DELETEALL;
    end;

    var
        DimMgt: Codeunit "408";

    procedure GetCurrencyCode(): Code[10]
    var
        SalesInvHeader: Record "112";
    begin
        IF "Document No." = SalesInvHeader."No." THEN
          EXIT(SalesInvHeader."Currency Code");
        IF SalesInvHeader.GET("Document No.") THEN
          EXIT(SalesInvHeader."Currency Code");
        EXIT('');
    end;

    procedure ShowDimensions()
    begin
        DimMgt.ShowDimensionSet("Dimension Set ID",STRSUBSTNO('%1 %2 %3',TABLECAPTION,"Document No.","Line No."));
    end;

    procedure ShowItemTrackingLines()
    var
        ItemTrackingMgt: Codeunit "6500";
    begin
        ItemTrackingMgt.CallPostedItemTrackingForm3(RowID1);
    end;

    procedure CalcVATAmountLines(var SalesInvHeader: Record "112";var VATAmountLine: Record "290")
    begin
        VATAmountLine.DELETEALL;
        SETRANGE("Document No.",SalesInvHeader."No.");
        IF FIND('-') THEN
          REPEAT
            VATAmountLine.INIT;
            VATAmountLine."VAT Identifier" := "VAT Identifier";
            VATAmountLine."VAT Calculation Type" := "VAT Calculation Type";
            VATAmountLine."Tax Group Code" := "Tax Group Code";
            VATAmountLine."VAT %" := "VAT %";
            VATAmountLine."VAT Base" := Amount;
            VATAmountLine."VAT Amount" := "Amount Including VAT" - Amount;
            VATAmountLine."Amount Including VAT" := "Amount Including VAT";
            VATAmountLine."Line Amount" := "Line Amount";
            IF "Allow Invoice Disc." THEN
              VATAmountLine."Inv. Disc. Base Amount" := "Line Amount";
            VATAmountLine."Invoice Discount Amount" := "Inv. Discount Amount";
            VATAmountLine.Quantity := "Quantity (Base)";
            VATAmountLine."Calculated VAT Amount" := "Amount Including VAT" - Amount - "VAT Difference";
            VATAmountLine."VAT Difference" := "VAT Difference";
            VATAmountLine.InsertLine;
          UNTIL NEXT = 0;
    end;

    local procedure GetFieldCaption(FieldNumber: Integer): Text[100]
    var
        "Field": Record "2000000041";
    begin
        Field.GET(DATABASE::"Sales Invoice Line",FieldNumber);
        EXIT(Field."Field Caption");
    end;

    local procedure GetCaptionClass(FieldNumber: Integer): Text[80]
    var
        SalesInvHeader: Record "112";
    begin
        IF NOT SalesInvHeader.GET("Document No.") THEN
          SalesInvHeader.INIT;
        IF SalesInvHeader."Prices Including VAT" THEN
          EXIT('2,1,' + GetFieldCaption(FieldNumber));

        EXIT('2,0,' + GetFieldCaption(FieldNumber));
    end;

    procedure RowID1(): Text[250]
    var
        ItemTrackingMgt: Codeunit "6500";
    begin
        EXIT(ItemTrackingMgt.ComposeRowID(DATABASE::"Sales Invoice Line",
            0,"Document No.",'',0,"Line No."));
    end;

    procedure GetSalesShptLines(var TempSalesShptLine: Record "111" temporary)
    var
        SalesShptLine: Record "111";
        ItemLedgEntry: Record "32";
        ValueEntry: Record "5802";
    begin
        TempSalesShptLine.RESET;
        TempSalesShptLine.DELETEALL;

        IF Type <> Type::Item THEN
          EXIT;

        FilterPstdDocLineValueEntries(ValueEntry);
        IF ValueEntry.FINDSET THEN
          REPEAT
            ItemLedgEntry.GET(ValueEntry."Item Ledger Entry No.");
            IF ItemLedgEntry."Document Type" = ItemLedgEntry."Document Type"::"Sales Shipment" THEN
              IF SalesShptLine.GET(ItemLedgEntry."Document No.",ItemLedgEntry."Document Line No.") THEN BEGIN
                TempSalesShptLine.INIT;
                TempSalesShptLine := SalesShptLine;
                IF TempSalesShptLine.INSERT THEN;
              END;
          UNTIL ValueEntry.NEXT = 0;
    end;

    procedure CalcShippedSaleNotReturned(var ShippedQtyNotReturned: Decimal;var RevUnitCostLCY: Decimal;ExactCostReverse: Boolean): Decimal
    var
        TempItemLedgEntry: Record "32" temporary;
        TotalCostLCY: Decimal;
        TotalQtyBase: Decimal;
    begin
        ShippedQtyNotReturned := 0;
        IF (Type <> Type::Item) OR (Quantity <= 0) THEN BEGIN
          RevUnitCostLCY := "Unit Cost (LCY)";
          EXIT;
        END;

        RevUnitCostLCY := 0;
        GetItemLedgEntries(TempItemLedgEntry,FALSE);
        IF TempItemLedgEntry.FINDSET THEN
          REPEAT
            ShippedQtyNotReturned := ShippedQtyNotReturned - TempItemLedgEntry."Shipped Qty. Not Returned";
            IF ExactCostReverse THEN BEGIN
              TempItemLedgEntry.CALCFIELDS("Cost Amount (Expected)","Cost Amount (Actual)");
              TotalCostLCY :=
                TotalCostLCY + TempItemLedgEntry."Cost Amount (Expected)" + TempItemLedgEntry."Cost Amount (Actual)";
              TotalQtyBase := TotalQtyBase + TempItemLedgEntry.Quantity;
            END;
          UNTIL TempItemLedgEntry.NEXT = 0;

        IF ExactCostReverse AND (ShippedQtyNotReturned <> 0) AND (TotalQtyBase <> 0) THEN
          RevUnitCostLCY := ABS(TotalCostLCY / TotalQtyBase) * "Qty. per Unit of Measure"
        ELSE
          RevUnitCostLCY := "Unit Cost (LCY)";
        ShippedQtyNotReturned := CalcQty(ShippedQtyNotReturned);

        IF ShippedQtyNotReturned > Quantity THEN
          ShippedQtyNotReturned := Quantity;
    end;

    local procedure CalcQty(QtyBase: Decimal): Decimal
    begin
        IF "Qty. per Unit of Measure" = 0 THEN
          EXIT(QtyBase);
        EXIT(ROUND(QtyBase / "Qty. per Unit of Measure",0.00001));
    end;

    procedure GetItemLedgEntries(var TempItemLedgEntry: Record "32" temporary;SetQuantity: Boolean)
    var
        ItemLedgEntry: Record "32";
        ValueEntry: Record "5802";
    begin
        IF SetQuantity THEN BEGIN
          TempItemLedgEntry.RESET;
          TempItemLedgEntry.DELETEALL;

          IF Type <> Type::Item THEN
            EXIT;
        END;

        FilterPstdDocLineValueEntries(ValueEntry);
        ValueEntry.SETFILTER("Invoiced Quantity",'<>0');
        IF ValueEntry.FINDSET THEN
          REPEAT
            ItemLedgEntry.GET(ValueEntry."Item Ledger Entry No.");
            TempItemLedgEntry := ItemLedgEntry;
            IF SetQuantity THEN BEGIN
              TempItemLedgEntry.Quantity := ValueEntry."Invoiced Quantity";
              IF ABS(TempItemLedgEntry."Shipped Qty. Not Returned") > ABS(TempItemLedgEntry.Quantity) THEN
                TempItemLedgEntry."Shipped Qty. Not Returned" := TempItemLedgEntry.Quantity;
            END;
            IF TempItemLedgEntry.INSERT THEN;
          UNTIL ValueEntry.NEXT = 0;
    end;

    procedure FilterPstdDocLineValueEntries(var ValueEntry: Record "5802")
    begin
        ValueEntry.RESET;
        ValueEntry.SETCURRENTKEY("Document No.");
        ValueEntry.SETRANGE("Document No.","Document No.");
        ValueEntry.SETRANGE("Document Type",ValueEntry."Document Type"::"Sales Invoice");
        ValueEntry.SETRANGE("Document Line No.","Line No.");
    end;

    procedure ShowItemLedgEntries()
    var
        TempItemLedgEntry: Record "32" temporary;
    begin
        IF Type = Type::Item THEN BEGIN
          GetItemLedgEntries(TempItemLedgEntry,FALSE);
          PAGE.RUNMODAL(0,TempItemLedgEntry);
        END;
    end;

    procedure ShowItemShipmentLines()
    var
        TempSalesShptLine: Record "111" temporary;
    begin
        IF Type = Type::Item THEN BEGIN
          GetSalesShptLines(TempSalesShptLine);
          PAGE.RUNMODAL(0,TempSalesShptLine);
        END;
    end;

    procedure ShowLineComments()
    var
        SalesDocLineComments: Record "44";
        SalesDocCommentSheet: Page "67";
    begin
        SalesDocLineComments.SETRANGE("Document Type",SalesDocLineComments."Document Type"::"Posted Invoice");
        SalesDocLineComments.SETRANGE("No.","Document No.");
        SalesDocLineComments.SETRANGE("Document Line No.","Line No.");
        SalesDocCommentSheet.SETTABLEVIEW(SalesDocLineComments);
        SalesDocCommentSheet.RUNMODAL;
    end;
}

