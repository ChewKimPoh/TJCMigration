// page 31 "Item List"
// {
//     // 20090611 DP.RWP Add Barcode and EnglishDescription
//     // 
//     // TJCSG1.00
//     //  1. 04/08/2014  dp.dst
//     //     - Changed the variable referencing Item Translation's Description to text with length of 50.
//     //     - The initial variable's length causes issue.
//     // DP.NCM TJC #511 11/04/2019 add field 50005 English Translation

//     Caption = 'Item List';
//     CardPageID = "Item Card";
//     Editable = false;
//     PageType = List;
//     SourceTable = Table27;

//     layout
//     {
//         area(content)
//         {
//             repeater()
//             {
//                 field("No.";"No.")
//                 {
//                 }
//                 field(Description;Description)
//                 {
//                 }
//                 field("Description 2";"Description 2")
//                 {
//                 }
//                 field("Global Dimension 1 Code";"Global Dimension 1 Code")
//                 {
//                 }
//                 field("English Description";"English Description")
//                 {
//                 }
//                 field(BarCode;BarCode)
//                 {
//                     Caption = 'Barcode';
//                 }
//                 field(Inventory;Inventory)
//                 {
//                 }
//                 field("Gen. Prod. Posting Group";"Gen. Prod. Posting Group")
//                 {
//                 }
//                 field("Inventory Value Zero";"Inventory Value Zero")
//                 {
//                 }
//                 field("Safety Stock Quantity";"Safety Stock Quantity")
//                 {
//                 }
//                 field("Item Category Code";"Item Category Code")
//                 {
//                 }
//                 field("Product Group Code";"Product Group Code")
//                 {
//                 }
//                 field("Created From Nonstock Item";"Created From Nonstock Item")
//                 {
//                     Visible = false;
//                 }
//                 field("Substitutes Exist";"Substitutes Exist")
//                 {
//                 }
//                 field("Stockkeeping Unit Exists";"Stockkeeping Unit Exists")
//                 {
//                     Visible = false;
//                 }
//                 field("Assembly BOM";"Assembly BOM")
//                 {
//                 }
//                 field("Production BOM No.";"Production BOM No.")
//                 {
//                 }
//                 field("Routing No.";"Routing No.")
//                 {
//                 }
//                 field("Base Unit of Measure";"Base Unit of Measure")
//                 {
//                 }
//                 field("Shelf No.";"Shelf No.")
//                 {
//                     Visible = false;
//                 }
//                 field("Costing Method";"Costing Method")
//                 {
//                     Visible = false;
//                 }
//                 field("Cost is Adjusted";"Cost is Adjusted")
//                 {
//                 }
//                 field("Standard Cost";"Standard Cost")
//                 {
//                     Visible = false;
//                 }
//                 field("Unit Cost";"Unit Cost")
//                 {
//                 }
//                 field("Last Direct Cost";"Last Direct Cost")
//                 {
//                     Visible = false;
//                 }
//                 field("Price/Profit Calculation";"Price/Profit Calculation")
//                 {
//                     Visible = false;
//                 }
//                 field("Profit %";"Profit %")
//                 {
//                     Visible = false;
//                 }
//                 field("Unit Price";"Unit Price")
//                 {
//                 }
//                 field("Inventory Posting Group";"Inventory Posting Group")
//                 {
//                     Visible = false;
//                 }
//                 field("VAT Prod. Posting Group";"VAT Prod. Posting Group")
//                 {
//                     Visible = false;
//                 }
//                 field("Item Disc. Group";"Item Disc. Group")
//                 {
//                     Visible = false;
//                 }
//                 field("Vendor No.";"Vendor No.")
//                 {
//                 }
//                 field("Vendor Item No.";"Vendor Item No.")
//                 {
//                     Visible = false;
//                 }
//                 field("Tariff No.";"Tariff No.")
//                 {
//                     Visible = false;
//                 }
//                 field("Search Description";"Search Description")
//                 {
//                 }
//                 field("Overhead Rate";"Overhead Rate")
//                 {
//                     Visible = false;
//                 }
//                 field("Indirect Cost %";"Indirect Cost %")
//                 {
//                     Visible = false;
//                 }
//                 field(Blocked;Blocked)
//                 {
//                     Visible = false;
//                 }
//                 field("Last Date Modified";"Last Date Modified")
//                 {
//                     Visible = false;
//                 }
//                 field("Sales Unit of Measure";"Sales Unit of Measure")
//                 {
//                     Visible = false;
//                 }
//                 field("Replenishment System";"Replenishment System")
//                 {
//                     Visible = false;
//                 }
//                 field("Purch. Unit of Measure";"Purch. Unit of Measure")
//                 {
//                     Visible = false;
//                 }
//                 field("Lead Time Calculation";"Lead Time Calculation")
//                 {
//                     Visible = false;
//                 }
//                 field("Manufacturing Policy";"Manufacturing Policy")
//                 {
//                     Visible = false;
//                 }
//                 field("Flushing Method";"Flushing Method")
//                 {
//                     Visible = false;
//                 }
//                 field("Assembly Policy";"Assembly Policy")
//                 {
//                     Visible = false;
//                 }
//                 field("Item Tracking Code";"Item Tracking Code")
//                 {
//                     Visible = false;
//                 }
//                 field(Retail;Retail)
//                 {
//                 }
//                 field(Clinic;Clinic)
//                 {
//                 }
//             }
//         }
//         area(factboxes)
//         {
//             part(;9089)
//             {
//                 SubPageLink = No.=FIELD(No.),
//                               Date Filter=FIELD(Date Filter),
//                               Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
//                               Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter),
//                               Location Filter=FIELD(Location Filter),
//                               Drop Shipment Filter=FIELD(Drop Shipment Filter),
//                               Bin Filter=FIELD(Bin Filter),
//                               Variant Filter=FIELD(Variant Filter),
//                               Lot No. Filter=FIELD(Lot No. Filter),
//                               Serial No. Filter=FIELD(Serial No. Filter);
//                 Visible = true;
//             }
//             part(;9090)
//             {
//                 SubPageLink = No.=FIELD(No.),
//                               Date Filter=FIELD(Date Filter),
//                               Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
//                               Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter),
//                               Location Filter=FIELD(Location Filter),
//                               Drop Shipment Filter=FIELD(Drop Shipment Filter),
//                               Bin Filter=FIELD(Bin Filter),
//                               Variant Filter=FIELD(Variant Filter),
//                               Lot No. Filter=FIELD(Lot No. Filter),
//                               Serial No. Filter=FIELD(Serial No. Filter);
//                 Visible = false;
//             }
//             part(;9091)
//             {
//                 SubPageLink = No.=FIELD(No.),
//                               Date Filter=FIELD(Date Filter),
//                               Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
//                               Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter),
//                               Location Filter=FIELD(Location Filter),
//                               Drop Shipment Filter=FIELD(Drop Shipment Filter),
//                               Bin Filter=FIELD(Bin Filter),
//                               Variant Filter=FIELD(Variant Filter),
//                               Lot No. Filter=FIELD(Lot No. Filter),
//                               Serial No. Filter=FIELD(Serial No. Filter);
//                 Visible = true;
//             }
//             part(;9109)
//             {
//                 SubPageLink = No.=FIELD(No.),
//                               Date Filter=FIELD(Date Filter),
//                               Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
//                               Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter),
//                               Location Filter=FIELD(Location Filter),
//                               Drop Shipment Filter=FIELD(Drop Shipment Filter),
//                               Bin Filter=FIELD(Bin Filter),
//                               Variant Filter=FIELD(Variant Filter),
//                               Lot No. Filter=FIELD(Lot No. Filter),
//                               Serial No. Filter=FIELD(Serial No. Filter);
//                 Visible = false;
//             }
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
//             group(Availability)
//             {
//                 Caption = 'Availability';
//                 Image = Item;
//                 action("Items b&y Location")
//                 {
//                     Caption = 'Items b&y Location';
//                     Image = ItemAvailbyLoc;

//                     trigger OnAction()
//                     var
//                         ItemsByLocation: Page "491";
//                     begin
//                         ItemsByLocation.SETRECORD(Rec);
//                         ItemsByLocation.RUN;
//                     end;
//                 }
//                 group("&Item Availability by")
//                 {
//                     Caption = '&Item Availability by';
//                     Image = ItemAvailability;
//                     action("<Action5>")
//                     {
//                         Caption = 'Event';
//                         Image = "Event";

//                         trigger OnAction()
//                         begin
//                             ItemAvailFormsMgt.ShowItemAvailFromItem(Rec,ItemAvailFormsMgt.ByEvent);
//                         end;
//                     }
//                     action(Period)
//                     {
//                         Caption = 'Period';
//                         Image = Period;
//                         RunObject = Page 157;
//                         RunPageLink = No.=FIELD(No.),
//                                       Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
//                                       Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter),
//                                       Location Filter=FIELD(Location Filter),
//                                       Drop Shipment Filter=FIELD(Drop Shipment Filter),
//                                       Variant Filter=FIELD(Variant Filter);
//                     }
//                     action(Variant)
//                     {
//                         Caption = 'Variant';
//                         Image = ItemVariant;
//                         RunObject = Page 5414;
//                         RunPageLink = No.=FIELD(No.),
//                                       Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
//                                       Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter),
//                                       Location Filter=FIELD(Location Filter),
//                                       Drop Shipment Filter=FIELD(Drop Shipment Filter),
//                                       Variant Filter=FIELD(Variant Filter);
//                     }
//                     action(Location)
//                     {
//                         Caption = 'Location';
//                         Image = Warehouse;
//                         RunObject = Page 492;
//                         RunPageLink = No.=FIELD(No.),
//                                       Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
//                                       Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter),
//                                       Location Filter=FIELD(Location Filter),
//                                       Drop Shipment Filter=FIELD(Drop Shipment Filter),
//                                       Variant Filter=FIELD(Variant Filter);
//                     }
//                     action("BOM Level")
//                     {
//                         Caption = 'BOM Level';
//                         Image = BOMLevel;

//                         trigger OnAction()
//                         begin
//                             ItemAvailFormsMgt.ShowItemAvailFromItem(Rec,ItemAvailFormsMgt.ByBOM);
//                         end;
//                     }
//                     action(Timeline)
//                     {
//                         Caption = 'Timeline';
//                         Image = Timeline;

//                         trigger OnAction()
//                         begin
//                             ShowTimelineFromItem(Rec);
//                         end;
//                     }
//                 }
//             }
//             group("Master Data")
//             {
//                 Caption = 'Master Data';
//                 Image = DataEntry;
//                 action("&Units of Measure")
//                 {
//                     Caption = '&Units of Measure';
//                     Image = UnitOfMeasure;
//                     RunObject = Page 5404;
//                     RunPageLink = Item No.=FIELD(No.);
//                 }
//                 action("Va&riants")
//                 {
//                     Caption = 'Va&riants';
//                     Image = ItemVariant;
//                     RunObject = Page 5401;
//                     RunPageLink = Item No.=FIELD(No.);
//                 }
//                 group(Dimensions)
//                 {
//                     Caption = 'Dimensions';
//                     Image = Dimensions;
//                     action("Dimensions-Single")
//                     {
//                         Caption = 'Dimensions-Single';
//                         Image = Dimensions;
//                         RunObject = Page 540;
//                         RunPageLink = Table ID=CONST(27),
//                                       No.=FIELD(No.);
//                         ShortCutKey = 'Shift+Ctrl+D';
//                     }
//                     action("Dimensions-&Multiple")
//                     {
//                         Caption = 'Dimensions-&Multiple';
//                         Image = DimensionSets;

//                         trigger OnAction()
//                         var
//                             Item: Record "27";
//                             DefaultDimMultiple: Page "542";
//                         begin
//                             CurrPage.SETSELECTIONFILTER(Item);
//                             DefaultDimMultiple.SetMultiItem(Item);
//                             DefaultDimMultiple.RUNMODAL;
//                         end;
//                     }
//                 }
//                 action("Import Safety Stock Qty")
//                 {
//                     Image = SuggestNumber;
//                     Promoted = true;
//                     PromotedIsBig = true;

//                     trigger OnAction()
//                     begin
//                         ImportSafetyStockQty;
//                     end;
//                 }
//                 action("Substituti&ons")
//                 {
//                     Caption = 'Substituti&ons';
//                     Image = ItemSubstitution;
//                     RunObject = Page 5716;
//                     RunPageLink = Type=CONST(Item),
//                                   No.=FIELD(No.);
//                 }
//                 action("Cross Re&ferences")
//                 {
//                     Caption = 'Cross Re&ferences';
//                     Image = Change;
//                     RunObject = Page 5721;
//                     RunPageLink = Item No.=FIELD(No.);
//                 }
//                 action("E&xtended Texts")
//                 {
//                     Caption = 'E&xtended Texts';
//                     Image = Text;
//                     RunObject = Page 391;
//                     RunPageLink = Table Name=CONST(Item),
//                                   No.=FIELD(No.);
//                     RunPageView = SORTING(Table Name,No.,Language Code,All Language Codes,Starting Date,Ending Date);
//                 }
//                 action(Translations)
//                 {
//                     Caption = 'Translations';
//                     Image = Translations;
//                     RunObject = Page 35;
//                     RunPageLink = Item No.=FIELD(No.),
//                                   Variant Code=CONST();
//                 }
//                 action("&Picture")
//                 {
//                     Caption = '&Picture';
//                     Image = Picture;
//                     RunObject = Page 346;
//                     RunPageLink = No.=FIELD(No.),
//                                   Date Filter=FIELD(Date Filter),
//                                   Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
//                                   Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter),
//                                   Location Filter=FIELD(Location Filter),
//                                   Drop Shipment Filter=FIELD(Drop Shipment Filter),
//                                   Variant Filter=FIELD(Variant Filter);
//                 }
//                 action(Identifiers)
//                 {
//                     Caption = 'Identifiers';
//                     Image = BarCode;
//                     RunObject = Page 7706;
//                     RunPageLink = Item No.=FIELD(No.);
//                     RunPageView = SORTING(Item No.,Variant Code,Unit of Measure Code);
//                 }
//             }
//             group("Assembly/Production")
//             {
//                 Caption = 'Assembly/Production';
//                 Image = Production;
//                 action(Structure)
//                 {
//                     Caption = 'Structure';
//                     Image = Hierarchy;

//                     trigger OnAction()
//                     var
//                         BOMStructure: Page "5870";
//                     begin
//                         BOMStructure.InitItem(Rec);
//                         BOMStructure.RUN;
//                     end;
//                 }
//                 action("Cost Shares")
//                 {
//                     Caption = 'Cost Shares';
//                     Image = CostBudget;

//                     trigger OnAction()
//                     var
//                         BOMCostShares: Page "5872";
//                     begin
//                         BOMCostShares.InitItem(Rec);
//                         BOMCostShares.RUN;
//                     end;
//                 }
//                 group("Assemb&ly")
//                 {
//                     Caption = 'Assemb&ly';
//                     Image = AssemblyBOM;
//                     action("<Action32>")
//                     {
//                         Caption = 'Assembly BOM';
//                         Image = BOM;
//                         RunObject = Page 36;
//                         RunPageLink = Parent Item No.=FIELD(No.);
//                     }
//                     action("Where-Used")
//                     {
//                         Caption = 'Where-Used';
//                         Image = Track;
//                         RunObject = Page 37;
//                         RunPageLink = Type=CONST(Item),
//                                       No.=FIELD(No.);
//                         RunPageView = SORTING(Type,No.);
//                     }
//                     action("Calc. Stan&dard Cost")
//                     {
//                         Caption = 'Calc. Stan&dard Cost';
//                         Image = CalculateCost;

//                         trigger OnAction()
//                         begin
//                             CalculateStdCost.CalcItem("No.",TRUE);
//                         end;
//                     }
//                     action("Calc. Unit Price")
//                     {
//                         Caption = 'Calc. Unit Price';
//                         Image = SuggestItemPrice;

//                         trigger OnAction()
//                         begin
//                             CalculateStdCost.CalcAssemblyItemPrice("No.");
//                         end;
//                     }
//                 }
//                 group(Production)
//                 {
//                     Caption = 'Production';
//                     Image = Production;
//                     action("Production BOM")
//                     {
//                         Caption = 'Production BOM';
//                         Image = BOM;
//                         RunObject = Page 99000786;
//                         RunPageLink = No.=FIELD(No.);
//                     }
//                     action("Where-Used")
//                     {
//                         Caption = 'Where-Used';
//                         Image = "Where-Used";

//                         trigger OnAction()
//                         var
//                             ProdBOMWhereUsed: Page "99000811";
//                         begin
//                             ProdBOMWhereUsed.SetItem(Rec,WORKDATE);
//                             ProdBOMWhereUsed.RUNMODAL;
//                         end;
//                     }
//                     action("Calc. Stan&dard Cost")
//                     {
//                         Caption = 'Calc. Stan&dard Cost';
//                         Image = CalculateCost;

//                         trigger OnAction()
//                         begin
//                             CalculateStdCost.CalcItem("No.",FALSE);
//                         end;
//                     }
//                 }
//             }
//             group(History)
//             {
//                 Caption = 'History';
//                 Image = History;
//                 group("E&ntries")
//                 {
//                     Caption = 'E&ntries';
//                     Image = Entries;
//                     action("Ledger E&ntries")
//                     {
//                         Caption = 'Ledger E&ntries';
//                         Image = ItemLedger;
//                         Promoted = false;
//                         //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
//                         //PromotedCategory = Process;
//                         RunObject = Page 38;
//                         RunPageLink = Item No.=FIELD(No.);
//                         RunPageView = SORTING(Item No.);
//                         ShortCutKey = 'Ctrl+F7';
//                     }
//                     action("&Reservation Entries")
//                     {
//                         Caption = '&Reservation Entries';
//                         Image = ReservationLedger;
//                         RunObject = Page 497;
//                         RunPageLink = Reservation Status=CONST(Reservation),
//                                       Item No.=FIELD(No.);
//                         RunPageView = SORTING(Item No.,Variant Code,Location Code,Reservation Status);
//                     }
//                     action("&Phys. Inventory Ledger Entries")
//                     {
//                         Caption = '&Phys. Inventory Ledger Entries';
//                         Image = PhysicalInventoryLedger;
//                         RunObject = Page 390;
//                         RunPageLink = Item No.=FIELD(No.);
//                         RunPageView = SORTING(Item No.);
//                     }
//                     action("&Value Entries")
//                     {
//                         Caption = '&Value Entries';
//                         Image = ValueLedger;
//                         RunObject = Page 5802;
//                         RunPageLink = Item No.=FIELD(No.);
//                         RunPageView = SORTING(Item No.);
//                     }
//                     action("Item &Tracking Entries")
//                     {
//                         Caption = 'Item &Tracking Entries';
//                         Image = ItemTrackingLedger;

//                         trigger OnAction()
//                         var
//                             ItemTrackingMgt: Codeunit "6500";
//                         begin
//                             ItemTrackingMgt.CallItemTrackingEntryForm(3,'',"No.",'','','','');
//                         end;
//                     }
//                     action("&Warehouse Entries")
//                     {
//                         Caption = '&Warehouse Entries';
//                         Image = BinLedger;
//                         RunObject = Page 7318;
//                         RunPageLink = Item No.=FIELD(No.);
//                         RunPageView = SORTING(Item No.,Bin Code,Location Code,Variant Code,Unit of Measure Code,Lot No.,Serial No.,Entry Type,Dedicated);
//                     }
//                 }
//                 group(Statistics)
//                 {
//                     Caption = 'Statistics';
//                     Image = Statistics;
//                     action(Statistics)
//                     {
//                         Caption = 'Statistics';
//                         Image = Statistics;
//                         Promoted = true;
//                         PromotedCategory = Process;
//                         ShortCutKey = 'F7';

//                         trigger OnAction()
//                         var
//                             ItemStatistics: Page "5827";
//                         begin
//                             ItemStatistics.SetItem(Rec);
//                             ItemStatistics.RUNMODAL;
//                         end;
//                     }
//                     action("Entry Statistics")
//                     {
//                         Caption = 'Entry Statistics';
//                         Image = EntryStatistics;
//                         RunObject = Page 304;
//                         RunPageLink = No.=FIELD(No.),
//                                       Date Filter=FIELD(Date Filter),
//                                       Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
//                                       Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter),
//                                       Location Filter=FIELD(Location Filter),
//                                       Drop Shipment Filter=FIELD(Drop Shipment Filter),
//                                       Variant Filter=FIELD(Variant Filter);
//                     }
//                     action("T&urnover")
//                     {
//                         Caption = 'T&urnover';
//                         Image = Turnover;
//                         RunObject = Page 158;
//                         RunPageLink = No.=FIELD(No.),
//                                       Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
//                                       Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter),
//                                       Location Filter=FIELD(Location Filter),
//                                       Drop Shipment Filter=FIELD(Drop Shipment Filter),
//                                       Variant Filter=FIELD(Variant Filter);
//                     }
//                 }
//                 action("Co&mments")
//                 {
//                     Caption = 'Co&mments';
//                     Image = ViewComments;
//                     RunObject = Page 124;
//                     RunPageLink = Table Name=CONST(Item),
//                                   No.=FIELD(No.);
//                 }
//             }
//             group("S&ales")
//             {
//                 Caption = 'S&ales';
//                 Image = Sales;
//                 action(Prices)
//                 {
//                     Caption = 'Prices';
//                     Image = Price;
//                     RunObject = Page 7002;
//                     RunPageLink = Item No.=FIELD(No.);
//                     RunPageView = SORTING(Item No.);
//                 }
//                 action("Line Discounts")
//                 {
//                     Caption = 'Line Discounts';
//                     Image = LineDiscount;
//                     RunObject = Page 7004;
//                     RunPageLink = Type=CONST(Item),
//                                   Code=FIELD(No.);
//                     RunPageView = SORTING(Type,Code);
//                 }
//                 action("Prepa&yment Percentages")
//                 {
//                     Caption = 'Prepa&yment Percentages';
//                     Image = PrepaymentPercentages;
//                     RunObject = Page 664;
//                     RunPageLink = Item No.=FIELD(No.);
//                 }
//                 action(Orders)
//                 {
//                     Caption = 'Orders';
//                     Image = Document;
//                     RunObject = Page 48;
//                     RunPageLink = Type=CONST(Item),
//                                   No.=FIELD(No.);
//                     RunPageView = SORTING(Document Type,Type,No.);
//                 }
//                 action("Returns Orders")
//                 {
//                     Caption = 'Returns Orders';
//                     Image = ReturnOrder;
//                     RunObject = Page 6633;
//                     RunPageLink = Type=CONST(Item),
//                                   No.=FIELD(No.);
//                     RunPageView = SORTING(Document Type,Type,No.);
//                 }
//             }
//             group("&Purchases")
//             {
//                 Caption = '&Purchases';
//                 Image = Purchasing;
//                 action("Ven&dors")
//                 {
//                     Caption = 'Ven&dors';
//                     Image = Vendor;
//                     RunObject = Page 114;
//                     RunPageLink = Item No.=FIELD(No.);
//                     RunPageView = SORTING(Item No.);
//                 }
//                 action(Prices)
//                 {
//                     Caption = 'Prices';
//                     Image = Price;
//                     RunObject = Page 7012;
//                     RunPageLink = Item No.=FIELD(No.);
//                     RunPageView = SORTING(Item No.);
//                 }
//                 action("Line Discounts")
//                 {
//                     Caption = 'Line Discounts';
//                     Image = LineDiscount;
//                     RunObject = Page 7014;
//                     RunPageLink = Item No.=FIELD(No.);
//                     RunPageView = SORTING(Item No.);
//                 }
//                 action("Prepa&yment Percentages")
//                 {
//                     Caption = 'Prepa&yment Percentages';
//                     Image = PrepaymentPercentages;
//                     RunObject = Page 665;
//                     RunPageLink = Item No.=FIELD(No.);
//                 }
//                 action(Orders)
//                 {
//                     Caption = 'Orders';
//                     Image = Document;
//                     RunObject = Page 56;
//                     RunPageLink = Type=CONST(Item),
//                                   No.=FIELD(No.);
//                     RunPageView = SORTING(Document Type,Type,No.);
//                 }
//                 action("Return Orders")
//                 {
//                     Caption = 'Return Orders';
//                     Image = ReturnOrder;
//                     RunObject = Page 6643;
//                     RunPageLink = Type=CONST(Item),
//                                   No.=FIELD(No.);
//                     RunPageView = SORTING(Document Type,Type,No.);
//                 }
//                 action("Nonstoc&k Items")
//                 {
//                     Caption = 'Nonstoc&k Items';
//                     Image = NonStockItem;
//                     RunObject = Page 5726;
//                 }
//             }
//             group(Warehouse)
//             {
//                 Caption = 'Warehouse';
//                 Image = Warehouse;
//                 action("&Bin Contents")
//                 {
//                     Caption = '&Bin Contents';
//                     Image = BinContent;
//                     RunObject = Page 7379;
//                     RunPageLink = Item No.=FIELD(No.);
//                     RunPageView = SORTING(Item No.);
//                 }
//                 action("Stockkeepin&g Units")
//                 {
//                     Caption = 'Stockkeepin&g Units';
//                     Image = SKU;
//                     RunObject = Page 5701;
//                     RunPageLink = Item No.=FIELD(No.);
//                     RunPageView = SORTING(Item No.);
//                 }
//             }
//             group(Service)
//             {
//                 Caption = 'Service';
//                 Image = ServiceItem;
//                 action("Ser&vice Items")
//                 {
//                     Caption = 'Ser&vice Items';
//                     Image = ServiceItem;
//                     RunObject = Page 5988;
//                     RunPageLink = Item No.=FIELD(No.);
//                     RunPageView = SORTING(Item No.);
//                 }
//                 action(Troubleshooting)
//                 {
//                     Caption = 'Troubleshooting';
//                     Image = Troubleshoot;

//                     trigger OnAction()
//                     var
//                         TroubleshootingHeader: Record "5943";
//                     begin
//                         TroubleshootingHeader.ShowForItem(Rec);
//                     end;
//                 }
//                 action("Troubleshooting Setup")
//                 {
//                     Caption = 'Troubleshooting Setup';
//                     Image = Troubleshoot;
//                     RunObject = Page 5993;
//                     RunPageLink = Type=CONST(Item),
//                                   No.=FIELD(No.);
//                 }
//             }
//             group(Resources)
//             {
//                 Caption = 'Resources';
//                 Image = Resource;
//                 group("R&esource")
//                 {
//                     Caption = 'R&esource';
//                     Image = Resource;
//                     action("Resource &Skills")
//                     {
//                         Caption = 'Resource &Skills';
//                         Image = ResourceSkills;
//                         RunObject = Page 6019;
//                         RunPageLink = Type=CONST(Item),
//                                       No.=FIELD(No.);
//                     }
//                     action("Skilled R&esources")
//                     {
//                         Caption = 'Skilled R&esources';
//                         Image = ResourceSkills;

//                         trigger OnAction()
//                         var
//                             ResourceSkill: Record "5956";
//                         begin
//                             CLEAR(SkilledResourceList);
//                             SkilledResourceList.Initialize(ResourceSkill.Type::Item,"No.",Description);
//                             SkilledResourceList.RUNMODAL;
//                         end;
//                     }
//                 }
//             }
//         }
//         area(processing)
//         {
//             group("F&unctions")
//             {
//                 Caption = 'F&unctions';
//                 Image = "Action";
//                 action("&Create Stockkeeping Unit")
//                 {
//                     Caption = '&Create Stockkeeping Unit';
//                     Image = CreateSKU;

//                     trigger OnAction()
//                     var
//                         Item: Record "27";
//                     begin
//                         Item.SETRANGE("No.","No.");
//                         REPORT.RUNMODAL(REPORT::"Create Stockkeeping Unit",TRUE,FALSE,Item);
//                     end;
//                 }
//                 action("C&alculate Counting Period")
//                 {
//                     Caption = 'C&alculate Counting Period';
//                     Image = CalculateCalendar;

//                     trigger OnAction()
//                     var
//                         PhysInvtCountMgt: Codeunit "7380";
//                     begin
//                         PhysInvtCountMgt.UpdateItemPhysInvtCount(Rec);
//                     end;
//                 }
//             }
//             action("Sales Prices")
//             {
//                 Caption = 'Sales Prices';
//                 Image = SalesPrices;
//                 Promoted = true;
//                 PromotedCategory = Process;
//                 RunObject = Page 7002;
//                 RunPageLink = Item No.=FIELD(No.);
//                 RunPageView = SORTING(Item No.);
//             }
//             action("Sales Line Discounts")
//             {
//                 Caption = 'Sales Line Discounts';
//                 Image = SalesLineDisc;
//                 Promoted = false;
//                 //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
//                 //PromotedCategory = Process;
//                 RunObject = Page 7004;
//                 RunPageLink = Type=CONST(Item),
//                               Code=FIELD(No.);
//                 RunPageView = SORTING(Type,Code);
//             }
//             action("Requisition Worksheet")
//             {
//                 Caption = 'Requisition Worksheet';
//                 Image = Worksheet;
//                 Promoted = true;
//                 PromotedCategory = Process;
//                 RunObject = Page 291;
//             }
//             action("Item Journal")
//             {
//                 Caption = 'Item Journal';
//                 Image = Journals;
//                 Promoted = true;
//                 PromotedCategory = Process;
//                 RunObject = Page 40;
//             }
//             action("Item Reclassification Journal")
//             {
//                 Caption = 'Item Reclassification Journal';
//                 Image = Journals;
//                 Promoted = false;
//                 //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
//                 //PromotedCategory = Process;
//                 RunObject = Page 393;
//             }
//             action("Item Tracing")
//             {
//                 Caption = 'Item Tracing';
//                 Image = ItemTracing;
//                 Promoted = false;
//                 //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
//                 //PromotedCategory = Process;
//                 RunObject = Page 6520;
//             }
//             action("Adjust Item Cost/Price")
//             {
//                 Caption = 'Adjust Item Cost/Price';
//                 Image = AdjustItemCost;
//                 Promoted = false;
//                 //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
//                 //PromotedCategory = Process;
//                 RunObject = Report 794;
//             }
//             action("Adjust Cost - Item Entries")
//             {
//                 Caption = 'Adjust Cost - Item Entries';
//                 Image = AdjustEntries;
//                 Promoted = true;
//                 PromotedCategory = Process;
//                 RunObject = Report 795;
//             }
//         }
//         area(reporting)
//         {
//             action("Inventory - List")
//             {
//                 Caption = 'Inventory - List';
//                 Image = "Report";
//                 Promoted = false;
//                 //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
//                 //PromotedCategory = "Report";
//                 RunObject = Report 701;
//             }
//             action("Item Register - Quantity")
//             {
//                 Caption = 'Item Register - Quantity';
//                 Image = "Report";
//                 Promoted = false;
//                 //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
//                 //PromotedCategory = "Report";
//                 RunObject = Report 703;
//             }
//             action("Inventory - Transaction Detail")
//             {
//                 Caption = 'Inventory - Transaction Detail';
//                 Image = "Report";
//                 Promoted = false;
//                 //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
//                 //PromotedCategory = "Report";
//                 RunObject = Report 704;
//             }
//             action("Inventory Availability")
//             {
//                 Caption = 'Inventory Availability';
//                 Image = "Report";
//                 Promoted = true;
//                 PromotedCategory = "Report";
//                 RunObject = Report 705;
//             }
//             action(Status)
//             {
//                 Caption = 'Status';
//                 Image = "Report";
//                 Promoted = false;
//                 //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
//                 //PromotedCategory = "Report";
//                 RunObject = Report 706;
//             }
//             action("Inventory - Availability Plan")
//             {
//                 Caption = 'Inventory - Availability Plan';
//                 Image = ItemAvailability;
//                 Promoted = false;
//                 //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
//                 //PromotedCategory = "Report";
//                 RunObject = Report 707;
//             }
//             action("Inventory Order Details")
//             {
//                 Caption = 'Inventory Order Details';
//                 Image = "Report";
//                 Promoted = false;
//                 //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
//                 //PromotedCategory = "Report";
//                 RunObject = Report 708;
//             }
//             action("Inventory Purchase Orders")
//             {
//                 Caption = 'Inventory Purchase Orders';
//                 Image = "Report";
//                 Promoted = false;
//                 //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
//                 //PromotedCategory = "Report";
//                 RunObject = Report 709;
//             }
//             action("Inventory - Top 10 List")
//             {
//                 Caption = 'Inventory - Top 10 List';
//                 Image = "Report";
//                 Promoted = true;
//                 PromotedCategory = "Report";
//                 RunObject = Report 711;
//             }
//             action("Inventory - Sales Statistics")
//             {
//                 Caption = 'Inventory - Sales Statistics';
//                 Image = "Report";
//                 Promoted = false;
//                 //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
//                 //PromotedCategory = "Report";
//                 RunObject = Report 712;
//             }
//             action("Assemble to Order - Sales")
//             {
//                 Caption = 'Assemble to Order - Sales';
//                 Image = "Report";
//                 //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
//                 //PromotedCategory = "Report";
//                 RunObject = Report 915;
//             }
//             action("Inventory - Customer Sales")
//             {
//                 Caption = 'Inventory - Customer Sales';
//                 Image = "Report";
//                 Promoted = false;
//                 //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
//                 //PromotedCategory = "Report";
//                 RunObject = Report 713;
//             }
//             action("Inventory - Vendor Purchases")
//             {
//                 Caption = 'Inventory - Vendor Purchases';
//                 Image = "Report";
//                 Promoted = false;
//                 //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
//                 //PromotedCategory = "Report";
//                 RunObject = Report 714;
//             }
//             action("Price List")
//             {
//                 Caption = 'Price List';
//                 Image = "Report";
//                 Promoted = true;
//                 PromotedCategory = "Report";
//                 RunObject = Report 715;
//             }
//             action("Inventory Cost and Price List")
//             {
//                 Caption = 'Inventory Cost and Price List';
//                 Image = "Report";
//                 Promoted = true;
//                 PromotedCategory = "Report";
//                 RunObject = Report 716;
//             }
//             action("Inventory - Reorders")
//             {
//                 Caption = 'Inventory - Reorders';
//                 Image = "Report";
//                 Promoted = true;
//                 PromotedCategory = "Report";
//                 RunObject = Report 717;
//             }
//             action("Inventory - Sales Back Orders")
//             {
//                 Caption = 'Inventory - Sales Back Orders';
//                 Image = "Report";
//                 Promoted = true;
//                 PromotedCategory = "Report";
//                 RunObject = Report 718;
//             }
//             action("Item/Vendor Catalog")
//             {
//                 Caption = 'Item/Vendor Catalog';
//                 Image = "Report";
//                 Promoted = false;
//                 //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
//                 //PromotedCategory = "Report";
//                 RunObject = Report 720;
//             }
//             action("Inventory - Cost Variance")
//             {
//                 Caption = 'Inventory - Cost Variance';
//                 Image = ItemCosts;
//                 Promoted = false;
//                 //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
//                 //PromotedCategory = "Report";
//                 RunObject = Report 721;
//             }
//             action("Phys. Inventory List")
//             {
//                 Caption = 'Phys. Inventory List';
//                 Image = "Report";
//                 Promoted = false;
//                 //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
//                 //PromotedCategory = "Report";
//                 RunObject = Report 722;
//             }
//             action("Inventory Valuation")
//             {
//                 Caption = 'Inventory Valuation';
//                 Image = "Report";
//                 Promoted = true;
//                 PromotedCategory = "Report";
//                 RunObject = Report 1001;
//             }
//             action("Nonstock Item Sales")
//             {
//                 Caption = 'Nonstock Item Sales';
//                 Image = "Report";
//                 Promoted = false;
//                 //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
//                 //PromotedCategory = "Report";
//                 RunObject = Report 5700;
//             }
//             action("Item Substitutions")
//             {
//                 Caption = 'Item Substitutions';
//                 Image = "Report";
//                 Promoted = false;
//                 //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
//                 //PromotedCategory = "Report";
//                 RunObject = Report 5701;
//             }
//             action("Invt. Valuation - Cost Spec.")
//             {
//                 Caption = 'Invt. Valuation - Cost Spec.';
//                 Image = "Report";
//                 Promoted = false;
//                 //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
//                 //PromotedCategory = "Report";
//                 RunObject = Report 5801;
//             }
//             action("Inventory Valuation - WIP")
//             {
//                 Caption = 'Inventory Valuation - WIP';
//                 Image = "Report";
//                 Promoted = false;
//                 //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
//                 //PromotedCategory = "Report";
//                 RunObject = Report 5802;
//             }
//             action("Item Register - Value")
//             {
//                 Caption = 'Item Register - Value';
//                 Image = "Report";
//                 Promoted = false;
//                 //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
//                 //PromotedCategory = "Report";
//                 RunObject = Report 5805;
//             }
//             action("Item Charges - Specification")
//             {
//                 Caption = 'Item Charges - Specification';
//                 Image = "Report";
//                 Promoted = false;
//                 //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
//                 //PromotedCategory = "Report";
//                 RunObject = Report 5806;
//             }
//             action("Item Age Composition - Qty.")
//             {
//                 Caption = 'Item Age Composition - Qty.';
//                 Image = "Report";
//                 Promoted = false;
//                 //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
//                 //PromotedCategory = "Report";
//                 RunObject = Report 5807;
//             }
//             action("Item Age Composition - Value")
//             {
//                 Caption = 'Item Age Composition - Value';
//                 Image = "Report";
//                 Promoted = false;
//                 //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
//                 //PromotedCategory = "Report";
//                 RunObject = Report 5808;
//             }
//             action("Item Expiration - Quantity")
//             {
//                 Caption = 'Item Expiration - Quantity';
//                 Image = "Report";
//                 Promoted = false;
//                 //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
//                 //PromotedCategory = "Report";
//                 RunObject = Report 5809;
//             }
//             action("Cost Shares Breakdown")
//             {
//                 Caption = 'Cost Shares Breakdown';
//                 Image = "Report";
//                 Promoted = false;
//                 //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
//                 //PromotedCategory = "Report";
//                 RunObject = Report 5848;
//             }
//             action("Detailed Calculation")
//             {
//                 Caption = 'Detailed Calculation';
//                 Image = "Report";
//                 Promoted = false;
//                 //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
//                 //PromotedCategory = "Report";
//                 RunObject = Report 99000756;
//             }
//             action("Rolled-up Cost Shares")
//             {
//                 Caption = 'Rolled-up Cost Shares';
//                 Image = "Report";
//                 Promoted = false;
//                 //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
//                 //PromotedCategory = "Report";
//                 RunObject = Report 99000754;
//             }
//             action("Single-Level Cost Shares")
//             {
//                 Caption = 'Single-Level Cost Shares';
//                 Image = "Report";
//                 Promoted = false;
//                 //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
//                 //PromotedCategory = "Report";
//                 RunObject = Report 99000755;
//             }
//             action("Where Used (Top Level)")
//             {
//                 Caption = 'Where Used (Top Level)';
//                 Image = "Report";
//                 Promoted = false;
//                 //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
//                 //PromotedCategory = "Report";
//                 RunObject = Report 99000757;
//             }
//             action("Quantity Explosion of BOM")
//             {
//                 Caption = 'Quantity Explosion of BOM';
//                 Image = "Report";
//                 Promoted = false;
//                 //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
//                 //PromotedCategory = "Report";
//                 RunObject = Report 99000753;
//             }
//             action("Compare List")
//             {
//                 Caption = 'Compare List';
//                 Image = "Report";
//                 Promoted = false;
//                 //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
//                 //PromotedCategory = "Report";
//                 RunObject = Report 99000758;
//             }
//         }
//     }

//     trigger OnAfterGetRecord()
//     begin
//         ItemCrossRef.RESET;
//         ItemCrossRef.SETRANGE("Item No.","No.");
//         ItemCrossRef.SETRANGE("Cross-Reference Type",ItemCrossRef."Cross-Reference Type"::"Bar Code");
//         IF ItemCrossRef.FINDFIRST THEN
//           BarCode := ItemCrossRef."Cross-Reference No."
//         ELSE
//           BarCode := '';
//     end;

//     var
//         SkilledResourceList: Page "6023";
//         CalculateStdCost: Codeunit "5812";
//         ItemAvailFormsMgt: Codeunit "353";
//         ItemCrossRef: Record "5717";
//         ItemTranslation: Record "30";
//         BarCode: Code[20];
//         EnglishDescription: Text[50];

//     procedure GetSelectionFilter(): Text
//     var
//         Item: Record "27";
//         SelectionFilterManagement: Codeunit "46";
//     begin
//         CurrPage.SETSELECTIONFILTER(Item);
//         EXIT(SelectionFilterManagement.GetSelectionFilterForItem(Item));
//     end;

//     procedure SetSelection(var Item: Record "27")
//     begin
//         CurrPage.SETSELECTIONFILTER(Item);
//     end;

//     procedure ImportSafetyStockQty()
//     var
//         ExcelBuffer: Record "370";
//         ServerFileName: Text;
//         SheetName: Text[250];
//         lItemNo: Code[20];
//         lrItem: Record "27";
//         FileMgt: Codeunit "419";
//         Text006: Label 'Import Excel File';
//         ExcelExtensionTok: Label '.xlsx', Locked=true;
//     begin
//         ServerFileName := FileMgt.UploadFile(Text006,ExcelExtensionTok);
//         IF ServerFileName = '' THEN
//           EXIT;

//         SheetName := ExcelBuffer.SelectSheetsName(ServerFileName);
//         IF SheetName = '' THEN
//           EXIT;

//         ExcelBuffer.LOCKTABLE;
//         ExcelBuffer.OpenBook(ServerFileName,SheetName);
//         ExcelBuffer.ReadSheet;
//         ExcelBuffer.SETFILTER("Row No.",'>%1',14);
//         ExcelBuffer.SETFILTER("Column No.",'7|9');
//         IF ExcelBuffer.FINDFIRST THEN REPEAT
//           IF ExcelBuffer."Column No." = 7 THEN
//             lItemNo := ExcelBuffer."Cell Value as Text";
//           IF ExcelBuffer."Column No." = 9 THEN BEGIN
//             lrItem.RESET;
//             lrItem.SETRANGE("No.",lItemNo);
//             IF lrItem.FINDFIRST THEN BEGIN
//               EVALUATE(lrItem."Safety Stock Quantity",ExcelBuffer."Cell Value as Text");
//               lrItem.VALIDATE("Safety Stock Quantity");
//               lrItem.MODIFY;
//             END ELSE
//               ERROR('Item %1 not found',lItemNo);
//           END;
//         UNTIL ExcelBuffer.NEXT = 0;
//         MESSAGE('Done');
//         ExcelBuffer.DELETEALL;

































//     end;
// }

