// report 50035 "Retail Commission(Prod. Staff)"
// {
//     DefaultLayout = RDLC;
//     RDLCLayout = './Retail Commission(Prod. Staff).rdlc';

//     dataset
//     {
//         dataitem(DataItem1000000000;Table112)
//         {
//             DataItemTableView = SORTING(No.);
//             column(CompanyName;COMPANYNAME)
//             {
//             }
//             column(FilterText;FilterText)
//             {
//             }
//             column(CommissionRate;CommissionRate)
//             {
//             }
//             column(PostingDateFrom;PostingDateFrom)
//             {
//             }
//             column(PostingDateTo;PostingDateTo)
//             {
//             }
//             column(LocationCode;LocationCode)
//             {
//             }
//             column(ItemNoFilter;ItemNoFilter)
//             {
//             }
//             column(No_SalesInvoiceHeader;"Sales Invoice Header"."No.")
//             {
//             }
//             column(PostingDate_SalesInvoiceHeader;"Sales Invoice Header"."Posting Date")
//             {
//             }
//             dataitem(DataItem1000000002;Table113)
//             {
//                 DataItemLink = Document No.=FIELD(No.);
//                 DataItemTableView = SORTING(Document No.,Line No.);
//                 column(Amount_SalesInvoiceLine;"Sales Invoice Line".Amount)
//                 {
//                 }
//                 column(LineAmount_SalesInvoiceLine;"Sales Invoice Line"."Line Amount")
//                 {
//                 }
//                 column(Quantity_SalesInvoiceLine;"Sales Invoice Line".Quantity)
//                 {
//                 }
//                 column(SelltoCustomerNo_SalesInvoiceLine;"Sales Invoice Line"."Sell-to Customer No.")
//                 {
//                 }
//                 column(DocumentNo_SalesInvoiceLine;"Sales Invoice Line"."Document No.")
//                 {
//                 }
//                 column(No_SalesInvoiceLine;"Sales Invoice Line"."No.")
//                 {
//                 }
//                 column(LocationCode_SalesInvoiceLine;"Sales Invoice Line"."Location Code")
//                 {
//                 }

//                 trigger OnAfterGetRecord()
//                 begin
//                     SalesAmount += "Sales Invoice Line"."Line Amount";
//                 end;

//                 trigger OnPreDataItem()
//                 begin
//                     SETFILTER("Location Code", LocationCode);
//                     SETFILTER("No.", ItemNoFilter);
//                 end;
//             }

//             trigger OnPreDataItem()
//             begin
//                 SalesAmount := 0;
//                 SETFILTER("Posting Date",'%1..%2',PostingDateFrom,PostingDateTo);
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
//                     field("Commission Rate (%)";CommissionRate)
//                     {
//                     }
//                     field("Posting Date From";PostingDateFrom)
//                     {
//                     }
//                     field("Posting Date To";PostingDateTo)
//                     {
//                     }
//                     field("Item No. Starting With";ItemNoFilter)
//                     {
//                     }
//                     field(Location;LocationCode)
//                     {
//                         TableRelation = Location;
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
//         CommissionRate := 0.5;
//     end;

//     trigger OnPreReport()
//     begin
//         FilterText := STRSUBSTNO(Text005,PostingDateFrom,PostingDateTo);
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
//         /*
//         //get Salesperson Name
//         i := 0;
//         UserSetup.RESET;
//         UserSetup.SETFILTER("Location Code",'=%1',LocationCode);
//         UserSetup.SETFILTER("Commission Rate",'<>%1',0);
//         IF UserSetup.FINDSET THEN
//           REPEAT
//             i += 1;
//             SMRate[i] := UserSetup."Commission Rate";
//             User.GET(UserSetup."User ID");
//             SMName[i] := User.Name;
//           UNTIL UserSetup.NEXT =0;

//         //Check if Location code has been set in User Setup Screen
//         IF i = 0 THEN ERROR(Text006);

//         //check commission Rate
//         FOR j := 1 TO i
//           DO
//             TotalSMRate += SMRate[j];
//         IF TotalSMRate <> 100 THEN
//           ERROR(Text007);
//         */

//     end;

//     var
//         UserSetup: Record "91";
//         User: Record "2000000120";
//         PostingDateFrom: Date;
//         PostingDateTo: Date;
//         CommissionRate: Decimal;
//         LocationCode: Code[10];
//         SMRate: array [10] of Decimal;
//         SMName: array [10] of Text[30];
//         SMAmount: array [10] of Decimal;
//         i: Integer;
//         j: Integer;
//         SalesAmount: Decimal;
//         TotalSMAmount: Decimal;
//         TotalSMRate: Decimal;
//         ItemNoFilter: Text[30];
//         Text001: Label 'Postind Date From cannot be zero.';
//         Text002: Label 'Posting Date To cannot be zero.';
//         Text003: Label 'Commision Rate cannot be zero.';
//         Text004: Label 'Posting Date To cannot be less then Posting Date From.';
//         Text005: Label 'Date Filter:%1 .. %2';
//         Text006: Label 'Please set Location Code and Commission Rate in User Setup Screen first!';
//         Text007: Label 'Total Commission Rate is not equal to 100%\Please check setting in User Setup Screen!';
//         Text008: Label 'Please select Location Code.';
//         FilterText: Text[100];
// }

