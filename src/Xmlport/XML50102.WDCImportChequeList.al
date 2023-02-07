xmlport 50102 "WDC Import Cheque List"
{
    Direction = Import;
    Format = VariableText;
    TextEncoding = UTF8;
    FieldDelimiter = '"';
    FieldSeparator = ';';
    UseRequestPage = false;
    Permissions = TableData "Cheque Header" = rimd, tabledata "Gen. Journal Line" = rimd;
    schema
    {
        textelement(Root)
        {
            tableelement("Cheque Header"; "Cheque Header")
            {
                AutoReplace = false;
                AutoSave = false;
                AutoUpdate = false;
                XmlName = 'ChequeList';

                fieldelement(ChequeNo; "Cheque Header"."Cheque No.")
                {

                }
                fieldelement(StartingDate; "Cheque Header"."Starting Date")
                {

                }
                fieldelement(DueDate; "Cheque Header"."Due Date")
                {

                }
                fieldelement(ChequeValue; "Cheque Header"."Cheque Value")
                {

                }
                fieldelement(Customer; "Cheque Header"."Customer No.")
                {

                }
                fieldelement(ChequeStatus; "Cheque Header"."Code Status")
                {

                }

                trigger OnBeforeInsertRecord()
                begin

                    if ChequeHeaderImport.Get("Cheque Header"."Cheque No.") then
                        currXMLport.Skip();

                    If "Cheque Header"."Cheque Value" = 0 then
                        error(Text0001, "Cheque Header"."Cheque No.");
                    If "Cheque Header"."Due Date" = 0D then
                        Error(Text0004, "Cheque Header"."Cheque No.");
                    If "Cheque Header"."Starting Date" = 0D then
                        Error(Text0005, "Cheque Header"."Cheque No.");
                    if not PaymentStatus.Get("Cheque Header"."Code Status") then
                        Error(Text0005, "Cheque Header"."Code Status");

                    lDocType := CopyStr("Cheque Header"."Code Status", 1, 3);

                    clear(ChequeHeaderImport);
                    ChequeHeaderImport.Validate("Cheque No.", "Cheque Header"."Cheque No.");
                    ChequeHeaderImport.Validate("Starting Date", "Cheque Header"."Starting Date");
                    ChequeHeaderImport.Validate("due Date", "Cheque Header"."Due Date");
                    ChequeHeaderImport.Validate("Cheque Value", "Cheque Header"."Cheque Value");
                    ChequeHeaderImport.Validate("Customer No.", "Cheque Header"."Customer No.");
                    if lDocType = 'TRT' then begin
                        ChequeHeaderImport.validate("Cheque/Traite", ChequeHeaderImport."Cheque/Traite"::Traite);
                        ChequeHeaderImport.Comment := Text008;
                    end else begin
                        ChequeHeaderImport.validate("Cheque/Traite", ChequeHeaderImport."Cheque/Traite"::Cheque);
                        ChequeHeaderImport.Comment := Text009;
                    end;
                    if ChequeHeaderImport.insert(true) then begin
                        //<<Insert first status
                        if LastLineNo = 0 then
                            LastLineNo := 1
                        else
                            LastLineNo += 1;

                        lGenjournalLine.Init();
                        lGenjournalLine."Journal Template Name" := 'PAYMENTS';
                        lGenjournalLine."Source Code" := 'PAYMENTJNL';
                        lGenjournalLine.InitNewLine(WorkDate, WorkDate, '', '', '', 0, '');
                        lGenjournalLine.validate("Document Type", lGenjournalLine."Document Type"::Payment);
                        lGenjournalLine.validate("Account Type", lGenjournalLine."Account Type"::Customer);
                        lGenjournalLine."Line No." := LastLineNo;
                        If lDocType = 'CH-' THEN begin
                            lBatchName.Reset();
                            lBatchName.SetRange("Payment Type", lGenjournalLine."Payment Type"::Cheque);
                            lBatchName.SetRange("First Step of Cheque", true);
                            if lBatchName.FindFirst() then begin
                                lGenjournalLine."Journal Batch Name" := lBatchName.Name;
                                lGenjournalLine."Account Type" := lBatchName."Account Type";
                                lGenjournalLine."Bal. Account No." := lBatchName."Bal. Account No.";
                            end;
                        END ELSE BEGIN
                            lBatchName.Reset();
                            lBatchName.SetRange("Payment Type", lGenjournalLine."Payment Type"::Traite);
                            lBatchName.SetRange("First Step of Traite", true);
                            if lBatchName.FindFirst() then begin
                                lGenjournalLine."Journal Batch Name" := lBatchName.Name;
                                lGenjournalLine."Account Type" := lBatchName."Account Type";
                                lGenjournalLine."Bal. Account No." := lBatchName."Bal. Account No.";
                            end;
                        END;

                        If lGenjournalLine.Insert then begin
                            lGenjournalLine.Validate("Cheque No.", "Cheque Header"."Cheque No.");
                            lGenjournalLine.Validate("Amount (LCY)", -"Cheque Header"."Cheque Value");
                            if lGenjournalLine.Modify then begin
                                ChequeHeaderImport."Cheque Generated" := true;
                                ChequeHeaderImport.Modify;
                            end;
                        end;
                        //>>Insert first status
                    end;
                end;

            }
        }

    }
    var
        ChequeHeaderImport: Record "Cheque Header";
        PaymentStatus: Record "WDC payment status";
        lGenjournalLine: record "Gen. Journal Line";
        lBatchName: record 232;
        ChequeCard: Page "Cheque Card";
        LastLineNo: Integer;
        Text0001: label 'Value cheque No. %1 must be not null ';
        Text0004: label 'Please check the due date of cheque No. %1';
        Text0005: label 'Please check the starting date of cheque No. %1';
        Text0006: label 'The code status %1 does not exist !';
        Text007: label 'Import completed';
        Text008: Label 'Imported Traite';
        Text009: Label 'Imported Cheque';
        lDocType: Code[10];

    trigger OnPostXmlPort()

    begin
        Message(Text007);
    end;
}