// report 322 "Aged Accounts Payable"
// {
//     // Aged Accounts Payable - 322
//     // Version No.         : TJCSG1.00
//     // Developer           : DP.AYD
//     // Init. DEV. Date     : 28/05/2014
//     // Date of last Change : 28/05/2014
//     // Description         : Based on DD#117 https://dptech.mydonedone.com/issuetracker/projects/4350/issues/117
//     DefaultLayout = RDLC;
//     RDLCLayout = './Aged Accounts Payable.rdlc';

//     Caption = 'Aged Accounts Payable';

//     dataset
//     {
//         dataitem(Vendor;Table23)
//         {
//             PrintOnlyIfDetail = true;
//             RequestFilterFields = "No.";
//             column(CompanyName;COMPANYNAME)
//             {
//             }
//             column(NewPagePerVendor;NewPagePerVendor)
//             {
//             }
//             column(AgesAsOfEndingDate;STRSUBSTNO(Text006,FORMAT(EndingDate,0,4)))
//             {
//             }
//             column(SelectAgeByDuePostngDocDt;STRSUBSTNO(Text007,SELECTSTR(AgingBy + 1,Text009)))
//             {
//             }
//             column(PrintAmountInLCY;PrintAmountInLCY)
//             {
//             }
//             column(CaptionVendorFilter;TABLECAPTION + ': ' + VendorFilter)
//             {
//             }
//             column(VendorFilter;VendorFilter)
//             {
//             }
//             column(AgingBy;AgingBy)
//             {
//             }
//             column(SelctAgeByDuePostngDocDt1;STRSUBSTNO(Text004,SELECTSTR(AgingBy + 1,Text009)))
//             {
//             }
//             column(HeaderText5;HeaderText[5])
//             {
//             }
//             column(HeaderText4;HeaderText[4])
//             {
//             }
//             column(HeaderText3;HeaderText[3])
//             {
//             }
//             column(HeaderText2;HeaderText[2])
//             {
//             }
//             column(HeaderText1;HeaderText[1])
//             {
//             }
//             column(PrintDetails;PrintDetails)
//             {
//             }
//             column(GrandTotalVLE5RemAmtLCY;GrandTotalVLERemaingAmtLCY[5])
//             {
//                 AutoFormatType = 1;
//             }
//             column(GrandTotalVLE4RemAmtLCY;GrandTotalVLERemaingAmtLCY[4])
//             {
//                 AutoFormatType = 1;
//             }
//             column(GrandTotalVLE3RemAmtLCY;GrandTotalVLERemaingAmtLCY[3])
//             {
//                 AutoFormatType = 1;
//             }
//             column(GrandTotalVLE2RemAmtLCY;GrandTotalVLERemaingAmtLCY[2])
//             {
//                 AutoFormatType = 1;
//             }
//             column(GrandTotalVLE1RemAmtLCY;GrandTotalVLERemaingAmtLCY[1])
//             {
//                 AutoFormatType = 1;
//             }
//             column(GrandTotalVLE1AmtLCY;GrandTotalVLEAmtLCY)
//             {
//                 AutoFormatType = 1;
//             }
//             column(PageGroupNo;PageGroupNo)
//             {
//             }
//             column(No_Vendor;"No.")
//             {
//             }
//             column(AgedAcctPayableCaption;AgedAcctPayableCaptionLbl)
//             {
//             }
//             column(CurrReportPageNoCaption;CurrReportPageNoCaptionLbl)
//             {
//             }
//             column(AllAmtsinLCYCaption;AllAmtsinLCYCaptionLbl)
//             {
//             }
//             column(AgedOverdueAmsCaption;AgedOverdueAmsCaptionLbl)
//             {
//             }
//             column(GrandTotalVLE5RemAmtLCYCaption;GrandTotalVLE5RemAmtLCYCaptionLbl)
//             {
//             }
//             column(AmountLCYCaption;AmountLCYCaptionLbl)
//             {
//             }
//             column(DueDateCaption;DueDateCaptionLbl)
//             {
//             }
//             column(DocumentNoCaption;DocumentNoCaptionLbl)
//             {
//             }
//             column(PostingDateCaption;PostingDateCaptionLbl)
//             {
//             }
//             column(DocumentTypeCaption;DocumentTypeCaptionLbl)
//             {
//             }
//             column(VendorNoCaption;FIELDCAPTION("No."))
//             {
//             }
//             column(VendorNameCaption;FIELDCAPTION(Name))
//             {
//             }
//             column(CurrencyCaption;CurrencyCaptionLbl)
//             {
//             }
//             column(TotalLCYCaption;TotalLCYCaptionLbl)
//             {
//             }
//             dataitem(DataItem4114;Table25)
//             {
//                 DataItemLink = Vendor No.=FIELD(No.);
//                 DataItemTableView = SORTING(Vendor No.,Posting Date,Currency Code);
//                 PrintOnlyIfDetail = true;

//                 trigger OnAfterGetRecord()
//                 var
//                     VendorLedgEntry: Record "25";
//                 begin
//                     VendorLedgEntry.SETCURRENTKEY("Closed by Entry No.");
//                     VendorLedgEntry.SETRANGE("Closed by Entry No.","Entry No.");
//                     VendorLedgEntry.SETRANGE("Posting Date",0D,EndingDate);
//                     IF VendorLedgEntry.FINDSET(FALSE,FALSE) THEN
//                       REPEAT
//                         InsertTemp(VendorLedgEntry);
//                       UNTIL VendorLedgEntry.NEXT = 0;

//                     IF "Closed by Entry No." <> 0 THEN BEGIN
//                       VendorLedgEntry.SETRANGE("Closed by Entry No.","Closed by Entry No.");
//                       IF VendorLedgEntry.FINDSET(FALSE,FALSE) THEN
//                         REPEAT
//                           InsertTemp(VendorLedgEntry);
//                         UNTIL VendorLedgEntry.NEXT = 0;
//                     END;

//                     VendorLedgEntry.RESET;
//                     VendorLedgEntry.SETRANGE("Entry No.","Closed by Entry No.");
//                     VendorLedgEntry.SETRANGE("Posting Date",0D,EndingDate);
//                     IF VendorLedgEntry.FINDSET(FALSE,FALSE) THEN
//                       REPEAT
//                         InsertTemp(VendorLedgEntry);
//                       UNTIL VendorLedgEntry.NEXT = 0;
//                     CurrReport.SKIP;
//                 end;

//                 trigger OnPreDataItem()
//                 begin
//                     SETRANGE("Posting Date",EndingDate + 1,12319999D);
//                 end;
//             }
//             dataitem(OpenVendorLedgEntry;Table25)
//             {
//                 DataItemLink = Vendor No.=FIELD(No.);
//                 DataItemTableView = SORTING(Vendor No.,Open,Positive,Due Date,Currency Code);
//                 PrintOnlyIfDetail = true;

//                 trigger OnAfterGetRecord()
//                 begin
//                     IF AgingBy = AgingBy::"Posting Date" THEN BEGIN
//                       CALCFIELDS("Remaining Amt. (LCY)");
//                       IF "Remaining Amt. (LCY)" = 0 THEN
//                         CurrReport.SKIP;
//                     END;
//                     InsertTemp(OpenVendorLedgEntry);
//                     CurrReport.SKIP;
//                 end;

//                 trigger OnPreDataItem()
//                 begin
//                     IF AgingBy = AgingBy::"Posting Date" THEN BEGIN
//                       SETRANGE("Posting Date",0D,EndingDate);
//                       SETRANGE("Date Filter",0D,EndingDate);
//                     END
//                 end;
//             }
//             dataitem(CurrencyLoop;Table2000000026)
//             {
//                 DataItemTableView = SORTING(Number)
//                                     WHERE(Number=FILTER(1..));
//                 PrintOnlyIfDetail = true;
//                 dataitem(TempVendortLedgEntryLoop;Table2000000026)
//                 {
//                     DataItemTableView = SORTING(Number)
//                                         WHERE(Number=FILTER(1..));
//                     column(ExternalDocNo;VendorLedgEntryEndingDate."External Document No.")
//                     {
//                     }
//                     column(DocumentDate;VendorLedgEntryEndingDate."Document Date")
//                     {
//                     }
//                     column(VendorName;Vendor.Name)
//                     {
//                     }
//                     column(VendorNo;Vendor."No.")
//                     {
//                     }
//                     column(VLEEndingDateRemAmtLCY;VendorLedgEntryEndingDate."Remaining Amt. (LCY)")
//                     {
//                         AutoFormatType = 1;
//                     }
//                     column(AgedVLE1RemAmtLCY;AgedVendorLedgEntry[1]."Remaining Amt. (LCY)")
//                     {
//                         AutoFormatType = 1;
//                     }
//                     column(AgedVendLedgEnt2RemAmtLCY;AgedVendorLedgEntry[2]."Remaining Amt. (LCY)")
//                     {
//                         AutoFormatType = 1;
//                     }
//                     column(AgedVendLedgEnt3RemAmtLCY;AgedVendorLedgEntry[3]."Remaining Amt. (LCY)")
//                     {
//                         AutoFormatType = 1;
//                     }
//                     column(AgedVendLedgEnt4RemAmtLCY;AgedVendorLedgEntry[4]."Remaining Amt. (LCY)")
//                     {
//                         AutoFormatType = 1;
//                     }
//                     column(AgedVendLedgEnt5RemAmtLCY;AgedVendorLedgEntry[5]."Remaining Amt. (LCY)")
//                     {
//                         AutoFormatType = 1;
//                     }
//                     column(VendLedgEntryEndDtAmtLCY;VendorLedgEntryEndingDate."Amount (LCY)")
//                     {
//                         AutoFormatType = 1;
//                     }
//                     column(VendLedgEntryEndDtDueDate;FORMAT(VendorLedgEntryEndingDate."Due Date"))
//                     {
//                     }
//                     column(VendLedgEntryEndDtDocNo;VendorLedgEntryEndingDate."Document No.")
//                     {
//                     }
//                     column(VendLedgEntyEndgDtDocType;FORMAT(VendorLedgEntryEndingDate."Document Type"))
//                     {
//                     }
//                     column(VendLedgEntryEndDtPostgDt;FORMAT(VendorLedgEntryEndingDate."Posting Date"))
//                     {
//                     }
//                     column(AgedVendLedgEnt5RemAmt;AgedVendorLedgEntry[5]."Remaining Amount")
//                     {
//                         AutoFormatExpression = CurrencyCode;
//                         AutoFormatType = 1;
//                     }
//                     column(AgedVendLedgEnt4RemAmt;AgedVendorLedgEntry[4]."Remaining Amount")
//                     {
//                         AutoFormatExpression = CurrencyCode;
//                         AutoFormatType = 1;
//                     }
//                     column(AgedVendLedgEnt3RemAmt;AgedVendorLedgEntry[3]."Remaining Amount")
//                     {
//                         AutoFormatExpression = CurrencyCode;
//                         AutoFormatType = 1;
//                     }
//                     column(AgedVendLedgEnt2RemAmt;AgedVendorLedgEntry[2]."Remaining Amount")
//                     {
//                         AutoFormatExpression = CurrencyCode;
//                         AutoFormatType = 1;
//                     }
//                     column(AgedVendLedgEnt1RemAmt;AgedVendorLedgEntry[1]."Remaining Amount")
//                     {
//                         AutoFormatExpression = CurrencyCode;
//                         AutoFormatType = 1;
//                     }
//                     column(VLEEndingDateRemAmt;VendorLedgEntryEndingDate."Remaining Amount")
//                     {
//                         AutoFormatExpression = CurrencyCode;
//                         AutoFormatType = 1;
//                     }
//                     column(VendLedgEntryEndingDtAmt;VendorLedgEntryEndingDate.Amount)
//                     {
//                         AutoFormatExpression = CurrencyCode;
//                         AutoFormatType = 1;
//                     }
//                     column(TotalVendorName;STRSUBSTNO(Text005,Vendor.Name))
//                     {
//                     }
//                     column(CurrCode_TempVenLedgEntryLoop;CurrencyCode)
//                     {
//                         AutoFormatExpression = CurrencyCode;
//                         AutoFormatType = 1;
//                     }

//                     trigger OnAfterGetRecord()
//                     var
//                         PeriodIndex: Integer;
//                     begin
//                         IF Number = 1 THEN BEGIN
//                           IF NOT TempVendorLedgEntry.FINDSET(FALSE,FALSE) THEN
//                             CurrReport.BREAK;
//                         END ELSE
//                           IF TempVendorLedgEntry.NEXT = 0 THEN
//                             CurrReport.BREAK;

//                         VendorLedgEntryEndingDate := TempVendorLedgEntry;
//                         DetailedVendorLedgerEntry.SETRANGE("Vendor Ledger Entry No.",VendorLedgEntryEndingDate."Entry No.");
//                         IF DetailedVendorLedgerEntry.FINDSET(FALSE,FALSE) THEN
//                           REPEAT
//                             IF (DetailedVendorLedgerEntry."Entry Type" =
//                                 DetailedVendorLedgerEntry."Entry Type"::"Initial Entry") AND
//                                (VendorLedgEntryEndingDate."Posting Date" > EndingDate) AND
//                                (AgingBy <> AgingBy::"Posting Date")
//                             THEN BEGIN
//                               IF VendorLedgEntryEndingDate."Document Date" <= EndingDate THEN
//                                 DetailedVendorLedgerEntry."Posting Date" :=
//                                   VendorLedgEntryEndingDate."Document Date"
//                               ELSE
//                                 IF (VendorLedgEntryEndingDate."Due Date" <= EndingDate) AND
//                                    (AgingBy = AgingBy::"Due Date")
//                                 THEN
//                                   DetailedVendorLedgerEntry."Posting Date" :=
//                                     VendorLedgEntryEndingDate."Due Date"
//                             END;

//                             IF (DetailedVendorLedgerEntry."Posting Date" <= EndingDate) OR
//                                (TempVendorLedgEntry.Open AND
//                                 (AgingBy = AgingBy::"Due Date") AND
//                                 (VendorLedgEntryEndingDate."Due Date" > EndingDate) AND
//                                 (VendorLedgEntryEndingDate."Posting Date" <= EndingDate))
//                             THEN BEGIN
//                               IF DetailedVendorLedgerEntry."Entry Type" IN
//                                  [DetailedVendorLedgerEntry."Entry Type"::"Initial Entry",
//                                   DetailedVendorLedgerEntry."Entry Type"::"Unrealized Loss",
//                                   DetailedVendorLedgerEntry."Entry Type"::"Unrealized Gain",
//                                   DetailedVendorLedgerEntry."Entry Type"::"Realized Loss",
//                                   DetailedVendorLedgerEntry."Entry Type"::"Realized Gain",
//                                   DetailedVendorLedgerEntry."Entry Type"::"Payment Discount",
//                                   DetailedVendorLedgerEntry."Entry Type"::"Payment Discount (VAT Excl.)",
//                                   DetailedVendorLedgerEntry."Entry Type"::"Payment Discount (VAT Adjustment)",
//                                   DetailedVendorLedgerEntry."Entry Type"::"Payment Tolerance",
//                                   DetailedVendorLedgerEntry."Entry Type"::"Payment Discount Tolerance",
//                                   DetailedVendorLedgerEntry."Entry Type"::"Payment Tolerance (VAT Excl.)",
//                                   DetailedVendorLedgerEntry."Entry Type"::"Payment Tolerance (VAT Adjustment)",
//                                   DetailedVendorLedgerEntry."Entry Type"::"Payment Discount Tolerance (VAT Excl.)",
//                                   DetailedVendorLedgerEntry."Entry Type"::"Payment Discount Tolerance (VAT Adjustment)"]
//                               THEN BEGIN
//                                 VendorLedgEntryEndingDate.Amount := VendorLedgEntryEndingDate.Amount + DetailedVendorLedgerEntry.Amount;
//                                 VendorLedgEntryEndingDate."Amount (LCY)" :=
//                                   VendorLedgEntryEndingDate."Amount (LCY)" + DetailedVendorLedgerEntry."Amount (LCY)";
//                               END;
//                               IF DetailedVendorLedgerEntry."Posting Date" <= EndingDate THEN BEGIN
//                                 VendorLedgEntryEndingDate."Remaining Amount" :=
//                                   VendorLedgEntryEndingDate."Remaining Amount" + DetailedVendorLedgerEntry.Amount;
//                                 VendorLedgEntryEndingDate."Remaining Amt. (LCY)" :=
//                                   VendorLedgEntryEndingDate."Remaining Amt. (LCY)" + DetailedVendorLedgerEntry."Amount (LCY)";
//                               END;
//                             END;
//                           UNTIL DetailedVendorLedgerEntry.NEXT = 0;

//                         IF VendorLedgEntryEndingDate."Remaining Amount" = 0 THEN
//                           CurrReport.SKIP;

//                         CASE AgingBy OF
//                           AgingBy::"Due Date":
//                             PeriodIndex := GetPeriodIndex(VendorLedgEntryEndingDate."Due Date");
//                           AgingBy::"Posting Date":
//                             PeriodIndex := GetPeriodIndex(VendorLedgEntryEndingDate."Posting Date");
//                           AgingBy::"Document Date":
//                             BEGIN
//                               IF VendorLedgEntryEndingDate."Document Date" > EndingDate THEN BEGIN
//                                 VendorLedgEntryEndingDate."Remaining Amount" := 0;
//                                 VendorLedgEntryEndingDate."Remaining Amt. (LCY)" := 0;
//                                 VendorLedgEntryEndingDate."Document Date" := VendorLedgEntryEndingDate."Posting Date";
//                               END;
//                               PeriodIndex := GetPeriodIndex(VendorLedgEntryEndingDate."Document Date");
//                             END;
//                         END;
//                         CLEAR(AgedVendorLedgEntry);
//                         AgedVendorLedgEntry[PeriodIndex]."Remaining Amount" := VendorLedgEntryEndingDate."Remaining Amount";
//                         AgedVendorLedgEntry[PeriodIndex]."Remaining Amt. (LCY)" := VendorLedgEntryEndingDate."Remaining Amt. (LCY)";
//                         TotalVendorLedgEntry[PeriodIndex]."Remaining Amount" += VendorLedgEntryEndingDate."Remaining Amount";
//                         TotalVendorLedgEntry[PeriodIndex]."Remaining Amt. (LCY)" += VendorLedgEntryEndingDate."Remaining Amt. (LCY)";
//                         GrandTotalVLERemaingAmtLCY[PeriodIndex] += VendorLedgEntryEndingDate."Remaining Amt. (LCY)";
//                         TotalVendorLedgEntry[1].Amount += VendorLedgEntryEndingDate."Remaining Amount";
//                         TotalVendorLedgEntry[1]."Amount (LCY)" += VendorLedgEntryEndingDate."Remaining Amt. (LCY)";
//                         GrandTotalVLEAmtLCY += VendorLedgEntryEndingDate."Remaining Amt. (LCY)";

//                         IF PrintToExcel THEN
//                           MakeExcelDataBody;
//                     end;

//                     trigger OnPostDataItem()
//                     begin
//                         IF NOT PrintAmountInLCY THEN
//                           UpdateCurrencyTotals;
//                     end;

//                     trigger OnPreDataItem()
//                     begin
//                         IF NOT PrintAmountInLCY THEN
//                           TempVendorLedgEntry.SETRANGE("Currency Code",TempCurrency.Code);
//                     end;
//                 }

//                 trigger OnAfterGetRecord()
//                 begin
//                     CLEAR(TotalVendorLedgEntry);

//                     IF Number = 1 THEN BEGIN
//                       IF NOT TempCurrency.FINDSET(FALSE,FALSE) THEN
//                         CurrReport.BREAK;
//                     END ELSE
//                       IF TempCurrency.NEXT = 0 THEN
//                         CurrReport.BREAK;

//                     IF TempCurrency.Code <> '' THEN
//                       CurrencyCode := TempCurrency.Code
//                     ELSE
//                       CurrencyCode := GLSetup."LCY Code";

//                     NumberOfCurrencies := NumberOfCurrencies + 1;
//                 end;

//                 trigger OnPostDataItem()
//                 begin
//                     IF NewPagePerVendor AND (NumberOfCurrencies > 0) THEN
//                       CurrReport.NEWPAGE;
//                 end;

//                 trigger OnPreDataItem()
//                 begin
//                     NumberOfCurrencies := 0;
//                 end;
//             }

//             trigger OnAfterGetRecord()
//             begin
//                 IF NewPagePerVendor THEN
//                   PageGroupNo := PageGroupNo + 1;

//                 TempCurrency.RESET;
//                 TempCurrency.DELETEALL;
//                 TempVendorLedgEntry.RESET;
//                 TempVendorLedgEntry.DELETEALL;
//                 CLEAR(GrandTotalVLERemaingAmtLCY);
//                 GrandTotalVLEAmtLCY := 0;
//             end;

//             trigger OnPreDataItem()
//             begin
//                 PageGroupNo := 1;
//             end;
//         }
//         dataitem(CurrencyTotals;Table2000000026)
//         {
//             DataItemTableView = SORTING(Number)
//                                 WHERE(Number=FILTER(1..));
//             column(Number_CurrencyTotals;Number)
//             {
//             }
//             column(NewPagePerVend_CurrTotal;NewPagePerVendor)
//             {
//             }
//             column(TempCurrency2Code;TempCurrency2.Code)
//             {
//                 AutoFormatExpression = CurrencyCode;
//                 AutoFormatType = 1;
//             }
//             column(AgedVendLedgEnt6RemAmtLCY5;AgedVendorLedgEntry[6]."Remaining Amount")
//             {
//                 AutoFormatExpression = CurrencyCode;
//                 AutoFormatType = 1;
//             }
//             column(AgedVendLedgEnt1RemAmtLCY1;AgedVendorLedgEntry[1]."Remaining Amount")
//             {
//                 AutoFormatExpression = CurrencyCode;
//                 AutoFormatType = 1;
//             }
//             column(AgedVendLedgEnt2RemAmtLCY2;AgedVendorLedgEntry[2]."Remaining Amount")
//             {
//                 AutoFormatExpression = CurrencyCode;
//                 AutoFormatType = 1;
//             }
//             column(AgedVendLedgEnt3RemAmtLCY3;AgedVendorLedgEntry[3]."Remaining Amount")
//             {
//                 AutoFormatExpression = CurrencyCode;
//                 AutoFormatType = 1;
//             }
//             column(AgedVendLedgEnt4RemAmtLCY4;AgedVendorLedgEntry[4]."Remaining Amount")
//             {
//                 AutoFormatExpression = CurrencyCode;
//                 AutoFormatType = 1;
//             }
//             column(AgedVendLedgEnt5RemAmtLCY5;AgedVendorLedgEntry[5]."Remaining Amount")
//             {
//                 AutoFormatExpression = CurrencyCode;
//                 AutoFormatType = 1;
//             }
//             column(CurrencySpecificationCaption;CurrencySpecificationCaptionLbl)
//             {
//             }

//             trigger OnAfterGetRecord()
//             begin
//                 IF Number = 1 THEN BEGIN
//                   IF NOT TempCurrency2.FINDSET(FALSE,FALSE) THEN
//                     CurrReport.BREAK;
//                 END ELSE
//                   IF TempCurrency2.NEXT = 0 THEN
//                     CurrReport.BREAK;

//                 CLEAR(AgedVendorLedgEntry);
//                 TempCurrencyAmount.SETRANGE("Currency Code",TempCurrency2.Code);
//                 IF TempCurrencyAmount.FINDSET(FALSE,FALSE) THEN
//                   REPEAT
//                     IF TempCurrencyAmount.Date <> 12319999D THEN
//                       AgedVendorLedgEntry[GetPeriodIndex(TempCurrencyAmount.Date)]."Remaining Amount" :=
//                         TempCurrencyAmount.Amount
//                     ELSE
//                       AgedVendorLedgEntry[6]."Remaining Amount" := TempCurrencyAmount.Amount;
//                   UNTIL TempCurrencyAmount.NEXT = 0;
//             end;

//             trigger OnPreDataItem()
//             begin
//                 PageGroupNo := 0;
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
//                     field(AgedAsOf;EndingDate)
//                     {
//                         Caption = 'Aged As Of';
//                     }
//                     field(AgingBy;AgingBy)
//                     {
//                         Caption = 'Aging by';
//                         OptionCaption = 'Due Date,Posting Date,Document Date';
//                     }
//                     field(PeriodLength;PeriodLength)
//                     {
//                         Caption = 'Period Length';
//                     }
//                     field(PrintAmountInLCY;PrintAmountInLCY)
//                     {
//                         Caption = 'Print Amounts in LCY';
//                     }
//                     field(PrintDetails;PrintDetails)
//                     {
//                         Caption = 'Print Details';
//                     }
//                     field(HeadingType;HeadingType)
//                     {
//                         Caption = 'Heading Type';
//                         OptionCaption = 'Date Interval,Number of Days';
//                     }
//                     field(NewPagePerVendor;NewPagePerVendor)
//                     {
//                         Caption = 'New Page per Vendor';
//                     }
//                     field(PrintToExcel;PrintToExcel)
//                     {
//                         Caption = 'Print to Excel';
//                     }
//                 }
//             }
//         }

//         actions
//         {
//         }

//         trigger OnOpenPage()
//         begin
//             IF EndingDate = 0D THEN
//               EndingDate := WORKDATE;
//             PrintToExcel := FALSE;
//         end;
//     }

//     labels
//     {
//     }

//     trigger OnPostReport()
//     begin
//         IF PrintToExcel THEN
//           CreateExcelbook;
//     end;

//     trigger OnPreReport()
//     begin
//         VendorFilter := Vendor.GETFILTERS;

//         GLSetup.GET;

//         CalcDates;
//         CreateHeadings;

//         IF PrintToExcel THEN
//           MakeExcelInfo;
//     end;

//     var
//         GLSetup: Record "98";
//         TempVendorLedgEntry: Record "25" temporary;
//         VendorLedgEntryEndingDate: Record "25";
//         TotalVendorLedgEntry: array [5] of Record "25";
//         AgedVendorLedgEntry: array [6] of Record "25";
//         TempCurrency: Record "4" temporary;
//         TempCurrency2: Record "4" temporary;
//         TempCurrencyAmount: Record "264" temporary;
//         TempExcelBuf: Record "370" temporary;
//         DetailedVendorLedgerEntry: Record "380";
//         GrandTotalVLERemaingAmtLCY: array [5] of Decimal;
//         GrandTotalVLEAmtLCY: Decimal;
//         VendorFilter: Text;
//         PrintAmountInLCY: Boolean;
//         EndingDate: Date;
//         AgingBy: Option "Due Date","Posting Date","Document Date";
//         PeriodLength: DateFormula;
//         PrintDetails: Boolean;
//         HeadingType: Option "Date Interval","Number of Days";
//         NewPagePerVendor: Boolean;
//         PeriodStartDate: array [5] of Date;
//         PeriodEndDate: array [5] of Date;
//         HeaderText: array [5] of Text[30];
//         Text000: Label 'Not Due';
//         Text001: Label 'Before';
//         CurrencyCode: Code[10];
//         Text002: Label 'days';
//         Text003: Label 'More than';
//         Text004: Label 'Aged by %1';
//         Text005: Label 'Total for %1';
//         Text006: Label 'Aged as of %1';
//         Text007: Label 'Aged by %1';
//         AllAmountsInLCYTxt: Label 'All Amounts in LCY';
//         NumberOfCurrencies: Integer;
//         Text009: Label 'Due Date,Posting Date,Document Date';
//         Text010: Label 'The Date Formula %1 cannot be used. Try to restate it. E.g. 1M+CM instead of CM+1M.';
//         PageGroupNo: Integer;
//         PrintToExcel: Boolean;
//         DataTxt: Label 'Data';
//         AgedAccountsPayableTxt: Label 'Aged Accounts Payable';
//         CompanyNameTxt: Label 'Company Name';
//         ReportNoTxt: Label 'Report No.';
//         ReportNameTxt: Label 'Report Name';
//         UserIDTxt: Label 'User ID';
//         DateTxt: Label 'Date';
//         VendorFiltersTxt: Label 'Vendor Filters';
//         VendLedgerEntryFiltersTxt: Label 'Vend. Ledger Entry Filters';
//         Text011: Label 'Enter a date formula in the Period Length field.';
//         Text027: Label '-%1', Comment='Negating the period length: %1 is the period length';
//         AgedAcctPayableCaptionLbl: Label 'Aged Accounts Payable';
//         CurrReportPageNoCaptionLbl: Label 'Page';
//         AllAmtsinLCYCaptionLbl: Label 'All Amounts in LCY';
//         AgedOverdueAmsCaptionLbl: Label 'Aged Overdue Amounts';
//         GrandTotalVLE5RemAmtLCYCaptionLbl: Label 'Balance';
//         AmountLCYCaptionLbl: Label 'Original Amount';
//         DueDateCaptionLbl: Label 'Due Date';
//         DocumentNoCaptionLbl: Label 'Document No.';
//         PostingDateCaptionLbl: Label 'Posting Date';
//         DocumentTypeCaptionLbl: Label 'Document Type';
//         CurrencyCaptionLbl: Label 'Currency Code';
//         TotalLCYCaptionLbl: Label 'Total (LCY)';
//         CurrencySpecificationCaptionLbl: Label 'Currency Specification';
//         ExternalDocNo: Text;
//         DocumentDate: Date;

//     local procedure CalcDates()
//     var
//         i: Integer;
//         PeriodLength2: DateFormula;
//     begin
//         IF NOT EVALUATE(PeriodLength2,STRSUBSTNO(Text027,PeriodLength)) THEN
//           ERROR(Text011);
//         IF AgingBy = AgingBy::"Due Date" THEN BEGIN
//           PeriodEndDate[1] := 12319999D;
//           PeriodStartDate[1] := EndingDate + 1;
//         END ELSE BEGIN
//           PeriodEndDate[1] := EndingDate;
//           PeriodStartDate[1] := CALCDATE(PeriodLength2,EndingDate + 1);
//         END;
//         FOR i := 2 TO ARRAYLEN(PeriodEndDate) DO BEGIN
//           PeriodEndDate[i] := PeriodStartDate[i - 1] - 1;
//           PeriodStartDate[i] := CALCDATE(PeriodLength2,PeriodEndDate[i] + 1);
//         END;

//         i := ARRAYLEN(PeriodEndDate);

//         PeriodStartDate[i] := 0D;

//         FOR i := 1 TO ARRAYLEN(PeriodEndDate) DO
//           IF PeriodEndDate[i] < PeriodStartDate[i] THEN
//             ERROR(Text010,PeriodLength);
//     end;

//     local procedure CreateHeadings()
//     var
//         i: Integer;
//     begin
//         IF AgingBy = AgingBy::"Due Date" THEN BEGIN
//           HeaderText[1] := Text000;
//           i := 2;
//         END ELSE
//           i := 1;
//         WHILE i < ARRAYLEN(PeriodEndDate) DO BEGIN
//           IF HeadingType = HeadingType::"Date Interval" THEN
//             HeaderText[i] := STRSUBSTNO('%1\..%2',PeriodStartDate[i],PeriodEndDate[i])
//           ELSE
//             HeaderText[i] :=
//               STRSUBSTNO('%1 - %2 %3',EndingDate - PeriodEndDate[i] + 1,EndingDate - PeriodStartDate[i] + 1,Text002);
//           i := i + 1;
//         END;
//         IF HeadingType = HeadingType::"Date Interval" THEN
//           HeaderText[i] := STRSUBSTNO('%1\%2',Text001,PeriodStartDate[i - 1])
//         ELSE
//           HeaderText[i] := STRSUBSTNO('%1\%2 %3',Text003,EndingDate - PeriodStartDate[i - 1] + 1,Text002);
//     end;

//     local procedure InsertTemp(var VendorLedgEntry: Record "25")
//     var
//         Currency: Record "4";
//     begin
//         WITH TempVendorLedgEntry DO BEGIN
//           IF GET(VendorLedgEntry."Entry No.") THEN
//             EXIT;
//           TempVendorLedgEntry := VendorLedgEntry;
//           INSERT;
//           IF PrintAmountInLCY THEN BEGIN
//             CLEAR(TempCurrency);
//             TempCurrency."Amount Rounding Precision" := GLSetup."Amount Rounding Precision";
//             IF TempCurrency.INSERT THEN;
//             EXIT;
//           END;
//           IF TempCurrency.GET("Currency Code") THEN
//             EXIT;
//           IF "Currency Code" <> '' THEN
//             Currency.GET("Currency Code")
//           ELSE BEGIN
//             CLEAR(Currency);
//             Currency."Amount Rounding Precision" := GLSetup."Amount Rounding Precision";
//           END;
//           TempCurrency := Currency;
//           TempCurrency.INSERT;
//         END;
//     end;

//     local procedure GetPeriodIndex(Date: Date): Integer
//     var
//         i: Integer;
//     begin
//         FOR i := 1 TO ARRAYLEN(PeriodEndDate) DO
//           IF Date IN [PeriodStartDate[i]..PeriodEndDate[i]] THEN
//             EXIT(i);
//     end;

//     local procedure UpdateCurrencyTotals()
//     var
//         i: Integer;
//     begin
//         TempCurrency2.Code := CurrencyCode;
//         IF TempCurrency2.INSERT THEN;
//         WITH TempCurrencyAmount DO BEGIN
//           FOR i := 1 TO ARRAYLEN(TotalVendorLedgEntry) DO BEGIN
//             "Currency Code" := CurrencyCode;
//             Date := PeriodStartDate[i];
//             IF FIND THEN BEGIN
//               Amount := Amount + TotalVendorLedgEntry[i]."Remaining Amount";
//               MODIFY;
//             END ELSE BEGIN
//               "Currency Code" := CurrencyCode;
//               Date := PeriodStartDate[i];
//               Amount := TotalVendorLedgEntry[i]."Remaining Amount";
//               INSERT;
//             END;
//           END;
//           "Currency Code" := CurrencyCode;
//           Date := 12319999D;
//           IF FIND THEN BEGIN
//             Amount := Amount + TotalVendorLedgEntry[1].Amount;
//             MODIFY;
//           END ELSE BEGIN
//             "Currency Code" := CurrencyCode;
//             Date := 12319999D;
//             Amount := TotalVendorLedgEntry[1].Amount;
//             INSERT;
//           END;
//         END;
//     end;

//     procedure MakeExcelInfo()
//     begin
//         TempExcelBuf.SetUseInfoSheet;
//         TempExcelBuf.AddInfoColumn(FORMAT(CompanyNameTxt),FALSE,'',TRUE,FALSE,FALSE,'',TempExcelBuf."Cell Type"::Text);
//         TempExcelBuf.AddInfoColumn(COMPANYNAME,FALSE,'',FALSE,FALSE,FALSE,'',TempExcelBuf."Cell Type"::Text);
//         TempExcelBuf.NewRow;
//         TempExcelBuf.AddInfoColumn(FORMAT(ReportNameTxt),FALSE,'',TRUE,FALSE,FALSE,'',TempExcelBuf."Cell Type"::Text);
//         TempExcelBuf.AddInfoColumn(
//           FORMAT(AgedAccountsPayableTxt),FALSE,'',FALSE,FALSE,FALSE,'',TempExcelBuf."Cell Type"::Text);
//         TempExcelBuf.NewRow;
//         TempExcelBuf.AddInfoColumn(FORMAT(ReportNoTxt),FALSE,'',TRUE,FALSE,FALSE,'',TempExcelBuf."Cell Type"::Text);
//         TempExcelBuf.AddInfoColumn(
//           REPORT::"Aged Accounts Payable",FALSE,'',FALSE,FALSE,FALSE,'',TempExcelBuf."Cell Type"::Number);
//         TempExcelBuf.NewRow;
//         TempExcelBuf.AddInfoColumn(FORMAT(UserIDTxt),FALSE,'',TRUE,FALSE,FALSE,'',TempExcelBuf."Cell Type"::Text);
//         TempExcelBuf.AddInfoColumn(USERID,FALSE,'',FALSE,FALSE,FALSE,'',TempExcelBuf."Cell Type"::Text);
//         TempExcelBuf.NewRow;
//         TempExcelBuf.AddInfoColumn(FORMAT(DateTxt),FALSE,'',TRUE,FALSE,FALSE,'',TempExcelBuf."Cell Type"::Text);
//         TempExcelBuf.AddInfoColumn(TODAY,FALSE,'',FALSE,FALSE,FALSE,'',TempExcelBuf."Cell Type"::Date);
//         TempExcelBuf.NewRow;
//         TempExcelBuf.AddInfoColumn(
//           FORMAT(VendorFiltersTxt),FALSE,'',TRUE,FALSE,FALSE,'',TempExcelBuf."Cell Type"::Text);
//         TempExcelBuf.AddInfoColumn(Vendor.GETFILTERS,FALSE,'',FALSE,FALSE,FALSE,'',TempExcelBuf."Cell Type"::Text);
//         TempExcelBuf.NewRow;
//         TempExcelBuf.AddInfoColumn(
//           FORMAT(VendLedgerEntryFiltersTxt),FALSE,'',TRUE,FALSE,FALSE,'',TempExcelBuf."Cell Type"::Text);
//         TempExcelBuf.AddInfoColumn(
//           "Vendor Ledger Entry".GETFILTERS,FALSE,'',FALSE,FALSE,FALSE,'',TempExcelBuf."Cell Type"::Text);
//         IF PrintAmountInLCY THEN BEGIN
//           TempExcelBuf.NewRow;
//           TempExcelBuf.AddInfoColumn(
//             FORMAT(AllAmountsInLCYTxt),FALSE,'',TRUE,FALSE,FALSE,'',TempExcelBuf."Cell Type"::Text);
//           TempExcelBuf.AddInfoColumn(PrintAmountInLCY,FALSE,'',FALSE,FALSE,FALSE,'',TempExcelBuf."Cell Type"::Text);
//         END;
//         TempExcelBuf.NewRow;
//         TempExcelBuf.AddInfoColumn(
//           FORMAT(COPYSTR(Text004,1,7)),FALSE,'',TRUE,FALSE,FALSE,'',TempExcelBuf."Cell Type"::Text);
//         TempExcelBuf.AddInfoColumn(
//           FORMAT(SELECTSTR(AgingBy + 1,Text009)),FALSE,'',FALSE,FALSE,FALSE,'',TempExcelBuf."Cell Type"::Text);
//         TempExcelBuf.ClearNewRow;
//         MakeExcelDataHeader;
//     end;

//     local procedure MakeExcelDataHeader()
//     begin
//         TempExcelBuf.NewRow;
//         TempExcelBuf.AddColumn(Vendor.FIELDCAPTION("No."),FALSE,'',TRUE,FALSE,TRUE,'',TempExcelBuf."Cell Type"::Text);
//         TempExcelBuf.AddColumn(Vendor.FIELDCAPTION(Name),FALSE,'',TRUE,FALSE,TRUE,'',TempExcelBuf."Cell Type"::Text);
//         TempExcelBuf.AddColumn(
//           TempVendorLedgEntry.FIELDCAPTION("Posting Date"),FALSE,'',TRUE,FALSE,TRUE,'',TempExcelBuf."Cell Type"::Text);
//         TempExcelBuf.AddColumn(
//           TempVendorLedgEntry.FIELDCAPTION("Document Type"),FALSE,'',TRUE,FALSE,TRUE,'',TempExcelBuf."Cell Type"::Text);
//         TempExcelBuf.AddColumn(
//           TempVendorLedgEntry.FIELDCAPTION("Document No."),FALSE,'',TRUE,FALSE,TRUE,'',TempExcelBuf."Cell Type"::Text);
//         TempExcelBuf.AddColumn(
//           TempVendorLedgEntry.FIELDCAPTION("Due Date"),FALSE,'',TRUE,FALSE,TRUE,'',TempExcelBuf."Cell Type"::Text);
//         IF NOT PrintAmountInLCY THEN BEGIN
//           TempExcelBuf.AddColumn(
//             TempVendorLedgEntry.FIELDCAPTION("Currency Code"),FALSE,'',TRUE,FALSE,TRUE,'',TempExcelBuf."Cell Type"::Text);
//           TempExcelBuf.AddColumn(
//             TempVendorLedgEntry.FIELDCAPTION("Original Amount"),FALSE,'',TRUE,FALSE,TRUE,'',TempExcelBuf."Cell Type"::Text);
//           TempExcelBuf.AddColumn(
//             TempVendorLedgEntry.FIELDCAPTION("Remaining Amount"),FALSE,'',TRUE,FALSE,TRUE,'',TempExcelBuf."Cell Type"::Text);
//         END ELSE BEGIN
//           TempExcelBuf.AddColumn(
//             TempVendorLedgEntry.FIELDCAPTION("Original Amt. (LCY)"),FALSE,'',TRUE,FALSE,TRUE,'',TempExcelBuf."Cell Type"::Text);
//           TempExcelBuf.AddColumn(
//             TempVendorLedgEntry.FIELDCAPTION("Remaining Amt. (LCY)"),FALSE,'',TRUE,FALSE,TRUE,'',TempExcelBuf."Cell Type"::Text);
//         END;
//     end;

//     procedure MakeExcelDataBody()
//     begin
//         TempExcelBuf.NewRow;
//         TempExcelBuf.AddColumn(Vendor."No.",FALSE,'',FALSE,FALSE,FALSE,'',TempExcelBuf."Cell Type"::Text);
//         TempExcelBuf.AddColumn(Vendor.Name,FALSE,'',FALSE,FALSE,FALSE,'',TempExcelBuf."Cell Type"::Text);
//         TempExcelBuf.AddColumn(
//           TempVendorLedgEntry."Posting Date",FALSE,'',FALSE,FALSE,FALSE,'',TempExcelBuf."Cell Type"::Date);
//         TempExcelBuf.AddColumn(
//           FORMAT(TempVendorLedgEntry."Document Type"),FALSE,'',FALSE,FALSE,FALSE,'',TempExcelBuf."Cell Type"::Text);
//         TempExcelBuf.AddColumn(
//           TempVendorLedgEntry."Document No.",FALSE,'',FALSE,FALSE,FALSE,'',TempExcelBuf."Cell Type"::Text);
//         TempExcelBuf.AddColumn(
//           TempVendorLedgEntry."Due Date",FALSE,'',FALSE,FALSE,FALSE,'',TempExcelBuf."Cell Type"::Date);
//         IF PrintAmountInLCY THEN BEGIN
//           TempExcelBuf.AddColumn(
//             VendorLedgEntryEndingDate."Amount (LCY)",FALSE,'',FALSE,FALSE,FALSE,'#,##0.00',TempExcelBuf."Cell Type"::Number);
//           TempExcelBuf.AddColumn(
//             VendorLedgEntryEndingDate."Remaining Amt. (LCY)",FALSE,'',FALSE,FALSE,FALSE,'#,##0.00',TempExcelBuf."Cell Type"::Number);
//         END ELSE BEGIN
//           TempExcelBuf.AddColumn(CurrencyCode,FALSE,'',FALSE,FALSE,FALSE,'',TempExcelBuf."Cell Type"::Text);
//           TempExcelBuf.AddColumn(
//             VendorLedgEntryEndingDate.Amount,FALSE,'',FALSE,FALSE,FALSE,'#,##0.00',TempExcelBuf."Cell Type"::Number);
//           TempExcelBuf.AddColumn(
//             VendorLedgEntryEndingDate."Remaining Amount",FALSE,'',FALSE,FALSE,FALSE,'#,##0.00',TempExcelBuf."Cell Type"::Number);
//         END;
//     end;

//     procedure CreateExcelbook()
//     begin
//         TempExcelBuf.CreateBookAndOpenExcel(DataTxt,AgedAccountsPayableTxt,COMPANYNAME,USERID);
//         ERROR('');
//     end;

//     procedure InitializeRequest(NewEndingDate: Date;NewAgingBy: Option;NewPeriodLength: DateFormula;NewPrintAmountInLCY: Boolean;NewPrintDetails: Boolean;NewHeadingType: Option;NewNewPagePerVendor: Boolean)
//     begin
//         EndingDate := NewEndingDate;
//         AgingBy := NewAgingBy;
//         PeriodLength := NewPeriodLength;
//         PrintAmountInLCY := NewPrintAmountInLCY;
//         PrintDetails := NewPrintDetails;
//         HeadingType := NewHeadingType;
//         NewPagePerVendor := NewNewPagePerVendor;
//     end;
// }

