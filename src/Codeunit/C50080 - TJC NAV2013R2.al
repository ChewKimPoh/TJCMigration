// codeunit 50080 SHWebServiceHandle
// {
//     SingleInstance = true;

//     trigger OnRun()
//     begin
//         MESSAGE('The Code unit SHWebServiceHandle has been started!');
//         CLEARALL;

//         IF ISCLEAR(MQBus) THEN
//             IF NOT CREATE(MQBus) THEN
//                 ERROR(Text001);

//         IF ISCLEAR(CC2) THEN
//             IF NOT CREATE(CC2) THEN
//                 ERROR(Text002);

//         IF ISCLEAR(XMLDoc) THEN
//             IF NOT CREATE(XMLDoc) THEN
//                 ERROR(Text003);

//         CC2.AddBusAdapter(MQBus,1);


//         CASE COMPANYNAME OF
//             'Tong Jum Chew Pte Ltd':
//                  MQBus.OpenReceiveQueue('.\Private$\to_tjc',0,0);
//             'X - Tong Jum Chew TEST':
//                  MQBus.OpenReceiveQueue('.\Private$\to_test',0,0);
//         END;
//     end;

//     var
//         MQBus: Automation ;
//         [WithEvents]
//         CC2: Automation ;
//         InMsg: Automation ;
//         XMLDoc: Automation ;
//         XMLNode: Automation ;
//         UserName: Text[50];
//         TCompanyName: Text[50];
//         FunctionName: Text[50];
//         ParameterList: Text[30];
//         Text001: Label 'MQBus does not exist!';
//         Text002: Label 'CC2 does not exist!';
//         Text003: Label 'Cannot create the xml document!';
//         InS: InStream;
//         XMLPortNo: Integer;
//         GeneralLedgerSetup: Record "98";
//         Temp_Path: Text[1024];

//     procedure FindNode(RootNode: Automation ;NodePath: Text[1024];var ReturnedNode: Automation ): Boolean
//     begin
//         ReturnedNode := RootNode.selectSingleNode(NodePath);
//         IF ISCLEAR(ReturnedNode) THEN
//             EXIT(FALSE)
//         ELSE
//             EXIT(TRUE);
//     end;

//     procedure SendSuccess(T_OutMsg: Automation )
//     var
//         T_OutStreamQueue: OutStream;
//         T_XMLDoc: Automation ;
//         T_XMLRoot: Automation ;
//         T_XMLNode: Automation ;
//     begin
//         T_OutStreamQueue := T_OutMsg.GetStream();
//         IF ISCLEAR(T_XMLDoc) THEN
//             IF NOT CREATE(T_XMLDoc) THEN
//                 ERROR(Text003);

//         T_XMLDoc.loadXML ('<?xml version="1.0" encoding="UTF-8"?><Success:description xmlns:Success="urn:Success"/>');
//         T_XMLRoot := T_XMLDoc.documentElement;
//         T_XMLRoot.text := 'OK';
//         T_XMLDoc.save(T_OutStreamQueue);
//         T_OutMsg.Send(0);
//         IF NOT ISCLEAR(T_OutMsg) THEN CLEAR(T_OutMsg);
//         IF NOT ISCLEAR(T_XMLDoc) THEN CLEAR(T_XMLDoc);
//     end;

//     procedure SendError(T_OutMsg: Automation ;ErrorMsg: Text[1024])
//     var
//         T_OutStreamQueue: OutStream;
//         T_XMLDoc: Automation ;
//         T_XMLRoot: Automation ;
//         T_XMLNode: Automation ;
//     begin
//         T_OutStreamQueue := T_OutMsg.GetStream();
//         IF ISCLEAR(T_XMLDoc) THEN
//             IF NOT CREATE(T_XMLDoc) THEN
//                 ERROR(Text003);

//         T_XMLDoc.loadXML ('<?xml version="1.0" encoding="UTF-8"?><MEVOError/>');
//         T_XMLRoot := T_XMLDoc.documentElement;
//         AddElement(T_XMLRoot,'trans_error',T_XMLRoot);
//         AddElement(T_XMLRoot,'trans_uid',T_XMLNode);
//         AddElement(T_XMLRoot,'error_desc',T_XMLNode);
//         T_XMLNode.text := ErrorMsg;
//         T_XMLDoc.save(T_OutStreamQueue);
//         T_OutMsg.Send(0);
//         IF NOT ISCLEAR(T_OutMsg) THEN CLEAR(T_OutMsg);
//         IF NOT ISCLEAR(T_XMLDoc) THEN CLEAR(T_XMLDoc);
//     end;

//     procedure AddElement(var XMLNode: Automation ;NodeName: Text[250];var CreatedXMLNode: Automation )
//     var
//         NewChildNode: Automation ;
//     begin
//         //for xml - add element to xml document

//         NewChildNode:=XMLNode.ownerDocument.createNode('element',NodeName,'');
//         XMLNode.appendChild(NewChildNode);
//         CreatedXMLNode:=NewChildNode;
//     end;

//     procedure AddAttribute(var XMLNode: Automation ;Name: Text[260];NodeValue: Text[260])
//     var
//         XMLNewAttributeNode: Automation ;
//     begin
//         //for xml - add attribute to xml document

//         IF NodeValue<>''THEN BEGIN
//         XMLNewAttributeNode:= XMLNode.ownerDocument.createAttribute(Name);
//         XMLNewAttributeNode.nodeValue:=NodeValue;
//         XMLNode.attributes.setNamedItem(XMLNewAttributeNode);
//         END;
//     end;

//     procedure GetRecord(T_XMLNode: Automation ;T_OutMsg: Automation ;xmlPortName: Text[30])
//     var
//         T_OutStreamQueue: OutStream;
//         RecRef: RecordRef;
//         xmlPortNumber: Integer;
//     begin

//         /*
//         TempBlob.Blob.CREATEINSTREAM(T_Instream);
//         XMLPORT.IMPORT(xmlPortNumber, T_Instream);


//         T_OutStreamQueue := T_OutMsg.GetStream();
//         T_XMLDoc.loadXML ('<?xml version="1.0" encoding="UTF-8"?><Success:description xmlns:Success="urn:Success"/>');
//         T_XMLRoot := T_XMLDoc.documentElement;
//         T_XMLRoot.text := 'OK';
//         T_XMLDoc.save(T_OutStreamQueue);
//         T_OutMsg.Send(0);
//         CLEAR(T_OutMsg);
//         CLEAR(T_XMLDoc);
//         */

//         xmlPortNumber := getXmlPortNumber(xmlPortName);

//         IF xmlPortNumber = 50036 THEN
//         BEGIN
//             Get_Customer_Price_History(T_OutMsg);
//             EXIT;
//         END;

//         IF xmlPortNumber = 50037 THEN
//         BEGIN
//             Get_Item_Location_Quantity(T_OutMsg);
//             EXIT;
//         END;


//         IF xmlPortNumber = 50038 THEN
//         BEGIN
//             Get_debtor_unpaid_bills_aging(T_OutMsg);
//             EXIT;
//         END;

//         IF xmlPortNumber = 50026 THEN
//         BEGIN
//             Location(T_OutMsg);
//             EXIT;
//         END;


//         IF fSaveAsFile(xmlPortName) THEN
//           SendSuccess(T_OutMsg)
//         ELSE
//           SendError(T_OutMsg,'Cannot export '+ xmlPortName);

//         IF ISCLEAR(T_OutMsg) THEN CLEAR(T_OutMsg);

//     end;

//     procedure InsertRecord(T_XMLNode: Automation ;T_OutMsg: Automation ;xmlPortNumber: Integer)
//     var
//         T_OutStreamQueue: OutStream;
//         T_XMLDoc: Automation ;
//         XMLNode: Automation ;
//         T_XMLRoot: Automation ;
//         TempBlob: Record "99008535";
//         T_OutStream: OutStream;
//         T_Instream: InStream;
//         bcon: Automation ;
//         i: Integer;
//         x: Integer;
//         OutText: array [1024] of Text[1024];
//         XmlFile: File;
//     begin
//         IF ISCLEAR(T_XMLDoc) THEN
//             IF NOT CREATE(T_XMLDoc) THEN
//                    ERROR(Text003);
//         /*
//         TempBlob.Blob.CREATEOUTSTREAM(T_OutStream);


//         CLEAR(bcon);
//         IF ISCLEAR(bcon) THEN
//             IF NOT CREATE(bcon) THEN
//               SendError(T_OutMsg, 'Create the BST error!');


//         i := 0;
//         x := 1;
//         bcon.BSTR(T_XMLNode.nodeTypedValue);
//         WHILE i < bcon.GetBSTRLength DO BEGIN
//           bcon.GetNextStringPortion(OutText[x],1000);
//           T_OutStream.WRITETEXT(OutText[x],1000);
//           i += 1000;
//           x +=1;
//         END;
//         CLEAR(bcon);


//         TempBlob.Blob.CREATEINSTREAM(T_Instream);
//         */
//         XmlFile.OPEN(T_XMLNode.text);
//         //MESSAGE(T_XMLNode.text);
//         XmlFile.CREATEINSTREAM(T_Instream);
//         XMLPORT.IMPORT(xmlPortNumber, T_Instream);

//         SendSuccess(InMsg.CreateReply);
//         EXIT;

//     end;

//     procedure getXmlPortNumber(xmlPortName: Text[30]): Integer
//     var
//         XmlPorts: array [1024] of Text[30];
//         XmlNumbers: array [1024] of Integer;
//         i: Integer;
//     begin
//         XmlNumbers[1] :=50011;
//         XmlNumbers[2] :=50012;
//         XmlNumbers[3] :=50013;
//         XmlNumbers[4] :=50014;
//         XmlNumbers[5] :=50015;
//         XmlNumbers[6] :=50016;
//         XmlNumbers[7] :=50017;
//         XmlNumbers[8] :=50018;
//         XmlNumbers[9] :=50019;
//         XmlNumbers[10]:=50020;
//         XmlNumbers[11]:=50021;
//         XmlNumbers[12]:=50022;
//         XmlNumbers[13]:=50023;
//         XmlNumbers[14]:=50024;
//         XmlNumbers[15]:=50025;
//         XmlNumbers[16]:=50026;
//         XmlNumbers[17]:=50027;
//         XmlNumbers[18]:=50028;
//         XmlNumbers[19]:=50029;
//         XmlNumbers[20]:=50030;
//         XmlNumbers[21]:=50031;
//         XmlNumbers[22]:=50032;
//         XmlNumbers[23]:=50033;
//         XmlNumbers[24]:=50034;
//         XmlNumbers[25]:=50035;
//         XmlNumbers[26]:=50036;
//         XmlNumbers[27]:=50037;
//         XmlNumbers[28]:=50038;


//         XmlPorts[1]:= 'bill_to';
//         XmlPorts[2]:= 'country';
//         XmlPorts[3]:= 'currency';
//         XmlPorts[4]:= 'customer';
//         XmlPorts[5]:= 'customer_contact';
//         XmlPorts[6]:= 'customer_discount_group';
//         XmlPorts[7]:= 'customer_history';
//         XmlPorts[8]:= 'customer_price_group';
//         XmlPorts[9]:= 'debtor_unpaid_bills';
//         XmlPorts[10]:= '';
//         XmlPorts[11]:= 'department';
//         XmlPorts[12]:= 'items';
//         XmlPorts[13]:= 'item_category';
//         XmlPorts[14]:= 'item_discount_group';
//         XmlPorts[15]:= 'item_uom';
//         XmlPorts[16]:= 'location';
//         XmlPorts[17]:= 'payment_method';
//         XmlPorts[18]:= 'payment_term';
//         XmlPorts[19]:= 'project';
//         XmlPorts[20]:= 'sales_person';
//         XmlPorts[21]:= 'sales_price';
//         XmlPorts[22]:= 'uom';
//         XmlPorts[23]:= 'iaf_trans';
//         XmlPorts[24]:= 'sales_line_discount';
//         XmlPorts[25]:= '';
//         XmlPorts[26]:= 'customer_price_history';
//         XmlPorts[27]:= 'item_location_quantity';
//         XmlPorts[28]:= 'debtor_unpaid_bills_aging';



//         i := 1;
//         REPEAT
//             IF ((XmlPorts[i] = xmlPortName) AND (XmlPorts[i] <> ''))  THEN
//             BEGIN
//                 EXIT (XmlNumbers[i]);
//             END;
//             i := i + 1;
//         UNTIL i>28;

//         EXIT (0);
//     end;

//     procedure Get_Customer_Price_History(T_OutMsg: Automation )
//     var
//         T_OutStreamQueue: OutStream;
//         T_XMLDoc: Automation ;
//         T_XMLFirstNode: Automation ;
//         T_XMLRoot: Automation ;
//         T_XMLNode: Automation ;
//         LoopNumber: Integer;
//         T_SalesInvLine1: Record "113";
//         T_SalesInvLine2: Record "113";
//         T_SalesInvoiceHeader: Record "112";
//         bExitLoop: Boolean;
//         GeneralLedgerSetup: Record "98";
//     begin
//         IF ISCLEAR(T_XMLDoc) THEN
//             IF NOT CREATE(T_XMLDoc) THEN
//                    ERROR(Text003);


//         T_OutStreamQueue := T_OutMsg.GetStream();
//         T_XMLDoc.loadXML ('<?xml version="1.0" encoding="UTF-8"?><MEVOData/>');
//         T_XMLRoot := T_XMLDoc.documentElement;


//         T_SalesInvLine1.SETCURRENTKEY("Sell-to Customer No.",Type,"Document No.");
//         T_SalesInvLine1.ASCENDING(FALSE);
//         T_SalesInvLine1.SETRANGE(Type,T_SalesInvLine1.Type::Item);
//         T_SalesInvLine1.SETRANGE("Document No.",'Q10/00001');
//         //T_SalesInvLine1.SETFILTER("Sell-to Customer No.",'<>%1','');
//         //T_SalesInvLine1.SETFILTER("Sell-to Customer No.",'<>%1','188');
//         IF T_SalesInvLine1.FIND('-') THEN
//           REPEAT
//             T_SalesInvLine2.SETCURRENTKEY("Sell-to Customer No.",Type,"Document No.");
//             T_SalesInvLine2.SETRANGE("Sell-to Customer No.",T_SalesInvLine1."Sell-to Customer No.");
//             T_SalesInvLine2.SETRANGE(Type,T_SalesInvLine1.Type);
//             T_SalesInvLine2.SETRANGE("No.",T_SalesInvLine1."No.");
//             T_SalesInvLine2.ASCENDING(FALSE);
//             IF T_SalesInvLine2.FIND('-') THEN
//             BEGIN
//                 LoopNumber := 1;
//                 AddElement(T_XMLRoot,'customer_price_history',T_XMLFirstNode);
//                 AddElement(T_XMLFirstNode,'customer_uid',T_XMLNode);
//                 T_XMLNode.text := T_SalesInvLine2."Sell-to Customer No.";
//                 AddElement(T_XMLFirstNode,'item_uid',T_XMLNode);
//                 T_XMLNode.text := T_SalesInvLine2."No.";
//                 AddElement(T_XMLFirstNode,'uom_uid',T_XMLNode);
//                 T_XMLNode.text := T_SalesInvLine2."Unit of Measure Code";
//                 AddElement(T_XMLFirstNode,'currency_code',T_XMLNode);
//                 T_SalesInvoiceHeader.RESET;
//                 T_SalesInvoiceHeader.SETRANGE("No.",T_SalesInvLine2."Document No.");
//                 T_SalesInvoiceHeader.FIND('-');
//                 IF  T_SalesInvoiceHeader."Currency Code" = '' THEN
//                     IF GeneralLedgerSetup.FIND('-') THEN
//                         T_XMLNode.text := GeneralLedgerSetup."LCY Code"
//                     ELSE T_XMLNode.text := 'SGD'
//                 ELSE
//                     T_XMLNode.text :=   T_SalesInvoiceHeader."Currency Code";

//             REPEAT
//                 T_SalesInvoiceHeader.RESET;
//                 T_SalesInvoiceHeader.SETRANGE("No.",T_SalesInvLine2."Document No.");
//                 T_SalesInvoiceHeader.FIND('-');
//                 IF LoopNumber = 1 THEN
//                 BEGIN
//                     AddElement(T_XMLFirstNode,'unit_price',T_XMLNode);
//                     T_XMLNode.text :=FORMATDECIMAL(T_SalesInvLine2."Unit Price");
//                     AddElement(T_XMLFirstNode,'quantity',T_XMLNode);
//                     T_XMLNode.text := FORMATDECIMAL(T_SalesInvLine2.Quantity);
//                     AddElement(T_XMLFirstNode,'trans_date',T_XMLNode);
//                     T_XMLNode.text := FORMATDATE(T_SalesInvoiceHeader."Posting Date");
//                 END;
//                 IF LoopNumber = 2 THEN
//                 BEGIN
//                     AddElement(T_XMLFirstNode,'unit_price2',T_XMLNode);
//                     T_XMLNode.text := FORMATDECIMAL(T_SalesInvLine2."Unit Price");
//                     AddElement(T_XMLFirstNode,'quantity2',T_XMLNode);
//                     T_XMLNode.text := FORMATDECIMAL(T_SalesInvLine2.Quantity);
//                     AddElement(T_XMLFirstNode,'trans_date2',T_XMLNode);
//                     T_XMLNode.text := FORMATDATE(T_SalesInvoiceHeader."Posting Date");
//                 END;
//                 IF LoopNumber = 3 THEN
//                 BEGIN
//                     AddElement(T_XMLFirstNode,'unit_price3',T_XMLNode);
//                     T_XMLNode.text := FORMATDECIMAL(T_SalesInvLine2."Unit Price");
//                     AddElement(T_XMLFirstNode,'quantity3',T_XMLNode);
//                     T_XMLNode.text := FORMATDECIMAL(T_SalesInvLine2.Quantity);
//                     AddElement(T_XMLFirstNode,'trans_date3',T_XMLNode);
//                     T_XMLNode.text := FORMATDATE(T_SalesInvoiceHeader."Posting Date");
//                 END;
//                     LoopNumber := LoopNumber + 1;
//                     bExitLoop := FALSE;
//                 IF (T_SalesInvLine2.NEXT = 0) THEN
//                 BEGIN
//                     bExitLoop := TRUE;
//                     IF (LoopNumber = 2) THEN
//                     BEGIN
//                     AddElement(T_XMLFirstNode,'unit_price2',T_XMLNode);
//                     T_XMLNode.text := '0';
//                     AddElement(T_XMLFirstNode,'quantity2',T_XMLNode);
//                     T_XMLNode.text := '0';
//                     AddElement(T_XMLFirstNode,'trans_date2',T_XMLNode);
//                     T_XMLNode.text := '2000-01-01T00:00:00';
//                     AddElement(T_XMLFirstNode,'unit_price3',T_XMLNode);
//                     T_XMLNode.text := '0';
//                     AddElement(T_XMLFirstNode,'quantity3',T_XMLNode);
//                     T_XMLNode.text := '0';
//                     AddElement(T_XMLFirstNode,'trans_date3',T_XMLNode);
//                     T_XMLNode.text := '2000-01-01T00:00:00';
//                     END;
//                     IF (LoopNumber = 3) THEN
//                     BEGIN
//                     AddElement(T_XMLFirstNode,'unit_price3',T_XMLNode);
//                     T_XMLNode.text := '0';
//                     AddElement(T_XMLFirstNode,'quantity3',T_XMLNode);
//                     T_XMLNode.text := '0';
//                     AddElement(T_XMLFirstNode,'trans_date3',T_XMLNode);
//                     T_XMLNode.text := '2000-01-01T00:00:00';
//                     END;
//                 END;
//             UNTIL ((bExitLoop) OR (LoopNumber>3));
//             END;
//             T_SalesInvLine1.SETRANGE("Sell-to Customer No.",T_SalesInvLine1."Sell-to Customer No.");
//             T_SalesInvLine1.SETRANGE("No.",T_SalesInvLine1."No.");
//             T_SalesInvLine1.FIND('+');
//             T_SalesInvLine1.SETRANGE("Sell-to Customer No.");
//             T_SalesInvLine1.SETRANGE("No.");
//           UNTIL T_SalesInvLine1.NEXT = 0;

//         T_XMLDoc.save(T_OutStreamQueue);
//         T_XMLDoc.save(Temp_Path +'customer_price_history.xml');

//         SendSuccess(T_OutMsg);
//         IF NOT ISCLEAR(T_OutMsg) THEN CLEAR(T_OutMsg);
//         IF NOT ISCLEAR(T_XMLDoc) THEN CLEAR(T_XMLDoc);
//     end;

//     procedure Get_Item_Location_Quantity(T_OutMsg: Automation )
//     var
//         T_OutStreamQueue: OutStream;
//         T_XMLDoc: Automation ;
//         T_XMLFirstNode: Automation ;
//         T_XMLRoot: Automation ;
//         T_XMLNode: Automation ;
//         LoopNumber: Integer;
//         bExitLoop: Boolean;
//         T_Item: Record "27";
//         T_Location: Record "14";
//         T_BinContent: Record "7302";
//     begin
//         IF ISCLEAR(T_XMLDoc) THEN
//             IF NOT CREATE(T_XMLDoc) THEN
//                    ERROR(Text003);


//         T_OutStreamQueue := T_OutMsg.GetStream();
//         T_XMLDoc.loadXML ('<?xml version="1.0" encoding="UTF-8"?><MEVOData/>');
//         T_XMLRoot := T_XMLDoc.documentElement;

//         /*
//         T_Item.RESET;
//         IF T_Item.FIND('-') THEN
//         REPEAT
//             T_Location.RESET;
//             IF T_Location.FIND('-') THEN
//             REPEAT
//                 T_Item.SETFILTER("Location Filter",T_Location.Code);
//                 T_Item.CALCFIELDS(Inventory);
//                 IF T_Item.Inventory > 0 THEN
//                 BEGIN
//                     AddElement(T_XMLRoot,'item_location_quantity',T_XMLFirstNode);
//                     AddElement(T_XMLFirstNode,'item_uid',T_XMLNode);
//                     T_XMLNode.text :=  T_Item."No.";
//                     AddElement(T_XMLFirstNode,'location_uid',T_XMLNode);
//                     T_XMLNode.text := T_Location.Code;
//                     AddElement(T_XMLFirstNode,'quantity',T_XMLNode);
//                     T_XMLNode.text := FORMATDECIMAL(T_Item.Inventory);
//                 END;
//             UNTIL T_Location.NEXT = 0;
//         UNTIL T_Item.NEXT = 0;
//         */

//         T_Item.RESET;
//         IF T_Item.FIND('-') THEN
//         REPEAT
//             T_BinContent.RESET;
//             T_BinContent.SETRANGE("Item No.", T_Item."No.");
//             IF T_BinContent.FIND('-') THEN
//             REPEAT
//                 T_BinContent.CALCFIELDS(Quantity);
//                 AddElement(T_XMLRoot,'item_location_quantity',T_XMLFirstNode);
//                 AddElement(T_XMLFirstNode,'item_uid',T_XMLNode);
//                 T_XMLNode.text :=  T_BinContent."Item No.";
//                 AddElement(T_XMLFirstNode,'location_uid',T_XMLNode);
//                 T_XMLNode.text := T_BinContent."Location Code" + '|' + T_BinContent."Bin Code";
//                 AddElement(T_XMLFirstNode,'quantity',T_XMLNode);
//                 T_XMLNode.text := FORMATDECIMAL(T_BinContent.Quantity);
//             UNTIL T_BinContent.NEXT = 0;
//         UNTIL T_Item.NEXT = 0;

//         T_XMLDoc.save(T_OutStreamQueue);
//         T_XMLDoc.save(Temp_Path +'item_location_quantity.xml');

//         SendSuccess(T_OutMsg);
//         IF NOT ISCLEAR(T_OutMsg) THEN CLEAR(T_OutMsg);
//         IF NOT ISCLEAR(T_XMLDoc) THEN CLEAR(T_XMLDoc);

//     end;

//     procedure ExportDebtor_Unpaid_Bill_Aging(CustLedgerEntry: Record "21";ReportDate: Date;var Results: array [17] of Text[50])
//     var
//         CustLedgerEntry2: Record "21";
//         Result: array [17] of Decimal;
//         LoopI: Integer;
//     begin
//         //CALCULATE THE MONTHS
//         CustLedgerEntry2.RESET;
//         CustLedgerEntry2.SETCURRENTKEY("Customer No.",Open,Positive,"Due Date","Currency Code");
//         CustLedgerEntry2.SETRANGE("Customer No.",  CustLedgerEntry."Customer No.");
//         CustLedgerEntry2.SETRANGE(Open,TRUE);
//         CustLedgerEntry2.SETRANGE("Document Type",CustLedgerEntry."Document Type"::Invoice);
//         IF CustLedgerEntry2.FIND('+') THEN
//         BEGIN
//           Result[1] := fGetMonths(CustLedgerEntry2."Posting Date", ReportDate);
//         END;

//         //CALCULATE THE OVERDUE
//         CustLedgerEntry2.RESET;
//         CustLedgerEntry2.SETCURRENTKEY("Customer No.",Open,Positive,"Due Date","Currency Code");
//         CustLedgerEntry2.SETRANGE("Customer No.",  CustLedgerEntry."Customer No.");
//         CustLedgerEntry2.SETRANGE(Open,TRUE);
//         CustLedgerEntry2.SETRANGE("Document Type",CustLedgerEntry."Document Type"::Invoice);

//         CustLedgerEntry2.SETRANGE("Due Date",0D,TODAY-1);
//         IF CustLedgerEntry2.FIND('-') THEN
//         REPEAT
//             CustLedgerEntry2.CALCFIELDS("Remaining Amount");
//             Result[2] += CustLedgerEntry2."Remaining Amount";
//         UNTIL CustLedgerEntry2.NEXT = 0;

//         //CALCULATE THE current_balance
//         CustLedgerEntry2.RESET;
//         CustLedgerEntry2.SETCURRENTKEY("Customer No.",Open,Positive,"Due Date","Currency Code");
//         CustLedgerEntry2.SETRANGE("Customer No.",  CustLedgerEntry."Customer No.");
//         CustLedgerEntry2.SETRANGE(Open,TRUE);
//         CustLedgerEntry2.SETRANGE("Document Type",CustLedgerEntry."Document Type"::Invoice);
//         CustLedgerEntry2.SETRANGE("Posting Date",CALCDATE('CD-12M',ReportDate),ReportDate);

//         IF CustLedgerEntry2.FIND('-') THEN
//         REPEAT
//             CustLedgerEntry2.CALCFIELDS("Remaining Amount");
//             Result[3] += CustLedgerEntry2."Remaining Amount";
//         UNTIL CustLedgerEntry2.NEXT = 0;

//         //CALCULATE month_to_date
//         Result[4] := 0;



//         //CALCULATE post_dated_check
//         Result[5] := 0;


//         //CALCULATE THE AGING
//             LoopI := 1;
//             REPEAT
//                 CustLedgerEntry2.RESET;
//                 CustLedgerEntry2.SETCURRENTKEY("Customer No.",Open,Positive,"Due Date","Currency Code");
//                 CustLedgerEntry2.SETRANGE("Customer No.",  CustLedgerEntry."Customer No.");
//                 CustLedgerEntry2.SETRANGE(Open,TRUE);
//                 CustLedgerEntry2.SETRANGE("Document Type",CustLedgerEntry."Document Type"::Invoice);
//                 CustLedgerEntry2.SETRANGE("Posting Date",
//                     CALCDATE('CD-'+FORMAT(LoopI)+'M',ReportDate),
//                     CALCDATE('CD-'+FORMAT(LoopI-1)+'M',ReportDate));
//                 IF CustLedgerEntry2.FIND('-') THEN
//                 REPEAT
//                     CustLedgerEntry2.CALCFIELDS("Remaining Amount");
//                     Result[5+LoopI] += CustLedgerEntry2."Remaining Amount";
//                 UNTIL CustLedgerEntry2.NEXT = 0;
//                 LoopI := LoopI + 1;
//             UNTIL LoopI > 12;


//         LoopI := 1;
//         REPEAT
//             Results[LoopI] := FORMATDECIMAL(Result[LoopI]);
//             LoopI += 1;
//         UNTIL LoopI > 17;
//     end;

//     procedure Get_debtor_unpaid_bills_aging(T_OutMsg: Automation )
//     var
//         T_OutStreamQueue: OutStream;
//         T_XMLDoc: Automation ;
//         T_XMLFirstNode: Automation ;
//         T_XMLRoot: Automation ;
//         T_XMLNode: Automation ;
//         Results: array [17] of Text[50];
//         CustLedgerEntry: Record "21";
//         CustLedgerEntry2: Record "21";
//         LastDateOfThisMonth: Date;
//     begin
//         IF ISCLEAR(T_XMLDoc) THEN
//             IF NOT CREATE(T_XMLDoc) THEN
//                    ERROR(Text003);


//         T_OutStreamQueue := T_OutMsg.GetStream();
//         T_XMLDoc.loadXML ('<?xml version="1.0" encoding="UTF-8"?><MEVOData/>');
//         T_XMLRoot := T_XMLDoc.documentElement;

//         LastDateOfThisMonth := CALCDATE('CM', TODAY);

//         CustLedgerEntry.RESET;
//         CustLedgerEntry.SETCURRENTKEY("Customer No.",Open,Positive,"Due Date","Currency Code");
//         CustLedgerEntry.SETRANGE(Open,TRUE);
//         CustLedgerEntry.SETRANGE("Document Type",CustLedgerEntry."Document Type"::Invoice);
//         IF CustLedgerEntry.FIND('-') THEN
//         REPEAT
//             CustLedgerEntry2.RESET;
//             CustLedgerEntry2.SETCURRENTKEY("Customer No.",Open,Positive,"Due Date","Currency Code");
//             CustLedgerEntry2.SETRANGE("Customer No.", CustLedgerEntry."Customer No.");
//             CustLedgerEntry2.SETRANGE(Open,TRUE);
//             CustLedgerEntry2.SETRANGE("Document Type", CustLedgerEntry."Document Type"::Invoice);
//             IF CustLedgerEntry2.FIND('-') THEN
//             BEGIN
//                 ExportDebtor_Unpaid_Bill_Aging(CustLedgerEntry2,LastDateOfThisMonth,Results);
//         AddElement(T_XMLRoot,'debtor_unpaid_bills_aging',T_XMLFirstNode);
//         AddElement(T_XMLFirstNode,'customer_uid',T_XMLNode);
//         T_XMLNode.text := CustLedgerEntry."Customer No.";
//         AddElement(T_XMLFirstNode,'is_open_item',T_XMLNode);
//         T_XMLNode.text := '1';
//         AddElement(T_XMLFirstNode,'months',T_XMLNode);
//         T_XMLNode.text := Results[1];
//         AddElement(T_XMLFirstNode,'overdue',T_XMLNode);
//         T_XMLNode.text := Results[2];
//         AddElement(T_XMLFirstNode,'current_balance',T_XMLNode);
//         T_XMLNode.text := Results[3];
//         AddElement(T_XMLFirstNode,'month_to_date',T_XMLNode);
//         T_XMLNode.text := Results[4];
//         AddElement(T_XMLFirstNode,'post_dated_check',T_XMLNode);
//         T_XMLNode.text := Results[5];


//         AddElement(T_XMLFirstNode,'age',T_XMLNode);
//         T_XMLNode.text := Results[6];
//         AddElement(T_XMLFirstNode,'age1',T_XMLNode);
//         T_XMLNode.text := Results[7];
//         AddElement(T_XMLFirstNode,'age2',T_XMLNode);
//         T_XMLNode.text := Results[8];
//         AddElement(T_XMLFirstNode,'age3',T_XMLNode);
//         T_XMLNode.text := Results[9];
//         AddElement(T_XMLFirstNode,'age4',T_XMLNode);
//         T_XMLNode.text := Results[10];
//         AddElement(T_XMLFirstNode,'age5',T_XMLNode);
//         T_XMLNode.text := Results[11];
//         AddElement(T_XMLFirstNode,'age6',T_XMLNode);
//         T_XMLNode.text := Results[12];
//         AddElement(T_XMLFirstNode,'age7',T_XMLNode);
//         T_XMLNode.text := Results[13];
//         AddElement(T_XMLFirstNode,'age8',T_XMLNode);
//         T_XMLNode.text := Results[14];
//         AddElement(T_XMLFirstNode,'age9',T_XMLNode);
//         T_XMLNode.text := Results[15];
//         AddElement(T_XMLFirstNode,'age10',T_XMLNode);
//         T_XMLNode.text := Results[16];
//         AddElement(T_XMLFirstNode,'age11',T_XMLNode);
//         T_XMLNode.text := Results[17];
//         AddElement(T_XMLFirstNode,'last_date',T_XMLNode);
//         T_XMLNode.text := FORMATDATE(TODAY);
//         AddElement(T_XMLFirstNode,'report_date',T_XMLNode);
//         T_XMLNode.text := FORMATDATE(TODAY);
//             END;
//             CustLedgerEntry.SETRANGE("Customer No.",CustLedgerEntry2."Customer No.");
//             IF CustLedgerEntry.FIND('+') THEN;
//             CustLedgerEntry.SETRANGE("Customer No.");
//         UNTIL CustLedgerEntry.NEXT = 0;


//         T_XMLDoc.save(T_OutStreamQueue);
//         T_XMLDoc.save(Temp_Path + 'debtor_unpaid_bills_aging.xml');

//         SendSuccess(T_OutMsg);
//         IF NOT ISCLEAR(T_OutMsg) THEN CLEAR(T_OutMsg);
//         IF NOT ISCLEAR(T_XMLDoc) THEN CLEAR(T_XMLDoc);
//     end;

//     procedure FORMATDATE(date: Date) ReturnValue: Text[30]
//     var
//         day: Integer;
//         month: Integer;
//         year: Integer;
//         dateToText: Text[2];
//         MonthToText: Text[2];
//         YearToText: Text[4];
//     begin
//         IF date = 0D THEN
//             EXIT('');
//         day   := DATE2DMY(date,1);
//         month := DATE2DMY(date,2);
//         year  := DATE2DMY(date,3);

//         IF year < 100 THEN
//             YearToText := FORMAT(year)+'2000'
//         ELSE
//             YearToText := FORMAT(year);

//         IF (year > 36) AND ( year < 100) THEN
//             YearToText := FORMAT(2036);


//         IF year > 2036 THEN
//             YearToText := FORMAT(2036);

//         IF month < 10 THEN
//             MonthToText := '0' + FORMAT(month)
//         ELSE
//             MonthToText := FORMAT(month);

//         IF day < 10 THEN
//             dateToText := '0' + FORMAT(day)
//         ELSE
//             dateToText := FORMAT(day);

//         EXIT( YearToText + '-' + MonthToText + '-' +dateToText +'T00:00:00' );
//     end;

//     procedure FORMATDECIMAL(number: Decimal) ReturnValue: Text[30]
//     begin
//         //number := ROUND(number,0.000001,'>');
//         ReturnValue := FORMAT(number);
//         ReturnValue := DELCHR(ReturnValue ,'=', ',');
//         IF ReturnValue = '' THEN
//             ReturnValue := '0';
//     end;

//     procedure fGetMonths(PostingDate: Date;LastDate: Date): Integer
//     var
//         LoopI: Integer;
//     begin
//         LoopI := 0;
//         REPEAT
//             PostingDate := CALCDATE('CD+1M',PostingDate);
//             LoopI += 1;
//         UNTIL PostingDate > LastDate;
//         IF LoopI > 12 THEN
//             LoopI := 12;
//         EXIT(LoopI)
//     end;

//     procedure fSaveAsFile(XmlPortName: Text[30]): Boolean
//     var
//         XmlFile: File;
//         xmlportnumber: Integer;
//         XmlOutStream: OutStream;
//     begin
//         xmlportnumber := getXmlPortNumber(XmlPortName);
//         IF XmlPortName = 'items' THEN XmlPortName := 'item';
//         IF EXISTS(Temp_Path +XmlPortName+'.xml') THEN
//             IF NOT ERASE(Temp_Path + XmlPortName+'.xml') THEN EXIT(FALSE);


//         IF NOT XmlFile.CREATE(Temp_Path + XmlPortName+'.xml') THEN EXIT(FALSE);
//         XmlFile.CREATEOUTSTREAM(XmlOutStream);
//         //IF NOT XMLPORT.EXPORT(xmlportnumber,XmlOutStream) THEN EXIT(FALSE);
//         XMLPORT.EXPORT(xmlportnumber,XmlOutStream);
//         XmlFile.CLOSE;

//         EXIT(TRUE);
//     end;

//     procedure Location(T_OutMsg: Automation )
//     var
//         T_OutStreamQueue: OutStream;
//         T_XMLDoc: Automation ;
//         T_XMLFirstNode: Automation ;
//         T_XMLRoot: Automation ;
//         T_XMLNode: Automation ;
//         LoopNumber: Integer;
//         bExitLoop: Boolean;
//         T_Location: Record "14";
//         T_Bin: Record "7354";
//     begin
//         IF ISCLEAR(T_XMLDoc) THEN
//             IF NOT CREATE(T_XMLDoc) THEN
//                    ERROR(Text003);


//         T_OutStreamQueue := T_OutMsg.GetStream();
//         T_XMLDoc.loadXML ('<?xml version="1.0" encoding="UTF-8"?><MEVOData/>');
//         T_XMLRoot := T_XMLDoc.documentElement;


//         T_Location.RESET;
//         IF T_Location.FIND('-') THEN
//         REPEAT
//             T_Bin.RESET;
//             T_Bin.SETRANGE("Location Code", T_Location.Code);
//             IF T_Bin.FIND('-') THEN
//             REPEAT
//                 //T_Bin.CALCFIELDS(Quantity);
//                 AddElement(T_XMLRoot,'location',T_XMLFirstNode);
//                 AddElement(T_XMLFirstNode,'location_uid',T_XMLNode);
//                 T_XMLNode.text :=  T_Bin."Location Code" + '|' + T_Bin.Code;
//                 AddElement(T_XMLFirstNode,'name',T_XMLNode);
//                 T_XMLNode.text := T_Location.Name;
//                 AddElement(T_XMLFirstNode,'name2',T_XMLNode);
//                 T_XMLNode.text := T_Location."Name 2";
//             UNTIL T_Bin.NEXT = 0;
//         UNTIL T_Location.NEXT = 0;

//         T_XMLDoc.save(T_OutStreamQueue);
//         T_XMLDoc.save(Temp_Path +'location.xml');

//         SendSuccess(T_OutMsg);
//         IF NOT ISCLEAR(T_OutMsg) THEN CLEAR(T_OutMsg);
//         IF NOT ISCLEAR(T_XMLDoc) THEN CLEAR(T_XMLDoc);
//     end;
// }

