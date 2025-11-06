table 99000772 "Production BOM Line"
{
    Caption = 'Production BOM Line';

    fields
    {
        field(1;"Production BOM No.";Code[20])
        {
            Caption = 'Production BOM No.';
            NotBlank = true;
            TableRelation = "Production BOM Header";
        }
        field(2;"Line No.";Integer)
        {
            Caption = 'Line No.';
        }
        field(3;"Version Code";Code[10])
        {
            Caption = 'Version Code';
            TableRelation = "Production BOM Version"."Version Code" WHERE (Production BOM No.=FIELD(Production BOM No.));
        }
        field(10;Type;Option)
        {
            Caption = 'Type';
            OptionCaption = ' ,Item,Production BOM';
            OptionMembers = " ",Item,"Production BOM";

            trigger OnValidate()
            begin
                TestStatus;

                xRec.Type := Type;

                INIT;
                Type := xRec.Type;
            end;
        }
        field(11;"No.";Code[20])
        {
            Caption = 'No.';
            TableRelation = IF (Type=CONST(Item)) Item WHERE (Type=CONST(Inventory))
                            ELSE IF (Type=CONST(Production BOM)) "Production BOM Header";

            trigger OnValidate()
            begin
                TESTFIELD(Type);

                TestStatus;

                CASE Type OF
                  Type::Item:
                    BEGIN
                      Item.GET("No.");
                      Description := Item.Description;
                      Item.TESTFIELD("Base Unit of Measure");
                      "Unit of Measure Code" := Item."Base Unit of Measure";
                      IF "No." <> xRec."No." THEN
                        "Variant Code" := '';
                    END;
                  Type::"Production BOM":
                    BEGIN
                      ProdBOMHeader.GET("No.");
                      ProdBOMHeader.TESTFIELD("Unit of Measure Code");
                      Description := ProdBOMHeader.Description;
                      "Unit of Measure Code" := ProdBOMHeader."Unit of Measure Code";
                    END;
                END;
            end;
        }
        field(12;Description;Text[50])
        {
            Caption = 'Description';
        }
        field(13;"Unit of Measure Code";Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = IF (Type=CONST(Item)) "Item Unit of Measure".Code WHERE (Item No.=FIELD(No.))
                            ELSE IF (Type=CONST(Production BOM)) "Unit of Measure";

            trigger OnValidate()
            begin
                TESTFIELD(Type,Type::Item);
                TESTFIELD("No.");
            end;
        }
        field(14;Quantity;Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0:5;
            Editable = false;
        }
        field(15;Position;Code[10])
        {
            Caption = 'Position';
        }
        field(16;"Position 2";Code[10])
        {
            Caption = 'Position 2';
        }
        field(17;"Position 3";Code[10])
        {
            Caption = 'Position 3';
        }
        field(18;"Lead-Time Offset";DateFormula)
        {
            Caption = 'Lead-Time Offset';

            trigger OnValidate()
            begin
                TESTFIELD("No.");
            end;
        }
        field(19;"Routing Link Code";Code[10])
        {
            Caption = 'Routing Link Code';
            TableRelation = "Routing Link";

            trigger OnValidate()
            begin
                IF "Routing Link Code" <> '' THEN BEGIN
                  TESTFIELD(Type,Type::Item);
                  TESTFIELD("No.");
                END;
            end;
        }
        field(20;"Scrap %";Decimal)
        {
            BlankNumbers = BlankNeg;
            Caption = 'Scrap %';
            DecimalPlaces = 0:5;
            MaxValue = 100;

            trigger OnValidate()
            begin
                TESTFIELD("No.");
            end;
        }
        field(21;"Variant Code";Code[10])
        {
            Caption = 'Variant Code';
            TableRelation = IF (Type=CONST(Item)) "Item Variant".Code WHERE (Item No.=FIELD(No.));

            trigger OnValidate()
            begin
                IF "Variant Code" = '' THEN
                  EXIT;
                TESTFIELD(Type,Type::Item);
                TESTFIELD("No.");
                ItemVariant.GET("No.","Variant Code");
                Description := ItemVariant.Description;
            end;
        }
        field(22;Comment;Boolean)
        {
            CalcFormula = Exist("Production BOM Comment Line" WHERE (Production BOM No.=FIELD(Production BOM No.),
                                                                     Version Code=FIELD(Version Code),
                                                                     BOM Line No.=FIELD(Line No.)));
            Caption = 'Comment';
            Editable = false;
            FieldClass = FlowField;
        }
        field(28;"Starting Date";Date)
        {
            Caption = 'Starting Date';

            trigger OnValidate()
            begin
                TESTFIELD("No.");

                IF "Starting Date" > 0D THEN
                  VALIDATE("Ending Date");
            end;
        }
        field(29;"Ending Date";Date)
        {
            Caption = 'Ending Date';

            trigger OnValidate()
            begin
                TESTFIELD("No.");

                IF ("Ending Date" > 0D) AND
                   ("Starting Date" > 0D) AND
                   ("Starting Date" > "Ending Date")
                THEN
                  ERROR(
                    Text000,
                    FIELDCAPTION("Ending Date"),
                    FIELDCAPTION("Starting Date"));
            end;
        }
        field(40;Length;Decimal)
        {
            Caption = 'Length';
            DecimalPlaces = 0:5;

            trigger OnValidate()
            begin
                VALIDATE("Calculation Formula");
            end;
        }
        field(41;Width;Decimal)
        {
            Caption = 'Width';
            DecimalPlaces = 0:5;

            trigger OnValidate()
            begin
                VALIDATE("Calculation Formula");
            end;
        }
        field(42;Weight;Decimal)
        {
            Caption = 'Weight';
            DecimalPlaces = 0:5;

            trigger OnValidate()
            begin
                VALIDATE("Calculation Formula");
            end;
        }
        field(43;Depth;Decimal)
        {
            Caption = 'Depth';
            DecimalPlaces = 0:5;

            trigger OnValidate()
            begin
                VALIDATE("Calculation Formula");
            end;
        }
        field(44;"Calculation Formula";Option)
        {
            Caption = 'Calculation Formula';
            OptionCaption = ' ,Length,Length * Width,Length * Width * Depth,Weight';
            OptionMembers = " ",Length,"Length * Width","Length * Width * Depth",Weight;

            trigger OnValidate()
            begin
                TESTFIELD("No.");

                CASE "Calculation Formula" OF
                  "Calculation Formula"::" ":
                    Quantity := "Quantity per";
                  "Calculation Formula"::Length:
                    Quantity := ROUND(Length * "Quantity per",0.00001);
                  "Calculation Formula"::"Length * Width":
                    Quantity := ROUND(Length * Width * "Quantity per",0.00001);
                  "Calculation Formula"::"Length * Width * Depth":
                    Quantity := ROUND(Length * Width * Depth * "Quantity per",0.00001);
                  "Calculation Formula"::Weight:
                    Quantity := ROUND(Weight * "Quantity per",0.00001);
                END;
            end;
        }
        field(45;"Quantity per";Decimal)
        {
            Caption = 'Quantity per';
            DecimalPlaces = 0:5;

            trigger OnValidate()
            begin
                VALIDATE("Calculation Formula");
            end;
        }
        field(50000;"Sequence Code";Code[10])
        {
        }
    }

    keys
    {
        key(Key1;"Production BOM No.","Version Code","Line No.")
        {
        }
        key(Key2;Type,"No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        ProdBOMComment: Record "99000776";
        PlanningAssignment: Record "99000850";
    begin
        IF Type <> Type::" " THEN BEGIN
          TestStatus;
          IF Type = Type::Item THEN
            PlanningAssignment.AssignPlannedOrders("No.",FALSE)
          ELSE
            IF Type = Type::"Production BOM" THEN
              PlanningAssignment.OldBom("No.");
        END;

        ProdBOMComment.SETRANGE("Production BOM No.","Production BOM No.");
        ProdBOMComment.SETRANGE("BOM Line No.","Line No.");
        ProdBOMComment.SETRANGE("Version Code","Version Code");
        ProdBOMComment.DELETEALL;
    end;

    trigger OnInsert()
    begin
        TestStatus;
    end;

    trigger OnModify()
    begin
        IF Type <> Type::" " THEN
          TestStatus;
    end;

    var
        Text000: Label '%1 must be later than %2.';
        Item: Record "27";
        ProdBOMHeader: Record "99000771";
        ItemVariant: Record "5401";

    procedure TestStatus()
    var
        ProdBOMVersion: Record "99000779";
    begin
        IF "Version Code" = '' THEN BEGIN
          ProdBOMHeader.GET("Production BOM No.");
          IF ProdBOMHeader.Status = ProdBOMHeader.Status::Certified THEN
            ProdBOMHeader.FIELDERROR(Status);
        END ELSE BEGIN
          ProdBOMVersion.GET("Production BOM No.","Version Code");
          IF ProdBOMVersion.Status = ProdBOMVersion.Status::Certified THEN
            ProdBOMVersion.FIELDERROR(Status);
        END;
    end;

    procedure GetQtyPerUnitOfMeasure(): Decimal
    var
        Item: Record "27";
        UOMMgt: Codeunit "5402";
    begin
        IF Type = Type::Item THEN BEGIN
          Item.GET("No.");
          EXIT(
            UOMMgt.GetQtyPerUnitOfMeasure(Item,"Unit of Measure Code"));
        END;
        EXIT(1);
    end;
}

