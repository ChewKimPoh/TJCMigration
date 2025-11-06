// codeunit 50005 "Budget Functions"
// {

//     trigger OnRun()
//     begin
//     end;

//     procedure GetJobList(var RetXml: BigText)
//     var
//         RecJob: Record "167";
//     begin
//         RecJob.RESET;
//         RetXml.ADDTEXT('<DPTech>');
//         IF RecJob.FINDFIRST THEN BEGIN
//         REPEAT
//           RetXml.ADDTEXT('<Job>');
//            RetXml.ADDTEXT('<No>' + RecJob."No." + '</No>');
//            RetXml.ADDTEXT('<Description>' +  RecJob.Description + '</Description>');
//           RetXml.ADDTEXT('</Job>');
//         UNTIL (RecJob.NEXT=0)
//         END ELSE BEGIN
//           RetXml.ADDTEXT('<Job></Job>');
//         END;
//         RetXml.ADDTEXT('</DPTech>');
//     end;

//     procedure GetJobTaskLines(var RetXML: BigText;JobNo: Text[64])
//     var
//         RecJobTask: Record "1001";
//     begin
//         RecJobTask.RESET;
//         RecJobTask.SETRANGE("Job No.",JobNo);
//         RetXML.ADDTEXT('<DPTech>');
//         IF RecJobTask.FINDFIRST THEN BEGIN
//         REPEAT
//         RecJobTask.CALCFIELDS("Schedule (Total Cost)");
//         RecJobTask.CALCFIELDS("Schedule (Total Price)");
//         RecJobTask.CALCFIELDS("Usage (Total Cost)");
//         RecJobTask.CALCFIELDS("Usage (Total Price)");
//           RetXML.ADDTEXT('<JobTask>');
//           RetXML.ADDTEXT('<JobTaskNo>' + RecJobTask."Job Task No." + '</JobTaskNo>');
//           RetXML.ADDTEXT('<Description>' +  RecJobTask.Description + '</Description>');
//           RetXML.ADDTEXT('<JobTaskType>' + FORMAT(RecJobTask."Job Task Type") + '</JobTaskType>');
//           RetXML.ADDTEXT('<StartDate>' + FORMAT(RecJobTask."Start Date") + '</StartDate>');
//           RetXML.ADDTEXT('<EndDate>' + FORMAT(RecJobTask."End Date") + '</EndDate>');
//           RetXML.ADDTEXT('<ScheduleTotalCost>' + FORMAT(RecJobTask."Schedule (Total Cost)") + '</ScheduleTotalCost>');
//           RetXML.ADDTEXT('<ScheduleTotalPrice>' + FORMAT(RecJobTask."Schedule (Total Price)") + '</ScheduleTotalPrice>');
//           RetXML.ADDTEXT('<UsageTotalCost>' + FORMAT(RecJobTask."Usage (Total Cost)") + '</UsageTotalCost>');
//           RetXML.ADDTEXT('<UsageTotalPrice>' + FORMAT(RecJobTask."Usage (Total Price)") + '</UsageTotalPrice>');

//           RetXML.ADDTEXT('</JobTask>');
//         UNTIL (RecJobTask.NEXT=0)
//         END ELSE BEGIN
//           RetXML.ADDTEXT('<JobTask></JobTask>');
//         END;
//         RetXML.ADDTEXT('</DPTech>');
//     end;
// }

