tableextension 50101 "WDC JournalBatchJTabExt" extends "Gen. Journal Batch" //232
{
    fields
    {
        field(50200; "Code Status"; Code[20])
        {
            TableRelation = "WDC payment status";
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                lPaymentStatus: Record 50100;
            begin
                Clear(Rec."Payment Type");
                Clear(Rec."Description Status");
                if lPaymentStatus.Get("Code Status") then begin
                    Rec."Payment Type" := lPaymentStatus."payment Type";
                    Rec."Description Status" := lPaymentStatus."Description Status";
                end;
            end;
        }
        field(50201; "Payment Type"; Enum "WDC Payment Type")
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50202; "Description Status"; Text[100])
        {
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(50204; "First Step of cheque"; Boolean)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                lBatchName: record 232;
            begin
                lBatchName.Reset();
                lBatchName.SetRange("First Step of cheque", true);
                if lBatchName.FindFirst() then
                    if lBatchName.Name <> rec.Name then
                        Error(Text0001);
            end;
        }
        field(50205; "First Step of Traite"; Boolean)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                lBatchName: record 232;
            begin
                lBatchName.Reset();
                lBatchName.SetRange("First Step of Traite", true);
                if lBatchName.FindFirst() then
                    if lBatchName.Name <> rec.Name then
                        Error(Text0001);
            end;
        }
        field(50206; "Last Step of Cheque"; Boolean)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                lBatchName: record 232;
            begin

            end;
        }
        field(50207; "Last Step of Traite"; Boolean)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                lBatchName: record 232;

            begin

            end;
        }

    }
    var
        Text0001: Label 'There is another batch name which is checked to do this Step';

}