// page 50005 "Monthly Commission Report"
// {
//     // TJCSG1.00
//     //  1. 07/03/2014  dp.dst
//     //     - Converted from Form.
//     //     - Found some inconsistencies on paramaters passed on function. Commented out first for Upgrade purpose.

//     PageType = ConfirmationDialog;

//     layout
//     {
//         area(content)
//         {
//             field(Month;Month)
//             {
//             }
//             field(Year;Year)
//             {
//             }
//             field(ProdGroupcode;ProdGroupcode)
//             {

//                 trigger OnValidate()
//                 begin
//                     IF NOT ValidateProductGroup(ProdGroupcode) THEN
//                      BEGIN
//                        MESSAGE('Invalid Product Group : '+ProdGroupcode);
//                        ProdGroupcode:='SG';
//                      END;
//                 end;
//             }
//             field(;'')
//             {
//                 CaptionClass = Text003;
//             }
//             field(;'')
//             {
//                 CaptionClass = Text002;
//             }
//             field(;'')
//             {
//                 CaptionClass = Text001;
//             }
//             field(;'')
//             {
//                 CaptionClass = Text000;
//             }
//         }
//     }

//     actions
//     {
//         area(processing)
//         {
//             action(Submit)
//             {
//                 Caption = 'Submit';
//                 Promoted = true;
//                 PromotedCategory = Process;

//                 trigger OnAction()
//                 begin
//                     //format data into start and end date

//                     MonthInteger:= Month+1 ;
//                     EVALUATE(YearInteger,FORMAT(Year));

//                     "Start Date":=DMY2DATE(1, MonthInteger,YearInteger);
//                     "End Date":=CALCDATE('+1M',"Start Date");
//                     "End Date":=CALCDATE('-1D',"End Date");

//                     // CreateTable.RetrieveInvoice("Start Date","End Date",ProdGroupcode);   // TJCSG1.00 Commented out first.
//                     CreateTable.ExportToExcel();

//                     //close form when completed
//                     CurrPage.CLOSE;
//                 end;
//             }
//         }
//     }

//     trigger OnInit()
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
//         Text000: Label 'Monthly Commission Report';
//         Text001: Label 'Month';
//         Text002: Label 'Year';
//         Text003: Label 'Product Group (Incentive)';

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

