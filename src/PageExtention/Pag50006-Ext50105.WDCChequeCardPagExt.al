pageextension 50105 "WDCChequeCardPagExt" extends "Cheque Card" //50006
{
    layout
    {
        addafter(Status)
        {

            field("Description Status"; Rec."Description Status")
            {
                ApplicationArea = All;
            }
            field("Cheque Generated"; Rec."Cheque Generated")
            {
                ApplicationArea = All;
            }
            field(Blocked; Rec.Blocked)
            {
                ApplicationArea = all;
            }
            field("Collection date"; Rec."Collection date")
            {
                ApplicationArea = all;
            }
        }

    }

    actions
    {

        addafter("General Ledger Entries")
        {
            action("Generate Cheque")
            {
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                PromotedOnly = true;
                Image = CreateLedgerBudget;
                trigger OnAction()
                var
                    ltext0001: label 'Value %1 must be not null ';
                    ltext0002: label 'Are you sure to generate the current document';
                    ltext0003: label '%1 is already Generated';
                    ltext0004: label 'Please check the due date of %1';
                    ltext0005: label 'Please check the starting date of %1';
                    ltext0006: label 'Must input an invoice in cheque lines';
                    ltext0007: label 'Cheque is blocked, you can not generate it';
                    lchequeLines: record "Cheque Line";

                begin
                    Rec.TestField("Customer No.");
                    if rec.Blocked then
                        error(ltext0007);
                    If rec."Cheque Value" = 0 then
                        error(ltext0001, Rec."Cheque/Traite");
                    If rec."Due Date" = 0D then
                        Error(ltext0004, Rec."Cheque/Traite");
                    If rec."Starting Date" = 0D then
                        Error(ltext0005, Rec."Cheque/Traite");
                    If Rec."Cheque Generated" then
                        Error(ltext0003, Rec."Cheque/Traite");
                    If Not Confirm(Ltext0002) THEN
                        exit;
                    GenerateCheque;
                end;
            }
        }

    }
    trigger OnAfterGetRecord()
    begin
        // If Rec."Cheque Generated" Then
        //     CurrPage.Editable := false
        // else
        //     CurrPage.Editable := true;
        // CurrPage.Update(false);
    end;

    trigger OnOpenPage()
    begin
        // If Rec."Cheque Generated" Then
        //     CurrPage.Editable := false
        // else
        //     CurrPage.Editable := true;
        // CurrPage.Update(false);
    end;

    trigger OnAfterGetCurrRecord()
    begin
        // If Rec."Cheque Generated" Then
        //     CurrPage.Editable := false
        // else
        //     CurrPage.Editable := true;
        // CurrPage.Update(false);
    end;

    procedure GenerateCheque()
    Var
        lGenjournalLine: record "Gen. Journal Line";
        lpaymentStatus: Record 50100;
        lBatchName: record 232;
        ltext0001: label '%1 genereted';
        lchequeHeader: record "Cheque Header";
        lchequeLines: Record "Cheque Line";

    begin
        lGenjournalLine.Init();
        lGenjournalLine."Journal Template Name" := 'PAYMENTS';
        lGenjournalLine."Source Code" := 'PAYMENTJNL';
        lGenjournalLine.InitNewLine(WorkDate, WorkDate, '', '', '', 0, '');
        lGenjournalLine.validate("Document Type", lGenjournalLine."Document Type"::Payment);
        lGenjournalLine.validate("Account Type", lGenjournalLine."Account Type"::Customer);
        If Rec."Cheque/Traite" = Rec."Cheque/Traite"::Cheque THEN begin
            lGenjournalLine."Journal Batch Name" := SelectBatcNameFromPaymentStatus(lGenjournalLine."Payment Type"::Cheque);
            lGenjournalLine."Line No." := WDC_GetNewLineNo('PAYMENTS', SelectBatcNameFromPaymentStatus(lGenjournalLine."Payment Type"::Cheque));
            lBatchName.Reset();
            lBatchName.SetRange("Payment Type", lGenjournalLine."Payment Type"::Cheque);
            lBatchName.SetRange("First Step of Cheque", true);
            if lBatchName.FindFirst() then begin
                lGenjournalLine."Account Type" := lBatchName."Account Type";
                lGenjournalLine."Bal. Account No." := lBatchName."Bal. Account No.";
            end;
        END ELSE BEGIN
            lGenjournalLine."Journal Batch Name" := SelectBatcNameFromPaymentStatus(lGenjournalLine."Payment Type"::Traite);
            lGenjournalLine."Line No." := WDC_GetNewLineNo('PAYMENTS', SelectBatcNameFromPaymentStatus(lGenjournalLine."Payment Type"::Traite));
            lBatchName.Reset();
            lBatchName.SetRange("Payment Type", lGenjournalLine."Payment Type"::Traite);
            lBatchName.SetRange("First Step of Traite", true);
            if lBatchName.FindFirst() then begin
                lGenjournalLine."Account Type" := lBatchName."Account Type";
                lGenjournalLine."Bal. Account No." := lBatchName."Bal. Account No.";
            end;
        END;

        If lGenjournalLine.Insert then begin
            lGenjournalLine.Validate("Cheque No.", Rec."Cheque No.");
            lGenjournalLine.Validate("Amount (LCY)", -Rec."Cheque Value");
            lGenjournalLine."Invoices To Paid" := GetAllInvoiceToPaid(Rec."Cheque No.");
            IF lGenjournalLine.Modify THEN begin
                If lchequeHeader.Get(Rec."Cheque No.") then begin
                    lchequeHeader."Cheque Generated" := true;
                    lchequeHeader.Modify;
                end;
            end;
            Clear(lGenjournalLine);
            Message(ltext0001, lchequeHeader."Cheque/Traite");
            // CurrPage.Editable := false;
            // CurrPage.Update();
        end;
    end;

    procedure GetAmountFromChequeLines(pChequeNo: code[20]): Decimal
    var
        lchequeLines: record "Cheque Line";
    begin
        lchequeLines.Reset();
        lchequeLines.SetRange("Cheque No.", pChequeNo);
        if lchequeLines.FindFirst() then
            lchequeLines.CalcSums("Amount LCY");
        Exit(lchequeLines."Amount LCY");
    end;

    procedure GetAllInvoiceToPaid(pChequeNo: code[20]): Text[250]
    var
        lchequeLines: record "Cheque Line";
        AllInvoiceToPaid: Text;
    begin
        Clear(AllInvoiceToPaid);
        lchequeLines.Reset();
        lchequeLines.SetRange("Cheque No.", pChequeNo);
        if lchequeLines.FindFirst() then
            repeat
                If StrLen(AllInvoiceToPaid) <= 230 then
                    AllInvoiceToPaid := AllInvoiceToPaid + lchequeLines."Invoice No." + ' | ';
            Until lchequeLines.Next = 0;
        If StrLen(AllInvoiceToPaid) >= 2 then
            AllInvoiceToPaid := DelStr(AllInvoiceToPaid, StrLen(AllInvoiceToPaid) - 2, 2);
        Exit(AllInvoiceToPaid);
    end;



    procedure SelectBatcNameFromPaymentStatus(pPaymentType: Enum "WDC Payment Type"): code[20]
    var
        lBatchName: Record 232;
        ltext0001: Label 'There is no payment batch name configured for the first step';
    begin
        lBatchName.Reset();
        lBatchName.SetRange("Payment Type", pPaymentType);
        If pPaymentType = pPaymentType::Cheque then
            lBatchName.SetRange("First Step of Cheque", true)
        Else
            If pPaymentType = pPaymentType::Traite then
                lBatchName.SetRange("First Step of Traite", true);
        If lBatchName.FindFirst() then
            Exit(lBatchName.Name)
        else
            Error(ltext0001);
    end;

    procedure WDC_GetNewLineNo(TemplateName: Code[10]; BatchName: Code[10]): Integer
    var
        GenJournalLine: Record "Gen. Journal Line";
    begin
        GenJournalLine.Reset();
        GenJournalLine.SetRange("Journal Template Name", TemplateName);
        GenJournalLine.SetRange("Journal Batch Name", BatchName);
        if GenJournalLine.FindLast then
            exit(GenJournalLine."Line No." + 10000);
        exit(10000);
    end;

    var
        IsNoTGenerated: Boolean;

}