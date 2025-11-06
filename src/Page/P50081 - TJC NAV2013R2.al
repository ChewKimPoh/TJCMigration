// page 50081 "Check Up List."
// {
//     // Version No.         : TJCSG1.00
//     // Developer           : DP.AYD
//     // Init. DEV. Date     : 27/6/2014
//     // Date of last Change : 27/6/2014
//     // Description         : Based on DD#166
//     // 
//     // TJCSG1.00
//     //  2. 04/07/2014  dp.dst
//     //     Last Changes: 08/07/2014.
//     //     - Added new Action "Close Check-up Card" to set the status of this Check-up Card to Closed.
//     //     - Closed card cannot be edited or deleted.
//     //     - Moved it to card level, changed the Visible property to FALSE.

//     AutoSplitKey = true;
//     CardPageID = "Check Up Card";
//     MultipleNewLines = true;
//     PageType = ListPart;
//     PromotedActionCategories = 'New,Tasks,Reports,Patient Checkup';
//     RefreshOnActivate = true;
//     ShowFilter = false;
//     SourceTable = Table50003;

//     layout
//     {
//         area(content)
//         {
//             repeater("Patient Lines")
//             {
//                 Caption = 'Patient Lines';
//                 Editable = false;
//                 field("Contact No.";"Contact No.")
//                 {
//                     Visible = false;
//                 }
//                 field("History No.";"History No.")
//                 {
//                 }
//                 field("Visit Date";"Visit Date")
//                 {
//                 }
//                 field("Doctor Name";"Doctor Name")
//                 {
//                 }
//                 field(Category;Category)
//                 {
//                 }
//                 field(Sickness;Sickness)
//                 {
//                 }
//                 field(Type;Type)
//                 {
//                 }
//             }
//         }
//     }

//     actions
//     {
//         area(processing)
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
//                 Enabled = false;
//                 Image = Cancel;
//                 Promoted = true;
//                 PromotedCategory = Category4;
//                 PromotedIsBig = true;
//                 Visible = false;

//                 trigger OnAction()
//                 var
//                     LPatientInfo: Record "50003";
//                     LPatientInfoDetaill: Record "50004";
//                     Answer: Boolean;
//                 begin
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
//             action("Co&mments")
//             {
//                 Caption = 'Co&mments';
//                 Image = ViewComments;
//                 Promoted = true;
//                 PromotedCategory = Category4;
//                 PromotedIsBig = true;
//                 RunObject = Page 50086;
//                 RunPageLink = No.=FIELD(Contact No.);
//                 RunPageView = SORTING(Table Name,No.,Sub No.,Line No.)
//                               ORDER(Ascending)
//                               WHERE(Table Name=CONST(Contact),
//                                     Sub No.=CONST(0));
//             }
//             action(MedicineSticker)
//             {
//                 Caption = 'Medicine &Sticker';
//                 Image = PrintDocument;
//                 Promoted = true;
//                 PromotedCategory = "Report";
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
//                 Image = PrintDocument;
//                 Promoted = true;
//                 PromotedCategory = "Report";
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
//                 Image = Copy;
//                 Promoted = true;
//                 PromotedCategory = Process;
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
//                 Visible = false;

//                 trigger OnAction()
//                 begin
//                     /*Start: TJCSG1.00 #2*/
//                     IF Status = Status::Open THEN BEGIN
//                       Status := Status::Closed;
//                       MODIFY;
//                     END ELSE
//                       ERROR(TJCSG_Text000);
//                     /*End: TJCSG1.00 #2*/

//                 end;
//             }
//         }
//     }

//     var
//         TJCSG_Text000: Label 'The status is already Closed.';
// }

