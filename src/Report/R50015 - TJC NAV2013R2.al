// report 50015 "Posted Sale Invoice2"
// {
//     // Version No.          : TJCSG1.00
//     // Deverloper           : DP.NDN
//     // Date of Last Change  : 22/10/2014
//     DefaultLayout = RDLC;
//     RDLCLayout = './Posted Sale Invoice2.rdlc';


//     dataset
//     {
//         dataitem(DataItem1000000000;Table112)
//         {
//             column(Sales_Header_No_;"Sales Invoice Header"."No.")
//             {
//             }
//             column(STRSUBSTNO_Text004_CopyText_;STRSUBSTNO(Text004,CopyText))
//             {
//             }
//             column(STRSUBSTNO_Text005_FORMAT_CurrReport_PAGENO__;STRSUBSTNO(Text005,FORMAT(CurrReport.PAGENO)))
//             {
//             }
//             column(CompanyInfo1_Picture;CompanyInfo1.Picture)
//             {
//             }
//             column(CustAddr_1_;CustAddr[1])
//             {
//             }
//             column(CustAddr_2_;CustAddr[2])
//             {
//             }
//             column(CustAddr_3_;CustAddr[3])
//             {
//             }
//             column(CustAddr_4_;CustAddr[4])
//             {
//             }
//             column(CustAddr_5_;CustAddr[5])
//             {
//             }
//             column(Sales_Header___Ship_to_Address_;"Sales Invoice Header"."Ship-to Address")
//             {
//             }
//             column(Sales_Header___Ship_to_Address_2_;"Sales Invoice Header"."Ship-to Address 2")
//             {
//             }
//             column(Sales_Header___No__;"Sales Invoice Header"."No.")
//             {
//             }
//             column(Sales_Header___Posting_Date_;"Sales Invoice Header"."Posting Date")
//             {
//             }
//             column(Sales_Header___External_Document_No__;"Sales Invoice Header"."External Document No.")
//             {
//             }
//             column(Sales_Header___Payment_Terms_Code_;"Sales Invoice Header"."Payment Terms Code")
//             {
//             }
//             column(TotalExclVATText;TotalExclVATText)
//             {
//             }
//             column(VATAmount;VATAmount)
//             {
//             }
//             column(TotalInclVATText;TotalInclVATText)
//             {
//             }
//             column(VATAmountLine_VATAmountText;VATAmountLine.VATAmountText)
//             {
//             }
//             column(Sales_Header___Bill_to_Customer_No____________Sales_Header___Salesperson_Code_;"Sales Invoice Header"."Bill-to Customer No."+'/'+"Sales Invoice Header"."Salesperson Code")
//             {
//             }
//             dataitem(DataItem1000000017;Table113)
//             {
//                 DataItemLink = Document No.=FIELD(No.);
//                 column(SalesLine__Line_Amount_;SalesLine."Line Amount")
//                 {
//                 }
//                 column(Sales_Line__Description;SalesLine.Description)
//                 {
//                 }
//                 column(Sales_Line___No___;"Sales Invoice Line"."No.")
//                 {
//                 }
//                 column(SerialNo2;SerialNo2)
//                 {
//                 }
//                 column(Sales_Line__Quantity;"Sales Invoice Line".Quantity)
//                 {
//                 }
//                 column(SalesLine__Unit_of_Measure_Code_;"Sales Invoice Line"."Unit of Measure Code")
//                 {
//                 }
//                 column(Sales_Line___Unit_Price_;"Sales Invoice Line"."Unit Price")
//                 {
//                 }
//                 column(Sales_Line___Line_Amount_;"Sales Invoice Line"."Line Amount")
//                 {
//                 }
//                 column(SalesLine_Description_______SalesLine__Description_2_;"Sales Invoice Line".Description+' '+"Sales Invoice Line"."Description 2")
//                 {
//                 }
//                 column(ItemTracking__Lot_No__;ItemTracking__Lot_No__)
//                 {
//                 }
//                 column(Sales_Line___Return_Reason_Code_;"Sales Invoice Line"."Return Reason Code")
//                 {
//                 }
//                 column(SalesLine__Line_Discount___;"Sales Invoice Line"."Line Discount %")
//                 {
//                 }
//                 column(rItem__Shelf_No__;"vShelfNo.")
//                 {
//                 }
//                 column(ItemEng;ItemEng)
//                 {
//                 }
//                 column(SalesLine__Line_Amount__Control84;SalesLine."Line Amount")
//                 {
//                 }
//                 column(SalesLine__Inv__Discount_Amount_;-SalesLine."Inv. Discount Amount")
//                 {
//                 }
//                 column(ContinuedCaptionLbl;ContinuedCaptionLbl)
//                 {
//                 }
//                 column(DPVATAmount;DPVATAmount)
//                 {
//                 }
//                 column(DPSalesLineSellto;DPSalesLineSellto)
//                 {
//                 }
//                 column(SerialNo;SerialNo)
//                 {
//                 }
//                 column(vAmountHeader;vAmountHeader)
//                 {
//                 }
//                 column(vAmountFooter;vAmountFooter)
//                 {
//                 }
//                 column(vTotalLineAmount;vTotalLineAmount)
//                 {
//                 }
//                 column(vTotalDiscountAmount;vTotalDiscountAmount)
//                 {
//                 }

//                 trigger OnAfterGetRecord()
//                 var
//                     EntryNo: Integer;
//                 begin
//                     CLEAR(rItem);
//                     CLEAR(ItemEng);
//                     IF (Type = Type::"G/L Account") THEN
//                       BEGIN
//                         "No.":='';
//                         "vShelfNo.":='';
//                       END;
//                     IF (Type = Type::Item) THEN
//                     BEGIN
//                        IF rItem.GET("No.") THEN
//                           "vShelfNo.":=rItem."Shelf No."
//                        ELSE
//                            "vShelfNo.":='';
//                     END;
//                     //"vShelfNo.":='Test';
//                     //Item Enghlish
//                     ItemEng:=GetEnglishName("No.");
//                       //MESSAGE(ItemEng);
//                      //Number
//                     //IF ("Sales Invoice Line"."Line No."=30000) THEN
//                     //  MESSAGE(FORMAT(SerialNo));

//                     IF Quantity <> 0 THEN
//                     SerialNo:= SerialNo + 1;
//                      // Tinh Amount Header
//                     vAmountFooter:=vAmountFooter+ "Sales Invoice Line"."Line Amount";
//                     vAmountHeader:=vAmountFooter;
//                     DPVATAmount := SalesLine."Amount Including VAT"-SalesLine.Amount;
//                     // Itemtrack
//                     TempItemTrack__Lot_No__:='';
//                     ItemTracking__Lot_No__:='';

//                     //Get Item Tracking Lines
//                     TempItemTrack.DELETEALL;
//                     CLEAR(ItemTracking);
//                     EntryNo := 1;
//                     ItemTracking.SETRANGE(ItemTracking."Source ID","Sales Invoice Line"."Document No.");
//                     ItemTracking.SETRANGE(ItemTracking."Item No.","Sales Invoice Line"."No." );
//                     ItemTracking.SETRANGE(ItemTracking."Source Ref. No.","Sales Invoice Line"."Line No."); //SWJ
//                     IF ItemTracking.FIND('-') THEN BEGIN
//                       ItemTracking__Lot_No__:=ItemTracking."Lot No.";
//                       TotalLot := ItemTracking.COUNT;
//                       IF TotalLot > 1 THEN
//                       REPEAT

//                         TempItemTrack.SETCURRENTKEY("Item No.","Variant Code","Location Code","Reservation Status",
//                                                     "Shipment Date","Expected Receipt Date","Serial No.","Lot No.");
//                         TempItemTrack.SETRANGE("Item No.","Sales Invoice Line"."No.");
//                         TempItemTrack.SETRANGE("Lot No.",ItemTracking."Lot No.");
//                         IF NOT TempItemTrack.FIND('-') THEN
//                         BEGIN

//                           TempItemTrack.INIT;
//                           TempItemTrack."Entry No." := EntryNo;
//                           TempItemTrack."Item No."  := "Sales Invoice Line"."No.";
//                           TempItemTrack."Lot No."   := ItemTracking."Lot No.";
//                           InsertTempTracking(EntryNo);
//                           /*
//                           IF NOT TempItemTrack.INSERT THEN BEGIN
//                             EntryNo += 1;
//                             TempItemTrack."Entry No." := EntryNo;
//                             TempItemTrack.INSERT;
//                           END;
//                           */

//                           EntryNo += 1;
//                         END;
//                         TempItemTrack__Lot_No__+=ItemTracking."Lot No."+DPEnter;
//                       UNTIL ItemTracking.NEXT = 0;

//                       TempItemTrack.RESET;
//                       TempItemTrack.SETFILTER("Entry No.",'%1',1);
//                       IF TempItemTrack.FIND('-') THEN TempItemTrack.DELETE;
//                     END;
//                     IF DPTrim(TempItemTrack__Lot_No__)<>'' THEN
//                       ItemTracking__Lot_No__:=TempItemTrack__Lot_No__;

//                 end;
//             }
//             dataitem(ItemTrackLines;Table2000000026)
//             {
//                 DataItemTableView = SORTING(Number);
//                 column(ItemTrackLines_Number;Number)
//                 {
//                 }

//                 trigger OnAfterGetRecord()
//                 begin
//                     IF Number = 1 THEN BEGIN
//                       IF NOT TempItemTrack.FIND('-') THEN
//                         CurrReport.BREAK;

//                     END  ELSE

//                     BEGIN
//                      IF TempItemTrack.NEXT = 0 THEN
//                        CurrReport.BREAK;

//                     END;
//                 end;

//                 trigger OnPreDataItem()
//                 begin
//                     CurrReport.SKIP;
//                     TempItemTrack.RESET;
//                     SETRANGE(Number,1,TempItemTrack.COUNT);
//                 end;
//             }

//             trigger OnAfterGetRecord()
//             begin
//                 CLEAR(SerialNo);
//                 CLEAR(vTotalDiscountAmount);
//                 //VATAmount := VATAmountLine.GetTotalVATAmount;
//                 // Lay dia chi
//                 FormatAddr.SalesInvBillTo(CustAddr,"Sales Invoice Header");

//                 IF "Payment Terms Code" = '' THEN
//                   PaymentTerms.INIT
//                 ELSE
//                   PaymentTerms.GET("Payment Terms Code");
//                 IF "Shipment Method Code" = '' THEN
//                   ShipmentMethod.INIT
//                 ELSE
//                   ShipmentMethod.GET("Shipment Method Code");

//                 FormatAddr.SalesInvShipTo(ShipToAddr,"Sales Invoice Header");
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
//                 ShowShippingAddr := "Sell-to Customer No." <> "Bill-to Customer No.";
//                 FOR i := 1 TO ARRAYLEN(ShipToAddr) DO
//                   IF ShipToAddr[i] <> CustAddr[i] THEN
//                     ShowShippingAddr := TRUE;
//                 // MESSAGE(CustAddr[1]);
//                 //MESSAGE("Sales Invoice Header"."No.");
//                 rSIL.RESET;
//                 rSIL.SETRANGE(rSIL."Document No.","Sales Invoice Header"."No.");
//                 IF rSIL.FINDFIRST THEN
//                   REPEAT
//                     VATAmount := VATAmount + (rSIL."VAT %"*rSIL."Line Amount"/100);
//                     vTotalDiscountAmount += rSIL."Inv. Discount Amount";
//                   UNTIL rSIL.NEXT=0;
//             end;
//         }
//     }

//     requestpage
//     {

//         layout
//         {
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
//             GLSetup.GET;
//         CompanyInfo.GET;
//     end;

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
//         SalesLine: Record "113" temporary;
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
//         rItem: Record "27";
//         "/* DP VARS * /": Integer;
//         DimSetEntry1: Record "480";
//         DimSetEntry2: Record "480";
//         DPVATAmount: Decimal;
//         DPSalesLineSellto: Text;
//         TempItemTrack__Lot_No__: Text;
//         ItemTracking__Lot_No__: Text;
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
//         Ship_toCaptionLbl: Label 'Ship-to';
//         Header_DimensionsCaptionLbl: Label 'Header Dimensions';
//         ContinuedCaptionLbl: Label 'Continued';
//         ContinuedCaption_Control83Lbl: Label 'Continued';
//         DISCOUNTCaptionLbl: Label 'DISCOUNT';
//         SUB_TOTALCaptionLbl: Label 'SUB-TOTAL';
//         Line_DimensionsCaptionLbl: Label 'Line Dimensions';
//         vAmountHeader: Decimal;
//         vAmountFooter: Decimal;
//         vTotalLineAmount: Decimal;
//         rSIL: Record "113";
//         "vShelfNo.": Code[10];
//         vTotalDiscountAmount: Decimal;

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

