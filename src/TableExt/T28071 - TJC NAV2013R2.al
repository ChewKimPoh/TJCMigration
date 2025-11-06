table 28071 "Sales Tax Invoice Header"
{
    Caption = 'Sales Tax Invoice Header';
    DataCaptionFields = "No.","Sell-to Customer Name";
    DrillDownPageID = 28081;
    LookupPageID = 28081;

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
        }
        field(10;"Bill-to Contact";Text[50])
        {
            Caption = 'Bill-to Contact';
        }
        field(11;"Your Reference";Text[30])
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
            Caption = 'Prices Including GST';
        }
        field(37;"Invoice Disc. Code";Code[20])
        {
            Caption = 'Invoice Disc. Code';
        }
        field(40;"Customer Disc. Group";Code[10])
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
                                                            No.=FIELD(No.)));
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
        }
        field(55;"Bal. Account No.";Code[20])
        {
            Caption = 'Bal. Account No.';
            TableRelation = IF (Bal. Account Type=CONST(G/L Account)) "G/L Account"
                            ELSE IF (Bal. Account Type=CONST(Bank Account)) "Bank Account";
        }
        field(56;"Job No.";Code[20])
        {
            Caption = 'Job No.';
            TableRelation = Job;
        }
        field(60;Amount;Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = Sum("Sales Tax Invoice Line".Amount WHERE (Document No.=FIELD(No.)));
            Caption = 'Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(61;"Amount Including VAT";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = Sum("Sales Tax Invoice Line"."Amount Including VAT" WHERE (Document No.=FIELD(No.)));
            Caption = 'Amount Including GST';
            Editable = false;
            FieldClass = FlowField;
        }
        field(70;"VAT Registration No.";Text[20])
        {
            Caption = 'GST Registration No.';
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
            Caption = 'GST Country/Region Code';
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
        field(100;"External Document No.";Code[20])
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
        field(112;"User ID";Code[20])
        {
            Caption = 'User ID';
            TableRelation = Table2000000002;
            //This property is currently not supported
            //TestTableRelation = false;

            trigger OnLookup()
            var
                LoginMgt: Codeunit "418";
            begin
                LoginMgt.LookupUserID("User ID");
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
            Caption = 'GST Bus. Posting Group';
            TableRelation = "VAT Business Posting Group";
        }
        field(119;"VAT Base Discount %";Decimal)
        {
            Caption = 'GST Base Discount %';
            DecimalPlaces = 0:5;
            MaxValue = 100;
            MinValue = 0;
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
            Caption = 'Responsibility Centre';
            TableRelation = "Responsibility Center";
        }
        field(5900;"Service Mgt. Document";Boolean)
        {
            Caption = 'Service Mgt. Document';
        }
        field(7001;"Allow Line Disc.";Boolean)
        {
            Caption = 'Allow Line Disc.';
        }
        field(28040;"WHT Business Posting Group";Code[10])
        {
            Caption = 'WHT Business Posting Group';
            TableRelation = "WHT Business Posting Group";
        }
        field(28041;"Rem. WHT Prepaid Amount (LCY)";Decimal)
        {
            CalcFormula = Sum("WHT Entry"."Remaining Unrealized Amount" WHERE (Document Type=CONST(Invoice),
                                                                               Document No.=FIELD(No.)));
            Caption = 'Rem. WHT Prepaid Amount (LCY)';
            FieldClass = FlowField;
        }
        field(28042;"Paid WHT Prepaid Amount (LCY)";Decimal)
        {
            CalcFormula = Sum("WHT Entry".Amount WHERE (Document Type=CONST(Payment),
                                                        Document No.=FIELD(No.)));
            Caption = 'Paid WHT Prepaid Amount (LCY)';
            FieldClass = FlowField;
        }
        field(28043;"Total WHT Prepaid Amount (LCY)";Decimal)
        {
            CalcFormula = Sum("WHT Entry"."Unrealized Amount" WHERE (Document Type=CONST(Invoice),
                                                                     Document No.=FIELD(No.)));
            Caption = 'Total WHT Prepaid Amount (LCY)';
            FieldClass = FlowField;
        }
        field(28070;"Tax Document Type";Option)
        {
            Caption = 'Tax Document Type';
            Editable = false;
            OptionCaption = ' ,Document Post,Group Batch,Prompt';
            OptionMembers = " ","Document Post","Group Batch",Prompt;
        }
        field(28071;"Printed Tax Document";Boolean)
        {
            Caption = 'Printed Tax Document';
            Editable = false;
        }
        field(28072;"Posted Tax Document";Boolean)
        {
            Caption = 'Posted Tax Document';
            Editable = false;
        }
        field(28073;"Tax Document Marked";Boolean)
        {
            Caption = 'Tax Document Marked';
            Editable = false;
        }
        field(28074;"Tax Date Filter";Date)
        {
            Caption = 'Tax Date Filter';
            FieldClass = FlowFilter;
        }
        field(28075;"Invoice Print Type";Option)
        {
            Caption = 'Invoice Print Type';
            Editable = false;
            OptionCaption = 'Invoice,Tax Invoice (Items),Tax Invoice (Services)';
            OptionMembers = Invoice,"Tax Invoice (Items)","Tax Invoice (Services)";
        }
        field(99008509;"Date Sent";Date)
        {
            Caption = 'Date Sent';
        }
        field(99008510;"Time Sent";Time)
        {
            Caption = 'Time Sent';
        }
        field(99008516;"BizTalk Sales Invoice";Boolean)
        {
            Caption = 'BizTalk Sales Invoice';
        }
        field(99008519;"Customer Order No.";Code[20])
        {
            Caption = 'Customer Order No.';
        }
        field(99008521;"BizTalk Document Sent";Boolean)
        {
            Caption = 'BizTalk Document Sent';
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
        key(Key4;"Service Mgt. Document")
        {
        }
        key(Key5;"Sell-to Customer No.","External Document No.")
        {
        }
        key(Key6;"Sell-to Customer No.","Order Date")
        {
        }
        key(Key7;"Sell-to Customer No.","No.")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown;"No.","Sell-to Customer No.")
        {
        }
    }

    trigger OnDelete()
    begin
        SalesTaxInvLine.RESET;
        SalesTaxInvLine.SETRANGE("Document No.","No.");
        SalesTaxInvLine.DELETEALL;
    end;

    trigger OnInsert()
    begin
        SalesSetup.GET;
        IF "No." = '' THEN BEGIN
          /*
          IF TaxInvoiceManagement.CheckTaxableNoSeries("Sell-to Customer No.",1) THEN BEGIN
            SalesSetup.TESTFIELD("Posted Non Tax Invoice Nos.");
            NoSeriesMgt.InitSeries(SalesSetup."Posted Non Tax Invoice Nos.",xRec."No. Series","Posting Date","No.","No. Series");
          END ELSE BEGIN
            TestNoSeries;
            NoSeriesMgt.InitSeries(SalesSetup."Posted Tax Invoice Nos.",xRec."No. Series","Posting Date","No.","No. Series");
          END;
          */
        END;

    end;

    var
        SalesSetup: Record "311";
        NoSeriesMgt: Codeunit "396";
        SalesTaxInvHeader: Record "28071";
        SalesTaxInvLine: Record "28072";

    procedure PrintRecords(ShowRequestForm: Boolean)
    var
        ReportSelection: Record "77";
    begin
        /*
        WITH SalesTaxInvHeader DO BEGIN
          COPY(Rec);
          ReportSelection.SETRANGE(Usage,ReportSelection.Usage::"S.TaxInvoice");
          ReportSelection.SETFILTER("Report ID",'<>0');
          ReportSelection.FIND('-');
          REPEAT
            REPORT.RUNMODAL(ReportSelection."Report ID",ShowRequestForm,FALSE,SalesTaxInvHeader);
          UNTIL ReportSelection.NEXT = 0;
        END;
        */

    end;

    procedure Navigate()
    begin
        //NavigateForm.SetDoc("Posting Date","No.");
        //NavigateForm.RUN;
    end;

    local procedure TestNoSeries(): Boolean
    begin
        //SalesSetup.TESTFIELD("Posted Tax Invoice Nos.");
    end;

    local procedure GetNoSeriesCode(): Code[10]
    begin
        //EXIT(SalesSetup."Posted Tax Invoice Nos.");
    end;
}

