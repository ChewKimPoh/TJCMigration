// page 50028 "Dosage UOM"
// {
//     Caption = 'Item Units of Measure';
//     DataCaptionFields = "Item No.";
//     Editable = false;
//     PageType = List;
//     SourceTable = Table5404;

//     layout
//     {
//         area(content)
//         {
//             repeater()
//             {
//                 field("Item No.";"Item No.")
//                 {
//                     Visible = false;
//                 }
//                 field(Code;Code)
//                 {
//                 }
//                 field("Qty. per Unit of Measure";"Qty. per Unit of Measure")
//                 {
//                 }
//                 field(Description;Description)
//                 {
//                 }
//                 field(Height;Height)
//                 {
//                     Visible = false;
//                 }
//                 field(Width;Width)
//                 {
//                     Visible = false;
//                 }
//                 field(Length;Length)
//                 {
//                     Visible = false;
//                 }
//                 field(Cubage;Cubage)
//                 {
//                     Visible = false;
//                 }
//                 field(Weight;Weight)
//                 {
//                     Visible = false;
//                 }
//             }
//         }
//     }

//     actions
//     {
//     }

//     trigger OnAfterGetRecord()
//     begin
//         UOM.GET(Code);
//         Description := UOM.Description;
//     end;

//     var
//         UOM: Record "204";
//         Description: Text[10];
// }

