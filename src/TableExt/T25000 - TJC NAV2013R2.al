table 25000 "Kit Sales Line"
{
    Caption = 'Kit Sales Line';
    DrillDownPageID = 25010;
    LookupPageID = 25010;
    PasteIsValid = false;

    fields
    {
        field(1;"Document Type";Option)
        {
            Caption = 'Document Type';
            OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order';
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";
        }
        field(2;"Document No.";Code[20])
        {
            Caption = 'Document No.';
            TableRelation = "Sales Header".No. WHERE (Document Type=FIELD(Document Type));
        }
        field(3;"Document Line No.";Integer)
        {
            Caption = 'Document Line No.';
            TableRelation = "Sales Line"."Line No." WHERE (Document Type=FIELD(Document Type),
                                                           Document No.=FIELD(Document No.));
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

            trigger OnValidate()
            begin
                TESTFIELD("Extended Quantity",0);;
                xKitSalesLine := Rec;
                INIT;
                Type := xKitSalesLine.Type;
                InitCompLine;
                CompLine.VALIDATE(Type);
                xKitSalesLine := Rec;
                INIT;
                Type := xKitSalesLine.Type;
            end;
        }
        field(6;"No.";Code[20])
        {
            Caption = 'No.';
            TableRelation = IF (Type=CONST(Item)) Item
                            ELSE IF (Type=FILTER(Resource|Setup Resource)) Resource;

            trigger OnValidate()
            begin
                TESTFIELD("Extended Quantity",0);;

                CheckItemAvailable;

                xKitSalesLine := Rec;
                INIT;
                Type := xKitSalesLine.Type;
                "No." := xKitSalesLine."No.";
                IF "No." = '' THEN
                  EXIT;
                InitCompLine;
                CompLine.VALIDATE("No.");
                Description := CompLine.Description;
                "Description 2" := CompLine."Description 2";
                "Shipment Date" := CompLine."Shipment Date";
                "Shortcut Dimension 1 Code" := CompLine."Shortcut Dimension 1 Code";
                "Shortcut Dimension 2 Code" := CompLine."Shortcut Dimension 2 Code";
                Reserve := CompLine.Reserve;
                "Unit of Measure Code" := CompLine."Unit of Measure Code";
                "Unit of Measure" := CompLine."Unit of Measure";
                "Qty. per Unit of Measure" := CompLine."Qty. per Unit of Measure";
                "Unit Cost (LCY)" := CompLine."Unit Cost (LCY)";
                "Unit Cost" := CompLine."Unit Cost";
                VALIDATE("Unit Price",CompLine."Unit Price");

                // Loc. code can have been overwritten above if code is different on sales header than on sales line.
                "Location Code" := KitLine."Location Code";
                IF Type = Type::Item THEN BEGIN
                  CompLine."Location Code" := KitLine."Location Code";
                  CompLine.VALIDATE("Variant Code");
                  "Bin Code" := CompLine."Bin Code";
                END;
            end;
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

            trigger OnValidate()
            begin
                TESTFIELD("Extended Quantity",0);;

                IF xRec."Variant Code" <> "Variant Code" THEN BEGIN
                  TestKitLine;
                  "Applies-to Entry" := 0;
                END;

                IF Reserve <> Reserve::Always THEN
                  CheckItemAvailable;

                InitCompLine;
                CompLine.VALIDATE("Variant Code","Variant Code");
                Description := CompLine.Description;
                "Description 2" := CompLine."Description 2";
                "Unit Cost (LCY)" := CompLine."Unit Cost (LCY)";
                "Unit Cost" := CompLine."Unit Cost";
                VALIDATE("Unit Price",CompLine."Unit Price");
                "Bin Code" := CompLine."Bin Code";
            end;
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

            trigger OnValidate()
            begin
                "Applies-to Entry" := 0;
                InitCompLine;
                CompLine.VALIDATE("Unit of Measure Code","Unit of Measure Code");
                "Unit of Measure" := CompLine."Unit of Measure";
                "Qty. per Unit of Measure" := CompLine."Qty. per Unit of Measure";
                "Unit Cost (LCY)" := CompLine."Unit Cost (LCY)";
                "Unit Cost" := CompLine."Unit Cost";
                "Unit Price" := CompLine."Unit Price";
                VALIDATE("Quantity per");
            end;
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
            MinValue = 0;

            trigger OnValidate()
            begin
                TESTFIELD("No.");
                IF "Quantity per" < 0 THEN
                  FIELDERROR("Quantity per",Text25001);
                "Quantity per (Base)" := ROUND("Quantity per" * "Qty. per Unit of Measure",0.00001);
                "Applies-to Entry" := 0;

                InitCompLine;
                CASE Type OF
                  Type::Item,Type::Resource:
                    BEGIN
                      "Extended Quantity" := "Quantity per" * KitLine."Quantity (Base)";
                      "Extended Quantity (Base)" := "Quantity per (Base)" * KitLine."Quantity (Base)";
                      "Outstanding Quantity" := "Quantity per" * KitLine."Outstanding Qty. (Base)";
                      "Outstanding Qty. (Base)" := "Quantity per (Base)" * KitLine."Outstanding Qty. (Base)";
                    END;
                  Type::"Setup Resource":
                    BEGIN
                      "Extended Quantity" := "Quantity per";
                      "Extended Quantity (Base)" := "Quantity per (Base)";
                      "Outstanding Quantity" := "Quantity per";
                      "Outstanding Qty. (Base)" := "Quantity per (Base)";
                    END;
                END;
                IF Reserve <> Reserve::Always THEN
                  CheckItemAvailable;
                CompLine."Unit of Measure Code" := "Unit of Measure Code";
                CompLine."Qty. per Unit of Measure" := "Qty. per Unit of Measure";
                CompLine."Unit Price" := "Unit Price";
                CompLine.VALIDATE(Quantity,"Extended Quantity");
                VALIDATE("Unit Price",CompLine."Unit Price");

                IF Type = Type::Item THEN
                  IF (xRec."Extended Quantity" <> "Extended Quantity") OR (xRec."Extended Quantity (Base)" <> "Extended Quantity (Base)") THEN
                BEGIN
                    //ReserveKitSalesLine.VerifyQuantity(Rec,xRec);
                    //WhseValidateSourceLine.KitSalesLineVerifyChange(Rec,xRec);
                  END;
            end;
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
        field(18;"Outstanding Quantity";Decimal)
        {
            Caption = 'Outstanding Quantity';
            DecimalPlaces = 0:5;
            Editable = false;
        }
        field(19;"Outstanding Qty. (Base)";Decimal)
        {
            Caption = 'Outstanding Qty. (Base)';
            DecimalPlaces = 0:5;
            Editable = false;
        }
        field(20;"Reserved Quantity";Decimal)
        {
            CalcFormula = -Sum("Reservation Entry".Quantity WHERE (Source ID=FIELD(Document No.),
                                                                   Source Ref. No.=FIELD(Line No.),
                                                                   Source Type=CONST(25000),
                                                                   Source Subtype=FIELD(Document Type),
                                                                   Source Prod. Order Line=FIELD(Document Line No.),
                                                                   Reservation Status=CONST(Reservation)));
            Caption = 'Reserved Quantity';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(21;"Reserved Qty. (Base)";Decimal)
        {
            CalcFormula = -Sum("Reservation Entry"."Quantity (Base)" WHERE (Source ID=FIELD(Document No.),
                                                                            Source Ref. No.=FIELD(Line No.),
                                                                            Source Type=CONST(25000),
                                                                            Source Subtype=FIELD(Document Type),
                                                                            Source Prod. Order Line=FIELD(Document Line No.),
                                                                            Reservation Status=CONST(Reservation)));
            Caption = 'Reserved Qty. (Base)';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(22;Reserve;Option)
        {
            Caption = 'Reserve';
            OptionCaption = 'Never,Optional,Always';
            OptionMembers = Never,Optional,Always;

            trigger OnValidate()
            begin
                IF Reserve <> Reserve::Never THEN BEGIN
                  TESTFIELD(Type,Type::Item);
                  TESTFIELD("No.");
                END;
                CALCFIELDS("Reserved Qty. (Base)");
                IF (Reserve = Reserve::Never) AND ("Reserved Qty. (Base)" > 0) THEN
                  TESTFIELD("Reserved Qty. (Base)",0);

                IF xRec.Reserve = Reserve::Always THEN BEGIN
                  Item.GET("No.");
                  IF Item.Reserve = Item.Reserve::Always THEN
                    TESTFIELD(Reserve,Reserve::Always);
                END;
            end;
        }
        field(23;"Shipment Date";Date)
        {
            Caption = 'Shipment Date';
            Editable = false;

            trigger OnValidate()
            var
                CheckDateConflict: Codeunit "99000815";
            begin
                IF ("Extended Quantity" <> 0) AND
                   (Reserve <> Reserve::Never)
                THEN
                  //CheckDateConflict.KitSalesLineCheck(Rec,FALSE);
            end;
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

            trigger OnLookup()
            begin
                SelectItemEntry;
            end;

            trigger OnValidate()
            var
                ItemLedgEntry: Record "32";
            begin
                IF "Applies-to Entry" <> 0 THEN BEGIN
                  ItemLedgEntry.GET("Applies-to Entry");
                  ItemLedgEntry.TESTFIELD("Location Code","Location Code");
                  ItemLedgEntry.TESTFIELD("Variant Code","Variant Code");

                  TESTFIELD(Type,Type::Item);
                  TESTFIELD("Extended Quantity");
                  InitCompLine;
                  CompLine.Quantity := "Extended Quantity";
                  CompLine.VALIDATE("Appl.-to Item Entry","Applies-to Entry");
                  ItemLedgEntry.GET("Applies-to Entry");

                  "Unit Cost (LCY)" := CompLine."Unit Cost (LCY)";
                  "Unit Cost" := CompLine."Unit Cost";
                END;
            end;
        }
        field(29;"Bin Code";Code[20])
        {
            Caption = 'Bin Code';
            TableRelation = IF (Type=CONST(Item)) "Bin Content"."Bin Code" WHERE (Location Code=FIELD(Location Code),
                                                                                  Item No.=FIELD(No.),
                                                                                  Variant Code=FIELD(Variant Code));

            trigger OnValidate()
            begin
                IF xRec."Bin Code" <> "Bin Code" THEN
                  TestKitLine;
                InitCompLine;
                CompLine."Variant Code" := "Variant Code";
                CompLine.VALIDATE("Bin Code","Bin Code");
            end;
        }
        field(30;"Unit Cost (LCY)";Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Unit Cost (LCY)';

            trigger OnValidate()
            begin
                IF (CurrFieldNo = FIELDNO("Unit Cost (LCY)")) AND
                   (Type = Type::Item) AND ("No." <> '') THEN BEGIN
                  Item.GET("No.");
                  IF Item."Costing Method" = Item."Costing Method"::Standard THEN
                    ERROR(
                      Text25000,
                      FIELDCAPTION("Unit Cost"),Item.FIELDCAPTION("Costing Method"),Item."Costing Method")
                END;
                InitCompLine;
                CompLine.VALIDATE("Unit Cost (LCY)","Unit Cost (LCY)");
                "Unit Cost" := CompLine."Unit Cost";
            end;
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

            trigger OnValidate()
            begin
                TESTFIELD(Type);
                IF (CurrFieldNo <> 0) AND
                   ("Quantity per" <> 0) AND
                   (("Unit Price" <> xRec."Unit Price") OR
                    ("Quantity per" <> xRec."Quantity per"))
                THEN;
                  //KitManagement.RollUpPrice(Rec,1);
            end;
        }
        field(33;"Pick Qty.";Decimal)
        {
            CalcFormula = Sum("Warehouse Activity Line"."Qty. Outstanding" WHERE (Activity Type=FILTER(<>Put-away),
                                                                                  Source Type=CONST(25000),
                                                                                  Source Subtype=FIELD(Document Type),
                                                                                  Source No.=FIELD(Document No.),
                                                                                  Source Line No.=FIELD(Document Line No.),
                                                                                  Source Subline No.=FIELD(Line No.),
                                                                                  Unit of Measure Code=FIELD(Unit of Measure Code),
                                                                                  Action Type=FILTER(' '|Place),
                                                                                  Original Breakbulk=CONST(No),
                                                                                  Breakbulk No.=CONST(0)));
            Caption = 'Pick Qty.';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(34;"Pick Qty. (Base)";Decimal)
        {
            CalcFormula = Sum("Warehouse Activity Line"."Qty. Outstanding (Base)" WHERE (Activity Type=FILTER(<>Put-away),
                                                                                         Source Type=CONST(25000),
                                                                                         Source Subtype=FIELD(Document Type),
                                                                                         Source No.=FIELD(Document No.),
                                                                                         Source Line No.=FIELD(Document Line No.),
                                                                                         Source Subline No.=FIELD(Line No.),
                                                                                         Unit of Measure Code=FIELD(Unit of Measure Code),
                                                                                         Action Type=FILTER(' '|Place),
                                                                                         Original Breakbulk=CONST(No),
                                                                                         Breakbulk No.=CONST(0)));
            Caption = 'Pick Qty. (Base)';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(35;"Qty. Picked";Decimal)
        {
            Caption = 'Qty. Picked';
            DecimalPlaces = 0:5;
            Editable = false;
        }
        field(36;"Qty. Picked (Base)";Decimal)
        {
            Caption = 'Qty. Picked (Base)';
            DecimalPlaces = 0:5;
            Editable = false;
        }
        field(37;"Completely Picked";Boolean)
        {
            Caption = 'Completely Picked';
            Editable = false;
        }
        field(38;"Quantity Shipped (Base)";Decimal)
        {
            Caption = 'Quantity Shipped (Base)';
            DecimalPlaces = 0:5;
            Editable = false;
        }
    }

    keys
    {
        key(Key1;"Document Type","Document No.","Document Line No.","Line No.")
        {
        }
        key(Key2;"Document Type",Type,"No.","Variant Code","Location Code","Shipment Date")
        {
            SumIndexFields = "Outstanding Qty. (Base)","Quantity Shipped (Base)","Qty. Picked (Base)";
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        CapableToPromise: Codeunit "99000886";
    begin
        GetKitLine;
        TestStatusOpen;
        IF NOT QtyShippedCheckSuspend THEN
          KitLine.TESTFIELD("Quantity Shipped",0);

        //IF NOT SkipPricing THEN
        //  KitManagement.RollUpPrice(Rec,2);

        IF ("Extended Quantity" <> 0) AND ItemExists("No.") THEN BEGIN
          //ReserveKitSalesLine.DeleteLine(Rec);
          CALCFIELDS("Reserved Qty. (Base)");
          TESTFIELD("Reserved Qty. (Base)",0);
          //WhseValidateSourceLine.KitSalesLineDelete(Rec);
        END;

        //CapableToPromise.RemoveReqLines("Document No.","Document Line No.","Line No.",0,FALSE);
    end;

    trigger OnInsert()
    begin
        TestStatusOpen;
        GetKitLine;
        //KitLine.TESTFIELD("Build Kit",TRUE); // already tested for type<>blank
        //KitManagement.RollUpPrice(Rec,3);
        //IF "Extended Quantity" <> 0 THEN
        //   ReserveKitSalesLine.VerifyQuantity(Rec,xRec);
    end;

    trigger OnModify()
    begin
        TestStatusOpen;
        //KitManagement.RollUpPrice(Rec,1);

        //IF ("Extended Quantity" <> 0) AND ItemExists(xRec."No.") THEN
        //  ReserveKitSalesLine.VerifyChange(Rec,xRec);
    end;

    trigger OnRename()
    begin
        ERROR(Text001,TABLECAPTION);
    end;

    var
        KitLine: Record "37";
        KitLine2: Record "37";
        CompLine: Record "37";
        xKitSalesLine: Record "25000";
        Text000: Label 'Automatic reservation is not possible.\Reserve items manually?';
        Text001: Label 'You cannot rename a %1.';
        Text25000: Label 'You cannot change %1 when %2 is %3.';
        Item: Record "27";
        WhseValidateSourceLine: Codeunit "5777";
        UseKitLine2: Boolean;
        Text25001: Label 'must be positive';
        SkipPricing: Boolean;
        QtyShippedCheckSuspend: Boolean;
        StatusCheckSuspended: Boolean;

    procedure GetCurrencyCode(): Code[10]
    var
        SalesHeader: Record "36";
    begin
        IF ("Document Type" = SalesHeader."Document Type") AND
           ("Document No." = SalesHeader."No.")
        THEN
          EXIT(SalesHeader."Currency Code");
        IF SalesHeader.GET("Document Type","Document No.") THEN
          EXIT(SalesHeader."Currency Code");
        EXIT('');
    end;

    local procedure GetCaptionClass(FieldNumber: Integer): Text[80]
    var
        SalesHeader: Record "36";
    begin
        IF NOT SalesHeader.GET("Document Type","Document No.") THEN BEGIN
          SalesHeader."No." := '';
          SalesHeader.INIT;
        END;
        IF SalesHeader."Prices Including VAT" THEN
          EXIT('2,1,' + GetFieldCaption(FieldNumber))
        ELSE
          EXIT('2,0,' + GetFieldCaption(FieldNumber));
    end;

    local procedure GetFieldCaption(FieldNumber: Integer): Text[100]
    var
        "Field": Record "2000000041";
    begin
        Field.GET(DATABASE::"Kit Sales Line",FieldNumber);
        EXIT(Field."Field Caption");
    end;

    procedure GetKitLine()
    begin
        IF UseKitLine2 THEN
          KitLine := KitLine2
        ELSE BEGIN
          TESTFIELD("Document No.");
          IF ("Document Type" <> KitLine."Document Type") OR
             ("Document No." <> KitLine."Document No.") OR
             ("Document Line No." <> KitLine."Line No.")
          THEN
            KitLine.GET("Document Type","Document No.","Document Line No.");
        END;
    end;

    procedure TestKitLine()
    begin
        GetKitLine;
        KitLine.TESTFIELD("Qty. Shipped Not Invoiced",0);
        KitLine.TESTFIELD("Shipment No.",'');
        KitLine.TESTFIELD("Return Qty. Rcd. Not Invd.",0);
        KitLine.TESTFIELD("Return Receipt No.",'');
    end;

    procedure InitCompLine()
    begin
        GetKitLine;
        //KitLine.TESTFIELD("Build Kit",TRUE);
        KitLine.TESTFIELD("Quantity Shipped",0);
        CompLine := KitLine;
        CompLine."Line No." := 0; // to avoid doc.dim to be really inserted.
        CASE Type OF
          Type::" ":
            CompLine.Type := CompLine.Type::" ";
          Type::Item:
            CompLine.Type := CompLine.Type::Item;
          Type::Resource, Type::"Setup Resource":
            CompLine.Type := CompLine.Type::Resource;
        END;
        CompLine."No." := "No.";
        CompLine."Shipment Date" := "Shipment Date";
        CompLine."Variant Code" := "Variant Code";
        CompLine."Unit of Measure Code" := "Unit of Measure Code";
        CompLine.Quantity := 0;
        CompLine."Unit Price" := "Unit Price";
        //CompLine."Build Kit" := FALSE;
        CompLine.SetHideValidationDialog(TRUE);
    end;

    procedure ItemAvailability(AvailabilityType: Option Date,Variant,Location,Bin)
    var
        Item: Record "27";
    begin
        TESTFIELD(Type,Type::Item);
        TESTFIELD("No.");
        Item.RESET;
        Item.GET("No.");
        Item.SETRANGE("No.","No.");
        Item.SETRANGE("Date Filter",0D,"Shipment Date");
        
        CASE AvailabilityType OF
          AvailabilityType::Date:
            BEGIN
              /*
              Item.SETRANGE("Variant Filter","Variant Code");
              Item.SETRANGE("Location Filter","Location Code");
              CLEAR(ItemAvailByDate);
              ItemAvailByDate.LOOKUPMODE(FALSE);
              ItemAvailByDate.SETRECORD(Item);
              ItemAvailByDate.SETTABLEVIEW(Item);
              ItemAvailByDate.RUNMODAL;
              */
            END;
          AvailabilityType::Variant:
            BEGIN
              Item.SETRANGE("Location Filter","Location Code");
              /*
              CLEAR(ItemAvailByVar);
              ItemAvailByVar.LOOKUPMODE(FALSE);
              ItemAvailByVar.SETRECORD(Item);
              ItemAvailByVar.SETTABLEVIEW(Item);
              ItemAvailByVar.RUNMODAL;
              */
            END;
          AvailabilityType::Location:
            BEGIN
              Item.SETRANGE("Variant Filter","Variant Code");
              /*
              CLEAR(ItemAvailByLoc);
              ItemAvailByLoc.LOOKUPMODE(FALSE);
              ItemAvailByLoc.SETRECORD(Item);
              ItemAvailByLoc.SETTABLEVIEW(Item);
              ItemAvailByLoc.RUNMODAL;
              */
            END;
        END;

    end;

    procedure ShowReservation()
    begin
        TESTFIELD(Type,Type::Item);
        TESTFIELD("No.");
        TESTFIELD(Reserve);
        //CLEAR(Reservation);
        //Reservation.SetKitSalesLine(Rec);
        //Reservation.RUNMODAL;
    end;

    procedure ShowReservationEntries(Modal: Boolean)
    var
        ReservEntry: Record "337";
        ReservEngineMgt: Codeunit "99000831";
    begin
        TESTFIELD(Type,Type::Item);
        TESTFIELD("No.");
        ReservEngineMgt.InitFilterAndSortingLookupFor(ReservEntry,TRUE);
        //ReserveKitSalesLine.FilterReservFor(ReservEntry,Rec);
        IF Modal THEN
          //FORM.RUNMODAL(FORM::Page497,ReservEntry)
          PAGE.RUNMODAL(PAGE::"Reservation Entries",ReservEntry)
        ELSE
          //FORM.RUN(FORM::Page497,ReservEntry);
          PAGE.RUN(PAGE::"Reservation Entries",ReservEntry);
    end;

    procedure AutoReserve()
    var
        ReservMgt: Codeunit "99000845";
        FullAutoReservation: Boolean;
    begin
        TESTFIELD(Type,Type::Item);
        TESTFIELD("No.");
        
        /*
        IF ReserveKitSalesLine.ReservQuantity(Rec) <> 0 THEN BEGIN
          ReservMgt.SetKitSalesLine(Rec);
          TESTFIELD("Shipment Date");
          ReservMgt.AutoReserve(FullAutoReservation,'',"Shipment Date",ReserveKitSalesLine.ReservQuantity(Rec));
          FIND;
          IF NOT FullAutoReservation THEN BEGIN
            COMMIT;
            IF CONFIRM(Text000,TRUE) THEN BEGIN
              ShowReservation;
              FIND;
            END;
          END;
        END;
        */

    end;

    procedure OpenItemTrackingLines()
    begin
        IF NOT ("Document Type" IN ["Document Type"::Quote,"Document Type"::Order,"Document Type"::Invoice]) THEN
          FIELDERROR("Document Type");
        TESTFIELD(Type,Type::Item);
        TESTFIELD("No.");
        TESTFIELD("Extended Quantity (Base)");

        //ReserveKitSalesLine.CallItemTracking(Rec);
    end;

    local procedure SelectItemEntry()
    var
        ItemLedgEntry: Record "32";
        KitSalesLine2: Record "25000";
    begin
        ItemLedgEntry.SETCURRENTKEY("Item No.",Open);
        ItemLedgEntry.SETRANGE("Item No.","No.");
        IF "Location Code" <> '' THEN
          ItemLedgEntry.SETRANGE("Location Code","Location Code");
        ItemLedgEntry.SETRANGE("Variant Code","Variant Code");
        ItemLedgEntry.SETRANGE(Positive,TRUE);
        ItemLedgEntry.SETRANGE(Open,TRUE);

        //IF FORM.RUNMODAL(FORM::Page38,ItemLedgEntry) = ACTION::LookupOK THEN BEGIN
        IF PAGE.RUNMODAL(PAGE::"Item Ledger Entries",ItemLedgEntry) = ACTION::LookupOK THEN BEGIN
          KitSalesLine2 := Rec;
          KitSalesLine2.VALIDATE("Applies-to Entry",ItemLedgEntry."Entry No.");
          IF Reserve <> Reserve::Always THEN
            CheckItemAvailable;
          Rec := KitSalesLine2;
        END;
    end;

    procedure SetKitLine(NewSalesLine: Record "37")
    begin
        UseKitLine2 := TRUE;
        KitLine2 := NewSalesLine;
    end;

    local procedure CheckItemAvailable()
    var
        SalesHeader: Record "36";
        ItemCheckAvail: Codeunit "311";
    begin
        IF "Shipment Date" = 0D THEN BEGIN
          SalesHeader.GET("Document Type","Document No.");
          IF SalesHeader."Shipment Date" <> 0D THEN
            "Shipment Date" := SalesHeader."Shipment Date"
          ELSE
            "Shipment Date" := WORKDATE;
        END;

        IF (CurrFieldNo <> 0) AND GUIALLOWED AND
           ("Document Type" IN ["Document Type"::Order,"Document Type"::Invoice]) AND
           (Type = Type::Item) AND ("No." <> '') AND
           ("Outstanding Quantity" > 0)
        THEN
          //ItemCheckAvail.KitSalesLineCheck2(Rec);
    end;

    procedure ItemExists(ItemNo: Code[20]): Boolean
    var
        Item2: Record "27";
    begin
        IF Type = Type::Item THEN
          IF NOT Item2.GET(ItemNo) THEN
            EXIT(FALSE);
        EXIT(TRUE);
    end;

    procedure SetSkipPricing()
    begin
        SkipPricing := TRUE;
    end;

    procedure SuspendQtyShippedCheck(Suspend: Boolean)
    begin
        QtyShippedCheckSuspend := Suspend;
    end;

    procedure SuspendStatusCheck(Suspend: Boolean)
    begin
        StatusCheckSuspended := Suspend;
    end;

    local procedure TestStatusOpen()
    var
        SalesHeader: Record "36";
    begin
        IF StatusCheckSuspended THEN
          EXIT;
        TESTFIELD("Document No.");
        IF ("Document Type" <> SalesHeader."Document Type") OR ("Document No." <> SalesHeader."No.") THEN
          SalesHeader.GET("Document Type","Document No.");
        SalesHeader.TESTFIELD(Status,SalesHeader.Status::Open);
    end;
}

