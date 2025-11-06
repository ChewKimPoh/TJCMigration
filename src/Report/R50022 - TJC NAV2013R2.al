// report 50022 "Summary Customer Point"
// {
//     DefaultLayout = RDLC;
//     RDLCLayout = './Summary Customer Point.rdlc';

//     dataset
//     {
//         dataitem(DataItem1000000000;Table18)
//         {
//             column(COMPANYNAME;COMPANYNAME)
//             {
//             }
//             column(Month;Month)
//             {
//             }
//             column(Year;Year)
//             {
//             }
//             column(No_Customer;Customer."No.")
//             {
//             }
//             dataitem(DataItem1000000002;Table50000)
//             {
//                 DataItemLink = Customer Code=FIELD(No.);
//                 DataItemTableView = SORTING(Customer Code,Product Group Code)
//                                     WHERE(Report Type=CONST(SaleComm));
//                 column(CustomerPoint_TempTable;"Temp Table"."Customer Point")
//                 {
//                 }
//                 column(LineAmount_TempTable;"Temp Table"."Line Amount")
//                 {
//                 }
//                 column(NameDescription_TempTable;"Temp Table"."Name Description")
//                 {
//                 }
//                 column(CustomerCode_TempTable;"Temp Table"."Customer Code")
//                 {
//                 }
//                 column(CustomerDescription_TempTable;"Temp Table"."Customer Description")
//                 {
//                 }
//             }
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
//                     field(Month;Month)
//                     {
//                     }
//                     field(Year;Year)
//                     {
//                     }
//                     field("Product Group (Incentive)";ProdGroupcode)
//                     {
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


//         CreateTable.RetrieveInvoice("Start Date","End Date",ProdGroupcode,'SalesComm');
//     end;

//     var
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

