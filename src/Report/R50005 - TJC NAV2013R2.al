// report 50005 "Create Transfer Lines"
// {
//     // TJCSG1.00
//     // NAV 2013 R2 Upgrade.
//     // Last Changes: 30/06/2014.
//     //  1. 27/01/2011  dpt.ds
//     //     - New report to create transfer lines from selected Item No.

//     ProcessingOnly = true;

//     dataset
//     {
//         dataitem(DataItem1000000000;Table27)
//         {
//             DataItemTableView = SORTING(No.);
//             RequestFilterFields = "No.","Item Category Code","Product Group Code";

//             trigger OnAfterGetRecord()
//             begin
//                 Counter += 1;
//                 IF Item.Blocked THEN
//                   CurrReport.SKIP;

//                 LineNo += 10000;

//                 TransferLine.RESET;
//                 TransferLine.INIT;
//                 TransferLine."Document No." := TrfOrderNo;
//                 TransferLine."Line No." := LineNo;
//                 TransferLine.INSERT(TRUE);

//                 TransferLine.VALIDATE("Item No.","No.");
//                 TransferLine.VALIDATE(Quantity,DefaultLineQty);
//                 TransferLine.MODIFY(TRUE);

//                 Window.UPDATE(1,TrfOrderNo);
//                 Window.UPDATE(2,"No.");
//                 Window.UPDATE(3,Description);
//                 Window.UPDATE(4,LineNo);
//                 Window.UPDATE(5,ROUND(Counter / TotalCounter * 10000,1));
//             end;

//             trigger OnPostDataItem()
//             begin
//                 Window.CLOSE;

//                 MESSAGE(
//                   TJC_Text010,
//                   Counter);
//             end;

//             trigger OnPreDataItem()
//             var
//                 LTransferLine: Record "5741";
//             begin
//                 Window.OPEN(
//                   TJC_Text000 +
//                   TJC_Text001 +
//                   TJC_Text002 +
//                   TJC_Text003 +
//                   TJC_Text004 +
//                   TJC_Text005);

//                 LineNo := 0;
//                 LTransferLine.SETRANGE("Document No.",TrfOrderNo);
//                 IF LTransferLine.FINDLAST THEN
//                   LineNo := LTransferLine."Line No.";

//                 TotalCounter := COUNT;
//             end;
//         }
//     }

//     requestpage
//     {

//         layout
//         {
//         }

//         actions
//         {
//         }
//     }

//     labels
//     {
//     }

//     var
//         TransferLine: Record "5741";
//         TrfOrderNo: Code[20];
//         Window: Dialog;
//         DefaultLineQty: Decimal;
//         Counter: Integer;
//         TotalCounter: Integer;
//         LineNo: Integer;
//         TJC_Text000: Label 'Creating... \';
//         TJC_Text001: Label 'Trf. Order No. #1#################### \';
//         TJC_Text002: Label 'Item No.       #2#################### \';
//         TJC_Text003: Label 'Description    #3############################## \';
//         TJC_Text004: Label 'Line No.       #4########## \';
//         TJC_Text005: Label '@5@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@';
//         TJC_Text007: Label 'Are you sure you wish to create Transfer Order Lines automatically?';
//         TJC_Text010: Label '%1 Transfer order lines have been created.';

//     procedure GetTransferOrderNo(pTrfOrderNo: Code[20])
//     begin
//         TrfOrderNo := pTrfOrderNo;
//     end;
// }

