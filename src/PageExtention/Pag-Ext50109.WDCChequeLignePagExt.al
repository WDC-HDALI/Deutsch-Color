pageextension 50109 "WDC ChequeLignePagExt" extends "Cheque Lines"
{
    layout
    {

        addbefore("Remaining Amount to Cheque")
        {
            field("Remaining Amount invoice"; Rec."Remaining Amount invoice")
            {
                Editable = false;
                Caption = 'Remaining Amount to Invoice';
            }
        }
        modify("Remaining Amount to Cheque")
        {
            Visible = false;
        }
    }

    trigger OnAfterGetRecord()
    begin
        Rec."Remaining Amount invoice" := 0;
        Rec."Remaining Amount invoice" := Rec.CalcuateRemaininAmountInvoice(Rec."Invoice No.");
        CurrPage.Update(false);
    end;

    var
        RemainingAmount: Decimal;
}