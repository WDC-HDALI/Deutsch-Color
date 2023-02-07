pageextension 50101 "WDC GenJournalBatchPagExt" extends "General Journal Batches" //251
{
    layout
    {
        addafter("Reason Code")
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
            field("First Step of cheque"; Rec."First Step of cheque")
            {
                ApplicationArea = All;
            }
            field("Last Step of Cheque"; Rec."Last Step of Cheque")
            {
                ApplicationArea = All;
            }
            field("First Step of Traite"; Rec."First Step of Traite")
            {
                ApplicationArea = All;
            }
            field("Last Step of Traite"; Rec."Last Step of Traite")
            {
                ApplicationArea = All;
            }

        }
    }

    actions
    {

    }
}