// table 28090 "Post Dated Check Line"
// {
//     Caption = 'Post Dated Check Line';
//     LookupPageID = 28091;

//     fields
//     {
//         field(1;"Line Number";Integer)
//         {
//             AutoIncrement = false;
//             Caption = 'Line Number';
//             Editable = false;
//             //This property is currently not supported
//             //TestTableRelation = true;
//             //The property 'ValidateTableRelation' can only be set if the property 'TableRelation' is set
//             //ValidateTableRelation = true;
//         }
//         field(3;"Document No.";Code[20])
//         {
//             Caption = 'Document No.';
//         }
//         field(9;"Account Type";Option)
//         {
//             Caption = 'Account Type';
//             OptionCaption = ' ,Customer,Vendor,G/L Account';
//             OptionMembers = " ",Customer,Vendor,"G/L Account";
//         }
//         field(10;"Account No.";Code[20])
//         {
//             Caption = 'Account No.';
//             TableRelation = IF (Account Type=CONST(G/L Account)) "G/L Account"
//                             ELSE IF (Account Type=CONST(Customer)) Customer
//                             ELSE IF (Account Type=CONST(Vendor)) Vendor;

//             trigger OnValidate()
//             begin
//                 CASE "Account Type" OF
//                   "Account Type"::Customer:
//                     BEGIN
//                       Customer.GET("Account No.");
//                       Description := Customer.Name;
//                       SalesSetup.GET;
//                       // SalesSetup.TESTFIELD("Post Dated Check Batch");
//                       // SalesSetup.TESTFIELD("Post Dated Check Template");
//                       // "Batch Name":=SalesSetup."Post Dated Check Batch";
//                       // "Template Name" := SalesSetup."Post Dated Check Template";
//                       // JnlBatch.GET(SalesSetup."Post Dated Check Template",SalesSetup."Post Dated Check Batch");
//                       // JnlBatch.SETRANGE("Journal Template Name",SalesSetup."Post Dated Check Template");
//                       // JnlBatch.SETRANGE(Name,SalesSetup."Post Dated Check Batch");
//                      "Bank Account" := JnlBatch."Bal. Account No.";
//                     END;
//                   "Account Type"::Vendor:
//                     BEGIN
//                       Vendor.GET("Account No.");
//                       Description := Vendor.Name;
//                       PurchSetup.GET;
//                       /*
//                       PurchSetup.TESTFIELD("Post Dated Check Batch");
//                       PurchSetup.TESTFIELD("Post Dated Check Template");
//                       IF "Batch Name" = '' THEN
//                         "Batch Name" := PurchSetup."Post Dated Check Batch";
//                      "Template Name" := PurchSetup."Post Dated Check Template";
//                       JnlBatch.GET(PurchSetup."Post Dated Check Template",PurchSetup."Post Dated Check Batch");
//                       JnlBatch.SETRANGE("Journal Template Name",PurchSetup."Post Dated Check Template");
//                       JnlBatch.SETRANGE(Name,PurchSetup."Post Dated Check Batch");
//                       */
//                      "Bank Account" := JnlBatch."Bal. Account No.";
//                     END;
//                   "Account Type"::"G/L Account":
//                     BEGIN
//                       GLAccount.GET("Account No.");
//                       Description := GLAccount.Name;
//                     END;
//                 END;
//                 "Date Received" := WORKDATE;

//             end;
//         }
//         field(11;"Check Date";Date)
//         {
//             Caption = 'Check Date';

//             trigger OnValidate()
//             begin
//                 VALIDATE(Amount);
//             end;
//         }
//         field(12;"Check No.";Code[20])
//         {
//             Caption = 'Check No.';
//         }
//         field(17;"Currency Code";Code[20])
//         {
//             Caption = 'Currency Code';
//             TableRelation = Currency;

//             trigger OnValidate()
//             begin
//                 IF "Currency Code" <> '' THEN BEGIN
//                   IF ("Currency Code" <> xRec."Currency Code") OR
//                      ("Check Date" <> xRec."Check Date") OR
//                      (CurrFieldNo = FIELDNO("Currency Code")) OR
//                      ("Currency Factor" = 0)
//                   THEN
//                     "Currency Factor" :=
//                       CurrExchRate.ExchangeRate("Check Date","Currency Code");
//                 END ELSE
//                   "Currency Factor" := 0;
//                 VALIDATE("Currency Factor");
//             end;
//         }
//         field(18;"Currency Factor";Decimal)
//         {
//             Caption = 'Currency Factor';

//             trigger OnValidate()
//             begin
//                 IF ("Currency Code" = '') AND ("Currency Factor" <> 0) THEN
//                   FIELDERROR("Currency Factor",STRSUBSTNO(Text002,FIELDCAPTION("Currency Code")));
//                 VALIDATE(Amount);
//             end;
//         }
//         field(20;Description;Text[50])
//         {
//             Caption = 'Description';
//         }
//         field(21;"Date Received";Date)
//         {
//             Caption = 'Date Received';
//         }
//         field(22;Amount;Decimal)
//         {
//             Caption = 'Amount';

//             trigger OnValidate()
//             begin
//                 IF "Account Type" = "Account Type"::Customer THEN
//                   IF Amount > 0 THEN
//                     FIELDERROR(Amount,Text006);

//                 IF "Account Type" = "Account Type"::Vendor  THEN
//                   IF Amount < 0 THEN
//                     FIELDERROR(Amount,Text007);

//                 GetCurrency;
//                 IF "Currency Code" = '' THEN
//                   "Amount (LCY)" := Amount
//                 ELSE
//                   "Amount (LCY)" := ROUND(
//                     CurrExchRate.ExchangeAmtFCYToLCY(
//                       "Check Date","Currency Code",
//                       Amount,"Currency Factor"));

//                 Amount := ROUND(Amount,Currency."Amount Rounding Precision");
//             end;
//         }
//         field(23;"Amount (LCY)";Decimal)
//         {
//             Caption = 'Amount (LCY)';

//             trigger OnValidate()
//             begin
//                 IF "Account Type" = "Account Type"::Customer THEN
//                   IF Amount > 0 THEN
//                     FIELDERROR(Amount,Text006);

//                 IF "Account Type" = "Account Type"::Vendor  THEN
//                   IF Amount < 0 THEN
//                     FIELDERROR(Amount,Text007);

//                 TempAmount := "Amount (LCY)";
//                 VALIDATE("Currency Code",'');
//                 Amount := TempAmount;
//                 "Amount (LCY)" := TempAmount;
//             end;
//         }
//         field(24;"Date Filter";Date)
//         {
//             Caption = 'Date Filter';
//             FieldClass = FlowFilter;
//         }
//         field(30;"Bank Account";Code[20])
//         {
//             Caption = 'Bank Account';
//             TableRelation = IF (Account Type=CONST(Customer)) "Customer Bank Account".Code WHERE (Customer No.=FIELD(Account No.))
//                             ELSE IF (Account Type=CONST(Vendor)) "Bank Account".No.;
//         }
//         field(34;"Replacement Check";Boolean)
//         {
//             Caption = 'Replacement Check';
//         }
//         field(40;Comment;Text[90])
//         {
//             Caption = 'Comment';
//         }
//         field(41;"Batch Name";Code[10])
//         {
//             Caption = 'Batch Name';

//             trigger OnLookup()
//             begin
//                 /*
//                 CLEAR(JournalBatch);
//                 CASE "Account Type" OF
//                   "Account Type"::Customer:
//                   BEGIN
//                   SalesSetup.GET;
//                   JnlBatch.SETRANGE("Journal Template Name",SalesSetup."Post Dated Check Template");
//                   END;
//                   "Account Type"::Vendor:
//                   BEGIN
//                   PurchSetup.GET;
//                   JnlBatch.SETRANGE("Journal Template Name",PurchSetup."Post Dated Check Template");
//                   END;
//                 END;
//                 JournalBatch.SETTABLEVIEW(JnlBatch);
//                 JournalBatch.SETRECORD(JnlBatch);
//                 JournalBatch.LOOKUPMODE(TRUE);
//                 IF JournalBatch.RUNMODAL = ACTION::LookupOK THEN
//                   JournalBatch.GETRECORD(JnlBatch);
//                 "Batch Name":=JnlBatch.Name;
//                 "Template Name" := JnlBatch."Journal Template Name";
//                 "Bank Account" := JnlBatch."Bal. Account No.";
//                 */

//             end;
//         }
//         field(42;"Applies-to Doc. Type";Option)
//         {
//             Caption = 'Applies-to Doc. Type';
//             OptionCaption = ' ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund';
//             OptionMembers = " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund;
//         }
//         field(43;"Applies-to Doc. No.";Code[20])
//         {
//             Caption = 'Applies-to Doc. No.';

//             trigger OnLookup()
//             var
//                 GenJnlPostLine: Codeunit "12";
//                 PaymentToleranceMgt: Codeunit "426";
//             begin
//                 IF xRec."Line Number" = 0 THEN
//                   xRec.Amount := Amount;

//                 IF "Account Type" IN
//                   ["Account Type"::Customer]
//                 THEN BEGIN
//                   AccNo := "Account No.";
//                   AccType := AccType::Customer;
//                   CLEAR(CustLedgEntry);
//                 END;
//                 IF "Account Type" IN
//                   ["Account Type"::Vendor]
//                 THEN BEGIN
//                   AccNo := "Account No.";
//                   AccType := AccType::Vendor;
//                   CLEAR(VendLedgEntry);
//                 END;

//                 xRec."Currency Code" := "Currency Code";
//                 xRec."Check Date" := "Check Date";

//                 CASE AccType OF
//                   AccType::Customer:
//                     BEGIN
//                       CustLedgEntry.SETCURRENTKEY("Customer No.",Open,Positive,"Due Date");
//                       CustLedgEntry.SETRANGE("Customer No.",AccNo);
//                       CustLedgEntry.SETRANGE(Open,TRUE);
//                       IF "Applies-to Doc. No." <> '' THEN BEGIN
//                         CustLedgEntry.SETRANGE("Document Type","Applies-to Doc. Type");
//                         CustLedgEntry.SETRANGE("Document No.","Applies-to Doc. No.");
//                         IF NOT CustLedgEntry.FINDFIRST THEN BEGIN
//                           CustLedgEntry.SETRANGE("Document Type");
//                           CustLedgEntry.SETRANGE("Document No.");
//                         END;
//                       END;
//                       IF "Applies-to ID" <> '' THEN BEGIN
//                         CustLedgEntry.SETRANGE("Applies-to ID","Applies-to ID");
//                         IF NOT CustLedgEntry.FINDFIRST THEN
//                           CustLedgEntry.SETRANGE("Applies-to ID");
//                       END;
//                       IF "Applies-to Doc. Type" <> "Applies-to Doc. Type"::" " THEN BEGIN
//                         CustLedgEntry.SETRANGE("Document Type","Applies-to Doc. Type");
//                         IF NOT CustLedgEntry.FINDFIRST THEN
//                           CustLedgEntry.SETRANGE("Document Type");
//                       END;
//                       IF  "Applies-to Doc. No." <>''THEN BEGIN
//                         CustLedgEntry.SETRANGE("Document No.","Applies-to Doc. No.");
//                         IF NOT CustLedgEntry.FINDFIRST THEN
//                           CustLedgEntry.SETRANGE("Document No.");
//                       END;
//                       IF Amount <> 0 THEN BEGIN
//                         CustLedgEntry.SETRANGE(Positive,Amount < 0);
//                         IF CustLedgEntry.FINDFIRST THEN;
//                         CustLedgEntry.SETRANGE(Positive);
//                       END;
//                       SetGenJnlLine(Rec);
//                       /*
//                       ApplyCustEntries.SetGenJnlLine(GenJnlLine,GenJnlLine.FIELDNO(GenJnlLine."Applies-to Doc. No."));
//                       ApplyCustEntries.SETTABLEVIEW(CustLedgEntry);
//                       ApplyCustEntries.SETRECORD(CustLedgEntry);
//                       ApplyCustEntries.LOOKUPMODE(TRUE);
//                       IF ApplyCustEntries.RUNMODAL = ACTION::LookupOK THEN BEGIN
//                         ApplyCustEntries.GETRECORD(CustLedgEntry);
//                         CLEAR(ApplyCustEntries);
//                         IF "Currency Code" <> CustLedgEntry."Currency Code" THEN
//                           IF Amount = 0 THEN BEGIN
//                             FromCurrencyCode := GetShowCurrencyCode("Currency Code");
//                             ToCurrencyCode := GetShowCurrencyCode(CustLedgEntry."Currency Code");
//                             IF NOT
//                                CONFIRM(
//                                  Text003 +
//                                  Text004,TRUE,
//                                  FIELDCAPTION("Currency Code"),TABLECAPTION,FromCurrencyCode,
//                                  ToCurrencyCode)
//                             THEN
//                               ERROR(Text005);
//                             VALIDATE("Currency Code",CustLedgEntry."Currency Code");
//                           END ELSE
//                             GenJnlApply.CheckAgainstApplnCurrency(
//                               "Currency Code",CustLedgEntry."Currency Code",GenJnlLine."Account Type"::Customer,TRUE);
//                         IF Amount = 0 THEN BEGIN
//                           CustLedgEntry.CALCFIELDS("Remaining Amount");
//                           IF GenJnlPostLine.CheckCalcPmtDiscGenJnlCust(GenJnlLine,CustLedgEntry,0,FALSE)
//                           THEN
//                             Amount := (CustLedgEntry."Remaining Amount" -
//                               CustLedgEntry."Remaining Pmt. Disc. Possible")
//                           ELSE
//                             Amount := CustLedgEntry."Remaining Amount";
//                           IF "Account Type" IN
//                             ["Account Type"::Customer]
//                           THEN
//                             Amount := -Amount;
//                           VALIDATE(Amount);
//                         END;
//                         "Applies-to Doc. Type" := CustLedgEntry."Document Type";
//                         "Applies-to Doc. No." := CustLedgEntry."Document No.";
//                         "Applies-to ID" := '';
//                       END ELSE
//                         CLEAR(ApplyCustEntries);
//                       */
//                     END;
//                   AccType::Vendor:
//                     BEGIN
//                       VendLedgEntry.SETCURRENTKEY("Vendor No.",Open,Positive,"Due Date");
//                       VendLedgEntry.SETRANGE("Vendor No.",AccNo);
//                       VendLedgEntry.SETRANGE(Open,TRUE);
//                       IF "Applies-to Doc. No." <> '' THEN BEGIN
//                         VendLedgEntry.SETRANGE("Document Type","Applies-to Doc. Type");
//                         VendLedgEntry.SETRANGE("Document No.","Applies-to Doc. No.");
//                         IF NOT VendLedgEntry.FINDFIRST THEN BEGIN
//                           VendLedgEntry.SETRANGE("Document Type");
//                           VendLedgEntry.SETRANGE("Document No.");
//                         END;
//                       END;
//                       IF "Applies-to ID" <> '' THEN BEGIN
//                         VendLedgEntry.SETRANGE("Applies-to ID","Applies-to ID");
//                         IF NOT VendLedgEntry.FINDFIRST THEN
//                           VendLedgEntry.SETRANGE("Applies-to ID");
//                       END;
//                       IF "Applies-to Doc. Type" <> "Applies-to Doc. Type"::" " THEN BEGIN
//                         VendLedgEntry.SETRANGE("Document Type","Applies-to Doc. Type");
//                         IF NOT VendLedgEntry.FINDFIRST THEN
//                           VendLedgEntry.SETRANGE("Document Type");
//                       END;
//                       IF  "Applies-to Doc. No." <> ''THEN BEGIN
//                         VendLedgEntry.SETRANGE("Document No.","Applies-to Doc. No.");
//                         IF NOT VendLedgEntry.FINDFIRST THEN
//                           VendLedgEntry.SETRANGE("Document No.");
//                       END;
//                       IF Amount <> 0 THEN BEGIN
//                         VendLedgEntry.SETRANGE(Positive,Amount < 0);
//                         IF VendLedgEntry.FINDFIRST THEN;
//                         VendLedgEntry.SETRANGE(Positive);
//                       END;
//                       SetGenJnlLine(Rec);
//                       /*
//                       ApplyVendEntries.SetGenJnlLine(GenJnlLine,GenJnlLine.FIELDNO("Applies-to Doc. No."));
//                       ApplyVendEntries.SETTABLEVIEW(VendLedgEntry);
//                       ApplyVendEntries.SETRECORD(VendLedgEntry);
//                       ApplyVendEntries.LOOKUPMODE(TRUE);
//                       IF ApplyVendEntries.RUNMODAL = ACTION::LookupOK THEN BEGIN
//                         ApplyVendEntries.GETRECORD(VendLedgEntry);
//                         CLEAR(ApplyVendEntries);
//                         IF "Currency Code" <> VendLedgEntry."Currency Code" THEN
//                           IF Amount = 0 THEN BEGIN
//                             FromCurrencyCode := GetShowCurrencyCode("Currency Code");
//                             ToCurrencyCode := GetShowCurrencyCode(VendLedgEntry."Currency Code");
//                             IF NOT
//                                CONFIRM(
//                                  Text003 +
//                                  Text004,TRUE,
//                                  FIELDCAPTION("Currency Code"),TABLECAPTION,FromCurrencyCode,
//                                  ToCurrencyCode)
//                             THEN
//                               ERROR(Text005);
//                             VALIDATE("Currency Code",VendLedgEntry."Currency Code");
//                           END ELSE
//                             GenJnlApply.CheckAgainstApplnCurrency(
//                               "Currency Code",VendLedgEntry."Currency Code",GenJnlLine."Account Type"::Vendor,TRUE);
//                         IF Amount = 0 THEN BEGIN
//                           VendLedgEntry.CALCFIELDS("Remaining Amount");
//                           IF GenJnlPostLine.CheckCalcPmtDiscGenJnlVend(GenJnlLine,VendLedgEntry,0,FALSE)
//                           THEN
//                             Amount := -(VendLedgEntry."Remaining Amount" -
//                               VendLedgEntry."Remaining Pmt. Disc. Possible")
//                           ELSE
//                             Amount := -VendLedgEntry."Remaining Amount";
//                           VALIDATE(Amount);
//                         END;
//                         "Applies-to Doc. Type" := VendLedgEntry."Document Type";
//                         "Applies-to Doc. No." := VendLedgEntry."Document No.";
//                         "Applies-to ID" := '';
//                       END ELSE
//                         CLEAR(ApplyVendEntries);
//                       */
//                     END;

//                 END;

//             end;
//         }
//         field(48;"Applies-to ID";Code[20])
//         {
//             Caption = 'Applies-to ID';

//             trigger OnValidate()
//             begin
//                 IF ("Applies-to ID" <> xRec."Applies-to ID") AND (xRec."Applies-to ID" <> '') THEN
//                   ClearCustVendAppID;
//             end;
//         }
//         field(50;"Bank Payment Type";Option)
//         {
//             Caption = 'Bank Payment Type';
//             OptionCaption = ' ,Computer Check,Manual Check';
//             OptionMembers = " ","Computer Check","Manual Check";
//         }
//         field(51;"Check Printed";Boolean)
//         {
//             Caption = 'Check Printed';
//             Editable = false;
//         }
//         field(52;"Interest Amount";Decimal)
//         {
//             Caption = 'Interest Amount';

//             trigger OnValidate()
//             begin
//                 IF "Currency Code" = '' THEN
//                   "Interest Amount (LCY)" := "Interest Amount"
//                 ELSE
//                   "Interest Amount (LCY)" := ROUND(
//                     CurrExchRate.ExchangeAmtFCYToLCY(
//                       "Date Received","Currency Code",
//                       "Interest Amount","Currency Factor"));
//             end;
//         }
//         field(53;"Interest Amount (LCY)";Decimal)
//         {
//             Caption = 'Interest Amount (LCY)';
//         }
//         field(1500000;"Template Name";Code[20])
//         {
//             Caption = 'Template Name';
//         }
//     }

//     keys
//     {
//         key(Key1;"Template Name","Batch Name","Account Type","Account No.","Line Number")
//         {
//             SumIndexFields = "Amount (LCY)";
//         }
//         key(Key2;"Check Date")
//         {
//             SumIndexFields = "Amount (LCY)";
//         }
//         key(Key3;"Account No.")
//         {
//             SumIndexFields = "Amount (LCY)";
//         }
//         key(Key4;"Line Number")
//         {
//         }
//         key(Key5;"Account Type","Account No.")
//         {
//             SumIndexFields = "Amount (LCY)";
//         }
//     }

//     fieldgroups
//     {
//     }

//     trigger OnDelete()
//     begin
//         TESTFIELD("Check Printed",FALSE);
//         ClearCustVendAppID;
//         /*
//         DimMgt.DeleteJnlLineDim(
//           DATABASE::"Post Dated Check Line",
//           "Template Name","Batch Name","Line Number",0);
//         */

//     end;

//     trigger OnModify()
//     begin
//         TESTFIELD("Check Printed",FALSE);
//         IF ("Applies-to ID" = '') AND (xRec."Applies-to ID" <> '') THEN
//           ClearCustVendAppID;
//     end;

//     var
//         Customer: Record "18";
//         Vendor: Record "23";
//         CurrExchRate: Record "330";
//         CurrencyCode: Code[20];
//         Currency: Record "4";
//         GLAccount: Record "15";
//         GenJnlLine: Record "81";
//         PostDatedCheck: Record "28090";
//         JnlBatch: Record "232";
//         GenJnlApply: Codeunit "225";
//         CustEntrySetApplID: Codeunit "101";
//         VendEntrySetApplID: Codeunit "111";
//         TempAmount: Decimal;
//         AccNo: Code[20];
//         FromCurrencyCode: Code[10];
//         ToCurrencyCode: Code[10];
//         AccType: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset";
//         CustLedgEntry: Record "21";
//         SalesSetup: Record "311";
//         VendLedgEntry: Record "25";
//         PurchSetup: Record "312";
//         Text002: Label 'cannot be specified without %1';
//         Text009: Label 'LCY';
//         Text003: Label 'The %1 in the %2 will be changed from %3 to %4.\';
//         Text004: Label 'Do you wish to continue?';
//         Text005: Label 'The update has been interrupted to respect the warning.';
//         Text006: Label 'must be negative';
//         Text007: Label 'must be positive';
//         DimMgt: Codeunit "408";

//     local procedure GetCurrency()
//     begin
//         CurrencyCode := "Currency Code";

//         IF CurrencyCode = '' THEN BEGIN
//           CLEAR(Currency);
//           Currency.InitRoundingPrecision
//         END ELSE
//           IF CurrencyCode <> Currency.Code THEN BEGIN
//             Currency.GET(CurrencyCode);
//             Currency.TESTFIELD("Amount Rounding Precision");
//           END;
//     end;

//     procedure SetGenJnlLine(var PostDatedCheck: Record "28090")
//     begin
//         WITH PostDatedCheck DO BEGIN
//         GenJnlLine."Line No.":="Line Number";
//         GenJnlLine."Journal Batch Name":='Postdated';
//         IF "Account Type"="Account Type"::Customer THEN
//           GenJnlLine."Account Type":=GenJnlLine."Account Type"::Customer
//         ELSE
//         IF "Account Type"="Account Type"::Vendor THEN
//           GenJnlLine."Account Type":=GenJnlLine."Account Type"::Vendor
//         ELSE
//         IF "Account Type"="Account Type"::"G/L Account" THEN
//           GenJnlLine."Account Type":=GenJnlLine."Account Type"::"G/L Account";
//         GenJnlLine."Account No.":="Account No.";
//         GenJnlLine."Document No.":="Document No.";
//         GenJnlLine."Posting Date":="Check Date";
//         GenJnlLine.Amount:=Amount;
//         GenJnlLine."Document No.":="Document No.";
//         GenJnlLine.Description:=Description;
//         IF "Currency Code" = '' THEN
//           GenJnlLine."Amount (LCY)" := Amount
//         ELSE
//           GenJnlLine."Amount (LCY)" := ROUND(
//             CurrExchRate.ExchangeAmtFCYToLCY(
//               "Date Received","Currency Code",
//               Amount,"Currency Factor"));
//         GenJnlLine."Currency Code":="Currency Code";
//         GenJnlLine."Applies-to Doc. Type":="Applies-to Doc. Type";
//         GenJnlLine."Applies-to Doc. No.":="Applies-to Doc. No.";
//         GenJnlLine."Applies-to ID":="Applies-to ID";
//         GenJnlLine."Document Type":=GenJnlLine."Document Type"::Payment;
//         // GenJnlLine."Post Dated Check":=TRUE;
//         // GenJnlLine."Check No.":="Check No.";
//         GenJnlLine."Bal. Account Type":=GenJnlLine."Bal. Account Type"::"Bank Account";
//         GenJnlLine."Bal. Account No.":="Bank Account";
//         END;
//     end;

//     procedure ClearCustVendAppID()
//     var
//         TempCustLedgEntry: Record "21";
//         TempVendLedgEntry: Record "25";
//         CustEntryEdit: Codeunit "103";
//         VendEntryEdit: Codeunit "113";
//     begin
//         IF "Account Type"="Account Type"::Customer THEN
//           AccType := AccType ::Customer;
//         IF "Account Type"="Account Type"::"G/L Account" THEN
//           AccType := AccType ::"G/L Account";
//         IF "Account Type"="Account Type"::Vendor THEN
//           AccType := AccType ::Vendor;

//           AccNo := "Account No.";
//         CASE AccType OF
//           AccType::Customer:
//             IF Rec."Applies-to ID" <> '' THEN BEGIN
//               CustLedgEntry.SETCURRENTKEY("Customer No.","Applies-to ID",Open);
//               CustLedgEntry.SETRANGE("Customer No.",AccNo);
//               CustLedgEntry.SETRANGE("Applies-to ID",Rec."Applies-to ID");
//               CustLedgEntry.SETRANGE(Open,TRUE);
//               IF CustLedgEntry.FINDFIRST THEN BEGIN
//                 CustLedgEntry."Accepted Pmt. Disc. Tolerance" := FALSE;
//                 CustLedgEntry."Accepted Payment Tolerance" := 0;
//                 CustLedgEntry."Amount to Apply" := 0;
//                 // CustEntrySetApplID.SetApplId(CustLedgEntry,TempCustLedgEntry,0,0,'');
//             END;
//             END ELSE IF Rec."Applies-to Doc. No." <> '' THEN BEGIN
//               CustLedgEntry.SETCURRENTKEY("Document No.","Document Type","Customer No.");
//               CustLedgEntry.SETRANGE("Document No.",Rec."Applies-to Doc. No.");
//               CustLedgEntry.SETRANGE("Document Type",Rec."Applies-to Doc. Type");
//               CustLedgEntry.SETRANGE("Customer No.",AccNo);
//               CustLedgEntry.SETRANGE(Open,TRUE);
//               IF CustLedgEntry.FINDFIRST THEN BEGIN
//                 CustLedgEntry."Accepted Pmt. Disc. Tolerance" := FALSE;
//                 CustLedgEntry."Accepted Payment Tolerance" := 0;
//                 CustLedgEntry."Amount to Apply" := 0;
//                 CustEntryEdit.RUN(CustLedgEntry);
//               END;
//             END;
//           AccType::Vendor:
//             IF Rec."Applies-to ID" <> '' THEN BEGIN
//               VendLedgEntry.SETCURRENTKEY("Vendor No.","Applies-to ID",Open);
//               VendLedgEntry.SETRANGE("Vendor No.",AccNo);
//               VendLedgEntry.SETRANGE("Applies-to ID",Rec."Applies-to ID");
//               VendLedgEntry.SETRANGE(Open,TRUE);
//               IF VendLedgEntry.FINDFIRST THEN BEGIN
//                 VendLedgEntry."Accepted Pmt. Disc. Tolerance" := FALSE;
//                 VendLedgEntry."Accepted Payment Tolerance" := 0;
//                 VendLedgEntry."Amount to Apply" := 0;
//                 // VendEntrySetApplID.SetApplId(VendLedgEntry,TempVendLedgEntry,0,0,'');
//             END;
//             END ELSE IF Rec."Applies-to Doc. No." <> '' THEN BEGIN
//               VendLedgEntry.SETCURRENTKEY("Document No.","Document Type","Vendor No.");
//               VendLedgEntry.SETRANGE("Document No.",Rec."Applies-to Doc. No.");
//               VendLedgEntry.SETRANGE("Document Type",Rec."Applies-to Doc. Type");
//               VendLedgEntry.SETRANGE("Vendor No.",AccNo);
//               VendLedgEntry.SETRANGE(Open,TRUE);
//               IF VendLedgEntry.FINDFIRST THEN BEGIN
//                 VendLedgEntry."Accepted Pmt. Disc. Tolerance" := FALSE;
//                 VendLedgEntry."Accepted Payment Tolerance" := 0;
//                 VendLedgEntry."Amount to Apply" := 0;
//                 VendEntryEdit.RUN(VendLedgEntry);
//               END;
//             END;
//         END;
//     end;

//     procedure GetShowCurrencyCode(CurrencyCode: Code[10]): Code[10]
//     begin
//         IF CurrencyCode <> '' THEN
//           EXIT(CurrencyCode)
//         ELSE
//           EXIT(Text009);
//     end;
// }

