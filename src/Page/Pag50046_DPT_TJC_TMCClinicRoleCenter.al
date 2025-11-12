// page 50046 "TMC (Clinic) Role Center"
// {
//     PageType = RoleCenter;

//     layout
//     {
//         area(rolecenter)
//         {
//             group()
//             {
//                 part(;50053)
//                 {
//                     Visible = false;
//                 }
//                 systempart(;Outlook)
//                 {
//                     Visible = false;
//                 }
//             }
//             group()
//             {
//                 systempart(;MyNotes)
//                 {
//                 }
//             }
//         }
//     }

//     actions
//     {
//         area(embedding)
//         {
//             group("TJC - TMC (Clinic)")
//             {
//                 Caption = 'TJC - TMC (Clinic)';
//                 Image = Marketing;
//                 action("Medicine List")
//                 {
//                     Caption = 'Medicine List';
//                     RunObject = Page 50024;
//                 }
//                 action("Patient List")
//                 {
//                     Caption = 'Patient List';
//                     RunObject = Page 50020;
//                 }
//             }
//         }
//         area(sections)
//         {
//             group(Setup)
//             {
//                 Caption = 'Setup';
//                 Image = Setup;
//                 action("Clinic Item Categories")
//                 {
//                     Caption = 'Clinic Item Categories';
//                     RunObject = Page 50025;
//                 }
//                 action("Sickness Category")
//                 {
//                     Caption = 'Sickness Category';
//                     RunObject = Page 50022;
//                 }
//                 action("Bar Code")
//                 {
//                     Caption = 'Bar Code';
//                     RunObject = Page 50029;
//                 }
//                 action("Tongue 1")
//                 {
//                     Caption = 'Tongue 1';
//                     RunObject = Page 50018;
//                 }
//                 action("Tongue 2")
//                 {
//                     Caption = 'Tongue 2';
//                     RunObject = Page 50019;
//                 }
//                 action(Pulse)
//                 {
//                     Caption = 'Pulse';
//                     RunObject = Page 50021;
//                 }
//                 action("User Setup")
//                 {
//                     Caption = 'User Setup';
//                     RunObject = Page 119;
//                     Visible = false;
//                 }
//             }
//         }
//         area(processing)
//         {
//             action("Clinic Visit Analysis")
//             {
//                 Caption = 'Clinic Visit Analysis';
//                 Image = AnalysisView;
//                 RunObject = Page 50027;
//             }
//             action("Item Journal")
//             {
//                 Caption = 'Item Journal';
//                 Image = Journals;
//                 RunObject = Page 40;
//                 Visible = false;
//             }
//             group(Setup)
//             {
//                 Caption = 'Setup';
//                 action("User Setup")
//                 {
//                     Caption = 'User Setup';
//                     Image = UserSetup;
//                     RunObject = Page 119;
//                 }
//                 action("Relationship Management Setup")
//                 {
//                     Caption = 'Relationship Management Setup';
//                     Image = MarketingSetup;
//                     RunObject = Page 5094;
//                 }
//                 action("Sales & Receivables Setup")
//                 {
//                     Caption = 'Sales & Receivables Setup';
//                     Image = ReceivablesPayablesSetup;
//                     RunObject = Page 459;
//                 }
//             }
//         }
//     }
// }

