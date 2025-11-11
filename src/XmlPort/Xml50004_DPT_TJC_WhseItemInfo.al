xmlport 50004 "Whse Item Info"
{
    UseDefaultNamespace = true;

    schema
    {
        textelement(ItemsInfo)
        {
            tableelement(Item; Item)
            {
                XmlName = 'ItemInfo';
                SourceTableView = SORTING("No.") WHERE(Blocked = FILTER(false), "Inventory Posting Group" = FILTER('FG'));
                fieldelement(ItemNo; Item."No.")
                {
                }
                fieldelement(Description; Item.Description)
                {
                }
                fieldelement(Description2; Item."Description 2")
                {
                }
                fieldelement(UOM; Item."Base Unit of Measure")
                {
                }
                fieldelement(Inv; Item.Inventory)
                {
                }
                fieldelement(QtyOnPO; Item."Qty. on Purch. Order")
                {
                }
                fieldelement(QtyOnSO; Item."Qty. on Sales Order")
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

