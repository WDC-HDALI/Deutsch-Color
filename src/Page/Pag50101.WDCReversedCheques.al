page 50101 "WDC Reversed Cheques"
{
    Caption = 'Reversed Cheque';
    ApplicationArea = Basic, Suite;
    PageType = List;
    SourceTable = "Cheque Header";
    SourceTableView = where("Cheque Reversed" = filter(true));
    UsageCategory = Lists;
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Cheque No."; Rec."Cheque No.")
                {
                }
                field("Cheque/Traite"; Rec."Cheque/Traite")
                {
                }
                field("Cheque Value"; Rec."Cheque Value")
                {
                }
                field(Comment; Rec.Comment)
                {
                }
                field("Starting Date"; Rec."Starting Date")
                {
                }
                field("Due Date"; Rec."Due Date")
                {
                }
                field("Customer No."; Rec."Customer No.")
                {
                }
                field("Customer Name"; Rec."Customer Name")
                {
                }
                field("Cheque Register No."; Rec."Cheque Register No.")
                {
                }
                field(Status; Rec.Status)
                {
                }
                field("Reason of Reverse Transcation"; Rec."Reason of Reverse Transcation")
                {
                }
            }
        }
    }
    actions
    {
        area(Reporting)
        {
            action("Cheque Analytic Report")
            {
            }
            action("Cheque Summary Report")
            {
            }
        }
    }
}

