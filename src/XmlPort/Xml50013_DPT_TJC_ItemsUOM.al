xmlport 50013 "Items UOM"
{
    UseDefaultNamespace = true;

    schema
    {
        textelement(ItemUOMs)
        {
            tableelement("Item Unit of Measure"; "Item Unit of Measure")
            {
                XmlName = 'ItemUOM';
                SourceTableView = WHERE("Item No." = FILTER(<> ''));
                fieldelement(ItemNo; "Item Unit of Measure"."Item No.")
                {
                }
                fieldelement(UOM; "Item Unit of Measure".Code)
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

