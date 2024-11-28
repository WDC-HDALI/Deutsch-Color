tableextension 50103 "WDC CustLedgerEntrTabExt" extends "Cust. Ledger Entry" //21
{
    fields
    {

        field(50200; "Code Status"; Code[20])
        {
            TableRelation = "WDC payment status";
            DataClassification = ToBeClassified;
            Editable = False;

        }
        field(50201; "Payment Type"; Enum "WDC Payment Type")
        {
            DataClassification = ToBeClassified;
            Editable = False;
        }
        field(50202; "Description Status"; Text[100])
        {
            Editable = False;
            DataClassification = ToBeClassified;

        }
        field(50203; "Cheque No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = False;
        }


        field(50205; "Sales person No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = False;
        }

        field(50206; "Amt(LCY) Not Applied"; Decimal)
        {
            Editable = False;
            DataClassification = ToBeClassified;
        }

    }
    keys
    {
        key(Key1; "Cheque No.", "Code Status")
        {

        }
        key(Key2; "Cheque No.")
        {

        }
    }
}

