xmlport 50007 "TO Lines"
{
    UseDefaultNamespace = true;

    schema
    {
        textelement(TOLines)
        {
            tableelement("Transfer Line"; "Transfer Line")
            {
                AutoSave = true;
                AutoUpdate = true;
                XmlName = 'TOLine';
                SourceTableView = SORTING("Document No.", "Line No.");
                fieldelement(LineNo; "Transfer Line"."Line No.")
                {
                }
                fieldelement(DocumentNo; "Transfer Line"."Document No.")
                {

                    trigger OnAfterAssignField()
                    var
                        recTOHeader: Record "Transfer Header";
                    begin
                        IF "Transfer Line"."Document No." <> '' THEN BEGIN
                            TODoc := "Transfer Line"."Document No.";
                            iLineNo := "Transfer Line"."Line No.";
                            recTOHeader.RESET;
                            recTOHeader.SETRANGE("No.", "Transfer Line"."Document No.");
                            recTOHeader.SETRANGE(Status, recTOHeader.Status::Released);
                            IF recTOHeader.FINDFIRST() THEN BEGIN
                                recTOHeader.Status := recTOHeader.Status::Open;
                                recTOHeader.MODIFY()
                            END;
                        END;
                    end;
                }
                fieldelement(ItemNo; "Transfer Line"."Item No.")
                {
                }
                textelement(itemdesc)
                {
                    XmlName = 'ItemDesc';
                }
                textelement(Qty)
                {

                    trigger OnBeforePassVariable()
                    begin
                        Qty := DecimalToXMLText("Transfer Line".Quantity);
                    end;

                    trigger OnAfterAssignVariable()
                    var
                        recTOLine: Record "Transfer Line";
                    begin
                        //MESSAGE(FORMAT(TODoc) + '-> Line ->' + FORMAT("Transfer Line"."Line No."));
                        //MESSAGE(FORMAT(TODoc) + '-> Line ->' + FORMAT(iLineNo));
                        //For Update
                        recTOLine.RESET;
                        recTOLine.SETRANGE("Document No.", TODoc);
                        recTOLine.SETRANGE("Line No.", "Transfer Line"."Line No.");
                        IF recTOLine.FINDFIRST() THEN BEGIN
                            //recTOLine.VALIDATE("Qty. to Ship" , XMLTextToDecimal(QtyToShip) );
                            recTOLine.Quantity := XMLTextToDecimal(Qty);
                            recTOLine.MODIFY();
                        END;
                        //For Update
                    end;
                }
                fieldelement(UOM; "Transfer Line"."Unit of Measure Code")
                {

                    trigger OnAfterAssignField()
                    var
                        recTOLine: Record "Transfer Line";
                    begin
                        recTOLine.RESET;
                        recTOLine.SETRANGE("Document No.", TODoc);
                        recTOLine.SETRANGE("Line No.", "Transfer Line"."Line No.");
                        IF recTOLine.FINDFIRST() THEN BEGIN
                            recTOLine."Unit of Measure Code" := "Transfer Line"."Unit of Measure Code";
                            recTOLine.MODIFY();
                        END;
                    end;
                }
                textelement(QtyToShip)
                {

                    trigger OnBeforePassVariable()
                    begin
                        QtyToShip := DecimalToXMLText("Transfer Line"."Qty. to Ship");
                    end;

                    trigger OnAfterAssignVariable()
                    var
                        recTOLine: Record "Transfer Line";
                    begin
                        recTOLine.RESET;
                        recTOLine.SETRANGE("Document No.", TODoc);
                        recTOLine.SETRANGE("Line No.", "Transfer Line"."Line No.");
                        IF recTOLine.FINDFIRST() THEN BEGIN
                            //recTOLine.VALIDATE("Qty. to Ship" , XMLTextToDecimal(QtyToShip) );
                            recTOLine."Qty. to Ship" := XMLTextToDecimal(QtyToShip);
                            recTOLine.MODIFY();
                        END;
                    end;
                }
                textelement(QtyShipped)
                {

                    trigger OnBeforePassVariable()
                    begin
                        QtyShipped := DecimalToXMLText("Transfer Line"."Quantity Shipped");
                    end;
                }
                textelement(QtyToReceive)
                {

                    trigger OnBeforePassVariable()
                    begin
                        QtyToReceive := DecimalToXMLText("Transfer Line"."Qty. to Receive");
                    end;

                    trigger OnAfterAssignVariable()
                    var
                        recTOLine: Record "Transfer Line";
                    begin
                        /*recTOLine.RESET;
                        recTOLine.SETRANGE("Document No.",TODoc);
                        recTOLine.SETRANGE("Line No.","Transfer Line"."Line No.");
                        IF recTOLine.FINDFIRST() THEN BEGIN
                          recTOLine.VALIDATE("Qty. to Receive" ,XMLTextToDecimal(QtyToReceive) );
                          recTOLine.MODIFY();
                        END;
                        */

                    end;
                }
                textelement(QtyReceived)
                {

                    trigger OnBeforePassVariable()
                    begin
                        QtyReceived := DecimalToXMLText("Transfer Line"."Quantity Received");
                    end;
                }

                trigger OnAfterGetRecord()
                var
                    recItem: Record Item;
                begin
                    IF "Transfer Line"."Item No." <> '' THEN BEGIN
                        recItem.RESET;
                        IF recItem.GET("Transfer Line"."Item No.") THEN BEGIN
                            ItemDesc := recItem.Description;
                        END;
                    END;
                end;

                trigger OnAfterInitRecord()
                begin
                    //"Purchase Line"."Document Type" := "Purchase Line"."Document Type"::Order;
                    //"Purchase Line".Type := "Purchase Line".Type::Item;
                end;

                trigger OnAfterInsertRecord()
                var
                    recTOLine: Record "Transfer Line";
                begin
                    IF "Transfer Line"."Document No." <> '' THEN BEGIN
                        TODoc := "Transfer Line"."Document No.";
                        iLineNo := "Transfer Line"."Line No.";
                        //MESSAGE(FORMAT("Transfer Line"."Line No." ));
                        recTOLine.RESET;
                        recTOLine.SETRANGE("Document No.", TODoc);
                        recTOLine.SETRANGE("Line No.", "Transfer Line"."Line No.");
                        IF recTOLine.FINDFIRST() THEN BEGIN
                            recTOLine.VALIDATE(Quantity, XMLTextToDecimal(Qty)); //for insert record
                            recTOLine.VALIDATE("Qty. to Ship", XMLTextToDecimal(QtyToShip)); //for insert record
                            recTOLine.VALIDATE("Qty. to Receive", XMLTextToDecimal(QtyToReceive)); //for insert record

                            //recTOLine.Quantity :=  XMLTextToDecimal(Qty) ;
                            recTOLine.MODIFY();
                        END;

                    END;

                    //MESSAGE(FORMAT(TODoc) + '-> Line ->' + FORMAT(iLineNo));
                end;

                trigger OnBeforeInsertRecord()
                begin
                    //PODoc := "Purchase Line"."Document No.";
                    //MESSAGE(PODoc);
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

    trigger OnPostXmlPort()
    var
        recTransferHeader: Record "Transfer Header";
        cPOPost: Codeunit "Purch.-Post";
    begin

        IF (TODoc <> '') THEN BEGIN
            recTransferHeader.RESET;
            recTransferHeader.SETRANGE("No.", TODoc);
            recTransferHeader.SETRANGE(Status, recTransferHeader.Status::Open);
            IF recTransferHeader.FINDFIRST() THEN BEGIN
                recTransferHeader.Status := recTransferHeader.Status::Released;
                recTransferHeader.MODIFY(TRUE)
            END;
        END;
    end;

    var
        TODoc: Code[20];
        iLineNo: Integer;

    local procedure DateToXMLText(Date: Date) XMLText: Text[30]
    begin
        XMLText := FORMAT(Date, 10, '<Year4>-<Month,2>-<Day,2>');
    end;

    local procedure XMLTextToDate(XMLText: Text[30]) Date: Date
    var
        Month: Integer;
        Day: Integer;
        Year: Integer;
    begin
        EVALUATE(Year, COPYSTR(XMLText, 1, 4));
        EVALUATE(Month, COPYSTR(XMLText, 6, 2));
        EVALUATE(Day, COPYSTR(XMLText, 9, 2));
        Date := DMY2DATE(Day, Month, Year);
    end;

    local procedure DecimalToXMLText(Amount: Decimal) XMLText: Text[30]
    var
        BeforePoint: Decimal;
        AfterPoint: Decimal;
        Places: Integer;
        Minus: Boolean;
    begin
        Minus := (Amount < 0);
        IF Minus THEN
            Amount := -Amount;
        BeforePoint := ROUND(Amount, 1, '<');
        AfterPoint := Amount - BeforePoint;
        Places := 0;
        WHILE ROUND(AfterPoint, 1) <> AfterPoint DO BEGIN
            AfterPoint := AfterPoint * 10;
            Places := Places + 1;
        END;
        XMLText :=
          FORMAT(BeforePoint, 0, 1) + '.' + CONVERTSTR(FORMAT(AfterPoint, Places, 1), ' ', '0');
        IF Minus THEN
            XMLText := '-' + XMLText;
    end;

    local procedure XMLTextToDecimal(XMLText: Text[30]) Amount: Decimal
    var
        BeforePoint: Decimal;
        AfterPoint: Decimal;
        BeforeText: Text[30];
        AfterText: Text[30];
        Minus: Boolean;
        Places: Integer;
        Point: Integer;
    begin
        IF STRLEN(XMLText) = 0 THEN
            EXIT(0);
        Minus := (XMLText[1] = '-');
        IF Minus THEN
            XMLText := DELSTR(XMLText, 1, 1);
        Point := STRLEN(XMLText);
        AfterText := '';
        WHILE (XMLText[Point] IN ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9']) AND
              (Point > 1)
        DO BEGIN
            Places := Places + 1;
            AfterText := ' ' + AfterText;
            AfterText[1] := XMLText[Point];
            Point := Point - 1;
        END;
        BeforeText := DELCHR(COPYSTR(XMLText, 1, Point), '=', '.,');
        EVALUATE(BeforePoint, BeforeText);
        EVALUATE(AfterPoint, AfterText);
        WHILE Places > 0 DO BEGIN
            AfterPoint := AfterPoint / 10;
            Places := Places - 1;
        END;
        Amount := BeforePoint + AfterPoint;
        IF Minus THEN
            Amount := -Amount;
    end;
}

