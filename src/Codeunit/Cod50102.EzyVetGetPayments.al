codeunit 50102 "EzyVet Get Payments"
{
    trigger OnRun()
    begin
        //Check Setups
        gConnectionThershold := 75;
        PaymentIntegrationLog.InsertLogs('Payment API Setups check started', 'SUCCESS');
        PaymentAPIIntegration.CheckSetup(gErrorMsgonSetups);
        if gErrorMsgonSetups = '' then
            PaymentIntegrationLog.InsertLogs('Payment  API Setups check finished', 'SUCCESS')
        else begin
            PaymentIntegrationLog.InsertLogs(gErrorMsgonSetups, 'ERROR');
            exit;
        end;

        //Get Access Token
        PaymentIntegrationLog.InsertLogs('Retrieve API Access Token is initiated', 'SUCCESS');
        PaymentAPIIntegration.GetAccessToken(gAccessToken, gErrorMsgonAccessTokenRetrieval);
        if gErrorMsgonAccessTokenRetrieval = '' then
            PaymentIntegrationLog.InsertLogs('Retrieve API Access Token is completed', 'SUCCESS')
        else begin
            PaymentIntegrationLog.InsertLogs(gErrorMsgonAccessTokenRetrieval, 'ERROR');
            exit;
        end;

        //Assign Filters
        if gIsAuto then begin
            APIConfiguration.Get();
            if APIConfiguration.last_invoice_retrieval_date = 0 then
                gFromDate := 0
            else
                gFromDate := APIConfiguration.last_invoice_retrieval_date;

            gToDate := EpochConverter.SystemDateTimeToEpochDateTime(CurrentDateTime);

        end;

        gfilters := StrSubstNo('{">=":%1,"<=":%2}', gFromDate, gToDate);

        //Retrieve New Records
        if gGetNewRecords then begin
            Clear(gRecordsCount);
            PaymentIntegrationLog.InsertLogs('Checking for new Payments is initiated', 'SUCCESS');
            PaymentAPIIntegration.GetPaymentListPages(gAccessToken, gRecordType::New, gFilters, gTotalPageCount, gErrorMsgonPagesCount);
            if gErrorMsgonPagesCount = '' then
                PaymentIntegrationLog.InsertLogs(StrSubstNo('%1 pages retrieved for new Payments', gTotalPageCount), 'SUCCESS')
            else begin
                PaymentIntegrationLog.InsertLogs(gErrorMsgonPagesCount, 'ERROR');
                exit;
            end;

            if gTotalPageCount >= 1 then begin
                PaymentIntegrationLog.InsertLogs('New Invoices Retrieval started', 'SUCCESS');
                GetNewPaymentList(gRecordType::New, gFromDate, gToDate, gErrorMsgonPaymentInsert);
                if gErrorMsgonPaymentInsert = '' then
                    PaymentIntegrationLog.InsertLogs(StrSubstNo('%1 new Payments retrieved', gRecordsCount), 'SUCCESS')
                else begin
                    PaymentIntegrationLog.InsertLogs(gErrorMsgonPaymentInsert, 'ERROR');
                    exit;
                end;
            end;
        end;

        //Retrieve Modified Records
        if gGetModifiedRecords then begin
            Clear(gRecordsCount);
            Clear(gTotalPageCount);
            Clear(gErrorMsgonPagesCount);
            if gFromDate <> 0 then begin
                PaymentIntegrationLog.InsertLogs('Checking for modified Payments is initiated ', 'SUCCESS');
                PaymentAPIIntegration.GetPaymentListPages(gAccessToken, gRecordType::Modified, gFilters, gTotalPageCount, gErrorMsgonPagesCount);
                if gErrorMsgonPagesCount = '' then
                    PaymentIntegrationLog.InsertLogs(StrSubstNo('%1 pages retrieved for modified Payments', gTotalPageCount), 'SUCCESS')
                else begin
                    PaymentIntegrationLog.InsertLogs(gErrorMsgonPagesCount, 'ERROR');
                    exit;
                end;

                if gTotalPageCount >= 1 then begin
                    PaymentIntegrationLog.InsertLogs(StrSubstNo('Modified Payments Retrieval started'), 'SUCCESS');
                    GetNewPaymentList(gRecordType::Modified, gFromDate, gToDate, gErrorMsgonPaymentInsert);
                    if gErrorMsgonPaymentInsert = '' then
                        PaymentIntegrationLog.InsertLogs(StrSubstNo('%1 modified Payments retrieved', gRecordsCount), 'SUCCESS')
                    else begin
                        PaymentIntegrationLog.InsertLogs(gErrorMsgonPaymentInsert, 'ERROR');
                        exit;
                    end;
                end;
            end;
        end;

        if gIsAuto then begin
            APIConfiguration.last_payment_retrieval_date := gToDate;
            APIConfiguration.Modify();
        end;
    end;

    procedure GetNewPaymentList(lRecordType: Option New,Modified; lFromDate: Integer; lToDate: integer; var lErrorMsgonProductInsert: Text)
    var
        lhttpClient: HttpClient;
        lhttpContent: HttpContent;
        lhttpHeaders: HttpHeaders;
        lhttpResponseMessage: HttpResponseMessage;
        lresponseText: Text;
        lFilters: Text;
        i: Integer;
        j: Integer;
        lRecordsCount: Integer;

    begin
        APIConfiguration.Get();
        i := 0;
        gPageCount := 0;
        gStopLoop := false;
        if gTotalPageCount > gConnectionThershold then
            gTimesofCalls := Round(gTotalPageCount / gConnectionThershold, 1, '>')
        else
            gTimesofCalls := 1;
        repeat
            j += 1;
            gPageCount += gConnectionThershold;
            repeat
                i += 1;
                if lRecordType = lRecordType::New then
                    lFilters := 'limit=200&' + StrSubstNo('ownership_id=%1&', APIConfiguration."Ownership ID") + StrSubstNo('page=%1&', i) + 'created_at=' + gfilters;
                if lRecordType = lRecordType::Modified then
                    lFilters := 'limit=200&' + StrSubstNo('ownership_id=%1&', APIConfiguration."Ownership ID") + StrSubstNo('page=%1&', i) + 'modified_at=' + gfilters;

                Clear(lhttpContent);
                Clear(lhttpClient);
                Clear(lhttpResponseMessage);
                Clear(lresponseText);
                lhttpClient.DefaultRequestHeaders.Add('Authorization', 'Bearer ' + FORMAT(gAccessToken));
                if lhttpClient.Get(APIConfiguration.Payment_url + lFilters, lhttpResponseMessage) then begin
                    lhttpResponseMessage.Content.ReadAs(lresponseText);
                    InsertPayments.InsertPayments(lresponseText, lRecordType, lRecordsCount);
                end else
                    Error(FORMAT(lhttpResponseMessage.Content));
                gStopLoop := (i = gPageCount) or (i = gtotalPageCount);
                gRecordsCount += lRecordsCount;
            until gStopLoop = true;

            if not (j = gTimesofCalls) then
                Sleep(60000);
        until j = gTimesofCalls;
    end;

    procedure SetParameters(lFromDate: Integer; lToDate: Integer; lIsAuto: Boolean; lGetNewRecords: Boolean; lGetModifiedRecords: Boolean)
    begin
        gFromDate := lFromDate;
        gToDate := lToDate;
        gIsAuto := lIsAuto;
        gGetNewRecords := lGetNewRecords;
        gGetModifiedRecords := lGetModifiedRecords;


    end;

    var
        PaymentAPIIntegration: Codeunit "EzyVet Payment API Integration";
        InsertPayments: Codeunit "EzyVet Insert Payments";
        gParameter: Text[100];
        gRecordType: Option New,Modified;
        gTotalPageCount: Integer;
        gPageCount: Integer;
        gStopLoop: Boolean;
        gConnectionThershold: Integer;
        gTimesofCalls: Integer;
        gAccessToken: Text;
        gErrorMsgonAccessTokenRetrieval: text;
        gErrorMsgonPagesCount: text;
        gFromDate: Integer;
        gToDate: Integer;
        gGetNewRecords: Boolean;
        gGetModifiedRecords: Boolean;
        gIsAuto: Boolean;
        gErrorMsgonSetups: Text;
        APIConfiguration: Record "EzyVet API Configuration";
        EpochConverter: Codeunit "EzyVet Epoch Convertor";
        gfilters: Text;
        PaymentIntegrationLog: Codeunit EzyVetPaymentIntegrationLogs;
        gErrorMsgonPaymentInsert: Text;
        gRecordsCount: Integer;
}

