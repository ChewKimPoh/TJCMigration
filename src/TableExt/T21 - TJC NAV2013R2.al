table 21 "Cust. Ledger Entry"
{
    Caption = 'Cust. Ledger Entry';
    DrillDownPageID = 25;
    LookupPageID = 25;

    fields
    {
        field(1;"Entry No.";Integer)
        {
            Caption = 'Entry No.';
        }
        field(3;"Customer No.";Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer;
        }
        field(4;"Posting Date";Date)
        {
            Caption = 'Posting Date';
        }
        field(5;"Document Type";Option)
        {
            Caption = 'Document Type';
            OptionCaption = ' ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund';
            OptionMembers = " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund;
        }
        field(6;"Document No.";Code[20])
        {
            Caption = 'Document No.';

            trigger OnLookup()
            var
                IncomingDocument: Record "130";
            begin
                IncomingDocument.HyperlinkToDocument("Document No.","Posting Date");
            end;
        }
        field(7;Description;Text[50])
        {
            Caption = 'Description';
        }
        field(11;"Currency Code";Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(13;Amount;Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = Sum("Detailed Cust. Ledg. Entry".Amount WHERE (Cust. Ledger Entry No.=FIELD(Entry No.),
                                                                         Entry Type=FILTER(Initial Entry|Unrealized Loss|Unrealized Gain|Realized Loss|Realized Gain|Payment Discount|'Payment Discount (VAT Excl.)'|'Payment Discount (VAT Adjustment)'|Correction of Remaining Amount|Payment Tolerance|Payment Discount Tolerance|'Payment Tolerance (VAT Excl.)'|'Payment Tolerance (VAT Adjustment)'|'Payment Discount Tolerance (VAT Excl.)'|'Payment Discount Tolerance (VAT Adjustment)'),
                                                                         Posting Date=FIELD(Date Filter)));
            Caption = 'Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(14;"Remaining Amount";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = Sum("Detailed Cust. Ledg. Entry".Amount WHERE (Cust. Ledger Entry No.=FIELD(Entry No.),
                                                                         Posting Date=FIELD(Date Filter)));
            Caption = 'Remaining Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(15;"Original Amt. (LCY)";Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" WHERE (Cust. Ledger Entry No.=FIELD(Entry No.),
                                                                                 Entry Type=FILTER(Initial Entry),
                                                                                 Posting Date=FIELD(Date Filter)));
            Caption = 'Original Amt. (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(16;"Remaining Amt. (LCY)";Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" WHERE (Cust. Ledger Entry No.=FIELD(Entry No.),
                                                                                 Posting Date=FIELD(Date Filter)));
            Caption = 'Remaining Amt. (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(17;"Amount (LCY)";Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" WHERE (Cust. Ledger Entry No.=FIELD(Entry No.),
                                                                                 Entry Type=FILTER(Initial Entry|Unrealized Loss|Unrealized Gain|Realized Loss|Realized Gain|Payment Discount|'Payment Discount (VAT Excl.)'|'Payment Discount (VAT Adjustment)'|Correction of Remaining Amount|Payment Tolerance|Payment Discount Tolerance|'Payment Tolerance (VAT Excl.)'|'Payment Tolerance (VAT Adjustment)'|'Payment Discount Tolerance (VAT Excl.)'|'Payment Discount Tolerance (VAT Adjustment)'),
                                                                                 Posting Date=FIELD(Date Filter)));
            Caption = 'Amount (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(18;"Sales (LCY)";Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Sales (LCY)';
        }
        field(19;"Profit (LCY)";Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Profit (LCY)';
        }
        field(20;"Inv. Discount (LCY)";Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Inv. Discount (LCY)';
        }
        field(21;"Sell-to Customer No.";Code[20])
        {
            Caption = 'Sell-to Customer No.';
            TableRelation = Customer;
        }
        field(22;"Customer Posting Group";Code[10])
        {
            Caption = 'Customer Posting Group';
            TableRelation = "Customer Posting Group";
        }
        field(23;"Global Dimension 1 Code";Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
        }
        field(24;"Global Dimension 2 Code";Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
        }
        field(25;"Salesperson Code";Code[10])
        {
            Caption = 'Salesperson Code';
            TableRelation = Salesperson/Purchaser;
        }
        field(27;"User ID";Code[50])
        {
            Caption = 'User ID';
            TableRelation = User."User Name";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnLookup()
            var
                UserMgt: Codeunit "418";
            begin
                UserMgt.LookupUserID("User ID");
            end;
        }
        field(28;"Source Code";Code[10])
        {
            Caption = 'Source Code';
            TableRelation = "Source Code";
        }
        field(33;"On Hold";Code[3])
        {
            Caption = 'On Hold';
        }
        field(34;"Applies-to Doc. Type";Option)
        {
            Caption = 'Applies-to Doc. Type';
            OptionCaption = ' ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund';
            OptionMembers = " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund;
        }
        field(35;"Applies-to Doc. No.";Code[20])
        {
            Caption = 'Applies-to Doc. No.';
        }
        field(36;Open;Boolean)
        {
            Caption = 'Open';
        }
        field(37;"Due Date";Date)
        {
            Caption = 'Due Date';

            trigger OnValidate()
            var
                ReminderEntry: Record "300";
                ReminderIssue: Codeunit "393";
            begin
                TESTFIELD(Open,TRUE);
                IF "Due Date" <> xRec."Due Date" THEN BEGIN
                  ReminderEntry.SETCURRENTKEY("Customer Entry No.",Type);
                  ReminderEntry.SETRANGE("Customer Entry No.","Entry No.");
                  ReminderEntry.SETRANGE(Type,ReminderEntry.Type::Reminder);
                  ReminderEntry.SETRANGE("Reminder Level","Last Issued Reminder Level");
                  IF ReminderEntry.FINDLAST THEN
                    ReminderIssue.ChangeDueDate(ReminderEntry,"Due Date",xRec."Due Date");
                END;
            end;
        }
        field(38;"Pmt. Discount Date";Date)
        {
            Caption = 'Pmt. Discount Date';

            trigger OnValidate()
            begin
                TESTFIELD(Open,TRUE);
            end;
        }
        field(39;"Original Pmt. Disc. Possible";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Original Pmt. Disc. Possible';
            Editable = false;
        }
        field(40;"Pmt. Disc. Given (LCY)";Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Pmt. Disc. Given (LCY)';
        }
        field(43;Positive;Boolean)
        {
            Caption = 'Positive';
        }
        field(44;"Closed by Entry No.";Integer)
        {
            Caption = 'Closed by Entry No.';
            TableRelation = "Cust. Ledger Entry";
        }
        field(45;"Closed at Date";Date)
        {
            Caption = 'Closed at Date';
        }
        field(46;"Closed by Amount";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Closed by Amount';
        }
        field(47;"Applies-to ID";Code[50])
        {
            Caption = 'Applies-to ID';

            trigger OnValidate()
            begin
                TESTFIELD(Open,TRUE);
            end;
        }
        field(49;"Journal Batch Name";Code[10])
        {
            Caption = 'Journal Batch Name';
        }
        field(50;"Reason Code";Code[10])
        {
            Caption = 'Reason Code';
            TableRelation = "Reason Code";
        }
        field(51;"Bal. Account Type";Option)
        {
            Caption = 'Bal. Account Type';
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset";
        }
        field(52;"Bal. Account No.";Code[20])
        {
            Caption = 'Bal. Account No.';
            TableRelation = IF (Bal. Account Type=CONST(G/L Account)) "G/L Account"
                            ELSE IF (Bal. Account Type=CONST(Customer)) Customer
                            ELSE IF (Bal. Account Type=CONST(Vendor)) Vendor
                            ELSE IF (Bal. Account Type=CONST(Bank Account)) "Bank Account"
                            ELSE IF (Bal. Account Type=CONST(Fixed Asset)) "Fixed Asset";
        }
        field(53;"Transaction No.";Integer)
        {
            Caption = 'Transaction No.';
        }
        field(54;"Closed by Amount (LCY)";Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Closed by Amount (LCY)';
        }
        field(58;"Debit Amount";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            BlankZero = true;
            CalcFormula = Sum("Detailed Cust. Ledg. Entry"."Debit Amount" WHERE (Cust. Ledger Entry No.=FIELD(Entry No.),
                                                                                 Entry Type=FILTER(Initial Entry|Unrealized Loss|Unrealized Gain|Realized Loss|Realized Gain|Payment Discount|'Payment Discount (VAT Excl.)'|'Payment Discount (VAT Adjustment)'|Correction of Remaining Amount|Payment Tolerance|Payment Discount Tolerance|'Payment Tolerance (VAT Excl.)'|'Payment Tolerance (VAT Adjustment)'|'Payment Discount Tolerance (VAT Excl.)'|'Payment Discount Tolerance (VAT Adjustment)'),
                                                                                 Posting Date=FIELD(Date Filter)));
            Caption = 'Debit Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(59;"Credit Amount";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            BlankZero = true;
            CalcFormula = Sum("Detailed Cust. Ledg. Entry"."Credit Amount" WHERE (Cust. Ledger Entry No.=FIELD(Entry No.),
                                                                                  Entry Type=FILTER(Initial Entry|Unrealized Loss|Unrealized Gain|Realized Loss|Realized Gain|Payment Discount|'Payment Discount (VAT Excl.)'|'Payment Discount (VAT Adjustment)'|Correction of Remaining Amount|Payment Tolerance|Payment Discount Tolerance|'Payment Tolerance (VAT Excl.)'|'Payment Tolerance (VAT Adjustment)'|'Payment Discount Tolerance (VAT Excl.)'|'Payment Discount Tolerance (VAT Adjustment)'),
                                                                                  Posting Date=FIELD(Date Filter)));
            Caption = 'Credit Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(60;"Debit Amount (LCY)";Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
            CalcFormula = Sum("Detailed Cust. Ledg. Entry"."Debit Amount (LCY)" WHERE (Cust. Ledger Entry No.=FIELD(Entry No.),
                                                                                       Entry Type=FILTER(Initial Entry|Unrealized Loss|Unrealized Gain|Realized Loss|Realized Gain|Payment Discount|'Payment Discount (VAT Excl.)'|'Payment Discount (VAT Adjustment)'|Correction of Remaining Amount|Payment Tolerance|Payment Discount Tolerance|'Payment Tolerance (VAT Excl.)'|'Payment Tolerance (VAT Adjustment)'|'Payment Discount Tolerance (VAT Excl.)'|'Payment Discount Tolerance (VAT Adjustment)'),
                                                                                       Posting Date=FIELD(Date Filter)));
            Caption = 'Debit Amount (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(61;"Credit Amount (LCY)";Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
            CalcFormula = Sum("Detailed Cust. Ledg. Entry"."Credit Amount (LCY)" WHERE (Cust. Ledger Entry No.=FIELD(Entry No.),
                                                                                        Entry Type=FILTER(Initial Entry|Unrealized Loss|Unrealized Gain|Realized Loss|Realized Gain|Payment Discount|'Payment Discount (VAT Excl.)'|'Payment Discount (VAT Adjustment)'|Correction of Remaining Amount|Payment Tolerance|Payment Discount Tolerance|'Payment Tolerance (VAT Excl.)'|'Payment Tolerance (VAT Adjustment)'|'Payment Discount Tolerance (VAT Excl.)'|'Payment Discount Tolerance (VAT Adjustment)'),
                                                                                        Posting Date=FIELD(Date Filter)));
            Caption = 'Credit Amount (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(62;"Document Date";Date)
        {
            Caption = 'Document Date';
        }
        field(63;"External Document No.";Code[35])
        {
            Caption = 'External Document No.';
        }
        field(64;"Calculate Interest";Boolean)
        {
            Caption = 'Calculate Interest';
        }
        field(65;"Closing Interest Calculated";Boolean)
        {
            Caption = 'Closing Interest Calculated';
        }
        field(66;"No. Series";Code[10])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series";
        }
        field(67;"Closed by Currency Code";Code[10])
        {
            Caption = 'Closed by Currency Code';
            TableRelation = Currency;
        }
        field(68;"Closed by Currency Amount";Decimal)
        {
            AutoFormatExpression = "Closed by Currency Code";
            AutoFormatType = 1;
            Caption = 'Closed by Currency Amount';
        }
        field(73;"Adjusted Currency Factor";Decimal)
        {
            Caption = 'Adjusted Currency Factor';
            DecimalPlaces = 0:15;
        }
        field(74;"Original Currency Factor";Decimal)
        {
            Caption = 'Original Currency Factor';
            DecimalPlaces = 0:15;
        }
        field(75;"Original Amount";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = Sum("Detailed Cust. Ledg. Entry".Amount WHERE (Cust. Ledger Entry No.=FIELD(Entry No.),
                                                                         Entry Type=FILTER(Initial Entry),
                                                                         Posting Date=FIELD(Date Filter)));
            Caption = 'Original Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(76;"Date Filter";Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(77;"Remaining Pmt. Disc. Possible";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Remaining Pmt. Disc. Possible';

            trigger OnValidate()
            begin
                TESTFIELD(Open,TRUE);
                CALCFIELDS(Amount,"Original Amount");

                IF "Remaining Pmt. Disc. Possible" * Amount < 0 THEN
                  FIELDERROR("Remaining Pmt. Disc. Possible",STRSUBSTNO(Text000,FIELDCAPTION(Amount)));

                IF ABS("Remaining Pmt. Disc. Possible") > ABS("Original Amount") THEN
                  FIELDERROR("Remaining Pmt. Disc. Possible",STRSUBSTNO(Text001,FIELDCAPTION("Original Amount")));
            end;
        }
        field(78;"Pmt. Disc. Tolerance Date";Date)
        {
            Caption = 'Pmt. Disc. Tolerance Date';

            trigger OnValidate()
            begin
                TESTFIELD(Open,TRUE);
            end;
        }
        field(79;"Max. Payment Tolerance";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Max. Payment Tolerance';

            trigger OnValidate()
            begin
                TESTFIELD(Open,TRUE);
                CALCFIELDS(Amount,"Remaining Amount");

                IF "Max. Payment Tolerance" * Amount < 0 THEN
                  FIELDERROR("Max. Payment Tolerance",STRSUBSTNO(Text000,FIELDCAPTION(Amount)));

                IF ABS("Max. Payment Tolerance") > ABS("Remaining Amount") THEN
                  FIELDERROR("Max. Payment Tolerance",STRSUBSTNO(Text001,FIELDCAPTION("Remaining Amount")));
            end;
        }
        field(80;"Last Issued Reminder Level";Integer)
        {
            Caption = 'Last Issued Reminder Level';
        }
        field(81;"Accepted Payment Tolerance";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Accepted Payment Tolerance';
        }
        field(82;"Accepted Pmt. Disc. Tolerance";Boolean)
        {
            Caption = 'Accepted Pmt. Disc. Tolerance';
        }
        field(83;"Pmt. Tolerance (LCY)";Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Pmt. Tolerance (LCY)';
        }
        field(84;"Amount to Apply";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Amount to Apply';

            trigger OnValidate()
            begin
                TESTFIELD(Open,TRUE);
                CALCFIELDS("Remaining Amount");

                IF "Amount to Apply" * "Remaining Amount" < 0 THEN
                  FIELDERROR("Amount to Apply",STRSUBSTNO(Text000,FIELDCAPTION("Remaining Amount")));

                IF ABS("Amount to Apply") > ABS("Remaining Amount") THEN
                  FIELDERROR("Amount to Apply",STRSUBSTNO(Text001,FIELDCAPTION("Remaining Amount")));
            end;
        }
        field(85;"IC Partner Code";Code[20])
        {
            Caption = 'IC Partner Code';
            TableRelation = "IC Partner";
        }
        field(86;"Applying Entry";Boolean)
        {
            Caption = 'Applying Entry';
        }
        field(87;Reversed;Boolean)
        {
            BlankZero = true;
            Caption = 'Reversed';
        }
        field(88;"Reversed by Entry No.";Integer)
        {
            BlankZero = true;
            Caption = 'Reversed by Entry No.';
            TableRelation = "Cust. Ledger Entry";
        }
        field(89;"Reversed Entry No.";Integer)
        {
            BlankZero = true;
            Caption = 'Reversed Entry No.';
            TableRelation = "Cust. Ledger Entry";
        }
        field(90;Prepayment;Boolean)
        {
            Caption = 'Prepayment';
        }
        field(172;"Payment Method Code";Code[10])
        {
            Caption = 'Payment Method Code';
            TableRelation = "Payment Method";
        }
        field(173;"Applies-to Ext. Doc. No.";Code[35])
        {
            Caption = 'Applies-to Ext. Doc. No.';
        }
        field(288;"Recipient Bank Account";Code[10])
        {
            Caption = 'Recipient Bank Account';
            TableRelation = "Customer Bank Account".Code WHERE (Customer No.=FIELD(Customer No.));
        }
        field(289;"Message to Recipient";Text[70])
        {
            Caption = 'Message to Recipient';

            trigger OnValidate()
            begin
                TESTFIELD(Open,TRUE);
            end;
        }
        field(290;"Exported to Payment File";Boolean)
        {
            Caption = 'Exported to Payment File';
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
        field(1200;"Direct Debit Mandate ID";Code[35])
        {
            Caption = 'Direct Debit Mandate ID';
            TableRelation = "SEPA Direct Debit Mandate" WHERE (Customer No.=FIELD(Customer No.));
        }
        field(51620;_Adjustment;Boolean)
        {
            Caption = 'Adjustment';
        }
        field(51621;"_BAS Adjustment";Boolean)
        {
            Caption = 'BAS Adjustment';
        }
        field(51626;"_Adjustment Applies-to";Code[20])
        {
            Caption = 'Adjustment Applies-to';
        }
        field(51628;"_Pre Adjmt. Reason Code";Code[10])
        {
            Caption = 'Pre Adjmt. Reason Code';
            TableRelation = "Reason Code";
        }
        field(58040;"_Rem. Amt for WHT";Decimal)
        {
            Caption = 'Rem. Amt for WHT';
        }
        field(58041;"_Rem. Amt";Decimal)
        {
            Caption = 'Rem. Amt';
        }
        field(58042;"_WHT Amount";Decimal)
        {
            Caption = 'WHT Amount';
            Editable = false;
        }
        field(58043;"_WHT Amount (LCY)";Decimal)
        {
            Caption = 'WHT Amount (LCY)';
            Editable = false;
        }
        field(58044;"_WHT Payment";Boolean)
        {
            Caption = 'WHT Payment';
        }
    }

    keys
    {
        key(Key1;"Entry No.")
        {
        }
        key(Key2;"Customer No.","Posting Date","Currency Code")
        {
            SumIndexFields = "Sales (LCY)","Profit (LCY)","Inv. Discount (LCY)";
        }
        key(Key3;"Document No.")
        {
        }
        key(Key4;"External Document No.")
        {
        }
        key(Key5;"Customer No.",Open,Positive,"Due Date","Currency Code")
        {
        }
        key(Key6;Open,"Due Date")
        {
        }
        key(Key7;"Document Type","Customer No.","Posting Date","Currency Code")
        {
            MaintainSIFTIndex = false;
            MaintainSQLIndex = false;
            SumIndexFields = "Sales (LCY)","Profit (LCY)","Inv. Discount (LCY)";
        }
        key(Key8;"Salesperson Code","Posting Date")
        {
        }
        key(Key9;"Closed by Entry No.")
        {
        }
        key(Key10;"Transaction No.")
        {
        }
        key(Key11;"Customer No.","Applies-to ID",Open,Positive,"Due Date")
        {
        }
        key(Key12;"Document Type","Closed at Date")
        {
        }
        key(Key13;"Document Type","Posting Date")
        {
        }
        key(Key14;"Document Type","Closed at Date","Sell-to Customer No.","Journal Batch Name")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown;"Entry No.",Description,"Customer No.","Posting Date","Document Type","Document No.")
        {
        }
    }

    var
        Text000: Label 'must have the same sign as %1';
        Text001: Label 'must not be larger than %1';

    procedure DrillDownOnEntries(var DtldCustLedgEntry: Record "379")
    var
        CustLedgEntry: Record "21";
    begin
        CustLedgEntry.RESET;
        DtldCustLedgEntry.COPYFILTER("Customer No.",CustLedgEntry."Customer No.");
        DtldCustLedgEntry.COPYFILTER("Currency Code",CustLedgEntry."Currency Code");
        DtldCustLedgEntry.COPYFILTER("Initial Entry Global Dim. 1",CustLedgEntry."Global Dimension 1 Code");
        DtldCustLedgEntry.COPYFILTER("Initial Entry Global Dim. 2",CustLedgEntry."Global Dimension 2 Code");
        CustLedgEntry.SETCURRENTKEY("Customer No.","Posting Date");
        CustLedgEntry.SETRANGE(Open,TRUE);
        PAGE.RUN(0,CustLedgEntry);
    end;

    procedure DrillDownOnOverdueEntries(var DtldCustLedgEntry: Record "379")
    var
        CustLedgEntry: Record "21";
    begin
        CustLedgEntry.RESET;
        DtldCustLedgEntry.COPYFILTER("Customer No.",CustLedgEntry."Customer No.");
        DtldCustLedgEntry.COPYFILTER("Currency Code",CustLedgEntry."Currency Code");
        DtldCustLedgEntry.COPYFILTER("Initial Entry Global Dim. 1",CustLedgEntry."Global Dimension 1 Code");
        DtldCustLedgEntry.COPYFILTER("Initial Entry Global Dim. 2",CustLedgEntry."Global Dimension 2 Code");
        CustLedgEntry.SETCURRENTKEY("Customer No.","Posting Date");
        CustLedgEntry.SETFILTER("Date Filter",'..%1',WORKDATE);
        CustLedgEntry.SETFILTER("Due Date",'<%1',WORKDATE);
        CustLedgEntry.SETFILTER("Remaining Amount",'<>%1',0);
        PAGE.RUN(0,CustLedgEntry);
    end;

    procedure GetOriginalCurrencyFactor(): Decimal
    begin
        IF "Original Currency Factor" = 0 THEN
          EXIT(1);
        EXIT("Original Currency Factor");
    end;

    procedure ShowDimensions()
    var
        DimMgt: Codeunit "408";
    begin
        DimMgt.ShowDimensionSet("Dimension Set ID",STRSUBSTNO('%1 %2',TABLECAPTION,"Entry No."));
    end;

    procedure SetStyle(): Text
    begin
        IF Open THEN BEGIN
          IF WORKDATE > "Due Date" THEN
            EXIT('Unfavorable')
        END ELSE
          IF "Closed at Date" > "Due Date" THEN
            EXIT('Attention');
        EXIT('');
    end;

    procedure CopyFromGenJnlLine(GenJnlLine: Record "81")
    begin
        "Customer No." := GenJnlLine."Account No.";
        "Posting Date" := GenJnlLine."Posting Date";
        "Document Date" := GenJnlLine."Document Date";
        "Document Type" := GenJnlLine."Document Type";
        "Document No." := GenJnlLine."Document No.";
        "External Document No." := GenJnlLine."External Document No.";
        Description := GenJnlLine.Description;
        "Currency Code" := GenJnlLine."Currency Code";
        "Sales (LCY)" := GenJnlLine."Sales/Purch. (LCY)";
        "Profit (LCY)" := GenJnlLine."Profit (LCY)";
        "Inv. Discount (LCY)" := GenJnlLine."Inv. Discount (LCY)";
        "Sell-to Customer No." := GenJnlLine."Sell-to/Buy-from No.";
        "Customer Posting Group" := GenJnlLine."Posting Group";
        "Global Dimension 1 Code" := GenJnlLine."Shortcut Dimension 1 Code";
        "Global Dimension 2 Code" := GenJnlLine."Shortcut Dimension 2 Code";
        "Dimension Set ID" := GenJnlLine."Dimension Set ID";
        "Salesperson Code" := GenJnlLine."Salespers./Purch. Code";
        "Source Code" := GenJnlLine."Source Code";
        "On Hold" := GenJnlLine."On Hold";
        "Applies-to Doc. Type" := GenJnlLine."Applies-to Doc. Type";
        "Applies-to Doc. No." := GenJnlLine."Applies-to Doc. No.";
        "Due Date" := GenJnlLine."Due Date";
        "Pmt. Discount Date" := GenJnlLine."Pmt. Discount Date";
        "Applies-to ID" := GenJnlLine."Applies-to ID";
        "Journal Batch Name" := GenJnlLine."Journal Batch Name";
        "Reason Code" := GenJnlLine."Reason Code";
        "Direct Debit Mandate ID" := GenJnlLine."Direct Debit Mandate ID";
        "User ID" := USERID;
        "Bal. Account Type" := GenJnlLine."Bal. Account Type";
        "Bal. Account No." := GenJnlLine."Bal. Account No.";
        "No. Series" := GenJnlLine."Posting No. Series";
        "IC Partner Code" := GenJnlLine."IC Partner Code";
        Prepayment := GenJnlLine.Prepayment;
        "Recipient Bank Account" := GenJnlLine."Recipient Bank Account";
        "Message to Recipient" := GenJnlLine."Message to Recipient";
        "Applies-to Ext. Doc. No." := GenJnlLine."Applies-to Ext. Doc. No.";
        "Payment Method Code" := GenJnlLine."Payment Method Code";
        "Exported to Payment File" := GenJnlLine."Exported to Payment File";
    end;

    procedure RecalculateAmounts(FromCurrencyCode: Code[10];ToCurrencyCode: Code[10];PostingDate: Date)
    var
        CurrExchRate: Record "330";
    begin
        IF ToCurrencyCode = FromCurrencyCode THEN
          EXIT;

        "Remaining Amount" :=
          CurrExchRate.ExchangeAmount("Remaining Amount",FromCurrencyCode,ToCurrencyCode,PostingDate);
        "Remaining Pmt. Disc. Possible" :=
          CurrExchRate.ExchangeAmount("Remaining Pmt. Disc. Possible",FromCurrencyCode,ToCurrencyCode,PostingDate);
        "Accepted Payment Tolerance" :=
          CurrExchRate.ExchangeAmount("Accepted Payment Tolerance",FromCurrencyCode,ToCurrencyCode,PostingDate);
        "Amount to Apply" :=
          CurrExchRate.ExchangeAmount("Amount to Apply",FromCurrencyCode,ToCurrencyCode,PostingDate);
    end;
}

