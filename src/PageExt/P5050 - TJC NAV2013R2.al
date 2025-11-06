// page 5050 "Contact Card"
// {
//     Caption = 'Contact Card';
//     PageType = ListPlus;
//     SourceTable = Table5050;

//     layout
//     {
//         area(content)
//         {
//             group(General)
//             {
//                 Caption = 'General';
//                 field("No.";"No.")
//                 {

//                     trigger OnAssistEdit()
//                     begin
//                         IF AssistEdit(xRec) THEN
//                           CurrPage.UPDATE;
//                     end;
//                 }
//                 field(Type;Type)
//                 {

//                     trigger OnValidate()
//                     begin
//                         TypeOnAfterValidate;
//                     end;
//                 }
//                 field("Company No.";"Company No.")
//                 {
//                     Enabled = "Company No.Enable";
//                 }
//                 field("Company Name";"Company Name")
//                 {
//                     AssistEdit = true;
//                     Enabled = "Company NameEnable";

//                     trigger OnAssistEdit()
//                     begin
//                         Cont.SETRANGE("No.","Company No.");
//                         CLEAR(CompanyDetails);
//                         CompanyDetails.SETTABLEVIEW(Cont);
//                         CompanyDetails.SETRECORD(Cont);
//                         IF Type = Type::Person THEN
//                           CompanyDetails.EDITABLE := FALSE;
//                         CompanyDetails.RUNMODAL;
//                     end;
//                 }
//                 field(IntegrationCustomerNo;IntegrationCustomerNo)
//                 {
//                     Caption = 'Integration Customer No.';
//                     Visible = false;

//                     trigger OnValidate()
//                     var
//                         Customer: Record "18";
//                         ContactBusinessRelation: Record "5054";
//                     begin
//                         IF NOT (IntegrationCustomerNo = '') THEN BEGIN
//                           Customer.GET(IntegrationCustomerNo);
//                           ContactBusinessRelation.SETCURRENTKEY("Link to Table","No.");
//                           ContactBusinessRelation.SETRANGE("Link to Table",ContactBusinessRelation."Link to Table"::Customer);
//                           ContactBusinessRelation.SETRANGE("No.",Customer."No.");
//                           IF ContactBusinessRelation.FINDFIRST THEN
//                             VALIDATE("Company No.",ContactBusinessRelation."Contact No.");
//                         END ELSE
//                           VALIDATE("Company No.",'');
//                     end;
//                 }
//                 field(Name;Name)
//                 {
//                     AssistEdit = true;

//                     trigger OnAssistEdit()
//                     begin
//                         MODIFY;
//                         COMMIT;
//                         Cont.SETRANGE("No.","No.");
//                         IF Type = Type::Person THEN BEGIN
//                           CLEAR(NameDetails);
//                           NameDetails.SETTABLEVIEW(Cont);
//                           NameDetails.SETRECORD(Cont);
//                           NameDetails.RUNMODAL;
//                         END ELSE BEGIN
//                           CLEAR(CompanyDetails);
//                           CompanyDetails.SETTABLEVIEW(Cont);
//                           CompanyDetails.SETRECORD(Cont);
//                           CompanyDetails.RUNMODAL;
//                         END;
//                         GET("No.");
//                         CurrPage.UPDATE;
//                     end;
//                 }
//                 field(Address;Address)
//                 {
//                 }
//                 field("Address 2";"Address 2")
//                 {
//                 }
//                 field("Post Code";"Post Code")
//                 {
//                 }
//                 field(City;City)
//                 {
//                 }
//                 field("Country/Region Code";"Country/Region Code")
//                 {
//                 }
//                 field("Search Name";"Search Name")
//                 {
//                 }
//                 field("Phone No.";"Phone No.")
//                 {
//                 }
//                 field("Salesperson Code";"Salesperson Code")
//                 {
//                 }
//                 field("Salutation Code";"Salutation Code")
//                 {
//                 }
//                 field("Last Date Modified";"Last Date Modified")
//                 {
//                 }
//                 field("Date of Last Interaction";"Date of Last Interaction")
//                 {

//                     trigger OnDrillDown()
//                     var
//                         InteractionLogEntry: Record "5065";
//                     begin
//                         InteractionLogEntry.SETCURRENTKEY("Contact Company No.",Date,"Contact No.",Canceled,"Initiated By","Attempt Failed");
//                         InteractionLogEntry.SETRANGE("Contact Company No.","Company No.");
//                         InteractionLogEntry.SETFILTER("Contact No.","Lookup Contact No.");
//                         InteractionLogEntry.SETRANGE("Attempt Failed",FALSE);
//                         IF InteractionLogEntry.FINDLAST THEN
//                           PAGE.RUN(0,InteractionLogEntry);
//                     end;
//                 }
//                 field("Last Date Attempted";"Last Date Attempted")
//                 {

//                     trigger OnDrillDown()
//                     var
//                         InteractionLogEntry: Record "5065";
//                     begin
//                         InteractionLogEntry.SETCURRENTKEY("Contact Company No.",Date,"Contact No.",Canceled,"Initiated By","Attempt Failed");
//                         InteractionLogEntry.SETRANGE("Contact Company No.","Company No.");
//                         InteractionLogEntry.SETFILTER("Contact No.","Lookup Contact No.");
//                         InteractionLogEntry.SETRANGE("Initiated By",InteractionLogEntry."Initiated By"::Us);
//                         IF InteractionLogEntry.FINDLAST THEN
//                           PAGE.RUN(0,InteractionLogEntry);
//                     end;
//                 }
//                 field("Next To-do Date";"Next To-do Date")
//                 {
//                 }
//             }
//             part(;5051)
//             {
//                 SubPageLink = Contact No.=FIELD(No.);
//             }
//             group(Communication)
//             {
//                 Caption = 'Communication';
//                 field("Phone No.2";"Phone No.")
//                 {
//                 }
//                 field("Mobile Phone No.";"Mobile Phone No.")
//                 {
//                 }
//                 field("Fax No.";"Fax No.")
//                 {
//                 }
//                 field("Telex No.";"Telex No.")
//                 {
//                 }
//                 field(Pager;Pager)
//                 {
//                 }
//                 field("Telex Answer Back";"Telex Answer Back")
//                 {
//                 }
//                 field("E-Mail";"E-Mail")
//                 {
//                 }
//                 field("Home Page";"Home Page")
//                 {
//                 }
//                 field("Language Code";"Language Code")
//                 {
//                 }
//                 field("Salutation Code2";"Salutation Code")
//                 {
//                 }
//                 field("Correspondence Type";"Correspondence Type")
//                 {
//                 }
//                 field("First Name";"First Name")
//                 {
//                     Visible = false;
//                 }
//                 field("Middle Name";"Middle Name")
//                 {
//                     Visible = false;
//                 }
//                 field(Surname;Surname)
//                 {
//                     Visible = false;
//                 }
//             }
//             group(Segmentation)
//             {
//                 Caption = 'Segmentation';
//                 field("No. of Mailing Groups";"No. of Mailing Groups")
//                 {

//                     trigger OnDrillDown()
//                     var
//                         ContMailingGrp: Record "5056";
//                     begin
//                         CurrPage.SAVERECORD;
//                         COMMIT;
//                         ContMailingGrp.SETRANGE("Contact No.","No.");
//                         PAGE.RUNMODAL(PAGE::"Contact Mailing Groups",ContMailingGrp);
//                         CurrPage.UPDATE(FALSE);
//                     end;
//                 }
//                 field("No. of Business Relations";"No. of Business Relations")
//                 {

//                     trigger OnDrillDown()
//                     var
//                         ContBusRel: Record "5054";
//                     begin
//                         CurrPage.SAVERECORD;
//                         COMMIT;
//                         ContBusRel.SETRANGE("Contact No.","Company No.");
//                         PAGE.RUNMODAL(PAGE::"Contact Business Relations",ContBusRel);
//                         CurrPage.UPDATE(FALSE);
//                     end;
//                 }
//                 field("No. of Industry Groups";"No. of Industry Groups")
//                 {

//                     trigger OnDrillDown()
//                     var
//                         ContIndustGrp: Record "5058";
//                     begin
//                         CurrPage.SAVERECORD;
//                         COMMIT;
//                         ContIndustGrp.SETRANGE("Contact No.","Company No.");
//                         PAGE.RUNMODAL(PAGE::"Contact Industry Groups",ContIndustGrp);
//                         CurrPage.UPDATE(FALSE);
//                     end;
//                 }
//                 field("No. of Job Responsibilities";"No. of Job Responsibilities")
//                 {
//                     Enabled = NoofJobResponsibilitiesEnable;

//                     trigger OnDrillDown()
//                     var
//                         ContJobResp: Record "5067";
//                     begin
//                         CurrPage.SAVERECORD;
//                         COMMIT;
//                         ContJobResp.SETRANGE("Contact No.","No.");
//                         PAGE.RUNMODAL(PAGE::"Contact Job Responsibilities",ContJobResp);
//                         CurrPage.UPDATE(FALSE);
//                     end;
//                 }
//                 field("Organizational Level Code";"Organizational Level Code")
//                 {
//                     Enabled = OrganizationalLevelCodeEnable;
//                 }
//                 field("Exclude from Segment";"Exclude from Segment")
//                 {
//                 }
//             }
//             group("Foreign Trade")
//             {
//                 Caption = 'Foreign Trade';
//                 field("Currency Code";"Currency Code")
//                 {
//                     Enabled = "Currency CodeEnable";
//                 }
//                 field("Territory Code";"Territory Code")
//                 {
//                 }
//                 field("VAT Registration No.";"VAT Registration No.")
//                 {
//                     Enabled = "VAT Registration No.Enable";
//                 }
//             }
//             group(Registration)
//             {
//                 Caption = 'Registration';
//                 field(Birthday;Birthday)
//                 {
//                     Editable = false;
//                 }
//                 field(Gender;Gender)
//                 {
//                     Editable = false;
//                 }
//                 field(Occupation;Occupation)
//                 {
//                     Editable = false;
//                 }
//                 field("Home Phone No.";"Home Phone No.")
//                 {
//                     Editable = false;
//                 }
//                 field(Age;Age)
//                 {
//                     Editable = false;
//                 }
//                 field("Marital Status";"Marital Status")
//                 {
//                     Editable = false;
//                 }
//                 field("External ID";"External ID")
//                 {
//                     Editable = false;
//                 }
//             }
//         }
//         area(factboxes)
//         {
//             systempart(;Links)
//             {
//                 Visible = true;
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
//             group("C&ontact")
//             {
//                 Caption = 'C&ontact';
//                 Image = ContactPerson;
//                 group("Comp&any")
//                 {
//                     Caption = 'Comp&any';
//                     Enabled = CompanyGroupEnabled;
//                     Image = Company;
//                     action("Business Relations")
//                     {
//                         Caption = 'Business Relations';
//                         Image = BusinessRelation;

//                         trigger OnAction()
//                         var
//                             ContactBusinessRelationRec: Record "5054";
//                         begin
//                             TESTFIELD(Type,Type::Company);
//                             ContactBusinessRelationRec.SETRANGE("Contact No.","Company No.");
//                             PAGE.RUN(PAGE::"Contact Business Relations",ContactBusinessRelationRec);
//                         end;
//                     }
//                     action("Industry Groups")
//                     {
//                         Caption = 'Industry Groups';
//                         Image = IndustryGroups;

//                         trigger OnAction()
//                         var
//                             ContactIndustryGroupRec: Record "5058";
//                         begin
//                             TESTFIELD(Type,Type::Company);
//                             ContactIndustryGroupRec.SETRANGE("Contact No.","Company No.");
//                             PAGE.RUN(PAGE::"Contact Industry Groups",ContactIndustryGroupRec);
//                         end;
//                     }
//                     action("Web Sources")
//                     {
//                         Caption = 'Web Sources';
//                         Image = Web;

//                         trigger OnAction()
//                         var
//                             ContactWebSourceRec: Record "5060";
//                         begin
//                             TESTFIELD(Type,Type::Company);
//                             ContactWebSourceRec.SETRANGE("Contact No.","Company No.");
//                             PAGE.RUN(PAGE::"Contact Web Sources",ContactWebSourceRec);
//                         end;
//                     }
//                 }
//                 group("P&erson")
//                 {
//                     Caption = 'P&erson';
//                     Enabled = PersonGroupEnabled;
//                     Image = User;
//                     action("Job Responsibilities")
//                     {
//                         Caption = 'Job Responsibilities';
//                         Image = Job;

//                         trigger OnAction()
//                         var
//                             ContJobResp: Record "5067";
//                         begin
//                             TESTFIELD(Type,Type::Person);
//                             ContJobResp.SETRANGE("Contact No.","No.");
//                             PAGE.RUNMODAL(PAGE::"Contact Job Responsibilities",ContJobResp);
//                         end;
//                     }
//                 }
//                 action("Pro&files")
//                 {
//                     Caption = 'Pro&files';
//                     Image = Answers;

//                     trigger OnAction()
//                     var
//                         ProfileManagement: Codeunit "5059";
//                     begin
//                         ProfileManagement.ShowContactQuestionnaireCard(Rec,'',0);
//                     end;
//                 }
//                 action("&Picture")
//                 {
//                     Caption = '&Picture';
//                     Image = Picture;
//                     RunObject = Page 5104;
//                     RunPageLink = No.=FIELD(No.);
//                 }
//                 action("Co&mments")
//                 {
//                     Caption = 'Co&mments';
//                     Image = ViewComments;
//                     RunObject = Page 5072;
//                     RunPageLink = Table Name=CONST(Contact),
//                                   No.=FIELD(No.),
//                                   Sub No.=CONST(0);
//                 }
//                 group("Alternati&ve Address")
//                 {
//                     Caption = 'Alternati&ve Address';
//                     Image = Addresses;
//                     action(Card)
//                     {
//                         Caption = 'Card';
//                         Image = EditLines;
//                         RunObject = Page 5057;
//                         RunPageLink = Contact No.=FIELD(No.);
//                     }
//                     action("Date Ranges")
//                     {
//                         Caption = 'Date Ranges';
//                         Image = DateRange;
//                         RunObject = Page 5059;
//                         RunPageLink = Contact No.=FIELD(No.);
//                     }
//                 }
//                 separator()
//                 {
//                     Caption = '';
//                 }
//             }
//             group("Related Information")
//             {
//                 Caption = 'Related Information';
//                 Image = Users;
//                 action("Relate&d Contacts")
//                 {
//                     Caption = 'Relate&d Contacts';
//                     Image = Users;
//                     RunObject = Page 5052;
//                     RunPageLink = Company No.=FIELD(Company No.);
//                 }
//                 action("Segmen&ts")
//                 {
//                     Caption = 'Segmen&ts';
//                     Image = Segment;
//                     RunObject = Page 5150;
//                     RunPageLink = Contact Company No.=FIELD(Company No.),
//                                   Contact No.=FILTER(<>''),
//                                   Contact No.=FIELD(FILTER(Lookup Contact No.));
//                     RunPageView = SORTING(Contact No.,Segment No.);
//                 }
//                 action("Mailing &Groups")
//                 {
//                     Caption = 'Mailing &Groups';
//                     Image = DistributionGroup;
//                     RunObject = Page 5064;
//                     RunPageLink = Contact No.=FIELD(No.);
//                 }
//                 action("C&ustomer/Vendor/Bank Acc.")
//                 {
//                     Caption = 'C&ustomer/Vendor/Bank Acc.';
//                     Image = ContactReference;

//                     trigger OnAction()
//                     begin
//                         ShowCustVendBank;
//                     end;
//                 }
//                 action("Online Map")
//                 {
//                     Caption = 'Online Map';
//                     Image = Map;

//                     trigger OnAction()
//                     begin
//                         DisplayMap;
//                     end;
//                 }
//                 separator()
//                 {
//                 }
//             }
//             group(Tasks)
//             {
//                 Caption = 'Tasks';
//                 Image = Task;
//                 action("T&o-dos")
//                 {
//                     Caption = 'T&o-dos';
//                     Image = TaskList;
//                     RunObject = Page 5096;
//                     RunPageLink = Contact Company No.=FIELD(FILTER(Company No.)),
//                                   Contact No.=FIELD(FILTER(No.)),
//                                   System To-do Type=FILTER(Contact Attendee);
//                     RunPageView = SORTING(Contact Company No.,Date,Contact No.,Closed);
//                 }
//                 action("Oppo&rtunities")
//                 {
//                     Caption = 'Oppo&rtunities';
//                     Image = OpportunityList;
//                     RunObject = Page 5123;
//                     RunPageLink = Contact Company No.=FIELD(Company No.),
//                                   Contact No.=FILTER(<>''),
//                                   Contact No.=FIELD(FILTER(Lookup Contact No.));
//                     RunPageView = SORTING(Contact Company No.,Contact No.);
//                 }
//                 separator()
//                 {
//                     Caption = '';
//                 }
//             }
//             group(Documents)
//             {
//                 Caption = 'Documents';
//                 Image = Documents;
//                 action("Sales &Quotes")
//                 {
//                     Caption = 'Sales &Quotes';
//                     Image = Quote;
//                     Promoted = true;
//                     PromotedCategory = Process;
//                     RunObject = Page 9300;
//                     RunPageLink = Sell-to Contact No.=FIELD(No.);
//                     RunPageView = SORTING(Document Type,Sell-to Contact No.);
//                 }
//                 separator()
//                 {
//                 }
//             }
//             group(History)
//             {
//                 Caption = 'History';
//                 Image = History;
//                 action("Postponed &Interactions")
//                 {
//                     Caption = 'Postponed &Interactions';
//                     Image = PostponedInteractions;
//                     RunObject = Page 5082;
//                     RunPageLink = Contact Company No.=FIELD(Company No.),
//                                   Contact No.=FILTER(<>''),
//                                   Contact No.=FIELD(FILTER(Lookup Contact No.));
//                     RunPageView = SORTING(Contact Company No.,Date,Contact No.,Canceled,Initiated By,Attempt Failed);
//                 }
//                 action("Interaction Log E&ntries")
//                 {
//                     Caption = 'Interaction Log E&ntries';
//                     Image = InteractionLog;
//                     RunObject = Page 5076;
//                     RunPageLink = Contact Company No.=FIELD(Company No.),
//                                   Contact No.=FILTER(<>''),
//                                   Contact No.=FIELD(FILTER(Lookup Contact No.));
//                     RunPageView = SORTING(Contact Company No.,Date,Contact No.,Canceled,Initiated By,Attempt Failed);
//                     ShortCutKey = 'Ctrl+F7';
//                 }
//                 action(Statistics)
//                 {
//                     Caption = 'Statistics';
//                     Image = Statistics;
//                     Promoted = true;
//                     PromotedCategory = Process;
//                     RunObject = Page 5053;
//                     RunPageLink = No.=FIELD(No.);
//                     ShortCutKey = 'F7';
//                 }
//             }
//         }
//         area(processing)
//         {
//             group("F&unctions")
//             {
//                 Caption = 'F&unctions';
//                 Image = "Action";
//                 action("Launch &Web Source")
//                 {
//                     Caption = 'Launch &Web Source';
//                     Image = LaunchWeb;

//                     trigger OnAction()
//                     var
//                         ContactWebSource: Record "5060";
//                     begin
//                         ContactWebSource.SETRANGE("Contact No.","Company No.");
//                         IF PAGE.RUNMODAL(PAGE::"Web Source Launch",ContactWebSource) = ACTION::LookupOK THEN
//                           ContactWebSource.Launch;
//                     end;
//                 }
//                 action("Print Cover &Sheet")
//                 {
//                     Caption = 'Print Cover &Sheet';
//                     Image = PrintCover;

//                     trigger OnAction()
//                     var
//                         Cont: Record "5050";
//                     begin
//                         Cont := Rec;
//                         Cont.SETRECFILTER;
//                         REPORT.RUN(REPORT::"Contact - Cover Sheet",TRUE,FALSE,Cont);
//                     end;
//                 }
//                 group("Create as")
//                 {
//                     Caption = 'Create as';
//                     Image = CustomerContact;
//                     action(Customer)
//                     {
//                         Caption = 'Customer';
//                         Image = Customer;

//                         trigger OnAction()
//                         begin
//                             CreateCustomer(ChooseCustomerTemplate);
//                         end;
//                     }
//                     action(Vendor)
//                     {
//                         Caption = 'Vendor';
//                         Image = Vendor;

//                         trigger OnAction()
//                         begin
//                             CreateVendor;
//                         end;
//                     }
//                     action(Bank)
//                     {
//                         Caption = 'Bank';
//                         Image = Bank;

//                         trigger OnAction()
//                         begin
//                             CreateBankAccount;
//                         end;
//                     }
//                 }
//                 group("Link with existing")
//                 {
//                     Caption = 'Link with existing';
//                     Image = Links;
//                     action(Customer)
//                     {
//                         Caption = 'Customer';
//                         Image = Customer;

//                         trigger OnAction()
//                         begin
//                             CreateCustomerLink;
//                         end;
//                     }
//                     action(Vendor)
//                     {
//                         Caption = 'Vendor';
//                         Image = Vendor;

//                         trigger OnAction()
//                         begin
//                             CreateVendorLink;
//                         end;
//                     }
//                     action(Bank)
//                     {
//                         Caption = 'Bank';
//                         Image = Bank;

//                         trigger OnAction()
//                         begin
//                             CreateBankAccountLink;
//                         end;
//                     }
//                 }
//                 separator()
//                 {
//                 }
//                 action("Apply Template")
//                 {
//                     Caption = 'Apply Template';
//                     Ellipsis = true;
//                     Image = ApplyTemplate;
//                     Promoted = true;
//                     PromotedCategory = Process;

//                     trigger OnAction()
//                     var
//                         ConfigTemplateMgt: Codeunit "8612";
//                         RecRef: RecordRef;
//                     begin
//                         RecRef.GETTABLE(Rec);
//                         ConfigTemplateMgt.UpdateFromTemplateSelection(RecRef);
//                     end;
//                 }
//             }
//             action("Create &Interact")
//             {
//                 Caption = 'Create &Interact';
//                 Image = CreateInteraction;
//                 Promoted = true;
//                 PromotedCategory = Process;

//                 trigger OnAction()
//                 begin
//                     CreateInteraction;
//                 end;
//             }
//         }
//         area(reporting)
//         {
//             action("Contact Cover Sheet")
//             {
//                 Caption = 'Contact Cover Sheet';
//                 Image = "Report";
//                 Promoted = true;
//                 PromotedCategory = "Report";

//                 trigger OnAction()
//                 begin
//                     Cont := Rec;
//                     Cont.SETRECFILTER;
//                     REPORT.RUN(REPORT::"Contact - Cover Sheet",TRUE,FALSE,Cont);
//                 end;
//             }
//         }
//     }

//     trigger OnAfterGetCurrRecord()
//     begin
//         xRec := Rec;
//         EnableFields;

//         IF Type = Type::Person THEN
//           IntegrationFindCustomerNo
//         ELSE
//           IntegrationCustomerNo := '';
//     end;

//     trigger OnInit()
//     begin
//         NoofJobResponsibilitiesEnable := TRUE;
//         OrganizationalLevelCodeEnable := TRUE;
//         "Company NameEnable" := TRUE;
//         "Company No.Enable" := TRUE;
//         "VAT Registration No.Enable" := TRUE;
//         "Currency CodeEnable" := TRUE;
//         MapPointVisible := TRUE;
//     end;

//     trigger OnOpenPage()
//     var
//         MapMgt: Codeunit "802";
//     begin
//         IF NOT MapMgt.TestSetup THEN
//           MapPointVisible := FALSE;
//     end;

//     var
//         Cont: Record "5050";
//         CompanyDetails: Page "5054";
//         NameDetails: Page "5055";
//         IntegrationCustomerNo: Code[20];
//         [InDataSet]
//         MapPointVisible: Boolean;
//         [InDataSet]
//         "Currency CodeEnable": Boolean;
//         [InDataSet]
//         "VAT Registration No.Enable": Boolean;
//         [InDataSet]
//         "Company No.Enable": Boolean;
//         [InDataSet]
//         "Company NameEnable": Boolean;
//         [InDataSet]
//         OrganizationalLevelCodeEnable: Boolean;
//         [InDataSet]
//         NoofJobResponsibilitiesEnable: Boolean;
//         CompanyGroupEnabled: Boolean;
//         PersonGroupEnabled: Boolean;

//     local procedure EnableFields()
//     begin
//         CompanyGroupEnabled := Type = Type::Company;
//         PersonGroupEnabled := Type = Type::Person;
//         "Currency CodeEnable" := Type = Type::Company;
//         "VAT Registration No.Enable" := Type = Type::Company;
//         "Company No.Enable" := Type = Type::Person;
//         "Company NameEnable" := Type = Type::Person;
//         OrganizationalLevelCodeEnable := Type = Type::Person;
//         NoofJobResponsibilitiesEnable := Type = Type::Person;
//     end;

//     procedure IntegrationFindCustomerNo()
//     var
//         ContactBusinessRelation: Record "5054";
//     begin
//         ContactBusinessRelation.SETCURRENTKEY("Link to Table","Contact No.");
//         ContactBusinessRelation.SETRANGE("Link to Table",ContactBusinessRelation."Link to Table"::Customer);
//         ContactBusinessRelation.SETRANGE("Contact No.","Company No.");
//         IF ContactBusinessRelation.FINDFIRST THEN BEGIN
//           IntegrationCustomerNo := ContactBusinessRelation."No.";
//         END ELSE
//           IntegrationCustomerNo := '';
//     end;

//     local procedure TypeOnAfterValidate()
//     begin
//         EnableFields;
//     end;
// }

