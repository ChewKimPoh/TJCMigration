codeunit 50021 "DP Xapp Svc"
{

    trigger OnRun()
    begin
    end;

    procedure ExportTOHeaderList(var XMLTOHeader: XMLport "TO Header List")
    var
        recTransferHeader: Record "Transfer Header";
    begin
        //recTransferHeader.SETRANGE(Status, recTransferHeader.Status::Released);
        //XMLTOHeader.SETTABLEVIEW(recTransferHeader);
        //MESSAGE('hi');
    end;

    procedure ExportItemInfo(var ItemInfoXML: XMLport "Whse Item Info")
    var
        recItem: Record Item;
    begin
        recItem.RESET;
        /*
        IF in_ItemNo <> '' THEN BEGIN
          IF recItem.GET(in_ItemNo) THEN
            ItemInfoXML.SETTABLEVIEW(recItem);
        END ELSE
          ItemInfoXML.SETTABLEVIEW(recItem);
          */
        ItemInfoXML.SETTABLEVIEW(recItem);

    end;

    procedure ExportItemsUOM(var ItemsUOMXML: XMLport "Items UOM")
    var
        recItemUOM: Record "Item Unit of Measure";
    begin
        recItemUOM.RESET;
        ItemsUOMXML.SETTABLEVIEW(recItemUOM);
    end;

    procedure ExportItemByLocations(var ItemByLocXML: XMLport "Whse Item By Locations"; in_ItemCode: Code[20])
    begin
        ItemByLocXML.SetData(in_ItemCode);
    end;

    procedure ExportLocationList(var XMLLocationList: XMLport "Location List")
    var
        recLocation: Record Location;
    begin
        recLocation.RESET();
        XMLLocationList.SETTABLEVIEW(recLocation);
    end;

    procedure ExportTOLineList(cTONo: Code[20]; var TOLineList: XMLport "TO Lines")
    var
        RecTOLine: Record "Transfer Line";
    begin
        RecTOLine.RESET;
        RecTOLine.SETRANGE("Document No.", cTONo);
        //RecPurchaseLine.SETFILTER("Outstanding Quantity" ,'<>%1',0);
        //RecTOLine.SETFILTER( "Qty. in Transit" ,'<>%1',0);
        TOLineList.SETTABLEVIEW(RecTOLine);
    end;

    procedure ExportUOMList(var UOMListXML: XMLport "UOM List")
    var
        recUOM: Record "Unit of Measure";
    begin
        recUOM.RESET;
        UOMListXML.SETTABLEVIEW(recUOM);
    end;

    procedure ImportTOHeader(var XMLTOHeader: XMLport "TO Header List"): Text
    var
        recTransferHeader: Record "Transfer Header";
    begin
        IF XMLTOHeader.IMPORT THEN BEGIN
            EXIT('Success');
        END ELSE
            EXIT(GETLASTERRORTEXT);
    end;

    procedure ImportToLine(var TOShipLineXML: XMLport "TO Lines"): Text
    begin
        IF TOShipLineXML.IMPORT THEN BEGIN
            EXIT('Success');
        END ELSE
            EXIT(GETLASTERRORTEXT);
    end;

    procedure isTOPostReceived(TONo: Code[20]): Boolean
    var
        recTrfReceiptHeader: Record "Transfer Receipt Header";
        ret: Boolean;
    begin
        ret := FALSE;
        recTrfReceiptHeader.RESET;
        recTrfReceiptHeader.SETRANGE("External Document No.", TONo);
        IF recTrfReceiptHeader.FINDFIRST THEN
            ret := TRUE;
        EXIT(ret);
    end;

    procedure ImportTJCTO(var XMLTOHeader: XMLport "TJC Transfer Order"): Text
    var
        recTransferHeader: Record "Transfer Header";
    begin
        IF XMLTOHeader.IMPORT THEN BEGIN
            EXIT('Success');
        END ELSE
            EXIT(GETLASTERRORTEXT);
    end;
}

