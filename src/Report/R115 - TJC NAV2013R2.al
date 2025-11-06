// report 116 Statement
// {
//     // STATEMENT REPORT - 116
//     // Version No.         : TJCSG1.00
//     // Developer           : DP.AYD
//     // Init. DEV. Date     : 07/05/2014
//     // Date of last Change : 15/07/2014
//     // Description         : Based on DD#114 https://dptech.mydonedone.com/issuetracker/projects/4350/issues/114
//     // 
//     // 1. 29/07/2014 DP.JL DD#114
//     //   - Alignment adjustment
//     // 2. 26/09/2014 DP.JL DD#219
//     //   - Fix page skipping issue.
//     // 3. 30/09/2014 DP.JL DD#256
//     //   - Hide the overdue footer section when "Show Overdue Entries" is not checked.
//     // 4. 09/06/2015 DP.NCM TJC DD 323
//     DefaultLayout = RDLC;
//     RDLCLayout = './Statement.rdlc';

//     Caption = 'Statement';
//     PreviewMode = PrintLayout;

//     dataset
//     {
//         dataitem(DataItem6836;Table18)
//         {
//             DataItemTableView = SORTING(No.);
//             PrintOnlyIfDetail = true;
//             RequestFilterFields = "No.","Search Name","Print Statements","Date Filter","Currency Filter";
//             column(Customer_No_;"No.")
//             {
//             }
//             column(IncludeAgingBand;IncludeAgingBand)
//             {
//             }
//             column(PrintEntriesDue;PrintEntriesDue)
//             {
//             }
//             column(SalespersonCode;"Salesperson Code")
//             {
//             }
//             dataitem(DataItem5444;Table2000000026)
//             {
//                 DataItemTableView = SORTING(Number)
//                                     WHERE(Number=CONST(1));
//                 PrintOnlyIfDetail = true;
//                 column(STRSUBSTNO_Text000_FORMAT_CurrReport_PAGENO__;STRSUBSTNO(Text000,FORMAT(CurrReport.PAGENO)))
//                 {
//                 }
//                 column(CustAddr_1_;CustAddr[1])
//                 {
//                 }
//                 column(CustAddr_2_;CustAddr[2])
//                 {
//                 }
//                 column(CustAddr_3_;CustAddr[3])
//                 {
//                 }
//                 column(CustAddr_4_;CustAddr[4])
//                 {
//                 }
//                 column(CustAddr_5_;CustAddr[5])
//                 {
//                 }
//                 column(CustAddr_6_;CustAddr[6])
//                 {
//                 }
//                 column(Customer__No__;Customer."No.")
//                 {
//                 }
//                 column(EndDate;EndDate)
//                 {
//                 }
//                 column(CustAddr_7_;CustAddr[7])
//                 {
//                 }
//                 column(CustAddr_8_;CustAddr[8])
//                 {
//                 }
//                 column(Integer_Number;Number)
//                 {
//                 }
//                 dataitem(CurrencyLoop;Table2000000026)
//                 {
//                     DataItemTableView = SORTING(Number)
//                                         WHERE(Number=FILTER(1..));
//                     PrintOnlyIfDetail = true;
//                     dataitem(CustLedgEntryHdr;Table2000000026)
//                     {
//                         DataItemTableView = SORTING(Number)
//                                             WHERE(Number=CONST(1));
//                         column(STRSUBSTNO_Text001_Currency2_Code_;STRSUBSTNO(Text001,Currency2.Code))
//                         {
//                         }
//                         column(StartBalance;StartBalance)
//                         {
//                             AutoFormatExpression = Currency2.Code;
//                             AutoFormatType = 1;
//                         }
//                         column(Balance_B_BCaption;Balance_B_BCaptionLbl)
//                         {
//                         }
//                         column(CustLedgEntryHdr_Number;Number)
//                         {
//                         }
//                         dataitem(DtldCustLedgEntries;Table379)
//                         {
//                             DataItemTableView = SORTING(Customer No.,Posting Date,Entry Type,Currency Code);
//                             column(EntryNo_DtldCustLedgEntries;DtldCustLedgEntries."Entry No.")
//                             {
//                             }
//                             column(CustLedgerEntryNo_DtldCustLedgEntries;DtldCustLedgEntries."Cust. Ledger Entry No.")
//                             {
//                             }
//                             column(CustBalance___Amount;CustBalance - Amount)
//                             {
//                                 AutoFormatExpression = "Currency Code";
//                                 AutoFormatType = 1;
//                             }
//                             column(DtldCustLedgEntries__Posting_Date_;"Posting Date")
//                             {
//                             }
//                             column(DtldCustLedgEntries__Document_No__;"Document No.")
//                             {
//                             }
//                             column(DtldCustLedgEntries__Currency_Code_;"Currency Code")
//                             {
//                             }
//                             column(CustBalance;CustBalance)
//                             {
//                                 AutoFormatExpression = "Currency Code";
//                                 AutoFormatType = 1;
//                             }
//                             column(DtldCustLedgEntries_DtldCustLedgEntries__Credit_Amount__LCY__;DtldCustLedgEntries."Credit Amount (LCY)")
//                             {
//                             }
//                             column(DtldCustLedgEntries_DtldCustLedgEntries__Debit_Amount__LCY__;DtldCustLedgEntries."Debit Amount (LCY)")
//                             {
//                             }
//                             column(CustBalance___Amount_Control75;CustBalance - Amount)
//                             {
//                                 AutoFormatExpression = "Currency Code";
//                                 AutoFormatType = 1;
//                             }
//                             column(CustBalance___AmountCaption;CustBalance___AmountCaptionLbl)
//                             {
//                             }
//                             column(CustBalance___Amount_Control75Caption;CustBalance___Amount_Control75CaptionLbl)
//                             {
//                             }
//                             column(DtldCustLedgEntries_Entry_No_;"Entry No.")
//                             {
//                             }

//                             trigger OnAfterGetRecord()
//                             begin
//                                 /*Start TJCSG1.00*/
//                                 //IF SkipReversedUnapplied(DtldCustLedgEntries) THEN
//                                 IF SkipReversedUnapplied(DtldCustLedgEntries) OR (Amount = 0) THEN
//                                 /*End TJCSG1.00*/
//                                   CurrReport.SKIP;
//                                 "Remaining Amount" := 0;
//                                 PrintLine := TRUE;
//                                 CASE "Entry Type" OF
//                                   "Entry Type"::"Initial Entry":
//                                      BEGIN
//                                       "Cust. Ledger Entry".GET("Cust. Ledger Entry No.");
//                                       Description := "Cust. Ledger Entry".Description;
//                                       "Due Date" := "Cust. Ledger Entry"."Due Date";
//                                       "Cust. Ledger Entry".SETRANGE("Date Filter",0D, EndDate);
//                                       "Cust. Ledger Entry".CALCFIELDS("Remaining Amount");
//                                       "Remaining Amount" := "Cust. Ledger Entry"."Remaining Amount";
//                                       "Cust. Ledger Entry".SETRANGE("Date Filter");
//                                     END;
//                                   "Entry Type"::Application:
//                                     BEGIN
//                                       DtldCustLedgEntries2.SETCURRENTKEY("Customer No.","Posting Date","Entry Type");
//                                       DtldCustLedgEntries2.SETRANGE("Customer No.","Customer No.");
//                                       DtldCustLedgEntries2.SETRANGE("Posting Date","Posting Date");
//                                       DtldCustLedgEntries2.SETRANGE("Entry Type","Entry Type"::Application);
//                                       DtldCustLedgEntries2.SETRANGE("Transaction No.","Transaction No.");
//                                       /*Start TJCSG1.00*/
//                                       //DtldCustLedgEntries2.SETFILTER("Currency Code",'<>%1',DtldCustLedgEntries."Currency Code");
//                                       //IF DtldCustLedgEntries2.FIND('-') THEN BEGIN
//                                       DtldCustLedgEntries2.SETFILTER("Currency Code",'<>%1',"Currency Code");
//                                       IF DtldCustLedgEntries2.FINDFIRST THEN BEGIN
//                                       /*End TJCSG1.00*/
//                                         Description := Text005;
//                                         "Due Date" := 0D;
//                                       END ELSE
//                                         PrintLine := FALSE;
//                                     END;
//                                   "Entry Type"::"Payment Discount",
//                                   "Entry Type"::"Payment Discount (VAT Excl.)",
//                                   "Entry Type"::"Payment Discount (VAT Adjustment)",
//                                   "Entry Type"::"Payment Discount Tolerance",
//                                   "Entry Type"::"Payment Discount Tolerance (VAT Excl.)",
//                                   "Entry Type"::"Payment Discount Tolerance (VAT Adjustment)":
//                                     BEGIN
//                                       Description := Text006;
//                                       "Due Date" := 0D;
//                                     END;
//                                   "Entry Type"::"Payment Tolerance",
//                                   "Entry Type"::"Payment Tolerance (VAT Excl.)",
//                                   "Entry Type"::"Payment Tolerance (VAT Adjustment)":
//                                     BEGIN
//                                       Description := Text014;
//                                       "Due Date" := 0D;
//                                     END;
//                                   "Entry Type"::"Appln. Rounding",
//                                   "Entry Type"::"Correction of Remaining Amount":
//                                     BEGIN
//                                       Description := Text007;
//                                       "Due Date" := 0D;
//                                     END;
//                                 END;

//                                 IF PrintLine THEN
//                                   CustBalance := CustBalance + Amount;

//                             end;

//                             trigger OnPreDataItem()
//                             begin
//                                 SETRANGE("Customer No.",Customer."No.");
//                                 SETRANGE("Posting Date",StartDate,EndDate);
//                                 SETRANGE("Currency Code",Currency2.Code);
//                                 /*TJCSG1.00*/ SETRANGE("Applied Cust. Ledger Entry No.",0);
//                                 IF Currency2.Code = '' THEN BEGIN
//                                   GLSetup.TESTFIELD("LCY Code");
//                                   CurrencyCode3 := GLSetup."LCY Code"
//                                 END ELSE
//                                   CurrencyCode3 := Currency2.Code;

//                             end;
//                         }
//                     }
//                     dataitem(CustLedgEntryFooter;Table2000000026)
//                     {
//                         DataItemTableView = SORTING(Number)
//                                             WHERE(Number=CONST(1));
//                         column(CurrencyCode3;CurrencyCode3)
//                         {
//                         }
//                         column(CustBalance_Control71;CustBalance)
//                         {
//                             AutoFormatExpression = Currency2.Code;
//                             AutoFormatType = 1;
//                         }
//                         column(CustBalance_Control71Caption;CustBalance_Control71CaptionLbl)
//                         {
//                         }
//                         column(CustLedgEntryFooter_Number;Number)
//                         {
//                         }
//                     }
//                     dataitem(CustLedgEntry2;Table21)
//                     {
//                         DataItemLink = Customer No.=FIELD(No.);
//                         DataItemLinkReference = Customer;
//                         DataItemTableView = SORTING(Customer No.,Open,Positive,Due Date);
//                         column(EntryNo_CustLedgEntry2;CustLedgEntry2."Entry No.")
//                         {
//                         }
//                         column(STRSUBSTNO_Text002_Currency2_Code_;STRSUBSTNO(Text002,Currency2.Code))
//                         {
//                         }
//                         column(CustLedgEntry2__Remaining_Amount_;"Remaining Amount")
//                         {
//                             AutoFormatExpression = "Currency Code";
//                             AutoFormatType = 1;
//                         }
//                         column(CustLedgEntry2__Posting_Date_;"Posting Date")
//                         {
//                         }
//                         column(CustLedgEntry2__Document_No__;"Document No.")
//                         {
//                         }
//                         column(CustLedgEntry2__Currency_Code_;"Currency Code")
//                         {
//                         }
//                         column(CustLedgEntry2_CustLedgEntry2__Original_Amt___LCY__;CustLedgEntry2."Original Amt. (LCY)")
//                         {
//                         }
//                         column(CustLedgEntry2_CustLedgEntry2__Remaining_Amt___LCY__;CustLedgEntry2."Remaining Amt. (LCY)")
//                         {
//                         }
//                         column(CustLedgEntry2__Remaining_Amount__Control64;"Remaining Amount")
//                         {
//                             AutoFormatExpression = "Currency Code";
//                             AutoFormatType = 1;
//                         }
//                         column(CustLedgEntry2__Remaining_Amount__Control66;"Remaining Amount")
//                         {
//                             AutoFormatExpression = "Currency Code" ;
//                             AutoFormatType = 1;
//                         }
//                         column(CurrencyCode3_Control73;CurrencyCode3)
//                         {
//                         }
//                         column(Original__Caption;Original__CaptionLbl)
//                         {
//                         }
//                         column(Remaining__Caption;Remaining__CaptionLbl)
//                         {
//                         }
//                         column(CustLedgEntry2__Remaining_Amount_Caption;CustLedgEntry2__Remaining_Amount_CaptionLbl)
//                         {
//                         }
//                         column(CustLedgEntry2__Remaining_Amount__Control64Caption;CustLedgEntry2__Remaining_Amount__Control64CaptionLbl)
//                         {
//                         }
//                         column(CustLedgEntry2__Remaining_Amount__Control66Caption;CustLedgEntry2__Remaining_Amount__Control66CaptionLbl)
//                         {
//                         }
//                         column(CustLedgEntry2_Entry_No_;"Entry No.")
//                         {
//                         }
//                         column(CustLedgEntry2_Customer_No_;"Customer No.")
//                         {
//                         }

//                         trigger OnAfterGetRecord()
//                         var
//                             CustLedgEntry: Record "21";
//                         begin
//                             IF IncludeAgingBand THEN
//                               IF ("Posting Date" > EndDate) AND ("Due Date" >= EndDate) THEN
//                                 CurrReport.SKIP;
//                             CustLedgEntry := CustLedgEntry2;
//                             CustLedgEntry.SETRANGE("Date Filter",0D,EndDate);
//                             CustLedgEntry.CALCFIELDS("Remaining Amount");
//                             "Remaining Amount" := CustLedgEntry."Remaining Amount";
//                             IF CustLedgEntry."Remaining Amount" = 0 THEN
//                               CurrReport.SKIP;

//                             IF IncludeAgingBand AND ("Posting Date" <= EndDate) THEN
//                               UpdateBuffer(Currency2.Code,GetDate("Posting Date","Due Date"),"Remaining Amount");
//                             IF ("Due Date" >= EndDate) OR  ("Remaining Amount" < 0) THEN
//                               CurrReport.SKIP;
//                         end;

//                         trigger OnPreDataItem()
//                         begin
//                             CurrReport.CREATETOTALS("Remaining Amount");
//                             IF NOT IncludeAgingBand THEN BEGIN
//                               SETRANGE("Due Date",0D,EndDate - 1);
//                               SETRANGE(Positive,TRUE);
//                             END;
//                             SETRANGE("Currency Code",Currency2.Code);
//                             IF (NOT PrintEntriesDue) AND (NOT IncludeAgingBand) THEN
//                               CurrReport.BREAK;
//                         end;
//                     }

//                     trigger OnAfterGetRecord()
//                     begin
//                         IF Number = 1 THEN
//                           Currency2.FIND('-')
//                         ELSE
//                           IF Currency2.NEXT = 0 THEN
//                             CurrReport.BREAK;

//                         Cust2 := Customer;
//                         Cust2.SETRANGE("Date Filter",0D,StartDate - 1);
//                         Cust2.SETRANGE("Currency Filter",Currency2.Code);
//                         Cust2.CALCFIELDS("Net Change");
//                         StartBalance := Cust2."Net Change";
//                         CustBalance := Cust2."Net Change";
//                         "Cust. Ledger Entry".SETCURRENTKEY("Customer No.","Posting Date","Currency Code");
//                         "Cust. Ledger Entry".SETRANGE("Customer No.",Customer."No.");
//                         "Cust. Ledger Entry".SETRANGE("Posting Date",StartDate,EndDate);
//                         "Cust. Ledger Entry".SETRANGE("Currency Code",Currency2.Code);
//                         /*Start TJCSG1.00*/
//                         EntriesExists := "Cust. Ledger Entry".FINDFIRST;
//                         //DP.NCM TJC DD 323
//                         //IF NOT EntriesExists THEN
//                         IF (NOT EntriesExists) AND (CustBalance = 0) THEN
//                         //DP.NCM TJC DD 323
//                           CurrReport.SKIP;
//                         /*End TJCSG1.00*/

//                     end;

//                     trigger OnPreDataItem()
//                     begin
//                         Customer.COPYFILTER("Currency Filter",Currency2.Code);
//                     end;
//                 }
//                 dataitem(AgingBandLoop;Table2000000026)
//                 {
//                     DataItemTableView = SORTING(Number)
//                                         WHERE(Number=FILTER(1..));
//                     column(AgingDate_1____1;AgingDate[1] + 1)
//                     {
//                     }
//                     column(AgingDate_2_;AgingDate[2])
//                     {
//                     }
//                     column(AgingDate_2_____1;AgingDate[2]  + 1)
//                     {
//                     }
//                     column(AgingDate_3_;AgingDate[3])
//                     {
//                     }
//                     column(AgingDate_3____1;AgingDate[3] + 1)
//                     {
//                     }
//                     column(AgingDate_4_;AgingDate[4])
//                     {
//                     }
//                     column(STRSUBSTNO_Text011_AgingBandEndingDate_PeriodLength_SELECTSTR_DateChoice___1_Text013__;STRSUBSTNO(Text011,AgingBandEndingDateText,PeriodLength,SELECTSTR(DateChoice + 1,Text013)))
//                     {
//                     }
//                     column(AgingDate_4____1;AgingDate[4] + 1)
//                     {
//                     }
//                     column(AgingDate_5_;AgingDate[5])
//                     {
//                     }
//                     column(AgingBandBuf__Column_1_Amt__;AgingBandBuf."Column 1 Amt.")
//                     {
//                         AutoFormatExpression = AgingBandBuf."Currency Code";
//                         AutoFormatType = 1;
//                     }
//                     column(AgingBandBuf__Column_2_Amt__;AgingBandBuf."Column 2 Amt.")
//                     {
//                         AutoFormatExpression = AgingBandBuf."Currency Code";
//                         AutoFormatType = 1;
//                     }
//                     column(AgingBandBuf__Column_3_Amt__;AgingBandBuf."Column 3 Amt.")
//                     {
//                         AutoFormatExpression = AgingBandBuf."Currency Code";
//                         AutoFormatType = 1;
//                     }
//                     column(AgingBandBuf__Column_4_Amt__;AgingBandBuf."Column 4 Amt.")
//                     {
//                         AutoFormatExpression = AgingBandBuf."Currency Code";
//                         AutoFormatType = 1;
//                     }
//                     column(AgingBandBuf__Column_5_Amt__;AgingBandBuf."Column 5 Amt.")
//                     {
//                         AutoFormatExpression = AgingBandBuf."Currency Code";
//                         AutoFormatType = 1;
//                     }
//                     column(AgingBandCurrencyCode;AgingBandCurrencyCode)
//                     {
//                     }
//                     column(beforeCaption;beforeCaptionLbl)
//                     {
//                     }
//                     column(AgingBandLoop_Number;Number)
//                     {
//                     }

//                     trigger OnAfterGetRecord()
//                     begin
//                         AgingBandEndingDateText:=FORMAT(AgingBandEndingDate,8,'<Day,2>-<Month,2>-<Year,2>');
//                         IF Number = 1 THEN BEGIN
//                           IF NOT AgingBandBuf.FIND('-') THEN
//                             CurrReport.BREAK;
//                         END ELSE
//                           IF AgingBandBuf.NEXT = 0 THEN
//                             CurrReport.BREAK;
//                         AgingBandCurrencyCode := AgingBandBuf."Currency Code";
//                         IF AgingBandCurrencyCode = '' THEN
//                           AgingBandCurrencyCode := GLSetup."LCY Code";
//                     end;

//                     trigger OnPreDataItem()
//                     begin
//                         IF NOT IncludeAgingBand THEN
//                           CurrReport.BREAK;
//                     end;
//                 }
//             }

//             trigger OnAfterGetRecord()
//             begin
//                 AgingBandBuf.DELETEALL;
//                 CurrReport.LANGUAGE := Language.GetLanguageID("Language Code");
//                 PrintLine := FALSE;
//                 Cust2 := Customer;
//                 COPYFILTER("Currency Filter",Currency2.Code);
//                 IF PrintAllHavingBal THEN BEGIN
//                   IF Currency2.FIND('-') THEN
//                     REPEAT
//                       Cust2.SETRANGE("Date Filter",0D,EndDate);
//                       Cust2.SETRANGE("Currency Filter",Currency2.Code);
//                       Cust2.CALCFIELDS("Net Change");
//                       PrintLine := Cust2."Net Change" <> 0;
//                     UNTIL (Currency2.NEXT = 0) OR PrintLine;
//                 END;
//                 IF (NOT PrintLine) AND PrintAllHavingEntry THEN BEGIN
//                   "Cust. Ledger Entry".RESET;
//                   "Cust. Ledger Entry".SETCURRENTKEY("Customer No.","Posting Date");
//                   "Cust. Ledger Entry".SETRANGE("Customer No.",Customer."No.");
//                   "Cust. Ledger Entry".SETRANGE("Posting Date",StartDate,EndDate);
//                   Customer.COPYFILTER("Currency Filter","Cust. Ledger Entry"."Currency Code");
//                   PrintLine := "Cust. Ledger Entry".FIND('-');
//                 END;
//                 IF NOT PrintLine THEN
//                   CurrReport.SKIP;

//                 FormatAddr.Customer(CustAddr,Customer);
//                 CurrReport.PAGENO := 1;
//                 /*
//                 IF NOT CurrReport.PREVIEW THEN BEGIN
//                   Customer.LOCKTABLE;
//                   Customer.FIND;
//                   Customer."Last Statement No." := Customer."Last Statement No." + 1;
//                   Customer.MODIFY;
//                   COMMIT;
//                 END ELSE
//                   Customer."Last Statement No." := Customer."Last Statement No." + 1;

//                 IF LogInteraction THEN
//                   IF NOT CurrReport.PREVIEW THEN
//                     SegManagement.LogDocument(
//                       7,FORMAT(Customer."Last Statement No."),0,0,DATABASE::Customer,"No.","Salesperson Code",'',
//                       Text003+FORMAT(Customer."Last Statement No."),'');
//                 */

//             end;

//             trigger OnPreDataItem()
//             begin
//                 StartDate := GETRANGEMIN("Date Filter");
//                 EndDate := GETRANGEMAX("Date Filter");
//                 AgingBandEndingDate := EndDate;
//                 CalcAgingBandDates;

//                 CompanyInfo.GET;
//                 FormatAddr.Company(CompanyAddr,CompanyInfo);

//                 Currency2.Code := '';
//                 Currency2.INSERT;
//                 COPYFILTER("Currency Filter",Currency.Code);
//                 IF Currency.FIND('-') THEN
//                   REPEAT
//                     Currency2 := Currency;
//                     Currency2.INSERT;
//                   UNTIL Currency.NEXT = 0;
//             end;
//         }
//     }

//     requestpage
//     {
//         SaveValues = true;

//         layout
//         {
//             area(content)
//             {
//                 group(Options)
//                 {
//                     Caption = 'Options';
//                     field(ShowOverdueEntries;PrintEntriesDue)
//                     {
//                         Caption = 'Show Overdue Entries';
//                     }
//                     field(IncludeAllCustomerswithLE;PrintAllHavingEntry)
//                     {
//                         Caption = 'Include All Customers with Ledger Entries';
//                         MultiLine = true;

//                         trigger OnValidate()
//                         begin
//                             IF NOT PrintAllHavingEntry THEN
//                               PrintAllHavingBal := TRUE;
//                         end;
//                     }
//                     field(IncludeAllCustomerswithBalance;PrintAllHavingBal)
//                     {
//                         Caption = 'Include All Customers with a Balance';
//                         MultiLine = true;

//                         trigger OnValidate()
//                         begin
//                             IF NOT PrintAllHavingBal THEN
//                               PrintAllHavingEntry := TRUE;
//                         end;
//                     }
//                     field(IncludeReversedEntries;PrintReversedEntries)
//                     {
//                         Caption = 'Include Reversed Entries';
//                     }
//                     field(IncludeUnappliedEntries;PrintUnappliedEntries)
//                     {
//                         Caption = 'Include Unapplied Entries';
//                     }
//                     field(IncludeAgingBand;IncludeAgingBand)
//                     {
//                         Caption = 'Include Aging Band';
//                     }
//                     field(AgingBandPeriodLengt;PeriodLength)
//                     {
//                         Caption = 'Aging Band Period Length';
//                     }
//                     field(AgingBandby;DateChoice)
//                     {
//                         Caption = 'Aging Band by';
//                         OptionCaption = 'Due Date,Posting Date';
//                     }
//                     field(LogInteraction;LogInteraction)
//                     {
//                         Caption = 'Log Interaction';
//                         Enabled = LogInteractionEnable;
//                         Visible = false;
//                     }
//                 }
//             }
//         }

//         actions
//         {
//         }

//         trigger OnOpenPage()
//         begin
//             InitRequestPageDataInternal;
//         end;
//     }

//     labels
//     {
//     }

//     trigger OnInitReport()
//     begin
//         GLSetup.GET;
//     end;

//     var
//         Text000: Label 'Page %1';
//         Text001: Label 'Entries %1';
//         Text002: Label 'Overdue Entries %1';
//         Text003: Label 'Statement ';
//         GLSetup: Record "98";
//         CompanyInfo: Record "79";
//         Cust2: Record "18";
//         Currency: Record "4";
//         Currency2: Record "4" temporary;
//         Language: Record "8";
//         "Cust. Ledger Entry": Record "21";
//         DtldCustLedgEntries2: Record "379";
//         AgingBandBuf: Record "47" temporary;
//         PrintAllHavingEntry: Boolean;
//         PrintAllHavingBal: Boolean;
//         PrintEntriesDue: Boolean;
//         PrintUnappliedEntries: Boolean;
//         PrintReversedEntries: Boolean;
//         PrintLine: Boolean;
//         LogInteraction: Boolean;
//         EntriesExists: Boolean;
//         StartDate: Date;
//         EndDate: Date;
//         "Due Date": Date;
//         CustAddr: array [8] of Text[50];
//         CompanyAddr: array [8] of Text[50];
//         Description: Text[50];
//         StartBalance: Decimal;
//         CustBalance: Decimal;
//         "Remaining Amount": Decimal;
//         FormatAddr: Codeunit "365";
//         SegManagement: Codeunit "5051";
//         CurrencyCode3: Code[10];
//         Text005: Label 'Multicurrency Application';
//         Text006: Label 'Payment Discount';
//         Text007: Label 'Rounding';
//         PeriodLength: DateFormula;
//         PeriodLength2: DateFormula;
//         DateChoice: Option "Due Date","Posting Date";
//         AgingDate: array [5] of Date;
//         Text008: Label 'You must specify the Aging Band Period Length.';
//         AgingBandEndingDate: Date;
//         Text010: Label 'You must specify Aging Band Ending Date.';
//         Text011: Label 'Aged Summary by %1 (%2 by %3)';
//         IncludeAgingBand: Boolean;
//         Text012: Label 'Period Length is out of range.';
//         AgingBandCurrencyCode: Code[10];
//         Text013: Label 'Due Date,Posting Date';
//         Text014: Label 'Application Writeoffs';
//         Balance_B_BCaptionLbl: Label 'Balance B/B';
//         CustBalance___AmountCaptionLbl: Label 'Continued';
//         CustBalance___Amount_Control75CaptionLbl: Label 'Continued';
//         CustBalance_Control71CaptionLbl: Label 'Total';
//         Original__CaptionLbl: Label 'Original $';
//         Remaining__CaptionLbl: Label 'Remaining $';
//         CustLedgEntry2__Remaining_Amount_CaptionLbl: Label 'Continued';
//         CustLedgEntry2__Remaining_Amount__Control64CaptionLbl: Label 'Continued';
//         CustLedgEntry2__Remaining_Amount__Control66CaptionLbl: Label 'Total';
//         beforeCaptionLbl: Label '..before';
//         [InDataSet]
//         LogInteractionEnable: Boolean;
//         isInitialized: Boolean;
//         AgingBandEndingDateText: Text;

//     local procedure GetDate(PostingDate: Date;DueDate: Date): Date
//     begin
//         IF DateChoice = DateChoice::"Posting Date" THEN
//           EXIT(PostingDate)
//         ELSE
//           EXIT(DueDate);
//     end;

//     local procedure CalcAgingBandDates()
//     begin
//         IF NOT IncludeAgingBand THEN
//           EXIT;
//         IF AgingBandEndingDate = 0D THEN
//           ERROR(Text010);
//         IF FORMAT(PeriodLength) = '' THEN
//           ERROR(Text008);
//         EVALUATE(PeriodLength2,'-' + FORMAT(PeriodLength));
//         AgingDate[5] := AgingBandEndingDate;
//         AgingDate[4] := CALCDATE(PeriodLength2,AgingDate[5]);
//         AgingDate[3] := CALCDATE(PeriodLength2,AgingDate[4]);
//         AgingDate[2] := CALCDATE(PeriodLength2,AgingDate[3]);
//         AgingDate[1] := CALCDATE(PeriodLength2,AgingDate[2]);
//         IF AgingDate[2] <= AgingDate[1] THEN
//           ERROR(Text012);
//     end;

//     local procedure UpdateBuffer(CurrencyCode: Code[10];Date: Date;Amount: Decimal)
//     var
//         I: Integer;
//         GoOn: Boolean;
//     begin
//         AgingBandBuf.INIT;
//         AgingBandBuf."Currency Code" := CurrencyCode;
//         IF NOT AgingBandBuf.FIND THEN
//           AgingBandBuf.INSERT;
//         I := 1;
//         GoOn := TRUE;
//         WHILE (I <= 5) AND GoOn DO BEGIN
//           IF Date <= AgingDate[I] THEN
//             IF I = 1 THEN BEGIN
//               AgingBandBuf."Column 1 Amt." := AgingBandBuf."Column 1 Amt." + Amount;
//               GoOn := FALSE;
//             END;
//           IF Date <= AgingDate[I] THEN
//             IF I = 2 THEN BEGIN
//               AgingBandBuf."Column 2 Amt." := AgingBandBuf."Column 2 Amt." + Amount;
//               GoOn := FALSE;
//             END;
//           IF Date <= AgingDate[I] THEN
//             IF I = 3 THEN BEGIN
//               AgingBandBuf."Column 3 Amt." := AgingBandBuf."Column 3 Amt." + Amount;
//               GoOn := FALSE;
//             END;
//           IF Date <= AgingDate[I] THEN
//             IF I = 4 THEN BEGIN
//               AgingBandBuf."Column 4 Amt." := AgingBandBuf."Column 4 Amt." + Amount;
//               GoOn := FALSE;
//             END;
//           IF Date <= AgingDate[I] THEN
//             IF I = 5 THEN BEGIN
//               AgingBandBuf."Column 5 Amt." := AgingBandBuf."Column 5 Amt." + Amount;
//               GoOn := FALSE;
//             END;
//           I := I + 1;
//         END;
//         AgingBandBuf.MODIFY;
//     end;

//     procedure SkipReversedUnapplied(var DtldCustLedgEntries: Record "379"): Boolean
//     var
//         CustLedgEntry: Record "21";
//     begin
//         IF PrintReversedEntries AND PrintUnappliedEntries THEN
//           EXIT(FALSE);
//         IF NOT PrintUnappliedEntries THEN
//           IF DtldCustLedgEntries.Unapplied THEN
//             EXIT(TRUE);
//         IF NOT PrintReversedEntries THEN BEGIN
//           CustLedgEntry.GET(DtldCustLedgEntries."Cust. Ledger Entry No.");
//           IF CustLedgEntry.Reversed THEN
//             EXIT(TRUE);
//         END;
//         EXIT(FALSE);
//     end;

//     procedure InitializeRequest(NewPrintEntriesDue: Boolean;NewPrintAllHavingEntry: Boolean;NewPrintAllHavingBal: Boolean;NewPrintReversedEntries: Boolean;NewPrintUnappliedEntries: Boolean;NewIncludeAgingBand: Boolean;NewPeriodLength: Text[30];NewDateChoice: Option;NewLogInteraction: Boolean)
//     begin
//         InitRequestPageDataInternal;

//         PrintEntriesDue := NewPrintEntriesDue;
//         PrintAllHavingEntry := NewPrintAllHavingEntry;
//         PrintAllHavingBal := NewPrintAllHavingBal;
//         PrintReversedEntries := NewPrintReversedEntries;
//         PrintUnappliedEntries := NewPrintUnappliedEntries;
//         IncludeAgingBand := NewIncludeAgingBand;
//         EVALUATE(PeriodLength,NewPeriodLength);
//         DateChoice := NewDateChoice;
//         LogInteraction := NewLogInteraction;
//     end;

//     procedure InitRequestPageDataInternal()
//     begin
//         IF isInitialized THEN
//           EXIT;

//         isInitialized := TRUE;

//         IF (NOT PrintAllHavingEntry) AND (NOT PrintAllHavingBal) THEN
//           PrintAllHavingBal := TRUE;

//         LogInteraction := SegManagement.FindInteractTmplCode(7) <> '';
//         LogInteractionEnable := LogInteraction;

//         IF FORMAT(PeriodLength) = '' THEN
//           EVALUATE(PeriodLength,'<1M+CM>');
//     end;
// }