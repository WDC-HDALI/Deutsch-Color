codeunit 50101 "WDC Payment Aplly"
{

    trigger OnRun()
    var

    begin

    end;

    var

    procedure ApplyPaymentEntry_DetCustLedgerEntry(pChequeNo: Code[20]; pTransactionNo: Integer)
    var
        lDetCustLedger: record "Detailed Cust. Ledg. Entry";
        lApplyDetCustLedger: record "Detailed Cust. Ledg. Entry";
        lchequeLines: record "Cheque Line";
    Begin
        lDetCustLedger.Reset();
        lDetCustLedger.SetRange("Document Type", lDetCustLedger."Document Type"::Payment);
        lDetCustLedger.SetRange("Entry Type", lDetCustLedger."Entry Type"::"Initial Entry"); //Hdali
        lDetCustLedger.SetRange("Document No.", pChequeNo);
        If lDetCustLedger.FindFirst then begin
            lApplyDetCustLedger.Init;
            lApplyDetCustLedger := lDetCustLedger;
            lApplyDetCustLedger."Entry No." := lDetCustLedger.GetLastEntryNo() + 1;
            lApplyDetCustLedger."Entry Type" := lDetCustLedger."Entry Type"::Application;
            lApplyDetCustLedger."Posting Date" := WorkDate;
            lApplyDetCustLedger."Document Type" := lDetCustLedger."Document Type"::Payment;
            lApplyDetCustLedger."Document No." := pChequeNo;
            lApplyDetCustLedger.Insert;
            lApplyDetCustLedger.Amount := GetSumAmountsInvoicesFromCHQ(pChequeNo);
            lApplyDetCustLedger."Amount (LCY)" := GetSumAmountsInvoicesFromCHQ(pChequeNo);
            lApplyDetCustLedger."Debit Amount" := GetSumAmountsInvoicesFromCHQ(pChequeNo);
            lApplyDetCustLedger."Debit Amount (LCY)" := GetSumAmountsInvoicesFromCHQ(pChequeNo);
            lApplyDetCustLedger."Transaction No." := pTransactionNo;
            lApplyDetCustLedger."Credit Amount" := 0;
            lApplyDetCustLedger."Credit Amount (LCY)" := 0;
            lApplyDetCustLedger."Initial Document Type" := lApplyDetCustLedger."Initial Document Type"::Payment;
            lApplyDetCustLedger."Ledger Entry Amount" := false;
            lApplyDetCustLedger."Applied Cust. Ledger Entry No." := GetAppliedCustomerLedgerEntry(pChequeNo);
            lApplyDetCustLedger.Modify;
        end;
    End;

    procedure ApplyInvoiceEntry_DetCustLedgerEntry(pInvoiceNo: Code[20]; pChequeNo: Code[20]; pTransactionNo: Integer)
    var
        lDetCustLedger: record "Detailed Cust. Ledg. Entry";
        lApplyDetCustLedger: record "Detailed Cust. Ledg. Entry";
        lchequeLines: record "Cheque Line";
    Begin
        lDetCustLedger.Reset();
        lDetCustLedger.SetRange("Document Type", lDetCustLedger."Document Type"::Invoice);
        lDetCustLedger.SetRange("Entry Type", lDetCustLedger."Entry Type"::"Initial Entry"); //Hdali
        lDetCustLedger.SetRange("Document No.", pInvoiceNo);
        If lDetCustLedger.FindFirst then begin
            lApplyDetCustLedger.Init;
            lApplyDetCustLedger := lDetCustLedger;
            lApplyDetCustLedger."Entry No." := lDetCustLedger.GetLastEntryNo() + 1;
            lApplyDetCustLedger."Entry Type" := lDetCustLedger."Entry Type"::Application;
            lApplyDetCustLedger."Posting Date" := WorkDate;
            lApplyDetCustLedger."Document Type" := lDetCustLedger."Document Type"::Payment;
            lApplyDetCustLedger."Document No." := pChequeNo;
            lApplyDetCustLedger.Insert;
            lApplyDetCustLedger.Amount := -GetAmountInvoiceFromCHQ(pInvoiceNo, pChequeNo);
            lApplyDetCustLedger."Amount (LCY)" := -GetAmountInvoiceFromCHQ(pInvoiceNo, pChequeNo);
            lApplyDetCustLedger."Transaction No." := pTransactionNo;
            lApplyDetCustLedger."Credit Amount" := GetAmountInvoiceFromCHQ(pInvoiceNo, pChequeNo);
            lApplyDetCustLedger."Credit Amount (LCY)" := GetAmountInvoiceFromCHQ(pInvoiceNo, pChequeNo);
            lApplyDetCustLedger."Debit Amount" := 0;
            lApplyDetCustLedger."Debit Amount (LCY)" := 0;
            lApplyDetCustLedger."Initial Document Type" := lApplyDetCustLedger."Initial Document Type"::Invoice;
            lApplyDetCustLedger."Ledger Entry Amount" := False;
            lApplyDetCustLedger."Applied Cust. Ledger Entry No." := GetAppliedCustomerLedgerEntry(pChequeNo);
            lApplyDetCustLedger."2nd Group" := '';
            lApplyDetCustLedger."3rd Group" := '';
            lApplyDetCustLedger.Modify;
        end;
    End;

    procedure GetAppliedCustomerLedgerEntry(pChequeNo: Code[20]): Integer
    var
        lCustLedgerEntry: record "Cust. Ledger Entry";
    begin
        lCustLedgerEntry.Reset();
        lCustLedgerEntry.SetRange("Document Type", lCustLedgerEntry."Document Type"::Payment);
        lCustLedgerEntry.SetRange("Document No.", pChequeNo);
        if lCustLedgerEntry.FindFirst() then;
        Exit(lCustLedgerEntry."Entry No.");
    end;

    procedure ClosedInvoiceCustomerLedgerEntry(pInvoiceNo: Code[20]; pApplyCustLedgEntry: Integer; pClosedByAmount: Decimal)
    var
        lCustLedgerEntry: record "Cust. Ledger Entry";
    Begin
        lCustLedgerEntry.Reset();
        lCustLedgerEntry.SetRange("Document Type", lCustLedgerEntry."Document Type"::Invoice);
        lCustLedgerEntry.SetRange("Document No.", pInvoiceNo);
        if lCustLedgerEntry.FindFirst() Then begin
            lCustLedgerEntry.CalcFields("Remaining Amt. (LCY)");
            if lCustLedgerEntry."Remaining Amt. (LCY)" = 0 Then begin
                lCustLedgerEntry.Open := false;
                lCustLedgerEntry."Closed by Entry No." := pApplyCustLedgEntry;
                lCustLedgerEntry."Closed by Amount (LCY)" := pClosedByAmount;
                lCustLedgerEntry.Modify;
            end;
        end;

    End;

    procedure ClosedPaymentCustomerLedgerEntry(pChequeNo: Code[20])
    var
        lCustLedgerEntry: record "Cust. Ledger Entry";
    Begin
        lCustLedgerEntry.Reset();
        lCustLedgerEntry.SetRange("Document Type", lCustLedgerEntry."Document Type"::Payment);
        lCustLedgerEntry.SetRange("Document No.", pChequeNo);
        if lCustLedgerEntry.FindFirst() Then begin
            lCustLedgerEntry.CalcFields("Remaining Amt. (LCY)");
            if lCustLedgerEntry."Remaining Amt. (LCY)" = 0 Then begin
                lCustLedgerEntry.Open := false;
                lCustLedgerEntry.Modify;
            end;
        End;
    end;

    procedure GetTransactionEntry(pChqNo: Code[20]): Integer
    var
        lCustLedgEntry: Record "Cust. Ledger Entry";
    begin
        lCustLedgEntry.Reset();
        lCustLedgEntry.SetRange("Document Type", lCustLedgEntry."Document Type"::Payment);
        lCustLedgEntry.SetRange("Document No.", pChqNo);
        if lCustLedgEntry.FindFirst() Then;
        exit(lCustLedgEntry."Transaction No.");
    end;


    procedure GetAmountInvoiceFromCHQ(pInvoiceNo: Code[20]; pChequeNo: Code[20]): Decimal
    var
        lchequeLines: record "Cheque Line";
    Begin
        lchequeLines.Reset();
        lchequeLines.SetRange("Cheque No.", pChequeNo);
        lchequeLines.setrange("Invoice No.", pInvoiceNo);
        If lchequeLines.FindFirst then;
        exit(lchequeLines."Amount LCY");
    End;

    procedure GetSumAmountsInvoicesFromCHQ(pChequeNo: Code[20]): Decimal
    var
        lchequeLines: record "Cheque Line";
    Begin
        lchequeLines.Reset();
        lchequeLines.SetRange("Cheque No.", pChequeNo);
        If lchequeLines.FindFirst then
            lchequeLines.CalcSums("Amount LCY");
        exit(lchequeLines."Amount LCY");
    End;

    procedure GetValueChequeFromCHQ(pChequeNo: Code[20]): Decimal
    var
        lChequeHeader: record "Cheque Header";
    Begin
        lChequeHeader.Get(pChequeNo);
        exit(lChequeHeader."Cheque Value");
    End;


}

