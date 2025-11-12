page 50089 "TJC Web Users"
{
    PageType = List;
    SourceTable = "TJC Web Users";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Full Name"; Rec."Full Name")
                {
                }
                field(UserID; Rec.UserID)
                {
                }
                field(Password; Rec.Password)
                {
                }
                field(Email; Rec.Email)
                {
                }
                field(SalesPerson; Rec.SalesPerson)
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Data Patching")
            {

                trigger OnAction()
                var
                    Lcdu_TJCFunctions: Codeunit "TJC Functions";
                begin
                    Lcdu_TJCFunctions.DataPatching;
                end;
            }
        }
    }
}

