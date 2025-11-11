xmlport 50005 "Whse Item By Locations"
{
    UseDefaultNamespace = true;

    schema
    {
        textelement(ItemByLocations)
        {
            tableelement(Location; Location)
            {
                XmlName = 'ItemByLocation';
                textelement(ItemCode)
                {

                    trigger OnBeforePassVariable()
                    begin
                        ItemCode := gItemCode;
                    end;
                }
                fieldelement(LocationCode; Location.Code)
                {
                }
                fieldelement(LocationName; Location.Name)
                {
                }
                textelement(BalQty)
                {
                }
                textelement(SOQty)
                {
                }
                textelement(NetBalQty)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    //MESSAGE(Location.Code);
                    recItem.RESET;
                    //recItem.SETRANGE("No.",'011');
                    recItem.SETRANGE("No.", gItemCode);
                    recItem.SETFILTER("Location Filter", Location.Code);
                    IF recItem.FINDFIRST() THEN BEGIN
                        recItem.CALCFIELDS(Inventory, "Qty. on Sales Order");
                        // BalQty:= FORMAT(recItem.Inventory - recItem."Qty. on Sales Order");
                        BalQty := FORMAT(recItem.Inventory);
                        SOQty := FORMAT(recItem."Qty. on Sales Order");
                        NetBalQty := FORMAT((recItem.Inventory - recItem."Qty. on Sales Order"));
                    END;
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

    var
        SalesLine: Record "Sales Line";
        gItemCode: Code[20];
        recItem: Record Item;

    local procedure XMLDecFormat(in_Dec: Decimal): Text
    begin
        EXIT(FORMAT(in_Dec, 0, '<Precision,2:><Standard Format,0>'));
    end;

    procedure SetData(in_ItemCode: Code[20])
    begin
        gItemCode := in_ItemCode;
    end;
}

