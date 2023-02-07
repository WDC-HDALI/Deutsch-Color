page 50102 "WDC Page Update"
{
    Caption = 'Page Wedata';
    //ApplicationArea = Basic, Suite;
    PageType = List;
    //SourceTable = "Cheque Header";
    // SourceTableView = where("Cheque Reversed" = filter(true));
    UsageCategory = Lists;
    layout
    {
        area(content)
        {
        }
    }
    actions
    {
        area(Reporting)
        {
            action("Delete Cust. Ledger")
            {
                caption = 'Delete Cust. Ledger';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                RunObject = report "WDC Delete Det Cust Entries";

            }
            action(UpdateChequeStatus)
            {
                caption = 'Update cheque status';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                RunObject = report "WDC update cheque status";

            }
        }
    }
}

