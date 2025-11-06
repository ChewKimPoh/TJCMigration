// report 50041 "Data Patch ILE"
// {
//     DefaultLayout = RDLC;
//     RDLCLayout = './Data Patch ILE.rdlc';
//     Permissions = TableData 32=rimd;

//     dataset
//     {
//     }

//     requestpage
//     {

//         layout
//         {
//         }

//         actions
//         {
//         }
//     }

//     labels
//     {
//     }

//     trigger OnPostReport()
//     var
//         rILE: Record "32";
//     begin
//         /*
//         Need data patch for Item Ledger Entry
//         - Reamaining Quantity = 6
//         - Open = Yes
//         Item Ledger Entry No.
//         - 3909760|4007338
//         */
//         rILE.RESET;
//         rILE.SETRANGE("Entry No.",3909760);
//         IF rILE.FINDFIRST THEN BEGIN
//           rILE.Open := TRUE;
//           rILE."Remaining Quantity" := 6;
//           rILE.MODIFY(FALSE);
//         END;
//         rILE.RESET;
//         rILE.SETRANGE("Entry No.",4007338);
//         IF rILE.FINDFIRST THEN BEGIN
//           rILE.Open := TRUE;
//           rILE."Remaining Quantity" := 6;
//           rILE.MODIFY(FALSE);
//         END;
//         MESSAGE('Done');

//     end;
// }

