// report 50004 "Sales Credit Memo B4 Post"
// {
//     // TJCSG1.00
//     // 1. 29/07/2014 DP.JL DD#189
//     //   - Field alignment adjustment
//     DefaultLayout = RDLC;
//     RDLCLayout = './Sales Credit Memo B4 Post.rdlc';

//     PreviewMode = PrintLayout;

//     dataset
//     {
//         dataitem(DataItem1000000000;Table36)
//         {
//             DataItemTableView = SORTING(Document Type,No.)
//                                 WHERE(Document Type=CONST(Credit Memo));
//             RequestFilterFields = "Document Type","No.";
//             column(No_SalesHeader;"Sales Header"."No.")
//             {
//             }
//             column(ExternalDocNo_SalesHeader;"Sales Header"."External Document No.")
//             {
//             }
//             column(SalesPersonCode_SalesHeader;"Sales Header"."Salesperson Code")
//             {
//             }
//             dataitem(CopyLoop;Table2000000026)
//             {
//                 DataItemTableView = SORTING(Number);
//                 dataitem(PageLoop;Table2000000026)
//                 {
//                     DataItemTableView = SORTING(Number)
//                                         WHERE(Number=CONST(1));
//                     column(CopyText;CopyText)
//                     {
//                     }
//                     column(BillToCustomerNo_SalesHeader;"Sales Header"."Bill-to Customer No.")
//                     {
//                     }
//                     column(CustAddr_1;CustAddr[1])
//                     {
//                     }
//                     column(CustAddr_2;CustAddr[2])
//                     {
//                     }
//                     column(CustAddr_3;CustAddr[3])
//                     {
//                     }
//                     column(CustAddr_4;CustAddr[4])
//                     {
//                     }
//                     column(CustAddr_5;CustAddr[5])
//                     {
//                     }
//                     column(ShiptoAddress_SalesHeader;"Sales Header"."Ship-to Address")
//                     {
//                     }
//                     column(ShipToAddress2_SalesHeader;"Sales Header"."Ship-to Address 2")
//                     {
//                     }
//                     column(SalesHeader_No;"Sales Header"."No.")
//                     {
//                     }
//                     column(PostingDate_SalesHeader;FORMAT("Sales Header"."Posting Date",0,'<Day,2>/<Month,2>/<Year4>'))
//                     {
//                     }
//                     column(PaymentTermCode_SalesHeader;"Sales Header"."Payment Terms Code")
//                     {
//                     }
//                     column(PageNo;PageNo)
//                     {
//                     }
//                     dataitem(DimensionLoop1;Table2000000026)
//                     {
//                         DataItemTableView = SORTING(Number)
//                                             WHERE(Number=FILTER(1..));
//                         column(DimText_DimensionLoop1;DimText)
//                         {
//                         }

//                         trigger OnAfterGetRecord()
//                         begin
//                             IF Number = 1 THEN BEGIN
//                               IF NOT DimSetEntry1.FIND('-') THEN
//                                 CurrReport.BREAK;
//                             END ELSE
//                               IF NOT Continue THEN
//                                 CurrReport.BREAK;

//                             CLEAR(DimText);
//                             Continue := FALSE;
//                             REPEAT
//                               OldDimText := DimText;
//                               IF DimText = '' THEN
//                                 DimText := STRSUBSTNO('%1 %2',DimSetEntry1."Dimension Code",DimSetEntry1."Dimension Value Code")
//                               ELSE
//                                 DimText :=
//                                   STRSUBSTNO(
//                                     '%1, %2 %3',DimText,
//                                     DimSetEntry1."Dimension Code",DimSetEntry1."Dimension Value Code");
//                               IF STRLEN(DimText) > MAXSTRLEN(OldDimText) THEN BEGIN
//                                 DimText := OldDimText;
//                                 Continue := TRUE;
//                                 EXIT;
//                               END;
//                             UNTIL DimSetEntry1.NEXT = 0;
//                         end;

//                         trigger OnPreDataItem()
//                         begin

//                             IF NOT ShowInternalInfo THEN
//                               CurrReport.BREAK;
//                         end;
//                     }
//                     dataitem(DataItem1000000005;Table37)
//                     {
//                         DataItemLink = Document Type=FIELD(Document Type),
//                                        Document No.=FIELD(No.);
//                         DataItemLinkReference = "Sales Header";
//                         DataItemTableView = SORTING(Document Type,Document No.,Line No.);

//                         trigger OnPreDataItem()
//                         begin
//                             CurrReport.BREAK;
//                         end;
//                     }
//                     dataitem(RoundLoop;Table2000000026)
//                     {
//                         DataItemTableView = SORTING(Number);
//                         column(SerialNo2;SerialNo2)
//                         {
//                         }
//                         column(SalesLine_DocumentNo;"Sales Line"."Document No.")
//                         {
//                         }
//                         column(SalesLine_LineNo;"Sales Line"."Line No.")
//                         {
//                         }
//                         column(SalesLine_Type;"Sales Line".Type)
//                         {
//                         }
//                         column(No_SalesLine;"Sales Line"."No.")
//                         {
//                         }
//                         column(Description_SalesLine;DELCHR("Sales Line".Description + ' '+ "Sales Line"."Description 2",'<>',' '))
//                         {
//                         }
//                         column(LotNo_ItemTracking;ItemTracking."Lot No.")
//                         {
//                         }
//                         column(ReturnReasonCode_SalesLine;"Sales Line"."Return Reason Code")
//                         {
//                         }
//                         column(Quantity_SalesLine;"Sales Line".Quantity)
//                         {
//                         }
//                         column(UOMCode_SalesLine;"Sales Line"."Unit of Measure Code")
//                         {
//                         }
//                         column(UnitPrice_SalesLine;"Sales Line"."Unit Price")
//                         {
//                         }
//                         column(LineDiscount_SalesLine;"Sales Line"."Line Discount %")
//                         {
//                         }
//                         column(LineAmount_SalesLine;"Sales Line"."Line Amount")
//                         {
//                         }
//                         column(InvDiscountAmount_SalesLine;"Sales Line"."Inv. Discount Amount")
//                         {
//                         }
//                         column(PriceIncludingVAT_SalesHeader;"Sales Header"."Prices Including VAT")
//                         {
//                         }
//                         column(NNCSalesLineLineAmt;NNCSalesLineLineAmt)
//                         {
//                         }
//                         column(NNCSalesLineInvDiscAmt;NNCSalesLineInvDiscAmt)
//                         {
//                         }
//                         column(NNCTotalLCY;NNCTotalLCY)
//                         {
//                         }
//                         column(NNCTotalExclVAT;NNCTotalExclVAT)
//                         {
//                         }
//                         column(NNCVATAmt;NNCVATAmt)
//                         {
//                         }
//                         column(NNCTotalInclVAT;NNCTotalInclVAT)
//                         {
//                         }
//                         column(NNCPmtDiscOnVAT;NNCPmtDiscOnVAT)
//                         {
//                         }
//                         column(NNCTotalInclVAT2;NNCTotalInclVAT2)
//                         {
//                         }
//                         column(NNCVATAmt2;NNCVATAmt2)
//                         {
//                         }
//                         column(NNCTotalExclVAT2;NNCTotalExclVAT2)
//                         {
//                         }
//                         column(VATBaseDisc_SalesHeader;"Sales Header"."VAT Base Discount %")
//                         {
//                         }
//                         column(SalesLineInvDiscAmt;SalesLine."Inv. Discount Amount")
//                         {
//                             AutoFormatExpression = "Sales Header"."Currency Code";
//                             AutoFormatType = 1;
//                         }
//                         column(TotalText;TotalText)
//                         {
//                         }
//                         column(SalsLinAmtExclLineDiscAmt;SalesLine."Line Amount" - SalesLine."Inv. Discount Amount")
//                         {
//                             AutoFormatExpression = "Sales Header"."Currency Code";
//                             AutoFormatType = 1;
//                         }
//                         column(TotalExclVATText;TotalExclVATText)
//                         {
//                         }
//                         column(VATAmtLineVATAmtText3;VATAmountLine.VATAmountText)
//                         {
//                         }
//                         column(TotalInclVATText;TotalInclVATText)
//                         {
//                         }
//                         column(VATAmount;VATAmount)
//                         {
//                             AutoFormatExpression = "Sales Header"."Currency Code";
//                             AutoFormatType = 1;
//                         }
//                         column(SalesLineAmtExclLineDisc;SalesLine."Line Amount" - SalesLine."Inv. Discount Amount" + VATAmount)
//                         {
//                             AutoFormatExpression = "Sales Header"."Currency Code";
//                             AutoFormatType = 1;
//                         }
//                         column(VATDiscountAmount;VATDiscountAmount)
//                         {
//                             AutoFormatExpression = "Sales Header"."Currency Code";
//                             AutoFormatType = 1;
//                         }
//                         column(VATBaseAmount;VATBaseAmount)
//                         {
//                             AutoFormatExpression = "Sales Header"."Currency Code";
//                             AutoFormatType = 1;
//                         }
//                         column(TotalAmountInclVAT;TotalAmountInclVAT)
//                         {
//                             AutoFormatExpression = "Sales Header"."Currency Code";
//                             AutoFormatType = 1;
//                         }
//                         column(ItemEng;ItemEng)
//                         {
//                         }
//                         dataitem(ItemTrackLines;Table2000000026)
//                         {
//                             DataItemTableView = SORTING(Number)
//                                                 WHERE(Number=FILTER(1..));
//                             column(LotNo_TempItemTrack;TempItemTrack."Lot No.")
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

//                                 TempItemTrack.RESET;
//                                 SETRANGE(Number,1,TempItemTrack.COUNT);
//                             end;
//                         }
//                         dataitem(DimensionLoop2;Table2000000026)
//                         {
//                             DataItemTableView = SORTING(Number)
//                                                 WHERE(Number=FILTER(1..));
//                             column(DimText;DimText)
//                             {
//                             }

//                             trigger OnAfterGetRecord()
//                             begin
//                                 IF Number = 1 THEN BEGIN
//                                   IF NOT DimSetEntry2.FINDSET THEN
//                                     CurrReport.BREAK;
//                                 END ELSE
//                                   IF NOT Continue THEN
//                                     CurrReport.BREAK;

//                                 CLEAR(DimText);
//                                 Continue := FALSE;
//                                 REPEAT

//                                   OldDimText := DimText;
//                                   IF DimText = '' THEN
//                                     DimText := STRSUBSTNO('%1 %2',DimSetEntry2."Dimension Code",DimSetEntry2."Dimension Value Code")
//                                   ELSE
//                                     DimText :=
//                                       STRSUBSTNO(
//                                         '%1, %2 %3',DimText,
//                                         DimSetEntry2."Dimension Code",DimSetEntry2."Dimension Value Code");
//                                   IF STRLEN(DimText) > MAXSTRLEN(OldDimText) THEN BEGIN
//                                     DimText := OldDimText;
//                                     Continue := TRUE;
//                                     EXIT;
//                                   END;

//                                 UNTIL DimSetEntry2.NEXT = 0;
//                             end;

//                             trigger OnPreDataItem()
//                             begin
//                                 IF NOT ShowInternalInfo THEN
//                                   CurrReport.BREAK;

//                                 DimSetEntry2.SETRANGE("Dimension Set ID","Sales Line"."Dimension Set ID");
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

//                             ItemEng := GetEnglishName(SalesLine."No.");

//                             IF NOT "Sales Header"."Prices Including VAT" AND
//                                (SalesLine."VAT Calculation Type" = SalesLine."VAT Calculation Type"::"Full VAT")
//                             THEN
//                               SalesLine."Line Amount" := 0;

//                             /*
//                             IF (SalesLine.Type = SalesLine.Type::"G/L Account") AND (NOT ShowInternalInfo) THEN
//                               "Sales Line"."No." := '';
//                             */
//                             IF (SalesLine.Type = SalesLine.Type::"G/L Account") THEN
//                               "Sales Line"."No." := '';

//                             NNCSalesLineLineAmt += SalesLine."Line Amount";
//                             NNCSalesLineInvDiscAmt += SalesLine."Inv. Discount Amount";

//                             NNCTotalLCY := NNCSalesLineLineAmt - NNCSalesLineInvDiscAmt;

//                             NNCTotalExclVAT := NNCTotalLCY;
//                             NNCVATAmt := VATAmount;
//                             NNCTotalInclVAT := NNCTotalLCY - NNCVATAmt;

//                             NNCPmtDiscOnVAT := -VATDiscountAmount;

//                             NNCTotalInclVAT2 := TotalAmountInclVAT;

//                             NNCVATAmt2 := VATAmount;
//                             NNCTotalExclVAT2 := VATBaseAmount;

//                             //Get Item Tracking Lines
//                             TempItemTrack.DELETEALL;
//                             CLEAR(ItemTracking);
//                             EntryNo := 1;
//                             ItemTracking.SETRANGE(ItemTracking."Source ID",SalesLine."Document No.");
//                             ItemTracking.SETRANGE(ItemTracking."Item No.",SalesLine."No." );
//                             ItemTracking.SETRANGE(ItemTracking."Source Ref. No.",SalesLine."Line No."); //SWJ
//                             IF ItemTracking.FIND('-') THEN BEGIN
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
//                                   TempItemTrack.INSERT;
//                                   EntryNo += 1;
//                                 END; //SWJ
//                               UNTIL ItemTracking.NEXT = 0;

//                               TempItemTrack.RESET;
//                               TempItemTrack.SETFILTER("Entry No.",'%1',1);
//                               IF TempItemTrack.FIND('-') THEN TempItemTrack.DELETE;
//                             END;

//                             /*
//                             IF SalesLine.Type = 0 THEN
//                             BEGIN
//                                intPos := STRPOS(SalesLine.Description, 'Shipment No.');
//                                IF intPos > 0 THEN
//                                BEGIN
//                                     CurrReport.Skip;
//                                END
//                             END;
//                             */

//                             IF SalesLine.Type >0 THEN BEGIN
//                                SerialNo += 1;
//                                SerialNo2 := SerialNo;
//                             END;

//                             CLEAR(ItemTracking);
//                             ItemTracking.SETRANGE(ItemTracking."Source ID",SalesLine."Document No.");
//                             ItemTracking.SETRANGE(ItemTracking."Item No.",SalesLine."No." );
//                             ItemTracking.SETRANGE(ItemTracking."Source Ref. No.",SalesLine."Line No."); //SWJ
//                             IF ItemTracking.FIND('-') THEN;

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
//                             ItemEng := '';
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

//                     trigger OnAfterGetRecord()
//                     begin
//                         PageNo := STRSUBSTNO(Text005,FORMAT(CurrReport.PAGENO));
//                     end;
//                 }

//                 trigger OnAfterGetRecord()
//                 var
//                     SalesPost: Codeunit "80";
//                 begin

//                     CLEAR(SalesLine);
//                     CLEAR(SalesPost);
//                     VATAmountLine.DELETEALL;
//                     SalesLine.DELETEALL;
//                     SalesPost.GetSalesLines("Sales Header",SalesLine,0);
//                     SalesLine.CalcVATAmountLines(0,"Sales Header",SalesLine,VATAmountLine);
//                     SalesLine.UpdateVATOnLines(0,"Sales Header",SalesLine,VATAmountLine);
//                     VATAmount := VATAmountLine.GetTotalVATAmount;
//                     VATBaseAmount := VATAmountLine.GetTotalVATBase;
//                     VATDiscountAmount :=
//                       VATAmountLine.GetTotalVATDiscount("Sales Header"."Currency Code","Sales Header"."Prices Including VAT");
//                     TotalAmountInclVAT := VATAmountLine.GetTotalAmountInclVAT;

//                     IF Number > 1 THEN
//                       CopyText := Text003;
//                     CurrReport.PAGENO := 1;

//                     NNCTotalLCY := 0;
//                     NNCTotalExclVAT := 0;
//                     NNCVATAmt := 0;
//                     NNCTotalInclVAT := 0;
//                     NNCPmtDiscOnVAT := 0;
//                     NNCTotalInclVAT2 := 0;
//                     NNCVATAmt2 := 0;
//                     NNCTotalExclVAT2 := 0;
//                     NNCSalesLineLineAmt := 0;
//                     NNCSalesLineInvDiscAmt := 0;
//                 end;

//                 trigger OnPostDataItem()
//                 begin

//                     IF NOT CurrReport.PREVIEW THEN
//                       SalesCountPrinted.RUN("Sales Header");
//                 end;

//                 trigger OnPreDataItem()
//                 begin

//                     NoOfLoops := ABS(NoOfCopies) + 1;
//                     CopyText := '';
//                     SETRANGE(Number,1,NoOfLoops);
//                 end;
//             }

//             trigger OnAfterGetRecord()
//             begin

//                 CLEAR(SerialNo);
//                 CurrReport.LANGUAGE := Language.GetLanguageID("Language Code");

//                 IF RespCenter.GET("Responsibility Center") THEN BEGIN
//                   FormatAddr.RespCenter(CompanyAddr,RespCenter);
//                   CompanyInfo."Phone No." := RespCenter."Phone No.";
//                   CompanyInfo."Fax No." := RespCenter."Fax No.";
//                 END ELSE
//                   FormatAddr.Company(CompanyAddr,CompanyInfo);

//                 /*
//                 DocDim1.SETRANGE("Table ID",DATABASE::"Sales Header");
//                 DocDim1.SETRANGE("Document Type","Sales Header"."Document Type");
//                 DocDim1.SETRANGE("Document No.","Sales Header"."No.");
//                 */
//                 DimSetEntry1.RESET;
//                 DimSetEntry1.SETRANGE("Dimension Set ID","Dimension Set ID");

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

//             end;

//             trigger OnPreDataItem()
//             begin
//                 GLSetup.GET;
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
//                     field("No. of Copies";NoOfCopies)
//                     {
//                     }
//                     field("Show Internal Information";ShowInternalInfo)
//                     {
//                         Visible = false;
//                     }
//                     field("Archieve Document";ArchiveDocument)
//                     {
//                         Visible = false;
//                     }
//                     field("Log Interaction";LogInteraction)
//                     {
//                         Visible = false;
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

//     var
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
//         DimSetEntry1: Record "480";
//         DimSetEntry2: Record "480";
//         TempPrepmtDimSetEntry: Record "480" temporary;
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
//         VALExchRate: Text[50];
//         intPos: Integer;
//         SerialNo: Integer;
//         SerialNo2: Integer;
//         Vblank: Char;
//         ItemTracking: Record "337";
//         TempItemTrack: Record "337" temporary;
//         TotalLot: Integer;
//         ItemEng: Text[60];
//         Text000: Label 'Salesperson';
//         Text001: Label 'TOTAL %1';
//         Text002: Label 'TOTAL %1 ';
//         Text003: Label 'COPY';
//         Text004: Label 'TAX INVOICE %1';
//         Text005: Label 'Page %1';
//         Text006: Label 'SUB-TOTAL %1 ';
//         Text007: Label 'GST Amount Specification in ';
//         Text008: Label 'Local Currency';
//         Text009: Label 'Exchange rate: %1/%2';
//         PageNo: Text[100];
//         NNCTotalLCY: Decimal;
//         NNCTotalExclVAT: Decimal;
//         NNCVATAmt: Decimal;
//         NNCTotalInclVAT: Decimal;
//         NNCPmtDiscOnVAT: Decimal;
//         NNCTotalInclVAT2: Decimal;
//         NNCVATAmt2: Decimal;
//         NNCTotalExclVAT2: Decimal;
//         NNCSalesLineLineAmt: Decimal;
//         NNCSalesLineInvDiscAmt: Decimal;

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
// }

