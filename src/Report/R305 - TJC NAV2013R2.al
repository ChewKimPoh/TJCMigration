// report 305 "Vendor - Summary Aging"
// {
//     DefaultLayout = RDLC;
//     RDLCLayout = './Vendor - Summary Aging.rdlc';
//     Caption = 'Vendor - Summary Aging';

//     dataset
//     {
//         dataitem(DataItem3182;Table23)
//         {
//             DataItemTableView = SORTING(No.);
//             RequestFilterFields = "No.","Search Name","Vendor Posting Group","Currency Filter";
//             column(COMPANYNAME;COMPANYNAME)
//             {
//             }
//             column(CurrReport_PAGENO;CurrReport.PAGENO)
//             {
//             }
//             column(PrintAmountsInLCY;PrintAmountsInLCY)
//             {
//             }
//             column(Vendor_TABLECAPTION__________VendFilter;TABLECAPTION + ': ' + VendFilter)
//             {
//             }
//             column(VendFilter;VendFilter)
//             {
//             }
//             column(PeriodStartDate_2_;FORMAT(PeriodStartDate[2]))
//             {
//             }
//             column(PeriodStartDate_3_;FORMAT(PeriodStartDate[3]))
//             {
//             }
//             column(PeriodStartDate_4_;FORMAT(PeriodStartDate[4]))
//             {
//             }
//             column(PeriodStartDate_3____1;FORMAT(PeriodStartDate[3] - 1))
//             {
//             }
//             column(PeriodStartDate_4____1;FORMAT(PeriodStartDate[4] - 1))
//             {
//             }
//             column(PeriodStartDate_5____1;FORMAT(PeriodStartDate[5] - 1))
//             {
//             }
//             column(PrintLine;PrintLine)
//             {
//             }
//             column(VendBalanceDueLCY_1_;VendBalanceDueLCY[1])
//             {
//                 AutoFormatType = 1;
//             }
//             column(VendBalanceDueLCY_2_;VendBalanceDueLCY[2])
//             {
//                 AutoFormatType = 1;
//             }
//             column(VendBalanceDueLCY_3_;VendBalanceDueLCY[3])
//             {
//                 AutoFormatType = 1;
//             }
//             column(VendBalanceDueLCY_4_;VendBalanceDueLCY[4])
//             {
//                 AutoFormatType = 1;
//             }
//             column(VendBalanceDueLCY_5_;VendBalanceDueLCY[5])
//             {
//                 AutoFormatType = 1;
//             }
//             column(TotalVendAmtDueLCY;TotalVendAmtDueLCY)
//             {
//                 AutoFormatType = 1;
//             }
//             column(LineTotalVendAmountDue;LineTotalVendAmountDue)
//             {
//                 AutoFormatType = 1;
//             }
//             column(VendBalanceDue_5_;VendBalanceDue[5])
//             {
//                 AutoFormatType = 1;
//             }
//             column(VendBalanceDue_4_;VendBalanceDue[4])
//             {
//                 AutoFormatType = 1;
//             }
//             column(VendBalanceDue_3_;VendBalanceDue[3])
//             {
//                 AutoFormatType = 1;
//             }
//             column(VendBalanceDue_2_;VendBalanceDue[2])
//             {
//                 AutoFormatType = 1;
//             }
//             column(VendBalanceDue_1_;VendBalanceDue[1])
//             {
//                 AutoFormatType = 1;
//             }
//             column(Vendor_Name;Name)
//             {
//             }
//             column(Vendor__No__;"No.")
//             {
//             }
//             column(InVendBalanceDueLCY_1;InVendBalanceDueLCY[1])
//             {
//                 AutoFormatType = 1;
//             }
//             column(InVendBalanceDueLCY_2;InVendBalanceDueLCY[2])
//             {
//                 AutoFormatType = 1;
//             }
//             column(InVendBalanceDueLCY_3;InVendBalanceDueLCY[3])
//             {
//                 AutoFormatType = 1;
//             }
//             column(InVendBalanceDueLCY_4;InVendBalanceDueLCY[4])
//             {
//                 AutoFormatType = 1;
//             }
//             column(InVendBalanceDueLCY_5;InVendBalanceDueLCY[5])
//             {
//                 AutoFormatType = 1;
//             }
//             column(Vendor___Summary_AgingCaption;Vendor___Summary_AgingCaptionLbl)
//             {
//             }
//             column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
//             {
//             }
//             column(All_amounts_are_in_LCYCaption;All_amounts_are_in_LCYCaptionLbl)
//             {
//             }
//             column(Balance_DueCaption;Balance_DueCaptionLbl)
//             {
//             }
//             column(Vendor__No___Control29Caption;FIELDCAPTION("No."))
//             {
//             }
//             column(Vendor_Name_Control30Caption;FIELDCAPTION(Name))
//             {
//             }
//             column(VendBalanceDue_1__Control31Caption;VendBalanceDue_1__Control31CaptionLbl)
//             {
//             }
//             column(VendBalanceDue_5__Control35Caption;VendBalanceDue_5__Control35CaptionLbl)
//             {
//             }
//             column(LineTotalVendAmountDue_Control36Caption;LineTotalVendAmountDue_Control36CaptionLbl)
//             {
//             }
//             column(Total__LCY_Caption;Total__LCY_CaptionLbl)
//             {
//             }
//             dataitem(DataItem5444;Table2000000026)
//             {
//                 DataItemTableView = SORTING(Number)
//                                     WHERE(Number=FILTER(1..));
//                 column(Currency2_Code;Currency2.Code)
//                 {
//                 }
//                 column(LineTotalVendAmountDue_Control36;LineTotalVendAmountDue)
//                 {
//                     AutoFormatExpression = Currency2.Code;
//                     AutoFormatType = 1;
//                 }
//                 column(VendBalanceDue_5__Control35;VendBalanceDue[5])
//                 {
//                     AutoFormatExpression = Currency2.Code;
//                     AutoFormatType = 1;
//                 }
//                 column(VendBalanceDue_4__Control34;VendBalanceDue[4])
//                 {
//                     AutoFormatExpression = Currency2.Code;
//                     AutoFormatType = 1;
//                 }
//                 column(VendBalanceDue_3__Control33;VendBalanceDue[3])
//                 {
//                     AutoFormatExpression = Currency2.Code;
//                     AutoFormatType = 1;
//                 }
//                 column(VendBalanceDue_2__Control32;VendBalanceDue[2])
//                 {
//                     AutoFormatExpression = Currency2.Code;
//                     AutoFormatType = 1;
//                 }
//                 column(VendBalanceDue_1__Control31;VendBalanceDue[1])
//                 {
//                     AutoFormatExpression = Currency2.Code;
//                     AutoFormatType = 1;
//                 }
//                 column(Vendor_Name_Control30;Vendor.Name)
//                 {
//                 }
//                 column(Vendor__No___Control29;Vendor."No.")
//                 {
//                 }

//                 trigger OnAfterGetRecord()
//                 var
//                     DtldVendLedgEntry: Record "380";
//                 begin
//                     IF Number = 1 THEN
//                       Currency2.FIND('-')
//                     ELSE
//                       IF Currency2.NEXT = 0 THEN
//                         CurrReport.BREAK;
//                     Currency2.CALCFIELDS("Vendor Ledg. Entries in Filter");
//                     IF NOT Currency2."Vendor Ledg. Entries in Filter" THEN
//                       CurrReport.SKIP;

//                     PrintLine := FALSE;
//                     LineTotalVendAmountDue := 0;
//                     FOR i := 1 TO 5 DO BEGIN
//                       DtldVendLedgEntry.SETCURRENTKEY("Vendor No.","Initial Entry Due Date");
//                       DtldVendLedgEntry.SETRANGE("Vendor No.",Vendor."No.");
//                       DtldVendLedgEntry.SETRANGE("Initial Entry Due Date",PeriodStartDate[i],PeriodStartDate[i + 1] - 1);
//                       DtldVendLedgEntry.SETRANGE("Currency Code",Currency2.Code);
//                       DtldVendLedgEntry.CALCSUMS(Amount);
//                       VendBalanceDue[i] := DtldVendLedgEntry.Amount;
//                       InVendBalanceDueLCY[i] := InVendBalanceDueLCY2[i];
//                       IF VendBalanceDue[i] <> 0 THEN
//                         PrintLine := TRUE;
//                       LineTotalVendAmountDue := LineTotalVendAmountDue + VendBalanceDue[i];
//                     END;
//                 end;

//                 trigger OnPreDataItem()
//                 begin
//                     IF PrintAmountsInLCY OR NOT PrintLine THEN
//                       CurrReport.BREAK;
//                     Currency2.RESET;
//                     Currency2.SETRANGE("Vendor Filter",Vendor."No.");
//                     Vendor.COPYFILTER("Currency Filter",Currency2.Code);
//                     IF (Vendor.GETFILTER("Global Dimension 1 Filter") <> '') OR
//                        (Vendor.GETFILTER("Global Dimension 2 Filter") <> '')
//                     THEN BEGIN
//                       Vendor.COPYFILTER("Global Dimension 1 Filter",Currency2."Global Dimension 1 Filter");
//                       Vendor.COPYFILTER("Global Dimension 2 Filter",Currency2."Global Dimension 2 Filter");
//                     END;
//                 end;
//             }

//             trigger OnAfterGetRecord()
//             var
//                 DtldVendLedgEntry: Record "380";
//             begin
//                 PrintLine := FALSE;
//                 LineTotalVendAmountDue := 0;
//                 COPYFILTER("Currency Filter",DtldVendLedgEntry."Currency Code");
//                 FOR i := 1 TO 5 DO BEGIN
//                   DtldVendLedgEntry.SETCURRENTKEY("Vendor No.","Initial Entry Due Date");
//                   DtldVendLedgEntry.SETRANGE("Vendor No.","No.");
//                   DtldVendLedgEntry.SETRANGE("Initial Entry Due Date",PeriodStartDate[i],PeriodStartDate[i + 1] - 1);
//                   DtldVendLedgEntry.CALCSUMS("Amount (LCY)");
//                   VendBalanceDue[i] := DtldVendLedgEntry."Amount (LCY)";
//                   VendBalanceDueLCY[i] := DtldVendLedgEntry."Amount (LCY)";
//                   IF PrintAmountsInLCY THEN
//                     InVendBalanceDueLCY[i] += DtldVendLedgEntry."Amount (LCY)"
//                   ELSE
//                     InVendBalanceDueLCY2[i] += DtldVendLedgEntry."Amount (LCY)";
//                   IF VendBalanceDue[i] <> 0 THEN
//                     PrintLine := TRUE;
//                   LineTotalVendAmountDue := LineTotalVendAmountDue + VendBalanceDueLCY[i];
//                   TotalVendAmtDueLCY := TotalVendAmtDueLCY + VendBalanceDueLCY[i];
//                 END;
//             end;

//             trigger OnPreDataItem()
//             begin
//                 CurrReport.CREATETOTALS(VendBalanceDueLCY,TotalVendAmtDueLCY);
//                 Currency2.Code := '';
//                 Currency2.INSERT;
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
//                     field(PeriodStartDate[2];PeriodStartDate[2])
//                     {
//                         Caption = 'Starting Date';
//                         NotBlank = true;
//                     }
//                     field(PeriodLength;PeriodLength)
//                     {
//                         Caption = 'Period Length';
//                     }
//                     field(PrintAmountsInLCY;PrintAmountsInLCY)
//                     {
//                         Caption = 'Show Amounts in LCY';
//                     }
//                 }
//             }
//         }

//         actions
//         {
//         }

//         trigger OnOpenPage()
//         begin
//             IF PeriodStartDate[2] = 0D THEN
//               PeriodStartDate[2] := WORKDATE;
//             IF FORMAT(PeriodLength) = '' THEN
//               EVALUATE(PeriodLength,'<1M>');
//         end;
//     }

//     labels
//     {
//     }

//     trigger OnPreReport()
//     begin
//         VendFilter := Vendor.GETFILTERS;
//         FOR i := 3 TO 5 DO
//           PeriodStartDate[i] := CALCDATE(PeriodLength,PeriodStartDate[i - 1]);
//         PeriodStartDate[6] := 12319999D;
//     end;

//     var
//         Currency: Record "4";
//         Currency2: Record "4" temporary;
//         PrintAmountsInLCY: Boolean;
//         VendFilter: Text;
//         PeriodStartDate: array [6] of Date;
//         LineTotalVendAmountDue: Decimal;
//         TotalVendAmtDueLCY: Decimal;
//         VendBalanceDue: array [5] of Decimal;
//         VendBalanceDueLCY: array [5] of Decimal;
//         PeriodLength: DateFormula;
//         PrintLine: Boolean;
//         i: Integer;
//         InVendBalanceDueLCY: array [5] of Decimal;
//         InVendBalanceDueLCY2: array [5] of Decimal;
//         Vendor___Summary_AgingCaptionLbl: Label 'Vendor - Summary Aging';
//         CurrReport_PAGENOCaptionLbl: Label 'Page';
//         All_amounts_are_in_LCYCaptionLbl: Label 'All amounts are in LCY';
//         Balance_DueCaptionLbl: Label 'Balance Due';
//         VendBalanceDue_1__Control31CaptionLbl: Label '...Before';
//         VendBalanceDue_5__Control35CaptionLbl: Label 'After...';
//         LineTotalVendAmountDue_Control36CaptionLbl: Label 'Balance';
//         VendBalanceDueLCY_1_CaptionLbl: Label 'Continued (LCY)';
//         VendBalanceDueLCY_1__Control39CaptionLbl: Label 'Continued (LCY)';
//         Total__LCY_CaptionLbl: Label 'Total (LCY)';

//     procedure InitializeRequest(NewPeriodStartDate: Date;NewPeriodLength: Text[10];NewPrintAmountsInLCY: Boolean)
//     begin
//         PeriodStartDate[2] := NewPeriodStartDate;
//         EVALUATE(PeriodLength,NewPeriodLength);
//         PrintAmountsInLCY := NewPrintAmountsInLCY;
//     end;
// }

