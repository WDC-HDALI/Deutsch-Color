
codeunit 50100 "ST PaymentSubscribers"
{
    trigger OnRun()
    begin

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"GenJnlManagement", 'OnAfterSetName', '', FALSE, FALSE)]
    local procedure OnAfterGetAccounts(var GenJournalLine: Record "Gen. Journal Line"; CurrentJnlBatchName: Code[10])
    var
        lBatchName: record 232;
        lGenJournalLine: record 81;
    begin
        IF Not lBatchName.Get(GenJournalLine."Journal Template Name", CurrentJnlBatchName) then
            Exit;
        lGenJournalLine.Reset();
        lGenJournalLine.SetRange("Journal Batch Name", CurrentJnlBatchName);
        if lGenJournalLine.FindFirst() then
            repeat
                lGenJournalLine."Code Status" := lBatchName."Code Status";
                lGenJournalLine."Payment Type" := lBatchName."Payment Type";
                lGenJournalLine."Description Status" := lBatchName."Description Status";
                lGenJournalLine.Modify;
            Until lGenJournalLine.Next = 0;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnAfterInitGLEntry', '', FALSE, FALSE)]
    local procedure OnAfterSetupNewLine(var GLEntry: Record "G/L Entry"; GenJournalLine: Record "Gen. Journal Line")
    begin
        IF GenJournalLine."Cheque No." <> '' then begin
            GLEntry."Cheque No." := GenJournalLine."Cheque No.";
            GLEntry."Customer No." := GenJournalLine."Customer No.";
            GLEntry."Sales person No." := GenJournalLine."Sales person No.";
            GLEntry."Code Status" := GenJournalLine."Code Status";
            GLEntry."Payment Type" := GenJournalLine."Payment Type";
            GLEntry."Description Status" := GenJournalLine."Description Status";
            SetCHQStatus(GenJournalLine."Cheque No.", GenJournalLine."Code Status");
            SetCustLedgerEntryStatus(GenJournalLine."Cheque No.", GenJournalLine."Code Status", GenJournalLine."Description Status");
        End;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnAfterInitCustLedgEntry', '', FALSE, FALSE)]
    local procedure OnAfterInitCustLedgEntry(var CustLedgerEntry: Record "Cust. Ledger Entry"; GenJournalLine: Record "Gen. Journal Line")
    Var

    begin
        IF GenJournalLine."Cheque No." <> '' then begin
            CustLedgerEntry."Cheque No." := GenJournalLine."Cheque No.";
            CustLedgerEntry."Customer No." := GenJournalLine."Customer No.";
            CustLedgerEntry."Sales person No." := GenJournalLine."Sales person No.";
            CustLedgerEntry."Code Status" := GenJournalLine."Code Status";
            CustLedgerEntry."Payment Type" := GenJournalLine."Payment Type";
            CustLedgerEntry."Description Status" := GenJournalLine."Description Status";

        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnAfterRunWithCheck', '', FALSE, FALSE)]
    local procedure OnAfterRunWithCheck(GenJnlLine: Record "Gen. Journal Line")
    var
        lChequeHeader: Record "Cheque Header";
    begin
        IF GenJnlLine."Cheque No." = '' then
            exit;
        if not lChequeHeader.Get(GenJnlLine."Cheque No.") then
            exit;
        lChequeHeader.TestField(Blocked, false);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnAfterRunWithoutCheck', '', FALSE, FALSE)]
    local procedure OnAfterRunWithoutCheck(GenJnlLine: Record "Gen. Journal Line")
    var
        lChequeHeader: Record "Cheque Header";
    begin
        IF GenJnlLine."Cheque No." = '' then
            exit;
        if not lChequeHeader.Get(GenJnlLine."Cheque No.") then
            exit;
        lChequeHeader.TestField(Blocked, false);
    end;

    [EventSubscriber(ObjectType::Page, Page::"Payment Journal", 'OnBeforeActionEvent', 'Post', FALSE, FALSE)]
    local procedure FilterChequeToPost(var Rec: Record "Gen. Journal Line")
    var
        Ltext001: Label 'Please select the rows to post';
    Begin
        Rec.SetRange("To Post", true);
        if Rec.IsEmpty Then
            Error(Ltext001);
    End;

    [EventSubscriber(ObjectType::Page, Page::"Payment Journal", 'OnBeforeActionEvent', 'Post and &Print', FALSE, FALSE)]
    local procedure FilterChequeToPostAndPrint(var Rec: Record "Gen. Journal Line")
    var
        Ltext001: Label 'Please select the rows to post';
    Begin
        Rec.SetRange("To Post", true);
        if Rec.IsEmpty Then
            Error(Ltext001);
    End;

    [EventSubscriber(ObjectType::Table, database::"Gen. Journal Line", 'OnAfterValidateEvent', 'Bal. Account Type', FALSE, FALSE)]
    local procedure OnAfterValidateEventBalAccType(var Rec: Record "Gen. Journal Line")
    var
    Begin
        If (Rec."Bal. Account Type" = Rec."Bal. Account Type"::Customer) and (Rec."Customer No." <> '') then begin
            Rec."Bal. Account No." := Rec."Customer No.";
        end;
    End;

    [EventSubscriber(ObjectType::Table, database::"Gen. Journal Line", 'OnAfterValidateEvent', 'Account Type', FALSE, FALSE)]
    local procedure OnAfterValidateEventAccType(var Rec: Record "Gen. Journal Line")
    var
    Begin
        If (Rec."Account Type" = Rec."Account Type"::Customer) and (Rec."Customer No." <> '') then begin
            Rec."Account No." := Rec."Customer No.";
        end;
    End;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnAfterPostGenJnlLine', '', FALSE, FALSE)]
    local procedure OnAfterPostGenJnlLine(var GenJournalLine: Record "Gen. Journal Line"; Balancing: Boolean)
    var
        lpaymentApply: Codeunit "WDC Payment Aplly";
        lchequeLines: record "Cheque Line";
        lCustLedgerEntry: Record "Cust. Ledger Entry";
        lCustLedgEntry: Record "Cust. Ledger Entry";
        lBatchName: record 232;
        Ltext001: Label 'The amount of this document must be equal or greater than the sum of the amounts LCY of the invoices';
        Ltext003: Label 'You have to fill the %1 of your document N°: %2, or delete this line and reinsert it';
        Ltext004: Label '%1 and %2 should have the same value ';
        lChequeCard: Page "Cheque Card";
        lChequeHeader: Record "Cheque Header";
    begin
        If (GenJournalLine."Cheque No." <> '') and (GenJournalLine."Customer No." = '') then
            Error(Ltext003, GenJournalLine.FieldCaption("Customer No."), GenJournalLine."Cheque No.");

        If (GenJournalLine."Account Type" = GenJournalLine."Account Type"::Customer) And (GenJournalLine."Cheque No." <> '') AND
         (GenJournalLine."Account No." <> GenJournalLine."Customer No.") then
            Error(Ltext004, GenJournalLine.FieldCaption("Account No."), GenJournalLine.FieldCaption("Customer No."));

        If (GenJournalLine."Bal. Account Type" = GenJournalLine."Bal. Account Type"::Customer) And
        (GenJournalLine."Cheque No." <> '') AND (GenJournalLine."Bal. Account No." <> GenJournalLine."Customer No.") then
            Error(Ltext004, GenJournalLine.FieldCaption("Bal. Account No."), GenJournalLine.FieldCaption("Customer No."));

        IF lchequeHeader.Get(GenJournalLine."Cheque No.") then
            IF lBatchName.Get(GenJournalLine."Journal Template Name", GenJournalLine."Journal Batch Name") then
                IF (lChequeHeader."Cheque Reversed") and (lBatchName."First Step of cheque" or lBatchName."First Step of Traite") then
                    exit;
        If (GenJournalLine."Cheque No." <> '') AND StepOfApply(GenJournalLine."Code Status") and
         (lChequeCard.GetAmountFromChequeLines(GenJournalLine."Cheque No.") > 0) then begin
            lCustLedgEntry.Reset();
            lCustLedgEntry.SetRange("Document Type", lCustLedgEntry."Document Type"::Payment);
            lCustLedgEntry.SetRange("Document No.", GenJournalLine."Cheque No.");
            if lCustLedgEntry.FindFirst() Then Begin
                If abs(GenJournalLine."Amount (LCY)") < lpaymentApply.GetSumAmountsInvoicesFromCHQ(GenJournalLine."Cheque No.") Then
                    Error(Ltext001);
                lchequeLines.Reset();
                lchequeLines.SetRange("Cheque No.", GenJournalLine."Cheque No.");
                if lchequeLines.FindFirst() then
                    repeat
                        lpaymentApply.ApplyInvoiceEntry_DetCustLedgerEntry(lchequeLines."Invoice No.", lchequeLines."Cheque No.", lCustLedgEntry."Transaction No.");
                        lpaymentApply.ClosedInvoiceCustomerLedgerEntry(lchequeLines."Invoice No.", lCustLedgEntry."Entry No.", lchequeLines."Amount LCY");
                    Until lchequeLines.Next = 0;
                lpaymentApply.ApplyPaymentEntry_DetCustLedgerEntry(GenJournalLine."Cheque No.", lCustLedgEntry."Transaction No.");
                lpaymentApply.ClosedPaymentCustomerLedgerEntry(GenJournalLine."Cheque No.");
            End;
        end;
    End;




    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Reverse", 'OnAfterReverseGLEntry', '', FALSE, FALSE)]
    Local procedure OnAfterReverseTransaction(var GLEntry: Record "G/L Entry")
    Var
        lChequeHeader: Record "Cheque Header";
        lCustomerLedgEntry: Record "Cust. Ledger Entry";
        LGLEntry: Record "G/L Entry";
        LPaymentStatus: Record "WDC payment status";
    begin
        if GLEntry."Document Type" = GLEntry."Document Type"::Payment then
            if GLEntry."Cheque No." <> '' then begin
                If lChequeHeader.Get(GLEntry."Cheque No.") then begin
                    lChequeHeader."Code Status" := lChequeHeader."Previous Code Status";
                    lChequeHeader."Cheque Reversed" := true;
                    lChequeHeader.Modify;
                    if LPaymentStatus.Get(lChequeHeader."Previous Code Status") Then;
                    SetCustLedgerEntryStatus(GLEntry."Cheque No.", lChequeHeader."Previous Code Status", LPaymentStatus."Description Status");
                    SetGLEntryStatus(GLEntry."Cheque No.", lChequeHeader."Previous Code Status", LPaymentStatus."Description Status");
                end;
            End;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Reverse", 'OnReverseGLEntryOnBeforeInsertGLEntry', '', FALSE, FALSE)]
    Local procedure OnReverseGLEntryOnBeforeInsertGLEntry(var GLEntry: Record "G/L Entry"; GenJnlLine: Record "Gen. Journal Line"; GLEntry2: Record "G/L Entry")
    Var
        lChequeHeader: Record "Cheque Header";
        Ltext001: Label 'You can reverse only the last entry of this document';
    begin
        if GLEntry."Document Type" = GLEntry."Document Type"::Payment then
            If lChequeHeader.Get(GLEntry."Document No.") then begin
                lChequeHeader.CalcFields("Description Status");
                If GLEntry."Code Status" <> lChequeHeader."Code Status" Then
                    Error(Ltext001);
            End;
    End;


    [EventSubscriber(ObjectType::Table, database::"Cheque Line", 'OnAfterValidateEvent', 'Invoice No.', FALSE, FALSE)]
    Local procedure OnAftervalidateInvoiceTable(Rec: Record "Cheque Line")
    Var
        ltext001: Label 'This invoice is already inputted in this document';
        lChequelines: Record "Cheque Line";
    begin
        lChequelines.Reset();
        lChequelines.SetRange("Cheque No.", Rec."Cheque No.");
        lChequelines.SetRange("Invoice No.", Rec."Invoice No.");
        lChequelines.Setfilter("Line No.", '<> %1', Rec."Line No.");
        if lChequelines.FindFirst() then
            Error(ltext001);
    end;

    [EventSubscriber(ObjectType::Table, database::"Cheque Header", 'OnAfterValidateEvent', 'Cheque Value', FALSE, FALSE)]
    Local procedure OnAftervalidateChequeValue(Rec: Record "Cheque Header")
    Var
        Ltext001: Label 'The amount of this document must be equal or greater than the sum of the amounts LCY of the invoices';
        LPaymentApply: Codeunit "WDC Payment Aplly";
    begin
        If Rec."Cheque Value" < LPaymentApply.GetSumAmountsInvoicesFromCHQ(Rec."Cheque No.") then
            Error(Ltext001);
    end;

    procedure StepOfApply(pStatusCode: Code[20]): Boolean
    var
        lBatchName: record 232;
    begin
        lBatchName.Reset();
        lBatchName.SetRange("Code Status", pStatusCode);
        If lBatchName.FindFirst() Then
            IF lBatchName."First Step of cheque" or lBatchName."First Step of Traite" then
                exit(true);
        exit(false)
    end;


    procedure SetCHQStatus(pChqNo: Code[20]; "pStatusCode": Code[20])
    var
        lCHQHeader: Record "Cheque Header";
    begin
        If Not lCHQHeader.Get(pChqNo) then
            Exit;
        If lCHQHeader."Code Status" <> pStatusCode then
            lCHQHeader."Previous Code Status" := lCHQHeader."Code Status";
        lCHQHeader."Code Status" := pStatusCode;
        lCHQHeader.Modify;
    end;

    procedure SetCustLedgerEntryStatus(pChqNo: Code[20]; "pStatusCode": Code[20]; pDescriptionStatus: Text[100])
    var
        lCustomerLedgEntry: Record "Cust. Ledger Entry";
    begin
        lCustomerLedgEntry.Reset();
        lCustomerLedgEntry.SetCurrentKey("Cheque No.");
        lCustomerLedgEntry.SetRange("Cheque No.", pChqNo);
        //lCustomerLedgEntry.SetRange("Document Type", lCustomerLedgEntry."Document Type"::Payment);
        if lCustomerLedgEntry.FindFirst() then Begin
            lCustomerLedgEntry.ModifyAll("Code Status", pStatusCode);
            lCustomerLedgEntry.ModifyAll("Description Status", pDescriptionStatus);

        end;
    end;

    procedure SetGLEntryStatus(pChqNo: Code[20]; "pStatusCode": Code[20]; pDescriptionStatus: Text[100])
    var
        LGLEntry: Record "G/L Entry";
    begin
        LGLEntry.Reset;
        LGLEntry.SetCurrentKey("Cheque No.");
        LGLEntry.SetRange("Cheque No.", pChqNo);
        If LGLEntry.FindSet then begin
            LGLEntry.ModifyAll("Code Status", pStatusCode);
            LGLEntry.ModifyAll("Description Status", pDescriptionStatus);
        end;
    End;


}