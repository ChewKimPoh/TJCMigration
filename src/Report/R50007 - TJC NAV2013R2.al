// report 50007 "Tax Invoice frm get shipment2"
// {
//     // Tax Invoice frm get shipment report - 50001
//     // Version No.         : TJCSG1.00
//     // Developer           : DP.AYD
//     // Init. DEV. Date     : 17/07/2014
//     // Date of last Change : 23/07/2014
//     // Description         : Based on DD#170 https://dptech.mydonedone.com/issuetracker/projects/4350/issues/170
//     // 
//     // 1. Upgrade
//     // 
//     // 2. 29/07/2014 DP.JL DD#170
//     //   - Alignment change.
//     // 
//     // 3. 6/8/2014 DP.AYD
//     //   - Fix item tracking with lot no > 1
//     // 
//     // 4. 19/8/2014 DP.AYD
//     //   - DD#225
//     //   - Item Tracking already exists
//     DefaultLayout = RDLC;
//     RDLCLayout = './Tax Invoice frm get shipment2.rdlc';

//     Caption = 'Tax Invoice frm get shipment';
//     PreviewMode = PrintLayout;

//     dataset
//     {
//         dataitem(DataItem6640;Table36)
//         {
//             DataItemTableView = SORTING(Document Type,No.)
//                                 WHERE(Document Type=CONST(Invoice));
//             RequestFilterFields = "No.","Sell-to Customer No.","No. Printed";
//             RequestFilterHeading = 'Sales Order';
//             column(Sales_Header_Document_Type;"Document Type")
//             {
//             }
//             column(Sales_Header_No_;"No.")
//             {
//             }
//             dataitem(CopyLoop;Table2000000026)
//             {
//                 DataItemTableView = SORTING(Number);
//                 dataitem(PageLoop;Table2000000026)
//                 {
//                     DataItemTableView = SORTING(Number)
//                                         WHERE(Number=CONST(1));
//                     column(VATDiscountAmount;vInvoiceDiscountAmt)
//                     {
//                     }
//                     column(STRSUBSTNO_Text004_CopyText_;STRSUBSTNO(Text004,CopyText))
//                     {
//                     }
//                     column(STRSUBSTNO_Text005_FORMAT_CurrReport_PAGENO__;STRSUBSTNO(Text005,FORMAT(CurrReport.PAGENO)))
//                     {
//                     }
//                     column(CompanyInfo1_Picture;CompanyInfo1.Picture)
//                     {
//                     }
//                     column(Sales_Header___No__;"Sales Header"."No.")
//                     {
//                     }
//                     column(Sales_Header___Posting_Date_;"Sales Header"."Posting Date")
//                     {
//                     }
//                     column(Sales_Header___External_Document_No__;"Sales Header"."External Document No.")
//                     {
//                     }
//                     column(Sales_Header___Payment_Terms_Code_;"Sales Header"."Payment Terms Code")
//                     {
//                     }
//                     column(Sales_Header___Bill_to_Customer_No____________Sales_Header___Salesperson_Code_;"Sales Header"."Bill-to Customer No." + '/' + "Sales Header"."Salesperson Code")
//                     {
//                     }
//                     column(CustAddr_1_;CustAddr[1])
//                     {
//                     }
//                     column(CustAddr_2_;CustAddr[2])
//                     {
//                     }
//                     column(CustAddr_3_;CustAddr[3])
//                     {
//                     }
//                     column(CustAddr_4_;CustAddr[4])
//                     {
//                     }
//                     column(CustAddr_5_;CustAddr[5])
//                     {
//                     }
//                     column(Sales_Header___Ship_to_Address_;"Sales Header"."Ship-to Address")
//                     {
//                     }
//                     column(Sales_Header___Ship_to_Address_2_;"Sales Header"."Ship-to Address 2")
//                     {
//                     }
//                     column(TotalInclVATText;TotalInclVATText)
//                     {
//                     }
//                     column(TotalAmountExclVAT;FORMAT(TotalAmountExclVAT,0,'<Precision,2:2><Standard Format,0>'))
//                     {
//                     }
//                     column(TotalAmountInclVAT;FORMAT(TotalAmountInclVAT,0,'<Precision,2:2><Standard Format,0>'))
//                     {
//                         AutoFormatExpression = "Sales Header"."Currency Code";
//                         AutoFormatType = 1;
//                     }
//                     column(VATAmountLine_VATAmountText;VATAmountLine.VATAmountText())
//                     {
//                     }
//                     column(VATAmount;FORMAT(VATAmount,0,'<Precision,2:2><Standard Format,0>'))
//                     {
//                         AutoFormatExpression = "Sales Header"."Currency Code";
//                         AutoFormatType = 1;
//                     }
//                     column(TotalExclVATText;TotalExclVATText)
//                     {
//                     }
//                     column(VATBaseAmount;VATBaseAmount)
//                     {
//                         AutoFormatExpression = "Sales Header"."Currency Code";
//                         AutoFormatType = 1;
//                     }
//                     column(Ship_toCaption;Ship_toCaptionLbl)
//                     {
//                     }
//                     column(PageLoop_Number;Number)
//                     {
//                     }
//                     dataitem(DimensionLoop1;Table2000000026)
//                     {
//                         DataItemLinkReference = "Sales Header";
//                         DataItemTableView = SORTING(Number)
//                                             WHERE(Number=FILTER(1..));
//                         column(DimText;DimText)
//                         {
//                         }
//                         column(DimText_Control80;DimText)
//                         {
//                         }
//                         column(Header_DimensionsCaption;Header_DimensionsCaptionLbl)
//                         {
//                         }
//                         column(DimensionLoop1_Number;Number)
//                         {
//                         }

//                         trigger OnAfterGetRecord()
//                         begin
//                             IF Number = 1 THEN BEGIN
//                               //IF NOT DocDim1.FIND('-') THEN
//                               IF NOT DimSetEntry1.FINDSET THEN // {TJCSG1.00}
//                                 CurrReport.BREAK;
//                             END ELSE
//                               IF NOT Continue THEN
//                                 CurrReport.BREAK;

//                             CLEAR(DimText);
//                             Continue := FALSE;
//                             REPEAT
//                               OldDimText := DimText;
//                               IF DimText = '' THEN
//                                 DimText := STRSUBSTNO(
//                                   // {TJCSG1.00} '%1 %2',DocDim1."Dimension Code",DocDim1."Dimension Value Code")
//                                   '%1 - %2',DimSetEntry1."Dimension Code",DimSetEntry1."Dimension Value Code") // {TJCSG1.00}
//                               ELSE
//                                 DimText :=
//                                   STRSUBSTNO(
//                                     '%1, %2 %3',DimText,
//                                     // {TJCSG1.00}DocDim1."Dimension Code",DocDim1."Dimension Value Code");
//                                     DimSetEntry1."Dimension Code",DimSetEntry1."Dimension Value Code");// {TJCSG1.00}
//                               IF STRLEN(DimText) > MAXSTRLEN(OldDimText) THEN BEGIN
//                                 DimText := OldDimText;
//                                 Continue := TRUE;
//                                 EXIT;
//                               END;
//                             UNTIL DimSetEntry1.NEXT = 0;// {TJCSG1.00} (DocDim1.NEXT = 0);
//                         end;

//                         trigger OnPreDataItem()
//                         begin
//                             IF NOT ShowInternalInfo THEN
//                               CurrReport.BREAK;
//                         end;
//                     }
//                     dataitem(DataItem2844;Table37)
//                     {
//                         DataItemLink = Document Type=FIELD(Document Type),
//                                        Document No.=FIELD(No.);
//                         DataItemLinkReference = "Sales Header";
//                         DataItemTableView = SORTING(Document Type,Document No.,Line No.)
//                                             ORDER(Ascending);

//                         trigger OnPreDataItem()
//                         begin
//                             CurrReport.BREAK;
//                         end;
//                     }
//                     dataitem(RoundLoop;Table2000000026)
//                     {
//                         DataItemTableView = SORTING(Number);
//                         column(SalesLine__Line_Amount_;SalesLine."Line Amount")
//                         {
//                             AutoFormatExpression = "Sales Header"."Currency Code";
//                             AutoFormatType = 1;
//                         }
//                         column(Sales_Line__Description;"Sales Line".Description)
//                         {
//                         }
//                         column(Sales_Line___No___;"Sales Line"."No." )
//                         {
//                         }
//                         column(SerialNo2;SerialNo2)
//                         {
//                         }
//                         column(Sales_Line__Quantity;"Sales Line".Quantity)
//                         {
//                         }
//                         column(SalesLine__Unit_of_Measure_Code_;SalesLine."Unit of Measure Code")
//                         {
//                         }
//                         column(Sales_Line___Unit_Price_;"Sales Line"."Unit Price")
//                         {
//                             AutoFormatExpression = "Sales Header"."Currency Code";
//                             AutoFormatType = 2;
//                         }
//                         column(Sales_Line___Line_Amount_;"Sales Line"."Line Amount")
//                         {
//                             AutoFormatExpression = "Sales Header"."Currency Code";
//                             AutoFormatType = 1;
//                         }
//                         column(SalesLine_Description_______SalesLine__Description_2_;SalesLine.Description+' ' + SalesLine."Description 2")
//                         {
//                         }
//                         column(ItemTracking__Lot_No__;ItemTracking__Lot_No__)
//                         {
//                         }
//                         column(SalesLine__Line_Discount___;SalesLine."Line Discount %")
//                         {
//                             DecimalPlaces = 2:2;
//                         }
//                         column(Sales_Line___Return_Reason_Code_;"Sales Line"."Return Reason Code")
//                         {
//                         }
//                         column(rItem__Shelf_No__;rItem."Shelf No.")
//                         {
//                         }
//                         column(ItemEng;ItemEng)
//                         {
//                         }
//                         column(SalesLine_Description_______SalesLine__Description_2__Control1000000020;SalesLine.Description+' ' + SalesLine."Description 2")
//                         {
//                         }
//                         column(SalesLine__Line_Amount__Control84;SalesLine."Line Amount")
//                         {
//                             AutoFormatExpression = "Sales Header"."Currency Code";
//                             AutoFormatType = 1;
//                         }
//                         column(SalesLine__Inv__Discount_Amount_;-SalesLine."Inv. Discount Amount")
//                         {
//                             AutoFormatExpression = "Sales Header"."Currency Code";
//                             AutoFormatType = 1;
//                         }
//                         column(SalesLine__Line_Amount__Control70;SalesLine."Line Amount")
//                         {
//                             AutoFormatExpression = "Sales Header"."Currency Code";
//                             AutoFormatType = 1;
//                         }
//                         column(ContinuedCaption;ContinuedCaptionLbl)
//                         {
//                         }
//                         column(ContinuedCaption_Control83;ContinuedCaption_Control83Lbl)
//                         {
//                         }
//                         column(DISCOUNTCaption;DISCOUNTCaptionLbl)
//                         {
//                         }
//                         column(SUB_TOTALCaption;SUB_TOTALCaptionLbl)
//                         {
//                         }
//                         column(RoundLoop_Number;Number)
//                         {
//                         }
//                         column(DPVATAmount;DPVATAmount)
//                         {
//                         }
//                         column(DPSalesLineSellto;DPSalesLineSellto)
//                         {
//                         }
//                         column(TempItemTrack__Lot_No__;TempItemTrack__Lot_No__)
//                         {
//                         }
//                         dataitem(ItemTrackLines;Table2000000026)
//                         {
//                             DataItemTableView = SORTING(Number);
//                             column(ItemTrackLines_Number;Number)
//                             {
//                             }

//                             trigger OnAfterGetRecord()
//                             begin
//                                 IF Number = 1 THEN BEGIN
//                                   IF NOT TempItemTrack.FIND('-') THEN
//                                     CurrReport.BREAK;

//                                 END  ELSE

//                                 BEGIN
//                                  IF TempItemTrack.NEXT = 0 THEN
//                                    CurrReport.BREAK;

//                                 END;
//                             end;

//                             trigger OnPreDataItem()
//                             begin
//                                 CurrReport.SKIP; //TJCSG1.00 #3
//                                 TempItemTrack.RESET;
//                                 SETRANGE(Number,1,TempItemTrack.COUNT);
//                             end;
//                         }
//                         dataitem(DimensionLoop2;Table2000000026)
//                         {
//                             DataItemTableView = SORTING(Number)
//                                                 WHERE(Number=FILTER(1..));
//                             column(DimText_Control82;DimText)
//                             {
//                             }
//                             column(Line_DimensionsCaption;Line_DimensionsCaptionLbl)
//                             {
//                             }
//                             column(DimensionLoop2_Number;Number)
//                             {
//                             }

//                             trigger OnAfterGetRecord()
//                             begin
//                                 IF Number = 1 THEN BEGIN
//                                   // {TJCSG1.00} IF NOT DocDim2.FIND('-') THEN
//                                   IF NOT DimSetEntry2.FINDSET THEN // {TJCSG1.00}
//                                     CurrReport.BREAK;
//                                 END ELSE
//                                   IF NOT Continue THEN
//                                     CurrReport.BREAK;

//                                 CLEAR(DimText);
//                                 Continue := FALSE;
//                                 REPEAT
//                                   OldDimText := DimText;
//                                   IF DimText = '' THEN
//                                     DimText := STRSUBSTNO(
//                                       // {TJCSG1.00} '%1 %2',DocDim2."Dimension Code",DocDim2."Dimension Value Code")
//                                       '%1 - %2',DimSetEntry2."Dimension Code",DimSetEntry2."Dimension Value Code") // {TJCSG1.00}
//                                   ELSE
//                                     DimText :=
//                                       STRSUBSTNO(
//                                         '%1, %2 %3',DimText,
//                                         // {TJCSG1.00} DocDim2."Dimension Code",DocDim2."Dimension Value Code");
//                                         DimSetEntry2."Dimension Code",DimSetEntry2."Dimension Value Code"); // {TJCSG1.00}
//                                   IF STRLEN(DimText) > MAXSTRLEN(OldDimText) THEN BEGIN
//                                     DimText := OldDimText;
//                                     Continue := TRUE;
//                                     EXIT;
//                                   END;
//                                 UNTIL DimSetEntry2.NEXT = 0;// {TJCSG1.00} (DocDim2.NEXT = 0);
//                             end;

//                             trigger OnPreDataItem()
//                             begin
//                                 IF NOT ShowInternalInfo THEN
//                                   CurrReport.BREAK;

//                                 // {TJCSG1.00} DocDim2.SETRANGE("Table ID",DATABASE::"Sales Line");
//                                 // {TJCSG1.00} DocDim2.SETRANGE("Document Type","Sales Line"."Document Type");
//                                 // {TJCSG1.00} DocDim2.SETRANGE("Document No.","Sales Line"."Document No.");
//                                 // {TJCSG1.00} DocDim2.SETRANGE("Line No.","Sales Line"."Line No.");
//                                 DimSetEntry2.SETRANGE("Dimension Set ID","Sales Line"."Dimension Set ID"); // {TJCSG1.00}
//                             end;
//                         }

//                         trigger OnAfterGetRecord()
//                         var
//                             EntryNo: Integer;
//                         begin
//                             IF Number = 1 THEN
//                               SalesLine.FIND('-')
//                             ELSE
//                               SalesLine.NEXT;
//                             "Sales Line" := SalesLine;

//                             IF NOT "Sales Header"."Prices Including VAT" AND
//                                (SalesLine."VAT Calculation Type" = SalesLine."VAT Calculation Type"::"Full VAT")
//                             THEN
//                               SalesLine."Line Amount" := 0;

//                             IF (SalesLine.Type = SalesLine.Type::"G/L Account") AND (NOT ShowInternalInfo) THEN
//                               "Sales Line"."No." := '';


//                             //{TJCSG1.00} start
//                             DPVATAmount := SalesLine."Amount Including VAT"-SalesLine.Amount;//{TJCSG1.00}
//                             DPSalesLineSellto := SalesLine."Sell-to Customer No.";

//                             //code from section
//                             CLEAR(rItem);
//                             IF (SalesLine.Type = SalesLine.Type::Item) THEN
//                             BEGIN
//                                IF rItem.GET(SalesLine."No.") THEN;
//                             END;

//                             ItemEng:=GetEnglishName(SalesLine."No.");
//                             //{TJCSG1.00} end

//                             TempItemTrack__Lot_No__:=''; //TJCSG1.00 #3
//                             ItemTracking__Lot_No__:='';

//                             //Get Item Tracking Lines
//                             TempItemTrack.DELETEALL;
//                             CLEAR(ItemTracking);
//                             EntryNo := 1;
//                             ItemTracking.SETRANGE(ItemTracking."Source ID",SalesLine."Document No.");
//                             ItemTracking.SETRANGE(ItemTracking."Item No.",SalesLine."No." );
//                             ItemTracking.SETRANGE(ItemTracking."Source Ref. No.",SalesLine."Line No."); //SWJ
//                             IF ItemTracking.FIND('-') THEN BEGIN
//                               ItemTracking__Lot_No__:=ItemTracking."Lot No."; //TJCSG1.00 #3
//                               TotalLot := ItemTracking.COUNT;
//                               IF TotalLot > 1 THEN
//                               REPEAT
//                                 //SWJ
//                                 TempItemTrack.SETCURRENTKEY("Item No.","Variant Code","Location Code","Reservation Status",
//                                                             "Shipment Date","Expected Receipt Date","Serial No.","Lot No.");
//                                 TempItemTrack.SETRANGE("Item No.",SalesLine."No.");
//                                 TempItemTrack.SETRANGE("Lot No.",ItemTracking."Lot No.");
//                                 IF NOT TempItemTrack.FIND('-') THEN
//                                 BEGIN
//                                 //>>SWJ
//                                   TempItemTrack.INIT;
//                                   TempItemTrack."Entry No." := EntryNo;
//                                   TempItemTrack."Item No."  := SalesLine."No.";
//                                   TempItemTrack."Lot No."   := ItemTracking."Lot No.";
//                                   //{TJCSG1.00 #4 Start}
//                                   //TempItemTrack.INSERT;
//                                   InsertTempTracking(EntryNo);
//                                   /*
//                                   IF NOT TempItemTrack.INSERT THEN BEGIN
//                                     EntryNo += 1;
//                                     TempItemTrack."Entry No." := EntryNo;
//                                     TempItemTrack.INSERT;
//                                   END;
//                                   */
//                                   //{TJCSG1.00 #4 End}
//                                   EntryNo += 1;
//                                 END;
//                                 TempItemTrack__Lot_No__+=ItemTracking."Lot No."+DPEnter; //TJCSG1.00 #3
//                               UNTIL ItemTracking.NEXT = 0;

//                               TempItemTrack.RESET;
//                               TempItemTrack.SETFILTER("Entry No.",'%1',1);
//                               IF TempItemTrack.FIND('-') THEN TempItemTrack.DELETE;
//                             END;
//                             IF DPTrim(TempItemTrack__Lot_No__)<>'' THEN //TJCSG1.00 #3
//                               ItemTracking__Lot_No__:=TempItemTrack__Lot_No__; //TJCSG1.00 #3

//                         end;

//                         trigger OnPostDataItem()
//                         begin
//                             SalesLine.DELETEALL;
//                         end;

//                         trigger OnPreDataItem()
//                         begin
//                             MoreLines := SalesLine.FIND('+');
//                             WHILE MoreLines AND (SalesLine.Description = '') AND  (SalesLine."Description 2"= '') AND
//                                   (SalesLine."No." = '') AND (SalesLine.Quantity = 0) AND
//                                   (SalesLine.Amount = 0)
//                             DO
//                               MoreLines := SalesLine.NEXT(-1) <> 0;
//                             IF NOT MoreLines THEN
//                               CurrReport.BREAK;
//                             SalesLine.SETRANGE("Line No.",0,SalesLine."Line No.");
//                             SETRANGE(Number,1,SalesLine.COUNT);
//                             CurrReport.CREATETOTALS(SalesLine."Line Amount",SalesLine."Inv. Discount Amount");
//                         end;
//                     }
//                     dataitem(VATCounter;Table2000000026)
//                     {
//                         DataItemTableView = SORTING(Number);

//                         trigger OnAfterGetRecord()
//                         begin
//                             VATAmountLine.GetLine(Number);
//                         end;

//                         trigger OnPreDataItem()
//                         begin
//                             IF VATAmount = 0 THEN
//                               CurrReport.BREAK;
//                             SETRANGE(Number,1,VATAmountLine.COUNT);
//                             CurrReport.CREATETOTALS(
//                               VATAmountLine."Line Amount",VATAmountLine."Inv. Disc. Base Amount",
//                               VATAmountLine."Invoice Discount Amount",VATAmountLine."VAT Base",VATAmountLine."VAT Amount");
//                         end;
//                     }
//                     dataitem(VATCounterLCY;Table2000000026)
//                     {
//                         DataItemTableView = SORTING(Number);

//                         trigger OnAfterGetRecord()
//                         begin
//                             VATAmountLine.GetLine(Number);

//                             VALVATBaseLCY := ROUND(CurrExchRate.ExchangeAmtFCYToLCY(
//                                                "Sales Header"."Posting Date","Sales Header"."Currency Code",
//                                                VATAmountLine."VAT Base","Sales Header"."Currency Factor"));
//                             VALVATAmountLCY := ROUND(CurrExchRate.ExchangeAmtFCYToLCY(
//                                                  "Sales Header"."Posting Date","Sales Header"."Currency Code",
//                                                  VATAmountLine."VAT Amount","Sales Header"."Currency Factor"));
//                         end;

//                         trigger OnPreDataItem()
//                         begin
//                             IF (NOT GLSetup."Print VAT specification in LCY") OR
//                                ("Sales Header"."Currency Code"  = '') OR
//                                (VATAmountLine.GetTotalVATAmount = 0) THEN
//                               CurrReport.BREAK;

//                             SETRANGE(Number,1,VATAmountLine.COUNT);
//                             CurrReport.CREATETOTALS(VALVATBaseLCY,VALVATAmountLCY);

//                             IF GLSetup."LCY Code" = '' THEN
//                               VALSpecLCYHeader := Text007 + Text008
//                             ELSE
//                               VALSpecLCYHeader := Text007 + FORMAT(GLSetup."LCY Code");

//                             CurrExchRate.FindCurrency("Sales Header"."Posting Date","Sales Header"."Currency Code",1);
//                             VALExchRate := STRSUBSTNO(Text009,CurrExchRate."Relational Exch. Rate Amount",CurrExchRate."Exchange Rate Amount");
//                         end;
//                     }
//                     dataitem(Total;Table2000000026)
//                     {
//                         DataItemTableView = SORTING(Number)
//                                             WHERE(Number=CONST(1));
//                     }
//                     dataitem(Total2;Table2000000026)
//                     {
//                         DataItemTableView = SORTING(Number)
//                                             WHERE(Number=CONST(1));

//                         trigger OnPreDataItem()
//                         begin
//                             IF NOT ShowShippingAddr THEN
//                               CurrReport.BREAK;
//                         end;
//                     }
//                 }

//                 trigger OnAfterGetRecord()
//                 var
//                     SalesPost: Codeunit "80";
//                 begin
//                     IF Number > 1 THEN
//                       CopyText := Text003;
//                     CurrReport.PAGENO := 1;
//                 end;

//                 trigger OnPostDataItem()
//                 begin
//                     /*IF NOT CurrReport.PREVIEW THEN
//                       SalesCountPrinted.RUN("Sales Header");
//                     */

//                 end;

//                 trigger OnPreDataItem()
//                 begin
//                     NoOfLoops := ABS(NoOfCopies) + 1;
//                     CopyText := '';
//                     SETRANGE(Number,1,NoOfLoops);
//                 end;
//             }

//             trigger OnAfterGetRecord()
//             var
//                 SalesPost: Codeunit "80";
//             begin
//                 CLEAR(SerialNo);

//                 CurrReport.LANGUAGE := Language.GetLanguageID("Language Code");

//                 IF RespCenter.GET("Responsibility Center") THEN BEGIN
//                   FormatAddr.RespCenter(CompanyAddr,RespCenter);
//                   CompanyInfo."Phone No." := RespCenter."Phone No.";
//                   CompanyInfo."Fax No." := RespCenter."Fax No.";
//                 END ELSE
//                   FormatAddr.Company(CompanyAddr,CompanyInfo);

//                 // {TJCSG1.00} DocDim1.SETRANGE("Table ID",DATABASE::"Sales Header");
//                 // {TJCSG1.00} DocDim1.SETRANGE("Document Type","Sales Header"."Document Type");
//                 // {TJCSG1.00} DocDim1.SETRANGE("Document No.","Sales Header"."No.");
//                 DimSetEntry1.SETRANGE("Dimension Set ID","Dimension Set ID"); // {TJCSG1.00}

//                 IF "Salesperson Code" = '' THEN BEGIN
//                   CLEAR(SalesPurchPerson);
//                   SalesPersonText := '';
//                 END ELSE BEGIN
//                   SalesPurchPerson.GET("Salesperson Code");
//                   SalesPersonText := Text000;

//                 END;
//                 IF "Your Reference" = '' THEN
//                   ReferenceText := ''
//                 ELSE
//                   ReferenceText := FIELDCAPTION("Your Reference");
//                 IF "VAT Registration No." = '' THEN
//                   VATNoText := ''
//                 ELSE
//                   VATNoText := FIELDCAPTION("VAT Registration No.");
//                 IF "Currency Code" = '' THEN BEGIN
//                   GLSetup.TESTFIELD("LCY Code");
//                   TotalText := STRSUBSTNO(Text001,GLSetup."LCY Code");
//                   TotalInclVATText := STRSUBSTNO(Text002,GLSetup."LCY Code");
//                   TotalExclVATText := STRSUBSTNO(Text006,GLSetup."LCY Code");
//                 END ELSE BEGIN
//                   TotalText := STRSUBSTNO(Text001,"Currency Code");
//                   TotalInclVATText := STRSUBSTNO(Text002,"Currency Code");
//                   TotalExclVATText := STRSUBSTNO(Text006,"Currency Code");
//                 END;
//                 FormatAddr.SalesHeaderBillTo(CustAddr,"Sales Header");

//                 IF "Payment Terms Code" = '' THEN
//                   PaymentTerms.INIT
//                 ELSE
//                   PaymentTerms.GET("Payment Terms Code");
//                 IF "Shipment Method Code" = '' THEN
//                   ShipmentMethod.INIT
//                 ELSE
//                   ShipmentMethod.GET("Shipment Method Code");

//                 FormatAddr.SalesHeaderShipTo(ShipToAddr,"Sales Header");
//                 ShowShippingAddr := "Sell-to Customer No." <> "Bill-to Customer No.";
//                 FOR i := 1 TO ARRAYLEN(ShipToAddr) DO
//                   IF ShipToAddr[i] <> CustAddr[i] THEN
//                     ShowShippingAddr := TRUE;
//                 /*
//                 IF NOT CurrReport.PREVIEW THEN BEGIN
//                   IF ArchiveDocument THEN
//                     ArchiveManagement.StoreSalesDocument("Sales Header",LogInteraction);

//                   IF LogInteraction THEN BEGIN
//                     CALCFIELDS("No. of Archived Versions");
//                     IF "Bill-to Contact No." <> '' THEN
//                       SegManagement.LogDocument(
//                         3,"No.","Doc. No. Occurrence",
//                         "No. of Archived Versions",DATABASE::Contact,"Bill-to Contact No."
//                         ,"Salesperson Code","Campaign No.","Posting Description","Opportunity No.")
//                     ELSE
//                       SegManagement.LogDocument(
//                         3,"No.","Doc. No. Occurrence",
//                         "No. of Archived Versions",DATABASE::Customer,"Bill-to Customer No.",
//                         "Salesperson Code","Campaign No.","Posting Description","Opportunity No.");
//                   END;
//                 END;
//                 */
//                 CLEAR(vInvoiceDiscountAmt);
//                 CLEAR(TotalAmountInclVAT);
//                 CLEAR(TotalAmountExclVAT);
//                 CLEAR(VATAmount);
//                 CLEAR(SalesLine);
//                 CLEAR(SalesPost);
//                 VATAmountLine.DELETEALL;
//                 SalesLine.DELETEALL;
//                 SalesPost.GetSalesLines("Sales Header",SalesLine,0);
//                 SalesLine.CalcVATAmountLines(0,"Sales Header",SalesLine,VATAmountLine);
//                 SalesLine.UpdateVATOnLines(0,"Sales Header",SalesLine,VATAmountLine);
//                 SalesLine.RESET;
//                 SalesLine.SETRANGE("Document Type","Sales Header"."Document Type");
//                 SalesLine.SETRANGE("Document No.","Sales Header"."No.");
//                 IF SalesLine.FINDSET THEN
//                 REPEAT
//                   TotalAmountExclVAT += SalesLine."Line Amount";
//                   vInvoiceDiscountAmt += SalesLine."Inv. Discount Amount" ;
//                 UNTIL SalesLine.NEXT =0;
//                 VATAmount := VATAmountLine.GetTotalVATAmount;
//                 VATBaseAmount := VATAmountLine.GetTotalVATBase;
//                 VATDiscountAmount :=
//                   VATAmountLine.GetTotalVATDiscount("Sales Header"."Currency Code","Sales Header"."Prices Including VAT");
//                 TotalAmountInclVAT := VATAmountLine.GetTotalAmountInclVAT;

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
//                     field(NoOfCopies;NoOfCopies)
//                     {
//                         Caption = 'No. of Copies';
//                     }
//                     field(ShowInternalInfo;ShowInternalInfo)
//                     {
//                         Caption = 'Show Internal Information';
//                     }
//                     field(ArchiveDocument;ArchiveDocument)
//                     {
//                         Caption = 'Archive Document';
//                     }
//                     field(LogInteraction;LogInteraction)
//                     {
//                         Caption = 'Log Interaction';
//                         Enabled = false;
//                     }
//                 }
//             }
//         }

//         actions
//         {
//         }

//         trigger OnOpenPage()
//         begin

//             ArchiveDocument := ArchiveManagement.SalesDocArchiveGranule;
//             //LogInteraction := SegManagement.FindInteractTmplCode(3) <> '';
//             LogInteraction:=FALSE;

//             //RequestOptionsPage.ArchiveDocument.ENABLED(ArchiveDocument);
//             //RequestOptionsPage.LogInteraction.ENABLED(LogInteraction);
//         end;
//     }

//     labels
//     {
//     }

//     trigger OnInitReport()
//     begin
//         GLSetup.GET;
//         CompanyInfo.GET;
//         SalesSetup.GET;

//         /*
//         // {TJCSG1.00}
//         CASE SalesSetup."Logo Position on Documents" OF
//           SalesSetup."Logo Position on Documents"::"No Logo":;
//           SalesSetup."Logo Position on Documents"::Left:
//             BEGIN
//               CompanyInfo.CALCFIELDS(Picture);
//             END;
//           SalesSetup."Logo Position on Documents"::Center:
//             BEGIN
//               CompanyInfo1.GET;
//               CompanyInfo1.CALCFIELDS(Picture);
//             END;
//           SalesSetup."Logo Position on Documents"::Right:
//             BEGIN
//               CompanyInfo2.GET;
//               CompanyInfo2.CALCFIELDS(Picture);
//             END;
//         END;
//         */

//         CompanyInfo1.GET;
//               //CompanyInfo1.CALCFIELDS(Picture);

//     end;

//     var
//         Text000: Label 'Salesperson';
//         Text001: Label 'TOTAL %1';
//         Text002: Label 'TOTAL %1 ';
//         Text003: Label 'COPY';
//         Text004: Label 'TAX INVOICE %1';
//         Text005: Label 'Page %1';
//         Text006: Label 'SUB-TOTAL %1 ';
//         GLSetup: Record "98";
//         ShipmentMethod: Record "10";
//         PaymentTerms: Record "3";
//         SalesPurchPerson: Record "13";
//         CompanyInfo: Record "79";
//         CompanyInfo1: Record "79";
//         CompanyInfo2: Record "79";
//         SalesSetup: Record "311";
//         VATAmountLine: Record "290" temporary;
//         SalesLine: Record "37" temporary;
//         RespCenter: Record "5714";
//         Language: Record "8";
//         CurrExchRate: Record "330";
//         SalesCountPrinted: Codeunit "313";
//         FormatAddr: Codeunit "365";
//         SegManagement: Codeunit "5051";
//         ArchiveManagement: Codeunit "5063";
//         CustAddr: array [8] of Text[50];
//         ShipToAddr: array [8] of Text[50];
//         CompanyAddr: array [8] of Text[50];
//         SalesPersonText: Text[30];
//         VATNoText: Text[30];
//         ReferenceText: Text[30];
//         TotalText: Text[50];
//         TotalExclVATText: Text[50];
//         TotalInclVATText: Text[50];
//         MoreLines: Boolean;
//         NoOfCopies: Integer;
//         NoOfLoops: Integer;
//         CopyText: Text[30];
//         ShowShippingAddr: Boolean;
//         i: Integer;
//         DimText: Text[120];
//         OldDimText: Text[75];
//         ShowInternalInfo: Boolean;
//         Continue: Boolean;
//         ArchiveDocument: Boolean;
//         LogInteraction: Boolean;
//         VATAmount: Decimal;
//         VATBaseAmount: Decimal;
//         VATDiscountAmount: Decimal;
//         TotalAmountInclVAT: Decimal;
//         VALVATBaseLCY: Decimal;
//         VALVATAmountLCY: Decimal;
//         VALSpecLCYHeader: Text[80];
//         Text007: Label 'GST Amount Specification in ';
//         Text008: Label 'Local Currency';
//         Text009: Label 'Exchange rate: %1/%2';
//         VALExchRate: Text[50];
//         intPos: Integer;
//         SerialNo: Integer;
//         SerialNo2: Integer;
//         Vblank: Char;
//         ItemTracking: Record "337";
//         TempItemTrack: Record "337" temporary;
//         TotalLot: Integer;
//         ItemEng: Text[60];
//         rItem: Record "27";
//         Ship_toCaptionLbl: Label 'Ship-to';
//         Header_DimensionsCaptionLbl: Label 'Header Dimensions';
//         ContinuedCaptionLbl: Label 'Continued';
//         ContinuedCaption_Control83Lbl: Label 'Continued';
//         DISCOUNTCaptionLbl: Label 'DISCOUNT';
//         SUB_TOTALCaptionLbl: Label 'SUB-TOTAL';
//         Line_DimensionsCaptionLbl: Label 'Line Dimensions';
//         "/* DP VARS * /": Integer;
//         DimSetEntry1: Record "480";
//         DimSetEntry2: Record "480";
//         DPVATAmount: Decimal;
//         DPSalesLineSellto: Text;
//         TempItemTrack__Lot_No__: Text;
//         ItemTracking__Lot_No__: Text;
//         TotalAmountExclVAT: Decimal;
//         vInvoiceDiscountAmt: Decimal;

//     procedure GetEnglishName(ItemCode: Code[20]) EnglishName: Text[60]
//     var
//         ItemTransTable: Record "30";
//     begin

//         ItemTransTable.SETRANGE(ItemTransTable."Item No.",ItemCode);
//         IF ItemTransTable.FIND('-') THEN
//         BEGIN
//            IF ItemTransTable."Description 2"<>'' THEN
//               EnglishName:=ItemTransTable.Description+' '+ItemTransTable."Description 2"
//            ELSE
//                 EnglishName:=ItemTransTable.Description;
//         END;
//         EXIT(EnglishName);
//     end;

//     procedure "/*DP FUNC */"()
//     begin
//     end;

//     procedure DPEnter() EnterChar: Text[2]
//     begin
//         EnterChar[1]:=13;
//         EnterChar[2]:=10;
//     end;

//     procedure DPTrim(TextToTrim: Text) Result: Text
//     begin
//         Result:=DELCHR(TextToTrim,'<>',' ')
//     end;

//     procedure InsertTempTracking(var EntryNo: Integer): Boolean
//     begin
//         /*TJCSG1.00 #4*/
//         IF NOT TempItemTrack.INSERT THEN BEGIN
//           EntryNo += 1;
//           TempItemTrack."Entry No." := EntryNo;
//           IF TempItemTrack.INSERT THEN
//             EXIT(TRUE)
//           ELSE
//             InsertTempTracking(EntryNo);
//         END;

//     end;
// }

