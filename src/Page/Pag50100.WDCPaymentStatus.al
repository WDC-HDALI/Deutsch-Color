page 50100 "WDC Payment Status"
{
    Caption = 'Payment Status';
    ApplicationArea = Basic, Suite;
    PageType = List;
    SourceTable = "WDC payment status";
    UsageCategory = Lists;
    layout
    {
        area(content)
        {

            repeater(Group)
            {
                field("Code Status"; Rec."Code Status")
                {
                    ApplicationArea = all;

                }
                field("payment Type"; Rec."payment Type")
                {
                    ApplicationArea = all;
                }
                field("Description Status"; Rec."Description Status")
                {
                    ApplicationArea = all;
                }

                field("Unpaid Step"; Rec."Unpaid Step")
                {
                    ApplicationArea = all;
                }
            }
        }
    }
    actions
    {
    }

    var


}

