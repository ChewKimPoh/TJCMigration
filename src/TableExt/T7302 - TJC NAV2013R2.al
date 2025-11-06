table 7302 "Bin Content"
{
    Caption = 'Bin Content';
    DrillDownPageID = 7305;
    LookupPageID = 7305;

    fields
    {
        field(1;"Location Code";Code[10])
        {
            Caption = 'Location Code';
            NotBlank = true;
            TableRelation = Location;

            trigger OnValidate()
            begin
                IF (CurrFieldNo <> 0) AND ("Location Code" <> xRec."Location Code") THEN BEGIN
                  CheckManualChange(FIELDCAPTION("Location Code"));
                  "Bin Code" := '';
                END;
            end;
        }
        field(2;"Zone Code";Code[10])
        {
            Caption = 'Zone Code';
            Editable = false;
            NotBlank = true;
            TableRelation = Zone.Code WHERE (Location Code=FIELD(Location Code));

            trigger OnValidate()
            begin
                IF (CurrFieldNo <> 0) AND ("Zone Code" <> xRec."Zone Code") THEN
                  CheckManualChange(FIELDCAPTION("Zone Code"));
            end;
        }
        field(3;"Bin Code";Code[20])
        {
            Caption = 'Bin Code';
            NotBlank = true;
            TableRelation = IF (Zone Code=FILTER('')) Bin.Code WHERE (Location Code=FIELD(Location Code))
                            ELSE IF (Zone Code=FILTER(<>'')) Bin.Code WHERE (Location Code=FIELD(Location Code),
                                                                             Zone Code=FIELD(Zone Code));

            trigger OnValidate()
            begin
                IF (CurrFieldNo <> 0) AND ("Bin Code" <> xRec."Bin Code") THEN BEGIN
                  CheckManualChange(FIELDCAPTION("Bin Code"));
                  GetBin("Location Code","Bin Code");
                  Dedicated := Bin.Dedicated;
                  "Bin Type Code" := Bin."Bin Type Code";
                  "Warehouse Class Code" := Bin."Warehouse Class Code";
                  "Bin Ranking" := Bin."Bin Ranking";
                  "Block Movement" := Bin."Block Movement";
                  "Zone Code" := Bin."Zone Code";
                END;
            end;
        }
        field(4;"Item No.";Code[20])
        {
            Caption = 'Item No.';
            NotBlank = true;
            TableRelation = Item WHERE (Type=CONST(Inventory));

            trigger OnValidate()
            begin
                IF (CurrFieldNo <> 0) AND ("Item No." <> xRec."Item No.") THEN BEGIN
                  CheckManualChange(FIELDCAPTION("Item No."));
                  "Variant Code" := '';
                END;

                IF ("Item No." <> xRec."Item No.") AND ("Item No." <> '') THEN BEGIN
                  GetItem("Item No.");
                  VALIDATE("Unit of Measure Code",Item."Base Unit of Measure");
                END;
            end;
        }
        field(10;"Bin Type Code";Code[10])
        {
            Caption = 'Bin Type Code';
            Editable = false;
            TableRelation = "Bin Type";
        }
        field(11;"Warehouse Class Code";Code[10])
        {
            Caption = 'Warehouse Class Code';
            Editable = false;
            TableRelation = "Warehouse Class";
        }
        field(12;"Block Movement";Option)
        {
            Caption = 'Block Movement';
            OptionCaption = ' ,Inbound,Outbound,All';
            OptionMembers = " ",Inbound,Outbound,All;
        }
        field(15;"Min. Qty.";Decimal)
        {
            Caption = 'Min. Qty.';
            DecimalPlaces = 0:5;
            MinValue = 0;
        }
        field(16;"Max. Qty.";Decimal)
        {
            Caption = 'Max. Qty.';
            DecimalPlaces = 0:5;
            MinValue = 0;

            trigger OnValidate()
            begin
                IF "Max. Qty." <> xRec."Max. Qty." THEN
                  CheckBinMaxCubageAndWeight;
            end;
        }
        field(21;"Bin Ranking";Integer)
        {
            Caption = 'Bin Ranking';
            Editable = false;
        }
        field(26;Quantity;Decimal)
        {
            CalcFormula = Sum("Warehouse Entry".Quantity WHERE (Location Code=FIELD(Location Code),
                                                                Bin Code=FIELD(Bin Code),
                                                                Item No.=FIELD(Item No.),
                                                                Variant Code=FIELD(Variant Code),
                                                                Unit of Measure Code=FIELD(Unit of Measure Code),
                                                                Lot No.=FIELD(Lot No. Filter),
                                                                Serial No.=FIELD(Serial No. Filter)));
            Caption = 'Quantity';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(29;"Pick Qty.";Decimal)
        {
            CalcFormula = Sum("Warehouse Activity Line"."Qty. Outstanding" WHERE (Location Code=FIELD(Location Code),
                                                                                  Bin Code=FIELD(Bin Code),
                                                                                  Item No.=FIELD(Item No.),
                                                                                  Variant Code=FIELD(Variant Code),
                                                                                  Unit of Measure Code=FIELD(Unit of Measure Code),
                                                                                  Action Type=CONST(Take),
                                                                                  Lot No.=FIELD(Lot No. Filter),
                                                                                  Serial No.=FIELD(Serial No. Filter),
                                                                                  Assemble to Order=CONST(No)));
            Caption = 'Pick Qty.';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(30;"Neg. Adjmt. Qty.";Decimal)
        {
            CalcFormula = Sum("Warehouse Journal Line"."Qty. (Absolute)" WHERE (Location Code=FIELD(Location Code),
                                                                                From Bin Code=FIELD(Bin Code),
                                                                                Item No.=FIELD(Item No.),
                                                                                Variant Code=FIELD(Variant Code),
                                                                                Unit of Measure Code=FIELD(Unit of Measure Code),
                                                                                Lot No.=FIELD(Lot No. Filter),
                                                                                Serial No.=FIELD(Serial No. Filter)));
            Caption = 'Neg. Adjmt. Qty.';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(31;"Put-away Qty.";Decimal)
        {
            CalcFormula = Sum("Warehouse Activity Line"."Qty. Outstanding" WHERE (Location Code=FIELD(Location Code),
                                                                                  Bin Code=FIELD(Bin Code),
                                                                                  Item No.=FIELD(Item No.),
                                                                                  Variant Code=FIELD(Variant Code),
                                                                                  Unit of Measure Code=FIELD(Unit of Measure Code),
                                                                                  Action Type=CONST(Place),
                                                                                  Lot No.=FIELD(Lot No. Filter),
                                                                                  Serial No.=FIELD(Serial No. Filter)));
            Caption = 'Put-away Qty.';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(32;"Pos. Adjmt. Qty.";Decimal)
        {
            CalcFormula = Sum("Warehouse Journal Line"."Qty. (Absolute)" WHERE (Location Code=FIELD(Location Code),
                                                                                To Bin Code=FIELD(Bin Code),
                                                                                Item No.=FIELD(Item No.),
                                                                                Variant Code=FIELD(Variant Code),
                                                                                Unit of Measure Code=FIELD(Unit of Measure Code),
                                                                                Lot No.=FIELD(Lot No. Filter),
                                                                                Serial No.=FIELD(Serial No. Filter)));
            Caption = 'Pos. Adjmt. Qty.';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(37;"Fixed";Boolean)
        {
            Caption = 'Fixed';
        }
        field(40;"Cross-Dock Bin";Boolean)
        {
            Caption = 'Cross-Dock Bin';
        }
        field(41;Default;Boolean)
        {
            Caption = 'Default';

            trigger OnValidate()
            begin
                IF (xRec.Default <> Default) AND Default THEN
                  IF WMSManagement.CheckDefaultBin(
                       "Item No.","Variant Code","Location Code","Bin Code")
                  THEN
                    ERROR(Text010,"Location Code","Item No.","Variant Code");
            end;
        }
        field(50;"Quantity (Base)";Decimal)
        {
            CalcFormula = Sum("Warehouse Entry"."Qty. (Base)" WHERE (Location Code=FIELD(Location Code),
                                                                     Bin Code=FIELD(Bin Code),
                                                                     Item No.=FIELD(Item No.),
                                                                     Variant Code=FIELD(Variant Code),
                                                                     Unit of Measure Code=FIELD(Unit of Measure Code),
                                                                     Lot No.=FIELD(Lot No. Filter),
                                                                     Serial No.=FIELD(Serial No. Filter)));
            Caption = 'Quantity (Base)';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(51;"Pick Quantity (Base)";Decimal)
        {
            CalcFormula = Sum("Warehouse Activity Line"."Qty. Outstanding (Base)" WHERE (Location Code=FIELD(Location Code),
                                                                                         Bin Code=FIELD(Bin Code),
                                                                                         Item No.=FIELD(Item No.),
                                                                                         Variant Code=FIELD(Variant Code),
                                                                                         Unit of Measure Code=FIELD(Unit of Measure Code),
                                                                                         Action Type=CONST(Take),
                                                                                         Lot No.=FIELD(Lot No. Filter),
                                                                                         Serial No.=FIELD(Serial No. Filter),
                                                                                         Assemble to Order=CONST(No)));
            Caption = 'Pick Quantity (Base)';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(52;"Negative Adjmt. Qty. (Base)";Decimal)
        {
            CalcFormula = Sum("Warehouse Journal Line"."Qty. (Absolute, Base)" WHERE (Location Code=FIELD(Location Code),
                                                                                      From Bin Code=FIELD(Bin Code),
                                                                                      Item No.=FIELD(Item No.),
                                                                                      Variant Code=FIELD(Variant Code),
                                                                                      Unit of Measure Code=FIELD(Unit of Measure Code),
                                                                                      Lot No.=FIELD(Lot No. Filter),
                                                                                      Serial No.=FIELD(Serial No. Filter)));
            Caption = 'Negative Adjmt. Qty. (Base)';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(53;"Put-away Quantity (Base)";Decimal)
        {
            CalcFormula = Sum("Warehouse Activity Line"."Qty. Outstanding (Base)" WHERE (Location Code=FIELD(Location Code),
                                                                                         Bin Code=FIELD(Bin Code),
                                                                                         Item No.=FIELD(Item No.),
                                                                                         Variant Code=FIELD(Variant Code),
                                                                                         Unit of Measure Code=FIELD(Unit of Measure Code),
                                                                                         Action Type=CONST(Place),
                                                                                         Lot No.=FIELD(Lot No. Filter),
                                                                                         Serial No.=FIELD(Serial No. Filter)));
            Caption = 'Put-away Quantity (Base)';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(54;"Positive Adjmt. Qty. (Base)";Decimal)
        {
            CalcFormula = Sum("Warehouse Journal Line"."Qty. (Absolute, Base)" WHERE (Location Code=FIELD(Location Code),
                                                                                      To Bin Code=FIELD(Bin Code),
                                                                                      Item No.=FIELD(Item No.),
                                                                                      Variant Code=FIELD(Variant Code),
                                                                                      Unit of Measure Code=FIELD(Unit of Measure Code),
                                                                                      Lot No.=FIELD(Lot No. Filter),
                                                                                      Serial No.=FIELD(Serial No. Filter)));
            Caption = 'Positive Adjmt. Qty. (Base)';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(5402;"Variant Code";Code[10])
        {
            Caption = 'Variant Code';
            TableRelation = "Item Variant".Code WHERE (Item No.=FIELD(Item No.));

            trigger OnValidate()
            begin
                IF (CurrFieldNo <> 0) AND ("Variant Code" <> xRec."Variant Code") THEN
                  CheckManualChange(FIELDCAPTION("Variant Code"));
            end;
        }
        field(5404;"Qty. per Unit of Measure";Decimal)
        {
            Caption = 'Qty. per Unit of Measure';
            DecimalPlaces = 0:5;
            Editable = false;
            InitValue = 1;
        }
        field(5407;"Unit of Measure Code";Code[10])
        {
            Caption = 'Unit of Measure Code';
            NotBlank = true;
            TableRelation = "Item Unit of Measure".Code WHERE (Item No.=FIELD(Item No.));

            trigger OnValidate()
            begin
                IF (CurrFieldNo <> 0) AND ("Unit of Measure Code" <> xRec."Unit of Measure Code") THEN
                  CheckManualChange(FIELDCAPTION("Unit of Measure Code"));

                GetItem("Item No.");
                "Qty. per Unit of Measure" :=
                  UOMMgt.GetQtyPerUnitOfMeasure(Item,"Unit of Measure Code");
            end;
        }
        field(6500;"Lot No. Filter";Code[20])
        {
            Caption = 'Lot No. Filter';
            FieldClass = FlowFilter;
        }
        field(6501;"Serial No. Filter";Code[20])
        {
            Caption = 'Serial No. Filter';
            FieldClass = FlowFilter;
        }
        field(6502;Dedicated;Boolean)
        {
            Caption = 'Dedicated';
            Editable = false;
        }
        field(50015;"Item Desc1";Text[30])
        {
            CalcFormula = Lookup(Item.Description WHERE (No.=FIELD(Item No.)));
            FieldClass = FlowField;
        }
        field(50016;"Item Desc2";Text[30])
        {
            CalcFormula = Lookup(Item."Description 2" WHERE (No.=FIELD(Item No.)));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1;"Location Code","Bin Code","Item No.","Variant Code","Unit of Measure Code")
        {
        }
        key(Key2;"Bin Type Code")
        {
        }
        key(Key3;"Location Code","Item No.","Variant Code","Cross-Dock Bin","Qty. per Unit of Measure","Bin Ranking")
        {
        }
        key(Key4;"Location Code","Warehouse Class Code","Fixed","Bin Ranking")
        {
        }
        key(Key5;"Location Code","Item No.","Variant Code","Warehouse Class Code","Fixed","Bin Ranking")
        {
        }
        key(Key6;"Item No.")
        {
        }
        key(Key7;Default,"Location Code","Item No.","Variant Code","Bin Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        BinContent: Record "7302";
    begin
        BinContent := Rec;
        BinContent.CALCFIELDS(
          "Quantity (Base)","Pick Quantity (Base)","Negative Adjmt. Qty. (Base)",
          "Put-away Quantity (Base)","Positive Adjmt. Qty. (Base)");
        IF BinContent."Quantity (Base)" <> 0 THEN
          ERROR(Text000,TABLECAPTION);

        IF (BinContent."Pick Quantity (Base)" <> 0) OR (BinContent."Negative Adjmt. Qty. (Base)" <> 0) OR
           (BinContent."Put-away Quantity (Base)" <> 0) OR (BinContent."Positive Adjmt. Qty. (Base)" <> 0)
        THEN
          ERROR(Text001,TABLECAPTION);
    end;

    trigger OnInsert()
    begin
        IF Default THEN
          IF WMSManagement.CheckDefaultBin(
               "Item No.","Variant Code","Location Code","Bin Code")
          THEN
            ERROR(Text010,"Location Code","Item No.","Variant Code");

        GetLocation("Location Code");
        IF Location."Directed Put-away and Pick" THEN
          TESTFIELD("Zone Code")
        ELSE
          TESTFIELD("Zone Code",'');

        IF "Min. Qty." > "Max. Qty." THEN
          ERROR(
            Text005,
            FIELDCAPTION("Max. Qty."),"Max. Qty.",
            FIELDCAPTION("Min. Qty."),"Min. Qty.");
    end;

    trigger OnModify()
    begin
        IF Default THEN
          IF WMSManagement.CheckDefaultBin(
               "Item No.","Variant Code","Location Code","Bin Code")
          THEN
            ERROR(Text010,"Location Code","Item No.","Variant Code");

        GetLocation("Location Code");
        IF Location."Directed Put-away and Pick" THEN
          TESTFIELD("Zone Code")
        ELSE
          TESTFIELD("Zone Code",'');

        IF "Min. Qty." > "Max. Qty." THEN
          ERROR(
            Text005,
            FIELDCAPTION("Max. Qty."),"Max. Qty.",
            FIELDCAPTION("Min. Qty."),"Min. Qty.");
    end;

    var
        Item: Record "27";
        Location: Record "14";
        Bin: Record "7354";
        Text000: Label 'You cannot delete this %1, because the %1 contains items.';
        Text001: Label 'You cannot delete this %1, because warehouse document lines have items allocated to this %1.';
        Text002: Label 'The total cubage %1 of the %2 for the %5 exceeds the %3 %4 of the %5.\Do you still want enter this %2?';
        Text003: Label 'The total weight %1 of the %2 for the %5 exceeds the %3 %4 of the %5.\Do you still want enter this %2?';
        Text004: Label 'Cancelled.';
        Text005: Label 'The %1 %2 must not be less than the %3 %4.';
        Text006: Label 'available must not be less than %1';
        UOMMgt: Codeunit "5402";
        Text007: Label 'You cannot modify the %1, because the %2 contains items.';
        Text008: Label 'You cannot modify the %1, because warehouse document lines have items allocated to this %2.';
        Text009: Label 'You must first set up user %1 as a warehouse employee.';
        Text010: Label 'There is already a default bin content for location code %1, item no. %2 and variant code %3.';
        WMSManagement: Codeunit "7302";
        StockProposal: Boolean;

    procedure SetUpNewLine()
    begin
        GetBin("Location Code","Bin Code");
        Dedicated := Bin.Dedicated;
        "Bin Type Code" := Bin."Bin Type Code";
        "Warehouse Class Code" := Bin."Warehouse Class Code";
        "Bin Ranking" := Bin."Bin Ranking";
        "Block Movement" := Bin."Block Movement";
        "Zone Code" := Bin."Zone Code";
        "Cross-Dock Bin" := Bin."Cross-Dock Bin";
    end;

    procedure CheckManualChange(CaptionField: Text[80])
    begin
        xRec.CALCFIELDS(
          "Quantity (Base)","Positive Adjmt. Qty. (Base)","Put-away Quantity (Base)",
          "Negative Adjmt. Qty. (Base)","Pick Quantity (Base)");
        IF xRec."Quantity (Base)" <> 0 THEN
          ERROR(Text007,CaptionField,TABLECAPTION);
        IF (xRec."Positive Adjmt. Qty. (Base)" <> 0) OR (xRec."Put-away Quantity (Base)" <> 0) OR
           (xRec."Negative Adjmt. Qty. (Base)" <> 0) OR (xRec."Pick Quantity (Base)" <> 0)
        THEN
          ERROR(Text008,CaptionField,TABLECAPTION);
    end;

    procedure CalcQtyAvailToTake(ExcludeQtyBase: Decimal): Decimal
    begin
        CALCFIELDS("Quantity (Base)","Negative Adjmt. Qty. (Base)","Pick Quantity (Base)");
        EXIT("Quantity (Base)" - ("Pick Quantity (Base)" - ExcludeQtyBase + "Negative Adjmt. Qty. (Base)"));
    end;

    procedure CalcQtyAvailToTakeUOM(): Decimal
    begin
        GetItem("Item No.");
        IF Item."No." <> '' THEN
          EXIT(ROUND(CalcQtyAvailToTake(0) / UOMMgt.GetQtyPerUnitOfMeasure(Item,"Unit of Measure Code"),0.00001));
    end;

    procedure CalcQtyAvailToPick(ExcludeQtyBase: Decimal): Decimal
    begin
        IF (NOT Dedicated) AND (NOT ("Block Movement" IN ["Block Movement"::Outbound,"Block Movement"::All])) THEN
          EXIT(CalcQtyAvailToTake(ExcludeQtyBase) - CalcQtyWithBlockedItemTracking);
    end;

    procedure CalcQtyWithBlockedItemTracking(): Decimal
    var
        SerialNoInfo: Record "6504";
        LotNoInfo: Record "6505";
        XBinContent: Record "7302";
        QtySNBlocked: Decimal;
        QtyLNBlocked: Decimal;
        QtySNAndLNBlocked: Decimal;
        SNGiven: Boolean;
        LNGiven: Boolean;
        NoITGiven: Boolean;
    begin
        SerialNoInfo.SETRANGE("Item No.","Item No.");
        SerialNoInfo.SETRANGE("Variant Code","Variant Code");
        COPYFILTER("Serial No. Filter",SerialNoInfo."Serial No.");
        SerialNoInfo.SETRANGE(Blocked,TRUE);

        LotNoInfo.SETRANGE("Item No.","Item No.");
        LotNoInfo.SETRANGE("Variant Code","Variant Code");
        COPYFILTER("Lot No. Filter",LotNoInfo."Lot No.");
        LotNoInfo.SETRANGE(Blocked,TRUE);

        IF SerialNoInfo.ISEMPTY AND LotNoInfo.ISEMPTY THEN
          EXIT;

        SNGiven := NOT (GETFILTER("Serial No. Filter") = '');
        LNGiven := NOT (GETFILTER("Lot No. Filter") = '');

        XBinContent.COPY(Rec);
        SETRANGE("Serial No. Filter");
        SETRANGE("Lot No. Filter");

        NoITGiven := NOT SNGiven AND NOT LNGiven;
        IF SNGiven OR NoITGiven THEN
          IF SerialNoInfo.FINDSET THEN
            REPEAT
              SETRANGE("Serial No. Filter",SerialNoInfo."Serial No.");
              CALCFIELDS("Quantity (Base)");
              QtySNBlocked += "Quantity (Base)";
              SETRANGE("Serial No. Filter");
            UNTIL SerialNoInfo.NEXT = 0;

        IF LNGiven OR NoITGiven THEN
          IF LotNoInfo.FINDSET THEN
            REPEAT
              SETRANGE("Lot No. Filter",LotNoInfo."Lot No.");
              CALCFIELDS("Quantity (Base)");
              QtyLNBlocked += "Quantity (Base)";
              SETRANGE("Lot No. Filter");
            UNTIL LotNoInfo.NEXT = 0;

        IF (SNGiven AND LNGiven) OR NoITGiven THEN
          IF SerialNoInfo.FINDSET THEN
            REPEAT
              IF LotNoInfo.FINDSET THEN
                REPEAT
                  SETRANGE("Serial No. Filter",SerialNoInfo."Serial No.");
                  SETRANGE("Lot No. Filter",LotNoInfo."Lot No.");
                  CALCFIELDS("Quantity (Base)");
                  QtySNAndLNBlocked += "Quantity (Base)";
                UNTIL LotNoInfo.NEXT = 0;
            UNTIL SerialNoInfo.NEXT = 0;

        COPY(XBinContent);
        EXIT(QtySNBlocked + QtyLNBlocked - QtySNAndLNBlocked);
    end;

    procedure CalcQtyAvailToPutAway(ExcludeQtyBase: Decimal): Decimal
    begin
        CALCFIELDS("Quantity (Base)","Positive Adjmt. Qty. (Base)","Put-away Quantity (Base)");
        EXIT(
          ROUND("Max. Qty." * "Qty. per Unit of Measure",0.00001) -
          ("Quantity (Base)" + "Put-away Quantity (Base)" - ExcludeQtyBase + "Positive Adjmt. Qty. (Base)"));
    end;

    procedure NeedToReplenish(ExcludeQtyBase: Decimal): Boolean
    begin
        CALCFIELDS("Quantity (Base)","Positive Adjmt. Qty. (Base)","Put-away Quantity (Base)");
        EXIT(
          ROUND("Min. Qty." * "Qty. per Unit of Measure",0.00001) >
          "Quantity (Base)" +
          ABS("Put-away Quantity (Base)" - ExcludeQtyBase + "Positive Adjmt. Qty. (Base)"));
    end;

    procedure CalcQtyToReplenish(ExcludeQtyBase: Decimal): Decimal
    begin
        CALCFIELDS("Quantity (Base)","Positive Adjmt. Qty. (Base)","Put-away Quantity (Base)");
        EXIT(
          ROUND("Max. Qty." * "Qty. per Unit of Measure",0.00001) -
          ("Quantity (Base)" + "Put-away Quantity (Base)" - ExcludeQtyBase + "Positive Adjmt. Qty. (Base)"));
    end;

    procedure CheckBinMaxCubageAndWeight()
    var
        BinContent: Record "7302";
        WMSMgt: Codeunit "7302";
        TotalCubage: Decimal;
        TotalWeight: Decimal;
        Cubage: Decimal;
        Weight: Decimal;
    begin
        GetBin("Location Code","Bin Code");
        IF (Bin."Maximum Cubage" <> 0) OR (Bin."Maximum Weight" <> 0) THEN BEGIN
          BinContent.SETRANGE("Location Code","Location Code");
          BinContent.SETRANGE("Bin Code","Bin Code");
          IF BinContent.FIND('-') THEN
            REPEAT
              IF (BinContent."Location Code" = "Location Code") AND
                 (BinContent."Bin Code" = "Bin Code") AND
                 (BinContent."Item No." = "Item No.") AND
                 (BinContent."Variant Code" = "Variant Code") AND
                 (BinContent."Unit of Measure Code" = "Unit of Measure Code")
              THEN
                WMSMgt.CalcCubageAndWeight(
                  "Item No.","Unit of Measure Code","Max. Qty.",Cubage,Weight)
              ELSE
                WMSMgt.CalcCubageAndWeight(
                  BinContent."Item No.",BinContent."Unit of Measure Code",
                  BinContent."Max. Qty.",Cubage,Weight);
              TotalCubage := TotalCubage + Cubage;
              TotalWeight := TotalWeight + Weight;
            UNTIL BinContent.NEXT = 0;

          IF (Bin."Maximum Cubage" > 0) AND (Bin."Maximum Cubage" - TotalCubage < 0) THEN
            IF NOT CONFIRM(
                 Text002,
                 FALSE,TotalCubage,FIELDCAPTION("Max. Qty."),
                 Bin.FIELDCAPTION("Maximum Cubage"),Bin."Maximum Cubage",Bin.TABLECAPTION)
            THEN
              ERROR(Text004);
          IF (Bin."Maximum Weight" > 0) AND (Bin."Maximum Weight" - TotalWeight < 0) THEN
            IF NOT CONFIRM(
                 Text003,
                 FALSE,TotalWeight,FIELDCAPTION("Max. Qty."),
                 Bin.FIELDCAPTION("Maximum Weight"),Bin."Maximum Weight",Bin.TABLECAPTION)
            THEN
              ERROR(Text004);
        END;
    end;

    procedure CheckDecreaseBinContent(Qty: Decimal;var QtyBase: Decimal;DecreaseQtyBase: Decimal)
    var
        WhseActivLine: Record "5767";
        QtyAvailToPickBase: Decimal;
        QtyAvailToPick: Decimal;
    begin
        IF "Block Movement" IN ["Block Movement"::Outbound,"Block Movement"::All] THEN
          FIELDERROR("Block Movement");

        GetLocation("Location Code");
        IF "Bin Code" = Location."Adjustment Bin Code" THEN
          EXIT;

        WhseActivLine.SETCURRENTKEY(
          "Item No.","Bin Code","Location Code","Action Type",
          "Variant Code","Unit of Measure Code","Breakbulk No.",
          "Activity Type","Lot No.","Serial No.","Original Breakbulk");
        WhseActivLine.SETRANGE("Item No.","Item No.");
        WhseActivLine.SETRANGE("Bin Code","Bin Code");
        WhseActivLine.SETRANGE("Location Code","Location Code");
        WhseActivLine.SETRANGE("Unit of Measure Code","Unit of Measure Code");
        WhseActivLine.SETRANGE("Variant Code","Variant Code");

        IF Location."Allow Breakbulk" THEN BEGIN
          WhseActivLine.SETRANGE("Action Type",WhseActivLine."Action Type"::Take);
          WhseActivLine.SETRANGE("Original Breakbulk",TRUE);
          WhseActivLine.SETRANGE("Breakbulk No.",0);
          WhseActivLine.CALCSUMS("Qty. (Base)");
          DecreaseQtyBase := DecreaseQtyBase + WhseActivLine."Qty. (Base)";
        END;

        QtyAvailToPickBase := CalcQtyAvailToTake(DecreaseQtyBase);
        IF QtyAvailToPickBase < QtyBase THEN BEGIN
          GetItem("Item No.");
          QtyAvailToPick := ROUND(QtyAvailToPickBase / UOMMgt.GetQtyPerUnitOfMeasure(Item,"Unit of Measure Code"),0.00001);
          IF QtyAvailToPick = Qty THEN
            QtyBase := QtyAvailToPickBase // rounding issue- qty is same, but not qty (base)
          ELSE
            FIELDERROR("Quantity (Base)",STRSUBSTNO(Text006,ABS(QtyBase)));
        END;
    end;

    procedure CheckIncreaseBinContent(QtyBase: Decimal;DeductQtyBase: Decimal;DeductCubage: Decimal;DeductWeight: Decimal;PutawayCubage: Decimal;PutawayWeight: Decimal;CalledbyPosting: Boolean;IgnoreError: Boolean): Boolean
    var
        WhseActivLine: Record "5767";
        WMSMgt: Codeunit "7302";
        QtyAvailToPutAwayBase: Decimal;
        AvailableWeight: Decimal;
        AvailableCubage: Decimal;
    begin
        IF "Block Movement" IN ["Block Movement"::Inbound,"Block Movement"::All] THEN
          IF NOT StockProposal THEN
            FIELDERROR("Block Movement");

        GetLocation("Location Code");
        IF "Bin Code" = Location."Adjustment Bin Code" THEN
          EXIT;

        IF NOT CheckWhseClass(IgnoreError) THEN
          EXIT(FALSE);

        IF QtyBase <> 0 THEN
          IF Location."Bin Capacity Policy" IN
             [Location."Bin Capacity Policy"::"Allow More Than Max. Capacity",
              Location."Bin Capacity Policy"::"Prohibit More Than Max. Cap."]
          THEN
            IF "Max. Qty." <> 0 THEN BEGIN
              QtyAvailToPutAwayBase := CalcQtyAvailToPutAway(DeductQtyBase);
              WMSMgt.CheckPutAwayAvailability(
                "Bin Code",WhseActivLine.FIELDCAPTION("Qty. (Base)"),TABLECAPTION,QtyBase,QtyAvailToPutAwayBase,
                (Location."Bin Capacity Policy" =
                 Location."Bin Capacity Policy"::"Prohibit More Than Max. Cap.") AND CalledbyPosting);
            END ELSE BEGIN
              GetBin("Location Code","Bin Code");
              IF (Bin."Maximum Cubage" <> 0) OR (Bin."Maximum Weight" <> 0) THEN BEGIN
                Bin.CalcCubageAndWeight(AvailableCubage,AvailableWeight,CalledbyPosting);
                IF NOT CalledbyPosting THEN BEGIN
                  AvailableCubage := AvailableCubage + DeductCubage;
                  AvailableWeight := AvailableWeight + DeductWeight;
                END;

                IF (Bin."Maximum Cubage" <> 0) AND (PutawayCubage > AvailableCubage) THEN
                  WMSMgt.CheckPutAwayAvailability(
                    "Bin Code",WhseActivLine.FIELDCAPTION(Cubage),Bin.TABLECAPTION,PutawayCubage,AvailableCubage,
                    (Location."Bin Capacity Policy" =
                     Location."Bin Capacity Policy"::"Prohibit More Than Max. Cap.") AND CalledbyPosting);

                IF (Bin."Maximum Weight" <> 0) AND (PutawayWeight > AvailableWeight) THEN
                  WMSMgt.CheckPutAwayAvailability(
                    "Bin Code",WhseActivLine.FIELDCAPTION(Weight),Bin.TABLECAPTION,PutawayWeight,AvailableWeight,
                    (Location."Bin Capacity Policy" =
                     Location."Bin Capacity Policy"::"Prohibit More Than Max. Cap.") AND CalledbyPosting);
              END;
            END;
        EXIT(TRUE);
    end;

    procedure CheckWhseClass(IgnoreError: Boolean): Boolean
    var
        ProductGroup: Record "5723";
    begin
        GetItem("Item No.");
        IF ProductGroup.GET(Item."Item Category Code",Item."Product Group Code") THEN;
        IF IgnoreError THEN
          EXIT("Warehouse Class Code" = ProductGroup."Warehouse Class Code");
        TESTFIELD("Warehouse Class Code",ProductGroup."Warehouse Class Code");
        EXIT(TRUE);
    end;

    procedure ShowBinContents(LocationCode: Code[10];ItemNo: Code[20];VariantCode: Code[10];BinCode: Code[20])
    var
        BinContent: Record "7302";
        BinContentLookup: Page "7305";
    begin
        IF BinCode <> '' THEN
          BinContent.SETRANGE("Bin Code",BinCode)
        ELSE
          BinContent.SETCURRENTKEY("Location Code","Item No.","Variant Code");
        BinContent.SETRANGE("Item No.",ItemNo);
        BinContent.SETRANGE("Variant Code",VariantCode);
        BinContentLookup.SETTABLEVIEW(BinContent);
        BinContentLookup.Initialize(LocationCode);
        BinContentLookup.RUNMODAL;
        CLEAR(BinContentLookup);
    end;

    local procedure GetLocation(LocationCode: Code[10])
    begin
        IF Location.Code <> LocationCode THEN
          Location.GET(LocationCode);
    end;

    procedure GetBin(LocationCode: Code[10];BinCode: Code[20])
    begin
        IF (LocationCode = '') OR (BinCode = '') THEN
          Bin.INIT
        ELSE
          IF (Bin."Location Code" <> LocationCode) OR
             (Bin.Code <> BinCode)
          THEN
            Bin.GET(LocationCode,BinCode);
    end;

    local procedure GetItem(ItemNo: Code[20])
    begin
        IF Item."No." = ItemNo THEN
          EXIT;

        IF ItemNo = '' THEN
          Item.INIT
        ELSE
          Item.GET(ItemNo);
    end;

    procedure GetItemDescr(ItemNo: Code[20];VariantCode: Code[10];var ItemDescription: Text[50])
    var
        Item: Record "27";
        ItemVariant: Record "5401";
        OldItemNo: Code[20];
    begin
        ItemDescription := '';
        IF ItemNo <> OldItemNo THEN BEGIN
          ItemDescription := '';
          IF ItemNo <> '' THEN BEGIN
            IF Item.GET(ItemNo) THEN
              ItemDescription := Item.Description;
            IF VariantCode <> '' THEN
              IF ItemVariant.GET(ItemNo,VariantCode) THEN
                ItemDescription := ItemVariant.Description;
          END;
          OldItemNo := ItemNo;
        END;
    end;

    procedure GetWhseLocation(var CurrentLocationCode: Code[10];var CurrentZoneCode: Code[10])
    var
        Location: Record "14";
        WhseEmployee: Record "7301";
        WMSMgt: Codeunit "7302";
    begin
        IF USERID <> '' THEN BEGIN
          WhseEmployee.SETRANGE("User ID",USERID);
          IF NOT WhseEmployee.FINDFIRST THEN
            ERROR(Text009,USERID);
          IF CurrentLocationCode <> '' THEN BEGIN
            IF NOT Location.GET(CurrentLocationCode) THEN BEGIN
              CurrentLocationCode := '';
              CurrentZoneCode := '';
            END ELSE
              IF NOT Location."Bin Mandatory" THEN BEGIN
                CurrentLocationCode := '';
                CurrentZoneCode := '';
              END ELSE BEGIN
                WhseEmployee.SETRANGE("Location Code",CurrentLocationCode);
                IF NOT WhseEmployee.FINDFIRST THEN BEGIN
                  CurrentLocationCode := '';
                  CurrentZoneCode := '';
                END;
              END
              ;
            IF CurrentLocationCode = '' THEN BEGIN
              CurrentLocationCode := WMSMgt.GetDefaultLocation;
              IF CurrentLocationCode <> '' THEN BEGIN
                Location.GET(CurrentLocationCode);
                IF NOT Location."Bin Mandatory" THEN
                  CurrentLocationCode := '';
              END;
            END;
          END;
        END;
        FILTERGROUP := 2;
        IF CurrentLocationCode <> '' THEN
          SETRANGE("Location Code",CurrentLocationCode)
        ELSE
          SETRANGE("Location Code");
        IF CurrentZoneCode <> '' THEN
          SETRANGE("Zone Code",CurrentZoneCode)
        ELSE
          SETRANGE("Zone Code");
        FILTERGROUP := 0;
    end;

    procedure CalcQtyonAdjmtBin(): Decimal
    var
        WhseEntry: Record "7312";
    begin
        GetLocation("Location Code");
        WhseEntry.SETCURRENTKEY(
          "Item No.","Bin Code","Location Code","Variant Code","Unit of Measure Code");
        WhseEntry.SETRANGE("Item No.","Item No.");
        WhseEntry.SETRANGE("Bin Code",Location."Adjustment Bin Code");
        WhseEntry.SETRANGE("Location Code","Location Code");
        WhseEntry.SETRANGE("Variant Code","Variant Code");
        WhseEntry.SETRANGE("Unit of Measure Code","Unit of Measure Code");
        WhseEntry.CALCSUMS("Qty. (Base)");
        EXIT(WhseEntry."Qty. (Base)");
    end;

    procedure CalcQtyBase(): Decimal
    var
        WhseActivLine: Record "5767";
        WhseJnlLine: Record "7311";
    begin
        WhseActivLine.SETCURRENTKEY(
          "Item No.","Bin Code","Location Code",
          "Action Type","Variant Code","Unit of Measure Code",
          "Breakbulk No.","Activity Type","Lot No.","Serial No.");
        WhseActivLine.SETRANGE("Item No.","Item No." );
        WhseActivLine.SETRANGE("Bin Code","Bin Code");
        WhseActivLine.SETRANGE("Location Code","Location Code");
        WhseActivLine.SETRANGE("Variant Code","Variant Code");
        WhseActivLine.SETRANGE("Unit of Measure Code","Unit of Measure Code");
        COPYFILTER("Lot No. Filter",WhseActivLine."Lot No.");
        COPYFILTER("Serial No. Filter",WhseActivLine."Serial No.");
        WhseActivLine.CALCSUMS("Qty. Outstanding (Base)");

        WhseJnlLine.SETCURRENTKEY(
          "Item No.","From Bin Code","Location Code","Entry Type","Variant Code",
          "Unit of Measure Code","Lot No.","Serial No.");
        WhseJnlLine.SETRANGE("Item No.","Item No." );
        WhseJnlLine.SETRANGE("From Bin Code","Bin Code");
        WhseJnlLine.SETRANGE("Location Code","Location Code");
        WhseJnlLine.SETRANGE("Variant Code","Variant Code");
        WhseJnlLine.SETRANGE("Unit of Measure Code","Unit of Measure Code");
        COPYFILTER("Lot No. Filter",WhseJnlLine."Lot No.");
        COPYFILTER("Serial No. Filter",WhseJnlLine."Serial No.");
        WhseJnlLine.CALCSUMS("Qty. (Absolute, Base)");

        CALCFIELDS("Quantity (Base)");
        EXIT(
          "Quantity (Base)" +
          WhseActivLine."Qty. Outstanding (Base)" +
          WhseJnlLine."Qty. (Absolute, Base)");
    end;

    procedure CalcQtyUOM(): Decimal
    begin
        GetItem("Item No.");
        CALCFIELDS("Quantity (Base)");
        IF Item."No." <> '' THEN
          EXIT(ROUND("Quantity (Base)" / UOMMgt.GetQtyPerUnitOfMeasure(Item,"Unit of Measure Code"),0.00001));
    end;

    procedure GetCaption(): Text[250]
    var
        ObjTransl: Record "377";
        ReservEntry: Record "337";
        FormCaption: Text[250];
        "Filter": Text;
    begin
        FormCaption :=
          STRSUBSTNO(
            '%1 %2',
            ObjTransl.TranslateObject(ObjTransl."Object Type"::Table,DATABASE::Location),
            "Location Code");

        CASE TRUE OF
          GetFieldFilter(GETFILTER("Serial No. Filter"),Filter):
            GetPageCaption(FormCaption,FIELDNO("Serial No. Filter"),Filter,-1,ReservEntry.FIELDCAPTION("Serial No."));
          GetFieldFilter(GETFILTER("Lot No. Filter"),Filter):
            GetPageCaption(FormCaption,FIELDNO("Lot No. Filter"),Filter,-1,ReservEntry.FIELDCAPTION("Lot No."));
          GetFieldFilter(GETFILTER("Bin Code"),Filter):
            GetPageCaption(FormCaption,FIELDNO("Bin Code"),Filter,DATABASE::"Registered Invt. Movement Line",'');
          GetFieldFilter(GETFILTER("Variant Code"),Filter):
            GetPageCaption(FormCaption,FIELDNO("Variant Code"),Filter,DATABASE::"Item Variant",'');
          GetFieldFilter(GETFILTER("Item No."),Filter):
            GetPageCaption(FormCaption,FIELDNO("Item No."),Filter,DATABASE::Item,'');
        END;

        EXIT(FormCaption);
    end;

    procedure SetProposalMode(NewValue: Boolean)
    begin
        StockProposal := NewValue;
    end;

    local procedure GetFieldFilter(FieldFilter: Text;var "Filter": Text): Boolean
    begin
        Filter := FieldFilter;
        EXIT(STRLEN(Filter) > 0);
    end;

    local procedure GetPageCaption(var PageCaption: Text;FieldNo: Integer;"Filter": Text;TableId: Integer;CustomDetails: Text)
    var
        ObjectTranslation: Record "377";
        FieldRef: FieldRef;
        RecRef: RecordRef;
    begin
        RecRef.GETTABLE(Rec);
        FieldRef := RecRef.FIELD(FieldNo);
        FieldRef.SETFILTER(Filter);

        IF RecRef.FINDFIRST THEN BEGIN
          IF TableId > 0 THEN
            CustomDetails := ObjectTranslation.TranslateObject(ObjectTranslation."Object Type"::Table,TableId);

          PageCaption := STRSUBSTNO('%1 %2 %3',PageCaption,CustomDetails,FieldRef.VALUE);
        END;
    end;
}

