page 50001 "Monthly Commission Report-old"
{
    // TJCSG1.00
    //  1. 07/03/2014  dp.dst
    //     - Converted from Form.
    //     - Found some inconsistencies on paramaters passed on function. Commented out first for Upgrade purpose.

    PageType = ConfirmationDialog;

    layout
    {
        area(content)
        {
            field("Start Date"; "Start Date")
            {
            }
            field("End Date"; "End Date")
            {
            }
            field(ProdGroupcode; ProdGroupcode)
            {
            }
            field("Product Group (Incentive)"; '')
            {
                CaptionClass = Text003;
            }
            field(Text002; '')
            {
                CaptionClass = Text002;
            }
            field(Text001; '')
            {
                CaptionClass = Text001;
            }
            field("Monthly Commission  Report"; '')
            {
                CaptionClass = Text000;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Submit)
            {
                Caption = 'Submit';
                //Promoted = true;
                //PromotedCategory = Process;

                trigger OnAction()
                begin
                    IF "Start Date" > "End Date" THEN
                        MESSAGE('Start Date cannot be later than End Date')
                    ELSE BEGIN
                        // CreateTable.RetrieveInvoice("Start Date","End Date",ProdGroupcode);   // wrong parameters.
                        CreateTable.ExportToExcel();
                    END;

                    CurrPage.CLOSE;
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        ProdGroupcode := 'SG';
        LastMonth := DATE2DMY(TODAY, 2);

        "Start Date" := DMY2DATE(1, LastMonth, 2007);
        "End Date" := CALCDATE('+1M', "Start Date");
        "End Date" := CALCDATE('-1D', "End Date");
    end;

    var
        "Start Date": Date;
        "End Date": Date;
        CreateTable: Codeunit CreateTempTable;

        // Note: Product Group is BC discontinued table
        //ProductGroup: Record "Product Group";
        ProdGroupcode: Code[10];
        LastMonth: Integer;
        "Date Expression": DateFormula;
        Text000: Label 'Monthly Commission  Report';
        Text001: Label 'Start Date';
        Text002: Label 'End Date';
        Text003: Label 'Product Group (Incentive)';
}

