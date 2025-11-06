codeunit 50008 "Report Management"
{

    trigger OnRun()
    begin
    end;

    var
        Text001: Label 'Amounts are in whole 10s';
        Text002: Label 'Amounts are in whole 100s';
        Text003: Label 'Amounts are in whole 1,000s';
        Text004: Label 'Amounts are in whole 100,000s';
        Text005: Label 'Amounts are in whole 1,000,000s';
        Text006: Label 'Amounts are not rounded';

    procedure RoundAmount(Amount: Decimal;Rounding: Option " ",Tens,Hundreds,Thousands,"Hundred Thousands",Millions): Decimal
    begin
        CASE Rounding OF
          Rounding::" ":
            EXIT(Amount);
          Rounding::Tens:
            EXIT(ROUND(Amount / 10,0.1));
          Rounding::Hundreds:
            EXIT(ROUND(Amount / 100,0.1));
          Rounding::Thousands:
            EXIT(ROUND(Amount / 1000,0.1));
          Rounding::"Hundred Thousands":
            EXIT(ROUND(Amount / 100000,0.1));
          Rounding::Millions:
            EXIT(ROUND(Amount / 1000000,0.1));
        END;
    end;

    procedure RoundDescription(Rounding: Option " ",Tens,Hundreds,Thousands,"Hundred Thousands",Millions): Text[50]
    begin
        CASE Rounding OF
          Rounding::" ":
            EXIT(Text006);
          Rounding::Tens:
            EXIT(Text001);
          Rounding::Hundreds:
            EXIT(Text002);
          Rounding::Thousands:
            EXIT(Text003);
          Rounding::"Hundred Thousands":
            EXIT(Text004);
          Rounding::Millions:
            EXIT(Text005);
        END;
    end;
}

