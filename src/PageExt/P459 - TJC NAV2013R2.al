// page 459 "Sales & Receivables Setup"
// {
//     // DP.RWP - Add Clinic Tab

//     Caption = 'Sales & Receivables Setup';
//     DeleteAllowed = false;
//     InsertAllowed = false;
//     PageType = Card;
//     SourceTable = Table311;

//     layout
//     {
//         area(content)
//         {
//             group(General)
//             {
//                 Caption = 'General';
//                 field("Discount Posting";"Discount Posting")
//                 {
//                 }
//                 field("Credit Warnings";"Credit Warnings")
//                 {
//                 }
//                 field("Stockout Warning";"Stockout Warning")
//                 {
//                 }
//                 field("Shipment on Invoice";"Shipment on Invoice")
//                 {
//                 }
//                 field("Return Receipt on Credit Memo";"Return Receipt on Credit Memo")
//                 {
//                 }
//                 field("Invoice Rounding";"Invoice Rounding")
//                 {
//                 }
//                 field("Ext. Doc. No. Mandatory";"Ext. Doc. No. Mandatory")
//                 {
//                 }
//                 field("Appln. between Currencies";"Appln. between Currencies")
//                 {
//                 }
//                 field("Logo Position on Documents";"Logo Position on Documents")
//                 {
//                 }
//                 field("Default Posting Date";"Default Posting Date")
//                 {
//                 }
//                 field("Default Quantity to Ship";"Default Quantity to Ship")
//                 {
//                 }
//                 field("Copy Comments Blanket to Order";"Copy Comments Blanket to Order")
//                 {
//                 }
//                 field("Copy Comments Order to Invoice";"Copy Comments Order to Invoice")
//                 {
//                 }
//                 field("Copy Comments Order to Shpt.";"Copy Comments Order to Shpt.")
//                 {
//                 }
//                 field("Copy Cmts Ret.Ord. to Cr. Memo";"Copy Cmts Ret.Ord. to Cr. Memo")
//                 {
//                 }
//                 field("Copy Cmts Ret.Ord. to Ret.Rcpt";"Copy Cmts Ret.Ord. to Ret.Rcpt")
//                 {
//                 }
//                 field("Allow VAT Difference";"Allow VAT Difference")
//                 {
//                 }
//                 field("Calc. Inv. Discount";"Calc. Inv. Discount")
//                 {
//                 }
//                 field("Calc. Inv. Disc. per VAT ID";"Calc. Inv. Disc. per VAT ID")
//                 {
//                 }
//                 field("VAT Bus. Posting Gr. (Price)";"VAT Bus. Posting Gr. (Price)")
//                 {
//                 }
//                 field("Exact Cost Reversing Mandatory";"Exact Cost Reversing Mandatory")
//                 {
//                 }
//                 field("Check Prepmt. when Posting";"Check Prepmt. when Posting")
//                 {
//                 }
//                 field("Archive Quotes and Orders";"Archive Quotes and Orders")
//                 {
//                 }
//             }
//             group(Dimensions)
//             {
//                 Caption = 'Dimensions';
//                 field("Customer Group Dimension Code";"Customer Group Dimension Code")
//                 {
//                 }
//                 field("Salesperson Dimension Code";"Salesperson Dimension Code")
//                 {
//                 }
//             }
//             group(Numbering)
//             {
//                 Caption = 'Numbering';
//                 field("Customer Nos.";"Customer Nos.")
//                 {
//                 }
//                 field("Quote Nos.";"Quote Nos.")
//                 {
//                 }
//                 field("Blanket Order Nos.";"Blanket Order Nos.")
//                 {
//                 }
//                 field("Order Nos.";"Order Nos.")
//                 {
//                 }
//                 field("Return Order Nos.";"Return Order Nos.")
//                 {
//                 }
//                 field("Invoice Nos.";"Invoice Nos.")
//                 {
//                 }
//                 field("Posted Invoice Nos.";"Posted Invoice Nos.")
//                 {
//                 }
//                 field("Credit Memo Nos.";"Credit Memo Nos.")
//                 {
//                 }
//                 field("Posted Credit Memo Nos.";"Posted Credit Memo Nos.")
//                 {
//                 }
//                 field("Posted Shipment Nos.";"Posted Shipment Nos.")
//                 {
//                 }
//                 field("Posted Return Receipt Nos.";"Posted Return Receipt Nos.")
//                 {
//                 }
//                 field("Reminder Nos.";"Reminder Nos.")
//                 {
//                 }
//                 field("Issued Reminder Nos.";"Issued Reminder Nos.")
//                 {
//                 }
//                 field("Fin. Chrg. Memo Nos.";"Fin. Chrg. Memo Nos.")
//                 {
//                 }
//                 field("Issued Fin. Chrg. M. Nos.";"Issued Fin. Chrg. M. Nos.")
//                 {
//                 }
//                 field("Posted Prepmt. Inv. Nos.";"Posted Prepmt. Inv. Nos.")
//                 {
//                 }
//                 field("Posted Prepmt. Cr. Memo Nos.";"Posted Prepmt. Cr. Memo Nos.")
//                 {
//                 }
//                 field("Direct Debit Mandate Nos.";"Direct Debit Mandate Nos.")
//                 {
//                 }
//             }
//             group("Background Posting")
//             {
//                 Caption = 'Background Posting';
//                 group(Post)
//                 {
//                     Caption = 'Post';
//                     field("Post with Job Queue";"Post with Job Queue")
//                     {
//                     }
//                     field("Job Queue Priority for Post";"Job Queue Priority for Post")
//                     {
//                     }
//                 }
//                 group("Post & Print")
//                 {
//                     Caption = 'Post & Print';
//                     field("Post & Print with Job Queue";"Post & Print with Job Queue")
//                     {
//                     }
//                     field("Job Q. Prio. for Post & Print";"Job Q. Prio. for Post & Print")
//                     {
//                     }
//                 }
//                 group(General)
//                 {
//                     Caption = 'General';
//                     field("Job Queue Category Code";"Job Queue Category Code")
//                     {
//                     }
//                     field("Notify On Success";"Notify On Success")
//                     {
//                     }
//                 }
//             }
//             group(Clinic)
//             {
//                 Caption = 'Clinic';
//                 field(BarCode1;BarCode1)
//                 {
//                 }
//                 field(BarCode3;BarCode3)
//                 {
//                 }
//                 field(BarCode5;BarCode5)
//                 {
//                 }
//                 field(BarCode7;BarCode7)
//                 {
//                 }
//                 field("Allow Edit";"Allow Edit")
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
//     }

//     trigger OnOpenPage()
//     begin
//         RESET;
//         IF NOT GET THEN BEGIN
//           INIT;
//           INSERT;
//         END;
//     end;
// }

