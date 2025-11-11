codeunit 50000 CreateTempTable
{
    // Date : 03/05/2007
    // By : Wong Chee Weng
    // Company : DP Technology
    // 
    // Retrieve data from the following table to calculate monthly sale and commission:
    // a. Customer Ledger Entry
    // b. Sales Invoice Header
    // c. Sales Invoice Line
    // d. User Setup
    // e. Item Category Group
    // f. Product Group
    // g. Sales Credit Memo Header
    // h. Sales Credit Memo Line
    // i. Sales Price
    // j. Customer Price Group
    // k. Temp Table
    // 
    // 20090529 RWP Exclude Retail Sales from prodcomm in RetrieveInvocie Function
    // 
    // DP.EDS
    //   #1 - 27/08/09 - Added some codes in to eliminate errors in the GET functions.
    // 
    // TJCSG1.00 Upgrade
    // 1. 04/04/2014 DP.JL DD#85
    //   - temp Commend out user table
    // 
    // 2. 31/5/2014 DP.AYD DD#123 https://dptech.mydonedone.com/issuetracker/projects/4350/issues/123
    //    - Comment old find at function AddCommToTable
    //    - Use New Key from Table - 50000 - Temp Table
    //      Keys : Name Code,Document Type
    //      Reason : Since Nav 2013 R2 Not using T 2000000002 - User
    //               function GetSatffDescription will return blank then
    //               function AddCommToTable must be changed to find by Name Code
    // 
    // 3. 31/5/2014 DP.AYD DD#123
    //    - To Avoid blank name description
    // 
    // 4. 02/06/2014 DP.AYD DD#123
    //    - Code optimation due to slow execution
    //    - Add Keys to T21  : Document Type,Closed at Date,Sell-to Customer No.,Journal Batch Name
    //    - Add Keys to T50000 :
    //      1. Name Code
    //      2. Document No,Document Type,Item Code
    // 
    // 5. 03/06/2014 DP.AYD DD#123
    //    - Add Progress Bar
    // 
    // 6. 2014/06/10 DP.AYD DD#122
    //    - Add Keys to :
    //      T114 : "Posting Date","Sell-to Customer No."
    //      T115 : "Document No.",Type
    //      T91  : "Staff Level")
    //    - Fix Progress Bar
    //    - To Improve performance, TempTable is changed to Temporary=Yes
    //    - Add Global Varibale DBTempTable
    //    - Bulk Insert is implemented to DBTemptable from Temporary Table
    // 
    // 7. 2014/7/4 DP.AYD DD#122
    //    - Rounding issue, different out put compare to NAV4


    trigger OnRun()
    begin
        //  ExportToExcel();
    end;

    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
        SalesInvoiceLine: Record "Sales Invoice Line";
        ItemCategoryCode: Code[20];
        ItemDescription: Text[100];
        ProductGroupCode: Code[20];
        Item: Record Item;
        TempTable: Record "Temp Table" temporary;
        DBTempTable: Record "Temp Table";
        EntryNo: Integer;
        NameCode: Text[20];
        SalespersonCode: Text[20];
        PostSalesInvoiceHeader: Record "Sales Invoice Header";
        Customer: Record Customer;
        pBar: Dialog;
        pBarTotal: Integer;
        pBarCount: Integer;
        pBarText: Text;
        pBarTime: Time;
        pBarDisplay: Integer;
        pBarStartTime: Time;
        pBarDuration: Duration;
        pBarShowTime: Boolean;
        pBarDocNo: Text;
        pBarDocNoLine: Integer;

    procedure RetrieveInvoiceForPromoter("Start Date": Date; "End Date": Date; "Production Incentive Group": Code[20]) Range: Text[30]
    var
        "Calculated Comm": Decimal;
        "Total Sale": Decimal;
        "Total Production Sale": Decimal;
        User: Record "User Setup";
        CreditMemoLine: Record "Sales Cr.Memo Line";
        CreditMemoHeader: Record "Sales Cr.Memo Header";
        PromoterCode: Code[20];
        PromoterDescription: Text[50];
        GotPromoter: Boolean;
        ItemCategoryDescription: Text[50];
        OpeningAR: Record "Temp Table";
        ItemCostPrice: Decimal;
        ProdCommPaid: Decimal;
        ProdCommUnpaid: Decimal;
        TotalProdCommPaid: Decimal;
        TotalProdCommUnpaid: Decimal;
        PromoterPriceGroup: Code[20];
    begin

        //delete record that document type are not equal 'Opening'
        //Record with 'Opening' are sales invoice line from old system
        TempTable.SETCURRENTKEY("Document Type");

        TempTable.SETRANGE(TempTable."Document Type", TempTable."Document Type"::Invoice);
        TempTable.DELETEALL;
        TempTable.SETRANGE(TempTable."Document Type", TempTable."Document Type"::CreditMemo);
        TempTable.DELETEALL;
        TempTable.SETRANGE(TempTable."Document Type", TempTable."Document Type"::NA);
        TempTable.DELETEALL;
        COMMIT;

        //get the new entry number
        TempTable.RESET;
        IF TempTable.FIND('+') THEN
            EntryNo := TempTable."Entry No" + 1
        ELSE
            EntryNo := 1;

        Range := FORMAT(EntryNo);
        PostSalesInvoiceHeader.RESET;
        PostSalesInvoiceHeader.SETCURRENTKEY("Posting Date", "Sell-to Customer No.");
        PostSalesInvoiceHeader.SETRANGE(PostSalesInvoiceHeader."Posting Date", "Start Date", "End Date");



        //get invoice that is closed between selected date range

        //=================================================
        //Part 1 - Invoice
        //=================================================


        IF PostSalesInvoiceHeader.FIND('-') THEN BEGIN
            REPEAT

                //get invoive line base on invoice no.
                SalesInvoiceLine.RESET;
                SalesInvoiceLine.SETCURRENTKEY("Document No.", Type);
                SalesInvoiceLine.SETRANGE(SalesInvoiceLine."Document No.", PostSalesInvoiceHeader."No.");
                SalesInvoiceLine.SETRANGE(SalesInvoiceLine.Type, SalesInvoiceLine.Type::Item);
                SalesInvoiceLine.SETFILTER(SalesInvoiceLine.Amount, '<>%1', 0);

                IF SalesInvoiceLine.FIND('-') THEN BEGIN
                    REPEAT

                        GotPromoter := FALSE;
                        //get promoter info if any
                        PromoterCode := SalesInvoiceLine."Shortcut Dimension 2 Code";
                        IF PromoterCode <> '' THEN BEGIN
                            PromoterDescription := GetPromoterDescription(PromoterCode);
                            PromoterPriceGroup := GetPromoterPriceGroup(PostSalesInvoiceHeader."Sell-to Customer No.");
                            GotPromoter := TRUE;

                        END;

                        IF GotPromoter THEN BEGIN

                            //reset for each invoice
                            "Total Sale" := 0;
                            "Total Production Sale" := 0;

                            //get item details
                            RetrieveItemInfo(SalesInvoiceLine."No.");
                            ItemCategoryDescription := GetItemcategoryDescription(ItemCategoryCode);

                            TempTable.INIT;
                            TempTable."Document No" := SalesInvoiceLine."Document No.";
                            TempTable."Entry No" := EntryNo;
                            TempTable."Name Code" := PromoterCode;
                            TempTable."Name Description" := PromoterDescription;
                            TempTable."Customer Code" := SalesInvoiceLine."Sell-to Customer No.";
                            TempTable."Customer Description" := GetCustomerDescription(SalesInvoiceLine."Sell-to Customer No.");
                            TempTable."Item Code" := SalesInvoiceLine."No.";
                            TempTable."Item Description" := ItemDescription;

                            TempTable."Sales Qty" := SalesInvoiceLine.Quantity;
                            TempTable."Line Amount" := SalesInvoiceLine.Amount;
                            TempTable."Invoice Date" := PostSalesInvoiceHeader."Posting Date";

                            //add to total production sale figure if it is the selected group
                            IF ProductGroupCode = "Production Incentive Group" THEN
                                "Total Production Sale" := SalesInvoiceLine.Amount;

                            TempTable."Closing Date" := CustLedgerEntry."Closed at Date";
                            TempTable."Product Group Code" := ProductGroupCode;
                            TempTable."Product Group Description" := GetProductGroupDescription(ProductGroupCode, ItemCategoryCode);
                            TempTable."Item Category Code" := ItemCategoryCode;

                            TempTable."Item category Description" := ItemCategoryDescription;

                            TempTable."Report Type" := TempTable."Report Type"::PromoterComm;
                            TempTable.Type := TempTable.Type::Promoter;
                            TempTable."Unit Price" := SalesInvoiceLine."Unit Price";
                            TempTable."Cost Price" := SalesInvoiceLine.Quantity * SalesInvoiceLine."Unit Cost (LCY)";
                            TempTable."Sales Margin" := SalesInvoiceLine.Quantity * (SalesInvoiceLine."Unit Price" -
                            SalesInvoiceLine."Unit Cost (LCY)");
                            "Calculated Comm" := GetPromoterCommRate(PromoterPriceGroup, SalesInvoiceLine."No.") *
                            SalesInvoiceLine."Quantity (Base)";

                            TempTable."Comm (Paid)" := "Calculated Comm";

                            //document type = invoice
                            TempTable."Document Type" := TempTable."Document Type"::Invoice;

                            TempTable.INSERT;
                            EntryNo += 1;
                        END;
                    UNTIL (SalesInvoiceLine.NEXT = 0);
                END;


            UNTIL (PostSalesInvoiceHeader.NEXT = 0);
        END;

        //=================================================
        //Part 2 - Credit Memo
        //=================================================
        //get credit memo that is within the selected date
        CreditMemoHeader.SETCURRENTKEY(CreditMemoHeader."Posting Date");
        CreditMemoHeader.SETRANGE(CreditMemoHeader."Posting Date", "Start Date", "End Date");

        IF CreditMemoHeader.FIND('-') THEN BEGIN
            REPEAT

                //get creditMemo line base on credit memo header no.

                CreditMemoLine.RESET;
                CreditMemoLine.SETRANGE(CreditMemoLine."Document No.", CreditMemoHeader."No.");
                CreditMemoLine.SETRANGE(CreditMemoLine.Type, CreditMemoLine.Type::Item);
                CreditMemoLine.SETFILTER(CreditMemoLine.Amount, '<>%1', 0);


                IF CreditMemoLine.FIND('-') THEN BEGIN
                    REPEAT

                        GotPromoter := FALSE;
                        //get promoter info if any
                        PromoterCode := CreditMemoLine."Shortcut Dimension 2 Code";
                        IF PromoterCode <> '' THEN BEGIN
                            PromoterDescription := GetPromoterDescription(PromoterCode);
                            PromoterPriceGroup := GetPromoterPriceGroup(CreditMemoHeader."Sell-to Customer No.");
                            GotPromoter := TRUE;

                        END;

                        IF GotPromoter THEN BEGIN

                            //reset for each invoice
                            "Total Sale" := 0;
                            "Total Production Sale" := 0;

                            //get item details
                            RetrieveItemInfo(SalesInvoiceLine."No.");
                            ItemCategoryDescription := GetItemcategoryDescription(ItemCategoryCode);

                            TempTable.INIT;
                            TempTable."Document No" := CreditMemoLine."Document No.";

                            TempTable."Entry No" := EntryNo;
                            TempTable."Name Code" := PromoterCode;
                            TempTable."Name Description" := PromoterDescription;
                            TempTable."Customer Code" := CreditMemoLine."Sell-to Customer No.";
                            TempTable."Customer Description" := GetCustomerDescription(CreditMemoLine."Sell-to Customer No.");
                            TempTable."Item Code" := CreditMemoLine."No.";
                            RetrieveItemInfo(CreditMemoLine."No.");
                            TempTable."Item Description" := ItemDescription;
                            TempTable."Sales Qty" := CreditMemoLine.Quantity;
                            TempTable."Line Amount" := CreditMemoLine.Amount * (-1);
                            TempTable."Invoice Date" := CreditMemoHeader."Posting Date";

                            TempTable."Product Group Code" := ProductGroupCode;
                            TempTable."Product Group Description" := GetProductGroupDescription(ProductGroupCode, ItemCategoryCode);
                            TempTable."Item Category Code" := ItemCategoryCode;
                            TempTable."Item category Description" := GetItemcategoryDescription(ItemCategoryCode);

                            TempTable."Report Type" := TempTable."Report Type"::SaleComm;
                            TempTable.Type := TempTable.Type::Salesperson;
                            TempTable."Unit Price" := CreditMemoLine."Unit Price";
                            TempTable."Cost Price" := (-1) * CreditMemoLine.Quantity * CreditMemoLine."Unit Cost (LCY)";
                            TempTable."Sales Margin" := (-1) * CreditMemoLine.Quantity * (CreditMemoLine."Unit Price" -
                            CreditMemoLine."Unit Cost (LCY)");
                            "Calculated Comm" := (-1) * GetPromoterCommRate(PromoterCode, CreditMemoLine."No.") * CreditMemoLine.
        "Quantity (Base)";

                            TempTable."Comm (Paid)" := "Calculated Comm";

                            //document type = CreditMemo
                            TempTable."Document Type" := TempTable."Document Type"::CreditMemo;

                            TempTable.INSERT;
                            EntryNo += 1;
                        END;
                    UNTIL (CreditMemoLine.NEXT = 0);
                END;


            UNTIL (CreditMemoHeader.NEXT = 0);
        END;
    end;

    procedure RetrieveInvoiceForPromoterOld("Start Date": Date; "End Date": Date; "Production Incentive Group": Code[20]) Range: Text[30]
    var
        "Calculated Comm": Decimal;
        "Total Sale": Decimal;
        "Total Production Sale": Decimal;
        User: Record "User Setup";
        CreditMemoLine: Record "Sales Cr.Memo Line";
        CreditMemoHeader: Record "Sales Cr.Memo Header";
        PromoterCode: Code[20];
        PromoterDescription: Text[50];
        GotPromoter: Boolean;
        ItemCategoryDescription: Text[50];
        OpeningAR: Record "Temp Table";
        ItemCostPrice: Decimal;
        ProdCommPaid: Decimal;
        ProdCommUnpaid: Decimal;
        TotalProdCommPaid: Decimal;
        TotalProdCommUnpaid: Decimal;
        PromoterPriceGroup: Code[20];
    begin
        /*

        //delete record that document type are not equal 'Opening'
        //Record with 'Opening' are sales invoice line from old system
                    TempTable.SETCURRENTKEY("Document Type");

        TempTable.SETRANGE(TempTable."Document Type",TempTable."Document Type"::Invoice);
        TempTable.DELETEALL;
        TempTable.SETRANGE(TempTable."Document Type",TempTable."Document Type"::CreditMemo);
        TempTable.DELETEALL;
        TempTable.SETRANGE(TempTable."Document Type",TempTable."Document Type"::NA);
        TempTable.DELETEALL;
        COMMIT;

        //get the new entry number
        TempTable.RESET;
        IF TempTable.FIND('+') THEN
           EntryNo:=TempTable."Entry No"+1
        ELSE
            EntryNo:=1;

        Range:=FORMAT(EntryNo);
        PostSalesInvoiceHeader.SETCURRENTKEY("Posting Date","Sell-to Customer No.");
        PostSalesInvoiceHeader.SETRANGE(PostSalesInvoiceHeader."Posting Date","Start Date","End Date");


        //get invoice that is closed between selected date range

        //=================================================
        //Part 1 - Invoice
        //=================================================


        IF PostSalesInvoiceHeader.FIND('-') THEN
        BEGIN
          REPEAT


               //get promoter info if any
               PromoterCode:=GetPromoterCode(CustLedgerEntry."Document No.");
               IF PromoterCode<>'' THEN
                   BEGIN
                        PromoterDescription:=GetPromoterDescription(PromoterCode);
                        PromoterPriceGroup:=GetPromoterPriceGroup(CustLedgerEntry."Customer No.");
                        GotPromoter:=TRUE;


                   END;
        IF GotPromoter THEN
        BEGIN

               IF NOT (CustLedgerEntry."Journal Batch Name"='OPENING') THEN
               BEGIN

               //get invoive line base on invoice no.
               SalesInvoiceLine.SETCURRENTKEY("Document No.",Type);
               SalesInvoiceLine.SETRANGE(SalesInvoiceLine."Document No.",CustLedgerEntry."Document No.");
               SalesInvoiceLine.SETRANGE(SalesInvoiceLine.Type,SalesInvoiceLine.Type::Item);
               SalesInvoiceLine.SETFILTER(SalesInvoiceLine.Amount,'<>%1',0);
               //set saleperson code and salesperson name
               SalespersonCode:=CustLedgerEntry."Salesperson Code";

               IF SalesInvoiceLine.FIND('-') THEN
               BEGIN
                     REPEAT

                     //reset for each invoice
                     "Total Sale":=0;
                     "Total Production Sale":=0;

                     //get item details
                     RetrieveItemInfo(SalesInvoiceLine."No.");
                     ItemCategoryDescription:= GetItemcategoryDescription(ItemCategoryCode);

                     TempTable.INIT;
                     TempTable."Document No":=SalesInvoiceLine."Document No.";
                     TempTable."Entry No":=EntryNo;
                     TempTable."Name Code":= PromoterCode;
                     TempTable."Name Description":= PromoterDescription ;
                     TempTable."Customer Code":=SalesInvoiceLine."Sell-to Customer No.";
                     TempTable."Customer Description":=GetCustomerDescription(SalesInvoiceLine."Sell-to Customer No.");
                     TempTable."Item Code":=SalesInvoiceLine."No." ;
                     TempTable."Item Description":=ItemDescription;

                     TempTable."Sales Qty":=  SalesInvoiceLine.Quantity;
                     TempTable."Line Amount":=SalesInvoiceLine.Amount;
                     TempTable."Invoice Date":=CustLedgerEntry."Posting Date" ;

                     //add to total production sale figure if it is the selected group
                     IF  ProductGroupCode="Production Incentive Group" THEN
                     "Total Production Sale":=SalesInvoiceLine.Amount;

                    TempTable."Closing Date":=CustLedgerEntry."Closed at Date";
                    TempTable."Product Group Code":=   ProductGroupCode;
                    TempTable."Product Group Description":=GetProductGroupDescription(ProductGroupCode,ItemCategoryCode);
                    TempTable."Item Category Code":= ItemCategoryCode;

                    TempTable."Item category Description":= ItemCategoryDescription;

                    TempTable."Report Type":=TempTable."Report Type"::PromoterComm;
                    TempTable.Type:= TempTable.Type::Promoter;
                    TempTable."Unit Price":= SalesInvoiceLine."Unit Price";
                    TempTable."Cost Price":=SalesInvoiceLine.Quantity*SalesInvoiceLine."Unit Cost (LCY)";
                    TempTable."Sales Margin":= SalesInvoiceLine.Quantity*(SalesInvoiceLine."Unit Price"-
                    SalesInvoiceLine."Unit Cost (LCY)");
                    "Calculated Comm":=GetPromoterCommRate(PromoterPriceGroup,SalesInvoiceLine."No.")*SalesInvoiceLine.Quantity;

                    //<120 days go to paid else unpaid
                    IF("End Date"-"Start Date"<120) THEN
                           TempTable."Comm (Paid)":="Calculated Comm"
                    ELSE
                           TempTable."Comm (Unpaid)":="Calculated Comm" ;

                     //calculate customer point
                     TempTable."Customer Point":=0;

                     //document type = invoice
                     TempTable."Document Type":=TempTable."Document Type"::Invoice;

                     TempTable.INSERT;
                     EntryNo+=1;

                UNTIL (SalesInvoiceLine.NEXT=0);
              END;
        END;
        //if got promoter end

             //for reason code not = opening
             END
            ELSE
             BEGIN
             //============================================
             //Part 1.B  - calculation for outstanding AR
             //============================================

               //get invoive line base on invoice no.
               OpeningAR.SETCURRENTKEY(OpeningAR."Document No",OpeningAR."Document Type");
               OpeningAR.SETRANGE(OpeningAR."Document No",CustLedgerEntry."Document No.");
               OpeningAR.SETRANGE(OpeningAR."Document Type",OpeningAR."Document Type"::Opening);

               //set saleperson code and salesperson name
               SalespersonCode:=CustLedgerEntry."Salesperson Code";

               //get promoter info if any
               PromoterCode:=GetPromoterCode(CustLedgerEntry."Document No.");
               IF PromoterCode<>'' THEN
                   BEGIN
                        PromoterDescription:=GetPromoterDescription(PromoterCode);
                        GotPromoter:=TRUE;

                   END;
        IF GotPromoter THEN
        BEGIN
               IF OpeningAR.FIND('-') THEN
               BEGIN
                     REPEAT

                     //reset for each invoice
                     "Total Sale":=0;
                     "Total Production Sale":=0;

                     //get item details
                     RetrieveItemInfo(OpeningAR."Item Code");
                     ItemCategoryDescription:= GetItemcategoryDescription(ItemCategoryCode);

                     TempTable.INIT;
                     TempTable."Document No":=OpeningAR."Document No";
                     TempTable."Entry No":=EntryNo;
                     TempTable."Name Code":= PromoterCode;
                     TempTable."Name Description":= PromoterDescription ;
                     TempTable."Customer Code":=OpeningAR."Customer Code";
                     TempTable."Customer Description":=GetCustomerDescription(OpeningAR."Customer Code");
                     TempTable."Item Code":=OpeningAR."Item Code" ;
                     TempTable."Item Description":=ItemDescription;

                     TempTable."Sales Qty":= OpeningAR."Sales Qty";
                     TempTable."Line Amount":=OpeningAR."Line Amount";
                     TempTable."Invoice Date":=OpeningAR."Invoice Date" ;

                     //add to total production sale figure if it is the selected group
                     IF  ProductGroupCode="Production Incentive Group" THEN
                     "Total Production Sale":=OpeningAR."Line Amount";

                    TempTable."Closing Date":=CustLedgerEntry."Closed at Date";
                    TempTable."Product Group Code":=   ProductGroupCode;
                    TempTable."Product Group Description":=GetProductGroupDescription(ProductGroupCode,ItemCategoryCode);
                    TempTable."Item Category Code":= ItemCategoryCode;

                    TempTable."Item category Description":= ItemCategoryDescription;

                    TempTable."Report Type":=TempTable."Report Type"::PromoterComm;
                    TempTable.Type:= TempTable.Type::Promoter;

                    TempTable."Unit Price":= OpeningAR."Unit Price";

          ItemCostPrice:=GetItemCostPrice(OpeningAR."Item Code" );

                    TempTable."Cost Price":=OpeningAR."Sales Qty"*ItemCostPrice ;
                    TempTable."Sales Margin":= OpeningAR."Sales Qty"*(OpeningAR."Unit Price"-
                    ItemCostPrice);
                    "Calculated Comm":=GetPromoterCommRate(PromoterCode,OpeningAR."Item Code" )* OpeningAR."Sales Qty";

                    //<120 days go to paid else unpaid
                    IF("End Date"-"Start Date"<120) THEN
                           TempTable."Comm (Paid)":="Calculated Comm"
                    ELSE
                           TempTable."Comm (Unpaid)":="Calculated Comm" ;

                     //calculate customer point
                     TempTable."Customer Point":=0;

                     //document type = invoice
                     TempTable."Document Type":=TempTable."Document Type"::Invoice;

                     TempTable.INSERT;
                     EntryNo+=1;




                UNTIL (OpeningAR.NEXT=0);
              END;
        //got promoter
        END;
             //============================================
             //end of Part 1.B
             //=============================================
             END;
           UNTIL (CustLedgerEntry.NEXT=0);
        END;

        //=================================================
        //Part 2 - CREDIT MEMO calculation
        //=================================================
        //get credit memo that is within the selected date
        CreditMemoHeader.SETCURRENTKEY(CreditMemoHeader."Posting Date");
        CreditMemoHeader.SETRANGE(CreditMemoHeader."Posting Date","Start Date","End Date");
        IF CreditMemoHeader.FIND('-') THEN
          BEGIN
               REPEAT

                  CreditMemoLine.SETRANGE(CreditMemoLine."Document No.",CreditMemoHeader."No.");
                  CreditMemoLine.SETRANGE(CreditMemoLine.Type,CreditMemoLine.Type::Item);

                  //get promoter info if any
                  PromoterCode:=CreditMemoHeader."Customer Price Group";
                  IF PromoterCode<>'' THEN
                      BEGIN
                        PromoterDescription:=GetPromoterDescription(PromoterCode);
                        GotPromoter:=TRUE;

                     END;

        IF GotPromoter THEN
        BEGIN
                  IF  CreditMemoLine.FIND('-') THEN
                     BEGIN
                          REPEAT

                            //get item details
                            RetrieveItemInfo( CreditMemoLine."No.");
                            ItemCategoryDescription:= GetItemcategoryDescription(ItemCategoryCode);



                            TempTable.INIT;
                            TempTable."Document No":=CreditMemoLine."Document No.";

                            TempTable."Entry No":=EntryNo;
                            TempTable."Name Code":=  PromoterCode;
                            TempTable."Name Description":= PromoterDescription;
                            TempTable."Customer Code":=CreditMemoLine."Sell-to Customer No.";
                            TempTable."Customer Description":=GetCustomerDescription(CreditMemoLine."Sell-to Customer No.");
                            TempTable."Item Code":=CreditMemoLine."No." ;
                            RetrieveItemInfo(CreditMemoLine."No.");
                            TempTable."Item Description":=ItemDescription;
                            TempTable."Sales Qty":=  CreditMemoLine.Quantity;
                            TempTable."Line Amount":=CreditMemoLine.Amount*(-1);
                            TempTable."Invoice Date":=CreditMemoHeader."Posting Date" ;

                            TempTable."Product Group Code":=   ProductGroupCode;
                            TempTable."Product Group Description":=GetProductGroupDescription(ProductGroupCode,ItemCategoryCode);
                            TempTable."Item Category Code":= ItemCategoryCode;
                            TempTable."Item category Description":= GetItemcategoryDescription(ItemCategoryCode);

                            TempTable."Report Type":=TempTable."Report Type"::SaleComm;
                            TempTable.Type:= TempTable.Type::Salesperson;
                            TempTable."Unit Price":= CreditMemoLine."Unit Price";
                            TempTable."Cost Price":=(-1)*CreditMemoLine.Quantity*CreditMemoLine."Unit Cost (LCY)";
                            TempTable."Sales Margin":=(-1)*CreditMemoLine.Quantity*(CreditMemoLine."Unit Price"-
                            CreditMemoLine."Unit Cost (LCY)");
                            "Calculated Comm":=(-1)*GetPromoterCommRate(PromoterCode,CreditMemoLine."No.")* CreditMemoLine.Quantity;

                             //<120 days
                             IF("End Date"-"Start Date"<120) THEN
                                 TempTable."Comm (Paid)":="Calculated Comm"
                             ELSE
                                 TempTable."Comm (Unpaid)":="Calculated Comm" ;

                             //document type = CreditMemo
                             TempTable."Document Type":=TempTable."Document Type"::CreditMemo;

                             TempTable.INSERT;
                             EntryNo+=1;

               UNTIL (CreditMemoLine.NEXT=0);
            END;
        //got promoter end
        END;
          UNTIL (CreditMemoHeader.NEXT=0);
        END;
        Range:=Range+'..'+FORMAT(EntryNo);
        */

    end;

    procedure AddProdCommSummaryToTable(DocumentNo: Code[20]; ItemNo: Code[20]; ProdCommPaid: Decimal; ProdCommUnpaid: Decimal)
    begin
        //{TJCSG1.00 #4}TempTable.SETCURRENTKEY(TempTable."Document No",TempTable."Document Type");
        /*TJCSG1.00 #4*/
        TempTable.SETCURRENTKEY(TempTable."Document No", TempTable."Document Type", "Item Code");
        TempTable.SETRANGE(TempTable."Document No", DocumentNo);
        TempTable.SETFILTER(TempTable."Document Type", '<>%1', TempTable."Document Type"::Opening);
        TempTable.SETRANGE(TempTable."Item Code", ItemNo);
        IF TempTable.FIND('-') THEN BEGIN
            TempTable."Production Comm (Paid)" += ProdCommPaid;
            TempTable."Production Comm (Unpaid)" += ProdCommUnpaid;
            TempTable.MODIFY;
            //AddToTempTable2(DocumentNo,ProdCommPaid,'CommSummary');
        END

    end;

    procedure AddCommToTable(Type: Text[30]; "Name Code": Code[20]; Description: Text[50]; CommPaid: Decimal; CommUnpaid: Decimal; EntryNo: Integer)
    begin
        /*TJCSG1.00 #2 Start*/
        //TempTable.SETCURRENTKEY(TempTable."Name Description",TempTable.Type);
        //TempTable.SETRANGE(TempTable."Name Description",Description);

        TempTable.SETCURRENTKEY("Name Code");
        TempTable.SETRANGE("Name Code", "Name Code");
        /*TJCSG1.00 #2 End*/
        // AddToTempTable2("Name Code",CommPaid,'CommTable');
        IF TempTable.FIND('-') THEN BEGIN
            TempTable."Production Comm (Paid)" += CommPaid;/*TJCSG1.00 #7*/ //:=TempTable."Production Comm (Paid)"+CommPaid;
            TempTable."Production Comm (Unpaid)" += CommUnpaid;/*TJCSG1.00 #7*///:=TempTable."Production Comm (Unpaid)"+CommUnpaid;
            TempTable.MODIFY;
        END
        ELSE BEGIN
            TempTable.INIT;
            TempTable."Entry No" := EntryNo;
            TempTable."Document Type" := TempTable."Document Type"::NA;
            TempTable."Name Code" := "Name Code";
            /*TJCSG1.00 #3 Start*/
            IF Description = '' THEN
                TempTable."Name Description" := "Name Code"
            ELSE
                /*TJCSG1.00 #3 End*/
                      TempTable."Name Description" := Description;
            IF Type = 'Management' THEN BEGIN
                TempTable."Report Type" := TempTable."Report Type"::MgtComm;
                TempTable.Type := TempTable.Type::Management;
            END
            ELSE BEGIN
                TempTable."Report Type" := TempTable."Report Type"::ProdComm;
                TempTable.Type := TempTable.Type::Production;
            END;

            TempTable."Production Comm (Paid)" += CommPaid;/*TJCSG1.00 #7*///:=TempTable."Production Comm (Paid)";
            TempTable."Production Comm (Unpaid)" += CommUnpaid;/*TJCSG1.00 #7*///:=TempTable."Production Comm (Unpaid)";
            TempTable.INSERT;


        END;

    end;

    procedure GetItemCostPrice("Item Code": Code[20]) Price: Decimal
    var
        Item: Record Item;
        ItemCostMgt: Codeunit ItemCostManagement;
        AverageCostLCY: Decimal;
        AverageCostACY: Decimal;
    begin

        Item.SETRANGE(Item."No.", "Item Code");
        IF Item.FIND('-') THEN BEGIN
            ItemCostMgt.CalculateAverageCost(Item, AverageCostLCY, AverageCostACY);
            Price := AverageCostLCY;
        END;
    end;

    procedure RetrieveInvoice("Start Date": Date; "End Date": Date; "Production Incentive Group": Code[20]; TypeofReport: Text[30]) Range: Text[30]
    var
        "Calculated Comm": Decimal;
        "Total Sale": Decimal;
        "Total Production Sale": Decimal;
        User: Record "User Setup";
        CreditMemoLine: Record "Sales Cr.Memo Line";
        CreditMemoHeader: Record "Sales Cr.Memo Header";
        PromoterCode: Code[20];
        PromoterDescription: Text[50];
        GotPromoter: Boolean;
        ItemCategoryDescription: Text[50];
        OpeningAR: Record "Temp Table" temporary;
        ItemCostPrice: Decimal;
        ProdCommPaid: Decimal;
        ProdCommUnpaid: Decimal;
        TotalProdCommPaid: Decimal;
        TotalProdCommUnpaid: Decimal;
        ProdComm: Boolean;
        SalesComm: Boolean;
        MgtComm: Boolean;
        lrCLE: Record "Cust. Ledger Entry";
        lbFound: Boolean;
        DtldCustLedgEntry1: Record "Detailed Cust. Ledg. Entry";
        DtldCustLedgEntry2: Record "Detailed Cust. Ledg. Entry";
        lrSIH: Record "Sales Invoice Header";
        firstAug2023: Date;
        lrSCMH: Record "Sales Cr.Memo Header";
    begin
        EVALUATE(firstAug2023, '01/08/2023');
        CLEAR(TempTable); //TJCSG1.00 #7
        //TTable.RESET;
        //IF TTable.FIND('-') THEN TTable.DELETEALL;
        //TTableEntryNo:=0;

        CASE TypeofReport OF
            'SalesComm':
                BEGIN
                    ProdComm := FALSE;
                    SalesComm := TRUE;
                    MgtComm := FALSE;
                END;
            'ProdComm':
                BEGIN
                    ProdComm := TRUE;
                    //SalesComm:=FALSE;     //temp - del
                    SalesComm := TRUE;        //temp - ins
                    MgtComm := FALSE;
                END;
            'MgtComm':
                BEGIN
                    ProdComm := FALSE;
                    SalesComm := FALSE;
                    MgtComm := TRUE;
                END;
            'ItemComm':
                BEGIN
                    ProdComm := TRUE;
                    SalesComm := TRUE;
                    MgtComm := TRUE;
                END;

        END;
        //delete record that document type are not equal 'Opening'
        //Record with 'Opening' are sales invoice line from old system
        /*TJCSG1.00 #6 Start*/
        //Remark All
        /*
        TempTable.SETCURRENTKEY("Document Type");

        TempTable.SETRANGE("Document Type",TempTable."Document Type"::Invoice);
        TempTable.DELETEALL;
        TempTable.SETRANGE("Document Type",TempTable."Document Type"::CreditMemo);
        TempTable.DELETEALL;
        TempTable.SETRANGE("Document Type",TempTable."Document Type"::NA);
        TempTable.DELETEALL;
        COMMIT;

        //get the new entry number
        TempTable.RESET;
        IF TempTable.FIND('+') THEN
           EntryNo:=TempTable."Entry No"+1
        ELSE
            EntryNo:=1;
        */
        //End of Remark All
        /*TJCSG1.00 End*/

        /*TJCSG1.00 Start*/
        //New Code
        DBTempTable.SETCURRENTKEY("Document Type");

        DBTempTable.SETRANGE("Document Type", TempTable."Document Type"::Invoice);
        DBTempTable.DELETEALL;
        DBTempTable.SETRANGE("Document Type", TempTable."Document Type"::CreditMemo);
        DBTempTable.DELETEALL;
        DBTempTable.SETRANGE("Document Type", TempTable."Document Type"::NA);
        DBTempTable.DELETEALL;
        COMMIT;

        //get the new entry number
        DBTempTable.RESET;
        IF DBTempTable.FIND('+') THEN
            EntryNo := TempTable."Entry No" + 1
        ELSE
            EntryNo := 1;
        //End New Code
        /*TJCSG1.00 End*/


        Range := FORMAT(EntryNo);
        // {TJCSG1.00 #4} CustLedgerEntry.SETCURRENTKEY("Document Type","Closed at Date");
        /*TJCSG1.00 #4*/
        CustLedgerEntry.SETCURRENTKEY("Document Type", "Closed at Date", "Sell-to Customer No.", "Journal Batch Name");
        CustLedgerEntry.SETRANGE(CustLedgerEntry."Document Type", CustLedgerEntry."Document Type"::Invoice);
        CustLedgerEntry.SETRANGE(CustLedgerEntry."Closed at Date", "Start Date", "End Date");

        //CustLedgerEntry.SETRANGE("Document No.",'INV09/06346');   //debug

        //get invoice that is closed between selected date range

        //=================================================
        //Part 1 - Invoice
        //=================================================

        /*TJCSG1.00 #6 Start*/
        pBarShowTime := FALSE;
        /*
      IF NOT CONFIRM('Do you to show executing time ?') THEN
        pBarShowTime:=FALSE
      ELSE
        pBarShowTime:=TRUE;
         */
        pBarStartTime := TIME;

        IF CustLedgerEntry.FIND('-') THEN
            PBarStart(CustLedgerEntry.COUNT);

        /*TJCSG1.00 #6 End */
        IF CustLedgerEntry.FIND('-') THEN BEGIN
            REPEAT
                /*TJCSG1.00 #6 */
                PBarUpdate2(CustLedgerEntry."Document No.", 0);
                //20090529 [
                /*DP.EDS Start 27/08/09 #1*/
                IF Customer.GET(CustLedgerEntry."Sell-to Customer No.") THEN //;{TJCSG1.00 #7}
                                                                             /*DP.EDS End 27/08/09 #1*/
            IF NOT Customer."Exclude from Prod. Comm." THEN BEGIN
                        //20090529 ]
                        IF NOT (CustLedgerEntry."Journal Batch Name" = 'OPENING') THEN BEGIN
                            //get invoive line base on invoice no.
                            SalesInvoiceLine.SETCURRENTKEY("Document No.", Type);
                            SalesInvoiceLine.SETRANGE(SalesInvoiceLine."Document No.", CustLedgerEntry."Document No.");
                            //SalesInvoiceLine.SETRANGE(SalesInvoiceLine.Type,SalesInvoiceLine.Type::Item);
                            SalesInvoiceLine.SETFILTER(SalesInvoiceLine.Amount, '<>%1', 0);
                            //set saleperson code and salesperson name
                            SalespersonCode := CustLedgerEntry."Salesperson Code";
                            /*TJCSG1.00 #6 Start*/
                            IF SalesInvoiceLine.FIND('-') THEN
                                pBarTotal := pBarTotal + SalesInvoiceLine.COUNT;
                            /*TJCSG1.00 #6 End*/
                            IF SalesInvoiceLine.FIND('-') THEN
                                REPEAT
                                    IF (SalesInvoiceLine.Type = SalesInvoiceLine.Type::Item) THEN BEGIN
                                        /*TJCSG1.00 #6 */
                                        PBarUpdate2(CustLedgerEntry."Document No.", SalesInvoiceLine."Line No.");
                                        //reset for each invoice
                                        "Total Sale" := 0;
                                        "Total Production Sale" := 0;

                                        //get item details
                                        RetrieveItemInfo(SalesInvoiceLine."No.");
                                        ItemCategoryDescription := GetItemcategoryDescription(ItemCategoryCode);


                                        //add to total sales figure
                                        "Total Sale" := SalesInvoiceLine.Amount;

                                        //add to total production sale figure if it is the selected group
                                        IF ProductGroupCode = "Production Incentive Group" THEN
                                            "Total Production Sale" := SalesInvoiceLine.Amount;
                                        IF SalesComm THEN BEGIN

                                            TempTable.INIT;
                                            TempTable."Document No" := SalesInvoiceLine."Document No.";
                                            TempTable."Entry No" := EntryNo;
                                            TempTable."Name Code" := SalespersonCode;
                                            TempTable."Name Description" := GetSalespersonDescription(SalespersonCode);
                                            TempTable."Customer Code" := SalesInvoiceLine."Sell-to Customer No.";
                                            TempTable."Customer Description" := GetCustomerDescription(SalesInvoiceLine."Sell-to Customer No.");
                                            TempTable."Item Code" := SalesInvoiceLine."No.";
                                            TempTable."Item Description" := ItemDescription;

                                            TempTable."Sales Qty" := SalesInvoiceLine.Quantity;
                                            TempTable."Line Amount" := SalesInvoiceLine.Amount;
                                            TempTable."Invoice Date" := CustLedgerEntry."Posting Date";

                                            TempTable."Closing Date" := CustLedgerEntry."Closed at Date";
                                            TempTable."Product Group Code" := ProductGroupCode;
                                            TempTable."Product Group Description" := GetProductGroupDescription(ProductGroupCode, ItemCategoryCode);
                                            TempTable."Item Category Code" := ItemCategoryCode;

                                            TempTable."Item category Description" := ItemCategoryDescription;

                                            TempTable."Report Type" := TempTable."Report Type"::SaleComm;
                                            TempTable.Type := TempTable.Type::Salesperson;
                                            TempTable."Unit Price" := SalesInvoiceLine."Unit Price";
                                            TempTable."Cost Price" := SalesInvoiceLine.Quantity * SalesInvoiceLine."Unit Cost (LCY)";
                                            TempTable."Sales Margin" := SalesInvoiceLine.Quantity * (SalesInvoiceLine."Unit Price" -
                                            SalesInvoiceLine."Unit Cost (LCY)");
                                            "Calculated Comm" := RetrieveCommrate(ItemCategoryCode) * SalesInvoiceLine.Amount / 100;

                                            //<120 days go to paid else unpaid
                                            IF ("End Date" - "Start Date" < 120) THEN
                                                TempTable."Comm (Paid)" := "Calculated Comm"
                                            ELSE
                                                TempTable."Comm (Unpaid)" := "Calculated Comm";

                                            //calculate customer point
                                            TempTable."Customer Point" := (GetCustomerPointRate(ProductGroupCode, ItemCategoryCode, SalesInvoiceLine."Return Reason Code") / 100) * SalesInvoiceLine.Amount;

                                            //document type = invoice
                                            TempTable."Document Type" := TempTable."Document Type"::Invoice;

                                            TempTable.INSERT;
                                            EntryNo += 1;
                                        END;
                                        //salescomm true

                                        //Calculate the commission for management and production staff

                                        //====management staff commission

                                        IF MgtComm THEN BEGIN
                                            //use to populate temp table invoice line
                                            TotalProdCommPaid := 0;
                                            TotalProdCommUnpaid := 0;

                                            /*TJCSG1.00 #6*/
                                            User.SETCURRENTKEY("Staff Level");
                                            User.SETRANGE(User."Staff Level", User."Staff Level"::Management);
                                            IF User.FIND('-') THEN BEGIN
                                                REPEAT

                                                    ProdCommPaid := 0;
                                                    ProdCommUnpaid := 0;

                                                    "Calculated Comm" := ("Total Sale" * User."Commission Rate" / 100) / 7;
                                                    //"Calculated Comm":=round("Calculated Comm",0.01); //yadi

                                                    //<120 days
                                                    IF ("End Date" - "Start Date" < 120) THEN
                                                        ProdCommPaid := "Calculated Comm"
                                                    ELSE
                                                        ProdCommUnpaid := "Calculated Comm";


                                                    AddCommToTable('Management', User."User ID", GetSatffDescription(User."User ID"),
                                                                      ProdCommPaid, ProdCommUnpaid, EntryNo);
                                                    TotalProdCommPaid := TotalProdCommPaid + ProdCommPaid;
                                                    TotalProdCommUnpaid := TotalProdCommUnpaid + ProdCommUnpaid;

                                                    //AddProdCommSummaryToTable(SalesInvoiceLine."Document No.",SalesInvoiceLine."No.",
                                                    // ProdCommPaid,ProdCommUnpaid);
                                                    EntryNo += 1;

                                                UNTIL (User.NEXT = 0);
                                            END;
                                        END;
                                        //===production staff commission

                                        IF ProdComm THEN BEGIN
                                            /*TJCSG1.00 #6*/
                                            User.SETCURRENTKEY("Staff Level");
                                            User.SETRANGE(User."Staff Level", User."Staff Level"::Production);
                                            IF User.FIND('-') THEN
                                                REPEAT
                                                    ProdCommPaid := 0;
                                                    ProdCommUnpaid := 0;
                                                    "Calculated Comm" := "Total Production Sale" * User."Commission Rate" * GetGroupCommRate(ProductGroupCode) / 10000;

                                                    //<120 days
                                                    IF ("End Date" - "Start Date" < 120) THEN
                                                        ProdCommPaid := "Calculated Comm"
                                                    ELSE
                                                        ProdCommUnpaid := "Calculated Comm";

                                                    AddCommToTable('Production', User."User ID", GetSatffDescription(User."User ID"),
                                                    ProdCommPaid, ProdCommUnpaid, EntryNo);
                                                    TotalProdCommPaid := TotalProdCommPaid + ProdCommPaid;
                                                    TotalProdCommUnpaid := TotalProdCommUnpaid + ProdCommUnpaid;

                                                    //    AddProdCommSummaryToTable(SalesInvoiceLine."Document No.",SalesInvoiceLine."No.",
                                                    //     ProdCommPaid,ProdCommUnpaid);

                                                    EntryNo += 1;

                                                UNTIL (User.NEXT = 0);
                                            //update to table
                                            AddProdCommSummaryToTable(SalesInvoiceLine."Document No.", SalesInvoiceLine."No.",
                                                                      TotalProdCommPaid, TotalProdCommUnpaid);
                                        END;
                                    END ELSE BEGIN
                                        //Check if account is 6030 and posting date after August
                                        lrSIH.GET(SalesInvoiceLine."Document No.");
                                        IF SalesComm AND (SalesInvoiceLine."No." = '6030') AND (lrSIH."Posting Date" >= firstAug2023) THEN BEGIN
                                            TempTable.INIT;
                                            TempTable."Document No" := SalesInvoiceLine."Document No.";
                                            TempTable."Entry No" := EntryNo;
                                            TempTable."Name Code" := SalespersonCode;
                                            TempTable."Name Description" := GetSalespersonDescription(SalespersonCode);
                                            TempTable."Customer Code" := SalesInvoiceLine."Sell-to Customer No.";
                                            TempTable."Customer Description" := GetCustomerDescription(SalesInvoiceLine."Sell-to Customer No.");
                                            TempTable."Item Code" := SalesInvoiceLine."No.";
                                            TempTable."Item Description" := SalesInvoiceLine.Description;

                                            TempTable."Sales Qty" := SalesInvoiceLine.Quantity;
                                            TempTable."Line Amount" := SalesInvoiceLine.Amount;
                                            TempTable."Invoice Date" := CustLedgerEntry."Posting Date";

                                            TempTable."Closing Date" := CustLedgerEntry."Closed at Date";

                                            TempTable."Report Type" := TempTable."Report Type"::SaleComm;
                                            TempTable.Type := TempTable.Type::Salesperson;
                                            TempTable."Unit Price" := SalesInvoiceLine."Unit Price";
                                            TempTable."Customer Point" := (GetCustomerPointRate('SG', '', SalesInvoiceLine."Return Reason Code") / 100) * SalesInvoiceLine.Amount;

                                            //document type = invoice
                                            TempTable."Document Type" := TempTable."Document Type"::Invoice;

                                            TempTable.INSERT;
                                            EntryNo += 1;
                                        END;
                                    END;
                                UNTIL (SalesInvoiceLine.NEXT = 0);
                            //for reason code not = opening

                        END
                        ELSE BEGIN
                            //============================================
                            //Part 1.B  - calculation for outstanding AR
                            //============================================

                            /*TJCSG1.00 #7 Start*/
                            CLEAR(OpeningAR);
                            OpeningAR.COPY(TempTable);
                            /*TJCSG1.00 #7 End*/

                            //get invoive line base on invoice no.
                            OpeningAR.SETCURRENTKEY(OpeningAR."Document No", OpeningAR."Document Type");
                            OpeningAR.SETRANGE(OpeningAR."Document No", CustLedgerEntry."Document No.");
                            OpeningAR.SETRANGE(OpeningAR."Document Type", OpeningAR."Document Type"::Opening);

                            //set saleperson code and salesperson name
                            SalespersonCode := CustLedgerEntry."Salesperson Code";
                            /*TJCSG1.00 #6 Start*/
                            IF OpeningAR.FIND('-') THEN
                                pBarTotal := pBarTotal + OpeningAR.COUNT;
                            /*TJCSG1.00 #6 End*/
                            IF OpeningAR.FIND('-') THEN BEGIN
                                REPEAT
                                    /*TJCSG1.00 #6 */
                                    PBarUpdate2(CustLedgerEntry."Document No.", -1);
                                    //reset for each invoice
                                    "Total Sale" := 0;
                                    "Total Production Sale" := 0;

                                    //get item details
                                    RetrieveItemInfo(OpeningAR."Item Code");


                                    ItemCategoryDescription := GetItemcategoryDescription(ItemCategoryCode);

                                    //add to total sales figure
                                    "Total Sale" := OpeningAR."Line Amount";

                                    //add to total production sale figure if it is the selected group
                                    IF ProductGroupCode = "Production Incentive Group" THEN
                                        "Total Production Sale" := OpeningAR."Line Amount";

                                    IF SalesComm THEN BEGIN
                                        TempTable.INIT;
                                        TempTable."Document No" := OpeningAR."Document No";
                                        TempTable."Entry No" := EntryNo;
                                        TempTable."Name Code" := SalespersonCode;
                                        TempTable."Name Description" := GetSalespersonDescription(SalespersonCode);
                                        TempTable."Customer Code" := CustLedgerEntry."Customer No.";
                                        TempTable."Customer Description" := GetCustomerDescription(CustLedgerEntry."Customer No.");
                                        TempTable."Item Code" := OpeningAR."Item Code";
                                        TempTable."Item Description" := ItemDescription;


                                        TempTable."Sales Qty" := OpeningAR."Sales Qty";
                                        TempTable."Line Amount" := OpeningAR."Line Amount";
                                        TempTable."Invoice Date" := OpeningAR."Invoice Date";


                                        TempTable."Closing Date" := CustLedgerEntry."Closed at Date";
                                        TempTable."Product Group Code" := ProductGroupCode;
                                        TempTable."Product Group Description" := GetProductGroupDescription(ProductGroupCode, ItemCategoryCode);
                                        TempTable."Item Category Code" := ItemCategoryCode;

                                        TempTable."Item category Description" := ItemCategoryDescription;

                                        TempTable."Report Type" := TempTable."Report Type"::SaleComm;
                                        TempTable.Type := TempTable.Type::Salesperson;
                                        TempTable."Unit Price" := OpeningAR."Unit Price";

                                        ItemCostPrice := GetItemCostPrice(OpeningAR."Item Code");

                                        TempTable."Cost Price" := OpeningAR."Sales Qty" * ItemCostPrice;
                                        TempTable."Sales Margin" := OpeningAR."Sales Qty" * (OpeningAR."Unit Price" -
                                                                   ItemCostPrice);

                                        "Calculated Comm" := RetrieveCommrate(ItemCategoryCode) * OpeningAR."Line Amount" / 100;

                                        //<120 days go to paid else unpaid
                                        IF ("End Date" - "Start Date" < 120) THEN
                                            TempTable."Comm (Paid)" := "Calculated Comm"
                                        ELSE
                                            TempTable."Comm (Unpaid)" := "Calculated Comm";

                                        //calculate customer point
                                        TempTable."Customer Point" := (GetCustomerPointRate(ProductGroupCode, ItemCategoryCode, '') / 100) * OpeningAR."Line Amount";

                                        //document type = invoice
                                        TempTable."Document Type" := TempTable."Document Type"::Invoice;

                                        TempTable.INSERT;
                                        EntryNo += 1;
                                    END; //salescomm end

                                    //Calculate the commission for management and production staff

                                    IF MgtComm THEN BEGIN
                                        //====management staff commission
                                        TotalProdCommPaid := 0;
                                        TotalProdCommUnpaid := 0;
                                        /*TJCSG1.00 #6*/
                                        User.SETCURRENTKEY("Staff Level");
                                        User.SETRANGE(User."Staff Level", User."Staff Level"::Management);
                                        IF User.FIND('-') THEN
                                            REPEAT
                                                ProdCommPaid := 0;
                                                ProdCommUnpaid := 0;

                                                "Calculated Comm" := ("Total Sale" * User."Commission Rate" / 100) / 7;

                                                //<120 days
                                                IF ("End Date" - "Start Date" < 120) THEN
                                                    ProdCommPaid := "Calculated Comm"
                                                ELSE
                                                    ProdCommUnpaid := "Calculated Comm";
                                                TotalProdCommPaid := TotalProdCommPaid + ProdCommPaid;
                                                TotalProdCommUnpaid := TotalProdCommUnpaid + ProdCommUnpaid;

                                                //document type = NA
                                                TempTable."Document Type" := TempTable."Document Type"::NA;
                                                AddCommToTable('Management', User."User ID", GetSatffDescription(User."User ID"),
                                                ProdCommPaid, ProdCommUnpaid, EntryNo);

                                                EntryNo += 1;

                                            UNTIL (User.NEXT = 0);

                                    END; //mgtcomm end
                                         //===production staff commission

                                    IF ProdComm THEN BEGIN
                                        /*TJCSG1.00 #6*/
                                        User.SETCURRENTKEY("Staff Level");
                                        User.SETRANGE(User."Staff Level", User."Staff Level"::Production);
                                        IF User.FIND('-') THEN
                                            REPEAT
                                                ProdCommPaid := 0;
                                                ProdCommUnpaid := 0;

                                                "Calculated Comm" := "Total Production Sale" * User."Commission Rate" * GetGroupCommRate(ProductGroupCode) / 10000;

                                                //<120 days
                                                IF ("End Date" - "Start Date" < 120) THEN
                                                    ProdCommPaid := "Calculated Comm"
                                                ELSE
                                                    ProdCommUnpaid := "Calculated Comm";
                                                TotalProdCommPaid := TotalProdCommPaid + ProdCommPaid;
                                                TotalProdCommUnpaid := TotalProdCommUnpaid + ProdCommUnpaid;

                                                AddCommToTable('Production', User."User ID", GetSatffDescription(User."User ID"),
                                                ProdCommPaid, ProdCommUnpaid, EntryNo);

                                                EntryNo += 1;

                                            UNTIL (User.NEXT = 0);

                                        AddProdCommSummaryToTable(OpeningAR."Document No", OpeningAR."Item Code",
                                        TotalProdCommPaid, TotalProdCommUnpaid);

                                    END; //prodcomm end
                                UNTIL (OpeningAR.NEXT = 0);
                            END;

                            //============================================
                            //end of Part 1.B
                            //=============================================
                        END;
                    END      //20090529
                             // MESSAGE('TP828 invoice %1',CustLedgerEntry."Document No."); //20090529

            UNTIL (CustLedgerEntry.NEXT = 0);
        END;

        //DP.NCM TJC #504
        CustLedgerEntry.RESET;
        CustLedgerEntry.SETCURRENTKEY("Document Type", "Closed at Date", "Sell-to Customer No.", "Journal Batch Name");
        CustLedgerEntry.SETRANGE("Document Type", CustLedgerEntry."Document Type"::Invoice);
        CustLedgerEntry.SETRANGE(Open, FALSE);
        CustLedgerEntry.SETRANGE("Closed at Date", 0D);
        pBarShowTime := FALSE;
        pBarStartTime := TIME;
        IF CustLedgerEntry.FIND('-') THEN
            PBarStart(CustLedgerEntry.COUNT);
        IF CustLedgerEntry.FIND('-') THEN
            REPEAT
                //get appliled entry. Check Applied Entry, if the Posting Date of applied document (receipt)
                //is in date range entered in option (users enter month)
                lrCLE.RESET;
                lbFound := FALSE;
                lrCLE.SETCURRENTKEY("Closed by Entry No.");
                lrCLE.SETRANGE("Closed by Entry No.", CustLedgerEntry."Entry No.");
                lrCLE.SETRANGE("Posting Date", "Start Date", "End Date");
                IF lrCLE.FIND('-') THEN
                    lbFound := TRUE;

                DtldCustLedgEntry1.SETCURRENTKEY("Cust. Ledger Entry No.");
                DtldCustLedgEntry1.SETRANGE("Cust. Ledger Entry No.", CustLedgerEntry."Entry No.");
                DtldCustLedgEntry1.SETRANGE(Unapplied, FALSE);
                IF DtldCustLedgEntry1.FIND('-') THEN
                    REPEAT
                        IF DtldCustLedgEntry1."Cust. Ledger Entry No." = DtldCustLedgEntry1."Applied Cust. Ledger Entry No." THEN BEGIN
                            DtldCustLedgEntry2.INIT;
                            DtldCustLedgEntry2.SETCURRENTKEY("Applied Cust. Ledger Entry No.", "Entry Type");
                            DtldCustLedgEntry2.SETRANGE(
                              "Applied Cust. Ledger Entry No.", DtldCustLedgEntry1."Applied Cust. Ledger Entry No.");
                            DtldCustLedgEntry2.SETRANGE("Entry Type", DtldCustLedgEntry2."Entry Type"::Application);
                            DtldCustLedgEntry2.SETRANGE(Unapplied, FALSE);
                            IF DtldCustLedgEntry2.FIND('-') THEN
                                REPEAT
                                    IF DtldCustLedgEntry2."Cust. Ledger Entry No." <>
                                      DtldCustLedgEntry2."Applied Cust. Ledger Entry No."
                                    THEN BEGIN
                                        lrCLE.SETCURRENTKEY("Entry No.");
                                        lrCLE.SETRANGE("Entry No.", DtldCustLedgEntry2."Cust. Ledger Entry No.");
                                        IF lrCLE.FIND('-') THEN
                                            lbFound := TRUE;
                                    END;
                                UNTIL DtldCustLedgEntry2.NEXT = 0;
                        END ELSE BEGIN
                            lrCLE.SETCURRENTKEY("Entry No.");
                            lrCLE.SETRANGE("Entry No.", DtldCustLedgEntry1."Applied Cust. Ledger Entry No.");
                            IF lrCLE.FIND('-') THEN
                                lbFound := TRUE;
                        END;
                    UNTIL DtldCustLedgEntry1.NEXT = 0;

                PBarUpdate2(CustLedgerEntry."Document No.", 0);
                IF Customer.GET(CustLedgerEntry."Sell-to Customer No.") THEN;
                IF (NOT Customer."Exclude from Prod. Comm.") AND
                  (NOT (CustLedgerEntry."Journal Batch Name" = 'OPENING')) AND lbFound THEN BEGIN
                    //get invoive line base on invoice no.
                    SalesInvoiceLine.SETCURRENTKEY("Document No.", Type);
                    SalesInvoiceLine.SETRANGE(SalesInvoiceLine."Document No.", CustLedgerEntry."Document No.");
                    SalesInvoiceLine.SETRANGE(SalesInvoiceLine.Type, SalesInvoiceLine.Type::Item);
                    SalesInvoiceLine.SETFILTER(SalesInvoiceLine.Amount, '<>%1', 0);
                    //set saleperson code and salesperson name
                    SalespersonCode := CustLedgerEntry."Salesperson Code";
                    IF SalesInvoiceLine.FIND('-') THEN
                        pBarTotal := pBarTotal + SalesInvoiceLine.COUNT;
                    IF SalesInvoiceLine.FIND('-') THEN
                        REPEAT
                            PBarUpdate2(CustLedgerEntry."Document No.", SalesInvoiceLine."Line No.");
                            //reset for each invoice
                            "Total Sale" := 0;
                            "Total Production Sale" := 0;
                            //get item details
                            RetrieveItemInfo(SalesInvoiceLine."No.");
                            ItemCategoryDescription := GetItemcategoryDescription(ItemCategoryCode);
                            //add to total sales figure
                            "Total Sale" := SalesInvoiceLine.Amount;
                            //add to total production sale figure if it is the selected group
                            IF ProductGroupCode = "Production Incentive Group" THEN
                                "Total Production Sale" := SalesInvoiceLine.Amount;
                            IF SalesComm THEN BEGIN
                                TempTable.INIT;
                                TempTable."Document No" := SalesInvoiceLine."Document No.";
                                TempTable."Entry No" := EntryNo;
                                TempTable."Name Code" := SalespersonCode;
                                TempTable."Name Description" := GetSalespersonDescription(SalespersonCode);
                                TempTable."Customer Code" := SalesInvoiceLine."Sell-to Customer No.";
                                TempTable."Customer Description" := GetCustomerDescription(SalesInvoiceLine."Sell-to Customer No.");
                                TempTable."Item Code" := SalesInvoiceLine."No.";
                                TempTable."Item Description" := ItemDescription;
                                TempTable."Sales Qty" := SalesInvoiceLine.Quantity;
                                TempTable."Line Amount" := SalesInvoiceLine.Amount;
                                TempTable."Invoice Date" := CustLedgerEntry."Posting Date";
                                TempTable."Closing Date" := CustLedgerEntry."Closed at Date";
                                TempTable."Product Group Code" := ProductGroupCode;
                                TempTable."Product Group Description" := GetProductGroupDescription(ProductGroupCode, ItemCategoryCode);
                                TempTable."Item Category Code" := ItemCategoryCode;
                                TempTable."Item category Description" := ItemCategoryDescription;
                                TempTable."Report Type" := TempTable."Report Type"::SaleComm;
                                TempTable.Type := TempTable.Type::Salesperson;
                                TempTable."Unit Price" := SalesInvoiceLine."Unit Price";
                                TempTable."Cost Price" := SalesInvoiceLine.Quantity * SalesInvoiceLine."Unit Cost (LCY)";
                                TempTable."Sales Margin" := SalesInvoiceLine.Quantity * (SalesInvoiceLine."Unit Price" -
                                SalesInvoiceLine."Unit Cost (LCY)");
                                "Calculated Comm" := RetrieveCommrate(ItemCategoryCode) * SalesInvoiceLine.Amount / 100;
                                //<120 days go to paid else unpaid
                                IF ("End Date" - "Start Date" < 120) THEN
                                    TempTable."Comm (Paid)" := "Calculated Comm"
                                ELSE
                                    TempTable."Comm (Unpaid)" := "Calculated Comm";
                                //calculate customer point
                                TempTable."Customer Point" := (GetCustomerPointRate(ProductGroupCode, ItemCategoryCode, SalesInvoiceLine."Return Reason Code") / 100) * SalesInvoiceLine.Amount;
                                //document type = invoice
                                TempTable."Document Type" := TempTable."Document Type"::Invoice;
                                TempTable.INSERT;
                                EntryNo += 1;
                            END;
                            IF MgtComm THEN BEGIN
                                //use to populate temp table invoice line
                                TotalProdCommPaid := 0;
                                TotalProdCommUnpaid := 0;
                                User.SETCURRENTKEY("Staff Level");
                                User.SETRANGE(User."Staff Level", User."Staff Level"::Management);
                                IF User.FIND('-') THEN BEGIN
                                    REPEAT

                                        ProdCommPaid := 0;
                                        ProdCommUnpaid := 0;
                                        "Calculated Comm" := ("Total Sale" * User."Commission Rate" / 100) / 7;
                                        //"Calculated Comm":=round("Calculated Comm",0.01); //yadi
                                        //<120 days
                                        IF ("End Date" - "Start Date" < 120) THEN
                                            ProdCommPaid := "Calculated Comm"
                                        ELSE
                                            ProdCommUnpaid := "Calculated Comm";
                                        AddCommToTable('Management', User."User ID", GetSatffDescription(User."User ID"),
                                                          ProdCommPaid, ProdCommUnpaid, EntryNo);
                                        TotalProdCommPaid := TotalProdCommPaid + ProdCommPaid;
                                        TotalProdCommUnpaid := TotalProdCommUnpaid + ProdCommUnpaid;
                                        EntryNo += 1;
                                    UNTIL (User.NEXT = 0);
                                END;
                            END;
                            //===production staff commission
                            IF ProdComm THEN BEGIN
                                User.SETCURRENTKEY("Staff Level");
                                User.SETRANGE(User."Staff Level", User."Staff Level"::Production);
                                IF User.FIND('-') THEN
                                    REPEAT
                                        ProdCommPaid := 0;
                                        ProdCommUnpaid := 0;
                                        "Calculated Comm" := "Total Production Sale" * User."Commission Rate" * GetGroupCommRate(ProductGroupCode) / 10000;
                                        //<120 days
                                        IF ("End Date" - "Start Date" < 120) THEN
                                            ProdCommPaid := "Calculated Comm"
                                        ELSE
                                            ProdCommUnpaid := "Calculated Comm";
                                        AddCommToTable('Production', User."User ID", GetSatffDescription(User."User ID"),
                                        ProdCommPaid, ProdCommUnpaid, EntryNo);
                                        TotalProdCommPaid := TotalProdCommPaid + ProdCommPaid;
                                        TotalProdCommUnpaid := TotalProdCommUnpaid + ProdCommUnpaid;
                                        EntryNo += 1;
                                    UNTIL (User.NEXT = 0);
                                //update to table
                                AddProdCommSummaryToTable(SalesInvoiceLine."Document No.", SalesInvoiceLine."No.",
                                                          TotalProdCommPaid, TotalProdCommUnpaid);
                            END;
                        UNTIL (SalesInvoiceLine.NEXT = 0);
                    //for reason code not = opening
                END;
            UNTIL (CustLedgerEntry.NEXT = 0);
        //DP.NCM TJC #504

        //=================================================
        //Part 2 - CREDIT MEMO calculation
        //=================================================
        //get credit memo that is within the selected date
        //CreditMemoHeader.SETCURRENTKEY(CreditMemoHeader."Posting Date");
        /*TJCSG1.00 #6*/
        CreditMemoHeader.SETCURRENTKEY("Posting Date", "Sell-to Customer No.");
        CreditMemoHeader.SETRANGE(CreditMemoHeader."Posting Date", "Start Date", "End Date");
        //CreditMemoHeader.SETRANGE(CreditMemoHeader."Sell-to Customer No.",'TP828');  //debug

        /*TJCSG1.00 #6 Start*/
        IF CreditMemoHeader.FIND('-') THEN
            pBarTotal := pBarTotal + CreditMemoHeader.COUNT;
        /*TJCSG1.00 #6 End*/
        IF CreditMemoHeader.FIND('-') THEN
            REPEAT
                /*TJCSG1.00 #6 */
                PBarUpdate2(CreditMemoHeader."No.", -2);

                //20090529[
                /*DP.EDS Start 27/08/09 #1*/
                IF Customer.GET(CreditMemoHeader."Sell-to Customer No.") THEN;
                /*DP.EDS End 27/08/09 #1*/
                IF NOT Customer."Exclude from Prod. Comm." THEN BEGIN
                    //20090529 ]
                    /*TJCSG1.00 #6*/
                    CreditMemoLine.SETCURRENTKEY("Document No.", Type);
                    CreditMemoLine.SETRANGE(CreditMemoLine."Document No.", CreditMemoHeader."No.");
                    //CreditMemoLine.SETRANGE(CreditMemoLine.Type,CreditMemoLine.Type::Item);
                    CreditMemoLine.SETFILTER(Amount, '<>0');
                    /*TJCSG1.00 #6 Start*/
                    IF CreditMemoLine.FIND('-') THEN
                        pBarTotal := pBarTotal + CreditMemoLine.COUNT;
                    /*TJCSG1.00 #6 End*/
                    IF CreditMemoLine.FIND('-') THEN BEGIN
                        REPEAT
                            IF (CreditMemoLine.Type = CreditMemoLine.Type::Item) THEN BEGIN
                                /*TJCSG1.00 #6 */
                                PBarUpdate2(CreditMemoHeader."No.", CreditMemoLine."Line No.");
                                //reset to 0 for every new credit memo
                                "Total Sale" := 0;
                                "Total Production Sale" := 0;

                                //minus from total sales figure
                                "Total Sale" := CreditMemoLine.Amount;
                                RetrieveItemInfo(CreditMemoLine."No.");

                                //add to total production sale figure if it is the select group
                                IF ProductGroupCode = "Production Incentive Group" THEN
                                    "Total Production Sale" := CreditMemoLine.Amount;

                                IF SalesComm THEN BEGIN
                                    TempTable.INIT;


                                    TempTable."Document No" := CreditMemoLine."Document No.";

                                    TempTable."Entry No" := EntryNo;
                                    TempTable."Name Code" := CreditMemoHeader."Salesperson Code";
                                    TempTable."Name Description" := GetSalespersonDescription(CreditMemoHeader."Salesperson Code");
                                    TempTable."Customer Code" := CreditMemoLine."Sell-to Customer No.";
                                    TempTable."Customer Description" := GetCustomerDescription(CreditMemoLine."Sell-to Customer No.");
                                    TempTable."Item Code" := CreditMemoLine."No.";

                                    TempTable."Item Description" := ItemDescription;
                                    TempTable."Sales Qty" := CreditMemoLine.Quantity;
                                    TempTable."Line Amount" := CreditMemoLine.Amount * (-1);
                                    TempTable."Invoice Date" := CreditMemoHeader."Posting Date";

                                    //         //add to total production sale figure if it is the select group
                                    //          IF  ProductGroupCode="Production Incentive Group" THEN
                                    //                 "Total Production Sale":= CreditMemoLine.Amount;

                                    TempTable."Product Group Code" := ProductGroupCode;
                                    TempTable."Product Group Description" := GetProductGroupDescription(ProductGroupCode, ItemCategoryCode);
                                    TempTable."Item Category Code" := ItemCategoryCode;
                                    TempTable."Item category Description" := GetItemcategoryDescription(ItemCategoryCode);

                                    TempTable."Report Type" := TempTable."Report Type"::SaleComm;
                                    TempTable.Type := TempTable.Type::Salesperson;
                                    TempTable."Unit Price" := CreditMemoLine."Unit Price";
                                    TempTable."Cost Price" := (-1) * CreditMemoLine.Quantity * CreditMemoLine."Unit Cost (LCY)";
                                    TempTable."Sales Margin" := (-1) * CreditMemoLine.Quantity * (CreditMemoLine."Unit Price" -
                                    CreditMemoLine."Unit Cost (LCY)");
                                    "Calculated Comm" := (-1) * RetrieveCommrate(ItemCategoryCode) * CreditMemoLine.Amount / 100;

                                    //<120 days
                                    IF ("End Date" - "Start Date" < 120) THEN
                                        TempTable."Comm (Paid)" := "Calculated Comm"
                                    ELSE
                                        TempTable."Comm (Unpaid)" := "Calculated Comm";

                                    //calculate customer point
                                    TempTable."Customer Point" := (-1) * (GetCustomerPointRate(ProductGroupCode, ItemCategoryCode, CreditMemoLine."Return Reason Code") / 100)
                                               * CreditMemoLine.Amount;

                                    //document type = CreditMemo
                                    TempTable."Document Type" := TempTable."Document Type"::CreditMemo;

                                    TempTable.INSERT;
                                    EntryNo += 1;
                                END; //salescomm end

                                IF MgtComm THEN BEGIN
                                    //====management staff commission
                                    TotalProdCommPaid := 0;
                                    TotalProdCommUnpaid := 0;
                                    /*TJCSG1.00 #6*/
                                    User.SETCURRENTKEY("Staff Level");
                                    User.SETRANGE(User."Staff Level", User."Staff Level"::Management);
                                    IF User.FIND('-') THEN BEGIN
                                        REPEAT
                                            ProdCommPaid := 0;
                                            ProdCommUnpaid := 0;

                                            "Calculated Comm" := ("Total Sale" * User."Commission Rate" / 100) / 7;

                                            //<120 days
                                            IF ("End Date" - "Start Date" < 120) THEN
                                                ProdCommPaid := (-1) * "Calculated Comm"
                                            ELSE
                                                ProdCommUnpaid := (-1) * "Calculated Comm";

                                            TotalProdCommPaid := TotalProdCommPaid + ProdCommPaid;
                                            TotalProdCommUnpaid := TotalProdCommUnpaid + ProdCommUnpaid;

                                            AddCommToTable('Management', User."User ID", GetSatffDescription(User."User ID"),
                                            ProdCommPaid, ProdCommUnpaid, EntryNo);

                                            EntryNo += 1;

                                        UNTIL (User.NEXT = 0);
                                    END;
                                END; //mgtcomm end

                                IF ProdComm THEN BEGIN
                                    //===production staff commission

                                    /*TJCSG1.00 #6*/
                                    User.SETCURRENTKEY("Staff Level");
                                    User.SETRANGE(User."Staff Level", User."Staff Level"::Production);
                                    IF User.FIND('-') THEN BEGIN
                                        REPEAT
                                            ProdCommPaid := 0;
                                            ProdCommUnpaid := 0;

                                            "Calculated Comm" := "Total Production Sale" * User."Commission Rate" * GetGroupCommRate(ProductGroupCode) / 10000;

                                            //<120 days
                                            IF ("End Date" - "Start Date" < 120) THEN
                                                ProdCommPaid := (-1) * "Calculated Comm"
                                            ELSE
                                                ProdCommUnpaid := (-1) * "Calculated Comm";


                                            TotalProdCommPaid := TotalProdCommPaid + ProdCommPaid;
                                            TotalProdCommUnpaid := TotalProdCommUnpaid + ProdCommUnpaid;


                                            AddCommToTable('Production', User."User ID", GetSatffDescription(User."User ID"),
                                                           ProdCommPaid, ProdCommUnpaid, EntryNo);

                                            EntryNo += 1;

                                        UNTIL (User.NEXT = 0);
                                    END;
                                    AddProdCommSummaryToTable(CreditMemoLine."Document No.", CreditMemoLine."No.",
                                                              ProdCommPaid, ProdCommUnpaid);
                                END; //prodcomm end
                            END ELSE BEGIN
                                lrSCMH.GET(CreditMemoLine."Document No.");
                                IF SalesComm AND (lrSCMH."Posting Date" >= firstAug2023) AND (lrSCMH."No." <> '6030') THEN BEGIN
                                    TempTable.INIT;
                                    TempTable."Document No" := CreditMemoLine."Document No.";
                                    TempTable."Entry No" := EntryNo;
                                    TempTable."Name Code" := CreditMemoHeader."Salesperson Code";
                                    TempTable."Name Description" := GetSalespersonDescription(CreditMemoHeader."Salesperson Code");
                                    TempTable."Customer Code" := CreditMemoLine."Sell-to Customer No.";
                                    TempTable."Customer Description" := GetCustomerDescription(CreditMemoLine."Sell-to Customer No.");
                                    TempTable."Item Code" := CreditMemoLine."No.";

                                    TempTable."Item Description" := CreditMemoLine.Description;
                                    TempTable."Sales Qty" := CreditMemoLine.Quantity;
                                    TempTable."Line Amount" := CreditMemoLine.Amount * (-1);
                                    TempTable."Invoice Date" := CreditMemoHeader."Posting Date";


                                    TempTable."Report Type" := TempTable."Report Type"::SaleComm;
                                    TempTable.Type := TempTable.Type::Salesperson;
                                    TempTable."Unit Price" := CreditMemoLine."Unit Price";


                                    //calculate customer point
                                    TempTable."Customer Point" := (-1) * (GetCustomerPointRate('SG', '', CreditMemoLine."Return Reason Code") / 100)
                                               * CreditMemoLine.Amount;

                                    //document type = CreditMemo
                                    TempTable."Document Type" := TempTable."Document Type"::CreditMemo;

                                    TempTable.INSERT;
                                    EntryNo += 1;
                                END; //salescomm end

                            END;
                        UNTIL (CreditMemoLine.NEXT = 0);
                    END;
                END; //20090529
            UNTIL (CreditMemoHeader.NEXT = 0);


        Range := Range + '..' + FORMAT(EntryNo);

        /*TJCSG1.00 #6 Start*/
        TempTable.RESET;
        IF TempTable.FIND('-') THEN
            REPEAT
                DBTempTable.INIT;
                DBTempTable := TempTable;
                DBTempTable.INSERT;
            UNTIL TempTable.NEXT = 0;

        /*TJCSG1.00 #6 */
        PBarUpdateFinish;
        pBarDuration := TIME - pBarStartTime;
        IF pBarShowTime THEN
            MESSAGE('Executing process is %1', pBarDuration);
        /*TJCSG1.00 #6 End*/

    end;

    procedure ExportToExcel()
    var
        CurrentRow: Integer;
        CurrentCol: Integer;
        DataTable: Record "Temp Table";
        "Last Cell": Text[7];
    begin

        /*
        //setup data for exporting from temp table to excel file

        IF  NOT(CheckForDataRow()) THEN
        BEGIN

             //if no promoter,salesperson,management,production entry, create empty line if necessary
             CheckTypeInTable();



        CLEARALL;
        CREATE(xlApp);

        xlBook := xlApp.Workbooks.Add;

        xlSheet := xlBook.Worksheets.Item('Sheet1');
        xlSheet.Name := 'SourceData';

        //delete worksheet 2 and 3
        xlSheet :=xlBook.Worksheets.Item('Sheet2');
        xlSheet.Delete;

        xlSheet :=xlBook.Worksheets.Item('Sheet3');
        xlSheet.Delete;

        //activate worksheet 1
        xlSheet :=xlBook.Worksheets.Item('SourceData');
        xlSheet.Activate;


              //insert the header

              xlSheet.Range('A2').Value := 'Document Type';
              xlSheet.Range('B2').Value := 'Report Type';
              xlSheet.Range('C2').Value := 'Type';
              xlSheet.Range('D2').Value := 'Posting Date';
              xlSheet.Range('E2').Value := 'Closing Date';
              xlSheet.Range('F2').Value := 'Name Code';
              xlSheet.Range('G2').Value := 'Name Description';
              xlSheet.Range('H2').Value := 'Customer Code';
              xlSheet.Range('I2').Value := 'Customer Description';
              xlSheet.Range('J2').Value := 'Item Code';
              xlSheet.Range('K2').Value := 'Item Description';
              xlSheet.Range('L2').Value := 'Sales Qty';
              xlSheet.Range('M2').Value := 'Line Amount';
              xlSheet.Range('N2').Value := 'Product Group Code';
              xlSheet.Range('O2').Value := 'Product Group Description';
              xlSheet.Range('P2').Value := 'Item Category Code';
              xlSheet.Range('Q2').Value := 'Item category Description';
              xlSheet.Range('R2').Value := 'Unit Price';
              xlSheet.Range('S2').Value := 'Cost Price';
              xlSheet.Range('T2').Value := 'Sales Margin';
              xlSheet.Range('U2').Value := 'Comm (Paid)';
              xlSheet.Range('V2').Value := 'Comm (Unpaid)';
              xlSheet.Range('W2').Value := 'Production Comm (Paid)';
              xlSheet.Range('X2').Value := 'Production Comm (Unpaid)';
              xlSheet.Range('Y2').Value := 'Customer Point';
              xlSheet.Range('Z2').Value := 'Document No';
              xlSheet.Range('A2').EntireRow.Font.Bold := TRUE;

         //insert the value

              DataTable.RESET;
              CurrentRow := 2;
              CurrentCol := 1;
              DataTable.SETCURRENTKEY(DataTable."Entry No",DataTable."Document No",DataTable."Document Type");
              DataTable.SETFILTER(DataTable."Document Type",'<>%1',DataTable."Document Type"::Opening);
              IF DataTable.FIND('-') THEN
              BEGIN
                  REPEAT
                      BEGIN
                          CurrentRow := CurrentRow + 1;
                          CurrentCol := 1;
                          xlSheet.Range(fGetCell(CurrentRow,CurrentCol)).Value := FORMAT(DataTable."Document Type");
                          CurrentCol := CurrentCol + 1;
                           xlSheet.Range(fGetCell(CurrentRow,CurrentCol)).Value := FORMAT(DataTable."Report Type");
                          CurrentCol := CurrentCol + 1;
                          xlSheet.Range(fGetCell(CurrentRow,CurrentCol)).Value := FORMAT(DataTable.Type);
                          CurrentCol := CurrentCol + 1;
                          xlSheet.Range(fGetCell(CurrentRow,CurrentCol)).Value := FORMAT(DataTable."Invoice Date");
                          CurrentCol := CurrentCol + 1;
                          xlSheet.Range(fGetCell(CurrentRow,CurrentCol)).Value := FORMAT(DataTable."Closing Date");
                          CurrentCol := CurrentCol + 1;
                          xlSheet.Range(fGetCell(CurrentRow,CurrentCol)).Value := FORMAT(DataTable."Name Code");
                          CurrentCol := CurrentCol + 1;
                          xlSheet.Range(fGetCell(CurrentRow,CurrentCol)).Value := FORMAT(DataTable."Name Description");
                          CurrentCol := CurrentCol + 1;
                          xlSheet.Range(fGetCell(CurrentRow,CurrentCol)).Value := FORMAT(DataTable."Customer Code");
                          CurrentCol := CurrentCol + 1;
                          xlSheet.Range(fGetCell(CurrentRow,CurrentCol)).Value := FORMAT(DataTable."Customer Description");
                          CurrentCol := CurrentCol + 1;
                          xlSheet.Range(fGetCell(CurrentRow,CurrentCol)).Value := FORMAT(DataTable."Item Code");
                          CurrentCol := CurrentCol + 1;
                          xlSheet.Range(fGetCell(CurrentRow,CurrentCol)).Value := FORMAT(DataTable."Item Description");
                          CurrentCol := CurrentCol + 1;
                          xlSheet.Range(fGetCell(CurrentRow,CurrentCol)).Value := FORMAT(DataTable."Sales Qty");
                          CurrentCol := CurrentCol + 1;
                          xlSheet.Range(fGetCell(CurrentRow,CurrentCol)).Value := FORMAT(DataTable."Line Amount");
                          CurrentCol := CurrentCol + 1;
                          xlSheet.Range(fGetCell(CurrentRow,CurrentCol)).Value := FORMAT(DataTable."Product Group Code");
                          CurrentCol := CurrentCol + 1;
                          xlSheet.Range(fGetCell(CurrentRow,CurrentCol)).Value := FORMAT(DataTable."Product Group Description");
                          CurrentCol := CurrentCol + 1;
                          xlSheet.Range(fGetCell(CurrentRow,CurrentCol)).Value := FORMAT(DataTable."Item Category Code");
                          CurrentCol := CurrentCol + 1;
                          xlSheet.Range(fGetCell(CurrentRow,CurrentCol)).Value := FORMAT(DataTable."Item category Description");
                          CurrentCol := CurrentCol + 1;
                          xlSheet.Range(fGetCell(CurrentRow,CurrentCol)).Value := FORMAT(DataTable."Unit Price");
                          CurrentCol := CurrentCol + 1;
                          xlSheet.Range(fGetCell(CurrentRow,CurrentCol)).Value := FORMAT(DataTable."Cost Price");
                          CurrentCol := CurrentCol + 1;
                          xlSheet.Range(fGetCell(CurrentRow,CurrentCol)).Value := FORMAT(DataTable."Sales Margin");
                          CurrentCol := CurrentCol + 1;
                          xlSheet.Range(fGetCell(CurrentRow,CurrentCol)).Value := FORMAT(DataTable."Comm (Paid)");
                          CurrentCol := CurrentCol + 1;
                          xlSheet.Range(fGetCell(CurrentRow,CurrentCol)).Value := FORMAT(DataTable."Comm (Unpaid)");
                          CurrentCol := CurrentCol + 1;
                          xlSheet.Range(fGetCell(CurrentRow,CurrentCol)).Value := FORMAT(DataTable."Production Comm (Paid)");
                          CurrentCol := CurrentCol + 1;
                          xlSheet.Range(fGetCell(CurrentRow,CurrentCol)).Value := FORMAT(DataTable."Production Comm (Unpaid)");
                          CurrentCol := CurrentCol + 1;
                          xlSheet.Range(fGetCell(CurrentRow,CurrentCol)).Value := FORMAT(DataTable."Customer Point");
                          CurrentCol := CurrentCol + 1;
                          xlSheet.Range(fGetCell(CurrentRow,CurrentCol)).Value := FORMAT(DataTable."Document No");

                         "Last Cell":= fGetCell(CurrentRow,CurrentCol);
                          CurrentCol := CurrentCol + 1;
                      END;
                  UNTIL DataTable.NEXT = 0;
              END;


         xlSheet.Cells.Select;
         xlSheet.Cells.EntireColumn.AutoFit;

        //creating the pivot table

        //pivot table 1 - salesperson comm
        //================================

              xlPivotCache := xlApp.ActiveWorkbook.PivotCaches.Add(1,STRSUBSTNO('SourceData!A2:%1',"Last Cell"));
              xlPivotCache.CreatePivotTable('','PivotTable1');

              xlSheet := xlApp.ActiveSheet();
              xlPivotTable := xlSheet.PivotTables('PivotTable1');
              xlSheet.Name := 'Salesperson Comm';

              //formating sheet title
              xlSheet.Range('A1').EntireRow.Insert;
              xlSheet.Range('A1').EntireRow.Insert;
              xlSheet.Range('A1').Value := 'Sales Commission Report By Month';
              xlSheet.Range('A1').EntireRow.Font.Bold := TRUE;

              //setting up Rows area
              xlPivotField := xlPivotTable.PivotFields('Name Description');
              xlPivotField.Orientation := 1; //RowField
              xlPivotField.Position    := 1;
              xlPivotField.Subtotals(1,TRUE);

              xlPivotField := xlPivotTable.PivotFields('Document No');
              xlPivotField.Orientation := 1;   //RowField
              xlPivotField.Position    := 2;
              xlPivotField.Subtotals(1,FALSE);

              xlPivotField := xlPivotTable.PivotFields('Closing Date');
              xlPivotField.Orientation := 1; //RowField
              xlPivotField.Position    := 3;
              xlPivotField.Subtotals(1,FALSE);



              //Setting up Columns area
              xlPivotField := xlPivotTable.PivotFields('Item Code');
              xlPivotField.Orientation := 2;   //ColumnField
              xlPivotField.Position    := 1;

              //Setting up Header area
              xlPivotField := xlPivotTable.PivotFields('Type');
              xlPivotField.Orientation := 3;  //HeaderField
              xlPivotField.Position    := 1;
              xlPivotField.CurrentPage:='Salesperson';

              //Data Field
              xlPivotField := xlPivotTable.PivotFields('Comm (Paid)');
              xlPivotField.Orientation := 4;   //DataField
              xlPivotField.Position    := 1;


              xlPivotField := xlPivotTable.PivotFields('Comm (Unpaid)');
              xlPivotField.Orientation := 4;   //DataField
              xlPivotField.Position    := 2;

              xlPivotField := xlPivotTable.PivotFields('Line Amount');
              xlPivotField.Orientation := 4;   //DataField
              xlPivotField.Position    := 3;
              xlPivotField."Function"  := 0;   //sum

        //pivot table 2 - management comm
        //===============================

              xlSheet := xlBook.Worksheets.Item('SourceData');
              xlSheet.Activate;

              xlPivotCache := xlApp.ActiveWorkbook.PivotCaches.Add(1,STRSUBSTNO('SourceData!A2:%1',"Last Cell"));
              xlPivotCache.CreatePivotTable('','PivotTable2');

              xlSheet:= xlApp.ActiveSheet();
              xlPivotTable := xlSheet.PivotTables('PivotTable2');
              xlSheet.Name := 'Management Comm ';

              //formating sheet title
              xlSheet.Range('A1').EntireRow.Insert;
              xlSheet.Range('A1').EntireRow.Insert;
              xlSheet.Range('A1').Value := 'Managment Commission Report By Month';
              xlSheet.Range('A1').EntireRow.Font.Bold := TRUE;

              //Setting up Rows area
              xlPivotField := xlPivotTable.PivotFields('Name Description');
              xlPivotField.Orientation := 1; //RowField
              xlPivotField.Position    := 1;
              xlPivotField.Subtotals(1,FALSE);


              //Setting up Header area
              xlPivotField := xlPivotTable.PivotFields('Type');
              xlPivotField.Orientation := 3; //HeaderField
              xlPivotField.Position    := 1;
              xlPivotField.CurrentPage:='Management';

              //Setting up Data area
              xlPivotField := xlPivotTable.PivotFields('Production Comm (Paid)');
              xlPivotField.Orientation :=4;   //DataField
              xlPivotField.Position    := 1;


              xlPivotField := xlPivotTable.PivotFields('Production Comm (Unpaid)');
              xlPivotField.Orientation := 4;   //DataField
              xlPivotField.Position    := 2;

        //pivot table 3 - Production comm
        //===============================

              xlSheet := xlBook.Worksheets.Item('SourceData');
              xlSheet.Activate;

              xlPivotCache := xlApp.ActiveWorkbook.PivotCaches.Add(1,STRSUBSTNO('SourceData!A2:%1',"Last Cell"));
              xlPivotCache.CreatePivotTable('','PivotTable3');

              xlSheet:= xlApp.ActiveSheet();
              xlPivotTable := xlSheet.PivotTables('PivotTable3');
              xlSheet.Name := 'Production Comm';

              //formating sheet title
              xlSheet.Range('A1').EntireRow.Insert;
              xlSheet.Range('A1').EntireRow.Insert;
              xlSheet.Range('A1').Value := 'Production Commission Report By Month';
              xlSheet.Range('A1').EntireRow.Font.Bold := TRUE;

              //Setting up Rows area
              xlPivotField := xlPivotTable.PivotFields('Name Description');
              xlPivotField.Orientation := 1; //RowField
              xlPivotField.Position    := 1;
              xlPivotField.Subtotals(1,FALSE);

              //Setting up Header area
              xlPivotField := xlPivotTable.PivotFields('Type');
              xlPivotField.Orientation := 3; //HeaderField
              xlPivotField.Position    := 1;
              xlPivotField.CurrentPage:='Production';

              //Setting up Data area
              xlPivotField := xlPivotTable.PivotFields('Production Comm (Paid)');
              xlPivotField.Orientation :=4;  //DataField
              xlPivotField.Position    := 1;

              xlPivotField := xlPivotTable.PivotFields('Production Comm (Unpaid)');
              xlPivotField.Orientation := 4; //DataField
              xlPivotField.Position    := 2;

        //pivot table 4 - Customer Point
        //===============================

              xlSheet := xlBook.Worksheets.Item('SourceData');
              xlSheet.Activate;

              xlPivotCache := xlApp.ActiveWorkbook.PivotCaches.Add(1,STRSUBSTNO('SourceData!A2:%1',"Last Cell"));
              xlPivotCache.CreatePivotTable('','PivotTable4');

              xlSheet:= xlApp.ActiveSheet();
              xlPivotTable := xlSheet.PivotTables('PivotTable4');
              xlSheet.Name := 'Customer Point';

              //formating sheet title
              xlSheet.Range('A1').EntireRow.Insert;
              xlSheet.Range('A1').EntireRow.Insert;
              xlSheet.Range('A1').Value := 'Customer Points Collection By Month';
              xlSheet.Range('A1').EntireRow.Font.Bold := TRUE;

              //Setting up Rows area
              xlPivotField := xlPivotTable.PivotFields('Name Description');
              xlPivotField.Orientation := 1; //RowField
              xlPivotField.Position    := 1;

              xlPivotField := xlPivotTable.PivotFields('Customer Description');
              xlPivotField.Orientation := 1;   //RowField
              xlPivotField.Position    := 2;
              xlPivotField.Subtotals(1,FALSE);

              xlPivotField := xlPivotTable.PivotFields('Document No');
              xlPivotField.Orientation := 1;   //RowField
              xlPivotField.Position    := 3;
              xlPivotField.Subtotals(1,FALSE);

              //Setting up Columns area
              xlPivotField := xlPivotTable.PivotFields('Product Group Code');
              xlPivotField.Orientation := 2;   //ColumnField
              xlPivotField.Position    := 1;


              //Setting up Header area
              xlPivotField := xlPivotTable.PivotFields('Type');
              xlPivotField.Orientation := 3;     //HeaderField
              xlPivotField.Position    := 1;
              xlPivotField.CurrentPage:='Salesperson';

              //Setting up Data area
              xlPivotField := xlPivotTable.PivotFields('Customer Point');
              xlPivotField.Orientation :=4;     //DataField
              xlPivotField.Position    := 1;

              xlPivotField := xlPivotTable.PivotFields('Line Amount');
              xlPivotField.Orientation := 4;     //DataField
              xlPivotField.Position    := 2;

        //pivot table 5 - Item Margin Analysis
        //====================================

              xlSheet := xlBook.Worksheets.Item('SourceData');
              xlSheet.Activate;

              xlPivotCache := xlApp.ActiveWorkbook.PivotCaches.Add(1,STRSUBSTNO('SourceData!A2:%1',"Last Cell"));
              xlPivotCache.CreatePivotTable('','PivotTable5');

              xlSheet:= xlApp.ActiveSheet();
              xlPivotTable := xlSheet.PivotTables('PivotTable5');
              xlPivotTable.Format(1);
              xlSheet.Name := 'Item Margin Analysis';

              //formating sheet title
              xlSheet.Range('A1').EntireRow.Insert;
              xlSheet.Range('A1').Value := 'Item Margin Analysis By Month';
              xlSheet.Range('A1').EntireRow.Font.Bold := TRUE;

              //Setting up Rows area
              xlPivotField := xlPivotTable.PivotFields('Item Code');
              xlPivotField.Orientation := 1; //RowField
              xlPivotField.Position    := 1;
              xlPivotField.Subtotals(1,FALSE);

              //Setting up Data area
              xlPivotField := xlPivotTable.PivotFields('Sales Margin');
              xlPivotField.Orientation :=4;    //DataField
              xlPivotField.Position    := 1;

              xlPivotField := xlPivotTable.PivotFields('Comm (Paid)');
              xlPivotField.Orientation := 4;   //DataField
              xlPivotField.Position    := 2;

              xlPivotField := xlPivotTable.PivotFields('Production Comm (Paid)');
              xlPivotField.Orientation := 4;    //DataField
              xlPivotField.Position    := 3;

             //setting for calculation field
             xlSheet.Range('E4').Value := 'Net Margin';
             xlSheet.Range('E4').EntireRow.Font.Bold := TRUE;
             xlSheet.Range('E4').EntireRow.HorizontalAlignment:=3;

             xlSheet.Cells.EntireColumn.AutoFit;

             //start from row 5
             xlRowCount:=5 ;
             //loop until first column is empty
             WHILE FORMAT(xlSheet.Range('A'+FORMAT(xlRowCount)).Value)<>''  DO
             BEGIN
                 xlSheet.Range('E'+FORMAT(xlRowCount)).Value := '=B'+FORMAT(xlRowCount)+'-C'+FORMAT(xlRowCount)+'-D'+FORMAT(xlRowCount);
                 xlRowCount:=xlRowCount+1;
             END;


        //pivot table 6 - Gross Profit By Saleperson
        //====================================

             xlSheet := xlBook.Worksheets.Item('SourceData');
             xlSheet.Activate;

             xlPivotCache := xlApp.ActiveWorkbook.PivotCaches.Add(1,STRSUBSTNO('SourceData!A2:%1',"Last Cell"));
             xlPivotCache.CreatePivotTable('','PivotTable6');

             xlSheet:= xlApp.ActiveSheet();
             xlPivotTable := xlSheet.PivotTables('PivotTable6');
             xlPivotTable.Format(1);
             xlSheet.Name := 'Profit By Salesperson';

             //formating sheet title
             xlSheet.Range('A1').EntireRow.Insert;
             xlSheet.Range('A1').EntireRow.Insert;
             xlSheet.Range('A1').Value := 'Gross Profit By Salesperson';
             xlSheet.Range('A1').EntireRow.Font.Bold := TRUE;

              //Setting up Rows area
              xlPivotField := xlPivotTable.PivotFields('Name Description');
              xlPivotField.Orientation := 1; //RowField
              xlPivotField.Position    := 1;
              xlPivotField.Subtotals(1,FALSE);

              //Setting up Data area
              xlPivotField := xlPivotTable.PivotFields('Line Amount');
              xlPivotField.Orientation :=4;    //DataField
              xlPivotField.Position    := 1;

              xlPivotField := xlPivotTable.PivotFields('Cost Price');
              xlPivotField.Orientation := 4;     //DataField
              xlPivotField.Position    := 2;

              xlPivotField := xlPivotTable.PivotFields('Comm (Paid)');
              xlPivotField.Orientation := 4;      //DataField
              xlPivotField.Position    := 3;

              //Setting up Header area
              xlPivotField := xlPivotTable.PivotFields('Type');
              xlPivotField.Orientation := 3;   //HeaderField
              xlPivotField.Position    := 1;
              xlPivotField.CurrentPage:='Salesperson';

              //setting for calculation field
              xlSheet.Range('E5').Value := 'Profit';
              xlSheet.Range('E5').EntireRow.Font.Bold := TRUE;
              xlSheet.Range('E5').EntireRow.HorizontalAlignment:=3;

              xlSheet.Cells.EntireColumn.AutoFit;
              xlRowCount:=6 ;
              WHILE FORMAT(xlSheet.Range('A'+FORMAT(xlRowCount)).Value)<>''  DO
              BEGIN
              xlSheet.Range('E'+FORMAT(xlRowCount)).Value := '=B'+FORMAT(xlRowCount)+'-C'+FORMAT(xlRowCount)+'-D'+FORMAT(xlRowCount);
              xlRowCount:=xlRowCount+1;
              END;

              //setting for calculation field
              xlSheet.Range('F5').Value := 'Profit%';
              xlSheet.Cells.EntireColumn.AutoFit;
              xlRowCount:=6 ;
              WHILE FORMAT(xlSheet.Range('A'+FORMAT(xlRowCount)).Value)<>''  DO
              BEGIN
                xlSheet.Range('F'+FORMAT(xlRowCount)).Value := '=100*(B'+FORMAT(xlRowCount)+'-C'+FORMAT(xlRowCount)+')/B'+FORMAT(xlRowCount)
        ;
              xlRowCount:=xlRowCount+1;
              END;


        //pivot table 7 - Promoter comm
        //================================

             xlSheet := xlBook.Worksheets.Item('SourceData');
             xlSheet.Activate;

             xlPivotCache := xlApp.ActiveWorkbook.PivotCaches.Add(1,STRSUBSTNO('SourceData!A2:%1',"Last Cell"));
             xlPivotCache.CreatePivotTable('','PivotTable7');

             xlSheet:= xlApp.ActiveSheet();
             xlPivotTable := xlSheet.PivotTables('PivotTable7');
             xlSheet.Name := 'Promoter Comm';

              //formating sheet title
              xlSheet.Range('A1').EntireRow.Insert;
              xlSheet.Range('A1').EntireRow.Insert;
              xlSheet.Range('A1').Value := 'Promoter Commission Report By Month';
              xlSheet.Range('A1').EntireRow.Font.Bold := TRUE;

              //setting up Rows area
              xlPivotField := xlPivotTable.PivotFields('Name Description');
              xlPivotField.Orientation := 1; //RowField
              xlPivotField.Position    := 1;
              xlPivotField.Subtotals(1,TRUE);

              xlPivotField := xlPivotTable.PivotFields('Document No');
              xlPivotField.Orientation := 1;   //RowField
              xlPivotField.Position    := 2;
              xlPivotField.Subtotals(1,FALSE);

              xlPivotField := xlPivotTable.PivotFields('Closing Date');
              xlPivotField.Orientation := 1; //RowField
              xlPivotField.Position    := 3;
              xlPivotField.Subtotals(1,FALSE);



              //Setting up Columns area
              xlPivotField := xlPivotTable.PivotFields('Item Code');
              xlPivotField.Orientation := 2;   //ColumnField
              xlPivotField.Position    := 1;

              //Setting up Header area
              xlPivotField := xlPivotTable.PivotFields('Type');
              xlPivotField.Orientation := 3;   //HeaderField
              xlPivotField.Position    := 1;
              xlPivotField.CurrentPage:='Promoter';

              //Data Field

              xlPivotField := xlPivotTable.PivotFields('Comm (Paid)');
              xlPivotField.Orientation := 4;   //DataField
              xlPivotField.Position    := 1;


              xlPivotField := xlPivotTable.PivotFields('Comm (Unpaid)');
              xlPivotField.Orientation := 4;   //DataField
              xlPivotField.Position    := 2;

              xlPivotField := xlPivotTable.PivotFields('Line Amount');
              xlPivotField.Orientation := 4;    //DataField
              xlPivotField.Position    := 3;
              xlPivotField."Function"  := 0;   //sum



              //show excel form
              xlApp.Visible := TRUE;

        END
        ELSE
        MESSAGE('No data available');
        */

    end;

    // Note: Product Group table discontinued in BC
    procedure RetrieveItemInfo(ItemCode: Code[20])
    begin
        //retrieve Item Category Code and Product Group Code by Item Code

        Item.SETRANGE(Item."No.", ItemCode);
        IF Item.FIND('-') THEN BEGIN
            ItemCategoryCode := Item."Item Category Code";
            // Note: Product Group table discontinued in BC
            // ProductGroupCode := Item."Product Group Code";
            ItemDescription := Item.Description;
        END;
    end;

    procedure RetrieveCommrate(ItemCategoryCode: Code[20]) CommRate: Decimal
    var
        ItemCategory: Record "Item Category";
    begin
        //retrieve commission rate by item category code

        CommRate := 0;
        ItemCategory.SETFILTER(ItemCategory.Code, ItemCategoryCode);
        IF ItemCategory.FIND('-') THEN
            CommRate := ItemCategory."Commission Rate";

        EXIT(CommRate);
    end;

    procedure GetCustomerDescription(CustomerCode: Code[20]) CustomerDescription: Text[100]
    var
        Customer: Record Customer;
    begin
        //retrieve customer description by customer code
        IF CustomerCode <> 'ZTP(TOH GUAN)' THEN BEGIN
            Customer.SETFILTER(Customer."No.", CustomerCode);
            IF Customer.FIND('-') THEN
                CustomerDescription := Customer.Name;
        END
        ELSE
            CustomerDescription := 'ZTP(TOH GUAN)'
    end;

    procedure GetItemcategoryDescription(ItemCategoryCode: Code[20]) ItemCategoryDescription: Text[100]
    var
        ItemCategoryGroup: Record "Item Category";
    begin
        //retrieve item category description by item category code

        ItemCategoryGroup.SETFILTER(ItemCategoryGroup.Code, ItemCategoryCode);
        IF ItemCategoryGroup.FIND('-') THEN
            ItemCategoryDescription := ItemCategoryGroup.Description;
        EXIT(ItemCategoryDescription);
    end;

    procedure GetSalespersonDescription(SalespersonCode: Code[20]) SalespersonDescription: Text[100]
    var
        Salesperson: Record "Salesperson/Purchaser";
    begin
        //retrieve salesperson name by salesperson code

        Salesperson.SETFILTER(Salesperson.Code, SalespersonCode);
        IF Salesperson.FIND('-') THEN
            SalespersonDescription := Salesperson.Name;
        EXIT(SalespersonDescription);
    end;

    // Note: Product Group table discontinued in BC
    procedure GetProductGroupDescription(ProductGroupCode: Text[30]; ItemCategoryCode: Text[30]) ProductGroupDescription: Text[100]
    var
    // ProductGroup: Record "Product Group";
    begin
        // //retrieve product group description by product group code and item category code

        // ProductGroup.SETRANGE(ProductGroup.Code, ProductGroupCode);
        // ProductGroup.SETRANGE(ProductGroup."Item Category Code", ItemCategoryCode);

        // IF ProductGroup.FIND('-') THEN
        //     ProductGroupDescription := ProductGroup.Description;
        // EXIT(ProductGroupDescription);
    end;

    // Note: Product Group table discontinued in BC
    procedure GetCustomerPointRate(ProductGroupCode: Text[30]; ItemCategoryCode: Text[30]; ReturnReasonCode: Code[20]) CustomerPointRate: Decimal
    var
        // ProductGroup: Record "Product Group";
        lrReturnReason: Record "Return Reason";
    begin
        // //retrieve customer point rate  by product group code and item category code

        // ProductGroup.SETRANGE(ProductGroup.Code, ProductGroupCode);
        // IF ItemCategoryCode <> '' THEN
        //     ProductGroup.SETRANGE(ProductGroup."Item Category Code", ItemCategoryCode);
        // IF ProductGroup.FIND('-') THEN BEGIN
        //     IF ReturnReasonCode = '' THEN
        //         CustomerPointRate := ProductGroup."Customer Point (%)"
        //     ELSE BEGIN
        //         lrReturnReason.GET(ReturnReasonCode);
        //         IF lrReturnReason."Deduct Penalty" THEN BEGIN
        //             CustomerPointRate := ProductGroup."Penalty Cust. Point Rate";
        //         END ELSE
        //             CustomerPointRate := ProductGroup."Customer Point (%)";
        //     END;
        // END;
        // EXIT(CustomerPointRate);
    end;

    // Note: Product Group table discontinued in BC
    procedure GetGroupCommRate(ProductGroupCode: Text[30]) GroupCommRate: Decimal
    var
    // ProductGroup: Record "Product Group";
    begin
        // //retrieve product group commission rate by product group code and item category code

        // ProductGroup.SETRANGE(ProductGroup.Code, ProductGroupCode);
        // ProductGroup.SETRANGE(ProductGroup."Item Category Code", ItemCategoryCode);
        // IF ProductGroup.FIND('-') THEN
        //     GroupCommRate := ProductGroup."Commission Rate";
        // EXIT(GroupCommRate);
    end;

    procedure GetSatffDescription(UserID: Code[20]) UserDescription: Text[50]
    begin
        // retrieve user description by user id
        /*1START TJCSG1.00 #1*/
        //NameDataTypeSubtypeLength
        //UserRecordTable2000000002
        //User.SETRANGE(User."User ID",UserID);
        //IF User.FIND('-') THEN
        //UserDescription:=User.Name;
        /*END TJCSG1.00 #1*/

        EXIT(UserDescription);

    end;

    procedure fGetCell(var Row: Integer; var Col: Integer) returnCell: Text[7]
    var
        startCh: Char;
        i: Integer;
        startString: Text[30];
    begin
        //get the cell string by row and column

        /*
        Ussage:::
        CurrentRow := 12;
        CurrentCol := 27;
        xlSheet.Range(fGetCell(CurrentRow,CurrentCol)).Value := 'sss';
        */

        startCh := 'A';
        i := 1;
        startString := FORMAT(startCh);

        WHILE i < Col DO BEGIN
            i := i + 1;
            IF i = 27 THEN BEGIN
                startString := 'AA';
                startCh := 'A';
            END
            ELSE IF i > 27 THEN BEGIN
                startCh := startCh + 1;
                startString := FORMAT('A') + FORMAT(startCh);
            END
            ELSE BEGIN
                startCh := startCh + 1;
                startString := FORMAT(startCh);
            END;
        END;
        returnCell := startString + FORMAT(Row);
        EXIT(returnCell);

    end;

    procedure CheckForDataRow() Status: Boolean
    begin
        //return whether temp table is empty
        //excluding record with document type as 'Opening'
        Status := TRUE;

        TempTable.SETFILTER(TempTable."Document Type", '<>%1', TempTable."Document Type"::Opening);
        IF TempTable.FIND('-') THEN BEGIN
            Status := FALSE;
        END;
        EXIT(Status);
    end;

    procedure GetPromoterCommRate(PromoterPriceGroup: Code[20]; "Item Code": Code[20]) "Comm Rate": Decimal
    var
        SalesPrice: Record "Sales Price";
    begin
        //sales code =promoter code
        "Comm Rate" := 0;
        SalesPrice.RESET;
        SalesPrice.SETRANGE(SalesPrice."Sales Code", PromoterPriceGroup);
        SalesPrice.SETRANGE(SalesPrice."Item No.", "Item Code");
        SalesPrice.SETRANGE(SalesPrice."Sales Type", SalesPrice."Sales Type"::"Customer Price Group");
        IF SalesPrice.FIND('-') THEN
            "Comm Rate" := SalesPrice."Unit Price" / GetItemUOM("Item Code", SalesPrice."Unit of Measure Code");

        EXIT("Comm Rate");
    end;

    procedure GetItemUOM(ItemNo: Code[20]; UOMCode: Code[20]) BaseQty: Decimal
    var
        UOM: Record "Item Unit of Measure";
    begin
        UOM.RESET;
        UOM.SETRANGE(UOM."Item No.", ItemNo);
        UOM.SETRANGE(UOM.Code, UOMCode);
        IF UOM.FIND('-') THEN
            BaseQty := UOM."Qty. per Unit of Measure";
    end;

    procedure GetPromoterCode(InvoiceNo: Code[20]) PromoterCode: Code[20]
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
    begin
        //return promoter

        SalesInvoiceHeader.RESET;
        SalesInvoiceHeader.SETRANGE(SalesInvoiceHeader."No.", InvoiceNo);
        IF SalesInvoiceHeader.FIND('-') THEN BEGIN
            IF SalesInvoiceHeader."Shortcut Dimension 2 Code" <> '' THEN BEGIN
                PromoterCode := SalesInvoiceHeader."Shortcut Dimension 2 Code";
                MESSAGE(PromoterCode);
            END;
        END;
    end;

    procedure GetPromoterPriceGroup(CustomerCode: Code[20]) PromoterPriceGroup: Code[20]
    var
        Customer: Record Customer;
    begin
        Customer.RESET;
        Customer.SETRANGE(Customer."No.", CustomerCode);
        IF Customer.FIND('-') THEN
            PromoterPriceGroup := Customer."Promoter Price Group";
    end;

    procedure GetPromoterDescription(PromoterCode: Code[20]) PromoterDescription: Text[50]
    var
        Promoter: Record "Dimension Value";
    begin
        //return promoter description

        Promoter.RESET;
        Promoter.SETRANGE(Promoter."Dimension Code", 'PROMOTER');
        Promoter.SETRANGE(Promoter.Code, PromoterCode);
        IF Promoter.FIND('-') THEN
            PromoterDescription := Promoter.Name
        ELSE
            PromoterDescription := '';

        EXIT(PromoterDescription);
    end;

    procedure InsertToTempTable(Type: Text[30])
    var
        EntryNo: Integer;
    begin
        //insert empty line if temptable type option is missing
        //error will occur during pivot table setup if option is missing

        TempTable.RESET;
        TempTable.SETCURRENTKEY(TempTable."Entry No", TempTable."Document No", TempTable."Document Type");
        IF TempTable.FIND('+') THEN
            EntryNo := TempTable."Entry No" + 1
        ELSE
            EntryNo := 1;
        TempTable.INIT;
        IF Type = 'Promoter' THEN BEGIN
            TempTable."Entry No" := EntryNo;
            IF Type = 'Promoter' THEN
                TempTable.Type := TempTable.Type::Promoter;
            IF Type = 'Salesperson' THEN
                TempTable.Type := TempTable.Type::Salesperson;
            IF Type = 'Management' THEN
                TempTable.Type := TempTable.Type::Management;
            IF Type = 'Production' THEN
                TempTable.Type := TempTable.Type::Production;

            TempTable.INSERT;
        END;
    end;

    procedure CheckTypeInTable() Status: Boolean
    var
        TempTable: Record "Temp Table";
    begin
        //check for any missing type in the temptable and insert if missing
        //error will occur during pivot table setup if option is missing

        //find promoter
        TempTable.RESET;
        TempTable.SETCURRENTKEY(TempTable."Entry No", TempTable."Document No", TempTable."Document Type");
        TempTable.SETRANGE(TempTable.Type, TempTable.Type::Promoter);
        TempTable.SETFILTER(TempTable."Document Type", '<>%1', TempTable."Document Type"::Opening);
        IF NOT TempTable.FIND('-') THEN
            InsertToTempTable('Promoter');

        //find salesperson
        TempTable.RESET;
        TempTable.SETCURRENTKEY(TempTable."Entry No", TempTable."Document No", TempTable."Document Type");
        TempTable.SETRANGE(TempTable.Type, TempTable.Type::Salesperson);
        TempTable.SETFILTER(TempTable."Document Type", '<>%1', TempTable."Document Type"::Opening);
        IF NOT TempTable.FIND('-') THEN
            InsertToTempTable('Salesperson');

        //find management
        TempTable.RESET;
        TempTable.SETCURRENTKEY(TempTable."Entry No", TempTable."Document No", TempTable."Document Type");
        TempTable.SETRANGE(TempTable.Type, TempTable.Type::Management);
        TempTable.SETFILTER(TempTable."Document Type", '<>%1', TempTable."Document Type"::Opening);
        IF NOT TempTable.FIND('-') THEN
            InsertToTempTable('Management');

        //find production
        TempTable.RESET;
        TempTable.SETCURRENTKEY(TempTable."Entry No", TempTable."Document No", TempTable."Document Type");
        TempTable.SETRANGE(TempTable.Type, TempTable.Type::Production);
        TempTable.SETFILTER(TempTable."Document Type", '<>%1', TempTable."Document Type"::Opening);
        IF NOT TempTable.FIND('-') THEN
            InsertToTempTable('Production');


        EXIT(Status);
    end;

    procedure PBarStart(InitTotal: Integer)
    begin
        /*TJCSG1.00 #5 Start*/
        pBarTime := TIME;
        pBarCount := 0;
        pBarDisplay := 0;
        pBarText := 'Completed              @1@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\\';
        pBarText := pBarText + 'Records              #2######\';
        pBarText := pBarText + 'Total Records              #3######\';
        pBarText := pBarText + 'Time Elapsed              #4######\';
        pBarText := pBarText + 'Doc. No              #5######\';
        pBarText := pBarText + 'Doc. Line No.              #6######\';
        pBarDuration := TIME - pBarStartTime;
        pBar.OPEN(pBarText, pBarDisplay, pBarCount, pBarTotal, pBarDuration, pBarDocNo, pBarDocNoLine);


        IF InitTotal < 1000 THEN InitTotal := 1000;
        pBarTotal := InitTotal;
        /*TJCSG1.00 #5 End*/

    end;

    procedure PBarUpdate2(VarDocNo: Text; VarDocLineNo: Integer)
    var
        pBarConst: Integer;
    begin
        /*TJCSG1.00 #5 Start*/
        pBarDocNo := VarDocNo;
        pBarDocNoLine := VarDocLineNo;
        IF pBarTotal = 0 THEN EXIT;   // to avoid error
        pBarDuration := TIME - pBarStartTime;
        pBarCount := pBarCount + 1;
        IF pBarTime < TIME - 1000 THEN BEGIN
            pBarTime := TIME;
            IF pBarCount > pBarTotal THEN pBarCount := pBarTotal;
            pBarDisplay := ROUND(pBarCount / pBarTotal * 10000, 1);
            pBar.UPDATE;
        END;
        /*TJCSG1.00 #5 End*/

    end;

    procedure PBarUpdateFinish()
    var
        pBarConst: Integer;
    begin
        /*TJCSG1.00 #6 Start*/
        IF pBarTotal = 0 THEN EXIT;   // to avoid error

        pBarCount := pBarTotal;
        pBarDisplay := ROUND(pBarCount / pBarTotal * 10000, 1);
        pBar.UPDATE;

        /*TJCSG1.00 #5 End*/

    end;
}

