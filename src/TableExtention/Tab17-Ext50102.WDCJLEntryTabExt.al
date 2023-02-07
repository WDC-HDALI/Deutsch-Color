tableextension 50102 "WDC JLEntryTabExt" extends "G/L Entry" //17
{
    fields
    {
        field(50200; "Code Status"; Code[20])
        {
            TableRelation = "WDC payment status";
            DataClassification = ToBeClassified;
        }
        field(50201; "Payment Type"; Enum "WDC Payment Type")
        {
            DataClassification = ToBeClassified;
        }
        field(50202; "Description Status"; Text[100])
        {
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(50203; "Cheque No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50204; "Customer No."; Code[20])
        {
            TableRelation = Customer;
            DataClassification = ToBeClassified;

        }
        field(50205; "Sales person No."; Code[20])
        {
            DataClassification = ToBeClassified;

        }
    }

}