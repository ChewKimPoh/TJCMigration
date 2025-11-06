// codeunit 1 ApplicationManagement
// {
//     // TJCSG1.00 Upgrade
//     // 1. 03/04/2014 DP.JL DD#85
//     //   - Moved code to the NAS NASManagement codeunit 44


//     trigger OnRun()
//     begin
//     end;

//     var
//         DebuggerManagement: Codeunit "9500";
//         LogInManagement: Codeunit "40";
//         TextManagement: Codeunit "41";
//         CaptionManagement: Codeunit "42";
//         LanguageManagement: Codeunit "43";
//         NASManagement: Codeunit "44";
//         AutoFormatManagement: Codeunit "45";

//     procedure CompanyOpen()
//     begin
//         LogInManagement.CompanyOpen;
//     end;

//     procedure GetSystemIndicator(var Text: Text[250];var Style: Option Standard,Accent1,Accent2,Accent3,Accent4,Accent5,Accent6,Accent7,Accent8,Accent9)
//     var
//         CompanyInformation: Record "79";
//     begin
//         IF CompanyInformation.GET THEN
//           CompanyInformation.GetSystemIndicator(Text,Style);
//     end;

//     procedure CompanyClose()
//     begin
//         LogInManagement.CompanyClose;
//     end;

//     procedure FindPrinter(ReportID: Integer): Text[250]
//     var
//         PrinterSelection: Record "78";
//     begin
//         CLEAR(PrinterSelection);

//         IF NOT PrinterSelection.GET(USERID,ReportID) THEN
//           IF NOT PrinterSelection.GET('',ReportID) THEN
//             IF NOT PrinterSelection.GET(USERID,0) THEN
//               IF PrinterSelection.GET('',0) THEN;

//         EXIT(PrinterSelection."Printer Name");
//     end;

//     procedure ApplicationVersion(): Text[80]
//     begin
//         EXIT('W1 7.10');
//     end;

//     procedure ApplicationBuild(): Text[80]
//     begin
//         EXIT('36281');
//     end;

//     procedure ApplicationLanguage(): Integer
//     begin
//         EXIT(1033);
//     end;

//     procedure DefaultRoleCenter(): Integer
//     var
//         ConfPersMgt: Codeunit "9170";
//     begin
//         EXIT(ConfPersMgt.DefaultRoleCenterID);
//     end;

//     procedure MakeDateTimeText(var DateTimeText: Text[250]): Integer
//     begin
//         EXIT(TextManagement.MakeDateTimeText(DateTimeText));
//     end;

//     procedure GetSeparateDateTime(DateTimeText: Text[250];var Date: Date;var Time: Time): Boolean
//     begin
//         EXIT(TextManagement.GetSeparateDateTime(DateTimeText,Date,Time));
//     end;

//     procedure MakeDateText(var DateText: Text[250]): Integer
//     begin
//         EXIT(TextManagement.MakeDateText(DateText));
//     end;

//     procedure MakeTimeText(var TimeText: Text[250]): Integer
//     begin
//         EXIT(TextManagement.MakeTimeText(TimeText));
//     end;

//     procedure MakeText(var Text: Text[250]): Integer
//     begin
//         EXIT(TextManagement.MakeText(Text));
//     end;

//     procedure MakeDateTimeFilter(var DateTimeFilterText: Text[250]): Integer
//     begin
//         EXIT(TextManagement.MakeDateTimeFilter(DateTimeFilterText));
//     end;

//     procedure MakeDateFilter(var DateFilterText: Text[1024]): Integer
//     begin
//         EXIT(TextManagement.MakeDateFilter(DateFilterText));
//     end;

//     procedure MakeTextFilter(var TextFilterText: Text): Integer
//     begin
//         EXIT(TextManagement.MakeTextFilter(TextFilterText));
//     end;

//     procedure MakeCodeFilter(var TextFilterText: Text): Integer
//     begin
//         EXIT(TextManagement.MakeTextFilter(TextFilterText));
//     end;

//     procedure MakeTimeFilter(var TimeFilterText: Text[250]): Integer
//     begin
//         EXIT(TextManagement.MakeTimeFilter(TimeFilterText));
//     end;

//     procedure AutoFormatTranslate(AutoFormatType: Integer;AutoFormatExpr: Text[80]): Text[80]
//     begin
//         EXIT(AutoFormatManagement.AutoFormatTranslate(AutoFormatType,AutoFormatExpr));
//     end;

//     procedure ReadRounding(): Decimal
//     begin
//         EXIT(AutoFormatManagement.ReadRounding);
//     end;

//     procedure CaptionClassTranslate(Language: Integer;CaptionExpr: Text[1024]): Text[1024]
//     begin
//         EXIT(CaptionManagement.CaptionClassTranslate(Language,CaptionExpr));
//     end;

//     procedure SetGlobalLanguage()
//     begin
//         LanguageManagement.SetGlobalLanguage;
//     end;

//     procedure ValidateApplicationlLanguage(LanguageID: Integer)
//     begin
//         LanguageManagement.ValidateApplicationLanguage(LanguageID);
//     end;

//     procedure LookupApplicationlLanguage(var LanguageID: Integer)
//     begin
//         LanguageManagement.LookupApplicationLanguage(LanguageID);
//     end;

//     procedure NASHandler(NASID: Text[260])
//     begin
//         NASManagement.NASHandler(NASID);

//         /*START TJCSG1.00 #1*/
//         /*
//         'WEBSERVICE':
//         BEGIN
//           MESSAGE('Webservice started...');
//           CODEUNIT.RUN(CODEUNIT::SHWebServiceHandle);
//           MESSAGE('Successfully call SHWebServiceHandle Codeunit');
//           CODEUNIT.RUN(CODEUNIT::TJCNavisionComm);
//           MESSAGE('Successfully call TJCNavisionComm Codeunit');
//         END;
//         */
//         /*END TJCSG1.00 #1*/

//     end;

//     procedure GetDatabaseTableTriggerSetup(TableId: Integer;var OnDatabaseInsert: Boolean;var OnDatabaseModify: Boolean;var OnDatabaseDelete: Boolean;var OnDatabaseRename: Boolean)
//     var
//         IntegrationManagement: Codeunit "5150";
//         ChangeLogMgt: Codeunit "423";
//     begin
//         ChangeLogMgt.GetDatabaseTableTriggerSetup(TableId,OnDatabaseInsert,OnDatabaseModify,OnDatabaseDelete,OnDatabaseRename);

//         IntegrationManagement.GetDatabaseTableTriggerSetup(TableId,OnDatabaseInsert,OnDatabaseModify,OnDatabaseDelete,OnDatabaseRename);
//     end;

//     procedure OnDatabaseInsert(RecRef: RecordRef)
//     var
//         IntegrationManagement: Codeunit "5150";
//         ChangeLogMgt: Codeunit "423";
//     begin
//         ChangeLogMgt.LogInsertion(RecRef);

//         IntegrationManagement.OnDatabaseInsert(RecRef);
//     end;

//     procedure OnDatabaseModify(RecRef: RecordRef)
//     var
//         IntegrationManagement: Codeunit "5150";
//         ChangeLogMgt: Codeunit "423";
//     begin
//         ChangeLogMgt.LogModification(RecRef);

//         IntegrationManagement.OnDatabaseModify(RecRef);
//     end;

//     procedure OnDatabaseDelete(RecRef: RecordRef)
//     var
//         IntegrationManagement: Codeunit "5150";
//         ChangeLogMgt: Codeunit "423";
//     begin
//         ChangeLogMgt.LogDeletion(RecRef);

//         IntegrationManagement.OnDatabaseDelete(RecRef);
//     end;

//     procedure OnDatabaseRename(RecRef: RecordRef;xRecRef: RecordRef)
//     var
//         IntegrationManagement: Codeunit "5150";
//         ChangeLogMgt: Codeunit "423";
//     begin
//         ChangeLogMgt.LogRename(RecRef,xRecRef);

//         IntegrationManagement.OnDatabaseRename(RecRef,xRecRef);
//     end;

//     procedure OnDebuggerBreak(ErrorMessage: Text)
//     begin
//         DebuggerManagement.ProcessDebuggerBreak(ErrorMessage);
//     end;

//     procedure LaunchDebugger()
//     begin
//         PAGE.RUN(PAGE::"Session List");
//     end;

//     procedure CustomizeChart(var TempChart: Record "2000000078" temporary): Boolean
//     var
//         GenericChartMgt: Codeunit "9180";
//     begin
//         EXIT(GenericChartMgt.ChartCustomization(TempChart));
//     end;
// }

