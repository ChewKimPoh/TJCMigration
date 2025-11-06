// codeunit 50021 "DP Xapp Svc"
// {

//     trigger OnRun()
//     begin
//     end;

//     procedure ExportTOHeaderList(var XMLTOHeader: XMLport "50006")
//     var
//         recTransferHeader: Record "5740";
//     begin
//         //recTransferHeader.SETRANGE(Status, recTransferHeader.Status::Released);
//         //XMLTOHeader.SETTABLEVIEW(recTransferHeader);
//         //MESSAGE('hi');
//     end;

//     procedure ExportItemInfo(var ItemInfoXML: XMLport "50004")
//     var
//         recItem: Record "27";
//     begin
//         recItem.RESET;
//         /*
//         IF in_ItemNo <> '' THEN BEGIN
//           IF recItem.GET(in_ItemNo) THEN
//             ItemInfoXML.SETTABLEVIEW(recItem);
//         END ELSE
//           ItemInfoXML.SETTABLEVIEW(recItem);
//           */
//           ItemInfoXML.SETTABLEVIEW(recItem);

//     end;

//     procedure ExportItemsUOM(var ItemsUOMXML: XMLport "50013")
//     var
//         recItemUOM: Record "5404";
//     begin
//         recItemUOM.RESET;
//         ItemsUOMXML.SETTABLEVIEW(recItemUOM);
//     end;

//     procedure ExportItemByLocations(var ItemByLocXML: XMLport "50005";in_ItemCode: Code[20])
//     begin
//         ItemByLocXML.SetData(in_ItemCode);
//     end;

//     procedure ExportLocationList(var XMLLocationList: XMLport "50010")
//     var
//         recLocation: Record "14";
//     begin
//         recLocation.RESET();
//         XMLLocationList.SETTABLEVIEW(recLocation);
//     end;

//     procedure ExportTOLineList(cTONo: Code[20];var TOLineList: XMLport "50007")
//     var
//         RecTOLine: Record "5741";
//     begin
//         RecTOLine.RESET;
//         RecTOLine.SETRANGE("Document No.", cTONo);
//         //RecPurchaseLine.SETFILTER("Outstanding Quantity" ,'<>%1',0);
//         //RecTOLine.SETFILTER( "Qty. in Transit" ,'<>%1',0);
//         TOLineList.SETTABLEVIEW(RecTOLine);
//     end;

//     procedure ExportUOMList(var UOMListXML: XMLport "50011")
//     var
//         recUOM: Record "204";
//     begin
//         recUOM.RESET;
//         UOMListXML.SETTABLEVIEW(recUOM);
//     end;

//     procedure ImportTOHeader(var XMLTOHeader: XMLport "50006"): Text
//     var
//         recTransferHeader: Record "5740";
//     begin
//         IF XMLTOHeader.IMPORT THEN BEGIN
//           EXIT('Success');
//         END ELSE
//           EXIT(GETLASTERRORTEXT);
//     end;

//     procedure ImportToLine(var TOShipLineXML: XMLport "50007"): Text
//     begin
//         IF TOShipLineXML.IMPORT THEN BEGIN
//           EXIT('Success');
//         END ELSE
//           EXIT(GETLASTERRORTEXT);
//     end;

//     procedure isTOPostReceived(TONo: Code[20]): Boolean
//     var
//         recTrfReceiptHeader: Record "5746";
//         ret: Boolean;
//     begin
//         ret := FALSE;
//         recTrfReceiptHeader.RESET;
//         recTrfReceiptHeader.SETRANGE("External Document No.",TONo);
//         IF recTrfReceiptHeader.FINDFIRST THEN
//           ret:= TRUE;
//         EXIT(ret);
//     end;

//     procedure ImportTJCTO(var XMLTOHeader: XMLport "50012"): Text
//     var
//         recTransferHeader: Record "5740";
//     begin
//         IF XMLTOHeader.IMPORT THEN BEGIN
//           EXIT('Success');
//         END ELSE
//           EXIT(GETLASTERRORTEXT);
//     end;
// }

