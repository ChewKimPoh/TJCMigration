// report 50019 "Summary Salesperson Commission"
// {
//     // TJCSG1.00
//     // 1. 02/06/20914 DP.JL DD#140
//     //   - Set default date to this year. (The original creater used an option field to set the dates.)
//     //   - Modify grouping in layout and added a page footer with the condition to act like a transfooter.
//     DefaultLayout = RDLC;
//     RDLCLayout = './Summary Salesperson Commission.rdlc';


//     dataset
//     {
//         dataitem(DataItem3065;Table13)
//         {
//             DataItemTableView = SORTING(Code)
//                                 WHERE(Type=CONST(Salesperson));
//             PrintOnlyIfDetail = true;
//             RequestFilterFields = "Code";
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
//             column(Salesperson_Purchaser_Name;Name)
//             {
//             }
//             column(CommPaidTotal;CommPaidTotal)
//             {
//                 DecimalPlaces = 3:3;
//             }
//             column(CommUnPaidTotal;CommUnPaidTotal)
//             {
//             }
//             column(LineAmountTotal;LineAmountTotal)
//             {
//             }
//             column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
//             {
//             }
//             column(Salesperson_Commission_ReportCaption;Salesperson_Commission_ReportCaptionLbl)
//             {
//             }
//             column(Salesperson_Purchaser_NameCaption;FIELDCAPTION(Name))
//             {
//             }
//             column(Customer_Code_NameCaption;Customer_Code_NameCaptionLbl)
//             {
//             }
//             column(Document__Document_No_Caption;Document.FIELDCAPTION("Document No"))
//             {
//             }
//             column(Document__Comm__Paid__Caption;Document.FIELDCAPTION("Comm (Paid)"))
//             {
//             }
//             column(Document__Comm__Unpaid__Caption;Document.FIELDCAPTION("Comm (Unpaid)"))
//             {
//             }
//             column(Inv__AmtCaption;Inv__AmtCaptionLbl)
//             {
//             }
//             column(Salesperson_TotalCaption;Salesperson_TotalCaptionLbl)
//             {
//             }
//             column(Salesperson_Purchaser_Code;Code)
//             {
//             }
//             dataitem(DataItem6836;Table18)
//             {
//                 DataItemLink = Salesperson Code=FIELD(Code);
//                 DataItemTableView = SORTING(Salesperson Code,No.)
//                                     ORDER(Ascending);
//                 column(Customer__No__;"No.")
//                 {
//                 }
//                 column(Customer_Name;Name)
//                 {
//                 }
//                 column(Customer_Salesperson_Code;"Salesperson Code")
//                 {
//                 }
//             }
//             dataitem(Document;Table50000)
//             {
//                 DataItemLink = Name Code=FIELD(Code);
//                 DataItemTableView = SORTING(Name Code,Customer Code,Document No)
//                                     WHERE(Type=CONST(Salesperson),
//                                           Document Type=FILTER(<>Opening));
//                 column(Document__Item_Code_;"Item Code")
//                 {
//                 }
//                 column(Document__Comm__Paid__;"Comm (Paid)")
//                 {
//                 }
//                 column(Document__Comm__Unpaid__;"Comm (Unpaid)")
//                 {
//                 }
//                 column(Document__Line_Amount_;"Line Amount")
//                 {
//                 }
//                 column(Document__Comm__Paid___Control1000000024;"Comm (Paid)")
//                 {
//                 }
//                 column(Document__Comm__Unpaid___Control1000000027;"Comm (Unpaid)")
//                 {
//                 }
//                 column(Document__Line_Amount__Control1000000028;"Line Amount")
//                 {
//                 }
//                 column(Document__Document_No_;"Document No")
//                 {
//                 }
//                 column(Document__Customer_Code_;"Customer Code")
//                 {
//                 }
//                 column(Document__Customer_Description_;"Customer Description")
//                 {
//                 }
//                 column(Document_Entry_No;"Entry No")
//                 {
//                 }
//                 column(Document_Document_Type;"Document Type")
//                 {
//                 }
//                 column(Document_Name_Code;"Name Code")
//                 {
//                 }

//                 trigger OnAfterGetRecord()
//                 begin
//                               CommPaidTotal:= CommPaidTotal+Document."Comm (Paid)";
//                               CommUnPaidTotal:= CommUnPaidTotal+Document."Comm (Unpaid)";
//                               LineAmountTotal:= LineAmountTotal+Document."Line Amount";
//                 end;
//             }

//             trigger OnAfterGetRecord()
//             begin
//                          CommPaidTotal:=0;
//                            CommUnPaidTotal:=0;
//                            LineAmountTotal:=0;
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

//         //START TKCSG1.00 #1 >>>
//         IF (ThisYear - 2007) >= 0 THEN
//           Year:= ThisYear - 2007;
//         //END TKCSG1.00 #1 <<<

//         /*
//         "Start Date":= DMY2DATE (1,LastMonth,2007);
//         "End Date":=CALCDATE('+1M',"Start Date");
//         "End Date":=CALCDATE('-1D',"End Date");
//         */

//         CASE LastMonth OF
//             1: Month:=Month::Jan;
//             2: Month:=Month::Feb;
//             3: Month:=Month::Mar;
//             4: Month:=Month::Apr;
//             5: Month:=Month::May;
//             6: Month:=Month::Jun;
//             7: Month:=Month::Jul;
//             8: Month:=Month::Aug;
//             9: Month:=Month::Sep;
//            10: Month:=Month::Oct;
//            11: Month:=Month::Nov;
//            12: Month:=Month::Dec;
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


//         CreateTable.RetrieveInvoice("Start Date","End Date",ProdGroupcode,'SalesComm');
//     end;

//     var
//         CommPaidTotal: Decimal;
//         CommUnPaidTotal: Decimal;
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
//         CurrReport_PAGENOCaptionLbl: Label 'Page';
//         Salesperson_Commission_ReportCaptionLbl: Label 'Salesperson Commission Report';
//         Customer_Code_NameCaptionLbl: Label 'Customer Code/Name';
//         Inv__AmtCaptionLbl: Label 'Inv. Amt';
//         Salesperson_TotalCaptionLbl: Label 'Salesperson Total';

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

