// report 5802 "Inventory Valuation - WIP"
// {
//     DefaultLayout = RDLC;
//     RDLCLayout = './Inventory Valuation - WIP.rdlc';
//     Caption = 'Inventory Valuation - WIP';

//     dataset
//     {
//         dataitem(DataItem4824;Table5405)
//         {
//             DataItemTableView = WHERE(Status=FILTER(Released..));
//             PrintOnlyIfDetail = true;
//             RequestFilterFields = Status,"No.";
//             column(CompanyName;COMPANYNAME)
//             {
//             }
//             column(TodayFormatted;FORMAT(TODAY,0,4))
//             {
//             }
//             column(ProdOrderFilter;ProdOrderFilter)
//             {
//             }
//             column(AsOfStartDateText;STRSUBSTNO(Text005,StartDateText))
//             {
//             }
//             column(AsofEndDate;STRSUBSTNO(Text005,FORMAT(EndDate)))
//             {
//             }
//             column(No_ProductionOrder;"No.")
//             {
//             }
//             column(SourceNo_ProductionOrder;"Source No.")
//             {
//             }
//             column(SrcType_ProductionOrder;"Source Type")
//             {
//             }
//             column(Desc_ProductionOrder;Description)
//             {
//             }
//             column(Status_ProductionOrder;Status)
//             {
//             }
//             column(InventoryValuationWIPCptn;InventoryValuationWIPCptnLbl)
//             {
//             }
//             column(CurrReportPageNoCaption;CurrReportPageNoCaptionLbl)
//             {
//             }
//             column(ValueOfCapCaption;ValueOfCapCaptionLbl)
//             {
//             }
//             column(ValueOfOutputCaption;ValueOfOutputCaptionLbl)
//             {
//             }
//             column(ValueEntryCostPostedtoGLCaption;ValueEntryCostPostedtoGLCaptionLbl)
//             {
//             }
//             column(ValueOfMatConsumpCaption;ValueOfMatConsumpCaptionLbl)
//             {
//             }
//             column(ProductionOrderNoCaption;ProductionOrderNoCaptionLbl)
//             {
//             }
//             column(ProdOrderStatusCaption;ProdOrderStatusCaptionLbl)
//             {
//             }
//             column(ProdOrderDescriptionCaption;ProdOrderDescriptionCaptionLbl)
//             {
//             }
//             column(ProdOrderSourceTypeCaptn;ProdOrderSourceTypeCaptnLbl)
//             {
//             }
//             column(ProdOrderSourceNoCaption;ProdOrderSourceNoCaptionLbl)
//             {
//             }
//             column(TotalCaption;TotalCaptionLbl)
//             {
//             }
//             dataitem(DataItem8894;Table5802)
//             {
//                 DataItemTableView = SORTING(Order Type,Order No.);
//                 column(ValueEntryCostPostedtoGL;TotalValueOfCostPstdToGL)
//                 {
//                     AutoFormatType = 1;
//                 }
//                 column(ValueOfOutput;TotalValueOfOutput)
//                 {
//                     AutoFormatType = 1;
//                 }
//                 column(ValueOfCap;TotalValueOfCap)
//                 {
//                     AutoFormatType = 1;
//                 }
//                 column(ValueOfMatConsump;TotalValueOfMatConsump)
//                 {
//                     AutoFormatType = 1;
//                 }
//                 column(ValueOfWIP;TotalValueOfWIP)
//                 {
//                     AutoFormatType = 1;
//                 }
//                 column(LastOutput;TotalLastOutput)
//                 {
//                 }
//                 column(AtLastDate;TotalAtLastDate)
//                 {
//                 }
//                 column(LastWIP;TotalLastWIP)
//                 {
//                 }

//                 trigger OnAfterGetRecord()
//                 begin
//                     CountRecord := CountRecord + 1;
//                     LastOutput := 0;
//                     AtLastDate := 0;
//                     LastWIP := 0;

//                     IF (CountRecord = LengthRecord) AND IsNotWIP THEN BEGIN
//                       ValueEntryOnPostDataItem("Value Entry");

//                       AtLastDate := NcValueOfWIP + NcValueOfMatConsump + NcValueOfCap + NcValueOfOutput;
//                       LastOutput := NcValueOfOutput;
//                       LastWIP := NcValueOfWIP;
//                       ValueOfCostPstdToGL := NcValueOfCostPstdToGL;

//                       NcValueOfWIP := 0;
//                       NcValueOfOutput := 0;
//                       NcValueOfMatConsump := 0;
//                       NcValueOfCap := 0;
//                       NcValueOfInvOutput1 := 0;
//                       NcValueOfExpOutPut1 := 0;
//                       NcValueOfExpOutPut2 := 0;
//                       NcValueOfRevalCostAct := 0;
//                       NcValueOfRevalCostPstd := 0;
//                       NcValueOfCostPstdToGL := 0;
//                     END;

//                     IF NOT IsNotWIP THEN BEGIN
//                       ValueOfWIP := 0;
//                       ValueOfMatConsump := 0;
//                       ValueOfCap := 0;
//                       ValueOfOutput := 0;
//                       ValueOfInvOutput1 := 0;
//                       ValueOfExpOutput1 := 0;
//                       ValueOfExpOutput2 := 0;
//                       IF EntryFound THEN
//                         ValueOfCostPstdToGL := "Cost Posted to G/L";

//                       IF "Posting Date" < StartDate THEN BEGIN
//                         IF "Item Ledger Entry Type" = "Item Ledger Entry Type"::" " THEN
//                           ValueOfWIP := "Cost Amount (Actual)"
//                         ELSE
//                           ValueOfWIP := -"Cost Amount (Actual)";
//                         IF "Item Ledger Entry Type" = "Item Ledger Entry Type"::Output THEN BEGIN
//                           ValueOfExpOutput1 := -"Cost Amount (Expected)";
//                           ValueOfInvOutput1 := -"Cost Amount (Actual)";
//                           ValueOfWIP := ValueOfExpOutput1 + ValueOfInvOutput1;
//                         END;

//                         IF ("Entry Type" = "Entry Type"::Revaluation) AND ("Cost Amount (Actual)" <> 0) THEN
//                           ValueOfWIP := 0;
//                       END ELSE
//                         CASE "Item Ledger Entry Type" OF
//                           "Item Ledger Entry Type"::Consumption:
//                             IF IsProductionCost("Value Entry") THEN
//                               ValueOfMatConsump := -"Cost Amount (Actual)";
//                           "Item Ledger Entry Type"::" ":
//                             ValueOfCap := "Cost Amount (Actual)";
//                           "Item Ledger Entry Type"::Output:
//                             BEGIN
//                               ValueOfExpOutput2 := -"Cost Amount (Expected)";
//                               ValueOfOutput := -("Cost Amount (Actual)" + "Cost Amount (Expected)");
//                               IF "Entry Type" = "Entry Type"::Revaluation THEN
//                                 ValueOfRevalCostAct += -"Cost Amount (Actual)";
//                             END;
//                         END;

//                       IF NOT ("Item Ledger Entry Type" = "Item Ledger Entry Type"::" ") THEN BEGIN
//                         "Cost Amount (Actual)" := -"Cost Amount (Actual)";
//                         IF IsProductionCost("Value Entry") THEN BEGIN
//                           ValueOfCostPstdToGL := -("Cost Posted to G/L" + "Expected Cost Posted to G/L");
//                           IF "Entry Type" = "Entry Type"::Revaluation THEN
//                             ValueOfRevalCostPstd += ValueOfCostPstdToGL;
//                         END ELSE
//                           ValueOfCostPstdToGL := 0;
//                       END ELSE
//                         ValueOfCostPstdToGL := "Cost Posted to G/L" + "Expected Cost Posted to G/L";

//                       NcValueOfWIP := NcValueOfWIP + ValueOfWIP;
//                       NcValueOfOutput := NcValueOfOutput + ValueOfOutput;
//                       NcValueOfMatConsump := NcValueOfMatConsump + ValueOfMatConsump;
//                       NcValueOfCap := NcValueOfCap + ValueOfCap;
//                       NcValueOfInvOutput1 := NcValueOfInvOutput1 + ValueOfInvOutput1;
//                       NcValueOfExpOutPut1 := NcValueOfExpOutPut1 + ValueOfExpOutput1;
//                       NcValueOfExpOutPut2 := NcValueOfExpOutPut2 + ValueOfExpOutput2;
//                       NcValueOfRevalCostAct := ValueOfRevalCostAct;
//                       NcValueOfRevalCostPstd := ValueOfRevalCostPstd;
//                       NcValueOfCostPstdToGL := NcValueOfCostPstdToGL + ValueOfCostPstdToGL;
//                       ValueOfCostPstdToGL := 0;

//                       IF CountRecord = LengthRecord THEN BEGIN
//                         ValueEntryOnPostDataItem("Value Entry");
//                         ValueOfCostPstdToGL := NcValueOfCostPstdToGL;

//                         AtLastDate := NcValueOfWIP + NcValueOfMatConsump + NcValueOfCap + NcValueOfOutput;
//                         LastOutput := NcValueOfOutput;
//                         LastWIP := NcValueOfWIP;

//                         NcValueOfWIP := 0;
//                         NcValueOfOutput := 0;
//                         NcValueOfMatConsump := 0;
//                         NcValueOfCap := 0;
//                         NcValueOfInvOutput1 := 0;
//                         NcValueOfExpOutPut1 := 0;
//                         NcValueOfExpOutPut2 := 0;
//                         NcValueOfRevalCostAct := 0;
//                         NcValueOfRevalCostPstd := 0;
//                         NcValueOfCostPstdToGL := 0;
//                       END;
//                     END;

//                     TotalValueOfCostPstdToGL := TotalValueOfCostPstdToGL + ValueOfCostPstdToGL;
//                     TotalValueOfOutput := TotalValueOfOutput + ValueOfOutput;
//                     TotalValueOfCap := TotalValueOfCap + ValueOfCap;
//                     TotalValueOfMatConsump := TotalValueOfMatConsump + ValueOfMatConsump;
//                     TotalValueOfWIP := TotalValueOfWIP + ValueOfWIP;
//                     TotalLastOutput := TotalLastOutput + LastOutput;
//                     TotalAtLastDate := TotalAtLastDate + AtLastDate;
//                     TotalLastWIP := TotalLastWIP + LastWIP;

//                     IF CountRecord <> LengthRecord THEN
//                       CurrReport.SKIP;
//                 end;

//                 trigger OnPostDataItem()
//                 begin
//                     ValueEntryOnPostDataItem("Value Entry");
//                 end;

//                 trigger OnPreDataItem()
//                 begin
//                     TotalValueOfCostPstdToGL := 0;
//                     TotalValueOfOutput := 0;
//                     TotalValueOfCap := 0;
//                     TotalValueOfMatConsump := 0;
//                     TotalValueOfWIP := 0;
//                     TotalLastOutput := 0;
//                     TotalAtLastDate := 0;
//                     TotalLastWIP := 0;

//                     SETRANGE("Order Type","Order Type"::Production);
//                     SETRANGE("Order No.","Production Order"."No.");
//                     IF EndDate <> 0D THEN
//                       SETRANGE("Posting Date",0D,EndDate);

//                     ValueOfRevalCostAct := 0;
//                     ValueOfRevalCostPstd := 0;
//                     LengthRecord := 0;
//                     CountRecord := 0;

//                     IF FIND('-') THEN
//                       REPEAT
//                         LengthRecord := LengthRecord + 1;
//                       UNTIL  NEXT = 0;
//                 end;
//             }

//             trigger OnAfterGetRecord()
//             begin
//                 IF FinishedProdOrderHasNoValueEntry("Production Order") THEN
//                   CurrReport.SKIP;
//                 EntryFound := ValueEntryExist("Production Order",StartDate,EndDate);
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
//                     field(StartingDate;StartDate)
//                     {
//                         Caption = 'Starting Date';
//                     }
//                     field(EndingDate;EndDate)
//                     {
//                         Caption = 'Ending Date';
//                     }
//                 }
//             }
//         }

//         actions
//         {
//         }

//         trigger OnOpenPage()
//         begin
//             IF (StartDate = 0D) AND (EndDate = 0D) THEN
//               EndDate := WORKDATE;
//         end;
//     }

//     labels
//     {
//     }

//     trigger OnPreReport()
//     begin
//         ProdOrderFilter := "Production Order".GETFILTERS;
//         IF (StartDate = 0D) AND (EndDate = 0D) THEN
//           EndDate := WORKDATE;

//         IF StartDate IN [0D,01010000D] THEN
//           StartDateText := ''
//         ELSE
//           StartDateText := FORMAT(StartDate - 1);
//     end;

//     var
//         Text005: Label 'As of %1';
//         StartDate: Date;
//         EndDate: Date;
//         ProdOrderFilter: Text;
//         StartDateText: Text[10];
//         ValueOfWIP: Decimal;
//         ValueOfMatConsump: Decimal;
//         ValueOfCap: Decimal;
//         ValueOfOutput: Decimal;
//         ValueOfExpOutput1: Decimal;
//         ValueOfInvOutput1: Decimal;
//         ValueOfExpOutput2: Decimal;
//         ValueOfRevalCostAct: Decimal;
//         ValueOfRevalCostPstd: Decimal;
//         ValueOfCostPstdToGL: Decimal;
//         NcValueOfWIP: Decimal;
//         NcValueOfOutput: Decimal;
//         NcValueOfMatConsump: Decimal;
//         NcValueOfCap: Decimal;
//         NcValueOfInvOutput1: Decimal;
//         NcValueOfExpOutPut1: Decimal;
//         NcValueOfExpOutPut2: Decimal;
//         NcValueOfRevalCostAct: Decimal;
//         NcValueOfRevalCostPstd: Decimal;
//         NcValueOfCostPstdToGL: Decimal;
//         LastOutput: Decimal;
//         LengthRecord: Integer;
//         CountRecord: Integer;
//         AtLastDate: Decimal;
//         LastWIP: Decimal;
//         TotalValueOfCostPstdToGL: Decimal;
//         TotalValueOfOutput: Decimal;
//         TotalValueOfCap: Decimal;
//         TotalValueOfMatConsump: Decimal;
//         TotalValueOfWIP: Decimal;
//         TotalLastOutput: Decimal;
//         TotalAtLastDate: Decimal;
//         TotalLastWIP: Decimal;
//         InventoryValuationWIPCptnLbl: Label 'Inventory Valuation - WIP';
//         CurrReportPageNoCaptionLbl: Label 'Page';
//         ValueOfCapCaptionLbl: Label 'Capacity ';
//         ValueOfOutputCaptionLbl: Label 'Output ';
//         ValueEntryCostPostedtoGLCaptionLbl: Label 'Cost Posted to G/L';
//         ValueOfMatConsumpCaptionLbl: Label 'Consumption ';
//         ProductionOrderNoCaptionLbl: Label 'No.';
//         ProdOrderStatusCaptionLbl: Label 'Status';
//         ProdOrderDescriptionCaptionLbl: Label 'Description';
//         ProdOrderSourceTypeCaptnLbl: Label 'Source Type';
//         ProdOrderSourceNoCaptionLbl: Label 'Source No.';
//         TotalCaptionLbl: Label 'Total';
//         EntryFound: Boolean;

//     procedure ValueEntryOnPostDataItem(ValueEntry: Record "5802")
//     begin
//         WITH ValueEntry DO
//           IF (NcValueOfExpOutPut2 + NcValueOfExpOutPut1) = 0 THEN BEGIN // if prod. order is invoiced
//             NcValueOfOutput := NcValueOfOutput - NcValueOfRevalCostAct; // take out revalued differnce
//             NcValueOfCostPstdToGL := NcValueOfCostPstdToGL - NcValueOfRevalCostPstd; // take out Cost posted to G/L
//           END;
//     end;

//     procedure IsNotWIP(): Boolean
//     begin
//         WITH "Value Entry" DO BEGIN
//           IF "Item Ledger Entry Type" = "Item Ledger Entry Type"::Output THEN
//             EXIT(NOT ("Entry Type" IN ["Entry Type"::"Direct Cost",
//                                        "Entry Type"::Revaluation]));

//           EXIT("Expected Cost");
//         END;
//     end;

//     procedure IsProductionCost(ValueEntry: Record "5802"): Boolean
//     var
//         ILE: Record "32";
//     begin
//         WITH ValueEntry DO
//           IF ("Entry Type" = "Entry Type"::Revaluation) AND ("Item Ledger Entry Type" = "Item Ledger Entry Type"::Consumption) THEN BEGIN
//             ILE.GET("Item Ledger Entry No.");
//             IF ILE.Positive THEN
//               EXIT(FALSE)
//           END;

//         EXIT(TRUE);
//     end;

//     procedure FinishedProdOrderHasNoValueEntry(ProductionOrder: Record "5405"): Boolean
//     begin
//         IF ProductionOrder.Status <> ProductionOrder.Status::Finished THEN
//           EXIT(FALSE);
//         EXIT(NOT ValueEntryExist(ProductionOrder,StartDate,12319999D));
//     end;

//     procedure InitializeRequest(NewStartDate: Date;NewEndDate: Date)
//     begin
//         StartDate := NewStartDate;
//         EndDate := NewEndDate;
//     end;

//     procedure ValueEntryExist(ProductionOrder: Record "5405";StartDate: Date;EndDate: Date): Boolean
//     var
//         ValueEntry: Record "5802";
//     begin
//         WITH ValueEntry DO BEGIN
//           SETRANGE("Order Type","Order Type"::Production);
//           SETRANGE("Order No.",ProductionOrder."No.");
//           SETRANGE("Posting Date",StartDate,EndDate);
//           EXIT(NOT ISEMPTY);
//         END;
//     end;
// }

