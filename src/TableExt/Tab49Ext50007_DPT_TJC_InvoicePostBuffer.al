tableextension 50007 "Invoice Post. Buffer" extends "Invoice Posting Buffer"
{
    // DP.NCM TJC #449 04/04/2018 - Add field 50000 Line Description

    fields
    {
        field(50000; "Line Description"; Text[250])
        {
        }
    }
}

