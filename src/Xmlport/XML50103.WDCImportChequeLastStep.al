xmlport 50103 "WDC Import Cheque Last Step"
{
    Direction = Import;
    Format = VariableText;
    TextEncoding = UTF8;
    FieldDelimiter = '"';
    FieldSeparator = ';';
    UseRequestPage = false;
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

                    if not ChequeHeader.Get("Cheque Header"."Cheque No.") then
                        currXMLport.Skip();

                    if "Cheque Header"."Code Status" = ChequeHeader."Code Status" then
                        currXMLport.Skip();

                    If "Cheque Header"."Cheque Value" = 0 then
                        error(Text001, "Cheque Header"."Cheque No.");
                    if not PaymentStatus.Get("Cheque Header"."Code Status") then
                        Error(Text002, "Cheque Header"."Code Status");

                    lDocType := CopyStr("Cheque Header"."Code Status", 1, 3);

                    if LastLineNo = 0 then
                        LastLineNo := 1
                    else
                        LastLineNo += 1;

                    lGenjournalLine.Init();
                    lGenjournalLine."Journal Template Name" := 'PAYMENTS';
                    lGenjournalLine."Source Code" := 'PAYMENTJNL';
                    lGenjournalLine.InitNewLine(WorkDate, WorkDate, '', '', '', 0, '');
                    lGenjournalLine.validate("Document Type", lGenjournalLine."Document Type"::Payment);
                    lGenjournalLine."Line No." := LastLineNo;
                    lGenjournalLine.validate("Journal Batch Name", "Cheque Header"."Code Status");
                    lBatchName.Get('PAYMENTS', "Cheque Header"."Code Status");
                    lGenjournalLine."Account Type" := lBatchName."Account Type";
                    lGenjournalLine."Account No." := lBatchName."Account No.";
                    lGenjournalLine."Bal. Account No." := lBatchName."Bal. Account No.";

                    If lGenjournalLine.Insert then begin
                        lGenjournalLine.Validate("Cheque No.", "Cheque Header"."Cheque No.");
                        lGenjournalLine.Validate("Amount (LCY)", -"Cheque Header"."Cheque Value");
                        lGenjournalLine.Modify;
                    end;
                end;

            }
        }

    }
    var
        ChequeHeader: Record "Cheque Header";
        PaymentStatus: Record "WDC payment status";
        lGenjournalLine: record "Gen. Journal Line";
        lBatchName: record 232;
        LastLineNo: Integer;
        Text001: label 'Value cheque No. %1 must be not null ';
        Text002: label 'Please check the starting date of cheque No. %1';
        Text003: label 'Import completed';
        lDocType: Code[10];


    trigger OnPostXmlPort()
    begin
        Message(Text003);
    end;
}