report 50109 "WDC update cheque status"
{
    dataset
    {
        dataitem(Integer; Integer)
        {
            DataItemTableView = sorting(Number) where(Number = Filter(1));
            trigger OnAfterGetRecord()
            var
                LGLentries: record "G/L Entry";
                ChequeHeader: Record "Cheque Header";
                lCustLegEntry: Record "Cust. Ledger Entry";
                PaymentStatus: Record "WDC payment status";
            begin

                if not Confirm('voulez vous faire les mise a jour des écritures') then
                    Exit;
                //////////////////////UIB2490221/////////////////////////////////
                LGLentries.Reset();
                LGLentries.SetFilter("Entry No.", '%1|%2', 1115089, 1115090);
                If LGLentries.FindFirst() then
                    repeat
                        LGLentries."Code Status" := 'CH-004-01';
                        LGLentries."Description Status" := 'Cheque Encaised Biat';
                        LGLentries."Payment Type" := LGLentries."Payment Type"::Cheque;
                        LGLentries."Cheque No." := LGLentries."Document No.";
                        LGLentries."Customer No." := 'C00122';
                        LGLentries."Sales person No." := 'NHABESSI';
                        if LGLentries.Modify() Then begin
                            if ChequeHeader.Get(LGLentries."Document No.") then Begin
                                ChequeHeader."Code Status" := 'CH-004-01';
                                If ChequeHeader.Modify() then BEGIN
                                    lCustLegEntry.Reset();
                                    lCustLegEntry.SetRange("Document No.", LGLentries."Document No.");
                                    if lCustLegEntry.FindSet() then
                                        repeat
                                            lCustLegEntry."Code Status" := 'CH-004-01';
                                            lCustLegEntry."Description Status" := 'Cheque Encaised Biat';
                                            lCustLegEntry.Modify();
                                        until lCustLegEntry.Next() = 0;
                                end;
                            END;
                        end;
                    Until LGLentries.Next() = 0;
                //////////////////////////BNA2481184///////////////////////////////
                LGLentries.Reset();
                LGLentries.SetFilter("Entry No.", '%1|%2', 1115091, 1115092);
                If LGLentries.FindFirst() then
                    repeat
                        LGLentries."Code Status" := 'CH-004-04';
                        LGLentries."Description Status" := 'Cheque Encaised Uib';
                        LGLentries."Payment Type" := LGLentries."Payment Type"::Cheque;
                        LGLentries."Cheque No." := LGLentries."Document No.";
                        LGLentries."Customer No." := 'C00337';
                        LGLentries."Sales person No." := 'GNOUREDDINE';
                        if LGLentries.Modify() Then begin
                            if ChequeHeader.Get(LGLentries."Document No.") then Begin
                                ChequeHeader."Code Status" := 'CH-004-04';
                                If ChequeHeader.Modify() then BEGIN
                                    lCustLegEntry.Reset();
                                    lCustLegEntry.SetRange("Document No.", LGLentries."Document No.");
                                    if lCustLegEntry.FindSet() then
                                        repeat
                                            lCustLegEntry."Code Status" := 'CH-004-04';
                                            lCustLegEntry."Description Status" := 'Cheque Encaised Uib';
                                            lCustLegEntry.Modify();
                                        until lCustLegEntry.Next() = 0;
                                end;
                            END;
                        end;
                    Until LGLentries.Next() = 0;

                //////////////////// Correction des Cust. Ledg entries qui n'ont pas des client******

                lCustLegEntry.reset;
                lCustLegEntry.SetFilter("Entry No.", '701409|708187|708231|706855|707717|707719|707721|707723|707725|715773|723212|723474|724261|724263|724265|724267|724269|724271|724273|724275|724277|724430|724432|724434|724436|725823');
                if lCustLegEntry.FindFirst() then begin
                    repeat
                        lCustLegEntry.CalcFields("Amount (LCY)");
                        if lCustLegEntry."Document Type" = lCustLegEntry."Document Type"::Payment Then begin
                            if lCustLegEntry."Entry No." = 724271 then //283
                                lCustLegEntry."Customer No." := 'C00448'
                            ELSE
                                if lCustLegEntry."Entry No." = 724273 then //283
                                    lCustLegEntry."Customer No." := 'C01261'
                                ELSE
                                    if lCustLegEntry."Entry No." = 724275 then //283
                                        lCustLegEntry."Customer No." := 'C01344'
                                    ELSE
                                        if lCustLegEntry."Entry No." = 724277 then //283
                                            lCustLegEntry."Customer No." := 'C01344'
                                        ELSE begin
                                            LGLentries.Reset();
                                            LGLentries.SetRange("Document No.", lCustLegEntry."Document No.");
                                            LGLentries.SetRange("Bal. Account Type", LGLentries."Bal. Account Type"::Customer);
                                            LGLentries.Setrange("Document Type", LGLentries."Document Type"::" ");
                                            LGLentries.Setfilter("G/L Account No.", '890');
                                            if LGLentries.FindFirst() then begin
                                                IF LGLentries."Bal. Account No." <> '' then begin
                                                    lCustLegEntry."Customer No." := LGLentries."Bal. Account No.";
                                                    lCustLegEntry.Modify();
                                                end;
                                            end;
                                        end;
                            lCustLegEntry.Modify();
                        end else begin
                            if lCustLegEntry."Document Type" = lCustLegEntry."Document Type"::" " Then begin
                                if lCustLegEntry."Entry No." = 701409 then //143
                                    lCustLegEntry."Customer No." := 'C01340';
                                if lCustLegEntry."Entry No." = 708231 then //150
                                    lCustLegEntry."Customer No." := 'C00205';
                                if lCustLegEntry."Entry No." = 708187 then //266
                                    lCustLegEntry."Customer No." := 'C00209';
                                if lCustLegEntry."Entry No." = 706855 then //486
                                    lCustLegEntry."Customer No." := 'C00675';
                                lCustLegEntry.Modify();
                            end;
                        End;
                    Until lCustLegEntry.Next = 0;
                end;

                //////////////////// Correction des balance 413 ******
                LGLentries.Reset();
                LGLentries.SetRange("Bal. Account Type", LGLentries."Bal. Account Type"::"G/L Account");
                LGLentries.SetFilter("G/L Account No.", '%1|%2|%3|%4', '4130391', '4131098', '4131114', '4131169');
                If LGLentries.FindFirst() then
                    repeat
                        Customer.reset;
                        Customer.SetRange("Related Custommer", LGLentries."Source No.");
                        if Customer.FindFirst() then begin
                            LGLentries."Source No." := Customer."No.";
                            LGLentries."G/L Account No." := '411001';
                            LGLentries.Modify();
                        end;

                    Until LGLentries.Next = 0;

            end;
        }
    }
    var
        AmountLCY: Decimal;
        customerNo: Code[20];
        Customer: record Customer;
}
