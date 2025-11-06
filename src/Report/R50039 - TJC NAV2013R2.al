// report 50039 "Balance Sheet"
// {
//     // Balance Sheet report - 80024
//     // Version No.         : TJCSG1.00
//     // Developer           : DP.AYD
//     // Init. DEV. Date     : 30/05/2014
//     // Date of last Change : 30/05/2014
//     // Description         : Based on DD#119 https://dptech.mydonedone.com/issuetracker/projects/4350/issues/119
//     // 
//     // 1. Add AccountType Variable , for making bold the account type <> Posting
//     DefaultLayout = RDLC;
//     RDLCLayout = './Balance Sheet.rdlc';

//     Caption = 'Statement of Balance Sheet';

//     dataset
//     {
//         dataitem(DataItem6710;Table15)
//         {
//             DataItemTableView = SORTING(No.);
//             RequestFilterFields = "No.","Account Type","Date Filter","Budget Filter","Global Dimension 1 Filter","Global Dimension 2 Filter";
//             column(FORMAT_TODAY_0_4_;FORMAT(TODAY,0,4))
//             {
//             }
//             column(LongText;LongText)
//             {
//             }
//             column(CurrReport_PAGENO;CurrReport.PAGENO)
//             {
//             }
//             column(COMPANYNAME;COMPANYNAME)
//             {
//             }
//             column(USERID;USERID)
//             {
//             }
//             column(ReportName;ReportName)
//             {
//             }
//             column(G_L_Account__TABLENAME__________GLFilter;"G/L Account".TABLENAME + ': ' + GLFilter)
//             {
//             }
//             column(RoundFactorText;RoundFactorText)
//             {
//             }
//             column(EmptyString;'')
//             {
//             }
//             column(EmptyString_Control1500013;'')
//             {
//             }
//             column(ColumnHeader_1_;ColumnHeader[1])
//             {
//             }
//             column(ColumnHeader_2_;ColumnHeader[2])
//             {
//             }
//             column(ColumnSubHeader_1_;ColumnSubHeader[1])
//             {
//             }
//             column(ColumnSubHeader_2_;ColumnSubHeader[2])
//             {
//             }
//             column(ColumnSubHeader_3_;ColumnSubHeader[3])
//             {
//             }
//             column(ColumnSubHeader_4_;ColumnSubHeader[4])
//             {
//             }
//             column(ColumnSubHeader_5_;ColumnSubHeader[5])
//             {
//             }
//             column(ColumnSubHeader_6_;ColumnSubHeader[6])
//             {
//             }
//             column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
//             {
//             }
//             column(No_Caption;No_CaptionLbl)
//             {
//             }
//             column(PADSTR_____G_L_Account__Indentation___2___G_L_Account__Name_Control1500025Caption;PADSTR_____G_L_Account__Indentation___2___G_L_Account__Name_Control1500025CaptionLbl)
//             {
//             }
//             column(G_L_Account_No_;"No.")
//             {
//             }
//             dataitem(DataItem5444;Table2000000026)
//             {
//                 DataItemTableView = SORTING(Number)
//                                     WHERE(Number=CONST(1));
//                 MaxIteration = 1;
//                 column(G_L_Account___No__;"G/L Account"."No.")
//                 {
//                 }
//                 column(PADSTR_____G_L_Account__Indentation___2___G_L_Account__Name;PADSTR('',"G/L Account".Indentation * 2)+"G/L Account".Name)
//                 {
//                 }
//                 column(G_L_Account___No___Control1500024;"G/L Account"."No.")
//                 {
//                 }
//                 column(PADSTR_____G_L_Account__Indentation___2___G_L_Account__Name_Control1500025;PADSTR('',"G/L Account".Indentation * 2)+"G/L Account".Name)
//                 {
//                 }
//                 column(ColumnAmountText_1_;ColumnAmountText[1])
//                 {
//                 }
//                 column(ColumnAmountText_2_;ColumnAmountText[2])
//                 {
//                 }
//                 column(ColumnAmountText_3_;ColumnAmountText[3])
//                 {
//                 }
//                 column(ColumnAmountText_6_;ColumnAmountText[6])
//                 {
//                 }
//                 column(ColumnAmountText_5_;ColumnAmountText[5])
//                 {
//                 }
//                 column(ColumnAmountText_4_;ColumnAmountText[4])
//                 {
//                 }
//                 column(G_L_Account___No___Control1500032;"G/L Account"."No.")
//                 {
//                 }
//                 column(PADSTR_____G_L_Account__Indentation___2___G_L_Account__Name_Control1500033;PADSTR('',"G/L Account".Indentation * 2)+"G/L Account".Name)
//                 {
//                 }
//                 column(ColumnAmountText_6__Control1500040;ColumnAmountText[6])
//                 {
//                 }
//                 column(ColumnAmountText_5__Control1500041;ColumnAmountText[5])
//                 {
//                 }
//                 column(ColumnAmountText_4__Control1500042;ColumnAmountText[4])
//                 {
//                 }
//                 column(ColumnAmountText_3__Control1500043;ColumnAmountText[3])
//                 {
//                 }
//                 column(ColumnAmountText_2__Control1500044;ColumnAmountText[2])
//                 {
//                 }
//                 column(ColumnAmountText_1__Control1500045;ColumnAmountText[1])
//                 {
//                 }
//                 column(Integer_Number;Number)
//                 {
//                 }
//                 column(AccountType;"G/L Account"."Account Type")
//                 {
//                 }
//             }

//             trigger OnAfterGetRecord()
//             begin
//                 CalculateAmount("G/L Account");

//                 RoundAmount;
//                 IF (ColumnAmount[1] = 0) AND (ColumnAmount[2] = 0) AND (ColumnAmount[3] = 0) AND
//                    (ColumnAmount[4] = 0) AND (ColumnAmount[5] = 0) AND (ColumnAmount[6] = 0) AND
//                    ("G/L Account"."Account Type" = "G/L Account"."Account Type"::Posting)
//                 THEN
//                   CurrReport.SKIP
//                 ELSE
//                   ConvertAmountToText;
//             end;

//             trigger OnPreDataItem()
//             begin
//                 PopulateFormatString;
//                 PopulateColumnHeader;
//                 FilterGLAccount("G/L Account");
//             end;
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
//                     field(RoundingFactor;RoundingFactor)
//                     {
//                         Caption = 'Amounts in whole';
//                     }
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
//         GLFilter := "G/L Account".GETFILTERS;
//         RoundFactorText := ReportMngmt.RoundDescription(RoundingFactor);
//         CurrentPeriodEnd := "G/L Account".GETRANGEMAX("Date Filter");

//         LastYearCurrentPeriodEnd := CALCDATE('-1Y',NORMALDATE(CurrentPeriodEnd) + 1) - 1;
//         IF CurrentPeriodEnd <> NORMALDATE(CurrentPeriodEnd) THEN
//           LastYearCurrentPeriodEnd := CLOSINGDATE(LastYearCurrentPeriodEnd);

//         AccPeriod.RESET;
//         AccPeriod.SETRANGE(AccPeriod."New Fiscal Year",TRUE,TRUE);
//         AccPeriod.SETFILTER(AccPeriod."Starting Date",'..%1',CurrentPeriodEnd);
//         AccPeriod.FIND('+');
//         CurrentYearStart := AccPeriod."Starting Date";

//         AccPeriod.SETFILTER(AccPeriod."Starting Date",'..%1',LastYearCurrentPeriodEnd);
//         IF AccPeriod.FIND('+') THEN
//           LastYearStart := AccPeriod."Starting Date";
//     end;

//     var
//         AccPeriod: Record "50";
//         ReportMngmt: Codeunit "50008";
//         GLFilter: Text[250];
//         LongText: Text[250];
//         RoundFactorText: Text[50];
//         FormatString: array [6] of Text[50];
//         CurrentPeriodEnd: Date;
//         LastYearCurrentPeriodEnd: Date;
//         CurrentYearStart: Date;
//         LastYearStart: Date;
//         RoundingFactor: Option " ",Tens,Hundreds,Thousands,"Hundred Thousands",Millions;
//         ColumnHeader: array [2] of Text[30];
//         ColumnSubHeader: array [6] of Text[30];
//         ColumnAmount: array [6] of Decimal;
//         ColumnAmountText: array [6] of Text[30];
//         DoNotRoundAmount: array [6] of Boolean;
//         ReportName: Text[250];
//         Text1450000: Label 'Current Year';
//         Text1450001: Label 'Last Year';
//         Text1450002: Label 'Balance';
//         Text1450003: Label 'Budget';
//         Text1450004: Label 'Variance %';
//         Text1450005: Label 'Statement of Financial Position';
//         Text1450006: Label 'Period: %1..%2 versus %3..%4';
//         CurrReport_PAGENOCaptionLbl: Label 'Page';
//         No_CaptionLbl: Label 'No.';
//         PADSTR_____G_L_Account__Indentation___2___G_L_Account__Name_Control1500025CaptionLbl: Label 'Name';
//         AccountType: Option Posting,Heading,Total,"Begin-Total","End-Total";

//     local procedure PopulateColumnHeader()
//     begin
//         ReportName := Text1450005;
//         ColumnHeader[1] := Text1450000;
//         ColumnHeader[2] := Text1450001;
//         ColumnSubHeader[1] := Text1450002;
//         ColumnSubHeader[2] := Text1450003;
//         ColumnSubHeader[3] := Text1450004;
//         ColumnSubHeader[4] := Text1450002;
//         ColumnSubHeader[5] := Text1450003;
//         ColumnSubHeader[6] := Text1450004;
//         LongText :=
//           STRSUBSTNO(
//             Text1450006,
//             CurrentYearStart,CurrentPeriodEnd,LastYearStart,LastYearCurrentPeriodEnd);
//     end;

//     local procedure ConvertAmountToText()
//     var
//         i: Integer;
//     begin
//         FOR i := 1 TO 6 DO BEGIN
//           IF FormatString[i] <> '' THEN
//             ColumnAmountText[i] := FORMAT(ColumnAmount[i],0,FormatString[i])
//           ELSE
//             ColumnAmountText[i] := FORMAT(ColumnAmount[i]);
//         END;
//     end;

//     local procedure PopulateFormatString()
//     var
//         i: Integer;
//     begin
//         FOR i := 1 TO 6 DO BEGIN
//           IF RoundingFactor = RoundingFactor::" " THEN
//             FormatString[i] := '<Precision,2:><Standard Format,0>'
//           ELSE
//             FormatString[i] := '<Precision,1:><Standard Format,0>';
//         END;
//         FormatString[3] := '';
//         FormatString[6] := '';
//         DoNotRoundAmount[3] := TRUE;
//         DoNotRoundAmount[6] := TRUE;
//     end;

//     local procedure RoundAmount()
//     var
//         i: Integer;
//     begin
//         FOR i := 1 TO 6 DO BEGIN
//           IF NOT DoNotRoundAmount[i] THEN
//             ColumnAmount[i] := ReportMngmt.RoundAmount(ColumnAmount[i],RoundingFactor);
//         END;
//     end;

//     local procedure FilterGLAccount(var GLAccount: Record "15")
//     begin
//         GLAccount.SETRANGE("Income/Balance",GLAccount."Income/Balance"::"Balance Sheet");
//     end;

//     local procedure CalculateAmount(var GLAccount: Record "15")
//     begin
//         GLAccount.SETRANGE("Date Filter",CurrentYearStart,CurrentPeriodEnd);
//         GLAccount.CALCFIELDS("Balance at Date","Budget at Date");
//         ColumnAmount[1] := GLAccount."Balance at Date";
//         ColumnAmount[2] := GLAccount."Budget at Date";
//         ColumnAmount[3] := 0;
//         IF ColumnAmount[2] <> 0 THEN
//           ColumnAmount[3] := ROUND((ColumnAmount[2] - ColumnAmount[1]) / ColumnAmount[2] * 100,1);

//         GLAccount.SETRANGE("Date Filter",LastYearStart,LastYearCurrentPeriodEnd);
//         GLAccount.CALCFIELDS("Balance at Date","Budget at Date");
//         ColumnAmount[4] := GLAccount."Balance at Date";
//         ColumnAmount[5] := GLAccount."Budget at Date";
//         ColumnAmount[6] := 0;
//         IF ColumnAmount[5] <> 0 THEN
//           ColumnAmount[6] := ROUND((ColumnAmount[5] - ColumnAmount[4]) / ColumnAmount[5] * 100,1);
//     end;
// }

