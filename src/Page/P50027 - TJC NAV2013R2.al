// page 50027 "Clinic Visit Analysis"
// {
//     PageType = Worksheet;
//     PromotedActionCategories = 'New,Tasks,Reports,Patient';
//     SourceTable = Table50003;
//     SourceTableView = SORTING(Visit Date);

//     layout
//     {
//         area(content)
//         {
//             field(VisitDate;VisitDate)
//             {
//                 Caption = 'Visit Date';

//                 trigger OnValidate()
//                 begin
//                     SETRANGE("Visit Date");
//                     IF VisitDate <> '' THEN
//                       SETFILTER("Visit Date", VisitDate);
//                     TotNo := COUNT;
//                       VisitDateOnAfterValidate;
//                 end;
//             }
//             field(DoctorCode;DoctorCode)
//             {
//                 Caption = 'Doctor Code';

//                 trigger OnLookup(var Text: Text): Boolean
//                 begin
//                     SETRANGE("Doctor code");
//                     LoginMgt.LookupUserID(DoctorCode);
//                     Text := DoctorCode;
//                     IF DoctorCode <> '' THEN
//                       SETRANGE("Doctor code", DoctorCode);
//                     TotNo := COUNT;
//                     CurrPage.UPDATE;
//                 end;

//                 trigger OnValidate()
//                 begin
//                     SETRANGE("Doctor code");
//                     IF DoctorCode <> '' THEN
//                       SETRANGE("Doctor code", DoctorCode);
//                     TotNo := COUNT;
//                       DoctorCodeOnAfterValidate;
//                 end;
//             }
//             field(LocationCode;LocationCode)
//             {
//                 Caption = 'Location Code';
//                 TableRelation = Location.Code;

//                 trigger OnValidate()
//                 begin
//                     SETRANGE("Location Code");
//                     IF LocationCode <> '' THEN
//                       SETRANGE("Location Code", LocationCode);
//                     TotNo := COUNT;
//                       LocationCodeOnAfterValidate;
//                 end;
//             }
//             repeater()
//             {
//                 Editable = false;
//                 field("Contact No.";"Contact No.")
//                 {
//                     Caption = 'Patient No.';
//                 }
//                 field("History No.";"History No.")
//                 {
//                 }
//                 field(EnglishName;EnglishName)
//                 {
//                     Caption = 'Patient English Name';
//                 }
//                 field(ChineseName;ChineseName)
//                 {
//                     Caption = 'Patient Chinese Name';
//                 }
//                 field("Visit Date";"Visit Date")
//                 {
//                 }
//                 field("Doctor code";"Doctor code")
//                 {
//                 }
//                 field("Doctor Name";"Doctor Name")
//                 {
//                 }
//                 field("Location Code";"Location Code")
//                 {
//                 }
//             }
//             field(TotNo;TotNo)
//             {
//                 Caption = 'Total No.';
//                 Editable = false;
//             }
//         }
//     }

//     actions
//     {
//         area(processing)
//         {
//             action(View)
//             {
//                 Ellipsis = true;
//                 Image = View;
//                 Promoted = true;
//                 PromotedCategory = Category4;
//                 PromotedIsBig = true;
//                 RunObject = Page 50083;
//                 RunPageLink = Contact No.=FIELD(Contact No.),
//                               History No.=FIELD(History No.);
//                 RunPageMode = View;
//                 RunPageView = SORTING(Contact No.,History No.)
//                               ORDER(Ascending);
//             }
//         }
//     }

//     trigger OnAfterGetRecord()
//     begin
//         IF Contact.GET("Contact No.") THEN BEGIN
//           ChineseName := Contact."Chinese Name";
//           EnglishName :=Contact.Name;
//         END;
//     end;

//     trigger OnOpenPage()
//     begin
//         TotNo := COUNT;
//     end;

//     var
//         LoginMgt: Codeunit "418";
//         Contact: Record "5050";
//         VisitDate: Text[100];
//         DoctorCode: Code[20];
//         LocationCode: Code[10];
//         TotNo: Integer;
//         EnglishName: Text[50];
//         ChineseName: Text[10];

//     local procedure VisitDateOnAfterValidate()
//     begin
//         CurrPage.UPDATE;
//     end;

//     local procedure DoctorCodeOnAfterValidate()
//     begin
//         CurrPage.UPDATE;
//     end;

//     local procedure LocationCodeOnAfterValidate()
//     begin
//         CurrPage.UPDATE;
//     end;
// }

