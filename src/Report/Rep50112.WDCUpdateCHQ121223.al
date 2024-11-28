report 50112 "WDC Update CHQ121223"
{
    Permissions = tabledata "Cust. Ledger Entry" = rimd, tabledata "Detailed Cust. Ledg. Entry" = rimd,
    tabledata "cheque Header" = rimd, tabledata "G/L Entry" = rimd, tabledata "Cheque Line" = rimd;

    dataset
    {
        dataitem(Integer; Integer)
        {
            DataItemTableView = where(Number = const(1));
            trigger OnAfterGetRecord()
            begin
                If not Confirm('voulez vous modifier les cheques') then
                    exit;
                Update_Zit4001542();
                Update_FT04103();
            end;
        }
    }
    trigger OnPostReport()
    begin
        Message('updated');
    end;

    procedure Update_Zit4001542()
    var
        DetCustLedg3: Record "Detailed Cust. Ledg. Entry";
        DetCustLedg4: Record "Detailed Cust. Ledg. Entry";
        DetCustLedg5: Record "Detailed Cust. Ledg. Entry";
        CustLedgEntries: Record "Cust. Ledger Entry";//21
    begin
        DetCustLedg3.Reset();
        DetCustLedg3.SetFilter("Entry No.", '74752|74865|74893|295322|297294');
        if DetCustLedg3.FindSet() then
            repeat
                DetCustLedg3.Delete();
            until DetCustLedg3.Next() = 0;
    end;

    procedure Update_FT04103()
    var
        DetCustLedg3: Record "Detailed Cust. Ledg. Entry";
        DetCustLedg4: Record "Detailed Cust. Ledg. Entry";
        DetCustLedg5: Record "Detailed Cust. Ledg. Entry";
        CustLedgEntries: Record "Cust. Ledger Entry";//21
    begin
        if DetCustLedg3.Get(77575) then
            DetCustLedg3.Delete();

        if CustLedgEntries.Get(697848) Then begin
            CustLedgEntries.Open := false;
            CustLedgEntries.Modify();
        end
    end;



}
