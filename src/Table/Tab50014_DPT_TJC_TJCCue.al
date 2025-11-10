table 50014 "TJC Cue"
{
    // Version No.         : TJCSG1.00
    // Developer           : DP.DST
    // Init. DEV. Date     : 16/05/2014
    // Date of Last Change :
    // Description:
    //   - New table to create TJC cue

    Caption = 'Binter Cue';

    fields
    {
        field(1;"Primary Key";Code[10])
        {
            Caption = 'Primary Key';
        }
        field(100;"Sales Orders - Open";Integer)
        {
            CalcFormula = Count("Sales Header" WHERE (Document Type=FILTER(Order),
                                                      Status=FILTER(Open)));
            Caption = 'Sales Orders - Open';
            Description = '**Start Copy from Table Sales Cue**';
            Editable = false;
            FieldClass = FlowField;
        }
        field(105;"Sales Orders - Released";Integer)
        {
            CalcFormula = Count("Sales Header" WHERE (Document Type=FILTER(Order),
                                                      Status=FILTER(Released)));
            Caption = 'Sales Orders - Released';
            Editable = false;
            FieldClass = FlowField;
        }
        field(110;"Ready to Ship";Integer)
        {
            CalcFormula = Count("Sales Header" WHERE (Document Type=FILTER(Order),
                                                      Status=FILTER(Released),
                                                      Ship=FILTER(No),
                                                      Shipment Date=FIELD(Date Filter2)));
            Caption = 'Ready to Ship';
            Editable = false;
            FieldClass = FlowField;
        }
        field(120;Delayed;Integer)
        {
            CalcFormula = Count("Sales Header" WHERE (Document Type=FILTER(Order),
                                                      Status=FILTER(Released),
                                                      Shipment Date=FIELD(Date Filter1)));
            Caption = 'Delayed';
            Editable = false;
            FieldClass = FlowField;
        }
        field(130;"Sales Return Orders - All";Integer)
        {
            CalcFormula = Count("Sales Header" WHERE (Document Type=FILTER(Return Order),
                                                      Status=FILTER(Open)));
            Caption = 'Sales Return Orders - All';
            Editable = false;
            FieldClass = FlowField;
        }
        field(140;"Sales Credit Memos - All";Integer)
        {
            CalcFormula = Count("Sales Header" WHERE (Document Type=FILTER(Credit Memo),
                                                      Status=FILTER(Open)));
            Caption = 'Sales Credit Memos - All';
            Editable = false;
            FieldClass = FlowField;
        }
        field(150;"Partially Shipped";Integer)
        {
            CalcFormula = Count("Sales Header" WHERE (Document Type=FILTER(Order),
                                                      Status=FILTER(Released),
                                                      Ship=FILTER(Yes),
                                                      Completely Shipped=FILTER(No),
                                                      Shipment Date=FIELD(Date Filter2)));
            Caption = 'Partially Shipped';
            Editable = false;
            FieldClass = FlowField;
        }
        field(160;"Sales Invoices - All";Integer)
        {
            CalcFormula = Count("Sales Header" WHERE (Document Type=FILTER(Invoice)));
            Caption = 'Sales Invoices - All';
            Editable = false;
            FieldClass = FlowField;
        }
        field(170;"Not Invoiced (Sales)";Integer)
        {
            CalcFormula = Count("Sales Header" WHERE (Document Type=FILTER(Order),
                                                      Completely Shipped=FILTER(Yes),
                                                      Invoice=FILTER(No)));
            Caption = 'Not Invoiced';
            Editable = false;
            FieldClass = FlowField;
        }
        field(180;"Partially Invoiced (Sales)";Integer)
        {
            CalcFormula = Count("Sales Header" WHERE (Document Type=FILTER(Order),
                                                      Completely Shipped=FILTER(Yes),
                                                      Invoice=FILTER(Yes)));
            Caption = 'Partially Invoiced';
            Description = '**End Copy from Table Sales Cue**';
            Editable = false;
            FieldClass = FlowField;
        }
        field(500;"To Send or Confirm";Integer)
        {
            CalcFormula = Count("Purchase Header" WHERE (Document Type=FILTER(Order),
                                                         Status=FILTER(Open)));
            Caption = 'To Send or Confirm';
            Description = '**Start Copy from Table Purchase Cue**';
            Editable = false;
            FieldClass = FlowField;
        }
        field(510;"Upcoming Orders";Integer)
        {
            CalcFormula = Count("Purchase Header" WHERE (Document Type=FILTER(Order),
                                                         Status=FILTER(Released),
                                                         Expected Receipt Date=FIELD(Date Filter1)));
            Caption = 'Upcoming Orders';
            Editable = false;
            FieldClass = FlowField;
        }
        field(520;"Outstanding Purch. Orders";Integer)
        {
            CalcFormula = Count("Purchase Header" WHERE (Document Type=FILTER(Order),
                                                         Status=FILTER(Released),
                                                         Receive=FILTER(Yes),
                                                         Completely Received=FILTER(No)));
            Caption = 'Outstanding Purch. Orders';
            Editable = false;
            FieldClass = FlowField;
        }
        field(530;"Purch. Return Orders - All";Integer)
        {
            CalcFormula = Count("Purchase Header" WHERE (Document Type=FILTER(Return Order)));
            Caption = 'Purch. Return Orders - All';
            Editable = false;
            FieldClass = FlowField;
        }
        field(540;"Not Invoiced (Purch)";Integer)
        {
            CalcFormula = Count("Purchase Header" WHERE (Document Type=FILTER(Order),
                                                         Completely Received=FILTER(Yes),
                                                         Invoice=FILTER(No)));
            Caption = 'Not Invoiced';
            Editable = false;
            FieldClass = FlowField;
        }
        field(550;"Partially Invoiced (Purch)";Integer)
        {
            CalcFormula = Count("Purchase Header" WHERE (Document Type=FILTER(Order),
                                                         Completely Received=FILTER(Yes),
                                                         Invoice=FILTER(Yes)));
            Caption = 'Partially Invoiced';
            Editable = false;
            FieldClass = FlowField;
        }
        field(560;"Purch. Credit Memo - All";Integer)
        {
            CalcFormula = Count("Purchase Header" WHERE (Document Type=FILTER(Credit Memo)));
            Caption = 'Purch. Credit Memo - All';
            Description = '**End Copy from Table Purchase Cue**';
            Editable = false;
            FieldClass = FlowField;
        }
        field(1000;"Released Sales Orders - Today";Integer)
        {
            CalcFormula = Count("Sales Header" WHERE (Document Type=FILTER(Order),
                                                      Status=FILTER(Released),
                                                      Shipment Date=FIELD(Date Filter3),
                                                      Location Code=FIELD(Location Filter)));
            Caption = 'Released Sales Orders - Today';
            Description = '**Start Copy from Table Warehouse Basic Cue**';
            Editable = false;
            FieldClass = FlowField;
        }
        field(1010;"Posted Sales Shipments - Today";Integer)
        {
            CalcFormula = Count("Sales Shipment Header" WHERE (Posting Date=FIELD(Date Filter4),
                                                               Location Code=FIELD(Location Filter)));
            Caption = 'Posted Sales Shipments - Today';
            Editable = false;
            FieldClass = FlowField;
        }
        field(1020;"Expected Purch. Orders - Today";Integer)
        {
            CalcFormula = Count("Purchase Header" WHERE (Document Type=FILTER(Order),
                                                         Status=FILTER(Released),
                                                         Expected Receipt Date=FIELD(Date Filter3),
                                                         Location Code=FIELD(Location Filter)));
            Caption = 'Expected Purch. Orders - Today';
            Editable = false;
            FieldClass = FlowField;
        }
        field(1030;"Posted Purch. Receipts - Today";Integer)
        {
            CalcFormula = Count("Purch. Rcpt. Header" WHERE (Posting Date=FIELD(Date Filter4),
                                                             Location Code=FIELD(Location Filter)));
            Caption = 'Posted Purch. Receipts - Today';
            Editable = false;
            FieldClass = FlowField;
        }
        field(1040;"Inventory Picks - Today";Integer)
        {
            CalcFormula = Count("Warehouse Activity Header" WHERE (Type=FILTER(Invt. Pick),
                                                                   Shipment Date=FIELD(Date Filter3),
                                                                   Location Code=FIELD(Location Filter)));
            Caption = 'Inventory Picks - Today';
            Editable = false;
            FieldClass = FlowField;
        }
        field(1050;"Inventory Put-aways - Today";Integer)
        {
            CalcFormula = Count("Warehouse Activity Header" WHERE (Type=FILTER(Invt. Put-away),
                                                                   Shipment Date=FIELD(Date Filter3),
                                                                   Location Code=FIELD(Location Filter)));
            Caption = 'Inventory Put-aways - Today';
            Description = '**End Copy from Table Warehouse Basic Cue**';
            Editable = false;
            FieldClass = FlowField;
        }
        field(1500;"Overdue Sales Documents";Integer)
        {
            CalcFormula = Count("Cust. Ledger Entry" WHERE (Document Type=FILTER(Invoice|Credit Memo),
                                                            Due Date=FIELD(Overdue Date Filter),
                                                            Open=CONST(Yes)));
            Caption = 'Overdue Sales Documents';
            Description = '**Start Copy from Table Financial Cue**';
            FieldClass = FlowField;
        }
        field(1510;"Purch. Invoices Due Today";Integer)
        {
            CalcFormula = Count("Vendor Ledger Entry" WHERE (Document Type=FILTER(Invoice|Credit Memo),
                                                             Due Date=FIELD(Due Date Filter),
                                                             Open=CONST(Yes)));
            Caption = 'Purch. Invoices Due Today';
            FieldClass = FlowField;
        }
        field(1520;"Customers - Blocked";Integer)
        {
            CalcFormula = Count(Customer WHERE (Blocked=FILTER(<>' ')));
            Caption = 'Customers - Blocked';
            FieldClass = FlowField;
        }
        field(1530;"Vendors - Blocked";Integer)
        {
            CalcFormula = Count(Vendor WHERE (Blocked=FILTER(<>' ')));
            Caption = 'Vendors - Blocked';
            FieldClass = FlowField;
        }
        field(1540;"Vendors - Payment on Hold";Integer)
        {
            CalcFormula = Count(Vendor WHERE (Blocked=FILTER(Payment)));
            Caption = 'Vendors - Payment on Hold';
            Description = '**End Copy from Table Financial Cue**';
            FieldClass = FlowField;
        }
        field(50000;"Date Filter1";Date)
        {
            Caption = 'Date Filter';
            Editable = false;
            FieldClass = FlowFilter;
        }
        field(50001;"Date Filter2";Date)
        {
            Caption = 'Date Filter2';
            Editable = false;
            FieldClass = FlowFilter;
        }
        field(50002;"Date Filter3";Date)
        {
            Caption = 'Date Filter2';
            Editable = false;
            FieldClass = FlowFilter;
        }
        field(50003;"Date Filter4";Date)
        {
            Caption = 'Date Filter2';
            Editable = false;
            FieldClass = FlowFilter;
        }
        field(50004;"Due Date Filter";Date)
        {
            Caption = 'Due Date Filter';
            Editable = false;
            FieldClass = FlowFilter;
        }
        field(50005;"Overdue Date Filter";Date)
        {
            Caption = 'Overdue Date Filter';
            FieldClass = FlowFilter;
        }
        field(50100;"Location Filter";Code[10])
        {
            Caption = 'Location Filter';
            FieldClass = FlowFilter;
        }
    }

    keys
    {
        key(Key1;"Primary Key")
        {
        }
    }

    fieldgroups
    {
    }
}

