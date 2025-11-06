// page 132 "Posted Sales Invoice"
// {
//     // Version No.          : TJCSG1.00
//     // Deverloper           : DP.NDN
//     // Date of Last Change  : 14/10/2014
//     // Description          :
//     //   - Set default the Filter No. to current Invoice No.
//     // 

//     Caption = 'Posted Sales Invoice';
//     InsertAllowed = false;
//     PageType = Document;
//     RefreshOnActivate = true;
//     SourceTable = Table112;

//     layout
//     {
//         area(content)
//         {
//             group(General)
//             {
//                 Caption = 'General';
//                 field("No.";"No.")
//                 {
//                     Editable = false;
//                     Importance = Promoted;
//                 }
//                 field("Sell-to Customer No.";"Sell-to Customer No.")
//                 {
//                     Editable = false;
//                     Importance = Promoted;
//                 }
//                 field("Sell-to Contact No.";"Sell-to Contact No.")
//                 {
//                     Editable = false;
//                 }
//                 field("Sell-to Customer Name";"Sell-to Customer Name")
//                 {
//                     Editable = false;
//                 }
//                 field("Sell-to Address";"Sell-to Address")
//                 {
//                     Editable = false;
//                 }
//                 field("Sell-to Address 2";"Sell-to Address 2")
//                 {
//                     Editable = false;
//                 }
//                 field("Sell-to Post Code";"Sell-to Post Code")
//                 {
//                     Editable = false;
//                 }
//                 field("Sell-to City";"Sell-to City")
//                 {
//                     Editable = false;
//                 }
//                 field("Sell-to Contact";"Sell-to Contact")
//                 {
//                     Editable = false;
//                 }
//                 field("Posting Date";"Posting Date")
//                 {
//                     Editable = false;
//                     Importance = Promoted;
//                 }
//                 field("Document Date";"Document Date")
//                 {
//                     Editable = false;
//                 }
//                 field("Quote No.";"Quote No.")
//                 {
//                 }
//                 field("Order No.";"Order No.")
//                 {
//                     Editable = false;
//                     Importance = Promoted;
//                 }
//                 field("Pre-Assigned No.";"Pre-Assigned No.")
//                 {
//                     Editable = false;
//                 }
//                 field("External Document No.";"External Document No.")
//                 {
//                     Editable = false;
//                     Importance = Promoted;
//                 }
//                 field("Salesperson Code";"Salesperson Code")
//                 {
//                     Editable = false;
//                 }
//                 field("Responsibility Center";"Responsibility Center")
//                 {
//                     Editable = false;
//                 }
//                 field("No. Printed";"No. Printed")
//                 {
//                     Editable = false;
//                     Visible = true;
//                 }
//             }
//             part(SalesInvLines;133)
//             {
//                 SubPageLink = Document No.=FIELD(No.);
//             }
//             group(Invoicing)
//             {
//                 Caption = 'Invoicing';
//                 field("Bill-to Customer No.";"Bill-to Customer No.")
//                 {
//                     Editable = false;
//                     Importance = Promoted;
//                 }
//                 field("Bill-to Contact No.";"Bill-to Contact No.")
//                 {
//                     Editable = false;
//                 }
//                 field("Bill-to Name";"Bill-to Name")
//                 {
//                     Editable = false;
//                 }
//                 field("Bill-to Address";"Bill-to Address")
//                 {
//                     Editable = false;
//                 }
//                 field("Bill-to Address 2";"Bill-to Address 2")
//                 {
//                     Editable = false;
//                 }
//                 field("Bill-to Post Code";"Bill-to Post Code")
//                 {
//                     Editable = false;
//                 }
//                 field("Bill-to City";"Bill-to City")
//                 {
//                     Editable = false;
//                 }
//                 field("Bill-to Contact";"Bill-to Contact")
//                 {
//                     Editable = false;
//                 }
//                 field("Shortcut Dimension 1 Code";"Shortcut Dimension 1 Code")
//                 {
//                     Editable = false;
//                 }
//                 field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
//                 {
//                     Editable = false;
//                 }
//                 field("Payment Terms Code";"Payment Terms Code")
//                 {
//                     Editable = false;
//                     Importance = Promoted;
//                 }
//                 field("Due Date";"Due Date")
//                 {
//                     Editable = false;
//                     Importance = Promoted;
//                 }
//                 field("Payment Discount %";"Payment Discount %")
//                 {
//                     Editable = false;
//                 }
//                 field("Pmt. Discount Date";"Pmt. Discount Date")
//                 {
//                     Editable = false;
//                 }
//                 field("Payment Method Code";"Payment Method Code")
//                 {
//                     Editable = false;
//                 }
//                 field("Direct Debit Mandate ID";"Direct Debit Mandate ID")
//                 {
//                     Editable = false;
//                 }
//                 field("Credit Card No.";"Credit Card No.")
//                 {
//                     Editable = false;
//                 }
//                 field(GetCreditcardNumber;GetCreditcardNumber)
//                 {
//                     Caption = 'Cr. Card Number (Last 4 Digits)';
//                     Editable = false;
//                 }
//             }
//             group(Shipping)
//             {
//                 Caption = 'Shipping';
//                 field("Ship-to Code";"Ship-to Code")
//                 {
//                     Editable = false;
//                     Importance = Promoted;
//                 }
//                 field("Ship-to Name";"Ship-to Name")
//                 {
//                     Editable = false;
//                 }
//                 field("Ship-to Address";"Ship-to Address")
//                 {
//                     Editable = false;
//                 }
//                 field("Ship-to Address 2";"Ship-to Address 2")
//                 {
//                     Editable = false;
//                 }
//                 field("Ship-to Post Code";"Ship-to Post Code")
//                 {
//                     Editable = false;
//                     Importance = Promoted;
//                 }
//                 field("Ship-to City";"Ship-to City")
//                 {
//                     Editable = false;
//                 }
//                 field("Ship-to Contact";"Ship-to Contact")
//                 {
//                     Editable = false;
//                 }
//                 field("Location Code";"Location Code")
//                 {
//                     Editable = false;
//                 }
//                 field("Shipment Method Code";"Shipment Method Code")
//                 {
//                     Editable = false;
//                 }
//                 field("Shipment Date";"Shipment Date")
//                 {
//                     Editable = false;
//                     Importance = Promoted;
//                 }
//             }
//             group("Foreign Trade")
//             {
//                 Caption = 'Foreign Trade';
//                 field("Currency Code";"Currency Code")
//                 {
//                     Importance = Promoted;

//                     trigger OnAssistEdit()
//                     begin
//                         ChangeExchangeRate.SetParameter("Currency Code","Currency Factor","Posting Date");
//                         ChangeExchangeRate.EDITABLE(FALSE);
//                         IF ChangeExchangeRate.RUNMODAL = ACTION::OK THEN BEGIN
//                           "Currency Factor" := ChangeExchangeRate.GetParameter;
//                           MODIFY;
//                         END;
//                         CLEAR(ChangeExchangeRate);
//                     end;
//                 }
//                 field("EU 3-Party Trade";"EU 3-Party Trade")
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
//                 Visible = true;
//             }
//         }
//     }

//     actions
//     {
//         area(navigation)
//         {
//             group("&Invoice")
//             {
//                 Caption = '&Invoice';
//                 Image = Invoice;
//                 action(Statistics)
//                 {
//                     Caption = 'Statistics';
//                     Image = Statistics;
//                     Promoted = true;
//                     PromotedCategory = Process;
//                     RunObject = Page 397;
//                     RunPageLink = No.=FIELD(No.);
//                     ShortCutKey = 'F7';
//                 }
//                 action("Co&mments")
//                 {
//                     Caption = 'Co&mments';
//                     Image = ViewComments;
//                     RunObject = Page 67;
//                     RunPageLink = Document Type=CONST(Posted Invoice),
//                                   No.=FIELD(No.),
//                                   Document Line No.=CONST(0);
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
//                 action(Approvals)
//                 {
//                     Caption = 'Approvals';
//                     Image = Approvals;

//                     trigger OnAction()
//                     var
//                         PostedApprovalEntries: Page "659";
//                     begin
//                         PostedApprovalEntries.Setfilters(DATABASE::"Sales Invoice Header","No.");
//                         PostedApprovalEntries.RUN;
//                     end;
//                 }
//                 separator()
//                 {
//                 }
//                 action("Credit Cards Transaction Lo&g Entries")
//                 {
//                     Caption = 'Credit Cards Transaction Lo&g Entries';
//                     Image = CreditCardLog;
//                     RunObject = Page 829;
//                     RunPageLink = Document Type=CONST(Payment),
//                                   Document No.=FIELD(No.),
//                                   Customer No.=FIELD(Bill-to Customer No.);
//                 }
//             }
//         }
//         area(processing)
//         {
//             action("&Print")
//             {
//                 Caption = '&Print';
//                 Ellipsis = true;
//                 Image = Print;
//                 Promoted = true;
//                 PromotedCategory = Process;

//                 trigger OnAction()
//                 begin
//                     CurrPage.SETSELECTIONFILTER(SalesInvHeader);
//                     SalesInvHeader.PrintRecords(TRUE);
//                 end;
//             }
//             action("Posted Sale Invoice")
//             {
//                 Caption = 'Posted Sale Invoice';
//                 Image = "Report";

//                 trigger OnAction()
//                 begin
//                      /*Start:DP.NDN DD#231 */
//                     CurrPage.SETSELECTIONFILTER(SalesInvHeader);
//                     REPORT.RUNMODAL(50010,TRUE,FALSE,SalesInvHeader);
//                     /*End:DP.NDN DD#231 */

//                 end;
//             }
//             action("&Navigate")
//             {
//                 Caption = '&Navigate';
//                 Image = Navigate;
//                 Promoted = true;
//                 PromotedCategory = Process;

//                 trigger OnAction()
//                 begin
//                     Navigate;
//                 end;
//             }
//         }
//     }

//     trigger OnOpenPage()
//     begin
//         SetSecurityFilterOnRespCenter;
//     end;

//     var
//         SalesInvHeader: Record "112";
//         ChangeExchangeRate: Page "511";
// }

