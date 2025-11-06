table 99000771 "Production BOM Header"
{
    Caption = 'Production BOM Header';
    DataCaptionFields = "No.",Description;
    DrillDownPageID = 99000787;
    LookupPageID = 99000787;

    fields
    {
        field(1;"No.";Code[20])
        {
            Caption = 'No.';
        }
        field(10;Description;Text[50])
        {
            Caption = 'Description';

            trigger OnValidate()
            begin
                "Search Name" := Description;
            end;
        }
        field(11;"Description 2";Text[50])
        {
            Caption = 'Description 2';
        }
        field(12;"Search Name";Code[50])
        {
            Caption = 'Search Name';
        }
        field(21;"Unit of Measure Code";Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = "Unit of Measure";

            trigger OnValidate()
            var
                Item: Record "27";
                ItemUnitOfMeasure: Record "5404";
            begin
                IF Status = Status::Certified THEN
                  FIELDERROR(Status);
                Item.SETCURRENTKEY("Production BOM No.");
                Item.SETRANGE("Production BOM No.","No.");
                IF Item.FINDSET THEN
                  REPEAT
                    ItemUnitOfMeasure.GET(Item."No.","Unit of Measure Code");
                  UNTIL Item.NEXT = 0;
            end;
        }
        field(22;"Low-Level Code";Integer)
        {
            Caption = 'Low-Level Code';
            Editable = false;
        }
        field(25;Comment;Boolean)
        {
            CalcFormula = Exist("Manufacturing Comment Line" WHERE (Table Name=CONST(Production BOM Header),
                                                                    No.=FIELD(No.)));
            Caption = 'Comment';
            Editable = false;
            FieldClass = FlowField;
        }
        field(40;"Creation Date";Date)
        {
            Caption = 'Creation Date';
            Editable = false;
        }
        field(43;"Last Date Modified";Date)
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
                PlanningAssignment: Record "99000850";
                MfgSetup: Record "99000765";
                ProdBOMCheck: Codeunit "99000769";
            begin
                IF (Status <> xRec.Status) AND (Status = Status::Certified) THEN BEGIN
                  MfgSetup.LOCKTABLE;
                  MfgSetup.GET;
                  ProdBOMCheck.ProdBOMLineCheck("No.",'');
                  "Low-Level Code" := 0;
                  ProdBOMCheck.RUN(Rec);
                  PlanningAssignment.NewBOM("No.");
                END;
                IF Status = Status::Closed THEN BEGIN
                  IF CONFIRM(
                       Text001,FALSE)
                  THEN BEGIN
                    ProdBOMVersion.SETRANGE("Production BOM No.","No.");
                    IF ProdBOMVersion.FIND('-') THEN
                      REPEAT
                        ProdBOMVersion.Status := ProdBOMVersion.Status::Closed;
                        ProdBOMVersion.MODIFY;
                      UNTIL ProdBOMVersion.NEXT = 0;
                  END ELSE
                    Status := xRec.Status;
                END;
            end;
        }
        field(50;"Version Nos.";Code[10])
        {
            Caption = 'Version Nos.';
            TableRelation = "No. Series";
        }
        field(51;"No. Series";Code[10])
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
        key(Key1;"No.")
        {
        }
        key(Key2;"Search Name")
        {
        }
        key(Key3;Description)
        {
        }
        key(Key4;Status)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        Item.SETCURRENTKEY("Production BOM No.");
        Item.SETRANGE("Production BOM No.","No.");
        IF Item.FINDFIRST THEN
          ERROR(Text000);

        ProdBOMLine.SETRANGE("Production BOM No.","No.");
        ProdBOMLine.DELETEALL(TRUE);

        ProdBOMVersion.SETRANGE("Production BOM No.","No.");
        ProdBOMVersion.DELETEALL;

        MfgComment.SETRANGE("Table Name",MfgComment."Table Name"::"Production BOM Header");
        MfgComment.SETRANGE("No.","No.");
        MfgComment.DELETEALL;
    end;

    trigger OnInsert()
    begin
        MfgSetup.GET;
        IF "No." = '' THEN BEGIN
          MfgSetup.TESTFIELD("Production BOM Nos.");
          NoSeriesMgt.InitSeries(MfgSetup."Production BOM Nos.",xRec."No. Series",0D,"No.","No. Series");
        END;

        "Creation Date" := TODAY;
    end;

    trigger OnModify()
    begin
        "Last Date Modified" := TODAY;
    end;

    trigger OnRename()
    begin
        IF Status = Status::Certified THEN
          ERROR(Text002,TABLECAPTION,FIELDCAPTION(Status),FORMAT(Status));
    end;

    var
        Text000: Label 'This Production BOM is being used on Items.';
        Text001: Label 'All versions attached to the BOM will be closed. Close BOM?';
        MfgSetup: Record "99000765";
        Item: Record "27";
        ProdBOMHeader: Record "99000771";
        ProdBOMVersion: Record "99000779";
        ProdBOMLine: Record "99000772";
        MfgComment: Record "99000770";
        NoSeriesMgt: Codeunit "396";
        Text002: Label 'You cannot rename the %1 when %2 is %3.';

    procedure AssistEdit(OldProdBOMHeader: Record "99000771"): Boolean
    begin
        WITH ProdBOMHeader DO BEGIN
          ProdBOMHeader := Rec;
          MfgSetup.GET;
          MfgSetup.TESTFIELD("Production BOM Nos.");
          IF NoSeriesMgt.SelectSeries(MfgSetup."Production BOM Nos.",OldProdBOMHeader."No. Series","No. Series") THEN BEGIN
            NoSeriesMgt.SetSeries("No.");
            Rec := ProdBOMHeader;
            EXIT(TRUE);
          END;
        END;
    end;
}

