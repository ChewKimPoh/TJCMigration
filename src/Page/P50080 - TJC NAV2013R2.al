// page 50080 "Patient Cards."
// {
//     // Version No.         : TJCSG1.00
//     // Developer           : DP.AYD
//     // Init. DEV. Date     : 27/6/2014
//     // Date of last Change : 27/6/2014
//     // Description         : Based on DD#166

//     Editable = true;
//     PageType = Document;
//     PromotedActionCategories = 'New,Tasks,Reports,Patient Checkup';
//     RefreshOnActivate = true;
//     SourceTable = Table5050;
//     SourceTableView = SORTING(No.)
//                       ORDER(Ascending)
//                       WHERE(Type=FILTER(Person));

//     layout
//     {
//         area(content)
//         {
//             group(General)
//             {
//                 Caption = 'General';
//                 field("No.";"No.")
//                 {
//                     Caption = 'Patient No.';
//                     Importance = Promoted;

//                     trigger OnValidate()
//                     begin
//                         Contact.SETCURRENTKEY("No.");
//                         Contact.SETRANGE("No.","No.");
//                         IF Contact.FIND('-') THEN BEGIN
//                            MESSAGE(Text010,"No.");
//                            IF CONFIRM(Text005,FALSE) THEN
//                              PAGE.RUN(50080,Contact);
//                            ERROR(Text010);
//                         END;
//                     end;
//                 }
//                 field("Chinese Name";"Chinese Name")
//                 {
//                     Importance = Promoted;
//                 }
//                 field(Birthday;Birthday)
//                 {
//                     Importance = Additional;
//                 }
//                 field(Age;Age)
//                 {
//                     Editable = false;
//                     Importance = Promoted;
//                 }
//                 field("Location Code";"Location Code")
//                 {
//                     Importance = Additional;
//                 }
//                 field("Marital Status";"Marital Status")
//                 {
//                     Importance = Additional;
//                 }
//                 field(Gender;Gender)
//                 {
//                     Importance = Additional;
//                 }
//                 field(Occupation;Occupation)
//                 {
//                     Importance = Additional;
//                 }
//                 field("NRIC No.";"NRIC No.")
//                 {
//                     Importance = Promoted;

//                     trigger OnValidate()
//                     begin
//                         IF  "NRIC No."='' THEN
//                           ERROR(Text001);

//                         Contact.SETCURRENTKEY("NRIC No.");
//                         Contact.SETRANGE("NRIC No.","NRIC No.");
//                         IF Contact.FIND('-') THEN BEGIN
//                            MESSAGE(Text003,"NRIC No.");
//                            IF CONFIRM(Text005,FALSE) THEN
//                              PAGE.RUN(50080,Contact);
//                            ERROR(Text003);
//                         END;
//                     end;
//                 }
//                 field(Name;Name)
//                 {
//                     Caption = 'English Name';
//                     Importance = Promoted;

//                     trigger OnValidate()
//                     begin
//                         IF  Name='' THEN
//                           ERROR(Text001);
//                     end;
//                 }
//                 field("Home Phone No.";"Home Phone No.")
//                 {
//                     Importance = Additional;
//                 }
//                 field("Phone No.";"Phone No.")
//                 {
//                     Caption = 'Office Phone No.';
//                     Importance = Additional;
//                 }
//                 field("Mobile Phone No.";"Mobile Phone No.")
//                 {
//                     Importance = Additional;
//                 }
//                 field(Address;Address)
//                 {
//                     Importance = Additional;
//                 }
//                 field("Address 2";"Address 2")
//                 {
//                     Importance = Additional;
//                 }
//             }
//             part(PatientCheckupList;50081)
//             {
//                 Caption = 'Check Up List';
//                 Editable = false;
//                 SubPageLink = Contact No.=FIELD(No.);
//                 SubPageView = SORTING(Contact No.,History No.)
//                               ORDER(Ascending);
//             }
//             part("Patient Medical History List";50084)
//             {
//                 Caption = 'Patient Medical History List';
//                 Editable = false;
//                 Provider = PatientCheckupList;
//                 SubPageLink = Contact No.=FIELD(Contact No.),
//                               History No.=FIELD(History No.);
//                 SubPageView = SORTING(Contact No.,History No.,Line No.)
//                               ORDER(Ascending);
//             }
//         }
//         area(factboxes)
//         {
//             part("Check Up Data";50082)
//             {
//                 Caption = 'Check Up Data';
//                 Editable = false;
//                 Provider = PatientCheckupList;
//                 SubPageLink = Contact No.=FIELD(Contact No.),
//                               History No.=FIELD(History No.);
//             }
//             part(Diagnosis;50085)
//             {
//                 Caption = 'Diagnosis';
//                 Editable = false;
//                 Provider = PatientCheckupList;
//                 SubPageLink = Contact No.=FIELD(Contact No.),
//                               History No.=FIELD(History No.);
//             }
//             part("Comment List";50086)
//             {
//                 Caption = 'Comment List';
//                 SubPageLink = No.=FIELD(No.);
//                 SubPageView = SORTING(Table Name,No.,Sub No.,Line No.)
//                               ORDER(Ascending)
//                               WHERE(Table Name=CONST(Contact),
//                                     Sub No.=CONST(0));
//             }
//         }
//     }

//     actions
//     {
//         area(navigation)
//         {
//             action(New)
//             {
//                 Ellipsis = true;
//                 Image = NewDocument;
//                 Promoted = true;
//                 PromotedCategory = Category4;
//                 PromotedIsBig = true;
//                 RunObject = Page 50083;
//                 RunPageLink = Contact No.=FIELD(No.);
//                 RunPageMode = Create;
//                 RunPageView = SORTING(Contact No.,History No.)
//                               ORDER(Ascending);
//             }
//             action("Co&mments")
//             {
//                 Caption = 'Co&mments';
//                 Image = ViewComments;
//                 Promoted = true;
//                 PromotedCategory = Category4;
//                 PromotedIsBig = true;
//                 RunObject = Page 50086;
//                 RunPageLink = No.=FIELD(No.);
//                 RunPageView = SORTING(Table Name,No.,Sub No.,Line No.)
//                               ORDER(Ascending)
//                               WHERE(Table Name=CONST(Contact),
//                                     Sub No.=CONST(0));
//             }
//         }
//     }

//     trigger OnAfterGetRecord()
//     begin
//         IF Birthday<>0D THEN
//         BEGIN
//           Age := DATE2DMY(TODAY,3) - DATE2DMY(Birthday,3);
//           CurrPage.UPDATE(FALSE);
//         END;
//     end;

//     trigger OnNewRecord(BelowxRec: Boolean)
//     begin
//         IF UserSetup.GET(USERID) THEN
//           "Location Code":=UserSetup."Location Code";
//         Type:=Type::Person;
//     end;

//     var
//         Text001: Label 'PatientNo/NRIC/ EnglishName cannot be empty!';
//         Text002: Label 'Do you want to create a new Patient Card?';
//         Text003: Label 'Contact No with  NRIC %1 has already existed! ';
//         Text004: Label 'Patient card with NRIC %1 has already existed! ';
//         Text005: Label 'Do you want to use the existing Patient Card?';
//         Text006: Label 'Do you want to use the existing empty patient Card with this NRIC?';
//         Text007: Label 'A new patient card cannot be created in View status.';
//         Text008: Label 'Cannot edit previous record!';
//         Text009: Label 'No history record exists. Please click new!';
//         NoSeriesManagement: Codeunit "396";
//         RelationshipMgtSetup: Record "5079";
//         Contact: Record "5050";
//         CheckupInfo: Record "50003";
//         SalesSetup: Record "311";
//         UserSetup: Record "91";
//         Text010: Label 'Contact No  %1 has already existed! ';
// }

