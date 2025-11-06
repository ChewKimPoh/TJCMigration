// page 25 "Customer Ledger Entries"
// {
//     Caption = 'Customer Ledger Entries';
//     DataCaptionFields = "Customer No.";
//     DeleteAllowed = false;
//     InsertAllowed = false;
//     PageType = List;
//     SourceTable = Table21;

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
//                     StyleExpr = StyleTxt;
//                 }
//                 field("External Document No.";"External Document No.")
//                 {
//                 }
//                 field("Document Date";"Document Date")
//                 {
//                 }
//                 field("Document No.";"Document No.")
//                 {
//                     Editable = false;
//                     StyleExpr = StyleTxt;
//                 }
//                 field("Customer No.";"Customer No.")
//                 {
//                     Editable = false;
//                 }
//                 field("Message to Recipient";"Message to Recipient")
//                 {
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
//                 field("IC Partner Code";"IC Partner Code")
//                 {
//                     Editable = false;
//                     Visible = false;
//                 }
//                 field("Salesperson Code";"Salesperson Code")
//                 {
//                     Editable = false;
//                     Visible = false;
//                 }
//                 field("Currency Code";"Currency Code")
//                 {
//                     Editable = false;
//                 }
//                 field("Original Amount";"Original Amount")
//                 {
//                     Editable = false;
//                 }
//                 field("Original Amt. (LCY)";"Original Amt. (LCY)")
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
//                 }
//                 field("Remaining Amt. (LCY)";"Remaining Amt. (LCY)")
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
//                 field("Due Date";"Due Date")
//                 {
//                     StyleExpr = StyleTxt;
//                 }
//                 field("Pmt. Discount Date";"Pmt. Discount Date")
//                 {
//                 }
//                 field("Pmt. Disc. Tolerance Date";"Pmt. Disc. Tolerance Date")
//                 {
//                 }
//                 field("Original Pmt. Disc. Possible";"Original Pmt. Disc. Possible")
//                 {
//                 }
//                 field("Remaining Pmt. Disc. Possible";"Remaining Pmt. Disc. Possible")
//                 {
//                 }
//                 field("Max. Payment Tolerance";"Max. Payment Tolerance")
//                 {
//                 }
//                 field("Payment Method Code";"Payment Method Code")
//                 {
//                 }
//                 field(Open;Open)
//                 {
//                     Editable = false;
//                 }
//                 field("Closed by Entry No.";"Closed by Entry No.")
//                 {
//                 }
//                 field("Closed at Date";"Closed at Date")
//                 {
//                 }
//                 field("On Hold";"On Hold")
//                 {
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
//                 field("Exported to Payment File";"Exported to Payment File")
//                 {
//                 }
//                 field("Direct Debit Mandate ID";"Direct Debit Mandate ID")
//                 {
//                     Visible = false;
//                 }
//             }
//         }
//         area(factboxes)
//         {
//             part(;9106)
//             {
//                 SubPageLink = Entry No.=FIELD(Entry No.);
//                 Visible = true;
//             }
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
//                 action("Reminder/Fin. Charge Entries")
//                 {
//                     Caption = 'Reminder/Fin. Charge Entries';
//                     Image = Reminder;
//                     RunObject = Page 444;
//                     RunPageLink = Customer Entry No.=FIELD(Entry No.);
//                     RunPageView = SORTING(Customer Entry No.);
//                 }
//                 action("Applied E&ntries")
//                 {
//                     Caption = 'Applied E&ntries';
//                     Image = Approve;
//                     RunObject = Page 61;
//                     RunPageOnRec = true;
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
//                 action("Detailed &Ledger Entries")
//                 {
//                     Caption = 'Detailed &Ledger Entries';
//                     Image = View;
//                     RunObject = Page 573;
//                     RunPageLink = Cust. Ledger Entry No.=FIELD(Entry No.),
//                                   Customer No.=FIELD(Customer No.);
//                     RunPageView = SORTING(Cust. Ledger Entry No.,Posting Date);
//                     ShortCutKey = 'Ctrl+F7';
//                 }
//             }
//         }
//         area(processing)
//         {
//             group("F&unctions")
//             {
//                 Caption = 'F&unctions';
//                 Image = "Action";
//                 action("Apply Entries")
//                 {
//                     Caption = 'Apply Entries';
//                     Image = ApplyEntries;
//                     ShortCutKey = 'Shift+F11';

//                     trigger OnAction()
//                     var
//                         CustLedgEntry: Record "21";
//                         CustEntryApplyPostEntries: Codeunit "226";
//                     begin
//                         CustLedgEntry.COPY(Rec);
//                         CustEntryApplyPostEntries.ApplyCustEntryFormEntry(CustLedgEntry);
//                         Rec := CustLedgEntry;
//                         CurrPage.UPDATE;
//                     end;
//                 }
//                 separator()
//                 {
//                 }
//                 action(UnapplyEntries)
//                 {
//                     Caption = 'Unapply Entries';
//                     Ellipsis = true;
//                     Image = UnApply;

//                     trigger OnAction()
//                     var
//                         CustEntryApplyPostedEntries: Codeunit "226";
//                     begin
//                         CustEntryApplyPostedEntries.UnApplyCustLedgEntry("Entry No.");
//                     end;
//                 }
//                 separator()
//                 {
//                 }
//                 action(ReverseTransaction)
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
//             action("Incoming Document")
//             {
//                 Caption = 'Incoming Document';
//                 Image = Document;
//                 Promoted = true;
//                 PromotedCategory = Process;

//                 trigger OnAction()
//                 var
//                     IncomingDocument: Record "130";
//                 begin
//                     IncomingDocument.HyperlinkToDocument("Document No.","Posting Date");
//                 end;
//             }
//         }
//     }

//     trigger OnAfterGetRecord()
//     begin
//         StyleTxt := SetStyle;
//     end;

//     trigger OnModifyRecord(): Boolean
//     begin
//         CODEUNIT.RUN(CODEUNIT::"Cust. Entry-Edit",Rec);
//         EXIT(FALSE);
//     end;

//     var
//         Navigate: Page "344";
//         StyleTxt: Text;
// }

