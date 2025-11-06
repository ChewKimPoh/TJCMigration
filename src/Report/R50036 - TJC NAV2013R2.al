// report 50036 "Doctor Commission 2"
// {
//     // DP.RWP - New Report to calculate doctor commission
//     // 
//     // 20100629 DP.RWP
//     //    -Get BarCode Items from Bar Code Table
//     // 
//     // Doctor Commission 2 - 50036
//     // Version No.         : TJCSG1.00
//     // Developer           : DP.AYD
//     // Init. DEV. Date     : 28/05/2014
//     // Date of last Change : 03/06/2014
//     // Description         : Based on DD#125 https://dptech.mydonedone.com/issuetracker/projects/4350/issues/125
//     // 
//     // 1. Change Keys
//     // DP.NCM TJC #803 01/09/2025 Change calculation to get Comm from BarCode instead of hardcoded
//     DefaultLayout = RDLC;
//     RDLCLayout = './Doctor Commission 2.rdlc';


//     dataset
//     {
//         dataitem(DataItem3141;Table50011)
//         {
//             DataItemTableView = SORTING(Location Code,Doctor Code,No.,Posting Date);
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
//             column(STRSUBSTNO_Text005_PostingDateFrom_PostingDateTo_;STRSUBSTNO(Text005,PostingDateFrom,PostingDateTo))
//             {
//             }
//             column(Doctor_Commission__Doctor_Code_;"Doctor Code")
//             {
//             }
//             column(Doctor_Commission__Posting_Date_;"Posting Date")
//             {
//             }
//             column(Doctor_Commission__Document_Date_;"Document Date")
//             {
//             }
//             column(Doctor_Commission__Document_No__;"Document No.")
//             {
//             }
//             column(Doctor_Commission__Location_Code_;"Location Code")
//             {
//             }
//             column(Doctor_Commission__No__;"No.")
//             {
//             }
//             column(Doctor_Commission_Quantity;Quantity)
//             {
//             }
//             column(Doctor_Commission__Line_Discount___;"Line Discount %")
//             {
//             }
//             column(Doctor_Commission_Commission;Commission)
//             {
//             }
//             column(Doctor_Commission__Line_Amount_;"Line Amount")
//             {
//             }
//             column(Doctor_Commission_Commission_Control1000000031;Commission)
//             {
//             }
//             column(Doctor_Commission_Commission_Control1000000035;Commission)
//             {
//             }
//             column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
//             {
//             }
//             column(Doctor_CommissionCaption;Doctor_CommissionCaptionLbl)
//             {
//             }
//             column(Doctor_Commission__Posting_Date_Caption;FIELDCAPTION("Posting Date"))
//             {
//             }
//             column(Doctor_Commission__Document_Date_Caption;FIELDCAPTION("Document Date"))
//             {
//             }
//             column(Doctor_Commission__Document_No__Caption;FIELDCAPTION("Document No."))
//             {
//             }
//             column(Doctor_Commission__Location_Code_Caption;FIELDCAPTION("Location Code"))
//             {
//             }
//             column(Doctor_Commission__No__Caption;FIELDCAPTION("No."))
//             {
//             }
//             column(Doctor_Commission_QuantityCaption;FIELDCAPTION(Quantity))
//             {
//             }
//             column(Doctor_Commission__Line_Discount___Caption;FIELDCAPTION("Line Discount %"))
//             {
//             }
//             column(Doctor_Commission_CommissionCaption;FIELDCAPTION(Commission))
//             {
//             }
//             column(Doctor_Commission__Line_Amount_Caption;FIELDCAPTION("Line Amount"))
//             {
//             }
//             column(Doctor_Commission__Doctor_Code_Caption;FIELDCAPTION("Doctor Code"))
//             {
//             }
//             column(Sub_TotalCaption;Sub_TotalCaptionLbl)
//             {
//             }
//             column(TotalCaption;TotalCaptionLbl)
//             {
//             }
//             column(Doctor_Commission_Line_No_;"Line No.")
//             {
//             }
//         }
//     }

//     requestpage
//     {

//         layout
//         {
//             area(content)
//             {
//                 group("Filter Info")
//                 {
//                     Caption = 'Filter Info';
//                     field(PostingDateFrom;PostingDateFrom)
//                     {
//                         Caption = 'Posting Date From';
//                     }
//                     field(PostingDateTo;PostingDateTo)
//                     {
//                         Caption = 'Posting Date To';
//                     }
//                     field(DoctorCode;DoctorCode)
//                     {
//                         Caption = 'Doctor Code';

//                         trigger OnLookup(var Text: Text): Boolean
//                         var
//                             SalespersonList: Page "14";
//                             Salesperson: Record "13";
//                         begin

//                             CLEAR(SalespersonList);
//                             Salesperson.RESET;
//                             Salesperson.SETRANGE(Salesperson.Type, Salesperson.Type::Others);
//                             SalespersonList.SETRECORD(Salesperson);
//                             SalespersonList.SETTABLEVIEW(Salesperson);
//                             SalespersonList.LOOKUPMODE(TRUE);
//                             IF SalespersonList.RUNMODAL = ACTION::LookupOK THEN BEGIN
//                               SalespersonList.GETRECORD(Salesperson);
//                               DoctorCode := Salesperson.Code;
//                             END;
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

//         "Commission Rate" := 40;
//     end;

//     trigger OnPreReport()
//     begin
//         //Check parameters
//         IF PostingDateFrom = 0D THEN
//           ERROR(Text001);
//         IF PostingDateTo = 0D THEN
//           ERROR(Text002);
//         IF ("Commission Rate"<=0) OR ("Commission Rate">=100) THEN
//             ERROR(Text003);
//         IF PostingDateFrom > PostingDateTo THEN
//           ERROR(Text004);

//         DoctorCommission.DELETEALL; //clear all entries

//         //20100629 [
//         /*
//         //get Medicine Item from Sales & Receivables Setup
//         SMSetup.GET;
//         MedicineBarcode[1] := SMSetup.BarCode3;
//         MedicineBarcode[2] := SMSetup.BarCode5;
//         MedicineBarcode[3] := SMSetup.BarCode7;
//         MedicineBarcode[4] := SMSetup.BarCode1;
//         */

//         //Get all BarCode items from Bar Code Table
//         CLEAR(MedicineBarCodeFilter);
//         BarCode.RESET;
//         IF BarCode.FINDSET THEN
//           REPEAT
//             MedicineBarCodeFilter += BarCode.Code +'|';
//           UNTIL BarCode.NEXT = 0;
//         IF MedicineBarCodeFilter <>'' THEN
//           MedicineBarCodeFilter := COPYSTR(MedicineBarCodeFilter,1, STRLEN(MedicineBarCodeFilter)-1);
//         //20100629 ]

//         //Extract info from Sales Invoice Header and Sales Invoice Line Table
//         SalesInvoiceHeader.RESET;
//         SalesInvoiceHeader.SETCURRENTKEY("Posting Date");
//         SalesInvoiceHeader.SETFILTER("Posting Date",'%1..%2',PostingDateFrom, PostingDateTo);
//         IF SalesInvoiceHeader.FINDSET THEN
//           REPEAT
//             /*TJCSG1.00 #1*/ SalesInvoiceLine.SETCURRENTKEY("Document No.","No.","Doctor Code");

//             SalesInvoiceLine.SETRANGE("Document No.", SalesInvoiceHeader."No.");
//             //20100629 [
//         //SalesInvoiceLine.SETFILTER("No.",'%1|%2|%3|%4', MedicineBarcode[1],MedicineBarcode[2],MedicineBarcode[3],MedicineBarcode[4]);
//             SalesInvoiceLine.SETFILTER("No.",MedicineBarCodeFilter);
//             //20100629 ]
//             IF DoctorCode <>'' THEN
//               SalesInvoiceLine.SETRANGE("Doctor Code",DoctorCode);
//             IF SalesInvoiceLine.FINDFIRST THEN
//               REPEAT
//                 DoctorCommission.INIT;
//                 DoctorCommission."Document No." := SalesInvoiceLine."Document No.";
//                 DoctorCommission."Line No." := SalesInvoiceLine."Line No.";
//                 DoctorCommission."Posting Date" :=SalesInvoiceHeader."Posting Date";
//                 DoctorCommission."Document Date":=  SalesInvoiceHeader."Document Date";
//                 DoctorCommission."Doctor Code" := SalesInvoiceLine."Doctor Code";
//                 DoctorCommission."Location Code":= SalesInvoiceLine."Location Code";

//                 DoctorCommission.Type :=SalesInvoiceLine.Type;
//                 DoctorCommission."No." := SalesInvoiceLine."No.";
//                 DoctorCommission.Quantity := SalesInvoiceLine.Quantity;
//                 DoctorCommission."Line Discount %":=  SalesInvoiceLine."Line Discount %";
//                 DoctorCommission."Line Amount" := SalesInvoiceLine."Line Amount";
//                 //DP.NCM TJC #803 01/09/2025 START
//                 BarCode.RESET;
//                 BarCode.SETRANGE(Code,SalesInvoiceLine."No.");
//                 IF BarCode.FINDFIRST THEN
//                   DoctorCommission.Commission := SalesInvoiceLine."Line Amount" * BarCode."Commission Rate"/100;

//                 //DoctorCommission.Commission := SalesInvoiceLine."Line Amount" * "Commission Rate"/100;
//                 //DP.NCM TJC #803 01/09/2025 END
//                 DoctorCommission.INSERT;
//               UNTIL SalesInvoiceLine.NEXT = 0
//           UNTIL SalesInvoiceHeader.NEXT =0;

//     end;

//     var
//         LoginMgt: Codeunit "418";
//         SMSetup: Record "311";
//         SalesInvoiceHeader: Record "112";
//         SalesInvoiceLine: Record "113";
//         DoctorCommission: Record "50011";
//         BarCode: Record "50012";
//         MedicineBarcode: array [4] of Code[20];
//         PostingDateFrom: Date;
//         PostingDateTo: Date;
//         DoctorCode: Code[20];
//         Text001: Label 'Postind Date From cannot be empty.';
//         Text002: Label 'Posting Date To cannot be empty.';
//         Text003: Label 'Commision Rate must be between 0 and 100.';
//         i: Integer;
//         Text004: Label 'Posting Date To cannot be less then Posting Date From.';
//         Text005: Label 'Date Filter:%1 .. %2';
//         "Commission Rate": Integer;
//         MedicineBarCodeFilter: Text[500];
//         CurrReport_PAGENOCaptionLbl: Label 'Page';
//         Doctor_CommissionCaptionLbl: Label 'Doctor Commission';
//         Sub_TotalCaptionLbl: Label 'Sub Total';
//         TotalCaptionLbl: Label 'Total';
// }

