pageextension 50111 "WDC Cust. Posting Group List" extends "Customer Posting Groups" //110
{
    actions
    {
        addlast(Navigation)
        {
            action(WDC_UpdateGLAccount)
            {
                ApplicationArea = All;
                Caption = 'WDC Update GL Account';
                Image = PaymentForecast;
                RunObject = xmlport "WDC Update GL Account";
                Promoted = true;
                PromotedIsBig = true;
            }
            action(WDC_UpdatePostingGroup)
            {
                ApplicationArea = All;
                Caption = 'WDC Update Posting Group';
                Image = UpdateUnitCost;
                RunObject = xmlport "WDC Update Posting Group";
                Promoted = true;
                PromotedIsBig = true;
            }
            action(WDC_RenameChequeList)
            {
                ApplicationArea = All;
                Caption = 'WDC Rename Cheque';
                Image = UpdateDescription;
                RunObject = report "WDC Update Cheque Code";
                Promoted = true;
                PromotedIsBig = true;
            }
            action(WDC_ImportCheque)
            {
                ApplicationArea = All;
                Caption = 'WDC Import Cheque';
                Image = ImportChartOfAccounts;
                RunObject = xmlport "WDC Import Cheque List";
                Promoted = true;
                PromotedIsBig = true;
            }
            action(WDC_ImportChequeLastStep)
            {
                ApplicationArea = All;
                Caption = 'WDC Import Cheque Last Step';
                Image = ImportCodes;
                RunObject = xmlport "WDC Import Cheque Last Step";
                Promoted = true;
                PromotedIsBig = true;
            }
        }
    }
}
