// table 25001 "Kit BOM Journal Line"
// {
//     Caption = 'Kit BOM Journal Line';

//     fields
//     {
//         field(1;"Journal Template Name";Code[10])
//         {
//             Caption = 'Journal Template Name';
//             TableRelation = Table88;
//         }
//         field(2;"Journal Batch Name";Code[10])
//         {
//             Caption = 'Journal Batch Name';
//             TableRelation = Table234.Field2 WHERE (Field1=FIELD(Journal Template Name));
//         }
//         field(3;"Journal Line No.";Integer)
//         {
//             Caption = 'Journal Line No.';
//             TableRelation = Table89.Field2 WHERE (Field1=FIELD(Journal Template Name),
//                                                   Field15=FIELD(Journal Batch Name));
//         }
//         field(4;"Line No.";Integer)
//         {
//             Caption = 'Line No.';
//         }
//         field(5;Type;Option)
//         {
//             Caption = 'Type';
//             OptionCaption = ' ,Item,,Resource,Setup Resource';
//             OptionMembers = " ",Item,,Resource,"Setup Resource";
//         }
//         field(6;"No.";Code[20])
//         {
//             Caption = 'No.';
//             TableRelation = IF (Type=CONST(Item)) Item
//                             ELSE IF (Type=FILTER(Resource|Setup Resource)) Resource;
//         }
//         field(7;Description;Text[50])
//         {
//             Caption = 'Description';
//         }
//         field(9;"Variant Code";Code[10])
//         {
//             Caption = 'Variant Code';
//             TableRelation = IF (Type=CONST(Item)) "Item Variant".Code WHERE (Item No.=FIELD(No.));
//         }
//         field(10;"Location Code";Code[10])
//         {
//             Caption = 'Location Code';
//             Editable = false;
//             TableRelation = Location;
//         }
//         field(11;"Unit of Measure Code";Code[10])
//         {
//             Caption = 'Unit of Measure Code';
//             TableRelation = IF (Type=CONST(Item)) "Item Unit of Measure".Code WHERE (Item No.=FIELD(No.))
//                             ELSE IF (Type=FILTER(Resource|Setup Resource)) "Resource Unit of Measure".Code WHERE (Resource No.=FIELD(No.))
//                             ELSE "Unit of Measure";
//         }
//         field(13;"Qty. per Unit of Measure";Decimal)
//         {
//             Caption = 'Qty. per Unit of Measure';
//             DecimalPlaces = 0:5;
//             Editable = false;
//             InitValue = 1;
//         }
//         field(14;"Quantity per";Decimal)
//         {
//             Caption = 'Quantity per';
//             DecimalPlaces = 0:5;
//         }
//         field(15;"Quantity per (Base)";Decimal)
//         {
//             Caption = 'Quantity per (Base)';
//             DecimalPlaces = 0:5;
//             Editable = false;
//         }
//         field(16;"Extended Quantity";Decimal)
//         {
//             Caption = 'Extended Quantity';
//             DecimalPlaces = 0:5;
//             Editable = false;
//         }
//         field(17;"Extended Quantity (Base)";Decimal)
//         {
//             Caption = 'Extended Quantity (Base)';
//             DecimalPlaces = 0:5;
//             Editable = false;
//         }
//         field(18;"Applies-to Entry";Integer)
//         {
//             Caption = 'Applies-to Entry';

//             trigger OnLookup()
//             begin
//                 TESTFIELD(Type,Type::Item);
//                 SelectItemEntry;
//             end;

//             trigger OnValidate()
//             var
//                 ItemLedgEntry: Record "32";
//             begin
//                 TESTFIELD(Type,Type::Item);
//                 TESTFIELD("Extended Quantity");
//                 IF "Applies-to Entry" <> 0 THEN BEGIN
//                   ItemLedgEntry.GET("Applies-to Entry");
//                   ItemLedgEntry.TESTFIELD(Positive,TRUE);
//                   "Location Code" := ItemLedgEntry."Location Code";
//                   "Variant Code" := ItemLedgEntry."Variant Code";
//                   IF NOT ItemLedgEntry.Open THEN
//                     MESSAGE(Text001,"Applies-to Entry");
//                 END;
//             end;
//         }
//         field(19;"Bin Code";Code[20])
//         {
//             Caption = 'Bin Code';
//             TableRelation = IF (Type=CONST(Item)) "Bin Content"."Bin Code" WHERE (Location Code=FIELD(Location Code),
//                                                                                   Item No.=FIELD(No.),
//                                                                                   Variant Code=FIELD(Variant Code));

//             trigger OnValidate()
//             var
//                 Location: Record "14";
//                 Bin: Record "7354";
//             begin
//                 TESTFIELD(Type,Type::Item);
//                 IF "Bin Code" <> xRec."Bin Code" THEN BEGIN
//                   TESTFIELD("Location Code");
//                   IF "Bin Code" <> '' THEN BEGIN
//                     Location.GET("Location Code");
//                     Location.TESTFIELD("Bin Mandatory");
//                     IF Location."Directed Put-away and Pick" THEN
//                       ERROR(Text002,
//                         FIELDCAPTION("Bin Code"),
//                         LOWERCASE(Location.TABLECAPTION),Location.Code,Location.FIELDCAPTION("Directed Put-away and Pick"));
//                     Bin.GET("Location Code","Bin Code");
//                     TESTFIELD("Location Code",Bin."Location Code");
//                   END;
//                 END;
//             end;
//         }
//         field(20;"Unit Cost";Decimal)
//         {
//             AutoFormatType = 2;
//             Caption = 'Unit Cost';

//             trigger OnValidate()
//             var
//                 ItemJnlLine: Record "83";
//                 Item: Record "27";
//             begin
//                 TESTFIELD(Type,Type::Item);
//                 TESTFIELD("No.");
//                 //BOMJnlLine.GET("Journal Template Name","Journal Batch Name","Journal Line No.");
//                 //BOMJnlLine.TESTFIELD("Entry Type",BOMJnlLine."Entry Type"::"1");
//                 Item.GET("No.");
//                 IF Item."Costing Method" = Item."Costing Method"::Standard THEN
//                   ERROR(
//                     Text003,
//                     FIELDCAPTION("Unit Cost"),Item.FIELDCAPTION("Costing Method"),Item."Costing Method");

//                 CLEAR(ItemJnlLine);
//                 ItemJnlLine."Entry Type" := ItemJnlLine."Entry Type"::"Positive Adjmt.";
//                 ItemJnlLine."Item No." := "No.";
//                 ItemJnlLine.VALIDATE("Unit Cost","Unit Cost");
//                 "Unit Cost" := ItemJnlLine."Unit Cost";
//             end;
//         }
//     }

//     keys
//     {
//         key(Key1;"Journal Template Name","Journal Batch Name","Journal Line No.","Line No.")
//         {
//         }
//     }

//     fieldgroups
//     {
//     }

//     trigger OnDelete()
//     begin
//         //ReserveKitBOMJnlLine.DeleteLine(Rec);
//     end;

//     var
//         Text001: Label 'When Posting the entry %1 will be opened first';
//         Text002: Label 'You cannot use a %1 because %2 %3 is set up with %4.';
//         Text003: Label 'You cannot change %1 when %2 is %3.';

//     local procedure SelectItemEntry()
//     var
//         ItemLedgEntry: Record "32";
//         KitBOMJnlLine2: Record "25001";
//     begin
//         ItemLedgEntry.SETRANGE("Item No.","No.");
//         ItemLedgEntry.SETCURRENTKEY("Item No.",Open);
//         ItemLedgEntry.SETRANGE(Open,TRUE);
//         ItemLedgEntry.SETRANGE(Positive,TRUE);
//         IF "Location Code" <> '' THEN
//           ItemLedgEntry.SETRANGE("Location Code","Location Code");

//         //IF FORM.RUNMODAL(FORM::Page38,ItemLedgEntry) = ACTION::LookupOK THEN BEGIN
//         IF PAGE.RUNMODAL(PAGE::"Item Ledger Entries",ItemLedgEntry) = ACTION::LookupOK THEN BEGIN
//           KitBOMJnlLine2 := Rec;
//           KitBOMJnlLine2.VALIDATE("Applies-to Entry",ItemLedgEntry."Entry No.");
//           Rec := KitBOMJnlLine2;
//         END;
//     end;

//     procedure OpenItemTrackingLines()
//     begin
//         TESTFIELD(Type,Type::Item);
//         TESTFIELD("No.");
//         TESTFIELD("Extended Quantity");
//         //ReserveKitBOMJnlLine.CallItemTracking(Rec);
//     end;

//     procedure ShowBinContents()
//     var
//         BinContent: Record "7302";
//     begin
//         TESTFIELD(Type,Type::Item);
//         TESTFIELD("No.");
//         BinContent.SETCURRENTKEY("Location Code","Item No.","Variant Code");
//         BinContent.SETRANGE("Location Code","Location Code");
//         BinContent.SETRANGE("Item No.","No.");
//         BinContent.SETRANGE("Variant Code","Variant Code");
//         //FORM.RUN(FORM::Page7305,BinContent);
//         PAGE.RUN(PAGE::"Bin Contents List",BinContent);
//     end;
// }

