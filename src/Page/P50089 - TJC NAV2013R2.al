// page 50089 "TJC Web Users"
// {
//     PageType = List;
//     SourceTable = Table50013;

//     layout
//     {
//         area(content)
//         {
//             repeater(Group)
//             {
//                 field("Full Name";"Full Name")
//                 {
//                 }
//                 field(UserID;UserID)
//                 {
//                 }
//                 field(Password;Password)
//                 {
//                 }
//                 field(Email;Email)
//                 {
//                 }
//                 field(SalesPerson;SalesPerson)
//                 {
//                 }
//             }
//         }
//     }

//     actions
//     {
//         area(processing)
//         {
//             action("Data Patching")
//             {

//                 trigger OnAction()
//                 var
//                     Lcdu_TJCFunctions: Codeunit "50003";
//                 begin
//                     Lcdu_TJCFunctions.DataPatching;
//                 end;
//             }
//         }
//     }
// }

