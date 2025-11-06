// page 255 "Cash Receipt Journal"
// {
//     AutoSplitKey = true;
//     Caption = 'Cash Receipt Journal';
//     DataCaptionExpression = DataCaption;
//     DelayedInsert = true;
//     PageType = Worksheet;
//     SaveValues = true;
//     SourceTable = Table81;

//     layout
//     {
//         area(content)
//         {
//             field(CurrentJnlBatchName;CurrentJnlBatchName)
//             {
//                 Caption = 'Batch Name';
//                 Lookup = true;

//                 trigger OnLookup(var Text: Text): Boolean
//                 begin
//                     CurrPage.SAVERECORD;
//                     GenJnlManagement.LookupName(CurrentJnlBatchName,Rec);
//                     CurrPage.UPDATE(FALSE);
//                 end;

//                 trigger OnValidate()
//                 begin
//                     GenJnlManagement.CheckName(CurrentJnlBatchName,Rec);
//                     CurrentJnlBatchNameOnAfterVali;
//                 end;
//             }
//             repeater()
//             {
//                 field("Posting Date";"Posting Date")
//                 {
//                 }
//                 field("Document Date";"Document Date")
//                 {
//                     Visible = false;
//                 }
//                 field("Document Type";"Document Type")
//                 {
//                 }
//                 field("Document No.";"Document No.")
//                 {
//                 }
//                 field("Incoming Document Entry No.";"Incoming Document Entry No.")
//                 {
//                     Visible = false;

//                     trigger OnAssistEdit()
//                     begin
//                         IF "Incoming Document Entry No." > 0 THEN
//                           HYPERLINK(GetIncomingDocumentURL);
//                     end;
//                 }
//                 field("External Document No.";"External Document No.")
//                 {
//                     Visible = false;
//                 }
//                 field("Account Type";"Account Type")
//                 {

//                     trigger OnValidate()
//                     begin
//                         GenJnlManagement.GetAccounts(Rec,AccName,BalAccName);
//                     end;
//                 }
//                 field("Account No.";"Account No.")
//                 {

//                     trigger OnValidate()
//                     begin
//                         GenJnlManagement.GetAccounts(Rec,AccName,BalAccName);
//                         ShowShortcutDimCode(ShortcutDimCode);
//                     end;
//                 }
//                 field("Posting Group";"Posting Group")
//                 {
//                 }
//                 field(Description;Description)
//                 {
//                 }
//                 field("Debit Amount";"Debit Amount")
//                 {
//                 }
//                 field("Credit Amount";"Credit Amount")
//                 {
//                 }
//                 field("Salespers./Purch. Code";"Salespers./Purch. Code")
//                 {
//                     Visible = false;
//                 }
//                 field("Campaign No.";"Campaign No.")
//                 {
//                     Visible = false;
//                 }
//                 field("Currency Code";"Currency Code")
//                 {
//                     AssistEdit = true;
//                     Visible = false;

//                     trigger OnAssistEdit()
//                     begin
//                         ChangeExchangeRate.SetParameter("Currency Code","Currency Factor","Posting Date");
//                         IF ChangeExchangeRate.RUNMODAL = ACTION::OK THEN
//                           VALIDATE("Currency Factor",ChangeExchangeRate.GetParameter);

//                         CLEAR(ChangeExchangeRate);
//                     end;
//                 }
//                 field("Gen. Posting Type";"Gen. Posting Type")
//                 {
//                     Visible = false;
//                 }
//                 field("Gen. Bus. Posting Group";"Gen. Bus. Posting Group")
//                 {
//                     Visible = false;
//                 }
//                 field("Gen. Prod. Posting Group";"Gen. Prod. Posting Group")
//                 {
//                     Visible = false;
//                 }
//                 field("VAT Bus. Posting Group";"VAT Bus. Posting Group")
//                 {
//                     Visible = false;
//                 }
//                 field("VAT Prod. Posting Group";"VAT Prod. Posting Group")
//                 {
//                     Visible = false;
//                 }
//                 field(Amount;Amount)
//                 {
//                 }
//                 field("VAT Amount";"VAT Amount")
//                 {
//                     Visible = false;
//                 }
//                 field("VAT Difference";"VAT Difference")
//                 {
//                     Visible = false;
//                 }
//                 field("Bal. VAT Amount";"Bal. VAT Amount")
//                 {
//                     Visible = false;
//                 }
//                 field("Bal. VAT Difference";"Bal. VAT Difference")
//                 {
//                     Visible = false;
//                 }
//                 field("Bal. Account Type";"Bal. Account Type")
//                 {
//                 }
//                 field("Bal. Account No.";"Bal. Account No.")
//                 {

//                     trigger OnValidate()
//                     begin
//                         GenJnlManagement.GetAccounts(Rec,AccName,BalAccName);
//                         ShowShortcutDimCode(ShortcutDimCode);
//                     end;
//                 }
//                 field("Credit Card No.";"Credit Card No.")
//                 {
//                     Visible = false;
//                 }
//                 field("Bal. Gen. Posting Type";"Bal. Gen. Posting Type")
//                 {
//                     Visible = false;
//                 }
//                 field("Bal. Gen. Bus. Posting Group";"Bal. Gen. Bus. Posting Group")
//                 {
//                     Visible = false;
//                 }
//                 field("Bal. Gen. Prod. Posting Group";"Bal. Gen. Prod. Posting Group")
//                 {
//                     Visible = false;
//                 }
//                 field("Bal. VAT Bus. Posting Group";"Bal. VAT Bus. Posting Group")
//                 {
//                     Visible = false;
//                 }
//                 field("Bal. VAT Prod. Posting Group";"Bal. VAT Prod. Posting Group")
//                 {
//                     Visible = false;
//                 }
//                 field("Shortcut Dimension 1 Code";"Shortcut Dimension 1 Code")
//                 {
//                     Visible = false;
//                 }
//                 field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
//                 {
//                     Visible = false;
//                 }
//                 field(ShortcutDimCode[3];ShortcutDimCode[3])
//                 {
//                     CaptionClass = '1,2,3';
//                     Visible = false;

//                     trigger OnLookup(var Text: Text): Boolean
//                     begin
//                         LookupShortcutDimCode(3,ShortcutDimCode[3]);
//                     end;

//                     trigger OnValidate()
//                     begin
//                         ValidateShortcutDimCode(3,ShortcutDimCode[3]);
//                     end;
//                 }
//                 field(ShortcutDimCode[4];ShortcutDimCode[4])
//                 {
//                     CaptionClass = '1,2,4';
//                     Visible = false;

//                     trigger OnLookup(var Text: Text): Boolean
//                     begin
//                         LookupShortcutDimCode(4,ShortcutDimCode[4]);
//                     end;

//                     trigger OnValidate()
//                     begin
//                         ValidateShortcutDimCode(4,ShortcutDimCode[4]);
//                     end;
//                 }
//                 field(ShortcutDimCode[5];ShortcutDimCode[5])
//                 {
//                     CaptionClass = '1,2,5';
//                     Visible = false;

//                     trigger OnLookup(var Text: Text): Boolean
//                     begin
//                         LookupShortcutDimCode(5,ShortcutDimCode[5]);
//                     end;

//                     trigger OnValidate()
//                     begin
//                         ValidateShortcutDimCode(5,ShortcutDimCode[5]);
//                     end;
//                 }
//                 field(ShortcutDimCode[6];ShortcutDimCode[6])
//                 {
//                     CaptionClass = '1,2,6';
//                     Visible = false;

//                     trigger OnLookup(var Text: Text): Boolean
//                     begin
//                         LookupShortcutDimCode(6,ShortcutDimCode[6]);
//                     end;

//                     trigger OnValidate()
//                     begin
//                         ValidateShortcutDimCode(6,ShortcutDimCode[6]);
//                     end;
//                 }
//                 field(ShortcutDimCode[7];ShortcutDimCode[7])
//                 {
//                     CaptionClass = '1,2,7';
//                     Visible = false;

//                     trigger OnLookup(var Text: Text): Boolean
//                     begin
//                         LookupShortcutDimCode(7,ShortcutDimCode[7]);
//                     end;

//                     trigger OnValidate()
//                     begin
//                         ValidateShortcutDimCode(7,ShortcutDimCode[7]);
//                     end;
//                 }
//                 field(ShortcutDimCode[8];ShortcutDimCode[8])
//                 {
//                     CaptionClass = '1,2,8';
//                     Visible = false;

//                     trigger OnLookup(var Text: Text): Boolean
//                     begin
//                         LookupShortcutDimCode(8,ShortcutDimCode[8]);
//                     end;

//                     trigger OnValidate()
//                     begin
//                         ValidateShortcutDimCode(8,ShortcutDimCode[8]);
//                     end;
//                 }
//                 field("Applied (Yes/No)";IsApplied)
//                 {
//                     Caption = 'Applied (Yes/No)';
//                 }
//                 field("Applies-to Doc. Type";"Applies-to Doc. Type")
//                 {
//                 }
//                 field("Applies-to Doc. No.";"Applies-to Doc. No.")
//                 {
//                 }
//                 field("Applies-to ID";"Applies-to ID")
//                 {
//                     Visible = false;
//                 }
//                 field("Reason Code";"Reason Code")
//                 {
//                     Visible = false;
//                 }
//                 field(Comment;Comment)
//                 {
//                     Visible = false;
//                 }
//                 field("Direct Debit Mandate ID";"Direct Debit Mandate ID")
//                 {
//                     Visible = false;
//                 }
//             }
//             group()
//             {
//                 fixed()
//                 {
//                     group("Account Name")
//                     {
//                         Caption = 'Account Name';
//                         field(AccName;AccName)
//                         {
//                             Editable = false;
//                         }
//                     }
//                     group("Bal. Account Name")
//                     {
//                         Caption = 'Bal. Account Name';
//                         field(BalAccName;BalAccName)
//                         {
//                             Caption = 'Bal. Account Name';
//                             Editable = false;
//                         }
//                     }
//                     group(Balance)
//                     {
//                         Caption = 'Balance';
//                         field(Balance;Balance + "Balance (LCY)" - xRec."Balance (LCY)")
//                         {
//                             AutoFormatType = 1;
//                             Caption = 'Balance';
//                             Editable = false;
//                             Visible = BalanceVisible;
//                         }
//                     }
//                     group("Total Balance")
//                     {
//                         Caption = 'Total Balance';
//                         field(TotalBalance;TotalBalance + "Balance (LCY)" - xRec."Balance (LCY)")
//                         {
//                             AutoFormatType = 1;
//                             Caption = 'Total Balance';
//                             Editable = false;
//                             Visible = TotalBalanceVisible;
//                         }
//                     }
//                 }
//             }
//         }
//         area(factboxes)
//         {
//             part(;699)
//             {
//                 SubPageLink = Dimension Set ID=FIELD(Dimension Set ID);
//                 Visible = false;
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
//             group("&Line")
//             {
//                 Caption = '&Line';
//                 Image = Line;
//                 action(Dimensions)
//                 {
//                     Caption = 'Dimensions';
//                     Image = Dimensions;
//                     Promoted = true;
//                     PromotedCategory = Process;
//                     ShortCutKey = 'Shift+Ctrl+D';

//                     trigger OnAction()
//                     begin
//                         ShowDimensions;
//                         CurrPage.SAVERECORD;
//                     end;
//                 }
//             }
//             group("A&ccount")
//             {
//                 Caption = 'A&ccount';
//                 Image = ChartOfAccounts;
//                 action(Card)
//                 {
//                     Caption = 'Card';
//                     Image = EditLines;
//                     RunObject = Codeunit 15;
//                     ShortCutKey = 'Shift+F7';
//                 }
//                 action("Ledger E&ntries")
//                 {
//                     Caption = 'Ledger E&ntries';
//                     Image = GLRegisters;
//                     Promoted = false;
//                     //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
//                     //PromotedCategory = Process;
//                     RunObject = Codeunit 14;
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
//                 action("Renumber Document Numbers")
//                 {
//                     Caption = 'Renumber Document Numbers';
//                     Image = EditLines;

//                     trigger OnAction()
//                     begin
//                         RenumberDocumentNo
//                     end;
//                 }
//                 action("Apply Entries")
//                 {
//                     Caption = 'Apply Entries';
//                     Ellipsis = true;
//                     Image = ApplyEntries;
//                     Promoted = true;
//                     PromotedCategory = Process;
//                     RunObject = Codeunit 225;
//                     ShortCutKey = 'Shift+F11';
//                 }
//                 action("Insert Conv. LCY Rndg. Lines")
//                 {
//                     Caption = 'Insert Conv. LCY Rndg. Lines';
//                     Image = InsertCurrency;
//                     RunObject = Codeunit 407;
//                 }
//             }
//             group("P&osting")
//             {
//                 Caption = 'P&osting';
//                 Image = Post;
//                 action(Reconcile)
//                 {
//                     Caption = 'Reconcile';
//                     Image = Reconcile;
//                     Promoted = true;
//                     PromotedCategory = Process;
//                     ShortCutKey = 'Ctrl+F11';

//                     trigger OnAction()
//                     begin
//                         GLReconcile.SetGenJnlLine(Rec);
//                         GLReconcile.RUN;
//                     end;
//                 }
//                 action("Test Report")
//                 {
//                     Caption = 'Test Report';
//                     Ellipsis = true;
//                     Image = TestReport;

//                     trigger OnAction()
//                     begin
//                         ReportPrint.PrintGenJnlLine(Rec);
//                     end;
//                 }
//                 action(Post)
//                 {
//                     Caption = 'P&ost';
//                     Image = PostOrder;
//                     Promoted = true;
//                     PromotedCategory = Process;
//                     PromotedIsBig = true;
//                     ShortCutKey = 'F9';

//                     trigger OnAction()
//                     begin
//                         CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post",Rec);
//                         CurrentJnlBatchName := GETRANGEMAX("Journal Batch Name");
//                         CurrPage.UPDATE(FALSE);
//                     end;
//                 }
//                 action("Post and &Print")
//                 {
//                     Caption = 'Post and &Print';
//                     Image = PostPrint;
//                     Promoted = true;
//                     PromotedCategory = Process;
//                     PromotedIsBig = true;
//                     ShortCutKey = 'Shift+F9';

//                     trigger OnAction()
//                     begin
//                         CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post+Print",Rec);
//                         CurrentJnlBatchName := GETRANGEMAX("Journal Batch Name");
//                         CurrPage.UPDATE(FALSE);
//                     end;
//                 }
//             }
//         }
//     }

//     trigger OnAfterGetCurrRecord()
//     begin
//         GenJnlManagement.GetAccounts(Rec,AccName,BalAccName);
//         UpdateBalance;
//     end;

//     trigger OnAfterGetRecord()
//     begin
//         ShowShortcutDimCode(ShortcutDimCode);
//     end;

//     trigger OnInit()
//     begin
//         TotalBalanceVisible := TRUE;
//         BalanceVisible := TRUE;
//     end;

//     trigger OnNewRecord(BelowxRec: Boolean)
//     begin
//         UpdateBalance;
//         SetUpNewLine(xRec,Balance,BelowxRec);
//         CLEAR(ShortcutDimCode);
//     end;

//     trigger OnOpenPage()
//     var
//         JnlSelected: Boolean;
//     begin
//         BalAccName := '';
//         OpenedFromBatch := ("Journal Batch Name" <> '') AND ("Journal Template Name" = '');
//         IF OpenedFromBatch THEN BEGIN
//           CurrentJnlBatchName := "Journal Batch Name";
//           GenJnlManagement.OpenJnl(CurrentJnlBatchName,Rec);
//           EXIT;
//         END;
//         GenJnlManagement.TemplateSelection(PAGE::"Cash Receipt Journal",3,FALSE,Rec,JnlSelected);
//         IF NOT JnlSelected THEN
//           ERROR('');
//         GenJnlManagement.OpenJnl(CurrentJnlBatchName,Rec);
//     end;

//     var
//         ChangeExchangeRate: Page "511";
//         GLReconcile: Page "345";
//         GenJnlManagement: Codeunit "230";
//         ReportPrint: Codeunit "228";
//         CurrentJnlBatchName: Code[10];
//         AccName: Text[50];
//         BalAccName: Text[50];
//         Balance: Decimal;
//         TotalBalance: Decimal;
//         ShowBalance: Boolean;
//         ShowTotalBalance: Boolean;
//         ShortcutDimCode: array [8] of Code[20];
//         OpenedFromBatch: Boolean;
//         [InDataSet]
//         BalanceVisible: Boolean;
//         [InDataSet]
//         TotalBalanceVisible: Boolean;

//     local procedure UpdateBalance()
//     begin
//         GenJnlManagement.CalcBalance(
//           Rec,xRec,Balance,TotalBalance,ShowBalance,ShowTotalBalance);
//         BalanceVisible := ShowBalance;
//         TotalBalanceVisible := ShowTotalBalance;
//     end;

//     local procedure CurrentJnlBatchNameOnAfterVali()
//     begin
//         CurrPage.SAVERECORD;
//         GenJnlManagement.SetName(CurrentJnlBatchName,Rec);
//         CurrPage.UPDATE(FALSE);
//     end;
// }

