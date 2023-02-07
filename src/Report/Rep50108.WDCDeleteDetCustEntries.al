report 50108 "WDC Delete Det Cust Entries"
{
    dataset
    {
        dataitem(DetCustLedgEntry;
        "Detailed Cust. Ledg. Entry")
        {
            RequestFilterFields = "Entry No.", "Entry Type", "Document No.", "Document Type";

            trigger OnAfterGetRecord()
            var
                lDetCustLegEntry: Record "Detailed Cust. Ledg. Entry";
                lCustLegEntry: Record "Cust. Ledger Entry";
            begin
                If not Confirm('voulez vous supprimer l''ecriture %1', true, DetCustLedgEntry."Entry No.") then
                    exit;
                If not Confirm('voulez vous supprimer l''ecriture %1', true, DetCustLedgEntry."Entry No.") then
                    exit;
                DetCustLedgEntry.Delete();
            end;
        }
    }
    var
        Open: Boolean;
        AmountLCY: Decimal;
        customerNo: Code[20];
}
