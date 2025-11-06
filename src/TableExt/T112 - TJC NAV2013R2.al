table 112 "Sales Invoice Header"
{
    Caption = 'Sales Invoice Header';
    DataCaptionFields = "No.","Sell-to Customer Name";
    DrillDownPageID = 143;
    LookupPageID = 143;

    fields
    {
        field(2;"Sell-to Customer No.";Code[20])
        {
            Caption = 'Sell-to Customer No.';
            NotBlank = true;
            TableRelation = Customer;
        }
        field(3;"No.";Code[20])
        {
            Caption = 'No.';
        }
        field(4;"Bill-to Customer No.";Code[20])
        {
            Caption = 'Bill-to Customer No.';
            NotBlank = true;
            TableRelation = Customer;
        }
        field(5;"Bill-to Name";Text[50])
        {
            Caption = 'Bill-to Name';
        }
        field(6;"Bill-to Name 2";Text[50])
        {
            Caption = 'Bill-to Name 2';
        }
        field(7;"Bill-to Address";Text[50])
        {
            Caption = 'Bill-to Address';
        }
        field(8;"Bill-to Address 2";Text[50])
        {
            Caption = 'Bill-to Address 2';
        }
        field(9;"Bill-to City";Text[30])
        {
            Caption = 'Bill-to City';
            TableRelation = "Post Code".City;
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(10;"Bill-to Contact";Text[50])
        {
            Caption = 'Bill-to Contact';
        }
        field(11;"Your Reference";Text[35])
        {
            Caption = 'Your Reference';
        }
        field(12;"Ship-to Code";Code[10])
        {
            Caption = 'Ship-to Code';
            TableRelation = "Ship-to Address".Code WHERE (Customer No.=FIELD(Sell-to Customer No.));
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
            TableRelation = "Post Code".City;
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(18;"Ship-to Contact";Text[50])
        {
            Caption = 'Ship-to Contact';
        }
        field(19;"Order Date";Date)
        {
            Caption = 'Order Date';
        }
        field(20;"Posting Date";Date)
        {
            Caption = 'Posting Date';
        }
        field(21;"Shipment Date";Date)
        {
            Caption = 'Shipment Date';
        }
        field(22;"Posting Description";Text[50])
        {
            Caption = 'Posting Description';
        }
        field(23;"Payment Terms Code";Code[10])
        {
            Caption = 'Payment Terms Code';
            TableRelation = "Payment Terms";
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
        }
        field(26;"Pmt. Discount Date";Date)
        {
            Caption = 'Pmt. Discount Date';
        }
        field(27;"Shipment Method Code";Code[10])
        {
            Caption = 'Shipment Method Code';
            TableRelation = "Shipment Method";
        }
        field(28;"Location Code";Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location WHERE (Use As In-Transit=CONST(No));
        }
        field(29;"Shortcut Dimension 1 Code";Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
        }
        field(30;"Shortcut Dimension 2 Code";Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
        }
        field(31;"Customer Posting Group";Code[10])
        {
            Caption = 'Customer Posting Group';
            Editable = false;
            TableRelation = "Customer Posting Group";
        }
        field(32;"Currency Code";Code[10])
        {
            Caption = 'Currency Code';
            Editable = false;
            TableRelation = Currency;
        }
        field(33;"Currency Factor";Decimal)
        {
            Caption = 'Currency Factor';
            DecimalPlaces = 0:15;
            MinValue = 0;
        }
        field(34;"Customer Price Group";Code[10])
        {
            Caption = 'Customer Price Group';
            TableRelation = "Customer Price Group";
        }
        field(35;"Prices Including VAT";Boolean)
        {
            Caption = 'Prices Including VAT';
        }
        field(37;"Invoice Disc. Code";Code[20])
        {
            Caption = 'Invoice Disc. Code';
        }
        field(40;"Customer Disc. Group";Code[20])
        {
            Caption = 'Customer Disc. Group';
            TableRelation = "Customer Discount Group";
        }
        field(41;"Language Code";Code[10])
        {
            Caption = 'Language Code';
            TableRelation = Language;
        }
        field(43;"Salesperson Code";Code[10])
        {
            Caption = 'Salesperson Code';
            TableRelation = Salesperson/Purchaser;
        }
        field(44;"Order No.";Code[20])
        {
            Caption = 'Order No.';
        }
        field(46;Comment;Boolean)
        {
            CalcFormula = Exist("Sales Comment Line" WHERE (Document Type=CONST(Posted Invoice),
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
                CustLedgEntry.SETCURRENTKEY("Document No.");
                CustLedgEntry.SETRANGE("Document Type","Applies-to Doc. Type");
                CustLedgEntry.SETRANGE("Document No.","Applies-to Doc. No.");
                PAGE.RUN(0,CustLedgEntry);
            end;
        }
        field(55;"Bal. Account No.";Code[20])
        {
            Caption = 'Bal. Account No.';
            TableRelation = IF (Bal. Account Type=CONST(G/L Account)) "G/L Account"
                            ELSE IF (Bal. Account Type=CONST(Bank Account)) "Bank Account";
        }
        field(60;Amount;Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = Sum("Sales Invoice Line".Amount WHERE (Document No.=FIELD(No.)));
            Caption = 'Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(61;"Amount Including VAT";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = Sum("Sales Invoice Line"."Amount Including VAT" WHERE (Document No.=FIELD(No.)));
            Caption = 'Amount Including VAT';
            Editable = false;
            FieldClass = FlowField;
        }
        field(70;"VAT Registration No.";Text[20])
        {
            Caption = 'VAT Registration No.';
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
        }
        field(75;"EU 3-Party Trade";Boolean)
        {
            Caption = 'EU 3-Party Trade';
        }
        field(76;"Transaction Type";Code[10])
        {
            Caption = 'Transaction Type';
            TableRelation = "Transaction Type";
        }
        field(77;"Transport Method";Code[10])
        {
            Caption = 'Transport Method';
            TableRelation = "Transport Method";
        }
        field(78;"VAT Country/Region Code";Code[10])
        {
            Caption = 'VAT Country/Region Code';
            TableRelation = Country/Region;
        }
        field(79;"Sell-to Customer Name";Text[50])
        {
            Caption = 'Sell-to Customer Name';
        }
        field(80;"Sell-to Customer Name 2";Text[50])
        {
            Caption = 'Sell-to Customer Name 2';
        }
        field(81;"Sell-to Address";Text[50])
        {
            Caption = 'Sell-to Address';
        }
        field(82;"Sell-to Address 2";Text[50])
        {
            Caption = 'Sell-to Address 2';
        }
        field(83;"Sell-to City";Text[30])
        {
            Caption = 'Sell-to City';
            TableRelation = "Post Code".City;
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(84;"Sell-to Contact";Text[50])
        {
            Caption = 'Sell-to Contact';
        }
        field(85;"Bill-to Post Code";Code[20])
        {
            Caption = 'Bill-to Post Code';
            TableRelation = "Post Code";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(86;"Bill-to County";Text[30])
        {
            Caption = 'Bill-to County';
        }
        field(87;"Bill-to Country/Region Code";Code[10])
        {
            Caption = 'Bill-to Country/Region Code';
            TableRelation = Country/Region;
        }
        field(88;"Sell-to Post Code";Code[20])
        {
            Caption = 'Sell-to Post Code';
            TableRelation = "Post Code";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(89;"Sell-to County";Text[30])
        {
            Caption = 'Sell-to County';
        }
        field(90;"Sell-to Country/Region Code";Code[10])
        {
            Caption = 'Sell-to Country/Region Code';
            TableRelation = Country/Region;
        }
        field(91;"Ship-to Post Code";Code[20])
        {
            Caption = 'Ship-to Post Code';
            TableRelation = "Post Code";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
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
        field(97;"Exit Point";Code[10])
        {
            Caption = 'Exit Point';
            TableRelation = "Entry/Exit Point";
        }
        field(98;Correction;Boolean)
        {
            Caption = 'Correction';
        }
        field(99;"Document Date";Date)
        {
            Caption = 'Document Date';
        }
        field(100;"External Document No.";Code[35])
        {
            Caption = 'External Document No.';
        }
        field(101;"Area";Code[10])
        {
            Caption = 'Area';
            TableRelation = Area;
        }
        field(102;"Transaction Specification";Code[10])
        {
            Caption = 'Transaction Specification';
            TableRelation = "Transaction Specification";
        }
        field(104;"Payment Method Code";Code[10])
        {
            Caption = 'Payment Method Code';
            TableRelation = "Payment Method";
        }
        field(105;"Shipping Agent Code";Code[10])
        {
            Caption = 'Shipping Agent Code';
            TableRelation = "Shipping Agent";
        }
        field(106;"Package Tracking No.";Text[30])
        {
            Caption = 'Package Tracking No.';
        }
        field(107;"Pre-Assigned No. Series";Code[10])
        {
            Caption = 'Pre-Assigned No. Series';
            TableRelation = "No. Series";
        }
        field(108;"No. Series";Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(110;"Order No. Series";Code[10])
        {
            Caption = 'Order No. Series';
            TableRelation = "No. Series";
        }
        field(111;"Pre-Assigned No.";Code[20])
        {
            Caption = 'Pre-Assigned No.';
        }
        field(112;"User ID";Code[50])
        {
            Caption = 'User ID';
            TableRelation = User."User Name";
            //This property is currently not supported
            //TestTableRelation = false;

            trigger OnLookup()
            var
                UserMgt: Codeunit "418";
            begin
                UserMgt.LookupUserID("User ID");
            end;
        }
        field(113;"Source Code";Code[10])
        {
            Caption = 'Source Code';
            TableRelation = "Source Code";
        }
        field(114;"Tax Area Code";Code[20])
        {
            Caption = 'Tax Area Code';
            TableRelation = "Tax Area";
        }
        field(115;"Tax Liable";Boolean)
        {
            Caption = 'Tax Liable';
        }
        field(116;"VAT Bus. Posting Group";Code[10])
        {
            Caption = 'VAT Bus. Posting Group';
            TableRelation = "VAT Business Posting Group";
        }
        field(119;"VAT Base Discount %";Decimal)
        {
            Caption = 'VAT Base Discount %';
            DecimalPlaces = 0:5;
            MaxValue = 100;
            MinValue = 0;
        }
        field(131;"Prepayment No. Series";Code[10])
        {
            Caption = 'Prepayment No. Series';
            TableRelation = "No. Series";
        }
        field(136;"Prepayment Invoice";Boolean)
        {
            Caption = 'Prepayment Invoice';
        }
        field(137;"Prepayment Order No.";Code[20])
        {
            Caption = 'Prepayment Order No.';
        }
        field(151;"Quote No.";Code[20])
        {
            Caption = 'Quote No.';
            Editable = false;
        }
        field(480;"Dimension Set ID";Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup()
            begin
                ShowDimensions;
            end;
        }
        field(827;"Credit Card No.";Code[20])
        {
            Caption = 'Credit Card No.';
            TableRelation = "DO Payment Credit Card" WHERE (Customer No.=FIELD(Bill-to Customer No.));
        }
        field(1200;"Direct Debit Mandate ID";Code[35])
        {
            Caption = 'Direct Debit Mandate ID';
            TableRelation = "SEPA Direct Debit Mandate" WHERE (Customer No.=FIELD(Bill-to Customer No.));
        }
        field(1300;"Canceled By";Code[20])
        {
            Caption = 'Canceled By';
            Editable = false;
            TableRelation = "Sales Cr.Memo Header";
        }
        field(1301;Canceled;Boolean)
        {
            CalcFormula = Exist("Sales Cr.Memo Header" WHERE (Canceled=CONST(Yes),
                                                              Applies-to Doc. Type=CONST(Invoice),
                                                              Applies-to Doc. No.=FIELD(No.)));
            Caption = 'Canceled';
            Editable = false;
            FieldClass = FlowField;
        }
        field(1302;Paid;Boolean)
        {
            CalcFormula = -Exist("Cust. Ledger Entry" WHERE (Entry No.=FIELD(Cust. Ledger Entry No.),
                                                             Open=FILTER(Yes)));
            Caption = 'Paid';
            Editable = false;
            FieldClass = FlowField;
        }
        field(1303;"Remaining Amount";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = Sum("Detailed Cust. Ledg. Entry".Amount WHERE (Cust. Ledger Entry No.=FIELD(Cust. Ledger Entry No.)));
            Caption = 'Remaining Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(1304;"Cust. Ledger Entry No.";Integer)
        {
            Caption = 'Cust. Ledger Entry No.';
            Editable = false;
            TableRelation = "Cust. Ledger Entry"."Entry No.";
            //This property is currently not supported
            //TestTableRelation = false;
        }
        field(1305;"Invoice Discount Amount";Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Sales Invoice Line"."Inv. Discount Amount" WHERE (Document No.=FIELD(No.)));
            Caption = 'Invoice Discount Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5050;"Campaign No.";Code[20])
        {
            Caption = 'Campaign No.';
            TableRelation = Campaign;
        }
        field(5052;"Sell-to Contact No.";Code[20])
        {
            Caption = 'Sell-to Contact No.';
            TableRelation = Contact;
        }
        field(5053;"Bill-to Contact No.";Code[20])
        {
            Caption = 'Bill-to Contact No.';
            TableRelation = Contact;
        }
        field(5700;"Responsibility Center";Code[10])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility Center";
        }
        field(7001;"Allow Line Disc.";Boolean)
        {
            Caption = 'Allow Line Disc.';
        }
        field(7200;"Get Shipment Used";Boolean)
        {
            Caption = 'Get Shipment Used';
        }
        field(50001;"No Picking List";Boolean)
        {
        }
    }

    keys
    {
        key(Key1;"No.")
        {
        }
        key(Key2;"Order No.")
        {
        }
        key(Key3;"Pre-Assigned No.")
        {
        }
        key(Key4;"Sell-to Customer No.","External Document No.")
        {
            MaintainSQLIndex = false;
        }
        key(Key5;"Sell-to Customer No.","Order Date")
        {
            MaintainSQLIndex = false;
        }
        key(Key6;"Sell-to Customer No.")
        {
        }
        key(Key7;"Prepayment Order No.","Prepayment Invoice")
        {
        }
        key(Key8;"Bill-to Customer No.")
        {
        }
        key(Key9;"Posting Date","Sell-to Customer No.")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown;"No.","Sell-to Customer No.","Bill-to Customer No.","Posting Date","Posting Description")
        {
        }
    }

    trigger OnDelete()
    begin
        TESTFIELD("No. Printed");
        LOCKTABLE;
        PostSalesLinesDelete.DeleteSalesInvLines(Rec);

        SalesCommentLine.SETRANGE("Document Type",SalesCommentLine."Document Type"::"Posted Invoice");
        SalesCommentLine.SETRANGE("No.","No.");
        SalesCommentLine.DELETEALL;

        ApprovalsMgt.DeletePostedApprovalEntry(DATABASE::"Sales Invoice Header","No.");
    end;

    var
        SalesInvHeader: Record "112";
        SalesCommentLine: Record "44";
        CustLedgEntry: Record "21";
        PostSalesLinesDelete: Codeunit "363";
        DimMgt: Codeunit "408";
        ApprovalsMgt: Codeunit "439";
        UserSetupMgt: Codeunit "5700";

    procedure PrintRecords(ShowRequestForm: Boolean)
    var
        ReportSelection: Record "77";
    begin
        WITH SalesInvHeader DO BEGIN
          COPY(Rec);
          FIND('-');
          ReportSelection.SETRANGE(Usage,ReportSelection.Usage::"S.Invoice");
          ReportSelection.SETFILTER("Report ID",'<>0');
          ReportSelection.FIND('-');
          REPEAT
            REPORT.RUNMODAL(ReportSelection."Report ID",ShowRequestForm,FALSE,SalesInvHeader);
          UNTIL ReportSelection.NEXT = 0;
        END;
    end;

    procedure Navigate()
    var
        NavigateForm: Page "344";
    begin
        NavigateForm.SetDoc("Posting Date","No.");
        NavigateForm.RUN;
    end;

    procedure GetCreditcardNumber(): Text[20]
    var
        DOPaymentCreditCard: Record "827";
    begin
        IF "Credit Card No." = '' THEN
          EXIT('');
        EXIT(DOPaymentCreditCard.GetCreditCardNumber("Credit Card No."));
    end;

    procedure LookupAdjmtValueEntries()
    var
        ValueEntry: Record "5802";
    begin
        ValueEntry.SETCURRENTKEY("Document No.");
        ValueEntry.SETRANGE("Document No.","No.");
        ValueEntry.SETRANGE("Document Type",ValueEntry."Document Type"::"Sales Invoice");
        ValueEntry.SETRANGE(Adjustment,TRUE);
        PAGE.RUNMODAL(0,ValueEntry);
    end;

    procedure ShowDimensions()
    begin
        DimMgt.ShowDimensionSet("Dimension Set ID",STRSUBSTNO('%1 %2',TABLECAPTION,"No."));
    end;

    procedure SetSecurityFilterOnRespCenter()
    begin
        IF UserSetupMgt.GetSalesFilter <> '' THEN BEGIN
          FILTERGROUP(2);
          SETRANGE("Responsibility Center",UserSetupMgt.GetSalesFilter);
          FILTERGROUP(0);
        END;
    end;
}

