// report 129 "Customer - Trial Balance"
// {
//     // Customer - Trial Balance - 129
//     // Version No.         : TJCSG1.00
//     // Developer           : DP.AYD
//     // Init. DEV. Date     : 28/05/2014
//     // Date of last Change : 2/06/2014
//     // Description         : Based on DD#116 https://dptech.mydonedone.com/issuetracker/projects/4350/issues/116
//     // 
//     // 1. Remove balance =0
//     DefaultLayout = RDLC;
//     RDLCLayout = './Customer - Trial Balance.rdlc';

//     Caption = 'Customer - Trial Balance';

//     dataset
//     {
//         dataitem(DataItem6836;Table18)
//         {
//             DataItemTableView = SORTING(Customer Posting Group);
//             RequestFilterFields = "No.","Date Filter","Customer Posting Group";
//             column(COMPANYNAME;COMPANYNAME)
//             {
//             }
//             column(STRSUBSTNO_Text003_PeriodFilter_;STRSUBSTNO(Text003,PeriodFilter))
//             {
//             }
//             column(FORMAT_TODAY_0_4_;FORMAT(TODAY,0,4))
//             {
//             }
//             column(USERID;USERID)
//             {
//             }
//             column(CurrReport_PAGENO;CurrReport.PAGENO)
//             {
//             }
//             column(STRSUBSTNO_Text005_Customer_FIELDCAPTION__Customer_Posting_Group___;STRSUBSTNO(Text005,Customer.FIELDCAPTION("Customer Posting Group")))
//             {
//             }
//             column(Customer_TABLECAPTION__________CustFilter;Customer.TABLECAPTION + ': ' + CustFilter)
//             {
//             }
//             column(EmptyString;'')
//             {
//             }
//             column(EmptyString_Control36;'')
//             {
//             }
//             column(PeriodStartDate;PeriodStartDate)
//             {
//             }
//             column(PeriodFilter;PeriodFilter)
//             {
//             }
//             column(FiscalYearStartDate;FiscalYearStartDate)
//             {
//             }
//             column(FiscalYearFilter;FiscalYearFilter)
//             {
//             }
//             column(PeriodEndDate;PeriodEndDate)
//             {
//             }
//             column(Customer__Customer_Posting_Group_;"Customer Posting Group")
//             {
//             }
//             column(YTDTotal;YTDTotal)
//             {
//                 AutoFormatType = 1;
//             }
//             column(YTDCreditAmt;YTDCreditAmt)
//             {
//                 AutoFormatType = 1;
//             }
//             column(YTDDebitAmt;YTDDebitAmt)
//             {
//                 AutoFormatType = 1;
//             }
//             column(YTDBeginBalance;YTDBeginBalance)
//             {
//             }
//             column(PeriodCreditAmt;PeriodCreditAmt)
//             {
//             }
//             column(PeriodDebitAmt;PeriodDebitAmt)
//             {
//             }
//             column(PeriodBeginBalance;PeriodBeginBalance)
//             {
//             }
//             column(Customer_Name;Name)
//             {
//             }
//             column(Customer__No__;"No.")
//             {
//             }
//             column(YTDTotal_Control32;YTDTotal)
//             {
//                 AutoFormatType = 1;
//             }
//             column(YTDCreditAmt_Control33;YTDCreditAmt)
//             {
//                 AutoFormatType = 1;
//             }
//             column(YTDDebitAmt_Control34;YTDDebitAmt)
//             {
//                 AutoFormatType = 1;
//             }
//             column(YTDBeginBalance_Control35;YTDBeginBalance)
//             {
//             }
//             column(PeriodCreditAmt_Control37;PeriodCreditAmt)
//             {
//             }
//             column(PeriodDebitAmt_Control38;PeriodDebitAmt)
//             {
//             }
//             column(PeriodBeginBalance_Control39;PeriodBeginBalance)
//             {
//             }
//             column(Text004__________Customer_Posting_Group_;Text004 + ' ' + "Customer Posting Group")
//             {
//             }
//             column(YTDTotal_Control41;YTDTotal)
//             {
//                 AutoFormatType = 1;
//             }
//             column(YTDCreditAmt_Control42;YTDCreditAmt)
//             {
//                 AutoFormatType = 1;
//             }
//             column(YTDDebitAmt_Control43;YTDDebitAmt)
//             {
//                 AutoFormatType = 1;
//             }
//             column(YTDBeginBalance_Control44;YTDBeginBalance)
//             {
//             }
//             column(PeriodCreditAmt_Control46;PeriodCreditAmt)
//             {
//             }
//             column(PeriodDebitAmt_Control47;PeriodDebitAmt)
//             {
//             }
//             column(PeriodBeginBalance_Control48;PeriodBeginBalance)
//             {
//             }
//             column(Customer___Trial_BalanceCaption;Customer___Trial_BalanceCaptionLbl)
//             {
//             }
//             column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
//             {
//             }
//             column(Amounts_in_LCYCaption;Amounts_in_LCYCaptionLbl)
//             {
//             }
//             column(Only_includes_customers_with_entries_in_the_periodCaption;Only_includes_customers_with_entries_in_the_periodCaptionLbl)
//             {
//             }
//             column(Customer__No__Caption;FIELDCAPTION("No."))
//             {
//             }
//             column(Customer_NameCaption;FIELDCAPTION(Name))
//             {
//             }
//             column(PeriodBeginBalanceCaption;PeriodBeginBalanceCaptionLbl)
//             {
//             }
//             column(PeriodDebitAmtCaption;PeriodDebitAmtCaptionLbl)
//             {
//             }
//             column(PeriodCreditAmtCaption;PeriodCreditAmtCaptionLbl)
//             {
//             }
//             column(YTDBeginBalanceCaption;YTDBeginBalanceCaptionLbl)
//             {
//             }
//             column(YTDDebitAmtCaption;YTDDebitAmtCaptionLbl)
//             {
//             }
//             column(YTDCreditAmtCaption;YTDCreditAmtCaptionLbl)
//             {
//             }
//             column(YTDTotalCaption;YTDTotalCaptionLbl)
//             {
//             }
//             column(PeriodCaption;PeriodCaptionLbl)
//             {
//             }
//             column(Fiscal_Year_To_DateCaption;Fiscal_Year_To_DateCaptionLbl)
//             {
//             }
//             column(Net_ChangeCaption;Net_ChangeCaptionLbl)
//             {
//             }
//             column(Net_ChangeCaption_Control54;Net_ChangeCaption_Control54Lbl)
//             {
//             }
//             column(Total_in_LCYCaption;Total_in_LCYCaptionLbl)
//             {
//             }

//             trigger OnAfterGetRecord()
//             begin
//                 CalcAmounts(
//                   PeriodStartDate,PeriodEndDate,
//                   PeriodBeginBalance,PeriodDebitAmt,PeriodCreditAmt,YTDTotal);

//                 CalcAmounts(
//                   FiscalYearStartDate,PeriodEndDate,
//                   YTDBeginBalance,YTDDebitAmt,YTDCreditAmt,YTDTotal);

//                 /*TJCSG1.00 Start #1*/
//                 IF (YTDTotal=0) AND (YTDCreditAmt=0) AND (YTDDebitAmt=0 )
//                    AND (YTDBeginBalance=0) AND (PeriodCreditAmt=0)
//                    AND (PeriodDebitAmt=0) AND (PeriodBeginBalance=0) THEN
//                   CurrReport.SKIP;
//                 /*TJCSG1.00 Start #2*/

//             end;

//             trigger OnPreDataItem()
//             begin
//                 LastFieldNo := FIELDNO("Customer Posting Group");
//                 CurrReport.CREATETOTALS(
//                   PeriodBeginBalance,PeriodDebitAmt,PeriodCreditAmt,YTDBeginBalance,
//                   YTDDebitAmt,YTDCreditAmt,YTDTotal);
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

//     trigger OnInitReport()
//     begin
//         HideZeroAmounts := TRUE;
//     end;

//     trigger OnPreReport()
//     begin
//         WITH Customer DO BEGIN
//           PeriodFilter := GETFILTER("Date Filter");
//           PeriodStartDate := GETRANGEMIN("Date Filter");
//           PeriodEndDate := GETRANGEMAX("Date Filter");
//           SETRANGE("Date Filter");
//           CustFilter := GETFILTERS;
//           SETRANGE("Date Filter",PeriodStartDate,PeriodEndDate);
//           AccountingPeriod.SETRANGE("Starting Date",0D,PeriodEndDate);
//           AccountingPeriod.SETRANGE("New Fiscal Year",TRUE);
//           IF AccountingPeriod.FIND('+') THEN
//             FiscalYearStartDate := AccountingPeriod."Starting Date"
//           ELSE
//             ERROR(Text000,AccountingPeriod.FIELDCAPTION("Starting Date"),AccountingPeriod.TABLECAPTION);
//           FiscalYearFilter := FORMAT(FiscalYearStartDate) + '..' + FORMAT(PeriodEndDate);
//         END;
//     end;

//     var
//         Text000: Label 'It was not possible to find a %1 in %2.';
//         AccountingPeriod: Record "50";
//         PeriodBeginBalance: Decimal;
//         PeriodDebitAmt: Decimal;
//         PeriodCreditAmt: Decimal;
//         YTDBeginBalance: Decimal;
//         YTDDebitAmt: Decimal;
//         YTDCreditAmt: Decimal;
//         YTDTotal: Decimal;
//         LastFieldNo: Integer;
//         FooterPrinted: Boolean;
//         HideZeroAmounts: Boolean;
//         PeriodFilter: Text[250];
//         FiscalYearFilter: Text[250];
//         CustFilter: Text[1024];
//         PeriodStartDate: Date;
//         PeriodEndDate: Date;
//         FiscalYearStartDate: Date;
//         Text001: Label 'Net change for period';
//         Text002: Label 'Year To Date';
//         Text003: Label 'Period: %1';
//         Text004: Label 'Total for';
//         Text005: Label 'Group Totals: %1';
//         Customer___Trial_BalanceCaptionLbl: Label 'Customer - Trial Balance';
//         CurrReport_PAGENOCaptionLbl: Label 'Page';
//         Amounts_in_LCYCaptionLbl: Label 'Amounts in LCY';
//         Only_includes_customers_with_entries_in_the_periodCaptionLbl: Label 'Only includes customers with entries in the period';
//         PeriodBeginBalanceCaptionLbl: Label 'Beginning Balance';
//         PeriodDebitAmtCaptionLbl: Label 'Debit';
//         PeriodCreditAmtCaptionLbl: Label 'Credit';
//         YTDBeginBalanceCaptionLbl: Label 'Beginning Balance';
//         YTDDebitAmtCaptionLbl: Label 'Debit';
//         YTDCreditAmtCaptionLbl: Label 'Credit';
//         YTDTotalCaptionLbl: Label 'Ending Balance';
//         PeriodCaptionLbl: Label 'Period';
//         Fiscal_Year_To_DateCaptionLbl: Label 'Fiscal Year-To-Date';
//         Net_ChangeCaptionLbl: Label 'Net Change';
//         Net_ChangeCaption_Control54Lbl: Label 'Net Change';
//         Total_in_LCYCaptionLbl: Label 'Total in LCY';

//     local procedure CalcAmounts(DateFrom: Date;DateTo: Date;var BeginBalance: Decimal;var DebitAmt: Decimal;var CreditAmt: Decimal;var TotalBalance: Decimal)
//     var
//         DtlCustLedgEntry: Record "379";
//     begin
//         Customer.SETRANGE("Date Filter",0D,DateFrom - 1);
//         Customer.CALCFIELDS("Net Change (LCY)");
//         BeginBalance := Customer."Net Change (LCY)";

//         WITH DtlCustLedgEntry DO BEGIN
//           SETCURRENTKEY("Customer No.","Posting Date","Entry Type","Currency Code");
//           SETRANGE("Customer No.",Customer."No.");
//           SETRANGE("Posting Date",DateFrom,DateTo);
//           SETFILTER("Entry Type",'<> %1',"Entry Type"::Application);
//           CALCSUMS("Debit Amount (LCY)","Credit Amount (LCY)");
//           DebitAmt := "Debit Amount (LCY)";
//           CreditAmt := "Credit Amount (LCY)";
//           TotalBalance := BeginBalance + DebitAmt - CreditAmt;
//         END;
//     end;
// }

