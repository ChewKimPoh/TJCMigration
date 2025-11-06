// report 50030 "Medicine Sticker"
// {
//     // DP.RWP - New Report to print medicine stickers
//     // 20100629 DP.RWP
//     //   - Add "Print Medicine Sticker" control
//     // 
//     // 2. TJCSG1.00 - 2014/06/24  DP.AYD
//     //    - Remark unused code.
//     // 3. TJCSG1.00 - 2014/06/24  DP.AYD
//     //    -fix chinese char
//     DefaultLayout = RDLC;
//     RDLCLayout = './Medicine Sticker.rdlc';


//     dataset
//     {
//         dataitem(DataItem2;Table79)
//         {
//             DataItemTableView = SORTING(Primary Key)
//                                 ORDER(Ascending);
//             column(Picture_CompanyInformation;"Company Information".Picture)
//             {
//             }
//             column(Name_CompanyInformation;Name_CompanyInformation)
//             {
//             }
//             column(Name2_CompanyInformation;Name2_CompanyInformation)
//             {
//             }
//             column(cono;CoNo)
//             {
//             }
//             column(gstno;GSTNo)
//             {
//             }
//             dataitem(DataItem1;Table50004)
//             {
//                 DataItemTableView = SORTING(Contact No.,History No.,Line No.)
//                                     ORDER(Ascending);
//                 RequestFilterFields = "Contact No.","History No.";
//                 column(UomDesc;UoMDesc)
//                 {
//                 }
//                 column(Address;Address)
//                 {
//                 }
//                 column(Address2;Address2)
//                 {
//                 }
//                 column(PhoneNo;PhoneNo)
//                 {
//                 }
//                 column(EnglishName;EnglishName)
//                 {
//                 }
//                 column(ChineseName;ChineseName)
//                 {
//                 }
//                 column(Description;Description)
//                 {
//                 }
//                 column(LineNo_PatientPrescriptionDetail;"Patient Prescription Detail"."Line No.")
//                 {
//                 }
//                 column(TimesPerDay_PatientPrescriptionDetail;"Patient Prescription Detail"."Times Per Day")
//                 {
//                 }
//                 column(DurationHour_PatientPrescriptionDetail;"Patient Prescription Detail"."Duration Hour")
//                 {
//                 }
//                 column(DosagePerTime_PatientPrescriptionDetail;"Patient Prescription Detail"."Dosage Per Time")
//                 {
//                 }
//                 column(ContactNo_PatientPrescriptionDetail;"Patient Prescription Detail"."Contact No.")
//                 {
//                 }
//                 column(HistoryNo_PatientPrescriptionDetail;"Patient Prescription Detail"."History No.")
//                 {
//                 }

//                 trigger OnAfterGetRecord()
//                 begin
//                     //20100629 [
//                     IF BarCode <> '' THEN BEGIN
//                       rBarCode.GET(BarCode);
//                       IF NOT rBarCode."Print Medicine Sticker" THEN
//                         CurrReport.SKIP;
//                     END;
//                     //20100629]

//                     /*
//                     //TJCSG1.00 #2 Start
//                     CLEAR(UOMDesc);
//                     CLEAR(Address);
//                     CLEAR(Address2);
//                     CLEAR(PhoneNo);
//                     //TJCSG1.00 #2 End
//                     */

//                     UoMDesc:='';
//                     Address:='';
//                     Address2:='';
//                     PhoneNo:='';

//                     Contact.RESET;
//                     IF Contact.GET("Contact No.") THEN BEGIN
//                       EnglishName := Contact.Name;
//                       ChineseName := Contact."Chinese Name";
//                     END;

//                     IF Location.GET("Location Code") THEN BEGIN
//                       Address := Location.Address;
//                       Address2 := Location."Address 2";
//                       PhoneNo := Location."Phone No.";
//                     END;

//                     CASE "When To Take"   OF
//                     //TJCSG1.00 #3 Start
//                     /*
//                      "When To Take"::"After meals" : Description := 'ŠŒ× After meals ŠÏš';
//                      "When To Take"::"No effect" : Description := 'ŠŒž§/ŠŒ× Before meals/After meals ŠÏš';
//                      "When To Take"::"Before meals" :  Description := 'ŠŒž§ Before meals ŠÏš';
//                      */
//                       "When To Take"::"After meals" : Description := '‡‰ŠÝ After meals ‡þ®“';
//                       "When To Take"::"No effect" : Description := '‡‰—/‡‰ŠÝ Before meals/After meals ‡þ®“';
//                       "When To Take"::"Before meals" : Description := '‡‰— Before meals ‡þ®“';
//                     //TJCSG1.00 #3 End
//                     END;

//                     IF UoM.GET("Dosage UOM") THEN
//                       UoMDesc := UoM.Description;

//                 end;

//                 trigger OnPreDataItem()
//                 begin
//                     /*
//                     //TJCSG1.00 #2 Start
//                     CompanyInformation.GET;
//                     CompanyInformation.CALCFIELDS(CompanyInformation.Picture);
//                     //TJCSG1.00 #2 End
//                     */

//                 end;
//             }

//             trigger OnAfterGetRecord()
//             begin
//                 //TJCSG1.00 #2 Start
//                 CoNo:='Co. No: 199306907Z';
//                 GSTNo:='GST: M2-0118600-5';
//                 Name_CompanyInformation:="Company Information".Name;
//                 //TJCSG1.00 #2 End
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
//         "/*TJCSGVARS*/": Char;
//         Name_CompanyInformation: Text;
//         Name2_CompanyInformation: Text;
//         CoNo: Text;
//         GSTNo: Text;
//         Contact: Record "5050";
//         Location: Record "14";
//         UoM: Record "204";
//         rBarCode: Record "50012";
//         Address: Text;
//         Address2: Text;
//         PhoneNo: Text;
//         UoMDesc: Text;
//         EnglishName: Text;
//         ChineseName: Text;
//         Description: Text;

//     procedure "/* PMSSGFUNC */"()
//     begin
//     end;

//     procedure DPEnter() EnterChar: Text[2]
//     begin
//         EnterChar[1]:=13;
//         EnterChar[2]:=10;
//     end;

//     procedure DPTrim(TextToTrim: Text) Result: Text
//     begin
//         Result:=DELCHR(TextToTrim,'<>',' ')
//     end;

//     procedure DPAddEnter(TextToAdd: Text) Result: Text
//     begin
//         IF DPTrim(TextToAdd)<>'' THEN
//           Result:=DPTrim(TextToAdd) +DPEnter;
//     end;

//     procedure DPAddEnter1(TextToAdd: Text) Result: Text
//     begin
//         IF DPTrim(TextToAdd)<>'' THEN
//           Result:=DPEnter+DPTrim(TextToAdd);
//     end;
// }

