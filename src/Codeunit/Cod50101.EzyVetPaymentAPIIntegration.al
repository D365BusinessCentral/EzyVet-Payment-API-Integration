codeunit 50101 "EzyVet Payment API Integration"
{
    
    procedure CheckSetup(var lErrorMsgonSetups: Text)
    begin
        if not GuiAllowed then begin
            APIConfiguration.Get();
            APIConfiguration.TestField(partner_id);
            APIConfiguration.TestField(client_id);
            APIConfiguration.TestField(client_secret);
            APIConfiguration.TestField(grant_type);
            APIConfiguration.TestField(scope);
            APIConfiguration.TestField(Payment_url);
            APIConfiguration.TestField("Ownership ID");
        end else begin
            APIConfiguration.Get();
            if APIConfiguration.partner_id = '' then begin
                lErrorMsgonSetups := 'Partner Id is blank in API configuration Setup';
                exit;
            end;
            if APIConfiguration.client_id = '' then begin
                lErrorMsgonSetups := 'Client Id is blank in API configuration Setup';
                exit;
            end;
            if APIConfiguration.client_secret = '' then begin
                lErrorMsgonSetups := 'Client_secret is blank in API configuration Setup';
                exit;
            end;
            if APIConfiguration.grant_type = '' then begin
                lErrorMsgonSetups := 'Grant Type is blank in API configuration Setup';
                exit;
            end;
            if APIConfiguration.scope = '' then begin
                lErrorMsgonSetups := 'Scope is blank in API configuration Setup';
                exit;
            end;
            if APIConfiguration.payment_url = '' then begin
                lErrorMsgonSetups := 'Payment Endpoint Url is blank in API configuration Setup';
                exit;
            end;

            if APIConfiguration."Ownership ID" = '' then begin
                lErrorMsgonSetups := 'Ownership ID is blank in API configuration Setup';
                exit;
            end;

        end;

    end;

    procedure GetAccessToken(var lAccessToken: Text; var lErrorMessage: text)
    var
        lhttpClient: HttpClient;
        lhttpContent: HttpContent;
        lhttpHeaders: HttpHeaders;
        lhttpRequestMessage: HttpRequestMessage;
        lhttpResponseMessage: HttpResponseMessage;
        lbodyContent: Text;
    begin
        lbodyContent := StrSubstNo('partner_id=%1&client_id=%2&client_secret=%3&grant_type=%4&scope=%5',
                        APIConfiguration.partner_id, APIConfiguration.client_id, APIConfiguration.client_secret,
                        APIConfiguration.grant_type, APIConfiguration.scope);
        lHttpcontent.WriteFrom(lbodyContent);
        lHttpcontent.GetHeaders(lHttpheaders);
        lHttpheaders.Remove('Content-Type');
        lHttpHeaders.Add('Content-Type', 'application/x-www-form-urlencoded');
        if lHttpclient.Post(APIConfiguration.access_token_endpoint_url, lHttpcontent, lhttpResponseMessage) then begin
            lhttpResponseMessage.Content.ReadAs(gresponseText);
            gJSONToken.ReadFrom(gresponseText);
            gJSONObject := gJSONToken.AsObject();
            lAccessToken := GetJSONToken(gJSONObject, 'access_token').AsValue().AsText();
        end else
            lErrorMessage := FORMAT(lhttpResponseMessage.Content);
    end;

    procedure GetPaymentListPages(lAccessToken: text; RecordType: Option New,Modified; lDateFilters: Text; var lPagesCount: Integer; var lErrorMessage: text)
    var
        lhttpClient: HttpClient;
        lhttpContent: HttpContent;
        lhttpHeaders: HttpHeaders;
        lhttpResponseMessage: HttpResponseMessage;
        lFilters: Text;
    begin
        lhttpClient.DefaultRequestHeaders.Add('Authorization', 'Bearer ' + FORMAT(lAccessToken));
        if RecordType = RecordType::New then
            lFilters := 'limit=200&' + StrSubstNo('ownership_id=%1&', APIConfiguration."Ownership ID") + 'created_at=' + lDateFilters;
        if RecordType = RecordType::Modified then
            lFilters := 'limit=200&' + StrSubstNo('ownership_id=%1&', APIConfiguration."Ownership ID") + 'modified_at=' + lDateFilters;

        if lhttpClient.Get(APIConfiguration.product_endpoint_url + lFilters, lhttpResponseMessage) then begin
            lhttpResponseMessage.Content.ReadAs(gresponseText);
            gJSONToken.ReadFrom(gresponseText);
            gJSONObject := gJSONToken.AsObject();
            gJSONToken.SelectToken('meta', gJSONToken);
            gJSONObject := gJSONToken.AsObject();
            lPagesCount := GetJSONToken(gJSONObject, 'items_page_total').AsValue().AsInteger();
        end else
            lErrorMessage := FORMAT(lhttpResponseMessage.Content);
    end;

    local procedure GetJSONToken(JsonObject: JsonObject;
    TokenKey: Text) JsonToken: JsonToken;
    var
    begin
        if not JsonObject.get(TokenKey, JsonToken) then Error('Could not find a token with key %1', TokenKey);
    end;

    var
        APIConfiguration: Record "EzyVet API Configuration";
        gresponseText: Text;
        gJSONToken: JsonToken;
        gJSONObject: JsonObject;
        gjsonArray: JsonArray;

}
