// table 11603 "BAS Business Unit"
// {
//     Caption = 'BAS Business Unit';

//     fields
//     {
//         field(2;"Company Name";Text[30])
//         {
//             Caption = 'Company Name';
//             NotBlank = true;
//             TableRelation = Company.Name;
//             //This property is currently not supported
//             //TestTableRelation = false;
//             ValidateTableRelation = false;
//         }
//         field(4;"BAS Version";Integer)
//         {
//             Caption = 'BAS Version';

//             trigger OnLookup()
//             begin
//                 IF "Company Name" <> COMPANYNAME THEN
//                   BASCalcSheet.CHANGECOMPANY("Company Name");
//                 BASCalcSheet.SETRANGE(A1,"Document No.");
//                 //IF FORM.RUNMODAL(FORM::Page11603,BASCalcSheet,BASCalcSheet."BAS Version") = ACTION::LookupOK THEN
//                 //  VALIDATE("BAS Version",BASCalcSheet."BAS Version");
//             end;

//             trigger OnValidate()
//             begin
//                 IF "Company Name" <> COMPANYNAME THEN
//                   BASCalcSheet.CHANGECOMPANY("Company Name");
//                 BASCalcSheet.GET("Document No.","BAS Version");
//             end;
//         }
//         field(5;"Document No.";Code[11])
//         {
//             Caption = 'Document No.';

//             trigger OnLookup()
//             begin
//                 IF "Company Name" <> COMPANYNAME THEN
//                   BASCalcSheet.CHANGECOMPANY("Company Name");
//                 //IF FORM.RUNMODAL(FORM::Page11603,BASCalcSheet,BASCalcSheet.A1) = ACTION::LookupOK THEN
//                   VALIDATE("Document No.",BASCalcSheet.A1);
//                   "BAS Version" := BASCalcSheet."BAS Version";
//             end;

//             trigger OnValidate()
//             begin
//                 IF "Document No." <> '' THEN BEGIN
//                   IF "Company Name" <> COMPANYNAME THEN
//                     BASCalcSheet.CHANGECOMPANY("Company Name");
//                   BASCalcSheet.SETRANGE(A1,"Document No.");
//                   BASCalcSheet.FIND('-');
//                 END ELSE
//                   "BAS Version" := 0;
//             end;
//         }
//     }

//     keys
//     {
//         key(Key1;"Company Name")
//         {
//         }
//     }

//     fieldgroups
//     {
//     }

//     trigger OnInsert()
//     begin
//         GLSetup.GET;
//         //GLSetup.TESTFIELD("BAS Group Company",TRUE);
//     end;

//     trigger OnModify()
//     begin
//         GLSetup.GET;
//         //GLSetup.TESTFIELD("BAS Group Company",TRUE);
//     end;

//     var
//         GLSetup: Record "98";
//         BASCalcSheet: Record "11601";
// }

