report 50103 "WDC Update Cheque Code"
{
    ProcessingOnly = true;
    UsageCategory = ReportsAndAnalysis;
    EnableHyperlinks = true;
    Permissions = TableData "Cheque Header" = rimd;

    dataset
    {
        dataitem("Cheque Header"; "Cheque Header")
        {
            RequestFilterFields = "Cheque No.";

            trigger OnAfterGetRecord()
            begin
                //Block cheques
                ChequeToRename.Get("Cheque Header"."Cheque No.");
                ChequeToRename.Blocked := true;
                if StrLen(ChequeToRename.Comment) = 0 then
                    ChequeToRename.Comment := Text001;
                ChequeToRename.Modify();

                //Rename cheque No.
                if (StrPos("Cheque Header"."Cheque No.", '_OLD')) <> 0 then
                    CurrReport.Skip();
                if StrLen("Cheque Header"."Cheque No.") < 17 then
                    ChequeToRename.Rename("Cheque Header"."Cheque No." + '_OLD')
                else
                    if StrLen("Cheque Header"."Cheque No.") = 17 then
                        ChequeToRename.Rename("Cheque Header"."Cheque No." + '_OL')
                    else
                        if StrLen("Cheque Header"."Cheque No.") = 18 then
                            ChequeToRename.Rename("Cheque Header"."Cheque No." + '_O')
                        else
                            if StrLen("Cheque Header"."Cheque No.") = 19 then
                                ChequeToRename.Rename("Cheque Header"."Cheque No." + '_');
            end;
        }
    }
    var
        ChequeToRename: Record "Cheque Header";
        Text001: label 'Old cheque blocked';
}