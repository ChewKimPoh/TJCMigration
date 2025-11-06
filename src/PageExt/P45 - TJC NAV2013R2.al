// page 45 "Sales List"
// {
//     Caption = 'Sales List';
//     DataCaptionFields = "Document Type";
//     Editable = false;
//     PageType = List;
//     SourceTable = Table36;

//     layout
//     {
//         area(content)
//         {
//             repeater()
//             {
//                 field("Posting Date";"Posting Date")
//                 {
//                 }
//                 field("Payment Terms Code";"Payment Terms Code")
//                 {
//                 }
//                 field(Status;Status)
//                 {
//                 }
//                 field("No.";"No.")
//                 {
//                 }
//                 field("Posting Description";"Posting Description")
//                 {
//                 }
//                 field(Amount;Amount)
//                 {
//                 }
//                 field("Amount Including VAT";"Amount Including VAT")
//                 {
//                 }
//                 field("Sell-to Customer No.";"Sell-to Customer No.")
//                 {
//                 }
//                 field("Sell-to Customer Name";"Sell-to Customer Name")
//                 {
//                 }
//                 field("External Document No.";"External Document No.")
//                 {
//                 }
//                 field("Sell-to Post Code";"Sell-to Post Code")
//                 {
//                     Visible = false;
//                 }
//                 field("Sell-to Country/Region Code";"Sell-to Country/Region Code")
//                 {
//                     Visible = false;
//                 }
//                 field("Sell-to Contact";"Sell-to Contact")
//                 {
//                     Visible = false;
//                 }
//                 field("Bill-to Customer No.";"Bill-to Customer No.")
//                 {
//                     Visible = false;
//                 }
//                 field("Bill-to Name";"Bill-to Name")
//                 {
//                     Visible = false;
//                 }
//                 field("Bill-to Post Code";"Bill-to Post Code")
//                 {
//                     Visible = false;
//                 }
//                 field("Bill-to Country/Region Code";"Bill-to Country/Region Code")
//                 {
//                     Visible = false;
//                 }
//                 field("Bill-to Contact";"Bill-to Contact")
//                 {
//                     Visible = false;
//                 }
//                 field("Ship-to Code";"Ship-to Code")
//                 {
//                     Visible = false;
//                 }
//                 field("Ship-to Name";"Ship-to Name")
//                 {
//                     Visible = false;
//                 }
//                 field("Ship-to Post Code";"Ship-to Post Code")
//                 {
//                     Visible = false;
//                 }
//                 field("Ship-to Country/Region Code";"Ship-to Country/Region Code")
//                 {
//                     Visible = false;
//                 }
//                 field("Ship-to Contact";"Ship-to Contact")
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
//                 field("Location Code";"Location Code")
//                 {
//                     Visible = true;
//                 }
//                 field("Salesperson Code";"Salesperson Code")
//                 {
//                     Visible = false;
//                 }
//                 field("Assigned User ID";"Assigned User ID")
//                 {
//                 }
//                 field("Currency Code";"Currency Code")
//                 {
//                     Visible = false;
//                 }
//                 field("Document Date";"Document Date")
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
//             group("&Line")
//             {
//                 Caption = '&Line';
//                 Image = Line;
//                 action(Card)
//                 {
//                     Caption = 'Card';
//                     Image = EditLines;
//                     Promoted = true;
//                     PromotedCategory = Process;
//                     ShortCutKey = 'Shift+F7';

//                     trigger OnAction()
//                     var
//                         PageID: Integer;
//                     begin
//                         CASE "Document Type" OF
//                           "Document Type"::Quote:
//                             PageID := PAGE::"Sales Quote";
//                           "Document Type"::Order:
//                             PageID := PAGE::"Sales Order";
//                           "Document Type"::Invoice:
//                             PageID := PAGE::"Sales Invoice";
//                           "Document Type"::"Return Order":
//                             PageID := PAGE::"Sales Return Order";
//                           "Document Type"::"Credit Memo":
//                             PageID := PAGE::"Sales Credit Memo";
//                           "Document Type"::"Blanket Order":
//                             PageID := PAGE::"Blanket Sales Order";
//                         END;

//                         PageID := GetPageId(PageID);

//                         IF PageID <> 0 THEN
//                           PAGE.RUN(PageID,Rec);
//                     end;
//                 }
//             }
//         }
//         area(reporting)
//         {
//             action("Sales Reservation Avail.")
//             {
//                 Caption = 'Sales Reservation Avail.';
//                 Image = "Report";
//                 Promoted = false;
//                 //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
//                 //PromotedCategory = "Report";
//                 RunObject = Report 209;
//             }
//         }
//     }

//     local procedure GetPageId(PageId: Integer): Integer
//     var
//         MiniPagesMapping: Record "1305";
//     begin
//         IF MiniPagesMapping.READPERMISSION THEN
//           IF MiniPagesMapping.GET(PageId) THEN
//             EXIT(MiniPagesMapping.SubstitutePageID);

//         EXIT(PageId);
//     end;
// }

