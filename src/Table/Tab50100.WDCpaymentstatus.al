table 50100 "WDC payment status"
{
    LookupPageId = 50100;
    DrillDownPageId = 50100;

    fields
    {
        field(1; "Code Status"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "payment Type"; Enum "WDC Payment Type")
        {

            DataClassification = ToBeClassified;
        }
        field(3; "Description Status"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Unpaid Step"; Boolean)
        {
            DataClassification = ToBeClassified;
        }

    }
    keys
    {
        key(Key1; "Code Status")
        {
            Clustered = true;
        }

    }
    fieldgroups
    {
        fieldgroup(DropDown; "Code Status", "Description Status")
        {

        }

    }




}