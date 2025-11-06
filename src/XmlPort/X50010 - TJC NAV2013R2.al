// xmlport 50010 "Location List"
// {
//     UseDefaultNamespace = true;

//     schema
//     {
//         textelement(LocationlList)
//         {
//             tableelement(Table14;Table14)
//             {
//                 AutoReplace = true;
//                 AutoSave = false;
//                 XmlName = 'Location';
//                 fieldelement(Code;Location.Code)
//                 {
//                 }
//                 fieldelement(Name;Location.Name)
//                 {
//                 }

//                 trigger OnAfterGetRecord()
//                 var
//                     recItem: Record "27";
//                 begin
//                 end;
//             }
//         }
//     }

//     requestpage
//     {

//         layout
//         {
//         }

//         actions
//         {
//         }
//     }

//     trigger OnPostXmlPort()
//     var
//         recTransferHeader: Record "5740";
//         cPOPost: Codeunit "90";
//     begin
//     end;

//     var
//         TODoc: Code[20];
// }

