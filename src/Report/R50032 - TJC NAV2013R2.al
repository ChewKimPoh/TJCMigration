// report 50032 "Medicine Prescription"
// {
//     // DP.RWP - New Report to print Medicine Prescription
//     DefaultLayout = RDLC;
//     RDLCLayout = './Medicine Prescription.rdlc';


//     dataset
//     {
//         dataitem(DataItem3371;Table50003)
//         {
//             RequestFilterFields = "Contact No.","History No.";
//             column(COMPANYNAME;COMPANYNAME)
//             {
//             }
//             column(Patient_Checkup_Info___Doctor_code_____;'*'+"Patient Checkup Info"."Doctor code"+'*')
//             {
//             }
//             column(EnglishName;EnglishName)
//             {
//             }
//             column(ChineseName;ChineseName)
//             {
//             }
//             column(FORMAT_TODAY_0_4_;FORMAT(TODAY,0,4))
//             {
//             }
//             column(USERID;USERID)
//             {
//             }
//             column(CurrReport_PAGENO;CurrReport.PAGENO)
//             {
//             }
//             column(Patient_Checkup_Info__Doctor_code_;"Doctor code")
//             {
//             }
//             column(Medicine_PrescriptionCaption;Medicine_PrescriptionCaptionLbl)
//             {
//             }
//             column(Doctor_CodeCaption;Doctor_CodeCaptionLbl)
//             {
//             }
//             column(Patient_English_NameCaption;Patient_English_NameCaptionLbl)
//             {
//             }
//             column(Patient_Chinese_NameCaption;Patient_Chinese_NameCaptionLbl)
//             {
//             }
//             column(Medicine_NameCaption;Medicine_NameCaptionLbl)
//             {
//             }
//             column(No_Caption;No_CaptionLbl)
//             {
//             }
//             column(Sticker_No_Caption;Sticker_No_CaptionLbl)
//             {
//             }
//             column(Patient_Prescription_Detail_QtyCaption;"Patient Prescription Detail".FIELDCAPTION(Qty))
//             {
//             }
//             column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
//             {
//             }
//             column(Number_of_DaysCaption;Number_of_DaysCaptionLbl)
//             {
//             }
//             column(Patient_Prescription_Detail_MultiplyCaption;"Patient Prescription Detail".FIELDCAPTION(Multiply))
//             {
//             }
//             column(Patient_Checkup_Info_Contact_No_;"Contact No.")
//             {
//             }
//             column(Patient_Checkup_Info_History_No_;"History No.")
//             {
//             }
//             dataitem(DataItem1274;Table50004)
//             {
//                 DataItemLink = Contact No.=FIELD(Contact No.),
//                                History No.=FIELD(History No.);
//                 DataItemTableView = SORTING(Contact No.,History No.,BarCode,Line No.);
//                 column(Patient_Prescription_Detail__Patient_Prescription_Detail___Medicine_Name_;"Patient Prescription Detail"."Medicine Name")
//                 {
//                 }
//                 column(Patient_Prescription_Detail_Qty;Qty)
//                 {
//                 }
//                 column(EntryNo;EntryNo)
//                 {
//                 }
//                 column(Patient_Prescription_Detail__Line_No__;"Line No.")
//                 {
//                 }
//                 column(Patient_Prescription_Detail__Patient_Prescription_Detail___How_Many_Days_;"Patient Prescription Detail"."How Many Days")
//                 {
//                 }
//                 column(Patient_Prescription_Detail_Multiply;Multiply)
//                 {
//                 }
//                 column(Patient_Prescription_Detail_Contact_No_;"Contact No.")
//                 {
//                 }
//                 column(Patient_Prescription_Detail_History_No_;"History No.")
//                 {
//                 }
//                 dataitem(DataItem5444;Table2000000026)
//                 {
//                     DataItemTableView = SORTING(Number)
//                                         WHERE(Number=FILTER(1..));
//                     column(BarCodeName____;'*'+BarCodeName+'*')
//                     {
//                     }
//                     column(BarCodeName;BarCodeName)
//                     {
//                     }
//                     column(Integer_Number;Number)
//                     {
//                     }

//                     trigger OnPreDataItem()
//                     begin
//                         SETRANGE(Number, 1, "Patient Prescription Detail".Multiply);
//                     end;
//                 }

//                 trigger OnAfterGetRecord()
//                 begin
//                     EntryNo += 1;

//                     IF "Patient Prescription Detail".BarCode = '' THEN BEGIN
//                       SMSetup.GET;
//                       CASE "Patient Prescription Detail"."How Many Days" OF
//                         0: BarCodeName := SMSetup.BarCode3;
//                         1: BarCodeName := SMSetup.BarCode5;
//                         2: BarCodeName := SMSetup.BarCode7;
//                         3: BarCodeName := SMSetup.BarCode1;
//                       END;
//                     END ELSE
//                       BarCodeName := "Patient Prescription Detail".BarCode;

//                     IF BarCodeName <> PrevBarCodeName THEN BEGIN
//                       BarCodeFlag := TRUE;
//                       PrevBarCodeName := BarCodeName;
//                     END ELSE
//                       BarCodeFlag := FALSE;
//                 end;

//                 trigger OnPreDataItem()
//                 begin
//                     BarCodeFlag := TRUE;
//                     PrevBarCodeName := '';
//                     EntryNo := 0;
//                 end;
//             }

//             trigger OnAfterGetRecord()
//             begin
//                 Contact.GET("Contact No.");
//                 ChineseName := Contact."Chinese Name";
//                 EnglishName := Contact.Name;
//             end;

//             trigger OnPreDataItem()
//             begin
//                 EntryNo := 0;
//                 CLEAR(ChineseName);
//                 CLEAR(EnglishName);
//             end;
//         }
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

//     var
//         Contact: Record "5050";
//         SMSetup: Record "311";
//         EnglishName: Text[50];
//         ChineseName: Text[10];
//         EntryNo: Integer;
//         BarCodeName: Code[20];
//         BarCodeFlag: Boolean;
//         PrevBarCodeName: Code[20];
//         Medicine_PrescriptionCaptionLbl: Label 'Medicine Prescription';
//         Doctor_CodeCaptionLbl: Label 'Doctor Code';
//         Patient_English_NameCaptionLbl: Label 'Patient English Name';
//         Patient_Chinese_NameCaptionLbl: Label 'Patient Chinese Name';
//         Medicine_NameCaptionLbl: Label 'Medicine Name';
//         No_CaptionLbl: Label 'No#';
//         Sticker_No_CaptionLbl: Label 'Sticker No.';
//         CurrReport_PAGENOCaptionLbl: Label 'Page';
//         Number_of_DaysCaptionLbl: Label 'Number of Days';
// }

