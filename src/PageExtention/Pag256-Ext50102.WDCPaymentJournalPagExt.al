pageextension 50102 "WDC PaymentJournalPagExt" extends "Payment Journal" //256
{
    layout
    {
        addbefore("Posting Date")
        {
            field("To Post"; Rec."To Post")
            {
                Editable = true;
            }
        }
        addbefore("Recipient Bank Account")
        {
            field("Posting Group"; Rec."Posting Group")
            {
                Editable = true;
                ApplicationArea = All;
            }
            field("Cheque No."; Rec."Cheque No.")
            {
                ApplicationArea = All;
                trigger OnValidate()
                var
                    lBatchName: Record 232;
                    lCHQHeader: Record "Cheque Header";
                begin
                    Clear(Rec."Document No.");
                    Rec.checkbatchName(Rec."Cheque No.");
                    If Rec."Cheque No." <> '' then begin
                        Rec."Document No." := Rec."Cheque No.";
                    end;
                end;
            }
            field("Customer No."; Rec."Customer No.")
            {
                ApplicationArea = All;
            }
            field("Invoices To Paid"; Rec."Invoices To Paid")
            {
                ApplicationArea = All;
            }
            field("Sales person No."; Rec."Sales person No.")
            {
                ApplicationArea = All;
            }
            field("Code Status"; Rec."Code Status")
            {
                ApplicationArea = All;
            }
            field("payment Type"; Rec."payment Type")
            {
                ApplicationArea = All;
            }
            field("Description Status"; Rec."Description Status")
            {
                ApplicationArea = All;
            }
        }


    }


    actions
    {

        addafter(Post)
        {
            action("Select all / Deselect all")
            {
                caption = 'Select all/Deselect all';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Image = SelectLineToApply;
                ShortcutKey = 'Ctrl+A';
                InFooterBar = true;
                trigger OnAction()
                begin
                    SeelectDeselectAll;
                end;
            }
        }


    }
    trigger OnOpenPage()
    begin
        rec.ModifyAll("To Post", false);
    end;

    var
        SelectedAll: Boolean;

    procedure SeelectDeselectAll()
    var

    begin
        If Not SelectedAll then begin
            Rec.ModifyAll(Rec."To Post", true);
            SelectedAll := true;
            CurrPage.Update;
        end Else begin
            SelectedAll := false;
            Rec.ModifyAll(Rec."To Post", false);
            CurrPage.Update;
        end;

    end;


}