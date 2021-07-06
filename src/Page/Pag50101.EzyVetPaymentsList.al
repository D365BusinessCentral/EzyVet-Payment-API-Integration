page 50101 "Ezyvet Payments List"
{

    ApplicationArea = All;
    Caption = 'Ezyvet Payments List';
    PageType = List;
    SourceTable = "EzyVet Payment";
    UsageCategory = Lists;
    CardPageId = "EzyVet Payment Card";

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
                }
                field(active; Rec.active)
                {
                    ToolTip = 'Specifies the value of the active field';
                    ApplicationArea = All;
                }
                field(allocated; Rec.allocated)
                {
                    ToolTip = 'Specifies the value of the allocated field';
                    ApplicationArea = All;
                }
                field(amount; Rec.amount)
                {
                    ToolTip = 'Specifies the value of the amount field';
                    ApplicationArea = All;
                }
                field(available; Rec.available)
                {
                    ToolTip = 'Specifies the value of the available field';
                    ApplicationArea = All;
                }
                field(cash_amount; Rec.cash_amount)
                {
                    ToolTip = 'Specifies the value of the cash_amount field';
                    ApplicationArea = All;
                }
                field(cash_change; Rec.cash_change)
                {
                    ToolTip = 'Specifies the value of the cash_change field';
                    ApplicationArea = All;
                }
                field(client_contact; Rec.client_contact)
                {
                    ToolTip = 'Specifies the value of the client_contact field';
                    ApplicationArea = All;
                }
                field(client_id; Rec.client_id)
                {
                    ToolTip = 'Specifies the value of the client_id field';
                    ApplicationArea = All;
                }
                field(comments; Rec.comments)
                {
                    ToolTip = 'Specifies the value of the comments field';
                    ApplicationArea = All;
                }
                field(created_at; Rec.created_at)
                {
                    ToolTip = 'Specifies the value of the created_at field';
                    ApplicationArea = All;
                }
                field(date; Rec.date)
                {
                    ToolTip = 'Specifies the value of the date field';
                    ApplicationArea = All;
                }
                field(details; Rec.details)
                {
                    ToolTip = 'Specifies the value of the details field';
                    ApplicationArea = All;
                }
                field(id; Rec.id)
                {
                    ToolTip = 'Specifies the value of the id field';
                    ApplicationArea = All;
                }
                field(ledger_account; Rec.ledger_account)
                {
                    ToolTip = 'Specifies the value of the ledger_account field';
                    ApplicationArea = All;
                }
                field(method; Rec.method)
                {
                    ToolTip = 'Specifies the value of the method field';
                    ApplicationArea = All;
                }
                field(modified_at; Rec.modified_at)
                {
                    ToolTip = 'Specifies the value of the modified_at field';
                    ApplicationArea = All;
                }
                field(outstanding; Rec.outstanding)
                {
                    ToolTip = 'Specifies the value of the outstanding field';
                    ApplicationArea = All;
                }
                field(ownership_id; Rec.ownership_id)
                {
                    ToolTip = 'Specifies the value of the ownership_id field';
                    ApplicationArea = All;
                }
                field(rounding_factor; Rec.rounding_factor)
                {
                    ToolTip = 'Specifies the value of the rounding_factor field';
                    ApplicationArea = All;
                }
                field(status; Rec.status)
                {
                    ToolTip = 'Specifies the value of the status field';
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(GetPayments)
            {
                Caption = 'Get Payments';
                Image = GetLines;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                ApplicationArea = All;

                trigger OnAction()
                var
                    GetPayments: Report EzyVetGetPayments;
                begin
                    GetPayments.RunModal();
                end;
            }
            action(CreatePayments)
            {
                Caption = 'Create Payments';
                Image = Create;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                ApplicationArea = All;

                trigger OnAction()
                var
                    CreatePayments: Codeunit "EzyVet Init Payment Journal";
                begin
                    CreatePayments.SetParameters(Rec."Entry No.");
                    CreatePayments.InitPaymentRecords();
                end;
            }
        }
    }
}
