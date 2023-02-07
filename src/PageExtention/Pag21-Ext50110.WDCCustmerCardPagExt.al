pageextension 50110 "WDCCustmerCardPagExt" extends "Customer Card" //21
{

    layout
    {
        addafter("Balance Due (LCY)")
        {

            field("Shipment Not Invoiced"; Rec."Shipment Not Invoiced")
            {
                ApplicationArea = All;
            }

            field("Return Not Invoiced"; Rec."Return Not Invoiced")
            {
                ApplicationArea = All;
            }

        }
    }
    var

}