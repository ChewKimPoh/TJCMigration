// page 370 "Bank Account Card"
// {
//     Caption = 'Bank Account Card';
//     PageType = Card;
//     SourceTable = Table270;

//     layout
//     {
//         area(content)
//         {
//             group(General)
//             {
//                 Caption = 'General';
//                 field("No.";"No.")
//                 {
//                     Importance = Promoted;
//                     Style = StrongAccent;
//                     StyleExpr = TRUE;

//                     trigger OnAssistEdit()
//                     begin
//                         IF AssistEdit(xRec) THEN
//                           CurrPage.UPDATE;
//                     end;
//                 }
//                 field(Name;Name)
//                 {
//                     Importance = Promoted;
//                     Style = StrongAccent;
//                     StyleExpr = TRUE;
//                 }
//                 field(Address;Address)
//                 {
//                 }
//                 field("Address 2";"Address 2")
//                 {
//                 }
//                 field("Post Code";"Post Code")
//                 {
//                 }
//                 field(City;City)
//                 {
//                 }
//                 field("Country/Region Code";"Country/Region Code")
//                 {
//                 }
//                 field("Phone No.";"Phone No.")
//                 {
//                 }
//                 field(Contact;Contact)
//                 {
//                 }
//                 field("Bank Branch No.";"Bank Branch No.")
//                 {
//                 }
//                 field("Bank Account No.";"Bank Account No.")
//                 {
//                     Importance = Promoted;
//                 }
//                 field("Search Name";"Search Name")
//                 {
//                 }
//                 field(Balance;Balance)
//                 {
//                     Importance = Promoted;
//                 }
//                 field("Balance (LCY)";"Balance (LCY)")
//                 {
//                 }
//                 field("Min. Balance";"Min. Balance")
//                 {
//                 }
//                 field("Our Contact Code";"Our Contact Code")
//                 {
//                 }
//                 field(Blocked;Blocked)
//                 {
//                 }
//                 field("Last Date Modified";"Last Date Modified")
//                 {
//                 }
//             }
//             group(Communication)
//             {
//                 Caption = 'Communication';
//                 field("Phone No.2";"Phone No.")
//                 {
//                     Importance = Promoted;
//                 }
//                 field("Fax No.";"Fax No.")
//                 {
//                 }
//                 field("E-Mail";"E-Mail")
//                 {
//                     Importance = Promoted;
//                 }
//                 field("Home Page";"Home Page")
//                 {
//                 }
//             }
//             group(Posting)
//             {
//                 Caption = 'Posting';
//                 field("Currency Code";"Currency Code")
//                 {
//                     Importance = Promoted;
//                     Style = StrongAccent;
//                     StyleExpr = TRUE;
//                 }
//                 field("Last Check No.";"Last Check No.")
//                 {
//                 }
//                 field("Transit No.";"Transit No.")
//                 {
//                 }
//                 field("Last Statement No.";"Last Statement No.")
//                 {
//                     Importance = Promoted;
//                 }
//                 field("Balance Last Statement";"Balance Last Statement")
//                 {
//                     Importance = Promoted;

//                     trigger OnValidate()
//                     begin
//                         IF "Balance Last Statement" <> xRec."Balance Last Statement" THEN
//                           IF NOT CONFIRM(Text001,FALSE,"No.") THEN
//                             ERROR(Text002);
//                     end;
//                 }
//                 field("Bank Acc. Posting Group";"Bank Acc. Posting Group")
//                 {
//                     Importance = Promoted;
//                     Style = StrongAccent;
//                     StyleExpr = TRUE;
//                 }
//             }
//             group(Transfer)
//             {
//                 Caption = 'Transfer';
//                 field("Bank Branch No.2";"Bank Branch No.")
//                 {
//                     Importance = Promoted;
//                 }
//                 field("Bank Account No.2";"Bank Account No.")
//                 {
//                     Importance = Promoted;
//                 }
//                 field("Transit No.2";"Transit No.")
//                 {
//                 }
//                 field("SWIFT Code";"SWIFT Code")
//                 {
//                     Importance = Promoted;
//                 }
//                 field(IBAN;IBAN)
//                 {
//                     Importance = Promoted;
//                 }
//                 field("Bank Statement Import Format";"Bank Statement Import Format")
//                 {
//                     Visible = false;
//                 }
//                 field("Payment Export Format";"Payment Export Format")
//                 {
//                 }
//                 field("SEPA Direct Debit Exp. Format";"SEPA Direct Debit Exp. Format")
//                 {
//                 }
//                 field("SEPA CT Msg. ID No. Series";"SEPA CT Msg. ID No. Series")
//                 {
//                 }
//                 field("SEPA DD Msg. ID No. Series";"SEPA DD Msg. ID No. Series")
//                 {
//                 }
//                 field("Creditor No.";"Creditor No.")
//                 {
//                 }
//             }
//         }
//         area(factboxes)
//         {
//             systempart(;Links)
//             {
//                 Visible = false;
//             }
//             systempart(;Notes)
//             {
//                 Visible = true;
//             }
//         }
//     }

//     actions
//     {
//         area(navigation)
//         {
//             group("&Bank Acc.")
//             {
//                 Caption = '&Bank Acc.';
//                 Image = Bank;
//                 action(Statistics)
//                 {
//                     Caption = 'Statistics';
//                     Image = Statistics;
//                     Promoted = true;
//                     PromotedCategory = Process;
//                     RunObject = Page 375;
//                     RunPageLink = No.=FIELD(No.),
//                                   Date Filter=FIELD(Date Filter),
//                                   Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
//                                   Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter);
//                     ShortCutKey = 'F7';
//                 }
//                 action("Co&mments")
//                 {
//                     Caption = 'Co&mments';
//                     Image = ViewComments;
//                     RunObject = Page 124;
//                     RunPageLink = Table Name=CONST(Bank Account),
//                                   No.=FIELD(No.);
//                 }
//                 action(Dimensions)
//                 {
//                     Caption = 'Dimensions';
//                     Image = Dimensions;
//                     RunObject = Page 540;
//                     RunPageLink = Table ID=CONST(270),
//                                   No.=FIELD(No.);
//                     ShortCutKey = 'Shift+Ctrl+D';
//                 }
//                 action(Balance)
//                 {
//                     Caption = 'Balance';
//                     Image = Balance;
//                     RunObject = Page 377;
//                     RunPageLink = No.=FIELD(No.),
//                                   Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
//                                   Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter);
//                 }
//                 action("St&atements")
//                 {
//                     Caption = 'St&atements';
//                     Image = "Report";
//                     Promoted = true;
//                     PromotedCategory = Process;
//                     RunObject = Page 389;
//                     RunPageLink = Bank Account No.=FIELD(No.);
//                 }
//                 action("Ledger E&ntries")
//                 {
//                     Caption = 'Ledger E&ntries';
//                     Image = BankAccountLedger;
//                     Promoted = false;
//                     //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
//                     //PromotedCategory = Process;
//                     RunObject = Page 372;
//                     RunPageLink = Bank Account No.=FIELD(No.);
//                     RunPageView = SORTING(Bank Account No.);
//                     ShortCutKey = 'Ctrl+F7';
//                 }
//                 action("Chec&k Ledger Entries")
//                 {
//                     Caption = 'Chec&k Ledger Entries';
//                     Image = CheckLedger;
//                     RunObject = Page 374;
//                     RunPageLink = Bank Account No.=FIELD(No.);
//                     RunPageView = SORTING(Bank Account No.);
//                 }
//                 action("C&ontact")
//                 {
//                     Caption = 'C&ontact';
//                     Image = ContactPerson;
//                     Visible = ContactActionVisible;

//                     trigger OnAction()
//                     begin
//                         ShowContact;
//                     end;
//                 }
//                 separator()
//                 {
//                 }
//                 action("Online Map")
//                 {
//                     Caption = 'Online Map';
//                     Image = Map;

//                     trigger OnAction()
//                     begin
//                         DisplayMap;
//                     end;
//                 }
//             }
//             action("Bank Account Reconciliations")
//             {
//                 Caption = 'Bank Account Reconciliations';
//                 Image = BankAccountRec;
//                 Promoted = true;
//                 PromotedCategory = Process;
//                 RunObject = Page 388;
//                 RunPageLink = Bank Account No.=FIELD(No.);
//                 RunPageView = SORTING(Bank Account No.);
//             }
//             action("Receivables-Payables")
//             {
//                 Caption = 'Receivables-Payables';
//                 Image = ReceivablesPayables;
//                 Promoted = true;
//                 PromotedCategory = Process;
//                 RunObject = Page 355;
//             }
//         }
//         area(processing)
//         {
//             action("Cash Receipt Journals")
//             {
//                 Caption = 'Cash Receipt Journals';
//                 Image = Journals;
//                 Promoted = true;
//                 PromotedCategory = Process;
//                 RunObject = Page 255;
//             }
//             action("Payment Journals")
//             {
//                 Caption = 'Payment Journals';
//                 Image = Journals;
//                 Promoted = true;
//                 PromotedCategory = Process;
//                 RunObject = Page 256;
//             }
//         }
//         area(reporting)
//         {
//             action(List)
//             {
//                 Caption = 'List';
//                 Image = OpportunitiesList;
//                 Promoted = true;
//                 PromotedCategory = "Report";
//                 RunObject = Report 1402;
//             }
//             action("Detail Trial Balance")
//             {
//                 Caption = 'Detail Trial Balance';
//                 Image = "Report";
//                 Promoted = true;
//                 PromotedCategory = "Report";
//                 RunObject = Report 1404;
//             }
//             action("Receivables-Payables")
//             {
//                 Caption = 'Receivables-Payables';
//                 Image = ReceivablesPayables;
//                 Promoted = false;
//                 //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
//                 //PromotedCategory = "Report";
//                 RunObject = Report 5;
//             }
//             action("Check Details")
//             {
//                 Caption = 'Check Details';
//                 Image = "Report";
//                 Promoted = true;
//                 PromotedCategory = "Report";
//                 RunObject = Report 1406;
//             }
//         }
//     }

//     trigger OnAfterGetRecord()
//     begin
//         CALCFIELDS("Check Report Name");
//     end;

//     trigger OnInit()
//     begin
//         MapPointVisible := TRUE;
//     end;

//     trigger OnOpenPage()
//     var
//         Contact: Record "5050";
//         MapMgt: Codeunit "802";
//     begin
//         IF NOT MapMgt.TestSetup THEN
//           MapPointVisible := FALSE;
//         ContactActionVisible := Contact.READPERMISSION;
//     end;

//     var
//         [InDataSet]
//         MapPointVisible: Boolean;
//         Text001: Label 'There may be a statement using the %1.\\Do you want to change Balance Last Statement?';
//         Text002: Label 'Canceled.';
//         [InDataSet]
//         ContactActionVisible: Boolean;
// }

