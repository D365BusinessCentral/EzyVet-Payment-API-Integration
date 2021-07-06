table 50101 "EzyVet Payment"
{
    Caption = 'EzyVet Payment';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
        }
        field(2; id; Text[100])
        {
            Caption = 'id';
            DataClassification = CustomerContent;
        }
        field(3; created_at; Text[50])
        {
            Caption = 'created_at';
            DataClassification = CustomerContent;
        }
        field(4; modified_at; Text[50])
        {
            Caption = 'modified_at';
            DataClassification = CustomerContent;
        }
        field(5; active; Text[10])
        {
            Caption = 'active';
            DataClassification = CustomerContent;
        }
        field(6; ownership_id; Text[100])
        {
            Caption = 'ownership_id';
            DataClassification = CustomerContent;
        }
        field(7; amount; Text[50])
        {
            Caption = 'amount';
            DataClassification = CustomerContent;
        }
        field(8; method; Text[100])
        {
            Caption = 'method';
            DataClassification = CustomerContent;
        }
        field(9; details; Text[100])
        {
            Caption = 'details';
            DataClassification = CustomerContent;
        }
        field(10; date; Text[50])
        {
            Caption = 'date';
            DataClassification = CustomerContent;
        }
        field(11; comments; Text[300])
        {
            Caption = 'comments';
            DataClassification = CustomerContent;
        }
        field(12; available; Text[50])
        {
            Caption = 'available';
            DataClassification = CustomerContent;
        }
        field(13; allocated; Text[50])
        {
            Caption = 'allocated';
            DataClassification = CustomerContent;
        }
        field(14; client_id; Text[100])
        {
            Caption = 'client_id';
            DataClassification = CustomerContent;
        }
        field(15; cash_amount; Text[50])
        {
            Caption = 'cash_amount';
            DataClassification = CustomerContent;
        }
        field(16; cash_change; Text[50])
        {
            Caption = 'cash_change';
            DataClassification = CustomerContent;
        }
        field(17; rounding_factor; Text[50])
        {
            Caption = 'rounding_factor';
            DataClassification = CustomerContent;
        }
        field(18; status; Text[100])
        {
            Caption = 'status';
            DataClassification = CustomerContent;
        }
        field(19; outstanding; Text[50])
        {
            Caption = 'outstanding';
            DataClassification = CustomerContent;

        }
        field(20; client_contact; Text[100])
        {
            Caption = 'client_contact';
            DataClassification = CustomerContent;
        }
        field(21; ledger_account; Text[100])
        {
            Caption = 'ledger_account';
            DataClassification = CustomerContent;
        }
        field(22; Processed; Boolean)
        {
            Caption = 'Processed';
            DataClassification = CustomerContent;
        }
        field(23; IsError; Boolean)
        {
            Caption = 'Is Error';
            DataClassification = CustomerContent;
        }
        field(24; "Error Message"; Text[2048])
        {
            Caption = 'Error Message';
            DataClassification = CustomerContent;
        }
        field(25; "Payment date"; DateTime)
        {
            Caption = 'Payment date';
            DataClassification = CustomerContent;
        }
        field(26; created_at_Date; DateTime)
        {
            Caption = 'created_at';
            DataClassification = CustomerContent;
        }
        field(27; modified_at_Date; DateTime)
        {
            Caption = 'modified_at';
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
