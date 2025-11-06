// codeunit 50003 "TJC Functions"
// {
//     Permissions = TableData 32=rm;

//     trigger OnRun()
//     var
//         recSalesPerson: Record "13";
//         str: Text;
//     begin
//         //MESSAGE(GETSOLine(VAR Record,'1076'));
//         //str := 'aaabcde';
//         //IF STRLEN(str) > 3 THEN
//         //  MESSAGE(PADSTR(str,3));
//     end;

//     var
//         SearchStr: Text;
//         DocType: Option "Sales Shipment";
//         UnitPrice: Decimal;
//         ConvertedString: Text;

//     procedure TJCLogin(var UserInfo: BigText;LoginID: Text[50];Password: Text[50]): Boolean
//     var
//         TJCWebUser: Record "50013";
//     begin
//         TJCWebUser.RESET;
//         TJCWebUser.SETRANGE(UserID,LoginID);
//         TJCWebUser.SETRANGE (Password,Password);

//         IF TJCWebUser.FINDFIRST THEN
//         BEGIN
//           UserInfo.ADDTEXT(TJCWebUser.SalesPerson);
//           EXIT(TRUE)
//         END
//         ELSE
//           EXIT(FALSE);
//     end;

//     procedure GetItemByLocation(var RetXML: BigText;ItemNo: Code[20])
//     var
//         recItemLedgerEntry: Record "32";
//     begin
//         recItemLedgerEntry.RESET;
//         recItemLedgerEntry.SETRANGE("Item No.",ItemNo);
//         recItemLedgerEntry.SETFILTER("Remaining Quantity",'<>%1',0);
//         recItemLedgerEntry.SETFILTER(recItemLedgerEntry."Location Code",'=%1','TJC');
//          RetXML.ADDTEXT('<DPTech>');
//         IF recItemLedgerEntry.FINDFIRST THEN BEGIN

//           REPEAT
//             RetXML.ADDTEXT('<ItemInfo>');
//             RetXML.ADDTEXT('<LocationCode>' + recItemLedgerEntry."Location Code"  +'</LocationCode>');
//             RetXML.ADDTEXT('<LotNo>' +recItemLedgerEntry."Lot No." +'</LotNo>');
//             RetXML.ADDTEXT('<Quantity>'+ FORMAT(recItemLedgerEntry."Remaining Quantity") +'</Quantity>');
//             RetXML.ADDTEXT('<ExpirationDate>' + FORMAT(recItemLedgerEntry."Expiration Date") + '</ExpirationDate>');
//             RetXML.ADDTEXT('<UomID>' + recItemLedgerEntry."Unit of Measure Code" + '</UomID>');
//             RetXML.ADDTEXT('</ItemInfo>');
//           UNTIL(recItemLedgerEntry.NEXT=0)

//         END
//         ELSE BEGIN
//           RetXML.ADDTEXT('<ItemInfo></ItemInfo>');
//         END;
//          RetXML.ADDTEXT('</DPTech>');


//          /*
//         RetXML.ADDTEXT('<DPTech>');
//         RetXML.ADDTEXT('<ItemInfo>');
//         RetXML.ADDTEXT('<LocationCode>BLUE</LocationCode>');
//         RetXML.ADDTEXT('<LotNo>0001</LotNo>');
//         RetXML.ADDTEXT('<Quantity>20</Quantity>');
//         RetXML.ADDTEXT('<ExpirationDate>01/01/2015 </ExpirationDate>');
//         RetXML.ADDTEXT('</ItemInfo>');

//         RetXML.ADDTEXT('<ItemInfo>');
//         RetXML.ADDTEXT('<LocationCode>RED</LocationCode>');
//         RetXML.ADDTEXT('<LotNo>0002</LotNo>');
//         RetXML.ADDTEXT('<Quantity>50</Quantity>');
//         RetXML.ADDTEXT('<ExpirationDate>01/01/2015</ExpirationDate>');
//         RetXML.ADDTEXT('</ItemInfo>');

//         RetXML.ADDTEXT('<ItemInfo>');
//         RetXML.ADDTEXT('<LocationCode>GREEN</LocationCode>');
//         RetXML.ADDTEXT('<LotNo>0001</LotNo>');
//         RetXML.ADDTEXT('<Quantity>100</Quantity>');
//         RetXML.ADDTEXT('<ExpirationDate>01/01/2015</ExpirationDate>');
//         RetXML.ADDTEXT('</ItemInfo>');
//         RetXML.ADDTEXT('</DPTech>');
//           */

//     end;

//     procedure GetCustomerPriceHistory(var RetXML: BigText;ItemNo: Code[20])
//     var
//         recItemLedger: Record "32";
//         recSalesInvHeader: Record "112";
//         recSalesInvLine: Record "113";
//     begin
//         //recItemLedger.RESET;
//         //recItemLedger.SETRANGE("Item No.",ItemNo);
//         //recItemLedger.SETRANGE("Document Type",recItemLedger."Document Type"::"Sales Shipment");
//         //recItemLedger.SETRANGE("Document Type",DocType);
//         //RetXML.ADDTEXT('<DPTech>');
//         //IF recItemLedger.FINDFIRST THEN BEGIN
//         //  REPEAT
//         //    RetXML.ADDTEXT('<ItemInfo>');
//         //      RetXML.ADDTEXT('<Date>'+ FORMAT(recItemLedger."Posting Date") +'</Date>');
//         //      RetXML.ADDTEXT('<CustomerNo>' + recItemLedger."Source No."+'</CustomerNo>');
//         //      RetXML.ADDTEXT('<Qty>'+ FORMAT(recItemLedger.Quantity) +'</Qty>');
//         //      UnitPrice:=recItemLedger."Sales Amount (Expected)"/recItemLedger.Quantity;
//         //      RetXML.ADDTEXT('<UnitPrice>'+ FORMAT(UnitPrice) +'</UnitPrice>');
//         //      RetXML.ADDTEXT('<Dis{count>'+  FORMAT(0.0) +'</Discount>');
//         //      RetXML.ADDTEXT('<TotalPrice>'+ FORMAT(recItemLedger."Sales Amount (Expected)"+ 0) +'</TotalPrice>');
//         //    RetXML.ADDTEXT('</ItemInfo>');
//         //  UNTIL(recItemLedger.NEXT=0)
//         //END ELSE BEGIN
//         //  RetXML.ADDTEXT('<ItemInfo></ItemInfo>');
//         //END;
//         //RetXML.ADDTEXT('</DPTech>');


//         recSalesInvHeader.RESET;
//         recSalesInvHeader.SETRANGE("Posting Date", CALCDATE('-3M', TODAY), TODAY);
//         RetXML.ADDTEXT('<DPTech>');
//         IF recSalesInvHeader.FINDFIRST THEN BEGIN
//           REPEAT
//             recSalesInvLine.RESET;
//             recSalesInvLine.SETRANGE("Document No.", recSalesInvHeader."No.");
//             recSalesInvLine.SETRANGE("No.", ItemNo);
//             IF recSalesInvLine.FINDSET THEN BEGIN
//               REPEAT
//                 RetXML.ADDTEXT('<ItemInfo>');
//                   RetXML.ADDTEXT('<Date>'+ FORMAT(recSalesInvHeader."Posting Date") +'</Date>');
//                   RetXML.ADDTEXT('<CustomerNo>' + recSalesInvHeader."Sell-to Customer No."+'</CustomerNo>');
//                   RetXML.ADDTEXT('<Qty>'+ FORMAT(recSalesInvLine.Quantity) +'</Qty>');
//                   RetXML.ADDTEXT('<UOMId>' + recSalesInvLine."Unit of Measure Code" + '</UOMId>');
//                   RetXML.ADDTEXT('<UnitPrice>'+ FORMAT(recSalesInvLine."Unit Price")+'</UnitPrice>');
//                   //RetXML.ADDTEXT('<Discount>'+  FORMAT(recSalesInvLine."Line Discount %")+'%'+'</Discount>');
//                   RetXML.ADDTEXT('<Discount>'+  FORMAT(recSalesInvLine."Line Discount %") +'</Discount>');
//                   RetXML.ADDTEXT('<TotalPrice>'+ FORMAT(recSalesInvLine.Amount + 0) +'</TotalPrice>');
//                 RetXML.ADDTEXT('</ItemInfo>');
//               UNTIL recSalesInvLine.NEXT = 0;
//             END;
//           UNTIL recSalesInvHeader.NEXT=0;
//         END ELSE BEGIN
//           RetXML.ADDTEXT('<ItemInfo></ItemInfo>');
//         END;
//         RetXML.ADDTEXT('</DPTech>');
//     end;

//     procedure GetSearchItem(var ItemInfo: BigText;SearchWords: Text[30];SearchType: Text[30])
//     var
//         recItem: Record "27";
//     begin

//         recItem.RESET;
//         IF SearchType='1' THEN BEGIN
//           //recItem.SETFILTER(recItem.Description,'%1','@*'+ SearchWords +'*' );
//           recItem.SETFILTER(recItem.Description,'%1','*'+ SearchWords +'*' );
//         END ELSE
//         BEGIN
//           //recItem.SETFILTER("No.",'%1','@*' + SearchWords +'*');
//           recItem.SETFILTER("No.",'%1','*'+ SearchWords +'*' );
//         END;
//         recItem.SETFILTER(Blocked,'<>%1',TRUE);
//         recItem.SETFILTER("Inventory Posting Group",'%1','FG');
//         recItem.SETFILTER("Location Filter",'TJC');
//         ItemInfo.ADDTEXT('<DPTech>');
//         IF recItem.FINDFIRST THEN BEGIN
//         REPEAT
//           recItem.CALCFIELDS(Inventory);
//           ItemInfo.ADDTEXT('<Item>');
//             ItemInfo.ADDTEXT('<ItemNo>' + recItem."No." + '</ItemNo>');
//             ItemInfo.ADDTEXT('<Name>' + recItem.Description + '</Name>');
//             ItemInfo.ADDTEXT('<Name2>' +recItem."Description 2" + '</Name2>');
//             ItemInfo.ADDTEXT('<UomId>'+ recItem."Base Unit of Measure" +'</UomId>');
//             ItemInfo.ADDTEXT('<Qty>' +FORMAT(recItem.Inventory) + '</Qty>');
//             ItemInfo.ADDTEXT('<Price>' + FORMAT(recItem."Unit Price") + '</Price>');
//           ItemInfo.ADDTEXT('</Item>');
//         UNTIL (recItem.NEXT=0)
//         END ELSE BEGIN
//           ItemInfo.ADDTEXT('<Item></Item>');
//         END;
//         ItemInfo.ADDTEXT('</DPTech>');
//     end;

//     procedure GetSearchCustomer(var CustomerInfo: BigText;SearchWords: Text[50];SearchType: Text[30];CSalespersonCode: Code[10])
//     var
//         recCustomer: Record "18";
//         recSalesPerson: Record "13";
//     begin
//         recCustomer.RESET;
//           IF SearchType='1' THEN BEGIN
//             recCustomer.SETFILTER(recCustomer.Name,'%1','@*' + SearchWords + '*');
//           END ELSE
//           BEGIN
//             recCustomer.SETFILTER("No.",'%1', '@*' + SearchWords + '*');
//           END;
//           recCustomer.SETFILTER(Blocked,'<>%1',recCustomer.Blocked::All);
//           IF CSalespersonCode <> '' THEN
//             recCustomer.SETFILTER("Salesperson Code",CSalespersonCode) ;
//           CustomerInfo.ADDTEXT('<DPTech>');
//           IF recCustomer.FINDFIRST THEN BEGIN
//           REPEAT
//               //recSalesPerson.RESET;
//               //recSalesPerson.RESET;
//               //recSalesPerson.SETFILTER(Code,'%1',recCustomer."Salesperson Code");
//               //IF recSalesPerson.FINDFIRST THEN  BEGIN
//                 CustomerInfo.ADDTEXT('<Customer>');
//                 CustomerInfo.ADDTEXT('<No>' + recCustomer."No." + '</No>');
//                 CustomerInfo.ADDTEXT('<Name>' + RemoveSpecialChar(recCustomer.Name) + '</Name>');
//                 CustomerInfo.ADDTEXT('<Name2>' + RemoveSpecialChar(recCustomer."Name 2") + '</Name2>');
//                 CustomerInfo.ADDTEXT('<Address>' + RemoveSpecialChar(recCustomer.Address) + '</Address>');
//                 CustomerInfo.ADDTEXT('<Address2>' + RemoveSpecialChar(recCustomer."Address 2") + '</Address2>');
//                 CustomerInfo.ADDTEXT('<City>' + recCustomer.City +'</City>');
//                 CustomerInfo.ADDTEXT ('<Country>' + recCustomer."Country/Region Code" +'</Country>');
//                 CustomerInfo.ADDTEXT('<PostalCode>' + recCustomer."Post Code" +'</PostalCode>');
//                 CustomerInfo.ADDTEXT('<ContactPerson>' + recCustomer.Contact +'</ContactPerson>');
//                 CustomerInfo.ADDTEXT('<Phone_No>' + recCustomer."Phone No." +'</Phone_No>');
//                 CustomerInfo.ADDTEXT('<Credit_Limit_LCY>' + FORMAT(recCustomer."Credit Limit (LCY)") +'</Credit_Limit_LCY>');
//                 CustomerInfo.ADDTEXT('<Inv_Amounts_LCY>' + FORMAT(recCustomer."Inv. Amounts (LCY)") +'</Inv_Amounts_LCY>');
//                 CustomerInfo.ADDTEXT('<Balance_LCY>' + FORMAT(recCustomer."Balance (LCY)") +'</Balance_LCY>');
//                 CustomerInfo.ADDTEXT('<Payment_Terms_Code>' + recCustomer."Payment Terms Code" + '</Payment_Terms_Code>');
//                 CustomerInfo.ADDTEXT('<Our_Account_No>' + recCustomer."Our Account No." +'</Our_Account_No>');
//                 CustomerInfo.ADDTEXT('<Currency_Code>' + recCustomer."Currency Code" +'</Currency_Code>');
//                 CustomerInfo.ADDTEXT('<SalesPerson_Code>' + recCustomer."Salesperson Code" +'</SalesPerson_Code>');
//                 recSalesPerson.RESET;
//                 recSalesPerson.RESET;
//                 recSalesPerson.SETFILTER(Code,'%1',recCustomer."Salesperson Code");
//                 IF recSalesPerson.FINDFIRST THEN  BEGIN
//                     CustomerInfo.ADDTEXT('<SalesPerson_Name>' + recSalesPerson.Name + '</SalesPerson_Name>');
//                 END ELSE BEGIN
//                     CustomerInfo.ADDTEXT('<SalesPerson_Name> </SalesPerson_Name>');
//                 END;
//                 CustomerInfo.ADDTEXT('<Bill_to_Customer_No>' + recCustomer."Bill-to Customer No."+'</Bill_to_Customer_No>');
//                 CustomerInfo.ADDTEXT('<Address_2>' + recCustomer."Address 2" + '</Address_2>');
//                 CustomerInfo.ADDTEXT('<FaxNo>' + recCustomer."Fax No." + '</FaxNo>');
//                 CustomerInfo.ADDTEXT('<Email>' + recCustomer."E-Mail" + '</Email>');
//                 CustomerInfo.ADDTEXT('</Customer>');
//               //END;

//           UNTIL (recCustomer.NEXT=0)
//           END ELSE BEGIN
//             CustomerInfo.ADDTEXT('<Customer></Customer>');
//           END;
//          CustomerInfo.ADDTEXT('</DPTech>');
//     end;

//     procedure CreateTJCSO(SOxml: XMLport "50001"): Boolean
//     begin
//         EXIT(SOxml.IMPORT);
//     end;

//     procedure GetSOHeader(var Result: BigText;SalesPerson: Code[10];StartDate: Date;EndDate: Date;IsByCustomer: Boolean;SearchValue: Text[50])
//     var
//         SalesHeader: Record "36";
//     begin
//          //SETRANGE(DocDate, StartDate, EndDate);
//          //SETFILTER(DocDate, '%1..%2', StartDate, EndDate);

//             CLEAR(Result);
//         //  IF SalesPerson = '' THEN
//         //    EXIT;
//           SalesHeader.RESET;
//           SalesHeader.SETFILTER(SalesHeader."Document Type",'%1',SalesHeader."Document Type"::Order);
//           IF SalesPerson <> '' THEN
//             SalesHeader.SETFILTER(SalesHeader."Salesperson Code",'%1',SalesPerson);

//          // SalesHeader.SETFILTER(SalesHeader."Authorization Required",'%1',TRUE); //Is Mobile Order

//           SalesHeader.SETFILTER(SalesHeader."Document Date", '%1..%2', StartDate, EndDate);
//           IF SearchValue <>'' THEN  BEGIN
//           IF IsByCustomer THEN
//              SalesHeader.SETFILTER(SalesHeader."Sell-to Customer No.",'%1','@*'+ SearchValue +'*')
//           ELSE
//              SalesHeader.SETFILTER(SalesHeader."No.",'%1','@*'+ SearchValue +'*');
//           END;
//           IF SalesHeader.FINDFIRST THEN
//           REPEAT
//             SalesHeader.CALCFIELDS(Amount);
//             SalesHeader.CALCFIELDS("Amount Including VAT");
//             Result.ADDTEXT(SalesHeader."No." + ' || ' +
//                            SalesHeader."Sell-to Customer No." + ' || ' +
//                            SalesHeader."Sell-to Customer Name" + ' || ' +
//                            SalesHeader."Sell-to Address" +'||'+
//                            FORMAT(SalesHeader.Amount) + ' || ' +
//                            FORMAT(SalesHeader."Amount Including VAT") + ' || ' +
//                            FORMAT(SalesHeader."Document Date",0,'<Day,2>/<Month,2>/<Year4>') + ' ||| ');
//           UNTIL SalesHeader.NEXT = 0;
//     end;

//     procedure GetSOLine(var Result: BigText;DocNo: Text[50]): Boolean
//     var
//         SalesLine: Record "37";
//         SalesHeader: Record "36";
//         ReasonCode: Text[20];
//         UomId: Text[20];
//     begin
//          //SETRANGE(DocDate, StartDate, EndDate);
//          //SETFILTER(DocDate, '%1..%2', StartDate, EndDate);

//           CLEAR(Result);
//           SalesLine.RESET;
//         //  SalesLine.SETFILTER(SalesLine.Type,'%1',SalesLine.Type::Item);
//           SalesLine.SETFILTER(SalesLine."Document No.",'%1',DocNo);
//           SalesLine.SETFILTER(SalesLine."Document Type",'%1',SalesHeader."Document Type"::Order);

//           IF SalesLine.FINDFIRST THEN
//           REPEAT
//             IF SalesLine."Return Reason Code"='' THEN
//             BEGIN
//               ReasonCode:='-';
//             END ELSE
//               ReasonCode:=SalesLine."Return Reason Code";

//             IF SalesLine."Unit of Measure Code"='' THEN
//             BEGIN
//               UomId:='-';
//              END ELSE
//                UomId:= SalesLine."Unit of Measure Code";

//             Result.ADDTEXT(SalesLine."No." + ' || ' +
//                            SalesLine.Description + ' || ' +
//                            FORMAT(SalesLine."Unit Price") + ' || ' +
//                            FORMAT(SalesLine.Quantity) +'||' +
//                            UomId + '||'+
//                            FORMAT(SalesLine."Line Amount") +'||'+
//                            FORMAT(SalesLine."Line Discount %")+ '||'+
//                            FORMAT(SalesLine."Line Discount Amount") + '||' +
//                            ReasonCode+ '||'+
//                            FORMAT(SalesLine."Amount Including VAT") + '|||');
//           UNTIL SalesLine.NEXT = 0;

//           IF SalesHeader.GET(SalesHeader."Document Type"::Order,DocNo) THEN
//           BEGIN
//             IF SalesHeader.Status = SalesHeader.Status::Open THEN
//              EXIT(TRUE)
//             ELSE
//               EXIT(FALSE);
//           END;
//     end;

//     procedure DeleteSO(SONo: Code[20])
//     var
//         SalesHeader: Record "36";
//         SalesLine: Record "37";
//     begin

//           IF SalesHeader.GET(SalesHeader."Document Type"::Order,SONo) THEN
//           BEGIN
//             SalesHeader.DELETE(TRUE);

//             SalesLine.RESET;
//             SalesLine.SETFILTER(SalesLine.Type,'%1',SalesLine.Type::Item);
//             SalesLine.SETFILTER(SalesLine."Document No.",'%1',SONo);
//             IF SalesLine.FINDFIRST THEN
//               SalesLine.DELETE(TRUE);
//           END;
//     end;

//     procedure GetSalesInvoiceHeader(var RetXml: BigText;SalesPersonCode: Code[10];CustomerNo: Code[20])
//     var
//         RecSalesHeader: Record "112";
//     begin
//         RecSalesHeader.RESET;
//         RecSalesHeader.SETFILTER(RecSalesHeader."Salesperson Code",'%1', SalesPersonCode);

//         RecSalesHeader.SETFILTER(RecSalesHeader."Sell-to Customer No.",'%1', CustomerNo);
//         //RecSalesHeader.SETRANGE("Posting Date", CALCDATE('-3M', TODAY), TODAY);


//         RetXml.ADDTEXT('<Invoice>');
//         IF RecSalesHeader.FINDFIRST THEN BEGIN
//         REPEAT
//         RecSalesHeader.CALCFIELDS(Amount,"Amount Including VAT");
//         RetXml.ADDTEXT('<InvoiceHead>');
//         RetXml.ADDTEXT('<Document_No>' + RecSalesHeader."No." + '</Document_No>');
//         RetXml.ADDTEXT('<Posting_Date>' + FORMAT(RecSalesHeader."Posting Date") + '</Posting_Date>');
//         RetXml.ADDTEXT('<Amount>' + FORMAT(RecSalesHeader."Amount Including VAT") + '</Amount>');
//         RetXml.ADDTEXT('</InvoiceHead>');
//         UNTIL(RecSalesHeader.NEXT=0)
//         END ELSE BEGIN
//         RetXml.ADDTEXT('<InvoiceHead></InvoiceHead>');
//         END;
//         RetXml.ADDTEXT('</Invoice>');
//     end;

//     procedure GetSalesInvoiceLine(var RetXml: BigText;DocNo: Code[20])
//     var
//         RecSalesLine: Record "113";
//     begin
//         RecSalesLine.RESET;
//         RecSalesLine.SETFILTER(RecSalesLine."Document No.",'%1', DocNo);

//         RetXml.ADDTEXT('<Invoice>');
//         IF RecSalesLine.FINDFIRST THEN BEGIN
//         REPEAT
//         RetXml.ADDTEXT('<InvoiceLine>');
//         RetXml.ADDTEXT('<No>' + RecSalesLine."No." + '</No>');
//         RetXml.ADDTEXT('<Description>'+ RecSalesLine.Description + '</Description>');
//         RetXml.ADDTEXT('<UomId>' + RecSalesLine."Unit of Measure Code" + '</UomId>');
//         RetXml.ADDTEXT('<Qty>' + FORMAT(RecSalesLine.Quantity) + '</Qty>');
//         RetXml.ADDTEXT('<UnitPrice>'+ FORMAT(RecSalesLine."Unit Price") + '</UnitPrice>');
//         RetXml.ADDTEXT('<LineDiscount>' + FORMAT(RecSalesLine."Line Discount %")+'%' +'</LineDiscount>');
//         RetXml.ADDTEXT('<LineAmount>' + FORMAT(RecSalesLine."Line Amount") + '</LineAmount>');

//         RetXml.ADDTEXT('</InvoiceLine>');
//         UNTIL(RecSalesLine.NEXT=0)
//         END ELSE BEGIN
//         RetXml.ADDTEXT('<InvoiceHead></InvoiceHead>');
//         END;
//         RetXml.ADDTEXT('</Invoice>');
//     end;

//     procedure GetSalesInvoiceHeaderByDocNo(var RetXml: BigText;DocNo: Code[20])
//     var
//         RecSalesHeader: Record "112";
//     begin
//         RecSalesHeader.RESET;
//         RecSalesHeader.SETFILTER(RecSalesHeader."No.",'%1',DocNo);
//         RetXml.ADDTEXT('<Invoice>');
//         IF RecSalesHeader.FINDFIRST THEN BEGIN
//         REPEAT
//         RecSalesHeader.CALCFIELDS(Amount,"Amount Including VAT");
//         RetXml.ADDTEXT('<InvoiceHead>');
//         RetXml.ADDTEXT('<Document_No>' + RecSalesHeader."No." + '</Document_No>');
//         RetXml.ADDTEXT('<Posting_Date>' + FORMAT(RecSalesHeader."Posting Date") + '</Posting_Date>');
//         RetXml.ADDTEXT('<Amount>'+ FORMAT(RecSalesHeader."Amount Including VAT") + '</Amount>');
//         RetXml.ADDTEXT('</InvoiceHead>');
//         UNTIL(RecSalesHeader.NEXT=0)
//         END ELSE BEGIN
//         RetXml.ADDTEXT('<InvoiceHead></InvoiceHead>');
//         END;
//         RetXml.ADDTEXT('</Invoice>');
//     end;

//     procedure ImportToNav(var PO: XMLport "50001"): Text[30]
//     begin
//          EXIT(FORMAT(PO.IMPORT));
//     end;

//     procedure RemoveSpecialChar(InString: Text[1000]): Text[1024]
//     var
//         OutString: Text[80];
//         StringLen: Integer;
//         i: Integer;
//         Li: Integer;
//         LNewInString: Text[1024];
//         LTestChr: Text[1];
//         Apstrp: Label '''';
//     begin

//         LNewInString := '';
//         FOR Li := 1 TO STRLEN(InString) DO BEGIN
//           LTestChr := COPYSTR(InString,Li,1);
//           IF ((LTestChr = '&') OR (LTestChr = Apstrp) OR (LTestChr = '>') OR (LTestChr = '<')) THEN
//             BEGIN
//               IF LTestChr = '&' THEN
//                 LNewInString := LNewInString+ ''
//               ELSE IF LTestChr = Apstrp THEN
//                 LNewInString := LNewInString+ ''
//               ELSE IF LTestChr = '>' THEN
//                 LNewInString := LNewInString+ ''
//               ELSE IF LTestChr = '<' THEN
//                 LNewInString := LNewInString+ ''
//               ELSE IF LTestChr = '"' THEN
//                 LNewInString := LNewInString+ ''
//               ELSE IF LTestChr = '160' THEN
//                 LNewInString := LNewInString+ ''
//               ELSE IF LTestChr = '180' THEN
//                 LNewInString := LNewInString+ ''

//             END
//           ELSE
//             LNewInString := LNewInString + LTestChr;
//         END;

//         EXIT(LNewInString);
//     end;

//     procedure GenerateSalesInvoice(PurHInfo: Text[1024];PurLInfo: array [50] of Text[1024]): Text
//     var
//         recInvoiceHeader: Record "36";
//         recInvoiceLine: Record "37";
//         SalesSetup: Record "311";
//         NoSeriesMgt: Codeunit "396";
//         SONo: Code[10];
//         dDocDate: Date;
//         DocumentDate: Text[20];
//         SelltoCustomerNo: Text[20];
//         ShiptoAddress: Text[50];
//         ShiptoAddress2: Text[50];
//         SalesPersonCode: Text[10];
//         iLineNo: Integer;
//         LineNo: Text[20];
//         LineDocType: Text[20];
//         LineType: Text[20];
//         No: Text[20];
//         dQuantity: Decimal;
//         Quantity: Text[20];
//         dUnitPrice: Decimal;
//         UnitPrice: Text[20];
//         cUnitUOM: Text[20];
//         strRetInvoiceNo: Text[30];
//         strInfoSplit: Text[1024];
//         i: Integer;
//         strInfoLine1Split: Text[1024];
//     begin
//         strRetInvoiceNo:='';
//         PurHInfo := ReplaceCommaAndTide(PurHInfo);
//         strInfoSplit :=CONVERTSTR(PurHInfo,'|',',');

//         DocumentDate:=SELECTSTR(1,strInfoSplit);
//         SelltoCustomerNo:=SELECTSTR(2,strInfoSplit);
//         ShiptoAddress:=SELECTSTR(3,strInfoSplit);
//         ShiptoAddress2:= SELECTSTR(4,strInfoSplit);
//         SalesPersonCode:= SELECTSTR(5,strInfoSplit);

//         SalesSetup.GET;
//         SalesSetup.TESTFIELD("Order Nos.");
//         SONo:= NoSeriesMgt.GetNextNo(SalesSetup."Order Nos.",TODAY,TRUE);

//         recInvoiceHeader.INIT;
//         recInvoiceHeader."Document Type":= recInvoiceHeader."Document Type"::Order;
//         //recInvoiceHeader."No.":=SONo;
//         recInvoiceHeader.VALIDATE("No.",SONo);
//         //recInvoiceHeader.VALIDATE("No. Series",SalesSetup."Order Nos.");
//         //recInvoiceHeader."No. Series" := SalesSetup."Order Nos.";




//         recInvoiceHeader.INSERT(TRUE);
//         COMMIT;

//         recInvoiceHeader.RESET;
//         IF recInvoiceHeader.GET(recInvoiceHeader."Document Type"::Order,SONo) THEN BEGIN

//         NoSeriesMgt.SetDefaultSeries(recInvoiceHeader."Posting No. Series",SalesSetup."Posted Invoice Nos.");
//         NoSeriesMgt.SetDefaultSeries(recInvoiceHeader."Shipping No. Series",SalesSetup."Posted Shipment Nos.");
//         NoSeriesMgt.SetDefaultSeries(recInvoiceHeader."Prepayment No. Series",SalesSetup."Posted Prepmt. Inv. Nos.");
//         NoSeriesMgt.SetDefaultSeries(recInvoiceHeader."Prepmt. Cr. Memo No. Series",SalesSetup."Posted Prepmt. Cr. Memo Nos.");
//         recInvoiceHeader."Posting Description" := FORMAT(recInvoiceHeader."Document Type") + ' ' + recInvoiceHeader."No.";




//         //recInvoiceHeader.VALIDATE("No.",SONo);
//         //recInvoiceHeader.VALIDATE("Posting Date",TODAY);
//         EVALUATE(dDocDate,DocumentDate);
//         recInvoiceHeader."Document Date":= dDocDate;
//         recInvoiceHeader."Order Date" := TODAY;
//         recInvoiceHeader."Posting Date" := TODAY;
//         recInvoiceHeader."Shipment Date" := TODAY;

//         recInvoiceHeader.VALIDATE("Sell-to Customer No.",SelltoCustomerNo);
//         recInvoiceHeader."Ship-to Address":=ReplaceCommaAndTide(ShiptoAddress);
//         recInvoiceHeader."Ship-to Address 2" :=ReplaceCommaAndTide(ShiptoAddress2);
//         recInvoiceHeader."Salesperson Code" :=SalesPersonCode;
//         recInvoiceHeader."Authorization Required":=TRUE;
//         recInvoiceHeader.MODIFY(TRUE);
//         END;

//         FOR i:=1 TO 50 DO BEGIN
//           IF PurLInfo[i]<>'-' THEN BEGIN
//           CLEAR(strInfoLine1Split);
//           CLEAR(LineNo);
//           CLEAR(LineDocType);
//           CLEAR(LineType);
//           CLEAR(No);
//           CLEAR(cUnitUOM);
//           CLEAR(Quantity);
//           CLEAR (UnitPrice);

//           strInfoLine1Split :=CONVERTSTR(PurLInfo[i],'|',',');
//           LineNo :=SELECTSTR(1,strInfoLine1Split);
//           No :=SELECTSTR(2,strInfoLine1Split);
//           cUnitUOM :=SELECTSTR(3,strInfoLine1Split);
//           Quantity :=SELECTSTR(4,strInfoLine1Split);
//           UnitPrice :=SELECTSTR(5,strInfoLine1Split);

//           recInvoiceLine.INIT;
//           recInvoiceLine."Document Type":=recInvoiceLine."Document Type" :: Order;
//           recInvoiceLine."Document No.":= SONo;
//           EVALUATE(iLineNo,LineNo);
//           recInvoiceLine."Line No.":=iLineNo;
//           recInvoiceLine.VALIDATE(Type,recInvoiceLine.Type::Item);
//          // recInvoiceLine.Type := recInvoiceLine.Type::Item;
//         //    recInvoiceLine."No." := No;
//           recInvoiceLine.VALIDATE("No.",No);

//           recInvoiceLine.VALIDATE("Unit of Measure Code",cUnitUOM);
//           recInvoiceLine.VALIDATE("Location Code",'TJC');
//           EVALUATE(dQuantity,Quantity);
//           recInvoiceLine.VALIDATE(Quantity,dQuantity);
//           EVALUATE(dUnitPrice,UnitPrice);
//           IF (dUnitPrice=0) THEN BEGIN
//             recInvoiceLine."Unit Price":=dUnitPrice;
//           //  recInvoiceLine."Qty. to Invoice":=0;
//          //   recInvoiceLine."Qty. to Ship":=0;
//           END;

//           recInvoiceLine.INSERT;

//           END;
//         END;
//         strRetInvoiceNo:=SONo;
//         EXIT(strRetInvoiceNo);
//     end;

//     procedure GetUOMByItem(var RetXML: BigText;ItemNo: Code[20])
//     var
//         recItemUOM: Record "5404";
//     begin
//         recItemUOM.RESET;
//         recItemUOM.SETRANGE("Item No.",ItemNo);
//         RetXML.ADDTEXT('<DPTech>');
//         IF recItemUOM.FINDFIRST THEN BEGIN
//           REPEAT
//             RetXML.ADDTEXT('<ItemUOM>');
//             RetXML.ADDTEXT('<ItemNo>' +recItemUOM."Item No." +'</ItemNo>');
//             RetXML.ADDTEXT('<UomID>' + recItemUOM.Code + '</UomID>');
//             RetXML.ADDTEXT('<UomPerQty>' + FORMAT(recItemUOM."Qty. per Unit of Measure") + '</UomPerQty>');
//             RetXML.ADDTEXT('</ItemUOM>');
//           UNTIL(recItemUOM.NEXT=0)
//         END
//         ELSE BEGIN
//           RetXML.ADDTEXT('<ItemUOM></ItemUOM>');
//         END;
//          RetXML.ADDTEXT('</DPTech>');
//     end;

//     procedure ReplaceCommaAndTide(InString: Text[1000]): Text[1024]
//     var
//         OutString: Text[80];
//         StringLen: Integer;
//         i: Integer;
//         Li: Integer;
//         LNewInString: Text[1024];
//         LTestChr: Text[1];
//         Apstrp: Label '''';
//     begin

//         LNewInString := '';
//         FOR Li := 1 TO STRLEN(InString) DO BEGIN
//           LTestChr := COPYSTR(InString,Li,1);
//           IF (LTestChr = ',')  THEN
//             BEGIN
//               IF LTestChr = ',' THEN
//                 LNewInString := LNewInString + '~'
//               ELSE IF LTestChr = '~' THEN
//                 LNewInString := LNewInString+ ','


//             END
//           ELSE
//             LNewInString := LNewInString + LTestChr;
//         END;

//         EXIT(LNewInString);
//     end;

//     procedure GetUnitPrice(itemID: Code[20];CustomerID: Code[20];var RetXML: BigText;UomID: Code[20])
//     var
//         recSalePrice: Record "7002";
//         decUnitPrice: Decimal;
//         isCustomerPrice: Boolean;
//         isCustomerPriceGroup: Boolean;
//         isAllCustomer: Boolean;
//         recCustomer: Record "18";
//         recItem: Record "27";
//         recSalesLineDiscount: Record "7004";
//     begin
//         isCustomerPrice := FALSE;
//         isCustomerPriceGroup := FALSE;
//         isAllCustomer := FALSE;

//         RetXML.ADDTEXT('<DPTech>');

//         //IF (CustomerID <> '') THEN BEGIN
//           recSalePrice.RESET;
//           recSalePrice.SETCURRENTKEY("Item No.","Ending Date");
//           recSalePrice.SETRANGE("Item No.",itemID);
//           recSalePrice.SETRANGE("Sales Type",recSalePrice."Sales Type"::Customer);
//           recSalePrice.SETRANGE("Sales Code",CustomerID);
//           recSalePrice.SETRANGE("Unit of Measure Code",UomID);
//           //DD621
//           recSalePrice.SETFILTER("Starting Date",'%1|<=%2',0D,TODAY);
//           recSalePrice.SETFILTER("Ending Date",'%1|>=%2',0D,TODAY);
//           //DD621

//           IF recSalePrice.FIND('-') THEN BEGIN
//             REPEAT
//               RetXML.ADDTEXT('<UnitPrice>');
//               RetXML.ADDTEXT('<Price>' + FORMAT(recSalePrice."Unit Price") + '</Price>');
//               RetXML.ADDTEXT('<ItemNo>' +recSalePrice."Item No." +'</ItemNo>');
//               RetXML.ADDTEXT('<UomID>' + recSalePrice."Unit of Measure Code" + '</UomID>');
//               RetXML.ADDTEXT('</UnitPrice>');
//               isCustomerPrice := TRUE;
//             UNTIL (recSalePrice.NEXT=0);
//           END;

//           //For Customer Price Group
//           IF (isCustomerPrice= FALSE) THEN BEGIN
//             recCustomer.RESET;
//             IF recCustomer.GET(CustomerID) THEN

//             recSalePrice.RESET;
//             recSalePrice.SETCURRENTKEY("Item No.","Ending Date");
//             recSalePrice.SETRANGE("Item No.",itemID);
//             recSalePrice.SETRANGE("Unit of Measure Code",UomID);
//             recSalePrice.SETRANGE("Sales Type",recSalePrice."Sales Type"::"Customer Price Group");
//             recSalePrice.SETRANGE("Sales Code",recCustomer."Customer Price Group");
//             //DD621
//             recSalePrice.SETFILTER("Starting Date",'%1|<=%2',0D,TODAY);
//             recSalePrice.SETFILTER("Ending Date",'%1|>=%2',0D,TODAY);
//             //DD621

//             IF recSalePrice.FIND('-') THEN BEGIN
//               REPEAT
//                 RetXML.ADDTEXT('<UnitPrice>');
//                 RetXML.ADDTEXT('<Price>' + FORMAT(recSalePrice."Unit Price") + '</Price>');
//                 RetXML.ADDTEXT('<ItemNo>' +recSalePrice."Item No." +'</ItemNo>');
//                 RetXML.ADDTEXT('<UomID>' + recSalePrice."Unit of Measure Code" + '</UomID>');
//                 RetXML.ADDTEXT('</UnitPrice>');
//                 isCustomerPriceGroup := TRUE;
//               UNTIL (recSalePrice.NEXT=0);
//             END;
//           END;

//         //For All Customer
//           IF (isCustomerPrice= FALSE) AND (isCustomerPriceGroup = FALSE) THEN BEGIN
//             recSalePrice.RESET;
//             recSalePrice.SETCURRENTKEY("Item No.","Ending Date");
//             recSalePrice.SETRANGE("Item No.",itemID);
//             recSalePrice.SETRANGE("Unit of Measure Code",UomID);
//             recSalePrice.SETRANGE("Sales Type",recSalePrice."Sales Type"::"All Customers");
//             //DD621
//             recSalePrice.SETFILTER("Starting Date",'%1|<=%2',0D,TODAY);
//             recSalePrice.SETFILTER("Ending Date",'%1|>=%2',0D,TODAY);
//             //DD621

//             IF recSalePrice.FIND('-') THEN BEGIN
//               REPEAT
//                 RetXML.ADDTEXT('<UnitPrice>');
//                 RetXML.ADDTEXT('<Price>' + FORMAT(recSalePrice."Unit Price") + '</Price>');
//                 RetXML.ADDTEXT('<ItemNo>' +recSalePrice."Item No." +'</ItemNo>');
//                 RetXML.ADDTEXT('<UomID>' + recSalePrice."Unit of Measure Code" + '</UomID>');
//                 RetXML.ADDTEXT('</UnitPrice>');
//                 isAllCustomer := TRUE;
//               UNTIL (recSalePrice.NEXT=0);
//             END;
//           END;

//             //Get from Item Card
//           IF (isCustomerPrice= FALSE) AND (isCustomerPriceGroup = FALSE) AND (isAllCustomer = FALSE) THEN BEGIN
//             recItem.RESET;
//             IF recItem.GET(itemID) THEN BEGIN
//                 RetXML.ADDTEXT('<UnitPrice>');
//                 RetXML.ADDTEXT('<Price>' + FORMAT(recItem."Unit Price") + '</Price>');
//                 RetXML.ADDTEXT('<ItemNo>' +recItem."No." +'</ItemNo>');
//                 RetXML.ADDTEXT('<UomID>' + recItem."Base Unit of Measure" + '</UomID>');
//                 RetXML.ADDTEXT('</UnitPrice>');
//             END;
//           END;
//         //END;


//          RetXML.ADDTEXT('</DPTech>');
//     end;

//     procedure GenerateSOQuote(PurHInfo: Text[1024];PurLInfo: array [50] of Text[1024]): Text
//     var
//         recSOHeader: Record "36";
//         recSOLine: Record "37";
//         SalesSetup: Record "311";
//         NoSeriesMgt: Codeunit "396";
//         SOQuoteNo: Code[10];
//         dDocDate: Date;
//         DocumentDate: Text[20];
//         SelltoCustomerNo: Text[20];
//         ShiptoAddress: Text[100];
//         ShiptoAddress2: Text[100];
//         SalesPersonCode: Text[10];
//         iLineNo: Integer;
//         LineNo: Text[20];
//         LineDocType: Text[20];
//         LineType: Text[20];
//         No: Text[20];
//         dQuantity: Decimal;
//         Quantity: Text[20];
//         dUnitPrice: Decimal;
//         UnitPrice: Text[20];
//         cUnitUOM: Text[20];
//         strRetInvoiceNo: Text[30];
//         strInfoSplit: Text[1024];
//         i: Integer;
//         strInfoLine1Split: Text[1024];
//         recItem: Record "27";
//         SalesType: Text[20];
//         IsFoc: Text[20];
//     begin
//         strRetInvoiceNo:='';
//         PurHInfo := ReplaceCommaAndTide(PurHInfo);
//         strInfoSplit :=CONVERTSTR(PurHInfo,'|',',');

//         DocumentDate:=SELECTSTR(1,strInfoSplit);
//         SelltoCustomerNo:=SELECTSTR(2,strInfoSplit);


//         ShiptoAddress:=SELECTSTR(3,strInfoSplit);
//         //Trim to 50
//         IF STRLEN(ShiptoAddress) > 50 THEN
//           ShiptoAddress := PADSTR(ShiptoAddress,50);
//          //Trim to 50

//         ShiptoAddress2:= SELECTSTR(4,strInfoSplit);
//         //Trim to 50
//         IF STRLEN(ShiptoAddress2) > 50 THEN
//           ShiptoAddress2 := PADSTR(ShiptoAddress2,50);
//          //Trim to 50

//         SalesPersonCode:= SELECTSTR(5,strInfoSplit);

//         SalesSetup.GET;
//         SalesSetup.TESTFIELD("Order Nos.");

//         SOQuoteNo:= NoSeriesMgt.GetNextNo( SalesSetup."Quote Nos.",TODAY,TRUE);

//         recSOHeader.INIT;
//         recSOHeader."Document Type":= recSOHeader."Document Type"::Quote;
//         //recInvoiceHeader."No.":=SONo;
//         recSOHeader.VALIDATE("No.",SOQuoteNo);
//         //recInvoiceHeader.VALIDATE("No. Series",SalesSetup."Order Nos.");
//         //recInvoiceHeader."No. Series" := SalesSetup."Order Nos.";

//         recSOHeader.INSERT(TRUE);
//         COMMIT;

//         recSOHeader.RESET;
//         IF recSOHeader.GET(recSOHeader."Document Type"::Quote,SOQuoteNo) THEN BEGIN

//         NoSeriesMgt.SetDefaultSeries(recSOHeader."Posting No. Series",SalesSetup."Posted Invoice Nos.");
//         NoSeriesMgt.SetDefaultSeries(recSOHeader."Shipping No. Series",SalesSetup."Posted Shipment Nos.");
//         NoSeriesMgt.SetDefaultSeries(recSOHeader."Prepayment No. Series",SalesSetup."Posted Prepmt. Inv. Nos.");
//         NoSeriesMgt.SetDefaultSeries(recSOHeader."Prepmt. Cr. Memo No. Series",SalesSetup."Posted Prepmt. Cr. Memo Nos.");
//         recSOHeader."Posting Description" := FORMAT(recSOHeader."Document Type") + ' ' + recSOHeader."No.";

//         //recInvoiceHeader.VALIDATE("No.",SONo);
//         //recInvoiceHeader.VALIDATE("Posting Date",TODAY);
//         EVALUATE(dDocDate,DocumentDate);
//         recSOHeader."Document Date":= dDocDate;
//         recSOHeader."Order Date" := TODAY;
//         //recSOHeader."Posting Date" := TODAY;
//         recSOHeader."Shipment Date" := TODAY;

//         recSOHeader.VALIDATE("Sell-to Customer No.",SelltoCustomerNo);
//         recSOHeader."Ship-to Address":=ReplaceCommaAndTide(ShiptoAddress);
//         recSOHeader."Ship-to Address 2" :=ReplaceCommaAndTide(ShiptoAddress2);
//         recSOHeader."Salesperson Code" :=SalesPersonCode;
//         recSOHeader."Authorization Required":=TRUE;
//         recSOHeader.MODIFY(TRUE);
//         END;

//         FOR i:=1 TO 50 DO BEGIN
//           IF PurLInfo[i]<>'-' THEN BEGIN
//           CLEAR(strInfoLine1Split);
//           CLEAR(LineNo);
//           CLEAR(LineDocType);
//           CLEAR(LineType);
//           CLEAR(No);
//           CLEAR(cUnitUOM);
//           CLEAR(Quantity);
//           CLEAR (UnitPrice);
//           CLEAR (SalesType);
//           strInfoLine1Split :=CONVERTSTR(PurLInfo[i],'|',',');
//           LineNo :=SELECTSTR(1,strInfoLine1Split);
//           No :=SELECTSTR(2,strInfoLine1Split);
//           cUnitUOM :=SELECTSTR(3,strInfoLine1Split);
//           Quantity :=SELECTSTR(4,strInfoLine1Split);
//           UnitPrice :=SELECTSTR(5,strInfoLine1Split);
//           SalesType := SELECTSTR(6,strInfoLine1Split);
//           IsFoc :=  SELECTSTR(7,strInfoLine1Split);
//           recSOLine.INIT;
//           recSOLine."Document Type":=recSOLine."Document Type" :: Quote;
//           recSOLine."Document No.":= SOQuoteNo;
//           EVALUATE(iLineNo,LineNo);
//           EVALUATE(dUnitPrice,UnitPrice);
//           EVALUATE(dQuantity,Quantity);
//           recSOLine."Line No.":=iLineNo;

//           IF SalesType='Item' THEN BEGIN
//            recSOLine.VALIDATE(Type,recSOLine.Type::Item);
//             recSOLine.VALIDATE("No.",No);
//             recSOLine.VALIDATE(Quantity,dQuantity);
//             recSOLine.VALIDATE("Location Code",'TJC');
//           // EVALUATE(dUnitPrice,UnitPrice);
//             IF (dUnitPrice=0) THEN BEGIN
//               IF IsFoc='true' THEN  BEGIN
//                // recSOLine."Unit Price":=dUnitPrice;
//         //        recSOLine."Unit Price":=0;
//                 recSOLine.VALIDATE("Unit Price",0);

//                 //recSOLine.Quantity:=dQuantity;
//                // recSOLine.VALIDATE(Quantity,dQuantity);
//                 recSOLine."Unit of Measure Code":=cUnitUOM;
//                 recSOLine."Line Amount" :=0;
//                 recSOLine.Amount :=0;
//                 recSOLine."Amount Including VAT" := 0;
//                // recSOLine."Line Discount %" := 0;
//                 recSOLine."Allow Invoice Disc." := FALSE;


//                 //recSOLine."Line Discount %" :=0;
//                // recSOLine."Qty. to Invoice":=dQuantity;
//                // recSOLine."Qty. to Ship":=dQuantity;

//               END
//             END ELSE
//             BEGIN
//                 recSOLine."Unit Price":=dUnitPrice;
//                         //recSOLine.Quantity:=dQuantity;
//                // recSOLine.VALIDATE(Quantity,dQuantity);
//                 //recSOLine."Unit of Measure Code":=cUnitUOM;
//                 recSOLine.VALIDATE("Unit Price",dUnitPrice);
//                 recSOLine.VALIDATE("Unit of Measure Code",cUnitUOM);
//             END;
//             // recSOLine.VALIDATE("Location Code",'TJC');
//           END ELSE
//           BEGIN
//            recSOLine.VALIDATE(Type,recSOLine.Type::"G/L Account");
//             recSOLine.VALIDATE("No.",No);
//               recSOLine.VALIDATE("Unit Price",dUnitPrice);
//               recSOLine.VALIDATE(Quantity,dQuantity);
//            // recSOLine.VALIDATE(Quantity,dQuantity);
//           END;


//           recSOLine.INSERT;

//           END;
//         END;
//         strRetInvoiceNo:=SOQuoteNo;
//         EXIT(strRetInvoiceNo);
//     end;

//     procedure DeleteQuote(SONo: Code[20])
//     var
//         SalesHeader: Record "36";
//         SalesLine: Record "37";
//     begin

//           IF SalesHeader.GET(SalesHeader."Document Type"::Quote,SONo) THEN
//           BEGIN
//             SalesHeader.DELETE(TRUE);

//             SalesLine.RESET;
//             SalesLine.SETFILTER(SalesLine.Type,'%1',SalesLine.Type::Item);
//             SalesLine.SETFILTER(SalesLine."Document No.",'%1',SONo);
//             IF SalesLine.FINDFIRST THEN
//               SalesLine.DELETE(TRUE);
//           END;
//     end;

//     procedure GetQuoteHeader(var Result: BigText;SalesPerson: Code[10];StartDate: Date;EndDate: Date;IsByCustomer: Boolean;SearchValue: Text[50])
//     var
//         SalesHeader: Record "36";
//     begin
//          //SETRANGE(DocDate, StartDate, EndDate);
//          //SETFILTER(DocDate, '%1..%2', StartDate, EndDate);

//             CLEAR(Result);
//         //  IF SalesPerson = '' THEN
//         //    EXIT;
//           SalesHeader.RESET;
//           SalesHeader.SETFILTER(SalesHeader."Document Type",'%1',SalesHeader."Document Type"::Quote);
//           IF SalesPerson <> '' THEN
//             SalesHeader.SETFILTER(SalesHeader."Salesperson Code",'%1',SalesPerson);

//           SalesHeader.SETFILTER(SalesHeader."Authorization Required",'%1',TRUE); //Is Mobile Order

//           SalesHeader.SETFILTER(SalesHeader."Document Date", '%1..%2', StartDate, EndDate);
//           IF SearchValue <>'' THEN  BEGIN
//           IF IsByCustomer THEN
//              SalesHeader.SETFILTER(SalesHeader."Sell-to Customer No.",'%1','@*'+ SearchValue +'*')
//           ELSE
//              SalesHeader.SETFILTER(SalesHeader."No.",'%1','@*'+ SearchValue +'*');
//           END;
//           IF SalesHeader.FINDFIRST THEN
//           REPEAT
//             SalesHeader.CALCFIELDS(Amount);
//             SalesHeader.CALCFIELDS("Amount Including VAT");
//             Result.ADDTEXT(SalesHeader."No." + ' || ' +
//                            SalesHeader."Sell-to Customer No." + ' || ' +
//                            SalesHeader."Sell-to Customer Name" + ' || ' +
//                            SalesHeader."Sell-to Address" +'||'+
//                            FORMAT(SalesHeader.Amount) + ' || ' +
//                            FORMAT(SalesHeader."Amount Including VAT") + ' || ' +
//                            FORMAT(SalesHeader."Document Date",0,'<Day,2>/<Month,2>/<Year4>') + ' ||| ');

//           UNTIL SalesHeader.NEXT = 0;
//     end;

//     procedure GetQuoteLine(var Result: BigText;DocNo: Text[50]): Boolean
//     var
//         SalesLine: Record "37";
//         SalesHeader: Record "36";
//         ReasonCode: Text[20];
//         UomId: Text[20];
//     begin
//          //SETRANGE(DocDate, StartDate, EndDate);
//          //SETFILTER(DocDate, '%1..%2', StartDate, EndDate);

//           CLEAR(Result);
//           SalesLine.RESET;
//          // SalesLine.SETFILTER(SalesLine.Type,'%1',SalesLine.Type::Item);
//           SalesLine.SETFILTER(SalesLine."Document Type",'%1',SalesHeader."Document Type"::Quote);
//           SalesLine.SETFILTER(SalesLine."Document No.",'%1',DocNo);
//           IF SalesLine.FINDFIRST THEN
//           REPEAT
//             IF SalesLine."Return Reason Code"='' THEN
//             BEGIN
//               ReasonCode:='-';
//             END ELSE
//               ReasonCode:=SalesLine."Return Reason Code";

//             IF SalesLine."Unit of Measure Code"='' THEN
//             BEGIN
//               UomId:='-';
//              END ELSE
//                UomId:= SalesLine."Unit of Measure Code";
//             Result.ADDTEXT(SalesLine."No." + ' || ' +
//                            FORMAT(SalesLine."Line No.") + ' || ' +
//                            SalesLine.Description + ' || ' +
//                            FORMAT(SalesLine."Unit Price") + ' || ' +
//                            FORMAT(SalesLine.Quantity) +'||' +
//                            UomId + '||' +
//                            FORMAT(SalesLine."Line Discount %") + '||' +
//                            ReasonCode + '||' +
//                            FORMAT(SalesLine."Line Amount") + '||' +
//                            FORMAT( SalesLine.Type) + '|||');
//           UNTIL SalesLine.NEXT = 0;

//           IF SalesHeader.GET(SalesHeader."Document Type"::Quote, DocNo) THEN
//           BEGIN
//             IF SalesHeader.Status = SalesHeader.Status::Open THEN
//               EXIT(TRUE)
//             ELSE
//               EXIT(FALSE);
//           END;
//     end;

//     procedure MakeOrder(QuoteCode: Code[20]): Text[50]
//     var
//         CSalesQuotetoOrder: Codeunit "86";
//         recSaleHeader: Record "36";
//         recSaleHeader2: Record "36";
//         retValue: Text[50];
//     begin
//         retValue:= '';
//         recSaleHeader.RESET;
//         IF recSaleHeader.GET(recSaleHeader."Document Type"::Quote,QuoteCode) THEN BEGIN
//           CSalesQuotetoOrder.RUN(recSaleHeader);
//           COMMIT;
//         END;

//         recSaleHeader.RESET;
//         recSaleHeader.SETRANGE(recSaleHeader."Quote No.",QuoteCode);
//         IF recSaleHeader.FIND('+') THEN BEGIN
//           retValue := recSaleHeader."No.";
//         END;
//         EXIT(retValue)
//     end;

//     procedure DeleteQuoteLine(HDocNo: Code[20];lineNo: Integer)
//     var
//         recSalesQuoteLine: Record "37";
//     begin
//         recSalesQuoteLine.RESET;
//         IF recSalesQuoteLine.GET(recSalesQuoteLine."Document Type"::Quote,HDocNo,lineNo) THEN
//            recSalesQuoteLine.DELETE(TRUE)
//         //Document Type,Document No.,Line No.
//     end;

//     procedure UpdateQuoteLine(HDocNo: Code[20];lineNo: Integer;ItemNo: Code[20];Qty: Integer;ReasonCode: Code[20];Amount: Decimal;UomId: Code[20];IsFoc: Text[20])
//     var
//         recSalesQuoteLine: Record "37";
//     begin
//         recSalesQuoteLine.RESET;
//         IF recSalesQuoteLine.GET(recSalesQuoteLine."Document Type"::Quote,HDocNo,lineNo) THEN BEGIN
//           //recSalesQuoteLine."No." := ItemNo;
//           recSalesQuoteLine.VALIDATE("No.",ItemNo);
//           //recSalesQuoteLine."Unit of Measure Code" := UomId;
//           recSalesQuoteLine.VALIDATE("Unit of Measure Code",UomId);
//           //recSalesQuoteLine.Quantity := Qty;
//           recSalesQuoteLine.VALIDATE(Quantity,Qty);
//           recSalesQuoteLine.VALIDATE("Location Code",'TJC');
//           IF Amount=0 THEN BEGIN
//           IF IsFoc='true' THEN BEGIN
//            // recSalesQuoteLine."Unit Price":=0;
//            recSalesQuoteLine.VALIDATE("Unit Price",0);
//             recSalesQuoteLine."Line Amount" :=0;
//             recSalesQuoteLine.Amount := 0;
//             recSalesQuoteLine."Amount Including VAT" := 0;
//            // recSalesQuoteLine."Qty. to Invoice":=Quantity;
//            // recSalesQuoteLine."Qty. to Ship":=Quantity;

//             //recSalesQuoteLine."Line Discount %" := 0;
//             recSalesQuoteLine."Allow Invoice Disc." := FALSE;


//             END
//            END;
//           recSalesQuoteLine."Return Reason Code" :=  ReasonCode;
//         //  recSalesQuoteLine."Line Amount" :=Amount;
//           recSalesQuoteLine.MODIFY(TRUE)
//         END;
//         //Document Type,Document No.,Line No.
//     end;

//     procedure GetReasonCode(var RetXML: BigText)
//     var
//         recReasonCode: Record "6635";
//     begin
//         RetXML.ADDTEXT('<DPTech>');
//         recReasonCode.RESET;
//         IF recReasonCode.FIND('-') THEN
//         REPEAT
//           RetXML.ADDTEXT('<ReasonCode>');
//           RetXML.ADDTEXT('<Code>' + FORMAT(recReasonCode.Code) + '</Code>');
//           RetXML.ADDTEXT('<Description>' + FORMAT(recReasonCode.Description) + '</Description>');
//             RetXML.ADDTEXT('</ReasonCode>');
//         UNTIL recReasonCode.NEXT = 0;
//         RetXML.ADDTEXT('</DPTech>');
//     end;

//     procedure GetDiscount(itemID: Code[20];CustomerID: Code[20];var RetXML: BigText;UomId: Code[20])
//     var
//         decDiscount: Decimal;
//         isCustomerDisc: Boolean;
//         isCustomerDiscGroup: Boolean;
//         isAllCustomer: Boolean;
//         recCustomer: Record "18";
//         recItem: Record "27";
//         recSalesLineDiscount: Record "7004";
//         isItemDiscGroup: Boolean;
//     begin
//         isCustomerDisc := FALSE;
//         isCustomerDiscGroup := FALSE;
//         isAllCustomer := FALSE;

//         RetXML.ADDTEXT('<DPTech>');

//         //IF (CustomerID <> '') THEN BEGIN
//           recSalesLineDiscount.RESET;
//          // recSalesLineDiscount.SETCURRENTKEY("Item No.","Ending Date");
//         //  recSalesLineDiscount.SETFILTER("Starting Date",'<%1',TODAY);
//         //  recSalesLineDiscount.SETFILTER("Ending Date",'>%1',TODAY);
//           recSalesLineDiscount.SETRANGE(Type,recSalesLineDiscount.Type::Item);
//           recSalesLineDiscount.SETRANGE(Code,itemID);
//           recSalesLineDiscount.SETRANGE("Sales Type",recSalesLineDiscount."Sales Type"::Customer);
//           recSalesLineDiscount.SETRANGE("Sales Code",CustomerID);
//           recSalesLineDiscount.SETRANGE("Unit of Measure Code",UomId);
//           IF recSalesLineDiscount.FIND('-') THEN BEGIN
//             REPEAT
//               RetXML.ADDTEXT('<Discount>');
//               RetXML.ADDTEXT('<DiscPercent>' + FORMAT(recSalesLineDiscount."Line Discount %") + '</DiscPercent>');
//               RetXML.ADDTEXT('<ItemNo>' +recSalesLineDiscount.Code +'</ItemNo>');
//               RetXML.ADDTEXT('<UomID>' + recSalesLineDiscount."Unit of Measure Code" + '</UomID>');
//               RetXML.ADDTEXT('</Discount>');
//               isCustomerDisc := TRUE;
//             UNTIL (recSalesLineDiscount.NEXT=0);
//           END;

//           //For Customer Disc Group with Item
//           IF (isCustomerDisc= FALSE) THEN BEGIN
//             recCustomer.RESET;
//             IF recCustomer.GET(CustomerID) THEN
//             recSalesLineDiscount.RESET;
//             //recSalesLineDiscount.SETCURRENTKEY("Item No.","Ending Date");
//           //  recSalesLineDiscount.SETFILTER("Starting Date",'<%1',TODAY);
//           //  recSalesLineDiscount.SETFILTER("Ending Date",'>%1',TODAY);
//             recSalesLineDiscount.SETRANGE(Type,recSalesLineDiscount.Type::Item);
//             recSalesLineDiscount.SETRANGE(Code,itemID);
//             recSalesLineDiscount.SETRANGE("Sales Type",recSalesLineDiscount."Sales Type"::"Customer Disc. Group");
//             recSalesLineDiscount.SETRANGE("Sales Code",recCustomer."Customer Disc. Group");
//             recSalesLineDiscount.SETRANGE("Unit of Measure Code",UomId);
//             IF recSalesLineDiscount.FIND('-') THEN BEGIN
//               REPEAT
//                 RetXML.ADDTEXT('<Discount>');
//                 RetXML.ADDTEXT('<DiscPercent>' + FORMAT(recSalesLineDiscount."Line Discount %") + '</DiscPercent>');
//                 RetXML.ADDTEXT('<ItemNo>' +recSalesLineDiscount.Code +'</ItemNo>');
//                 RetXML.ADDTEXT('<UomID>' + recSalesLineDiscount."Unit of Measure Code" + '</UomID>');
//                 RetXML.ADDTEXT('</Discount>');
//                 isCustomerDiscGroup := TRUE;
//               UNTIL (recSalesLineDiscount.NEXT=0);
//             END;
//           END;
//           // For Customer Disc Group with Item Disc Group


//         //For All Customer
//           IF (isCustomerDisc= FALSE) AND (isCustomerDiscGroup = FALSE) THEN BEGIN
//             recSalesLineDiscount.RESET;
//            // recSalesLineDiscount.SETCURRENTKEY("Item No.","Ending Date");
//         //    recSalesLineDiscount.SETFILTER("Starting Date",'<%1',TODAY);
//         //    recSalesLineDiscount.SETFILTER("Ending Date",'>%1',TODAY);
//             recSalesLineDiscount.SETRANGE(Type,recSalesLineDiscount.Type::Item);
//             recSalesLineDiscount.SETRANGE(Code,itemID);
//             recSalesLineDiscount.SETRANGE("Sales Type",recSalesLineDiscount."Sales Type"::"All Customers");
//             recSalesLineDiscount.SETRANGE("Unit of Measure Code",UomId);
//             IF recSalesLineDiscount.FIND('-') THEN BEGIN
//                 RetXML.ADDTEXT('<Discount>');
//                 RetXML.ADDTEXT('<DiscPercent>' + FORMAT(recSalesLineDiscount."Line Discount %") + '</DiscPercent>');
//                 RetXML.ADDTEXT('<ItemNo>' +recSalesLineDiscount.Code +'</ItemNo>');
//                 RetXML.ADDTEXT('<UomID>' + recSalesLineDiscount."Unit of Measure Code" + '</UomID>');
//                 RetXML.ADDTEXT('</Discount>');
//               REPEAT
//                 isAllCustomer := TRUE;
//               UNTIL (recSalesLineDiscount.NEXT=0);
//             END;
//           END;

//             //Get from Item Card
//           IF (isCustomerDisc= FALSE) AND (isCustomerDiscGroup = FALSE) AND (isAllCustomer = FALSE) THEN BEGIN
//             recItem.RESET;
//             IF recItem.GET(itemID) THEN BEGIN
//                 RetXML.ADDTEXT('<Discount>');
//                 RetXML.ADDTEXT('<DiscPercent> 0 </DiscPercent>');
//                 RetXML.ADDTEXT('<ItemNo>' +recItem."No." +'</ItemNo>');
//                 RetXML.ADDTEXT('<UomID>' + recItem."Base Unit of Measure" + '</UomID>');
//                 RetXML.ADDTEXT('</Discount>');
//             END;
//           END;
//         //END;


//          RetXML.ADDTEXT('</DPTech>');
//     end;

//     procedure InsertQuoteLine(PurLInfo: Text[1024];SOQuoteNo: Code[20]): Text
//     var
//         recSOLine: Record "37";
//         SalesSetup: Record "311";
//         NoSeriesMgt: Codeunit "396";
//         DocumentDate: Text[20];
//         LineDocType: Text[20];
//         No: Text[20];
//         dQuantity: Decimal;
//         Quantity: Text[20];
//         dUnitPrice: Decimal;
//         UnitPrice: Text[20];
//         cUnitUOM: Text[20];
//         strRetInvoiceNo: Text[30];
//         strInfoSplit: Text[1024];
//         i: Integer;
//         strInfoLineSplit: Text[1024];
//         recItem: Record "27";
//         LastLineNo: Integer;
//         SalesType: Text[20];
//         CustomerId: Text[30];
//         IsFoc: Text[20];
//     begin
//           strRetInvoiceNo:='';

//           CLEAR(strInfoLineSplit);
//           CLEAR(LineDocType);
//           CLEAR(No);
//           CLEAR(cUnitUOM);
//           CLEAR(Quantity);
//           CLEAR (UnitPrice);
//           CLEAR(SalesType);
//           CLEAR(CustomerId);
//           PurLInfo := ReplaceCommaAndTide(PurLInfo);
//           strInfoLineSplit :=CONVERTSTR(PurLInfo,'|',',');
//           No :=SELECTSTR(1,strInfoLineSplit);
//           cUnitUOM :=SELECTSTR(2,strInfoLineSplit);
//           Quantity :=SELECTSTR(3,strInfoLineSplit);
//           UnitPrice :=SELECTSTR(4,strInfoLineSplit);
//           SalesType:=SELECTSTR(5,strInfoLineSplit);
//           CustomerId:= SELECTSTR(6,strInfoLineSplit);
//           IsFoc:= SELECTSTR(7,strInfoLineSplit);
//           recSOLine.RESET;
//           recSOLine.SETRANGE("Document Type", recSOLine."Document Type"::Quote);
//           recSOLine.SETRANGE("Document No.", SOQuoteNo);
//           IF recSOLine.FINDLAST THEN
//             LastLineNo := recSOLine."Line No."
//           ELSE
//             LastLineNo := 0;

//           CLEAR(recSOLine);
//           recSOLine.INIT;
//           recSOLine."Document Type":=recSOLine."Document Type" :: Quote;
//           recSOLine."Document No.":= SOQuoteNo;
//           recSOLine."Sell-to Customer No.":=CustomerId;
//            recSOLine."Line No.":=LastLineNo + 10000;
//            EVALUATE(dQuantity,Quantity);
//            EVALUATE(dUnitPrice,UnitPrice);
//           IF SalesType='Item' THEN BEGIN
//            recSOLine.VALIDATE(Type,recSOLine.Type::Item);
//             recSOLine.VALIDATE("No.",No);
//             recSOLine.VALIDATE("Location Code",'TJC');
//            EVALUATE(dUnitPrice,UnitPrice);
//            recSOLine.VALIDATE(Quantity,dQuantity);
//             IF (dUnitPrice=0) THEN BEGIN
//               IF IsFoc='true' THEN BEGIN
//                 //recSOLine."Unit Price":=0;
//                 recSOLine.VALIDATE("Unit Price",0);
//                  recSOLine."Line Amount" :=0;
//                  recSOLine.Amount := 0;
//                  recSOLine."Amount Including VAT" := 0;
//                 // recSOLine."Line Discount %" := 0;
//                // recSOLine.Quantity:=dQuantity;
//                 recSOLine."Unit of Measure Code":=cUnitUOM;
//                // recSOLine."Qty. to Invoice":=0;
//               //  recSOLine."Qty. to Ship":=0;
//                 //recSOLine."Line Discount %" := 0;
//                 recSOLine."Allow Invoice Disc." := FALSE;


//                END
//             END ELSE
//             BEGIN
//              // recSOLine.VALIDATE(Quantity,dQuantity);
//               recSOLine.VALIDATE("Unit Price",dUnitPrice);
//               recSOLine.VALIDATE("Unit of Measure Code",cUnitUOM);
//               //recSOLine.VALIDATE("Location Code",'TJC');
//             END;

//           END ELSE
//           BEGIN
//            recSOLine.VALIDATE(Type,recSOLine.Type::"G/L Account");
//             recSOLine.VALIDATE("No.",No);
//             recSOLine.VALIDATE("Unit Price",dUnitPrice);
//             recSOLine.VALIDATE(Quantity,dQuantity);
//           END;

//         recSOLine.INSERT;
//         strRetInvoiceNo:=SOQuoteNo;
//         EXIT(strRetInvoiceNo);
//     end;

//     procedure DataPatching()
//     var
//         Lrec_ILE: Record "32";
//     begin
//         //UPDATE ILE - DP.HB DD#325
//         Lrec_ILE.RESET;
//         Lrec_ILE.SETRANGE("Lot No.", '20030804');
//         Lrec_ILE.SETFILTER("Remaining Quantity", '<>%1', 0);
//         IF Lrec_ILE.FINDFIRST THEN
//           REPEAT
//             IF Lrec_ILE."Remaining Quantity" <> 0 THEN BEGIN
//               Lrec_ILE."Remaining Quantity" := 0;
//               Lrec_ILE.Open := FALSE;
//               Lrec_ILE.MODIFY;
//             END;
//           UNTIL Lrec_ILE.NEXT = 0;

//         Lrec_ILE.RESET;
//         Lrec_ILE.SETRANGE("Lot No.", '20030804');
//         Lrec_ILE.SETRANGE("Document No.", 'DO07/01154');
//         IF Lrec_ILE.FINDFIRST THEN BEGIN
//           Lrec_ILE."Document Type" := Lrec_ILE."Document Type"::"Sales Shipment";
//           Lrec_ILE.Quantity := Lrec_ILE.Quantity * -1;
//           Lrec_ILE."Invoiced Quantity" := Lrec_ILE."Invoiced Quantity" * -1;
//           Lrec_ILE."Cost Amount (Actual)" := Lrec_ILE."Cost Amount (Actual)" * -1;
//           Lrec_ILE."Document Line No." := 10000;
//           Lrec_ILE."Shipped Qty. Not Returned" := Lrec_ILE.Quantity;
//           Lrec_ILE.MODIFY;
//         END;

//         MESSAGE('Data has been successfuly patched');
//     end;
// }

