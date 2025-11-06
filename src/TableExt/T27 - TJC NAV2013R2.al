table 27 Item
{
    // DP.NCM TJC #511 11/04/2019 add field 50005 English Translation

    Caption = 'Item';
    DataCaptionFields = "No.",Description;
    DrillDownPageID = 31;
    LookupPageID = 31;
    Permissions = ;

    fields
    {
        field(1;"No.";Code[20])
        {
            Caption = 'No.';

            trigger OnValidate()
            begin
                IF "No." <> xRec."No." THEN BEGIN
                  GetInvtSetup;
                  NoSeriesMgt.TestManual(InvtSetup."Item Nos.");
                  "No. Series" := '';
                END;
            end;
        }
        field(2;"No. 2";Code[20])
        {
            Caption = 'No. 2';
        }
        field(3;Description;Text[50])
        {
            Caption = 'Description';

            trigger OnValidate()
            begin
                IF ("Search Description" = UPPERCASE(xRec.Description)) OR ("Search Description" = '') THEN
                  "Search Description" := Description;

                IF "Created From Nonstock Item" THEN BEGIN
                  NonstockItem.SETCURRENTKEY("Item No.");
                  NonstockItem.SETRANGE("Item No.","No.");
                  IF NonstockItem.FINDFIRST THEN
                    IF NonstockItem.Description = '' THEN BEGIN
                      NonstockItem.Description := Description;
                      NonstockItem.MODIFY;
                    END;
                END;
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
        field(6;"Assembly BOM";Boolean)
        {
            CalcFormula = Exist("BOM Component" WHERE (Parent Item No.=FIELD(No.)));
            Caption = 'Assembly BOM';
            Editable = false;
            FieldClass = FlowField;
        }
        field(8;"Base Unit of Measure";Code[10])
        {
            Caption = 'Base Unit of Measure';
            TableRelation = "Unit of Measure";
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                UnitOfMeasure: Record "204";
            begin
                IF "Base Unit of Measure" <> xRec."Base Unit of Measure" THEN BEGIN
                  TestNoOpenEntriesExist(FIELDCAPTION("Base Unit of Measure"));

                  "Sales Unit of Measure" := "Base Unit of Measure";
                  "Purch. Unit of Measure" := "Base Unit of Measure";
                  IF "Base Unit of Measure" <> '' THEN BEGIN
                    UnitOfMeasure.GET("Base Unit of Measure");

                    IF NOT ItemUnitOfMeasure.GET("No.","Base Unit of Measure") THEN BEGIN
                      ItemUnitOfMeasure.INIT;
                      ItemUnitOfMeasure.VALIDATE("Item No.","No.");
                      ItemUnitOfMeasure.VALIDATE(Code,"Base Unit of Measure");
                      ItemUnitOfMeasure."Qty. per Unit of Measure" := 1;
                      ItemUnitOfMeasure.INSERT;
                    END ELSE BEGIN
                      IF ItemUnitOfMeasure."Qty. per Unit of Measure" <> 1 THEN
                        ERROR(STRSUBSTNO(BaseUnitOfMeasureQtyMustBeOneErr,"Base Unit of Measure",ItemUnitOfMeasure."Qty. per Unit of Measure"));
                    END;
                  END;
                END;
            end;
        }
        field(9;"Price Unit Conversion";Integer)
        {
            Caption = 'Price Unit Conversion';
        }
        field(10;Type;Option)
        {
            Caption = 'Type';
            OptionCaption = 'Inventory,Service';
            OptionMembers = Inventory,Service;

            trigger OnValidate()
            var
                ItemLedgEntry: Record "32";
            begin
                ItemLedgEntry.RESET;
                ItemLedgEntry.SETCURRENTKEY("Item No.");
                ItemLedgEntry.SETRANGE("Item No.","No.");
                IF NOT ItemLedgEntry.ISEMPTY THEN
                  ERROR(CannotChangeFieldErr,FIELDCAPTION(Type),TABLECAPTION,"No.",ItemLedgEntry.TABLECAPTION);

                CheckJournalsAndWorksheets(FIELDNO(Type));
                CheckDocuments(FIELDNO(Type));
                IF Type = Type::Service THEN BEGIN
                  CALCFIELDS("Assembly BOM");
                  TESTFIELD("Assembly BOM",FALSE);

                  CALCFIELDS("Stockkeeping Unit Exists");
                  TESTFIELD("Stockkeeping Unit Exists",FALSE);

                  VALIDATE("Assembly Policy","Assembly Policy"::"Assemble-to-Stock");
                  VALIDATE("Replenishment System","Replenishment System"::Purchase);
                  VALIDATE(Reserve,Reserve::Never);
                  VALIDATE("Inventory Posting Group",'');
                  VALIDATE("Item Tracking Code",'');
                  VALIDATE("Costing Method","Costing Method"::FIFO);
                  VALIDATE("Production BOM No.",'');
                  VALIDATE("Routing No.",'');
                  VALIDATE("Reordering Policy","Reordering Policy"::" ");
                  VALIDATE("Order Tracking Policy","Order Tracking Policy"::None);
                END;
            end;
        }
        field(11;"Inventory Posting Group";Code[10])
        {
            Caption = 'Inventory Posting Group';
            TableRelation = "Inventory Posting Group";

            trigger OnValidate()
            begin
                IF "Inventory Posting Group" <> '' THEN
                  TESTFIELD(Type,Type::Inventory);
            end;
        }
        field(12;"Shelf No.";Code[10])
        {
            Caption = 'Shelf No.';
        }
        field(14;"Item Disc. Group";Code[20])
        {
            Caption = 'Item Disc. Group';
            TableRelation = "Item Discount Group";
        }
        field(15;"Allow Invoice Disc.";Boolean)
        {
            Caption = 'Allow Invoice Disc.';
            InitValue = true;
        }
        field(16;"Statistics Group";Integer)
        {
            Caption = 'Statistics Group';
        }
        field(17;"Commission Group";Integer)
        {
            Caption = 'Commission Group';
        }
        field(18;"Unit Price";Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Unit Price';
            MinValue = 0;

            trigger OnValidate()
            begin
                VALIDATE("Price/Profit Calculation");
            end;
        }
        field(19;"Price/Profit Calculation";Option)
        {
            Caption = 'Price/Profit Calculation';
            OptionCaption = 'Profit=Price-Cost,Price=Cost+Profit,No Relationship';
            OptionMembers = "Profit=Price-Cost","Price=Cost+Profit","No Relationship";

            trigger OnValidate()
            begin
                CASE "Price/Profit Calculation" OF
                  "Price/Profit Calculation"::"Profit=Price-Cost":
                    IF "Unit Price" <> 0 THEN
                      IF "Unit Cost" = 0 THEN
                        "Profit %" := 0
                      ELSE
                        "Profit %" :=
                          ROUND(
                            100 * (1 - "Unit Cost" /
                                   ("Unit Price" / (1 + CalcVAT))),0.00001)
                    ELSE
                      "Profit %" := 0;
                  "Price/Profit Calculation"::"Price=Cost+Profit":
                    IF "Profit %" < 100 THEN BEGIN
                      GetGLSetup;
                      "Unit Price" :=
                        ROUND(
                          ("Unit Cost" / (1 - "Profit %" / 100)) *
                          (1 + CalcVAT),
                          GLSetup."Unit-Amount Rounding Precision");
                    END;
                END;
            end;
        }
        field(20;"Profit %";Decimal)
        {
            Caption = 'Profit %';
            DecimalPlaces = 0:5;

            trigger OnValidate()
            begin
                VALIDATE("Price/Profit Calculation");
            end;
        }
        field(21;"Costing Method";Option)
        {
            Caption = 'Costing Method';
            OptionCaption = 'FIFO,LIFO,Specific,Average,Standard';
            OptionMembers = FIFO,LIFO,Specific,"Average",Standard;

            trigger OnValidate()
            begin
                IF "Costing Method" = xRec."Costing Method" THEN
                  EXIT;

                IF "Costing Method" <> "Costing Method"::FIFO THEN
                  TESTFIELD(Type,Type::Inventory);

                IF "Costing Method" = "Costing Method"::Specific THEN BEGIN
                  TESTFIELD("Item Tracking Code");

                  ItemTrackingCode.GET("Item Tracking Code");
                  IF NOT ItemTrackingCode."SN Specific Tracking" THEN
                    ERROR(
                      Text018,
                      ItemTrackingCode.FIELDCAPTION("SN Specific Tracking"),
                      FORMAT(TRUE),ItemTrackingCode.TABLECAPTION,ItemTrackingCode.Code,
                      FIELDCAPTION("Costing Method"),"Costing Method");
                END;

                TestNoEntriesExist(FIELDCAPTION("Costing Method"));

                ItemCostMgt.UpdateUnitCost(Rec,'','',0,0,FALSE,FALSE,TRUE,FIELDNO("Costing Method"));
            end;
        }
        field(22;"Unit Cost";Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Unit Cost';
            MinValue = 0;

            trigger OnValidate()
            begin
                IF "Costing Method" = "Costing Method"::Standard THEN
                  VALIDATE("Standard Cost","Unit Cost")
                ELSE
                  TestNoEntriesExist(FIELDCAPTION("Unit Cost"));
                VALIDATE("Price/Profit Calculation");
            end;
        }
        field(24;"Standard Cost";Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Standard Cost';
            MinValue = 0;

            trigger OnValidate()
            begin
                IF ("Costing Method" = "Costing Method"::Standard) AND (CurrFieldNo <> 0) THEN
                  IF NOT GUIALLOWED THEN BEGIN
                    "Standard Cost" := xRec."Standard Cost";
                    EXIT;
                  END ELSE
                    IF NOT
                       CONFIRM(
                         Text020 +
                         Text021 +
                         Text022,FALSE,
                         FIELDCAPTION("Standard Cost"))
                    THEN BEGIN
                      "Standard Cost" := xRec."Standard Cost";
                      EXIT;
                    END;

                ItemCostMgt.UpdateUnitCost(Rec,'','',0,0,FALSE,FALSE,TRUE,FIELDNO("Standard Cost"));
            end;
        }
        field(25;"Last Direct Cost";Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Last Direct Cost';
            MinValue = 0;
        }
        field(28;"Indirect Cost %";Decimal)
        {
            Caption = 'Indirect Cost %';
            DecimalPlaces = 0:5;
            MinValue = 0;

            trigger OnValidate()
            begin
                ItemCostMgt.UpdateUnitCost(Rec,'','',0,0,FALSE,FALSE,TRUE,FIELDNO("Indirect Cost %"));
            end;
        }
        field(29;"Cost is Adjusted";Boolean)
        {
            Caption = 'Cost is Adjusted';
            Editable = false;
            InitValue = true;
        }
        field(30;"Allow Online Adjustment";Boolean)
        {
            Caption = 'Allow Online Adjustment';
            Editable = false;
            InitValue = true;
        }
        field(31;"Vendor No.";Code[20])
        {
            Caption = 'Vendor No.';
            TableRelation = Vendor;
            //This property is currently not supported
            //TestTableRelation = true;
            ValidateTableRelation = true;

            trigger OnValidate()
            begin
                IF (xRec."Vendor No." <> "Vendor No.") AND
                   ("Vendor No." <> '')
                THEN
                  IF Vend.GET("Vendor No.") THEN
                    "Lead Time Calculation" := Vend."Lead Time Calculation";
            end;
        }
        field(32;"Vendor Item No.";Text[20])
        {
            Caption = 'Vendor Item No.';
        }
        field(33;"Lead Time Calculation";DateFormula)
        {
            Caption = 'Lead Time Calculation';
        }
        field(34;"Reorder Point";Decimal)
        {
            Caption = 'Reorder Point';
            DecimalPlaces = 0:5;
        }
        field(35;"Maximum Inventory";Decimal)
        {
            Caption = 'Maximum Inventory';
            DecimalPlaces = 0:5;
        }
        field(36;"Reorder Quantity";Decimal)
        {
            Caption = 'Reorder Quantity';
            DecimalPlaces = 0:5;
        }
        field(37;"Alternative Item No.";Code[20])
        {
            Caption = 'Alternative Item No.';
            TableRelation = Item;
        }
        field(38;"Unit List Price";Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Unit List Price';
            MinValue = 0;
        }
        field(39;"Duty Due %";Decimal)
        {
            Caption = 'Duty Due %';
            DecimalPlaces = 0:5;
            MaxValue = 100;
            MinValue = 0;
        }
        field(40;"Duty Code";Code[10])
        {
            Caption = 'Duty Code';
        }
        field(41;"Gross Weight";Decimal)
        {
            Caption = 'Gross Weight';
            DecimalPlaces = 0:5;
            MinValue = 0;
        }
        field(42;"Net Weight";Decimal)
        {
            Caption = 'Net Weight';
            DecimalPlaces = 0:5;
            MinValue = 0;
        }
        field(43;"Units per Parcel";Decimal)
        {
            Caption = 'Units per Parcel';
            DecimalPlaces = 0:5;
            MinValue = 0;
        }
        field(44;"Unit Volume";Decimal)
        {
            Caption = 'Unit Volume';
            DecimalPlaces = 0:5;
            MinValue = 0;
        }
        field(45;Durability;Code[10])
        {
            Caption = 'Durability';
        }
        field(46;"Freight Type";Code[10])
        {
            Caption = 'Freight Type';
        }
        field(47;"Tariff No.";Code[20])
        {
            Caption = 'Tariff No.';
            TableRelation = "Tariff Number";
        }
        field(48;"Duty Unit Conversion";Decimal)
        {
            Caption = 'Duty Unit Conversion';
            DecimalPlaces = 0:5;
        }
        field(49;"Country/Region Purchased Code";Code[10])
        {
            Caption = 'Country/Region Purchased Code';
            TableRelation = Country/Region;
        }
        field(50;"Budget Quantity";Decimal)
        {
            Caption = 'Budget Quantity';
            DecimalPlaces = 0:5;
        }
        field(51;"Budgeted Amount";Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Budgeted Amount';
        }
        field(52;"Budget Profit";Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Budget Profit';
        }
        field(53;Comment;Boolean)
        {
            CalcFormula = Exist("Comment Line" WHERE (Table Name=CONST(Item),
                                                      No.=FIELD(No.)));
            Caption = 'Comment';
            Editable = false;
            FieldClass = FlowField;
        }
        field(54;Blocked;Boolean)
        {
            Caption = 'Blocked';
        }
        field(55;"Cost is Posted to G/L";Boolean)
        {
            CalcFormula = -Exist("Post Value Entry to G/L" WHERE (Item No.=FIELD(No.)));
            Caption = 'Cost is Posted to G/L';
            Editable = false;
            FieldClass = FlowField;
        }
        field(62;"Last Date Modified";Date)
        {
            Caption = 'Last Date Modified';
            Editable = false;
        }
        field(64;"Date Filter";Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(65;"Global Dimension 1 Filter";Code[20])
        {
            CaptionClass = '1,3,1';
            Caption = 'Global Dimension 1 Filter';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
        }
        field(66;"Global Dimension 2 Filter";Code[20])
        {
            CaptionClass = '1,3,2';
            Caption = 'Global Dimension 2 Filter';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
        }
        field(67;"Location Filter";Code[10])
        {
            Caption = 'Location Filter';
            FieldClass = FlowFilter;
            TableRelation = Location;
        }
        field(68;Inventory;Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE (Item No.=FIELD(No.),
                                                                  Global Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                  Global Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                  Location Code=FIELD(Location Filter),
                                                                  Drop Shipment=FIELD(Drop Shipment Filter),
                                                                  Variant Code=FIELD(Variant Filter),
                                                                  Lot No.=FIELD(Lot No. Filter),
                                                                  Serial No.=FIELD(Serial No. Filter)));
            Caption = 'Inventory';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(69;"Net Invoiced Qty.";Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry"."Invoiced Quantity" WHERE (Item No.=FIELD(No.),
                                                                             Global Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                             Global Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                             Location Code=FIELD(Location Filter),
                                                                             Drop Shipment=FIELD(Drop Shipment Filter),
                                                                             Variant Code=FIELD(Variant Filter),
                                                                             Lot No.=FIELD(Lot No. Filter),
                                                                             Serial No.=FIELD(Serial No. Filter)));
            Caption = 'Net Invoiced Qty.';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(70;"Net Change";Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE (Item No.=FIELD(No.),
                                                                  Global Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                  Global Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                  Location Code=FIELD(Location Filter),
                                                                  Drop Shipment=FIELD(Drop Shipment Filter),
                                                                  Posting Date=FIELD(Date Filter),
                                                                  Variant Code=FIELD(Variant Filter),
                                                                  Lot No.=FIELD(Lot No. Filter),
                                                                  Serial No.=FIELD(Serial No. Filter)));
            Caption = 'Net Change';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(71;"Purchases (Qty.)";Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry"."Invoiced Quantity" WHERE (Entry Type=CONST(Purchase),
                                                                             Item No.=FIELD(No.),
                                                                             Global Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                             Global Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                             Location Code=FIELD(Location Filter),
                                                                             Drop Shipment=FIELD(Drop Shipment Filter),
                                                                             Variant Code=FIELD(Variant Filter),
                                                                             Posting Date=FIELD(Date Filter),
                                                                             Lot No.=FIELD(Lot No. Filter),
                                                                             Serial No.=FIELD(Serial No. Filter)));
            Caption = 'Purchases (Qty.)';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(72;"Sales (Qty.)";Decimal)
        {
            CalcFormula = -Sum("Value Entry"."Invoiced Quantity" WHERE (Item Ledger Entry Type=CONST(Sale),
                                                                        Item No.=FIELD(No.),
                                                                        Global Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                        Global Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                        Location Code=FIELD(Location Filter),
                                                                        Drop Shipment=FIELD(Drop Shipment Filter),
                                                                        Variant Code=FIELD(Variant Filter),
                                                                        Posting Date=FIELD(Date Filter)));
            Caption = 'Sales (Qty.)';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(73;"Positive Adjmt. (Qty.)";Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry"."Invoiced Quantity" WHERE (Entry Type=CONST(Positive Adjmt.),
                                                                             Item No.=FIELD(No.),
                                                                             Global Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                             Global Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                             Location Code=FIELD(Location Filter),
                                                                             Drop Shipment=FIELD(Drop Shipment Filter),
                                                                             Variant Code=FIELD(Variant Filter),
                                                                             Posting Date=FIELD(Date Filter),
                                                                             Lot No.=FIELD(Lot No. Filter),
                                                                             Serial No.=FIELD(Serial No. Filter)));
            Caption = 'Positive Adjmt. (Qty.)';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(74;"Negative Adjmt. (Qty.)";Decimal)
        {
            CalcFormula = -Sum("Item Ledger Entry"."Invoiced Quantity" WHERE (Entry Type=CONST(Negative Adjmt.),
                                                                              Item No.=FIELD(No.),
                                                                              Global Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                              Global Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                              Location Code=FIELD(Location Filter),
                                                                              Drop Shipment=FIELD(Drop Shipment Filter),
                                                                              Variant Code=FIELD(Variant Filter),
                                                                              Posting Date=FIELD(Date Filter),
                                                                              Lot No.=FIELD(Lot No. Filter),
                                                                              Serial No.=FIELD(Serial No. Filter)));
            Caption = 'Negative Adjmt. (Qty.)';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(77;"Purchases (LCY)";Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Value Entry"."Purchase Amount (Actual)" WHERE (Item Ledger Entry Type=CONST(Purchase),
                                                                              Item No.=FIELD(No.),
                                                                              Global Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                              Global Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                              Location Code=FIELD(Location Filter),
                                                                              Drop Shipment=FIELD(Drop Shipment Filter),
                                                                              Variant Code=FIELD(Variant Filter),
                                                                              Posting Date=FIELD(Date Filter)));
            Caption = 'Purchases (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(78;"Sales (LCY)";Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Value Entry"."Sales Amount (Actual)" WHERE (Item Ledger Entry Type=CONST(Sale),
                                                                           Item No.=FIELD(No.),
                                                                           Global Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                           Global Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                           Location Code=FIELD(Location Filter),
                                                                           Drop Shipment=FIELD(Drop Shipment Filter),
                                                                           Variant Code=FIELD(Variant Filter),
                                                                           Posting Date=FIELD(Date Filter)));
            Caption = 'Sales (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(79;"Positive Adjmt. (LCY)";Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Value Entry"."Cost Amount (Actual)" WHERE (Item Ledger Entry Type=CONST(Positive Adjmt.),
                                                                          Item No.=FIELD(No.),
                                                                          Global Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                          Global Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                          Location Code=FIELD(Location Filter),
                                                                          Drop Shipment=FIELD(Drop Shipment Filter),
                                                                          Variant Code=FIELD(Variant Filter),
                                                                          Posting Date=FIELD(Date Filter)));
            Caption = 'Positive Adjmt. (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(80;"Negative Adjmt. (LCY)";Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Value Entry"."Cost Amount (Actual)" WHERE (Item Ledger Entry Type=CONST(Negative Adjmt.),
                                                                          Item No.=FIELD(No.),
                                                                          Global Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                          Global Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                          Location Code=FIELD(Location Filter),
                                                                          Drop Shipment=FIELD(Drop Shipment Filter),
                                                                          Variant Code=FIELD(Variant Filter),
                                                                          Posting Date=FIELD(Date Filter)));
            Caption = 'Negative Adjmt. (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(83;"COGS (LCY)";Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = -Sum("Value Entry"."Cost Amount (Actual)" WHERE (Item Ledger Entry Type=CONST(Sale),
                                                                           Item No.=FIELD(No.),
                                                                           Global Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                           Global Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                           Location Code=FIELD(Location Filter),
                                                                           Drop Shipment=FIELD(Drop Shipment Filter),
                                                                           Variant Code=FIELD(Variant Filter),
                                                                           Posting Date=FIELD(Date Filter)));
            Caption = 'COGS (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(84;"Qty. on Purch. Order";Decimal)
        {
            CalcFormula = Sum("Purchase Line"."Outstanding Qty. (Base)" WHERE (Document Type=CONST(Order),
                                                                               Type=CONST(Item),
                                                                               No.=FIELD(No.),
                                                                               Shortcut Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                               Shortcut Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                               Location Code=FIELD(Location Filter),
                                                                               Drop Shipment=FIELD(Drop Shipment Filter),
                                                                               Variant Code=FIELD(Variant Filter),
                                                                               Expected Receipt Date=FIELD(Date Filter)));
            Caption = 'Qty. on Purch. Order';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(85;"Qty. on Sales Order";Decimal)
        {
            CalcFormula = Sum("Sales Line"."Outstanding Qty. (Base)" WHERE (Document Type=CONST(Order),
                                                                            Type=CONST(Item),
                                                                            No.=FIELD(No.),
                                                                            Shortcut Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                            Shortcut Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                            Location Code=FIELD(Location Filter),
                                                                            Drop Shipment=FIELD(Drop Shipment Filter),
                                                                            Variant Code=FIELD(Variant Filter),
                                                                            Shipment Date=FIELD(Date Filter)));
            Caption = 'Qty. on Sales Order';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(87;"Price Includes VAT";Boolean)
        {
            Caption = 'Price Includes VAT';

            trigger OnValidate()
            var
                VATPostingSetup: Record "325";
                SalesSetup: Record "311";
            begin
                IF "Price Includes VAT" THEN BEGIN
                  SalesSetup.GET;
                  IF SalesSetup."VAT Bus. Posting Gr. (Price)" <> '' THEN
                    "VAT Bus. Posting Gr. (Price)" := SalesSetup."VAT Bus. Posting Gr. (Price)";
                  VATPostingSetup.GET("VAT Bus. Posting Gr. (Price)","VAT Prod. Posting Group");
                END;
                VALIDATE("Price/Profit Calculation");
            end;
        }
        field(89;"Drop Shipment Filter";Boolean)
        {
            Caption = 'Drop Shipment Filter';
            FieldClass = FlowFilter;
        }
        field(90;"VAT Bus. Posting Gr. (Price)";Code[10])
        {
            Caption = 'VAT Bus. Posting Gr. (Price)';
            TableRelation = "VAT Business Posting Group";

            trigger OnValidate()
            begin
                VALIDATE("Price/Profit Calculation");
            end;
        }
        field(91;"Gen. Prod. Posting Group";Code[10])
        {
            Caption = 'Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group";

            trigger OnValidate()
            begin
                IF xRec."Gen. Prod. Posting Group" <> "Gen. Prod. Posting Group" THEN BEGIN
                  IF CurrFieldNo <> 0 THEN
                    IF ProdOrderExist THEN
                      IF NOT CONFIRM(
                           Text024 +
                           Text022,FALSE,
                           FIELDCAPTION("Gen. Prod. Posting Group"))
                      THEN BEGIN
                        "Gen. Prod. Posting Group" := xRec."Gen. Prod. Posting Group";
                        EXIT;
                      END;

                  IF GenProdPostingGrp.ValidateVatProdPostingGroup(GenProdPostingGrp,"Gen. Prod. Posting Group") THEN
                    VALIDATE("VAT Prod. Posting Group",GenProdPostingGrp."Def. VAT Prod. Posting Group");
                END;

                VALIDATE("Price/Profit Calculation");
            end;
        }
        field(92;Picture;BLOB)
        {
            Caption = 'Picture';
            SubType = Bitmap;
        }
        field(93;"Transferred (Qty.)";Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry"."Invoiced Quantity" WHERE (Entry Type=CONST(Transfer),
                                                                             Item No.=FIELD(No.),
                                                                             Global Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                             Global Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                             Location Code=FIELD(Location Filter),
                                                                             Drop Shipment=FIELD(Drop Shipment Filter),
                                                                             Variant Code=FIELD(Variant Filter),
                                                                             Posting Date=FIELD(Date Filter),
                                                                             Lot No.=FIELD(Lot No. Filter),
                                                                             Serial No.=FIELD(Serial No. Filter)));
            Caption = 'Transferred (Qty.)';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(94;"Transferred (LCY)";Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Value Entry"."Sales Amount (Actual)" WHERE (Item Ledger Entry Type=CONST(Transfer),
                                                                           Item No.=FIELD(No.),
                                                                           Global Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                           Global Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                           Location Code=FIELD(Location Filter),
                                                                           Drop Shipment=FIELD(Drop Shipment Filter),
                                                                           Variant Code=FIELD(Variant Filter),
                                                                           Posting Date=FIELD(Date Filter)));
            Caption = 'Transferred (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(95;"Country/Region of Origin Code";Code[10])
        {
            Caption = 'Country/Region of Origin Code';
            TableRelation = Country/Region;
        }
        field(96;"Automatic Ext. Texts";Boolean)
        {
            Caption = 'Automatic Ext. Texts';
        }
        field(97;"No. Series";Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(98;"Tax Group Code";Code[10])
        {
            Caption = 'Tax Group Code';
            TableRelation = "Tax Group";
        }
        field(99;"VAT Prod. Posting Group";Code[10])
        {
            Caption = 'VAT Prod. Posting Group';
            TableRelation = "VAT Product Posting Group";

            trigger OnValidate()
            begin
                VALIDATE("Price/Profit Calculation");
            end;
        }
        field(100;Reserve;Option)
        {
            Caption = 'Reserve';
            InitValue = Optional;
            OptionCaption = 'Never,Optional,Always';
            OptionMembers = Never,Optional,Always;

            trigger OnValidate()
            begin
                IF Reserve <> Reserve::Never THEN
                  TESTFIELD(Type,Type::Inventory);
            end;
        }
        field(101;"Reserved Qty. on Inventory";Decimal)
        {
            CalcFormula = Sum("Reservation Entry"."Quantity (Base)" WHERE (Item No.=FIELD(No.),
                                                                           Source Type=CONST(32),
                                                                           Source Subtype=CONST(0),
                                                                           Reservation Status=CONST(Reservation),
                                                                           Serial No.=FIELD(Serial No. Filter),
                                                                           Lot No.=FIELD(Lot No. Filter),
                                                                           Location Code=FIELD(Location Filter),
                                                                           Variant Code=FIELD(Variant Filter)));
            Caption = 'Reserved Qty. on Inventory';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(102;"Reserved Qty. on Purch. Orders";Decimal)
        {
            CalcFormula = Sum("Reservation Entry"."Quantity (Base)" WHERE (Item No.=FIELD(No.),
                                                                           Source Type=CONST(39),
                                                                           Source Subtype=CONST(1),
                                                                           Reservation Status=CONST(Reservation),
                                                                           Location Code=FIELD(Location Filter),
                                                                           Variant Code=FIELD(Variant Filter),
                                                                           Expected Receipt Date=FIELD(Date Filter)));
            Caption = 'Reserved Qty. on Purch. Orders';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(103;"Reserved Qty. on Sales Orders";Decimal)
        {
            CalcFormula = -Sum("Reservation Entry"."Quantity (Base)" WHERE (Item No.=FIELD(No.),
                                                                            Source Type=CONST(37),
                                                                            Source Subtype=CONST(1),
                                                                            Reservation Status=CONST(Reservation),
                                                                            Location Code=FIELD(Location Filter),
                                                                            Variant Code=FIELD(Variant Filter),
                                                                            Shipment Date=FIELD(Date Filter)));
            Caption = 'Reserved Qty. on Sales Orders';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(105;"Global Dimension 1 Code";Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(1));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1,"Global Dimension 1 Code");
            end;
        }
        field(106;"Global Dimension 2 Code";Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(2));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2,"Global Dimension 2 Code");
            end;
        }
        field(107;"Res. Qty. on Outbound Transfer";Decimal)
        {
            CalcFormula = -Sum("Reservation Entry"."Quantity (Base)" WHERE (Item No.=FIELD(No.),
                                                                            Source Type=CONST(5741),
                                                                            Source Subtype=CONST(0),
                                                                            Reservation Status=CONST(Reservation),
                                                                            Location Code=FIELD(Location Filter),
                                                                            Variant Code=FIELD(Variant Filter),
                                                                            Shipment Date=FIELD(Date Filter)));
            Caption = 'Res. Qty. on Outbound Transfer';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(108;"Res. Qty. on Inbound Transfer";Decimal)
        {
            CalcFormula = Sum("Reservation Entry"."Quantity (Base)" WHERE (Item No.=FIELD(No.),
                                                                           Source Type=CONST(5741),
                                                                           Source Subtype=CONST(1),
                                                                           Reservation Status=CONST(Reservation),
                                                                           Location Code=FIELD(Location Filter),
                                                                           Variant Code=FIELD(Variant Filter),
                                                                           Expected Receipt Date=FIELD(Date Filter)));
            Caption = 'Res. Qty. on Inbound Transfer';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(120;"Stockout Warning";Option)
        {
            Caption = 'Stockout Warning';
            OptionCaption = 'Default,No,Yes';
            OptionMembers = Default,No,Yes;
        }
        field(121;"Prevent Negative Inventory";Option)
        {
            Caption = 'Prevent Negative Inventory';
            OptionCaption = 'Default,No,Yes';
            OptionMembers = Default,No,Yes;
        }
        field(200;"Cost of Open Production Orders";Decimal)
        {
            CalcFormula = Sum("Prod. Order Line"."Cost Amount" WHERE (Status=FILTER(Planned|Firm Planned|Released),
                                                                      Item No.=FIELD(No.)));
            Caption = 'Cost of Open Production Orders';
            FieldClass = FlowField;
        }
        field(521;"Application Wksh. User ID";Code[128])
        {
            Caption = 'Application Wksh. User ID';
        }
        field(910;"Assembly Policy";Option)
        {
            Caption = 'Assembly Policy';
            OptionCaption = 'Assemble-to-Stock,Assemble-to-Order';
            OptionMembers = "Assemble-to-Stock","Assemble-to-Order";

            trigger OnValidate()
            begin
                IF "Assembly Policy" = "Assembly Policy"::"Assemble-to-Order" THEN
                  TESTFIELD("Replenishment System","Replenishment System"::Assembly);
                IF Type = Type::Service THEN
                  TESTFIELD("Assembly Policy","Assembly Policy"::"Assemble-to-Stock");
            end;
        }
        field(929;"Res. Qty. on Assembly Order";Decimal)
        {
            CalcFormula = Sum("Reservation Entry"."Quantity (Base)" WHERE (Item No.=FIELD(No.),
                                                                           Source Type=CONST(900),
                                                                           Source Subtype=CONST(1),
                                                                           Reservation Status=CONST(Reservation),
                                                                           Location Code=FIELD(Location Filter),
                                                                           Variant Code=FIELD(Variant Filter),
                                                                           Expected Receipt Date=FIELD(Date Filter)));
            Caption = 'Res. Qty. on Assembly Order';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(930;"Res. Qty. on  Asm. Comp.";Decimal)
        {
            CalcFormula = -Sum("Reservation Entry"."Quantity (Base)" WHERE (Item No.=FIELD(No.),
                                                                            Source Type=CONST(901),
                                                                            Source Subtype=CONST(1),
                                                                            Reservation Status=CONST(Reservation),
                                                                            Location Code=FIELD(Location Filter),
                                                                            Variant Code=FIELD(Variant Filter),
                                                                            Expected Receipt Date=FIELD(Date Filter)));
            Caption = 'Res. Qty. on  Asm. Comp.';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(977;"Qty. on Assembly Order";Decimal)
        {
            CalcFormula = Sum("Assembly Header"."Remaining Quantity (Base)" WHERE (Document Type=CONST(Order),
                                                                                   Item No.=FIELD(No.),
                                                                                   Shortcut Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                   Shortcut Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                                   Location Code=FIELD(Location Filter),
                                                                                   Variant Code=FIELD(Variant Filter),
                                                                                   Due Date=FIELD(Date Filter)));
            Caption = 'Qty. on Assembly Order';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(978;"Qty. on Asm. Component";Decimal)
        {
            CalcFormula = Sum("Assembly Line"."Remaining Quantity (Base)" WHERE (Document Type=CONST(Order),
                                                                                 Type=CONST(Item),
                                                                                 No.=FIELD(No.),
                                                                                 Shortcut Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                 Shortcut Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                                 Location Code=FIELD(Location Filter),
                                                                                 Variant Code=FIELD(Variant Filter),
                                                                                 Due Date=FIELD(Date Filter)));
            Caption = 'Qty. on Asm. Component';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(1001;"Qty. on Job Order";Decimal)
        {
            CalcFormula = Sum("Job Planning Line"."Remaining Qty. (Base)" WHERE (Status=CONST(Order),
                                                                                 Type=CONST(Item),
                                                                                 No.=FIELD(No.),
                                                                                 Location Code=FIELD(Location Filter),
                                                                                 Variant Code=FIELD(Variant Filter),
                                                                                 Planning Date=FIELD(Date Filter)));
            Caption = 'Qty. on Job Order';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(1002;"Res. Qty. on Job Order";Decimal)
        {
            CalcFormula = -Sum("Reservation Entry"."Quantity (Base)" WHERE (Item No.=FIELD(No.),
                                                                            Source Type=CONST(1003),
                                                                            Source Subtype=CONST(2),
                                                                            Reservation Status=CONST(Reservation),
                                                                            Location Code=FIELD(Location Filter),
                                                                            Variant Code=FIELD(Variant Filter),
                                                                            Shipment Date=FIELD(Date Filter)));
            Caption = 'Res. Qty. on Job Order';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(5400;"Low-Level Code";Integer)
        {
            Caption = 'Low-Level Code';
            Editable = false;
        }
        field(5401;"Lot Size";Decimal)
        {
            Caption = 'Lot Size';
            DecimalPlaces = 0:5;
            MinValue = 0;
        }
        field(5402;"Serial Nos.";Code[10])
        {
            Caption = 'Serial Nos.';
            TableRelation = "No. Series";

            trigger OnValidate()
            begin
                IF "Serial Nos." <> '' THEN
                  TESTFIELD("Item Tracking Code");
            end;
        }
        field(5403;"Last Unit Cost Calc. Date";Date)
        {
            Caption = 'Last Unit Cost Calc. Date';
            Editable = false;
        }
        field(5404;"Rolled-up Material Cost";Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Rolled-up Material Cost';
            DecimalPlaces = 2:5;
            Editable = false;
        }
        field(5405;"Rolled-up Capacity Cost";Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Rolled-up Capacity Cost';
            DecimalPlaces = 2:5;
            Editable = false;
        }
        field(5407;"Scrap %";Decimal)
        {
            Caption = 'Scrap %';
            DecimalPlaces = 0:2;
            MaxValue = 100;
            MinValue = 0;
        }
        field(5409;"Inventory Value Zero";Boolean)
        {
            Caption = 'Inventory Value Zero';

            trigger OnValidate()
            begin
                CheckForProductionOutput("No.");
            end;
        }
        field(5410;"Discrete Order Quantity";Integer)
        {
            Caption = 'Discrete Order Quantity';
            MinValue = 0;
        }
        field(5411;"Minimum Order Quantity";Decimal)
        {
            Caption = 'Minimum Order Quantity';
            DecimalPlaces = 0:5;
            MinValue = 0;
        }
        field(5412;"Maximum Order Quantity";Decimal)
        {
            Caption = 'Maximum Order Quantity';
            DecimalPlaces = 0:5;
            MinValue = 0;
        }
        field(5413;"Safety Stock Quantity";Decimal)
        {
            Caption = 'Safety Stock Quantity';
            DecimalPlaces = 0:5;
            MinValue = 0;
        }
        field(5414;"Order Multiple";Decimal)
        {
            Caption = 'Order Multiple';
            DecimalPlaces = 0:5;
            MinValue = 0;
        }
        field(5415;"Safety Lead Time";DateFormula)
        {
            Caption = 'Safety Lead Time';
        }
        field(5417;"Flushing Method";Option)
        {
            Caption = 'Flushing Method';
            OptionCaption = 'Manual,Forward,Backward,Pick + Forward,Pick + Backward';
            OptionMembers = Manual,Forward,Backward,"Pick + Forward","Pick + Backward";
        }
        field(5419;"Replenishment System";Option)
        {
            Caption = 'Replenishment System';
            OptionCaption = 'Purchase,Prod. Order,,Assembly';
            OptionMembers = Purchase,"Prod. Order",,Assembly;

            trigger OnValidate()
            begin
                IF "Replenishment System" <> "Replenishment System"::Assembly THEN
                  TESTFIELD("Assembly Policy","Assembly Policy"::"Assemble-to-Stock");
                IF "Replenishment System" <> "Replenishment System"::Purchase THEN
                  TESTFIELD(Type,Type::Inventory);
            end;
        }
        field(5420;"Scheduled Receipt (Qty.)";Decimal)
        {
            CalcFormula = Sum("Prod. Order Line"."Remaining Qty. (Base)" WHERE (Status=FILTER(Firm Planned|Released),
                                                                                Item No.=FIELD(No.),
                                                                                Variant Code=FIELD(Variant Filter),
                                                                                Shortcut Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                Shortcut Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                                Location Code=FIELD(Location Filter),
                                                                                Due Date=FIELD(Date Filter)));
            Caption = 'Scheduled Receipt (Qty.)';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(5421;"Scheduled Need (Qty.)";Decimal)
        {
            CalcFormula = Sum("Prod. Order Component"."Remaining Qty. (Base)" WHERE (Status=FILTER(Planned..Released),
                                                                                     Item No.=FIELD(No.),
                                                                                     Variant Code=FIELD(Variant Filter),
                                                                                     Shortcut Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                     Shortcut Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                                     Location Code=FIELD(Location Filter),
                                                                                     Due Date=FIELD(Date Filter)));
            Caption = 'Scheduled Need (Qty.)';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(5422;"Rounding Precision";Decimal)
        {
            Caption = 'Rounding Precision';
            DecimalPlaces = 0:5;
            InitValue = 1;

            trigger OnValidate()
            begin
                IF "Rounding Precision" <= 0 THEN
                  FIELDERROR("Rounding Precision",Text027);
            end;
        }
        field(5423;"Bin Filter";Code[20])
        {
            Caption = 'Bin Filter';
            FieldClass = FlowFilter;
            TableRelation = Bin.Code WHERE (Location Code=FIELD(Location Filter));
        }
        field(5424;"Variant Filter";Code[10])
        {
            Caption = 'Variant Filter';
            FieldClass = FlowFilter;
            TableRelation = "Item Variant".Code WHERE (Item No.=FIELD(No.));
        }
        field(5425;"Sales Unit of Measure";Code[10])
        {
            Caption = 'Sales Unit of Measure';
            TableRelation = "Item Unit of Measure".Code WHERE (Item No.=FIELD(No.));
        }
        field(5426;"Purch. Unit of Measure";Code[10])
        {
            Caption = 'Purch. Unit of Measure';
            TableRelation = "Item Unit of Measure".Code WHERE (Item No.=FIELD(No.));
        }
        field(5428;"Time Bucket";DateFormula)
        {
            Caption = 'Time Bucket';

            trigger OnValidate()
            begin
                CalendarMgt.CheckDateFormulaPositive("Time Bucket");
            end;
        }
        field(5429;"Reserved Qty. on Prod. Order";Decimal)
        {
            CalcFormula = Sum("Reservation Entry"."Quantity (Base)" WHERE (Item No.=FIELD(No.),
                                                                           Source Type=CONST(5406),
                                                                           Source Subtype=FILTER(1..3),
                                                                           Reservation Status=CONST(Reservation),
                                                                           Location Code=FIELD(Location Filter),
                                                                           Variant Code=FIELD(Variant Filter),
                                                                           Expected Receipt Date=FIELD(Date Filter)));
            Caption = 'Reserved Qty. on Prod. Order';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(5430;"Res. Qty. on Prod. Order Comp.";Decimal)
        {
            CalcFormula = -Sum("Reservation Entry"."Quantity (Base)" WHERE (Item No.=FIELD(No.),
                                                                            Source Type=CONST(5407),
                                                                            Source Subtype=FILTER(1..3),
                                                                            Reservation Status=CONST(Reservation),
                                                                            Location Code=FIELD(Location Filter),
                                                                            Variant Code=FIELD(Variant Filter),
                                                                            Shipment Date=FIELD(Date Filter)));
            Caption = 'Res. Qty. on Prod. Order Comp.';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(5431;"Res. Qty. on Req. Line";Decimal)
        {
            CalcFormula = Sum("Reservation Entry"."Quantity (Base)" WHERE (Item No.=FIELD(No.),
                                                                           Source Type=CONST(246),
                                                                           Source Subtype=FILTER(0),
                                                                           Reservation Status=CONST(Reservation),
                                                                           Location Code=FIELD(Location Filter),
                                                                           Variant Code=FIELD(Variant Filter),
                                                                           Expected Receipt Date=FIELD(Date Filter)));
            Caption = 'Res. Qty. on Req. Line';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(5440;"Reordering Policy";Option)
        {
            Caption = 'Reordering Policy';
            OptionCaption = ' ,Fixed Reorder Qty.,Maximum Qty.,Order,Lot-for-Lot';
            OptionMembers = " ","Fixed Reorder Qty.","Maximum Qty.","Order","Lot-for-Lot";

            trigger OnValidate()
            begin
                "Include Inventory" :=
                  "Reordering Policy" IN ["Reordering Policy"::"Lot-for-Lot",
                                          "Reordering Policy"::"Maximum Qty.",
                                          "Reordering Policy"::"Fixed Reorder Qty."];

                IF "Reordering Policy" <> "Reordering Policy"::" " THEN
                  TESTFIELD(Type,Type::Inventory);
            end;
        }
        field(5441;"Include Inventory";Boolean)
        {
            Caption = 'Include Inventory';
        }
        field(5442;"Manufacturing Policy";Option)
        {
            Caption = 'Manufacturing Policy';
            OptionCaption = 'Make-to-Stock,Make-to-Order';
            OptionMembers = "Make-to-Stock","Make-to-Order";
        }
        field(5443;"Rescheduling Period";DateFormula)
        {
            Caption = 'Rescheduling Period';

            trigger OnValidate()
            begin
                CalendarMgt.CheckDateFormulaPositive("Rescheduling Period");
            end;
        }
        field(5444;"Lot Accumulation Period";DateFormula)
        {
            Caption = 'Lot Accumulation Period';

            trigger OnValidate()
            begin
                CalendarMgt.CheckDateFormulaPositive("Lot Accumulation Period");
            end;
        }
        field(5445;"Dampener Period";DateFormula)
        {
            Caption = 'Dampener Period';

            trigger OnValidate()
            begin
                CalendarMgt.CheckDateFormulaPositive("Dampener Period");
            end;
        }
        field(5446;"Dampener Quantity";Decimal)
        {
            Caption = 'Dampener Quantity';
            DecimalPlaces = 0:5;
            MinValue = 0;
        }
        field(5447;"Overflow Level";Decimal)
        {
            Caption = 'Overflow Level';
            DecimalPlaces = 0:5;
            MinValue = 0;
        }
        field(5700;"Stockkeeping Unit Exists";Boolean)
        {
            CalcFormula = Exist("Stockkeeping Unit" WHERE (Item No.=FIELD(No.)));
            Caption = 'Stockkeeping Unit Exists';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5701;"Manufacturer Code";Code[10])
        {
            Caption = 'Manufacturer Code';
            TableRelation = Manufacturer;
        }
        field(5702;"Item Category Code";Code[10])
        {
            Caption = 'Item Category Code';
            TableRelation = "Item Category";

            trigger OnValidate()
            begin
                IF "Item Category Code" <> xRec."Item Category Code" THEN BEGIN
                  IF ItemCategory.GET("Item Category Code") THEN BEGIN
                    IF "Gen. Prod. Posting Group" = '' THEN
                      VALIDATE("Gen. Prod. Posting Group",ItemCategory."Def. Gen. Prod. Posting Group");
                    IF ("VAT Prod. Posting Group" = '') OR
                       (GenProdPostingGrp.ValidateVatProdPostingGroup(GenProdPostingGrp,"Gen. Prod. Posting Group") AND
                        ("Gen. Prod. Posting Group" = ItemCategory."Def. Gen. Prod. Posting Group") AND
                        ("VAT Prod. Posting Group" = GenProdPostingGrp."Def. VAT Prod. Posting Group"))
                    THEN
                      VALIDATE("VAT Prod. Posting Group",ItemCategory."Def. VAT Prod. Posting Group");
                    IF "Inventory Posting Group" = '' THEN
                      VALIDATE("Inventory Posting Group",ItemCategory."Def. Inventory Posting Group");
                    IF "Tax Group Code" = '' THEN
                      VALIDATE("Tax Group Code",ItemCategory."Def. Tax Group Code");
                    VALIDATE("Costing Method",ItemCategory."Def. Costing Method");
                  END;

                  IF NOT ProductGrp.GET("Item Category Code","Product Group Code") THEN
                    VALIDATE("Product Group Code",'')
                  ELSE
                    VALIDATE("Product Group Code");
                END;
            end;
        }
        field(5703;"Created From Nonstock Item";Boolean)
        {
            Caption = 'Created From Nonstock Item';
            Editable = false;
        }
        field(5704;"Product Group Code";Code[10])
        {
            Caption = 'Product Group Code';
            TableRelation = "Product Group".Code WHERE (Item Category Code=FIELD(Item Category Code));
        }
        field(5706;"Substitutes Exist";Boolean)
        {
            CalcFormula = Exist("Item Substitution" WHERE (Type=CONST(Item),
                                                           No.=FIELD(No.)));
            Caption = 'Substitutes Exist';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5707;"Qty. in Transit";Decimal)
        {
            CalcFormula = Sum("Transfer Line"."Qty. in Transit (Base)" WHERE (Derived From Line No.=CONST(0),
                                                                              Item No.=FIELD(No.),
                                                                              Transfer-to Code=FIELD(Location Filter),
                                                                              Variant Code=FIELD(Variant Filter),
                                                                              Shortcut Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                              Shortcut Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                              Receipt Date=FIELD(Date Filter)));
            Caption = 'Qty. in Transit';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(5708;"Trans. Ord. Receipt (Qty.)";Decimal)
        {
            CalcFormula = Sum("Transfer Line"."Outstanding Qty. (Base)" WHERE (Derived From Line No.=CONST(0),
                                                                               Item No.=FIELD(No.),
                                                                               Transfer-to Code=FIELD(Location Filter),
                                                                               Variant Code=FIELD(Variant Filter),
                                                                               Shortcut Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                               Shortcut Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                               Receipt Date=FIELD(Date Filter)));
            Caption = 'Trans. Ord. Receipt (Qty.)';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(5709;"Trans. Ord. Shipment (Qty.)";Decimal)
        {
            CalcFormula = Sum("Transfer Line"."Outstanding Qty. (Base)" WHERE (Derived From Line No.=CONST(0),
                                                                               Item No.=FIELD(No.),
                                                                               Transfer-from Code=FIELD(Location Filter),
                                                                               Variant Code=FIELD(Variant Filter),
                                                                               Shortcut Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                               Shortcut Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                               Shipment Date=FIELD(Date Filter)));
            Caption = 'Trans. Ord. Shipment (Qty.)';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(5776;"Qty. Assigned to ship";Decimal)
        {
            CalcFormula = Sum("Warehouse Shipment Line"."Qty. Outstanding (Base)" WHERE (Item No.=FIELD(No.),
                                                                                         Location Code=FIELD(Location Filter),
                                                                                         Variant Code=FIELD(Variant Filter),
                                                                                         Due Date=FIELD(Date Filter)));
            Caption = 'Qty. Assigned to ship';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(5777;"Qty. Picked";Decimal)
        {
            CalcFormula = Sum("Warehouse Shipment Line"."Qty. Picked (Base)" WHERE (Item No.=FIELD(No.),
                                                                                    Location Code=FIELD(Location Filter),
                                                                                    Variant Code=FIELD(Variant Filter),
                                                                                    Due Date=FIELD(Date Filter)));
            Caption = 'Qty. Picked';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(5900;"Service Item Group";Code[10])
        {
            Caption = 'Service Item Group';
            TableRelation = "Service Item Group".Code;

            trigger OnValidate()
            var
                ResSkill: Record "5956";
            begin
                IF xRec."Service Item Group" <> "Service Item Group" THEN BEGIN
                  IF NOT ResSkillMgt.ChangeRelationWithGroup(
                       ResSkill.Type::Item,
                       "No.",
                       ResSkill.Type::"Service Item Group",
                       "Service Item Group",
                       xRec."Service Item Group")
                  THEN
                    "Service Item Group" := xRec."Service Item Group";
                END ELSE
                  ResSkillMgt.RevalidateRelation(
                    ResSkill.Type::Item,
                    "No.",
                    ResSkill.Type::"Service Item Group",
                    "Service Item Group")
            end;
        }
        field(5901;"Qty. on Service Order";Decimal)
        {
            CalcFormula = Sum("Service Line"."Outstanding Qty. (Base)" WHERE (Document Type=CONST(Order),
                                                                              Type=CONST(Item),
                                                                              No.=FIELD(No.),
                                                                              Shortcut Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                              Shortcut Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                              Location Code=FIELD(Location Filter),
                                                                              Variant Code=FIELD(Variant Filter),
                                                                              Needed by Date=FIELD(Date Filter)));
            Caption = 'Qty. on Service Order';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(5902;"Res. Qty. on Service Orders";Decimal)
        {
            CalcFormula = -Sum("Reservation Entry"."Quantity (Base)" WHERE (Item No.=FIELD(No.),
                                                                            Source Type=CONST(5902),
                                                                            Source Subtype=CONST(1),
                                                                            Reservation Status=CONST(Reservation),
                                                                            Location Code=FIELD(Location Filter),
                                                                            Variant Code=FIELD(Variant Filter),
                                                                            Shipment Date=FIELD(Date Filter)));
            Caption = 'Res. Qty. on Service Orders';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(6500;"Item Tracking Code";Code[10])
        {
            Caption = 'Item Tracking Code';
            TableRelation = "Item Tracking Code";

            trigger OnValidate()
            begin
                IF "Item Tracking Code" <> '' THEN
                  TESTFIELD(Type,Type::Inventory);
                IF "Item Tracking Code" = xRec."Item Tracking Code" THEN
                  EXIT;

                IF NOT ItemTrackingCode.GET("Item Tracking Code") THEN
                  CLEAR(ItemTrackingCode);

                IF NOT ItemTrackingCode2.GET(xRec."Item Tracking Code") THEN
                  CLEAR(ItemTrackingCode2);

                IF (ItemTrackingCode."SN Specific Tracking" <> ItemTrackingCode2."SN Specific Tracking") OR
                   (ItemTrackingCode."Lot Specific Tracking" <> ItemTrackingCode2."Lot Specific Tracking")
                THEN
                  TestNoEntriesExist(FIELDCAPTION("Item Tracking Code"));

                IF "Costing Method" = "Costing Method"::Specific THEN BEGIN
                  TestNoEntriesExist(FIELDCAPTION("Item Tracking Code"));

                  TESTFIELD("Item Tracking Code");

                  ItemTrackingCode.GET("Item Tracking Code");
                  IF NOT ItemTrackingCode."SN Specific Tracking" THEN
                    ERROR(
                      Text018,
                      ItemTrackingCode.FIELDCAPTION("SN Specific Tracking"),
                      FORMAT(TRUE),ItemTrackingCode.TABLECAPTION,ItemTrackingCode.Code,
                      FIELDCAPTION("Costing Method"),"Costing Method");
                END;
            end;
        }
        field(6501;"Lot Nos.";Code[10])
        {
            Caption = 'Lot Nos.';
            TableRelation = "No. Series";

            trigger OnValidate()
            begin
                IF "Lot Nos." <> '' THEN
                  TESTFIELD("Item Tracking Code");
            end;
        }
        field(6502;"Expiration Calculation";DateFormula)
        {
            Caption = 'Expiration Calculation';
        }
        field(6503;"Lot No. Filter";Code[20])
        {
            Caption = 'Lot No. Filter';
            FieldClass = FlowFilter;
        }
        field(6504;"Serial No. Filter";Code[20])
        {
            Caption = 'Serial No. Filter';
            FieldClass = FlowFilter;
        }
        field(7171;"No. of Substitutes";Integer)
        {
            CalcFormula = Count("Item Substitution" WHERE (Type=CONST(Item),
                                                           No.=FIELD(No.)));
            Caption = 'No. of Substitutes';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7301;"Special Equipment Code";Code[10])
        {
            Caption = 'Special Equipment Code';
            TableRelation = "Special Equipment";
        }
        field(7302;"Put-away Template Code";Code[10])
        {
            Caption = 'Put-away Template Code';
            TableRelation = "Put-away Template Header";
        }
        field(7307;"Put-away Unit of Measure Code";Code[10])
        {
            Caption = 'Put-away Unit of Measure Code';
            TableRelation = "Item Unit of Measure".Code WHERE (Item No.=FIELD(No.));
        }
        field(7380;"Phys Invt Counting Period Code";Code[10])
        {
            Caption = 'Phys Invt Counting Period Code';
            TableRelation = "Phys. Invt. Counting Period";

            trigger OnValidate()
            var
                PhysInvtCountPeriod: Record "7381";
                PhysInvtCountPeriodMgt: Codeunit "7380";
            begin
                IF "Phys Invt Counting Period Code" <> '' THEN BEGIN
                  PhysInvtCountPeriod.GET("Phys Invt Counting Period Code");
                  PhysInvtCountPeriod.TESTFIELD("Count Frequency per Year");
                  IF "Phys Invt Counting Period Code" <> xRec."Phys Invt Counting Period Code" THEN BEGIN
                    IF CurrFieldNo <> 0 THEN
                      IF NOT CONFIRM(
                           Text7380,
                           FALSE,
                           FIELDCAPTION("Phys Invt Counting Period Code"),
                           FIELDCAPTION("Next Counting Period"))
                      THEN
                        ERROR(Text7381);

                    "Next Counting Period" :=
                      PhysInvtCountPeriodMgt.CalcPeriod(
                        "Last Counting Period Update",'',PhysInvtCountPeriod."Count Frequency per Year",
                        ("Last Counting Period Update" = 0D) OR
                        ("Phys Invt Counting Period Code" <> xRec."Phys Invt Counting Period Code"));
                  END;
                END ELSE BEGIN
                  IF CurrFieldNo <> 0 THEN
                    IF NOT CONFIRM(Text003,FALSE,FIELDCAPTION("Phys Invt Counting Period Code")) THEN
                      ERROR(Text7381);
                  "Next Counting Period" := '';
                  "Last Counting Period Update" := 0D;
                END;
            end;
        }
        field(7381;"Last Counting Period Update";Date)
        {
            Caption = 'Last Counting Period Update';
            Editable = false;
        }
        field(7382;"Next Counting Period";Text[250])
        {
            Caption = 'Next Counting Period';
            Editable = false;
        }
        field(7383;"Last Phys. Invt. Date";Date)
        {
            CalcFormula = Max("Phys. Inventory Ledger Entry"."Posting Date" WHERE (Item No.=FIELD(No.),
                                                                                   Phys Invt Counting Period Type=FILTER(' '|Item)));
            Caption = 'Last Phys. Invt. Date';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7384;"Use Cross-Docking";Boolean)
        {
            Caption = 'Use Cross-Docking';
            InitValue = true;
        }
        field(7700;"Identifier Code";Code[20])
        {
            CalcFormula = Lookup("Item Identifier".Code WHERE (Item No.=FIELD(No.)));
            Caption = 'Identifier Code';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50000;Clinic;Boolean)
        {
            Description = 'For Patient System';
        }
        field(50001;Retail;Boolean)
        {
            Description = 'For Patient System';
        }
        field(50002;"Clinic Item Category Code";Code[10])
        {
            Description = 'For Patient System';
            TableRelation = "Item Category" WHERE (Clinic=CONST(Yes));
        }
        field(50003;"Clinic Product Category Code";Code[10])
        {
            Description = 'For Patient System';
            TableRelation = "Product Group".Code WHERE (Item Category Code=FIELD(Clinic Item Category Code));
        }
        field(50004;Usage;Text[100])
        {
            Description = 'For Patient System';
        }
        field(50005;"English Description";Text[100])
        {
            CalcFormula = Lookup("Item Translation".Description WHERE (Item No.=FIELD(No.),
                                                                       Language Code=CONST(ENG)));
            FieldClass = FlowField;
        }
        field(99000750;"Routing No.";Code[20])
        {
            Caption = 'Routing No.';
            TableRelation = "Routing Header";

            trigger OnValidate()
            begin
                IF "Routing No." <> '' THEN
                  TESTFIELD(Type,Type::Inventory);

                PlanningAssignment.RoutingReplace(Rec,xRec."Routing No.");

                IF "Routing No." <> xRec."Routing No." THEN
                  ItemCostMgt.UpdateUnitCost(Rec,'','',0,0,FALSE,FALSE,TRUE,FIELDNO("Routing No."));
            end;
        }
        field(99000751;"Production BOM No.";Code[20])
        {
            Caption = 'Production BOM No.';
            TableRelation = "Production BOM Header";

            trigger OnValidate()
            var
                MfgSetup: Record "99000765";
                ProdBOMHeader: Record "99000771";
                ItemUnitOfMeasure: Record "5404";
                CalcLowLevel: Codeunit "99000793";
            begin
                IF "Production BOM No." <> '' THEN
                  TESTFIELD(Type,Type::Inventory);

                PlanningAssignment.BomReplace(Rec,xRec."Production BOM No.");

                IF "Production BOM No." <> xRec."Production BOM No." THEN
                  ItemCostMgt.UpdateUnitCost(Rec,'','',0,0,FALSE,FALSE,TRUE,FIELDNO("Production BOM No."));

                IF ("Production BOM No." <> '') AND ("Production BOM No." <> xRec."Production BOM No.") THEN BEGIN
                  ProdBOMHeader.GET("Production BOM No.");
                  ItemUnitOfMeasure.GET("No.",ProdBOMHeader."Unit of Measure Code");
                  IF ProdBOMHeader.Status = ProdBOMHeader.Status::Certified THEN BEGIN
                    MfgSetup.GET;
                    IF MfgSetup."Dynamic Low-Level Code" THEN
                      CalcLowLevel.RUN(Rec);
                  END;
                END;
            end;
        }
        field(99000752;"Single-Level Material Cost";Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Single-Level Material Cost';
            Editable = false;
        }
        field(99000753;"Single-Level Capacity Cost";Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Single-Level Capacity Cost';
            Editable = false;
        }
        field(99000754;"Single-Level Subcontrd. Cost";Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Single-Level Subcontrd. Cost';
            Editable = false;
        }
        field(99000755;"Single-Level Cap. Ovhd Cost";Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Single-Level Cap. Ovhd Cost';
            Editable = false;
        }
        field(99000756;"Single-Level Mfg. Ovhd Cost";Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Single-Level Mfg. Ovhd Cost';
            Editable = false;
        }
        field(99000757;"Overhead Rate";Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Overhead Rate';
        }
        field(99000758;"Rolled-up Subcontracted Cost";Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Rolled-up Subcontracted Cost';
            Editable = false;
        }
        field(99000759;"Rolled-up Mfg. Ovhd Cost";Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Rolled-up Mfg. Ovhd Cost';
            Editable = false;
        }
        field(99000760;"Rolled-up Cap. Overhead Cost";Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Rolled-up Cap. Overhead Cost';
            Editable = false;
        }
        field(99000761;"Planning Issues (Qty.)";Decimal)
        {
            CalcFormula = Sum("Planning Component"."Expected Quantity (Base)" WHERE (Item No.=FIELD(No.),
                                                                                     Due Date=FIELD(Date Filter),
                                                                                     Location Code=FIELD(Location Filter),
                                                                                     Variant Code=FIELD(Variant Filter),
                                                                                     Shortcut Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                     Shortcut Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                                     Planning Line Origin=CONST(" ")));
            Caption = 'Planning Issues (Qty.)';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(99000762;"Planning Receipt (Qty.)";Decimal)
        {
            CalcFormula = Sum("Requisition Line"."Quantity (Base)" WHERE (Type=CONST(Item),
                                                                          No.=FIELD(No.),
                                                                          Due Date=FIELD(Date Filter),
                                                                          Location Code=FIELD(Location Filter),
                                                                          Variant Code=FIELD(Variant Filter),
                                                                          Shortcut Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                          Shortcut Dimension 2 Code=FIELD(Global Dimension 2 Filter)));
            Caption = 'Planning Receipt (Qty.)';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(99000765;"Planned Order Receipt (Qty.)";Decimal)
        {
            CalcFormula = Sum("Prod. Order Line"."Remaining Qty. (Base)" WHERE (Status=CONST(Planned),
                                                                                Item No.=FIELD(No.),
                                                                                Variant Code=FIELD(Variant Filter),
                                                                                Shortcut Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                Shortcut Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                                Location Code=FIELD(Location Filter),
                                                                                Due Date=FIELD(Date Filter)));
            Caption = 'Planned Order Receipt (Qty.)';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(99000766;"FP Order Receipt (Qty.)";Decimal)
        {
            CalcFormula = Sum("Prod. Order Line"."Remaining Qty. (Base)" WHERE (Status=CONST(Firm Planned),
                                                                                Item No.=FIELD(No.),
                                                                                Variant Code=FIELD(Variant Filter),
                                                                                Shortcut Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                Shortcut Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                                Location Code=FIELD(Location Filter),
                                                                                Due Date=FIELD(Date Filter)));
            Caption = 'FP Order Receipt (Qty.)';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(99000767;"Rel. Order Receipt (Qty.)";Decimal)
        {
            CalcFormula = Sum("Prod. Order Line"."Remaining Qty. (Base)" WHERE (Status=CONST(Released),
                                                                                Item No.=FIELD(No.),
                                                                                Variant Code=FIELD(Variant Filter),
                                                                                Shortcut Dimension 1 Code=FIELD(Global Dimension 2 Filter),
                                                                                Shortcut Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                                Location Code=FIELD(Location Filter),
                                                                                Due Date=FIELD(Date Filter)));
            Caption = 'Rel. Order Receipt (Qty.)';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(99000768;"Planning Release (Qty.)";Decimal)
        {
            CalcFormula = Sum("Requisition Line"."Quantity (Base)" WHERE (Type=CONST(Item),
                                                                          No.=FIELD(No.),
                                                                          Starting Date=FIELD(Date Filter),
                                                                          Location Code=FIELD(Location Filter),
                                                                          Variant Code=FIELD(Variant Filter),
                                                                          Shortcut Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                          Shortcut Dimension 2 Code=FIELD(Global Dimension 2 Filter)));
            Caption = 'Planning Release (Qty.)';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(99000769;"Planned Order Release (Qty.)";Decimal)
        {
            CalcFormula = Sum("Prod. Order Line"."Remaining Qty. (Base)" WHERE (Status=CONST(Planned),
                                                                                Item No.=FIELD(No.),
                                                                                Variant Code=FIELD(Variant Filter),
                                                                                Shortcut Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                Shortcut Dimension 2 Code=FIELD(Global Dimension 1 Filter),
                                                                                Location Code=FIELD(Location Filter),
                                                                                Starting Date=FIELD(Date Filter)));
            Caption = 'Planned Order Release (Qty.)';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(99000770;"Purch. Req. Receipt (Qty.)";Decimal)
        {
            CalcFormula = Sum("Requisition Line"."Quantity (Base)" WHERE (Type=CONST(Item),
                                                                          No.=FIELD(No.),
                                                                          Variant Code=FIELD(Variant Filter),
                                                                          Location Code=FIELD(Location Filter),
                                                                          Shortcut Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                          Shortcut Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                          Due Date=FIELD(Date Filter),
                                                                          Planning Line Origin=CONST(" ")));
            Caption = 'Purch. Req. Receipt (Qty.)';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(99000771;"Purch. Req. Release (Qty.)";Decimal)
        {
            CalcFormula = Sum("Requisition Line"."Quantity (Base)" WHERE (Type=CONST(Item),
                                                                          No.=FIELD(No.),
                                                                          Location Code=FIELD(Location Filter),
                                                                          Variant Code=FIELD(Variant Filter),
                                                                          Shortcut Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                          Shortcut Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                          Order Date=FIELD(Date Filter)));
            Caption = 'Purch. Req. Release (Qty.)';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(99000773;"Order Tracking Policy";Option)
        {
            Caption = 'Order Tracking Policy';
            OptionCaption = 'None,Tracking Only,Tracking & Action Msg.';
            OptionMembers = "None","Tracking Only","Tracking & Action Msg.";

            trigger OnValidate()
            var
                ReservEntry: Record "337";
                ActionMessageEntry: Record "99000849";
                TempReservationEntry: Record "337" temporary;
            begin
                IF "Order Tracking Policy" <> "Order Tracking Policy"::None THEN
                  TESTFIELD(Type,Type::Inventory);
                IF xRec."Order Tracking Policy" = "Order Tracking Policy" THEN
                  EXIT;
                IF "Order Tracking Policy" > xRec."Order Tracking Policy" THEN BEGIN
                  MESSAGE(Text99000000 +
                    Text99000001,
                    SELECTSTR("Order Tracking Policy",Text99000002));
                END ELSE BEGIN
                  ActionMessageEntry.SETCURRENTKEY("Reservation Entry");
                  ReservEntry.SETCURRENTKEY("Item No.","Variant Code","Location Code","Reservation Status");
                  ReservEntry.SETRANGE("Item No.","No.");
                  ReservEntry.SETRANGE("Reservation Status",ReservEntry."Reservation Status"::Tracking,ReservEntry."Reservation Status"::Surplus);
                  IF ReservEntry.FIND('-') THEN
                    REPEAT
                      ActionMessageEntry.SETRANGE("Reservation Entry",ReservEntry."Entry No.");
                      ActionMessageEntry.DELETEALL;
                      IF "Order Tracking Policy" = "Order Tracking Policy"::None THEN
                        IF (ReservEntry."Lot No." <> '') OR (ReservEntry."Serial No." <> '') THEN BEGIN
                          TempReservationEntry := ReservEntry;
                          TempReservationEntry."Reservation Status" := TempReservationEntry."Reservation Status"::Surplus;
                          TempReservationEntry.INSERT;
                        END ELSE
                          ReservEntry.DELETE;
                    UNTIL ReservEntry.NEXT = 0;

                  IF TempReservationEntry.FIND('-') THEN
                    REPEAT
                      ReservEntry := TempReservationEntry;
                      ReservEntry.MODIFY;
                    UNTIL TempReservationEntry.NEXT = 0;
                END;
            end;
        }
        field(99000774;"Prod. Forecast Quantity (Base)";Decimal)
        {
            CalcFormula = Sum("Production Forecast Entry"."Forecast Quantity (Base)" WHERE (Item No.=FIELD(No.),
                                                                                            Production Forecast Name=FIELD(Production Forecast Name),
                                                                                            Forecast Date=FIELD(Date Filter),
                                                                                            Location Code=FIELD(Location Filter),
                                                                                            Component Forecast=FIELD(Component Forecast)));
            Caption = 'Prod. Forecast Quantity (Base)';
            DecimalPlaces = 0:5;
            FieldClass = FlowField;
        }
        field(99000775;"Production Forecast Name";Code[10])
        {
            Caption = 'Production Forecast Name';
            FieldClass = FlowFilter;
            TableRelation = "Production Forecast Name";
        }
        field(99000776;"Component Forecast";Boolean)
        {
            Caption = 'Component Forecast';
            FieldClass = FlowFilter;
        }
        field(99000777;"Qty. on Prod. Order";Decimal)
        {
            CalcFormula = Sum("Prod. Order Line"."Remaining Qty. (Base)" WHERE (Status=FILTER(Planned..Released),
                                                                                Item No.=FIELD(No.),
                                                                                Shortcut Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                Shortcut Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                                Location Code=FIELD(Location Filter),
                                                                                Variant Code=FIELD(Variant Filter),
                                                                                Due Date=FIELD(Date Filter)));
            Caption = 'Qty. on Prod. Order';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(99000778;"Qty. on Component Lines";Decimal)
        {
            CalcFormula = Sum("Prod. Order Component"."Remaining Qty. (Base)" WHERE (Status=FILTER(Planned..Released),
                                                                                     Item No.=FIELD(No.),
                                                                                     Shortcut Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                     Shortcut Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                                     Location Code=FIELD(Location Filter),
                                                                                     Variant Code=FIELD(Variant Filter),
                                                                                     Due Date=FIELD(Date Filter)));
            Caption = 'Qty. on Component Lines';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(99000875;Critical;Boolean)
        {
            Caption = 'Critical';
        }
        field(99008500;"Common Item No.";Code[20])
        {
            Caption = 'Common Item No.';
        }
    }

    keys
    {
        key(Key1;"No.")
        {
        }
        key(Key2;"Search Description")
        {
        }
        key(Key3;"Inventory Posting Group")
        {
        }
        key(Key4;"Shelf No.")
        {
        }
        key(Key5;"Vendor No.")
        {
        }
        key(Key6;"Gen. Prod. Posting Group")
        {
        }
        key(Key7;"Low-Level Code")
        {
        }
        key(Key8;"Production BOM No.")
        {
        }
        key(Key9;"Routing No.")
        {
        }
        key(Key10;"Vendor Item No.","Vendor No.")
        {
        }
        key(Key11;"Common Item No.")
        {
        }
        key(Key12;"Service Item Group")
        {
        }
        key(Key13;"Cost is Adjusted","Allow Online Adjustment")
        {
        }
        key(Key14;Description)
        {
        }
        key(Key15;"Base Unit of Measure")
        {
        }
        key(Key16;Type)
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown;"No.",Description,"Base Unit of Measure","Unit Price",Inventory)
        {
        }
    }

    trigger OnDelete()
    var
        BinContent: Record "7302";
        ItemCrossReference: Record "5717";
    begin
        CheckJournalsAndWorksheets(0);
        CheckDocuments(0);

        MoveEntries.MoveItemEntries(Rec);

        ServiceItem.RESET;
        ServiceItem.SETRANGE("Item No.","No.");
        IF ServiceItem.FIND('-') THEN
          REPEAT
            ServiceItem.VALIDATE("Item No.",'');
            ServiceItem.MODIFY(TRUE);
          UNTIL ServiceItem.NEXT = 0;

        ItemBudgetEntry.SETCURRENTKEY("Analysis Area","Budget Name","Item No.");
        ItemBudgetEntry.SETRANGE("Item No.","No.");
        ItemBudgetEntry.DELETEALL(TRUE);

        ItemSub.RESET;
        ItemSub.SETRANGE(Type,ItemSub.Type::Item);
        ItemSub.SETRANGE("No.","No.");
        ItemSub.DELETEALL;

        ItemSub.RESET;
        ItemSub.SETRANGE("Substitute Type",ItemSub."Substitute Type"::Item);
        ItemSub.SETRANGE("Substitute No.","No.");
        ItemSub.DELETEALL;

        SKU.RESET;
        SKU.SETCURRENTKEY("Item No.");
        SKU.SETRANGE("Item No.","No.");
        SKU.DELETEALL;

        NonstockItemMgt.NonstockItemDel(Rec);
        CommentLine.SETRANGE("Table Name",CommentLine."Table Name"::Item);
        CommentLine.SETRANGE("No.","No.");
        CommentLine.DELETEALL;

        ItemVend.SETCURRENTKEY("Item No.");
        ItemVend.SETRANGE("Item No.","No.");
        ItemVend.DELETEALL;

        SalesPrice.SETRANGE("Item No.","No.");
        SalesPrice.DELETEALL;

        SalesLineDisc.SETRANGE(Type,SalesLineDisc.Type::Item);
        SalesLineDisc.SETRANGE(Code,"No.");
        SalesLineDisc.DELETEALL;

        SalesPrepmtPct.SETRANGE("Item No.","No.");
        SalesPrepmtPct.DELETEALL;

        PurchPrice.SETRANGE("Item No.","No.");
        PurchPrice.DELETEALL;

        PurchLineDisc.SETRANGE("Item No.","No.");
        PurchLineDisc.DELETEALL;

        PurchPrepmtPct.SETRANGE("Item No.","No.");
        PurchPrepmtPct.DELETEALL;

        ItemTranslation.SETRANGE("Item No.","No.");
        ItemTranslation.DELETEALL;

        ItemUnitOfMeasure.SETRANGE("Item No.","No.");
        ItemUnitOfMeasure.DELETEALL;

        ItemVariant.SETRANGE("Item No.","No.");
        ItemVariant.DELETEALL;

        ExtTextHeader.SETRANGE("Table Name",ExtTextHeader."Table Name"::Item);
        ExtTextHeader.SETRANGE("No.","No.");
        ExtTextHeader.DELETEALL(TRUE);

        ItemAnalysisViewEntry.SETRANGE("Item No.","No.");
        ItemAnalysisViewEntry.DELETEALL;

        ItemAnalysisBudgViewEntry.SETRANGE("Item No.","No.");
        ItemAnalysisBudgViewEntry.DELETEALL;

        PlanningAssignment.SETRANGE("Item No.","No.");
        PlanningAssignment.DELETEALL;

        BOMComp.RESET;
        BOMComp.SETRANGE("Parent Item No.","No.");
        BOMComp.DELETEALL;

        TroubleshSetup.RESET;
        TroubleshSetup.SETRANGE(Type,TroubleshSetup.Type::Item);
        TroubleshSetup.SETRANGE("No.","No.");
        TroubleshSetup.DELETEALL;

        ResSkillMgt.DeleteItemResSkills("No.");
        DimMgt.DeleteDefaultDim(DATABASE::Item,"No.");

        ItemIdent.RESET;
        ItemIdent.SETCURRENTKEY("Item No.");
        ItemIdent.SETRANGE("Item No.","No.");
        ItemIdent.DELETEALL;

        ServiceItemComponent.RESET;
        ServiceItemComponent.SETRANGE(Type,ServiceItemComponent.Type::Item);
        ServiceItemComponent.SETRANGE("No.","No.");
        ServiceItemComponent.MODIFYALL("No.",'');

        BinContent.SETCURRENTKEY("Item No.");
        BinContent.SETRANGE("Item No.","No.");
        BinContent.DELETEALL;

        ItemCrossReference.SETRANGE("Item No.","No.");
        ItemCrossReference.DELETEALL;
    end;

    trigger OnInsert()
    begin
        IF "No." = '' THEN BEGIN
          GetInvtSetup;
          InvtSetup.TESTFIELD("Item Nos.");
          NoSeriesMgt.InitSeries(InvtSetup."Item Nos.",xRec."No. Series",0D,"No.","No. Series");
        END;

        DimMgt.UpdateDefaultDim(
          DATABASE::Item,"No.",
          "Global Dimension 1 Code","Global Dimension 2 Code");
    end;

    trigger OnModify()
    begin
        "Last Date Modified" := TODAY;

        PlanningAssignment.ItemChange(Rec,xRec);
    end;

    trigger OnRename()
    begin
        "Last Date Modified" := TODAY;
    end;

    var
        Text000: Label 'You cannot delete %1 %2 because there is at least one outstanding Purchase %3 that includes this item.';
        Text001: Label 'You cannot delete %1 %2 because there is at least one outstanding Sales %3 that includes this item.';
        Text002: Label 'You cannot delete %1 %2 because there are one or more outstanding production orders that include this item.';
        Text003: Label 'Do you want to change %1?';
        Text004: Label 'You cannot delete %1 %2 because there are one or more certified Production BOM that include this item.';
        Text006: Label 'Prices including VAT cannot be calculated when %1 is %2.';
        Text007: Label 'You cannot change %1 because there are one or more ledger entries for this item.';
        Text008: Label 'You cannot change %1 because there is at least one outstanding Purchase %2 that include this item.';
        Text014: Label 'You cannot delete %1 %2 because there are one or more production order component lines that include this item with a remaining quantity that is not 0.';
        Text016: Label 'You cannot delete %1 %2 because there are one or more outstanding transfer orders that include this item.';
        Text017: Label 'You cannot delete %1 %2 because there is at least one outstanding Service %3 that includes this item.';
        Text018: Label '%1 must be %2 in %3 %4 when %5 is %6.';
        Text019: Label 'You cannot change %1 because there are one or more open ledger entries for this item.';
        Text020: Label 'There may be orders and open ledger entries for the item. ';
        Text021: Label 'If you change %1 it may affect new orders and entries.\\';
        Text022: Label 'Do you want to change %1?';
        GLSetup: Record "98";
        InvtSetup: Record "313";
        Text023: Label 'You cannot delete %1 %2 because there is at least one %3 that includes this item.';
        Text024: Label 'If you change %1 it may affect existing production orders.\';
        Text025: Label '%1 must be an integer because %2 %3 is set up to use %4.';
        Text026: Label '%1 cannot be changed because the %2 has work in process (WIP). Changing the value may offset the WIP account.';
        Text7380: Label 'If you change the %1, the %2 is calculated.\Do you still want to change the %1?';
        Text7381: Label 'Cancelled.';
        Text99000000: Label 'The change will not affect existing entries.\';
        CommentLine: Record "97";
        Text99000001: Label 'If you want to generate %1 for existing entries, you must run a regenerative planning.';
        ItemVend: Record "99";
        Text99000002: Label 'tracking,tracking and action messages';
        SalesPrice: Record "7002";
        SalesLineDisc: Record "7004";
        SalesPrepmtPct: Record "459";
        PurchPrice: Record "7012";
        PurchLineDisc: Record "7014";
        PurchPrepmtPct: Record "460";
        ItemTranslation: Record "30";
        BOMComp: Record "90";
        PurchOrderLine: Record "39";
        SalesOrderLine: Record "37";
        VATPostingSetup: Record "325";
        ExtTextHeader: Record "279";
        GenProdPostingGrp: Record "251";
        ItemUnitOfMeasure: Record "5404";
        ItemVariant: Record "5401";
        ItemJnlLine: Record "83";
        ProdOrderLine: Record "5406";
        ProdOrderComp: Record "5407";
        PlanningAssignment: Record "99000850";
        SKU: Record "5700";
        ItemTrackingCode: Record "6502";
        ItemTrackingCode2: Record "6502";
        ServInvLine: Record "5902";
        ItemSub: Record "5715";
        ItemCategory: Record "5722";
        TransLine: Record "5741";
        Vend: Record "23";
        NonstockItem: Record "5718";
        ProdBOMHeader: Record "99000771";
        ProdBOMLine: Record "99000772";
        ItemIdent: Record "7704";
        RequisitionLine: Record "246";
        ItemBudgetEntry: Record "7134";
        ItemAnalysisViewEntry: Record "7154";
        ItemAnalysisBudgViewEntry: Record "7156";
        TroubleshSetup: Record "5945";
        ServiceItem: Record "5940";
        ServiceContractLine: Record "5964";
        ServiceItemComponent: Record "5941";
        ProductGrp: Record "5723";
        NoSeriesMgt: Codeunit "396";
        MoveEntries: Codeunit "361";
        DimMgt: Codeunit "408";
        NonstockItemMgt: Codeunit "5703";
        ItemCostMgt: Codeunit "5804";
        ResSkillMgt: Codeunit "5931";
        CalendarMgt: Codeunit "7600";
        HasInvtSetup: Boolean;
        GLSetupRead: Boolean;
        Text027: Label 'must be greater than 0.', Comment='starts with "Rounding Precision"';
        Text028: Label 'You cannot perform this action because entries for item %1 are unapplied in %2 by user %3.';
        CannotChangeFieldErr: Label 'You cannot change the %1 field on %2 %3 because there exists at least one %4 then includes this item.', Comment='%1 = field name, %2 = item table name, %3 = item No., %4 = table name';
        BaseUnitOfMeasureQtyMustBeOneErr: Label 'The quantity per base unit of measure must be 1. %1 is set up with %2 per unit of measure.\\You can change this setup in the Item Units of Measure window.', Comment='%1 Name of Unit of measure (e.g. BOX, PCS, KG...), %2 Qty. of %1 per base unit of measure ';

    procedure AssistEdit(): Boolean
    begin
        GetInvtSetup;
        InvtSetup.TESTFIELD("Item Nos.");
        IF NoSeriesMgt.SelectSeries(InvtSetup."Item Nos.",xRec."No. Series","No. Series") THEN BEGIN
          NoSeriesMgt.SetSeries("No.");
          EXIT(TRUE);
        END;
    end;

    procedure FindItemVend(var ItemVend: Record "99";LocationCode: Code[10])
    var
        GetPlanningParameters: Codeunit "99000855";
    begin
        TESTFIELD("No.");
        ItemVend.RESET;
        ItemVend.SETRANGE("Item No.","No.");
        ItemVend.SETRANGE("Vendor No.",ItemVend."Vendor No.");
        ItemVend.SETRANGE("Variant Code",ItemVend."Variant Code");

        IF NOT ItemVend.FIND('+') THEN BEGIN
          ItemVend."Item No." := "No.";
          ItemVend."Vendor Item No." := '';
          GetPlanningParameters.AtSKU(SKU,"No.",ItemVend."Variant Code",LocationCode);
          IF ItemVend."Vendor No." = '' THEN
            ItemVend."Vendor No." := SKU."Vendor No.";
          IF (ItemVend."Vendor Item No." = '') AND (ItemVend."Vendor No." = SKU."Vendor No.") THEN
            ItemVend."Vendor Item No." := SKU."Vendor Item No.";
          ItemVend."Lead Time Calculation" := SKU."Lead Time Calculation";
        END;
        IF FORMAT(ItemVend."Lead Time Calculation") = '' THEN
          IF Vend.GET(ItemVend."Vendor No.") THEN
            ItemVend."Lead Time Calculation" := Vend."Lead Time Calculation";
        ItemVend.RESET;
    end;

    procedure ValidateShortcutDimCode(FieldNumber: Integer;var ShortcutDimCode: Code[20])
    begin
        DimMgt.ValidateDimValueCode(FieldNumber,ShortcutDimCode);
        DimMgt.SaveDefaultDim(DATABASE::Item,"No.",FieldNumber,ShortcutDimCode);
        MODIFY;
    end;

    procedure TestNoEntriesExist(CurrentFieldName: Text[100])
    var
        ItemLedgEntry: Record "32";
    begin
        ItemLedgEntry.SETCURRENTKEY("Item No.");
        ItemLedgEntry.SETRANGE("Item No.","No.");
        IF NOT ItemLedgEntry.ISEMPTY THEN
          ERROR(
            Text007,
            CurrentFieldName);

        PurchOrderLine.SETCURRENTKEY("Document Type",Type,"No.");
        PurchOrderLine.SETFILTER(
          "Document Type",'%1|%2',
          PurchOrderLine."Document Type"::Order,
          PurchOrderLine."Document Type"::"Return Order");
        PurchOrderLine.SETRANGE(Type,PurchOrderLine.Type::Item);
        PurchOrderLine.SETRANGE("No.","No.");
        IF PurchOrderLine.FINDFIRST THEN
          ERROR(
            Text008,
            CurrentFieldName,
            PurchOrderLine."Document Type");
    end;

    procedure TestNoOpenEntriesExist(CurrentFieldName: Text[100])
    var
        ItemLedgEntry: Record "32";
    begin
        ItemLedgEntry.SETCURRENTKEY("Item No.",Open);
        ItemLedgEntry.SETRANGE("Item No.","No.");
        ItemLedgEntry.SETRANGE(Open,TRUE);
        IF NOT ItemLedgEntry.ISEMPTY THEN
          ERROR(
            Text019,
            CurrentFieldName);
    end;

    procedure ItemSKUGet(var Item: Record "27";LocationCode: Code[10];VariantCode: Code[10])
    var
        SKU: Record "5700";
    begin
        IF Item.GET("No.") THEN BEGIN
          IF SKU.GET(LocationCode,Item."No.",VariantCode) THEN
            Item."Shelf No." := SKU."Shelf No.";
        END;
    end;

    procedure GetInvtSetup()
    begin
        IF NOT HasInvtSetup THEN BEGIN
          InvtSetup.GET;
          HasInvtSetup := TRUE;
        END;
    end;

    procedure IsMfgItem(): Boolean
    begin
        EXIT("Replenishment System" = "Replenishment System"::"Prod. Order");
    end;

    procedure IsAssemblyItem(): Boolean
    begin
        EXIT("Replenishment System" = "Replenishment System"::Assembly);
    end;

    procedure HasBOM(): Boolean
    begin
        CALCFIELDS("Assembly BOM");
        EXIT("Assembly BOM" OR ("Production BOM No." <> ''));
    end;

    local procedure GetGLSetup()
    begin
        IF NOT GLSetupRead THEN
          GLSetup.GET;
        GLSetupRead := TRUE;
    end;

    procedure ProdOrderExist(): Boolean
    begin
        ProdOrderLine.SETCURRENTKEY(Status,"Item No.");
        ProdOrderLine.SETFILTER(Status,'..%1',ProdOrderLine.Status::Released);
        ProdOrderLine.SETRANGE("Item No.","No.");
        IF NOT ProdOrderLine.ISEMPTY THEN
          EXIT(TRUE);

        EXIT(FALSE);
    end;

    procedure PlanningTransferShptQty() "Sum": Decimal
    var
        ReqLine: Record "246";
    begin
        ReqLine.SETCURRENTKEY(Type,"No.","Variant Code","Transfer-from Code","Transfer Shipment Date");
        ReqLine.SETRANGE("Replenishment System",ReqLine."Replenishment System"::Transfer);
        ReqLine.SETRANGE(Type,ReqLine.Type::Item);
        ReqLine.SETRANGE("No.","No.");
        COPYFILTER("Variant Filter",ReqLine."Variant Code");
        COPYFILTER("Location Filter",ReqLine."Transfer-from Code");
        COPYFILTER("Date Filter",ReqLine."Transfer Shipment Date");
        IF ReqLine.ISEMPTY THEN
          EXIT;

        IF ReqLine.FINDSET THEN
          REPEAT
            Sum += ReqLine."Quantity (Base)";
          UNTIL ReqLine.NEXT = 0;
    end;

    procedure PlanningReleaseQty() "Sum": Decimal
    var
        ReqLine: Record "246";
    begin
        ReqLine.SETCURRENTKEY(Type,"No.","Variant Code","Location Code");
        ReqLine.SETRANGE(Type,ReqLine.Type::Item);
        ReqLine.SETRANGE("No.","No.");
        COPYFILTER("Variant Filter",ReqLine."Variant Code");
        COPYFILTER("Location Filter",ReqLine."Location Code");
        COPYFILTER("Date Filter",ReqLine."Starting Date");
        COPYFILTER("Global Dimension 1 Filter",ReqLine."Shortcut Dimension 1 Code");
        COPYFILTER("Global Dimension 2 Filter",ReqLine."Shortcut Dimension 2 Code");
        IF ReqLine.ISEMPTY THEN
          EXIT;

        IF ReqLine.FINDSET THEN
          REPEAT
            Sum += ReqLine."Quantity (Base)";
          UNTIL ReqLine.NEXT = 0;
    end;

    procedure CalcSalesReturn(): Decimal
    var
        SalesLine: Record "37";
    begin
        SalesLine.SETCURRENTKEY("Document Type",Type,"No.","Variant Code","Drop Shipment","Location Code","Shipment Date");
        SalesLine.SETRANGE("Document Type",SalesLine."Document Type"::"Return Order");
        SalesLine.SETRANGE(Type,SalesLine.Type::Item);
        SalesLine.SETRANGE("No.","No.");
        SalesLine.SETFILTER("Location Code",GETFILTER("Location Filter"));
        SalesLine.SETFILTER("Drop Shipment",GETFILTER("Drop Shipment Filter"));
        SalesLine.SETFILTER("Variant Code",GETFILTER("Variant Filter"));
        SalesLine.SETFILTER("Shipment Date",GETFILTER("Date Filter"));
        SalesLine.CALCSUMS("Outstanding Qty. (Base)");
        EXIT(SalesLine."Outstanding Qty. (Base)");
    end;

    procedure CalcPlanningWorksheetQty(): Decimal
    var
        RequisitionLine: Record "246";
    begin
        RequisitionLine.SETRANGE(Type,RequisitionLine.Type::Item);
        RequisitionLine.SETRANGE("No.","No.");
        RequisitionLine.SETFILTER("Variant Code",GETFILTER("Variant Filter"));
        RequisitionLine.SETFILTER("Location Code",GETFILTER("Location Filter"));
        RequisitionLine.SETFILTER("Shortcut Dimension 1 Code",GETFILTER("Global Dimension 1 Filter"));
        RequisitionLine.SETFILTER("Shortcut Dimension 2 Code",GETFILTER("Global Dimension 2 Filter"));
        RequisitionLine.SETFILTER("Due Date",GETFILTER("Date Filter"));
        RequisitionLine.SETRANGE("Planning Line Origin",RequisitionLine."Planning Line Origin"::Planning);
        RequisitionLine.CALCSUMS("Quantity (Base)");
        EXIT(RequisitionLine."Quantity (Base)");
    end;

    procedure CalcResvQtyOnSalesReturn(): Decimal
    var
        ReservationEntry: Record "337";
    begin
        ReservationEntry.SETCURRENTKEY(
          "Item No.","Source Type","Source Subtype","Reservation Status",
          "Location Code","Variant Code","Shipment Date","Expected Receipt Date");
        ReservationEntry.SETRANGE("Item No.","No.");
        ReservationEntry.SETRANGE("Source Type",DATABASE::"Sales Line");
        ReservationEntry.SETRANGE("Source Subtype",5); // return order
        ReservationEntry.SETRANGE("Reservation Status",ReservationEntry."Reservation Status"::Reservation);
        ReservationEntry.SETFILTER("Location Code",GETFILTER("Location Filter"));
        ReservationEntry.SETFILTER("Variant Code",GETFILTER("Variant Filter"));
        ReservationEntry.SETFILTER("Expected Receipt Date",GETFILTER("Date Filter"));
        ReservationEntry.CALCSUMS("Quantity (Base)");
        EXIT(ReservationEntry."Quantity (Base)");
    end;

    procedure CalcPurchReturn(): Decimal
    var
        PurchLine: Record "39";
    begin
        PurchLine.SETCURRENTKEY("Document Type",Type,"No.","Variant Code","Drop Shipment","Location Code","Expected Receipt Date");
        PurchLine.SETRANGE("Document Type",PurchLine."Document Type"::"Return Order");
        PurchLine.SETRANGE(Type,PurchLine.Type::Item);
        PurchLine.SETRANGE("No.","No.");
        PurchLine.SETFILTER("Location Code",GETFILTER("Location Filter"));
        PurchLine.SETFILTER("Drop Shipment",GETFILTER("Drop Shipment Filter"));
        PurchLine.SETFILTER("Variant Code",GETFILTER("Variant Filter"));
        PurchLine.SETFILTER("Expected Receipt Date",GETFILTER("Date Filter"));
        PurchLine.CALCSUMS("Outstanding Qty. (Base)");
        EXIT(PurchLine."Outstanding Qty. (Base)");
    end;

    procedure CalcResvQtyOnPurchReturn(): Decimal
    var
        ReservationEntry: Record "337";
    begin
        ReservationEntry.SETCURRENTKEY(
          "Item No.","Source Type","Source Subtype","Reservation Status",
          "Location Code","Variant Code","Shipment Date","Expected Receipt Date");
        ReservationEntry.SETRANGE("Item No.","No.");
        ReservationEntry.SETRANGE("Source Type",DATABASE::"Purchase Line");
        ReservationEntry.SETRANGE("Source Subtype",5); // return order
        ReservationEntry.SETRANGE("Reservation Status",ReservationEntry."Reservation Status"::Reservation);
        ReservationEntry.SETFILTER("Location Code",GETFILTER("Location Filter"));
        ReservationEntry.SETFILTER("Variant Code",GETFILTER("Variant Filter"));
        ReservationEntry.SETFILTER("Shipment Date",GETFILTER("Date Filter"));
        ReservationEntry.CALCSUMS("Quantity (Base)");
        EXIT(-ReservationEntry."Quantity (Base)");
    end;

    procedure CheckSerialNoQty(ItemNo: Code[20];FieldName: Text[30];Quantity: Decimal)
    var
        ItemRec: Record "27";
        ItemTrackingCode3: Record "6502";
    begin
        IF Quantity = ROUND(Quantity,1) THEN
          EXIT;
        IF NOT ItemRec.GET(ItemNo) THEN
          EXIT;
        IF ItemRec."Item Tracking Code" = '' THEN
          EXIT;
        IF NOT ItemTrackingCode3.GET(ItemRec."Item Tracking Code") THEN
          EXIT;
        IF ItemTrackingCode3."SN Specific Tracking" THEN
          ERROR(Text025,
            FieldName,
            TABLECAPTION,
            ItemNo,
            ItemTrackingCode3.FIELDCAPTION("SN Specific Tracking"));
    end;

    procedure CheckForProductionOutput(ItemNo: Code[20])
    var
        ItemLedgEntry: Record "32";
    begin
        CLEAR(ItemLedgEntry);
        ItemLedgEntry.SETCURRENTKEY("Item No.","Entry Type","Variant Code","Drop Shipment","Location Code","Posting Date");
        ItemLedgEntry.SETRANGE("Item No.",ItemNo);
        ItemLedgEntry.SETRANGE("Entry Type",ItemLedgEntry."Entry Type"::Output);
        IF NOT ItemLedgEntry.ISEMPTY THEN
          ERROR(Text026,FIELDCAPTION("Inventory Value Zero"),TABLECAPTION);
    end;

    procedure CheckBlockedByApplWorksheet()
    var
        ApplicationWorksheet: Page "521";
    begin
        IF "Application Wksh. User ID" <> '' THEN
          ERROR(Text028,"No.",ApplicationWorksheet.CAPTION,"Application Wksh. User ID");
    end;

    procedure ShowTimelineFromItem(var Item: Record "27")
    var
        ItemAvailByTimeline: Page "5540";
    begin
        ItemAvailByTimeline.SetItem(Item);
        ItemAvailByTimeline.RUN;
    end;

    procedure ShowTimelineFromSKU(ItemNo: Code[20];LocationCode: Code[10];VariantCode: Code[10])
    var
        Item: Record "27";
    begin
        Item.GET(ItemNo);
        Item.SETRANGE("No.",Item."No.");
        Item.SETRANGE("Variant Filter",VariantCode);
        Item.SETRANGE("Location Filter",LocationCode);
        ShowTimelineFromItem(Item);
    end;

    local procedure CheckJournalsAndWorksheets(CurrFieldNo: Integer)
    begin
        CheckItemJnlLine(CurrFieldNo);
        CheckStdCostWksh(CurrFieldNo);
        CheckReqLine(CurrFieldNo);
    end;

    local procedure CheckItemJnlLine(CurrFieldNo: Integer)
    begin
        ItemJnlLine.SETRANGE("Item No.","No.");
        IF NOT ItemJnlLine.ISEMPTY THEN BEGIN
          IF CurrFieldNo = 0 THEN
            ERROR(Text023,TABLECAPTION,"No.",ItemJnlLine.TABLECAPTION);
          IF CurrFieldNo = FIELDNO(Type) THEN
            ERROR(CannotChangeFieldErr,FIELDCAPTION(Type),TABLECAPTION,"No.",ItemJnlLine.TABLECAPTION);
        END;
    end;

    local procedure CheckStdCostWksh(CurrFieldNo: Integer)
    var
        StdCostWksh: Record "5841";
    begin
        StdCostWksh.RESET;
        StdCostWksh.SETRANGE(Type,StdCostWksh.Type::Item);
        StdCostWksh.SETRANGE("No.","No.");
        IF NOT StdCostWksh.ISEMPTY THEN
          IF CurrFieldNo = 0 THEN
            ERROR(Text023,TABLECAPTION,"No.",StdCostWksh.TABLECAPTION);
    end;

    local procedure CheckReqLine(CurrFieldNo: Integer)
    begin
        RequisitionLine.SETCURRENTKEY(Type,"No.");
        RequisitionLine.SETRANGE(Type,RequisitionLine.Type::Item);
        RequisitionLine.SETRANGE("No.","No.");
        IF NOT RequisitionLine.ISEMPTY THEN BEGIN
          IF CurrFieldNo = 0 THEN
            ERROR(Text023,TABLECAPTION,"No.",RequisitionLine.TABLECAPTION);
          IF CurrFieldNo = FIELDNO(Type) THEN
            ERROR(CannotChangeFieldErr,FIELDCAPTION(Type),TABLECAPTION,"No.",RequisitionLine.TABLECAPTION);
        END;
    end;

    local procedure CheckDocuments(CurrFieldNo: Integer)
    begin
        CheckBOM(CurrFieldNo);
        CheckPurchLine(CurrFieldNo);
        CheckSalesLine(CurrFieldNo);
        CheckProdOrderLine(CurrFieldNo);
        CheckProdOrderCompLine(CurrFieldNo);
        CheckPlanningCompLine(CurrFieldNo);
        CheckTransLine(CurrFieldNo);
        CheckServLine(CurrFieldNo);
        CheckProdBOMLine(CurrFieldNo);
        CheckServContractLine(CurrFieldNo);
        CheckAsmHeader(CurrFieldNo);
        CheckAsmLine(CurrFieldNo);
        CheckJobPlanningLine(CurrFieldNo);
    end;

    local procedure CheckBOM(CurrFieldNo: Integer)
    begin
        BOMComp.RESET;
        BOMComp.SETCURRENTKEY(Type,"No.");
        BOMComp.SETRANGE(Type,BOMComp.Type::Item);
        BOMComp.SETRANGE("No.","No.");
        IF NOT BOMComp.ISEMPTY THEN BEGIN
          IF CurrFieldNo = 0 THEN
            ERROR(Text023,TABLECAPTION,"No.",BOMComp.TABLECAPTION);
          IF CurrFieldNo = FIELDNO(Type) THEN
            ERROR(CannotChangeFieldErr,FIELDCAPTION(Type),TABLECAPTION,"No.",BOMComp.TABLECAPTION);
        END;
    end;

    local procedure CheckPurchLine(CurrFieldNo: Integer)
    begin
        PurchOrderLine.SETCURRENTKEY(Type,"No.");
        PurchOrderLine.SETRANGE(Type,PurchOrderLine.Type::Item);
        PurchOrderLine.SETRANGE("No.","No.");
        IF NOT PurchOrderLine.ISEMPTY THEN BEGIN
          IF CurrFieldNo = 0 THEN
            ERROR(Text000,TABLECAPTION,"No.",PurchOrderLine."Document Type");
          IF CurrFieldNo = FIELDNO(Type) THEN
            ERROR(CannotChangeFieldErr,FIELDCAPTION(Type),TABLECAPTION,"No.",PurchOrderLine.TABLECAPTION);
        END;
    end;

    local procedure CheckSalesLine(CurrFieldNo: Integer)
    begin
        SalesOrderLine.SETCURRENTKEY(Type,"No.");
        SalesOrderLine.SETRANGE(Type,SalesOrderLine.Type::Item);
        SalesOrderLine.SETRANGE("No.","No.");
        IF NOT SalesOrderLine.ISEMPTY THEN BEGIN
          IF CurrFieldNo = 0 THEN
            ERROR(Text001,TABLECAPTION,"No.",SalesOrderLine."Document Type");
          IF CurrFieldNo = FIELDNO(Type) THEN
            ERROR(CannotChangeFieldErr,FIELDCAPTION(Type),TABLECAPTION,"No.",SalesOrderLine.TABLECAPTION);
        END;
    end;

    local procedure CheckProdOrderLine(CurrFieldNo: Integer)
    begin
        IF ProdOrderExist THEN BEGIN
          IF CurrFieldNo = 0 THEN
            ERROR(Text002,TABLECAPTION,"No.");
          IF CurrFieldNo = FIELDNO(Type) THEN
            ERROR(CannotChangeFieldErr,FIELDCAPTION(Type),TABLECAPTION,"No.",ProdOrderLine.TABLECAPTION);
        END;
    end;

    local procedure CheckProdOrderCompLine(CurrFieldNo: Integer)
    begin
        ProdOrderComp.SETCURRENTKEY(Status,"Item No.");
        ProdOrderComp.SETFILTER(Status,'..%1',ProdOrderComp.Status::Released);
        ProdOrderComp.SETRANGE("Item No.","No.");
        IF NOT ProdOrderComp.ISEMPTY THEN BEGIN
          IF CurrFieldNo = 0 THEN
            ERROR(Text014,TABLECAPTION,"No.");
          IF CurrFieldNo = FIELDNO(Type) THEN
            ERROR(CannotChangeFieldErr,FIELDCAPTION(Type),TABLECAPTION,"No.",ProdOrderComp.TABLECAPTION);
        END;
    end;

    local procedure CheckPlanningCompLine(CurrFieldNo: Integer)
    var
        PlanningComponent: Record "99000829";
    begin
        PlanningComponent.SETCURRENTKEY("Item No.","Variant Code","Location Code","Due Date","Planning Line Origin");
        PlanningComponent.SETRANGE("Item No.","No.");
        IF NOT PlanningComponent.ISEMPTY THEN BEGIN
          IF CurrFieldNo = 0 THEN
            ERROR(Text023,TABLECAPTION,"No.",PlanningComponent.TABLECAPTION);
          IF CurrFieldNo = FIELDNO(Type) THEN
            ERROR(CannotChangeFieldErr,FIELDCAPTION(Type),TABLECAPTION,"No.",PlanningComponent.TABLECAPTION);
        END;
    end;

    local procedure CheckTransLine(CurrFieldNo: Integer)
    begin
        TransLine.SETCURRENTKEY("Item No.");
        TransLine.SETRANGE("Item No.","No.");
        IF NOT TransLine.ISEMPTY THEN BEGIN
          IF CurrFieldNo = 0 THEN
            ERROR(Text016,TABLECAPTION,"No.");
          IF CurrFieldNo = FIELDNO(Type) THEN
            ERROR(CannotChangeFieldErr,FIELDCAPTION(Type),TABLECAPTION,"No.",TransLine.TABLECAPTION);
        END;
    end;

    local procedure CheckServLine(CurrFieldNo: Integer)
    begin
        ServInvLine.RESET;
        ServInvLine.SETCURRENTKEY(Type,"No.");
        ServInvLine.SETRANGE(Type,ServInvLine.Type::Item);
        ServInvLine.SETRANGE("No.","No.");
        IF NOT ServInvLine.ISEMPTY THEN BEGIN
          IF CurrFieldNo = 0 THEN
            ERROR(Text017,TABLECAPTION,"No.",ServInvLine."Document Type");
          IF CurrFieldNo = FIELDNO(Type) THEN
            ERROR(CannotChangeFieldErr,FIELDCAPTION(Type),TABLECAPTION,"No.",ServInvLine.TABLECAPTION);
        END;
    end;

    local procedure CheckProdBOMLine(CurrFieldNo: Integer)
    begin
        ProdBOMLine.RESET;
        ProdBOMLine.SETCURRENTKEY(Type,"No.");
        ProdBOMLine.SETRANGE(Type,ProdBOMLine.Type::Item);
        ProdBOMLine.SETRANGE("No.","No.");
        IF ProdBOMLine.FIND('-') THEN BEGIN
          IF CurrFieldNo = FIELDNO(Type) THEN
            ERROR(CannotChangeFieldErr,FIELDCAPTION(Type),TABLECAPTION,"No.",ProdBOMLine.TABLECAPTION);
          IF CurrFieldNo = 0 THEN
            REPEAT
              IF ProdBOMHeader.GET(ProdBOMLine."Production BOM No.") AND
                 (ProdBOMHeader.Status = ProdBOMHeader.Status::Certified)
              THEN
                ERROR(Text004,TABLECAPTION,"No.");
            UNTIL ProdBOMLine.NEXT = 0;
        END;
    end;

    local procedure CheckServContractLine(CurrFieldNo: Integer)
    begin
        ServiceContractLine.RESET;
        ServiceContractLine.SETRANGE("Item No.","No.");
        IF NOT ServiceContractLine.ISEMPTY THEN BEGIN
          IF CurrFieldNo = 0 THEN
            ERROR(Text023,TABLECAPTION,"No.",ServiceContractLine.TABLECAPTION);
          IF CurrFieldNo = FIELDNO(Type) THEN
            ERROR(CannotChangeFieldErr,FIELDCAPTION(Type),TABLECAPTION,"No.",ServiceContractLine.TABLECAPTION);
        END;
    end;

    local procedure CheckAsmHeader(CurrFieldNo: Integer)
    var
        AsmHeader: Record "900";
    begin
        AsmHeader.SETCURRENTKEY("Document Type","Item No.");
        AsmHeader.SETRANGE("Item No.","No.");
        IF NOT AsmHeader.ISEMPTY THEN BEGIN
          IF CurrFieldNo = 0 THEN
            ERROR(Text023,TABLECAPTION,"No.",AsmHeader.TABLECAPTION);
          IF CurrFieldNo = FIELDNO(Type) THEN
            ERROR(CannotChangeFieldErr,FIELDCAPTION(Type),TABLECAPTION,"No.",AsmHeader.TABLECAPTION);
        END;
    end;

    local procedure CheckAsmLine(CurrFieldNo: Integer)
    var
        AsmLine: Record "901";
    begin
        AsmLine.SETCURRENTKEY(Type,"No.");
        AsmLine.SETRANGE(Type,AsmLine.Type::Item);
        AsmLine.SETRANGE("No.","No.");
        IF NOT AsmLine.ISEMPTY THEN BEGIN
          IF CurrFieldNo = 0 THEN
            ERROR(Text023,TABLECAPTION,"No.",AsmLine.TABLECAPTION);
          IF CurrFieldNo = FIELDNO(Type) THEN
            ERROR(CannotChangeFieldErr,FIELDCAPTION(Type),TABLECAPTION,"No.",AsmLine.TABLECAPTION);
        END;
    end;

    procedure PreventNegativeInventory(): Boolean
    var
        InventorySetup: Record "313";
    begin
        CASE "Prevent Negative Inventory" OF
          "Prevent Negative Inventory"::Yes:
            EXIT(TRUE);
          "Prevent Negative Inventory"::No:
            EXIT(FALSE);
          "Prevent Negative Inventory"::Default:
            BEGIN
              InventorySetup.GET;
              EXIT(InventorySetup."Prevent Negative Inventory");
            END;
        END;
    end;

    local procedure CheckJobPlanningLine(CurrFieldNo: Integer)
    var
        JobPlanningLine: Record "1003";
    begin
        JobPlanningLine.SETCURRENTKEY(Type,"No.");
        JobPlanningLine.SETRANGE(Type,JobPlanningLine.Type::Item);
        JobPlanningLine.SETRANGE("No.","No.");
        IF NOT JobPlanningLine.ISEMPTY THEN BEGIN
          IF CurrFieldNo = 0 THEN
            ERROR(Text023,TABLECAPTION,"No.",JobPlanningLine.TABLECAPTION);
          IF CurrFieldNo = FIELDNO(Type) THEN
            ERROR(CannotChangeFieldErr,FIELDCAPTION(Type),TABLECAPTION,"No.",JobPlanningLine.TABLECAPTION);
        END;
    end;

    local procedure CalcVAT(): Decimal
    begin
        IF "Price Includes VAT" AND
           ("Price/Profit Calculation" < "Price/Profit Calculation"::"No Relationship")
        THEN BEGIN
          VATPostingSetup.GET("VAT Bus. Posting Gr. (Price)","VAT Prod. Posting Group");
          CASE VATPostingSetup."VAT Calculation Type" OF
            VATPostingSetup."VAT Calculation Type"::"Reverse Charge VAT":
              VATPostingSetup."VAT %" := 0;
            VATPostingSetup."VAT Calculation Type"::"Sales Tax":
              ERROR(
                Text006,
                VATPostingSetup.FIELDCAPTION("VAT Calculation Type"),
                VATPostingSetup."VAT Calculation Type");
          END;
        END ELSE
          CLEAR(VATPostingSetup);

        EXIT(VATPostingSetup."VAT %" / 100);
    end;

    procedure CalcUnitPriceExclVAT(): Decimal
    begin
        EXIT("Unit Price" * (1 - CalcVAT));
    end;
}

