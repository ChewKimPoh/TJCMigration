table 28075 "Purch. Tax Inv. Header"
{
    Caption = 'Purch. Tax Inv. Header';
    DataCaptionFields = "No.","Buy-from Vendor Name";
    LookupPageID = 28079;

    fields
    {
        field(2;"Buy-from Vendor No.";Code[20])
        {
            Caption = 'Buy-from Vendor No.';
            NotBlank = true;
            TableRelation = Vendor;
        }
        field(3;"No.";Code[20])
        {
            Caption = 'No.';
        }
        field(4;"Pay-to Vendor No.";Code[20])
        {
            Caption = 'Pay-to Vendor No.';
            NotBlank = true;
            TableRelation = Vendor;
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
        }
        field(10;"Pay-to Contact";Text[50])
        {
            Caption = 'Pay-to Contact';
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
        field(21;"Expected Receipt Date";Date)
        {
            Caption = 'Expected Receipt Date';
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
        field(31;"Vendor Posting Group";Code[10])
        {
            Caption = 'Vendor Posting Group';
            Editable = false;
            TableRelation = "Vendor Posting Group";
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
        field(35;"Prices Including VAT";Boolean)
        {
            Caption = 'Prices Including GST';
        }
        field(37;"Invoice Disc. Code";Code[20])
        {
            Caption = 'Invoice Disc. Code';
        }
        field(41;"Language Code";Code[10])
        {
            Caption = 'Language Code';
            TableRelation = Language;
        }
        field(43;"Purchaser Code";Code[10])
        {
            Caption = 'Purchaser Code';
            TableRelation = Salesperson/Purchaser;
        }
        field(44;"Order No.";Code[20])
        {
            Caption = 'Order No.';
        }
        field(46;Comment;Boolean)
        {
            CalcFormula = Exist("Purch. Comment Line" WHERE (Document Type=CONST(Posted Invoice),
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
            CalcFormula = Sum("Purch. Tax Inv. Line".Amount WHERE (Document No.=FIELD(No.)));
            Caption = 'Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(61;"Amount Including VAT";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = Sum("Purch. Tax Inv. Line"."Amount Including VAT" WHERE (Document No.=FIELD(No.)));
            Caption = 'Amount Including GST';
            Editable = false;
            FieldClass = FlowField;
        }
        field(66;"Vendor Order No.";Code[20])
        {
            Caption = 'Vendor Order No.';
        }
        field(68;"Vendor Invoice No.";Code[20])
        {
            Caption = 'Vendor Invoice No.';
        }
        field(70;"VAT Registration No.";Text[20])
        {
            Caption = 'GST Registration No.';
        }
        field(72;"Sell-to Customer No.";Code[20])
        {
            Caption = 'Sell-to Customer No.';
            TableRelation = Customer;
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
        }
        field(84;"Buy-from Contact";Text[50])
        {
            Caption = 'Buy-from Contact';
        }
        field(85;"Pay-to Post Code";Code[20])
        {
            Caption = 'Pay-to Post Code';
            TableRelation = "Post Code";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
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
            TableRelation = "Post Code";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
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
        field(95;"Order Address Code";Code[10])
        {
            Caption = 'Order Address Code';
            TableRelation = "Order Address".Code WHERE (Vendor No.=FIELD(Buy-from Vendor No.));
        }
        field(97;"Entry Point";Code[10])
        {
            Caption = 'Entry Point';
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
                // LoginMgt.LookupUserID("User ID");
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
        field(5052;"Buy-from Contact No.";Code[20])
        {
            Caption = 'Buy-from Contact No.';
            TableRelation = Contact;
        }
        field(5053;"Pay-to Contact No.";Code[20])
        {
            Caption = 'Pay-to Contact No.';
            TableRelation = Contact;
        }
        field(5700;"Responsibility Center";Code[10])
        {
            Caption = 'Responsibility Centre';
            TableRelation = "Responsibility Center";
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
        field(28044;"Actual Vendor No.";Code[20])
        {
            Caption = 'Actual Vendor No.';
        }
        field(28070;"Printed Tax Document";Boolean)
        {
            Caption = 'Printed Tax Document';
            Editable = false;
        }
        field(28071;"Posted Tax Document";Boolean)
        {
            Caption = 'Posted Tax Document';
            Editable = false;
        }
        field(28073;"Tax Date Filter";Date)
        {
            Caption = 'Tax Date Filter';
            FieldClass = FlowFilter;
        }
        field(28074;"Tax Document Marked";Boolean)
        {
            Caption = 'Tax Document Marked';
            Editable = false;
        }
        field(28075;"Invoice Print Type";Option)
        {
            Caption = 'Invoice Print Type';
            Editable = false;
            OptionCaption = 'Invoice,Tax Invoice (Items),Tax Invoice (Services)';
            OptionMembers = Invoice,"Tax Invoice (Items)","Tax Invoice (Services)";
        }
        field(99008500;"Date Received";Date)
        {
            Caption = 'Date Received';
        }
        field(99008501;"Time Received";Time)
        {
            Caption = 'Time Received';
        }
        field(99008506;"BizTalk Purchase Invoice";Boolean)
        {
            Caption = 'BizTalk Purchase Invoice';
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
        key(Key4;"Vendor Invoice No.","Posting Date")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown;"No.","Buy-from Vendor No.")
        {
        }
    }

    trigger OnDelete()
    begin
        PurchTaxInvLine.RESET;
        PurchTaxInvLine.SETRANGE("Document No.","No.");
        PurchTaxInvLine.DELETEALL;
    end;

    trigger OnInsert()
    begin
        PurchSetup.GET;
        IF "No." = '' THEN BEGIN
          /*
          IF TaxInvoiceManagement.CheckTaxableNoSeries("Buy-from Vendor No.",0) THEN BEGIN
            PurchSetup.TESTFIELD("Posted Non Tax Invoice Nos.");
            NoSeriesMgt.InitSeries(PurchSetup."Posted Non Tax Invoice Nos.",xRec."No. Series","Posting Date","No.","No. Series");
          END ELSE BEGIN
            TestNoSeries;
            NoSeriesMgt.InitSeries(GetNoSeriesCode,xRec."No. Series","Posting Date","No.","No. Series");
          END;
          */
        END;

    end;

    var
        PurchSetup: Record "312";
        NoSeriesMgt: Codeunit "396";
        PurchTaxInvHeader: Record "28075";
        PurchTaxInvLine: Record "28076";

    procedure PrintRecords(ShowRequestForm: Boolean)
    var
        ReportSelection: Record "77";
    begin
        /*
        WITH PurchTaxInvHeader DO BEGIN
          COPY(Rec);
          ReportSelection.SETRANGE(Usage,ReportSelection.Usage::"P.TaxInvoice");
          ReportSelection.SETFILTER("Report ID",'<>0');
          ReportSelection.FIND('-');
          REPEAT
            REPORT.RUNMODAL(ReportSelection."Report ID",ShowRequestForm,FALSE,PurchTaxInvHeader);
          UNTIL ReportSelection.NEXT = 0;
        END;
        */

    end;

    procedure Navigate()
    begin
        // NavigateForm.SetDoc("Posting Date","No.");
        // NavigateForm.RUN;
    end;

    local procedure TestNoSeries(): Boolean
    begin
        // PurchSetup.TESTFIELD("Posted Tax Invoice Nos.");
    end;

    local procedure GetNoSeriesCode(): Code[10]
    begin
        // EXIT(PurchSetup."Posted Tax Invoice Nos.");
    end;
}

