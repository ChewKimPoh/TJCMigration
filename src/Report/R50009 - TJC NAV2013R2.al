// report 50009 "Safety Stock Check"
// {
//     DefaultLayout = RDLC;
//     RDLCLayout = './Safety Stock Check.rdlc';

//     dataset
//     {
//         dataitem(DataItem8129;Table27)
//         {
//             DataItemTableView = SORTING(No.)
//                                 WHERE(Safety Stock Quantity=FILTER(>0));
//             RequestFilterFields = "No.","Item Category Code","Product Group Code","Shelf No.","Location Filter";
//             column(FORMAT_TODAY_0_4_;FORMAT(TODAY,0,4))
//             {
//             }
//             column(COMPANYNAME;COMPANYNAME)
//             {
//             }
//             column(CurrReport_PAGENO;CurrReport.PAGENO)
//             {
//             }
//             column(USERID;USERID)
//             {
//             }
//             column(Item__No__;"No.")
//             {
//             }
//             column(Item_Description_____Item__Description_2_;Item.Description+' '+Item."Description 2")
//             {
//             }
//             column(Item__Base_Unit_of_Measure_;"Base Unit of Measure")
//             {
//             }
//             column(Item_Inventory;Inventory)
//             {
//             }
//             column(Item__Qty__on_Purch__Order_;"Qty. on Purch. Order")
//             {
//             }
//             column(Item__Qty__on_Sales_Order_;"Qty. on Sales Order")
//             {
//             }
//             column(Item__Qty__on_Prod__Order_;"Qty. on Prod. Order")
//             {
//             }
//             column(Item__Qty__on_Component_Lines_;"Qty. on Component Lines")
//             {
//             }
//             column(Item__Safety_Stock_Quantity_;"Safety Stock Quantity")
//             {
//             }
//             column(ItemCaption;ItemCaptionLbl)
//             {
//             }
//             column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
//             {
//             }
//             column(Item__No__Caption;FIELDCAPTION("No."))
//             {
//             }
//             column(UOMCaption;UOMCaptionLbl)
//             {
//             }
//             column(Item_InventoryCaption;FIELDCAPTION(Inventory))
//             {
//             }
//             column(Item__Qty__on_Purch__Order_Caption;FIELDCAPTION("Qty. on Purch. Order"))
//             {
//             }
//             column(Item__Qty__on_Sales_Order_Caption;FIELDCAPTION("Qty. on Sales Order"))
//             {
//             }
//             column(Item__Qty__on_Prod__Order_Caption;FIELDCAPTION("Qty. on Prod. Order"))
//             {
//             }
//             column(Item__Qty__on_Component_Lines_Caption;FIELDCAPTION("Qty. on Component Lines"))
//             {
//             }
//             column(Item__Safety_Stock_Quantity_Caption;FIELDCAPTION("Safety Stock Quantity"))
//             {
//             }
//             column(DescriptionCaption;DescriptionCaptionLbl)
//             {
//             }

//             trigger OnAfterGetRecord()
//             begin
//                 Item.CALCFIELDS(Inventory,"Qty. on Purch. Order","Qty. on Sales Order","Qty. on Prod. Order","Qty. on Component Lines");
//                 netqty := Inventory+"Qty. on Purch. Order"
//                           -"Qty. on Sales Order"
//                           +"Qty. on Prod. Order"
//                           -"Qty. on Component Lines";

//                 IF netqty > Item."Safety Stock Quantity" THEN
//                   CurrReport.SKIP;
//             end;
//         }
//     }

//     requestpage
//     {

//         layout
//         {
//         }

//         actions
//         {
//         }
//     }

//     labels
//     {
//     }

//     var
//         netqty: Decimal;
//         ItemCaptionLbl: Label 'Item';
//         CurrReport_PAGENOCaptionLbl: Label 'Page';
//         UOMCaptionLbl: Label 'UOM';
//         DescriptionCaptionLbl: Label 'Description';
// }

