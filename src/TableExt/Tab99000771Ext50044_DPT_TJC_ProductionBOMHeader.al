tableextension 50044 "Production BOM Header" extends "Production BOM Header"
{
    fields
    {
        field(50000; "Size/Shape"; Text[50])
        {
            Description = 'DP0001-Additional Information';
        }
        field(50001; Colour; Code[50])
        {
            Description = 'DP0001-Additional Information';
        }
        field(50002; "Theoretical Unit Weight"; Decimal)
        {
            Description = 'DP0001-Additional Information';
        }
        field(50003; Equipments; Text[150])
        {
        }
    }
}

