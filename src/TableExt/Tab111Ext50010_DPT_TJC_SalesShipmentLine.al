tableextension 50010 "Sales Shipment Line" extends "Sales Shipment Line"
{
    // TJCRMS1.00
    // #1 26/03/2009  DP.SWJ
    //    - Populate three fields from Sales Line to Sales Invoice Line
    //   DP.NCM TJC DD 299 18032015 - Bring Bin Code over from Shipment Line
    fields
    {
        field(50000; "Disc. Reason Code"; Code[10])
        {
            TableRelation = "Return Reason";
        }
        field(50001; "Cashier Code"; Code[10])
        {
            TableRelation = "Salesperson/Purchaser".Code WHERE(Type = CONST(Others));
        }
        field(50002; "Doctor Code"; Code[10])
        {
            TableRelation = "Salesperson/Purchaser".Code WHERE(Type = CONST(Others));
        }
    }
}