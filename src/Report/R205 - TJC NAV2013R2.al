// report 205 "Order Confirmation"
// {
//     DefaultLayout = RDLC;
//     RDLCLayout = './Order Confirmation.rdlc';
//     Caption = 'Order Confirmation';

//     dataset
//     {
//         dataitem(DataItem6640;Table36)
//         {
//             DataItemTableView = SORTING(Document Type,No.)
//                                 WHERE(Document Type=CONST(Order));
//             RequestFilterFields = "No.","Sell-to Customer No.","No. Printed";
//             RequestFilterHeading = 'Sales Order';
//             column(DocType_SalesHeader;"Document Type")
//             {
//             }
//             column(No_SalesHeader;"No.")
//             {
//             }
//             column(InvDiscAmtCaption;InvDiscAmtCaptionLbl)
//             {
//             }
//             column(PhoneNoCaption;PhoneNoCaptionLbl)
//             {
//             }
//             column(AmountCaption;AmountCaptionLbl)
//             {
//             }
//             column(VATPercentageCaption;VATPercentageCaptionLbl)
//             {
//             }
//             column(VATBaseCaption;VATBaseCaptionLbl)
//             {
//             }
//             column(VATAmtCaption;VATAmtCaptionLbl)
//             {
//             }
//             column(VATAmtSpecCaption;VATAmtSpecCaptionLbl)
//             {
//             }
//             column(LineAmtCaption;LineAmtCaptionLbl)
//             {
//             }
//             column(TotalCaption;TotalCaptionLbl)
//             {
//             }
//             column(UnitPriceCaption;UnitPriceCaptionLbl)
//             {
//             }
//             column(PaymentTermsCaption;PaymentTermsCaptionLbl)
//             {
//             }
//             column(ShipmentMethodCaption;ShipmentMethodCaptionLbl)
//             {
//             }
//             column(DocumentDateCaption;DocumentDateCaptionLbl)
//             {
//             }
//             column(AllowInvDiscCaption;AllowInvDiscCaptionLbl)
//             {
//             }
//             dataitem(CopyLoop;Table2000000026)
//             {
//                 DataItemTableView = SORTING(Number);
//                 dataitem(PageLoop;Table2000000026)
//                 {
//                     DataItemTableView = SORTING(Number)
//                                         WHERE(Number=CONST(1));
//                     column(CompanyInfo2Picture;CompanyInfo2.Picture)
//                     {
//                     }
//                     column(CompanyInfo3Picture;CompanyInfo3.Picture)
//                     {
//                     }
//                     column(CompanyInfo1Picture;CompanyInfo1.Picture)
//                     {
//                     }
//                     column(OrderConfirmCopyCaption;STRSUBSTNO(Text004,CopyText))
//                     {
//                     }
//                     column(CustAddr1;CustAddr[1])
//                     {
//                     }
//                     column(CompanyAddr1;CompanyAddr[1])
//                     {
//                     }
//                     column(CustAddr2;CustAddr[2])
//                     {
//                     }
//                     column(CompanyAddr2;CompanyAddr[2])
//                     {
//                     }
//                     column(CustAddr3;CustAddr[3])
//                     {
//                     }
//                     column(CompanyAddr3;CompanyAddr[3])
//                     {
//                     }
//                     column(CustAddr4;CustAddr[4])
//                     {
//                     }
//                     column(CompanyAddr4;CompanyAddr[4])
//                     {
//                     }
//                     column(CustAddr5;CustAddr[5])
//                     {
//                     }
//                     column(CompanyInfoPhNo;CompanyInfo."Phone No.")
//                     {
//                         IncludeCaption = false;
//                     }
//                     column(CustAddr6;CustAddr[6])
//                     {
//                     }
//                     column(CompanyInfoVATRegNo;CompanyInfo."VAT Registration No.")
//                     {
//                     }
//                     column(CompanyInfoGiroNo;CompanyInfo."Giro No.")
//                     {
//                     }
//                     column(CompanyInfoBankName;CompanyInfo."Bank Name")
//                     {
//                     }
//                     column(CompanyInfoHomePage;CompanyInfo."Home Page")
//                     {
//                     }
//                     column(CompanyInfoEmail;CompanyInfo."E-Mail")
//                     {
//                     }
//                     column(CompanyInfoBankAccNo;CompanyInfo."Bank Account No.")
//                     {
//                     }
//                     column(BilltoCustNo_SalesHeader;"Sales Header"."Bill-to Customer No.")
//                     {
//                     }
//                     column(DocDate_SalesHeader;FORMAT("Sales Header"."Document Date"))
//                     {
//                     }
//                     column(VATNoText;VATNoText)
//                     {
//                     }
//                     column(VATRegNo_SalesHeader;"Sales Header"."VAT Registration No.")
//                     {
//                     }
//                     column(ShptDate_SalesHeader;FORMAT("Sales Header"."Shipment Date"))
//                     {
//                     }
//                     column(SalesPersonText;SalesPersonText)
//                     {
//                     }
//                     column(SalesPurchPersonName;SalesPurchPerson.Name)
//                     {
//                     }
//                     column(ReferenceText;ReferenceText)
//                     {
//                     }
//                     column(SalesOrderReference_SalesHeader;"Sales Header"."Your Reference")
//                     {
//                     }
//                     column(CustAddr7;CustAddr[7])
//                     {
//                     }
//                     column(CustAddr8;CustAddr[8])
//                     {
//                     }
//                     column(CompanyAddr5;CompanyAddr[5])
//                     {
//                     }
//                     column(CompanyAddr6;CompanyAddr[6])
//                     {
//                     }
//                     column(PricesInclVAT_SalesHeader;"Sales Header"."Prices Including VAT")
//                     {
//                     }
//                     column(PageCaption;PageCaptionCap)
//                     {
//                     }
//                     column(OutputNo;OutputNo)
//                     {
//                     }
//                     column(PmntTermsDesc;PaymentTerms.Description)
//                     {
//                     }
//                     column(ShptMethodDesc;ShipmentMethod.Description)
//                     {
//                     }
//                     column(PricesInclVATYesNo_SalesHeader;FORMAT("Sales Header"."Prices Including VAT"))
//                     {
//                     }
//                     column(VATRegNoCaption;VATRegNoCaptionLbl)
//                     {
//                     }
//                     column(GiroNoCaption;GiroNoCaptionLbl)
//                     {
//                     }
//                     column(BankCaption;BankCaptionLbl)
//                     {
//                     }
//                     column(AccountNoCaption;AccountNoCaptionLbl)
//                     {
//                     }
//                     column(ShipmentDateCaption;ShipmentDateCaptionLbl)
//                     {
//                     }
//                     column(OrderNoCaption;OrderNoCaptionLbl)
//                     {
//                     }
//                     column(HomePageCaption;HomePageCaptionCap)
//                     {
//                     }
//                     column(EmailCaption;EmailCaptionLbl)
//                     {
//                     }
//                     column(BilltoCustNo_SalesHeaderCaption;"Sales Header".FIELDCAPTION("Bill-to Customer No."))
//                     {
//                     }
//                     column(PricesInclVAT_SalesHeaderCaption;"Sales Header".FIELDCAPTION("Prices Including VAT"))
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
//                         column(DimensionLoop1Number;Number)
//                         {
//                         }
//                         column(HeaderDimCaption;HeaderDimCaptionLbl)
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
//                     dataitem(DataItem2844;Table37)
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
//                         column(SalesLineAmt;SalesLine."Line Amount")
//                         {
//                             AutoFormatExpression = "Sales Header"."Currency Code";
//                             AutoFormatType = 1;
//                         }
//                         column(Desc_SalesLine;"Sales Line".Description)
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
//                         column(DisplayAssemblyInfo;DisplayAssemblyInformation)
//                         {
//                         }
//                         column(ShowInternalInfo;ShowInternalInfo)
//                         {
//                         }
//                         column(No2_SalesLine;"Sales Line"."No.")
//                         {
//                         }
//                         column(Qty_SalesLine;"Sales Line".Quantity)
//                         {
//                         }
//                         column(UOM_SalesLine;"Sales Line"."Unit of Measure")
//                         {
//                         }
//                         column(UnitPrice_SalesLine;"Sales Line"."Unit Price")
//                         {
//                             AutoFormatExpression = "Sales Header"."Currency Code";
//                             AutoFormatType = 2;
//                             IncludeCaption = false;
//                         }
//                         column(LineDisc_SalesLine;"Sales Line"."Line Discount %")
//                         {
//                         }
//                         column(LineAmt_SalesLine;"Sales Line"."Line Amount")
//                         {
//                             AutoFormatExpression = "Sales Header"."Currency Code";
//                             AutoFormatType = 1;
//                         }
//                         column(AllowInvDisc_SalesLine;"Sales Line"."Allow Invoice Disc.")
//                         {
//                         }
//                         column(VATIdentifier_SalesLine;"Sales Line"."VAT Identifier")
//                         {
//                         }
//                         column(Type_SalesLine;FORMAT("Sales Line".Type))
//                         {
//                         }
//                         column(No_SalesLine;"Sales Line"."Line No.")
//                         {
//                         }
//                         column(AllowInvDiscountYesNo_SalesLine;FORMAT("Sales Line"."Allow Invoice Disc."))
//                         {
//                         }
//                         column(AsmInfoExistsForLine;AsmInfoExistsForLine)
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
//                         column(DiscountPercentCaption;DiscountPercentCaptionLbl)
//                         {
//                         }
//                         column(SubtotalCaption;SubtotalCaptionLbl)
//                         {
//                         }
//                         column(PaymentDiscountVATCaption;PaymentDiscountVATCaptionLbl)
//                         {
//                         }
//                         column(Desc_SalesLineCaption;"Sales Line".FIELDCAPTION(Description))
//                         {
//                         }
//                         column(No2_SalesLineCaption;"Sales Line".FIELDCAPTION("No."))
//                         {
//                         }
//                         column(Qty_SalesLineCaption;"Sales Line".FIELDCAPTION(Quantity))
//                         {
//                         }
//                         column(UOM_SalesLineCaption;"Sales Line".FIELDCAPTION("Unit of Measure"))
//                         {
//                         }
//                         column(VATIdentifier_SalesLineCaption;"Sales Line".FIELDCAPTION("VAT Identifier"))
//                         {
//                         }
//                         dataitem(DimensionLoop2;Table2000000026)
//                         {
//                             DataItemTableView = SORTING(Number)
//                                                 WHERE(Number=FILTER(1..));
//                             column(DimText2;DimText)
//                             {
//                             }
//                             column(LineDimCaption;LineDimCaptionLbl)
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
//                         dataitem(AsmLoop;Table2000000026)
//                         {
//                             DataItemTableView = SORTING(Number);
//                             column(AsmLineType;AsmLine.Type)
//                             {
//                             }
//                             column(AsmLineNo;BlanksForIndent + AsmLine."No.")
//                             {
//                             }
//                             column(AsmLineDescription;BlanksForIndent + AsmLine.Description)
//                             {
//                             }
//                             column(AsmLineQuantity;AsmLine.Quantity)
//                             {
//                             }
//                             column(AsmLineUOMText;GetUnitOfMeasureDescr(AsmLine."Unit of Measure Code"))
//                             {
//                             }

//                             trigger OnAfterGetRecord()
//                             begin
//                                 IF Number = 1 THEN
//                                   AsmLine.FINDSET
//                                 ELSE
//                                   AsmLine.NEXT;
//                             end;

//                             trigger OnPreDataItem()
//                             begin
//                                 IF NOT DisplayAssemblyInformation THEN
//                                   CurrReport.BREAK;
//                                 IF NOT AsmInfoExistsForLine THEN
//                                   CurrReport.BREAK;
//                                 AsmLine.SETRANGE("Document Type",AsmHeader."Document Type");
//                                 AsmLine.SETRANGE("Document No.",AsmHeader."No.");
//                                 SETRANGE(Number,1,AsmLine.COUNT);
//                             end;
//                         }

//                         trigger OnAfterGetRecord()
//                         begin
//                             IF Number = 1 THEN
//                               SalesLine.FIND('-')
//                             ELSE
//                               SalesLine.NEXT;
//                             "Sales Line" := SalesLine;
//                             IF DisplayAssemblyInformation THEN
//                               AsmInfoExistsForLine := SalesLine.AsmToOrderExists(AsmHeader);

//                             IF NOT "Sales Header"."Prices Including VAT" AND
//                                (SalesLine."VAT Calculation Type" = SalesLine."VAT Calculation Type"::"Full VAT")
//                             THEN
//                               SalesLine."Line Amount" := 0;

//                             IF (SalesLine.Type = SalesLine.Type::"G/L Account") AND (NOT ShowInternalInfo) THEN
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
//                         end;

//                         trigger OnPostDataItem()
//                         begin
//                             SalesLine.DELETEALL;
//                         end;

//                         trigger OnPreDataItem()
//                         begin
//                             MoreLines := SalesLine.FIND('+');
//                             WHILE MoreLines AND (SalesLine.Description = '') AND (SalesLine."Description 2" = '') AND
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
//                         column(VATAmountLineVATBase;VATAmountLine."VAT Base")
//                         {
//                             AutoFormatExpression = "Sales Header"."Currency Code";
//                             AutoFormatType = 1;
//                         }
//                         column(VATAmtLineVATAmt;VATAmountLine."VAT Amount")
//                         {
//                             AutoFormatExpression = "Sales Header"."Currency Code";
//                             AutoFormatType = 1;
//                         }
//                         column(VATAmtLineLineAmt;VATAmountLine."Line Amount")
//                         {
//                             AutoFormatExpression = "Sales Header"."Currency Code";
//                             AutoFormatType = 1;
//                         }
//                         column(VATAmtLineInvDiscBaseAmt;VATAmountLine."Inv. Disc. Base Amount")
//                         {
//                             AutoFormatExpression = "Sales Header"."Currency Code";
//                             AutoFormatType = 1;
//                         }
//                         column(VATAmtLineInvDiscAmt;VATAmountLine."Invoice Discount Amount")
//                         {
//                             AutoFormatExpression = "Sales Header"."Currency Code";
//                             AutoFormatType = 1;
//                         }
//                         column(VATAmtLineVATPercentage;VATAmountLine."VAT %")
//                         {
//                             DecimalPlaces = 0:5;
//                         }
//                         column(VATAmtLineVATIdentifier;VATAmountLine."VAT Identifier")
//                         {
//                         }
//                         column(InvDiscBaseAmtCaption;InvDiscBaseAmtCaptionLbl)
//                         {
//                         }
//                         column(VATIdentifierCaption;VATIdentifierCaptionLbl)
//                         {
//                         }

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
//                         column(VALExchRate;VALExchRate)
//                         {
//                         }
//                         column(VALSpecLCYHeader;VALSpecLCYHeader)
//                         {
//                         }
//                         column(VALVATBaseLCY;VALVATBaseLCY)
//                         {
//                             AutoFormatType = 1;
//                         }
//                         column(VALVATAmountLCY;VALVATAmountLCY)
//                         {
//                             AutoFormatType = 1;
//                         }
//                         column(VATAmtLineVATPercentage2;VATAmountLine."VAT %")
//                         {
//                             DecimalPlaces = 0:5;
//                         }
//                         column(VATAmtLineVATIdentifier2;VATAmountLine."VAT Identifier")
//                         {
//                         }

//                         trigger OnAfterGetRecord()
//                         begin
//                             VATAmountLine.GetLine(Number);
//                             VALVATBaseLCY :=
//                               VATAmountLine.GetBaseLCY(
//                                 "Sales Header"."Posting Date","Sales Header"."Currency Code","Sales Header"."Currency Factor");
//                             VALVATAmountLCY :=
//                               VATAmountLine.GetAmountLCY(
//                                 "Sales Header"."Posting Date","Sales Header"."Currency Code","Sales Header"."Currency Factor");
//                         end;

//                         trigger OnPreDataItem()
//                         begin
//                             IF (NOT GLSetup."Print VAT specification in LCY") OR
//                                ("Sales Header"."Currency Code" = '') OR
//                                (VATAmountLine.GetTotalVATAmount = 0)
//                             THEN
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
//                     dataitem(Total2;Table2000000026)
//                     {
//                         DataItemTableView = SORTING(Number)
//                                             WHERE(Number=CONST(1));
//                         column(SelltoCustNo_SalesHeader;"Sales Header"."Sell-to Customer No.")
//                         {
//                         }
//                         column(ShipToAddr8;ShipToAddr[8])
//                         {
//                         }
//                         column(ShipToAddr7;ShipToAddr[7])
//                         {
//                         }
//                         column(ShipToAddr6;ShipToAddr[6])
//                         {
//                         }
//                         column(ShipToAddr5;ShipToAddr[5])
//                         {
//                         }
//                         column(ShipToAddr4;ShipToAddr[4])
//                         {
//                         }
//                         column(ShipToAddr3;ShipToAddr[3])
//                         {
//                         }
//                         column(ShipToAddr2;ShipToAddr[2])
//                         {
//                         }
//                         column(ShipToAddr1;ShipToAddr[1])
//                         {
//                         }
//                         column(ShiptoAddrCaption;ShiptoAddrCaptionLbl)
//                         {
//                         }
//                         column(SelltoCustNo_SalesHeaderCaption;"Sales Header".FIELDCAPTION("Sell-to Customer No."))
//                         {
//                         }

//                         trigger OnPreDataItem()
//                         begin
//                             IF NOT ShowShippingAddr THEN
//                               CurrReport.BREAK;
//                         end;
//                     }
//                     dataitem(PrepmtLoop;Table2000000026)
//                     {
//                         DataItemTableView = SORTING(Number)
//                                             WHERE(Number=FILTER(1..));
//                         column(PrepmtLineAmount;PrepmtLineAmount)
//                         {
//                             AutoFormatExpression = "Sales Header"."Currency Code";
//                             AutoFormatType = 1;
//                         }
//                         column(PrepmtInvBufDesc;PrepmtInvBuf.Description)
//                         {
//                         }
//                         column(PrepmtInvBufGLAccNo;PrepmtInvBuf."G/L Account No.")
//                         {
//                         }
//                         column(TotalExclVATText2;TotalExclVATText)
//                         {
//                         }
//                         column(PrepmtVATAmtLineVATAmtTxt;PrepmtVATAmountLine.VATAmountText)
//                         {
//                         }
//                         column(TotalInclVATText2;TotalInclVATText)
//                         {
//                         }
//                         column(PrepmtInvAmount;PrepmtInvBuf.Amount)
//                         {
//                             AutoFormatExpression = "Sales Header"."Currency Code";
//                             AutoFormatType = 1;
//                         }
//                         column(PrepmtVATAmount;PrepmtVATAmount)
//                         {
//                             AutoFormatExpression = "Sales Header"."Currency Code";
//                             AutoFormatType = 1;
//                         }
//                         column(PrepmtInvAmtInclVATAmt;PrepmtInvBuf.Amount + PrepmtVATAmount)
//                         {
//                             AutoFormatExpression = "Sales Header"."Currency Code";
//                             AutoFormatType = 1;
//                         }
//                         column(VATAmtLineVATAmtText2;VATAmountLine.VATAmountText)
//                         {
//                         }
//                         column(PrepmtTotalAmountInclVAT;PrepmtTotalAmountInclVAT)
//                         {
//                             AutoFormatExpression = "Sales Header"."Currency Code";
//                             AutoFormatType = 1;
//                         }
//                         column(PrepmtVATBaseAmount;PrepmtVATBaseAmount)
//                         {
//                             AutoFormatExpression = "Sales Header"."Currency Code";
//                             AutoFormatType = 1;
//                         }
//                         column(PrepmtLoopNumber;Number)
//                         {
//                         }
//                         column(DescriptionCaption;DescriptionCaptionLbl)
//                         {
//                         }
//                         column(GLAccountNoCaption;GLAccountNoCaptionLbl)
//                         {
//                         }
//                         column(PrepaymentSpecCaption;PrepaymentSpecCaptionLbl)
//                         {
//                         }
//                         dataitem(PrepmtDimLoop;Table2000000026)
//                         {
//                             DataItemTableView = SORTING(Number)
//                                                 WHERE(Number=FILTER(1..));
//                             column(DimText3;DimText)
//                             {
//                             }

//                             trigger OnAfterGetRecord()
//                             begin
//                                 IF Number = 1 THEN BEGIN
//                                   IF NOT TempPrepmtDimSetEntry.FIND('-') THEN
//                                     CurrReport.BREAK;
//                                 END ELSE
//                                   IF NOT Continue THEN
//                                     CurrReport.BREAK;

//                                 CLEAR(DimText);
//                                 Continue := FALSE;
//                                 REPEAT
//                                   OldDimText := DimText;
//                                   IF DimText = '' THEN
//                                     DimText :=
//                                       STRSUBSTNO('%1 %2',TempPrepmtDimSetEntry."Dimension Code",TempPrepmtDimSetEntry."Dimension Value Code")
//                                   ELSE
//                                     DimText :=
//                                       STRSUBSTNO(
//                                         '%1, %2 %3',DimText,
//                                         TempPrepmtDimSetEntry."Dimension Code",TempPrepmtDimSetEntry."Dimension Value Code");
//                                   IF STRLEN(DimText) > MAXSTRLEN(OldDimText) THEN BEGIN
//                                     DimText := OldDimText;
//                                     Continue := TRUE;
//                                     EXIT;
//                                   END;
//                                 UNTIL TempPrepmtDimSetEntry.NEXT = 0;
//                             end;
//                         }

//                         trigger OnAfterGetRecord()
//                         begin
//                             IF Number = 1 THEN BEGIN
//                               IF NOT PrepmtInvBuf.FIND('-') THEN
//                                 CurrReport.BREAK;
//                             END ELSE
//                               IF PrepmtInvBuf.NEXT = 0 THEN
//                                 CurrReport.BREAK;

//                             IF ShowInternalInfo THEN
//                               DimMgt.GetDimensionSet(TempPrepmtDimSetEntry,PrepmtInvBuf."Dimension Set ID");

//                             IF "Sales Header"."Prices Including VAT" THEN
//                               PrepmtLineAmount := PrepmtInvBuf."Amount Incl. VAT"
//                             ELSE
//                               PrepmtLineAmount := PrepmtInvBuf.Amount;
//                         end;

//                         trigger OnPreDataItem()
//                         begin
//                             CurrReport.CREATETOTALS(
//                               PrepmtInvBuf.Amount,PrepmtInvBuf."Amount Incl. VAT",
//                               PrepmtVATAmountLine."Line Amount",PrepmtVATAmountLine."VAT Base",
//                               PrepmtVATAmountLine."VAT Amount",
//                               PrepmtLineAmount);
//                         end;
//                     }
//                     dataitem(PrepmtVATCounter;Table2000000026)
//                     {
//                         DataItemTableView = SORTING(Number);
//                         column(PrepmtVATAmtLineVATAmt;PrepmtVATAmountLine."VAT Amount")
//                         {
//                             AutoFormatExpression = "Sales Header"."Currency Code";
//                             AutoFormatType = 1;
//                         }
//                         column(PrepmtVATAmtLineVATBase;PrepmtVATAmountLine."VAT Base")
//                         {
//                             AutoFormatExpression = "Sales Header"."Currency Code";
//                             AutoFormatType = 1;
//                         }
//                         column(PrepmtVATAmtLineLineAmt;PrepmtVATAmountLine."Line Amount")
//                         {
//                             AutoFormatExpression = "Sales Header"."Currency Code";
//                             AutoFormatType = 1;
//                         }
//                         column(PrepmtVATAmtLineVATPerc;PrepmtVATAmountLine."VAT %")
//                         {
//                             DecimalPlaces = 0:5;
//                         }
//                         column(PrepmtVATAmtLineVATIdent;PrepmtVATAmountLine."VAT Identifier")
//                         {
//                         }
//                         column(PrepmtVATCounterNumber;Number)
//                         {
//                         }
//                         column(PrepaymentVATAmtSpecCap;PrepaymentVATAmtSpecCapLbl)
//                         {
//                         }

//                         trigger OnAfterGetRecord()
//                         begin
//                             PrepmtVATAmountLine.GetLine(Number);
//                         end;

//                         trigger OnPreDataItem()
//                         begin
//                             SETRANGE(Number,1,PrepmtVATAmountLine.COUNT);
//                         end;
//                     }
//                     dataitem(PrepmtTotal;Table2000000026)
//                     {
//                         DataItemTableView = SORTING(Number)
//                                             WHERE(Number=CONST(1));
//                         column(PrepmtPmtTermsDesc;PrepmtPaymentTerms.Description)
//                         {
//                         }
//                         column(PrepmtPmtTermsDescCaption;PrepmtPmtTermsDescCaptionLbl)
//                         {
//                         }

//                         trigger OnPreDataItem()
//                         begin
//                             IF NOT PrepmtInvBuf.FIND('-') THEN
//                               CurrReport.BREAK;
//                         end;
//                     }
//                 }

//                 trigger OnAfterGetRecord()
//                 var
//                     PrepmtSalesLine: Record "37" temporary;
//                     SalesPost: Codeunit "80";
//                     TempSalesLine: Record "37" temporary;
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

//                     PrepmtInvBuf.DELETEALL;
//                     SalesPostPrepmt.GetSalesLines("Sales Header",0,PrepmtSalesLine);

//                     IF NOT PrepmtSalesLine.ISEMPTY THEN BEGIN
//                       SalesPostPrepmt.GetSalesLinesToDeduct("Sales Header",TempSalesLine);
//                       IF NOT TempSalesLine.ISEMPTY THEN
//                         SalesPostPrepmt.CalcVATAmountLines("Sales Header",TempSalesLine,PrepmtVATAmountLineDeduct,1);
//                     END;
//                     SalesPostPrepmt.CalcVATAmountLines("Sales Header",PrepmtSalesLine,PrepmtVATAmountLine,0);
//                     IF PrepmtVATAmountLine.FINDSET THEN
//                       REPEAT
//                         PrepmtVATAmountLineDeduct := PrepmtVATAmountLine;
//                         IF PrepmtVATAmountLineDeduct.FIND THEN BEGIN
//                           PrepmtVATAmountLine."VAT Base" := PrepmtVATAmountLine."VAT Base" - PrepmtVATAmountLineDeduct."VAT Base";
//                           PrepmtVATAmountLine."VAT Amount" := PrepmtVATAmountLine."VAT Amount" - PrepmtVATAmountLineDeduct."VAT Amount";
//                           PrepmtVATAmountLine."Amount Including VAT" := PrepmtVATAmountLine."Amount Including VAT" -
//                             PrepmtVATAmountLineDeduct."Amount Including VAT";
//                           PrepmtVATAmountLine."Line Amount" := PrepmtVATAmountLine."Line Amount" - PrepmtVATAmountLineDeduct."Line Amount";
//                           PrepmtVATAmountLine."Inv. Disc. Base Amount" := PrepmtVATAmountLine."Inv. Disc. Base Amount" -
//                             PrepmtVATAmountLineDeduct."Inv. Disc. Base Amount";
//                           PrepmtVATAmountLine."Invoice Discount Amount" := PrepmtVATAmountLine."Invoice Discount Amount" -
//                             PrepmtVATAmountLineDeduct."Invoice Discount Amount";
//                           PrepmtVATAmountLine."Calculated VAT Amount" := PrepmtVATAmountLine."Calculated VAT Amount" -
//                             PrepmtVATAmountLineDeduct."Calculated VAT Amount";
//                           PrepmtVATAmountLine.MODIFY;
//                         END;
//                       UNTIL PrepmtVATAmountLine.NEXT = 0;

//                     SalesPostPrepmt.UpdateVATOnLines("Sales Header",PrepmtSalesLine,PrepmtVATAmountLine,0);
//                     SalesPostPrepmt.BuildInvLineBuffer2("Sales Header",PrepmtSalesLine,0,PrepmtInvBuf);
//                     PrepmtVATAmount := PrepmtVATAmountLine.GetTotalVATAmount;
//                     PrepmtVATBaseAmount := PrepmtVATAmountLine.GetTotalVATBase;
//                     PrepmtTotalAmountInclVAT := PrepmtVATAmountLine.GetTotalAmountInclVAT;

//                     IF Number > 1 THEN BEGIN
//                       CopyText := Text003;
//                       OutputNo += 1;
//                     END;
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
//                     IF Print THEN
//                       SalesCountPrinted.RUN("Sales Header");
//                 end;

//                 trigger OnPreDataItem()
//                 begin
//                     NoOfLoops := ABS(NoOfCopies) + 1;
//                     CopyText := '';
//                     SETRANGE(Number,1,NoOfLoops);
//                     OutputNo := 1;
//                 end;
//             }

//             trigger OnAfterGetRecord()
//             begin
//                 CompanyInfo.GET;
//                 CurrReport.LANGUAGE := Language.GetLanguageID("Language Code");

//                 IF RespCenter.GET("Responsibility Center") THEN BEGIN
//                   FormatAddr.RespCenter(CompanyAddr,RespCenter);
//                   CompanyInfo."Phone No." := RespCenter."Phone No.";
//                   CompanyInfo."Fax No." := RespCenter."Fax No.";
//                 END ELSE
//                   FormatAddr.Company(CompanyAddr,CompanyInfo);

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
//                 ELSE BEGIN
//                   PaymentTerms.GET("Payment Terms Code");
//                   PaymentTerms.TranslateDescription(PaymentTerms,"Language Code");
//                 END;
//                 IF "Prepmt. Payment Terms Code" = '' THEN
//                   PrepmtPaymentTerms.INIT
//                 ELSE BEGIN
//                   PrepmtPaymentTerms.GET("Prepmt. Payment Terms Code");
//                   PrepmtPaymentTerms.TranslateDescription(PrepmtPaymentTerms,"Language Code");
//                 END;
//                 IF "Prepmt. Payment Terms Code" = '' THEN
//                   PrepmtPaymentTerms.INIT
//                 ELSE BEGIN
//                   PrepmtPaymentTerms.GET("Prepmt. Payment Terms Code");
//                   PrepmtPaymentTerms.TranslateDescription(PrepmtPaymentTerms,"Language Code");
//                 END;
//                 IF "Shipment Method Code" = '' THEN
//                   ShipmentMethod.INIT
//                 ELSE BEGIN
//                   ShipmentMethod.GET("Shipment Method Code");
//                   ShipmentMethod.TranslateDescription(ShipmentMethod,"Language Code");
//                 END;

//                 FormatAddr.SalesHeaderShipTo(ShipToAddr,"Sales Header");
//                 ShowShippingAddr := "Sell-to Customer No." <> "Bill-to Customer No.";
//                 FOR i := 1 TO ARRAYLEN(ShipToAddr) DO
//                   IF ShipToAddr[i] <> CustAddr[i] THEN
//                     ShowShippingAddr := TRUE;

//                 IF Print THEN BEGIN
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
//                 Print := Print OR NOT CurrReport.PREVIEW;
//                 AsmInfoExistsForLine := FALSE;
//             end;
//         }
//     }

//     requestpage
//     {
//         SaveValues = true;

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

//                         trigger OnValidate()
//                         begin
//                             IF NOT ArchiveDocument THEN
//                               LogInteraction := FALSE;
//                         end;
//                     }
//                     field(LogInteraction;LogInteraction)
//                     {
//                         Caption = 'Log Interaction';
//                         Enabled = LogInteractionEnable;

//                         trigger OnValidate()
//                         begin
//                             IF LogInteraction THEN
//                               ArchiveDocument := ArchiveDocumentEnable;
//                         end;
//                     }
//                     field(ShowAssemblyComponents;DisplayAssemblyInformation)
//                     {
//                         Caption = 'Show Assembly Components';
//                     }
//                 }
//             }
//         }

//         actions
//         {
//         }

//         trigger OnInit()
//         begin
//             LogInteractionEnable := TRUE;
//         end;

//         trigger OnOpenPage()
//         begin
//             ArchiveDocument := SalesSetup."Archive Quotes and Orders";
//             LogInteraction := SegManagement.FindInteractTmplCode(3) <> '';

//             LogInteractionEnable := LogInteraction;
//         end;
//     }

//     labels
//     {
//     }

//     trigger OnInitReport()
//     begin
//         GLSetup.GET;

//         SalesSetup.GET;

//         CASE SalesSetup."Logo Position on Documents" OF
//           SalesSetup."Logo Position on Documents"::"No Logo":
//             ;
//           SalesSetup."Logo Position on Documents"::Left:
//             BEGIN
//               CompanyInfo3.GET;
//               CompanyInfo3.CALCFIELDS(Picture);
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
//     end;

//     var
//         Text000: Label 'Salesperson';
//         Text001: Label 'Total %1';
//         Text002: Label 'Total %1 Incl. VAT';
//         Text003: Label 'COPY';
//         Text004: Label 'Order Confirmation %1';
//         PageCaptionCap: Label 'Page %1 of %2';
//         Text006: Label 'Total %1 Excl. VAT';
//         GLSetup: Record "98";
//         ShipmentMethod: Record "10";
//         PaymentTerms: Record "3";
//         PrepmtPaymentTerms: Record "3";
//         SalesPurchPerson: Record "13";
//         CompanyInfo: Record "79";
//         CompanyInfo1: Record "79";
//         CompanyInfo2: Record "79";
//         CompanyInfo3: Record "79";
//         SalesSetup: Record "311";
//         VATAmountLine: Record "290" temporary;
//         PrepmtVATAmountLine: Record "290" temporary;
//         PrepmtVATAmountLineDeduct: Record "290" temporary;
//         SalesLine: Record "37" temporary;
//         DimSetEntry1: Record "480";
//         DimSetEntry2: Record "480";
//         TempPrepmtDimSetEntry: Record "480" temporary;
//         PrepmtInvBuf: Record "461" temporary;
//         RespCenter: Record "5714";
//         Language: Record "8";
//         CurrExchRate: Record "330";
//         AsmHeader: Record "900";
//         AsmLine: Record "901";
//         SalesCountPrinted: Codeunit "313";
//         FormatAddr: Codeunit "365";
//         SegManagement: Codeunit "5051";
//         ArchiveManagement: Codeunit "5063";
//         SalesPostPrepmt: Codeunit "442";
//         DimMgt: Codeunit "408";
//         CustAddr: array [8] of Text[50];
//         ShipToAddr: array [8] of Text[50];
//         CompanyAddr: array [8] of Text[50];
//         SalesPersonText: Text[30];
//         VATNoText: Text[80];
//         ReferenceText: Text[80];
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
//         Text007: Label 'VAT Amount Specification in ';
//         Text008: Label 'Local Currency';
//         Text009: Label 'Exchange rate: %1/%2';
//         VALExchRate: Text[50];
//         PrepmtVATAmount: Decimal;
//         PrepmtVATBaseAmount: Decimal;
//         PrepmtTotalAmountInclVAT: Decimal;
//         PrepmtLineAmount: Decimal;
//         OutputNo: Integer;
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
//         Print: Boolean;
//         [InDataSet]
//         ArchiveDocumentEnable: Boolean;
//         [InDataSet]
//         LogInteractionEnable: Boolean;
//         DisplayAssemblyInformation: Boolean;
//         AsmInfoExistsForLine: Boolean;
//         InvDiscAmtCaptionLbl: Label 'Invoice Discount Amount';
//         VATRegNoCaptionLbl: Label 'VAT Registration No.';
//         GiroNoCaptionLbl: Label 'Giro No.';
//         BankCaptionLbl: Label 'Bank';
//         AccountNoCaptionLbl: Label 'Account No.';
//         ShipmentDateCaptionLbl: Label 'Shipment Date';
//         OrderNoCaptionLbl: Label 'Order No.';
//         HomePageCaptionCap: Label 'Home Page';
//         EmailCaptionLbl: Label 'E-Mail';
//         HeaderDimCaptionLbl: Label 'Header Dimensions';
//         DiscountPercentCaptionLbl: Label 'Discount %';
//         SubtotalCaptionLbl: Label 'Subtotal';
//         PaymentDiscountVATCaptionLbl: Label 'Payment Discount on VAT';
//         LineDimCaptionLbl: Label 'Line Dimensions';
//         InvDiscBaseAmtCaptionLbl: Label 'Invoice Discount Base Amount';
//         VATIdentifierCaptionLbl: Label 'VAT Identifier';
//         ShiptoAddrCaptionLbl: Label 'Ship-to Address';
//         DescriptionCaptionLbl: Label 'Description';
//         GLAccountNoCaptionLbl: Label 'G/L Account No.';
//         PrepaymentSpecCaptionLbl: Label 'Prepayment Specification';
//         PrepaymentVATAmtSpecCapLbl: Label 'Prepayment VAT Amount Specification';
//         PrepmtPmtTermsDescCaptionLbl: Label 'Prepmt. Payment Terms';
//         PhoneNoCaptionLbl: Label 'Phone No.';
//         AmountCaptionLbl: Label 'Amount';
//         VATPercentageCaptionLbl: Label 'VAT %';
//         VATBaseCaptionLbl: Label 'VAT Base';
//         VATAmtCaptionLbl: Label 'VAT Amount';
//         VATAmtSpecCaptionLbl: Label 'VAT Amount Specification';
//         LineAmtCaptionLbl: Label 'Line Amount';
//         TotalCaptionLbl: Label 'Total';
//         UnitPriceCaptionLbl: Label 'Unit Price';
//         PaymentTermsCaptionLbl: Label 'Payment Terms';
//         ShipmentMethodCaptionLbl: Label 'Shipment Method';
//         DocumentDateCaptionLbl: Label 'Document Date';
//         AllowInvDiscCaptionLbl: Label 'Allow Invoice Discount';

//     procedure InitializeRequest(NoOfCopiesFrom: Integer;ShowInternalInfoFrom: Boolean;ArchiveDocumentFrom: Boolean;LogInteractionFrom: Boolean;PrintFrom: Boolean;DisplayAsmInfo: Boolean)
//     begin
//         NoOfCopies := NoOfCopiesFrom;
//         ShowInternalInfo := ShowInternalInfoFrom;
//         ArchiveDocument := ArchiveDocumentFrom;
//         LogInteraction := LogInteractionFrom;
//         Print := PrintFrom;
//         DisplayAssemblyInformation := DisplayAsmInfo;
//     end;

//     procedure GetUnitOfMeasureDescr(UOMCode: Code[10]): Text[10]
//     var
//         UnitOfMeasure: Record "204";
//     begin
//         IF NOT UnitOfMeasure.GET(UOMCode) THEN
//           EXIT(UOMCode);
//         EXIT(UnitOfMeasure.Description);
//     end;

//     procedure BlanksForIndent(): Text[10]
//     begin
//         EXIT(PADSTR('',2,' '));
//     end;
// }

