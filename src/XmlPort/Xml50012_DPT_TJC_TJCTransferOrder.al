xmlport 50012 "TJC Transfer Order"
{
    UseDefaultNamespace = true;

    schema
    {
        textelement(TJCTO)
        {
            tableelement("Transfer Header"; "Transfer Header")
            {
                AutoReplace = true;
                AutoSave = true;
                XmlName = 'TJCTOHeader';
                SourceTableView = SORTING("No.") WHERE(Status = CONST(0));
                fieldelement(No; "Transfer Header"."External Document No.")
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
                                //    recTransferHeader.VALIDATE("Transfer-from Code","Transfer Header"."Transfer-from Code");
                                //    recTransferHeader.VALIDATE("Transfer-To Code","Transfer Header"."Transfer-To Code");
                                recTransferHeader.VALIDATE("Shipment Date", TODAY);
                                recTransferHeader.VALIDATE("Receipt Date", TODAY);
                                recTransferHeader.MODIFY()
                            END;
                        END;
                    end;
                }
                fieldelement(FromLoc; "Transfer Header"."Transfer-from Code")
                {
                }
                fieldelement(ToLoc; "Transfer Header"."Transfer-to Code")
                {
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
                        "Transfer Header"."Posting Date" := XMLTextToDate(PostingDate);
                        IF (TODoc <> '') THEN BEGIN
                            recTransferHeader.RESET;
                            IF recTransferHeader.GET(TODoc) THEN BEGIN
                                //recTransferHeader."Posting Date" := XMLTextToDate(PostingDate);
                                recTransferHeader.VALIDATE("Posting Date", XMLTextToDate(PostingDate));
                                recTransferHeader.VALIDATE("Shipment Date", XMLTextToDate(PostingDate));
                                recTransferHeader.VALIDATE("Receipt Date", XMLTextToDate(PostingDate));
                                recTransferHeader.MODIFY(TRUE)
                            END;
                        END;
                    end;
                }
                tableelement("Transfer Line"; "Transfer Line")
                {
                    LinkFields = "Document No." = FIELD("No.");
                    LinkTable = "Transfer Header";
                    XmlName = 'TJCTOLine';
                    textelement(LineNo)
                    {
                    }
                    fieldelement(ItemNo; "Transfer Line"."Item No.")
                    {
                    }
                    fieldelement(UOM; "Transfer Line"."Unit of Measure Code")
                    {
                    }
                    textelement(Qty)
                    {

                        trigger OnAfterAssignVariable()
                        begin
                            "Transfer Line".VALIDATE(Quantity, XMLTextToDecimal(Qty));
                        end;
                    }

                    trigger OnBeforeInsertRecord()
                    begin
                        LastLineNo += 10000;
                        "Transfer Line"."Line No." := LastLineNo;
                    end;
                }

                trigger OnAfterInsertRecord()
                var
                    recTransferHeader: Record "Transfer Header";
                    TempDimSetEntry: Record "Dimension Set Entry" temporary;
                    dimSetID: Integer;
                    DimMgt: Codeunit DimensionManagement;
                    recDimSetEntry1: Record "Dimension Set Entry";
                    recDimSetEntry: Record "Dimension Set Entry";
                    dimCode: Code[20];
                begin
                    IF "Transfer Header"."No." <> '' THEN BEGIN
                        TODoc := "Transfer Header"."No.";
                    END;

                    IF "Transfer Header"."Transfer-to Code" = 'TJC' THEN BEGIN
                        dimCode := "Transfer Header"."Transfer-from Code"
                    END ELSE BEGIN
                        dimCode := "Transfer Header"."Transfer-to Code";
                    END;

                    //Set Dim for dept
                    TempDimSetEntry.VALIDATE("Dimension Code", 'DEPT');//DEPARTMENT
                    TempDimSetEntry.VALIDATE("Dimension Value Code", dimCode);
                    TempDimSetEntry.INSERT;
                    dimSetID := 0;
                    dimSetID := DimMgt.GetDimensionSetID(TempDimSetEntry);
                    recDimSetEntry1.RESET;
                    recDimSetEntry1.SETFILTER(recDimSetEntry1."Dimension Set ID", '%1', dimSetID); // check if the ID is available
                    IF recDimSetEntry1.FINDFIRST THEN BEGIN

                    END ELSE BEGIN
                        IF TempDimSetEntry.FINDFIRST THEN
                            REPEAT
                                recDimSetEntry.RESET;
                                recDimSetEntry.INIT;
                                recDimSetEntry.VALIDATE(recDimSetEntry."Dimension Set ID", dimSetID);
                                recDimSetEntry.VALIDATE(recDimSetEntry."Dimension Code", TempDimSetEntry."Dimension Code");
                                recDimSetEntry.VALIDATE(recDimSetEntry."Dimension Value Code", TempDimSetEntry."Dimension Value Code");
                                recDimSetEntry.INSERT;
                            UNTIL TempDimSetEntry.NEXT = 0;
                    END;

                    IF (dimSetID > 0) THEN BEGIN
                        "Transfer Header".VALIDATE("Dimension Set ID", dimSetID);
                        "Transfer Header".VALIDATE("Shortcut Dimension 1 Code", dimCode);
                        "Transfer Header".MODIFY(TRUE);
                    END;

                    //Set Dim for dept
                end;

                trigger OnBeforeInsertRecord()
                var
                    recTransferHeader: Record "Transfer Header";
                    Location: Record Location;
                begin
                    //"Transfer Header".SetHideValidationDialog(TRUE);
                    //"Transfer Header".VALIDATE("Transfer-from Code","Transfer Header"."Transfer-from Code");
                    //"Transfer Header".VALIDATE("Transfer-To Code","Transfer Header"."Transfer-To Code");
                    //"Transfer Header".VALIDATE("Transfer-from Code",'AMK720');
                    //"Transfer Header".VALIDATE("Transfer-To Code",'CT449');

                    //AMK720  ,CT449
                    /*
                      recTransferHeader.RESET;
                      IF recTransferHeader.GET("Transfer Header"."No.") THEN BEGIN
                        //HideValidationDialog := TRUE;
                        recTransferHeader.SetHideValidationDialog(TRUE);
                    //    recTransferHeader.VALIDATE("Transfer-from Code","Transfer Header"."Transfer-from Code");
                        //recTransferHeader.VALIDATE("Transfer-To Code","Transfer Header"."Transfer-To Code");
                        recTransferHeader.VALIDATE("Transfer-from Code",'AMK720');
                        recTransferHeader.VALIDATE("Transfer-to Code",'CT449');
                        recTransferHeader.MODIFY(TRUE);
                      END;
                     */

                    IF Location.GET("Transfer Header"."Transfer-from Code") THEN BEGIN
                        "Transfer Header"."Transfer-from Name" := Location.Name;
                        "Transfer Header"."Transfer-from Name 2" := Location."Name 2";
                        "Transfer Header"."Transfer-from Address" := Location.Address;
                        "Transfer Header"."Transfer-from Address 2" := Location."Address 2";
                        "Transfer Header"."Transfer-from Post Code" := Location."Post Code";
                        "Transfer Header"."Transfer-from City" := Location.City;
                        "Transfer Header"."Transfer-from County" := Location.County;
                        "Transfer Header"."Trsf.-from Country/Region Code" := Location."Country/Region Code";
                        "Transfer Header"."Transfer-from Contact" := Location.Contact;
                    END;

                    IF Location.GET("Transfer Header"."Transfer-to Code") THEN BEGIN
                        "Transfer Header"."Transfer-to Name" := Location.Name;
                        "Transfer Header"."Transfer-to Name 2" := Location."Name 2";
                        "Transfer Header"."Transfer-to Address" := Location.Address;
                        "Transfer Header"."Transfer-to Address 2" := Location."Address 2";
                        "Transfer Header"."Transfer-to Post Code" := Location."Post Code";
                        "Transfer Header"."Transfer-to City" := Location.City;
                        "Transfer Header"."Transfer-to County" := Location.County;
                        "Transfer Header"."Trsf.-to Country/Region Code" := Location."Country/Region Code";
                        "Transfer Header"."Transfer-to Contact" := Location.Contact;
                    END;

                    "Transfer Header"."In-Transit Code" := 'OWN.LOG';
                    "Transfer Header".VALIDATE("Shipment Date", TODAY);
                    "Transfer Header".VALIDATE("Receipt Date", TODAY);

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

    trigger OnPreXmlPort()
    begin
        LastLineNo := 0;
    end;

    var
        TODoc: Code[20];
        LastLineNo: Integer;

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

