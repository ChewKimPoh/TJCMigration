table 38 "Purchase Header"
{
    // TJCSG1.00
    // NAV 2013 R2 Upgrade
    //  1. 08/07/2014  dp.dst
    //     - Renumbered field 58041 "_Actual Vendor No." to 58044 due to field numbering issue when posting to Purch.
    //       Inv. Header.

    Caption = 'Purchase Header';
    DataCaptionFields = "No.","Buy-from Vendor Name";
    LookupPageID = 53;

    fields
    {
        field(1;"Document Type";Option)
        {
            Caption = 'Document Type';
            OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order';
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";
        }
        field(2;"Buy-from Vendor No.";Code[20])
        {
            Caption = 'Buy-from Vendor No.';
            TableRelation = Vendor;

            trigger OnValidate()
            begin
                TESTFIELD(Status,Status::Open);
                IF ("Buy-from Vendor No." <> xRec."Buy-from Vendor No.") AND
                   (xRec."Buy-from Vendor No." <> '')
                THEN BEGIN
                  IF HideValidationDialog THEN
                    Confirmed := TRUE
                  ELSE
                    Confirmed := CONFIRM(Text004,FALSE,FIELDCAPTION("Buy-from Vendor No."));
                  IF Confirmed THEN BEGIN
                    PurchLine.SETRANGE("Document Type","Document Type");
                    PurchLine.SETRANGE("Document No.","No.");
                    IF "Buy-from Vendor No." = '' THEN BEGIN
                      IF NOT PurchLine.ISEMPTY THEN
                        ERROR(
                          Text005,
                          FIELDCAPTION("Buy-from Vendor No."));
                      INIT;
                      PurchSetup.GET;
                      "No. Series" := xRec."No. Series";
                      InitRecord;
                      IF xRec."Receiving No." <> '' THEN BEGIN
                        "Receiving No. Series" := xRec."Receiving No. Series";
                        "Receiving No." := xRec."Receiving No.";
                      END;
                      IF xRec."Posting No." <> '' THEN BEGIN
                        "Posting No. Series" := xRec."Posting No. Series";
                        "Posting No." := xRec."Posting No.";
                      END;
                      IF xRec."Return Shipment No." <> '' THEN BEGIN
                        "Return Shipment No. Series" := xRec."Return Shipment No. Series";
                        "Return Shipment No." := xRec."Return Shipment No.";
                      END;
                      IF xRec."Prepayment No." <> '' THEN BEGIN
                        "Prepayment No. Series" := xRec."Prepayment No. Series";
                        "Prepayment No." := xRec."Prepayment No.";
                      END;
                      IF xRec."Prepmt. Cr. Memo No." <> '' THEN BEGIN
                        "Prepmt. Cr. Memo No. Series" := xRec."Prepmt. Cr. Memo No. Series";
                        "Prepmt. Cr. Memo No." := xRec."Prepmt. Cr. Memo No.";
                      END;
                      EXIT;
                    END;
                    IF "Document Type" = "Document Type"::Order THEN
                      PurchLine.SETFILTER("Quantity Received",'<>0')
                    ELSE
                      IF "Document Type" = "Document Type"::Invoice THEN BEGIN
                        PurchLine.SETRANGE("Buy-from Vendor No.",xRec."Buy-from Vendor No.");
                        PurchLine.SETFILTER("Receipt No.",'<>%1','');
                      END;
                    IF PurchLine.FINDFIRST THEN
                      IF "Document Type" = "Document Type"::Order THEN
                        PurchLine.TESTFIELD("Quantity Received",0)
                      ELSE
                        PurchLine.TESTFIELD("Receipt No.",'');

                    PurchLine.SETRANGE("Receipt No.");
                    PurchLine.SETRANGE("Quantity Received");
                    PurchLine.SETRANGE("Buy-from Vendor No.");

                    IF "Document Type" = "Document Type"::Order THEN BEGIN
                      PurchLine.SETFILTER("Prepmt. Amt. Inv.",'<>0');
                      IF PurchLine.FIND('-') THEN
                        PurchLine.TESTFIELD("Prepmt. Amt. Inv.",0);
                      PurchLine.SETRANGE("Prepmt. Amt. Inv.");
                    END;

                    IF "Document Type" = "Document Type"::"Return Order" THEN
                      PurchLine.SETFILTER("Return Qty. Shipped",'<>0')
                    ELSE
                      IF "Document Type" = "Document Type"::"Credit Memo" THEN BEGIN
                        PurchLine.SETRANGE("Buy-from Vendor No.",xRec."Buy-from Vendor No.");
                        PurchLine.SETFILTER("Return Shipment No.",'<>%1','');
                      END;
                    IF PurchLine.FINDFIRST THEN
                      IF "Document Type" = "Document Type"::"Return Order" THEN
                        PurchLine.TESTFIELD("Return Qty. Shipped",0)
                      ELSE
                        PurchLine.TESTFIELD("Return Shipment No.",'');

                    PurchLine.RESET;
                  END ELSE BEGIN
                    Rec := xRec;
                    EXIT;
                  END;
                END;

                GetVend("Buy-from Vendor No.");
                Vend.CheckBlockedVendOnDocs(Vend,FALSE);
                Vend.TESTFIELD("Gen. Bus. Posting Group");
                "Buy-from Vendor Name" := Vend.Name;
                "Buy-from Vendor Name 2" := Vend."Name 2";
                "Buy-from Address" := Vend.Address;
                "Buy-from Address 2" := Vend."Address 2";
                "Buy-from City" := Vend.City;
                "Buy-from Post Code" := Vend."Post Code";
                "Buy-from County" := Vend.County;
                "Buy-from Country/Region Code" := Vend."Country/Region Code";
                IF NOT SkipBuyFromContact THEN
                  "Buy-from Contact" := Vend.Contact;
                "Gen. Bus. Posting Group" := Vend."Gen. Bus. Posting Group";
                "VAT Bus. Posting Group" := Vend."VAT Bus. Posting Group";
                "Tax Area Code" := Vend."Tax Area Code";
                "Tax Liable" := Vend."Tax Liable";
                "VAT Country/Region Code" := Vend."Country/Region Code";
                "VAT Registration No." := Vend."VAT Registration No.";
                VALIDATE("Lead Time Calculation",Vend."Lead Time Calculation");
                "Responsibility Center" := UserSetupMgt.GetRespCenter(1,Vend."Responsibility Center");
                VALIDATE("Sell-to Customer No.",'');
                VALIDATE("Location Code",UserSetupMgt.GetLocation(1,Vend."Location Code","Responsibility Center"));

                IF "Buy-from Vendor No." = xRec."Pay-to Vendor No." THEN BEGIN
                  IF ReceivedPurchLinesExist OR ReturnShipmentExist THEN BEGIN
                    TESTFIELD("VAT Bus. Posting Group",xRec."VAT Bus. Posting Group");
                    TESTFIELD("Gen. Bus. Posting Group",xRec."Gen. Bus. Posting Group");
                  END;
                END;

                "Buy-from IC Partner Code" := Vend."IC Partner Code";
                "Send IC Document" := ("Buy-from IC Partner Code" <> '') AND ("IC Direction" = "IC Direction"::Outgoing);

                IF Vend."Pay-to Vendor No." <> '' THEN
                  VALIDATE("Pay-to Vendor No.",Vend."Pay-to Vendor No.")
                ELSE BEGIN
                  IF "Buy-from Vendor No." = "Pay-to Vendor No." THEN
                    SkipPayToContact := TRUE;
                  VALIDATE("Pay-to Vendor No.","Buy-from Vendor No.");
                  SkipPayToContact := FALSE;
                END;
                "Order Address Code" := '';

                VALIDATE("Order Address Code");

                IF (xRec."Buy-from Vendor No." <> "Buy-from Vendor No.") OR
                   (xRec."Currency Code" <> "Currency Code") OR
                   (xRec."Gen. Bus. Posting Group" <> "Gen. Bus. Posting Group") OR
                   (xRec."VAT Bus. Posting Group" <> "VAT Bus. Posting Group")
                THEN
                  RecreatePurchLines(FIELDCAPTION("Buy-from Vendor No."));

                IF NOT SkipBuyFromContact THEN
                  UpdateBuyFromCont("Buy-from Vendor No.");
            end;
        }
        field(3;"No.";Code[20])
        {
            Caption = 'No.';

            trigger OnValidate()
            begin
                IF "No." <> xRec."No." THEN BEGIN
                  PurchSetup.GET;
                  NoSeriesMgt.TestManual(GetNoSeriesCode);
                  "No. Series" := '';
                END;
            end;
        }
        field(4;"Pay-to Vendor No.";Code[20])
        {
            Caption = 'Pay-to Vendor No.';
            NotBlank = true;
            TableRelation = Vendor;

            trigger OnValidate()
            begin
                TESTFIELD(Status,Status::Open);
                IF (xRec."Pay-to Vendor No." <> "Pay-to Vendor No.") AND
                   (xRec."Pay-to Vendor No." <> '')
                THEN BEGIN
                  IF HideValidationDialog THEN
                    Confirmed := TRUE
                  ELSE
                    Confirmed := CONFIRM(Text004,FALSE,FIELDCAPTION("Pay-to Vendor No."));
                  IF Confirmed THEN BEGIN
                    PurchLine.SETRANGE("Document Type","Document Type");
                    PurchLine.SETRANGE("Document No.","No.");

                    IF "Document Type" = "Document Type"::Order THEN
                      PurchLine.SETFILTER("Quantity Received",'<>0');
                    IF "Document Type" = "Document Type"::Invoice THEN
                      PurchLine.SETFILTER("Receipt No.",'<>%1','');
                    IF PurchLine.FINDFIRST THEN
                      IF "Document Type" = "Document Type"::Order THEN
                        PurchLine.TESTFIELD("Quantity Received",0)
                      ELSE
                        PurchLine.TESTFIELD("Receipt No.",'');

                    PurchLine.SETRANGE("Receipt No.");
                    PurchLine.SETRANGE("Quantity Received");

                    IF "Document Type" = "Document Type"::Order THEN BEGIN
                      PurchLine.SETFILTER("Prepmt. Amt. Inv.",'<>0');
                      IF PurchLine.FIND('-') THEN
                        PurchLine.TESTFIELD("Prepmt. Amt. Inv.",0);
                      PurchLine.SETRANGE("Prepmt. Amt. Inv.");
                    END;

                    IF "Document Type" = "Document Type"::"Return Order" THEN
                      PurchLine.SETFILTER("Return Qty. Shipped",'<>0');
                    IF "Document Type" = "Document Type"::"Credit Memo" THEN
                      PurchLine.SETFILTER("Return Shipment No.",'<>%1','');
                    IF PurchLine.FINDFIRST THEN
                      IF "Document Type" = "Document Type"::"Return Order" THEN
                        PurchLine.TESTFIELD("Return Qty. Shipped",0)
                      ELSE
                        PurchLine.TESTFIELD("Return Shipment No.",'');

                    PurchLine.RESET;
                  END ELSE
                    "Pay-to Vendor No." := xRec."Pay-to Vendor No.";
                END;

                GetVend("Pay-to Vendor No.");
                Vend.CheckBlockedVendOnDocs(Vend,FALSE);
                Vend.TESTFIELD("Vendor Posting Group");

                "Pay-to Name" := Vend.Name;
                "Pay-to Name 2" := Vend."Name 2";
                "Pay-to Address" := Vend.Address;
                "Pay-to Address 2" := Vend."Address 2";
                "Pay-to City" := Vend.City;
                "Pay-to Post Code" := Vend."Post Code";
                "Pay-to County" := Vend.County;
                "Pay-to Country/Region Code" := Vend."Country/Region Code";
                IF NOT SkipPayToContact THEN
                  "Pay-to Contact" := Vend.Contact;
                "Payment Terms Code" := Vend."Payment Terms Code";
                "Prepmt. Payment Terms Code" := Vend."Payment Terms Code";

                IF "Document Type" = "Document Type"::"Credit Memo" THEN BEGIN
                  "Payment Method Code" := '';
                  IF PaymentTerms.GET("Payment Terms Code") THEN
                    IF PaymentTerms."Calc. Pmt. Disc. on Cr. Memos" THEN
                      "Payment Method Code" := Vend."Payment Method Code"
                END ELSE
                  "Payment Method Code" := Vend."Payment Method Code";

                "Shipment Method Code" := Vend."Shipment Method Code";
                "Vendor Posting Group" := Vend."Vendor Posting Group";
                GLSetup.GET;
                IF GLSetup."Bill-to/Sell-to VAT Calc." = GLSetup."Bill-to/Sell-to VAT Calc."::"Bill-to/Pay-to No." THEN BEGIN
                  "VAT Bus. Posting Group" := Vend."VAT Bus. Posting Group";
                  "VAT Country/Region Code" := Vend."Country/Region Code";
                  "VAT Registration No." := Vend."VAT Registration No.";
                  "Gen. Bus. Posting Group" := Vend."Gen. Bus. Posting Group";
                END;
                "Prices Including VAT" := Vend."Prices Including VAT";
                "Currency Code" := Vend."Currency Code";
                "Invoice Disc. Code" := Vend."Invoice Disc. Code";
                "Language Code" := Vend."Language Code";
                "Purchaser Code" := Vend."Purchaser Code";
                VALIDATE("Payment Terms Code");
                VALIDATE("Prepmt. Payment Terms Code");
                VALIDATE("Payment Method Code");
                VALIDATE("Currency Code");
                VALIDATE("Creditor No.",Vend."Creditor No.");

                IF "Document Type" = "Document Type"::Order THEN
                  VALIDATE("Prepayment %",Vend."Prepayment %");

                IF "Pay-to Vendor No." = xRec."Pay-to Vendor No." THEN BEGIN
                  IF ReceivedPurchLinesExist THEN
                    TESTFIELD("Currency Code",xRec."Currency Code");
                END;

                InitDefaultDim;

                IF (xRec."Buy-from Vendor No." = "Buy-from Vendor No.") AND
                   (xRec."Pay-to Vendor No." <> "Pay-to Vendor No.")
                THEN
                  RecreatePurchLines(FIELDCAPTION("Pay-to Vendor No."));

                IF NOT SkipPayToContact THEN
                  UpdatePayToCont("Pay-to Vendor No.");

                "Pay-to IC Partner Code" := Vend."IC Partner Code";
            end;
        }
        field(5;"Pay-to Name";Text[50])
        {
            Caption = 'Pay-to Name';
        }
        field(6;"Pay-to Name 2";Text[50])
        {
            Caption = 'Pay-to Name 2';
        }
        field(7;"Pay-to Address";Text[50])
        {
            Caption = 'Pay-to Address';
        }
        field(8;"Pay-to Address 2";Text[50])
        {
            Caption = 'Pay-to Address 2';
        }
        field(9;"Pay-to City";Text[30])
        {
            Caption = 'Pay-to City';
            TableRelation = IF (Pay-to Country/Region Code=CONST()) "Post Code".City
                            ELSE IF (Pay-to Country/Region Code=FILTER(<>'')) "Post Code".City WHERE (Country/Region Code=FIELD(Pay-to Country/Region Code));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                PostCode.ValidateCity(
                  "Pay-to City","Pay-to Post Code","Pay-to County","Pay-to Country/Region Code",(CurrFieldNo <> 0) AND GUIALLOWED);
            end;
        }
        field(10;"Pay-to Contact";Text[50])
        {
            Caption = 'Pay-to Contact';
        }
        field(11;"Your Reference";Text[35])
        {
            Caption = 'Your Reference';
        }
        field(12;"Ship-to Code";Code[10])
        {
            Caption = 'Ship-to Code';
            TableRelation = "Ship-to Address".Code WHERE (Customer No.=FIELD(Sell-to Customer No.));

            trigger OnValidate()
            begin
                IF ("Document Type" = "Document Type"::Order) AND
                   (xRec."Ship-to Code" <> "Ship-to Code")
                THEN BEGIN
                  PurchLine.SETRANGE("Document Type",PurchLine."Document Type"::Order);
                  PurchLine.SETRANGE("Document No.","No.");
                  PurchLine.SETFILTER("Sales Order Line No.",'<>0');
                  IF NOT PurchLine.ISEMPTY THEN
                    ERROR(
                      Text006,
                      FIELDCAPTION("Ship-to Code"));
                END;

                IF "Ship-to Code" <> '' THEN BEGIN
                  ShipToAddr.GET("Sell-to Customer No.","Ship-to Code");
                  "Ship-to Name" := ShipToAddr.Name;
                  "Ship-to Name 2" := ShipToAddr."Name 2";
                  "Ship-to Address" := ShipToAddr.Address;
                  "Ship-to Address 2" := ShipToAddr."Address 2";
                  "Ship-to City" := ShipToAddr.City;
                  "Ship-to Post Code" := ShipToAddr."Post Code";
                  "Ship-to County" := ShipToAddr.County;
                  "Ship-to Country/Region Code" := ShipToAddr."Country/Region Code";
                  "Ship-to Contact" := ShipToAddr.Contact;
                  "Shipment Method Code" := ShipToAddr."Shipment Method Code";
                  IF ShipToAddr."Location Code" <> '' THEN
                    VALIDATE("Location Code",ShipToAddr."Location Code");
                END ELSE BEGIN
                  TESTFIELD("Sell-to Customer No.");
                  Cust.GET("Sell-to Customer No.");
                  "Ship-to Name" := Cust.Name;
                  "Ship-to Name 2" := Cust."Name 2";
                  "Ship-to Address" := Cust.Address;
                  "Ship-to Address 2" := Cust."Address 2";
                  "Ship-to City" := Cust.City;
                  "Ship-to Post Code" := Cust."Post Code";
                  "Ship-to County" := Cust.County;
                  "Ship-to Country/Region Code" := Cust."Country/Region Code";
                  "Ship-to Contact" := Cust.Contact;
                  "Shipment Method Code" := Cust."Shipment Method Code";
                  IF Cust."Location Code" <> '' THEN
                    VALIDATE("Location Code",Cust."Location Code");
                END;
            end;
        }
        field(13;"Ship-to Name";Text[50])
        {
            Caption = 'Ship-to Name';
        }
        field(14;"Ship-to Name 2";Text[50])
        {
            Caption = 'Ship-to Name 2';
        }
        field(15;"Ship-to Address";Text[50])
        {
            Caption = 'Ship-to Address';
        }
        field(16;"Ship-to Address 2";Text[50])
        {
            Caption = 'Ship-to Address 2';
        }
        field(17;"Ship-to City";Text[30])
        {
            Caption = 'Ship-to City';
            TableRelation = IF (Ship-to Country/Region Code=CONST()) "Post Code".City
                            ELSE IF (Ship-to Country/Region Code=FILTER(<>'')) "Post Code".City WHERE (Country/Region Code=FIELD(Ship-to Country/Region Code));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                PostCode.ValidateCity(
                  "Ship-to City","Ship-to Post Code","Ship-to County","Ship-to Country/Region Code",(CurrFieldNo <> 0) AND GUIALLOWED);
            end;
        }
        field(18;"Ship-to Contact";Text[50])
        {
            Caption = 'Ship-to Contact';
        }
        field(19;"Order Date";Date)
        {
            Caption = 'Order Date';

            trigger OnValidate()
            begin
                TESTFIELD(Status,Status::Open);
                IF ("Document Type" IN ["Document Type"::Quote,"Document Type"::Order]) AND
                   NOT ("Order Date" = xRec."Order Date")
                THEN
                  PriceMessageIfPurchLinesExist(FIELDCAPTION("Order Date"));
            end;
        }
        field(20;"Posting Date";Date)
        {
            Caption = 'Posting Date';

            trigger OnValidate()
            begin
                TestNoSeriesDate(
                  "Posting No.","Posting No. Series",
                  FIELDCAPTION("Posting No."),FIELDCAPTION("Posting No. Series"));
                TestNoSeriesDate(
                  "Prepayment No.","Prepayment No. Series",
                  FIELDCAPTION("Prepayment No."),FIELDCAPTION("Prepayment No. Series"));
                TestNoSeriesDate(
                  "Prepmt. Cr. Memo No.","Prepmt. Cr. Memo No. Series",
                  FIELDCAPTION("Prepmt. Cr. Memo No."),FIELDCAPTION("Prepmt. Cr. Memo No. Series"));

                VALIDATE("Document Date","Posting Date");

                IF ("Document Type" IN ["Document Type"::Invoice,"Document Type"::"Credit Memo"]) AND
                   NOT ("Posting Date" = xRec."Posting Date")
                THEN
                  PriceMessageIfPurchLinesExist(FIELDCAPTION("Posting Date"));

                IF "Currency Code" <> '' THEN BEGIN
                  UpdateCurrencyFactor;
                  IF "Currency Factor" <> xRec."Currency Factor" THEN
                    ConfirmUpdateCurrencyFactor;
                END;
                IF PurchLinesExist THEN
                  JobUpdatePurchLines;
            end;
        }
        field(21;"Expected Receipt Date";Date)
        {
            Caption = 'Expected Receipt Date';

            trigger OnValidate()
            begin
                UpdatePurchLines(FIELDCAPTION("Expected Receipt Date"));
            end;
        }
        field(22;"Posting Description";Text[50])
        {
            Caption = 'Posting Description';
        }
        field(23;"Payment Terms Code";Code[10])
        {
            Caption = 'Payment Terms Code';
            TableRelation = "Payment Terms";

            trigger OnValidate()
            begin
                IF ("Payment Terms Code" <> '') AND ("Document Date" <> 0D) THEN BEGIN
                  PaymentTerms.GET("Payment Terms Code");
                  IF (("Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"]) AND
                      NOT PaymentTerms."Calc. Pmt. Disc. on Cr. Memos")
                  THEN BEGIN
                    VALIDATE("Due Date","Document Date");
                    VALIDATE("Pmt. Discount Date",0D);
                    VALIDATE("Payment Discount %",0);
                  END ELSE BEGIN
                    "Due Date" := CALCDATE(PaymentTerms."Due Date Calculation","Document Date");
                    "Pmt. Discount Date" := CALCDATE(PaymentTerms."Discount Date Calculation","Document Date");
                    IF NOT UpdateDocumentDate THEN
                      VALIDATE("Payment Discount %",PaymentTerms."Discount %")
                  END;
                END ELSE BEGIN
                  VALIDATE("Due Date","Document Date");
                  IF NOT UpdateDocumentDate THEN BEGIN
                    VALIDATE("Pmt. Discount Date",0D);
                    VALIDATE("Payment Discount %",0);
                  END;
                END;
                IF xRec."Payment Terms Code" = "Prepmt. Payment Terms Code" THEN
                  VALIDATE("Prepmt. Payment Terms Code","Payment Terms Code");
            end;
        }
        field(24;"Due Date";Date)
        {
            Caption = 'Due Date';
        }
        field(25;"Payment Discount %";Decimal)
        {
            Caption = 'Payment Discount %';
            DecimalPlaces = 0:5;
            MaxValue = 100;
            MinValue = 0;

            trigger OnValidate()
            begin
                IF NOT (CurrFieldNo IN [0,FIELDNO("Posting Date"),FIELDNO("Document Date")]) THEN
                  TESTFIELD(Status,Status::Open);
                GLSetup.GET;
                IF "Payment Discount %" < GLSetup."VAT Tolerance %" THEN
                  "VAT Base Discount %" := "Payment Discount %"
                ELSE
                  "VAT Base Discount %" := GLSetup."VAT Tolerance %";
                VALIDATE("VAT Base Discount %");
            end;
        }
        field(26;"Pmt. Discount Date";Date)
        {
            Caption = 'Pmt. Discount Date';
        }
        field(27;"Shipment Method Code";Code[10])
        {
            Caption = 'Shipment Method Code';
            TableRelation = "Shipment Method";

            trigger OnValidate()
            begin
                TESTFIELD(Status,Status::Open);
            end;
        }
        field(28;"Location Code";Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location WHERE (Use As In-Transit=CONST(No));

            trigger OnValidate()
            begin
                TESTFIELD(Status,Status::Open);
                IF ("Location Code" <> xRec."Location Code") AND
                   (xRec."Buy-from Vendor No." = "Buy-from Vendor No.")
                THEN
                  MessageIfPurchLinesExist(FIELDCAPTION("Location Code"));

                UpdateShipToAddress;

                IF "Location Code" = '' THEN BEGIN
                  IF InvtSetup.GET THEN
                    "Inbound Whse. Handling Time" := InvtSetup."Inbound Whse. Handling Time";
                END ELSE BEGIN
                  IF Location.GET("Location Code") THEN;
                  "Inbound Whse. Handling Time" := Location."Inbound Whse. Handling Time";
                END;
            end;
        }
        field(29;"Shortcut Dimension 1 Code";Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(1));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1,"Shortcut Dimension 1 Code");
            end;
        }
        field(30;"Shortcut Dimension 2 Code";Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(2));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2,"Shortcut Dimension 2 Code");
            end;
        }
        field(31;"Vendor Posting Group";Code[10])
        {
            Caption = 'Vendor Posting Group';
            Editable = false;
            TableRelation = "Vendor Posting Group";
        }
        field(32;"Currency Code";Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;

            trigger OnValidate()
            begin
                IF NOT (CurrFieldNo IN [0,FIELDNO("Posting Date")]) OR ("Currency Code" <> xRec."Currency Code") THEN
                  TESTFIELD(Status,Status::Open);
                IF (CurrFieldNo <> FIELDNO("Currency Code")) AND ("Currency Code" = xRec."Currency Code") THEN
                  UpdateCurrencyFactor
                ELSE BEGIN
                  IF "Currency Code" <> xRec."Currency Code" THEN BEGIN
                    UpdateCurrencyFactor;
                    IF PurchLinesExist THEN
                      IF CONFIRM(ChangeCurrencyQst,FALSE,FIELDCAPTION("Currency Code")) THEN BEGIN
                        SetHideValidationDialog(TRUE);
                        RecreatePurchLines(FIELDCAPTION("Currency Code"));
                        SetHideValidationDialog(FALSE);
                      END ELSE
                        ERROR(Text018,FIELDCAPTION("Currency Code"));
                  END ELSE
                    IF "Currency Code" <> '' THEN BEGIN
                      UpdateCurrencyFactor;
                      IF "Currency Factor" <> xRec."Currency Factor" THEN
                        ConfirmUpdateCurrencyFactor;
                    END;
                END;
            end;
        }
        field(33;"Currency Factor";Decimal)
        {
            Caption = 'Currency Factor';
            DecimalPlaces = 0:15;
            Editable = false;
            MinValue = 0;

            trigger OnValidate()
            begin
                IF "Currency Factor" <> xRec."Currency Factor" THEN
                  UpdatePurchLines(FIELDCAPTION("Currency Factor"));
            end;
        }
        field(35;"Prices Including VAT";Boolean)
        {
            Caption = 'Prices Including VAT';

            trigger OnValidate()
            var
                PurchLine: Record "39";
                Currency: Record "4";
                RecalculatePrice: Boolean;
            begin
                TESTFIELD(Status,Status::Open);

                IF "Prices Including VAT" <> xRec."Prices Including VAT" THEN BEGIN
                  PurchLine.SETRANGE("Document Type","Document Type");
                  PurchLine.SETRANGE("Document No.","No.");
                  PurchLine.SETFILTER("Direct Unit Cost",'<>%1',0);
                  PurchLine.SETFILTER("VAT %",'<>%1',0);
                  IF PurchLine.FIND('-') THEN BEGIN
                    RecalculatePrice :=
                      CONFIRM(
                        STRSUBSTNO(
                          Text025 +
                          Text027,
                          FIELDCAPTION("Prices Including VAT"),PurchLine.FIELDCAPTION("Direct Unit Cost")),
                        TRUE);
                    PurchLine.SetPurchHeader(Rec);

                    IF "Currency Code" = '' THEN
                      Currency.InitRoundingPrecision
                    ELSE
                      Currency.GET("Currency Code");

                    REPEAT
                      PurchLine.TESTFIELD("Quantity Invoiced",0);
                      PurchLine.TESTFIELD("Prepmt. Amt. Inv.",0);
                      IF NOT RecalculatePrice THEN BEGIN
                        PurchLine."VAT Difference" := 0;
                        PurchLine.InitOutstandingAmount;
                      END ELSE
                        IF "Prices Including VAT" THEN BEGIN
                          PurchLine."Direct Unit Cost" :=
                            ROUND(
                              PurchLine."Direct Unit Cost" * (1 + PurchLine."VAT %" / 100),
                              Currency."Unit-Amount Rounding Precision");
                          IF PurchLine.Quantity <> 0 THEN BEGIN
                            PurchLine."Line Discount Amount" :=
                              ROUND(
                                PurchLine.Quantity * PurchLine."Direct Unit Cost" * PurchLine."Line Discount %" / 100,
                                Currency."Amount Rounding Precision");
                            PurchLine.VALIDATE("Inv. Discount Amount",
                              ROUND(
                                PurchLine."Inv. Discount Amount" * (1 + PurchLine."VAT %" / 100),
                                Currency."Amount Rounding Precision"));
                          END;
                        END ELSE BEGIN
                          PurchLine."Direct Unit Cost" :=
                            ROUND(
                              PurchLine."Direct Unit Cost" / (1 + PurchLine."VAT %" / 100),
                              Currency."Unit-Amount Rounding Precision");
                          IF PurchLine.Quantity <> 0 THEN BEGIN
                            PurchLine."Line Discount Amount" :=
                              ROUND(
                                PurchLine.Quantity * PurchLine."Direct Unit Cost" * PurchLine."Line Discount %" / 100,
                                Currency."Amount Rounding Precision");
                            PurchLine.VALIDATE("Inv. Discount Amount",
                              ROUND(
                                PurchLine."Inv. Discount Amount" / (1 + PurchLine."VAT %" / 100),
                                Currency."Amount Rounding Precision"));
                          END;
                        END;
                      PurchLine.MODIFY;
                    UNTIL PurchLine.NEXT = 0;
                  END;
                END;
            end;
        }
        field(37;"Invoice Disc. Code";Code[20])
        {
            Caption = 'Invoice Disc. Code';

            trigger OnValidate()
            begin
                TESTFIELD(Status,Status::Open);
                MessageIfPurchLinesExist(FIELDCAPTION("Invoice Disc. Code"));
            end;
        }
        field(41;"Language Code";Code[10])
        {
            Caption = 'Language Code';
            TableRelation = Language;

            trigger OnValidate()
            begin
                MessageIfPurchLinesExist(FIELDCAPTION("Language Code"));
            end;
        }
        field(43;"Purchaser Code";Code[10])
        {
            Caption = 'Purchaser Code';
            TableRelation = Salesperson/Purchaser;

            trigger OnValidate()
            var
                ApprovalEntry: Record "454";
            begin
                ApprovalEntry.SETRANGE("Table ID",DATABASE::"Purchase Header");
                ApprovalEntry.SETRANGE("Document Type","Document Type");
                ApprovalEntry.SETRANGE("Document No.","No.");
                ApprovalEntry.SETFILTER(Status,'<>%1&<>%2',ApprovalEntry.Status::Canceled,ApprovalEntry.Status::Rejected);
                IF NOT ApprovalEntry.ISEMPTY THEN
                  ERROR(Text042,FIELDCAPTION("Purchaser Code"));

                InitDefaultDim;
            end;
        }
        field(45;"Order Class";Code[10])
        {
            Caption = 'Order Class';
        }
        field(46;Comment;Boolean)
        {
            CalcFormula = Exist("Purch. Comment Line" WHERE (Document Type=FIELD(Document Type),
                                                             No.=FIELD(No.),
                                                             Document Line No.=CONST(0)));
            Caption = 'Comment';
            Editable = false;
            FieldClass = FlowField;
        }
        field(47;"No. Printed";Integer)
        {
            Caption = 'No. Printed';
            Editable = false;
        }
        field(51;"On Hold";Code[3])
        {
            Caption = 'On Hold';
        }
        field(52;"Applies-to Doc. Type";Option)
        {
            Caption = 'Applies-to Doc. Type';
            OptionCaption = ' ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund';
            OptionMembers = " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund;
        }
        field(53;"Applies-to Doc. No.";Code[20])
        {
            Caption = 'Applies-to Doc. No.';

            trigger OnLookup()
            begin
                TESTFIELD("Bal. Account No.",'');
                VendLedgEntry.SETCURRENTKEY("Vendor No.",Open,Positive,"Due Date");
                VendLedgEntry.SETRANGE("Vendor No.","Pay-to Vendor No.");
                VendLedgEntry.SETRANGE(Open,TRUE);
                IF "Applies-to Doc. No." <> '' THEN BEGIN
                  VendLedgEntry.SETRANGE("Document Type","Applies-to Doc. Type");
                  VendLedgEntry.SETRANGE("Document No.","Applies-to Doc. No.");
                  IF VendLedgEntry.FINDFIRST THEN;
                  VendLedgEntry.SETRANGE("Document Type");
                  VendLedgEntry.SETRANGE("Document No.");
                END ELSE
                  IF "Applies-to Doc. Type" <> 0 THEN BEGIN
                    VendLedgEntry.SETRANGE("Document Type","Applies-to Doc. Type");
                    IF VendLedgEntry.FINDFIRST THEN;
                    VendLedgEntry.SETRANGE("Document Type");
                  END ELSE
                    IF Amount <> 0 THEN BEGIN
                      VendLedgEntry.SETRANGE(Positive,Amount < 0);
                      IF VendLedgEntry.FINDFIRST THEN;
                      VendLedgEntry.SETRANGE(Positive);
                    END;
                ApplyVendEntries.SetPurch(Rec,VendLedgEntry,PurchHeader.FIELDNO("Applies-to Doc. No."));
                ApplyVendEntries.SETTABLEVIEW(VendLedgEntry);
                ApplyVendEntries.SETRECORD(VendLedgEntry);
                ApplyVendEntries.LOOKUPMODE(TRUE);
                IF ApplyVendEntries.RUNMODAL = ACTION::LookupOK THEN BEGIN
                  ApplyVendEntries.GetVendLedgEntry(VendLedgEntry);
                  GenJnlApply.CheckAgainstApplnCurrency(
                    "Currency Code",VendLedgEntry."Currency Code",GenJnILine."Account Type"::Vendor,TRUE);
                  "Applies-to Doc. Type" := VendLedgEntry."Document Type";
                  "Applies-to Doc. No." := VendLedgEntry."Document No.";
                END;
                CLEAR(ApplyVendEntries);
            end;

            trigger OnValidate()
            begin
                IF "Applies-to Doc. No." <> '' THEN
                  TESTFIELD("Bal. Account No.",'');

                IF ("Applies-to Doc. No." <> xRec."Applies-to Doc. No.") AND (xRec."Applies-to Doc. No." <> '') AND
                   ("Applies-to Doc. No." <> '')
                THEN BEGIN
                  SetAmountToApply("Applies-to Doc. No.","Buy-from Vendor No.");
                  SetAmountToApply(xRec."Applies-to Doc. No.","Buy-from Vendor No.");
                END ELSE
                  IF ("Applies-to Doc. No." <> xRec."Applies-to Doc. No.") AND (xRec."Applies-to Doc. No." = '') THEN
                    SetAmountToApply("Applies-to Doc. No.","Buy-from Vendor No.")
                  ELSE
                    IF ("Applies-to Doc. No." <> xRec."Applies-to Doc. No.") AND ("Applies-to Doc. No." = '') THEN
                      SetAmountToApply(xRec."Applies-to Doc. No.","Buy-from Vendor No.");
            end;
        }
        field(55;"Bal. Account No.";Code[20])
        {
            Caption = 'Bal. Account No.';
            TableRelation = IF (Bal. Account Type=CONST(G/L Account)) "G/L Account"
                            ELSE IF (Bal. Account Type=CONST(Bank Account)) "Bank Account";

            trigger OnValidate()
            begin
                IF "Bal. Account No." <> '' THEN
                  CASE "Bal. Account Type" OF
                    "Bal. Account Type"::"G/L Account":
                      BEGIN
                        GLAcc.GET("Bal. Account No.");
                        GLAcc.CheckGLAcc;
                        GLAcc.TESTFIELD("Direct Posting",TRUE);
                      END;
                    "Bal. Account Type"::"Bank Account":
                      BEGIN
                        BankAcc.GET("Bal. Account No.");
                        BankAcc.TESTFIELD(Blocked,FALSE);
                        BankAcc.TESTFIELD("Currency Code","Currency Code");
                      END;
                  END;
            end;
        }
        field(57;Receive;Boolean)
        {
            Caption = 'Receive';
        }
        field(58;Invoice;Boolean)
        {
            Caption = 'Invoice';
        }
        field(59;"Print Posted Documents";Boolean)
        {
            Caption = 'Print Posted Documents';
        }
        field(60;Amount;Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = Sum("Purchase Line".Amount WHERE (Document Type=FIELD(Document Type),
                                                            Document No.=FIELD(No.)));
            Caption = 'Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(61;"Amount Including VAT";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = Sum("Purchase Line"."Amount Including VAT" WHERE (Document Type=FIELD(Document Type),
                                                                            Document No.=FIELD(No.)));
            Caption = 'Amount Including VAT';
            Editable = false;
            FieldClass = FlowField;
        }
        field(62;"Receiving No.";Code[20])
        {
            Caption = 'Receiving No.';
        }
        field(63;"Posting No.";Code[20])
        {
            Caption = 'Posting No.';
        }
        field(64;"Last Receiving No.";Code[20])
        {
            Caption = 'Last Receiving No.';
            Editable = false;
            TableRelation = "Purch. Rcpt. Header";
        }
        field(65;"Last Posting No.";Code[20])
        {
            Caption = 'Last Posting No.';
            Editable = false;
            TableRelation = "Purch. Inv. Header";
        }
        field(66;"Vendor Order No.";Code[35])
        {
            Caption = 'Vendor Order No.';
        }
        field(67;"Vendor Shipment No.";Code[35])
        {
            Caption = 'Vendor Shipment No.';
        }
        field(68;"Vendor Invoice No.";Code[35])
        {
            Caption = 'Vendor Invoice No.';
        }
        field(69;"Vendor Cr. Memo No.";Code[35])
        {
            Caption = 'Vendor Cr. Memo No.';
        }
        field(70;"VAT Registration No.";Text[20])
        {
            Caption = 'VAT Registration No.';
        }
        field(72;"Sell-to Customer No.";Code[20])
        {
            Caption = 'Sell-to Customer No.';
            TableRelation = Customer;

            trigger OnValidate()
            begin
                IF ("Document Type" = "Document Type"::Order) AND
                   (xRec."Sell-to Customer No." <> "Sell-to Customer No.")
                THEN BEGIN
                  PurchLine.SETRANGE("Document Type",PurchLine."Document Type"::Order);
                  PurchLine.SETRANGE("Document No.","No.");
                  PurchLine.SETFILTER("Sales Order Line No.",'<>0');
                  IF NOT PurchLine.ISEMPTY THEN
                    ERROR(
                      Text006,
                      FIELDCAPTION("Sell-to Customer No."));
                END;

                IF "Sell-to Customer No." = '' THEN
                  VALIDATE("Location Code",UserSetupMgt.GetLocation(1,'',"Responsibility Center"))
                ELSE
                  VALIDATE("Ship-to Code",'');
            end;
        }
        field(73;"Reason Code";Code[10])
        {
            Caption = 'Reason Code';
            TableRelation = "Reason Code";
        }
        field(74;"Gen. Bus. Posting Group";Code[10])
        {
            Caption = 'Gen. Bus. Posting Group';
            TableRelation = "Gen. Business Posting Group";

            trigger OnValidate()
            begin
                TESTFIELD(Status,Status::Open);
                IF (xRec."Buy-from Vendor No." = "Buy-from Vendor No.") AND
                   (xRec."Gen. Bus. Posting Group" <> "Gen. Bus. Posting Group")
                THEN
                  IF GenBusPostingGrp.ValidateVatBusPostingGroup(GenBusPostingGrp,"Gen. Bus. Posting Group") THEN BEGIN
                    "VAT Bus. Posting Group" := GenBusPostingGrp."Def. VAT Bus. Posting Group";
                    RecreatePurchLines(FIELDCAPTION("Gen. Bus. Posting Group"));
                  END;
            end;
        }
        field(76;"Transaction Type";Code[10])
        {
            Caption = 'Transaction Type';
            TableRelation = "Transaction Type";

            trigger OnValidate()
            begin
                UpdatePurchLines(FIELDCAPTION("Transaction Type"));
            end;
        }
        field(77;"Transport Method";Code[10])
        {
            Caption = 'Transport Method';
            TableRelation = "Transport Method";

            trigger OnValidate()
            begin
                UpdatePurchLines(FIELDCAPTION("Transport Method"));
            end;
        }
        field(78;"VAT Country/Region Code";Code[10])
        {
            Caption = 'VAT Country/Region Code';
            TableRelation = Country/Region;
        }
        field(79;"Buy-from Vendor Name";Text[50])
        {
            Caption = 'Buy-from Vendor Name';
        }
        field(80;"Buy-from Vendor Name 2";Text[50])
        {
            Caption = 'Buy-from Vendor Name 2';
        }
        field(81;"Buy-from Address";Text[50])
        {
            Caption = 'Buy-from Address';
        }
        field(82;"Buy-from Address 2";Text[50])
        {
            Caption = 'Buy-from Address 2';
        }
        field(83;"Buy-from City";Text[30])
        {
            Caption = 'Buy-from City';
            TableRelation = IF (Buy-from Country/Region Code=CONST()) "Post Code".City
                            ELSE IF (Buy-from Country/Region Code=FILTER(<>'')) "Post Code".City WHERE (Country/Region Code=FIELD(Buy-from Country/Region Code));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                PostCode.ValidateCity(
                  "Buy-from City","Buy-from Post Code","Buy-from County","Buy-from Country/Region Code",(CurrFieldNo <> 0) AND GUIALLOWED);
            end;
        }
        field(84;"Buy-from Contact";Text[50])
        {
            Caption = 'Buy-from Contact';
        }
        field(85;"Pay-to Post Code";Code[20])
        {
            Caption = 'Pay-to Post Code';
            TableRelation = IF (Pay-to Country/Region Code=CONST()) "Post Code"
                            ELSE IF (Pay-to Country/Region Code=FILTER(<>'')) "Post Code" WHERE (Country/Region Code=FIELD(Pay-to Country/Region Code));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                PostCode.ValidatePostCode(
                  "Pay-to City","Pay-to Post Code","Pay-to County","Pay-to Country/Region Code",(CurrFieldNo <> 0) AND GUIALLOWED);
            end;
        }
        field(86;"Pay-to County";Text[30])
        {
            Caption = 'Pay-to County';
        }
        field(87;"Pay-to Country/Region Code";Code[10])
        {
            Caption = 'Pay-to Country/Region Code';
            TableRelation = Country/Region;
        }
        field(88;"Buy-from Post Code";Code[20])
        {
            Caption = 'Buy-from Post Code';
            TableRelation = IF (Buy-from Country/Region Code=CONST()) "Post Code"
                            ELSE IF (Buy-from Country/Region Code=FILTER(<>'')) "Post Code" WHERE (Country/Region Code=FIELD(Buy-from Country/Region Code));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                PostCode.ValidatePostCode(
                  "Buy-from City","Buy-from Post Code","Buy-from County","Buy-from Country/Region Code",(CurrFieldNo <> 0) AND GUIALLOWED);
            end;
        }
        field(89;"Buy-from County";Text[30])
        {
            Caption = 'Buy-from County';
        }
        field(90;"Buy-from Country/Region Code";Code[10])
        {
            Caption = 'Buy-from Country/Region Code';
            TableRelation = Country/Region;
        }
        field(91;"Ship-to Post Code";Code[20])
        {
            Caption = 'Ship-to Post Code';
            TableRelation = IF (Ship-to Country/Region Code=CONST()) "Post Code"
                            ELSE IF (Ship-to Country/Region Code=FILTER(<>'')) "Post Code" WHERE (Country/Region Code=FIELD(Ship-to Country/Region Code));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                PostCode.ValidatePostCode(
                  "Ship-to City","Ship-to Post Code","Ship-to County","Ship-to Country/Region Code",(CurrFieldNo <> 0) AND GUIALLOWED);
            end;
        }
        field(92;"Ship-to County";Text[30])
        {
            Caption = 'Ship-to County';
        }
        field(93;"Ship-to Country/Region Code";Code[10])
        {
            Caption = 'Ship-to Country/Region Code';
            TableRelation = Country/Region;
        }
        field(94;"Bal. Account Type";Option)
        {
            Caption = 'Bal. Account Type';
            OptionCaption = 'G/L Account,Bank Account';
            OptionMembers = "G/L Account","Bank Account";
        }
        field(95;"Order Address Code";Code[10])
        {
            Caption = 'Order Address Code';
            TableRelation = "Order Address".Code WHERE (Vendor No.=FIELD(Buy-from Vendor No.));

            trigger OnValidate()
            begin
                IF "Order Address Code" <> '' THEN BEGIN
                  OrderAddr.GET("Buy-from Vendor No.","Order Address Code");
                  "Buy-from Vendor Name" := OrderAddr.Name;
                  "Buy-from Vendor Name 2" := OrderAddr."Name 2";
                  "Buy-from Address" := OrderAddr.Address;
                  "Buy-from Address 2" := OrderAddr."Address 2";
                  "Buy-from City" := OrderAddr.City;
                  "Buy-from Contact" := OrderAddr.Contact;
                  "Buy-from Post Code" := OrderAddr."Post Code";
                  "Buy-from County" := OrderAddr.County;
                  "Buy-from Country/Region Code" := OrderAddr."Country/Region Code";

                  IF ("Document Type" = "Document Type"::"Return Order") OR
                     ("Document Type" = "Document Type"::"Credit Memo")
                  THEN BEGIN
                    "Ship-to Name" := OrderAddr.Name;
                    "Ship-to Name 2" := OrderAddr."Name 2";
                    "Ship-to Address" := OrderAddr.Address;
                    "Ship-to Address 2" := OrderAddr."Address 2";
                    "Ship-to City" := OrderAddr.City;
                    "Ship-to Post Code" := OrderAddr."Post Code";
                    "Ship-to County" := OrderAddr.County;
                    "Ship-to Country/Region Code" := OrderAddr."Country/Region Code";
                    "Ship-to Contact" := OrderAddr.Contact;
                  END
                END ELSE BEGIN
                  GetVend("Buy-from Vendor No.");
                  "Buy-from Vendor Name" := Vend.Name;
                  "Buy-from Vendor Name 2" := Vend."Name 2";
                  "Buy-from Address" := Vend.Address;
                  "Buy-from Address 2" := Vend."Address 2";
                  "Buy-from City" := Vend.City;
                  "Buy-from Contact" := Vend.Contact;
                  "Buy-from Post Code" := Vend."Post Code";
                  "Buy-from County" := Vend.County;
                  "Buy-from Country/Region Code" := Vend."Country/Region Code";

                  IF ("Document Type" = "Document Type"::"Return Order") OR
                     ("Document Type" = "Document Type"::"Credit Memo")
                  THEN BEGIN
                    "Ship-to Name" := Vend.Name;
                    "Ship-to Name 2" := Vend."Name 2";
                    "Ship-to Address" := Vend.Address;
                    "Ship-to Address 2" := Vend."Address 2";
                    "Ship-to City" := Vend.City;
                    "Ship-to Post Code" := Vend."Post Code";
                    "Ship-to County" := Vend.County;
                    "Ship-to Country/Region Code" := Vend."Country/Region Code";
                    "Ship-to Contact" := Vend.Contact;
                    "Shipment Method Code" := Vend."Shipment Method Code";
                    IF Vend."Location Code" <> '' THEN
                      VALIDATE("Location Code",Vend."Location Code");
                  END
                END;
            end;
        }
        field(97;"Entry Point";Code[10])
        {
            Caption = 'Entry Point';
            TableRelation = "Entry/Exit Point";

            trigger OnValidate()
            begin
                UpdatePurchLines(FIELDCAPTION("Entry Point"));
            end;
        }
        field(98;Correction;Boolean)
        {
            Caption = 'Correction';
        }
        field(99;"Document Date";Date)
        {
            Caption = 'Document Date';

            trigger OnValidate()
            begin
                IF xRec."Document Date" <> "Document Date" THEN
                  UpdateDocumentDate := TRUE;
                VALIDATE("Payment Terms Code");
                VALIDATE("Prepmt. Payment Terms Code");
            end;
        }
        field(101;"Area";Code[10])
        {
            Caption = 'Area';
            TableRelation = Area;

            trigger OnValidate()
            begin
                UpdatePurchLines(FIELDCAPTION(Area));
            end;
        }
        field(102;"Transaction Specification";Code[10])
        {
            Caption = 'Transaction Specification';
            TableRelation = "Transaction Specification";

            trigger OnValidate()
            begin
                UpdatePurchLines(FIELDCAPTION("Transaction Specification"));
            end;
        }
        field(104;"Payment Method Code";Code[10])
        {
            Caption = 'Payment Method Code';
            TableRelation = "Payment Method";

            trigger OnValidate()
            begin
                PaymentMethod.INIT;
                IF "Payment Method Code" <> '' THEN
                  PaymentMethod.GET("Payment Method Code");
                "Bal. Account Type" := PaymentMethod."Bal. Account Type";
                "Bal. Account No." := PaymentMethod."Bal. Account No.";
                IF "Bal. Account No." <> '' THEN BEGIN
                  TESTFIELD("Applies-to Doc. No.",'');
                  TESTFIELD("Applies-to ID",'');
                END;
            end;
        }
        field(107;"No. Series";Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(108;"Posting No. Series";Code[10])
        {
            Caption = 'Posting No. Series';
            TableRelation = "No. Series";

            trigger OnLookup()
            begin
                WITH PurchHeader DO BEGIN
                  PurchHeader := Rec;
                  PurchSetup.GET;
                  TestNoSeries;
                  IF NoSeriesMgt.LookupSeries(GetPostingNoSeriesCode,"Posting No. Series") THEN
                    VALIDATE("Posting No. Series");
                  Rec := PurchHeader;
                END;
            end;

            trigger OnValidate()
            begin
                IF "Posting No. Series" <> '' THEN BEGIN
                  PurchSetup.GET;
                  TestNoSeries;
                  NoSeriesMgt.TestSeries(GetPostingNoSeriesCode,"Posting No. Series");
                END;
                TESTFIELD("Posting No.",'');
            end;
        }
        field(109;"Receiving No. Series";Code[10])
        {
            Caption = 'Receiving No. Series';
            TableRelation = "No. Series";

            trigger OnLookup()
            begin
                WITH PurchHeader DO BEGIN
                  PurchHeader := Rec;
                  PurchSetup.GET;
                  PurchSetup.TESTFIELD("Posted Receipt Nos.");
                  IF NoSeriesMgt.LookupSeries(PurchSetup."Posted Receipt Nos.","Receiving No. Series") THEN
                    VALIDATE("Receiving No. Series");
                  Rec := PurchHeader;
                END;
            end;

            trigger OnValidate()
            begin
                IF "Receiving No. Series" <> '' THEN BEGIN
                  PurchSetup.GET;
                  PurchSetup.TESTFIELD("Posted Receipt Nos.");
                  NoSeriesMgt.TestSeries(PurchSetup."Posted Receipt Nos.","Receiving No. Series");
                END;
                TESTFIELD("Receiving No.",'');
            end;
        }
        field(114;"Tax Area Code";Code[20])
        {
            Caption = 'Tax Area Code';
            TableRelation = "Tax Area";

            trigger OnValidate()
            begin
                TESTFIELD(Status,Status::Open);
                MessageIfPurchLinesExist(FIELDCAPTION("Tax Area Code"));
            end;
        }
        field(115;"Tax Liable";Boolean)
        {
            Caption = 'Tax Liable';

            trigger OnValidate()
            begin
                TESTFIELD(Status,Status::Open);
                MessageIfPurchLinesExist(FIELDCAPTION("Tax Liable"));
            end;
        }
        field(116;"VAT Bus. Posting Group";Code[10])
        {
            Caption = 'VAT Bus. Posting Group';
            TableRelation = "VAT Business Posting Group";

            trigger OnValidate()
            begin
                TESTFIELD(Status,Status::Open);
                IF (xRec."Buy-from Vendor No." = "Buy-from Vendor No.") AND
                   (xRec."VAT Bus. Posting Group" <> "VAT Bus. Posting Group")
                THEN
                  RecreatePurchLines(FIELDCAPTION("VAT Bus. Posting Group"));
            end;
        }
        field(118;"Applies-to ID";Code[50])
        {
            Caption = 'Applies-to ID';

            trigger OnValidate()
            var
                TempVendLedgEntry: Record "25";
            begin
                IF "Applies-to ID" <> '' THEN
                  TESTFIELD("Bal. Account No.",'');
                IF ("Applies-to ID" <> xRec."Applies-to ID") AND (xRec."Applies-to ID" <> '') THEN BEGIN
                  VendLedgEntry.SETCURRENTKEY("Vendor No.",Open);
                  VendLedgEntry.SETRANGE("Vendor No.","Pay-to Vendor No.");
                  VendLedgEntry.SETRANGE(Open,TRUE);
                  VendLedgEntry.SETRANGE("Applies-to ID",xRec."Applies-to ID");
                  IF VendLedgEntry.FINDFIRST THEN
                    VendEntrySetApplID.SetApplId(VendLedgEntry,TempVendLedgEntry,'');
                  VendLedgEntry.RESET;
                END;
            end;
        }
        field(119;"VAT Base Discount %";Decimal)
        {
            Caption = 'VAT Base Discount %';
            DecimalPlaces = 0:5;
            MaxValue = 100;
            MinValue = 0;

            trigger OnValidate()
            begin
                GLSetup.GET;
                IF "VAT Base Discount %" > GLSetup."VAT Tolerance %" THEN BEGIN
                  IF HideValidationDialog THEN
                    Confirmed := TRUE
                  ELSE
                    Confirmed :=
                      CONFIRM(
                        Text007 +
                        Text008,FALSE,
                        FIELDCAPTION("VAT Base Discount %"),
                        GLSetup.FIELDCAPTION("VAT Tolerance %"),
                        GLSetup.TABLECAPTION);
                  IF NOT Confirmed THEN
                    "VAT Base Discount %" := xRec."VAT Base Discount %";
                END;

                IF ("VAT Base Discount %" = xRec."VAT Base Discount %") AND
                   (CurrFieldNo <> 0)
                THEN
                  EXIT;

                PurchLine.SETRANGE("Document Type","Document Type");
                PurchLine.SETRANGE("Document No.","No.");
                PurchLine.SETFILTER(Type,'<>%1',PurchLine.Type::" ");
                PurchLine.SETFILTER(Quantity,'<>0');
                PurchLine.LOCKTABLE;
                IF PurchLine.FINDSET THEN BEGIN
                  MODIFY;
                  REPEAT
                    PurchLine.UpdateAmounts;
                    PurchLine.MODIFY;
                  UNTIL PurchLine.NEXT = 0;
                END;
                PurchLine.RESET;
            end;
        }
        field(120;Status;Option)
        {
            Caption = 'Status';
            Editable = false;
            OptionCaption = 'Open,Released,Pending Approval,Pending Prepayment';
            OptionMembers = Open,Released,"Pending Approval","Pending Prepayment";
        }
        field(121;"Invoice Discount Calculation";Option)
        {
            Caption = 'Invoice Discount Calculation';
            Editable = false;
            OptionCaption = 'None,%,Amount';
            OptionMembers = "None","%",Amount;
        }
        field(122;"Invoice Discount Value";Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Invoice Discount Value';
            Editable = false;
        }
        field(123;"Send IC Document";Boolean)
        {
            Caption = 'Send IC Document';

            trigger OnValidate()
            begin
                IF "Send IC Document" THEN BEGIN
                  TESTFIELD("Buy-from IC Partner Code");
                  TESTFIELD("IC Direction","IC Direction"::Outgoing);
                END;
            end;
        }
        field(124;"IC Status";Option)
        {
            Caption = 'IC Status';
            OptionCaption = 'New,Pending,Sent';
            OptionMembers = New,Pending,Sent;
        }
        field(125;"Buy-from IC Partner Code";Code[20])
        {
            Caption = 'Buy-from IC Partner Code';
            Editable = false;
            TableRelation = "IC Partner";
        }
        field(126;"Pay-to IC Partner Code";Code[20])
        {
            Caption = 'Pay-to IC Partner Code';
            Editable = false;
            TableRelation = "IC Partner";
        }
        field(129;"IC Direction";Option)
        {
            Caption = 'IC Direction';
            OptionCaption = 'Outgoing,Incoming';
            OptionMembers = Outgoing,Incoming;

            trigger OnValidate()
            begin
                IF "IC Direction" = "IC Direction"::Incoming THEN
                  "Send IC Document" := FALSE;
            end;
        }
        field(130;"Prepayment No.";Code[20])
        {
            Caption = 'Prepayment No.';
        }
        field(131;"Last Prepayment No.";Code[20])
        {
            Caption = 'Last Prepayment No.';
            TableRelation = "Purch. Inv. Header";
        }
        field(132;"Prepmt. Cr. Memo No.";Code[20])
        {
            Caption = 'Prepmt. Cr. Memo No.';
        }
        field(133;"Last Prepmt. Cr. Memo No.";Code[20])
        {
            Caption = 'Last Prepmt. Cr. Memo No.';
            TableRelation = "Purch. Cr. Memo Hdr.";
        }
        field(134;"Prepayment %";Decimal)
        {
            Caption = 'Prepayment %';
            DecimalPlaces = 0:5;
            MaxValue = 100;
            MinValue = 0;

            trigger OnValidate()
            begin
                IF CurrFieldNo <> 0 THEN
                  UpdatePurchLines(FIELDCAPTION("Prepayment %"));
            end;
        }
        field(135;"Prepayment No. Series";Code[10])
        {
            Caption = 'Prepayment No. Series';
            TableRelation = "No. Series";

            trigger OnLookup()
            begin
                WITH PurchHeader DO BEGIN
                  PurchHeader := Rec;
                  PurchSetup.GET;
                  PurchSetup.TESTFIELD("Posted Prepmt. Inv. Nos.");
                  IF NoSeriesMgt.LookupSeries(GetPostingPrepaymentNoSeriesCode,"Prepayment No. Series") THEN
                    VALIDATE("Prepayment No. Series");
                  Rec := PurchHeader;
                END;
            end;

            trigger OnValidate()
            begin
                IF "Prepayment No. Series" <> '' THEN BEGIN
                  PurchSetup.GET;
                  PurchSetup.TESTFIELD("Posted Prepmt. Inv. Nos.");
                  NoSeriesMgt.TestSeries(GetPostingPrepaymentNoSeriesCode,"Prepayment No. Series");
                END;
                TESTFIELD("Prepayment No.",'');
            end;
        }
        field(136;"Compress Prepayment";Boolean)
        {
            Caption = 'Compress Prepayment';
            InitValue = true;
        }
        field(137;"Prepayment Due Date";Date)
        {
            Caption = 'Prepayment Due Date';
        }
        field(138;"Prepmt. Cr. Memo No. Series";Code[10])
        {
            Caption = 'Prepmt. Cr. Memo No. Series';
            TableRelation = "No. Series";

            trigger OnLookup()
            begin
                WITH PurchHeader DO BEGIN
                  PurchHeader := Rec;
                  PurchSetup.GET;
                  PurchSetup.TESTFIELD("Posted Prepmt. Cr. Memo Nos.");
                  IF NoSeriesMgt.LookupSeries(GetPostingPrepaymentNoSeriesCode,"Prepmt. Cr. Memo No. Series") THEN
                    VALIDATE("Prepmt. Cr. Memo No. Series");
                  Rec := PurchHeader;
                END;
            end;

            trigger OnValidate()
            begin
                IF "Prepmt. Cr. Memo No. Series" <> '' THEN BEGIN
                  PurchSetup.GET;
                  PurchSetup.TESTFIELD("Posted Prepmt. Cr. Memo Nos.");
                  NoSeriesMgt.TestSeries(GetPostingPrepaymentNoSeriesCode,"Prepmt. Cr. Memo No. Series");
                END;
                TESTFIELD("Prepmt. Cr. Memo No.",'');
            end;
        }
        field(139;"Prepmt. Posting Description";Text[50])
        {
            Caption = 'Prepmt. Posting Description';
        }
        field(142;"Prepmt. Pmt. Discount Date";Date)
        {
            Caption = 'Prepmt. Pmt. Discount Date';
        }
        field(143;"Prepmt. Payment Terms Code";Code[10])
        {
            Caption = 'Prepmt. Payment Terms Code';
            TableRelation = "Payment Terms";

            trigger OnValidate()
            var
                PaymentTerms: Record "3";
            begin
                IF ("Prepmt. Payment Terms Code" <> '') AND ("Document Date" <> 0D) THEN BEGIN
                  PaymentTerms.GET("Prepmt. Payment Terms Code");
                  IF (("Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"]) AND
                      NOT PaymentTerms."Calc. Pmt. Disc. on Cr. Memos")
                  THEN BEGIN
                    VALIDATE("Prepayment Due Date","Document Date");
                    VALIDATE("Prepmt. Pmt. Discount Date",0D);
                    VALIDATE("Prepmt. Payment Discount %",0);
                  END ELSE BEGIN
                    "Prepayment Due Date" := CALCDATE(PaymentTerms."Due Date Calculation","Document Date");
                    "Prepmt. Pmt. Discount Date" := CALCDATE(PaymentTerms."Discount Date Calculation","Document Date");
                    IF NOT UpdateDocumentDate THEN
                      VALIDATE("Prepmt. Payment Discount %",PaymentTerms."Discount %")
                  END;
                END ELSE BEGIN
                  VALIDATE("Prepayment Due Date","Document Date");
                  IF NOT UpdateDocumentDate THEN BEGIN
                    VALIDATE("Prepmt. Pmt. Discount Date",0D);
                    VALIDATE("Prepmt. Payment Discount %",0);
                  END;
                END;
            end;
        }
        field(144;"Prepmt. Payment Discount %";Decimal)
        {
            Caption = 'Prepmt. Payment Discount %';
            DecimalPlaces = 0:5;
            MaxValue = 100;
            MinValue = 0;

            trigger OnValidate()
            begin
                IF NOT (CurrFieldNo IN [0,FIELDNO("Posting Date"),FIELDNO("Document Date")]) THEN
                  TESTFIELD(Status,Status::Open);
                GLSetup.GET;
                IF "Payment Discount %" < GLSetup."VAT Tolerance %" THEN
                  "VAT Base Discount %" := "Payment Discount %"
                ELSE
                  "VAT Base Discount %" := GLSetup."VAT Tolerance %";
                VALIDATE("VAT Base Discount %");
            end;
        }
        field(151;"Quote No.";Code[20])
        {
            Caption = 'Quote No.';
            Editable = false;
        }
        field(160;"Job Queue Status";Option)
        {
            Caption = 'Job Queue Status';
            Editable = false;
            OptionCaption = ' ,Scheduled for Posting,Error,Posting';
            OptionMembers = " ","Scheduled for Posting",Error,Posting;

            trigger OnLookup()
            var
                JobQueueEntry: Record "472";
            begin
                IF "Job Queue Status" = "Job Queue Status"::" " THEN
                  EXIT;
                JobQueueEntry.ShowStatusMsg("Job Queue Entry ID");
            end;
        }
        field(161;"Job Queue Entry ID";Guid)
        {
            Caption = 'Job Queue Entry ID';
            Editable = false;
        }
        field(165;"Incoming Document Entry No.";Integer)
        {
            Caption = 'Incoming Document Entry No.';
            TableRelation = "Incoming Document" WHERE (Status=FILTER(New|Approved));

            trigger OnValidate()
            var
                IncomingDocument: Record "130";
            begin
                IncomingDocument.SetPurchDoc(Rec);
            end;
        }
        field(170;"Creditor No.";Code[20])
        {
            Caption = 'Creditor No.';
            Numeric = true;
        }
        field(171;"Payment Reference";Code[50])
        {
            Caption = 'Payment Reference';
            Numeric = true;

            trigger OnValidate()
            begin
                IF "Payment Reference" <> '' THEN
                  TESTFIELD("Creditor No.");
            end;
        }
        field(480;"Dimension Set ID";Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup()
            begin
                ShowDocDim;
            end;
        }
        field(1305;"Invoice Discount Amount";Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Purchase Line"."Inv. Discount Amount" WHERE (Document No.=FIELD(No.),
                                                                            Document Type=FIELD(Document Type)));
            Caption = 'Invoice Discount Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5043;"No. of Archived Versions";Integer)
        {
            CalcFormula = Max("Purchase Header Archive"."Version No." WHERE (Document Type=FIELD(Document Type),
                                                                             No.=FIELD(No.),
                                                                             Doc. No. Occurrence=FIELD(Doc. No. Occurrence)));
            Caption = 'No. of Archived Versions';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5048;"Doc. No. Occurrence";Integer)
        {
            Caption = 'Doc. No. Occurrence';
        }
        field(5050;"Campaign No.";Code[20])
        {
            Caption = 'Campaign No.';
            TableRelation = Campaign;

            trigger OnValidate()
            begin
                InitDefaultDim;
            end;
        }
        field(5052;"Buy-from Contact No.";Code[20])
        {
            Caption = 'Buy-from Contact No.';
            TableRelation = Contact;

            trigger OnLookup()
            var
                Cont: Record "5050";
                ContBusinessRelation: Record "5054";
            begin
                IF "Buy-from Vendor No." <> '' THEN BEGIN
                  IF Cont.GET("Buy-from Contact No.") THEN
                    Cont.SETRANGE("Company No.",Cont."Company No.")
                  ELSE BEGIN
                    ContBusinessRelation.RESET;
                    ContBusinessRelation.SETCURRENTKEY("Link to Table","No.");
                    ContBusinessRelation.SETRANGE("Link to Table",ContBusinessRelation."Link to Table"::Vendor);
                    ContBusinessRelation.SETRANGE("No.","Buy-from Vendor No.");
                    IF ContBusinessRelation.FINDFIRST THEN
                      Cont.SETRANGE("Company No.",ContBusinessRelation."Contact No.")
                    ELSE
                      Cont.SETRANGE("No.",'');
                  END;
                END;

                IF "Buy-from Contact No." <> '' THEN
                  IF Cont.GET("Buy-from Contact No.") THEN ;
                IF PAGE.RUNMODAL(0,Cont) = ACTION::LookupOK THEN BEGIN
                  xRec := Rec;
                  VALIDATE("Buy-from Contact No.",Cont."No.");
                END;
            end;

            trigger OnValidate()
            var
                ContBusinessRelation: Record "5054";
                Cont: Record "5050";
            begin
                TESTFIELD(Status,Status::Open);

                IF ("Buy-from Contact No." <> xRec."Buy-from Contact No.") AND
                   (xRec."Buy-from Contact No." <> '')
                THEN BEGIN
                  IF HideValidationDialog THEN
                    Confirmed := TRUE
                  ELSE
                    Confirmed := CONFIRM(Text004,FALSE,FIELDCAPTION("Buy-from Contact No."));
                  IF Confirmed THEN BEGIN
                    PurchLine.SETRANGE("Document Type","Document Type");
                    PurchLine.SETRANGE("Document No.","No.");
                    IF ("Buy-from Contact No." = '') AND ("Buy-from Vendor No." = '') THEN BEGIN
                      IF NOT PurchLine.ISEMPTY THEN
                        ERROR(
                          Text005,
                          FIELDCAPTION("Buy-from Contact No."));
                      INIT;
                      PurchSetup.GET;
                      InitRecord;
                      "No. Series" := xRec."No. Series";
                      IF xRec."Receiving No." <> '' THEN BEGIN
                        "Receiving No. Series" := xRec."Receiving No. Series";
                        "Receiving No." := xRec."Receiving No.";
                      END;
                      IF xRec."Posting No." <> '' THEN BEGIN
                        "Posting No. Series" := xRec."Posting No. Series";
                        "Posting No." := xRec."Posting No.";
                      END;
                      IF xRec."Return Shipment No." <> '' THEN BEGIN
                        "Return Shipment No. Series" := xRec."Return Shipment No. Series";
                        "Return Shipment No." := xRec."Return Shipment No.";
                      END;
                      IF xRec."Prepayment No." <> '' THEN BEGIN
                        "Prepayment No. Series" := xRec."Prepayment No. Series";
                        "Prepayment No." := xRec."Prepayment No.";
                      END;
                      IF xRec."Prepmt. Cr. Memo No." <> '' THEN BEGIN
                        "Prepmt. Cr. Memo No. Series" := xRec."Prepmt. Cr. Memo No. Series";
                        "Prepmt. Cr. Memo No." := xRec."Prepmt. Cr. Memo No.";
                      END;
                      EXIT;
                    END;
                  END ELSE BEGIN
                    Rec := xRec;
                    EXIT;
                  END;
                END;

                IF ("Buy-from Vendor No." <> '') AND ("Buy-from Contact No." <> '') THEN BEGIN
                  Cont.GET("Buy-from Contact No.");
                  ContBusinessRelation.RESET;
                  ContBusinessRelation.SETCURRENTKEY("Link to Table","No.");
                  ContBusinessRelation.SETRANGE("Link to Table",ContBusinessRelation."Link to Table"::Vendor);
                  ContBusinessRelation.SETRANGE("No.","Buy-from Vendor No.");
                  IF ContBusinessRelation.FINDFIRST THEN
                    IF ContBusinessRelation."Contact No." <> Cont."Company No." THEN
                      ERROR(Text038,Cont."No.",Cont.Name,"Buy-from Vendor No.");
                END;

                UpdateBuyFromVend("Buy-from Contact No.");
            end;
        }
        field(5053;"Pay-to Contact No.";Code[20])
        {
            Caption = 'Pay-to Contact No.';
            TableRelation = Contact;

            trigger OnLookup()
            var
                Cont: Record "5050";
                ContBusinessRelation: Record "5054";
            begin
                IF "Pay-to Vendor No." <> '' THEN BEGIN
                  IF Cont.GET("Pay-to Contact No.") THEN
                    Cont.SETRANGE("Company No.",Cont."Company No.")
                  ELSE BEGIN
                    ContBusinessRelation.RESET;
                    ContBusinessRelation.SETCURRENTKEY("Link to Table","No.");
                    ContBusinessRelation.SETRANGE("Link to Table",ContBusinessRelation."Link to Table"::Vendor);
                    ContBusinessRelation.SETRANGE("No.","Pay-to Vendor No.");
                    IF ContBusinessRelation.FINDFIRST THEN
                      Cont.SETRANGE("Company No.",ContBusinessRelation."Contact No.")
                    ELSE
                      Cont.SETRANGE("No.",'');
                  END;
                END;

                IF "Pay-to Contact No." <> '' THEN
                  IF Cont.GET("Pay-to Contact No.") THEN ;
                IF PAGE.RUNMODAL(0,Cont) = ACTION::LookupOK THEN BEGIN
                  xRec := Rec;
                  VALIDATE("Pay-to Contact No.",Cont."No.");
                END;
            end;

            trigger OnValidate()
            var
                ContBusinessRelation: Record "5054";
                Cont: Record "5050";
            begin
                TESTFIELD(Status,Status::Open);

                IF ("Pay-to Contact No." <> xRec."Pay-to Contact No.") AND
                   (xRec."Pay-to Contact No." <> '')
                THEN BEGIN
                  IF HideValidationDialog THEN
                    Confirmed := TRUE
                  ELSE
                    Confirmed := CONFIRM(Text004,FALSE,FIELDCAPTION("Pay-to Contact No."));
                  IF Confirmed THEN BEGIN
                    PurchLine.SETRANGE("Document Type","Document Type");
                    PurchLine.SETRANGE("Document No.","No.");
                    IF ("Pay-to Contact No." = '') AND ("Pay-to Vendor No." = '') THEN BEGIN
                      IF NOT PurchLine.ISEMPTY THEN
                        ERROR(
                          Text005,
                          FIELDCAPTION("Pay-to Contact No."));
                      INIT;
                      PurchSetup.GET;
                      InitRecord;
                      "No. Series" := xRec."No. Series";
                      IF xRec."Receiving No." <> '' THEN BEGIN
                        "Receiving No. Series" := xRec."Receiving No. Series";
                        "Receiving No." := xRec."Receiving No.";
                      END;
                      IF xRec."Posting No." <> '' THEN BEGIN
                        "Posting No. Series" := xRec."Posting No. Series";
                        "Posting No." := xRec."Posting No.";
                      END;
                      IF xRec."Return Shipment No." <> '' THEN BEGIN
                        "Return Shipment No. Series" := xRec."Return Shipment No. Series";
                        "Return Shipment No." := xRec."Return Shipment No.";
                      END;
                      IF xRec."Prepayment No." <> '' THEN BEGIN
                        "Prepayment No. Series" := xRec."Prepayment No. Series";
                        "Prepayment No." := xRec."Prepayment No.";
                      END;
                      IF xRec."Prepmt. Cr. Memo No." <> '' THEN BEGIN
                        "Prepmt. Cr. Memo No. Series" := xRec."Prepmt. Cr. Memo No. Series";
                        "Prepmt. Cr. Memo No." := xRec."Prepmt. Cr. Memo No.";
                      END;
                      EXIT;
                    END;
                  END ELSE BEGIN
                    "Pay-to Contact No." := xRec."Pay-to Contact No.";
                    EXIT;
                  END;
                END;

                IF ("Pay-to Vendor No." <> '') AND ("Pay-to Contact No." <> '') THEN BEGIN
                  Cont.GET("Pay-to Contact No.");
                  ContBusinessRelation.RESET;
                  ContBusinessRelation.SETCURRENTKEY("Link to Table","No.");
                  ContBusinessRelation.SETRANGE("Link to Table",ContBusinessRelation."Link to Table"::Vendor);
                  ContBusinessRelation.SETRANGE("No.","Pay-to Vendor No.");
                  IF ContBusinessRelation.FINDFIRST THEN
                    IF ContBusinessRelation."Contact No." <> Cont."Company No." THEN
                      ERROR(Text038,Cont."No.",Cont.Name,"Pay-to Vendor No.");
                END;

                UpdatePayToVend("Pay-to Contact No.");
            end;
        }
        field(5700;"Responsibility Center";Code[10])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility Center";

            trigger OnValidate()
            begin
                TESTFIELD(Status,Status::Open);
                IF NOT UserSetupMgt.CheckRespCenter(1,"Responsibility Center") THEN
                  ERROR(
                    Text028,
                    RespCenter.TABLECAPTION,UserSetupMgt.GetPurchasesFilter);

                "Location Code" := UserSetupMgt.GetLocation(1,'',"Responsibility Center");
                IF "Location Code" = '' THEN BEGIN
                  IF InvtSetup.GET THEN
                    "Inbound Whse. Handling Time" := InvtSetup."Inbound Whse. Handling Time";
                END ELSE BEGIN
                  IF Location.GET("Location Code") THEN;
                  "Inbound Whse. Handling Time" := Location."Inbound Whse. Handling Time";
                END;

                UpdateShipToAddress;

                InitDefaultDim;

                IF xRec."Responsibility Center" <> "Responsibility Center" THEN BEGIN
                  RecreatePurchLines(FIELDCAPTION("Responsibility Center"));
                  "Assigned User ID" := '';
                END;
            end;
        }
        field(5752;"Completely Received";Boolean)
        {
            CalcFormula = Min("Purchase Line"."Completely Received" WHERE (Document Type=FIELD(Document Type),
                                                                           Document No.=FIELD(No.),
                                                                           Type=FILTER(<>' '),
                                                                           Location Code=FIELD(Location Filter)));
            Caption = 'Completely Received';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5753;"Posting from Whse. Ref.";Integer)
        {
            Caption = 'Posting from Whse. Ref.';
        }
        field(5754;"Location Filter";Code[10])
        {
            Caption = 'Location Filter';
            FieldClass = FlowFilter;
            TableRelation = Location;
        }
        field(5790;"Requested Receipt Date";Date)
        {
            Caption = 'Requested Receipt Date';

            trigger OnValidate()
            begin
                TESTFIELD(Status,Status::Open);
                IF "Promised Receipt Date" <> 0D THEN
                  ERROR(
                    Text034,
                    FIELDCAPTION("Requested Receipt Date"),
                    FIELDCAPTION("Promised Receipt Date"));

                IF "Requested Receipt Date" <> xRec."Requested Receipt Date" THEN
                  UpdatePurchLines(FIELDCAPTION("Requested Receipt Date"));
            end;
        }
        field(5791;"Promised Receipt Date";Date)
        {
            Caption = 'Promised Receipt Date';

            trigger OnValidate()
            begin
                TESTFIELD(Status,Status::Open);
                IF "Promised Receipt Date" <> xRec."Promised Receipt Date" THEN
                  UpdatePurchLines(FIELDCAPTION("Promised Receipt Date"));
            end;
        }
        field(5792;"Lead Time Calculation";DateFormula)
        {
            Caption = 'Lead Time Calculation';

            trigger OnValidate()
            begin
                TESTFIELD(Status,Status::Open);
                IF "Lead Time Calculation" <> xRec."Lead Time Calculation" THEN
                  UpdatePurchLines(FIELDCAPTION("Lead Time Calculation"));
            end;
        }
        field(5793;"Inbound Whse. Handling Time";DateFormula)
        {
            Caption = 'Inbound Whse. Handling Time';

            trigger OnValidate()
            begin
                TESTFIELD(Status,Status::Open);
                IF "Inbound Whse. Handling Time" <> xRec."Inbound Whse. Handling Time" THEN
                  UpdatePurchLines(FIELDCAPTION("Inbound Whse. Handling Time"));
            end;
        }
        field(5796;"Date Filter";Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(5800;"Vendor Authorization No.";Code[35])
        {
            Caption = 'Vendor Authorization No.';
        }
        field(5801;"Return Shipment No.";Code[20])
        {
            Caption = 'Return Shipment No.';
        }
        field(5802;"Return Shipment No. Series";Code[10])
        {
            Caption = 'Return Shipment No. Series';
            TableRelation = "No. Series";

            trigger OnLookup()
            begin
                WITH PurchHeader DO BEGIN
                  PurchHeader := Rec;
                  PurchSetup.GET;
                  PurchSetup.TESTFIELD("Posted Return Shpt. Nos.");
                  IF NoSeriesMgt.LookupSeries(PurchSetup."Posted Return Shpt. Nos.","Return Shipment No. Series") THEN
                    VALIDATE("Return Shipment No. Series");
                  Rec := PurchHeader;
                END;
            end;

            trigger OnValidate()
            begin
                IF "Return Shipment No. Series" <> '' THEN BEGIN
                  PurchSetup.GET;
                  PurchSetup.TESTFIELD("Posted Return Shpt. Nos.");
                  NoSeriesMgt.TestSeries(PurchSetup."Posted Return Shpt. Nos.","Return Shipment No. Series");
                END;
                TESTFIELD("Return Shipment No.",'');
            end;
        }
        field(5803;Ship;Boolean)
        {
            Caption = 'Ship';
        }
        field(5804;"Last Return Shipment No.";Code[20])
        {
            Caption = 'Last Return Shipment No.';
            Editable = false;
            TableRelation = "Return Shipment Header";
        }
        field(9000;"Assigned User ID";Code[50])
        {
            Caption = 'Assigned User ID';
            TableRelation = "User Setup";

            trigger OnValidate()
            begin
                IF NOT UserSetupMgt.CheckRespCenter2(1,"Responsibility Center","Assigned User ID") THEN
                  ERROR(
                    Text049,"Assigned User ID",
                    RespCenter.TABLECAPTION,UserSetupMgt.GetPurchasesFilter2("Assigned User ID"));
            end;
        }
        field(50001;"Printing Version";Code[20])
        {
        }
        field(51612;_Adjustment;Boolean)
        {
            Caption = 'Adjustment';
            Editable = false;
        }
        field(51613;"_BAS Adjustment";Boolean)
        {
            Caption = 'BAS Adjustment';
            Editable = false;
        }
        field(51614;"_Adjustment Applies-to";Code[20])
        {
            Caption = 'Adjustment Applies-to';
        }
        field(51620;_ABN;Text[14])
        {
            Caption = 'ABN';
            Editable = false;
            Numeric = true;
        }
        field(51622;"_ABN Division Part No.";Text[3])
        {
            Caption = 'ABN Division Part No.';
        }
        field(58040;"_WHT Business Posting Group";Code[10])
        {
            Caption = 'WHT Business Posting Group';
        }
        field(58044;"_Actual Vendor No.";Code[20])
        {
            Caption = 'Actual Vendor No.';
            TableRelation = Vendor;
        }
        field(58070;"_Printed Tax Document";Boolean)
        {
            Caption = 'Printed Tax Document';
            Editable = false;
        }
        field(58071;"_Posted Tax Document";Boolean)
        {
            Caption = 'Posted Tax Document';
            Editable = false;
        }
        field(58072;"_Tax Document Posting Date";Date)
        {
            Caption = 'Tax Document Posting Date';
            Editable = false;
        }
        field(58087;"_Vendor Exchange Rate (ACY)";Decimal)
        {
            Caption = 'Vendor Exchange Rate (ACY)';
            DecimalPlaces = 0:15;
        }
    }

    keys
    {
        key(Key1;"Document Type","No.")
        {
        }
        key(Key2;"No.","Document Type")
        {
        }
        key(Key3;"Document Type","Buy-from Vendor No.")
        {
        }
        key(Key4;"Document Type","Pay-to Vendor No.")
        {
        }
        key(Key5;"Buy-from Vendor No.")
        {
        }
        key(Key6;"Incoming Document Entry No.")
        {
        }
        key(Key7;"Buy-from Vendor No.","Vendor Authorization No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        IF NOT UserSetupMgt.CheckRespCenter(1,"Responsibility Center") THEN
          ERROR(
            Text023,
            RespCenter.TABLECAPTION,UserSetupMgt.GetPurchasesFilter);

        PurchPost.DeleteHeader(
          Rec,PurchRcptHeader,PurchInvHeader,PurchCrMemoHeader,
          ReturnShptHeader,PurchInvHeaderPrepmt,PurchCrMemoHeaderPrepmt);
        VALIDATE("Applies-to ID",'');

        ApprovalMgt.DeleteApprovalEntry(DATABASE::"Purchase Header","Document Type","No.");
        PurchLine.LOCKTABLE;

        WhseRequest.SETRANGE("Source Type",DATABASE::"Purchase Line");
        WhseRequest.SETRANGE("Source Subtype","Document Type");
        WhseRequest.SETRANGE("Source No.","No.");
        WhseRequest.DELETEALL(TRUE);

        PurchLine.SETRANGE("Document Type","Document Type");
        PurchLine.SETRANGE("Document No.","No.");
        PurchLine.SETRANGE(Type,PurchLine.Type::"Charge (Item)");
        DeletePurchaseLines;
        PurchLine.SETRANGE(Type);
        DeletePurchaseLines;

        PurchCommentLine.SETRANGE("Document Type","Document Type");
        PurchCommentLine.SETRANGE("No.","No.");
        PurchCommentLine.DELETEALL;

        IF (PurchRcptHeader."No." <> '') OR
           (PurchInvHeader."No." <> '') OR
           (PurchCrMemoHeader."No." <> '') OR
           (ReturnShptHeader."No." <> '') OR
           (PurchInvHeaderPrepmt."No." <> '') OR
           (PurchCrMemoHeaderPrepmt."No." <> '')
        THEN BEGIN
          COMMIT;

          IF PurchRcptHeader."No." <> '' THEN
            IF CONFIRM(
                 Text000,TRUE,
                 PurchRcptHeader."No.")
            THEN BEGIN
              PurchRcptHeader.SETRECFILTER;
              PurchRcptHeader.PrintRecords(TRUE);
            END;

          IF PurchInvHeader."No." <> '' THEN
            IF CONFIRM(
                 Text001,TRUE,
                 PurchInvHeader."No.")
            THEN BEGIN
              PurchInvHeader.SETRECFILTER;
              PurchInvHeader.PrintRecords(TRUE);
            END;

          IF PurchCrMemoHeader."No." <> '' THEN
            IF CONFIRM(
                 Text002,TRUE,
                 PurchCrMemoHeader."No.")
            THEN BEGIN
              PurchCrMemoHeader.SETRECFILTER;
              PurchCrMemoHeader.PrintRecords(TRUE);
            END;

          IF ReturnShptHeader."No." <> '' THEN
            IF CONFIRM(
                 Text024,TRUE,
                 ReturnShptHeader."No.")
            THEN BEGIN
              ReturnShptHeader.SETRECFILTER;
              ReturnShptHeader.PrintRecords(TRUE);
            END;

          IF PurchInvHeaderPrepmt."No." <> '' THEN
            IF CONFIRM(
                 Text043,TRUE,
                 PurchInvHeader."No.")
            THEN BEGIN
              PurchInvHeaderPrepmt.SETRECFILTER;
              PurchInvHeaderPrepmt.PrintRecords(TRUE);
            END;

          IF PurchCrMemoHeaderPrepmt."No." <> '' THEN
            IF CONFIRM(
                 Text044,TRUE,
                 PurchCrMemoHeaderPrepmt."No.")
            THEN BEGIN
              PurchCrMemoHeaderPrepmt.SETRECFILTER;
              PurchCrMemoHeaderPrepmt.PrintRecords(TRUE);
            END;
        END;
    end;

    trigger OnInsert()
    begin
        IF "No." = '' THEN BEGIN
          TestNoSeries;
          NoSeriesMgt.InitSeries(GetNoSeriesCode,xRec."No. Series","Posting Date","No.","No. Series");
        END;

        InitRecord;

        IF GETFILTER("Buy-from Vendor No.") <> '' THEN
          IF GETRANGEMIN("Buy-from Vendor No.") = GETRANGEMAX("Buy-from Vendor No.") THEN
            VALIDATE("Buy-from Vendor No.",GETRANGEMIN("Buy-from Vendor No."));

        "Doc. No. Occurrence" := ArchiveManagement.GetNextOccurrenceNo(DATABASE::"Purchase Header","Document Type","No.");
    end;

    trigger OnRename()
    begin
        ERROR(Text003,TABLECAPTION);
    end;

    var
        Text000: Label 'Do you want to print receipt %1?';
        Text001: Label 'Do you want to print invoice %1?';
        Text002: Label 'Do you want to print credit memo %1?';
        Text003: Label 'You cannot rename a %1.';
        Text004: Label 'Do you want to change %1?';
        Text005: Label 'You cannot reset %1 because the document still has one or more lines.';
        Text006: Label 'You cannot change %1 because the order is associated with one or more sales orders.';
        Text007: Label '%1 is greater than %2 in the %3 table.\';
        Text008: Label 'Confirm change?';
        Text009: Label 'Deleting this document will cause a gap in the number series for receipts. ';
        Text010: Label 'An empty receipt %1 will be created to fill this gap in the number series.\\';
        Text011: Label 'Do you want to continue?';
        Text012: Label 'Deleting this document will cause a gap in the number series for posted invoices. ';
        Text013: Label 'An empty posted invoice %1 will be created to fill this gap in the number series.\\';
        Text014: Label 'Deleting this document will cause a gap in the number series for posted credit memos. ';
        Text015: Label 'An empty posted credit memo %1 will be created to fill this gap in the number series.\\';
        Text016: Label 'If you change %1, the existing purchase lines will be deleted and new purchase lines based on the new information in the header will be created.\\';
        Text018: Label 'You must delete the existing purchase lines before you can change %1.';
        Text019: Label 'You have changed %1 on the purchase header, but it has not been changed on the existing purchase lines.\';
        Text020: Label 'You must update the existing purchase lines manually.';
        Text021: Label 'The change may affect the exchange rate used on the price calculation of the purchase lines.';
        Text022: Label 'Do you want to update the exchange rate?';
        Text023: Label 'You cannot delete this document. Your identification is set up to process from %1 %2 only.';
        Text024: Label 'Do you want to print return shipment %1?';
        Text025: Label 'You have modified the %1 field. Note that the recalculation of VAT may cause penny differences, so you must check the amounts afterwards. ';
        Text027: Label 'Do you want to update the %2 field on the lines to reflect the new value of %1?';
        Text028: Label 'Your identification is set up to process from %1 %2 only.';
        Text029: Label 'Deleting this document will cause a gap in the number series for return shipments. ';
        Text030: Label 'An empty return shipment %1 will be created to fill this gap in the number series.\\';
        Text032: Label 'You have modified %1.\\';
        Text033: Label 'Do you want to update the lines?';
        PurchSetup: Record "312";
        GLSetup: Record "98";
        GLAcc: Record "15";
        PurchLine: Record "39";
        xPurchLine: Record "39";
        VendLedgEntry: Record "25";
        Vend: Record "23";
        PaymentTerms: Record "3";
        PaymentMethod: Record "289";
        CurrExchRate: Record "330";
        PurchHeader: Record "38";
        PurchCommentLine: Record "43";
        ShipToAddr: Record "222";
        Cust: Record "18";
        CompanyInfo: Record "79";
        PostCode: Record "225";
        OrderAddr: Record "224";
        BankAcc: Record "270";
        PurchRcptHeader: Record "120";
        PurchInvHeader: Record "122";
        PurchCrMemoHeader: Record "124";
        ReturnShptHeader: Record "6650";
        PurchInvHeaderPrepmt: Record "122";
        PurchCrMemoHeaderPrepmt: Record "124";
        GenBusPostingGrp: Record "250";
        GenJnILine: Record "81";
        RespCenter: Record "5714";
        Location: Record "14";
        WhseRequest: Record "5765";
        InvtSetup: Record "313";
        NoSeriesMgt: Codeunit "396";
        TransferExtendedText: Codeunit "378";
        GenJnlApply: Codeunit "225";
        PurchPost: Codeunit "90";
        VendEntrySetApplID: Codeunit "111";
        DimMgt: Codeunit "408";
        ApprovalMgt: Codeunit "439";
        UserSetupMgt: Codeunit "5700";
        ArchiveManagement: Codeunit "5063";
        ReservePurchLine: Codeunit "99000834";
        ApplyVendEntries: Page "233";
        CurrencyDate: Date;
        HideValidationDialog: Boolean;
        Confirmed: Boolean;
        Text034: Label 'You cannot change the %1 when the %2 has been filled in.';
        Text037: Label 'Contact %1 %2 is not related to vendor %3.';
        Text038: Label 'Contact %1 %2 is related to a different company than vendor %3.';
        Text039: Label 'Contact %1 %2 is not related to a vendor.';
        SkipBuyFromContact: Boolean;
        SkipPayToContact: Boolean;
        Text040: Label 'You can not change the %1 field because %2 %3 has %4 = %5 and the %6 has already been assigned %7 %8.';
        Text041: Label 'The purchase %1 %2 has item tracking. Do you want to delete it anyway?';
        Text042: Label 'You must cancel the approval process if you wish to change the %1.';
        Text043: Label 'Do you want to print prepayment invoice %1?';
        Text044: Label 'Do you want to print prepayment credit memo %1?';
        Text045: Label 'Deleting this document will cause a gap in the number series for prepayment invoices. An empty prepayment invoice %1 will be created to fill this gap in the number series.\\Do you want to continue?';
        Text046: Label 'Deleting this document will cause a gap in the number series for prepayment credit memos. An empty prepayment credit memo %1 will be created to fill this gap in the number series.\\Do you want to continue?';
        Text049: Label '%1 is set up to process from %2 %3 only.';
        Text050: Label 'Reservations exist for this order. These reservations will be canceled if a date conflict is caused by this change.\\';
        Text051: Label 'You may have changed a dimension.\\Do you want to update the lines?';
        Text052: Label 'The %1 field on the purchase order %2 must be the same as on sales order %3.';
        NameAddressDetails: Text[512];
        DropShptNameAddressDetails: Text[512];
        SpecOrderNameAddressDetails: Text[512];
        UpdateDocumentDate: Boolean;
        Text053: Label 'There are unposted prepayment amounts on the document of type %1 with the number %2.';
        Text054: Label 'There are unpaid prepayment invoices that are related to the document of type %1 with the number %2.';
        ChangeCurrencyQst: Label 'If you change %1, the existing purchase lines will be deleted and new purchase lines based on the new information in the header will be created. You may need to update the price information manually.\\Do you want to change %1?';

    procedure InitRecord()
    begin
        PurchSetup.GET;

        CASE "Document Type" OF
          "Document Type"::Quote,"Document Type"::Order:
            BEGIN
              NoSeriesMgt.SetDefaultSeries("Posting No. Series",PurchSetup."Posted Invoice Nos.");
              NoSeriesMgt.SetDefaultSeries("Receiving No. Series",PurchSetup."Posted Receipt Nos.");
              IF "Document Type" = "Document Type"::Order THEN BEGIN
                NoSeriesMgt.SetDefaultSeries("Prepayment No. Series",PurchSetup."Posted Prepmt. Inv. Nos.");
                NoSeriesMgt.SetDefaultSeries("Prepmt. Cr. Memo No. Series",PurchSetup."Posted Prepmt. Cr. Memo Nos.");
              END;
            END;
          "Document Type"::Invoice:
            BEGIN
              IF ("No. Series" <> '') AND
                 (PurchSetup."Invoice Nos." = PurchSetup."Posted Invoice Nos.")
              THEN
                "Posting No. Series" := "No. Series"
              ELSE
                NoSeriesMgt.SetDefaultSeries("Posting No. Series",PurchSetup."Posted Invoice Nos.");
              IF PurchSetup."Receipt on Invoice" THEN
                NoSeriesMgt.SetDefaultSeries("Receiving No. Series",PurchSetup."Posted Receipt Nos.");
            END;
          "Document Type"::"Return Order":
            BEGIN
              NoSeriesMgt.SetDefaultSeries("Posting No. Series",PurchSetup."Posted Credit Memo Nos.");
              NoSeriesMgt.SetDefaultSeries("Return Shipment No. Series",PurchSetup."Posted Return Shpt. Nos.");
            END;
          "Document Type"::"Credit Memo":
            BEGIN
              IF ("No. Series" <> '') AND
                 (PurchSetup."Credit Memo Nos." = PurchSetup."Posted Credit Memo Nos.")
              THEN
                "Posting No. Series" := "No. Series"
              ELSE
                NoSeriesMgt.SetDefaultSeries("Posting No. Series",PurchSetup."Posted Credit Memo Nos.");
              IF PurchSetup."Return Shipment on Credit Memo" THEN
                NoSeriesMgt.SetDefaultSeries("Return Shipment No. Series",PurchSetup."Posted Return Shpt. Nos.");
            END;
        END;

        IF "Document Type" IN ["Document Type"::Order,"Document Type"::Invoice,"Document Type"::"Return Order"] THEN
          "Order Date" := WORKDATE;

        IF "Document Type" = "Document Type"::Invoice THEN
          "Expected Receipt Date" := WORKDATE;

        IF NOT ("Document Type" IN ["Document Type"::"Blanket Order","Document Type"::Quote]) AND
           ("Posting Date" = 0D)
        THEN
          "Posting Date" := WORKDATE;

        IF PurchSetup."Default Posting Date" = PurchSetup."Default Posting Date"::"No Date" THEN
          "Posting Date" := 0D;

        "Document Date" := WORKDATE;

        VALIDATE("Sell-to Customer No.",'');

        IF "Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"] THEN BEGIN
          GLSetup.GET;
          Correction := GLSetup."Mark Cr. Memos as Corrections";
        END;

        "Posting Description" := FORMAT("Document Type") + ' ' + "No.";

        IF InvtSetup.GET THEN
          "Inbound Whse. Handling Time" := InvtSetup."Inbound Whse. Handling Time";

        "Responsibility Center" := UserSetupMgt.GetRespCenter(1,"Responsibility Center");
    end;

    procedure AssistEdit(OldPurchHeader: Record "38"): Boolean
    var
        NoSeries: Code[10];
    begin
        PurchSetup.GET;
        TestNoSeries;
        NoSeries := "No. Series";
        IF NoSeriesMgt.SelectSeries(GetNoSeriesCode,OldPurchHeader."No. Series","No. Series") AND
           (NoSeries <> "No. Series")
        THEN BEGIN
          PurchSetup.GET;
          TestNoSeries;
          NoSeriesMgt.SetSeries("No.");
          EXIT(TRUE);
        END;
    end;

    local procedure TestNoSeries(): Boolean
    begin
        PurchSetup.GET;
        CASE "Document Type" OF
          "Document Type"::Quote:
            PurchSetup.TESTFIELD("Quote Nos.");
          "Document Type"::Order:
            PurchSetup.TESTFIELD("Order Nos.");
          "Document Type"::Invoice:
            BEGIN
              PurchSetup.TESTFIELD("Invoice Nos.");
              PurchSetup.TESTFIELD("Posted Invoice Nos.");
            END;
          "Document Type"::"Return Order":
            PurchSetup.TESTFIELD("Return Order Nos.");
          "Document Type"::"Credit Memo":
            BEGIN
              PurchSetup.TESTFIELD("Credit Memo Nos.");
              PurchSetup.TESTFIELD("Posted Credit Memo Nos.");
            END;
          "Document Type"::"Blanket Order":
            PurchSetup.TESTFIELD("Blanket Order Nos.");
        END;
    end;

    local procedure GetNoSeriesCode(): Code[10]
    begin
        CASE "Document Type" OF
          "Document Type"::Quote:
            EXIT(PurchSetup."Quote Nos.");
          "Document Type"::Order:
            EXIT(PurchSetup."Order Nos.");
          "Document Type"::Invoice:
            EXIT(PurchSetup."Invoice Nos.");
          "Document Type"::"Return Order":
            EXIT(PurchSetup."Return Order Nos.");
          "Document Type"::"Credit Memo":
            EXIT(PurchSetup."Credit Memo Nos.");
          "Document Type"::"Blanket Order":
            EXIT(PurchSetup."Blanket Order Nos.");
        END;
    end;

    local procedure GetPostingNoSeriesCode(): Code[10]
    begin
        IF "Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"] THEN
          EXIT(PurchSetup."Posted Credit Memo Nos.");
        EXIT(PurchSetup."Posted Invoice Nos.");
    end;

    local procedure GetPostingPrepaymentNoSeriesCode(): Code[10]
    begin
        IF "Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"] THEN
          EXIT(PurchSetup."Posted Prepmt. Cr. Memo Nos.");
        EXIT(PurchSetup."Posted Prepmt. Inv. Nos.");
    end;

    local procedure TestNoSeriesDate(No: Code[20];NoSeriesCode: Code[10];NoCapt: Text[1024];NoSeriesCapt: Text[1024])
    var
        NoSeries: Record "308";
    begin
        IF (No <> '') AND (NoSeriesCode <> '') THEN BEGIN
          NoSeries.GET(NoSeriesCode);
          IF NoSeries."Date Order" THEN
            ERROR(
              Text040,
              FIELDCAPTION("Posting Date"),NoSeriesCapt,NoSeriesCode,
              NoSeries.FIELDCAPTION("Date Order"),NoSeries."Date Order","Document Type",
              NoCapt,No);
        END;
    end;

    procedure ConfirmDeletion(): Boolean
    begin
        PurchPost.TestDeleteHeader(
          Rec,PurchRcptHeader,PurchInvHeader,PurchCrMemoHeader,
          ReturnShptHeader,PurchInvHeaderPrepmt,PurchCrMemoHeaderPrepmt);
        IF PurchRcptHeader."No." <> '' THEN
          IF NOT CONFIRM(
               Text009 +
               Text010 +
               Text011,TRUE,
               PurchRcptHeader."No.")
          THEN
            EXIT;
        IF PurchInvHeader."No." <> '' THEN
          IF NOT CONFIRM(
               Text012 +
               Text013 +
               Text011,TRUE,
               PurchInvHeader."No.")
          THEN
            EXIT;
        IF PurchCrMemoHeader."No." <> '' THEN
          IF NOT CONFIRM(
               Text014 +
               Text015 +
               Text011,TRUE,
               PurchCrMemoHeader."No.")
          THEN
            EXIT;
        IF ReturnShptHeader."No." <> '' THEN
          IF NOT CONFIRM(
               Text029 +
               Text030 +
               Text011,TRUE,
               ReturnShptHeader."No.")
          THEN
            EXIT;
        IF "Prepayment No." <> '' THEN
          IF NOT CONFIRM(
               Text045,TRUE,
               PurchInvHeaderPrepmt."No.")
          THEN
            EXIT;
        IF "Prepmt. Cr. Memo No." <> '' THEN
          IF NOT CONFIRM(
               Text046,TRUE,
               PurchCrMemoHeaderPrepmt."No.")
          THEN
            EXIT;
        EXIT(TRUE);
    end;

    local procedure GetVend(VendNo: Code[20])
    begin
        IF VendNo <> Vend."No." THEN
          Vend.GET(VendNo);
    end;

    procedure PurchLinesExist(): Boolean
    begin
        PurchLine.RESET;
        PurchLine.SETRANGE("Document Type","Document Type");
        PurchLine.SETRANGE("Document No.","No.");
        EXIT(PurchLine.FINDFIRST);
    end;

    procedure RecreatePurchLines(ChangedFieldName: Text[100])
    var
        PurchLineTmp: Record "39" temporary;
        ItemChargeAssgntPurch: Record "5805";
        TempItemChargeAssgntPurch: Record "5805" temporary;
        TempInteger: Record "2000000026" temporary;
        SalesHeader: Record "36";
        SalesLine: Record "37";
        CopyDocMgt: Codeunit "6620";
        ExtendedTextAdded: Boolean;
    begin
        IF PurchLinesExist THEN BEGIN
          IF HideValidationDialog THEN
            Confirmed := TRUE
          ELSE
            Confirmed :=
              CONFIRM(
                Text016 +
                Text004,FALSE,ChangedFieldName);
          IF Confirmed THEN BEGIN
            PurchLine.LOCKTABLE;
            ItemChargeAssgntPurch.LOCKTABLE;
            MODIFY;

            PurchLine.RESET;
            PurchLine.SETRANGE("Document Type","Document Type");
            PurchLine.SETRANGE("Document No.","No.");
            IF PurchLine.FINDSET THEN BEGIN
              REPEAT
                PurchLine.TESTFIELD("Quantity Received",0);
                PurchLine.TESTFIELD("Quantity Invoiced",0);
                PurchLine.TESTFIELD("Return Qty. Shipped",0);
                PurchLine.CALCFIELDS("Reserved Qty. (Base)");
                PurchLine.TESTFIELD("Reserved Qty. (Base)",0);
                PurchLine.TESTFIELD("Receipt No.",'');
                PurchLine.TESTFIELD("Return Shipment No.",'');
                PurchLine.TESTFIELD("Blanket Order No.",'');
                IF PurchLine."Drop Shipment" OR PurchLine."Special Order" THEN BEGIN
                  CASE TRUE OF
                    PurchLine."Drop Shipment":
                      SalesHeader.GET(SalesHeader."Document Type"::Order,PurchLine."Sales Order No.");
                    PurchLine."Special Order":
                      SalesHeader.GET(SalesHeader."Document Type"::Order,PurchLine."Special Order Sales No.");
                  END;
                  TESTFIELD("Sell-to Customer No.",SalesHeader."Sell-to Customer No.");
                  TESTFIELD("Ship-to Code",SalesHeader."Ship-to Code");
                END;

                PurchLine.TESTFIELD("Prepmt. Amt. Inv.",0);
                PurchLineTmp := PurchLine;
                IF PurchLine.Nonstock THEN BEGIN
                  PurchLine.Nonstock := FALSE;
                  PurchLine.MODIFY;
                END;
                PurchLineTmp.INSERT;
              UNTIL PurchLine.NEXT = 0;

              ItemChargeAssgntPurch.SETRANGE("Document Type","Document Type");
              ItemChargeAssgntPurch.SETRANGE("Document No.","No.");
              IF ItemChargeAssgntPurch.FINDSET THEN BEGIN
                REPEAT
                  TempItemChargeAssgntPurch.INIT;
                  TempItemChargeAssgntPurch := ItemChargeAssgntPurch;
                  TempItemChargeAssgntPurch.INSERT;
                UNTIL ItemChargeAssgntPurch.NEXT = 0;
                ItemChargeAssgntPurch.DELETEALL;
              END;

              PurchLine.DELETEALL(TRUE);

              PurchLine.INIT;
              PurchLine."Line No." := 0;
              PurchLineTmp.FINDSET;
              ExtendedTextAdded := FALSE;
              REPEAT
                IF PurchLineTmp."Attached to Line No." = 0 THEN BEGIN
                  PurchLine.INIT;
                  PurchLine."Line No." := PurchLine."Line No." + 10000;
                  PurchLine.VALIDATE(Type,PurchLineTmp.Type);
                  IF PurchLineTmp."No." = '' THEN BEGIN
                    PurchLine.VALIDATE(Description,PurchLineTmp.Description);
                    PurchLine.VALIDATE("Description 2",PurchLineTmp."Description 2");
                    PurchLine.INSERT;
                  END ELSE BEGIN
                    PurchLine.VALIDATE("No.",PurchLineTmp."No.");
                    IF PurchLine.Type <> PurchLine.Type::" " THEN
                      CASE TRUE OF
                        PurchLineTmp."Drop Shipment":
                          BEGIN
                            SalesLine.GET(SalesLine."Document Type"::Order,
                              PurchLineTmp."Sales Order No.",
                              PurchLineTmp."Sales Order Line No.");
                            CopyDocMgt.TransfldsFromSalesToPurchLine(SalesLine,PurchLine);
                            PurchLine."Drop Shipment" := PurchLineTmp."Drop Shipment";
                            PurchLine."Purchasing Code" := SalesLine."Purchasing Code";
                            PurchLine."Sales Order No." := PurchLineTmp."Sales Order No.";
                            PurchLine."Sales Order Line No." := PurchLineTmp."Sales Order Line No.";
                            EVALUATE(PurchLine."Inbound Whse. Handling Time",'<0D>');
                            PurchLine.VALIDATE("Inbound Whse. Handling Time");
                            PurchLine.INSERT;

                            SalesLine.VALIDATE("Unit Cost (LCY)",PurchLine."Unit Cost (LCY)");
                            SalesLine."Purchase Order No." := PurchLine."Document No.";
                            SalesLine."Purch. Order Line No." := PurchLine."Line No.";
                            SalesLine.MODIFY;
                          END;
                        PurchLineTmp."Special Order":
                          BEGIN
                            SalesLine.GET(SalesLine."Document Type"::Order,
                              PurchLineTmp."Special Order Sales No.",
                              PurchLineTmp."Special Order Sales Line No.");
                            CopyDocMgt.TransfldsFromSalesToPurchLine(SalesLine,PurchLine);
                            PurchLine."Special Order" := PurchLineTmp."Special Order";
                            PurchLine."Purchasing Code" := SalesLine."Purchasing Code";
                            PurchLine."Special Order Sales No." := PurchLineTmp."Special Order Sales No.";
                            PurchLine."Special Order Sales Line No." := PurchLineTmp."Special Order Sales Line No.";
                            PurchLine.INSERT;

                            SalesLine.VALIDATE("Unit Cost (LCY)",PurchLine."Unit Cost (LCY)");
                            SalesLine."Special Order Purchase No." := PurchLine."Document No.";
                            SalesLine."Special Order Purch. Line No." := PurchLine."Line No.";
                            SalesLine.MODIFY;
                          END;
                        ELSE BEGIN
                          PurchLine.VALIDATE("Unit of Measure Code",PurchLineTmp."Unit of Measure Code");
                          PurchLine.VALIDATE("Variant Code",PurchLineTmp."Variant Code");
                          PurchLine."Prod. Order No." := PurchLineTmp."Prod. Order No.";
                          IF PurchLine."Prod. Order No." <> '' THEN BEGIN
                            PurchLine.Description := PurchLineTmp.Description;
                            PurchLine.VALIDATE("VAT Prod. Posting Group",PurchLineTmp."VAT Prod. Posting Group");
                            PurchLine.VALIDATE("Gen. Prod. Posting Group",PurchLineTmp."Gen. Prod. Posting Group");
                            PurchLine.VALIDATE("Expected Receipt Date",PurchLineTmp."Expected Receipt Date");
                            PurchLine.VALIDATE("Requested Receipt Date",PurchLineTmp."Requested Receipt Date");
                            PurchLine.VALIDATE("Qty. per Unit of Measure",PurchLineTmp."Qty. per Unit of Measure");
                          END;
                          IF (PurchLineTmp."Job No." <> '') AND (PurchLineTmp."Job Task No." <> '') THEN BEGIN
                            PurchLine.VALIDATE("Job No.",PurchLineTmp."Job No.");
                            PurchLine.VALIDATE("Job Task No.",PurchLineTmp."Job Task No.");
                            PurchLine."Job Line Type" := PurchLineTmp."Job Line Type";
                          END;
                          IF PurchLineTmp.Quantity <> 0 THEN
                            PurchLine.VALIDATE(Quantity,PurchLineTmp.Quantity);
                          IF "Currency Code" = xRec."Currency Code" THEN
                            PurchLine.VALIDATE("Direct Unit Cost",PurchLineTmp."Direct Unit Cost");
                          PurchLine."Routing No." := PurchLineTmp."Routing No.";
                          PurchLine."Routing Reference No." := PurchLineTmp."Routing Reference No.";
                          PurchLine."Operation No." := PurchLineTmp."Operation No.";
                          PurchLine."Work Center No." := PurchLineTmp."Work Center No.";
                          PurchLine."Prod. Order Line No." := PurchLineTmp."Prod. Order Line No.";
                          PurchLine."Overhead Rate" := PurchLineTmp."Overhead Rate";
                          PurchLine.INSERT;
                        END;
                      END;
                  END;
                  ExtendedTextAdded := FALSE;

                  IF PurchLine.Type = PurchLine.Type::Item THEN BEGIN
                    ClearItemAssgntPurchFilter(TempItemChargeAssgntPurch);
                    TempItemChargeAssgntPurch.SETRANGE("Applies-to Doc. Type",PurchLineTmp."Document Type");
                    TempItemChargeAssgntPurch.SETRANGE("Applies-to Doc. No.",PurchLineTmp."Document No.");
                    TempItemChargeAssgntPurch.SETRANGE("Applies-to Doc. Line No.",PurchLineTmp."Line No.");
                    IF TempItemChargeAssgntPurch.FINDSET THEN
                      REPEAT
                        IF NOT TempItemChargeAssgntPurch.MARK THEN BEGIN
                          TempItemChargeAssgntPurch."Applies-to Doc. Line No." := PurchLine."Line No.";
                          TempItemChargeAssgntPurch.Description := PurchLine.Description;
                          TempItemChargeAssgntPurch.MODIFY;
                          TempItemChargeAssgntPurch.MARK(TRUE);
                        END;
                      UNTIL TempItemChargeAssgntPurch.NEXT = 0;
                  END;
                  IF PurchLine.Type = PurchLine.Type::"Charge (Item)" THEN BEGIN
                    TempInteger.INIT;
                    TempInteger.Number := PurchLine."Line No.";
                    TempInteger.INSERT;
                  END;
                END ELSE
                  IF NOT ExtendedTextAdded THEN BEGIN
                    TransferExtendedText.PurchCheckIfAnyExtText(PurchLine,TRUE);
                    TransferExtendedText.InsertPurchExtText(PurchLine);
                    PurchLine.FINDLAST;
                    ExtendedTextAdded := TRUE;
                  END;
              UNTIL PurchLineTmp.NEXT = 0;

              ClearItemAssgntPurchFilter(TempItemChargeAssgntPurch);
              PurchLineTmp.SETRANGE(Type,PurchLine.Type::"Charge (Item)");
              IF PurchLineTmp.FINDSET THEN
                REPEAT
                  TempItemChargeAssgntPurch.SETRANGE("Document Line No.",PurchLineTmp."Line No.");
                  IF TempItemChargeAssgntPurch.FINDSET THEN BEGIN
                    REPEAT
                      TempInteger.FINDFIRST;
                      ItemChargeAssgntPurch.INIT;
                      ItemChargeAssgntPurch := TempItemChargeAssgntPurch;
                      ItemChargeAssgntPurch."Document Line No." := TempInteger.Number;
                      ItemChargeAssgntPurch.VALIDATE("Unit Cost",0);
                      ItemChargeAssgntPurch.INSERT;
                    UNTIL TempItemChargeAssgntPurch.NEXT = 0;
                    TempInteger.DELETE;
                  END;
                UNTIL PurchLineTmp.NEXT = 0;

              PurchLineTmp.SETRANGE(Type);
              PurchLineTmp.DELETEALL;
              ClearItemAssgntPurchFilter(TempItemChargeAssgntPurch);
              TempItemChargeAssgntPurch.DELETEALL;
            END;
          END ELSE
            ERROR(
              Text018,ChangedFieldName);
        END;
    end;

    procedure MessageIfPurchLinesExist(ChangedFieldName: Text[100])
    begin
        IF PurchLinesExist AND NOT HideValidationDialog THEN
          MESSAGE(
            Text019 +
            Text020,
            ChangedFieldName);
    end;

    procedure PriceMessageIfPurchLinesExist(ChangedFieldName: Text[100])
    begin
        IF PurchLinesExist AND NOT HideValidationDialog THEN
          MESSAGE(
            Text019 +
            Text021,ChangedFieldName);
    end;

    local procedure UpdateCurrencyFactor()
    begin
        IF "Currency Code" <> '' THEN BEGIN
          IF "Posting Date" <> 0D THEN
            CurrencyDate := "Posting Date"
          ELSE
            CurrencyDate := WORKDATE;

          "Currency Factor" := CurrExchRate.ExchangeRate(CurrencyDate,"Currency Code");
        END ELSE
          "Currency Factor" := 0;
    end;

    local procedure ConfirmUpdateCurrencyFactor()
    begin
        IF HideValidationDialog THEN
          Confirmed := TRUE
        ELSE
          Confirmed := CONFIRM(Text022,FALSE);
        IF Confirmed THEN
          VALIDATE("Currency Factor")
        ELSE
          "Currency Factor" := xRec."Currency Factor";
    end;

    procedure SetHideValidationDialog(NewHideValidationDialog: Boolean)
    begin
        HideValidationDialog := NewHideValidationDialog;
    end;

    procedure UpdatePurchLines(ChangedFieldName: Text[100])
    var
        UpdateConfirmed: Boolean;
    begin
        IF NOT PurchLinesExist THEN
          EXIT;

        IF NOT GUIALLOWED THEN
          UpdateConfirmed := TRUE
        ELSE
          CASE ChangedFieldName OF
            FIELDCAPTION("Expected Receipt Date"):
              BEGIN
                UpdateConfirmed :=
                  CONFIRM(
                    STRSUBSTNO(
                      Text032 +
                      Text033,ChangedFieldName));
                IF UpdateConfirmed THEN
                  ConfirmResvDateConflict;
              END;
            FIELDCAPTION("Requested Receipt Date"):
              BEGIN
                UpdateConfirmed :=
                  CONFIRM(
                    STRSUBSTNO(
                      Text032 +
                      Text033,ChangedFieldName));
                IF UpdateConfirmed THEN
                  ConfirmResvDateConflict;
              END;
            FIELDCAPTION("Promised Receipt Date"):
              BEGIN
                UpdateConfirmed :=
                  CONFIRM(
                    STRSUBSTNO(
                      Text032 +
                      Text033,ChangedFieldName));
                IF UpdateConfirmed THEN
                  ConfirmResvDateConflict;
              END;
            FIELDCAPTION("Lead Time Calculation"):
              BEGIN
                UpdateConfirmed :=
                  CONFIRM(
                    STRSUBSTNO(
                      Text032 +
                      Text033,ChangedFieldName));
                IF UpdateConfirmed THEN
                  ConfirmResvDateConflict;
              END;
            FIELDCAPTION("Inbound Whse. Handling Time"):
              BEGIN
                UpdateConfirmed :=
                  CONFIRM(
                    STRSUBSTNO(
                      Text032 +
                      Text033,ChangedFieldName));
                IF UpdateConfirmed THEN
                  ConfirmResvDateConflict;
              END;
            FIELDCAPTION("Prepayment %"):
              UpdateConfirmed :=
                CONFIRM(
                  STRSUBSTNO(
                    Text032 +
                    Text033,ChangedFieldName));
          END;

        PurchLine.LOCKTABLE;
        MODIFY;

        REPEAT
          xPurchLine := PurchLine;
          CASE ChangedFieldName OF
            FIELDCAPTION("Expected Receipt Date"):
              IF UpdateConfirmed AND (PurchLine."No." <> '') THEN
                PurchLine.VALIDATE("Expected Receipt Date","Expected Receipt Date");
            FIELDCAPTION("Currency Factor"):
              IF PurchLine.Type <> PurchLine.Type::" " THEN
                PurchLine.VALIDATE("Direct Unit Cost");
            FIELDCAPTION("Transaction Type"):
              PurchLine.VALIDATE("Transaction Type","Transaction Type");
            FIELDCAPTION("Transport Method"):
              PurchLine.VALIDATE("Transport Method","Transport Method");
            FIELDCAPTION("Entry Point"):
              PurchLine.VALIDATE("Entry Point","Entry Point");
            FIELDCAPTION(Area):
              PurchLine.VALIDATE(Area,Area);
            FIELDCAPTION("Transaction Specification"):
              PurchLine.VALIDATE("Transaction Specification","Transaction Specification");
            FIELDCAPTION("Requested Receipt Date"):
              IF UpdateConfirmed AND (PurchLine."No." <> '') THEN
                PurchLine.VALIDATE("Requested Receipt Date","Requested Receipt Date");
            FIELDCAPTION("Prepayment %"):
              IF UpdateConfirmed AND (PurchLine."No." <> '') THEN
                PurchLine.VALIDATE("Prepayment %","Prepayment %");
            FIELDCAPTION("Promised Receipt Date"):
              IF UpdateConfirmed AND (PurchLine."No." <> '') THEN
                PurchLine.VALIDATE("Promised Receipt Date","Promised Receipt Date");
            FIELDCAPTION("Lead Time Calculation"):
              IF UpdateConfirmed AND (PurchLine."No." <> '') THEN
                PurchLine.VALIDATE("Lead Time Calculation","Lead Time Calculation");
            FIELDCAPTION("Inbound Whse. Handling Time"):
              IF UpdateConfirmed AND (PurchLine."No." <> '') THEN
                PurchLine.VALIDATE("Inbound Whse. Handling Time","Inbound Whse. Handling Time");
          END;
          PurchLine.MODIFY(TRUE);
          ReservePurchLine.VerifyChange(PurchLine,xPurchLine);
        UNTIL PurchLine.NEXT = 0;
    end;

    procedure ConfirmResvDateConflict()
    var
        ResvEngMgt: Codeunit "99000831";
    begin
        IF ResvEngMgt.ResvExistsForPurchHeader(Rec) THEN
          IF NOT CONFIRM(Text050 + Text011,FALSE) THEN
            ERROR('');
    end;

    procedure CreateDim(Type1: Integer;No1: Code[20];Type2: Integer;No2: Code[20];Type3: Integer;No3: Code[20];Type4: Integer;No4: Code[20])
    var
        SourceCodeSetup: Record "242";
        TableID: array [10] of Integer;
        No: array [10] of Code[20];
        OldDimSetID: Integer;
    begin
        SourceCodeSetup.GET;
        TableID[1] := Type1;
        No[1] := No1;
        TableID[2] := Type2;
        No[2] := No2;
        TableID[3] := Type3;
        No[3] := No3;
        TableID[4] := Type4;
        No[4] := No4;
        "Shortcut Dimension 1 Code" := '';
        "Shortcut Dimension 2 Code" := '';
        OldDimSetID := "Dimension Set ID";
        "Dimension Set ID" :=
          DimMgt.GetDefaultDimID(TableID,No,SourceCodeSetup.Purchases,"Shortcut Dimension 1 Code","Shortcut Dimension 2 Code",0,0);

        IF (OldDimSetID <> "Dimension Set ID") AND PurchLinesExist THEN BEGIN
          MODIFY;
          UpdateAllLineDim("Dimension Set ID",OldDimSetID);
        END;
    end;

    procedure InitDefaultDim()
    begin
        CreateDim(
          DATABASE::Vendor,"Pay-to Vendor No.",
          DATABASE::"Salesperson/Purchaser","Purchaser Code",
          DATABASE::Campaign,"Campaign No.",
          DATABASE::"Responsibility Center","Responsibility Center");
    end;

    procedure ValidateShortcutDimCode(FieldNumber: Integer;var ShortcutDimCode: Code[20])
    var
        OldDimSetID: Integer;
    begin
        OldDimSetID := "Dimension Set ID";
        DimMgt.ValidateShortcutDimValues(FieldNumber,ShortcutDimCode,"Dimension Set ID");
        IF "No." <> '' THEN
          MODIFY;

        IF OldDimSetID <> "Dimension Set ID" THEN BEGIN
          MODIFY;
          IF PurchLinesExist THEN
            UpdateAllLineDim("Dimension Set ID",OldDimSetID);
        END;
    end;

    procedure ReceivedPurchLinesExist(): Boolean
    begin
        PurchLine.RESET;
        PurchLine.SETRANGE("Document Type","Document Type");
        PurchLine.SETRANGE("Document No.","No.");
        PurchLine.SETFILTER("Quantity Received",'<>0');
        EXIT(PurchLine.FINDFIRST);
    end;

    procedure ReturnShipmentExist(): Boolean
    begin
        PurchLine.RESET;
        PurchLine.SETRANGE("Document Type","Document Type");
        PurchLine.SETRANGE("Document No.","No.");
        PurchLine.SETFILTER("Return Qty. Shipped",'<>0');
        EXIT(PurchLine.FINDFIRST);
    end;

    local procedure UpdateShipToAddress()
    begin
        IF "Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"] THEN
          EXIT;

        IF ("Location Code" <> '') AND
           Location.GET("Location Code") AND
           ("Sell-to Customer No." = '')
        THEN BEGIN
          "Ship-to Name" := Location.Name;
          "Ship-to Name 2" := Location."Name 2";
          "Ship-to Address" := Location.Address;
          "Ship-to Address 2" := Location."Address 2";
          "Ship-to City" := Location.City;
          "Ship-to Post Code" := Location."Post Code";
          "Ship-to County" := Location.County;
          "Ship-to Country/Region Code" := Location."Country/Region Code";
          "Ship-to Contact" := Location.Contact;
        END;

        IF ("Location Code" = '') AND
           ("Sell-to Customer No." = '')
        THEN BEGIN
          CompanyInfo.GET;
          "Ship-to Code" := '';
          "Ship-to Name" := CompanyInfo."Ship-to Name";
          "Ship-to Name 2" := CompanyInfo."Ship-to Name 2";
          "Ship-to Address" := CompanyInfo."Ship-to Address";
          "Ship-to Address 2" := CompanyInfo."Ship-to Address 2";
          "Ship-to City" := CompanyInfo."Ship-to City";
          "Ship-to Post Code" := CompanyInfo."Ship-to Post Code";
          "Ship-to County" := CompanyInfo."Ship-to County";
          "Ship-to Country/Region Code" := CompanyInfo."Ship-to Country/Region Code";
          "Ship-to Contact" := CompanyInfo."Ship-to Contact";
        END;
    end;

    local procedure DeletePurchaseLines()
    begin
        IF PurchLine.FINDSET THEN BEGIN
          HandleItemTrackingDeletion;
          REPEAT
            PurchLine.SuspendStatusCheck(TRUE);
            PurchLine.DELETE(TRUE);
          UNTIL PurchLine.NEXT = 0;
        END;
    end;

    procedure HandleItemTrackingDeletion()
    var
        ReservEntry: Record "337";
        ReservEntry2: Record "337";
    begin
        WITH ReservEntry DO BEGIN
          RESET;
          SETCURRENTKEY(
            "Source ID","Source Ref. No.","Source Type","Source Subtype",
            "Source Batch Name","Source Prod. Order Line","Reservation Status");
          SETRANGE("Source Type",DATABASE::"Purchase Line");
          SETRANGE("Source Subtype","Document Type");
          SETRANGE("Source ID","No.");
          SETRANGE("Source Batch Name",'');
          SETRANGE("Source Prod. Order Line",0);
          SETFILTER("Item Tracking",'> %1',"Item Tracking"::None);
          IF ISEMPTY THEN
            EXIT;

          IF HideValidationDialog OR NOT GUIALLOWED THEN
            Confirmed := TRUE
          ELSE
            Confirmed := CONFIRM(Text041,FALSE,LOWERCASE(FORMAT("Document Type")),"No.");

          IF NOT Confirmed THEN
            ERROR('');

          IF FINDSET THEN
            REPEAT
              ReservEntry2 := ReservEntry;
              ReservEntry2.ClearItemTrackingFields;
              ReservEntry2.MODIFY;
            UNTIL NEXT = 0;
        END;
    end;

    local procedure ClearItemAssgntPurchFilter(var TempItemChargeAssgntPurch: Record "5805")
    begin
        TempItemChargeAssgntPurch.SETRANGE("Document Line No.");
        TempItemChargeAssgntPurch.SETRANGE("Applies-to Doc. Type");
        TempItemChargeAssgntPurch.SETRANGE("Applies-to Doc. No.");
        TempItemChargeAssgntPurch.SETRANGE("Applies-to Doc. Line No.");
    end;

    procedure UpdateBuyFromCont(VendorNo: Code[20])
    var
        ContBusRel: Record "5054";
        Vend: Record "23";
    begin
        IF Vend.GET(VendorNo) THEN BEGIN
          IF Vend."Primary Contact No." <> '' THEN
            "Buy-from Contact No." := Vend."Primary Contact No."
          ELSE BEGIN
            ContBusRel.RESET;
            ContBusRel.SETCURRENTKEY("Link to Table","No.");
            ContBusRel.SETRANGE("Link to Table",ContBusRel."Link to Table"::Vendor);
            ContBusRel.SETRANGE("No.","Buy-from Vendor No.");
            IF ContBusRel.FINDFIRST THEN
              "Buy-from Contact No." := ContBusRel."Contact No."
            ELSE
              "Buy-from Contact No." := '';
          END;
          "Buy-from Contact" := Vend.Contact;
        END;
    end;

    procedure UpdatePayToCont(VendorNo: Code[20])
    var
        ContBusRel: Record "5054";
        Vend: Record "23";
    begin
        IF Vend.GET(VendorNo) THEN BEGIN
          IF Vend."Primary Contact No." <> '' THEN
            "Pay-to Contact No." := Vend."Primary Contact No."
          ELSE BEGIN
            ContBusRel.RESET;
            ContBusRel.SETCURRENTKEY("Link to Table","No.");
            ContBusRel.SETRANGE("Link to Table",ContBusRel."Link to Table"::Vendor);
            ContBusRel.SETRANGE("No.","Pay-to Vendor No.");
            IF ContBusRel.FINDFIRST THEN
              "Pay-to Contact No." := ContBusRel."Contact No."
            ELSE
              "Pay-to Contact No." := '';
          END;
          "Pay-to Contact" := Vend.Contact;
        END;
    end;

    procedure UpdateBuyFromVend(ContactNo: Code[20])
    var
        ContBusinessRelation: Record "5054";
        Vend: Record "23";
        Cont: Record "5050";
    begin
        IF Cont.GET(ContactNo) THEN BEGIN
          "Buy-from Contact No." := Cont."No.";
          IF Cont.Type = Cont.Type::Person THEN
            "Buy-from Contact" := Cont.Name
          ELSE
            IF Vend.GET("Buy-from Vendor No.") THEN
              "Buy-from Contact" := Vend.Contact
            ELSE
              "Buy-from Contact" := ''
        END ELSE BEGIN
          "Buy-from Contact" := '';
          EXIT;
        END;

        ContBusinessRelation.RESET;
        ContBusinessRelation.SETCURRENTKEY("Link to Table","Contact No.");
        ContBusinessRelation.SETRANGE("Link to Table",ContBusinessRelation."Link to Table"::Vendor);
        ContBusinessRelation.SETRANGE("Contact No.",Cont."Company No.");
        IF ContBusinessRelation.FINDFIRST THEN BEGIN
          IF ("Buy-from Vendor No." <> '') AND
             ("Buy-from Vendor No." <> ContBusinessRelation."No.")
          THEN
            ERROR(Text037,Cont."No.",Cont.Name,"Buy-from Vendor No.");
          IF "Buy-from Vendor No." = '' THEN BEGIN
            SkipBuyFromContact := TRUE;
            VALIDATE("Buy-from Vendor No.",ContBusinessRelation."No.");
            SkipBuyFromContact := FALSE;
          END;
        END ELSE
          ERROR(Text039,Cont."No.",Cont.Name);

        IF ("Buy-from Vendor No." = "Pay-to Vendor No.") OR
           ("Pay-to Vendor No." = '')
        THEN
          VALIDATE("Pay-to Contact No.","Buy-from Contact No.");
    end;

    procedure UpdatePayToVend(ContactNo: Code[20])
    var
        ContBusinessRelation: Record "5054";
        Vend: Record "23";
        Cont: Record "5050";
    begin
        IF Cont.GET(ContactNo) THEN BEGIN
          "Pay-to Contact No." := Cont."No.";
          IF Cont.Type = Cont.Type::Person THEN
            "Pay-to Contact" := Cont.Name
          ELSE
            IF Vend.GET("Pay-to Vendor No.") THEN
              "Pay-to Contact" := Vend.Contact
            ELSE
              "Pay-to Contact" := '';
        END ELSE BEGIN
          "Pay-to Contact" := '';
          EXIT;
        END;

        ContBusinessRelation.RESET;
        ContBusinessRelation.SETCURRENTKEY("Link to Table","Contact No.");
        ContBusinessRelation.SETRANGE("Link to Table",ContBusinessRelation."Link to Table"::Vendor);
        ContBusinessRelation.SETRANGE("Contact No.",Cont."Company No.");
        IF ContBusinessRelation.FINDFIRST THEN BEGIN
          IF "Pay-to Vendor No." = '' THEN BEGIN
            SkipPayToContact := TRUE;
            VALIDATE("Pay-to Vendor No.",ContBusinessRelation."No.");
            SkipPayToContact := FALSE;
          END ELSE
            IF "Pay-to Vendor No." <> ContBusinessRelation."No." THEN
              ERROR(Text037,Cont."No.",Cont.Name,"Pay-to Vendor No.");
        END ELSE
          ERROR(Text039,Cont."No.",Cont.Name);
    end;

    procedure CreateInvtPutAwayPick()
    var
        WhseRequest: Record "5765";
    begin
        TESTFIELD(Status,Status::Released);

        WhseRequest.RESET;
        WhseRequest.SETCURRENTKEY("Source Document","Source No.");
        CASE "Document Type" OF
          "Document Type"::Order:
            WhseRequest.SETRANGE("Source Document",WhseRequest."Source Document"::"Purchase Order");
          "Document Type"::"Return Order":
            WhseRequest.SETRANGE("Source Document",WhseRequest."Source Document"::"Purchase Return Order");
        END;
        WhseRequest.SETRANGE("Source No.","No.");
        REPORT.RUNMODAL(REPORT::"Create Invt Put-away/Pick/Mvmt",TRUE,FALSE,WhseRequest);
    end;

    procedure ShowDocDim()
    var
        OldDimSetID: Integer;
    begin
        OldDimSetID := "Dimension Set ID";
        "Dimension Set ID" :=
          DimMgt.EditDimensionSet2(
            "Dimension Set ID",STRSUBSTNO('%1 %2',"Document Type","No."),
            "Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");

        IF OldDimSetID <> "Dimension Set ID" THEN BEGIN
          MODIFY;
          IF PurchLinesExist THEN
            UpdateAllLineDim("Dimension Set ID",OldDimSetID);
        END;
    end;

    local procedure UpdateAllLineDim(NewParentDimSetID: Integer;OldParentDimSetID: Integer)
    var
        NewDimSetID: Integer;
    begin
        // Update all lines with changed dimensions.

        IF NewParentDimSetID = OldParentDimSetID THEN
          EXIT;
        IF NOT CONFIRM(Text051) THEN
          EXIT;

        PurchLine.RESET;
        PurchLine.SETRANGE("Document Type","Document Type");
        PurchLine.SETRANGE("Document No.","No.");
        PurchLine.LOCKTABLE;
        IF PurchLine.FIND('-') THEN
          REPEAT
            NewDimSetID := DimMgt.GetDeltaDimSetID(PurchLine."Dimension Set ID",NewParentDimSetID,OldParentDimSetID);
            IF PurchLine."Dimension Set ID" <> NewDimSetID THEN BEGIN
              PurchLine."Dimension Set ID" := NewDimSetID;
              DimMgt.UpdateGlobalDimFromDimSetID(
                PurchLine."Dimension Set ID",PurchLine."Shortcut Dimension 1 Code",PurchLine."Shortcut Dimension 2 Code");
              PurchLine.MODIFY;
            END;
          UNTIL PurchLine.NEXT = 0;
    end;

    procedure SetAmountToApply(AppliesToDocNo: Code[20];VendorNo: Code[20])
    var
        VendLedgEntry: Record "25";
    begin
        VendLedgEntry.SETCURRENTKEY("Document No.");
        VendLedgEntry.SETRANGE("Document No.",AppliesToDocNo);
        VendLedgEntry.SETRANGE("Vendor No.",VendorNo);
        VendLedgEntry.SETRANGE(Open,TRUE);
        IF VendLedgEntry.FINDFIRST THEN BEGIN
          IF VendLedgEntry."Amount to Apply" = 0 THEN  BEGIN
            VendLedgEntry.CALCFIELDS("Remaining Amount");
            VendLedgEntry."Amount to Apply" := VendLedgEntry."Remaining Amount";
          END ELSE
            VendLedgEntry."Amount to Apply" := 0;
          VendLedgEntry."Accepted Payment Tolerance" := 0;
          VendLedgEntry."Accepted Pmt. Disc. Tolerance" := FALSE;
          CODEUNIT.RUN(CODEUNIT::"Vend. Entry-Edit",VendLedgEntry);
        END;
    end;

    procedure SetShipToForSpecOrder()
    begin
        IF Location.GET("Location Code") THEN BEGIN
          "Ship-to Code" := '';
          "Ship-to Name" := Location.Name;
          "Ship-to Name 2" := Location."Name 2";
          "Ship-to Address" := Location.Address;
          "Ship-to Address 2" := Location."Address 2";
          "Ship-to City" := Location.City;
          "Ship-to Post Code" := Location."Post Code";
          "Ship-to County" := Location.County;
          "Ship-to Country/Region Code" := Location."Country/Region Code";
          "Ship-to Contact" := Location.Contact;
          "Location Code" := Location.Code;
        END ELSE BEGIN
          CompanyInfo.GET;
          "Ship-to Code" := '';
          "Ship-to Name" := CompanyInfo."Ship-to Name";
          "Ship-to Name 2" := CompanyInfo."Ship-to Name 2";
          "Ship-to Address" := CompanyInfo."Ship-to Address";
          "Ship-to Address 2" := CompanyInfo."Ship-to Address 2";
          "Ship-to City" := CompanyInfo."Ship-to City";
          "Ship-to Post Code" := CompanyInfo."Ship-to Post Code";
          "Ship-to County" := CompanyInfo."Ship-to County";
          "Ship-to Country/Region Code" := CompanyInfo."Ship-to Country/Region Code";
          "Ship-to Contact" := CompanyInfo."Ship-to Contact";
          "Location Code" := '';
        END;
    end;

    procedure JobUpdatePurchLines()
    begin
        WITH PurchLine DO BEGIN
          SETFILTER("Job No.",'<>%1','');
          SETFILTER("Job Task No.",'<>%1','');
          LOCKTABLE;
          IF FINDSET(TRUE,FALSE) THEN BEGIN
            SetPurchHeader(Rec);
            REPEAT
              JobSetCurrencyFactor;
              CreateTempJobJnlLine(FALSE);
              UpdateJobPrices;
              MODIFY;
            UNTIL NEXT = 0;
          END;
        END
    end;

    procedure GetPstdDocLinesToRevere()
    var
        PurchPostedDocLines: Page "5855";
    begin
        GetVend("Buy-from Vendor No.");
        PurchPostedDocLines.SetToPurchHeader(Rec);
        PurchPostedDocLines.SETRECORD(Vend);
        PurchPostedDocLines.LOOKUPMODE := TRUE;
        IF PurchPostedDocLines.RUNMODAL = ACTION::LookupOK THEN
          PurchPostedDocLines.CopyLineToDoc;

        CLEAR(PurchPostedDocLines);
    end;

    procedure SetSecurityFilterOnRespCenter()
    begin
        IF UserSetupMgt.GetPurchasesFilter <> '' THEN BEGIN
          FILTERGROUP(2);
          SETRANGE("Responsibility Center",UserSetupMgt.GetPurchasesFilter);
          FILTERGROUP(0);
        END;

        SETRANGE("Date Filter",0D,WORKDATE - 1);
    end;

    procedure CalcInvDiscForHeader()
    var
        PurchaseInvDisc: Codeunit "70";
    begin
        PurchSetup.GET;
        IF PurchSetup."Calc. Inv. Discount" THEN
          PurchaseInvDisc.CalculateIncDiscForHeader(Rec);
    end;

    procedure AddShipToAddress(SalesHeader: Record "36";ShowError: Boolean)
    var
        PurchLine2: Record "39";
    begin
        IF ShowError THEN BEGIN
          PurchLine2.RESET;
          PurchLine2.SETRANGE("Document Type","Document Type"::Order);
          PurchLine2.SETRANGE("Document No.","No.");
          IF NOT PurchLine2.ISEMPTY THEN BEGIN
            IF "Ship-to Name" <> SalesHeader."Ship-to Name" THEN
              ERROR(Text052,FIELDCAPTION("Ship-to Name"),"No.",SalesHeader."No.");
            IF "Ship-to Name 2" <> SalesHeader."Ship-to Name 2" THEN
              ERROR(Text052,FIELDCAPTION("Ship-to Name 2"),"No.",SalesHeader."No.");
            IF "Ship-to Address" <> SalesHeader."Ship-to Address" THEN
              ERROR(Text052,FIELDCAPTION("Ship-to Address"),"No.",SalesHeader."No.");
            IF "Ship-to Address 2" <> SalesHeader."Ship-to Address 2" THEN
              ERROR(Text052,FIELDCAPTION("Ship-to Address 2"),"No.",SalesHeader."No.");
            IF "Ship-to Post Code" <> SalesHeader."Ship-to Post Code" THEN
              ERROR(Text052,FIELDCAPTION("Ship-to Post Code"),"No.",SalesHeader."No.");
            IF "Ship-to City" <> SalesHeader."Ship-to City" THEN
              ERROR(Text052,FIELDCAPTION("Ship-to City"),"No.",SalesHeader."No.");
            IF "Ship-to Contact" <> SalesHeader."Ship-to Contact" THEN
              ERROR(Text052,FIELDCAPTION("Ship-to Contact"),"No.",SalesHeader."No.");
          END ELSE BEGIN
            // no purchase line exists
            "Ship-to Name" := SalesHeader."Ship-to Name";
            "Ship-to Name 2" := SalesHeader."Ship-to Name 2";
            "Ship-to Address" := SalesHeader."Ship-to Address";
            "Ship-to Address 2" := SalesHeader."Ship-to Address 2";
            "Ship-to Post Code" := SalesHeader."Ship-to Post Code";
            "Ship-to City" := SalesHeader."Ship-to City";
            "Ship-to Contact" := SalesHeader."Ship-to Contact";
          END;
        END;
    end;

    procedure DropShptOrderExists(SalesHeader: Record "36"): Boolean
    var
        SalesLine2: Record "37";
    begin
        // returns TRUE if sales is either Drop Shipment of Special Order
        SalesLine2.RESET;
        SalesLine2.SETRANGE("Document Type",SalesLine2."Document Type"::Order);
        SalesLine2.SETRANGE("Document No.",SalesHeader."No.");
        SalesLine2.SETRANGE("Drop Shipment",TRUE);
        EXIT(NOT SalesLine2.ISEMPTY);
    end;

    procedure SpecialOrderExists(SalesHeader: Record "36"): Boolean
    var
        SalesLine3: Record "37";
    begin
        SalesLine3.RESET;
        SalesLine3.SETRANGE("Document Type",SalesLine3."Document Type"::Order);
        SalesLine3.SETRANGE("Document No.",SalesHeader."No.");
        SalesLine3.SETRANGE("Special Order",TRUE);
        EXIT(NOT SalesLine3.ISEMPTY);
    end;

    procedure QtyToReceiveIsZero(): Boolean
    begin
        PurchLine.RESET;
        PurchLine.SETRANGE("Document Type","Document Type");
        PurchLine.SETRANGE("Document No.","No.");
        PurchLine.SETFILTER("Qty. to Receive",'<>0');
        EXIT(PurchLine.ISEMPTY);
    end;

    procedure IsApprovedForPosting(): Boolean
    var
        SalesHeader: Record "36";
    begin
        SalesHeader.INIT;
        IF ApprovalMgt.PrePostApprovalCheck(SalesHeader,Rec) THEN BEGIN
          IF ApprovalMgt.TestPurchasePrepayment(Rec) THEN
            ERROR(STRSUBSTNO(Text053,"Document Type","No."));
          IF ApprovalMgt.TestPurchasePayment(Rec) THEN
            IF NOT CONFIRM(STRSUBSTNO(Text054,"Document Type","No."),TRUE) THEN
              EXIT(FALSE);
          EXIT(TRUE);
        END;
    end;

    procedure IsApprovedForPostingBatch(): Boolean
    var
        SalesHeader: Record "36";
    begin
        SalesHeader.INIT;
        IF ApprovalMgt.PrePostApprovalCheck(SalesHeader,Rec) THEN BEGIN
          IF ApprovalMgt.TestPurchasePrepayment(Rec) THEN
            EXIT(FALSE);
          IF ApprovalMgt.TestPurchasePayment(Rec) THEN
            EXIT(FALSE);
          EXIT(TRUE);
        END;
    end;

    procedure SendToPosting(PostingCodeunitID: Integer)
    begin
        IF NOT IsApprovedForPosting THEN
          EXIT;
        CODEUNIT.RUN(PostingCodeunitID,Rec);
    end;

    procedure CancelBackgroundPosting()
    var
        PurchasePostViaJobQueue: Codeunit "98";
    begin
        PurchasePostViaJobQueue.CancelQueueEntry(Rec);
    end;

    procedure CheckDropShptAddressDetails(SalesHeader: Record "36"): Boolean
    begin
        NameAddressDetails := DropShptNameAddressDetails;
        DropShptNameAddressDetails :=
          SalesHeader."Ship-to Name" + SalesHeader."Ship-to Name 2" +
          SalesHeader."Ship-to Address" + SalesHeader."Ship-to Address 2" +
          SalesHeader."Ship-to Post Code" + SalesHeader."Ship-to City" +
          SalesHeader."Ship-to Contact";
        IF NameAddressDetails = '' THEN
          NameAddressDetails := DropShptNameAddressDetails;
        EXIT(NameAddressDetails = DropShptNameAddressDetails);
    end;

    procedure AddSpecialOrderToAddress(SalesHeader: Record "36";ShowError: Boolean)
    var
        PurchLine3: Record "39";
        LocationCode: Record "14";
    begin
        IF ShowError THEN BEGIN
          PurchLine3.RESET;
          PurchLine3.SETRANGE("Document Type","Document Type"::Order);
          PurchLine3.SETRANGE("Document No.","No.");
          IF NOT PurchLine3.ISEMPTY THEN BEGIN
            LocationCode.GET("Location Code");
            IF "Ship-to Name" <> LocationCode.Name THEN
              ERROR(Text052,FIELDCAPTION("Ship-to Name"),"No.",SalesHeader."No.");
            IF "Ship-to Name 2" <> LocationCode."Name 2" THEN
              ERROR(Text052,FIELDCAPTION("Ship-to Name 2"),"No.",SalesHeader."No.");
            IF "Ship-to Address" <> LocationCode.Address THEN
              ERROR(Text052,FIELDCAPTION("Ship-to Address"),"No.",SalesHeader."No.");
            IF "Ship-to Address 2" <> LocationCode."Address 2" THEN
              ERROR(Text052,FIELDCAPTION("Ship-to Address 2"),"No.",SalesHeader."No.");
            IF "Ship-to Post Code" <> LocationCode."Post Code" THEN
              ERROR(Text052,FIELDCAPTION("Ship-to Post Code"),"No.",SalesHeader."No.");
            IF "Ship-to City" <> LocationCode.City THEN
              ERROR(Text052,FIELDCAPTION("Ship-to City"),"No.",SalesHeader."No.");
            IF "Ship-to Contact" <> LocationCode.Contact THEN
              ERROR(Text052,FIELDCAPTION("Ship-to Contact"),"No.",SalesHeader."No.");
          END ELSE
            SetShipToForSpecOrder;
        END;
    end;

    procedure CheckSpecOrderAddressDetails(SalesHeader: Record "36"): Boolean
    var
        LocationCode: Record "14";
    begin
        NameAddressDetails := SpecOrderNameAddressDetails;
        IF LocationCode.GET(SalesHeader."Location Code") THEN
          SpecOrderNameAddressDetails :=
            LocationCode.Name + LocationCode."Name 2" +
            LocationCode.Address + LocationCode."Address 2" +
            LocationCode."Post Code" + LocationCode.City +
            LocationCode.Contact
        ELSE BEGIN
          CompanyInfo.GET;
          SpecOrderNameAddressDetails :=
            CompanyInfo."Ship-to Name" + CompanyInfo."Ship-to Name 2" +
            CompanyInfo."Ship-to Address" + CompanyInfo."Ship-to Address 2" +
            CompanyInfo."Ship-to Post Code" + CompanyInfo."Ship-to City" +
            CompanyInfo."Ship-to Contact";
        END;
        IF NameAddressDetails = '' THEN
          NameAddressDetails := SpecOrderNameAddressDetails;
        EXIT(NameAddressDetails = SpecOrderNameAddressDetails);
    end;

    procedure ZeroAmountInLines()
    var
        PurchLine: Record "39";
    begin
        PurchLine.SetPurchHeader(PurchHeader);
        PurchLine.SETRANGE("Document Type","Document Type");
        PurchLine.SETRANGE("Document No.","No.");
        PurchLine.SETFILTER(Type,'>0');
        PurchLine.SETFILTER(Quantity,'<>0');
        IF PurchLine.FINDSET(TRUE) THEN
          REPEAT
            PurchLine.Amount := 0;
            PurchLine."Amount Including VAT" := 0;
            PurchLine."VAT Base Amount" := 0;
            PurchLine.InitOutstandingAmount;
            PurchLine.MODIFY;
          UNTIL PurchLine.NEXT = 0;
    end;
}

