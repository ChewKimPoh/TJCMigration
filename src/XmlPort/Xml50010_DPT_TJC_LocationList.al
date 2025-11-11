xmlport 50010 "Location List"
{
    UseDefaultNamespace = true;

    schema
    {
        textelement(LocationlList)
        {
            tableelement(Location; Location)
            {
                AutoReplace = true;
                AutoSave = false;
                XmlName = 'Location';
                fieldelement(Code; Location.Code)
                {
                }
                fieldelement(Name; Location.Name)
                {
                }

                trigger OnAfterGetRecord()
                var
                    recItem: Record Item;
                begin
                end;
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    trigger OnPostXmlPort()
    var
        recTransferHeader: Record "Transfer Header";
        cPOPost: Codeunit "Purch.-Post";
    begin
    end;

    var
        TODoc: Code[20];
}

