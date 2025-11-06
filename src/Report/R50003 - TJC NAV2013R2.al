// report 50003 "DP Negative Stock Adjustment"
// {
//     ProcessingOnly = true;

//     dataset
//     {
//         dataitem(DataItem1000000000;Table27)
//         {
//             RequestFilterFields = "Inventory Posting Group","No.","Item Category Code";
//             dataitem(DataItem1000000001;Table32)
//             {
//                 DataItemLink = Item No.=FIELD(No.);
//                 DataItemTableView = SORTING(Item No.,Open,Variant Code,Positive,Location Code,Posting Date)
//                                     WHERE(Open=CONST(Yes),
//                                           Quantity=FILTER(>0));
//                 RequestFilterFields = "Location Code";

//                 trigger OnAfterGetRecord()
//                 begin
//                     //JournalTemplateName
//                     //JournalBatchName
//                     //DocumentNo

//                     //INSERT INTO Item journal line

//                     rIJL.RESET;
//                     rIJL.SETRANGE("Journal Template Name",JournalTemplateName);
//                     rIJL.SETRANGE("Journal Batch Name",JournalBatchName);
//                     IF rIJL.FINDLAST THEN
//                       IJLLineNo := rIJL."Line No." + 10000
//                     ELSE IJLLineNo := 10000;

//                     rRE.RESET;
//                     IF rRE.FINDLAST THEN
//                       RELineNo := rRE."Entry No." + 1
//                     ELSE RELineNo := 1;


//                     rIJL.RESET;
//                     rIJL.INIT;
//                     rIJL.VALIDATE("Journal Template Name",JournalTemplateName);
//                     rIJL.VALIDATE("Journal Batch Name",JournalBatchName);
//                     rIJL.VALIDATE("Line No.",IJLLineNo);
//                     IJLLineNo := IJLLineNo + 10000;
//                     rIJL.VALIDATE("Posting Date",vPostingDate);
//                     rIJL.VALIDATE("Entry Type",rIJL."Entry Type"::"Negative Adjmt.");
//                     rIJL.VALIDATE("Document No.",DocumentNo);
//                     rIJL.VALIDATE("Item No.",Item."No.");
//                     rIJL.VALIDATE("Location Code","Item Ledger Entry"."Location Code");
//                     rIJL.VALIDATE(Quantity,"Item Ledger Entry"."Remaining Quantity");
//                     rIJL.VALIDATE("Unit of Measure Code","Item Ledger Entry"."Unit of Measure Code");
//                     IF ("Item Ledger Entry"."Lot No." = '') THEN
//                       rIJL.VALIDATE("Applies-to Entry","Item Ledger Entry"."Entry No.");
//                     rIJL.INSERT;
//                     IF ("Item Ledger Entry"."Lot No." <> '') THEN BEGIN
//                       rRE.RESET; rRE.INIT;
//                       rRE."Entry No." := RELineNo;
//                       RELineNo := RELineNo + 1;
//                       rRE."Location Code" := "Item Ledger Entry"."Location Code";
//                       rRE.Positive := FALSE;
//                       rRE."Item Tracking" := rRE."Item Tracking"::"Lot No.";
//                       rRE."Item No." := Item."No.";
//                       rRE."Quantity (Base)" := - rIJL."Quantity (Base)";
//                       rRE."Reservation Status" := rRE."Reservation Status"::Prospect;
//                       rRE."Creation Date" := TODAY;
//                       rRE."Source Type" := 83;
//                       rRE."Source Subtype" := 3;
//                       rRE."Source ID" := rIJL."Journal Template Name";
//                       rRE."Source Batch Name" := rIJL."Journal Batch Name";
//                       rRE."Source Ref. No." := rIJL."Line No.";
//                       rRE."Shipment Date" := vPostingDate;
//                       rRE."Created By" := USERID;
//                       rRE."Qty. per Unit of Measure" := rIJL."Qty. per Unit of Measure";
//                       rRE.Quantity := -rIJL.Quantity;
//                       rRE."Qty. to Handle (Base)" := rRE."Quantity (Base)";
//                       rRE."Qty. to Invoice (Base)" := rRE."Quantity (Base)";
//                       rRE."Lot No." := "Item Ledger Entry"."Lot No.";
//                       rRE.VALIDATE("Appl.-to Item Entry","Item Ledger Entry"."Entry No.");
//                       rRE.INSERT;
//                     END;
//                 end;
//             }

//             trigger OnAfterGetRecord()
//             begin
//                 Item.CALCFIELDS(Inventory);
//                 IF Item.Inventory = 0 THEN CurrReport.SKIP;
//             end;

//             trigger OnPreDataItem()
//             begin
//                 IF (JournalTemplateName = '') OR
//                    (JournalBatchName = '') OR
//                    (DocumentNo = '')
//                 THEN ERROR('Please key in Journal Template Name, Journal Batch Name and Document No');
//             end;
//         }
//     }

//     requestpage
//     {

//         layout
//         {
//             area(content)
//             {
//                 field(DocumentNo;DocumentNo)
//                 {
//                     Caption = 'Document No.';
//                 }
//                 field(JournalTemplateName;JournalTemplateName)
//                 {
//                     Caption = 'Journal Template Name';
//                 }
//                 field(JournalBatchName;JournalBatchName)
//                 {
//                     Caption = 'Journal Batch Name';
//                 }
//                 field(vPostingDate;vPostingDate)
//                 {
//                     Caption = 'Posting Date';
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

//     trigger OnInitReport()
//     begin
//         JournalTemplateName := 'ITEM';
//         JournalBatchName := 'DEFAULT';
//     end;

//     trigger OnPostReport()
//     begin
//         MESSAGE('Done');
//     end;

//     var
//         JournalTemplateName: Code[20];
//         JournalBatchName: Code[20];
//         DocumentNo: Code[20];
//         rIJL: Record "83";
//         rRE: Record "337";
//         rIJL1: Record "83";
//         IJLLineNo: Integer;
//         RELineNo: Integer;
//         vPostingDate: Date;
// }

