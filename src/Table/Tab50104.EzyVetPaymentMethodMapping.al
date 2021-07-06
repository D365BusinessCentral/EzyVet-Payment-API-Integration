table 50104 "EzyVet Payment Method Mapping"
{
    Caption = 'EzyVet Payment Method Mapping';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
            DataClassification = CustomerContent;
        }
        field(2; "Payment Method Code"; Code[20])
        {
            Caption = 'Payment Method Code';
            DataClassification = CustomerContent;
        }
        field(3; "Payment Method Id"; Integer)
        {
            Caption = 'EzyVet Payment Method Id';
            DataClassification = CustomerContent;
        }
        field(4; "G/L Account"; Code[20])
        {
            Caption = 'G/L Account';
            DataClassification = CustomerContent;
            TableRelation = "G/L Account" where("Account Type" = filter(Posting));
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
