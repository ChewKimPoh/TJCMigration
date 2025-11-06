// codeunit 40 LogInManagement
// {
//     Permissions = TableData 17=r,
//                   TableData 51=rimd;

//     trigger OnRun()
//     begin
//     end;

//     var
//         Text000: Label 'CRONUS', Comment='{Locked} ';
//         Text019: Label 'End User License Agreement has not been accepted.';
//         Text020: Label 'The Go Live date is %1.';
//         Text021: Label 'This is the demonstration company %1\\You can try out program features on the data in the demonstration company before you use the features with your real data.\The work date has been set to %2.';
//         Text022: Label 'You must change password before you can continue.';
//         GLSetup: Record "98";
//         [SecurityFiltering(SecurityFilter::Filtered)]User: Record "2000000120";
//         LogInWorkDate: Date;
//         LogInDate: Date;
//         LogInTime: Time;
//         GLSetupRead: Boolean;

//     procedure CompanyOpen()
//     begin
//         IF GUIALLOWED THEN
//           LogInStart;
//     end;

//     procedure CompanyClose()
//     begin
//         IF GUIALLOWED THEN
//           LogInEnd;
//     end;

//     local procedure LogInStart()
//     var
//         GLSetup: Record "98";
//         GLEntry: Record "17";
//         "Profile": Record "2000000072";
//         Language: Record "2000000045";
//         LicenseAgreement: Record "140";
//         ApplicationManagement: Codeunit "1";
//         CompanyInitialize: Codeunit "2";
//         ConfPersonalizationMgt: Codeunit "9170";
//         IdentityManagement: Codeunit "9801";
//         OK: Boolean;
//     begin
//         IF (STRPOS(COMPANYNAME,Text000) < 1) AND LicenseAgreement.GET THEN
//           IF (TODAY >= LicenseAgreement."Effective Date") AND NOT LicenseAgreement.Accepted THEN BEGIN
//             PAGE.RUNMODAL(PAGE::"License Agreement Accept");
//             LicenseAgreement.GET;
//             IF NOT LicenseAgreement.Accepted THEN
//               MESSAGE(Text019);
//           END ELSE
//             IF TODAY < LicenseAgreement."Effective Date" THEN
//               MESSAGE(Text020,LicenseAgreement."Effective Date");

//         Language.SETRANGE("Localization Exist",TRUE);
//         Language.SETRANGE("Globally Enabled",TRUE);
//         Language."Language ID" := GLOBALLANGUAGE;
//         IF NOT Language.FIND THEN BEGIN
//           Language."Language ID" := WINDOWSLANGUAGE;
//           IF NOT Language.FIND THEN
//             Language."Language ID" := ApplicationManagement.ApplicationLanguage;
//         END;
//         GLOBALLANGUAGE := Language."Language ID";

//         // Check if the logged in user must change login before allowing access.
//         IF 0 <> User.COUNT THEN BEGIN
//           IF IdentityManagement.IsUserNamePasswordAuthentication THEN BEGIN
//             User.SETRANGE("User Security ID",USERSECURITYID);
//             User.FINDFIRST;
//             IF User."Change Password" THEN
//               PAGE.RUNMODAL(PAGE::"Change Password");

//             SELECTLATESTVERSION;
//             User.FINDFIRST;
//             IF User."Change Password" THEN
//               ERROR(Text022);
//           END;
//           User.SETRANGE("User Security ID");
//         END;

//         IF NOT GLSetup.GET THEN BEGIN
//           CompanyInitialize.RUN;
//           COMMIT;
//           CLEAR(CompanyInitialize);
//         END;

//         IF Profile.ISEMPTY THEN BEGIN
//           ConfPersonalizationMgt.RUN;
//           COMMIT;
//           CLEAR(ConfPersonalizationMgt);
//         END;

//         LogInDate := TODAY;
//         LogInTime := TIME;
//         LogInWorkDate := 0D;
//         IF STRPOS(COMPANYNAME,Text000) = 1 THEN
//           IF GLEntry.READPERMISSION THEN BEGIN
//             GLEntry.SETCURRENTKEY("G/L Account No.","Posting Date");
//             OK := TRUE;
//             REPEAT
//               GLEntry.SETFILTER("G/L Account No.",'>%1',GLEntry."G/L Account No.");
//               GLEntry.SETFILTER("Posting Date",'>%1',GLEntry."Posting Date");
//               IF GLEntry.FINDFIRST THEN BEGIN
//                 GLEntry.SETRANGE("G/L Account No.",GLEntry."G/L Account No.");
//                 GLEntry.SETRANGE("Posting Date");
//                 GLEntry.FINDLAST;
//               END ELSE
//                 OK := FALSE
//             UNTIL NOT OK;
//             IF NOT (GLEntry."Posting Date" IN [0D,WORKDATE]) THEN BEGIN
//               IF CURRENTEXECUTIONMODE <> EXECUTIONMODE::Debug THEN
//                 MESSAGE(
//                   Text021,
//                   COMPANYNAME,NORMALDATE(GLEntry."Posting Date"));
//               LogInWorkDate := WORKDATE;
//               WORKDATE := NORMALDATE(GLEntry."Posting Date");
//             END;
//           END;

//         SelectRetailOutlet;
//     end;

//     local procedure LogInEnd()
//     var
//         UserSetup: Record "91";
//         UserTimeRegister: Record "51";
//         LogOutDate: Date;
//         LogOutTime: Time;
//         Minutes: Integer;
//         UserSetupFound: Boolean;
//         RegisterTime: Boolean;
//     begin
//         IF LogInWorkDate <> 0D THEN
//           IF LogInWorkDate = LogInDate THEN
//             WORKDATE := TODAY
//           ELSE
//             WORKDATE := LogInWorkDate;

//         IF USERID <> '' THEN BEGIN
//           IF UserSetup.GET(USERID) THEN BEGIN
//             UserSetupFound := TRUE;
//             RegisterTime := UserSetup."Register Time";
//           END;
//           IF NOT UserSetupFound THEN
//             IF GetGLSetup THEN
//               RegisterTime := GLSetup."Register Time";
//           IF RegisterTime THEN BEGIN
//             LogOutDate := TODAY;
//             LogOutTime := TIME;
//             IF (LogOutDate > LogInDate) OR (LogOutDate = LogInDate) AND (LogOutTime > LogInTime) THEN
//               Minutes := ROUND((1440 * (LogOutDate - LogInDate)) + ((LogOutTime - LogInTime) / 60000),1);
//             IF Minutes = 0 THEN
//               Minutes := 1;
//             UserTimeRegister.INIT;
//             UserTimeRegister."User ID" := USERID;
//             UserTimeRegister.Date := LogInDate;
//             IF UserTimeRegister.FIND THEN BEGIN
//               UserTimeRegister.Minutes := UserTimeRegister.Minutes + Minutes;
//               UserTimeRegister.MODIFY;
//             END ELSE BEGIN
//               UserTimeRegister.Minutes := Minutes;
//               UserTimeRegister.INSERT;
//             END;
//           END;
//         END;
//     end;

//     local procedure GetGLSetup(): Boolean
//     begin
//         IF NOT GLSetupRead THEN
//           GLSetupRead := GLSetup.GET;
//         EXIT(GLSetupRead);
//     end;

//     procedure SelectRetailOutlet()
//     var
//         UserSetup: Record "91";
//         LocationTable: Record "14";
//         LocationPage: Page "15";
//         TempLocationTable: Record "14" temporary;
//     begin
//         IF USERID <> '' THEN BEGIN

//           IF UserSetup.GET(USERID) THEN BEGIN
//             IF UserSetup."Location Code" <> '' THEN BEGIN
//               CLEAR(LocationPage);
//               //LocationPage.Set(TRUE);
//               LocationTable.GET(UserSetup."Location Code");
//               LocationPage.SETRECORD(LocationTable);
//               LocationTable.SETFILTER(Name,'*Retail Outlet');
//               LocationPage.SETTABLEVIEW(LocationTable);
//               LocationPage.LOOKUPMODE(TRUE);
//               IF LocationPage.RUNMODAL = ACTION::LookupOK THEN BEGIN
//                 LocationPage.GETRECORD(LocationTable);

//                 IF UserSetup."Location Code" <> LocationTable.Code THEN BEGIN
//                   UserSetup."Location Code" := LocationTable.Code;
//                   UserSetup.MODIFY(TRUE);
//                 END;

//               END;
//             END;
//           END;

//           /*
//           IF UserSetup.GET(USERID) THEN BEGIN
//             IF UserSetup."Location Code" <> '' THEN BEGIN

//               TempLocationTable.DELETEALL;
//               LocationTable.SETRANGE("Code", UserSetup."Location Code");
//               IF LocationTable.FINDFIRST THEN BEGIN
//                 TempLocationTable := LocationTable;
//                 //MESSAGE(TempLocationTable.Code);
//                 TempLocationTable.INSERT;
//               END;
//               LocationTable.RESET;
//               LocationTable.SETFILTER(Name,'*Retail Outlet');
//               IF LocationTable.FINDFIRST THEN BEGIN
//                 REPEAT
//                   IF LocationTable."Code" <> UserSetup."Location Code" THEN BEGIN
//                     TempLocationTable := LocationTable;
//                     //MESSAGE(TempLocationTable.Code);
//                     TempLocationTable.INSERT;
//                   END;
//                 UNTIL LocationTable.NEXT = 0;
//               END;

//               CLEAR(LocationPage);
//               //LocationPage.Set(TRUE);
//               //LocationTable.SETFILTER(Name,'*Retail Outlet');
//               LocationPage.LOOKUPMODE(TRUE);
//               LocationPage.SETTABLEVIEW(TempLocationTable);
//               IF Page.RUNMODAL(50090, TempLocationTable) = ACTION::LookupOK THEN BEGIN
//                 LocationPage.GETRECORD(TempLocationTable);

//                 IF UserSetup."Location Code" <> TempLocationTable.Code THEN BEGIN
//                   UserSetup."Location Code" := TempLocationTable.Code;
//                   UserSetup.MODIFY(TRUE);
//                 END;

//               END;
//             END;
//           END;
//           */
//         END;

//     end;
// }

