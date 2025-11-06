// page 232 "Apply Customer Entries"
// {
//     Caption = 'Apply Customer Entries';
//     DataCaptionFields = "Customer No.";
//     DeleteAllowed = false;
//     InsertAllowed = false;
//     LinksAllowed = false;
//     PageType = Worksheet;
//     SourceTable = Table21;

//     layout
//     {
//         area(content)
//         {
//             group(General)
//             {
//                 Caption = 'General';
//                 field(ApplyingCustLedgEntry."Posting Date";ApplyingCustLedgEntry."Posting Date")
//                 {
//                     Caption = 'Posting Date';
//                     Editable = false;
//                 }
//                 field(ApplyingCustLedgEntry."Document Type";ApplyingCustLedgEntry."Document Type")
//                 {
//                     Caption = 'Document Type';
//                     Editable = false;
//                     OptionCaption = ' ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund';
//                 }
//                 field(ApplyingCustLedgEntry."Document No.";ApplyingCustLedgEntry."Document No.")
//                 {
//                     Caption = 'Document No.';
//                     Editable = false;
//                 }
//                 field(ApplyingCustLedgEntry."Customer No.";ApplyingCustLedgEntry."Customer No.")
//                 {
//                     Caption = 'Customer No.';
//                     Editable = false;
//                 }
//                 field(ApplyingCustLedgEntry.Description;ApplyingCustLedgEntry.Description)
//                 {
//                     Caption = 'Description';
//                     Editable = false;
//                 }
//                 field(ApplyingCustLedgEntry."Currency Code";ApplyingCustLedgEntry."Currency Code")
//                 {
//                     Caption = 'Currency Code';
//                     Editable = false;
//                 }
//                 field(ApplyingCustLedgEntry.Amount;ApplyingCustLedgEntry.Amount)
//                 {
//                     Caption = 'Amount';
//                     Editable = false;
//                 }
//                 field(ApplyingCustLedgEntry."Remaining Amount";ApplyingCustLedgEntry."Remaining Amount")
//                 {
//                     Caption = 'Remaining Amount';
//                     Editable = false;
//                 }
//             }
//             repeater()
//             {
//                 field("Applies-to ID";"Applies-to ID")
//                 {
//                     Visible = "Applies-to IDVisible";
//                 }
//                 field("Posting Date";"Posting Date")
//                 {
//                     Editable = false;
//                 }
//                 field("Document Type";"Document Type")
//                 {
//                     Editable = false;
//                     StyleExpr = StyleTxt;
//                 }
//                 field("Document No.";"Document No.")
//                 {
//                     Editable = false;
//                     StyleExpr = StyleTxt;
//                 }
//                 field("External Document No.";"External Document No.")
//                 {
//                 }
//                 field("Customer No.";"Customer No.")
//                 {
//                     Editable = false;
//                 }
//                 field(Description;Description)
//                 {
//                     Editable = false;
//                 }
//                 field("Currency Code";"Currency Code")
//                 {
//                 }
//                 field("Original Amount";"Original Amount")
//                 {
//                     Editable = false;
//                     Visible = false;
//                 }
//                 field(Amount;Amount)
//                 {
//                     Editable = false;
//                     Visible = false;
//                 }
//                 field("Remaining Amount";"Remaining Amount")
//                 {
//                     Editable = false;
//                 }
//                 field(CalcApplnRemainingAmount("Remaining Amount");CalcApplnRemainingAmount("Remaining Amount"))
//                 {
//                     AutoFormatExpression = ApplnCurrencyCode;
//                     AutoFormatType = 1;
//                     Caption = 'Appln. Remaining Amount';
//                 }
//                 field("Amount to Apply";"Amount to Apply")
//                 {

//                     trigger OnValidate()
//                     begin
//                         CODEUNIT.RUN(CODEUNIT::"Cust. Entry-Edit",Rec);

//                         IF (xRec."Amount to Apply" = 0) OR ("Amount to Apply" = 0) AND
//                            (ApplnType = ApplnType::"Applies-to ID")
//                         THEN
//                           SetCustApplId;
//                         GET("Entry No.");
//                         AmounttoApplyOnAfterValidate;
//                     end;
//                 }
//                 field(CalcApplnAmounttoApply("Amount to Apply");CalcApplnAmounttoApply("Amount to Apply"))
//                 {
//                     AutoFormatExpression = ApplnCurrencyCode;
//                     AutoFormatType = 1;
//                     Caption = 'Appln. Amount to Apply';
//                 }
//                 field("Due Date";"Due Date")
//                 {
//                     StyleExpr = StyleTxt;
//                 }
//                 field("Pmt. Discount Date";"Pmt. Discount Date")
//                 {

//                     trigger OnValidate()
//                     begin
//                         RecalcApplnAmount;
//                     end;
//                 }
//                 field("Pmt. Disc. Tolerance Date";"Pmt. Disc. Tolerance Date")
//                 {
//                 }
//                 field("Original Pmt. Disc. Possible";"Original Pmt. Disc. Possible")
//                 {
//                     Visible = false;
//                 }
//                 field("Remaining Pmt. Disc. Possible";"Remaining Pmt. Disc. Possible")
//                 {

//                     trigger OnValidate()
//                     begin
//                         RecalcApplnAmount;
//                     end;
//                 }
//                 field(CalcApplnRemainingAmount("Remaining Pmt. Disc. Possible");CalcApplnRemainingAmount("Remaining Pmt. Disc. Possible"))
//                 {
//                     AutoFormatExpression = ApplnCurrencyCode;
//                     AutoFormatType = 1;
//                     Caption = 'Appln. Pmt. Disc. Possible';
//                 }
//                 field("Max. Payment Tolerance";"Max. Payment Tolerance")
//                 {
//                 }
//                 field(Open;Open)
//                 {
//                     Editable = false;
//                 }
//                 field(Positive;Positive)
//                 {
//                     Editable = false;
//                 }
//                 field("Global Dimension 1 Code";"Global Dimension 1 Code")
//                 {
//                 }
//                 field("Global Dimension 2 Code";"Global Dimension 2 Code")
//                 {
//                 }
//             }
//             group()
//             {
//                 fixed()
//                 {
//                     group("Appln. Currency")
//                     {
//                         Caption = 'Appln. Currency';
//                         field(ApplnCurrencyCode;ApplnCurrencyCode)
//                         {
//                             Editable = false;
//                             TableRelation = Currency;
//                         }
//                     }
//                     group("Amount to Apply")
//                     {
//                         Caption = 'Amount to Apply';
//                         field(AmountToApply;AppliedAmount)
//                         {
//                             AutoFormatExpression = ApplnCurrencyCode;
//                             AutoFormatType = 1;
//                             Caption = 'Amount to Apply';
//                             Editable = false;
//                         }
//                     }
//                     group("Pmt. Disc. Amount")
//                     {
//                         Caption = 'Pmt. Disc. Amount';
//                         field(-PmtDiscAmount;-PmtDiscAmount)
//                         {
//                             AutoFormatExpression = ApplnCurrencyCode;
//                             AutoFormatType = 1;
//                             Caption = 'Pmt. Disc. Amount';
//                             Editable = false;
//                         }
//                     }
//                     group(Rounding)
//                     {
//                         Caption = 'Rounding';
//                         field(ApplnRounding;ApplnRounding)
//                         {
//                             AutoFormatExpression = ApplnCurrencyCode;
//                             AutoFormatType = 1;
//                             Caption = 'Rounding';
//                             Editable = false;
//                         }
//                     }
//                     group("Applied Amount")
//                     {
//                         Caption = 'Applied Amount';
//                         field(AppliedAmount;AppliedAmount + (-PmtDiscAmount) + ApplnRounding)
//                         {
//                             AutoFormatExpression = ApplnCurrencyCode;
//                             AutoFormatType = 1;
//                             Caption = 'Applied Amount';
//                             Editable = false;
//                         }
//                     }
//                     group("Available Amount")
//                     {
//                         Caption = 'Available Amount';
//                         field(ApplyingAmount;ApplyingAmount)
//                         {
//                             AutoFormatExpression = ApplnCurrencyCode;
//                             AutoFormatType = 1;
//                             Caption = 'Available Amount';
//                             Editable = false;
//                         }
//                     }
//                     group(Balance)
//                     {
//                         Caption = 'Balance';
//                         field(ControlBalance;AppliedAmount + (-PmtDiscAmount) + ApplyingAmount + ApplnRounding)
//                         {
//                             AutoFormatExpression = ApplnCurrencyCode;
//                             AutoFormatType = 1;
//                             Caption = 'Balance';
//                             Editable = false;
//                         }
//                     }
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
//                     RunPageLink = Cust. Ledger Entry No.=FIELD(Entry No.);
//                     RunPageView = SORTING(Cust. Ledger Entry No.,Posting Date);
//                     ShortCutKey = 'Ctrl+F7';
//                 }
//             }
//             group("&Application")
//             {
//                 Caption = '&Application';
//                 Image = Apply;
//                 action("Set Applies-to ID")
//                 {
//                     Caption = 'Set Applies-to ID';
//                     Image = SelectLineToApply;
//                     Promoted = true;
//                     PromotedCategory = Process;
//                     PromotedIsBig = true;
//                     ShortCutKey = 'Shift+F11';

//                     trigger OnAction()
//                     begin
//                         IF (CalcType = CalcType::GenJnlLine) AND (ApplnType = ApplnType::"Applies-to Doc. No.") THEN
//                           ERROR(Text004);

//                         SetCustApplId;
//                     end;
//                 }
//                 action("Post Application")
//                 {
//                     Caption = 'Post Application';
//                     Ellipsis = true;
//                     Image = PostApplication;
//                     Promoted = true;
//                     PromotedCategory = Process;
//                     ShortCutKey = 'F9';

//                     trigger OnAction()
//                     begin
//                         PostDirectApplication;
//                     end;
//                 }
//                 separator("-")
//                 {
//                     Caption = '-';
//                 }
//                 action("Show Only Selected Entries to Be Applied")
//                 {
//                     Caption = 'Show Only Selected Entries to Be Applied';
//                     Image = ShowSelected;

//                     trigger OnAction()
//                     begin
//                         ShowAppliedEntries := NOT ShowAppliedEntries;
//                         IF ShowAppliedEntries THEN BEGIN
//                           IF CalcType = CalcType::GenJnlLine THEN
//                             SETRANGE("Applies-to ID",GenJnlLine."Applies-to ID")
//                           ELSE BEGIN
//                             CustEntryApplID := USERID;
//                             IF CustEntryApplID = '' THEN
//                               CustEntryApplID := '***';
//                             SETRANGE("Applies-to ID",CustEntryApplID);
//                           END;
//                         END ELSE
//                           SETRANGE("Applies-to ID");
//                     end;
//                 }
//             }
//         }
//         area(processing)
//         {
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

//     trigger OnAfterGetCurrRecord()
//     begin
//         IF ApplnType = ApplnType::"Applies-to Doc. No." THEN
//           CalcApplnAmount;
//     end;

//     trigger OnAfterGetRecord()
//     begin
//         StyleTxt := SetStyle;
//     end;

//     trigger OnInit()
//     begin
//         "Applies-to IDVisible" := TRUE;
//     end;

//     trigger OnModifyRecord(): Boolean
//     begin
//         CODEUNIT.RUN(CODEUNIT::"Cust. Entry-Edit",Rec);
//         IF "Applies-to ID" <> xRec."Applies-to ID" THEN
//           CalcApplnAmount;
//         EXIT(FALSE);
//     end;

//     trigger OnOpenPage()
//     begin
//         IF CalcType = CalcType::Direct THEN BEGIN
//           Cust.GET("Customer No.");
//           ApplnCurrencyCode := Cust."Currency Code";
//           FindApplyingEntry;
//         END;

//         "Applies-to IDVisible" := ApplnType <> ApplnType::"Applies-to Doc. No.";

//         GLSetup.GET;

//         IF ApplnType = ApplnType::"Applies-to Doc. No." THEN
//           CalcApplnAmount;
//         PostingDone := FALSE;
//     end;

//     trigger OnQueryClosePage(CloseAction: Action): Boolean
//     begin
//         IF CloseAction = ACTION::LookupOK THEN
//           LookupOKOnPush;
//         IF ApplnType = ApplnType::"Applies-to Doc. No." THEN BEGIN
//           IF OK AND (ApplyingCustLedgEntry."Posting Date" < "Posting Date") THEN BEGIN
//             OK := FALSE;
//             ERROR(
//               Text006,ApplyingCustLedgEntry."Document Type",ApplyingCustLedgEntry."Document No.",
//               "Document Type","Document No.");
//           END;
//           IF OK THEN BEGIN
//             IF "Amount to Apply" = 0 THEN
//               "Amount to Apply" := "Remaining Amount";
//             CODEUNIT.RUN(CODEUNIT::"Cust. Entry-Edit",Rec);
//           END;
//         END;
//         IF (CalcType = CalcType::Direct) AND NOT OK AND NOT PostingDone THEN BEGIN
//           Rec := ApplyingCustLedgEntry;
//           "Applying Entry" := FALSE;
//           "Applies-to ID" := '';
//           "Amount to Apply" := 0;
//           CODEUNIT.RUN(CODEUNIT::"Cust. Entry-Edit",Rec);
//         END;
//     end;

//     var
//         ApplyingCustLedgEntry: Record "21" temporary;
//         AppliedCustLedgEntry: Record "21";
//         Currency: Record "4";
//         CurrExchRate: Record "330";
//         GenJnlLine: Record "81";
//         GenJnlLine2: Record "81";
//         SalesHeader: Record "36";
//         ServHeader: Record "5900";
//         Cust: Record "18";
//         CustLedgEntry: Record "21";
//         GLSetup: Record "98";
//         TotalSalesLine: Record "37";
//         TotalSalesLineLCY: Record "37";
//         TotalServLine: Record "5902";
//         TotalServLineLCY: Record "5902";
//         CustEntrySetApplID: Codeunit "101";
//         GenJnlApply: Codeunit "225";
//         SalesPost: Codeunit "80";
//         PaymentToleranceMgt: Codeunit "426";
//         Navigate: Page "344";
//         AppliedAmount: Decimal;
//         ApplyingAmount: Decimal;
//         PmtDiscAmount: Decimal;
//         ApplnDate: Date;
//         ApplnCurrencyCode: Code[10];
//         ApplnRoundingPrecision: Decimal;
//         ApplnRounding: Decimal;
//         ApplnType: Option " ","Applies-to Doc. No.","Applies-to ID";
//         AmountRoundingPrecision: Decimal;
//         VATAmount: Decimal;
//         VATAmountText: Text[30];
//         StyleTxt: Text;
//         ProfitLCY: Decimal;
//         ProfitPct: Decimal;
//         CalcType: Option Direct,GenJnlLine,SalesHeader,ServHeader;
//         CustEntryApplID: Code[50];
//         ValidExchRate: Boolean;
//         DifferentCurrenciesInAppln: Boolean;
//         Text002: Label 'You must select an applying entry before you can post the application.';
//         ShowAppliedEntries: Boolean;
//         Text003: Label 'You must post the application from the window where you entered the applying entry.';
//         Text004: Label 'You are not allowed to set Applies-to ID while selecting Applies-to Doc. No.';
//         OK: Boolean;
//         Text006: Label 'You are not allowed to apply and post an entry to an entry with an earlier posting date.\\Instead, post the document of type %1 with the number %2 and then apply it to the document of type %3 with the number %4.';
//         PostingDone: Boolean;
//         [InDataSet]
//         "Applies-to IDVisible": Boolean;
//         Text012: Label 'The application was successfully posted.';
//         Text013: Label 'The %1 entered must not be before the %1 on the %2.';
//         Text019: Label 'Post application process has been canceled.';

//     procedure SetGenJnlLine(NewGenJnlLine: Record "81";ApplnTypeSelect: Integer)
//     begin
//         GenJnlLine := NewGenJnlLine;

//         IF GenJnlLine."Account Type" = GenJnlLine."Account Type"::Customer THEN
//           ApplyingAmount := GenJnlLine.Amount;
//         IF GenJnlLine."Bal. Account Type" = GenJnlLine."Bal. Account Type"::Customer THEN
//           ApplyingAmount := -GenJnlLine.Amount;
//         ApplnDate := GenJnlLine."Posting Date";
//         ApplnCurrencyCode := GenJnlLine."Currency Code";
//         CalcType := CalcType::GenJnlLine;

//         CASE ApplnTypeSelect OF
//           GenJnlLine.FIELDNO("Applies-to Doc. No."):
//             ApplnType := ApplnType::"Applies-to Doc. No.";
//           GenJnlLine.FIELDNO("Applies-to ID"):
//             ApplnType := ApplnType::"Applies-to ID";
//         END;

//         SetApplyingCustLedgEntry;
//     end;

//     procedure SetSales(NewSalesHeader: Record "36";var NewCustLedgEntry: Record "21";ApplnTypeSelect: Integer)
//     var
//         TotalAdjCostLCY: Decimal;
//     begin
//         SalesHeader := NewSalesHeader;
//         COPYFILTERS(NewCustLedgEntry);

//         SalesPost.SumSalesLines(
//           SalesHeader,0,TotalSalesLine,TotalSalesLineLCY,
//           VATAmount,VATAmountText,ProfitLCY,ProfitPct,TotalAdjCostLCY);

//         CASE SalesHeader."Document Type" OF
//           SalesHeader."Document Type"::"Return Order",
//           SalesHeader."Document Type"::"Credit Memo":
//             ApplyingAmount := -TotalSalesLine."Amount Including VAT"
//           ELSE
//             ApplyingAmount := TotalSalesLine."Amount Including VAT";
//         END;

//         ApplnDate := SalesHeader."Posting Date";
//         ApplnCurrencyCode := SalesHeader."Currency Code";
//         CalcType := CalcType::SalesHeader;

//         CASE ApplnTypeSelect OF
//           SalesHeader.FIELDNO("Applies-to Doc. No."):
//             ApplnType := ApplnType::"Applies-to Doc. No.";
//           SalesHeader.FIELDNO("Applies-to ID"):
//             ApplnType := ApplnType::"Applies-to ID";
//         END;

//         SetApplyingCustLedgEntry;
//     end;

//     procedure SetService(NewServHeader: Record "5900";var NewCustLedgEntry: Record "21";ApplnTypeSelect: Integer)
//     var
//         ServAmountsMgt: Codeunit "5986";
//         TotalAdjCostLCY: Decimal;
//     begin
//         ServHeader := NewServHeader;
//         COPYFILTERS(NewCustLedgEntry);

//         ServAmountsMgt.SumServiceLines(
//           ServHeader,0,TotalServLine,TotalServLineLCY,
//           VATAmount,VATAmountText,ProfitLCY,ProfitPct,TotalAdjCostLCY);

//         CASE ServHeader."Document Type" OF
//           ServHeader."Document Type"::"Credit Memo":
//             ApplyingAmount := -TotalServLine."Amount Including VAT"
//           ELSE
//             ApplyingAmount := TotalServLine."Amount Including VAT";
//         END;

//         ApplnDate := ServHeader."Posting Date";
//         ApplnCurrencyCode := ServHeader."Currency Code";
//         CalcType := CalcType::ServHeader;

//         CASE ApplnTypeSelect OF
//           ServHeader.FIELDNO("Applies-to Doc. No."):
//             ApplnType := ApplnType::"Applies-to Doc. No.";
//           ServHeader.FIELDNO("Applies-to ID"):
//             ApplnType := ApplnType::"Applies-to ID";
//         END;

//         SetApplyingCustLedgEntry;
//     end;

//     procedure SetCustLedgEntry(NewCustLedgEntry: Record "21")
//     begin
//         Rec := NewCustLedgEntry;
//     end;

//     procedure SetApplyingCustLedgEntry()
//     var
//         "CustEntry-Edit": Codeunit "103";
//     begin
//         CASE CalcType OF
//           CalcType::SalesHeader:
//             BEGIN
//               ApplyingCustLedgEntry."Entry No." := 1;
//               ApplyingCustLedgEntry."Posting Date" := SalesHeader."Posting Date";
//               IF SalesHeader."Document Type" = SalesHeader."Document Type"::"Return Order" THEN
//                 ApplyingCustLedgEntry."Document Type" := SalesHeader."Document Type"::"Credit Memo"
//               ELSE
//                 ApplyingCustLedgEntry."Document Type" := SalesHeader."Document Type";
//               ApplyingCustLedgEntry."Document No." := SalesHeader."No.";
//               ApplyingCustLedgEntry."Customer No." := SalesHeader."Bill-to Customer No.";
//               ApplyingCustLedgEntry.Description := SalesHeader."Posting Description";
//               ApplyingCustLedgEntry."Currency Code" := SalesHeader."Currency Code";
//               IF ApplyingCustLedgEntry."Document Type" = ApplyingCustLedgEntry."Document Type"::"Credit Memo" THEN  BEGIN
//                 ApplyingCustLedgEntry.Amount := -TotalSalesLine."Amount Including VAT";
//                 ApplyingCustLedgEntry."Remaining Amount" := -TotalSalesLine."Amount Including VAT";
//               END ELSE BEGIN
//                 ApplyingCustLedgEntry.Amount := TotalSalesLine."Amount Including VAT";
//                 ApplyingCustLedgEntry."Remaining Amount" := TotalSalesLine."Amount Including VAT";
//               END;
//               CalcApplnAmount;
//             END;
//           CalcType::ServHeader:
//             BEGIN
//               ApplyingCustLedgEntry."Entry No." := 1;
//               ApplyingCustLedgEntry."Posting Date" := ServHeader."Posting Date";
//               ApplyingCustLedgEntry."Document Type" := ServHeader."Document Type";
//               ApplyingCustLedgEntry."Document No." := ServHeader."No.";
//               ApplyingCustLedgEntry."Customer No." := ServHeader."Bill-to Customer No.";
//               ApplyingCustLedgEntry.Description := ServHeader."Posting Description";
//               ApplyingCustLedgEntry."Currency Code" := ServHeader."Currency Code";
//               IF ApplyingCustLedgEntry."Document Type" = ApplyingCustLedgEntry."Document Type"::"Credit Memo" THEN  BEGIN
//                 ApplyingCustLedgEntry.Amount := -TotalServLine."Amount Including VAT";
//                 ApplyingCustLedgEntry."Remaining Amount" := -TotalServLine."Amount Including VAT";
//               END ELSE BEGIN
//                 ApplyingCustLedgEntry.Amount := TotalServLine."Amount Including VAT";
//                 ApplyingCustLedgEntry."Remaining Amount" := TotalServLine."Amount Including VAT";
//               END;
//               CalcApplnAmount;
//             END;
//           CalcType::Direct:
//             BEGIN
//               IF "Applying Entry" THEN BEGIN
//                 IF ApplyingCustLedgEntry."Entry No." <> 0 THEN
//                   CustLedgEntry := ApplyingCustLedgEntry;
//                 "CustEntry-Edit".RUN(Rec);
//                 IF "Applies-to ID" = '' THEN
//                   SetCustApplId;
//                 CALCFIELDS(Amount);
//                 ApplyingCustLedgEntry := Rec;
//                 IF CustLedgEntry."Entry No." <> 0 THEN BEGIN
//                   Rec := CustLedgEntry;
//                   "Applying Entry" := FALSE;
//                   SetCustApplId;
//                 END;
//                 SETFILTER("Entry No.",'<> %1',ApplyingCustLedgEntry."Entry No.");
//                 ApplyingAmount := ApplyingCustLedgEntry."Remaining Amount";
//                 ApplnDate := ApplyingCustLedgEntry."Posting Date";
//                 ApplnCurrencyCode := ApplyingCustLedgEntry."Currency Code";
//               END;
//               CalcApplnAmount;
//             END;
//           CalcType::GenJnlLine:
//             BEGIN
//               ApplyingCustLedgEntry."Entry No." := 1;
//               ApplyingCustLedgEntry."Posting Date" := GenJnlLine."Posting Date";
//               ApplyingCustLedgEntry."Document Type" := GenJnlLine."Document Type";
//               ApplyingCustLedgEntry."Document No." := GenJnlLine."Document No.";
//               ApplyingCustLedgEntry."Customer No." := GenJnlLine."Account No.";
//               ApplyingCustLedgEntry.Description := GenJnlLine.Description;
//               ApplyingCustLedgEntry."Currency Code" := GenJnlLine."Currency Code";
//               ApplyingCustLedgEntry.Amount := GenJnlLine.Amount;
//               ApplyingCustLedgEntry."Remaining Amount" := GenJnlLine.Amount;
//               CalcApplnAmount;
//             END;
//         END;
//     end;

//     procedure SetCustApplId()
//     begin
//         IF (CalcType = CalcType::GenJnlLine) AND (ApplyingCustLedgEntry."Posting Date" < "Posting Date") THEN
//           ERROR(
//             Text006,ApplyingCustLedgEntry."Document Type",ApplyingCustLedgEntry."Document No.",
//             "Document Type","Document No.");

//         IF ApplyingCustLedgEntry."Entry No." <> 0 THEN
//           GenJnlApply.CheckAgainstApplnCurrency(
//             ApplnCurrencyCode,"Currency Code",GenJnlLine."Account Type"::Customer,TRUE);

//         CustLedgEntry.COPY(Rec);
//         CurrPage.SETSELECTIONFILTER(CustLedgEntry);

//         CustEntrySetApplID.SetApplId(CustLedgEntry,ApplyingCustLedgEntry,GetAppliesToID);

//         CalcApplnAmount;
//     end;

//     local procedure GetAppliesToID() AppliesToID: Code[50]
//     begin
//         CASE CalcType OF
//           CalcType::GenJnlLine:
//             AppliesToID := GenJnlLine."Applies-to ID";
//           CalcType::SalesHeader:
//             AppliesToID := SalesHeader."Applies-to ID";
//           CalcType::ServHeader:
//             AppliesToID := ServHeader."Applies-to ID";
//         END;
//     end;

//     procedure CalcApplnAmount()
//     var
//         ExchAccGLJnlLine: Codeunit "366";
//     begin
//         AppliedAmount := 0;
//         PmtDiscAmount := 0;
//         DifferentCurrenciesInAppln := FALSE;

//         CASE CalcType OF
//           CalcType::Direct:
//             BEGIN
//               FindAmountRounding;
//               CustEntryApplID := USERID;
//               IF CustEntryApplID = '' THEN
//                 CustEntryApplID := '***';

//               CustLedgEntry := ApplyingCustLedgEntry;

//               AppliedCustLedgEntry.SETCURRENTKEY("Customer No.",Open,Positive);
//               AppliedCustLedgEntry.SETRANGE("Customer No.","Customer No.");
//               AppliedCustLedgEntry.SETRANGE(Open,TRUE);
//               AppliedCustLedgEntry.SETRANGE("Applies-to ID",CustEntryApplID);

//               IF ApplyingCustLedgEntry."Entry No." <> 0 THEN BEGIN
//                 CustLedgEntry.CALCFIELDS("Remaining Amount");
//                 AppliedCustLedgEntry.SETFILTER("Entry No.",'<>%1',ApplyingCustLedgEntry."Entry No.");
//               END;

//               HandlChosenEntries(0,
//                 CustLedgEntry."Remaining Amount",
//                 CustLedgEntry."Currency Code",
//                 CustLedgEntry."Posting Date");
//             END;
//           CalcType::GenJnlLine:
//             BEGIN
//               FindAmountRounding;
//               IF GenJnlLine."Bal. Account Type" = GenJnlLine."Bal. Account Type"::Customer THEN
//                 ExchAccGLJnlLine.RUN(GenJnlLine);

//               CASE ApplnType OF
//                 ApplnType::"Applies-to Doc. No.":
//                   BEGIN
//                     AppliedCustLedgEntry := Rec;
//                     WITH AppliedCustLedgEntry DO BEGIN
//                       CALCFIELDS("Remaining Amount");
//                       IF "Currency Code" <> ApplnCurrencyCode THEN BEGIN
//                         "Remaining Amount" :=
//                           CurrExchRate.ExchangeAmtFCYToFCY(
//                             ApplnDate,"Currency Code",ApplnCurrencyCode,"Remaining Amount");
//                         "Remaining Pmt. Disc. Possible" :=
//                           CurrExchRate.ExchangeAmtFCYToFCY(
//                             ApplnDate,"Currency Code",ApplnCurrencyCode,"Remaining Pmt. Disc. Possible");
//                         "Amount to Apply" :=
//                           CurrExchRate.ExchangeAmtFCYToFCY(
//                             ApplnDate,"Currency Code",ApplnCurrencyCode,"Amount to Apply");
//                       END;

//                       IF "Amount to Apply" <> 0 THEN
//                         AppliedAmount := ROUND("Amount to Apply",AmountRoundingPrecision)
//                       ELSE
//                         AppliedAmount := ROUND("Remaining Amount",AmountRoundingPrecision);

//                       IF PaymentToleranceMgt.CheckCalcPmtDiscGenJnlCust(
//                            GenJnlLine,AppliedCustLedgEntry,0,FALSE) AND
//                          ((ABS(GenJnlLine.Amount) + ApplnRoundingPrecision >=
//                            ABS(AppliedAmount - "Remaining Pmt. Disc. Possible")) OR
//                           (GenJnlLine.Amount = 0))
//                       THEN
//                         PmtDiscAmount := "Remaining Pmt. Disc. Possible";

//                       IF NOT DifferentCurrenciesInAppln THEN
//                         DifferentCurrenciesInAppln := ApplnCurrencyCode <> "Currency Code";
//                     END;
//                     CheckRounding;
//                   END;
//                 ApplnType::"Applies-to ID":
//                   BEGIN
//                     GenJnlLine2 := GenJnlLine;
//                     AppliedCustLedgEntry.SETCURRENTKEY("Customer No.",Open,Positive);
//                     AppliedCustLedgEntry.SETRANGE("Customer No.",GenJnlLine."Account No.");
//                     AppliedCustLedgEntry.SETRANGE(Open,TRUE);
//                     AppliedCustLedgEntry.SETRANGE("Applies-to ID",GenJnlLine."Applies-to ID");

//                     HandlChosenEntries(1,
//                       GenJnlLine2.Amount,
//                       GenJnlLine2."Currency Code",
//                       GenJnlLine2."Posting Date");
//                   END;
//               END;
//             END;
//           CalcType::SalesHeader,CalcType::ServHeader:
//             BEGIN
//               FindAmountRounding;

//               CASE ApplnType OF
//                 ApplnType::"Applies-to Doc. No.":
//                   BEGIN
//                     AppliedCustLedgEntry := Rec;
//                     WITH AppliedCustLedgEntry DO BEGIN
//                       CALCFIELDS("Remaining Amount");

//                       IF "Currency Code" <> ApplnCurrencyCode THEN
//                         "Remaining Amount" :=
//                           CurrExchRate.ExchangeAmtFCYToFCY(
//                             ApplnDate,"Currency Code",ApplnCurrencyCode,"Remaining Amount");

//                       AppliedAmount := ROUND("Remaining Amount",AmountRoundingPrecision);

//                       IF NOT DifferentCurrenciesInAppln THEN
//                         DifferentCurrenciesInAppln := ApplnCurrencyCode <> "Currency Code";
//                     END;
//                     CheckRounding;
//                   END;
//                 ApplnType::"Applies-to ID":
//                   BEGIN
//                     AppliedCustLedgEntry.SETCURRENTKEY("Customer No.",Open,Positive);
//                     IF CalcType = CalcType::SalesHeader THEN
//                       AppliedCustLedgEntry.SETRANGE("Customer No.",SalesHeader."Bill-to Customer No.")
//                     ELSE
//                       AppliedCustLedgEntry.SETRANGE("Customer No.",ServHeader."Bill-to Customer No.");
//                     AppliedCustLedgEntry.SETRANGE(Open,TRUE);
//                     AppliedCustLedgEntry.SETRANGE("Applies-to ID",GetAppliesToID);

//                     HandlChosenEntries(2,
//                       ApplyingAmount,
//                       ApplnCurrencyCode,
//                       ApplnDate);
//                   END;
//               END;
//             END;
//         END;
//     end;

//     procedure CalcApplnRemainingAmount(Amount: Decimal): Decimal
//     var
//         ApplnRemainingAmount: Decimal;
//     begin
//         ValidExchRate := TRUE;
//         IF ApplnCurrencyCode = "Currency Code" THEN
//           EXIT(Amount);

//         IF ApplnDate = 0D THEN
//           ApplnDate := "Posting Date";
//         ApplnRemainingAmount :=
//           CurrExchRate.ApplnExchangeAmtFCYToFCY(
//             ApplnDate,"Currency Code",ApplnCurrencyCode,Amount,ValidExchRate);
//         EXIT(ApplnRemainingAmount);
//     end;

//     procedure CalcApplnAmounttoApply(AmounttoApply: Decimal): Decimal
//     var
//         ApplnAmounttoApply: Decimal;
//     begin
//         ValidExchRate := TRUE;

//         IF ApplnCurrencyCode = "Currency Code" THEN
//           EXIT(AmounttoApply);

//         IF ApplnDate = 0D THEN
//           ApplnDate := "Posting Date";
//         ApplnAmounttoApply :=
//           CurrExchRate.ApplnExchangeAmtFCYToFCY(
//             ApplnDate,"Currency Code",ApplnCurrencyCode,AmounttoApply,ValidExchRate);
//         EXIT(ApplnAmounttoApply);
//     end;

//     procedure FindAmountRounding()
//     begin
//         IF ApplnCurrencyCode = '' THEN BEGIN
//           Currency.INIT;
//           Currency.Code := '';
//           Currency.InitRoundingPrecision;
//         END ELSE
//           IF ApplnCurrencyCode <> Currency.Code THEN
//             Currency.GET(ApplnCurrencyCode);

//         AmountRoundingPrecision := Currency."Amount Rounding Precision";
//     end;

//     procedure CheckRounding()
//     begin
//         ApplnRounding := 0;

//         CASE CalcType OF
//           CalcType::SalesHeader,CalcType::ServHeader:
//             EXIT;
//           CalcType::GenJnlLine:
//             IF (GenJnlLine."Document Type" <> GenJnlLine."Document Type"::Payment) AND
//                (GenJnlLine."Document Type" <> GenJnlLine."Document Type"::Refund)
//             THEN
//               EXIT;
//         END;

//         IF ApplnCurrencyCode = '' THEN
//           ApplnRoundingPrecision := GLSetup."Appln. Rounding Precision"
//         ELSE BEGIN
//           IF ApplnCurrencyCode <> "Currency Code" THEN
//             Currency.GET(ApplnCurrencyCode);
//           ApplnRoundingPrecision := Currency."Appln. Rounding Precision";
//         END;

//         IF (ABS((AppliedAmount - PmtDiscAmount) + ApplyingAmount) <= ApplnRoundingPrecision) AND DifferentCurrenciesInAppln THEN
//           ApplnRounding := -((AppliedAmount - PmtDiscAmount) + ApplyingAmount);
//     end;

//     procedure GetCustLedgEntry(var CustLedgEntry: Record "21")
//     begin
//         CustLedgEntry := Rec;
//     end;

//     procedure FindApplyingEntry()
//     begin
//         IF CalcType = CalcType::Direct THEN BEGIN
//           CustEntryApplID := USERID;
//           IF CustEntryApplID = '' THEN
//             CustEntryApplID := '***';

//           CustLedgEntry.SETCURRENTKEY("Customer No.","Applies-to ID",Open);
//           CustLedgEntry.SETRANGE("Customer No.","Customer No.");
//           CustLedgEntry.SETRANGE("Applies-to ID",CustEntryApplID);
//           CustLedgEntry.SETRANGE(Open,TRUE);
//           CustLedgEntry.SETRANGE("Applying Entry",TRUE);
//           IF CustLedgEntry.FINDFIRST THEN BEGIN
//             CustLedgEntry.CALCFIELDS(Amount,"Remaining Amount");
//             ApplyingCustLedgEntry := CustLedgEntry;
//             SETFILTER("Entry No.",'<>%1',CustLedgEntry."Entry No.");
//             SETRANGE(Positive,CustLedgEntry."Remaining Amount" < 0);
//             ApplyingAmount := CustLedgEntry."Remaining Amount";
//             ApplnDate := CustLedgEntry."Posting Date";
//             ApplnCurrencyCode := CustLedgEntry."Currency Code";
//           END;
//           CalcApplnAmount;
//         END;
//     end;

//     procedure HandlChosenEntries(Type: Option Direct,GenJnlLine,SalesHeader;CurrentAmount: Decimal;CurrencyCode: Code[10];"Posting Date": Date)
//     var
//         AppliedCustLedgEntryTemp: Record "21" temporary;
//         PossiblePmtDisc: Decimal;
//         OldPmtDisc: Decimal;
//         CorrectionAmount: Decimal;
//         CalculateCurrency: Boolean;
//         CanUseDisc: Boolean;
//         FromZeroGenJnl: Boolean;
//     begin
//         IF AppliedCustLedgEntry.FINDSET(FALSE,FALSE) THEN BEGIN
//           REPEAT
//             AppliedCustLedgEntryTemp := AppliedCustLedgEntry;
//             AppliedCustLedgEntryTemp.INSERT;
//           UNTIL AppliedCustLedgEntry.NEXT = 0;
//         END ELSE
//           EXIT;

//         FromZeroGenJnl := (CurrentAmount = 0) AND (Type = Type::GenJnlLine);

//         REPEAT
//           IF NOT FromZeroGenJnl THEN
//             AppliedCustLedgEntryTemp.SETRANGE(Positive,CurrentAmount < 0);
//           IF AppliedCustLedgEntryTemp.FINDFIRST THEN BEGIN
//             AppliedCustLedgEntryTemp.CALCFIELDS("Remaining Amount");

//             IF Type = Type::Direct THEN
//               CalculateCurrency := ApplyingCustLedgEntry."Entry No." <> 0
//             ELSE
//               CalculateCurrency := TRUE;

//             IF (CurrencyCode <> AppliedCustLedgEntryTemp."Currency Code") AND CalculateCurrency THEN BEGIN
//               AppliedCustLedgEntryTemp."Remaining Amount" :=
//                 CurrExchRate.ExchangeAmount(
//                   AppliedCustLedgEntryTemp."Remaining Amount",
//                   AppliedCustLedgEntryTemp."Currency Code",
//                   CurrencyCode,"Posting Date");
//               AppliedCustLedgEntryTemp."Remaining Pmt. Disc. Possible" :=
//                 CurrExchRate.ExchangeAmount(
//                   AppliedCustLedgEntryTemp."Remaining Pmt. Disc. Possible",
//                   AppliedCustLedgEntryTemp."Currency Code",
//                   CurrencyCode,"Posting Date");
//               AppliedCustLedgEntryTemp."Amount to Apply" :=
//                 CurrExchRate.ExchangeAmount(
//                   AppliedCustLedgEntryTemp."Amount to Apply",
//                   AppliedCustLedgEntryTemp."Currency Code",
//                   CurrencyCode,"Posting Date");
//             END;

//             CASE Type OF
//               Type::Direct:
//                 CanUseDisc := PaymentToleranceMgt.CheckCalcPmtDiscCust(CustLedgEntry,AppliedCustLedgEntryTemp,0,FALSE,FALSE);
//               Type::GenJnlLine:
//                 CanUseDisc := PaymentToleranceMgt.CheckCalcPmtDiscGenJnlCust(GenJnlLine2,AppliedCustLedgEntryTemp,0,FALSE)
//               ELSE
//                 CanUseDisc := FALSE;
//             END;

//             IF CanUseDisc AND
//                (ABS(AppliedCustLedgEntryTemp."Amount to Apply") >= ABS(AppliedCustLedgEntryTemp."Remaining Amount" -
//                   AppliedCustLedgEntryTemp."Remaining Pmt. Disc. Possible"))
//             THEN BEGIN
//               IF (ABS(CurrentAmount) > ABS(AppliedCustLedgEntryTemp."Remaining Amount" -
//                     AppliedCustLedgEntryTemp."Remaining Pmt. Disc. Possible"))
//               THEN BEGIN
//                 PmtDiscAmount := PmtDiscAmount + AppliedCustLedgEntryTemp."Remaining Pmt. Disc. Possible";
//                 CurrentAmount := CurrentAmount + AppliedCustLedgEntryTemp."Remaining Amount" -
//                   AppliedCustLedgEntryTemp."Remaining Pmt. Disc. Possible";
//               END ELSE
//                 IF (ABS(CurrentAmount) = ABS(AppliedCustLedgEntryTemp."Remaining Amount" -
//                       AppliedCustLedgEntryTemp."Remaining Pmt. Disc. Possible"))
//                 THEN BEGIN
//                   PmtDiscAmount := PmtDiscAmount + AppliedCustLedgEntryTemp."Remaining Pmt. Disc. Possible" + PossiblePmtDisc;
//                   CurrentAmount := CurrentAmount + AppliedCustLedgEntryTemp."Remaining Amount" -
//                     AppliedCustLedgEntryTemp."Remaining Pmt. Disc. Possible" - PossiblePmtDisc;
//                   PossiblePmtDisc := 0;
//                   AppliedAmount := AppliedAmount + CorrectionAmount;
//                 END ELSE
//                   IF FromZeroGenJnl THEN BEGIN
//                     PmtDiscAmount := PmtDiscAmount + AppliedCustLedgEntryTemp."Remaining Pmt. Disc. Possible";
//                     CurrentAmount := CurrentAmount +
//                       AppliedCustLedgEntryTemp."Remaining Amount" - AppliedCustLedgEntryTemp."Remaining Pmt. Disc. Possible";
//                   END ELSE BEGIN
//                     IF (CurrentAmount + AppliedCustLedgEntryTemp."Remaining Amount" >= 0) <> (CurrentAmount >= 0) THEN BEGIN
//                       PmtDiscAmount := PmtDiscAmount + PossiblePmtDisc;
//                       AppliedAmount := AppliedAmount + CorrectionAmount;
//                     END;
//                     CurrentAmount := CurrentAmount + AppliedCustLedgEntryTemp."Remaining Amount" -
//                       AppliedCustLedgEntryTemp."Remaining Pmt. Disc. Possible";
//                     PossiblePmtDisc := AppliedCustLedgEntryTemp."Remaining Pmt. Disc. Possible";
//                   END;
//             END ELSE BEGIN
//               IF ((CurrentAmount - PossiblePmtDisc + AppliedCustLedgEntryTemp."Amount to Apply") * CurrentAmount) <= 0 THEN BEGIN
//                 PmtDiscAmount := PmtDiscAmount + PossiblePmtDisc;
//                 CurrentAmount := CurrentAmount - PossiblePmtDisc;
//                 PossiblePmtDisc := 0;
//                 AppliedAmount := AppliedAmount + CorrectionAmount;
//               END;
//               CurrentAmount := CurrentAmount + AppliedCustLedgEntryTemp."Amount to Apply";
//             END;
//           END ELSE BEGIN
//             AppliedCustLedgEntryTemp.SETRANGE(Positive);
//             AppliedCustLedgEntryTemp.FINDFIRST;
//           END;

//           IF OldPmtDisc <> PmtDiscAmount THEN
//             AppliedAmount := AppliedAmount + AppliedCustLedgEntryTemp."Remaining Amount"
//           ELSE
//             AppliedAmount := AppliedAmount + AppliedCustLedgEntryTemp."Amount to Apply";
//           OldPmtDisc := PmtDiscAmount;

//           IF PossiblePmtDisc <> 0 THEN
//             CorrectionAmount := AppliedCustLedgEntryTemp."Remaining Amount" - AppliedCustLedgEntryTemp."Amount to Apply"
//           ELSE
//             CorrectionAmount := 0;

//           IF NOT DifferentCurrenciesInAppln THEN
//             DifferentCurrenciesInAppln := ApplnCurrencyCode <> AppliedCustLedgEntryTemp."Currency Code";

//           AppliedCustLedgEntryTemp.DELETE;
//           AppliedCustLedgEntryTemp.SETRANGE(Positive);

//         UNTIL NOT AppliedCustLedgEntryTemp.FINDFIRST;
//         CheckRounding;
//     end;

//     local procedure AmounttoApplyOnAfterValidate()
//     begin
//         IF ApplnType <> ApplnType::"Applies-to Doc. No." THEN BEGIN
//           CalcApplnAmount;
//           CurrPage.UPDATE(FALSE);
//         END;
//     end;

//     local procedure RecalcApplnAmount()
//     begin
//         CurrPage.UPDATE(TRUE);
//         CalcApplnAmount;
//     end;

//     local procedure LookupOKOnPush()
//     begin
//         OK := TRUE;
//     end;

//     local procedure PostDirectApplication()
//     var
//         CustEntryApplyPostedEntries: Codeunit "226";
//         PostApplication: Page "579";
//         ApplicationDate: Date;
//         NewApplicationDate: Date;
//         NewDocumentNo: Code[20];
//     begin
//         IF CalcType = CalcType::Direct THEN BEGIN
//           IF ApplyingCustLedgEntry."Entry No." <> 0 THEN BEGIN
//             Rec := ApplyingCustLedgEntry;
//             ApplicationDate := CustEntryApplyPostedEntries.GetApplicationDate(Rec);
//             PostApplication.SetValues("Document No.",ApplicationDate);
//             IF ACTION::OK = PostApplication.RUNMODAL THEN BEGIN
//               PostApplication.GetValues(NewDocumentNo,NewApplicationDate);
//               IF NewApplicationDate < ApplicationDate THEN
//                 ERROR(Text013,FIELDCAPTION("Posting Date"),TABLECAPTION);
//             END ELSE
//               ERROR(Text019);

//             CustEntryApplyPostedEntries.Apply(Rec,NewDocumentNo,NewApplicationDate);

//             MESSAGE(Text012);
//             PostingDone := TRUE;
//             CurrPage.CLOSE;
//           END ELSE
//             ERROR(Text002);
//         END ELSE
//           ERROR(Text003);
//     end;
// }

