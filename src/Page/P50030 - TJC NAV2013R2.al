// page 50030 "Logo Screen"
// {
//     PageType = Card;

//     layout
//     {
//         area(content)
//         {
//             field(;'')
//             {
//                 CaptionClass = FORMAT ('Welcome ' + USERID + ' to '  + COMPANYNAME);
//                 Editable = false;
//             }
//             field(recCI.Name;recCI.Name)
//             {
//                 Editable = false;
//                 Visible = false;
//             }
//             field(;'')
//             {
//                 CaptionClass = Text001;
//             }
//             field(;'')
//             {
//                 CaptionClass = Text000;
//             }
//             field(recCI.Picture;recCI.Picture)
//             {
//             }
//         }
//     }

//     actions
//     {
//     }

//     trigger OnOpenPage()
//     begin
//         recCI.GET;
//         recCI.CALCFIELDS(recCI.Picture);
//     end;

//     var
//         recCI: Record "79";
//         recPic: Record "27";
//         Text000: Label 'Implemented By:';
//         Text001: Label 'DP Technology Pte Ltd';
// }

