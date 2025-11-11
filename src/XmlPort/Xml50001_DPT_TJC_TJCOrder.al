xmlport 50001 TJCOrder
{
    UseDefaultNamespace = true;

    schema
    {
        textelement("<dpdata>")
        {
            XmlName = 'DPDATA';
            tableelement("Sales Header"; "Sales Header")
            {
                MaxOccurs = Once;
                XmlName = 'order_trans';
                fieldelement(doc_type; "Sales Header"."Document Type")
                {
                }
                fieldelement(trans_date; "Sales Header"."Document Date")
                {
                }
                fieldelement(customer_Id; "Sales Header"."Sell-to Customer No.")
                {
                }
                fieldelement(ship_to_addr; "Sales Header"."Ship-to Address")
                {
                }
                fieldelement(ship_to_addr2; "Sales Header"."Ship-to Address 2")
                {
                }
                fieldelement(salesperson; "Sales Header"."Salesperson Code")
                {
                }

                fieldelement(isMobileOrder; "Sales Header"."Authorization Required")
                {
                    // Note: Authorization Required discontinued in BC. Newly added into bc sales order for compatibility purposes.
                }
                tableelement("Sales Line"; "Sales Line")
                {
                    LinkFields = "Document No." = FIELD("No.");
                    LinkTable = "Sales Header";
                    XmlName = 'order_trans_detail';
                    fieldelement(lineno; "Sales Line"."Line No.")
                    {
                    }
                    fieldelement(ldoc_type; "Sales Line"."Document Type")
                    {
                    }
                    fieldelement(l_type; "Sales Line".Type)
                    {
                    }
                    fieldelement(item_uid; "Sales Line"."No.")
                    {
                    }
                    fieldelement(quantity; "Sales Line".Quantity)
                    {
                    }
                    fieldelement(uom_id; "Sales Line"."Unit of Measure")
                    {
                    }
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

