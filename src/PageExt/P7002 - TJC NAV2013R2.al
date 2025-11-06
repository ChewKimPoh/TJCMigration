// page 7002 "Sales Prices"
// {
//     Caption = 'Sales Prices';
//     DataCaptionExpression = GetCaption;
//     DelayedInsert = true;
//     PageType = Worksheet;
//     SaveValues = true;
//     SourceTable = Table7002;

//     layout
//     {
//         area(content)
//         {
//             group(General)
//             {
//                 Caption = 'General';
//                 field(SalesTypeFilter;SalesTypeFilter)
//                 {
//                     Caption = 'Sales Type Filter';
//                     OptionCaption = 'Customer,Customer Price Group,All Customers,Campaign,None';

//                     trigger OnValidate()
//                     begin
//                         SalesTypeFilterOnAfterValidate;
//                     end;
//                 }
//                 field(SalesCodeFilterCtrl;SalesCodeFilter)
//                 {
//                     Caption = 'Sales Code Filter';
//                     Enabled = SalesCodeFilterCtrlEnable;

//                     trigger OnLookup(var Text: Text): Boolean
//                     var
//                         CustList: Page "22";
//                         CustPriceGrList: Page "7";
//                         CampaignList: Page "5087";
//                     begin
//                         IF SalesTypeFilter = SalesTypeFilter::"All Customers" THEN
//                           EXIT;

//                         CASE SalesTypeFilter OF
//                           SalesTypeFilter::Customer:
//                             BEGIN
//                               CustList.LOOKUPMODE := TRUE;
//                               IF CustList.RUNMODAL = ACTION::LookupOK THEN
//                                 Text := CustList.GetSelectionFilter
//                               ELSE
//                                 EXIT(FALSE);
//                             END;
//                           SalesTypeFilter::"Customer Price Group":
//                             BEGIN
//                               CustPriceGrList.LOOKUPMODE := TRUE;
//                               IF CustPriceGrList.RUNMODAL = ACTION::LookupOK THEN
//                                 Text := CustPriceGrList.GetSelectionFilter
//                               ELSE
//                                 EXIT(FALSE);
//                             END;
//                           SalesTypeFilter::Campaign:
//                             BEGIN
//                               CampaignList.LOOKUPMODE := TRUE;
//                               IF CampaignList.RUNMODAL = ACTION::LookupOK THEN
//                                 Text := CampaignList.GetSelectionFilter
//                               ELSE
//                                 EXIT(FALSE);
//                             END;
//                         END;

//                         EXIT(TRUE);
//                     end;

//                     trigger OnValidate()
//                     begin
//                         SalesCodeFilterOnAfterValidate;
//                     end;
//                 }
//                 field(ItemNoFilterCtrl;ItemNoFilter)
//                 {
//                     Caption = 'Item No. Filter';

//                     trigger OnLookup(var Text: Text): Boolean
//                     var
//                         ItemList: Page "31";
//                     begin
//                         ItemList.LOOKUPMODE := TRUE;
//                         IF ItemList.RUNMODAL = ACTION::LookupOK THEN
//                           Text := ItemList.GetSelectionFilter
//                         ELSE
//                           EXIT(FALSE);

//                         EXIT(TRUE);
//                     end;

//                     trigger OnValidate()
//                     begin
//                         ItemNoFilterOnAfterValidate;
//                     end;
//                 }
//                 field(StartingDateFilter;StartingDateFilter)
//                 {
//                     Caption = 'Starting Date Filter';

//                     trigger OnValidate()
//                     var
//                         ApplicationMgt: Codeunit "1";
//                     begin
//                         IF ApplicationMgt.MakeDateFilter(StartingDateFilter) = 0 THEN;
//                         StartingDateFilterOnAfterValid;
//                     end;
//                 }
//                 field(SalesCodeFilterCtrl2;CurrencyCodeFilter)
//                 {
//                     Caption = 'Currency Code Filter';

//                     trigger OnLookup(var Text: Text): Boolean
//                     var
//                         CurrencyList: Page "5";
//                     begin
//                         CurrencyList.LOOKUPMODE := TRUE;
//                         IF CurrencyList.RUNMODAL = ACTION::LookupOK THEN
//                           Text := CurrencyList.GetSelectionFilter
//                         ELSE
//                           EXIT(FALSE);

//                         EXIT(TRUE);
//                     end;

//                     trigger OnValidate()
//                     begin
//                         CurrencyCodeFilterOnAfterValid;
//                     end;
//                 }
//             }
//             repeater()
//             {
//                 field("Sales Type";"Sales Type")
//                 {
//                 }
//                 field("Sales Code";"Sales Code")
//                 {
//                     Editable = "Sales CodeEditable";
//                 }
//                 field("Item No.";"Item No.")
//                 {
//                 }
//                 field(T_Item.Description;T_Item.Description)
//                 {
//                     Caption = 'Item Description';
//                 }
//                 field("Variant Code";"Variant Code")
//                 {
//                     Visible = false;
//                 }
//                 field("Currency Code";"Currency Code")
//                 {
//                     Visible = false;
//                 }
//                 field("Unit of Measure Code";"Unit of Measure Code")
//                 {
//                 }
//                 field("Minimum Quantity";"Minimum Quantity")
//                 {
//                 }
//                 field("Unit Price";"Unit Price")
//                 {
//                 }
//                 field("Starting Date";"Starting Date")
//                 {
//                 }
//                 field("Ending Date";"Ending Date")
//                 {
//                 }
//                 field("Price Includes VAT";"Price Includes VAT")
//                 {
//                     Visible = false;
//                 }
//                 field("Allow Line Disc.";"Allow Line Disc.")
//                 {
//                     Visible = false;
//                 }
//                 field("Allow Invoice Disc.";"Allow Invoice Disc.")
//                 {
//                     Visible = false;
//                 }
//                 field("VAT Bus. Posting Gr. (Price)";"VAT Bus. Posting Gr. (Price)")
//                 {
//                     Visible = false;
//                 }
//             }
//         }
//         area(factboxes)
//         {
//             systempart(;Links)
//             {
//                 Visible = false;
//             }
//             systempart(;Notes)
//             {
//                 Visible = false;
//             }
//         }
//     }

//     actions
//     {
//     }

//     trigger OnAfterGetCurrRecord()
//     begin
//         "Sales CodeEditable" := "Sales Type" <> "Sales Type"::"All Customers"
//     end;

//     trigger OnAfterGetRecord()
//     begin
//         T_Item.GET("Item No.");
//     end;

//     trigger OnInit()
//     begin
//         SalesCodeFilterCtrlEnable := TRUE;
//         "Sales CodeEditable" := TRUE;
//     end;

//     trigger OnOpenPage()
//     begin
//         GetRecFilters;
//         SetRecFilters;
//     end;

//     var
//         Cust: Record "18";
//         CustPriceGr: Record "6";
//         Campaign: Record "5071";
//         SalesTypeFilter: Option Customer,"Customer Price Group","All Customers",Campaign,"None";
//         SalesCodeFilter: Text[250];
//         ItemNoFilter: Text[250];
//         StartingDateFilter: Text[30];
//         CurrencyCodeFilter: Text[250];
//         Text000: Label 'All Customers';
//         Text001: Label 'No %1 within the filter %2.';
//         [InDataSet]
//         "Sales CodeEditable": Boolean;
//         [InDataSet]
//         SalesCodeFilterCtrlEnable: Boolean;
//         T_Item: Record "27";

//     procedure GetRecFilters()
//     begin
//         IF GETFILTERS <> '' THEN BEGIN
//           IF GETFILTER("Sales Type") <> '' THEN
//             SalesTypeFilter := GetSalesTypeFilter
//           ELSE
//             SalesTypeFilter := SalesTypeFilter::None;

//           SalesCodeFilter := GETFILTER("Sales Code");
//           ItemNoFilter := GETFILTER("Item No.");
//           CurrencyCodeFilter := GETFILTER("Currency Code");
//         END;

//         EVALUATE(StartingDateFilter,GETFILTER("Starting Date"));
//     end;

//     procedure SetRecFilters()
//     begin
//         SalesCodeFilterCtrlEnable := TRUE;

//         IF SalesTypeFilter <> SalesTypeFilter::None THEN
//           SETRANGE("Sales Type",SalesTypeFilter)
//         ELSE
//           SETRANGE("Sales Type");

//         IF SalesTypeFilter IN [SalesTypeFilter::"All Customers",SalesTypeFilter::None] THEN BEGIN
//           SalesCodeFilterCtrlEnable := FALSE;
//           SalesCodeFilter := '';
//         END;

//         IF SalesCodeFilter <> '' THEN
//           SETFILTER("Sales Code",SalesCodeFilter)
//         ELSE
//           SETRANGE("Sales Code");

//         IF StartingDateFilter <> '' THEN
//           SETFILTER("Starting Date",StartingDateFilter)
//         ELSE
//           SETRANGE("Starting Date");

//         IF ItemNoFilter <> '' THEN BEGIN
//           SETFILTER("Item No.",ItemNoFilter);
//         END ELSE
//           SETRANGE("Item No.");

//         IF CurrencyCodeFilter <> '' THEN BEGIN
//           SETFILTER("Currency Code",CurrencyCodeFilter);
//         END ELSE
//           SETRANGE("Currency Code");

//         CASE SalesTypeFilter OF
//           SalesTypeFilter::Customer:
//             CheckFilters(DATABASE::Customer,SalesCodeFilter);
//           SalesTypeFilter::"Customer Price Group":
//             CheckFilters(DATABASE::"Customer Price Group",SalesCodeFilter);
//           SalesTypeFilter::Campaign:
//             CheckFilters(DATABASE::Campaign,SalesCodeFilter);
//         END;
//         CheckFilters(DATABASE::Item,ItemNoFilter);
//         CheckFilters(DATABASE::Currency,CurrencyCodeFilter);

//         CurrPage.UPDATE(FALSE);
//     end;

//     procedure GetCaption(): Text[250]
//     var
//         ObjTransl: Record "377";
//         SourceTableName: Text[100];
//         SalesSrcTableName: Text[100];
//         Description: Text[250];
//     begin
//         GetRecFilters;
//         "Sales CodeEditable" := "Sales Type" <> "Sales Type"::"All Customers";

//         SourceTableName := '';
//         IF ItemNoFilter <> '' THEN
//           SourceTableName := ObjTransl.TranslateObject(ObjTransl."Object Type"::Table,27);

//         SalesSrcTableName := '';
//         CASE SalesTypeFilter OF
//           SalesTypeFilter::Customer:
//             BEGIN
//               SalesSrcTableName := ObjTransl.TranslateObject(ObjTransl."Object Type"::Table,18);
//               Cust."No." := SalesCodeFilter;
//               IF Cust.FIND THEN
//                 Description := Cust.Name;
//             END;
//           SalesTypeFilter::"Customer Price Group":
//             BEGIN
//               SalesSrcTableName := ObjTransl.TranslateObject(ObjTransl."Object Type"::Table,6);
//               CustPriceGr.Code := SalesCodeFilter;
//               IF CustPriceGr.FIND THEN
//                 Description := CustPriceGr.Description;
//             END;
//           SalesTypeFilter::Campaign:
//             BEGIN
//               SalesSrcTableName := ObjTransl.TranslateObject(ObjTransl."Object Type"::Table,5071);
//               Campaign."No." := SalesCodeFilter;
//               IF Campaign.FIND THEN
//                 Description := Campaign.Description;
//             END;
//           SalesTypeFilter::"All Customers":
//             BEGIN
//               SalesSrcTableName := Text000;
//               Description := '';
//             END;
//         END;

//         IF SalesSrcTableName = Text000 THEN
//           EXIT(STRSUBSTNO('%1 %2 %3',SalesSrcTableName,SourceTableName,ItemNoFilter));
//         EXIT(STRSUBSTNO('%1 %2 %3 %4 %5',SalesSrcTableName,SalesCodeFilter,Description,SourceTableName,ItemNoFilter));
//     end;

//     procedure CheckFilters(TableNo: Integer;FilterTxt: Text[250])
//     var
//         FilterRecordRef: RecordRef;
//         FilterFieldRef: FieldRef;
//     begin
//         IF FilterTxt = '' THEN
//           EXIT;
//         CLEAR(FilterRecordRef);
//         CLEAR(FilterFieldRef);
//         FilterRecordRef.OPEN(TableNo);
//         FilterFieldRef := FilterRecordRef.FIELD(1);
//         FilterFieldRef.SETFILTER(FilterTxt);
//         IF FilterRecordRef.ISEMPTY THEN
//           ERROR(Text001,FilterRecordRef.CAPTION,FilterTxt);
//     end;

//     local procedure SalesCodeFilterOnAfterValidate()
//     begin
//         CurrPage.SAVERECORD;
//         SetRecFilters;
//     end;

//     local procedure SalesTypeFilterOnAfterValidate()
//     begin
//         CurrPage.SAVERECORD;
//         SalesCodeFilter := '';
//         SetRecFilters;
//     end;

//     local procedure StartingDateFilterOnAfterValid()
//     begin
//         CurrPage.SAVERECORD;
//         SetRecFilters;
//     end;

//     local procedure ItemNoFilterOnAfterValidate()
//     begin
//         CurrPage.SAVERECORD;
//         SetRecFilters;
//     end;

//     local procedure CurrencyCodeFilterOnAfterValid()
//     begin
//         CurrPage.SAVERECORD;
//         SetRecFilters;
//     end;

//     local procedure GetSalesTypeFilter(): Integer
//     begin
//         CASE GETFILTER("Sales Type") OF
//           FORMAT("Sales Type"::Customer):
//             EXIT(0);
//           FORMAT("Sales Type"::"Customer Price Group"):
//             EXIT(1);
//           FORMAT("Sales Type"::"All Customers"):
//             EXIT(2);
//           FORMAT("Sales Type"::Campaign):
//             EXIT(3);
//         END;
//     end;
// }

