table 25004 "Kit Sales Shipment Line"
{
    Caption = 'Kit Sales Shipment Line';
    DrillDownPageID = 25005;
    LookupPageID = 25005;
    PasteIsValid = false;

    fields
    {
        field(2;"Document No.";Code[20])
        {
            Caption = 'Document No.';
            TableRelation = "Sales Shipment Header";
        }
        field(3;"Document Line No.";Integer)
        {
            Caption = 'Document Line No.';
            TableRelation = "Sales Shipment Line"."Line No." WHERE (Document No.=FIELD(Document No.));
        }
        field(4;"Line No.";Integer)
        {
            Caption = 'Line No.';
        }
        field(5;Type;Option)
        {
            Caption = 'Type';
            OptionCaption = ' ,Item,,Resource,Setup Resource';
            OptionMembers = " ",Item,,Resource,"Setup Resource";
        }
        field(6;"No.";Code[20])
        {
            Caption = 'No.';
            TableRelation = IF (Type=CONST(Item)) Item
                            ELSE IF (Type=FILTER(Resource|Setup Resource)) Resource;
        }
        field(7;Description;Text[50])
        {
            Caption = 'Description';
        }
        field(8;"Description 2";Text[50])
        {
            Caption = 'Description 2';
        }
        field(9;"Variant Code";Code[10])
        {
            Caption = 'Variant Code';
            TableRelation = IF (Type=CONST(Item)) "Item Variant".Code WHERE (Item No.=FIELD(No.));
        }
        field(10;"Location Code";Code[10])
        {
            Caption = 'Location Code';
            Editable = false;
            TableRelation = Location;
        }
        field(11;"Unit of Measure Code";Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = IF (Type=CONST(Item)) "Item Unit of Measure".Code WHERE (Item No.=FIELD(No.))
                            ELSE IF (Type=FILTER(Resource|Setup Resource)) "Resource Unit of Measure".Code WHERE (Resource No.=FIELD(No.))
                            ELSE "Unit of Measure";
        }
        field(12;"Unit of Measure";Text[10])
        {
            Caption = 'Unit of Measure';
        }
        field(13;"Qty. per Unit of Measure";Decimal)
        {
            Caption = 'Qty. per Unit of Measure';
            DecimalPlaces = 0:5;
            Editable = false;
            InitValue = 1;
        }
        field(14;"Quantity per";Decimal)
        {
            Caption = 'Quantity per';
            DecimalPlaces = 0:5;
        }
        field(15;"Quantity per (Base)";Decimal)
        {
            Caption = 'Quantity per (Base)';
            DecimalPlaces = 0:5;
            Editable = false;
        }
        field(16;"Extended Quantity";Decimal)
        {
            Caption = 'Extended Quantity';
            DecimalPlaces = 0:5;
            Editable = false;
        }
        field(17;"Extended Quantity (Base)";Decimal)
        {
            Caption = 'Extended Quantity (Base)';
            DecimalPlaces = 0:5;
            Editable = false;
        }
        field(23;"Shipment Date";Date)
        {
            Caption = 'Shipment Date';
            Editable = false;
        }
        field(26;"Shortcut Dimension 1 Code";Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
        }
        field(27;"Shortcut Dimension 2 Code";Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
        }
        field(28;"Applies-to Entry";Integer)
        {
            Caption = 'Applies-to Entry';
        }
        field(29;"Bin Code";Code[20])
        {
            Caption = 'Bin Code';
        }
        field(30;"Unit Cost (LCY)";Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Unit Cost (LCY)';
        }
        field(31;"Unit Cost";Decimal)
        {
            AutoFormatExpression = GetCurrencyCode;
            AutoFormatType = 2;
            Caption = 'Unit Cost';
            Editable = false;
        }
        field(32;"Unit Price";Decimal)
        {
            AutoFormatExpression = GetCurrencyCode;
            AutoFormatType = 2;
            CaptionClass = GetCaptionClass(FIELDNO("Unit Price"));
            Caption = 'Unit Price';
        }
    }

    keys
    {
        key(Key1;"Document No.","Document Line No.","Line No.")
        {
        }
    }

    fieldgroups
    {
    }

    local procedure GetCurrencyCode(): Code[10]
    var
        SalesShptHeader: Record "110";
    begin
        IF "Document No." = SalesShptHeader."No." THEN
          EXIT(SalesShptHeader."Currency Code");
        IF SalesShptHeader.GET("Document No.") THEN
          EXIT(SalesShptHeader."Currency Code");
        EXIT('');
    end;

    local procedure GetCaptionClass(FieldNumber: Integer): Text[80]
    var
        SalesShptHeader: Record "110";
    begin
        IF NOT SalesShptHeader.GET("Document No.") THEN BEGIN
          SalesShptHeader."No." := '';
          SalesShptHeader.INIT;
        END;
        IF SalesShptHeader."Prices Including VAT" THEN
          EXIT('2,1,' + GetFieldCaption(FieldNumber))
        ELSE
          EXIT('2,0,' + GetFieldCaption(FieldNumber));
    end;

    local procedure GetFieldCaption(FieldNumber: Integer): Text[100]
    var
        "Field": Record "2000000041";
    begin
        Field.GET(DATABASE::"Kit Sales Shipment Line",FieldNumber);
        EXIT(Field."Field Caption");
    end;

    procedure ShowItemTrackingLines()
    var
        ItemTrackingMgt: Codeunit "6500";
    begin
        IF Type = Type::Item THEN
          //ItemTrackingMgt.CallPostedItemTrackingForm5("Document No.","Document Line No.","No.");
    end;
}

