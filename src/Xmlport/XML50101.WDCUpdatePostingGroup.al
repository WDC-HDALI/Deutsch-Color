xmlport 50101 "WDC Update Posting Group"
{
    Direction = Import;
    Format = VariableText;
    TextEncoding = UTF8;
    FieldDelimiter = '"';
    FieldSeparator = ';';
    UseRequestPage = false;
    Permissions = TableData "Customer Posting Group" = rimd, tabledata "Sales Header" = rimd;
    schema
    {
        textelement(Root)
        {
            tableelement("Customer Posting Group"; "Customer Posting Group")
            {
                AutoReplace = false;
                AutoSave = false;
                AutoUpdate = false;
                XmlName = 'CustomerPostingGroup';

                fieldelement(CustPosGroup; "Customer Posting Group"."Receivables Account")
                {

                }
                fieldelement(CustPosGroupNew; "Customer Posting Group".Code)
                {

                }

                trigger OnBeforeInsertRecord()
                begin
                    if "Customer Posting Group"."Receivables Account" = "Customer Posting Group"."Code" then
                        currXMLport.Skip();
                    if not CustPostingGroup2.get("Customer Posting Group"."Code") then
                        currXMLport.Skip();
                    if not CustPostingGroup2.get("Customer Posting Group"."Receivables Account") then
                        currXMLport.Skip();

                    SalesHeader.Reset();
                    SalesHeader.SetRange("Customer Posting Group", "Customer Posting Group"."Receivables Account");
                    if SalesHeader.FindSet() then
                        repeat
                            SalesHeaderUpdate.reset;
                            SalesHeaderUpdate.get(SalesHeader."Document Type", SalesHeader."No.");
                            SalesHeaderUpdate."Customer Posting Group" := "Customer Posting Group".Code;
                            SalesHeaderUpdate.Modify();
                        until SalesHeader.Next() = 0;

                    SalesShipHeader.Reset();
                    SalesShipHeader.SetRange("Customer Posting Group", "Customer Posting Group"."Receivables Account");
                    if SalesShipHeader.FindSet() then
                        repeat
                            SalesShipHeaderUpdate.reset;
                            SalesShipHeaderUpdate.get(SalesShipHeader."No.");
                            SalesShipHeaderUpdate."Customer Posting Group" := "Customer Posting Group".Code;
                            SalesShipHeaderUpdate.Modify();
                        until SalesShipHeader.Next() = 0;
                end;

            }
        }

    }
    var
        SalesHeader: Record "Sales Header";
        SalesHeaderUpdate: Record "Sales Header";
        SalesShipHeader: Record "Sales Shipment Header";
        SalesShipHeaderUpdate: Record "Sales Shipment Header";
        CustPostingGroup2: Record "Customer Posting Group";
        Text001: label 'Import completed';

    trigger OnPostXmlPort()

    begin
        Message(Text001);
    end;


}