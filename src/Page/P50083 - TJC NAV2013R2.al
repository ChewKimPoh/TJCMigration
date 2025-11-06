// page 50083 "Check Up Card"
// {
//     // Version No.         : TJCSG1.00
//     // Developer           : DP.AYD
//     // Init. DEV. Date     : 27/6/2014
//     // Description         : Based on DD#166
//     // 
//     // TJCSG1.00
//     //  2. 04/07/2014  dp.dst
//     //     TJC DD #178
//     //     Last Changes: 08/07/2014.
//     //     - Inserted codes on OnAfterGetRecord() to change the page mode to non-editable if the Status is Closed.
//     //     - Inserted codes on OnModifyRecord() and OnDeleteRecord() to prevent users from modifing or deleting the record
//     //       if the Status is Closed.
//     //     - Inserted codes on Cancel - OnAction() to disallow the deletion if the Checkup Info's status is Closed.
//     //     - Created new action "Close Check-up Card" to change the status to Closed (moved from Patient Check-up List).

//     PageType = Document;
//     PromotedActionCategories = 'New,Proces,Report,Patient Checkup,Reports,Tasks';
//     RefreshOnActivate = true;
//     SourceTable = Table50003;

//     layout
//     {
//         area(content)
//         {
//             group(General)
//             {
//                 field("Contact No.";"Contact No.")
//                 {
//                     Editable = false;
//                     Importance = Promoted;
//                 }
//                 field("History No.";"History No.")
//                 {
//                     Editable = false;
//                     Importance = Promoted;
//                 }
//                 field("Visit Date";"Visit Date")
//                 {
//                     Importance = Promoted;
//                 }
//                 field("Doctor code";"Doctor code")
//                 {
//                     Importance = Additional;
//                 }
//                 field("Doctor Name";"Doctor Name")
//                 {
//                     Importance = Promoted;
//                 }
//                 field("Location Code";"Location Code")
//                 {
//                     Importance = Additional;
//                 }
//                 field(Tongue1;Tongue1)
//                 {
//                 }
//                 field(Tongue2;Tongue2)
//                 {
//                     Importance = Additional;
//                 }
//                 field("Left Pulse";"Left Pulse")
//                 {
//                     Importance = Promoted;
//                 }
//                 field("Right Pulse";"Right Pulse")
//                 {
//                     Importance = Additional;
//                 }
//                 field(Status;Status)
//                 {
//                     Editable = false;
//                 }
//                 field("Low Blood Pressure";"Low Blood Pressure")
//                 {
//                     Importance = Promoted;
//                 }
//                 field("High Blood Pressure";"High Blood Pressure")
//                 {
//                     Importance = Promoted;
//                 }
//                 field("Category No.";"Category No.")
//                 {
//                     Importance = Additional;
//                 }
//                 field(Category;Category)
//                 {
//                     Editable = false;
//                     Importance = Promoted;
//                 }
//                 field("Sickness No.";"Sickness No.")
//                 {
//                     Importance = Additional;
//                 }
//                 field(Sickness;Sickness)
//                 {
//                     Editable = false;
//                     Importance = Promoted;
//                 }
//                 field("Type No.";"Type No.")
//                 {
//                     Importance = Additional;
//                 }
//                 field(Type;Type)
//                 {
//                     Editable = false;
//                     Importance = Promoted;
//                 }
//                 field("Diagnosis Info";"Diagnosis Info")
//                 {
//                     Importance = Promoted;
//                     MultiLine = true;
//                     RowSpan = 10;
//                 }
//             }
//             part(;50084)
//             {
//                 ShowFilter = false;
//                 SubPageLink = Contact No.=FIELD(Contact No.),
//                               History No.=FIELD(History No.);
//                 SubPageView = SORTING(Contact No.,History No.,Line No.)
//                               ORDER(Ascending);
//             }
//         }
//         area(factboxes)
//         {
//             part("Patient Info";50087)
//             {
//                 Caption = 'Patient Info';
//                 SubPageLink = No.=FIELD(Contact No.);
//                 SubPageView = SORTING(No.)
//                               ORDER(Ascending)
//                               WHERE(Type=CONST(Person));
//             }
//             part(PatientCommentSheet;50086)
//             {
//                 Caption = 'Comment Sheet';
//                 Editable = false;
//                 SubPageLink = No.=FIELD(Contact No.);
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
//             action(View)
//             {
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
//             action(Edit)
//             {
//                 Image = Edit;
//                 Promoted = true;
//                 PromotedCategory = Category4;
//                 PromotedIsBig = true;
//                 RunObject = Page 50083;
//                 RunPageLink = Contact No.=FIELD(Contact No.),
//                               History No.=FIELD(History No.);
//                 RunPageMode = Edit;
//                 RunPageView = SORTING(Contact No.,History No.)
//                               ORDER(Ascending);
//             }
//             action(New)
//             {
//                 Ellipsis = true;
//                 Image = NewDocument;
//                 Promoted = true;
//                 PromotedCategory = Category4;
//                 PromotedIsBig = true;
//                 RunObject = Page 50083;
//                 RunPageLink = Contact No.=FIELD(Contact No.);
//                 RunPageMode = Create;
//                 RunPageView = SORTING(Contact No.,History No.)
//                               ORDER(Ascending);
//             }
//             action(Cancel)
//             {
//                 Image = Cancel;
//                 Promoted = true;
//                 PromotedCategory = Category4;
//                 PromotedIsBig = true;

//                 trigger OnAction()
//                 var
//                     LPatientInfo: Record "50003";
//                     LPatientInfoDetaill: Record "50004";
//                     Answer: Boolean;
//                 begin
//                     /*Start: TJCSG1.00 #2*/
//                     IF Status = Status::Closed THEN
//                       ERROR(TJCSG_Text001,"Contact No.");
//                     /*End: TJCSG1.00 #2*/

//                     IF CONFIRM('Do you want to cancel record ',TRUE) THEN BEGIN
//                       LPatientInfoDetaill.SETRANGE("Contact No.","Contact No.");
//                       LPatientInfoDetaill.SETRANGE("History No.","History No.");
//                       IF LPatientInfoDetaill.FIND('-') THEN
//                       BEGIN
//                         Answer:=CONFIRM('This Record contains Patient Prescription Detail, do you still want to delete?',TRUE) ;
//                         IF Answer THEN
//                           BEGIN
//                             REPEAT
//                               LPatientInfoDetaill.DELETE;
//                             UNTIL LPatientInfoDetaill.NEXT=0;
//                             IF LPatientInfo.GET("Contact No.","History No.") THEN
//                               LPatientInfo.DELETE;
//                           END;
//                       END
//                       ELSE
//                         IF LPatientInfo.GET("Contact No.","History No.") THEN
//                           LPatientInfo.DELETE;

//                       CurrPage.UPDATE(FALSE);
//                     END;

//                 end;
//             }
//             action(Comments)
//             {
//                 Caption = 'Co&mments';
//                 Ellipsis = true;
//                 Image = ViewComments;
//                 Promoted = true;
//                 PromotedCategory = Category4;
//                 PromotedIsBig = true;
//                 RunObject = Page 50086;
//                 RunPageLink = No.=FIELD(Contact No.);
//                 RunPageMode = Edit;
//                 RunPageView = SORTING(Table Name,No.,Sub No.,Line No.)
//                               ORDER(Ascending)
//                               WHERE(Table Name=CONST(Contact),
//                                     Sub No.=CONST(0));
//             }
//             action(MedicineSticker)
//             {
//                 Caption = 'Medicine &Sticker';
//                 Ellipsis = true;
//                 Image = PrintDocument;
//                 Promoted = true;
//                 PromotedCategory = Category4;
//                 PromotedIsBig = true;

//                 trigger OnAction()
//                 var
//                     PPDetail: Record "50004";
//                     Medicine: Report "50030";
//                 begin
//                     PPDetail.RESET;
//                     PPDetail.SETRANGE("Contact No.","Contact No.");
//                     PPDetail.SETRANGE(PPDetail."History No.","History No.");
//                     Medicine.SETTABLEVIEW(PPDetail);
//                     Medicine.RUN;
//                 end;
//             }
//             action(MedicinePrescription)
//             {
//                 Caption = 'Medicine &Prescription';
//                 Ellipsis = true;
//                 Image = PrintDocument;
//                 Promoted = true;
//                 PromotedCategory = Category4;
//                 PromotedIsBig = true;

//                 trigger OnAction()
//                 var
//                     PPDetail: Record "50003";
//                     Medicine: Report "50032";
//                 begin
//                     PPDetail.RESET;
//                     PPDetail.SETRANGE("Contact No.","Contact No.");
//                     PPDetail.SETRANGE(PPDetail."History No.","History No.");
//                     Medicine.SETTABLEVIEW(PPDetail);
//                     Medicine.RUN;
//                 end;
//             }
//             action(CopyMedicine)
//             {
//                 Caption = '&Copy Medicine';
//                 Ellipsis = true;
//                 Image = Copy;
//                 Promoted = true;
//                 PromotedCategory = Category4;
//                 PromotedIsBig = true;

//                 trigger OnAction()
//                 var
//                     CopyMedicine: Report "50031";
//                 begin
//                     CopyMedicine.SetValue("Contact No.","History No.");
//                     CopyMedicine.RUN;
//                 end;
//             }
//             action("Close Check-up Card")
//             {
//                 Image = CloseDocument;
//                 Promoted = true;
//                 PromotedCategory = Process;
//                 PromotedIsBig = true;

//                 trigger OnAction()
//                 begin
//                     /*Start: TJCSG1.00 #2*/
//                     IF Status = Status::Open THEN BEGIN
//                       Status := Status::Closed;
//                       MODIFY;
//                     END ELSE
//                       ERROR(TJCSG_Text002);
//                     /*End: TJCSG1.00 #2*/

//                 end;
//             }
//         }
//     }

//     trigger OnAfterGetRecord()
//     begin
//         /*Start: TJCSG1.00 #2*/
//         /*
//         IF Status = Status::Closed THEN
//           CurrPage.EDITABLE := FALSE
//         ELSE
//           CurrPage.EDITABLE := TRUE;

//         CurrPage.UPDATE(False);
//         */
//         /*End: TJCSG1.00 #2*/

//     end;

//     trigger OnDeleteRecord(): Boolean
//     begin
//         /*Start: TJCSG1.00 #2*/
//         IF Status = Status::Closed THEN
//           ERROR(TJCSG_Text001,"Contact No.");
//         /*End: TJCSG1.00 #2*/

//     end;

//     trigger OnModifyRecord(): Boolean
//     begin
//         /*Start: TJCSG1.00 #2*/
//         IF Status = Status::Closed THEN
//           ERROR(TJCSG_Text000,"Contact No.");
//         /*End: TJCSG1.00 #2*/

//     end;

//     trigger OnNewRecord(BelowxRec: Boolean)
//     var
//         PatientInfo: Record "50003";
//         tblUser: Record "2000000120";
//         UserSetup: Record "91";
//     begin
//         PatientInfo.RESET;
//         PatientInfo.SETRANGE("Contact No.","Contact No.");
//         IF PatientInfo.FIND('+') THEN
//           "History No.":=PatientInfo."History No."+1
//         ELSE
//           "History No.":=1;

//         "Visit Date":=TODAY;

//         "Doctor code":=USERID;
//         tblUser.SETRANGE("User Name",USERID);
//         IF tblUser.FIND('-') THEN
//           "Doctor Name":=tblUser."Full Name";

//         IF UserSetup.GET(USERID) THEN
//           "Location Code":=UserSetup."Location Code";
//     end;

//     var
//         TJCSG_Text000: Label 'The status of this Check Up info for this Patient %1 is closed. \You cannot make any changes on it.';
//         TJCSG_Text001: Label 'The status of this Check Up info for this Patient %1 is closed. \You cannot delete it.';
//         TJCSG_Text002: Label 'The status of this Check Up info for this Patient is already CLOSED.';
// }

