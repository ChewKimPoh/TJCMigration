// report 50002 "Picking List report"
// {
//     // // wcw - 270308 to skip if "No Picking List" is true
//     // 
//     // 
//     // Picking List report - 50002
//     // Version No.         : TJCSG1.00
//     // Developer           : DP.AYD
//     // Init. DEV. Date     : 28/05/2014
//     // Date of last Change : 28/05/2014
//     // Description         : Based on DD#121 https://dptech.mydonedone.com/issuetracker/projects/4350/issues/121
//     DefaultLayout = RDLC;
//     RDLCLayout = './Picking List report.rdlc';

//     PreviewMode = PrintLayout;

//     dataset
//     {
//         dataitem(DataItem8129;Table27)
//         {
//             DataItemTableView = SORTING(Shelf No.)
//                                 ORDER(Ascending);
//             PrintOnlyIfDetail = false;
//             column(USERID;USERID)
//             {
//             }
//             column(PostDate;PostDate)
//             {
//             }
//             column(CurrReport_PAGENO;CurrReport.PAGENO)
//             {
//             }
//             column(TODAY;TODAY)
//             {
//             }
//             column(QUANTITYCaption;QUANTITYCaptionLbl)
//             {
//             }
//             column(BIN_CODECaption;BIN_CODECaptionLbl)
//             {
//             }
//             column(ITEM_DESCRIPTIONCaption;ITEM_DESCRIPTIONCaptionLbl)
//             {
//             }
//             column(ITEM_NOCaption;ITEM_NOCaptionLbl)
//             {
//             }
//             column(DOCUMENT_NOCaption;DOCUMENT_NOCaptionLbl)
//             {
//             }
//             column(PICKING_LISTCaption;PICKING_LISTCaptionLbl)
//             {
//             }
//             column(Shipment_DateCaption;Shipment_DateCaptionLbl)
//             {
//             }
//             column(CUSTOMERCaption;CUSTOMERCaptionLbl)
//             {
//             }
//             column(PageCaption;PageCaptionLbl)
//             {
//             }
//             column(PrintedCaption;PrintedCaptionLbl)
//             {
//             }
//             column(Tong_Jum_Chew_Pte_LtdCaption;Tong_Jum_Chew_Pte_LtdCaptionLbl)
//             {
//             }
//             column(Item_No_;"No.")
//             {
//             }
//             column(Item_Shelf_No_;"Shelf No.")
//             {
//             }
//             dataitem(DataItem2844;Table37)
//             {
//                 DataItemLink = No.=FIELD(No.);
//                 DataItemTableView = SORTING(Document Type,No.,Unit of Measure Code)
//                                     ORDER(Ascending)
//                                     WHERE(Qty. to Ship=FILTER(>0));
//                 PrintOnlyIfDetail = false;
//                 RequestFilterFields = "Document Type","Document No.","Location Code";
//                 column(Sales_Line__Sales_Line___Unit_of_Measure_Code_;"Sales Line"."Unit of Measure Code")
//                 {
//                 }
//                 column(Sales_Line__Sales_Line___Qty__to_Ship_;"Sales Line"."Qty. to Ship")
//                 {
//                 }
//                 column(Sales_Line__Sales_Line___Bin_Code_;"Sales Line"."Bin Code")
//                 {
//                 }
//                 column(Sales_Line__Description____________Sales_Line___Description_2__;"Sales Line".Description  + '  ' + "Sales Line"."Description 2" )
//                 {
//                 }
//                 column(Sales_Line__Sales_Line___No__;"Sales Line"."No.")
//                 {
//                 }
//                 column(Sales_Line__Sales_Line___Document_No__;"Sales Line"."Document No.")
//                 {
//                 }
//                 column(Sales_Line__Sales_Line___Sell_to_Customer_No__;"Sales Line"."Sell-to Customer No.")
//                 {
//                 }
//                 column(Shelf_No_______Item__Shelf_No__;'Shelf No : '+  Item."Shelf No.")
//                 {
//                 }
//                 column(Sales_Line__Description____________Sales_Line___Description_2___Control1000000025;"Sales Line".Description  + '  ' + "Sales Line"."Description 2" )
//                 {
//                 }
//                 column(Sales_Line__Sales_Line___No___Control1000000026;"Sales Line"."No.")
//                 {
//                 }
//                 column(Sales_Line__Sales_Line___Unit_of_Measure_Code__Control1000000027;"Sales Line"."Unit of Measure Code")
//                 {
//                 }
//                 column(Sales_Line__Sales_Line___Qty__to_Ship__Control1000000028;"Sales Line"."Qty. to Ship")
//                 {
//                 }
//                 column(TotalFor___FIELDCAPTION__No___;TotalFor + FIELDCAPTION("No."))
//                 {
//                 }
//                 column(Sales_Line__Qty__to_Ship_;"Qty. to Ship")
//                 {
//                 }
//                 column(TotalFor___FIELDCAPTION__Document_Type__;TotalFor + FIELDCAPTION("Document Type"))
//                 {
//                 }
//                 column(Sales_Line__Qty__to_Ship__Control1000000042;"Qty. to Ship")
//                 {
//                 }
//                 column(TOTALCaption;TOTALCaptionLbl)
//                 {
//                 }
//                 column(Sales_Line_Document_Type;"Document Type")
//                 {
//                 }
//                 column(Sales_Line_Line_No_;"Line No.")
//                 {
//                 }
//                 dataitem("Reservation Entry";Table337)
//                 {
//                     DataItemLink = Source ID=FIELD(Document No.),
//                                    Item No.=FIELD(No.),
//                                    Source Ref. No.=FIELD(Line No.);
//                     column(Reservation_Entry__Reservation_Entry___Expiration_Date_;"Reservation Entry"."Expiration Date")
//                     {
//                     }
//                     column(Reservation_Entry__Reservation_Entry___Lot_No__;"Reservation Entry"."Lot No.")
//                     {
//                     }
//                     column(Sales_Line___Unit_of_Measure_;"Sales Line"."Unit of Measure")
//                     {
//                     }
//                     column(Sales_Line___Qty__to_Ship_;"Sales Line"."Qty. to Ship")
//                     {
//                     }
//                     column(Lot_QtyCaption;Lot_QtyCaptionLbl)
//                     {
//                     }
//                     column(Exp_DateCaption;Exp_DateCaptionLbl)
//                     {
//                     }
//                     column(Lot_No_Caption;Lot_No_CaptionLbl)
//                     {
//                     }
//                     column(Reservation_Entry_Entry_No_;"Entry No.")
//                     {
//                     }
//                     column(Reservation_Entry_Positive;Positive)
//                     {
//                     }
//                     column(Reservation_Entry_Source_ID;"Source ID")
//                     {
//                     }
//                     column(Reservation_Entry_Item_No_;"Item No.")
//                     {
//                     }
//                     column(Reservation_Entry_Source_Ref__No_;"Source Ref. No.")
//                     {
//                     }
//                     column(DisplayQty;vDisplayQty)
//                     {
//                     }

//                     trigger OnAfterGetRecord()
//                     begin
//                         IF ("Sales Line"."Unit of Measure Code" <> Item."Base Unit of Measure") THEN
//                         BEGIN
//                           rIUOM.RESET;
//                           rIUOM.SETRANGE("Item No.",Item."No.");
//                           rIUOM.SETRANGE(Code,"Sales Line"."Unit of Measure Code");
//                           IF rIUOM.FINDFIRST THEN
//                             vDisplayQty := -"Quantity (Base)" / rIUOM."Qty. per Unit of Measure";
//                         END ELSE
//                           vDisplayQty := -"Quantity (Base)";
//                     end;
//                 }

//                 trigger OnAfterGetRecord()
//                 begin
//                     CLEAR(vDisplayQty);
//                     IF SalesHeader.GET("Document Type","Document No.") THEN
//                     BEGIN
//                       IF DocStatus = DocStatus::Open THEN BEGIN
//                         IF SalesHeader.Status = SalesHeader.Status::Released THEN
//                            CurrReport.SKIP;
//                       END;

//                       IF DocStatus = DocStatus::Released THEN BEGIN
//                         IF SalesHeader.Status = SalesHeader.Status::Open THEN
//                            CurrReport.SKIP;
//                       END;

//                       IF PostDate <> SalesHeader."Posting Date" THEN BEGIN
//                            //CurrReport.SKIP;
//                       END;

//                       IF (PostDateTo < SalesHeader."Posting Date") OR
//                          (PostDate > SalesHeader."Posting Date") THEN BEGIN
//                            CurrReport.SKIP;
//                        END;
//                     // wcw - 270308 to skip if "No Picking List" is true[

//                       IF SalesHeader."No Picking List" THEN
//                            CurrReport.SKIP;
//                     //]

//                       END;
//                     rRE.RESET;
//                     rRE.SETRANGE("Item No.","No.");
//                     rRE.SETRANGE("Source ID","Document No.");
//                     rRE.SETRANGE("Source Ref. No.","Line No.");
//                     IF NOT rRE.FINDFIRST THEN
//                       vDisplayQty := "Qty. to Ship";
//                 end;

//                 trigger OnPreDataItem()
//                 begin
//                     LastFieldNo := FIELDNO("Unit of Measure Code");
//                 end;
//             }
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
//                     field(DocStatus;DocStatus)
//                     {
//                         Caption = 'Status';
//                     }
//                     field(PostDate;PostDate)
//                     {
//                         Caption = 'Posting Date From';
//                     }
//                     field(PostDateTo;PostDateTo)
//                     {
//                         Caption = 'Posting Date To';
//                     }
//                 }
//             }
//         }

//         actions
//         {
//         }

//         trigger OnOpenPage()
//         begin
//              PostDate := TODAY + 1;
//              PostDateTo := TODAY + 1;
//         end;
//     }

//     labels
//     {
//     }

//     var
//         LastFieldNo: Integer;
//         FooterPrinted: Boolean;
//         TotalFor: Label 'Total for ';
//         DocStatus: Option Open,Released;
//         PostDate: Date;
//         SalesHeader: Record "36";
//         PostDateTo: Date;
//         QUANTITYCaptionLbl: Label 'QUANTITY';
//         BIN_CODECaptionLbl: Label 'BIN CODE';
//         ITEM_DESCRIPTIONCaptionLbl: Label 'ITEM DESCRIPTION';
//         ITEM_NOCaptionLbl: Label 'ITEM NO';
//         DOCUMENT_NOCaptionLbl: Label 'DOCUMENT NO';
//         PICKING_LISTCaptionLbl: Label 'PICKING LIST';
//         Shipment_DateCaptionLbl: Label 'Shipment Date';
//         CUSTOMERCaptionLbl: Label 'CUSTOMER';
//         PageCaptionLbl: Label 'Page';
//         PrintedCaptionLbl: Label 'Printed';
//         Tong_Jum_Chew_Pte_LtdCaptionLbl: Label 'Tong Jum Chew Pte Ltd';
//         TOTALCaptionLbl: Label 'TOTAL';
//         Lot_QtyCaptionLbl: Label 'Lot Qty';
//         Exp_DateCaptionLbl: Label 'Exp Date';
//         Lot_No_CaptionLbl: Label 'Lot No.';
//         vDisplayQty: Decimal;
//         rIUOM: Record "5404";
//         rRE: Record "337";
// }

