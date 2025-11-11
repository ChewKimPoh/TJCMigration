codeunit 50010 "Test Codeunit 1"
{

    trigger OnRun()
    begin
        /*
        CurrForm.SETSELECTIONFILTER(Rec);
        IF FINDSET THEN
          REPEAT
            ItemNo := "Item No.";
          UNTIL NEXT = 0;

        CLEARMARKS;
        MARKEDONLY(FALSE);
        CurrForm.UPDATE(FALSE);
        */

        // SetSelectionFilter is not working on form variable, and used only for CurrForm.
        /*
        ItemNo := '';
        ItemLedgerEntry.RESET;
        ItemLedgerEntry.SETCURRENTKEY("Item No.","Posting Date");
        ItemLedgerEntry.SETRANGE("Posting Date",010114D,270214D);
        CLEAR(ItemLedgerEntries);
        ItemLedgerEntries.SETTABLEVIEW(ItemLedgerEntry);
        ItemLedgerEntries.SetSelectionFilter(ItemLedgerEntry);
        If ItemLedgerEntry.FindSet Then
          Repeat
            ItemNo += (ItemLedgerEntry."Item No." + ' \');
          Until ItemLedgerEntry.Next = 0;

        Message('Item No. selected are: \' + ItemNo);
        ItemLedgerEntry.ClearMarks;
        ItemLedgerEntry.MarkedOnly(False);
        */

        /*
        PurchRcptHeader.RESET;
        MESSAGE('No. of Records is: %1',PurchRcptHeader.COUNT);
        */

        /*
        Counter := 0;
        Item.RESET;
        TotalCounter := Item.COUNT;

        Window.OPEN(
          'Processing Item... \' +
          'Item No.    #1#################### \' +
          'Description #2############################## \' +
          '@3@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');

        Item.RESET;
        IF Item.FINDFIRST THEN
          REPEAT
            Counter += 1;
            Window.UPDATE(1,Item."No.");
            Window.UPDATE(2,Item.Description);
            Window.UPDATE(3,ROUND(Counter / TotalCounter * 10000,1));

            Item."Search Description" := Item.Description;
            Item.MODIFY;
          UNTIL Item.NEXT = 0;

        Window.CLOSE;

        Counter := 0;
        Customer.RESET;
        TotalCounter := Customer.COUNT;

        Window.OPEN(
          'Processing Customer... \' +
          'Customer No. #1#################### \' +
          'Name         #2############################## \' +
          '@3@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
        Customer.RESET;
        IF Customer.FINDFIRST THEN
          REPEAT
            Counter += 1;
            Window.UPDATE(1,Customer."No.");
            Window.UPDATE(2,Customer.Name);
            Window.UPDATE(3,ROUND(Counter / TotalCounter * 10000,1));

            Customer."Search Name" := Customer.Name;
            Customer.MODIFY;
          UNTIL Customer.NEXT = 0;

        Window.CLOSE;

        Counter := 0;
        Vendor.RESET;
        TotalCounter := Vendor.COUNT;

        Window.OPEN(
          'Processing Vendor... \' +
          'Vendor No. #1#################### \' +
          'Name       #2############################## \' +
          '@3@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');

        Vendor.RESET;
        IF Vendor.FINDFIRST THEN
          REPEAT
            Counter += 1;
            Window.UPDATE(1,Vendor."No.");
            Window.UPDATE(2,Vendor.Name);
            Window.UPDATE(3,ROUND(Counter / TotalCounter * 10000,1));

            Vendor."Search Name" := Vendor.Name;
            Vendor.MODIFY;
          UNTIL Vendor.NEXT = 0;

        Window.CLOSE;
        */

        // Update Purch. Header / Line
        PurchHeader.RESET;
        IF PurchHeader.FINDSET THEN
            REPEAT
                Vendor.RESET;
                IF Vendor.GET(PurchHeader."Pay-to Vendor No.") THEN;
                PurchHeader."Pay-to Name" := Vendor.Name;
                IF Vendor.GET(PurchHeader."Buy-from Vendor No.") THEN;
                PurchHeader."Buy-from Vendor Name" := Vendor.Name;
                PurchHeader.MODIFY;
            UNTIL PurchHeader.NEXT = 0;

        PurchLine.RESET;
        IF PurchLine.FINDSET THEN
            REPEAT
                Item.RESET;
                IF PurchLine.Type = PurchLine.Type::Item THEN BEGIN
                    IF Item.GET(PurchLine."No.") THEN;
                    PurchLine.Description := Item.Description;
                    PurchLine.MODIFY;
                END;
            UNTIL PurchLine.NEXT = 0;

        SalesHeader.RESET;
        IF SalesHeader.FINDSET THEN
            REPEAT
                Customer.RESET;
                IF Customer.GET(SalesHeader."Sell-to Customer No.") THEN;
                SalesHeader."Sell-to Customer Name" := Customer.Name;
                IF Customer.GET(SalesHeader."Bill-to Customer No.") THEN;
                SalesHeader."Bill-to Name" := Customer.Name;
                SalesHeader.MODIFY;
            UNTIL SalesHeader.NEXT = 0;

        SalesLine.RESET;
        IF SalesLine.FINDSET THEN
            REPEAT
                Item.RESET;
                IF SalesLine.Type = SalesLine.Type::Item THEN BEGIN
                    IF Item.GET(SalesLine."No.") THEN;
                    SalesLine.Description := Item.Description;
                    SalesLine.MODIFY;
                END;
            UNTIL SalesLine.NEXT = 0;

    end;

    var
        ItemLedgerEntry: Record "Item Ledger Entry";
        PurchRcptHeader: Record "Purch. Rcpt. Header";
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        PurchHeader: Record "Purchase Header";
        PurchLine: Record "Purchase Line";
        Item: Record Item;
        Customer: Record Customer;
        Vendor: Record Vendor;
        ItemLedgerEntries: Page "Item Ledger Entries";
        ItemNo: Text[1024];
        Counter: Integer;
        TotalCounter: Integer;
        Window: Dialog;
}

