// report 405 "Order"
// {
//     // Management Commission Report - 50013
//     // Version No.         : TJCSG1.00
//     // Developer           : DP.AYD
//     // Init. DEV. Date     : 05/08/2014
//     // Date of last Change : 06/06/2014
//     // Description         : Based on DD#205 https://dptech.mydonedone.com/issuetracker/projects/4350/issues/205
//     // 
//     // 10/04/2019 DP.NCM TJC #514, adjust left margin 2.1cm to 1.1cm
//     DefaultLayout = RDLC;
//     RDLCLayout = './Order.rdlc';

//     Caption = 'Order';
//     PreviewMode = PrintLayout;

//     dataset
//     {
//         dataitem(DataItem4458;Table38)
//         {
//             DataItemTableView = SORTING(Document Type,No.)
//                                 WHERE(Document Type=CONST(Order));
//             RequestFilterFields = "No.","Buy-from Vendor No.","No. Printed";
//             RequestFilterHeading = 'Purchase Order';
//             column(Purchase_Header_Document_Type;"Document Type")
//             {
//             }
//             column(Purchase_Header_No_;"No.")
//             {
//             }
//             dataitem(CopyLoop;Table2000000026)
//             {
//                 DataItemTableView = SORTING(Number);
//                 dataitem(PageLoop;Table2000000026)
//                 {
//                     DataItemTableView = SORTING(Number)
//                                         WHERE(Number=CONST(1));
//                     column(CompanyAddr_1_;CompanyAddr[1])
//                     {
//                     }
//                     column(Authorised_ByCaption;Authorised_ByCaptionLbl)
//                     {
//                     }
//                     column(PageLoop_Number;Number)
//                     {
//                     }
//                     dataitem(DimensionLoop1;Table2000000026)
//                     {
//                         DataItemLinkReference = "Purchase Header";
//                         DataItemTableView = SORTING(Number)
//                                             WHERE(Number=FILTER(1..));
//                         column(DimText;DimText)
//                         {
//                         }
//                         column(DimText_Control72;DimText)
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
//                               /*//TJCSG1.00
//                                                           IF NOT DocDim1.FIND('-') THEN
//                                 CurrReport.BREAK;
//                                                             */
//                             END ELSE
//                               IF NOT Continue THEN
//                                 CurrReport.BREAK;
//                             /*//TJCSG1.00
//                             CLEAR(DimText);
//                             Continue := FALSE;
//                             REPEAT
//                               OldDimText := DimText;
//                               IF DimText = '' THEN
//                                 DimText := STRSUBSTNO(
//                                   '%1 %2',DocDim1."Dimension Code",DocDim1."Dimension Value Code")
//                               ELSE
//                                 DimText :=
//                                   STRSUBSTNO(
//                                     '%1, %2 %3',DimText,
//                                     DocDim1."Dimension Code",DocDim1."Dimension Value Code");
//                               IF STRLEN(DimText) > MAXSTRLEN(OldDimText) THEN BEGIN
//                                 DimText := OldDimText;
//                                 Continue := TRUE;
//                                 EXIT;
//                               END;
//                             UNTIL (DocDim1.NEXT = 0);
//                                                     */

//                         end;

//                         trigger OnPreDataItem()
//                         begin
//                             IF NOT ShowInternalInfo THEN
//                               CurrReport.BREAK;
//                         end;
//                     }
//                     dataitem(DataItem6547;Table39)
//                     {
//                         DataItemLink = Document Type=FIELD(Document Type),
//                                        Document No.=FIELD(No.);
//                         DataItemLinkReference = "Purchase Header";
//                         DataItemTableView = SORTING(Document Type,Document No.,Line No.);

//                         trigger OnPreDataItem()
//                         begin
//                             CurrReport.BREAK;
//                         end;
//                     }
//                     dataitem(RoundLoop;Table2000000026)
//                     {
//                         DataItemTableView = SORTING(Number);
//                         column(Purchase_Line___Currency_Code_;"Purchase Line"."Currency Code")
//                         {
//                         }
//                         column(CompanyAddr_1__Control5;CompanyAddr[1])
//                         {
//                         }
//                         column(CompanyAddr_2_;CompanyAddr[2])
//                         {
//                         }
//                         column(CompanyAddr_3_;CompanyAddr[3])
//                         {
//                         }
//                         column(CompanyInfo__Phone_No__;CompanyInfo."Phone No.")
//                         {
//                         }
//                         column(BuyFromAddr_1_;BuyFromAddr[1])
//                         {
//                         }
//                         column(CompanyInfo__Fax_No__;CompanyInfo."Fax No.")
//                         {
//                         }
//                         column(BuyFromAddr_2_;BuyFromAddr[2])
//                         {
//                         }
//                         column(CompanyInfo__VAT_Registration_No__;CompanyInfo."VAT Registration No.")
//                         {
//                         }
//                         column(BuyFromAddr_3_;BuyFromAddr[3])
//                         {
//                         }
//                         column(BuyFromAddr_4_;BuyFromAddr[4])
//                         {
//                         }
//                         column(STRSUBSTNO_Text004_CopyText_;STRSUBSTNO(Text004,CopyText))
//                         {
//                         }
//                         column(BuyFromAddr_5_;BuyFromAddr[5])
//                         {
//                         }
//                         column(BuyFromAddr_6_;BuyFromAddr[6])
//                         {
//                         }
//                         column(Purchase_Header___Posting_Date_;FORMAT("Purchase Header"."Posting Date"))
//                         {
//                         }
//                         column(BuyFromAddr_7_;BuyFromAddr[7])
//                         {
//                         }
//                         column(Purchase_Header___No__;"Purchase Header"."No.")
//                         {
//                         }
//                         column(BuyFromAddr_8_;BuyFromAddr[8])
//                         {
//                         }
//                         column(Purchase_Header___Expected_Receipt_Date_;FORMAT("Purchase Header"."Expected Receipt Date"))
//                         {
//                         }
//                         column(STRSUBSTNO_Text005_FORMAT_CurrReport_PAGENO__;STRSUBSTNO(Text005,FORMAT(CurrReport.PAGENO)))
//                         {
//                         }
//                         column(SalesPurchPerson_Name;SalesPurchPerson.Name)
//                         {
//                         }
//                         column(PurchLine__Line_Amount_;PurchLine."Line Amount")
//                         {
//                             AutoFormatExpression = "Purchase Line"."Currency Code";
//                             AutoFormatType = 1;
//                         }
//                         column(Purchase_Line__Description;"Purchase Line".Description)
//                         {
//                         }
//                         column(Purchase_Line___No__;"Purchase Line"."No.")
//                         {
//                         }
//                         column(Purchase_Line__Description_Control63;"Purchase Line".Description)
//                         {
//                         }
//                         column(Purchase_Line__Quantity;"Purchase Line".Quantity)
//                         {
//                         }
//                         column(Purchase_Line___Unit_of_Measure_;"Purchase Line"."Unit of Measure")
//                         {
//                         }
//                         column(Purchase_Line___Direct_Unit_Cost_;"Purchase Line"."Direct Unit Cost")
//                         {
//                             AutoFormatExpression = "Purchase Header"."Currency Code";
//                             AutoFormatType = 2;
//                         }
//                         column(Purchase_Line___Line_Amount_;"Purchase Line"."Line Amount")
//                         {
//                             AutoFormatExpression = "Purchase Header"."Currency Code";
//                             AutoFormatType = 1;
//                         }
//                         column(Purchase_Line___Description_2_;"Purchase Line"."Description 2")
//                         {
//                         }
//                         column(Purchase_Line___Variant_Code_;"Purchase Line"."Variant Code")
//                         {
//                         }
//                         column(PurchLine__Line_Amount__Control77;PurchLine."Line Amount")
//                         {
//                             AutoFormatExpression = "Purchase Header"."Currency Code";
//                             AutoFormatType = 1;
//                         }
//                         column(TotalText;TotalText)
//                         {
//                         }
//                         column(PurchLine__Line_Amount__PurchLine__Inv__Discount_Amount_;PurchLine."Line Amount"-PurchLine."Inv. Discount Amount")
//                         {
//                             AutoFormatExpression = "Purchase Header"."Currency Code";
//                             AutoFormatType = 1;
//                         }
//                         column(TotalInclVATText;TotalInclVATText)
//                         {
//                         }
//                         column(VATAmountLine_VATAmountText;VATAmountLine.VATAmountText)
//                         {
//                         }
//                         column(VATAmount;VATAmount)
//                         {
//                             AutoFormatExpression = "Purchase Header"."Currency Code";
//                             AutoFormatType = 1;
//                         }
//                         column(PurchLine__Line_Amount__PurchLine__Inv__Discount_Amount____VATAmount;PurchLine."Line Amount"-PurchLine."Inv. Discount Amount" + VATAmount)
//                         {
//                             AutoFormatExpression = "Purchase Header"."Currency Code";
//                             AutoFormatType = 1;
//                         }
//                         column(TotalExclVATText;TotalExclVATText)
//                         {
//                         }
//                         column(PurchLine__Line_Amount__PurchLine__Inv__Discount_Amount__Control147;PurchLine."Line Amount"-PurchLine."Inv. Discount Amount")
//                         {
//                             AutoFormatExpression = "Purchase Header"."Currency Code";
//                             AutoFormatType = 1;
//                         }
//                         column(Purchase_Line___No__Caption;"Purchase Line".FIELDCAPTION("No."))
//                         {
//                         }
//                         column(Purchase_Line__Description_Control63Caption;"Purchase Line".FIELDCAPTION(Description))
//                         {
//                         }
//                         column(Unit_CostCaption;Unit_CostCaptionLbl)
//                         {
//                         }
//                         column(AmountCaption;AmountCaptionLbl)
//                         {
//                         }
//                         column(VersionCaption;VersionCaptionLbl)
//                         {
//                         }
//                         column(CompanyInfo__Phone_No__Caption;CompanyInfo__Phone_No__CaptionLbl)
//                         {
//                         }
//                         column(CompanyInfo__Fax_No__Caption;CompanyInfo__Fax_No__CaptionLbl)
//                         {
//                         }
//                         column(CompanyInfo__VAT_Registration_No__Caption;CompanyInfo__VAT_Registration_No__CaptionLbl)
//                         {
//                         }
//                         column(DATECaption;DATECaptionLbl)
//                         {
//                         }
//                         column(P_O_No_Caption;P_O_No_CaptionLbl)
//                         {
//                         }
//                         column(Exp_Delivery_DateCaption;Exp_Delivery_DateCaptionLbl)
//                         {
//                         }
//                         column(Requestor_Caption;Requestor_CaptionLbl)
//                         {
//                         }
//                         column(QTYCaption;QTYCaptionLbl)
//                         {
//                         }
//                         column(ContinuedCaption;ContinuedCaptionLbl)
//                         {
//                         }
//                         column(ContinuedCaption_Control76;ContinuedCaption_Control76Lbl)
//                         {
//                         }
//                         column(RoundLoop_Number;Number)
//                         {
//                         }
//                         dataitem(DimensionLoop2;Table2000000026)
//                         {
//                             DataItemTableView = SORTING(Number)
//                                                 WHERE(Number=FILTER(1..));
//                             column(DimText_Control74;DimText)
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
//                                 /*
//                                 //TJCSG1.00
//                                                               IF NOT DocDim2.FIND('-') THEN
//                                     CurrReport.BREAK;
//                                 */
//                                 END ELSE
//                                   IF NOT Continue THEN
//                                     CurrReport.BREAK;
//                                 /*
//                                 //TJCSG1.00

//                                 CLEAR(DimText);
//                                 Continue := FALSE;
//                                 REPEAT
//                                   OldDimText := DimText;
//                                   IF DimText = '' THEN
//                                     DimText := STRSUBSTNO(
//                                       '%1 %2',DocDim2."Dimension Code",DocDim2."Dimension Value Code")
//                                   ELSE
//                                     DimText :=
//                                       STRSUBSTNO(
//                                         '%1, %2 %3',DimText,
//                                         DocDim2."Dimension Code",DocDim2."Dimension Value Code");
//                                   IF STRLEN(DimText) > MAXSTRLEN(OldDimText) THEN BEGIN
//                                     DimText := OldDimText;
//                                     Continue := TRUE;
//                                     EXIT;
//                                   END;
//                                 UNTIL (DocDim2.NEXT = 0);
//                                 */

//                             end;

//                             trigger OnPreDataItem()
//                             begin
//                                 IF NOT ShowInternalInfo THEN
//                                   CurrReport.BREAK;
//                                 /*
//                                 //TJCSG1.00
//                                 DocDim2.SETRANGE("Table ID",DATABASE::"Purchase Line");
//                                 DocDim2.SETRANGE("Document Type","Purchase Line"."Document Type");
//                                 DocDim2.SETRANGE("Document No.","Purchase Line"."Document No.");
//                                 DocDim2.SETRANGE("Line No.","Purchase Line"."Line No.");
//                                 */

//                             end;
//                         }

//                         trigger OnAfterGetRecord()
//                         begin
//                             IF Number = 1 THEN
//                               PurchLine.FIND('-')
//                             ELSE
//                               PurchLine.NEXT;
//                             "Purchase Line" := PurchLine;

//                             IF NOT "Purchase Header"."Prices Including VAT" AND
//                                (PurchLine."VAT Calculation Type" = PurchLine."VAT Calculation Type"::"Full VAT")
//                             THEN
//                               PurchLine."Line Amount" := 0;

//                             IF (PurchLine.Type = PurchLine.Type::"G/L Account") AND (NOT ShowInternalInfo) THEN
//                               "Purchase Line"."No." := '';
//                         end;

//                         trigger OnPostDataItem()
//                         begin
//                             PurchLine.DELETEALL;
//                         end;

//                         trigger OnPreDataItem()
//                         begin
//                             MoreLines := PurchLine.FIND('+');
//                             WHILE MoreLines AND (PurchLine.Description = '') AND (PurchLine."Description 2"= '') AND
//                                   (PurchLine."No." = '') AND (PurchLine.Quantity = 0) AND
//                                   (PurchLine.Amount = 0) DO
//                               MoreLines := PurchLine.NEXT(-1) <> 0;
//                             IF NOT MoreLines THEN
//                               CurrReport.BREAK;
//                             PurchLine.SETRANGE("Line No.",0,PurchLine."Line No.");
//                             SETRANGE(Number,1,PurchLine.COUNT);
//                             CurrReport.CREATETOTALS(PurchLine."Line Amount",PurchLine."Inv. Discount Amount");
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
//                                                "Purchase Header"."Posting Date","Purchase Header"."Currency Code",
//                                                VATAmountLine."VAT Base","Purchase Header"."Currency Factor"));
//                             VALVATAmountLCY := ROUND(CurrExchRate.ExchangeAmtFCYToLCY(
//                                                  "Purchase Header"."Posting Date","Purchase Header"."Currency Code",
//                                                  VATAmountLine."VAT Amount","Purchase Header"."Currency Factor"));
//                         end;

//                         trigger OnPreDataItem()
//                         begin
//                             IF (NOT GLSetup."Print VAT specification in LCY") OR
//                                ("Purchase Header"."Currency Code"  = '') OR
//                                (VATAmountLine.GetTotalVATAmount = 0) THEN
//                               CurrReport.BREAK;

//                             SETRANGE(Number,1,VATAmountLine.COUNT);
//                             CurrReport.CREATETOTALS(VALVATBaseLCY,VALVATAmountLCY);

//                             IF GLSetup."LCY Code" = '' THEN
//                               VALSpecLCYHeader := Text007 + Text008
//                             ELSE
//                               VALSpecLCYHeader := Text007 + FORMAT(GLSetup."LCY Code");

//                             CurrExchRate.FindCurrency("Purchase Header"."Posting Date","Purchase Header"."Currency Code",1);
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
//                             IF "Purchase Header"."Buy-from Vendor No." = "Purchase Header"."Pay-to Vendor No." THEN
//                               CurrReport.BREAK;
//                         end;
//                     }
//                     dataitem(Total3;Table2000000026)
//                     {
//                         DataItemTableView = SORTING(Number)
//                                             WHERE(Number=CONST(1));

//                         trigger OnPreDataItem()
//                         begin
//                             IF ("Purchase Header"."Sell-to Customer No." = '') AND (ShipToAddr[1] = '') THEN
//                               CurrReport.BREAK;
//                         end;
//                     }
//                 }

//                 trigger OnAfterGetRecord()
//                 begin
//                     CLEAR(PurchLine);
//                     CLEAR(PurchPost);
//                     PurchLine.DELETEALL;
//                     VATAmountLine.DELETEALL;
//                     PurchPost.GetPurchLines("Purchase Header",PurchLine,0);
//                     PurchLine.CalcVATAmountLines(0,"Purchase Header",PurchLine,VATAmountLine);
//                     PurchLine.UpdateVATOnLines(0,"Purchase Header",PurchLine,VATAmountLine);
//                     VATAmount := VATAmountLine.GetTotalVATAmount;
//                     VATBaseAmount := VATAmountLine.GetTotalVATBase;
//                     VATDiscountAmount :=
//                       VATAmountLine.GetTotalVATDiscount("Purchase Header"."Currency Code","Purchase Header"."Prices Including VAT");
//                     TotalAmountInclVAT := VATAmountLine.GetTotalAmountInclVAT;

//                     IF Number > 1 THEN
//                       CopyText := Text003;
//                     CurrReport.PAGENO := 1;
//                 end;

//                 trigger OnPostDataItem()
//                 begin
//                     /*
//                     //TJCSG1.00
//                     IF NOT CurrReport.PREVIEW THEN
//                       PurchCountPrinted.RUN("Purchase Header");
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
//             begin
//                 CurrReport.LANGUAGE := Language.GetLanguageID("Language Code");

//                 CompanyInfo.GET;

//                 IF RespCenter.GET("Responsibility Center") THEN BEGIN
//                   FormatAddr.RespCenter(CompanyAddr,RespCenter);
//                   CompanyInfo."Phone No." := RespCenter."Phone No.";
//                   CompanyInfo."Fax No." := RespCenter."Fax No.";
//                 END ELSE
//                   FormatAddr.Company(CompanyAddr,CompanyInfo);
//                 /*//TJCSG1.00
//                 DocDim1.SETRANGE("Table ID",DATABASE::"Purchase Header");
//                 DocDim1.SETRANGE("Document Type","Purchase Header"."Document Type");
//                 DocDim1.SETRANGE("Document No.","Purchase Header"."No.");
//                 */
//                 IF "Purchaser Code" = '' THEN BEGIN
//                   SalesPurchPerson.INIT;
//                   PurchaserText := '';
//                 END ELSE BEGIN
//                   SalesPurchPerson.GET("Purchaser Code");
//                   PurchaserText := Text000
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

//                 FormatAddr.PurchHeaderBuyFrom(BuyFromAddr,"Purchase Header");
//                 IF ("Purchase Header"."Buy-from Vendor No." <> "Purchase Header"."Pay-to Vendor No.") THEN
//                   FormatAddr.PurchHeaderPayTo(VendAddr,"Purchase Header");
//                 IF "Payment Terms Code" = '' THEN
//                   PaymentTerms.INIT
//                 ELSE
//                   PaymentTerms.GET("Payment Terms Code");
//                 IF "Shipment Method Code" = '' THEN
//                   ShipmentMethod.INIT
//                 ELSE
//                   ShipmentMethod.GET("Shipment Method Code");

//                 FormatAddr.PurchHeaderShipTo(ShipToAddr,"Purchase Header");

//                 /*
//                 //TJCSG1.00
//                 IF NOT CurrReport.PREVIEW THEN BEGIN
//                   IF ArchiveDocument THEN
//                     ArchiveManagement.StorePurchDocument("Purchase Header",LogInteraction);

//                   IF LogInteraction THEN BEGIN
//                     CALCFIELDS("No. of Archived Versions");
//                     SegManagement.LogDocument(
//                       13,"No.","Doc. No. Occurrence","No. of Archived Versions",DATABASE::Vendor,"Buy-from Vendor No.",
//                       "Purchaser Code",'',"Posting Description",'');
//                   END;
//                 END;
//                 */

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
//                     }
//                 }
//             }
//         }

//         actions
//         {
//         }

//         trigger OnOpenPage()
//         begin
//             /*ArchiveDocument := ArchiveManagement.PurchaseDocArchiveGranule;
//             LogInteraction := SegManagement.FindInteractTmplCode(13) <> '';

//             RequestOptionsPage.ArchiveDocument.ENABLED(ArchiveDocument);
//             RequestOptionsPage.LogInteraction.ENABLED(LogInteraction);
//              */

//         end;
//     }

//     labels
//     {
//     }

//     trigger OnInitReport()
//     begin
//         GLSetup.GET;
//     end;

//     var
//         Text000: Label 'Purchaser';
//         Text001: Label 'Total %1';
//         Text002: Label 'Total %1 Incl. GST';
//         Text003: Label 'COPY';
//         Text004: Label 'PURCHASE ORDER %1';
//         Text005: Label 'Page %1';
//         Text006: Label 'Total %1 Excl. GST';
//         GLSetup: Record "98";
//         CompanyInfo: Record "79";
//         ShipmentMethod: Record "10";
//         PaymentTerms: Record "3";
//         SalesPurchPerson: Record "13";
//         VATAmountLine: Record "290" temporary;
//         PurchLine: Record "39" temporary;
//         RespCenter: Record "5714";
//         Language: Record "8";
//         CurrExchRate: Record "330";
//         PurchCountPrinted: Codeunit "317";
//         FormatAddr: Codeunit "365";
//         PurchPost: Codeunit "90";
//         ArchiveManagement: Codeunit "5063";
//         SegManagement: Codeunit "5051";
//         VendAddr: array [8] of Text[50];
//         ShipToAddr: array [8] of Text[50];
//         CompanyAddr: array [8] of Text[50];
//         BuyFromAddr: array [8] of Text[50];
//         PurchaserText: Text[30];
//         VATNoText: Text[30];
//         ReferenceText: Text[30];
//         TotalText: Text[50];
//         TotalInclVATText: Text[50];
//         TotalExclVATText: Text[50];
//         MoreLines: Boolean;
//         NoOfCopies: Integer;
//         NoOfLoops: Integer;
//         CopyText: Text[30];
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
//         Text007: Label 'GST Amount Specification in ';
//         Text008: Label 'Local Currency';
//         Text009: Label 'Exchange rate: %1/%2';
//         Authorised_ByCaptionLbl: Label 'Authorised By';
//         Header_DimensionsCaptionLbl: Label 'Header Dimensions';
//         Unit_CostCaptionLbl: Label 'Unit Cost';
//         AmountCaptionLbl: Label 'Amount';
//         VersionCaptionLbl: Label 'Version';
//         CompanyInfo__Phone_No__CaptionLbl: Label 'Phone No.';
//         CompanyInfo__Fax_No__CaptionLbl: Label 'Fax No.';
//         CompanyInfo__VAT_Registration_No__CaptionLbl: Label 'GST Reg. No.';
//         DATECaptionLbl: Label 'DATE';
//         P_O_No_CaptionLbl: Label 'P/O No.';
//         Exp_Delivery_DateCaptionLbl: Label 'Exp.Delivery Date';
//         Requestor_CaptionLbl: Label 'Requestor:';
//         QTYCaptionLbl: Label 'QTY';
//         ContinuedCaptionLbl: Label 'Continued';
//         ContinuedCaption_Control76Lbl: Label 'Continued';
//         Line_DimensionsCaptionLbl: Label 'Line Dimensions';
// }

