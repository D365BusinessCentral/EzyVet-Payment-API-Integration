table 50102 "EzyVet Payment Linked Invoice"
{
    Caption = 'EzyVet Payment Linked Invoice';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
        }
        field(2; "Payment id"; Text[100])
        {
            Caption = 'Payment id';
            DataClassification = CustomerContent;
        }
        field(3; id; Text[100])
        {
            Caption = 'id';
            DataClassification = CustomerContent;
        }
        field(4; allocated_amount; Text[50])
        {
            Caption = 'allocated_amount';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }

}
