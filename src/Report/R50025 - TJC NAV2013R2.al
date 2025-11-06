// report 50025 "Yearly Customer Point Summary"
// {
//     // WCW - 191007 - create report
//     // 
//     // Version No.         : TJCSG1.00
//     // Developer           : DP.AYD
//     // Init. DEV. Date     : 7/8/2014
//     // Date of last Change : 12/8/2014
//     // Description         : DD#182 https://dptech.mydonedone.com/issuetracker/projects/4350/issues/182
//     // 
//     // 1. Upgrade
//     // 2. Error type convert at runtime
//     DefaultLayout = RDLC;
//     RDLCLayout = './Yearly Customer Point Summary.rdlc';

//     PreviewMode = PrintLayout;

//     dataset
//     {
//         dataitem(DataItem6836;Table18)
//         {
//             DataItemTableView = SORTING(No.)
//                                 ORDER(Ascending);
//             column(COMPANYNAME;COMPANYNAME)
//             {
//             }
//             column(USERID;USERID)
//             {
//             }
//             column(CurrReport_PAGENO;CurrReport.PAGENO)
//             {
//             }
//             column(FORMAT_TODAY_0_4_;FORMAT(TODAY,0,4))
//             {
//             }
//             column(MonthDesc_1_;MonthDesc[1])
//             {
//             }
//             column(MonthDesc_12_;MonthDesc[12])
//             {
//             }
//             column(MonthDesc_2_;MonthDesc[2])
//             {
//             }
//             column(MonthDesc_1__Control1000000037;MonthDesc[1])
//             {
//             }
//             column(MonthDesc_4_;MonthDesc[4])
//             {
//             }
//             column(MonthDesc_3_;MonthDesc[3])
//             {
//             }
//             column(MonthDesc_6_;MonthDesc[6])
//             {
//             }
//             column(MonthDesc_5_;MonthDesc[5])
//             {
//             }
//             column(MonthDesc_8_;MonthDesc[8])
//             {
//             }
//             column(MonthDesc_7_;MonthDesc[7])
//             {
//             }
//             column(MonthDesc_10_;MonthDesc[10])
//             {
//             }
//             column(MonthDesc_9_;MonthDesc[9])
//             {
//             }
//             column(MonthDesc_12__Control1000000056;MonthDesc[12])
//             {
//             }
//             column(MonthDesc_11_;MonthDesc[11])
//             {
//             }
//             column(Customer_Name___Customer__Name_2_;Customer.Name + Customer."Name 2")
//             {
//             }
//             column(CustomerPoint_1_;CustomerPoint[1])
//             {
//             }
//             column(CustomerPoint_2_;CustomerPoint[2])
//             {
//             }
//             column(CustomerPoint_3_;CustomerPoint[3])
//             {
//             }
//             column(CustomerPoint_4_;CustomerPoint[4])
//             {
//             }
//             column(CustomerPoint_5_;CustomerPoint[5])
//             {
//             }
//             column(CustomerPoint_6_;CustomerPoint[6])
//             {
//             }
//             column(CustomerPoint_7_;CustomerPoint[7])
//             {
//             }
//             column(CustomerPoint_8_;CustomerPoint[8])
//             {
//             }
//             column(CustomerPoint_9_;CustomerPoint[9])
//             {
//             }
//             column(CustomerPoint_10_;CustomerPoint[10])
//             {
//             }
//             column(CustomerPoint_11_;CustomerPoint[11])
//             {
//             }
//             column(CustomerPoint_12_;CustomerPoint[12])
//             {
//             }
//             column(PointTotal;PointTotal)
//             {
//             }
//             column(Customer__Salesperson_Code_;"Salesperson Code")
//             {
//             }
//             column(Customer_Customer__No__;Customer."No.")
//             {
//             }
//             column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
//             {
//             }
//             column(Customer_Point_SummaryCaption;Customer_Point_SummaryCaptionLbl)
//             {
//             }
//             column(Period__Caption;Period__CaptionLbl)
//             {
//             }
//             column(ToCaption;ToCaptionLbl)
//             {
//             }
//             column(Customer_CodeCaption;Customer_CodeCaptionLbl)
//             {
//             }
//             column(TotalCaption;TotalCaptionLbl)
//             {
//             }
//             column(Customer__Salesperson_Code_Caption;FIELDCAPTION("Salesperson Code"))
//             {
//             }
//             column(Customer_NameCaption;Customer_NameCaptionLbl)
//             {
//             }

//             trigger OnAfterGetRecord()
//             begin
//                 PopulateCustomerPoint(CustomerPoint,Month+1);
//                 //from section  {TJCSG1.00 #1}
//                 //CurrReport.SHOWOUTPUT((PointTotal<>0) OR (ShowZeroTotal));
//                 IF NOT ((PointTotal<>0) OR (ShowZeroTotal)) THEN CurrReport.SKIP; //tjcsg1.00 #1
//             end;

//             trigger OnPreDataItem()
//             begin

//                 PopulateMonth(MonthDesc,Month+1);
//             end;
//         }
//     }

//     requestpage
//     {

//         layout
//         {
//             area(content)
//             {
//                 group("Customer Point Summary")
//                 {
//                     Caption = 'Customer Point Summary';
//                     field(Month;Month)
//                     {
//                         Caption = 'Start Month';
//                     }
//                     field(Year;Year)
//                     {
//                         Caption = 'Year';
//                     }
//                     field(ShowZeroTotal;ShowZeroTotal)
//                     {
//                         Caption = 'Show Customer With Zero Total';
//                     }
//                 }
//             }
//         }

//         actions
//         {
//         }

//         trigger OnInit()
//         begin
//             /*TJCSG1.00 #1 Start*/

//             Year:=DATE2DMY(TODAY,3)-2007;
//             Month:=DATE2DMY(TODAY,2)-1;

//             /*TJCSG1.00 #1 End*/

//         end;
//     }

//     labels
//     {
//     }

//     trigger OnInitReport()
//     begin
//         //default to first month date


//         LastMonth:= 1;
//         ThisYear:=  DATE2DMY(TODAY,3);

//         CASE LastMonth OF
//             1 :
//                Month:=Month::Jan;
//             2 :
//                Month:=Month::Feb;
//             3 :
//                Month:=Month::Mar;
//             4 :
//                Month:=Month::Apr;
//             5 :
//                Month:=Month::May;
//             6 :
//                Month:=Month::Jun;
//             7 :
//                Month:=Month::Jul;
//             8 :
//                Month:=Month::Aug;
//             9 :
//                Month:=Month::Sep;
//            10 :
//                Month:=Month::Oct;
//            11 :
//                Month:=Month::Nov;
//            12 :
//                Month:=Month::Dec;
//         END;
//     end;

//     var
//         LastFieldNo: Integer;
//         FooterPrinted: Boolean;
//         MonthDesc: array [12] of Text[6];
//         CustomerPoint: array [12] of Decimal;
//         LastMonth: Integer;
//         ThisYear: Integer;
//         LastMonthDate: Date;
//         PointTotal: Decimal;
//         ShowZeroTotal: Boolean;
//         CurrReport_PAGENOCaptionLbl: Label 'Page';
//         Customer_Point_SummaryCaptionLbl: Label 'Customer Point Summary';
//         Period__CaptionLbl: Label 'Period :';
//         ToCaptionLbl: Label 'To';
//         Customer_CodeCaptionLbl: Label 'Customer Code';
//         TotalCaptionLbl: Label 'Total';
//         Customer_NameCaptionLbl: Label 'Customer Name';
//         Month: Option Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec;
//         Year: Option "2007","2008","2009","2010","2011","2012","2013","2014","2015","2016","2017","2018","2019","2020","2021","2022","2023","2024","2025","2026","2027","2028";

//     procedure GetCustomerPoint(CustomerNo: Code[20];StartDate: Date;EndDate: Date) Point: Decimal
//     var
//         DataTable: Record "50001";
//     begin
//         //message(format(startdate)+'  '+format(enddate));
//         DataTable.RESET;
//         DataTable.SETRANGE(DataTable.Type,'Customer');
//         DataTable.SETRANGE(DataTable."No.",CustomerNo);
//         DataTable.SETRANGE(DataTable.Date,StartDate,EndDate);
//         DataTable.SETRANGE(DataTable.Adjustment,DataTable.Adjustment::Positive);
//         IF DataTable.FIND('-') THEN
//           BEGIN
//              REPEAT
//                 Point+=DataTable."Customer Points";
//              UNTIL DataTable.NEXT=0;
//           END;
//     end;

//     procedure PopulateCustomerPoint(var CustomerPointArray: array [12] of Decimal;StartMonth: Integer)
//     var
//         Index: Integer;
//         YearString: Text[4];
//         YearInteger: Integer;
//         StartDate: Date;
//         EndDate: Date;
//         YearOption: Option "2007","2008","2009","2010","2011","2012","2013","2014","2015","2016","2017","2018","2019","2020","2021","2022","2023","2024","2025","2026","2027","2028";
//         TempPoint: Decimal;
//     begin
//         PointTotal:=0;
//         YearOption:=Year;
//         FOR Index :=1 TO 12 DO
//           BEGIN
//             EVALUATE(YearInteger,FORMAT(YearOption));

//             GetDateRange(StartDate,EndDate,StartMonth,YearInteger);
//             TempPoint:=GetCustomerPoint(Customer."No.",StartDate,EndDate);
//             PointTotal+=TempPoint;
//             CustomerPointArray[Index]:=TempPoint;
//              IF StartMonth=12 THEN
//                BEGIN
//                 StartMonth:=1;
//                 //tjcsg1.00 #2 this code make error convert at runtime// YearOption+=1;
//                 YearOption:=Year+1; //tjcsg1.00  #2
//                END
//              ELSE
//                 StartMonth+=1;
//           END;
//     end;

//     procedure GetMonthText(MonthNumber: Integer) MonthText: Text[3]
//     begin
//         CASE MonthNumber OF
//             1 :
//                MonthText:='Jan';
//             2 :
//                MonthText:='Feb';
//             3 :
//                MonthText:='Mar';
//             4 :
//                MonthText:='Apr';
//             5 :
//                MonthText:='May';
//             6 :
//                MonthText:='Jun';
//             7 :
//                MonthText:='Jul';
//             8 :
//                MonthText:='Aug';
//             9 :
//                MonthText:='Sep';
//            10 :
//                MonthText:='Oct';
//            11 :
//                MonthText:='Nov';
//            12 :
//                MonthText:='Dec';
//         END;
//     end;

//     procedure PopulateMonth(var MonthArray: array [12] of Text[6];StartMonth: Integer)
//     var
//         Index: Integer;
//         YearString: Text[4];
//         YearOption: Option "2007","2008","2009","2010","2011","2012","2013","2014","2015","2016","2017","2018","2019","2020","2021","2022","2023","2024","2025","2026","2027","2028";
//     begin
//         YearOption:=Year;
//         FOR Index :=1 TO 12 DO
//           BEGIN
//             YearString:=FORMAT(YearOption);
//             MonthArray[Index]:=GetMonthText(StartMonth)+' '+COPYSTR(YearString,3,2);
//              IF StartMonth=12 THEN
//                BEGIN
//                 StartMonth:=1;
//                  //tjcsg1.00 #2  this code make error convert at runtime// YearOption+=1;
//                 YearOption:=Year+1; //tjcsg1.00 #2
//                END
//              ELSE
//                 StartMonth+=1;
//           END;
//     end;

//     procedure GetDateRange(var StartDate: Date;var EndDate: Date;StartMonth: Integer;Year: Integer)
//     var
//         YearInteger: Integer;
//     begin
//         //format data into start and end date

//         StartDate:=DMY2DATE(1, StartMonth,Year);
//         EndDate:=CALCDATE('+1M',StartDate);
//         EndDate:=CALCDATE('-1D',EndDate);
//     end;
// }

