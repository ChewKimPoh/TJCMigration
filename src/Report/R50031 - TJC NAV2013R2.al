// report 50031 "Copy Medicine"
// {
//     //       DP.RWP - New report to copy prescription
//     // 
//     //       20100629 DP.RWP
//     //          -Add BarCode field

//     ProcessingOnly = true;

//     dataset
//     {
//     }

//     requestpage
//     {

//         layout
//         {
//             area(content)
//             {
//                 group(Options)
//                 {
//                     Caption = 'Options';
//                     field(FromPatient;FromPatient)
//                     {
//                         Caption = 'From Patient No.';

//                         trigger OnLookup(var Text: Text): Boolean
//                         var
//                             Contact: Record "5050";
//                             PatientList: Page "50020";
//                         begin
//                             CLEAR(PatientList);
//                             Contact.RESET;
//                             UserSetup.GET(USERID);
//                             Contact.SETRANGE("Location Code", UserSetup."Location Code");
//                             PatientList.SETTABLEVIEW(Contact);
//                             PatientList.LOOKUPMODE(TRUE);
//                             IF PatientList.RUNMODAL = ACTION::LookupOK THEN BEGIN
//                               PatientList.GETRECORD(Contact);
//                               Text := Contact."No.";
//                               FromPatient :=Text;
//                               CLEAR(FromHistoryNo);
//                             END;
//                         end;
//                     }
//                     field(FromHistoryNo;FromHistoryNo)
//                     {
//                         Caption = 'From History No.';

//                         trigger OnLookup(var Text: Text): Boolean
//                         var
//                             PatientCheckUp: Record "50003";
//                             PatientCheckUpList: Page "50088";
//                         begin
//                             CLEAR(PatientCheckUpList);
//                             PatientCheckUp.RESET;
//                             PatientCheckUp.SETRANGE("Contact No.", FromPatient);
//                             PatientCheckUpList.SETTABLEVIEW(PatientCheckUp);
//                             PatientCheckUpList.LOOKUPMODE(TRUE);
//                             IF PatientCheckUpList.RUNMODAL = ACTION::LookupOK THEN BEGIN
//                               PatientCheckUpList.GETRECORD(PatientCheckUp);
//                               FromHistoryNo := PatientCheckUp."History No.";
//                             END;
//                         end;
//                     }
//                     field(ToPatient;ToPatient)
//                     {
//                         Caption = 'To Patient No.';
//                         Editable = false;
//                     }
//                     field(ToHistoryNo;ToHistoryNo)
//                     {
//                         Caption = 'To History No.';
//                         Editable = false;
//                     }
//                 }
//             }
//         }

//         actions
//         {
//         }
//     }

//     labels
//     {
//     }

//     trigger OnPostReport()
//     begin
//         //Copy medicine
//         IF (FromPatient ='') OR (FromHistoryNo = 0) THEN BEGIN
//           MESSAGE(Text001);
//           EXIT;
//         END;
//         IF (FromPatient =ToPatient) AND (FromHistoryNo = ToHistoryNo) THEN
//           ERROR(Text003);

//         FromMedicine.RESET;
//         FromMedicine.SETRANGE("Contact No.",FromPatient);
//         FromMedicine.SETRANGE("History No.",FromHistoryNo);
//         IF NOT FromMedicine.FINDSET THEN BEGIN
//           MESSAGE(Text002,FromPatient,FromHistoryNo);
//           EXIT;
//         END ELSE BEGIN
//         //get last LineNo
//         ToMedicine.RESET;
//         ToMedicine.SETRANGE("Contact No.",ToPatient);
//         ToMedicine.SETRANGE("History No.", ToHistoryNo);
//         IF ToMedicine.FINDLAST THEN
//           LineNo := ToMedicine."Line No." + 10000
//         ELSE
//           LineNo := 10000;

//         REPEAT
//           ToMedicine.INIT;
//           ToMedicine."Contact No." := ToPatient;
//           ToMedicine."History No." := ToHistoryNo;
//           ToMedicine."Line No." := LineNo;
//           ToMedicine."Medicine Code" := FromMedicine."Medicine Code";
//           ToMedicine."Location Code":= FromMedicine."Location Code";
//           ToMedicine."Dosage Per Time" :=FromMedicine."Dosage Per Time";
//           ToMedicine."Times Per Day"  :=FromMedicine."Times Per Day";

//           ToMedicine.BarCode := FromMedicine.BarCode;   //20100629
//           ToMedicine."How Many Days"  :=FromMedicine."How Many Days";
//           ToMedicine.Multiply   :=FromMedicine.Multiply;
//           ToMedicine."Duration Hour" := FromMedicine."Duration Hour";
//           ToMedicine.Qty   :=FromMedicine.Qty;
//           ToMedicine."Clinic Item Category Code":=  FromMedicine."Clinic Item Category Code";
//           ToMedicine."Clinic Product Category Code":=  FromMedicine."Clinic Product Category Code";

//           ToMedicine.Remark :=FromMedicine.Remark;
//           ToMedicine."When To Take":=FromMedicine."When To Take";
//           ToMedicine."Medicine Name":= FromMedicine."Medicine Name";
//           ToMedicine."Base Unit of Measure Code":=FromMedicine."Base Unit of Measure Code";
//           ToMedicine."Dosage UOM":=FromMedicine."Dosage UOM";

//           ToMedicine.INSERT;
//           LineNo += 10000;
//         UNTIL FromMedicine.NEXT = 0;
//         END;
//     end;

//     var
//         UserSetup: Record "91";
//         FromMedicine: Record "50004";
//         ToMedicine: Record "50004";
//         FromPatient: Code[20];
//         FromHistoryNo: Integer;
//         ToPatient: Code[20];
//         ToHistoryNo: Integer;
//         Text001: Label 'Please input From Patient/From History No info first!';
//         Text002: Label 'No data exists for %1 and %2.';
//         Text003: Label 'Cannot copy itselft.';
//         LineNo: Integer;

//     procedure SetValue(Patient: Code[20];HistoryNo: Integer)
//     begin
//               ToPatient := Patient;
//               ToHistoryNo := HistoryNo;
//               FromPatient := Patient;
//     end;
// }

