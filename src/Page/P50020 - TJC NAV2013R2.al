// page 50020 "Patient List"
// {
//     Caption = 'Patient List';
//     CardPageID = "Patient Cards.";
//     DataCaptionFields = "Company No.";
//     Editable = false;
//     PageType = List;
//     PromotedActionCategories = 'New,Tasks,Reports,Patient';
//     SourceTable = Table5050;
//     SourceTableView = SORTING(No.)
//                       WHERE(Type=CONST(Person));

//     layout
//     {
//         area(content)
//         {
//             repeater()
//             {
//                 Editable = false;
//                 IndentationColumn = NameIndent;
//                 IndentationControls = Name;
//                 field("No.";"No.")
//                 {
//                 }
//                 field(Name;Name)
//                 {
//                 }
//                 field("Chinese Name";"Chinese Name")
//                 {
//                 }
//                 field("NRIC No.";"NRIC No.")
//                 {
//                     Caption = 'NRIC';
//                 }
//                 field("Location Code";"Location Code")
//                 {
//                 }
//                 field("Home Phone No.";"Home Phone No.")
//                 {
//                 }
//                 field("Phone No.";"Phone No.")
//                 {
//                     Caption = 'Office Phone No.';
//                 }
//                 field("Mobile Phone No.";"Mobile Phone No.")
//                 {
//                     Visible = false;
//                 }
//                 field(Gender;Gender)
//                 {
//                 }
//                 field(Birthday;Birthday)
//                 {
//                 }
//             }
//         }
//         area(factboxes)
//         {
//             part(PatientCheckupList;50081)
//             {
//                 Caption = 'Check Up List';
//                 SubPageLink = Contact No.=FIELD(No.);
//                 SubPageView = SORTING(Contact No.,History No.)
//                               ORDER(Ascending);
//             }
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
//                 RunObject = Page 50080;
//                 RunPageMode = Create;
//                 RunPageView = SORTING(No.)
//                               ORDER(Ascending)
//                               WHERE(Type=CONST(Person));
//             }
//             action(Edit)
//             {
//                 Ellipsis = true;
//                 Image = Edit;
//                 Promoted = true;
//                 PromotedCategory = Category4;
//                 PromotedIsBig = true;
//                 RunObject = Page 50080;
//                 RunPageLink = No.=FIELD(No.);
//                 RunPageMode = Edit;
//                 RunPageView = SORTING(No.)
//                               ORDER(Ascending)
//                               WHERE(Type=CONST(Person));
//             }
//             action(View)
//             {
//                 Ellipsis = true;
//                 Image = View;
//                 Promoted = true;
//                 PromotedCategory = Category4;
//                 PromotedIsBig = true;
//                 RunObject = Page 50080;
//                 RunPageLink = No.=FIELD(No.);
//                 RunPageMode = View;
//                 RunPageView = SORTING(No.)
//                               ORDER(Ascending)
//                               WHERE(Type=CONST(Person));
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
//         NameIndent := 0;
//         NoOnFormat;
//         NameOnFormat;
//     end;

//     trigger OnOpenPage()
//     begin
//         //SETFILTER("NRIC No.",'<>%1','');

//         //DD-415 Removal of filters by the user's Location Code
//         //UserSetup.GET(USERID);
//         //SETRANGE("Location Code", UserSetup."Location Code");
//     end;

//     var
//         Cont: Record "5050";
//         UserSetup: Record "91";
//         [InDataSet]
//         "No.Emphasize": Boolean;
//         [InDataSet]
//         NameEmphasize: Boolean;
//         [InDataSet]
//         NameIndent: Integer;

//     local procedure NoOnFormat()
//     begin
//         IF Type = Type::Company THEN
//           "No.Emphasize" := TRUE;
//     end;

//     local procedure NameOnFormat()
//     begin
//         IF Type = Type::Company THEN
//           NameEmphasize := TRUE
//         ELSE BEGIN
//           Cont.SETCURRENTKEY("Company Name","Company No.",Type,Name);
//           IF ("Company No." <> '') AND (NOT HASFILTER) AND (NOT MARKEDONLY) AND (CURRENTKEY = Cont.CURRENTKEY)
//           THEN
//             NameIndent := 1;
//         END;
//     end;
// }

