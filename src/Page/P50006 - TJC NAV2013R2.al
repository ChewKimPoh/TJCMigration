// page 50006 "Stock Take List"
// {
//     InsertAllowed = false;
//     PageType = Worksheet;
//     SourceTable = Table50002;

//     layout
//     {
//         area(content)
//         {
//             field(Batch.Name;Batch.Name)
//             {
//                 TableRelation = "Item Journal Batch".Name WHERE (Journal Template Name=CONST(PHYS. INVE));

//                 trigger OnValidate()
//                 begin
//                     //    SETRANGE("Batch Name",Batch.Name);
//                     //       CurrForm.UPDATE;
//                     //CurrForm.UPDATE(FALSE)  ;;
//                       BatchNameOnAfterValidate;
//                 end;
//             }
//             repeater()
//             {
//                 Editable = true;
//                 field(Status;Status)
//                 {
//                 }
//                 field("Batch Name";"Batch Name")
//                 {
//                     Editable = false;
//                 }
//                 field(Date;Date)
//                 {
//                     Editable = false;
//                 }
//                 field("Item Code";"Item Code")
//                 {
//                     Editable = false;
//                 }
//                 field(Description;Description)
//                 {
//                     Editable = false;
//                 }
//                 field("Lot No.";"Lot No.")
//                 {
//                     Editable = true;
//                 }
//                 field(Remark;Remark)
//                 {
//                 }
//                 field(Location;Location)
//                 {
//                     Editable = false;
//                 }
//                 field(Bin;Bin)
//                 {
//                     Editable = false;
//                 }
//                 field("System Quantity";"System Quantity")
//                 {
//                     Caption = 'Qty. (Calculated)';
//                     Editable = false;
//                 }
//                 field(Quantity;Quantity)
//                 {
//                     Caption = 'Qty. (Phys. Inventory)';
//                     Editable = false;
//                 }
//                 field("Qty (Difference)";"Qty (Difference)")
//                 {
//                     Editable = false;
//                 }
//                 field(UserCode;UserCode)
//                 {
//                     Editable = false;
//                 }
//                 field(PDACode;PDACode)
//                 {
//                     Editable = false;
//                 }
//             }
//             field(;'')
//             {
//                 CaptionClass = Text000;
//             }
//         }
//     }

//     actions
//     {
//         area(processing)
//         {
//             action("Compare Stock Inventory")
//             {
//                 Caption = 'Compare Stock Inventory';
//                 Promoted = true;
//                 PromotedCategory = Process;

//                 trigger OnAction()
//                 begin
//                        BIZLayer."Compare Stock Inventory"(Batch.Name);
//                        CurrPage.UPDATE;
//                 end;
//             }
//         }
//     }

//     trigger OnInit()
//     begin

//         RESET;
//         FILTERGROUP(2);
//         SETRANGE("Batch Name",'');
//         FILTERGROUP(0);
//     end;

//     trigger OnOpenPage()
//     begin
//            IF  Batch.FIND('-') THEN;
//     end;

//     var
//         Batch: Record "233";
//         location: Record "14";
//         BIZLayer: Codeunit "50002";
//         Text000: Label 'Batch Name';

//     local procedure BatchNameOnAfterValidate()
//     begin
//         RESET;
//            SETRANGE("Batch Name",Batch.Name);
//           CurrPage.UPDATE(FALSE)  ;
//     end;
// }

