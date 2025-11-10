tableextension 50012 "Sales Invoice Line" extends "Sales Invoice Line"
{
    // TJCRMS1.00
    // #1 26/03/2009  DP.SWJ
    //    - Populate three fields from Sales Line to Sales Invoice Line
    // Version No.         : TJCSG1.00
    // Developer           : DP.AYD
    // Init. DEV. Date     : 03/06/2014
    // Date of last Change : 03/06/2014
    // Description         : Based on DD#125 https://dptech.mydonedone.com/issuetracker/projects/4350/issues/125
    // 
    // 1. Add Keys :
    //    - Document No.,No.,Doctor Code
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