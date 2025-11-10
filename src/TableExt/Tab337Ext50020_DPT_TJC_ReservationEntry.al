// table 337 "Reservation Entry"
// {
//     Caption = 'Reservation Entry';
//     DrillDownPageID = 497;
//     LookupPageID = 497;

//     fields
//     {
//         field(1;"Entry No.";Integer)
//         {
//             AutoIncrement = true;
//             Caption = 'Entry No.';
//         }
//         field(2;"Item No.";Code[20])
//         {
//             Caption = 'Item No.';
//             TableRelation = Item;
//         }
//         field(3;"Location Code";Code[10])
//         {
//             Caption = 'Location Code';
//             TableRelation = Location;
//         }
//         field(4;"Quantity (Base)";Decimal)
//         {
//             Caption = 'Quantity (Base)';
//             DecimalPlaces = 0:5;

//             trigger OnValidate()
//             begin
//                 Quantity := ROUND("Quantity (Base)" / "Qty. per Unit of Measure",0.00001);
//                 "Qty. to Handle (Base)" := "Quantity (Base)";
//                 "Qty. to Invoice (Base)" := "Quantity (Base)";
//             end;
//         }
//         field(5;"Reservation Status";Option)
//         {
//             Caption = 'Reservation Status';
//             OptionCaption = 'Reservation,Tracking,Surplus,Prospect';
//             OptionMembers = Reservation,Tracking,Surplus,Prospect;
//         }
//         field(7;Description;Text[50])
//         {
//             Caption = 'Description';
//         }
//         field(8;"Creation Date";Date)
//         {
//             Caption = 'Creation Date';
//         }
//         field(9;"Transferred from Entry No.";Integer)
//         {
//             Caption = 'Transferred from Entry No.';
//             TableRelation = "Reservation Entry";
//         }
//         field(10;"Source Type";Integer)
//         {
//             Caption = 'Source Type';
//         }
//         field(11;"Source Subtype";Option)
//         {
//             Caption = 'Source Subtype';
//             OptionCaption = '0,1,2,3,4,5,6,7,8,9,10';
//             OptionMembers = "0","1","2","3","4","5","6","7","8","9","10";
//         }
//         field(12;"Source ID";Code[20])
//         {
//             Caption = 'Source ID';
//         }
//         field(13;"Source Batch Name";Code[10])
//         {
//             Caption = 'Source Batch Name';
//         }
//         field(14;"Source Prod. Order Line";Integer)
//         {
//             Caption = 'Source Prod. Order Line';
//         }
//         field(15;"Source Ref. No.";Integer)
//         {
//             Caption = 'Source Ref. No.';
//         }
//         field(16;"Item Ledger Entry No.";Integer)
//         {
//             Caption = 'Item Ledger Entry No.';
//             Editable = false;
//             TableRelation = "Item Ledger Entry";
//         }
//         field(22;"Expected Receipt Date";Date)
//         {
//             Caption = 'Expected Receipt Date';
//         }
//         field(23;"Shipment Date";Date)
//         {
//             Caption = 'Shipment Date';
//         }
//         field(24;"Serial No.";Code[20])
//         {
//             Caption = 'Serial No.';
//         }
//         field(25;"Created By";Code[50])
//         {
//             Caption = 'Created By';
//             TableRelation = User."User Name";
//             //This property is currently not supported
//             //TestTableRelation = false;

//             trigger OnLookup()
//             var
//                 UserMgt: Codeunit "418";
//             begin
//                 UserMgt.LookupUserID("Created By");
//             end;
//         }
//         field(27;"Changed By";Code[50])
//         {
//             Caption = 'Changed By';
//             TableRelation = User."User Name";
//             //This property is currently not supported
//             //TestTableRelation = false;

//             trigger OnLookup()
//             var
//                 UserMgt: Codeunit "418";
//             begin
//                 UserMgt.LookupUserID("Changed By");
//             end;
//         }
//         field(28;Positive;Boolean)
//         {
//             Caption = 'Positive';
//             Editable = true;
//         }
//         field(29;"Qty. per Unit of Measure";Decimal)
//         {
//             Caption = 'Qty. per Unit of Measure';
//             DecimalPlaces = 0:5;
//             Editable = false;
//             InitValue = 1;

//             trigger OnValidate()
//             begin
//                 Quantity := ROUND("Quantity (Base)" / "Qty. per Unit of Measure",0.00001);
//             end;
//         }
//         field(30;Quantity;Decimal)
//         {
//             Caption = 'Quantity';
//             DecimalPlaces = 0:5;
//         }
//         field(31;"Action Message Adjustment";Decimal)
//         {
//             CalcFormula = Sum("Action Message Entry".Quantity WHERE (Reservation Entry=FIELD(Entry No.),
//                                                                      Calculation=CONST(Sum)));
//             Caption = 'Action Message Adjustment';
//             DecimalPlaces = 0:5;
//             Editable = false;
//             FieldClass = FlowField;
//         }
//         field(32;Binding;Option)
//         {
//             Caption = 'Binding';
//             Editable = false;
//             OptionCaption = ' ,Order-to-Order';
//             OptionMembers = " ","Order-to-Order";
//         }
//         field(33;"Suppressed Action Msg.";Boolean)
//         {
//             Caption = 'Suppressed Action Msg.';
//         }
//         field(34;"Planning Flexibility";Option)
//         {
//             Caption = 'Planning Flexibility';
//             OptionCaption = 'Unlimited,None';
//             OptionMembers = Unlimited,"None";
//         }
//         field(38;"Appl.-to Item Entry";Integer)
//         {
//             Caption = 'Appl.-to Item Entry';
//         }
//         field(40;"Warranty Date";Date)
//         {
//             Caption = 'Warranty Date';
//             Editable = false;
//         }
//         field(41;"Expiration Date";Date)
//         {
//             Caption = 'Expiration Date';
//             Editable = true;
//         }
//         field(50;"Qty. to Handle (Base)";Decimal)
//         {
//             Caption = 'Qty. to Handle (Base)';
//             DecimalPlaces = 0:5;
//         }
//         field(51;"Qty. to Invoice (Base)";Decimal)
//         {
//             Caption = 'Qty. to Invoice (Base)';
//             DecimalPlaces = 0:5;
//         }
//         field(53;"Quantity Invoiced (Base)";Decimal)
//         {
//             Caption = 'Quantity Invoiced (Base)';
//             DecimalPlaces = 0:5;
//         }
//         field(80;"New Serial No.";Code[20])
//         {
//             Caption = 'New Serial No.';
//             Editable = false;
//         }
//         field(81;"New Lot No.";Code[20])
//         {
//             Caption = 'New Lot No.';
//             Editable = false;
//         }
//         field(900;"Disallow Cancellation";Boolean)
//         {
//             Caption = 'Disallow Cancellation';
//         }
//         field(5400;"Lot No.";Code[20])
//         {
//             Caption = 'Lot No.';
//         }
//         field(5401;"Variant Code";Code[10])
//         {
//             Caption = 'Variant Code';
//             TableRelation = "Item Variant".Code WHERE (Item No.=FIELD(Item No.));
//         }
//         field(5811;"Appl.-from Item Entry";Integer)
//         {
//             Caption = 'Appl.-from Item Entry';
//             MinValue = 0;
//         }
//         field(5817;Correction;Boolean)
//         {
//             Caption = 'Correction';
//         }
//         field(6505;"New Expiration Date";Date)
//         {
//             Caption = 'New Expiration Date';
//             Editable = false;
//         }
//         field(6510;"Item Tracking";Option)
//         {
//             Caption = 'Item Tracking';
//             Editable = false;
//             OptionCaption = 'None,Lot No.,Lot and Serial No.,Serial No.';
//             OptionMembers = "None","Lot No.","Lot and Serial No.","Serial No.";
//         }
//     }

//     keys
//     {
//         key(Key1;"Entry No.",Positive)
//         {
//         }
//         key(Key2;"Source ID","Source Ref. No.","Source Type","Source Subtype","Source Batch Name","Source Prod. Order Line","Reservation Status","Shipment Date","Expected Receipt Date")
//         {
//             MaintainSIFTIndex = false;
//             SumIndexFields = "Quantity (Base)",Quantity;
//         }
//         key(Key3;"Item No.","Variant Code","Location Code","Reservation Status","Shipment Date","Expected Receipt Date","Serial No.","Lot No.")
//         {
//             MaintainSIFTIndex = false;
//             SumIndexFields = "Quantity (Base)";
//         }
//         key(Key4;"Item No.","Source Type","Source Subtype","Reservation Status","Location Code","Variant Code","Shipment Date","Expected Receipt Date","Serial No.","Lot No.")
//         {
//             MaintainSIFTIndex = false;
//             MaintainSQLIndex = false;
//             SumIndexFields = "Quantity (Base)",Quantity;
//         }
//         key(Key5;"Item No.","Variant Code","Location Code","Item Tracking","Reservation Status","Lot No.","Serial No.")
//         {
//             MaintainSIFTIndex = false;
//             MaintainSQLIndex = false;
//             SumIndexFields = "Quantity (Base)";
//         }
//     }

//     fieldgroups
//     {
//         fieldgroup(DropDown;"Entry No.",Positive,"Item No.",Description,Quantity)
//         {
//         }
//     }

//     trigger OnDelete()
//     var
//         ActionMessageEntry: Record "99000849";
//     begin
//         ActionMessageEntry.SETCURRENTKEY("Reservation Entry");
//         ActionMessageEntry.SETRANGE("Reservation Entry","Entry No.");
//         ActionMessageEntry.DELETEALL;
//     end;

//     var
//         Text001: Label 'Line';

//     procedure TextCaption(): Text[255]
//     var
//         ItemLedgEntry: Record "32";
//         SalesLine: Record "37";
//         ReqLine: Record "246";
//         PurchLine: Record "39";
//         ItemJnlLine: Record "83";
//         ProdOrderLine: Record "5406";
//         ProdOrderComp: Record "5407";
//         AssemblyHeader: Record "900";
//         AssemblyLine: Record "901";
//         TransLine: Record "5741";
//         ServLine: Record "5902";
//         JobJnlLine: Record "210";
//     begin
//         CASE "Source Type" OF
//           DATABASE::"Item Ledger Entry":
//             EXIT(ItemLedgEntry.TABLECAPTION);
//           DATABASE::"Sales Line":
//             EXIT(SalesLine.TABLECAPTION);
//           DATABASE::"Requisition Line":
//             EXIT(ReqLine.TABLECAPTION);
//           DATABASE::"Purchase Line":
//             EXIT(PurchLine.TABLECAPTION);
//           DATABASE::"Item Journal Line":
//             EXIT(ItemJnlLine.TABLECAPTION);
//           DATABASE::"Job Journal Line":
//             EXIT(JobJnlLine.TABLECAPTION);
//           DATABASE::"Prod. Order Line":
//             EXIT(ProdOrderLine.TABLECAPTION);
//           DATABASE::"Prod. Order Component":
//             EXIT(ProdOrderComp.TABLECAPTION);
//           DATABASE::"Assembly Header":
//             EXIT(AssemblyHeader.TABLECAPTION);
//           DATABASE::"Assembly Line":
//             EXIT(AssemblyLine.TABLECAPTION);
//           DATABASE::"Transfer Line":
//             EXIT(TransLine.TABLECAPTION);
//           DATABASE::"Service Line":
//             EXIT(ServLine.TABLECAPTION);
//           ELSE
//             EXIT(Text001);
//         END;
//     end;

//     procedure SummEntryNo(): Integer
//     begin
//         CASE "Source Type" OF
//           DATABASE::"Item Ledger Entry":
//             EXIT(1);
//           DATABASE::"Purchase Line":
//             EXIT(11 + "Source Subtype");
//           DATABASE::"Requisition Line":
//             EXIT(21);
//           DATABASE::"Sales Line":
//             EXIT(31 + "Source Subtype");
//           DATABASE::"Item Journal Line":
//             EXIT(41 + "Source Subtype");
//           DATABASE::"Job Journal Line":
//             EXIT(51 + "Source Subtype");
//           DATABASE::"Prod. Order Line":
//             EXIT(61 + "Source Subtype");
//           DATABASE::"Prod. Order Component":
//             EXIT(71 + "Source Subtype");
//           DATABASE::"Transfer Line":
//             EXIT(101 + "Source Subtype");
//           DATABASE::"Service Line":
//             EXIT(110);
//           DATABASE::"Assembly Header":
//             EXIT(141 + "Source Subtype");
//           DATABASE::"Assembly Line":
//             EXIT(151 + "Source Subtype");
//           ELSE
//             EXIT(0);
//         END;
//     end;

//     procedure SetPointer(RowID: Text[250])
//     var
//         ItemTrackingMgt: Codeunit "6500";
//         StrArray: array [6] of Text[100];
//     begin
//         ItemTrackingMgt.DecomposeRowID(RowID,StrArray);
//         EVALUATE("Source Type",StrArray[1]);
//         EVALUATE("Source Subtype",StrArray[2]);
//         "Source ID" := StrArray[3];
//         "Source Batch Name" := StrArray[4];
//         EVALUATE("Source Prod. Order Line",StrArray[5]);
//         EVALUATE("Source Ref. No.",StrArray[6]);
//     end;

//     procedure Lock()
//     var
//         Rec2: Record "337";
//     begin
//         Rec2.SETCURRENTKEY("Item No.");
//         IF "Item No." <> '' THEN
//           Rec2.SETRANGE("Item No.","Item No.");
//         Rec2.LOCKTABLE;
//         IF Rec2.FINDLAST THEN;
//     end;

//     procedure UpdateItemTracking()
//     var
//         ItemTrackingMgt: Codeunit "6500";
//     begin
//         "Item Tracking" := ItemTrackingMgt.ItemTrackingOption("Lot No.","Serial No.");
//     end;

//     procedure ClearItemTrackingFields()
//     begin
//         "Lot No." := '';
//         "Serial No." := '';
//         UpdateItemTracking;
//     end;

//     procedure FilterLinesWithItemToPlan(var Item: Record "27";IsReceipt: Boolean)
//     begin
//         RESET;
//         SETCURRENTKEY(
//           "Item No.","Variant Code","Location Code","Reservation Status","Shipment Date","Expected Receipt Date");
//         SETRANGE("Item No.",Item."No.");
//         SETFILTER("Variant Code",Item.GETFILTER("Variant Filter"));
//         SETFILTER("Location Code",Item.GETFILTER("Location Filter"));
//         SETRANGE("Reservation Status","Reservation Status"::Reservation);
//         SETFILTER(Binding,'<>%1',Binding::"Order-to-Order");
//         IF IsReceipt THEN
//           SETFILTER("Expected Receipt Date",Item.GETFILTER("Date Filter"))
//         ELSE
//           SETFILTER("Shipment Date",Item.GETFILTER("Date Filter"));
//         SETFILTER("Quantity (Base)",'<>0');
//     end;

//     procedure FindLinesWithItemToPlan(var Item: Record "27";IsReceipt: Boolean): Boolean
//     begin
//         FilterLinesWithItemToPlan(Item,IsReceipt);
//         EXIT(FIND('-'));
//     end;

//     procedure LinesWithItemToPlanExist(var Item: Record "27";IsReceipt: Boolean): Boolean
//     begin
//         FilterLinesWithItemToPlan(Item,IsReceipt);
//         EXIT(NOT ISEMPTY);
//     end;
// }

