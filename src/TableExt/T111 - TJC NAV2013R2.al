table 111 "Sales Shipment Line"
{
    // TJCRMS1.00
    // #1 26/03/2009  DP.SWJ
    //    - Populate three fields from Sales Line to Sales Invoice Line
    //   DP.NCM TJC DD 299 18032015 - Bring Bin Code over from Shipment Line

    Caption = 'Sales Shipment Line';
    DrillDownPageID = 525;
    LookupPageID = 525;
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
            TableRelation = "Sales Shipment Header";
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
        field(39;"Item Shpt. Entry No.";Integer)
        {
            Caption = 'Item Shpt. Entry No.';
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
        field(58;"Qty. Shipped Not Invoiced";Decimal)
        {
            Caption = 'Qty. Shipped Not Invoiced';
            DecimalPlaces = 0:5;
            Editable = false;
        }
        field(61;"Quantity Invoiced";Decimal)
        {
            Caption = 'Quantity Invoiced';
            DecimalPlaces = 0:5;
            Editable = false;
        }
        field(65;"Order No.";Code[20])
        {
            Caption = 'Order No.';
        }
        field(66;"Order Line No.";Integer)
        {
            Caption = 'Order Line No.';
        }
        field(68;"Bill-to Customer No.";Code[20])
        {
            Caption = 'Bill-to Customer No.';
            Editable = false;
            TableRelation = Customer;
        }
        field(71;"Purchase Order No.";Code[20])
        {
            Caption = 'Purchase Order No.';
        }
        field(72;"Purch. Order Line No.";Integer)
        {
            Caption = 'Purch. Order Line No.';
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
            TableRelation = "Sales Shipment Line"."Line No." WHERE (Document No.=FIELD(Document No.));
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
        field(91;"Currency Code";Code[10])
        {
            CalcFormula = Lookup("Sales Shipment Header"."Currency Code" WHERE (No.=FIELD(Document No.)));
            Caption = 'Currency Code';
            Editable = false;
            FieldClass = FlowField;
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
        field(826;"Authorized for Credit Card";Boolean)
        {
            Caption = 'Authorized for Credit Card';
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
        field(5461;"Qty. Invoiced (Base)";Decimal)
        {
            Caption = 'Qty. Invoiced (Base)';
            DecimalPlaces = 0:5;
            Editable = false;
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
        field(5790;"Requested Delivery Date";Date)
        {
            Caption = 'Requested Delivery Date';
            Editable = false;
        }
        field(5791;"Promised Delivery Date";Date)
        {
            Caption = 'Promised Delivery Date';
            Editable = false;
        }
        field(5792;"Shipping Time";DateFormula)
        {
            Caption = 'Shipping Time';
        }
        field(5793;"Outbound Whse. Handling Time";DateFormula)
        {
            Caption = 'Outbound Whse. Handling Time';
        }
        field(5794;"Planned Delivery Date";Date)
        {
            Caption = 'Planned Delivery Date';
            Editable = false;
        }
        field(5795;"Planned Shipment Date";Date)
        {
            Caption = 'Planned Shipment Date';
            Editable = false;
        }
        field(5811;"Appl.-from Item Entry";Integer)
        {
            Caption = 'Appl.-from Item Entry';
            MinValue = 0;
        }
        field(5812;"Item Charge Base Amount";Decimal)
        {
            AutoFormatExpression = GetCurrencyCode;
            AutoFormatType = 1;
            Caption = 'Item Charge Base Amount';
        }
        field(5817;Correction;Boolean)
        {
            Caption = 'Correction';
            Editable = false;
        }
        field(6608;"Return Reason Code";Code[10])
        {
            Caption = 'Return Reason Code';
            TableRelation = "Return Reason";
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
        }
        key(Key2;"Order No.","Order Line No.")
        {
        }
        key(Key3;"Blanket Order No.","Blanket Order Line No.")
        {
        }
        key(Key4;"Item Shpt. Entry No.")
        {
        }
        key(Key5;"Sell-to Customer No.")
        {
        }
        key(Key6;"Bill-to Customer No.")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown;"Document No.","Line No.","Sell-to Customer No.",Type,"No.","Shipment Date")
        {
        }
    }

    trigger OnDelete()
    var
        ServItem: Record "5940";
        SalesDocLineComments: Record "44";
    begin
        ServItem.RESET;
        ServItem.SETCURRENTKEY("Sales/Serv. Shpt. Document No.","Sales/Serv. Shpt. Line No.");
        ServItem.SETRANGE("Sales/Serv. Shpt. Document No.","Document No.");
        ServItem.SETRANGE("Sales/Serv. Shpt. Line No.","Line No.");
        ServItem.SETRANGE("Shipment Type",ServItem."Shipment Type"::Sales);
        IF ServItem.FIND('-') THEN
          REPEAT
            ServItem.VALIDATE("Sales/Serv. Shpt. Document No.",'');
            ServItem.VALIDATE("Sales/Serv. Shpt. Line No.",0);
            ServItem.MODIFY(TRUE);
          UNTIL ServItem.NEXT = 0;

        SalesDocLineComments.SETRANGE("Document Type",SalesDocLineComments."Document Type"::Shipment);
        SalesDocLineComments.SETRANGE("No.","Document No.");
        SalesDocLineComments.SETRANGE("Document Line No.","Line No.");
        IF NOT SalesDocLineComments.ISEMPTY THEN
          SalesDocLineComments.DELETEALL;

        PostedATOLink.DeleteAsmFromSalesShptLine(Rec);
    end;

    var
        Text000: Label 'Shipment No. %1:';
        Text001: Label 'The program cannot find this Sales line.';
        Currency: Record "4";
        SalesShptHeader: Record "110";
        PostedATOLink: Record "914";
        DimMgt: Codeunit "408";
        CurrencyRead: Boolean;

    procedure GetCurrencyCode(): Code[10]
    begin
        IF "Document No." = SalesShptHeader."No." THEN
          EXIT(SalesShptHeader."Currency Code");
        IF SalesShptHeader.GET("Document No.") THEN
          EXIT(SalesShptHeader."Currency Code");
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
        ItemTrackingMgt.CallPostedItemTrackingForm(DATABASE::"Sales Shipment Line",0,"Document No.",'',0,"Line No.");
    end;

    procedure InsertInvLineFromShptLine(var SalesLine: Record "37")
    var
        SalesInvHeader: Record "36";
        SalesOrderHeader: Record "36";
        SalesOrderLine: Record "37";
        TempSalesLine: Record "37" temporary;
        SalesSetup: Record "311";
        TransferOldExtLines: Codeunit "379";
        ItemTrackingMgt: Codeunit "6500";
        ExtTextLine: Boolean;
        NextLineNo: Integer;
    begin
        SETRANGE("Document No.","Document No.");

        TempSalesLine := SalesLine;
        IF SalesLine.FIND('+') THEN
          NextLineNo := SalesLine."Line No." + 10000
        ELSE
          NextLineNo := 10000;

        IF SalesInvHeader."No." <> TempSalesLine."Document No." THEN
          SalesInvHeader.GET(TempSalesLine."Document Type",TempSalesLine."Document No.");

        IF SalesLine."Shipment No." <> "Document No." THEN BEGIN
          SalesLine.INIT;
          SalesLine."Line No." := NextLineNo;
          SalesLine."Document Type" := TempSalesLine."Document Type";
          SalesLine."Document No." := TempSalesLine."Document No.";
          SalesLine.Description := STRSUBSTNO(Text000,"Document No.");
          SalesLine.INSERT;
          NextLineNo := NextLineNo + 10000;
        END;

        TransferOldExtLines.ClearLineNumbers;

        REPEAT
          ExtTextLine := (TransferOldExtLines.GetNewLineNumber("Attached to Line No.") <> 0);

          IF SalesOrderLine.GET(
               SalesOrderLine."Document Type"::Order,"Order No.","Order Line No.")
          THEN BEGIN
            IF (SalesOrderHeader."Document Type" <> SalesOrderLine."Document Type"::Order) OR
               (SalesOrderHeader."No." <> SalesOrderLine."Document No.")
            THEN
              SalesOrderHeader.GET(SalesOrderLine."Document Type"::Order,"Order No.");

            InitCurrency("Currency Code");

            IF SalesInvHeader."Prices Including VAT" THEN BEGIN
              IF NOT SalesOrderHeader."Prices Including VAT" THEN
                SalesOrderLine."Unit Price" :=
                  ROUND(
                    SalesOrderLine."Unit Price" * (1 + SalesOrderLine."VAT %" / 100),
                    Currency."Unit-Amount Rounding Precision");
            END ELSE BEGIN
              IF SalesOrderHeader."Prices Including VAT" THEN
                SalesOrderLine."Unit Price" :=
                  ROUND(
                    SalesOrderLine."Unit Price" / (1 + SalesOrderLine."VAT %" / 100),
                    Currency."Unit-Amount Rounding Precision");
            END;
          END ELSE BEGIN
            SalesOrderHeader.INIT;
            IF ExtTextLine OR (Type = Type::" ") THEN BEGIN
              SalesOrderLine.INIT;
              SalesOrderLine."Line No." := "Order Line No.";
              SalesOrderLine.Description := Description;
              SalesOrderLine."Description 2" := "Description 2";
            END ELSE
              ERROR(Text001);
          END;

          SalesLine := SalesOrderLine;
          SalesLine."Line No." := NextLineNo;
          SalesLine."Document Type" := TempSalesLine."Document Type";
          SalesLine."Document No." := TempSalesLine."Document No.";
          SalesLine."Variant Code" := "Variant Code";
          SalesLine."Location Code" := "Location Code";
          SalesLine."Quantity (Base)" := 0;
          SalesLine.Quantity := 0;
          SalesLine."Outstanding Qty. (Base)" := 0;
          SalesLine."Outstanding Quantity" := 0;
          SalesLine."Quantity Shipped" := 0;
          SalesLine."Qty. Shipped (Base)" := 0;
          SalesLine."Quantity Invoiced" := 0;
          SalesLine."Qty. Invoiced (Base)" := 0;
          SalesLine.Amount := 0;
          SalesLine."Amount Including VAT" := 0;
          SalesLine."Purchase Order No." := '';
          SalesLine."Purch. Order Line No." := 0;
          SalesLine."Drop Shipment" := "Drop Shipment";
          SalesLine."Special Order Purchase No." := '';
          SalesLine."Special Order Purch. Line No." := 0;
          SalesLine."Special Order" := FALSE;
          SalesLine."Shipment No." := "Document No.";
          SalesLine."Shipment Line No." := "Line No.";
          SalesLine."Appl.-to Item Entry" := 0;
          SalesLine."Appl.-from Item Entry" := 0;
          SalesLine."Prepmt. Amt. Inv." := 0;
          IF NOT ExtTextLine AND (SalesLine.Type <> 0) THEN BEGIN
            SalesLine.VALIDATE(Quantity,Quantity - "Quantity Invoiced");
            SalesLine.VALIDATE("Unit Price",SalesOrderLine."Unit Price");
            SalesLine."Allow Line Disc." := SalesOrderLine."Allow Line Disc.";
            SalesLine."Allow Invoice Disc." := SalesOrderLine."Allow Invoice Disc.";
            SalesLine.VALIDATE(
              "Line Discount Amount",
              ROUND(
                SalesOrderLine."Line Discount Amount" * SalesLine.Quantity / SalesOrderLine.Quantity,
                Currency."Amount Rounding Precision"));
            SalesLine."Line Discount %" := SalesOrderLine."Line Discount %";
            SalesLine.UpdatePrePaymentAmounts;
            SalesSetup.GET;
            IF NOT SalesSetup."Calc. Inv. Discount" THEN
              IF SalesOrderLine.Quantity = 0 THEN
                SalesLine.VALIDATE("Inv. Discount Amount",0)
              ELSE BEGIN
                SalesLine.VALIDATE(
                  "Inv. Discount Amount",
                  ROUND(
                    SalesOrderLine."Inv. Discount Amount" * SalesLine.Quantity / SalesOrderLine.Quantity,
                    Currency."Amount Rounding Precision"));
                SalesLine.VALIDATE("Prepmt. Amt. Inv.",SalesOrderLine."Prepmt. Amt. Inv.");
              END;
          END;

          SalesLine."Attached to Line No." :=
            TransferOldExtLines.TransferExtendedText(
              SalesOrderLine."Line No.",
              NextLineNo,
              SalesOrderLine."Attached to Line No.");
          SalesLine."Shortcut Dimension 1 Code" := "Shortcut Dimension 1 Code";
          SalesLine."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
          SalesLine."Dimension Set ID" := "Dimension Set ID";
          //DP.NCM TJC DD 299
          IF SalesLine.Type = SalesLine.Type::Item THEN
            SalesLine.VALIDATE("Bin Code","Bin Code");
          //DP.NCM TJC DD 299
          SalesLine.INSERT;

          ItemTrackingMgt.CopyHandledItemTrkgToInvLine(SalesOrderLine,SalesLine);

          NextLineNo := NextLineNo + 10000;
          IF "Attached to Line No." = 0 THEN
            SETRANGE("Attached to Line No.","Line No.");
        UNTIL (NEXT = 0) OR ("Attached to Line No." = 0);

        IF SalesOrderHeader.GET(SalesOrderHeader."Document Type"::Order,"Order No.") THEN BEGIN
          SalesOrderHeader."Get Shipment Used" := TRUE;
          SalesOrderHeader.MODIFY;
        END;
    end;

    procedure GetSalesInvLines(var TempSalesInvLine: Record "113" temporary)
    var
        SalesInvLine: Record "113";
        ItemLedgEntry: Record "32";
        ValueEntry: Record "5802";
    begin
        TempSalesInvLine.RESET;
        TempSalesInvLine.DELETEALL;

        IF Type <> Type::Item THEN
          EXIT;

        FilterPstdDocLnItemLedgEntries(ItemLedgEntry);
        ItemLedgEntry.SETFILTER("Invoiced Quantity",'<>0');
        IF ItemLedgEntry.FINDSET THEN BEGIN
          ValueEntry.SETCURRENTKEY("Item Ledger Entry No.","Entry Type");
          ValueEntry.SETRANGE("Entry Type",ValueEntry."Entry Type"::"Direct Cost");
          ValueEntry.SETFILTER("Invoiced Quantity",'<>0');
          REPEAT
            ValueEntry.SETRANGE("Item Ledger Entry No.",ItemLedgEntry."Entry No.");
            IF ValueEntry.FINDSET THEN
              REPEAT
                IF ValueEntry."Document Type" = ValueEntry."Document Type"::"Sales Invoice" THEN
                  IF SalesInvLine.GET(ValueEntry."Document No.",ValueEntry."Document Line No.") THEN BEGIN
                    TempSalesInvLine.INIT;
                    TempSalesInvLine := SalesInvLine;
                    IF TempSalesInvLine.INSERT THEN;
                  END;
              UNTIL ValueEntry.NEXT = 0;
          UNTIL ItemLedgEntry.NEXT = 0;
        END;
    end;

    procedure CalcShippedSaleNotReturned(var ShippedQtyNotReturned: Decimal;var RevUnitCostLCY: Decimal;ExactCostReverse: Boolean)
    var
        ItemLedgEntry: Record "32";
        TotalCostLCY: Decimal;
        TotalQtyBase: Decimal;
    begin
        ShippedQtyNotReturned := 0;
        IF (Type <> Type::Item) OR (Quantity <= 0) THEN BEGIN
          RevUnitCostLCY := "Unit Cost (LCY)";
          EXIT;
        END;

        RevUnitCostLCY := 0;
        FilterPstdDocLnItemLedgEntries(ItemLedgEntry);
        IF ItemLedgEntry.FINDSET THEN
          REPEAT
            ShippedQtyNotReturned := ShippedQtyNotReturned - ItemLedgEntry."Shipped Qty. Not Returned";
            IF ExactCostReverse THEN BEGIN
              ItemLedgEntry.CALCFIELDS("Cost Amount (Expected)","Cost Amount (Actual)");
              TotalCostLCY :=
                TotalCostLCY + ItemLedgEntry."Cost Amount (Expected)" + ItemLedgEntry."Cost Amount (Actual)";
              TotalQtyBase := TotalQtyBase + ItemLedgEntry.Quantity;
            END;
          UNTIL ItemLedgEntry.NEXT = 0;

        IF ExactCostReverse AND (ShippedQtyNotReturned <> 0) AND (TotalQtyBase <> 0) THEN
          RevUnitCostLCY := ABS(TotalCostLCY / TotalQtyBase) * "Qty. per Unit of Measure"
        ELSE
          RevUnitCostLCY := "Unit Cost (LCY)";

        ShippedQtyNotReturned := CalcQty(ShippedQtyNotReturned);
    end;

    local procedure CalcQty(QtyBase: Decimal): Decimal
    begin
        IF "Qty. per Unit of Measure" = 0 THEN
          EXIT(QtyBase);
        EXIT(ROUND(QtyBase / "Qty. per Unit of Measure",0.00001));
    end;

    procedure FilterPstdDocLnItemLedgEntries(var ItemLedgEntry: Record "32")
    begin
        ItemLedgEntry.RESET;
        ItemLedgEntry.SETCURRENTKEY("Document No.");
        ItemLedgEntry.SETRANGE("Document No.","Document No.");
        ItemLedgEntry.SETRANGE("Document Type",ItemLedgEntry."Document Type"::"Sales Shipment");
        ItemLedgEntry.SETRANGE("Document Line No.","Line No.");
    end;

    procedure ShowItemLedgEntries()
    var
        ItemLedgEntry: Record "32";
    begin
        IF Type = Type::Item THEN BEGIN
          FilterPstdDocLnItemLedgEntries(ItemLedgEntry);
          PAGE.RUNMODAL(0,ItemLedgEntry);
        END;
    end;

    procedure ShowItemSalesInvLines()
    var
        TempSalesInvLine: Record "113" temporary;
    begin
        IF Type = Type::Item THEN BEGIN
          GetSalesInvLines(TempSalesInvLine);
          PAGE.RUNMODAL(PAGE::"Posted Sales Invoice Lines",TempSalesInvLine);
        END;
    end;

    local procedure InitCurrency(CurrencyCode: Code[10])
    begin
        IF (Currency.Code = CurrencyCode) AND CurrencyRead THEN
          EXIT;

        IF CurrencyCode <> '' THEN
          Currency.GET(CurrencyCode)
        ELSE
          Currency.InitRoundingPrecision;
        CurrencyRead := TRUE;
    end;

    procedure ShowLineComments()
    var
        SalesDocLineComments: Record "44";
        SalesDocCommentSheet: Page "67";
    begin
        SalesDocLineComments.SETRANGE("Document Type",SalesDocLineComments."Document Type"::Shipment);
        SalesDocLineComments.SETRANGE("No.","Document No.");
        SalesDocLineComments.SETRANGE("Document Line No.","Line No.");
        SalesDocCommentSheet.SETTABLEVIEW(SalesDocLineComments);
        SalesDocCommentSheet.RUNMODAL;
    end;

    procedure ShowAsmToOrder()
    begin
        PostedATOLink.ShowPostedAsm(Rec);
    end;

    procedure AsmToShipmentExists(var PostedAsmHeader: Record "910"): Boolean
    var
        PostedAssembleToOrderLink: Record "914";
    begin
        IF NOT PostedAssembleToOrderLink.AsmExistsForPostedShipmentLine(Rec) THEN
          EXIT(FALSE);
        EXIT(PostedAsmHeader.GET(PostedAssembleToOrderLink."Assembly Document No."));
    end;
}

