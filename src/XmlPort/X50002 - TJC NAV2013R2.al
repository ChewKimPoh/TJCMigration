// xmlport 50002 "Import Sales Invoice Lines"
// {

//     schema
//     {
//         textelement(Root)
//         {
//             tableelement(Table2000000026;Table2000000026)
//             {
//                 XmlName = 'Table';
//                 UseTemporary = true;
//                 textelement(ItemNo)
//                 {
//                 }
//                 textelement(ItemDesc)
//                 {
//                 }
//                 textelement(Dummy1)
//                 {
//                 }
//                 textelement(Dummy2)
//                 {
//                 }
//                 textelement(ItemQty)
//                 {
//                 }

//                 trigger OnAfterInitRecord()
//                 begin
//                     i += 1;
//                     IF i <= 2 THEN
//                       currXMLport.SKIP;

//                     InitVariables;
//                 end;

//                 trigger OnBeforeInsertRecord()
//                 var
//                     LSalesLine: Record "37";
//                 begin
//                     Integer.Number := i;

//                     BinContent.RESET;
//                     BinContent.SETRANGE("Location Code",LocationCode);
//                     BinContent.SETRANGE("Bin Code",BinCode);
//                     BinContent.SETRANGE("Item No.",ItemNo);
//                     IF NOT BinContent.FINDSET THEN
//                       ERROR(TJCText002,
//                         ItemNo,LocationCode,BinCode);

//                     Counter += 1;
//                     LineNo += 10000;
//                     LSalesLine.INIT;
//                     LSalesLine."Document Type" := DocType;
//                     LSalesLine."Document No." := DocNo;
//                     LSalesLine."Line No." := LineNo;

//                     LSalesLine.VALIDATE(Type,LSalesLine.Type::Item);
//                     LSalesLine.VALIDATE("No.",ItemNo);
//                     LSalesLine.VALIDATE("Location Code",LocationCode);
//                     LSalesLine.VALIDATE("Bin Code",BinCode);

//                     IF EVALUATE(Qty,ItemQty) THEN
//                       IF Qty > 0 THEN
//                         LSalesLine.VALIDATE(Quantity,Qty);

//                     LSalesLine.INSERT(TRUE);
//                 end;
//             }
//         }
//     }

//     requestpage
//     {

//         layout
//         {
//             area(content)
//             {
//                 group(Options)
//                 {
//                     Caption = 'Options';
//                     field(BinCode;BinCode)
//                     {
//                         Caption = 'Bin Code';
//                     }
//                 }
//             }
//         }

//         actions
//         {
//         }
//     }

//     trigger OnPostXmlPort()
//     begin
//         MESSAGE(TJCText004,Counter);
//     end;

//     trigger OnPreXmlPort()
//     var
//         LSalesInvLine: Record "37";
//     begin
//         IF BinCode = '' THEN
//           ERROR(TJCText002);

//         Counter := 0;
//         LineNo := 0;
//         LSalesInvLine.RESET;
//         LSalesInvLine.SETRANGE("Document Type",DocType);
//         LSalesInvLine.SETRANGE("Document No.",DocNo);
//         IF LSalesInvLine.FINDLAST THEN
//           LineNo := LSalesInvLine."Line No.";
//     end;

//     var
//         Item: Record "27";
//         TJCText000: Label 'Sales %1 Document No. %2 can not be found.';
//         TJCText001: Label 'Item No. %1 is not found. Please check.';
//         SalesHeader: Record "36";
//         SalesLine: Record "37";
//         BinContent: Record "7302";
//         BinCode: Code[20];
//         DocNo: Code[20];
//         LocationCode: Code[10];
//         Qty: Decimal;
//         DocType: Integer;
//         LineNo: Integer;
//         i: Integer;
//         TJCText002: Label 'Bin Code cannot be blank. Please fill in the Bin Code.';
//         TJCText003: Label 'Item %1 cannot be found in Location %2 Bin Code %3.';
//         Counter: Integer;
//         TJCText004: Label 'Total of %1 records have been inserted to Sales Invoice Lines.';

//     procedure GetParams(pDocNo: Code[20];pDocType: Integer;pLocCode: Code[10])
//     begin
//         DocNo := pDocNo;
//         DocType := pDocType;
//         LocationCode := pLocCode;
//     end;

//     procedure InitVariables()
//     begin
//         CLEAR(ItemNo);
//         CLEAR(ItemDesc);
//         CLEAR(Dummy1);
//         CLEAR(Dummy2);
//         CLEAR(ItemQty);
//     end;
// }

