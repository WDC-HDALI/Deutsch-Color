tableextension 50104 "WDC ChequeHeaderTabExt" extends "Cheque Header" //50004
{
    fields
    {
        field(50200; "Code Status"; Code[20])
        {
            TableRelation = "WDC payment status";
            DataClassification = ToBeClassified;
            Editable = False;
        }

        field(50202; "Description Status"; Text[100])
        {
            Editable = False;
            FieldClass = FlowField;
            CalcFormula = lookup("WDC payment status"."Description Status" where("Code Status" = field("Code Status")));
        }
        field(50203; "Cheque Generated"; Boolean)
        {
            Editable = False;
        }

        field(50206; "Cheque Reversed"; Boolean)
        {
            Editable = False;
        }
        field(50207; "Previous Code Status"; Code[20])
        {
            TableRelation = "WDC payment status";
            DataClassification = ToBeClassified;
            Editable = False;
        }
        field(50208; "Blocked"; Boolean)
        {

        }
        field(50209; "Collection date"; Date)
        {
            Editable = False;
            FieldClass = FlowField;
            CalcFormula = lookup("G/L Entry"."Posting Date" where("Cheque No." = field("Cheque No."),
                                                                 "Code Status" = FILTER('TRT-004-* | CH-004-*'),
                                                                 "Bal. Account Type" = filter(3),
                                                                 "Description Status" = FIELD("Description Status")));
        }

    }
    trigger OnRename()
    var
    begin
        TestField("Cheque Generated", false);
    end;

    trigger OnModify()
    var
    begin
        if Blocked = xRec.Blocked then
            TestField(Blocked, false);
        if ("Cheque Generated" = xRec."Cheque Generated") and (Blocked = xRec.Blocked) then
            TestField("Cheque Generated", false);

    end;

    trigger OnDelete()
    var
        myInt: Integer;
        Ltext001: Label 'You cannot delete an applied document';
    begin

        If "Code Status" <> '' Then
            Error(Ltext001)
        Else begin
            DeletePaymentJournalLines(Rec."Cheque No.");
            DeleteChequeLines(Rec."Cheque No.");
        end;

    end;

    procedure DeletePaymentJournalLines(pChequeNo: code[20])
    var
        lPaymentJournalLine: record "Gen. Journal Line";
    begin
        lPaymentJournalLine.Reset();
        lPaymentJournalLine.SetRange("Cheque No.", pChequeNo);
        If lPaymentJournalLine.FindFirst() Then
            lPaymentJournalLine.DeleteAll();
    End;

    procedure DeleteChequeLines(pChequeNo: code[20])
    var
        LchequeLines: record "Cheque Line";
    begin
        LchequeLines.Reset();
        LchequeLines.SetRange("Cheque No.", pChequeNo);
        If LchequeLines.FindFirst() Then
            LchequeLines.DeleteAll();
    End;

}
