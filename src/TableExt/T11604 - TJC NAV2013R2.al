table 11604 "BAS Calc. Sheet Entry"
{
    Caption = 'BAS Calc. Sheet Entry';
    DataPerCompany = false;
    DrillDownPageID = 11606;
    LookupPageID = 11606;

    fields
    {
        field(1;"Company Name";Text[30])
        {
            Caption = 'Company Name';
            TableRelation = Company;
        }
        field(2;"BAS Document No.";Code[11])
        {
            Caption = 'BAS Document No.';
        }
        field(3;"BAS Version";Integer)
        {
            Caption = 'BAS Version';
        }
        field(4;"Field Label No.";Text[30])
        {
            Caption = 'Field Label No.';
        }
        field(5;Amount;Decimal)
        {
            Caption = 'Amount';
        }
        field(6;"Entry No.";Integer)
        {
            Caption = 'Entry No.';

            trigger OnLookup()
            var
                GLEntry: Record "17";
                VATEntry: Record "254";
                Text000: Label 'You cannot lookup consolidated entries.';
            begin
                IF "Company Name" = COMPANYNAME THEN BEGIN
                  CASE Type OF
                    Type::"G/L Entry":
                      BEGIN
                        GLEntry.CHANGECOMPANY("Company Name");
                        GLEntry.SETRANGE("Entry No.","Entry No.");
                        //FORM.RUNMODAL(FORM::Page20,GLEntry);
                        PAGE.RUNMODAL(PAGE::"General Ledger Entries",GLEntry);
                      END;
                    Type::"GST Entry":
                      BEGIN
                        VATEntry.CHANGECOMPANY("Company Name");
                        VATEntry.SETRANGE("Entry No.","Entry No.");
                        PAGE.RUNMODAL(PAGE::"VAT Entries",VATEntry);
                      END;
                  END;
                END ELSE
                  MESSAGE(Text000);
            end;
        }
        field(7;Type;Option)
        {
            Caption = 'Type';
            OptionCaption = 'G/L Entry,GST Entry';
            OptionMembers = "G/L Entry","GST Entry";
        }
        field(8;"Amount Type";Option)
        {
            Caption = 'Amount Type';
            OptionCaption = ' ,Amount,Base,Unrealised Amount,Unrealised Base,GST Amount';
            OptionMembers = " ",Amount,Base,"Unrealized Amount","Unrealized Base","GST Amount";
        }
        field(10;"Consol. BAS Doc. No.";Code[11])
        {
            Caption = 'Consol. BAS Doc. No.';
        }
        field(11;"Consol. Version No.";Integer)
        {
            Caption = 'Consol. Version No.';
        }
        field(12;"Gen. Posting Type";Option)
        {
            Caption = 'Gen. Posting Type';
            OptionCaption = ' ,Purchase,Sale,Settlement';
            OptionMembers = " ",Purchase,Sale,Settlement;
        }
        field(13;"GST Bus. Posting Group";Code[10])
        {
            Caption = 'GST Bus. Posting Group';
        }
        field(14;"GST Prod. Posting Group";Code[10])
        {
            Caption = 'GST Prod. Posting Group';
        }
        field(15;"BAS Adjustment";Boolean)
        {
            Caption = 'BAS Adjustment';
        }
    }

    keys
    {
        key(Key1;"Company Name","BAS Document No.","BAS Version","Field Label No.",Type,"Entry No.","Amount Type")
        {
            SumIndexFields = Amount;
        }
        key(Key2;"Consol. BAS Doc. No.","Consol. Version No.")
        {
        }
        key(Key3;"Company Name","BAS Document No.","BAS Version","Field Label No.","GST Bus. Posting Group","GST Prod. Posting Group","BAS Adjustment")
        {
        }
        key(Key4;"Company Name",Type,"Entry No.","BAS Document No.","BAS Version")
        {
        }
    }

    fieldgroups
    {
    }
}

