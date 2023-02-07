pageextension 50107 "WDC CustLegEntryPagExt" extends "Customer Ledger Entries" //25
{
    layout
    {
        addafter(Description)
        {

            field("Code Status"; Rec."Code Status")
            {
                ApplicationArea = All;
            }
            field("payment Type"; Rec."payment Type")
            {
                ApplicationArea = All;
            }
            field("Description Status"; Rec."Description Status")
            {
                ApplicationArea = All;
            }
            field("Cheque No."; Rec."Cheque No.")
            {
                ApplicationArea = All;
            }

            field("Sales person No."; Rec."Sales person No.")
            {
                ApplicationArea = All;
            }

        }
    }

    actions
    {

    }
}