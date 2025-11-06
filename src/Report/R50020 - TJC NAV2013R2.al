// report 50020 "Block/Unblock Cust.-BatchJob"
// {
//     Caption = 'Block/Unblock Customer Card';
//     ProcessingOnly = true;

//     dataset
//     {
//         dataitem(DataItem1000000000;Table21)
//         {
//             DataItemTableView = SORTING(Customer No.,Posting Date,Currency Code)
//                                 WHERE(Customer No.=CONST(DONOTLOOP));
//             RequestFilterFields = "Customer No.";
//             RequestFilterHeading = 'Filters...';
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

//         trigger OnOpenPage()
//         begin
//             PostingDateFilter := TODAY();
//             //"Cust. Ledger Entry".SETFILTER("Posting Date", '%1', PostingDateFilter);
//             "Cust. Ledger Entry".SETFILTER("Date Filter", '%1', PostingDateFilter);
//         end;
//     }

//     labels
//     {
//     }

//     trigger OnInitReport()
//     begin
//         MaxDebtLength := 120;
//         MinRemainingInvoiceAmt := 0.01;
//         TotalRecBlocked := 0;
//         TotalRecUnBlocked := 0;
//     end;

//     trigger OnPostReport()
//     begin
//         SetCustomerOnOff;
//     end;

//     var
//         TempDoNotChangeCust: Record "18" temporary;
//         TempCustToBlock: Record "18" temporary;
//         TempCustToUnBlock: Record "18" temporary;
//         TotalRecBlocked: Integer;
//         TotalRecUnBlocked: Integer;
//         MaxDebtLength: Integer;
//         MinRemainingInvoiceAmt: Decimal;
//         ForceBlockText: Label 'FORCEBLOCK';
//         TotalUpdatedText: Label 'Total Blocked Customer Card: %1\Total Unblocked Customer Card: %2';
//         PostingDateFilter: Date;
//         MyCounter: Integer;
//         MyWin: Dialog;

//     procedure SetCustomerOnOff()
//     var
//         RecordModifiedText: Label 'Total %1 Customer Card updated.';
//     begin
//         TestPostingDateFilter;
//         MyWin.OPEN('Processing: #1########');
//         CollectToBlockCustomers;
//         CollectToUnBlockCustomers;
//         CollectDoNotChangeCustomers;
//         SwitchOFFCustomerBlockedField;
//         SwitchONCustomerBlockedField;
//         MyWin.CLOSE;
//         MESSAGE(TotalUpdatedText,TotalRecBlocked,TotalRecUnBlocked);
//     end;

//     procedure TestPostingDateFilter()
//     var
//         LDate: Record "2000000007";
//         LDateErrorText: Label 'E R R O R ! \Filter more than a single date is not allowed!';
//     begin
//         IF STRLEN("Cust. Ledger Entry".GETFILTER("Posting Date")) = 0 THEN
//           EXIT;

//         LDate.SETRANGE("Period Type",LDate."Period Type"::Date);
//         LDate.SETFILTER("Period Start","Cust. Ledger Entry".GETFILTER("Posting Date"));
//         IF LDate.COUNT > 1 THEN
//           ERROR(LDateErrorText);
//     end;

//     procedure CollectToBlockCustomers()
//     var
//         LCustLedgEntryQuery: Query "50000";
//         LUpperLimitDate: Date;
//     begin
//         TempCustToBlock.RESET;
//         IF NOT TempCustToBlock.ISEMPTY THEN
//             TempCustToBlock.DELETEALL;

//         IF STRLEN("Cust. Ledger Entry".GETFILTER("Customer No.")) > 0 THEN
//           LCustLedgEntryQuery.SETFILTER(CustLedgEntry_CustNo,"Cust. Ledger Entry".GETFILTER("Customer No."));

//         IF STRLEN("Cust. Ledger Entry".GETFILTER("Posting Date")) > 0 THEN BEGIN
//           EVALUATE(LUpperLimitDate,"Cust. Ledger Entry".GETFILTER("Posting Date"));
//           LUpperLimitDate := LUpperLimitDate - MaxDebtLength;
//         END ELSE
//           LUpperLimitDate := TODAY - MaxDebtLength;
//         LCustLedgEntryQuery.SETFILTER(CustLedgEntry_Posting_Date,'%1..%2',010100D,LUpperLimitDate);
//         LCustLedgEntryQuery.SETFILTER(CustLedgEntry_Remaining_Amt,'>%1',MinRemainingInvoiceAmt);

//         LCustLedgEntryQuery.OPEN;
//         WHILE LCustLedgEntryQuery.READ DO BEGIN
//           MyCounter += 1;
//           IF MyCounter MOD 10 = 0 THEN
//             MyWin.UPDATE(1,MyCounter);

//           IF NOT TempCustToBlock.GET(LCustLedgEntryQuery.CustLedgEntry_CustNo) THEN BEGIN
//             TempCustToBlock."No." := LCustLedgEntryQuery.CustLedgEntry_CustNo;
//             TempCustToBlock.INSERT;
//           END;
//         END;
//         LCustLedgEntryQuery.CLOSE;
//     end;

//     procedure CollectToUnBlockCustomers()
//     var
//         LCust: Record "18";
//     begin
//         TempCustToUnBlock.RESET;
//         IF NOT TempCustToUnBlock.ISEMPTY THEN
//             TempCustToUnBlock.DELETEALL;

//         TempCustToBlock.RESET;
//         LCust.RESET;
//         LCust.SETFILTER(Blocked,'<>%1',LCust.Blocked::" ");
//         IF NOT LCust.FINDSET THEN
//           EXIT;
//         REPEAT
//           MyCounter += 1;
//           IF MyCounter MOD 10 = 0 THEN
//             MyWin.UPDATE(1,MyCounter);

//           IF NOT TempCustToBlock.GET(LCust."No.") THEN BEGIN
//             IF NOT TempCustToUnBlock.GET(LCust."No.") THEN BEGIN
//               TempCustToUnBlock."No." := LCust."No.";
//               TempCustToUnBlock.INSERT;
//             END;
//           END;
//         UNTIL LCust.NEXT = 0;
//     end;

//     procedure CollectDoNotChangeCustomers()
//     var
//         LCust: Record "18";
//     begin
//         TempDoNotChangeCust.RESET;
//         IF NOT TempDoNotChangeCust.ISEMPTY THEN
//             TempDoNotChangeCust.DELETEALL;

//         LCust.RESET;
//         LCust.SETRANGE("Reminder Terms Code",ForceBlockText);
//         IF NOT LCust.FINDSET THEN
//           EXIT;
//         REPEAT
//           MyCounter += 1;
//           IF MyCounter MOD 10 = 0 THEN
//             MyWin.UPDATE(1,MyCounter);

//           IF NOT TempDoNotChangeCust.GET(LCust."No.") THEN BEGIN
//             TempDoNotChangeCust."No." := LCust."No.";
//             TempDoNotChangeCust.INSERT;
//           END;
//         UNTIL LCust.NEXT = 0;
//     end;

//     procedure SwitchOFFCustomerBlockedField()
//     var
//         LCust: Record "18";
//     begin
//         TempCustToUnBlock.RESET;
//         IF NOT TempCustToUnBlock.FIND('-') THEN
//           EXIT;

//         TempDoNotChangeCust.RESET;
//         REPEAT
//           MyCounter += 1;
//           IF MyCounter MOD 10 = 0 THEN
//             MyWin.UPDATE(1,MyCounter);

//           IF NOT TempDoNotChangeCust.GET(TempCustToUnBlock."No.") THEN BEGIN
//             LCust.GET(TempCustToUnBlock."No.");
//             IF LCust.Blocked <> LCust.Blocked::" " THEN BEGIN
//               LCust.Blocked := LCust.Blocked::" ";
//               LCust.MODIFY;
//               TotalRecUnBlocked += 1;
//             END;
//           END;
//         UNTIL TempCustToUnBlock.NEXT = 0;
//     end;

//     procedure SwitchONCustomerBlockedField()
//     var
//         LCust: Record "18";
//     begin
//         LCust.RESET;
//         TempCustToBlock.RESET;
//         TempCustToBlock.FIND('-');
//         REPEAT
//           MyCounter += 1;
//           IF MyCounter MOD 10 = 0 THEN
//             MyWin.UPDATE(1,MyCounter);

//           IF LCust.GET(TempCustToBlock."No.") THEN BEGIN
//             // ,Ship,Invoice,All
//             IF LCust.Blocked <> LCust.Blocked::Invoice THEN BEGIN
//               LCust.Blocked := LCust.Blocked::Invoice;
//               LCust.MODIFY;
//               TotalRecBlocked += 1;
//             END;
//           END;
//         UNTIL TempCustToBlock.NEXT = 0;
//     end;
// }

