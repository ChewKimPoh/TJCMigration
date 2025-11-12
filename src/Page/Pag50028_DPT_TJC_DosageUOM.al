page 50028 "Dosage UOM"
{
    Caption = 'Item Units of Measure';
    DataCaptionFields = "Item No.";
    Editable = false;
    PageType = List;
    SourceTable = "Item Unit of Measure";

    layout
    {
        area(content)
        {
            repeater(control1)
            {
                field("Item No."; Rec."Item No.")
                {
                    Visible = false;
                }
                field(Code; Rec.Code)
                {
                }
                field("Qty. per Unit of Measure"; Rec."Qty. per Unit of Measure")
                {
                }
                field(Description; Description)
                {
                }
                field(Height; Rec.Height)
                {
                    Visible = false;
                }
                field(Width; Rec.Width)
                {
                    Visible = false;
                }
                field(Length; Rec.Length)
                {
                    Visible = false;
                }
                field(Cubage; Rec.Cubage)
                {
                    Visible = false;
                }
                field(Weight; Rec.Weight)
                {
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        UOM.GET(Rec.Code);
        Description := UOM.Description;
    end;

    var
        UOM: Record "Unit of Measure";
        Description: Text[10];
}

