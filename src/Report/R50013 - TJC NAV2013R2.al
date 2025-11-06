// report 50013 "Management Commission Report"
// {
//     // Management Commission Report - 50013
//     // Version No.         : TJCSG1.00
//     // Developer           : DP.AYD
//     // Init. DEV. Date     : 28/05/2014
//     // Date of last Change : 10/06/2014
//     // Description         : Based on DD#122 https://dptech.mydonedone.com/issuetracker/projects/4350/issues/122
//     // 
//     // TJCSG1.00 #1 :
//     // 1. 31/05/2014 DP.AYD DD#122 https://dptech.mydonedone.com/issuetracker/projects/4350/issues/122
//     //    - Add default year and month
//     DefaultLayout = RDLC;
//     RDLCLayout = './Management Commission Report.rdlc';


//     dataset
//     {
//         dataitem(DataItem6463;Table50000)
//         {
//             DataItemTableView = SORTING(Name Description,Type)
//                                 WHERE(Document Type=CONST(NA),
//                                       Type=CONST(Management));
//             column(USERID;USERID)
//             {
//             }
//             column(COMPANYNAME;COMPANYNAME)
//             {
//             }
//             column(CurrReport_PAGENO;CurrReport.PAGENO)
//             {
//             }
//             column(FORMAT_TODAY_0_4_;FORMAT(TODAY,0,4))
//             {
//             }
//             column(Month;Month)
//             {
//             }
//             column(Year;Year)
//             {
//             }
//             column(Temp_Table__Name_Code_;"Name Code")
//             {
//             }
//             column(Temp_Table__Name_Description_;"Name Description")
//             {
//             }
//             column(Temp_Table__Production_Comm__Paid__;"Production Comm (Paid)")
//             {
//             }
//             column(Temp_Table__Production_Comm__Unpaid__;"Production Comm (Unpaid)")
//             {
//             }
//             column(Temp_Table__Production_Comm__Paid___Control1000000007;"Production Comm (Paid)")
//             {
//             }
//             column(Temp_Table__Production_Comm__Unpaid___Control1000000010;"Production Comm (Unpaid)")
//             {
//             }
//             column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
//             {
//             }
//             column(Management_Commission_ReportCaption;Management_Commission_ReportCaptionLbl)
//             {
//             }
//             column(Period__Caption;Period__CaptionLbl)
//             {
//             }
//             column(CodeCaption;CodeCaptionLbl)
//             {
//             }
//             column(NameCaption;NameCaptionLbl)
//             {
//             }
//             column(Commmission__Paid_Caption;Commmission__Paid_CaptionLbl)
//             {
//             }
//             column(Commmission__Unpaid_Caption;Commmission__Unpaid_CaptionLbl)
//             {
//             }
//             column(Grand_TotalCaption;Grand_TotalCaptionLbl)
//             {
//             }
//             column(Temp_Table_Entry_No;"Entry No")
//             {
//             }
//             column(Temp_Table_Document_No;"Document No")
//             {
//             }
//             column(Temp_Table_Document_Type;"Document Type")
//             {
//             }

//             trigger OnPreDataItem()
//             begin
//                 /*                        "Temp Table".SETFILTER("Temp Table"."Entry No",Range);
//                                    CurrReport.CREATETOTALS("Temp Table"."Production Comm (Paid)");
//                                  CurrReport.CREATETOTALS("Temp Table"."Production Comm (Unpaid)");
//                 */

//             end;
//         }
//     }

//     requestpage
//     {

//         layout
//         {
//             area(content)
//             {
//                 group("Management Commission Report")
//                 {
//                     Caption = 'Management Commission Report';
//                     field(Month;Month)
//                     {
//                         Caption = 'Month';
//                     }
//                     field(Year;Year)
//                     {
//                         Caption = 'Year';
//                     }
//                     field(ProdGroupcode;ProdGroupcode)
//                     {
//                         Caption = 'Product Group (Incentive)';
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

//         //default to last month date
//         LastMonthDate:=CALCDATE('-1M',TODAY);


//         LastMonth:= DATE2DMY(LastMonthDate,2);
//         ThisYear:=  DATE2DMY(LastMonthDate,3);


//         /*
//         "Start Date":= DMY2DATE (1,LastMonth,2007);
//         "End Date":=CALCDATE('+1M',"Start Date");
//         "End Date":=CALCDATE('-1D',"End Date");
//         */

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
//         ProdGroupcode:='SG';

//     end;

//     trigger OnPreReport()
//     begin
//         //format data into start and end date

//         MonthInteger:= Month+1 ;
//         EVALUATE(YearInteger,FORMAT(Year));

//         "Start Date":=DMY2DATE(1, MonthInteger,YearInteger);
//         "End Date":=CALCDATE('+1M',"Start Date");
//         "End Date":=CALCDATE('-1D',"End Date");


//         CreateTable.RetrieveInvoice("Start Date","End Date",ProdGroupcode,'MgtComm');
//     end;

//     var
//         LineAmountTotal: Decimal;
//         Month: Option Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec;
//         Year: Option "2007","2008","2009","2010","2011","2012","2013","2014","2015","2016","2017","2018","2019","2020","2021","2022","2023","2024","2025","2026","2027","2028";
//         LastMonth: Integer;
//         ThisYear: Integer;
//         LastMonthDate: Date;
//         CreateTable: Codeunit "50000";
//         MonthInteger: Integer;
//         YearInteger: Integer;
//         "Start Date": Date;
//         "End Date": Date;
//         TempTable: Record "50000";
//         TransactionTable: Record "50001";
//         ProdGroupcode: Code[20];
//         Range: Text[30];
//         CurrReport_PAGENOCaptionLbl: Label 'Page';
//         Management_Commission_ReportCaptionLbl: Label 'Management Commission Report';
//         Period__CaptionLbl: Label 'Period :';
//         CodeCaptionLbl: Label 'Code';
//         NameCaptionLbl: Label 'Name';
//         Commmission__Paid_CaptionLbl: Label 'Commmission (Paid)';
//         Commmission__Unpaid_CaptionLbl: Label 'Commmission (Unpaid)';
//         Grand_TotalCaptionLbl: Label 'Grand Total';

//     procedure ValidateProductGroup(ProductGroup: Code[20]) Status: Boolean
//     var
//         ProductGroupTable: Record "5723";
//     begin
//         //validate product group

//         ProductGroupTable.RESET;
//         ProductGroupTable.SETRANGE(ProductGroupTable.Code,ProductGroup);
//         IF ProductGroupTable.FIND('-') THEN
//            Status:=TRUE;

//         EXIT(Status);
//     end;
// }

