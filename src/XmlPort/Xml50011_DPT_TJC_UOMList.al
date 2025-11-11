xmlport 50011 "UOM List"
{
    UseDefaultNamespace = true;

    schema
    {
        textelement(UOMsList)
        {
            tableelement("Unit of Measure"; "Unit of Measure")
            {
                XmlName = 'UOM';
                fieldelement(Code; "Unit of Measure".Code)
                {
                }
                fieldelement(Desc; "Unit of Measure".Description)
                {
                }
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
}

