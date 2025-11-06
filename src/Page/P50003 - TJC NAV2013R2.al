// page 50003 "Cust Point / Comm Update"
// {
//     PageType = Card;

//     layout
//     {
//         area(content)
//         {
//             field(Month;Month)
//             {
//                 Caption = 'Month';
//             }
//             field(Year;Year)
//             {
//                 Caption = 'Year';
//             }
//             field(ProdGroupcode;ProdGroupcode)
//             {
//                 Caption = 'Prod. Group Code';

//                 trigger OnValidate()
//                 begin

//                     IF NOT ValidateProductGroup(ProdGroupcode) THEN
//                      BEGIN
//                         MESSAGE('Invalid Product Group : '+ProdGroupcode);
//                         ProdGroupcode:='SG';
//                      END;
//                 end;
//             }
//         }
//     }

//     actions
//     {
//         area(processing)
//         {
//             action(Update)
//             {
//                 Caption = 'Update';
//                 Image = Refresh;
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

//                     //call codeunit to generate temp table data
//                     CreateTempTable.RetrieveInvoice("Start Date","End Date",'SG','SalesComm');

//                     //call function to loop through the temp table data
//                     InsertIntoTable();

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
//         CreateTempTable: Codeunit "50000";
//         MonthInteger: Integer;
//         YearInteger: Integer;
//         "Start Date": Date;
//         "End Date": Date;
//         TempTable: Record "50000";
//         TransactionTable: Record "50001";
//         ProdGroupcode: Code[20];
//         Text000: Label 'Customer Point / Commission Monthly Update';
//         Text001: Label 'Month';
//         Text002: Label 'Year';
//         Text003: Label 'Product Group (Incentive)';

//     procedure InsertIntoTable()
//     begin


//         //check for data in temp table, display message if no data
//         IF CreateTempTable.CheckForDataRow THEN
//             MESSAGE('No Data Available')
//         ELSE
//         BEGIN

//             //retrieve only with document type =Invoice or credit note

//            // TempTable.SETFILTER(TempTable."Document Type",'<>%1',TempTable."Document Type"::NA);
//             TempTable.RESET;
//             IF TempTable.FIND('-')THEN
//               BEGIN

//                    //delete old data
//                    TransactionTable.RESET;
//                    TransactionTable.SETRANGE(TransactionTable.Date,"Start Date");
//                    TransactionTable.SETRANGE(TransactionTable.Adjustment,TransactionTable.Adjustment::Positive);
//                    IF TransactionTable.FIND('-') THEN
//                    BEGIN

//                         REPEAT
//                         //only delete and update positive for customer point
//                        TransactionTable.DELETE;
//                         UNTIL TransactionTable.NEXT=0;
//                    END;
//                    REPEAT
//                      IF (TempTable."Document Type"=TempTable."Document Type"::Invoice) OR (TempTable."Document Type"=
//                      TempTable."Document Type"::CreditMemo) THEN

//                         AddPointToTable(TempTable."Name Code",TempTable."Name Description","Start Date",TempTable."Comm (Paid)",
//                         TempTable."Comm (Unpaid)",TempTable."Customer Point",TempTable."Customer Code",
//                         TempTable."Customer Description",FORMAT(TempTable.Type))

//                      ELSE
//                         AddPointToTable(TempTable."Name Code",TempTable."Name Description","Start Date",TempTable."Production Comm (Paid)"
//         ,
//                         TempTable."Production Comm (Unpaid)",TempTable."Customer Point",TempTable."Customer Code",
//                          TempTable."Customer Description",FORMAT(TempTable.Type));
//                      UNTIL (TempTable.NEXT=0);
//               END;
//             MESSAGE('Update Completed');
//         END;
//     end;

//     procedure AddPointToTable(NameCode: Code[20];NameDescription: Text[100];Date: Date;"Comm (Paid)": Decimal;"Comm (Unpaid)": Decimal;Point: Decimal;CustomerCode: Code[20];CustomerDescription: Text[100];Type: Text[30])
//     var
//         EntryNumber: Integer;
//     begin
//         //add the point to customer record if existed
//         //insert new record if new


//         //get sale comm transaction
//         TransactionTable.SETRANGE(TransactionTable."No.",NameCode);
//         TransactionTable.SETRANGE(TransactionTable.Date,Date);
//         TransactionTable.SETRANGE(TransactionTable.Adjustment,TransactionTable.Adjustment::Positive);

//         IF TransactionTable.FIND('-') THEN
//             BEGIN
//                    TransactionTable."Comm (Paid)":=TransactionTable."Comm (Paid)"+"Comm (Paid)";
//                    TransactionTable."Comm (Unpaid)":=TransactionTable."Comm (Unpaid)"+"Comm (Unpaid)";
//                    TransactionTable.MODIFY;
//             END
//         ELSE
//             BEGIN
//               EntryNumber:=GetEntryNo();
//               TransactionTable.INIT;
//               TransactionTable."Entry No":=EntryNumber;
//               TransactionTable.Adjustment:=TransactionTable.Adjustment::Positive;
//               TransactionTable."No.":=NameCode;
//               TransactionTable.Description:=NameDescription;
//               TransactionTable.Date:=Date;
//               TransactionTable."Time Stamp":=TODAY;
//               TransactionTable."Comm (Paid)":="Comm (Paid)";
//               TransactionTable."Comm (Unpaid)":="Comm (Unpaid)";
//               TransactionTable.Type:=Type;

//               TransactionTable.INSERT;
//             END;

//         //get customer transaction

//         IF (CustomerCode<>'') AND (Point<>0) THEN
//         BEGIN

//         TransactionTable.SETRANGE(TransactionTable."No.",CustomerCode);
//         TransactionTable.SETRANGE(TransactionTable.Date,Date);
//         TransactionTable.SETRANGE(TransactionTable.Adjustment,TransactionTable.Adjustment::Positive);

//         IF TransactionTable.FIND('-') THEN
//             BEGIN
//                    TransactionTable."Customer Points":=TransactionTable."Customer Points"+Point;
//                    TransactionTable.MODIFY;
//             END
//         ELSE
//             BEGIN
//               EntryNumber:=GetEntryNo();
//               TransactionTable.INIT;
//               TransactionTable."Entry No":=EntryNumber;
//               TransactionTable.Adjustment:=TransactionTable.Adjustment::Positive;
//               TransactionTable.Type:='Customer';
//               TransactionTable."No.":=CustomerCode;
//                TransactionTable.Description:=CustomerDescription;
//               TransactionTable.Date:=Date;
//               TransactionTable."Time Stamp":=TODAY;
//               TransactionTable."Customer Points":=Point;

//               TransactionTable.INSERT;
//             END;
//         END;
//     end;

//     procedure GetEntryNo() EntryNumber: Integer
//     begin
//         //get next entry no

//         TransactionTable.RESET;
//         IF TransactionTable.FIND('+') THEN
//            EntryNumber:=TransactionTable."Entry No"+1
//         ELSE
//            EntryNumber:=1;
//         EXIT(EntryNumber);
//     end;

//     procedure ValidateProductGroup(ProductGroup: Code[20]) Status: Boolean
//     var
//         ProductGroupTable: Record "5723";
//     begin
//         ProductGroupTable.RESET;
//         ProductGroupTable.SETRANGE(ProductGroupTable.Code,ProductGroup);
//         IF ProductGroupTable.FIND('-') THEN
//            Status:=TRUE;

//         EXIT(Status);
//     end;
// }

