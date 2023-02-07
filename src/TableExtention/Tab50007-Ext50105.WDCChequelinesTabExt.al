tableextension 50105 "WDC ChequelinesTabExt" extends "Cheque Line" //50007
{
    fields
    {
        modify("Invoice No.")
        {
            trigger OnAfterValidate()
            begin
                Rec."Remaining Amount invoice" := 0;
                Rec.validate("Remaining Amount invoice", CalcuateRemaininAmountInvoice(Rec."Invoice No."));

            end;
        }
        field(50200; "Amt(LCY) Not Applied"; Decimal)
        {
            Editable = False;
            FieldClass = FlowField;
            CalcFormula = lookup("Cust. Ledger Entry"."Amt(LCY) Not Applied" where("Document No." = field("Invoice No."),
                                                                              "Document Type" = filter(Invoice)));

        }
        field(50201; "Remaining Amount invoice"; Decimal)
        {
            Editable = False;
        }
    }
    trigger OnModify()
    var
        LCHQHeader: Record "Cheque Header";
        ltext001: Label 'You cannot modify a line of blocked document';
        ltext002: Label 'You cannot modify a line of generated document';
    begin
        IF LCHQHeader.Get(Rec."Cheque No.") THEN Begin
            if LCHQHeader.Blocked then
                Error(ltext001);
            if LCHQHeader."Cheque Generated" then
                Error(ltext002);
        End;

    end;

    trigger OnDelete()
    var
        LCHQHeader: Record "Cheque Header";
        ltext001: Label 'You cannot delete a line of blocked document';
        ltext002: Label 'You cannot delete a line of generated document';
        lchqLines: page "Cheque Lines";
    begin
        IF LCHQHeader.Get(Rec."Cheque No.") THEN begin
            if LCHQHeader.Blocked then
                Error(ltext001);
            if LCHQHeader."Cheque Generated" then
                Error(ltext002);
        end;
    end;

    trigger OnInsert()
    var
        LCHQHeader: Record "Cheque Header";
        ltext001: Label 'You cannot insert any line in generated document';
        lchqLines: page "Cheque Lines";
    begin
        IF LCHQHeader.Get(Rec."Cheque No.") THEN begin
            if LCHQHeader."Cheque Generated" then
                Error(ltext001);
        end;
        Rec."Remaining Amount invoice" := 0;
        Rec."Remaining Amount invoice" := CalcuateRemaininAmountInvoice(Rec."Invoice No.");
    end;

    procedure CalcuateRemaininAmountInvoice(pInvoive: Code[20]): Decimal
    Var
        lcustLedgEntry: record "Cust. Ledger Entry";
    begin
        lcustLedgEntry.Reset();
        lcustLedgEntry.SetRange("Document No.", pInvoive);
        lcustLedgEntry.SetRange("Document Type", lcustLedgEntry."Document Type"::Invoice);
        If lcustLedgEntry.FindFirst() then begin
            lcustLedgEntry.CalcFields("Remaining Amt. (LCY)");
            exit(lcustLedgEntry."Remaining Amt. (LCY)");
        end;
        exit(0);
    end;

}
