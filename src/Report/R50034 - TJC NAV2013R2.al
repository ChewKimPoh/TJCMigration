// report 50034 "Retail Commission(Retail Staff"
// {
//     // 
//     // Retail Commission(Retail Staff - 50034
//     // Version No.         : TJCSG1.00
//     // Developer           : DP.AYD
//     // Init. DEV. Date     : 28/05/2014
//     // Date of last Change : 28/05/2014
//     // Description         : Based on DD#124 https://dptech.mydonedone.com/issuetracker/projects/4350/issues/124
//     // 
//     // TJCSG1.00 Update :
//     // 1. Remark User Table
//     DefaultLayout = RDLC;
//     RDLCLayout = './Retail Commission(Retail Staff.rdlc';


//     dataset
//     {
//         dataitem(DataItem5581;Table112)
//         {
//             DataItemTableView = SORTING(Posting Date,Sell-to Customer No.);
//             PrintOnlyIfDetail = true;
//             column(CurrReport_PAGENO;CurrReport.PAGENO)
//             {
//             }
//             column(FORMAT_TODAY_0_4_;FORMAT(TODAY,0,4))
//             {
//             }
//             column(USERID;USERID)
//             {
//             }
//             column(COMPANYNAME;COMPANYNAME)
//             {
//             }
//             column(STRSUBSTNO_Text005_PostingDateFrom_PostingDateTo_;STRSUBSTNO(Text005,PostingDateFrom,PostingDateTo))
//             {
//             }
//             column(SalesAmount;SalesAmount)
//             {
//             }
//             column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
//             {
//             }
//             column(Retail_Commission__Retail_Staffs_Caption;Retail_Commission__Retail_Staffs_CaptionLbl)
//             {
//             }
//             column(Sale_AmountCaption;Sale_AmountCaptionLbl)
//             {
//             }
//             column(Sales_Invoice_Line_QuantityCaption;"Sales Invoice Line".FIELDCAPTION(Quantity))
//             {
//             }
//             column(Sales_Invoice_Line__No__Caption;"Sales Invoice Line".FIELDCAPTION("No."))
//             {
//             }
//             column(Sales_Invoice_Line__Sell_to_Customer_No__Caption;"Sales Invoice Line".FIELDCAPTION("Sell-to Customer No."))
//             {
//             }
//             column(Sales_Invoice_Line__Document_No__Caption;"Sales Invoice Line".FIELDCAPTION("Document No."))
//             {
//             }
//             column(Sales_Invoice_Header___Posting_Date_Caption;FIELDCAPTION("Posting Date"))
//             {
//             }
//             column(Sales_Invoice_Line__Location_Code_Caption;"Sales Invoice Line".FIELDCAPTION("Location Code"))
//             {
//             }
//             column(Total_Caption;Total_CaptionLbl)
//             {
//             }
//             column(Sales_Invoice_Header_No_;"No.")
//             {
//             }
//             dataitem(DataItem1570;Table113)
//             {
//                 DataItemLink = Document No.=FIELD(No.);
//                 DataItemTableView = SORTING(Document No.,Line No.)
//                                     ORDER(Ascending)
//                                     WHERE(Type=CONST(Item));
//                 column(Sales_Invoice_Header___Posting_Date_;"Sales Invoice Header"."Posting Date")
//                 {
//                 }
//                 column(Sales_Invoice_Line__No__;"No.")
//                 {
//                 }
//                 column(Sales_Invoice_Line_Quantity;Quantity)
//                 {
//                 }
//                 column(Sales_Invoice_Line__Sell_to_Customer_No__;"Sell-to Customer No.")
//                 {
//                 }
//                 column(Sales_Invoice_Line__Line_Amount_;"Line Amount")
//                 {
//                 }
//                 column(Sales_Invoice_Line__Document_No__;"Document No.")
//                 {
//                 }
//                 column(Sales_Invoice_Line__Location_Code_;"Location Code")
//                 {
//                 }
//                 column(Sales_Invoice_Line_Line_No_;"Line No.")
//                 {
//                 }

//                 trigger OnAfterGetRecord()
//                 begin
//                     SalesAmount += "Sales Invoice Line"."Line Amount";
//                     Summary:=FALSE;
//                 end;

//                 trigger OnPreDataItem()
//                 begin
//                     SETRANGE("Location Code", LocationCode);
//                 end;
//             }

//             trigger OnAfterGetRecord()
//             begin
//                 Summary:=FALSE;
//             end;

//             trigger OnPreDataItem()
//             begin
//                 SETFILTER("Posting Date",'%1..%2',PostingDateFrom,PostingDateTo);
//             end;
//         }
//         dataitem(DataItem1000000032;Table2000000026)
//         {
//             DataItemTableView = SORTING(Number)
//                                 WHERE(Number=FILTER(1..));
//             column(Summary;Summary)
//             {
//             }
//             column(SMName_i_;SMName[i])
//             {
//             }
//             column(SMRate_i_;SMRate[i])
//             {
//             }
//             column(SMAmount_i_;SMAmount[i])
//             {
//             }
//             column(TotalSMAmount;TotalSMAmount)
//             {
//             }
//             column(NameCaption;NameCaptionLbl)
//             {
//             }
//             column(Commission_Rate____Caption;Commission_Rate____CaptionLbl)
//             {
//             }
//             column(AmountCaption;AmountCaptionLbl)
//             {
//             }
//             column(Total_Caption_Control1000000029;Total_Caption_Control1000000029Lbl)
//             {
//             }
//             column(Integer_Number;Number)
//             {
//             }

//             trigger OnAfterGetRecord()
//             begin
//                 Summary:=TRUE;
//                 i +=1;
//                 SMAmount[i] := SalesAmount*SMRate[i]/100*CommissionRate/100;
//                 TotalSMAmount += SMAmount[i];
//             end;

//             trigger OnPreDataItem()
//             begin

//                 SETRANGE(Number,1,i);
//                 CLEAR(i);
//                 CLEAR(TotalSMAmount);
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
//                     field(CommissionRate;CommissionRate)
//                     {
//                         Caption = 'Commission Rate (%)';
//                     }
//                     field(PostingDateFrom;PostingDateFrom)
//                     {
//                         Caption = 'Posting Date From';
//                     }
//                     field(PostingDateTo;PostingDateTo)
//                     {
//                         Caption = 'Posting Date To';
//                     }
//                     field(LocationCode;LocationCode)
//                     {
//                         Caption = 'Location';
//                         Lookup = true;
//                         TableRelation = Location;

//                         trigger OnLookup(var Text: Text): Boolean
//                         begin
//                             Location.Code:=LocationCode;
//                             IF PAGE.RUNMODAL(0,Location) = ACTION::LookupOK THEN
//                               LocationCode := Location.Code;
//                         end;

//                         trigger OnValidate()
//                         begin
//                             IF NOT Location.GET(LocationCode) THEN
//                               ERROR('Location %1 doesnt exixts',LocationCode);
//                         end;
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

//     trigger OnInitReport()
//     begin
//         PostingDateFrom :=CALCDATE('CM+1D-1M',TODAY);
//         PostingDateTo:= CALCDATE('1M-1D',PostingDateFrom);
//         CommissionRate := 4;
//     end;

//     trigger OnPreReport()
//     begin
//         //Check parameters
//         IF PostingDateFrom = 0D THEN
//           ERROR(Text001);
//         IF PostingDateTo = 0D THEN
//           ERROR(Text002);

//         IF CommissionRate = 0 THEN
//             ERROR(Text003);
//         IF PostingDateFrom > PostingDateTo THEN
//           ERROR(Text004);

//         IF LocationCode = '' THEN
//           ERROR(Text008);

//         //get Salesperson Name
//         i := 0;
//         UserSetup.RESET;
//         UserSetup.SETFILTER("Location Code",'=%1',LocationCode);
//         UserSetup.SETFILTER("Commission Rate",'<>%1',0);
//         IF UserSetup.FINDSET THEN
//           REPEAT
//             i += 1;
//             SMRate[i] := UserSetup."Commission Rate";
//             /*TJCSG1.00 #1 Start*/
//             //User.GET(UserSetup."User ID");
//             //SMName[i] := User.Name;
//             SMName[i] := UserSetup."User ID";
//             /*TJCSG1.00 #1 End*/
//           UNTIL UserSetup.NEXT =0;

//         //Check if Location code has been set in User Setup Screen
//         IF i = 0 THEN ERROR(Text006);

//         //check commission Rate
//         FOR j := 1 TO i
//           DO
//             TotalSMRate += SMRate[j];
//         IF TotalSMRate <> 100 THEN
//           ERROR(Text007);

//     end;

//     var
//         UserSetup: Record "91";
//         PostingDateFrom: Date;
//         PostingDateTo: Date;
//         CommissionRate: Decimal;
//         Text001: Label 'Postind Date From cannot be zero.';
//         Text002: Label 'Posting Date To cannot be zero.';
//         Text003: Label 'Commision Rate cannot be zero.';
//         Text004: Label 'Posting Date To cannot be less then Posting Date From.';
//         Text005: Label 'Date Filter:%1 .. %2';
//         LocationCode: Code[10];
//         SMRate: array [10] of Decimal;
//         SMName: array [10] of Text[30];
//         SMAmount: array [10] of Decimal;
//         i: Integer;
//         j: Integer;
//         SalesAmount: Decimal;
//         TotalSMAmount: Decimal;
//         TotalSMRate: Decimal;
//         Text006: Label 'Please set Location Code and Commission Rate in User Setup Screen first!';
//         Text007: Label 'Total Commission Rate is not equal to 100%\Please check setting in User Setup Screen!';
//         Text008: Label 'Please select Location Code.';
//         CurrReport_PAGENOCaptionLbl: Label 'Page';
//         Retail_Commission__Retail_Staffs_CaptionLbl: Label 'Retail Commission (Retail Staffs)';
//         Sale_AmountCaptionLbl: Label 'Sale Amount';
//         Total_CaptionLbl: Label 'Total:';
//         NameCaptionLbl: Label 'Name';
//         Commission_Rate____CaptionLbl: Label 'Commission Rate (%)';
//         AmountCaptionLbl: Label 'Amount';
//         Total_Caption_Control1000000029Lbl: Label 'Total:';
//         Location: Record "14";
//         isInitialized: Boolean;
//         Summary: Boolean;

//     procedure InitializeRequest(NewPostingDateFrom: Date;NewPostingDateTo: Date;NewCommissionRate: Decimal;NewLocationCode: Code[10])
//     begin
//         InitRequestPageDataInternal;

//         PostingDateFrom:=NewPostingDateFrom;
//         PostingDateTo:=NewPostingDateTo;
//         CommissionRate:=NewCommissionRate;
//         LocationCode:=NewLocationCode
//     end;

//     procedure InitRequestPageDataInternal()
//     begin
//         IF isInitialized THEN
//           EXIT;

//         isInitialized := TRUE;
//     end;
// }

