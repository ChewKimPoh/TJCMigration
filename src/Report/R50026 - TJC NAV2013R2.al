// report 50026 "Yearly Commission Summary"
// {
//     // WCW - 191007 - create report
//     // 
//     // Version No.         : TJCSG1.00
//     // Developer           : DP.AYD
//     // Init. DEV. Date     : 7/8/2014
//     // Date of last Change : 12/8/2014
//     // Description         : DD#183 https://dptech.mydonedone.com/issuetracker/projects/4350/issues/183
//     // 
//     // 1. Upgrade
//     // 2. Error type convert at runtime
//     // 3. Add filter at tablix to fix header visibility, not isnothing(company_name)=true
//     DefaultLayout = RDLC;
//     RDLCLayout = './Yearly Commission Summary.rdlc';

//     PreviewMode = PrintLayout;

//     dataset
//     {
//         dataitem(DataItem3065;Table13)
//         {
//             DataItemTableView = SORTING(Code)
//                                 ORDER(Ascending)
//                                 WHERE(Type=CONST(Salesperson));
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
//             column(TotalText;TotalText)
//             {
//             }
//             column(Salesperson_Purchaser_Name;Name)
//             {
//             }
//             column(Commission_1_;Commission[1])
//             {
//             }
//             column(Commission_2_;Commission[2])
//             {
//             }
//             column(Commission_3_;Commission[3])
//             {
//             }
//             column(Commission_4_;Commission[4])
//             {
//             }
//             column(Commission_5_;Commission[5])
//             {
//             }
//             column(Commission_6_;Commission[6])
//             {
//             }
//             column(Commission_7_;Commission[7])
//             {
//             }
//             column(Commission_8_;Commission[8])
//             {
//             }
//             column(Commission_9_;Commission[9])
//             {
//             }
//             column(Commission_10_;Commission[10])
//             {
//             }
//             column(Commission_11_;Commission[11])
//             {
//             }
//             column(Commission_12_;Commission[12])
//             {
//             }
//             column(CommissionTotal;CommissionTotal)
//             {
//             }
//             column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
//             {
//             }
//             column(Commission_SummaryCaption;Commission_SummaryCaptionLbl)
//             {
//             }
//             column(Period__Caption;Period__CaptionLbl)
//             {
//             }
//             column(ToCaption;ToCaptionLbl)
//             {
//             }
//             column(Salesperson_Purchaser_NameCaption;FIELDCAPTION(Name))
//             {
//             }
//             column(Salesperson_Purchaser_Code;Code)
//             {
//             }

//             trigger OnAfterGetRecord()
//             begin
//                 PopulateComm(Commission,Month+1,'Salesperson',"Salesperson/Purchaser".Code);
//                 //from section
//                 //CurrReport.SHOWOUTPUT((CommissionTotal<>0) OR (ShowZeroTotal));
//                 IF NOT ((CommissionTotal<>0) OR (ShowZeroTotal)) THEN CurrReport.SKIP; //tjcsg1.00 #1
//             end;

//             trigger OnPreDataItem()
//             begin

//                 PopulateMonth(MonthDesc,Month+1);
//             end;
//         }
//         dataitem(Management;Table91)
//         {
//             DataItemTableView = SORTING(User ID)
//                                 ORDER(Ascending)
//                                 WHERE(Staff Level=CONST(Management));
//             column(Management_Management__User_ID_;Management."User ID")
//             {
//             }
//             column(Commission_1__Control1000000015;Commission[1])
//             {
//             }
//             column(Commission_2__Control1000000016;Commission[2])
//             {
//             }
//             column(Commission_3__Control1000000017;Commission[3])
//             {
//             }
//             column(Commission_4__Control1000000018;Commission[4])
//             {
//             }
//             column(Commission_5__Control1000000019;Commission[5])
//             {
//             }
//             column(Commission_6__Control1000000020;Commission[6])
//             {
//             }
//             column(Commission_7__Control1000000021;Commission[7])
//             {
//             }
//             column(Commission_8__Control1000000022;Commission[8])
//             {
//             }
//             column(Commission_9__Control1000000023;Commission[9])
//             {
//             }
//             column(Commission_10__Control1000000024;Commission[10])
//             {
//             }
//             column(Commission_11__Control1000000025;Commission[11])
//             {
//             }
//             column(Commission_12__Control1000000026;Commission[12])
//             {
//             }
//             column(CommissionTotal_Control1000000027;CommissionTotal)
//             {
//             }

//             trigger OnAfterGetRecord()
//             begin
//                 PopulateComm(Commission,Month+1,'Management',Management."User ID");
//             end;
//         }
//         dataitem(Production;Table91)
//         {
//             DataItemTableView = SORTING(User ID)
//                                 ORDER(Ascending)
//                                 WHERE(Staff Level=CONST(Production));
//             column(Production_Production__User_ID_;Production."User ID")
//             {
//             }
//             column(Commission_1__Control1000000029;Commission[1])
//             {
//             }
//             column(Commission_2__Control1000000030;Commission[2])
//             {
//             }
//             column(Commission_3__Control1000000031;Commission[3])
//             {
//             }
//             column(Commission_4__Control1000000032;Commission[4])
//             {
//             }
//             column(Commission_5__Control1000000033;Commission[5])
//             {
//             }
//             column(Commission_6__Control1000000034;Commission[6])
//             {
//             }
//             column(Commission_7__Control1000000035;Commission[7])
//             {
//             }
//             column(Commission_8__Control1000000038;Commission[8])
//             {
//             }
//             column(Commission_9__Control1000000039;Commission[9])
//             {
//             }
//             column(Commission_10__Control1000000040;Commission[10])
//             {
//             }
//             column(Commission_11__Control1000000041;Commission[11])
//             {
//             }
//             column(Commission_12__Control1000000042;Commission[12])
//             {
//             }
//             column(CommissionTotal_Control1000000043;CommissionTotal)
//             {
//             }

//             trigger OnAfterGetRecord()
//             begin
//                 PopulateComm(Commission,Month+1,'Production',Production."User ID");
//             end;
//         }
//     }

//     requestpage
//     {

//         layout
//         {
//             area(content)
//             {
//                 group("Commision Summary")
//                 {
//                     Caption = 'Commision Summary';
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
//                         Caption = 'Show Commission With Zero Total';
//                     }
//                 }
//             }
//         }

//         actions
//         {
//         }

//         trigger OnOpenPage()
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
//         Commission: array [12] of Decimal;
//         Month: Option Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec;
//         Year: Option "2007","2008","2009","2010","2011","2012","2013","2014","2015","2016","2017","2018","2019","2020","2021","2022","2023","2024","2025","2026","2027","2028";
//         LastMonth: Integer;
//         ThisYear: Integer;
//         LastMonthDate: Date;
//         CommissionTotal: Decimal;
//         ShowZeroTotal: Boolean;
//         TotalText: Label 'Total';
//         CurrReport_PAGENOCaptionLbl: Label 'Page';
//         Commission_SummaryCaptionLbl: Label 'Commission Summary';
//         Period__CaptionLbl: Label 'Period :';
//         ToCaptionLbl: Label 'To';

//     procedure GetComm("Code": Code[20];StartDate: Date;EndDate: Date;Type: Text[30]) Comm: Decimal
//     var
//         DataTable: Record "50001";
//     begin

//         DataTable.RESET;
//         DataTable.SETRANGE(DataTable.Type,Type);
//         DataTable.SETRANGE(DataTable."No.",Code);
//         DataTable.SETRANGE(DataTable.Date,StartDate,EndDate);
//         DataTable.SETRANGE(DataTable.Adjustment,DataTable.Adjustment::Positive);
//         IF DataTable.FIND('-') THEN
//           BEGIN
//              REPEAT
//                 Comm+=DataTable."Comm (Paid)";
//              UNTIL DataTable.NEXT=0;
//           END;
//     end;

//     procedure PopulateComm(var CommArray: array [12] of Decimal;StartMonth: Integer;Type: Text[30];"Code": Code[20])
//     var
//         Index: Integer;
//         YearString: Text[4];
//         YearInteger: Integer;
//         StartDate: Date;
//         EndDate: Date;
//         YearOption: Option "2007","2008","2009","2010","2011","2012","2013","2014","2015","2016","2017","2018","2019","2020","2021","2022","2023","2024","2025","2026","2027","2028";
//         TempComm: Decimal;
//     begin
//         CommissionTotal:=0;
//         YearOption:=Year;
//         FOR Index :=1 TO 12 DO
//           BEGIN
//             EVALUATE(YearInteger,FORMAT(YearOption));

//             GetDateRange(StartDate,EndDate,StartMonth,YearInteger);
//             TempComm:=GetComm(Code,StartDate,EndDate,Type);
//             CommissionTotal+=TempComm;
//             CommArray[Index]:=TempComm;
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
//                 //tjcsg1.00 #2 this code make error convert at runtime// YearOption+=1;
//                 YearOption:=Year+1; //tjcsg1.00  #2

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

