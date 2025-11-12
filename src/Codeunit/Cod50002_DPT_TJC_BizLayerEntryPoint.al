codeunit 50002 "BiZLayer Entry Point"
{
    // // TJCSG1.00
    // //  1. 17/04/2014  dp.dst
    // //     - Commented out some codes (Create command) due to its incompatibility with NAV 2013.
    // //     - Commented out some codes with reference to Table 2000000002 (User) as this table no longer exists in NAV 2013.


    // trigger OnRun()
    // begin
    // end;

    // var
    //     NewChildNode: Automation ;
    //     XMLNewAttributeNode: Automation ;
    //     XMLRoot: Automation ;
    //     XMLNode: Automation ;
    //     ChildNode: Automation ;
    //     XMLDom: Automation ;

    // procedure GetBarcodeFromItemNo(ItemCode: Code[20]) Barcode: Code[20]
    // var
    //     ItemCrossRef: Record "5717";
    // begin
    //     ItemCrossRef.RESET;
    //     ItemCrossRef.SETRANGE(ItemCrossRef."Cross-Reference Type",ItemCrossRef."Cross-Reference Type"::"Bar Code");
    //     ItemCrossRef.SETRANGE(ItemCrossRef."Item No.",ItemCode);
    //     IF ItemCrossRef.FIND('+') THEN
    //       Barcode:=ItemCrossRef."Cross-Reference No."
    //     ELSE
    //       Barcode:=ItemCode;
    // end;

    // procedure GetItemNoFromBarcode(var Barcode: Code[20]) ItemCode: Code[20]
    // var
    //     ItemCrossRef: Record "5717";
    // begin
    //     ItemCrossRef.RESET;
    //     ItemCrossRef.SETRANGE(ItemCrossRef."Cross-Reference Type",ItemCrossRef."Cross-Reference Type"::"Bar Code");
    //     ItemCrossRef.SETRANGE(ItemCrossRef."Cross-Reference No.",Barcode);
    //     IF ItemCrossRef.FIND('+') THEN
    //       ItemCode:=ItemCrossRef."Item No."
    //     ELSE
    //       ItemCode:=Barcode;
    // end;

    // procedure GetItem(var XMLDom: Automation )
    // var
    //     Item: Record "27";
    //     Barcode: Code[20];
    // begin
    //     //return item code as barcode if barcode is not setup

    //     //XMLDom.loadXML ('<?xml version="1.0" standalone="yes"?><NavDSItem/>');
    //     XMLDom.loadXML ('<?xml version="1.0" ?><NavDSItem/>');
    //     XMLRoot := XMLDom.documentElement;

    //     IF Item.FIND('-') THEN
    //       REPEAT
    //         AddElement (XMLRoot,'NavItem',XMLNode);
    //         AddAttribute (XMLNode, 'ItemCode', GetBarcodeFromItemNo(Item."No."));
    //         IF Item."Item Tracking Code"='' THEN
    //              AddAttribute (XMLNode, 'Lot','NO')
    //         ELSE
    //              AddAttribute (XMLNode, 'Lot', 'YES');
    //         AddAttribute (XMLNode,'BUom', Item."Base Unit of Measure");
    //         AddAttribute (XMLNode,'Desc',Item.Description);
    //     //    AddAttribute (XMLNode,'Desc',Item.Description);

    //       UNTIL Item.NEXT=0;
    //         AddAttribute (XMLNode, 'xmlns', '');
    // end;

    // procedure GetLocationBin(var XMLDom: Automation )
    // var
    //     Location: Record "14";
    //     bin: Record "7354";
    // begin
    //     //return item code as barcode if barcode is not setup

    //     XMLDom.loadXML ('<?xml version="1.0"?><NavDSLocation/>');
    //     XMLRoot := XMLDom.documentElement;

    //     IF Location.FIND('-') THEN
    //       REPEAT
    //         AddElement (XMLRoot,'NavLocation',XMLNode);
    //         AddAttribute (XMLNode, 'Location', Location.Code);
    //       UNTIL Location.NEXT=0;
    //         AddAttribute (XMLNode, 'xmlns', '');

    //     IF bin.FIND('-') THEN
    //       REPEAT
    //         AddElement (XMLRoot,'NavBin',XMLNode);
    //         AddAttribute (XMLNode, 'Location', bin."Location Code");
    //         AddAttribute (XMLNode, 'Bin', bin.Code);

    //       UNTIL bin.NEXT=0;
    //         AddAttribute (XMLNode, 'xmlns', '');
    // end;

    // procedure GetItemUOM(XMLDom: Automation )
    // var
    //     UnitOfMeasure: Record "5404";
    // begin
    //     XMLDom.loadXML ('<?xml version="1.0"?><NavDSItemUom/>');
    //     XMLRoot := XMLDom.documentElement;

    //     IF UnitOfMeasure.FIND('-') THEN
    //       REPEAT

    //         AddElement (XMLRoot,'NavItemUom',XMLNode);
    //         AddAttribute (XMLNode, 'ItemCode', GetBarcodeFromItemNo(UnitOfMeasure."Item No."));
    //         AddAttribute (XMLNode, 'UOM', UnitOfMeasure.Code);
    //         AddAttribute (XMLNode, 'QtyByUom', FORMAT(UnitOfMeasure."Qty. per Unit of Measure"));
    //       UNTIL (UnitOfMeasure.NEXT = 0);

    //     AddAttribute (XMLNode, 'xmlns', '');
    // end;

    // procedure AddElement(var XMLNode: Automation ;NodeName: Text[250];var CreatedXMLNode: Automation )
    // begin
    //     //for xml - add element to xml document

    //     NewChildNode:=XMLNode.ownerDocument.createNode('element',NodeName,'');
    //     XMLNode.appendChild(NewChildNode);
    //     CreatedXMLNode:=NewChildNode;
    // end;

    // procedure AddAttribute(var XMLNode: Automation ;Name: Text[260];NodeValue: Text[260])
    // begin
    //     //for xml - add attribute to xml document

    //     IF NodeValue<>''THEN BEGIN

    //     XMLNewAttributeNode:= XMLNode.ownerDocument.createAttribute(Name);
    //     XMLNewAttributeNode.nodeValue:=NodeValue;
    //     XMLNode.attributes.setNamedItem(XMLNewAttributeNode);
    //     END;
    // end;

    // procedure UpdateStockTake(XmlString: Automation ;XMLDom: Automation ;UserCode: Code[20];BatchName: Code[20];PDACode: Code[20])
    // var
    //     pLotNo: Code[20];
    //     pItemNo: Code[20];
    //     pBarcode: Code[20];
    //     pQty: Decimal;
    //     pUser: Code[20];
    //     pDate: Date;
    //     pTime: Time;
    //     pLocation: Code[10];
    //     pBin: Code[10];
    //     XMLDoc: Automation ;
    //     XMLNode: Automation ;
    //     XMLNodeList: Automation ;
    //     XMLChildNode: Automation ;
    //     LineCount: Integer;
    //     idx: Integer;
    //     StockTakeTable: Record "50002";
    //     EntryNo: Integer;
    //     bcon: Automation ;
    //     i: Integer;
    //     x: Integer;
    //     OutText: array [1024] of Text[1024];
    //     T_OutStream: OutStream;
    //     TempBlob: Record "99008535";
    //     T_Instream: InStream;
    //     VerifyCount: Integer;
    // begin
    //     //StockTakeTable.DELETEALL;

    //     //get entry last number
    //     StockTakeTable.RESET;
    //     IF StockTakeTable.FIND('+') THEN
    //        EntryNo:=StockTakeTable.EntryNo+1
    //     ELSE
    //       EntryNo:=1;


    //     TempBlob.Blob.CREATEOUTSTREAM(T_OutStream);


    //     // TJCSG1.00 #1: Commented out this code.
    //     // CREATE(bcon);
    //     i := 0;
    //     x := 1;

    //     bcon.BSTR(XmlString.nodeTypedValue);
    //     WHILE i < bcon.GetBSTRLength DO BEGIN
    //       bcon.GetNextStringPortion(OutText[x],1000);
    //       T_OutStream.WRITETEXT(OutText[x],1000);
    //       i += 1000;
    //       x +=1;
    //     END;
    //     CLEAR(bcon);


    //     // TJCSG1.00: Commented out this code.
    //     //CREATE(XMLDoc);
    //     TempBlob.Blob.CREATEINSTREAM(T_Instream);
    //     XMLDoc.load(T_Instream);

    //     XMLNodeList:=XMLDoc.selectNodes('/DocumentElement/summaryTable');
    //     //XMLNodeList:=XMLDoc.selectNodes('/DocumentElement');
    //     LineCount:=XMLNodeList.length;
    //     VerifyCount:=0;
    //     //--------------
    //     XMLNodeList.reset;

    //     FOR idx:=0 TO LineCount-1 DO BEGIN

    //     XMLNode:=XMLNodeList.nextNode;
    //       XMLChildNode:=XMLNode.selectSingleNode('/DocumentElement/summaryTable['+FORMAT(idx)+']/lotNo/text()');
    //       IF ISCLEAR(XMLChildNode) THEN
    //          pLotNo:=''
    //       ELSE
    //          pLotNo:=XMLChildNode.text;

    //       XMLChildNode:=XMLNode.selectSingleNode('/DocumentElement/summaryTable['+FORMAT(idx)+']/qty/text()');
    //       EVALUATE(pQty,XMLChildNode.text);
    //       XMLChildNode:=XMLNode.selectSingleNode('/DocumentElement/summaryTable['+FORMAT(idx)+']/itemNo/text()');
    //       pBarcode:=XMLChildNode.text;
    //       XMLChildNode:=XMLNode.selectSingleNode('/DocumentElement/summaryTable['+FORMAT(idx)+']/location/text()');
    //       pLocation:=XMLChildNode.text;
    //       XMLChildNode:=XMLNode.selectSingleNode('/DocumentElement/summaryTable['+FORMAT(idx)+']/bin/text()');
    //       IF ISCLEAR(XMLChildNode) THEN
    //          pBin:=''
    //       ELSE
    //          pBin:=XMLChildNode.text;

    //       pItemNo:=GetItemNoFromBarcode(pBarcode);


    //     StockTakeTable.SETRANGE(StockTakeTable."Lot No.",pLotNo);
    //     StockTakeTable.SETRANGE(StockTakeTable.PDACode,PDACode);
    //     StockTakeTable.SETRANGE(StockTakeTable."Item Code",pItemNo);
    //     StockTakeTable.SETRANGE(StockTakeTable.Location,pLocation);
    //     StockTakeTable.SETRANGE(StockTakeTable.Bin,pBin);
    //     IF StockTakeTable.FIND('-') THEN
    //              BEGIN
    //                    StockTakeTable.Quantity:=pQty;
    //                    StockTakeTable.Date:=CURRENTDATETIME;
    //                    StockTakeTable.Status:=StockTakeTable.Status::Open;
    //                    StockTakeTable.MODIFY;
    //                    VerifyCount+=1;
    //              END
    //     ELSE
    //              BEGIN
    //                    StockTakeTable.INIT;
    //                    StockTakeTable."Item Code":= pItemNo;
    //                    StockTakeTable."Lot No.":=pLotNo;
    //                    StockTakeTable.Quantity:=pQty;
    //                    StockTakeTable.Date:=CURRENTDATETIME;
    //                    StockTakeTable.EntryNo:=EntryNo  ;
    //                    StockTakeTable.UserCode:=UserCode;
    //                    StockTakeTable."Batch Name":=BatchName;
    //                    StockTakeTable.PDACode:=PDACode;
    //                    StockTakeTable.Barcode:=pBarcode;
    //                    StockTakeTable.Location:=pLocation;
    //                    StockTakeTable.Bin:=pBin;
    //                    StockTakeTable.INSERT(TRUE);
    //                    EntryNo+=1;
    //                    VerifyCount+=1;
    //              END

    //     END;
    //     //===============
    //     //return status
    //     IF VerifyCount<>LineCount THEN
    //        ERROR('Error Inserting');
    //     XMLDom.loadXML ('<?xml version="1.0"?><NavDSProcessStatus/>');
    //     XMLRoot := XMLDom.documentElement;

    //         AddElement (XMLRoot,'NavProcessStatus',XMLNode);
    //         AddAttribute (XMLNode, 'Status','OK');
    //         AddAttribute (XMLNode, 'xmlns', '');


    //     /*

    //     LotInfo.SETRANGE(LotInfo."Lot No.",LotNo);
    //     IF LotInfo.FIND('-') THEN
    //     ItemNo:=LotInfo."Item No.";

    //     EXIT(ItemNo);
    //     */

    // end;

    // procedure ValidateBatchName(BatchName: Code[20]) Status: Boolean
    // var
    //     ItemJournalBatch: Record "233";
    // begin
    //           ItemJournalBatch.RESET;
    //           ItemJournalBatch.SETRANGE(ItemJournalBatch."Journal Template Name",'PHYS. INVE');
    //           ItemJournalBatch.SETRANGE(ItemJournalBatch.Name,BatchName);
    //           IF ItemJournalBatch.FIND('-') THEN
    //                Status:=TRUE;
    // end;

    // procedure AuthenticateLogin(UserID: Code[20];Password: Text[30];BatchName: Code[20]) ReturnStatus: Text[30]
    // var
    //     UserSetup: Record "91";
    // begin

    //     //check before authenticate, reason: error message pop out if user not found
    //     UserSetup.RESET;
    //     UserSetup.SETRANGE(UserSetup."User ID",UserID);
    //     IF UserSetup.FIND('-') THEN
    //     BEGIN


    //             IF AuthenticateUser(UserID,Password) THEN
    //                 BEGIN
    //                       IF ValidateBatchName(BatchName) THEN
    //                         BEGIN
    //                                ReturnStatus:='OK';
    //                         END
    //                 ELSE
    //                         BEGIN
    //                                ReturnStatus:='Batch Name Not Found';
    //                         END;
    //                 END
    //             ELSE
    //                 ReturnStatus:='Wrong Username/Password';
    //     END
    //     ELSE
    //       ReturnStatus:='Wrong Username/Password';
    // end;

    // procedure AuthenticateUser(UserID: Code[20];Password: Text[30]) IsValidUser: Boolean
    // begin
    //     /*Start: TJCSG1.00 #1*/
    //     // Commented out the following codes & removed the local variables User & refUser pointing to T2000000002 as it is obsolete in NAV 2013.
    //     /*
    //     IsValidUser:=FALSE;

    //      User.GET(UserID);

    //           refUser := User;
    //           refUser.VALIDATE(Password,Password);

    //            IF User.Password <> refUser.Password THEN
    //            BEGIN
    //                IsValidUser := FALSE;
    //                EXIT;
    //            END;

    //             IsValidUser := TRUE;

    //     EXIT(IsValidUser);
    //     */

    // end;

    // procedure CreateReservationEntry(itemjentry: Record "83")
    // var
    //     "Reservation Entry": Record "337";
    //     "Reservation Entry1": Record "337";
    //     "Entry No": Integer;
    //     Inventory: Integer;
    // begin


    //     //update lot no into reservation entry


    //     "Reservation Entry".RESET;
    //     "Reservation Entry".SETRANGE("Reservation Entry"."Source ID",'PHYS. INVE');
    //     "Reservation Entry".SETRANGE("Reservation Entry"."Source Ref. No.",itemjentry."Line No.");
    //     "Reservation Entry".SETRANGE("Reservation Entry"."Source Type",DATABASE::"Item Journal Line") ;

    //     //030807 delete any old reservation
    //     IF "Reservation Entry".FIND('-')THEN
    //         "Reservation Entry".DELETE;

    //         IF "Reservation Entry1".FIND('+') THEN
    //              "Entry No":="Reservation Entry1"."Entry No."+1
    //         ELSE
    //              "Entry No":=1;

    //           "Reservation Entry".INIT;

    //           //populate fields
    //          "Reservation Entry"."Entry No.":="Entry No";
    //          "Reservation Entry"."Item No.":=itemjentry."Item No.";
    //          "Reservation Entry"."Location Code" :=itemjentry."Location Code";
    //          "Reservation Entry"."Reservation Status":="Reservation Entry"."Reservation Status"::Prospect;
    //          "Reservation Entry"."Creation Date":=TODAY;
    //          "Reservation Entry"."Source ID":= 'PHYS. INVE';
    //          "Reservation Entry"."Source Ref. No.":=itemjentry."Line No.";
    //          "Reservation Entry"."Created By":=USERID;
    //          "Reservation Entry"."Qty. per Unit of Measure" :=itemjentry."Qty. per Unit of Measure";
    //          "Reservation Entry"."Lot No.":=  itemjentry."Lot No.";

    //          "Reservation Entry"."Source Type":=DATABASE::"Item Journal Line";
    //          "Reservation Entry"."Source Batch Name":=itemjentry."Journal Batch Name";
    //             IF itemjentry."Entry Type"=itemjentry."Entry Type"::"Positive Adjmt." THEN
    //                 BEGIN
    //                    "Reservation Entry"."Source Subtype":=2;
    //                    "Reservation Entry".Quantity:=itemjentry.Quantity;
    //                    "Reservation Entry"."Quantity (Base)":=itemjentry.Quantity*itemjentry."Qty. per Unit of Measure";
    //                    "Reservation Entry".VALIDATE("Quantity (Base)");
    //                    "Reservation Entry".Positive:=TRUE;
    //                 END
    //             ELSE
    //                 BEGIN
    //                    "Reservation Entry"."Source Subtype":=3;
    //                    "Reservation Entry"."Shipment Date":=TODAY;
    //                    "Reservation Entry".Quantity:=(-1)*itemjentry.Quantity;

    //                    "Reservation Entry"."Quantity (Base)":=(-1)*itemjentry.Quantity*itemjentry."Qty. per Unit of Measure";
    //                    "Reservation Entry".VALIDATE("Quantity (Base)");
    //                    "Reservation Entry".Positive:=FALSE
    //                 END;


    //     "Reservation Entry".INSERT;

    //     //END;
    // end;

    // procedure UpdateLotToReservationEntry(Type: Text[30];"Item No": Code[20];Location: Code[20];"Lot No": Code[20];Bin: Code[20];"Docu No": Code[20];"Line No": Integer;Quantity: Integer;Date: Date;QUOM: Decimal)
    // var
    //     "Reservation Entry": Record "337";
    //     "Entry No": Integer;
    //     Inventory: Integer;
    //     "Reservation Entry1": Record "337";
    // begin
    // end;

    procedure "Compare Stock Inventory"("Batch Name": Code[20])
    // var
    //     "Stock Table": Record "50002";
    //     ItemJournalLine: Record "83";
    //     Inventory: Decimal;
    begin
        //     /*//THU
        //               ItemJournalLine.RESET;
        //               ItemJournalLine.SETRANGE(ItemJournalLine."Journal Batch Name","Batch Name");
        //               ItemJournalLine.SETRANGE(ItemJournalLine."Journal Template Name", 'PHYS. INVE');
        //               IF ItemJournalLine.FIND('-') THEN
        //               BEGIN
        //                  REPEAT
        //                      Inventory:=0;
        //                      "Stock Table".RESET;
        //                      "Stock Table".SETRANGE("Stock Table"."Batch Name","Batch Name");
        //                      "Stock Table".SETRANGE("Stock Table"."Item Code",ItemJournalLine."Item No.");
        //                     "Stock Table".SETRANGE("Stock Table"."Lot No.",ItemJournalLine."Lot No.");
        //                      "Stock Table".SETRANGE("Stock Table".Location,ItemJournalLine."Location Code");
        //                      "Stock Table".SETRANGE("Stock Table".Bin,ItemJournalLine."Bin Code");
        //                       IF "Stock Table".FIND('-') THEN
        //                           BEGIN
        //                              REPEAT
        //                               Inventory:=Inventory+"Stock Table".Quantity;

        //                              "Stock Table".Status:="Stock Table".Status::Retrieved;
        //                              "Stock Table"."System Quantity":=ItemJournalLine."Qty. (Calculated)";
        //                              "Stock Table".VALIDATE("System Quantity");
        //                              "Stock Table".MODIFY;

        //                           UNTIL "Stock Table".NEXT=0;
        //                           END;

        //                     ItemJournalLine.VALIDATE("Qty. (Phys. Inventory)",Inventory);
        //                     ItemJournalLine.MODIFY;

        //                  UNTIL ItemJournalLine.NEXT=0;
        //               END;

        //     */
        //     /*
        //      "Stock Table".RESET;
        //      "Stock Table".SETRANGE("Stock Table"."Batch Name","Batch Name");
        //      IF "Stock Table".FIND('-') THEN
        //         BEGIN
        //           REPEAT

        //               ItemJournalLine.RESET;
        //               ItemJournalLine.SETRANGE(ItemJournalLine."Journal Batch Name","Batch Name");
        //               ItemJournalLine.SETRANGE(ItemJournalLine."Journal Template Name", 'PHYS. INVE');
        //               ItemJournalLine.SETRANGE(ItemJournalLine."Lot No.","Stock Table"."Lot No.");
        //               ItemJournalLine.SETRANGE(ItemJournalLine."Item No.","Stock Table"."Item Code");
        //               IF ItemJournalLine.FIND('-') THEN
        //                  BEGIN

        //                   Inventory:=ItemJournalLine."Qty. (Phys. Inventory)"+"Stock Table".Quantity;

        //                   ItemJournalLine.VALIDATE("Qty. (Phys. Inventory)",Inventory);

        //                    ItemJournalLine.MODIFY;
        //                    "Stock Table".Status:="Stock Table".Status::Retrieved;
        //                    "Stock Table"."System Quantity":=ItemJournalLine."Qty. (Calculated)";
        //                    "Stock Table".MODIFY;

        //                  END;
        //           UNTIL "Stock Table".NEXT=0;
        //         END;
        //     */



        //      "Stock Table".RESET;
        //      "Stock Table".SETRANGE("Stock Table"."Batch Name","Batch Name");
        //      "Stock Table".SETFILTER(Status,'<>%1',"Stock Table".Status::Retrieved);
        //      IF "Stock Table".FIND('-') THEN
        //         BEGIN
        //           REPEAT
        //           Inventory:= 0;
        //               ItemJournalLine.RESET;
        //               ItemJournalLine.SETRANGE(ItemJournalLine."Journal Batch Name","Batch Name");
        //               ItemJournalLine.SETRANGE(ItemJournalLine."Journal Template Name", 'PHYS. INVE');
        //               ItemJournalLine.SETRANGE(ItemJournalLine."Lot No.","Stock Table"."Lot No.");
        //               ItemJournalLine.SETRANGE(ItemJournalLine."Item No.","Stock Table"."Item Code");
        //               IF ItemJournalLine.FIND('-') THEN
        //               BEGIN

        //                 Inventory:=ItemJournalLine."Qty. (Phys. Inventory)"+"Stock Table".Quantity;
        //                 ItemJournalLine.VALIDATE("Qty. (Phys. Inventory)",Inventory);
        //                 ItemJournalLine.MODIFY;
        //                 "Stock Table".Status:="Stock Table".Status::Retrieved;
        //                 "Stock Table".Remark:= '';
        //                 "Stock Table"."System Quantity":=ItemJournalLine."Qty. (Calculated)";
        //                 "Stock Table".MODIFY;
        //               END
        //               ELSE BEGIN
        //                   //Checking for lot no only not found
        //                 ItemJournalLine.RESET;
        //                 ItemJournalLine.SETRANGE(ItemJournalLine."Journal Batch Name","Batch Name");
        //                 ItemJournalLine.SETRANGE(ItemJournalLine."Journal Template Name", 'PHYS. INVE');
        //                 //ItemJournalLine.SETRANGE(ItemJournalLine."Lot No.","Stock Table"."Lot No.");
        //                 ItemJournalLine.SETRANGE(ItemJournalLine."Item No.","Stock Table"."Item Code");
        //                 IF ItemJournalLine.FIND('-') THEN
        //                 BEGIN
        //                   "Stock Table".Status:="Stock Table".Status::"Not Found";
        //                   "Stock Table".Remark:= 'Lot No. Not Match';
        //                   "Stock Table".MODIFY;
        //                 END
        //               END;
        //           UNTIL "Stock Table".NEXT=0;
        //         END;

    end;
}

