xmlport 50104 "WDC Import GL Entries"
{
    Direction = Import;
    Format = VariableText;
    TextEncoding = UTF8;
    FieldDelimiter = '"';
    FieldSeparator = ';';
    UseRequestPage = false;
    Permissions = TableData "G/L Entry" = rimd, tabledata "G/L Account" = rimd;
    schema
    {
        textelement(Root)
        {
            tableelement(GLEntries; 17)
            {
                AutoReplace = false;
                AutoSave = false;
                AutoUpdate = false;
                XmlName = 'GLentries';

                fieldelement(CustomerNo; GLEntries."Customer No.")
                {

                }
                fieldelement(Amount; GLEntries.Amount)
                {

                }

                trigger OnBeforeInsertRecord()
                var
                    lGlEntriesDebit: Record 17;
                    lGlEntriesCredit: Record 17;
                begin
                    lGlEntriesDebit.Init();
                    lGlEntriesDebit."Entry No." := lGlEntriesDebit.GetLastEntryNo + 1;
                    lGlEntriesDebit."Document No." := 'WDC CORR';
                    lGlEntriesDebit.Validate("Posting Date", 20220415D);
                    lGlEntriesDebit.Validate("G/L Account No.", '531207');
                    lGlEntriesDebit."Bal. Account Type" := lGlEntriesDebit."Bal. Account Type"::"G/L Account";
                    lGlEntriesDebit.Validate("Bal. Account No.", '531207');
                    lGlEntriesDebit.Amount := GLEntries.Amount;
                    lGlEntriesDebit."Debit Amount" := Abs(GLEntries.Amount);
                    lGlEntriesDebit."Customer No." := GLEntries."Customer No.";
                    lGlEntriesDebit.Insert();

                    lGlEntriesCredit.Init();
                    lGlEntriesCredit."Entry No." := lGlEntriesCredit.GetLastEntryNo + 1;
                    lGlEntriesCredit."Document No." := 'WDC CORR';
                    lGlEntriesCredit.Validate("Posting Date", 20220415D);
                    lGlEntriesCredit.Validate("G/L Account No.", '531207');
                    lGlEntriesCredit."Bal. Account Type" := lGlEntriesCredit."Bal. Account Type"::"G/L Account";
                    lGlEntriesCredit.Validate("Bal. Account No.", '531207');
                    lGlEntriesCredit.Amount := GLEntries.Amount * -1;
                    lGlEntriesCredit."Credit Amount" := Abs(GLEntries.Amount);
                    lGlEntriesCredit."Customer No." := GLEntries."Customer No.";
                    lGlEntriesCredit.Insert();
                ENd;
            }
        }

    }

    var
        lItem: Record Item;
        Cout: Decimal;
        CodeArticle: code[20];
        Compteur: Integer;


    trigger OnPostXmlPort()
    begin
        MESSAGE('Stock importé avec succés');
    end;


}