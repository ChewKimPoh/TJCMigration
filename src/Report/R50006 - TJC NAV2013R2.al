// report 50006 "Create Sales Lines"
// {
//     // TJCSG1.00
//     // NAV 2013 R2 Upgrade.
//     // Last Changes: 30/06/2014.
//     //  1. 25/02/2011  dpt.ds
//     //     REF:DP-03266-FHY3S1
//     //     - New report to create sales lines from selected Item No.
//     //  2. 07/03/2011  dpt.ds
//     //     - Enhancements: Added Location Code that users can select from to generate the sales lines.

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

//                 SalesLine.RESET;
//                 SalesLine.SetHideValidationDialog(TRUE);

//                 SalesLine.INIT;
//                 SalesLine."Document Type" := DocType;
//                 SalesLine."Document No." := SalesOrderNo;
//                 SalesLine."Line No." := LineNo;
//                 SalesLine.INSERT(TRUE);

//                 SalesLine.VALIDATE(Type,SalesLine.Type::Item);
//                 SalesLine.VALIDATE("No.","No.");

//                 SalesLine.VALIDATE("Location Code",LocationCode);

//                 SalesLine.VALIDATE(Quantity,DefaultLineQty);
//                 SalesLine.MODIFY(TRUE);

//                 Window.UPDATE(1,SalesOrderNo);
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
//                 LSalesLine: Record "37";
//             begin
//                 Window.OPEN(
//                   TJC_Text000 +
//                   TJC_Text001 +
//                   TJC_Text002 +
//                   TJC_Text003 +
//                   TJC_Text004 +
//                   TJC_Text005);

//                 LineNo := 0;
//                 LSalesLine.SETRANGE("Document Type",DocType);
//                 LSalesLine.SETRANGE("Document No.",SalesOrderNo);
//                 IF LSalesLine.FINDLAST THEN
//                   LineNo := LSalesLine."Line No.";

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
//         SalesLine: Record "37";
//         SalesOrderNo: Code[20];
//         LocationCode: Code[10];
//         DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";
//         Window: Dialog;
//         DefaultLineQty: Decimal;
//         Counter: Integer;
//         TotalCounter: Integer;
//         LineNo: Integer;
//         TJC_Text000: Label 'Creating... \';
//         TJC_Text001: Label 'Sales Order No. #1#################### \';
//         TJC_Text002: Label 'Item No.        #2#################### \';
//         TJC_Text003: Label 'Description     #3############################## \';
//         TJC_Text004: Label 'Line No.        #4########## \';
//         TJC_Text005: Label '@5@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@';
//         TJC_Text007: Label 'Are you sure you wish to create Sales Order Lines automatically?';
//         TJC_Text010: Label '%1 sales order lines have been created.';

//     procedure GetSalesOrderNo(pDocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";pSalesOrderNo: Code[20])
//     begin
//         DocType := pDocumentType;
//         SalesOrderNo := pSalesOrderNo;
//     end;
// }

