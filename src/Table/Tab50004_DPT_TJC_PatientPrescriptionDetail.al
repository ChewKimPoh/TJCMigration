table 50004 "Patient Prescription Detail"
{
    // DP.RWP - New Table used for Patient Management System
    // 
    // 20100629 DP.RWP
    //    -Add BarCode field
    // 
    // TJCSG1.00
    // NAV 2013 R2 Upgrade
    //  1. 06/08/2014  dp.dst
    //     - Changed the field "How Many Days" -> Editable property to YES.


    fields
    {
        field(1; "Contact No."; Code[20])
        {
        }
        field(2; "History No."; Integer)
        {
        }
        field(3; "Line No."; Integer)
        {
        }
        field(10; "Medicine Code"; Code[20])
        {
            TableRelation = Item."No." WHERE(Clinic = CONST(true));

            trigger OnValidate()
            var
                rPatientCheckup: Record "Patient Checkup Info";
                rItem: Record Item;
            begin
                rItem.RESET;
                IF rItem.GET("Medicine Code") THEN BEGIN
                    "Medicine Name" := rItem.Description;
                    "Base Unit of Measure Code" := rItem."Base Unit of Measure";
                END;

                rPatientCheckup.RESET;
                rPatientCheckup.SETRANGE("Contact No.", "Contact No.");
                rPatientCheckup.SETRANGE("History No.", "History No.");
                IF rPatientCheckup.FINDSET THEN
                    "Location Code" := rPatientCheckup."Location Code";

                Multiply := 1;
            end;
        }
        field(19; "Medicine Name"; Text[30])
        {
            Editable = true;
            FieldClass = Normal;
        }
        field(20; "Base Unit of Measure Code"; Code[10])
        {
            FieldClass = Normal;
        }
        field(25; "Location Code"; Code[10])
        {
            TableRelation = Location WHERE("Use As In-Transit" = CONST(false));
        }
        field(30; "Dosage Per Time"; Decimal)
        {
            DecimalPlaces = 0 : 2;

            trigger OnValidate()
            begin
                Qty := CalcQty;
            end;
        }
        field(40; "Times Per Day"; Integer)
        {

            trigger OnValidate()
            begin
                Qty := CalcQty;
            end;
        }
        field(43; BarCode; Code[20])
        {
            TableRelation = "Bar Code";

            trigger OnValidate()
            begin
                rBarCode.GET(BarCode);
                "How Many Days" := rBarCode."How Many Days";
                Qty := CalcQty;
            end;
        }
        field(45; "How Many Days"; Option)
        {
            OptionCaption = '3,5,7,1';
            OptionMembers = "3","5","7","1";

            trigger OnValidate()
            begin
                Qty := CalcQty;
            end;
        }
        field(47; Multiply; Integer)
        {
            BlankZero = true;
            InitValue = 1;
            MinValue = 1;
            NotBlank = true;

            trigger OnValidate()
            begin
                Qty := CalcQty;
            end;
        }
        field(50; "Duration Hour"; Integer)
        {
        }
        field(60; Qty; Decimal)
        {
            DecimalPlaces = 0 : 2;
            Editable = false;
        }
        field(70; Remark; Text[50])
        {
        }
        field(75; "When To Take"; Option)
        {
            OptionMembers = "After meals","Before meals","No effect";
        }
        field(80; "Clinic Item Category Code"; Code[10])
        {
            TableRelation = "Item Category" WHERE(Clinic = CONST(true));
        }
        field(90; "Clinic Product Category Code"; Code[10])
        {
            //TableRelation = "Product Group".Code WHERE("Item Category Code" = FIELD("Clinic Item Category Code"));
        }
        field(100; "Dosage UOM"; Code[10])
        {
            TableRelation = "Item Unit of Measure".Code WHERE("Item No." = FIELD("Medicine Code"));
        }
    }

    keys
    {
        key(Key1; "Contact No.", "History No.", "Line No.")
        {
        }
        key(Key2; "Contact No.", "History No.", BarCode, "Line No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        rBarCode: Record "Bar Code";

    procedure CalcQty(): Decimal
    var
        Days: Integer;
    begin
        CASE "How Many Days" OF
            0:
                Days := 3;
            1:
                Days := 5;
            2:
                Days := 7;
            3:
                Days := 1;
        END;
        EXIT("Dosage Per Time" * "Times Per Day" * Days * Multiply);
    end;
}

