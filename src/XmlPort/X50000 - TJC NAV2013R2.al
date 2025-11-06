// xmlport 50000 "Import RMS"
// {
//     // TJCSG1.00
//     // Original History of Developments:
//     // 
//     // Version No.           : TJCRMS1.00
//     // Developer             : DP.SWJ
//     // Init. Dev Date        : 23/03/2009
//     // Date of last change   : 27/04/2009
//     // Description:
//     //   - Skips 3 top lines
//     //   - Needs to delete all lines before starting insert records
//     //   - Ticks Sales Header "Price Inclusive GST"
//     //   - Hardcodes Gen.Prod.Posting Group with conditions:
//     //     1. IF Inventory Value Zero = YES THEN TP828
//     //     2. IF Inventory Value Zero = NO THEN TP828-R
//     // 
//     // #1 Discount given is Line Discount Amount
//     // #2 DP.SWJ  01/07/2009
//     //    - If Gen. Product Posting Group of the item <> "CS" and <> "TP828"  then "TP828-R"
//     //      else remain same as Gen Product Posting Group.
//     // 
//     // 20100531 DP.RWP - Update Gen.Product Posting Group
//     // 
//     // NAV 2013 Upgrade.
//     //  1. 07/03/2014  dp.dst
//     //     - New XMLport converted from dataport 50000 "Import RMS".
//     //     - Needs to convert to XMLport as NAV 2013 does not support dataport.

//     Direction = Import;
//     Format = VariableText;
//     UseRequestPage = false;

//     schema
//     {
//         textelement(Root)
//         {
//             tableelement(Table2000000026;Table2000000026)
//             {
//                 XmlName = 'Table';
//                 UseTemporary = true;
//                 textelement(vItemNo)
//                 {
//                 }
//                 textelement(vQty)
//                 {
//                 }
//                 textelement(vUOM)
//                 {
//                 }
//                 textelement(vUnitPrice)
//                 {
//                 }
//                 textelement(vDiscPct)
//                 {
//                 }
//                 textelement(vDiscReasonCode)
//                 {
//                 }
//                 textelement(vReturnCode)
//                 {
//                 }
//                 textelement(vCashier)
//                 {
//                 }
//                 textelement(vDoctor)
//                 {
//                 }
//                 textelement(vLocation)
//                 {
//                 }

//                 trigger OnAfterInitRecord()
//                 begin
//                     i += 1;
//                     IF i <= 3 THEN
//                       currXMLport.SKIP;

//                     InitVariables;
//                 end;

//                 trigger OnBeforeInsertRecord()
//                 var
//                     LSalesLine: Record "37";
//                 begin
//                     Integer.Number := i;

//                     IF NOT Item.GET(vItemNo) THEN
//                       ERROR(TJCText001,vItemNo)
//                     ELSE BEGIN
//                       LineNo += 10000;
//                       LSalesLine.INIT;
//                       LSalesLine."Document Type" := DocType;
//                       LSalesLine."Document No." := DocNo;
//                       LSalesLine."Line No." := LineNo;

//                       LSalesLine.VALIDATE(Type,LSalesLine.Type::Item);
//                       LSalesLine.VALIDATE("No.",vItemNo);
//                       LSalesLine.VALIDATE("Location Code",vLocation);

//                       /*Start: DP.SWJ #2*/
//                       /*
//                       IF Item."Inventory Value Zero" THEN
//                         SalesLine.VALIDATE("Gen. Prod. Posting Group",'TP828')
//                       ELSE
//                         SalesLine.VALIDATE("Gen. Prod. Posting Group",'TP828-R');
//                       */

//                       //20100531
//                       /*
//                       IF (Item."Gen. Prod. Posting Group" <> 'CS') AND (Item."Gen. Prod. Posting Group" <> 'TP828') THEN
//                         SalesLine.VALIDATE("Gen. Prod. Posting Group",'TP828-R');
//                       */
//                       IF (Item."Gen. Prod. Posting Group" <> 'CS') AND (Item."Gen. Prod. Posting Group" <> 'OUTLET') THEN
//                         LSalesLine.VALIDATE("Gen. Prod. Posting Group",'OUTLET-R');

//                       //20100531 [
//                       /*End: DP.SWJ #2*/

//                       IF EVALUATE(Qty,vQty) THEN
//                         LSalesLine.VALIDATE(Quantity,Qty);
//                       LSalesLine.VALIDATE("Unit of Measure Code",vUOM);
//                       LSalesLine."Disc. Reason Code" := vDiscReasonCode;
//                       LSalesLine.VALIDATE("Return Reason Code",vReturnCode);
//                       LSalesLine."Cashier Code" := vCashier;
//                       LSalesLine."Doctor Code" := vDoctor;

//                       IF EVALUATE(UnitPrice,vUnitPrice) THEN
//                         LSalesLine.VALIDATE("Unit Price",UnitPrice);
//                       IF EVALUATE(DiscPct,vDiscPct) THEN
//                         LSalesLine.VALIDATE("Line Discount Amount",DiscPct);

//                       LSalesLine.INSERT(TRUE);
//                       TotRec +=1;
//                     END;

//                 end;
//             }
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

//     trigger OnPostXmlPort()
//     begin
//         MESSAGE('%1 records inserted successfully',TotRec);
//     end;

//     trigger OnPreXmlPort()
//     var
//         LSalesLine: Record "37";
//     begin
//         IF SalesHeader.GET(DocType,DocNo) THEN BEGIN
//           SalesHeader.VALIDATE("Prices Including VAT",TRUE);
//           SalesHeader.MODIFY;

//           LSalesLine.RESET;
//           LSalesLine.SETRANGE("Document Type",DocType);
//           LSalesLine.SETRANGE("Document No.",DocNo);
//           LSalesLine.DELETEALL;
//           // IF SalesLine.FINDFIRST THEN
//           //   SalesLine.DELETEALL;
//         END ELSE
//           ERROR(TJCText000,DocType,DocNo);

//         /*Start: TJCSG1.00 #1*/
//         // The following codes are unnecessary as Sales Line records have been emptied and Line No is always 0.
//         /*
//         LSalesLine.RESET;
//         LSalesLine.SETRANGE("Document Type",DocType);
//         LSalesLine.SETRANGE("Document No.",DocNo);
//         IF LSalesLine.FINDLAST THEN
//           LineNo := LSalesLine."Line No."
//         ELSE
//           CLEAR(LineNo);
//         */
//         LineNo := 0;
//         /*End: TJCSG1.00 #1*/

//         // Takes out 3 top lines
//         // Removed these from original development as it is not working in NAV 2013 R2.
//         /*
//         FOR i := 1 TO 3 DO BEGIN
//           REPEAT
//             CurrFile.READ(cha);
//           UNTIL cha = 10;
//         END;
//         */
//         i := 0;

//     end;

//     var
//         SalesHeader: Record "36";
//         SalesLine: Record "37";
//         Item: Record "27";
//         CurrFile: File;
//         DocNo: Code[20];
//         ItemNo: Code[20];
//         UOM: Code[10];
//         DiscReasonCode: Code[10];
//         ReturnCode: Code[10];
//         Cashier: Code[10];
//         Doctor: Code[10];
//         Location: Code[10];
//         GenProdPosting: Code[10];
//         cha: Char;
//         FileName: Text[256];
//         Qty: Decimal;
//         UnitPrice: Decimal;
//         DiscPct: Decimal;
//         i: Integer;
//         DocType: Integer;
//         LineNo: Integer;
//         TotRec: Integer;
//         TJCText000: Label 'Sales %1 Document No. %2 can not be found.';
//         TJCText001: Label 'Item No. %1 is not found. Please check.';

//     procedure SetDocumentNo(LDocNo: Code[20];LDocType: Integer)
//     begin
//         DocNo := LDocNo;
//         DocType := LDocType;
//     end;

//     procedure InitVariables()
//     begin
//         CLEAR(ItemNo);
//         CLEAR(Qty);
//         CLEAR(UOM);
//         CLEAR(UnitPrice);
//         CLEAR(DiscPct);
//         CLEAR(DiscReasonCode);
//         CLEAR(ReturnCode);
//         CLEAR(Cashier);
//         CLEAR(Doctor);
//         CLEAR(Location);
//     end;
// }

