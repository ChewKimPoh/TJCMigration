xmlport 50006 "TO Header List"
{
    UseDefaultNamespace = true;

    schema
    {
        textelement(TOReleaseList)
        {
            tableelement("Transfer Header"; "Transfer Header")
            {
                AutoReplace = true;
                AutoSave = true;
                XmlName = 'TO';
                SourceTableView = SORTING("No.") WHERE(Status = CONST(0));
                fieldelement(No; "Transfer Header"."No.")
                {

                    trigger OnAfterAssignField()
                    var
                        recTransferHeader: Record "Transfer Header";
                    begin
                        IF "Transfer Header"."No." <> '' THEN BEGIN
                            TODoc := "Transfer Header"."No.";
                            recTransferHeader.RESET;
                            IF recTransferHeader.GET("Transfer Header"."No.") THEN BEGIN
                                recTransferHeader.Status := recTransferHeader.Status::Open;
                                recTransferHeader.MODIFY()
                            END;
                        END;
                    end;
                }
                fieldelement(FromLoc; "Transfer Header"."Transfer-from Code")
                {
                    FieldValidate = Yes;

                    trigger OnAfterAssignField()
                    var
                        recTransferHeader: Record "Transfer Header";
                    begin
                        IF (TODoc <> '') THEN BEGIN
                            recTransferHeader.RESET;
                            IF recTransferHeader.GET(TODoc) THEN BEGIN
                                //recTransferHeader."Transfer-from Code" := "Transfer Header"."Transfer-from Code";
                                recTransferHeader.VALIDATE("Transfer-from Code", "Transfer Header"."Transfer-from Code");
                                recTransferHeader.MODIFY(TRUE)
                            END;
                        END;
                    end;
                }
                fieldelement(ToLoc; "Transfer Header"."Transfer-to Code")
                {
                    FieldValidate = Yes;

                    trigger OnAfterAssignField()
                    var
                        recTransferHeader: Record "Transfer Header";
                    begin
                        IF (TODoc <> '') THEN BEGIN
                            recTransferHeader.RESET;
                            IF recTransferHeader.GET(TODoc) THEN BEGIN
                                //recTransferHeader."Transfer-to Code" := "Transfer Header"."Transfer-to Code";
                                recTransferHeader.VALIDATE("Transfer-to Code", "Transfer Header"."Transfer-to Code");
                                recTransferHeader.MODIFY(TRUE)
                            END;
                        END;
                    end;
                }
                textelement(ShipmentDate)
                {

                    trigger OnBeforePassVariable()
                    begin
                        //MESSAGE(DateToXMLText("Transfer Header"."Shipment Date"));
                        ShipmentDate := DateToXMLText("Transfer Header"."Shipment Date");
                    end;

                    trigger OnAfterAssignVariable()
                    var
                        recTransferHeader: Record "Transfer Header";
                    begin
                        //MESSAGE(ShipmentDate + ' TONO. -> ' + TODoc);
                        IF (TODoc <> '') THEN BEGIN
                            recTransferHeader.RESET;
                            IF recTransferHeader.GET(TODoc) THEN BEGIN
                                recTransferHeader."Shipment Date" := XMLTextToDate(ShipmentDate);
                                recTransferHeader.MODIFY(TRUE)
                            END;
                        END;
                    end;
                }
                textelement(ReceiptDate)
                {

                    trigger OnBeforePassVariable()
                    begin
                        ReceiptDate := DateToXMLText("Transfer Header"."Receipt Date");
                    end;

                    trigger OnAfterAssignVariable()
                    var
                        recTransferHeader: Record "Transfer Header";
                    begin
                        IF (TODoc <> '') THEN BEGIN
                            recTransferHeader.RESET;
                            IF recTransferHeader.GET(TODoc) THEN BEGIN
                                recTransferHeader."Receipt Date" := XMLTextToDate(ReceiptDate);
                                recTransferHeader.MODIFY(TRUE)
                            END;
                        END;
                    end;
                }
                textelement(PostingDate)
                {

                    trigger OnBeforePassVariable()
                    begin
                        PostingDate := DateToXMLText("Transfer Header"."Posting Date");
                    end;

                    trigger OnAfterAssignVariable()
                    var
                        recTransferHeader: Record "Transfer Header";
                    begin
                        IF (TODoc <> '') THEN BEGIN
                            recTransferHeader.RESET;
                            IF recTransferHeader.GET(TODoc) THEN BEGIN
                                recTransferHeader."Posting Date" := XMLTextToDate(PostingDate);
                                recTransferHeader.MODIFY(TRUE)
                            END;
                        END;
                    end;
                }
                fieldelement(Status; "Transfer Header".Status)
                {
                }

                trigger OnAfterInsertRecord()
                begin
                    IF "Transfer Header"."No." <> '' THEN BEGIN
                        TODoc := "Transfer Header"."No.";
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

    trigger OnPostXmlPort()
    var
        recTransferHeader: Record "Transfer Header";
    begin
        IF (TODoc <> '') THEN BEGIN
            recTransferHeader.RESET;
            IF recTransferHeader.GET(TODoc) THEN BEGIN
                //recTransferHeader."Posting Date" := XMLTextToDate(PostingDate) ; //add for new insert
                //recTransferHeader."Receipt Date" := XMLTextToDate(ReceiptDate) ; //add for new insert
                //recTransferHeader."Shipment Date" := XMLTextToDate(ShipmentDate) ; //add for new insert

                recTransferHeader.VALIDATE("Posting Date", XMLTextToDate(PostingDate)); //add for new insert
                recTransferHeader.VALIDATE("Receipt Date", XMLTextToDate(ReceiptDate)); //add for new insert
                recTransferHeader.VALIDATE("Shipment Date", XMLTextToDate(ShipmentDate)); //add for new inse
                                                                                          //recTransferHeader.Status:= recTransferHeader.Status::Released;
                recTransferHeader.MODIFY(TRUE)
            END;
        END;
    end;

    var
        TODoc: Code[20];

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

