// page 20 "General Ledger Entries"
// {
//     Caption = 'General Ledger Entries';
//     DataCaptionExpression = GetCaption;
//     Editable = false;
//     PageType = List;
//     SourceTable = Table17;

//     layout
//     {
//         area(content)
//         {
//             repeater()
//             {
//                 field("System-Created Entry";"System-Created Entry")
//                 {
//                 }
//                 field("Posting Date";"Posting Date")
//                 {
//                 }
//                 field("Source Type";"Source Type")
//                 {
//                 }
//                 field("VAT Bus. Posting Group";"VAT Bus. Posting Group")
//                 {
//                 }
//                 field("VAT Prod. Posting Group";"VAT Prod. Posting Group")
//                 {
//                 }
//                 field("Source No.";"Source No.")
//                 {
//                 }
//                 field("Document Type";"Document Type")
//                 {
//                 }
//                 field("Document No.";"Document No.")
//                 {
//                 }
//                 field("G/L Account No.";"G/L Account No.")
//                 {
//                 }
//                 field("G/L Account Name";"G/L Account Name")
//                 {
//                     DrillDown = false;
//                     Visible = false;
//                 }
//                 field(Description;Description)
//                 {
//                 }
//                 field("Job No.";"Job No.")
//                 {
//                     Visible = false;
//                 }
//                 field("Global Dimension 1 Code";"Global Dimension 1 Code")
//                 {
//                     Visible = false;
//                 }
//                 field("Global Dimension 2 Code";"Global Dimension 2 Code")
//                 {
//                     Visible = false;
//                 }
//                 field("IC Partner Code";"IC Partner Code")
//                 {
//                     Visible = false;
//                 }
//                 field("Gen. Posting Type";"Gen. Posting Type")
//                 {
//                 }
//                 field("Gen. Bus. Posting Group";"Gen. Bus. Posting Group")
//                 {
//                 }
//                 field("Gen. Prod. Posting Group";"Gen. Prod. Posting Group")
//                 {
//                 }
//                 field(Amount;Amount)
//                 {
//                 }
//                 field("Additional-Currency Amount";"Additional-Currency Amount")
//                 {
//                     Visible = false;
//                 }
//                 field("VAT Amount";"VAT Amount")
//                 {
//                     Visible = false;
//                 }
//                 field("Bal. Account Type";"Bal. Account Type")
//                 {
//                 }
//                 field("Bal. Account No.";"Bal. Account No.")
//                 {
//                 }
//                 field("User ID";"User ID")
//                 {
//                     Visible = false;
//                 }
//                 field("Source Code";"Source Code")
//                 {
//                     Visible = false;
//                 }
//                 field("Reason Code";"Reason Code")
//                 {
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
//                 field("FA Entry Type";"FA Entry Type")
//                 {
//                     Visible = false;
//                 }
//                 field("FA Entry No.";"FA Entry No.")
//                 {
//                     Visible = false;
//                 }
//                 field("Entry No.";"Entry No.")
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
//                 action(Dimensions)
//                 {
//                     Caption = 'Dimensions';
//                     Image = Dimensions;
//                     ShortCutKey = 'Shift+Ctrl+D';

//                     trigger OnAction()
//                     begin
//                         ShowDimensions;
//                         CurrPage.SAVERECORD;
//                     end;
//                 }
//                 action(GLDimensionOverview)
//                 {
//                     Caption = 'G/L Dimension Overview';
//                     Image = Dimensions;

//                     trigger OnAction()
//                     begin
//                         PAGE.RUN(PAGE::"G/L Entries Dimension Overview",Rec);
//                     end;
//                 }
//                 action("Value Entries")
//                 {
//                     Caption = 'Value Entries';
//                     Image = ValueLedger;

//                     trigger OnAction()
//                     begin
//                         ShowValueEntries;
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
//                         ReversalEntry.ReverseTransaction("Transaction No.")
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
//                 var
//                     Navigate: Page "344";
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

//     var
//         GLAcc: Record "15";

//     local procedure GetCaption(): Text[250]
//     begin
//         IF GLAcc."No." <> "G/L Account No." THEN
//           IF NOT GLAcc.GET("G/L Account No.") THEN
//             IF GETFILTER("G/L Account No.") <> '' THEN
//               IF GLAcc.GET(GETRANGEMIN("G/L Account No.")) THEN;
//         EXIT(STRSUBSTNO('%1 %2',GLAcc."No.",GLAcc.Name))
//     end;
// }

