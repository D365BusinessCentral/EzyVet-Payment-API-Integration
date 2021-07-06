page 50103 "EzyVet Payment SubPage"
{

    Caption = 'EzyVet Payment SubPage';
    PageType = ListPart;
    SourceTable = "EzyVet Payment Linked Invoice";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the Entry No. field';
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Payment id"; Rec."Payment id")
                {
                    ToolTip = 'Specifies the value of the Payment id field';
                    ApplicationArea = All;
                    Visible = false;
                }
                field(id; Rec.id)
                {
                    ToolTip = 'Specifies the value of the id field';
                    ApplicationArea = All;
                }
                field(allocated_amount; Rec.allocated_amount)
                {
                    ToolTip = 'Specifies the value of the allocated_amount field';
                    ApplicationArea = All;
                }
            }
        }
    }

}
