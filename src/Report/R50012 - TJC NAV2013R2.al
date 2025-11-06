// report 50012 "Salesperson Commission Report"
// {
//     // TJCSG1.00
//     // 1. 02/06/20914 DP.JL DD#140
//     //   - Set default date to this year. (The original creater used an option field to set the dates.)
//     //   - Modify grouping in layout and added a page footer with the condition to act like a transfooter.
//     DefaultLayout = RDLC;
//     RDLCLayout = './Salesperson Commission Report.rdlc';


//     dataset
//     {
//         dataitem(DataItem1;Table13)
//         {
//             DataItemTableView = SORTING(Code)
//                                 WHERE(Type=CONST(Salesperson));
//             PrintOnlyIfDetail = true;
//             RequestFilterFields = "Code";
//             column(CurrReport_PAGENO;CurrReport.PAGENO)
//             {
//             }
//             column(COMPANYNAME;COMPANYNAME)
//             {
//             }
//             column(Code_SalesPurch;"Salesperson/Purchaser".Code)
//             {
//             }
//             column(Name_SalesPurch;"Salesperson/Purchaser".Name)
//             {
//             }
//             column(CommPaidTotal;CommPaidTotal)
//             {
//             }
//             column(CommUnPaidTotal;CommUnPaidTotal)
//             {
//             }
//             column(LineAmountTotal;LineAmountTotal)
//             {
//             }
//             dataitem(DataItem2;Table18)
//             {
//                 DataItemLink = Salesperson Code=FIELD(Code);
//                 DataItemTableView = SORTING(Salesperson Code,No.)
//                                     ORDER(Ascending);
//                 PrintOnlyIfDetail = true;
//                 column(No_Customer;Customer."No.")
//                 {
//                 }
//                 column(Name_Customer;Customer.Name)
//                 {
//                 }
//                 dataitem(Document;Table50000)
//                 {
//                     DataItemLink = Customer Code=FIELD(No.);
//                     DataItemTableView = SORTING(Customer Code,Document No)
//                                         WHERE(Type=CONST(Salesperson),
//                                               Document Type=FILTER(<>Opening));
//                     column(DocNo_Document;Document."Document No")
//                     {
//                     }
//                     column(ItemCode_Document;Document."Item Code")
//                     {
//                     }
//                     column(CommPaid_Document;Document."Comm (Paid)")
//                     {
//                     }
//                     column(CommUnpaid_Document;Document."Comm (Unpaid)")
//                     {
//                     }
//                     column(LineAmt_Document;Document."Line Amount")
//                     {
//                     }

//                     trigger OnAfterGetRecord()
//                     begin
//                         CommPaidTotal:= CommPaidTotal+Document."Comm (Paid)";
//                         CommUnPaidTotal:= CommUnPaidTotal+Document."Comm (Unpaid)";
//                         LineAmountTotal:= LineAmountTotal+Document."Line Amount";
//                     end;

//                     trigger OnPreDataItem()
//                     begin
//                         Document.SETFILTER(Document."Entry No",Range);
//                     end;
//                 }
//             }

//             trigger OnAfterGetRecord()
//             begin
//                 CommPaidTotal:=0;
//                 CommUnPaidTotal:=0;
//                 LineAmountTotal:=0;
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
//                     field(ShowDetails;ShowDetails)
//                     {
//                         Caption = 'Show Details';
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
//         SalespersonCommisionCaption = 'Salesperson Commision Report';
//         SalesPurchName = 'Name';
//         SalesPurchCustCode = 'Customer Code/ Name';
//         SalesPurchDocNo = 'Document No';
//         SalesPurchItemCode = 'Item Code';
//         SalesPurchCommPaid = 'Comm (Paid)';
//         SalesPurchCommUnpaid = 'Comm (Unpaid)';
//         SalesPurchLineAmt = 'Line Amount';
//         DocumentTotal = 'Docu Total';
//         SalespersonTotal = 'Salesperson Total';
//         PageNo = 'Page:';
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
//         ShowDetails:=TRUE;

//     end;

//     trigger OnPreReport()
//     begin
//         //format data into start and end date

//         MonthInteger:= Month+1 ;
//         EVALUATE(YearInteger,FORMAT(Year));

//         "Start Date":=DMY2DATE(1, MonthInteger,YearInteger);
//         "End Date":=CALCDATE('+1M',"Start Date");
//         "End Date":=CALCDATE('-1D',"End Date");


//         Range:=CreateTable.RetrieveInvoice("Start Date","End Date",ProdGroupcode,'SalesComm');
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
//         Range: Text[30];
//         ShowDetails: Boolean;

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

