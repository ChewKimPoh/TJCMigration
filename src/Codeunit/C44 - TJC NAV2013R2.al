// codeunit 44 NASManagement
// {
//     // TJCSG1.00 Upgrade
//     // 1. 03/04/2014 DP.JL DD#85
//     //   - Code brought from codeunit 1


//     trigger OnRun()
//     begin
//     end;

//     procedure NASHandler(NASID: Text[260])
//     var
//         Parameter: Text[260];
//         ParamStr: Text[260];
//         SepPosition: Integer;
//     begin
//         ParamStr := UPPERCASE(NASID);
//         REPEAT
//           SepPosition := STRPOS(ParamStr,',');
//           IF SepPosition > 0 THEN
//             Parameter := COPYSTR(ParamStr,1,SepPosition - 1)
//           ELSE
//             Parameter := ParamStr;

//           CASE Parameter OF
//             'JOBQUEUE':
//               CODEUNIT.RUN(CODEUNIT::"Job Queue - NAS Start Up");

//             /*START TJCSG1.00 #1*/
//             'WEBSERVICE':
//             BEGIN
//               MESSAGE('Webservice started...');
//               CODEUNIT.RUN(CODEUNIT::SHWebServiceHandle);
//               MESSAGE('Successfully call SHWebServiceHandle Codeunit');
//               CODEUNIT.RUN(CODEUNIT::TJCNavisionComm);
//               MESSAGE('Successfully call TJCNavisionComm Codeunit');
//             END;
//             /*END TJCSG1.00 #1*/

//           END;
//           ParamStr := COPYSTR(ParamStr,SepPosition + 1);
//         UNTIL SepPosition = 0;

//     end;
// }

