// report 50016 "Generate Item Reclass Jnl"
// {
//     ProcessingOnly = true;

//     dataset
//     {
//         dataitem(DataItem1000000000;Table27)
//         {
//             RequestFilterFields = "No.","Base Unit of Measure","Item Category Code","Item Tracking Code";
//             dataitem(DataItem1000000001;Table5404)
//             {
//                 DataItemLink = Item No.=FIELD(No.);

//                 trigger OnAfterGetRecord()
//                 var
//                     lrILE: Record "32";
//                     lrIJL: Record "83";
//                     RemainingQty: Decimal;
//                     lrRE: Record "337";
//                 begin

//                     CLEAR(RemainingQty);
//                     lrILE.RESET;
//                     lrILE.SETCURRENTKEY("Item No.","Location Code",Open,"Variant Code","Unit of Measure Code","Lot No.","Serial No.");
//                     lrILE.SETRANGE("Item No.",Item."No.");
//                     lrILE.SETRANGE("Location Code",FromLocation);
//                     lrILE.SETRANGE(Open,TRUE);
//                     lrILE.SETRANGE("Unit of Measure Code",Code);
//                     IF FromDept <> '' THEN
//                       lrILE.SETRANGE("Global Dimension 1 Code",FromDept);
//                     IF lrILE.FINDFIRST THEN REPEAT
//                       RemainingQty := RemainingQty + lrILE."Remaining Quantity";
//                       UOMCode := lrILE."Unit of Measure Code";
//                     UNTIL lrILE.NEXT = 0;
//                     IF RemainingQty <> 0 THEN BEGIN
//                       //Insert Item Reclass Journal Line
//                       LineNo := LineNo + 10000;
//                       CLEAR(lrIJL);
//                       lrIJL."Journal Template Name" := 'TRANSFER';
//                       lrIJL."Journal Batch Name" := ItemJnlBatch;
//                       lrIJL."Line No." := LineNo;
//                       lrIJL.SetUpNewLine(lrIJLTemplate);
//                       lrIJL.INSERT;
//                       lrIJL.VALIDATE("Item No.",lrILE."Item No.");
//                       lrIJL.VALIDATE("Location Code",lrILE."Location Code");
//                       lrIJL.VALIDATE("Unit of Measure Code",Code);
//                       lrIJL.VALIDATE(Quantity,RemainingQty / "Qty. per Unit of Measure");
//                       lrIJL.VALIDATE("New Location Code",ToLocation);
//                       lrIJL.VALIDATE("Posting Date",PostingDate);
//                       lrIJL.MODIFY;
//                       IF ToDept <> '' THEN BEGIN
//                         lrIJL.VALIDATE("Shortcut Dimension 1 Code",FromDept);
//                         lrIJL.VALIDATE("New Shortcut Dimension 1 Code",ToDept);
//                         lrIJL.MODIFY;
//                       END;

//                       lrILE.RESET;
//                       lrILE.SETCURRENTKEY("Item No.","Location Code",Open,"Variant Code","Unit of Measure Code","Lot No.","Serial No.");
//                       lrILE.SETRANGE("Item No.",Item."No.");
//                       lrILE.SETRANGE("Location Code",FromLocation);
//                       lrILE.SETRANGE(Open,TRUE);
//                       lrILE.SETRANGE("Unit of Measure Code",Code);
//                       lrILE.SETFILTER("Lot No.",'<>%1','');
//                       IF FromDept <> '' THEN
//                         lrILE.SETRANGE("Global Dimension 1 Code",FromDept);
//                       IF lrILE.FINDFIRST THEN REPEAT
//                         //insert RE
//                         lrRE.RESET;
//                         lrRE.SETRANGE("Item No.",lrILE."Item No.");
//                         lrRE.SETRANGE("Source ID",'TRANSFER');
//                         lrRE.SETRANGE("Source Batch Name",ItemJnlBatch);
//                         lrRE.SETRANGE("Source Ref. No.", lrIJL."Line No.");
//                         lrRE.SETRANGE("Lot No.",lrILE."Lot No.");
//                         IF lrRE.FINDFIRST THEN BEGIN
//                           lrRE."Quantity (Base)" := lrRE."Quantity (Base)" -lrILE."Remaining Quantity";
//                           lrRE.Quantity := lrRE.Quantity -(lrILE."Remaining Quantity" / "Qty. per Unit of Measure");
//                           lrRE."Qty. to Handle (Base)" := lrRE."Qty. to Handle (Base)" -lrILE."Remaining Quantity";
//                           lrRE."Qty. to Invoice (Base)" := lrRE."Qty. to Invoice (Base)" -lrILE."Remaining Quantity";
//                           lrRE.MODIFY;
//                         END ELSE BEGIN
//                           REEntry := REEntry + 1;
//                           CLEAR(lrRE);
//                           lrRE."Entry No." := REEntry;
//                           lrRE."Item No." := lrILE."Item No.";
//                           lrRE."Location Code" := lrILE."Location Code";
//                           lrRE."Quantity (Base)" := -lrILE."Remaining Quantity";
//                           lrRE."Reservation Status" := lrRE."Reservation Status"::Prospect;
//                           lrRE."Creation Date" := TODAY;
//                           lrRE."Source Type" := 83;
//                           lrRE."Source Subtype" := 4;
//                           lrRE."Source ID" := 'TRANSFER';
//                           lrRE."Source Batch Name" := ItemJnlBatch;
//                           lrRE."Source Ref. No." := lrIJL."Line No.";
//                           lrRE."Shipment Date" := lrIJL."Posting Date";
//                           lrRE."Created By" := USERID;
//                           lrRE.Positive := FALSE;
//                           lrRE."Qty. per Unit of Measure" := "Qty. per Unit of Measure";
//                           lrRE.Quantity := -lrILE."Remaining Quantity" / "Qty. per Unit of Measure";
//                           lrRE."Planning Flexibility" := lrRE."Planning Flexibility"::Unlimited;
//                           lrRE."Qty. to Handle (Base)" := -lrILE."Remaining Quantity";
//                           lrRE."Qty. to Invoice (Base)" := -lrILE."Remaining Quantity";
//                           lrRE."New Lot No." := lrILE."Lot No.";
//                           lrRE."Lot No." := lrILE."Lot No.";
//                           lrRE."New Expiration Date" := lrILE."Expiration Date";
//                           lrRE."Item Tracking" := lrRE."Item Tracking"::"Lot No.";
//                           //lrRE."Appl.-to Item Entry" := lrILE."Entry No.";
//                           lrRE.INSERT;
//                         END;
//                         IF UOMCode <> lrILE."Unit of Measure Code" THEN
//                           ERROR('need to handle UOM, Item %1,',lrRE."Item No.");
//                       UNTIL lrILE.NEXT = 0;
//                     END;
//                 end;
//             }

//             trigger OnAfterGetRecord()
//             begin
//                 IF Item.Blocked THEN CurrReport.SKIP;
//             end;

//             trigger OnPreDataItem()
//             var
//                 rRE: Record "337";
//             begin
//                 lrIJLTemplate."Journal Template Name" := 'TRANSFER';
//                 lrIJLTemplate."Journal Batch Name" := ItemJnlBatch;
//                 recItemJnlBatch.GET('TRANSFER',ItemJnlBatch);
//                 lrIJLTemplate."Entry Type" := lrIJLTemplate."Entry Type"::Transfer;
//                 lrIJLTemplate."Posting Date" := PostingDate;
//                 lrIJLTemplate."Document No." := NoSeriesMgt.TryGetNextNo(recItemJnlBatch."No. Series",PostingDate);
//                 rRE.RESET;
//                 IF rRE.FINDLAST THEN
//                   REEntry := rRE."Entry No.";
//             end;
//         }
//     }

//     requestpage
//     {

//         layout
//         {
//             area(content)
//             {
//                 field(ItemJnlBatch;ItemJnlBatch)
//                 {
//                     Caption = 'Item Reclass Jnl. Batch';
//                     Editable = false;

//                     trigger OnLookup(var Text: Text): Boolean
//                     var
//                         rIJL: Record "83";
//                         ItemJnlMgt: Codeunit "240";
//                     begin
//                     end;
//                 }
//                 field(PostingDate;PostingDate)
//                 {
//                     Caption = 'Posting Date';
//                 }
//                 field(FromLocation;FromLocation)
//                 {
//                     Caption = 'From Location';
//                     TableRelation = Location.Code;
//                 }
//                 field(ToLocation;ToLocation)
//                 {
//                     Caption = 'To Location';
//                     TableRelation = Location.Code;
//                 }
//                 field("From Department";FromDept)
//                 {
//                     TableRelation = "Dimension Value".Code WHERE (Dimension Code=CONST(DEPT));
//                 }
//                 field("To Department";ToDept)
//                 {
//                     TableRelation = "Dimension Value".Code WHERE (Dimension Code=CONST(DEPT));
//                 }
//             }
//         }

//         actions
//         {
//         }
//     }

//     labels
//     {
//     }

//     trigger OnPreReport()
//     begin
//         IF FromLocation = '' THEN
//           ERROR('From Location Code cannot be blank');
//         IF ToLocation = '' THEN
//           ERROR('To Location Code cannot be blank');
//         IF PostingDate = 0D THEN
//           ERROR('Posting Date cannot be blank.');
//         IF ItemJnlBatch = '' THEN
//           ERROR('Item Reclass Journal Batch cannot be blank.');
//         IF (FromDept <> '') OR (ToDept <> '') THEN BEGIN
//           IF FromDept = ToDept THEN
//             ERROR('From Dept cannot be the same with To Dept');
//         END;
//     end;

//     var
//         FromLocation: Code[20];
//         ToLocation: Code[20];
//         PostingDate: Date;
//         ItemJnlBatch: Code[20];
//         LineNo: Integer;
//         lrIJLTemplate: Record "83";
//         NoSeriesMgt: Codeunit "396";
//         recItemJnlBatch: Record "233";
//         REEntry: Integer;
//         UOMCode: Code[10];
//         FromDept: Code[20];
//         ToDept: Code[20];

//     procedure SetParameter(parItemJnlBatch: Code[20])
//     begin
//         ItemJnlBatch :=  parItemJnlBatch;
//     end;
// }

