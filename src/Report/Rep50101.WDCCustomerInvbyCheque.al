report 50101 "WDC Customer Inv. by Cheque"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/Report/RDLC/WDCCustomerInvCHQ.rdl';
    AdditionalSearchTerms = 'Customer Inv. by Cheque';
    ApplicationArea = Basic, Suite;
    Caption = 'Customer Inv. by Cheque';
    EnableHyperlinks = true;
    UsageCategory = ReportsAndAnalysis;
    Description = 'Customer Inv. by Cheque';
    dataset
    {
        dataitem(Header; "Integer")
        {
            DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
            column(STRSUBSTNO_Text000_FORMAT_EndDate_; StrSubstNo(Text000Lbl, Format(EndDate)))
            {
            }
            column(COMPANYNAME; COMPANYPROPERTY.DisplayName)
            {
            }
            column(Customer_TABLECAPTION_CustFilter; Customer.TableCaption + ': ' + CustFilter)
            {
            }
            column(CustFilter; CustFilter)
            {
            }
            column(Customer_Detailed_AgingCaption; Customer_Detailed_AgingCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Cust_Ledger_Entry_Posting_Date_Caption; Cust_Ledger_Entry_Posting_Date_CaptionLbl)
            {
            }
            column(Cust_Ledger_Entry_Document_No_Caption; "Cust. Ledger Entry".FieldCaption("Document No."))
            {
            }
            column(Cust_Ledger_Entry_DescriptionCaption; "Cust. Ledger Entry".FieldCaption(Description))
            {
            }
            column(Cust_Ledger_Entry_Due_Date_Caption; Cust_Ledger_Entry_Due_Date_CaptionLbl)
            {
            }
            column(OverDueMonthsCaption; OverDueMonthsCaptionLbl)
            {
            }
            column(Cust_Ledger_Entry_Remaining_Amount_Caption; "Cust. Ledger Entry".FieldCaption("Remaining Amount"))
            {
            }
            column(Cust_Ledger_Entry_Currency_Code_Caption; "Cust. Ledger Entry".FieldCaption("Currency Code"))
            {
            }
            column(Cust_Ledger_Entry_Remaining_Amt_LCY_Caption; "Cust. Ledger Entry".FieldCaption("Remaining Amt. (LCY)"))
            {
            }
            column(Customer_Phone_No_Caption; Customer.FieldCaption("Phone No."))
            {
            }
            dataitem(Customer; Customer)
            {
                PrintOnlyIfDetail = true;
                RequestFilterFields = "No.", "Customer Posting Group", "Currency Filter", "Payment Terms Code";
                column(Customer_No_; "No.")
                {
                }
                column(Customer_Name; Name)
                {
                }
                column(Customer_Phone_No_; "Phone No.")
                {
                }
                column(CustomerContact; Contact)
                {
                }
                column(EMail; "E-Mail")
                {
                }
                column(TTC_Return_Not_Invoiced; "Return Not Invoiced")
                {
                }
                column(TTC_Shippement_Not_Invoiced; "Shipment Not Invoiced")
                {
                }
                dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
                {
                    DataItemLink = "Customer No." = FIELD("No."), "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"), "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"), "Currency Code" = FIELD("Currency Filter"), "Date Filter" = FIELD("Date Filter");
                    DataItemTableView = SORTING("Customer No.", "Posting Date", "Currency Code") order(descending);
                    column(Cust_Ledger_Entry_Posting_Date_;
                    Format("Posting Date"))
                    {
                    }
                    column(Cust_Ledger_Entry_Document_No_; "Document No.")
                    {
                    }
                    column(Cust_Ledger_Entry_Description; Description)
                    {
                    }
                    column(Cust_Ledger_Entry_Due_Date_; Format(DocDueDate))
                    {
                    }

                    column(DocState; DocState)
                    {
                    }
                    column(OverDueMonths; OverDueMonths)
                    {
                        AutoFormatExpression = "Currency Code";
                        AutoFormatType = 1;
                    }
                    column(Cust_Ledger_Entry_Remaining_Amount_; "Remaining Amount")
                    {
                        AutoFormatExpression = "Currency Code";
                        AutoFormatType = 1;
                    }
                    column(Cust_Ledger_Entry_Currency_Code_; "Currency Code")
                    {
                    }
                    column(Cust_Ledger_Entry_Remaining_Amt_LCY_; "Remaining Amt. (LCY)")
                    {
                        AutoFormatType = 1;
                    }
                    //<<WDC
                    column(Cust_Ledger_Entry_Document_Type; "Document Type")
                    {

                    }
                    column(Cust_Ledger_Entry_Payment_Type; "Payment Type")
                    {

                    }
                    column(Cust_Ledger_Entry_Code_Status; "Code Status")
                    {

                    }
                    column(Cust_Ledger_Entry_Description_Status; "Description Status")
                    {

                    }
                    column(Cust_Ledger_Entry_Cheque_No_; "Cheque No.")
                    {

                    }
                    column(Cust_Ledger_Entry_Sales_person_No_; "Sales person No.")
                    {

                    }
                    column(Description_CustLedEntries; Description_CustLedEntries)
                    {

                    }

                    column(AmountInvoiceInCHQ; AmountInvoiceInCHQ)//WDC_HD
                    {

                    }
                    column(AmountCHQ; AmountCHQ)//WDC_HD
                    {

                    }

                    column(Amount__LCY_; Amount__LCY)//WDC_HD
                    {

                    }
                    column(Remainning_Amount__LCY; Remainning_Amount__LCY)//WDC_HD
                    {

                    }
                    column(Paymet_Type_Text; Paymet_Type_Text)//WDC_HD
                    {

                    }

                    column(TotalInvoices; TotalInvoices)//WDC_HD
                    {

                    }
                    column(TotalPaymennt; TotalPaymennt)//WDC_HD
                    {

                    }
                    column(TotalStartigAmount; TotalStartigAmount)//WDC_HD
                    {

                    }
                    column(TotalEmptyDocuType; TotalEmptyDocuType)//WDC_HD
                    {

                    }
                    column(TotalCheque; TotalCheque)//WDC_HD
                    {

                    }
                    column(DocumentNo; DocumentNo)//WDC_HD
                    {

                    }
                    column(DueDatePassed; DueDatePassed)//WDC_HD
                    {

                    }
                    column(Reversed; Reversed)
                    {

                    }


                    trigger OnAfterGetRecord()
                    var
                        lCHQLines: record "Cheque Line";
                        lBatchName: record 232;
                        LchequeHeader: record "Cheque Header";
                        TextDocState: Label 'Expired';
                    begin
                        //>>WDC_HD
                        Clear(Paymet_Type_Text);
                        Clear(DocumentNo);
                        Clear(DocState);
                        DueDatePassed := 0;
                        Amount__LCY := 0;
                        Remainning_Amount__LCY := 0;
                        "Cust. Ledger Entry".CalcFields("Amount (LCY)");
                        "Cust. Ledger Entry".CalcFields("Remaining Amt. (LCY)");

                        lBatchName.Reset();
                        lBatchName.SetRange("Code Status", "Cust. Ledger Entry"."Code Status");
                        if lBatchName.FindFirst() then;

                        If ("Cust. Ledger Entry".Open = TRUE) AND (("Cust. Ledger Entry"."Document Type" = "Cust. Ledger Entry"."Document Type"::Invoice) or ("Cust. Ledger Entry"."Document Type" = "Cust. Ledger Entry"."Document Type"::"Credit Memo")) Then Begin
                            Paymet_Type_Text := 'Invoices /Credit Memo';
                            DocumentNo := "Cust. Ledger Entry"."Document No.";
                            Amount__LCY := "Cust. Ledger Entry"."Amount (LCY)";
                            Remainning_Amount__LCY := "Cust. Ledger Entry"."Remaining Amt. (LCY)";
                            TotalInvoices += "Cust. Ledger Entry"."Remaining Amt. (LCY)";
                            DocDueDate := "Cust. Ledger Entry"."Due Date";
                            DueDatePassed := GetDueDatePassed(DocumentNo);
                        ENd ELSE
                            If ("Cust. Ledger Entry".Open = TRUE) AND (("Cust. Ledger Entry"."Document Type" = "Cust. Ledger Entry"."Document Type"::payment) AND ("Cust. Ledger Entry"."Cheque No." = '')) Then Begin
                                Paymet_Type_Text := 'Payment';
                                Amount__LCY := "Cust. Ledger Entry"."Amount (LCY)";
                                Remainning_Amount__LCY := "Cust. Ledger Entry"."Remaining Amt. (LCY)";
                                TotalPaymennt += "Cust. Ledger Entry"."Remaining Amt. (LCY)";
                                DocumentNo := "Cust. Ledger Entry"."Cheque No.";
                                DocDueDate := GetDueDateFromCheque("Cust. Ledger Entry"."Cheque No.");
                            End ELSE
                                If ("Cust. Ledger Entry".Open = TRUE) AND (("Cust. Ledger Entry"."Document Type" = "Cust. Ledger Entry"."Document Type"::" ") AND ("Cust. Ledger Entry"."Posting Date" = "Starting Date")) Then Begin
                                    Paymet_Type_Text := 'Amount 01.08.2021';
                                    DocumentNo := "Cust. Ledger Entry"."Document No.";
                                    Amount__LCY := "Cust. Ledger Entry"."Amount (LCY)";
                                    Remainning_Amount__LCY := "Cust. Ledger Entry"."Remaining Amt. (LCY)";
                                    TotalStartigAmount += "Cust. Ledger Entry"."Remaining Amt. (LCY)";
                                    DocDueDate := "Cust. Ledger Entry"."Due Date";
                                    DueDatePassed := GetDueDatePassed(DocumentNo)
                                End ELSE
                                    If ("Cust. Ledger Entry".Open = TRUE) AND (("Cust. Ledger Entry"."Document Type" = "Cust. Ledger Entry"."Document Type"::" ") AND ("Cust. Ledger Entry"."Posting Date" <> "Starting Date")) THEN Begin
                                        Paymet_Type_Text := '';
                                        DocumentNo := "Cust. Ledger Entry"."Document No.";
                                        Amount__LCY := "Cust. Ledger Entry"."Amount (LCY)";
                                        Remainning_Amount__LCY := "Cust. Ledger Entry"."Remaining Amt. (LCY)";
                                        TotalEmptyDocuType += "Cust. Ledger Entry"."Remaining Amt. (LCY)";
                                        DocDueDate := "Cust. Ledger Entry"."Due Date";
                                        DueDatePassed := GetDueDatePassed(DocumentNo);
                                    End else begin
                                        //<<SAT
                                        //If ("Cust. Ledger Entry"."Cheque No." <> '') AND (not (IsUnpaidStep("Cust. Ledger Entry"."Code Status"))) AND
                                        //((Not lBatchName."Last Step of Cheque") AND (Not lBatchName."Last Step of Traite") OR ("Cust. Ledger Entry"."Remaining Amt. (LCY)" <> 0)) AND
                                        //(("Cust. Ledger Entry".Reversed = FAlse) AND ("Cust. Ledger Entry".Open = True) And ("Cust. Ledger Entry"."Remaining Amt. (LCY)" <> 0)) AND ("Cust. Ledger Entry"."Code Status" <> '') then begin

                                        If ("Cust. Ledger Entry"."Cheque No." <> '') AND ("Cust. Ledger Entry"."Document Type" = "Cust. Ledger Entry"."Document Type"::Payment) AND (not (IsUnpaidStep("Cust. Ledger Entry"."Code Status", "Cust. Ledger Entry"."Cheque No.", "Cust. Ledger Entry"."Customer No."))) AND
                                        ((Not lBatchName."Last Step of Cheque") AND (Not lBatchName."Last Step of Traite")) AND
                                        not (("Cust. Ledger Entry".Reversed = TRUE) AND ("Cust. Ledger Entry".Open = FALSE) And ("Cust. Ledger Entry"."Remaining Amt. (LCY)" = 0)) then begin

                                            Amount__LCY := ABS("Cust. Ledger Entry"."Amount (LCY)");
                                            Remainning_Amount__LCY := Abs("Cust. Ledger Entry"."Remaining Amt. (LCY)");
                                            if (STRPOS("Cust. Ledger Entry"."Code Status", 'CH-006') = 0) AND (STRPOS("Cust. Ledger Entry"."Code Status", 'TRT-006') = 0) AND
                                                (STRPOS("Cust. Ledger Entry"."Code Status", 'CH-007') = 0) AND (STRPOS("Cust. Ledger Entry"."Code Status", 'TRT-007') = 0) then
                                                TotalCheque += Amount__LCY - Remainning_Amount__LCY
                                            else
                                                TotalCheque += Remainning_Amount__LCY;
                                            //TotalCheque += Amount__LCY - Remainning_Amount__LCY;
                                            //>>SAT  
                                            Paymet_Type_Text := 'Cheque/Traite';
                                            DocumentNo := "Cust. Ledger Entry"."Cheque No.";
                                            DocDueDate := GetDueDateFromCheque("Cust. Ledger Entry"."Cheque No.");
                                        end else
                                            CurrReport.Skip();
                                    end;
                        If DocDueDate < Today Then
                            DocState := TextDocState;
                        //<<WDC_HD 
                    end;

                    trigger OnPreDataItem()
                    begin

                    end;

                }
                dataitem("Integer"; "Integer")
                {
                    DataItemTableView = SORTING(Number) WHERE(Number = FILTER(1 ..));
                    column(TempCurrencyTotalBuffer_Total_Amount_; TempCurrencyTotalBuffer."Total Amount")
                    {
                        AutoFormatExpression = TempCurrencyTotalBuffer."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(TempCurrencyTotalBuffer_Currency_Code_; TempCurrencyTotalBuffer."Currency Code")
                    {
                    }
                    column(TempCurrencyTotalBuffer_Total_Amount_LCY_; TempCurrencyTotalBuffer."Total Amount (LCY)")
                    {
                        AutoFormatType = 1;
                    }

                    trigger OnAfterGetRecord()
                    begin
                        if Number = 1 then
                            OK := TempCurrencyTotalBuffer.Find('-')
                        else
                            OK := TempCurrencyTotalBuffer.Next <> 0;
                        if not OK then
                            CurrReport.Break();
                        TempCurrencyTotalBuffer2.UpdateTotal(
                          TempCurrencyTotalBuffer."Currency Code",
                          TempCurrencyTotalBuffer."Total Amount",
                          TempCurrencyTotalBuffer."Total Amount (LCY)", Counter1);
                    end;

                    trigger OnPostDataItem()
                    begin
                        TempCurrencyTotalBuffer.DeleteAll();
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    TotalInvoices := 0;
                    TotalCheque := 0;
                    TotalPaymennt := 0;
                    TotalStartigAmount := 0;
                    TotalEmptyDocuType := 0;
                end;

                trigger OnPreDataItem()
                begin
                    if OnlyOpen then
                        NumCustLedgEntriesperCust.SetRange(OpenValue, TRUE);

                    if NumCustLedgEntriesperCust.Open then
                        while NumCustLedgEntriesperCust.Read do
                            if not CustomersWithLedgerEntriesList.Contains(NumCustLedgEntriesperCust.Customer_No) then
                                CustomersWithLedgerEntriesList.Add(NumCustLedgEntriesperCust.Customer_No);
                end;
            }
            dataitem(Integer2; "Integer")
            {
                DataItemTableView = SORTING(Number) WHERE(Number = FILTER(1 ..));
                column(TempCurrencyTotalBuffer2_Currency_Code_; TempCurrencyTotalBuffer2."Currency Code")
                {
                }
                column(TempCurrencyTotalBuffer2_Total_Amount_; TempCurrencyTotalBuffer2."Total Amount")
                {
                    AutoFormatExpression = TempCurrencyTotalBuffer."Currency Code";
                    AutoFormatType = 1;
                }
                column(TempCurrencyTotalBuffer2_Total_Amount_LCY_; TempCurrencyTotalBuffer2."Total Amount (LCY)")
                {
                    AutoFormatType = 1;
                }
                column(TotalCaption; TotalCaptionLbl)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if Number = 1 then
                        OK := TempCurrencyTotalBuffer2.Find('-')
                    else
                        OK := TempCurrencyTotalBuffer2.Next <> 0;
                    if not OK then
                        CurrReport.Break();
                end;

                trigger OnPostDataItem()
                begin
                    TempCurrencyTotalBuffer2.DeleteAll();
                end;
            }
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field("Ending Date"; EndDate)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Ending Date';
                        ToolTip = 'Specifies the end of the period covered by the report (for example, 12/31/17).';
                    }
                    field(ShowOpenEntriesOnly; OnlyOpen)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Show Open Entries Only';
                        ToolTip = 'Specifies that you want to only show open entries relating to the list of the customers'' balances that are due.';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            if EndDate = 0D then
                EndDate := CALCDATE('<CM+30D>', WORKDATE);   //WDC  

            OnlyOpen := TRUE;   //WDC
            "Starting Date" := 20210801D;
        end;
    }

    labels
    {
        CustomerContactCaption = 'Contact';
    }

    trigger OnPreReport()
    var
        FormatDocument: Codeunit "Format Document";
    begin
        CustFilter := FormatDocument.GetRecordFiltersWithCaptions(Customer);
    end;

    var

        Text000Lbl: Label 'As of %1', Comment = '%1 is the as of date';
        TempCurrencyTotalBuffer: Record "Currency Total Buffer" temporary;
        TempCurrencyTotalBuffer2: Record "Currency Total Buffer" temporary;

        NumCustLedgEntriesperCust: Query "Num CustLedgEntries per Cust";
        CustomersWithLedgerEntriesList: List of [Code[20]];
        EndDate: Date;
        CustFilter: Text;
        OverDueMonths: Integer;
        OK: Boolean;
        Counter: Integer;
        Counter1: Integer;
        OnlyOpen: Boolean;
        Customer_Detailed_AgingCaptionLbl: Label 'Customer Detailed Aging';

        CurrReport_PAGENOCaptionLbl: Label 'Page';
        Cust_Ledger_Entry_Posting_Date_CaptionLbl: Label 'Posting Date';
        Cust_Ledger_Entry_Due_Date_CaptionLbl: Label 'Due Date';
        OverDueMonthsCaptionLbl: Label 'Months Due';
        TotalCaptionLbl: Label 'Total';
        DocStateCaption: Label 'Document Satate';
        Description_CustLedEntries: Text;   //WDC

        ChequeHeader: Record "Cheque Header"; //WDC 

        i: Integer;
        //>>WDC_HD
        AmountInvoiceInCHQ: Decimal;
        AmountCHQ: Decimal;
        Amount__LCY: Decimal;
        Remainning_Amount__LCY: Decimal;
        Paymet_Type_Text: text;
        TotalInvoices: Decimal;
        TotalPaymennt: Decimal;
        TotalStartigAmount: Decimal;
        TotalEmptyDocuType: Decimal;
        TotalCheque: Decimal;
        DocumentNo: Text;
        DocDueDate: Date;
        DocState: Text;
        DueDatePassed: Integer;
        "Starting Date": date;
    //<<WDC_HD
    procedure InitializeRequest(SetEndDate: Date; SetOnlyOpen: Boolean)
    begin
        EndDate := SetEndDate;
        OnlyOpen := SetOnlyOpen;
    end;

    procedure GetDueDateFromCheque(pCHEqueNo: Code[20]): Date;
    var
        lchequeHeader: Record "Cheque Header";
    begin
        if lchequeHeader.Get(pCHEqueNo) then
            exit(lchequeHeader."Due Date");
        exit(0D);
    end;

    procedure GetDueDatePassed(pInvoiceNo: Code[20]): Integer;
    var
        lSalesInvoiceHeader: Record "Sales Invoice Header";
    begin
        if lSalesInvoiceHeader.Get(pInvoiceNo) then
            exit(today - lSalesInvoiceHeader."Due Date");
        exit(0);
    end;

    local procedure CalcFullMonthsBetweenDates(FromDate: Date; ToDate: Date): Integer
    var
        FullMonths: Integer;
        LeftOverDays: Integer;
    begin
        FullMonths := (Date2DMY(ToDate, 3) - Date2DMY(FromDate, 3)) * 12 + Date2DMY(ToDate, 2) - Date2DMY(FromDate, 2) - 1;

        if Date2DMY(ToDate, 1) = Date2DMY(CalcDate('<CM>', ToDate), 1) then
            FullMonths += 1
        else
            LeftOverDays := Date2DMY(ToDate, 1);

        if Date2DMY(FromDate, 1) - LeftOverDays <= 1 then
            FullMonths += 1;

        exit(FullMonths);
    end;

    procedure IsUnpaidStep(pCodeStatus: Code[20]; pChequeNo: Code[20]; pCustNo: Code[20]): Boolean;
    var
        lPaymentStatus: Record "WDC payment status";
        lBatChName: Record 236;
        lCustLedgEnt: Record 21;
    begin
        //<<SAT
        //IF lPaymentStatus.Get(pCodeStatus) then
        //    exit(lPaymentStatus."Unpaid Step");
        if (STRPOS(format(pCodeStatus), 'CH-006') = 0) AND (STRPOS(format(pCodeStatus), 'TRT-006') = 0) AND
        (STRPOS(format(pCodeStatus), 'CH-007') = 0) AND (STRPOS(format(pCodeStatus), 'TRT-007') = 0) then
            exit(false);
        lCustLedgEnt.Reset();
        lCustLedgEnt.SetRange("Document Type", lCustLedgEnt."Document Type"::" ");
        lCustLedgEnt.SetRange("Customer No.", pCustNo);
        lCustLedgEnt.SetRange("Cheque No.", pChequeNo);
        if lCustLedgEnt.Count = 0 then
            exit(false)
        else
            exit(true);
        //>>SAT
    end;

}

