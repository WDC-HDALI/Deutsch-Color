tableextension 50106 "WDC CustomerTabExt" extends customer //18
{
    fields
    {

        field(50204; "Shipment Not Invoiced"; Decimal)
        {
            Editable = False;
            FieldClass = FlowField;
            CalcFormula = sum("Sales line"."Shipped Not Invoiced (LCY)" where("Sell-to Customer No." = field("No."),
                                                                             "Document Type" = filter(Order),
                                                                             Type = filter(<> 1),
                                                                             "Shipped Not Invoiced (LCY)" = filter(<> 0)));
        }
        field(50205; "Return Not Invoiced"; Decimal)
        {
            Editable = False;
            FieldClass = FlowField;
            CalcFormula = sum("Sales line"."Return Rcd. Not Invd. (LCY)" where("Sell-to Customer No." = field("No."),
                                                                            "Document Type" = filter("Return Order"),
                                                                            Type = filter(<> 1),
                                                                            "Return Rcd. Not Invd. (LCY)" = filter(<> 0)));
        }


    }

}