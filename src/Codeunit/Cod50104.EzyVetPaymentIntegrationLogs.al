codeunit 50104 EzyVetPaymentIntegrationLogs
{
    procedure InsertLogs(lDescription: Text[500]; lStatus: text)
    var
        lProductsIntegrationLog: Record EzyvetPaymentIntegrationLog;
        lEntryNo: Integer;
    begin
        Clear(lEntryNo);
        lProductsIntegrationLog.Reset();
        if lProductsIntegrationLog.FindLast() then
            lEntryNo := lProductsIntegrationLog."Entry No.";

        lProductsIntegrationLog.Init();
        lProductsIntegrationLog."Entry No." := lEntryNo + 1;
        lProductsIntegrationLog.Description := lDescription;
        lProductsIntegrationLog.LogDateTime := CurrentDateTime;
        if lStatus = 'SUCCESS' then
            lProductsIntegrationLog.Status := lProductsIntegrationLog.Status::Success;
        if lStatus = 'ERROR' then
            lProductsIntegrationLog.Status := lProductsIntegrationLog.Status::Error;
        lProductsIntegrationLog.Insert();
    end;
}
