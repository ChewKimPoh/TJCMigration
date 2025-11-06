// page 16 "Chart of Accounts"
// {
//     Caption = 'Chart of Accounts';
//     CardPageID = "G/L Account Card";
//     PageType = List;
//     RefreshOnActivate = true;
//     SourceTable = Table15;

//     layout
//     {
//         area(content)
//         {
//             repeater()
//             {
//                 IndentationColumn = NameIndent;
//                 IndentationControls = Name;
//                 field("No.";"No.")
//                 {
//                     Style = Strong;
//                     StyleExpr = NoEmphasize;
//                 }
//                 field(Name;Name)
//                 {
//                     Style = Strong;
//                     StyleExpr = NameEmphasize;
//                 }
//                 field("Income/Balance";"Income/Balance")
//                 {
//                 }
//                 field("Account Type";"Account Type")
//                 {
//                 }
//                 field(Indentation;Indentation)
//                 {
//                 }
//                 field("Debit Amount";"Debit Amount")
//                 {
//                 }
//                 field("Credit Amount";"Credit Amount")
//                 {
//                 }
//                 field("Direct Posting";"Direct Posting")
//                 {
//                     Visible = false;
//                 }
//                 field(Totaling;Totaling)
//                 {

//                     trigger OnLookup(var Text: Text): Boolean
//                     var
//                         GLaccList: Page "18";
//                     begin
//                         GLaccList.LOOKUPMODE(TRUE);
//                         IF NOT (GLaccList.RUNMODAL = ACTION::LookupOK) THEN
//                           EXIT(FALSE);

//                         Text := GLaccList.GetSelectionFilter;
//                         EXIT(TRUE);
//                     end;
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
//                 field("VAT Bus. Posting Group";"VAT Bus. Posting Group")
//                 {
//                     Visible = false;
//                 }
//                 field("VAT Prod. Posting Group";"VAT Prod. Posting Group")
//                 {
//                     Visible = false;
//                 }
//                 field("Net Change";"Net Change")
//                 {
//                     BlankZero = true;
//                 }
//                 field("Balance at Date";"Balance at Date")
//                 {
//                     BlankZero = true;
//                     Visible = false;
//                 }
//                 field(Balance;Balance)
//                 {
//                     BlankZero = true;
//                 }
//                 field("Additional-Currency Net Change";"Additional-Currency Net Change")
//                 {
//                     BlankZero = true;
//                     Visible = false;
//                 }
//                 field("Add.-Currency Balance at Date";"Add.-Currency Balance at Date")
//                 {
//                     BlankZero = true;
//                     Visible = false;
//                 }
//                 field("Additional-Currency Balance";"Additional-Currency Balance")
//                 {
//                     BlankZero = true;
//                     Visible = false;
//                 }
//                 field("Consol. Debit Acc.";"Consol. Debit Acc.")
//                 {
//                     Visible = false;
//                 }
//                 field("Consol. Credit Acc.";"Consol. Credit Acc.")
//                 {
//                     Visible = false;
//                 }
//                 field("Cost Type No.";"Cost Type No.")
//                 {
//                 }
//                 field("Consol. Translation Method";"Consol. Translation Method")
//                 {
//                     Visible = false;
//                 }
//                 field("Default IC Partner G/L Acc. No";"Default IC Partner G/L Acc. No")
//                 {
//                     Visible = false;
//                 }
//             }
//         }
//         area(factboxes)
//         {
//             part(;9083)
//             {
//                 SubPageLink = Table ID=CONST(15),
//                               No.=FIELD(No.);
//                 Visible = false;
//             }
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
//             group("A&ccount")
//             {
//                 Caption = 'A&ccount';
//                 Image = ChartOfAccounts;
//                 action("Ledger E&ntries")
//                 {
//                     Caption = 'Ledger E&ntries';
//                     Image = GLRegisters;
//                     Promoted = false;
//                     //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
//                     //PromotedCategory = Process;
//                     RunObject = Page 20;
//                     RunPageLink = G/L Account No.=FIELD(No.);
//                     RunPageView = SORTING(G/L Account No.);
//                     ShortCutKey = 'Ctrl+F7';
//                 }
//                 action("Co&mments")
//                 {
//                     Caption = 'Co&mments';
//                     Image = ViewComments;
//                     RunObject = Page 124;
//                     RunPageLink = Table Name=CONST(G/L Account),
//                                   No.=FIELD(No.);
//                 }
//                 group(Dimensions)
//                 {
//                     Caption = 'Dimensions';
//                     Image = Dimensions;
//                     action("Dimensions-Single")
//                     {
//                         Caption = 'Dimensions-Single';
//                         Image = Dimensions;
//                         RunObject = Page 540;
//                         RunPageLink = Table ID=CONST(15),
//                                       No.=FIELD(No.);
//                         ShortCutKey = 'Shift+Ctrl+D';
//                     }
//                     action("Dimensions-&Multiple")
//                     {
//                         Caption = 'Dimensions-&Multiple';
//                         Image = DimensionSets;

//                         trigger OnAction()
//                         var
//                             GLAcc: Record "15";
//                             DefaultDimMultiple: Page "542";
//                         begin
//                             CurrPage.SETSELECTIONFILTER(GLAcc);
//                             DefaultDimMultiple.SetMultiGLAcc(GLAcc);
//                             DefaultDimMultiple.RUNMODAL;
//                         end;
//                     }
//                 }
//                 action("E&xtended Texts")
//                 {
//                     Caption = 'E&xtended Texts';
//                     Image = Text;
//                     RunObject = Page 391;
//                     RunPageLink = Table Name=CONST(G/L Account),
//                                   No.=FIELD(No.);
//                     RunPageView = SORTING(Table Name,No.,Language Code,All Language Codes,Starting Date,Ending Date);
//                 }
//                 action("Receivables-Payables")
//                 {
//                     Caption = 'Receivables-Payables';
//                     Image = ReceivablesPayables;
//                     RunObject = Page 159;
//                 }
//                 action("Where-Used List")
//                 {
//                     Caption = 'Where-Used List';
//                     Image = Track;

//                     trigger OnAction()
//                     var
//                         CalcGLAccWhereUsed: Codeunit "100";
//                     begin
//                         CalcGLAccWhereUsed.CheckGLAcc("No.");
//                     end;
//                 }
//             }
//             group("&Balance")
//             {
//                 Caption = '&Balance';
//                 Image = Balance;
//                 action("G/L &Account Balance")
//                 {
//                     Caption = 'G/L &Account Balance';
//                     Image = GLAccountBalance;
//                     RunObject = Page 415;
//                     RunPageLink = No.=FIELD(No.),
//                                   Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
//                                   Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter),
//                                   Business Unit Filter=FIELD(Business Unit Filter);
//                 }
//                 action("G/L &Balance")
//                 {
//                     Caption = 'G/L &Balance';
//                     Image = GLBalance;
//                     RunObject = Page 414;
//                     RunPageOnRec = true;
//                 }
//                 action("G/L Balance by &Dimension")
//                 {
//                     Caption = 'G/L Balance by &Dimension';
//                     Image = GLBalanceDimension;
//                     RunObject = Page 408;
//                 }
//                 separator()
//                 {
//                     Caption = '';
//                 }
//                 action("G/L Account Balance/Bud&get")
//                 {
//                     Caption = 'G/L Account Balance/Bud&get';
//                     Image = Period;
//                     RunObject = Page 154;
//                     RunPageLink = No.=FIELD(No.),
//                                   Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
//                                   Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter),
//                                   Business Unit Filter=FIELD(Business Unit Filter),
//                                   Budget Filter=FIELD(Budget Filter);
//                 }
//                 action("G/L Balance/B&udget")
//                 {
//                     Caption = 'G/L Balance/B&udget';
//                     Image = ChartOfAccounts;
//                     RunObject = Page 422;
//                     RunPageOnRec = true;
//                 }
//                 separator()
//                 {
//                 }
//                 action("Chart of Accounts &Overview")
//                 {
//                     Caption = 'Chart of Accounts &Overview';
//                     Image = Accounts;
//                     RunObject = Page 634;
//                 }
//             }
//             action("G/L Register")
//             {
//                 Caption = 'G/L Register';
//                 Image = GLRegisters;
//                 Promoted = true;
//                 PromotedCategory = Process;
//                 RunObject = Page 116;
//             }
//         }
//         area(processing)
//         {
//             group("F&unctions")
//             {
//                 Caption = 'F&unctions';
//                 Image = "Action";
//                 action(IndentChartOfAccounts)
//                 {
//                     Caption = 'Indent Chart of Accounts';
//                     Image = IndentChartOfAccounts;
//                     Promoted = true;
//                     PromotedCategory = Process;
//                     PromotedIsBig = true;
//                     RunObject = Codeunit 3;
//                 }
//             }
//             group("Periodic Activities")
//             {
//                 Caption = 'Periodic Activities';
//                 action("Recurring General Journal")
//                 {
//                     Caption = 'Recurring General Journal';
//                     Image = Journal;
//                     Promoted = true;
//                     PromotedCategory = Process;
//                     PromotedIsBig = true;
//                     RunObject = Page 283;
//                 }
//                 action("Close Income Statement")
//                 {
//                     Caption = 'Close Income Statement';
//                     Image = CloseYear;
//                     Promoted = true;
//                     PromotedCategory = Process;
//                     PromotedIsBig = true;
//                     RunObject = Report 94;
//                 }
//             }
//         }
//         area(reporting)
//         {
//             action("Detail Trial Balance")
//             {
//                 Caption = 'Detail Trial Balance';
//                 Image = "Report";
//                 Promoted = true;
//                 PromotedCategory = "Report";
//                 RunObject = Report 4;
//             }
//             action("Trial Balance")
//             {
//                 Caption = 'Trial Balance';
//                 Image = "Report";
//                 Promoted = true;
//                 PromotedCategory = "Report";
//                 RunObject = Report 6;
//             }
//             action("Trial Balance by Period")
//             {
//                 Caption = 'Trial Balance by Period';
//                 Image = "Report";
//                 Promoted = false;
//                 //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
//                 //PromotedCategory = "Report";
//                 RunObject = Report 38;
//             }
//             action("G/L Register")
//             {
//                 Caption = 'G/L Register';
//                 Image = GLRegisters;
//                 Promoted = true;
//                 PromotedCategory = "Report";
//                 RunObject = Report 3;
//             }
//         }
//     }

//     trigger OnAfterGetRecord()
//     begin
//         NoEmphasize := "Account Type" <> "Account Type"::Posting;
//         NameIndent := Indentation;
//         NameEmphasize := "Account Type" <> "Account Type"::Posting;
//     end;

//     trigger OnNewRecord(BelowxRec: Boolean)
//     begin
//         SetupNewGLAcc(xRec,BelowxRec);
//     end;

//     var
//         [InDataSet]
//         NoEmphasize: Boolean;
//         [InDataSet]
//         NameEmphasize: Boolean;
//         [InDataSet]
//         NameIndent: Integer;
// }

