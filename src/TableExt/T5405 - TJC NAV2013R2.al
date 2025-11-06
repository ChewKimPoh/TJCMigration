table 5405 "Production Order"
{
    Caption = 'Production Order';
    DataCaptionFields = "No.",Description;
    DrillDownPageID = 99000815;
    LookupPageID = 99000815;

    fields
    {
        field(1;Status;Option)
        {
            Caption = 'Status';
            OptionCaption = 'Simulated,Planned,Firm Planned,Released,Finished';
            OptionMembers = Simulated,Planned,"Firm Planned",Released,Finished;
        }
        field(2;"No.";Code[20])
        {
            Caption = 'No.';
            TableRelation = "Production Order".No. WHERE (Status=FIELD(Status));
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                IF "No." <> xRec."No." THEN BEGIN
                  MfgSetup.GET;
                  NoSeriesMgt.TestManual(GetNoSeriesCode);
                  "No. Series" := '';
                END;
            end;
        }
        field(3;Description;Text[50])
        {
            Caption = 'Description';

            trigger OnValidate()
            begin
                "Search Description" := Description;
            end;
        }
        field(4;"Search Description";Code[50])
        {
            Caption = 'Search Description';
        }
        field(5;"Description 2";Text[50])
        {
            Caption = 'Description 2';
        }
        field(6;"Creation Date";Date)
        {
            Caption = 'Creation Date';
            Editable = false;
        }
        field(7;"Last Date Modified";Date)
        {
            Caption = 'Last Date Modified';
            Editable = false;
        }
        field(9;"Source Type";Option)
        {
            Caption = 'Source Type';
            OptionCaption = 'Item,Family,Sales Header';
            OptionMembers = Item,Family,"Sales Header";

            trigger OnValidate()
            begin
                IF "Source Type" <> xRec."Source Type" THEN
                  CheckProdOrderStatus(FIELDCAPTION("Source Type"));
            end;
        }
        field(10;"Source No.";Code[20])
        {
            Caption = 'Source No.';
            TableRelation = IF (Source Type=CONST(Item)) Item WHERE (Type=CONST(Inventory))
                            ELSE IF (Source Type=CONST(Family)) Family
                            ELSE IF (Status=CONST(Simulated),
                                     Source Type=CONST(Sales Header)) "Sales Header".No. WHERE (Document Type=CONST(Quote))
                                     ELSE IF (Status=FILTER(Planned..),
                                              Source Type=CONST(Sales Header)) "Sales Header".No. WHERE (Document Type=CONST(Order));

            trigger OnValidate()
            var
                Item: Record "27";
                Family: Record "99000773";
                SalesHeader: Record "36";
            begin
                IF "Source No." <> xRec."Source No." THEN
                  CheckProdOrderStatus(FIELDCAPTION("Source No."));

                IF "Source No." = '' THEN
                  EXIT;

                CASE "Source Type" OF
                  "Source Type"::Item:
                    BEGIN
                      Item.GET("Source No.");
                      Item.TESTFIELD(Blocked,FALSE);
                      Description := Item.Description;
                      "Description 2" := Item."Description 2";
                      "Routing No." := Item."Routing No.";
                      "Inventory Posting Group" := Item."Inventory Posting Group";
                      "Gen. Prod. Posting Group" := Item."Gen. Prod. Posting Group";
                      "Unit Cost" := Item."Unit Cost";
                      CreateDim(DATABASE::Item,"Source No.");
                    END;
                  "Source Type"::Family:
                    BEGIN
                      Family.GET("Source No.");
                      Description := Family.Description;
                      "Description 2" := Family."Description 2";
                      "Routing No." := Family."Routing No.";
                      "Inventory Posting Group" := '';
                      "Gen. Prod. Posting Group" := '';
                      "Unit Cost" := 0;
                    END;
                  "Source Type"::"Sales Header":
                    BEGIN
                      IF Status = Status::Simulated THEN
                        SalesHeader.GET(SalesHeader."Document Type"::Quote,"Source No.")
                      ELSE
                        SalesHeader.GET(SalesHeader."Document Type"::Order,"Source No.");
                      Description := SalesHeader."Ship-to Name";
                      "Description 2" := SalesHeader."Ship-to Name 2";
                      "Routing No." := '';
                      "Inventory Posting Group" := '';
                      "Gen. Prod. Posting Group" := '';
                      "Gen. Bus. Posting Group" := SalesHeader."Gen. Bus. Posting Group";
                      "Unit Cost" := 0;
                      "Location Code" := SalesHeader."Location Code";
                      "Due Date" := SalesHeader."Shipment Date";
                      "Ending Date" := SalesHeader."Shipment Date";
                      "Dimension Set ID" := SalesHeader."Dimension Set ID";
                      "Shortcut Dimension 1 Code" := SalesHeader."Shortcut Dimension 1 Code";
                      "Shortcut Dimension 2 Code" := SalesHeader."Shortcut Dimension 2 Code";
                    END;
                END;
                VALIDATE(Description);
                InitRecord;
                UpdateDatetime;
            end;
        }
        field(11;"Routing No.";Code[20])
        {
            Caption = 'Routing No.';
            TableRelation = "Routing Header";
        }
        field(15;"Inventory Posting Group";Code[10])
        {
            Caption = 'Inventory Posting Group';
            TableRelation = "Inventory Posting Group";
        }
        field(16;"Gen. Prod. Posting Group";Code[10])
        {
            Caption = 'Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group";
        }
        field(17;"Gen. Bus. Posting Group";Code[10])
        {
            Caption = 'Gen. Bus. Posting Group';
            TableRelation = "Gen. Business Posting Group";
        }
        field(19;Comment;Boolean)
        {
            CalcFormula = Exist("Prod. Order Comment Line" WHERE (Status=FIELD(Status),
                                                                  Prod. Order No.=FIELD(No.)));
            Caption = 'Comment';
            Editable = false;
            FieldClass = FlowField;
        }
        field(20;"Starting Time";Time)
        {
            Caption = 'Starting Time';

            trigger OnValidate()
            begin
                ProdOrderLine.SETCURRENTKEY(Status,"Prod. Order No.","Planning Level Code");
                ProdOrderLine.ASCENDING(FALSE);
                ProdOrderLine.SETRANGE(Status,Status);
                ProdOrderLine.SETRANGE("Prod. Order No.","No.");
                ProdOrderLine.SETFILTER("Item No.",'<>%1','');
                ProdOrderLine.SETFILTER("Planning Level Code",'>%1',0);
                IF ProdOrderLine.FIND('-') THEN BEGIN
                  "Starting Date-Time" := CREATEDATETIME("Starting Date","Starting Time");
                  MODIFY;
                  MultiLevelMessage;
                  EXIT;
                END;
                "Due Date" := 0D;
                ProdOrderLine.SETRANGE("Planning Level Code");
                IF ProdOrderLine.FIND('-') THEN
                  REPEAT
                    ProdOrderLine."Starting Time" := "Starting Time";
                    ProdOrderLine."Starting Date" := "Starting Date";
                    ProdOrderLine.MODIFY;
                    CalcProdOrder.SetParameter(TRUE);
                    CalcProdOrder.Recalculate(ProdOrderLine,0,TRUE);
                    IF ProdOrderLine."Planning Level Code" > 0 THEN
                      ProdOrderLine."Due Date" := ProdOrderLine."Ending Date"
                    ELSE
                      ProdOrderLine."Due Date" :=
                        LeadTimeMgt.PlannedDueDate(
                          ProdOrderLine."Item No.",
                          ProdOrderLine."Location Code",
                          ProdOrderLine."Variant Code",
                          ProdOrderLine."Ending Date",
                          '',
                          2);

                    IF "Due Date" = 0D THEN
                      "Due Date" := ProdOrderLine."Due Date";
                    "Starting Date-Time" := CREATEDATETIME("Starting Date","Starting Time");
                    ProdOrderLine.MODIFY(TRUE);
                    ProdOrderLine.CheckEndingDate(CurrFieldNo <> 0);
                  UNTIL ProdOrderLine.NEXT = 0
                ELSE BEGIN
                  "Ending Date" := "Starting Date";
                  "Ending Time" := "Starting Time";
                END;
                AdjustStartEndingDate;
                MODIFY;
            end;
        }
        field(21;"Starting Date";Date)
        {
            Caption = 'Starting Date';

            trigger OnValidate()
            begin
                VALIDATE("Starting Time");
            end;
        }
        field(22;"Ending Time";Time)
        {
            Caption = 'Ending Time';

            trigger OnValidate()
            begin
                ProdOrderLine.SETCURRENTKEY(Status,"Prod. Order No.","Planning Level Code");
                ProdOrderLine.ASCENDING(TRUE);
                ProdOrderLine.SETRANGE(Status,Status);
                ProdOrderLine.SETRANGE("Prod. Order No.","No.");
                ProdOrderLine.SETFILTER("Item No.",'<>%1','');
                ProdOrderLine.SETFILTER("Planning Level Code",'>%1',0);
                IF ProdOrderLine.FIND('-') THEN BEGIN
                  "Ending Date-Time" := CREATEDATETIME("Ending Date","Ending Time");
                  MODIFY;
                  MultiLevelMessage;
                  EXIT;
                END;
                "Due Date" := 0D;
                ProdOrderLine.SETRANGE("Planning Level Code");
                IF ProdOrderLine.FIND('-') THEN
                  REPEAT
                    ProdOrderLine."Ending Time" := "Ending Time";
                    ProdOrderLine."Ending Date" := "Ending Date";
                    ProdOrderLine.MODIFY;
                    CalcProdOrder.SetParameter(TRUE);
                    CalcProdOrder.Recalculate(ProdOrderLine,1,TRUE);
                    IF ProdOrderLine."Planning Level Code" > 0 THEN
                      ProdOrderLine."Due Date" := ProdOrderLine."Ending Date"
                    ELSE
                      ProdOrderLine."Due Date" :=
                        LeadTimeMgt.PlannedDueDate(
                          ProdOrderLine."Item No.",
                          ProdOrderLine."Location Code",
                          ProdOrderLine."Variant Code",
                          ProdOrderLine."Ending Date",
                          '',
                          2);
                    IF "Due Date" = 0D THEN
                      "Due Date" := ProdOrderLine."Due Date";
                    "Ending Date-Time" := CREATEDATETIME("Ending Date","Ending Time");
                    ProdOrderLine.MODIFY(TRUE);
                    ProdOrderLine.CheckEndingDate(CurrFieldNo <> 0);
                  UNTIL ProdOrderLine.NEXT = 0
                ELSE BEGIN
                  "Starting Date" := "Ending Date";
                  "Starting Time" := "Ending Time";
                END;
                AdjustStartEndingDate;
                MODIFY;
            end;
        }
        field(23;"Ending Date";Date)
        {
            Caption = 'Ending Date';

            trigger OnValidate()
            begin
                VALIDATE("Ending Time");
            end;
        }
        field(24;"Due Date";Date)
        {
            Caption = 'Due Date';

            trigger OnValidate()
            begin
                IF "Due Date" = 0D THEN
                  EXIT;
                IF (CurrFieldNo = FIELDNO("Due Date")) OR
                   (CurrFieldNo = FIELDNO("Location Code")) OR
                   UpdateEndDate
                THEN BEGIN
                  ProdOrderLine.SETCURRENTKEY(Status,"Prod. Order No.","Planning Level Code");
                  ProdOrderLine.ASCENDING(TRUE);
                  ProdOrderLine.SETRANGE(Status,Status);
                  ProdOrderLine.SETRANGE("Prod. Order No.","No.");
                  ProdOrderLine.SETFILTER("Item No.",'<>%1','');
                  ProdOrderLine.SETFILTER("Planning Level Code",'>%1',0);
                  IF NOT ProdOrderLine.ISEMPTY THEN BEGIN
                    ProdOrderLine.SETRANGE("Planning Level Code",0);
                    IF "Source Type" = "Source Type"::Family THEN BEGIN
                      UpdateEndingDate(ProdOrderLine);
                    END ELSE BEGIN
                      IF ProdOrderLine.FIND('-') THEN
                        "Ending Date" :=
                          LeadTimeMgt.PlannedEndingDate(ProdOrderLine."Item No.","Location Code",'',"Due Date",'',2)
                      ELSE
                        "Ending Date" := "Due Date";
                      "Ending Date-Time" := CREATEDATETIME("Ending Date","Ending Time");
                      MultiLevelMessage;
                      EXIT;
                    END;
                  END ELSE BEGIN
                    ProdOrderLine.SETRANGE("Planning Level Code");
                    IF NOT ProdOrderLine.ISEMPTY THEN
                      UpdateEndingDate(ProdOrderLine)
                    ELSE BEGIN
                      IF "Source Type" = "Source Type"::Item THEN
                        "Ending Date" :=
                          LeadTimeMgt.PlannedEndingDate(
                            "Source No.",
                            "Location Code",
                            '',
                            "Due Date",
                            '',
                            2)
                      ELSE
                        "Ending Date" := "Due Date";
                      "Starting Date" := "Ending Date";
                      "Starting Date-Time" := CREATEDATETIME("Starting Date","Starting Time");
                      "Ending Date-Time" := CREATEDATETIME("Ending Date","Ending Time");
                    END;
                    AdjustStartEndingDate;
                    MODIFY;
                  END;
                END;
            end;
        }
        field(25;"Finished Date";Date)
        {
            Caption = 'Finished Date';
            Editable = false;
        }
        field(28;Blocked;Boolean)
        {
            Caption = 'Blocked';
        }
        field(30;"Shortcut Dimension 1 Code";Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(1));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1,"Shortcut Dimension 1 Code");
            end;
        }
        field(31;"Shortcut Dimension 2 Code";Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(2));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2,"Shortcut Dimension 2 Code");
            end;
        }
        field(32;"Location Code";Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location WHERE (Use As In-Transit=CONST(No));

            trigger OnValidate()
            begin
                GetDefaultBin;

                VALIDATE("Due Date"); // Scheduling consider Calendar assigned to Location
            end;
        }
        field(33;"Bin Code";Code[20])
        {
            Caption = 'Bin Code';
            TableRelation = IF (Source Type=CONST(Item)) Bin.Code WHERE (Location Code=FIELD(Location Code),
                                                                         Item Filter=FIELD(Source No.))
                                                                         ELSE IF (Source Type=FILTER(<>Item)) Bin.Code WHERE (Location Code=FIELD(Location Code));

            trigger OnValidate()
            var
                WhseIntegrationMgt: Codeunit "7317";
            begin
                IF "Bin Code" <> '' THEN
                  WhseIntegrationMgt.CheckBinTypeCode(DATABASE::"Production Order",
                    FIELDCAPTION("Bin Code"),
                    "Location Code",
                    "Bin Code",0);
            end;
        }
        field(34;"Replan Ref. No.";Code[20])
        {
            Caption = 'Replan Ref. No.';
            Editable = false;
        }
        field(35;"Replan Ref. Status";Option)
        {
            Caption = 'Replan Ref. Status';
            Editable = false;
            OptionCaption = 'Simulated,Planned,Firm Planned,Released,Finished';
            OptionMembers = Simulated,Planned,"Firm Planned",Released,Finished;
        }
        field(38;"Low-Level Code";Integer)
        {
            Caption = 'Low-Level Code';
            Editable = false;
        }
        field(40;Quantity;Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0:5;
            MinValue = 0;

            trigger OnValidate()
            begin
                IF "Source Type" = "Source Type"::Item THEN
                  "Cost Amount" := ROUND(Quantity * "Unit Cost")
                ELSE
                  "Cost Amount" := 0;
            end;
        }
        field(41;"Unit Cost";Decimal)
        {
            Caption = 'Unit Cost';
            DecimalPlaces = 2:5;
        }
        field(42;"Cost Amount";Decimal)
        {
            Caption = 'Cost Amount';
            DecimalPlaces = 2:2;
        }
        field(47;"Work Center Filter";Code[20])
        {
            Caption = 'Work Center Filter';
            FieldClass = FlowFilter;
            TableRelation = "Work Center";
        }
        field(48;"Capacity Type Filter";Option)
        {
            Caption = 'Capacity Type Filter';
            FieldClass = FlowFilter;
            OptionCaption = 'Work Center,Machine Center';
            OptionMembers = "Work Center","Machine Center";
        }
        field(49;"Capacity No. Filter";Code[20])
        {
            Caption = 'Capacity No. Filter';
            FieldClass = FlowFilter;
            TableRelation = IF (Capacity Type Filter=CONST(Work Center)) "Machine Center"
                            ELSE IF (Capacity Type Filter=CONST(Machine Center)) "Work Center";
        }
        field(50;"Date Filter";Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(51;"Expected Operation Cost Amt.";Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Prod. Order Routing Line"."Expected Operation Cost Amt." WHERE (Status=FIELD(Status),
                                                                                               Prod. Order No.=FIELD(No.)));
            Caption = 'Expected Operation Cost Amt.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(52;"Expected Component Cost Amt.";Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Prod. Order Component"."Cost Amount" WHERE (Status=FIELD(Status),
                                                                           Prod. Order No.=FIELD(No.),
                                                                           Due Date=FIELD(Date Filter)));
            Caption = 'Expected Component Cost Amt.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(55;"Actual Time Used";Decimal)
        {
            CalcFormula = Sum("Capacity Ledger Entry".Quantity WHERE (Order Type=CONST(Production),
                                                                      Order No.=FIELD(No.),
                                                                      Type=FIELD(Capacity Type Filter),
                                                                      No.=FIELD(Capacity No. Filter),
                                                                      Posting Date=FIELD(Date Filter)));
            Caption = 'Actual Time Used';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(56;"Allocated Capacity Need";Decimal)
        {
            CalcFormula = Sum("Prod. Order Capacity Need"."Needed Time" WHERE (Status=FIELD(Status),
                                                                               Prod. Order No.=FIELD(No.),
                                                                               Type=FIELD(Capacity Type Filter),
                                                                               No.=FIELD(Capacity No. Filter),
                                                                               Work Center No.=FIELD(Work Center Filter),
                                                                               Date=FIELD(Date Filter),
                                                                               Requested Only=CONST(No)));
            Caption = 'Allocated Capacity Need';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(57;"Expected Capacity Need";Decimal)
        {
            CalcFormula = Sum("Prod. Order Capacity Need"."Needed Time" WHERE (Status=FIELD(Status),
                                                                               Prod. Order No.=FIELD(No.),
                                                                               Type=FIELD(Capacity Type Filter),
                                                                               No.=FIELD(Capacity No. Filter),
                                                                               Work Center No.=FIELD(Work Center Filter),
                                                                               Date=FIELD(Date Filter),
                                                                               Requested Only=CONST(No)));
            Caption = 'Expected Capacity Need';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(80;"No. Series";Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(82;"Planned Order No.";Code[20])
        {
            Caption = 'Planned Order No.';
        }
        field(83;"Firm Planned Order No.";Code[20])
        {
            Caption = 'Firm Planned Order No.';
        }
        field(85;"Simulated Order No.";Code[20])
        {
            Caption = 'Simulated Order No.';
        }
        field(92;"Expected Material Ovhd. Cost";Decimal)
        {
            CalcFormula = Sum("Prod. Order Component"."Overhead Amount" WHERE (Status=FIELD(Status),
                                                                               Prod. Order No.=FIELD(No.)));
            Caption = 'Expected Material Ovhd. Cost';
            DecimalPlaces = 2:2;
            Editable = false;
            FieldClass = FlowField;
        }
        field(94;"Expected Capacity Ovhd. Cost";Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Prod. Order Routing Line"."Expected Capacity Ovhd. Cost" WHERE (Status=FIELD(Status),
                                                                                               Prod. Order No.=FIELD(No.)));
            Caption = 'Expected Capacity Ovhd. Cost';
            Editable = false;
            FieldClass = FlowField;
        }
        field(98;"Starting Date-Time";DateTime)
        {
            Caption = 'Starting Date-Time';

            trigger OnValidate()
            begin
                "Starting Date" := DT2DATE("Starting Date-Time");
                "Starting Time" := DT2TIME("Starting Date-Time");
                VALIDATE("Starting Time");
            end;
        }
        field(99;"Ending Date-Time";DateTime)
        {
            Caption = 'Ending Date-Time';

            trigger OnValidate()
            begin
                "Ending Date" := DT2DATE("Ending Date-Time");
                "Ending Time" := DT2TIME("Ending Date-Time");
                VALIDATE("Ending Time");
            end;
        }
        field(480;"Dimension Set ID";Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup()
            begin
                ShowDocDim;
            end;
        }
        field(7300;"Completely Picked";Boolean)
        {
            CalcFormula = Min("Prod. Order Component"."Completely Picked" WHERE (Status=FIELD(Status),
                                                                                 Prod. Order No.=FIELD(No.)));
            Caption = 'Completely Picked';
            FieldClass = FlowField;
        }
        field(9000;"Assigned User ID";Code[50])
        {
            Caption = 'Assigned User ID';
            TableRelation = "User Setup";
        }
        field(50000;"Theoretical Unit Weight";Decimal)
        {
        }
        field(50001;"Special Instruction";Text[100])
        {
        }
    }

    keys
    {
        key(Key1;Status,"No.")
        {
        }
        key(Key2;"No.",Status)
        {
        }
        key(Key3;"Search Description")
        {
        }
        key(Key4;"Low-Level Code","Replan Ref. No.","Replan Ref. Status")
        {
        }
        key(Key5;Description)
        {
        }
        key(Key6;"Source No.")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown;"No.",Description,"Source No.","Source Type")
        {
        }
    }

    trigger OnDelete()
    begin
        IF Status = Status::Released THEN BEGIN
          ItemLedgEntry.SETCURRENTKEY("Order Type","Order No.");
          ItemLedgEntry.SETRANGE("Order Type",ItemLedgEntry."Order Type"::Production);
          ItemLedgEntry.SETRANGE("Order No.","No.");
          IF ItemLedgEntry.FINDFIRST THEN
            ERROR(
              Text000,
              Status,TABLECAPTION,"No.",ItemLedgEntry.TABLECAPTION);

          CapLedgEntry.SETCURRENTKEY("Order Type","Order No.");
          CapLedgEntry.SETRANGE("Order Type",CapLedgEntry."Order Type"::Production);
          CapLedgEntry.SETRANGE("Order No.","No.");
          IF CapLedgEntry.FINDFIRST THEN
            ERROR(
              Text000,
              Status,TABLECAPTION,"No.",CapLedgEntry.TABLECAPTION);
        END;

        IF Status IN [Status::Released,Status::Finished] THEN BEGIN
          PurchLine.SETCURRENTKEY(
            "Document Type",Type,"Prod. Order No.","Prod. Order Line No.","Routing No.","Operation No.");
          PurchLine.SETRANGE("Document Type",PurchLine."Document Type"::Order);
          PurchLine.SETRANGE(Type,PurchLine.Type::Item);
          PurchLine.SETRANGE("Prod. Order No.","No.");
          IF PurchLine.FINDFIRST THEN
            ERROR(
              Text000,
              Status,TABLECAPTION,"No.",PurchLine.TABLECAPTION);
        END;

        IF Status = Status::Finished THEN
          DeleteFnshdProdOrderRelations
        ELSE
          DeleteRelations;
    end;

    trigger OnInsert()
    begin
        MfgSetup.GET;
        IF "No." = '' THEN BEGIN
          TestNoSeries;
          NoSeriesMgt.InitSeries(GetNoSeriesCode,xRec."No. Series","Due Date","No.","No. Series");
        END;

        IF Status = Status::Released THEN BEGIN
          IF ProdOrder.GET(Status::Finished,"No.") THEN
            ERROR(Text007,Status,TABLECAPTION,ProdOrder."No.",ProdOrder.Status);
          InvtAdjmtEntryOrder.SETRANGE("Order Type",InvtAdjmtEntryOrder."Order Type"::Production);
          InvtAdjmtEntryOrder.SETRANGE("Order No.","No.");
          IF InvtAdjmtEntryOrder.FINDFIRST THEN
            ERROR(Text007,Status,TABLECAPTION,ProdOrder."No.",InvtAdjmtEntryOrder.TABLECAPTION);
        END;

        InitRecord;

        "Starting Time" := MfgSetup."Normal Starting Time";
        "Ending Time" := MfgSetup."Normal Ending Time";
        "Creation Date" := TODAY;
        UpdateDatetime;
    end;

    trigger OnModify()
    begin
        "Last Date Modified" := TODAY;
        IF Status = Status::Finished THEN
          ERROR(Text006);
    end;

    trigger OnRename()
    begin
        ERROR(Text001,TABLECAPTION);
    end;

    var
        Text000: Label 'You cannot delete %1 %2 %3 because there is at least one %4 associated with it.', Comment='%1 = Document status; %2 = Table caption; %3 = Field value; %4 = Table Caption';
        Text001: Label 'You cannot rename a %1.';
        Text002: Label 'You cannot change %1 on %2 %3 %4 because there is at least one %5 associated with it.', Comment='%1 = Field caption; %2 = Document status; %3 = Table caption; %4 = Field value; %5 = Table Caption';
        Text003: Label 'The production order contains lines connected in a multi-level structure and the production order lines have not been automatically rescheduled.\';
        Text005: Label 'Use Refresh if you want to reschedule the lines.';
        MfgSetup: Record "99000765";
        ProdOrder: Record "5405";
        ProdOrderLine: Record "5406";
        InvtAdjmtEntryOrder: Record "5896";
        CapLedgEntry: Record "5832";
        ItemLedgEntry: Record "32";
        Location: Record "14";
        PurchLine: Record "39";
        NoSeriesMgt: Codeunit "396";
        CalcProdOrder: Codeunit "99000773";
        LeadTimeMgt: Codeunit "5404";
        DimMgt: Codeunit "408";
        Text006: Label 'A Finished Production Order cannot be modified.';
        Text007: Label '%1 %2 %3 cannot be created, because a %4 %2 %3 already exists.';
        ItemTrackingMgt: Codeunit "6500";
        HideValidationDialog: Boolean;
        Text008: Label 'Nothing to handle.';
        Text009: Label 'The %1 %2 %3 has item tracking. Do you want to delete it anyway?';
        UpdateEndDate: Boolean;
        Text010: Label 'You may have changed a dimension.\\Do you want to update the lines?';
        Text011: Label 'You cannot change Finished Production Order dimensions.';

    procedure InitRecord()
    begin
        IF "Due Date" = 0D THEN
          VALIDATE("Due Date",WORKDATE);
        IF ("Source Type" = "Source Type"::Item) AND ("Source No." <> '') THEN
          "Ending Date" :=
            LeadTimeMgt.PlannedEndingDate(
              "Source No.",
              "Location Code",
              '',
              "Due Date",
              '',
              2)
        ELSE
          "Ending Date" := "Due Date";
        "Starting Date" := "Ending Date";
        "Starting Date-Time" := CREATEDATETIME("Starting Date","Starting Time");
        "Ending Date-Time" := CREATEDATETIME("Ending Date","Ending Time");
    end;

    procedure TestNoSeries()
    begin
        MfgSetup.GET;

        CASE Status OF
          Status::Simulated:
            MfgSetup.TESTFIELD("Simulated Order Nos.");
          Status::Planned:
            MfgSetup.TESTFIELD("Planned Order Nos.");
          Status::"Firm Planned":
            MfgSetup.TESTFIELD("Firm Planned Order Nos.");
          Status::Released:
            MfgSetup.TESTFIELD("Released Order Nos.");
        END;
    end;

    procedure AssistEdit(OldProdOrder: Record "5405"): Boolean
    begin
        WITH ProdOrder DO BEGIN
          ProdOrder := Rec;
          MfgSetup.GET;
          TestNoSeries;
          IF NoSeriesMgt.SelectSeries(GetNoSeriesCode,OldProdOrder."No. Series","No. Series") THEN BEGIN
            NoSeriesMgt.SetSeries("No.");
            Rec := ProdOrder;
            EXIT(TRUE);
          END;
        END;
    end;

    procedure GetNoSeriesCode(): Code[10]
    begin
        MfgSetup.GET;

        CASE Status OF
          Status::Simulated:
            EXIT(MfgSetup."Simulated Order Nos.");
          Status::Planned:
            EXIT(MfgSetup."Planned Order Nos.");
          Status::"Firm Planned":
            EXIT(MfgSetup."Firm Planned Order Nos.");
          Status::Released:
            EXIT(MfgSetup."Released Order Nos.");
        END;
    end;

    procedure CheckProdOrderStatus(Name: Text[80])
    begin
        IF Status <> Status::Released THEN
          EXIT;

        IF Status IN [Status::Released,Status::Finished] THEN BEGIN
          ItemLedgEntry.SETCURRENTKEY("Order Type","Order No.");
          ItemLedgEntry.SETRANGE("Order Type",ItemLedgEntry."Order Type"::Production);
          ItemLedgEntry.SETRANGE("Order No.","No.");
          IF ItemLedgEntry.FINDFIRST THEN
            ERROR(
              Text002,
              Name,Status,TABLECAPTION,"No.",ItemLedgEntry.TABLECAPTION);

          CapLedgEntry.SETCURRENTKEY("Order Type","Order No.");
          CapLedgEntry.SETRANGE("Order Type",CapLedgEntry."Order Type"::Production);
          CapLedgEntry.SETRANGE("Order No.","No.");
          IF CapLedgEntry.FINDFIRST THEN
            ERROR(
              Text002,
              Name,Status,TABLECAPTION,"No.",CapLedgEntry.TABLECAPTION);
        END;
    end;

    procedure DeleteRelations()
    var
        ProdOrderComment: Record "5414";
        WhseRequest: Record "7325";
    begin
        ProdOrderComment.SETRANGE(Status,Status);
        ProdOrderComment.SETRANGE("Prod. Order No.","No.");
        ProdOrderComment.DELETEALL;

        HandleItemTrackingDeletion;

        ProdOrderLine.LOCKTABLE;
        ProdOrderLine.SETRANGE(Status,Status);
        ProdOrderLine.SETRANGE("Prod. Order No.","No.");
        ProdOrderLine.DELETEALL(TRUE);

        WhseRequest.SETRANGE("Document Type",WhseRequest."Document Type"::Production);
        WhseRequest.SETRANGE("Document Subtype",Status);
        WhseRequest.SETRANGE("Document No.","No.");
        WhseRequest.DELETEALL(TRUE);
        ItemTrackingMgt.DeleteWhseItemTrkgLines(
          DATABASE::"Prod. Order Component",Status,"No.",'',0,0,'',FALSE);
    end;

    procedure DeleteFnshdProdOrderRelations()
    var
        FnshdProdOrderRtngLine: Record "5409";
        FnshdProdOrderLine: Record "5406";
        FnshdProdOrderComp: Record "5407";
        FnshdProdOrderRtngTool: Record "5411";
        FnshdProdOrderRtngPers: Record "5412";
        FnshdProdOrderRtngQltyMeas: Record "5413";
        FnshdProdOrderComment: Record "5414";
        FnshdProdOrderRtngCmt: Record "5415";
        FnshdProdOrderBOMComment: Record "5416";
    begin
        FnshdProdOrderRtngLine.SETRANGE(Status,Status);
        FnshdProdOrderRtngLine.SETRANGE("Prod. Order No.","No.");
        FnshdProdOrderRtngLine.DELETEALL;

        FnshdProdOrderLine.SETRANGE(Status,Status);
        FnshdProdOrderLine.SETRANGE("Prod. Order No.","No.");
        FnshdProdOrderLine.DELETEALL;

        FnshdProdOrderComp.SETRANGE(Status,Status);
        FnshdProdOrderComp.SETRANGE("Prod. Order No.","No.");
        FnshdProdOrderComp.DELETEALL;

        FnshdProdOrderRtngTool.SETRANGE(Status,Status);
        FnshdProdOrderRtngTool.SETRANGE("Prod. Order No.","No.");
        FnshdProdOrderRtngTool.DELETEALL;

        FnshdProdOrderRtngPers.SETRANGE(Status,Status);
        FnshdProdOrderRtngPers.SETRANGE("Prod. Order No.","No.");
        FnshdProdOrderRtngPers.DELETEALL;

        FnshdProdOrderRtngQltyMeas.SETRANGE(Status,Status);
        FnshdProdOrderRtngQltyMeas.SETRANGE("Prod. Order No.","No.");
        FnshdProdOrderRtngQltyMeas.DELETEALL;

        FnshdProdOrderComment.SETRANGE(Status,Status);
        FnshdProdOrderComment.SETRANGE("Prod. Order No.","No.");
        FnshdProdOrderComment.DELETEALL;

        FnshdProdOrderRtngCmt.SETRANGE(Status,Status);
        FnshdProdOrderRtngCmt.SETRANGE("Prod. Order No.","No.");
        FnshdProdOrderRtngCmt.DELETEALL;

        FnshdProdOrderBOMComment.SETRANGE(Status,Status);
        FnshdProdOrderBOMComment.SETRANGE("Prod. Order No.","No.");
        FnshdProdOrderBOMComment.DELETEALL;
    end;

    procedure HandleItemTrackingDeletion()
    var
        ReservEntry: Record "337";
        ReservEntry2: Record "337";
        Confirmed: Boolean;
    begin
        WITH ReservEntry DO BEGIN
          ProdOrder := Rec;
          RESET;
          SETCURRENTKEY(
            "Source ID","Source Ref. No.","Source Type","Source Subtype",
            "Source Batch Name","Source Prod. Order Line","Reservation Status");
          SETFILTER("Source Type",'%1|%2',DATABASE::"Prod. Order Line",DATABASE::"Prod. Order Component");
          SETRANGE("Source Subtype",ProdOrder.Status);
          SETRANGE("Source ID",ProdOrder."No.");
          SETRANGE("Source Batch Name",'');
          SETFILTER("Item Tracking",'> %1',"Item Tracking"::None);
          IF ISEMPTY THEN
            EXIT;

          IF HideValidationDialog OR NOT GUIALLOWED THEN
            Confirmed := TRUE
          ELSE
            Confirmed := CONFIRM(Text009,FALSE,ProdOrder.Status,ProdOrder.TABLECAPTION,ProdOrder."No.");

          IF NOT Confirmed THEN
            ERROR('');

          IF FINDSET THEN
            REPEAT
              ReservEntry2 := ReservEntry;
              ReservEntry2.ClearItemTrackingFields;
              ReservEntry2.MODIFY;
            UNTIL NEXT = 0;
        END;
    end;

    procedure AdjustStartEndingDate()
    begin
        ProdOrderLine.RESET;
        ProdOrderLine.SETRANGE(Status,Status);
        ProdOrderLine.SETRANGE("Prod. Order No.","No.");

        IF NOT ProdOrderLine.FIND('-') THEN
          EXIT;

        "Starting Date" := 12319999D;
        "Starting Time" := 235959T;
        "Ending Date" := 0D;
        "Ending Time" := 000000T;

        REPEAT
          IF (ProdOrderLine."Starting Date" < "Starting Date") OR
             ((ProdOrderLine."Starting Date" = "Starting Date") AND
              (ProdOrderLine."Starting Time" < "Starting Time"))
          THEN BEGIN
            "Starting Time" := ProdOrderLine."Starting Time";
            "Starting Date" := ProdOrderLine."Starting Date";
          END;
          IF (ProdOrderLine."Ending Date" > "Ending Date") OR
             ((ProdOrderLine."Ending Date" = "Ending Date") AND
              (ProdOrderLine."Ending Time" > "Ending Time"))
          THEN BEGIN
            "Ending Time" := ProdOrderLine."Ending Time";
            "Ending Date" := ProdOrderLine."Ending Date";
          END;
        UNTIL ProdOrderLine.NEXT = 0;
        UpdateDatetime;
    end;

    procedure MultiLevelMessage()
    begin
        MESSAGE(
          Text003 +
          Text005);
    end;

    procedure UpdateDatetime()
    begin
        IF ("Starting Date" <> 0D) AND ("Starting Time" <> 0T) THEN
          "Starting Date-Time" := CREATEDATETIME("Starting Date","Starting Time")
        ELSE
          "Starting Date-Time" := 0DT;

        IF ("Ending Date" <> 0D) AND ("Ending Time" <> 0T) THEN
          "Ending Date-Time" := CREATEDATETIME("Ending Date","Ending Time")
        ELSE
          "Ending Date-Time" := 0DT;
    end;

    procedure CreateDim(Type1: Integer;No1: Code[20])
    var
        TableID: array [10] of Integer;
        No: array [10] of Code[20];
    begin
        TableID[1] := Type1;
        No[1] := No1;
        "Shortcut Dimension 1 Code" := '';
        "Shortcut Dimension 2 Code" := '';
        "Dimension Set ID" :=
          DimMgt.GetDefaultDimID(
            TableID,No,'',
            "Shortcut Dimension 1 Code","Shortcut Dimension 2 Code",0,0);
    end;

    procedure ValidateShortcutDimCode(FieldNumber: Integer;var ShortcutDimCode: Code[20])
    var
        OldDimSetID: Integer;
    begin
        OldDimSetID := "Dimension Set ID";
        DimMgt.ValidateShortcutDimValues(FieldNumber,ShortcutDimCode,"Dimension Set ID");

        IF OldDimSetID <> "Dimension Set ID" THEN BEGIN
          IF Status = Status::Finished THEN
            ERROR(Text011);
          MODIFY;
          IF SalesLinesExist THEN
            UpdateAllLineDim("Dimension Set ID",OldDimSetID);
        END;
    end;

    procedure Navigate()
    var
        NavigateForm: Page "344";
    begin
        NavigateForm.SetDoc("Due Date","No.");
        NavigateForm.RUN;
    end;

    procedure CreatePick(AssignedUserID: Code[50];SortingMethod: Option;SetBreakBulkFilter: Boolean;DoNotFillQtyToHandle: Boolean;PrintDocument: Boolean)
    var
        ProdOrderCompLine: Record "5407";
        WhseWkshLine: Record "7326";
        CreatePickFromWhseSource: Report "7305";
        ItemTrackingMgt: Codeunit "6500";
    begin
        ProdOrderCompLine.RESET;
        ProdOrderCompLine.SETRANGE(Status,Status);
        ProdOrderCompLine.SETRANGE("Prod. Order No.","No.");
        IF ProdOrderCompLine.FIND('-') THEN
          REPEAT
            ItemTrackingMgt.InitItemTrkgForTempWkshLine(
              WhseWkshLine."Whse. Document Type"::Production,ProdOrderCompLine."Prod. Order No.",
              ProdOrderCompLine."Prod. Order Line No.",DATABASE::"Prod. Order Component",
              ProdOrderCompLine.Status,ProdOrderCompLine."Prod. Order No.",
              ProdOrderCompLine."Prod. Order Line No.",ProdOrderCompLine."Line No.");
          UNTIL ProdOrderCompLine.NEXT = 0;
        COMMIT;

        TESTFIELD(Status,Status::Released);
        CALCFIELDS("Completely Picked");
        IF "Completely Picked" THEN
          ERROR(Text008);

        ProdOrderCompLine.RESET;
        ProdOrderCompLine.SETRANGE(Status,Status);
        ProdOrderCompLine.SETRANGE("Prod. Order No.","No.");
        ProdOrderCompLine.SETFILTER(
          "Flushing Method",'%1|%2|%3',
          ProdOrderCompLine."Flushing Method"::Manual,
          ProdOrderCompLine."Flushing Method"::"Pick + Forward",
          ProdOrderCompLine."Flushing Method"::"Pick + Backward");
        ProdOrderCompLine.SETRANGE("Planning Level Code",0);
        ProdOrderCompLine.SETFILTER("Expected Quantity",'>0');
        IF ProdOrderCompLine.FIND('-') THEN BEGIN
          CreatePickFromWhseSource.SetProdOrder(Rec);
          CreatePickFromWhseSource.SetHideValidationDialog(HideValidationDialog);
          IF HideValidationDialog THEN
            CreatePickFromWhseSource.Initialize(AssignedUserID,SortingMethod,PrintDocument,DoNotFillQtyToHandle,SetBreakBulkFilter);
          CreatePickFromWhseSource.USEREQUESTPAGE(NOT HideValidationDialog);
          CreatePickFromWhseSource.RUNMODAL;
          CreatePickFromWhseSource.GetResultMessage(2);
          CLEAR(CreatePickFromWhseSource);
        END ELSE
          IF NOT HideValidationDialog THEN
            MESSAGE(Text008);
    end;

    procedure SetHideValidationDialog(NewHideValidationDialog: Boolean)
    begin
        HideValidationDialog := NewHideValidationDialog;
    end;

    procedure CreateInvtPutAwayPick()
    var
        WhseRequest: Record "5765";
    begin
        TESTFIELD(Status,Status::Released);

        WhseRequest.RESET;
        WhseRequest.SETCURRENTKEY("Source Document","Source No.");
        WhseRequest.SETFILTER(
          "Source Document",'%1|%2',
          WhseRequest."Source Document"::"Prod. Consumption",
          WhseRequest."Source Document"::"Prod. Output");
        WhseRequest.SETRANGE("Source No.","No.");
        REPORT.RUNMODAL(REPORT::"Create Invt Put-away/Pick/Mvmt",TRUE,FALSE,WhseRequest);
    end;

    local procedure GetDefaultBin()
    var
        WMSManagement: Codeunit "7302";
    begin
        "Bin Code" := '';
        IF "Source Type" <> "Source Type"::Item THEN
          EXIT;

        IF ("Location Code" <> '') AND ("Source No." <> '') THEN BEGIN
          GetLocation("Location Code");
          IF Location."Bin Mandatory" AND NOT Location."Directed Put-away and Pick" THEN
            WMSManagement.GetDefaultBin("Source No.",'',"Location Code","Bin Code");
        END;
    end;

    local procedure GetLocation(LocationCode: Code[10])
    begin
        IF Location.Code <> LocationCode THEN
          Location.GET(LocationCode);
    end;

    procedure SetUpdateEndDate()
    begin
        UpdateEndDate := TRUE;
    end;

    local procedure UpdateEndingDate(var ProdOrderLine: Record "5406")
    begin
        IF ProdOrderLine.FINDSET(TRUE) THEN
          REPEAT
            ProdOrderLine."Due Date" := "Due Date";
            ProdOrderLine.MODIFY;
            CalcProdOrder.SetParameter(TRUE);
            ProdOrderLine."Ending Date" :=
              LeadTimeMgt.PlannedEndingDate(
                ProdOrderLine."Item No.",
                ProdOrderLine."Location Code",
                ProdOrderLine."Variant Code",
                ProdOrderLine."Due Date",
                '',
                2);
            CalcProdOrder.Recalculate(ProdOrderLine,1,TRUE);
            "Starting Date-Time" := CREATEDATETIME("Starting Date","Starting Time");
            "Ending Date-Time" := CREATEDATETIME("Ending Date","Ending Time");
            ProdOrderLine.MODIFY(TRUE);
            ProdOrderLine.CheckEndingDate(CurrFieldNo <> 0);
          UNTIL ProdOrderLine.NEXT = 0
    end;

    procedure ShowDocDim()
    var
        OldDimSetID: Integer;
    begin
        OldDimSetID := "Dimension Set ID";
        TESTFIELD("No.");
        "Dimension Set ID" :=
          DimMgt.EditDimensionSet2(
            "Dimension Set ID",STRSUBSTNO('%1 %2',TABLECAPTION,"No."),
            "Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
        IF OldDimSetID <> "Dimension Set ID" THEN BEGIN
          IF Status = Status::Finished THEN
            ERROR(Text011);
          MODIFY;
          IF SalesLinesExist THEN
            UpdateAllLineDim("Dimension Set ID",OldDimSetID);
        END;
    end;

    procedure SalesLinesExist(): Boolean
    begin
        ProdOrderLine.RESET;
        ProdOrderLine.SETRANGE("Prod. Order No.","No.");
        ProdOrderLine.SETRANGE(Status,Status);
        EXIT(ProdOrderLine.FINDFIRST);
    end;

    local procedure UpdateAllLineDim(NewParentDimSetID: Integer;OldParentDimSetID: Integer)
    var
        NewDimSetID: Integer;
        OldDimSetID: Integer;
    begin
        // Update all lines with changed dimensions.

        IF NewParentDimSetID = OldParentDimSetID THEN
          EXIT;
        IF NOT CONFIRM(Text010) THEN
          EXIT;

        ProdOrderLine.RESET;
        ProdOrderLine.SETRANGE("Prod. Order No.","No.");
        ProdOrderLine.SETRANGE(Status,Status);
        ProdOrderLine.LOCKTABLE;
        IF ProdOrderLine.FIND('-') THEN
          REPEAT
            OldDimSetID := ProdOrderLine."Dimension Set ID";
            NewDimSetID := DimMgt.GetDeltaDimSetID(ProdOrderLine."Dimension Set ID",NewParentDimSetID,OldParentDimSetID);
            IF ProdOrderLine."Dimension Set ID" <> NewDimSetID THEN BEGIN
              ProdOrderLine."Dimension Set ID" := NewDimSetID;
              DimMgt.UpdateGlobalDimFromDimSetID(
                ProdOrderLine."Dimension Set ID",ProdOrderLine."Shortcut Dimension 1 Code",ProdOrderLine."Shortcut Dimension 2 Code");
              ProdOrderLine.MODIFY;
              ProdOrderLine.UpdateProdOrderCompDim(NewDimSetID,OldDimSetID);
            END;
          UNTIL ProdOrderLine.NEXT = 0;
    end;
}

