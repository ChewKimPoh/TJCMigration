page 50006 "Stock Take List"
{
    InsertAllowed = false;
    PageType = Worksheet;
    SourceTable = "Stock Take";

    layout
    {
        area(content)
        {
            field(BatchName1; Rec."Batch Name")
            {
                TableRelation = "Item Journal Batch".Name WHERE("Journal Template Name" = CONST('PHYS. INVE'));

                trigger OnValidate()
                begin
                    //    SETRANGE("Batch Name",Batch.Name);
                    //       CurrForm.UPDATE;
                    //CurrForm.UPDATE(FALSE)  ;;
                    BatchNameOnAfterValidate;
                end;
            }
            repeater(control1)
            {
                Editable = true;
                field(Status; Rec.Status)
                {
                }
                field(BatchName2; Rec."Batch Name")
                {
                    Editable = false;
                }
                field(Date; Rec.Date)
                {
                    Editable = false;
                }
                field("Item Code"; Rec."Item Code")
                {
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                    Editable = false;
                }
                field("Lot No."; Rec."Lot No.")
                {
                    Editable = true;
                }
                field(Remark; Rec.Remark)
                {
                }
                field(Location; Rec.Location)
                {
                    Editable = false;
                }
                field(Bin; Rec.Bin)
                {
                    Editable = false;
                }
                field("System Quantity"; Rec."System Quantity")
                {
                    Caption = 'Qty. (Calculated)';
                    Editable = false;
                }
                field(Quantity; Rec.Quantity)
                {
                    Caption = 'Qty. (Phys. Inventory)';
                    Editable = false;
                }
                field("Qty (Difference)"; Rec."Qty (Difference)")
                {
                    Editable = false;
                }
                field(UserCode; Rec.UserCode)
                {
                    Editable = false;
                }
                field(PDACode; Rec.PDACode)
                {
                    Editable = false;
                }
            }
            field(Text000; '')
            {
                CaptionClass = Text000;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Compare Stock Inventory")
            {
                Caption = 'Compare Stock Inventory';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    BIZLayer."Compare Stock Inventory"(Batch.Name);
                    CurrPage.UPDATE;
                end;
            }
        }
    }

    trigger OnInit()
    begin

        Rec.RESET;
        Rec.FILTERGROUP(2);
        Rec.SETRANGE("Batch Name", '');
        Rec.FILTERGROUP(0);
    end;

    trigger OnOpenPage()
    begin
        IF Batch.FIND('-') THEN;
    end;

    var
        Batch: Record "Item Journal Batch";
        location: Record Location;
        BIZLayer: Codeunit "BizLayer Entry Point";
        Text000: Label 'Batch Name';

    local procedure BatchNameOnAfterValidate()
    begin
        Rec.RESET;
        Rec.SETRANGE("Batch Name", Batch.Name);
        CurrPage.UPDATE(FALSE);
    end;
}

