// report 50037 "Transfer Order TJC"
// {
//     // //TJC#434
//     DefaultLayout = RDLC;
//     RDLCLayout = './Transfer Order TJC.rdlc';

//     Caption = 'Transfer Order';

//     dataset
//     {
//         dataitem(DataItem2957;Table5740)
//         {
//             DataItemTableView = SORTING(No.);
//             RequestFilterFields = "No.","Transfer-from Code","Transfer-to Code";
//             RequestFilterHeading = 'Transfer Order';
//             column(No_TransferHdr;"No.")
//             {
//             }
//             dataitem(CopyLoop;Table2000000026)
//             {
//                 DataItemTableView = SORTING(Number);
//                 dataitem(PageLoop;Table2000000026)
//                 {
//                     DataItemTableView = SORTING(Number)
//                                         WHERE(Number=CONST(1));
//                     column(CopyCaption;STRSUBSTNO(Text001,CopyText))
//                     {
//                     }
//                     column(TransferToAddr1;TransferToAddr[1])
//                     {
//                     }
//                     column(TransferFromAddr1;TransferFromAddr[1])
//                     {
//                     }
//                     column(TransferToAddr2;TransferToAddr[2])
//                     {
//                     }
//                     column(TransferFromAddr2;TransferFromAddr[2])
//                     {
//                     }
//                     column(TransferToAddr3;TransferToAddr[3])
//                     {
//                     }
//                     column(TransferFromAddr3;TransferFromAddr[3])
//                     {
//                     }
//                     column(TransferToAddr4;TransferToAddr[4])
//                     {
//                     }
//                     column(TransferFromAddr4;TransferFromAddr[4])
//                     {
//                     }
//                     column(TransferToAddr5;TransferToAddr[5])
//                     {
//                     }
//                     column(TransferToAddr6;TransferToAddr[6])
//                     {
//                     }
//                     column(InTransitCode_TransHdr;"Transfer Header"."In-Transit Code")
//                     {
//                         IncludeCaption = true;
//                     }
//                     column(PostingDate_TransHdr;FORMAT("Transfer Header"."Posting Date",0,4))
//                     {
//                     }
//                     column(TransferToAddr7;TransferToAddr[7])
//                     {
//                     }
//                     column(TransferToAddr8;TransferToAddr[8])
//                     {
//                     }
//                     column(TransferFromAddr5;TransferFromAddr[5])
//                     {
//                     }
//                     column(TransferFromAddr6;TransferFromAddr[6])
//                     {
//                     }
//                     column(PageCaption;STRSUBSTNO(Text002,''))
//                     {
//                     }
//                     column(OutputNo;OutputNo)
//                     {
//                     }
//                     column(ShptMethodDesc;ShipmentMethod.Description)
//                     {
//                     }
//                     column(ExtDocNo;"Transfer Header"."External Document No.")
//                     {
//                     }
//                     dataitem(DimensionLoop1;Table2000000026)
//                     {
//                         DataItemLinkReference = "Transfer Header";
//                         DataItemTableView = SORTING(Number)
//                                             WHERE(Number=FILTER(1..));
//                         column(DimText;DimText)
//                         {
//                         }
//                         column(Number_DimensionLoop1;Number)
//                         {
//                         }
//                         column(HdrDimensionsCaption;HdrDimensionsCaptionLbl)
//                         {
//                         }

//                         trigger OnAfterGetRecord()
//                         begin
//                             IF Number = 1 THEN BEGIN
//                               IF NOT DimSetEntry1.FINDSET THEN
//                                 CurrReport.BREAK;
//                             END ELSE
//                               IF NOT Continue THEN
//                                 CurrReport.BREAK;

//                             CLEAR(DimText);
//                             Continue := FALSE;
//                             REPEAT
//                               OldDimText := DimText;
//                               IF DimText = '' THEN
//                                 DimText := STRSUBSTNO('%1 - %2',DimSetEntry1."Dimension Code",DimSetEntry1."Dimension Value Code")
//                               ELSE
//                                 DimText :=
//                                   STRSUBSTNO(
//                                     '%1; %2 - %3',DimText,
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
//                     dataitem(DataItem9370;Table5741)
//                     {
//                         DataItemLink = Document No.=FIELD(No.);
//                         DataItemLinkReference = "Transfer Header";
//                         DataItemTableView = SORTING(Document No.,Line No.)
//                                             WHERE(Derived From Line No.=CONST(0));
//                         column(seqNo;seqNo)
//                         {
//                         }
//                         column(ItemNo_TransLine;"Item No.")
//                         {
//                             IncludeCaption = true;
//                         }
//                         column(Desc_TransLine;Description)
//                         {
//                             IncludeCaption = true;
//                         }
//                         column(Unit_Price;varUnitPrice)
//                         {
//                         }
//                         column(Qty_TransLine;Quantity)
//                         {
//                             IncludeCaption = true;
//                         }
//                         column(UOM_TransLine;"Unit of Measure")
//                         {
//                             IncludeCaption = true;
//                         }
//                         column(Qty_TransLineShipped;"Quantity Shipped")
//                         {
//                             IncludeCaption = true;
//                         }
//                         column(QtyReceived_TransLine;"Quantity Received")
//                         {
//                             IncludeCaption = true;
//                         }
//                         column(TransFromBinCode_TransLine;"Transfer-from Bin Code")
//                         {
//                             IncludeCaption = true;
//                         }
//                         column(TransToBinCode_TransLine;"Transfer-To Bin Code")
//                         {
//                             IncludeCaption = true;
//                         }
//                         column(LineNo_TransLine;"Line No.")
//                         {
//                         }
//                         dataitem(DimensionLoop2;Table2000000026)
//                         {
//                             DataItemTableView = SORTING(Number)
//                                                 WHERE(Number=FILTER(1..));
//                             column(DimText2;DimText)
//                             {
//                             }
//                             column(Number_DimensionLoop2;Number)
//                             {
//                             }
//                             column(LineDimensionsCaption;LineDimensionsCaptionLbl)
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
//                                     DimText := STRSUBSTNO('%1 - %2',DimSetEntry2."Dimension Code",DimSetEntry2."Dimension Value Code")
//                                   ELSE
//                                     DimText :=
//                                       STRSUBSTNO(
//                                         '%1; %2 - %3',DimText,
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
//                             end;
//                         }

//                         trigger OnAfterGetRecord()
//                         begin
//                             DimSetEntry2.SETRANGE("Dimension Set ID","Dimension Set ID");

//                             IF "Transfer Line"."Item No." <>'' THEN
//                               seqNo += 1;
//                             CLEAR(varUnitPrice);
//                             recItem.RESET;
//                             recItem.SETRANGE("No.","Item No.");
//                             IF recItem.FINDFIRST THEN
//                               varUnitPrice := recItem."Unit Price";

//                             //TJC#434
//                             recItemUOM.RESET;
//                             recItemUOM.SETRANGE("Item No.","Item No.");
//                             recItemUOM.SETRANGE(Code,"Unit of Measure Code");
//                             IF recItemUOM.FINDFIRST THEN
//                               varUnitPrice := varUnitPrice * recItemUOM."Qty. per Unit of Measure";
//                             //TJC#434
//                         end;

//                         trigger OnPreDataItem()
//                         begin
//                             seqNo := 0;
//                         end;
//                     }
//                 }

//                 trigger OnAfterGetRecord()
//                 begin
//                     IF Number > 1 THEN BEGIN
//                       CopyText := Text000;
//                       OutputNo += 1;
//                     END;
//                     CurrReport.PAGENO := 1;
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
//                 DimSetEntry1.SETRANGE("Dimension Set ID","Dimension Set ID");
//                 FormatAddr.TransferHeaderTransferFrom(TransferFromAddr,"Transfer Header");
//                 FormatAddr.TransferHeaderTransferTo(TransferToAddr,"Transfer Header");

//                 IF NOT ShipmentMethod.GET("Shipment Method Code") THEN
//                   ShipmentMethod.INIT;
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
//                 }
//             }
//         }

//         actions
//         {
//         }
//     }

//     labels
//     {
//         PostingDateCaption = 'Posting Date';
//         ShptMethodDescCaption = 'Shipment Method';
//     }

//     var
//         Text000: Label 'COPY';
//         Text001: Label 'Transfer Order %1';
//         Text002: Label 'Page %1';
//         ShipmentMethod: Record "10";
//         DimSetEntry1: Record "480";
//         DimSetEntry2: Record "480";
//         FormatAddr: Codeunit "365";
//         TransferFromAddr: array [8] of Text[50];
//         TransferToAddr: array [8] of Text[50];
//         NoOfCopies: Integer;
//         NoOfLoops: Integer;
//         CopyText: Text[30];
//         DimText: Text[120];
//         OldDimText: Text[75];
//         ShowInternalInfo: Boolean;
//         Continue: Boolean;
//         OutputNo: Integer;
//         HdrDimensionsCaptionLbl: Label 'Header Dimensions';
//         LineDimensionsCaptionLbl: Label 'Line Dimensions';
//         seqNo: Integer;
//         varUnitPrice: Decimal;
//         recItem: Record "27";
//         recItemUOM: Record "5404";
// }

