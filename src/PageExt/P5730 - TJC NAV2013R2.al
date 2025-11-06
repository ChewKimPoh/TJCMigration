// page 5730 "Item Categories"
// {
//     Caption = 'Item Categories';
//     PageType = List;
//     SourceTable = Table5722;

//     layout
//     {
//         area(content)
//         {
//             repeater()
//             {
//                 field(Code;Code)
//                 {
//                 }
//                 field(Description;Description)
//                 {
//                 }
//                 field("Commission Rate";"Commission Rate")
//                 {
//                 }
//                 field("Def. Gen. Prod. Posting Group";"Def. Gen. Prod. Posting Group")
//                 {
//                 }
//                 field("Def. Inventory Posting Group";"Def. Inventory Posting Group")
//                 {
//                 }
//                 field("Def. VAT Prod. Posting Group";"Def. VAT Prod. Posting Group")
//                 {
//                 }
//                 field("Def. Costing Method";"Def. Costing Method")
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
//         area(processing)
//         {
//             action("&Prod. Groups")
//             {
//                 Caption = '&Prod. Groups';
//                 Image = ItemGroup;
//                 Promoted = true;
//                 PromotedCategory = Process;
//                 RunObject = Page 5731;
//                 RunPageLink = Item Category Code=FIELD(Code);
//             }
//         }
//     }
// }

