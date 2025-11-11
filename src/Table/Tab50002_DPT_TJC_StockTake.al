table 50002 "Stock Take"
{

    fields
    {
        field(1; "Item Code"; Code[20])
        {
        }
        field(2; "Lot No."; Code[20])
        {
        }
        field(3; Quantity; Decimal)
        {
            Description = 'Qty phys. inventory';
        }
        field(4; Date; DateTime)
        {
        }
        field(5; EntryNo; Integer)
        {
        }
        field(6; UserCode; Code[20])
        {
        }
        field(7; "Batch Name"; Code[20])
        {
        }
        field(8; PDACode; Code[20])
        {
        }
        field(9; Status; Option)
        {
            OptionMembers = Open,Retrieved,"Not Found";
        }
        field(10; "System Quantity"; Decimal)
        {
            Description = 'qty calculated';

            trigger OnValidate()
            begin
                "Qty (Difference)" := "System Quantity" - Quantity;
            end;
        }
        field(11; "Qty (Difference)"; Decimal)
        {
            Description = 'qty calculated - Qty phys. inventory';
        }
        field(12; Barcode; Code[20])
        {
        }
        field(13; Location; Code[10])
        {
            TableRelation = Location;

            trigger OnValidate()
            begin
                IF Location <> xRec.Location THEN BEGIN
                    IF Bin <> '' THEN
                        Bin := '';
                END;
            end;
        }
        field(14; Bin; Code[10])
        {
            TableRelation = Bin.Code WHERE("Location Code" = FIELD(Location));
        }
        field(15; Description; Text[100])
        {
            CalcFormula = Lookup(Item.Description WHERE("No." = FIELD("Item Code")));
            FieldClass = FlowField;
        }
        field(16; "Created Date"; DateTime)
        {
        }
        field(17; "Ceated By"; Code[20])
        {
        }
        field(18; Remark; Text[50])
        {
        }
    }

    keys
    {
        key(Key1; EntryNo)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        "Created Date" := Date;
        "Ceated By" := UserCode;
    end;
}

