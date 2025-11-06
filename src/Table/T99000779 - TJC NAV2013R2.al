table 99000779 "Production BOM Version"
{
    Caption = 'Production BOM Version';
    DataCaptionFields = "Production BOM No.","Version Code",Description;
    DrillDownPageID = 99000800;
    LookupPageID = 99000800;

    fields
    {
        field(1;"Production BOM No.";Code[20])
        {
            Caption = 'Production BOM No.';
            NotBlank = true;
            TableRelation = "Production BOM Header";
        }
        field(2;"Version Code";Code[10])
        {
            Caption = 'Version Code';
        }
        field(3;Description;Text[50])
        {
            Caption = 'Description';
        }
        field(10;"Starting Date";Date)
        {
            Caption = 'Starting Date';
        }
        field(21;"Unit of Measure Code";Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = "Unit of Measure";

            trigger OnValidate()
            begin
                IF (Status = Status::Certified) AND ("Unit of Measure Code" <> xRec."Unit of Measure Code") THEN
                  FIELDERROR(Status);
            end;
        }
        field(22;"Last Date Modified";Date)
        {
            Caption = 'Last Date Modified';
            Editable = false;
        }
        field(45;Status;Option)
        {
            Caption = 'Status';
            OptionCaption = 'New,Certified,Under Development,Closed';
            OptionMembers = New,Certified,"Under Development",Closed;

            trigger OnValidate()
            var
                ProdBOMHeader: Record "99000771";
                PlanningAssignment: Record "99000850";
                ProdBOMCheck: Codeunit "99000769";
            begin
                IF (Status <> xRec.Status) AND (Status = Status::Certified) THEN BEGIN
                  ProdBOMCheck.ProdBOMLineCheck("Production BOM No.","Version Code");
                  TESTFIELD("Unit of Measure Code");
                  ProdBOMHeader.GET("Production BOM No.");
                  ProdBOMHeader."Low-Level Code" := 0;
                  ProdBOMCheck.Code(ProdBOMHeader,"Version Code");
                  PlanningAssignment.NewBOM("Production BOM No.");
                END;
                MODIFY(TRUE);
                COMMIT;
            end;
        }
        field(50;"No. Series";Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(50000;"Size/Shape";Text[50])
        {
            Description = 'DP0001-Additional Information';
        }
        field(50001;Colour;Code[50])
        {
            Description = 'DP0001-Additional Information';
        }
        field(50002;"Theoretical Unit Weight";Decimal)
        {
            Description = 'DP0001-Additional Information';
        }
        field(50003;Equipments;Text[150])
        {
        }
    }

    keys
    {
        key(Key1;"Production BOM No.","Version Code")
        {
        }
        key(Key2;"Production BOM No.","Starting Date")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        ProdBOMLine: Record "99000772";
    begin
        ProdBOMLine.SETRANGE("Production BOM No.","Production BOM No.");
        ProdBOMLine.SETRANGE("Version Code","Version Code");
        ProdBOMLine.DELETEALL(TRUE);
    end;

    trigger OnInsert()
    begin
        ProdBOMHeader.GET("Production BOM No.");
        IF "Version Code" = '' THEN BEGIN
          ProdBOMHeader.TESTFIELD("Version Nos.");
          NoSeriesMgt.InitSeries(ProdBOMHeader."Version Nos.",xRec."No. Series",0D,"Version Code","No. Series");
        END;
    end;

    trigger OnModify()
    begin
        "Last Date Modified" := TODAY;
    end;

    trigger OnRename()
    begin
        IF Status = Status::Certified THEN
          ERROR(Text001,TABLECAPTION,FIELDCAPTION(Status),FORMAT(Status));
    end;

    var
        ProdBOMHeader: Record "99000771";
        ProdBOMVersion: Record "99000779";
        NoSeriesMgt: Codeunit "396";
        Text001: Label 'You cannot rename the %1 when %2 is %3.';

    procedure AssistEdit(OldProdBOMVersion: Record "99000779"): Boolean
    begin
        WITH ProdBOMVersion DO BEGIN
          ProdBOMVersion := Rec;
          ProdBOMHeader.GET("Production BOM No.");
          ProdBOMHeader.TESTFIELD("Version Nos.");
          IF NoSeriesMgt.SelectSeries(ProdBOMHeader."Version Nos.",OldProdBOMVersion."No. Series","No. Series") THEN BEGIN
            NoSeriesMgt.SetSeries("Version Code");
            Rec := ProdBOMVersion;
            EXIT(TRUE);
          END;
        END;
    end;

    procedure Caption(): Text[100]
    var
        ProdBOMHeader: Record "99000771";
    begin
        IF GETFILTERS = '' THEN
          EXIT('');

        IF NOT ProdBOMHeader.GET("Production BOM No.") THEN
          EXIT('');

        EXIT(
          STRSUBSTNO('%1 %2 %3',
            "Production BOM No.",ProdBOMHeader.Description,"Version Code"));
    end;
}

