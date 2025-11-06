// query 50000 "Filtered Cust. Ledger Entry"
// {
//     OrderBy = Ascending(CustLedgEntry_CustNo),Ascending(CustLedgEntry_Posting_Date),Ascending(CustLedgEntry_Open),Ascending(CustLedgEntry_Remaining_Amt);

//     elements
//     {
//         dataitem(QueryElement1000000003;Table21)
//         {
//             DataItemTableFilter = Customer No.=FILTER(<>''),
// Document Type=CONST(Invoice),
// Open=CONST(Yes);
//             column(CustLedgEntry_CustNo;"Customer No.")
//             {
//             }
//             column(CustLedgEntry_Posting_Date;"Posting Date")
//             {
//             }
//             column(CustLedgEntry_Open;Open)
//             {
//             }
//             column(CustLedgEntry_Document_Type;"Document Type")
//             {
//             }
//             column(CustLedgEntry_Document_No;"Document No.")
//             {
//             }
//             column(CustLedgEntry_Currency_Code;"Currency Code")
//             {
//             }
//             column(CustLedgEntry_Amount;Amount)
//             {
//             }
//             column(CustLedgEntry_Remaining_Amt;"Remaining Amount")
//             {
//             }
//             column(CustLedgEntry_Entry_No;"Entry No.")
//             {
//             }
//         }
//     }
// }

