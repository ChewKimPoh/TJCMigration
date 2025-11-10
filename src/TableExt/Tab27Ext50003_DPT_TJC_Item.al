tableextension 50003 Item extends Item
{
    // DP.NCM TJC #11 11/04/2019 add field 50005 English Translation
    fields
    {
        field(50000; Clinic; Boolean)
        {
            Description = 'For Patient System';
        }
        field(50001; Retail; Boolean)
        {
            Description = 'For Patient System';
        }
        field(50002; "Clinic Item Category Code"; Code[10])
        {
            Description = 'For Patient System';
            TableRelation = "Item Category" WHERE(Clinic = CONST(true));
        }
        field(50003; "Clinic Product Category Code"; Code[10])
        {
            Description = 'For Patient System';
            //TableRelation = "Product Group".Code WHERE("Item Category Code" = FIELD("Clinic Item Category Code"));
        }
        field(50004; Usage; Text[100])
        {
            Description = 'For Patient System';
        }
        // field(50005; "English Description"; Text[100])
        // {
        //     CalcFormula = Lookup("Item Translation".Description WHERE("Item No." = FIELD("No."),
        //         "Language Code" = CONST(ENG)));
        //     FieldClass = FlowField;
        // }
    }
}

