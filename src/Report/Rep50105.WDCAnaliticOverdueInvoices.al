report 50105 "WDC Analitic Overdue Invoices"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/Report/RDLC/WDCAnOverdueInvoices.rdl';
    AdditionalSearchTerms = 'Analitic Overdue Invoices';
    ApplicationArea = Basic, Suite;
    Caption = 'Analitic Overdue Invoices';
    EnableHyperlinks = true;
    UsageCategory = ReportsAndAnalysis;
    Description = 'Analitic Overdue Invoices';
    dataset
    {
        dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
        {
            RequestFilterFields = "Sell-to Customer No.", "Salesperson Code", "Posting Date", "Due Date";
            DataItemTableView = SORTING("Customer No.", "Posting Date", "Currency Code") order(ascending)
                                           where("Document Type" = filter(2 | 3),
                                           "Sell-to Customer No." = filter('C*'));
            column(GLFilter; GLFilter)
            {
            }
            column(CompanyInfoName; CompanyInfo.Name)
            {
            }
            column(FromDate; FromDate)
            {
            }
            column(ToDate; ToDate)
            {
            }
            column(CustNo; "Cust. Ledger Entry"."Customer No.")
            {
            }

            column(CustName; customer.Name)
            {
            }

            column(SalespersonInv; "Cust. Ledger Entry"."Salesperson Code")
            {

            }
            column(PaymentTermeCustomer; customer."Payment Terms Code")
            {
            }
            column(PaymentTermeCode; InvoiceHeader."Payment Terms Code")
            {
            }

            column(PostingDate; "Cust. Ledger Entry"."Posting Date")
            {
            }

            column(DocumentNo; "Cust. Ledger Entry"."Document No.")
            {

            }
            column(AmntIncVatInv; "Cust. Ledger Entry"."Original Amt. (LCY)")
            {

            }
            column(TotalPaymentAmt; TotalPaymentAmt * -1)
            {

            }
            column(RemainingAmtInv; "Cust. Ledger Entry"."Remaining Amt. (LCY)")
            {

            }
            column(DueDateInv; "Cust. Ledger Entry"."Due Date")
            {

            }
            column(LineNo; LineNo)
            {

            }

            column(CollectionDate; CollectionDate)
            {

            }
            column(PostingCashDate; PostingCashDate)
            {

            }

            column(OnTime; OnTime)
            {

            }
            column(Sup30days; Sup30days)
            {

            }
            column(Sup60days; Sup60days)
            {

            }
            column(Sup90days; Sup90days)
            {

            }
            column(Sup120days; Sup120days)
            {

            }
            column(Over120days; Over120days)
            {

            }

            trigger OnPreDataItem()
            begin
                CompanyInfo.get;
                GLFilter := "Cust. Ledger Entry".GetFilters;
                LineNo := 0;
                If "Cust. Ledger Entry"."Posting Date" <> 0D then begin
                    FromDate := "Cust. Ledger Entry".GetRangeMin("Posting Date");
                    ToDate := "Cust. Ledger Entry".GetRangeMax("Posting Date");
                end;

            end;

            trigger OnAfterGetRecord()
            begin
                TotalPaymentAmt := 0;
                OnTime := 0;
                Sup30days := 0;
                Sup60days := 0;
                Sup90days := 0;
                Sup120days := 0;
                Over120days := 0;
                Clear(CollectionDate);
                Clear(PostingCashDate);
                "Cust. Ledger Entry".CalcFields("Remaining Amt. (LCY)");
                LineNo += 1;
                if Customer.GET("Cust. Ledger Entry"."Sell-to Customer No.") then;
                if InvoiceHeader.GET("Cust. Ledger Entry"."Document No.") then
                    if "Cust. Ledger Entry"."Remaining Amt. (LCY)" <> "Cust. Ledger Entry"."Amount (LCY)" then
                        GetOverdueDay(InvoiceHeader."No.", InvoiceHeader."Due Date", "Cust. Ledger Entry"."Entry No.");

            end;

        }
    }


    procedure GetOverdueDay(pInvoiceNo: code[20]; pDueInvDate: Date; pCustLedgEntryNo: Integer)
    var
        lDetCustLedg: Record "Detailed Cust. Ledg. Entry";
        NbOverDueDays: Integer;
    begin
        lDetCustLedg.Reset();
        lDetCustLedg.SetCurrentKey("Cust. Ledger Entry No.", "Posting Date");
        lDetCustLedg.SetRange("Cust. Ledger Entry No.", pCustLedgEntryNo);
        lDetCustLedg.SetRange("Customer No.", "Cust. Ledger Entry"."Customer No.");
        //lDetCustLedg.SetRange("Document Type", lDetCustLedg."Document Type"::Payment);
        lDetCustLedg.SetRange("Entry Type", lDetCustLedg."Entry Type"::Application);
        If lDetCustLedg.FindFirst() then
            repeat
                If (lDetCustLedg."Amount (LCY)" * -1) >= 1 THen Begin
                    NbOverDueDays := CalcOverDueDay(pDueInvDate, lDetCustLedg."Document No.");
                    If (CollectionDate <> 0D) OR (PostingCashDate <> 0D) Then begin
                        if NbOverDueDays <= 0 Then
                            OnTime += (lDetCustLedg."Amount (LCY)" * -1)
                        else
                            if (0 < NbOverDueDays) and (NbOverDueDays <= 30) then
                                Sup30days += (lDetCustLedg."Amount (LCY)" * -1)
                            else
                                if (30 < NbOverDueDays) and (NbOverDueDays <= 60) then
                                    Sup60days += (lDetCustLedg."Amount (LCY)" * -1)
                                else
                                    if (60 < NbOverDueDays) and (NbOverDueDays <= 90) then
                                        Sup90days += (lDetCustLedg."Amount (LCY)" * -1)
                                    else
                                        if (90 < NbOverDueDays) and (NbOverDueDays <= 120) then
                                            Sup120days += (lDetCustLedg."Amount (LCY)" * -1)
                                        else
                                            if (NbOverDueDays > 120) then
                                                Over120days += (lDetCustLedg."Amount (LCY)" * -1)
                    end;
                End;
                TotalPaymentAmt += lDetCustLedg."Amount (LCY)";
            until lDetCustLedg.Next() = 0;

    end;

    procedure CalcOverDueDay(pInvDueDate: Date; pPaymentNo: code[20]): Integer
    var
        lCustLedgEnt: Record "Cust. Ledger Entry";
        lCHQHeader: Record "Cheque Header";
    begin
        Clear(PostingCashDate);
        lCustLedgEnt.Reset();
        lCustLedgEnt.SetCurrentKey("Document No.");
        lCustLedgEnt.SetRange("Document No.", pPaymentNo);
        lCustLedgEnt.SetFilter("Document Type", '<>%1', lCustLedgEnt."Document Type"::"Credit Memo");
        lCustLedgEnt.setrange("Customer No.", "Cust. Ledger Entry"."Customer No.");
        if lCustLedgEnt.FindFirst() then begin
            if lCustLedgEnt."Cheque No." <> '' then begin
                If lCHQHeader.Get(lCustLedgEnt."Cheque No.") then begin
                    lCHQHeader.CalcFields("Collection date");
                    if lCHQHeader."Collection date" <> 0D then
                        CollectionDate := lCHQHeader."Collection date";
                    if (pInvDueDate <> 0D) and (CollectionDate <> 0D) Then
                        exit(CollectionDate - pInvDueDate);
                end;
            end else begin
                if (pInvDueDate <> 0D) and (lCustLedgEnt."Posting Date" <> 0D) And (lCustLedgEnt."Cheque No." = '') Then begin
                    If lCustLedgEnt."Posting Date" <> 0D Then
                        PostingCashDate := lCustLedgEnt."Posting Date";
                    exit(lCustLedgEnt."Posting Date" - pInvDueDate);
                end;
            end;
        end;
        exit(0)
    end;

    var
        GLFilter: Text;
        CompanyInfo: Record "Company Information";
        Customer: Record Customer;
        InvoiceHeader: Record "Sales Invoice Header";
        LineNo: Integer;
        FromDate: Date;
        ToDate: Date;
        OnTime: Decimal;
        Sup30days: Decimal;
        Sup60days: Decimal;
        Sup90days: Decimal;
        Sup120days: Decimal;
        Over120days: Decimal;
        CollectionDate: date;
        PostingCashDate: Date;
        TotalPaymentAmt: Decimal;
}

