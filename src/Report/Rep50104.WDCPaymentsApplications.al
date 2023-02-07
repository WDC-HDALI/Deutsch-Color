report 50104 "WDC Payments Applications"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/Report/RDLC/WDCPaymentApplication.rdl';
    AdditionalSearchTerms = 'Payment Application';
    ApplicationArea = Basic, Suite;
    Caption = 'Payment Application';
    EnableHyperlinks = true;
    UsageCategory = ReportsAndAnalysis;
    Description = 'Payment Application';
    dataset
    {
        dataitem(CustomerData; Customer)
        {
            DataItemTableView = sorting("No.") where("No." = filter('C*'));
            column(CustomerNo; CustomerData."No.")
            {
            }
            column(CustName; CustomerData.Name)
            {
            }
            column(TotalCHQ_TRT; TotalCHQ_TRT)
            {

            }

            column(TotalPayment; TotalPayment)
            {

            }
            column(TotalBycustomer; TotalBycustomer)
            {

            }

            dataitem("G/L Entry"; "G/L Entry")
            {
                DataItemLink = "Customer No." = FIELD("No.");
                DataItemTableView = sorting("G/L Account No.", "Posting Date") WHERE("Bal. Account Type" = filter(3), "Code Status" = filter('CH-004-*' | 'TRT-004-*'));
                column(GLFilter; GLFilter)
                {

                }
                column(Posting_Date_GLEntry; "G/L Entry"."Posting Date")
                {

                }

                column(SalesPersonPayment; "Sales person No.")
                {
                }
                column(Payment_Type_GLEnty; "Payment Type")
                {

                }
                column(ChequeNo_CustLedg; "G/L Entry"."Cheque No.")
                {

                }
                column(PaymentAmountLCY_CustLedg; "G/L Entry".Amount)
                {

                }

                dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
                {

                    DataItemLink = "Customer No." = FIELD("Customer No."), "Cheque No." = FIELD("Cheque No.");
                    DataItemTableView = SORTING("Customer No.", "Posting Date", "Currency Code") order(ascending)
                                           where("Document Type" = filter(0 | 1),
                                           "Cheque No." = filter(<> ''));


                    dataitem("DetCustLedgEntry"; "Detailed Cust. Ledg. Entry")
                    {
                        DataItemLink = "Applied Cust. Ledger Entry No." = FIELD("Entry No.");
                        DataItemTableView = SORTING("Customer No.", "Posting Date", "Currency Code") where("Initial Document Type" = filter('Invoice'),
                                             "Entry Type" = filter('Application'),
                                             Unapplied = const(false));
                        column(InvoiceNo; InvoiceNo)
                        {
                        }
                        column(InvoiceAmountLCY_DetCust; "Amount (LCY)")
                        {
                        }
                        column(GetItemCategory; GetItemCategory(InvoiceNo))
                        {

                        }
                        column(SalespersonInvoice; SalespersonInvoice)
                        {

                        }

                        trigger OnAfterGetRecord()
                        var
                            lDetCustLegEntry: Record "Detailed Cust. Ledg. Entry";
                            lCustLegEntry: Record "Cust. Ledger Entry";
                        begin
                            Clear(InvoiceNo);
                            Clear(SalespersonInvoice);
                            "Cust. Ledger Entry".CalcFields("Amount (LCY)");
                            lDetCustLegEntry.Reset();
                            lDetCustLegEntry.SetCurrentKey("Cust. Ledger Entry No.", "Posting Date");
                            lDetCustLegEntry.SetRange("Cust. Ledger Entry No.", DetCustLedgEntry."Cust. Ledger Entry No.");
                            lDetCustLegEntry.SetRange("Entry Type", lDetCustLegEntry."Entry Type"::"Initial Entry");
                            lDetCustLegEntry.SetRange("Document Type", lDetCustLegEntry."Document Type"::Invoice);
                            if lDetCustLegEntry.FindFirst() then BEGIN
                                InvoiceNo := lDetCustLegEntry."Document No.";
                                lCustLegEntry.Reset();
                                lCustLegEntry.SetCurrentKey("Customer No.", "Posting Date", "Currency Code");
                                lCustLegEntry.SetRange("Document Type", lCustLegEntry."Document Type"::Invoice);
                                lCustLegEntry.SetRange("Document No.", lDetCustLegEntry."Document No.");
                                if SalesPersonCodeFilter <> '' then
                                    lCustLegEntry.SetRange("Salesperson Code", SalesPersonCodeFilter);
                                If lCustLegEntry.FindFirst() then
                                    SalespersonInvoice := lCustLegEntry."Salesperson Code";
                            END ELSE
                                CurrReport.Skip();
                        end;
                    }
                    trigger OnPreDataItem()
                    begin
                        if CustomerFilter <> '' then
                            "Cust. Ledger Entry".SetFilter("Customer No.", CustomerFilter);
                        if SalesPersonManFilter <> '' then
                            "Cust. Ledger Entry".SetFilter("Sales person No.", SalesPersonManFilter);
                    end;

                }
                trigger OnPreDataItem()
                begin
                    "G/L Entry".SetRange("Posting Date", StartDateFilter, EndtDateFilter);
                    if CustomerFilter <> '' then
                        "G/L Entry".SetFilter("Customer No.", CustomerFilter);
                    if SalesPersonManFilter <> '' then
                        "G/L Entry".SetFilter("Sales person No.", SalesPersonManFilter);
                end;

                trigger OnAfterGetRecord()
                var
                    lCHQHeader: Record "Cheque Header";
                begin
                    CompanyInfo.Get;
                    GLFilter := "G/L Entry".GetFilters;
                    IF lCHQHeader.Get("G/L Entry"."Cheque No.") THEN begin
                        If lCHQHeader."Code Status" <> "G/L Entry"."Code Status" then
                            CurrReport.Skip();
                    end;
                    If Customer.get("G/L Entry"."Customer No.") then;

                end;
            }
            dataitem("Cust. Ledger Entry 2"; "Cust. Ledger Entry")
            {
                DataItemLink = "Customer No." = FIELD("No.");
                DataItemTableView = SORTING("Customer No.", "Posting Date", "Currency Code") order(ascending)
                                           where("Document Type" = filter(0 | 1),
                                                 "Cheque No." = filter(''),
                                                   "Code Status" = filter(''));

                column(PostingDate2; "Cust. Ledger Entry 2"."Posting Date")
                {
                }
                column(SalespersonPayment1; "Cust. Ledger Entry 2"."Sales person No.")
                {

                }
                column(PaymentAmount2; PaymentAmount2)
                {
                }
                column(DocumentType_CustLedg2; "Cust. Ledger Entry 2"."Document Type")
                {

                }
                column(DocumentNo_CustLedg2; "Cust. Ledger Entry 2"."Document No.")
                {

                }
                column(salesPersonPayment2; salesPersonPayment2)
                {

                }
                column(InvoiceNo3; InvoiceNo3)
                {

                }
                column(InvoicesTotal3; InvoicesTotal3)
                {

                }

                dataitem(DetCustLedgEntry2; "Detailed Cust. Ledg. Entry")
                {
                    DataItemLink = "Applied Cust. Ledger Entry No." = FIELD("Entry No.");
                    DataItemTableView = Sorting("Cust. Ledger Entry No.", "Posting Date") where("Initial Document Type" = filter('Invoice'),
                                             "Entry Type" = filter('Application'),
                                             Unapplied = const(false));


                    column(InvoiceNo2; InvoiceNo2)
                    {
                    }

                    column(GetItemCategory2; GetItemCategory(InvoiceNo2))
                    {

                    }
                    column(InvoiceAmountLCY2; "Amount (LCY)")
                    {
                    }
                    column(SalespersonInvoice2; SalespersonInvoice2)
                    {

                    }



                    trigger OnAfterGetRecord()
                    var
                        lDetCustLegEntry: Record "Detailed Cust. Ledg. Entry";
                        lCustLegEntry: Record "Cust. Ledger Entry";
                    begin
                        Clear(InvoiceNo2);
                        Clear(SalespersonInvoice2);
                        "Cust. Ledger Entry 2".CalcFields("Amount (LCY)");
                        lDetCustLegEntry.Reset();
                        lDetCustLegEntry.SetCurrentKey("Cust. Ledger Entry No.", "Posting Date");
                        lDetCustLegEntry.SetRange("Cust. Ledger Entry No.", DetCustLedgEntry2."Cust. Ledger Entry No.");
                        lDetCustLegEntry.SetRange("Entry Type", lDetCustLegEntry."Entry Type"::"Initial Entry");
                        lDetCustLegEntry.SetRange("Document Type", lDetCustLegEntry."Document Type"::Invoice);
                        if lDetCustLegEntry.FindFirst() then BEGIN
                            InvoiceNo2 := lDetCustLegEntry."Document No.";
                            lCustLegEntry.Reset();
                            lCustLegEntry.SetCurrentKey("Customer No.", "Posting Date", "Currency Code");
                            lCustLegEntry.SetRange("Document Type", lCustLegEntry."Document Type"::Invoice);
                            lCustLegEntry.SetRange("Document No.", lDetCustLegEntry."Document No.");
                            if SalesPersonCodeFilter <> '' then
                                lCustLegEntry.SetRange("Salesperson Code", SalesPersonCodeFilter);
                            If lCustLegEntry.FindFirst() then
                                SalespersonInvoice2 := lCustLegEntry."Salesperson Code";
                        END ELSE
                            CurrReport.Skip();
                    end;
                }
                trigger OnPreDataItem()
                begin
                    "Cust. Ledger Entry 2".SetRange("Posting Date", StartDateFilter, EndtDateFilter);
                    if CustomerFilter <> '' then
                        "Cust. Ledger Entry 2".SetFilter("Customer No.", CustomerFilter);
                    // if SalesPersonManFilter <> '' then
                    //     "Cust. Ledger Entry 2".SetFilter("Sales person No.", SalesPersonManFilter);
                end;

                trigger OnAfterGetRecord()
                var
                    lCustLedgEntPayment: Record "Cust. Ledger Entry";
                begin
                    InvoiceNo3 := '';
                    salesPersonPayment2 := '';
                    If "Cust. Ledger Entry 2"."Document Type" = "Cust. Ledger Entry 2"."Document Type"::" " Then BEGIN
                        If (SalesPersonManFilter <> "Cust. Ledger Entry 2"."Salesperson Code") and (SalesPersonManFilter <> '') Then
                            CurrReport.Skip();
                        salesPersonPayment2 := "Cust. Ledger Entry 2"."Salesperson Code";
                    End Else begin
                        If "Cust. Ledger Entry 2"."Document Type" = "Cust. Ledger Entry 2"."Document Type"::Payment then
                            If (SalesPersonManFilter <> "Cust. Ledger Entry 2"."Sales person No.") and (SalesPersonManFilter <> '') Then
                                CurrReport.Skip();
                    end;

                    PaymentAmount2 := 0;
                    lCustLedgEntPayment.Reset();
                    lCustLedgEntPayment.SetCurrentKey("Customer No.", "Posting Date", "Currency Code");
                    lCustLedgEntPayment.SetRange("Customer No.", CustomerData."No.");
                    lCustLedgEntPayment.SetRange("Posting Date", StartDateFilter, EndtDateFilter);
                    lCustLedgEntPayment.SetRange("Document Type", "Cust. Ledger Entry 2"."Document Type");
                    lCustLedgEntPayment.SetRange("Document No.", "Cust. Ledger Entry 2"."Document No.");
                    lCustLedgEntPayment.SetRange("Cheque No.", '');
                    lCustLedgEntPayment.SetRange("Code Status", '');
                    If lCustLedgEntPayment.FindFirst() THEN
                        repeat
                            lCustLedgEntPayment.CalcFields("Amount (LCY)");
                            if SalesPersonManFilter <> '' Then BEGIN
                                If "Cust. Ledger Entry 2"."Document Type" = "Cust. Ledger Entry 2"."Document Type"::" " then BEGIN
                                    If "Salesperson Code" = SalesPersonManFilter then
                                        PaymentAmount2 += lCustLedgEntPayment."Amount (LCY)";
                                End Else BEGIN
                                    If "Sales person No." = SalesPersonManFilter then
                                        PaymentAmount2 += lCustLedgEntPayment."Amount (LCY)";
                                END;
                            END Else
                                PaymentAmount2 += lCustLedgEntPayment."Amount (LCY)";
                        until lCustLedgEntPayment.Next = 0;
                    InvoiceNo3 := '';
                    if "Cust. Ledger Entry 2"."Document Type" = "Cust. Ledger Entry 2"."Document Type"::Payment THEN
                        InvoiceNo3 := GetInvoicesOfImpaidCheque("Cust. Ledger Entry 2"."Document No.");
                end;
            }

            trigger OnPreDataItem()
            begin
                If CustomerFilter <> '' then
                    CustomerData.SetFilter("No.", CustomerFilter);
                If SalesPersonManFilter <> '' then
                    CustomerData.SetFilter("Salesperson Code", SalesPersonManFilter);
            end;

            trigger OnAfterGetRecord()
            var
                lCustLedgEntry: Record "Cust. Ledger Entry";
                lGLEntry: Record "G/L Entry";
            begin
                TotalPayment := 0;
                TotalCHQ_TRT := 0;
                lGLEntry.Reset();
                lGLEntry.SetCurrentKey("G/L Account No.", "Posting Date");
                lGLEntry.SetRange("Posting Date", StartDateFilter, EndtDateFilter);
                lGLEntry.SetRange("Customer No.", CustomerData."No.");
                lGLEntry.SetRange("Bal. Account Type", lGLEntry."Bal. Account Type"::"Bank Account");
                lGLEntry.SetFilter("Code Status", '%1|%2', 'CH-004-*', 'TRT-004-*');
                If SalesPersonManFilter <> '' then
                    lGLEntry.SetFilter("Sales person No.", SalesPersonManFilter);

                lCustLedgEntry.Reset();
                lCustLedgEntry.SetCurrentKey("Customer No.", "Posting Date", "Currency Code");
                lCustLedgEntry.SetRange("Customer No.", CustomerData."No.");
                lCustLedgEntry.SetRange("Posting Date", StartDateFilter, EndtDateFilter);
                lCustLedgEntry.SetFilter("Document Type", '%1|%2', lCustLedgEntry."Document Type"::" ", lCustLedgEntry."Document Type"::Payment);
                lCustLedgEntry.SetRange("Cheque No.", '');
                lCustLedgEntry.SetRange("Code Status", '');
                If SalesPersonManFilter <> '' then
                    lCustLedgEntry.SetFilter("Sales person No.", SalesPersonManFilter);

                If (Not (lGLEntry.FindFirst)) And (Not (lCustLedgEntry.FindFirst)) then
                    CurrReport.Skip()
                Else Begin
                    repeat
                        lCustLedgEntry.CalcFields("Amount (LCY)");
                        TotalPayment += lCustLedgEntry."Amount (LCY)" * (-1);
                    until lCustLedgEntry.Next = 0;
                    lGLEntry.CalcSums(lGLEntry.Amount);
                    TotalCHQ_TRT := lGLEntry.Amount * (-1);
                    TotalBycustomer += TotalCHQ_TRT + TotalPayment;
                End;
            End;

        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Filters)
                {
                    Caption = 'Filter';
                    field(StartDateFilter; StartDateFilter)
                    {
                        ApplicationArea = all;
                        Caption = 'Start Posting Date';
                    }
                    field(EndtDateFilter; EndtDateFilter)
                    {
                        ApplicationArea = all;
                        Caption = 'End Posting Date';
                    }
                    field(CustomerFilter; CustomerFilter)
                    {
                        ApplicationArea = all;
                        Caption = 'Customer';
                        TableRelation = Customer where("No." = filter('C*'));
                    }
                    field(SalesPersonManFilter; SalesPersonManFilter)
                    {
                        ApplicationArea = all;
                        Caption = 'Sales Person Manager';
                        TableRelation = "Salesperson/Purchaser";
                    }
                    field(SalesPersonCodeFilter; SalesPersonCodeFilter)
                    {
                        Visible = False;
                        Caption = 'Sales Person code';
                        TableRelation = "Salesperson/Purchaser";
                    }
                }
            }
        }
    }

    trigger OnPreReport()
    var
        ltext001: Label 'You should put the both filter date ';
        ltext002: Label 'Starting Date filter should be inferior then the Ending Date';
    begin

        If (StartDateFilter = 0D) Or (EndtDateFilter = 0D) then
            Error(ltext001);
        IF (StartDateFilter > EndtDateFilter) and (EndtDateFilter <> 0D) then
            Error(ltext002);
        TotalBycustomer := 0;
    end;


    procedure GetItemCategory(pInvoiceNo: Code[20]): Code[20]
    var
        lsalesinvoiceLine: Record 113;
    begin
        lsalesinvoiceLine.Reset();
        lsalesinvoiceLine.SetCurrentKey("Document No.", "Line No.");
        lsalesinvoiceLine.SetRange("Document No.", pInvoiceNo);
        lsalesinvoiceLine.SetRange(Type, lsalesinvoiceLine.Type::Item);
        lsalesinvoiceLine.SetFilter("Item Category Code", '<>%1', '');
        if lsalesinvoiceLine.FindFirst() then;
        Exit(lsalesinvoiceLine."Item Category Code");
    end;

    procedure GetInvoicesOfImpaidCheque(pDocumentNo: Code[20]): Text
    var
        lCustLedgEntry: Record 21;
        lDetCustLedgEntry: Record 379;
        lDetCustLedgInvoice: Record 379;
        lCustLedgInvoice: Record 21;
        lInvoicesNo: Text;
        lText001: Label ' Total Amounts of Invoices = %1 %2';

    begin
        lDetCustLedgEntry.Reset();
        lDetCustLedgEntry.SetRange("Document No.", pDocumentNo);
        lDetCustLedgEntry.SetRange("Initial Document Type", lDetCustLedgEntry."Initial Document Type"::" ");
        lDetCustLedgEntry.SetRange("Entry Type", lDetCustLedgEntry."Entry Type"::Application);
        if lDetCustLedgEntry.FindFirst() then begin
            lCustLedgEntry.Reset();
            lCustLedgEntry.SetRange("Entry No.", lDetCustLedgEntry."Cust. Ledger Entry No.");
            lCustLedgEntry.SetFilter("Cheque No.", '<>%1', '');
            lCustLedgEntry.SetFilter("Code Status", '%1|%2|%3|%4', 'CH-006*', 'TRT-006*', 'CH-007*', 'TRT-007*');
            if lCustLedgEntry.FindFirst() Then BEGIN
                lInvoicesNo := '';
                InvoicesTotal3 := 0;
                lDetCustLedgInvoice.Reset();
                lDetCustLedgInvoice.SetRange("Document No.", lCustLedgEntry."Document No.");
                lDetCustLedgInvoice.SetRange("Initial Document Type", lDetCustLedgInvoice."Initial Document Type"::Invoice);
                lDetCustLedgInvoice.SetRange("Entry Type", lDetCustLedgInvoice."Entry Type"::Application);
                If lDetCustLedgInvoice.FindFirst() then begin
                    repeat
                        IF lCustLedgInvoice.Get(lDetCustLedgInvoice."Cust. Ledger Entry No.") then begin
                            lInvoicesNo := lInvoicesNo + lCustLedgInvoice."Document No." + '-';
                            InvoicesTotal3 += lDetCustLedgInvoice."Amount (LCY)" * (-1);
                        end;
                    until lDetCustLedgInvoice.Next = 0;

                    lInvoicesNo := CopyStr(lInvoicesNo, 1, StrLen(lInvoicesNo) - 1) + StrSubstNo(lText001, Round(InvoicesTotal3, 0.001, '>'), lDetCustLedgEntry."Currency Code");

                END;
            END;
        end;

        exit(lInvoicesNo);
    end;

    var
        GLFilter: Text;
        InvoiceNo3: Text;
        CompanyInfo: Record "Company Information";
        Customer: Record Customer;
        Customer2: Record Customer;
        StartDateFilter: Date;
        EndtDateFilter: Date;
        SalespersonInvoice: code[20];
        SalespersonInvoice2: code[20];
        salesPersonPayment2: Code[20];
        CustomerFilter: Code[20];
        SalesPersonManFilter: Code[20];
        SalesPersonCodeFilter: Code[20];
        InvoiceNo: Code[20];
        InvoiceNo2: Code[20];
        CustToAppear: Boolean;
        TotalPayment: Decimal;
        TotalCHQ_TRT: Decimal;
        TotalBycustomer: Decimal;
        PaymentAmount2: Decimal;
        InvoicesTotal3: Decimal;

}

