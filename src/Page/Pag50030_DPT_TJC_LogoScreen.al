page 50030 "Logo Screen"
{
    PageType = Card;

    layout
    {
        area(content)
        {
            field(welcome; '')
            {
                CaptionClass = FORMAT('Welcome ' + USERID + ' to ' + COMPANYNAME);
                Editable = false;
            }
            field(recCI_Name; recCI.Name)
            {
                Editable = false;
                Visible = false;
            }
            field(Text001; '')
            {
                CaptionClass = Text001;
            }
            field(Text000; '')
            {
                CaptionClass = Text000;
            }
            field(recCI_Picture; recCI.Picture)
            {
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        recCI.GET;
        recCI.CALCFIELDS(recCI.Picture);
    end;

    var
        recCI: Record "Company Information";
        recPic: Record Item;
        Text000: Label 'Implemented By:';
        Text001: Label 'DP Technology Pte Ltd';
}

