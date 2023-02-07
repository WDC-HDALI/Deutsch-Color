pageextension 50100 "WDC GenJournalPagExt" extends "General Journal" //39
{
    layout
    {
        addafter("Currency Code")
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
            field("Customer No."; Rec."Customer No.")
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