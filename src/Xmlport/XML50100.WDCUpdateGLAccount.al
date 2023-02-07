xmlport 50100 "WDC Update GL Account"
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
            tableelement(GLAccount; "G/L Account")
            {
                AutoReplace = false;
                AutoSave = false;
                AutoUpdate = false;
                XmlName = 'GLAccount';

                fieldelement(GLAccount2; "GLAccount"."No.")
                {

                }
                fieldelement(GLAccountCorresp; "GLAccount"."No. 2")
                {

                }


                trigger OnBeforeInsertRecord()
                begin
                    if GLAccount."No." = GLAccount."No. 2" then
                        currXMLport.Skip();
                    if not GLAccount2.get(GLAccount."No.") then
                        currXMLport.Skip();
                    if not GLAccount2.get(GLAccount."No. 2") then
                        currXMLport.Skip();

                    GLEntryUpdated.Reset();
                    GLEntryUpdated.SetCurrentKey("G/L Account No.", "Posting Date");
                    GLEntryUpdated.SetRange("G/L Account No.", "GLAccount"."No.");
                    IF GLEntryUpdated.FindSet() then
                        repeat
                            GLEntryChanged.GET(GLEntryUpdated."Entry No.");
                            GLEntryChanged."G/L Account No." := "GLAccount"."No. 2";
                            GLEntryChanged.Modify();
                        until GLEntryUpdated.Next() = 0;
                end;

            }

        }

    }
    var
        GLEntryUpdated: Record "G/L Entry";
        GLEntryChanged: Record "G/L Entry";
        GLAccount2: Record "G/L Account";
        Text001: Label 'Import completed';

    trigger OnPostXmlPort()

    begin
        Message(Text001);
    end;


}