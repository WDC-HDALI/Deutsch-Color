pageextension 50108 "WDC Customer List" extends "Customer List" //22
{
    actions
    {
        addfirst(processing)
        {
            action(WDC_CustomerPaymentsTracking)
            {
                ApplicationArea = All;
                Caption = 'Customer Payments Tracking';
                Image = PaymentForecast;
                RunObject = report "WDC Customer Payments Tracking";
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;

            }
            action(WDC_CustomerInvByCHQ)
            {
                ApplicationArea = All;
                Caption = 'Customer Invoices By Cheque';
                Image = PaymentJournal;
                RunObject = report "WDC Customer Inv. by Cheque";
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;

            }
            action(WDC_Total_BySales_Person)
            {
                ApplicationArea = All;
                Caption = 'Total by Sales Serson';
                Image = PaymentHistory;
                RunObject = report "WDC Total by Sales Person";
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;

            }
            action(WDC_Payment_Application)
            {
                ApplicationArea = All;
                Caption = 'Payments Applications';
                Image = ApplyEntries;
                RunObject = report "WDC Payments Applications";
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;

            }
            action(WDC_AnaliticOverdueInvoices)
            {
                ApplicationArea = All;
                Caption = 'Analitic Overdue Invoices';
                Image = ApplyEntries;
                RunObject = report "WDC Analitic Overdue Invoices";
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;

            }
            action(WDC_CustDebitProgress)
            {
                ApplicationArea = All;
                Caption = 'Customer Debit Progress';
                Image = ApplyEntries;
                RunObject = report "WDC Customer Debit Progress";
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;

            }
        }
    }
}
