report 50101 EzyVetGetPayments
{
    ApplicationArea = All;
    Caption = 'EzyVetGetPayments';
    UsageCategory = Tasks;
    ProcessingOnly = true;
    requestpage
    {
        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';

                    field(gFromDate; gFromDate)
                    {
                        Caption = 'From Date';
                        ApplicationArea = all;
                    }
                    field(gToDate; gToDate)
                    {
                        Caption = 'To Date';
                        ApplicationArea = all;

                    }
                    field(gGetNewRecords; gGetNewRecords)
                    {
                        Caption = 'Get New Records';
                        ApplicationArea = all;
                    }
                    field(gGetModifiedRecords; gGetModifiedRecords)
                    {
                        Caption = 'Get Modified Records';
                        ApplicationArea = all;
                    }
                }
            }
        }
    }
    trigger OnPostReport()
    begin
        if gGetNewRecords or gGetModifiedRecords then begin
            gEpochFromDate := EPOCHConverter.SystemDateTimeToEpochDateTime(gfromDate);
            gEpochToDate := EPOCHConverter.SystemDateTimeToEpochDateTime(gToDate);
            Clear(GetPayments);
            GetPayments.SetParameters(gEpochFromDate, gEpochToDate, false, gGetNewRecords, gGetModifiedRecords);
            GetPayments.Run();
        end else
            Error('Choose either "Get New Records" or "Get Modified Records" option to process');

    end;

    var
        gFromDate: DateTime;
        gToDate: DateTime;
        gEpochFromDate: Integer;
        gEpochToDate: Integer;
        EPOCHConverter: Codeunit "EzyVet Epoch Convertor";
        GetPayments: Codeunit "EzyVet Get Payments";
        gGetNewRecords: Boolean;
        gGetModifiedRecords: Boolean;

}
