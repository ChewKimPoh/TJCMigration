// page 372 "Bank Account Ledger Entries"
// {
//     Caption = 'Bank Account Ledger Entries';
//     DataCaptionFields = "Bank Account No.";
//     DeleteAllowed = false;
//     Editable = false;
//     InsertAllowed = false;
//     PageType = List;
//     SourceTable = Table271;

//     layout
//     {
//         area(content)
//         {
//             repeater()
//             {
//                 field("Posting Date";"Posting Date")
//                 {
//                     Editable = false;
//                 }
//                 field("Document Type";"Document Type")
//                 {
//                     Editable = false;
//                 }
//                 field("External Document No.";"External Document No.")
//                 {
//                     Editable = false;
//                 }
//                 field("Document No.";"Document No.")
//                 {
//                     Editable = false;
//                 }
//                 field("Bank Account No.";"Bank Account No.")
//                 {
//                     Editable = false;
//                 }
//                 field(Description;Description)
//                 {
//                     Editable = false;
//                 }
//                 field("Global Dimension 1 Code";"Global Dimension 1 Code")
//                 {
//                     Editable = false;
//                     Visible = false;
//                 }
//                 field("Global Dimension 2 Code";"Global Dimension 2 Code")
//                 {
//                     Editable = false;
//                     Visible = false;
//                 }
//                 field("Our Contact Code";"Our Contact Code")
//                 {
//                     Editable = false;
//                     Visible = false;
//                 }
//                 field("Currency Code";"Currency Code")
//                 {
//                     Editable = false;
//                     Visible = false;
//                 }
//                 field(Amount;Amount)
//                 {
//                     Editable = false;
//                 }
//                 field("Amount (LCY)";"Amount (LCY)")
//                 {
//                     Editable = false;
//                     Visible = false;
//                 }
//                 field("Remaining Amount";"Remaining Amount")
//                 {
//                     Editable = false;
//                     Visible = false;
//                 }
//                 field("Bal. Account Type";"Bal. Account Type")
//                 {
//                     Editable = false;
//                     Visible = false;
//                 }
//                 field("Bal. Account No.";"Bal. Account No.")
//                 {
//                     Editable = false;
//                     Visible = false;
//                 }
//                 field(Open;Open)
//                 {
//                     Editable = false;
//                 }
//                 field("User ID";"User ID")
//                 {
//                     Editable = false;
//                     Visible = false;
//                 }
//                 field("Source Code";"Source Code")
//                 {
//                     Editable = false;
//                     Visible = false;
//                 }
//                 field("Reason Code";"Reason Code")
//                 {
//                     Editable = false;
//                     Visible = false;
//                 }
//                 field(Reversed;Reversed)
//                 {
//                     Visible = false;
//                 }
//                 field("Reversed by Entry No.";"Reversed by Entry No.")
//                 {
//                     Visible = false;
//                 }
//                 field("Reversed Entry No.";"Reversed Entry No.")
//                 {
//                     Visible = false;
//                 }
//                 field("Entry No.";"Entry No.")
//                 {
//                     Editable = false;
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
//                 Visible = false;
//             }
//         }
//     }

//     actions
//     {
//         area(navigation)
//         {
//             group("Ent&ry")
//             {
//                 Caption = 'Ent&ry';
//                 Image = Entry;
//                 action("Check Ledger E&ntries")
//                 {
//                     Caption = 'Check Ledger E&ntries';
//                     Image = CheckLedger;
//                     RunObject = Page 374;
//                     RunPageLink = Bank Account Ledger Entry No.=FIELD(Entry No.);
//                     RunPageView = SORTING(Bank Account Ledger Entry No.);
//                     ShortCutKey = 'Shift+F7';
//                 }
//                 action(Dimensions)
//                 {
//                     Caption = 'Dimensions';
//                     Image = Dimensions;
//                     ShortCutKey = 'Shift+Ctrl+D';

//                     trigger OnAction()
//                     begin
//                         ShowDimensions;
//                     end;
//                 }
//             }
//         }
//         area(processing)
//         {
//             group("F&unctions")
//             {
//                 Caption = 'F&unctions';
//                 Image = "Action";
//                 action("Reverse Transaction")
//                 {
//                     Caption = 'Reverse Transaction';
//                     Ellipsis = true;
//                     Image = ReverseRegister;

//                     trigger OnAction()
//                     var
//                         ReversalEntry: Record "179";
//                     begin
//                         CLEAR(ReversalEntry);
//                         IF Reversed THEN
//                           ReversalEntry.AlreadyReversedEntry(TABLECAPTION,"Entry No.");
//                         IF "Journal Batch Name" = '' THEN
//                           ReversalEntry.TestFieldError;
//                         TESTFIELD("Transaction No.");
//                         ReversalEntry.ReverseTransaction("Transaction No.");
//                     end;
//                 }
//             }
//             action("&Navigate")
//             {
//                 Caption = '&Navigate';
//                 Image = Navigate;
//                 Promoted = true;
//                 PromotedCategory = Process;

//                 trigger OnAction()
//                 begin
//                     Navigate.SetDoc("Posting Date","Document No.");
//                     Navigate.RUN;
//                 end;
//             }
//         }
//     }

//     var
//         Navigate: Page "344";
// }

