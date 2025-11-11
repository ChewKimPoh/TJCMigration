// codeunit 50001 TJCNavisionComm
// {
//     // TJCSG1.00
//     //  1. 17/04/2014  dp.dst
//     //     - Commented out the codes in OnRun() trigger as they are incompatible with NAV 2013.

//     SingleInstance = true;

//     trigger OnRun()
//     begin
//         /*Start: TJCSG1.00 #1*/
//         // Commented out this code first as it is incompatible with NAV 2013.
//         /*
//         MESSAGE('Warehouse Code unit started...');
//         IF ISCLEAR(MQBus) THEN
//           CREATE(MQBus);
//         IF ISCLEAR(CC2) THEN
//           CREATE(CC2);
//         IF ISCLEAR(XMLDom) THEN
//            CREATE(XMLDom);
//         CC2.AddBusAdapter(MQBus,1);
//         MQBus.OpenReceiveQueue('.\Private$\tonavisionstock',0,0);
//         */
//         /*End: TJCSG1.00 #1*/

//     end;

//     var
//         MQBus: Automation ;
//         [WithEvents]
//         CC2: Automation ;
//         InMsg: Automation ;
//         InS: InStream;
//         XMLDom: Automation ;
//         XMLNode: Automation ;
//         OutMsg: Automation ;
//         OutS: OutStream;
//         Request: Text[1000];
//         Parameters: array [200] of Text[1000];
//         auxstring: Text[1000];
//         argpos: Integer;
//         commapos: Integer;
//         ParCount: Integer;
//         BizLayer: Codeunit "50002";
//         FunctionName: Text[50];
//         NewChildNode: Automation ;
//         XMLNewAttributeNode: Automation ;
//         XMLRoot: Automation ;

//     procedure ParseRequest(string: Text[1000])
//     begin
//         Request := COPYSTR (string, 1, STRPOS (string, '(') - 1);
//         auxstring := COPYSTR (string, STRPOS (string, '(') + 1, STRLEN (string) - STRPOS (string, '(') - 1);
//         argpos := 1;
//         commapos := STRPOS (auxstring, ',');
//         WHILE (commapos <> 0) DO
//           BEGIN
//             Parameters[argpos] := COPYSTR (auxstring, 1, commapos - 1);
//             auxstring := COPYSTR (auxstring, STRPOS (auxstring, ',') + 1);
//             argpos := argpos + 1;
//             commapos := STRPOS (auxstring, ',');
//           END;
//         Parameters[argpos] := auxstring;
//         ParCount := argpos;
//     end;

//     procedure FindNode(RootNode: Automation ;NodePath: Text[1024];var ReturnedNode: Automation ): Boolean
//     begin
//         ReturnedNode := RootNode.selectSingleNode(NodePath);
//         IF ISCLEAR(ReturnedNode) THEN
//             EXIT(FALSE)
//         ELSE
//             EXIT(TRUE);
//     end;

//     procedure AddElement(var XMLNode: Automation ;NodeName: Text[250];var CreatedXMLNode: Automation )
//     begin
//         //for xml - add element to xml document

//         NewChildNode:=XMLNode.ownerDocument.createNode('element',NodeName,'');
//         XMLNode.appendChild(NewChildNode);
//         CreatedXMLNode:=NewChildNode;
//     end;

//     procedure AddAttribute(var XMLNode: Automation ;Name: Text[260];NodeValue: Text[260])
//     begin
//         //for xml - add attribute to xml document

//         IF NodeValue<>''THEN BEGIN

//         XMLNewAttributeNode:= XMLNode.ownerDocument.createAttribute(Name);
//         XMLNewAttributeNode.nodeValue:=NodeValue;

//         XMLNode.attributes.setNamedItem(XMLNewAttributeNode);
//         END;
//     end;
// }

