page 50104 "EzyVet Payment Method Mapping"
{

    ApplicationArea = All;
    Caption = 'EzyVet Payment Method Mapping';
    PageType = List;
    SourceTable = "EzyVet Payment Method Mapping";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Payment Method Code"; Rec."Payment Method Code")
                {
                    ToolTip = 'Specifies the value of the Payment Method Code field';
                    ApplicationArea = All;
                }
                field("Payment Method Id"; Rec."Payment Method Id")
                {
                    ToolTip = 'Specifies the value of the Payment Method Id field';
                    ApplicationArea = All;
                }
                field("G/L Account"; Rec."G/L Account")
                {
                    ToolTip = 'Specifies the value of the G/L Account field';
                    ApplicationArea = All;
                }
            }
        }
    }

}
