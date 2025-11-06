// codeunit 50020 "Test Codeunit 3"
// {

//     trigger OnRun()
//     var
//         LTrackingSpec: Record "336";
//     begin
//         /*
//         MyUserID := USERID;
//         MESSAGE('User ID: %1',MyUserID);
//         */
//         /*
//         Tongue1.RESET;
//         IF Tongue1.FINDSET THEN
//           REPEAT
//             _Tongue1.INIT;
//             _Tongue1.TRANSFERFIELDS(Tongue1);
//             _Tongue1.INSERT;
//           UNTIL Tongue1.NEXT = 0;
//         */
//         /*
//         LineNo := 0;
//         _Tongue1.RESET;
//         IF _Tongue1.FINDSET THEN
//           REPEAT
//             LineNo += 1;
//             _Tongue1."No." := LineNo;
//             _Tongue1.MODIFY;
//           UNTIL _Tongue1.NEXT = 0;
//         */
//         /*
//         CLEAR (FileManagement);
//         FileName := FileManagement.OpenFileDialog(Text000,FileName,FileManagement.GetToFilterText('','.xlsx'));
//         ExcelBuffer.OpenBook(FileName,'Sheet1');
//         ExcelBuffer.ReadSheet();

//         IF ExcelBuffer.FINDFIRST THEN
//           REPEAT
//             MessageValue := MessageValue + ExcelBuffer."Cell Value as Text" + '\';
//           UNTIL ExcelBuffer.NEXT = 0;

//         MESSAGE(MessageValue);
//         */
//         /*
//         LTrackingSpec.RESET;
//         IF LTrackingSpec.GET(2289121) THEN BEGIN
//           TrackingSpec.INIT;
//           TrackingSpec.TRANSFERFIELDS(LTrackingSpec);
//           TrackingSpec."Entry No." := 2289124;
//           TrackingSpec."Lot No." := 'LE10030';
//           TrackingSpec."Source ID" := 'OR14/10969';
//           TrackingSpec."Creation Date" := 141014D;
//           TrackingSpec.INSERT;
//         END;
//         */
//         TrackingSpec.RESET;
//         IF TrackingSpec.GET(2289124) THEN BEGIN
//           TrackingSpec."Item Ledger Entry No." := 2289124;
//           TrackingSpec.MODIFY;
//         END;

//     end;

//     var
//         Tongue1: Record "50007";
//         ExcelBuffer: Record "370";
//         TrackingSpec: Record "336";
//         FileManagement: Codeunit "419";
//         MyUserID: Code[20];
//         LineNo: Integer;
//         FileName: Text[250];
//         Text000: Label 'Import from Excel File';
//         MessageValue: Text[1024];
// }

