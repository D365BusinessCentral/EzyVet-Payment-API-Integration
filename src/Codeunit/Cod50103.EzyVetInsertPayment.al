codeunit 50103 "EzyVet Insert Payments"
{
    procedure InsertPayments(lJSONText: Text; lRecordType: Option New,Modified; var lCount: Integer)
    var
        lEzyVetPaymentHeader: Record "EzyVet Payment";
        lEzyVetPaymentLine: Record "EzyVet Payment Linked Invoice";
        lJSONObject: JsonObject;
        lJSONToken: JsonToken;
        lJSONArray: JsonArray;
        lJSONArray1: JsonArray;
        i: Integer;
        j: Integer;
        k: Integer;
        l: Integer;
        lHeaderEntryNo: Integer;
        lLineEntryNo: Integer;
        lEPOCHConvertor: Codeunit "EzyVet Epoch Convertor";
    begin
        j := 0;
        lCount := 0;
        lEzyVetPaymentHeader.Reset();
        if not lEzyVetPaymentHeader.findlast() then
            lHeaderEntryNo := 0
        else
            lHeaderEntryNo := lEzyVetPaymentHeader."Entry No.";


        lJSONToken.ReadFrom(lJSONText);
        lJSONObject := lJSONToken.AsObject();
        lJSONToken.SelectToken('items', lJSONToken);
        lJSONArray := lJSONToken.AsArray();
        //Process JSON response
        for i := 0 to lJSONArray.Count - 1 do begin

            lCount += 1;
            lJSONArray.Get(i, lJSONToken);
            lJSONToken.SelectToken('payment', lJSONToken);
            lJSONObject := lJSONToken.AsObject();
            lEzyVetPaymentHeader.Reset();
            lEzyVetPaymentHeader.SetRange(id, GetJSONToken(lJSONObject, 'id').AsValue().AsText());
            if not lEzyVetPaymentHeader.FindFirst() then begin
                j += 1;
                lEzyVetPaymentHeader.Init();
                lEzyVetPaymentHeader."Entry No." := lHeaderEntryNo + j;
                lEzyVetPaymentHeader.Insert();
                lEzyVetPaymentHeader.id := GetJSONToken(lJSONObject, 'id').AsValue().AsText();
                lEzyVetPaymentHeader.active := GetJSONToken(lJSONObject, 'active').AsValue().AsText();
                lEzyVetPaymentHeader.created_at := GetJSONToken(lJSONObject, 'created_at').AsValue().AsText();
                lEzyVetPaymentHeader.modified_at := GetJSONToken(lJSONObject, 'modified_at').AsValue().AsText();
                if not GetJSONToken(lJSONObject, 'amount').AsValue().IsNull then
                    lEzyVetPaymentHeader.amount := GetJSONToken(lJSONObject, 'amount').AsValue().AsText();
                if not GetJSONToken(lJSONObject, 'method').AsValue().IsNull then
                    lEzyVetPaymentHeader.method := GetJSONToken(lJSONObject, 'method').AsValue().AsText();
                //if not GetJSONToken(lJSONObject, 'outstanding').AsValue().IsNull then
                //lEzyVetPaymentHeader.outstanding := GetJSONToken(lJSONObject, 'outstanding').AsValue().AsText();
                if not GetJSONToken(lJSONObject, 'allocated').AsValue().IsNull then
                    lEzyVetPaymentHeader.allocated := GetJSONToken(lJSONObject, 'allocated').AsValue().AsText();
                if not GetJSONToken(lJSONObject, 'client_id').AsValue().IsNull then
                    lEzyVetPaymentHeader.client_id := GetJSONToken(lJSONObject, 'client_id').AsValue().AsText();
                if not GetJSONToken(lJSONObject, 'date').AsValue().IsNull then
                    lEzyVetPaymentHeader.date := GetJSONToken(lJSONObject, 'date').AsValue().AsText();
                if not GetJSONToken(lJSONObject, 'details').AsValue().IsNull then
                    lEzyVetPaymentHeader.details := GetJSONToken(lJSONObject, 'details').AsValue().AsText();
                if not GetJSONToken(lJSONObject, 'comments').AsValue().IsNull then
                    lEzyVetPaymentHeader.comments := GetJSONToken(lJSONObject, 'comments').AsValue().AsText();
                //if not GetJSONToken(lJSONObject, 'client_contact').AsValue().IsNull then
                //lEzyVetPaymentHeader.client_contact := GetJSONToken(lJSONObject, 'client_contact').AsValue().AsText();
                if not GetJSONToken(lJSONObject, 'ownership_id').AsValue().IsNull then
                    lEzyVetPaymentHeader.ownership_id := GetJSONToken(lJSONObject, 'ownership_id').AsValue().AsText();
                //if not GetJSONToken(lJSONObject, 'ledger_account').AsValue().IsNull then
                //lEzyVetPaymentHeader.ledger_account := GetJSONToken(lJSONObject, 'ledger_account').AsValue().AsText();
                if not GetJSONToken(lJSONObject, 'cash_amount').AsValue().IsNull then
                    lEzyVetPaymentHeader.cash_amount := GetJSONToken(lJSONObject, 'cash_amount').AsValue().AsText();
                if not GetJSONToken(lJSONObject, 'cash_change').AsValue().IsNull then
                    lEzyVetPaymentHeader.cash_change := GetJSONToken(lJSONObject, 'cash_change').AsValue().AsText();
                if not GetJSONToken(lJSONObject, 'rounding_factor').AsValue().IsNull then
                    lEzyVetPaymentHeader.rounding_factor := GetJSONToken(lJSONObject, 'rounding_factor').AsValue().AsText();
                if not GetJSONToken(lJSONObject, 'status').AsValue().IsNull then
                    lEzyVetPaymentHeader.status := GetJSONToken(lJSONObject, 'status').AsValue().AsText();
                if not GetJSONToken(lJSONObject, 'date').AsValue().IsNull then
                    lEzyVetPaymentHeader."Payment date" := lEPOCHConvertor.EpochDateTimeToSystemDateTime(GetJSONToken(lJSONObject, 'date').AsValue().AsInteger());

                lEzyVetPaymentHeader.modified_at_Date := lEPOCHConvertor.EpochDateTimeToSystemDateTime(GetJSONToken(lJSONObject, 'modified_at').AsValue().AsInteger());
                lEzyVetPaymentHeader.created_at_Date := lEPOCHConvertor.EpochDateTimeToSystemDateTime(GetJSONToken(lJSONObject, 'created_at').AsValue().AsInteger());
                lEzyVetPaymentHeader.Modify();


                //if not GetJSONToken(lJSONObject, 'linked_invoices').AsValue().IsNull then begin
                Clear(k);
                Clear(l);
                Clear(lJSONArray1);
                lEzyVetPaymentLine.Reset();
                if not lEzyVetPaymentLine.findlast() then
                    lLineEntryNo := 0
                else
                    lLineEntryNo := lEzyVetPaymentLine."Entry No.";

                lJSONToken.SelectToken('linked_invoices', lJSONToken);
                lJSONArray1 := lJSONToken.AsArray();
                for k := 0 to lJSONArray1.Count - 1 do begin
                    l += 1;
                    lJSONArray1.Get(k, lJSONToken);
                    lJSONObject := lJSONToken.AsObject();
                    lEzyVetPaymentLine.Init();
                    lEzyVetPaymentLine."Entry No." := lLineEntryNo + l;
                    lEzyVetPaymentLine.Insert();
                    lEzyVetPaymentLine.id := GetJSONToken(lJSONObject, 'id').AsValue().AsText();
                    lEzyVetPaymentLine.allocated_amount := GetJSONToken(lJSONObject, 'allocated_amount').AsValue().AsText();
                    lEzyVetPaymentLine."Payment id" := lEzyVetPaymentHeader.id;
                    lEzyVetPaymentLine.Modify();
                end;

            end;
            //end;
        end;
    end;

    local procedure GetJSONToken(JsonObject: JsonObject;
    TokenKey: Text) JsonToken: JsonToken;
    var
    begin
        if not JsonObject.get(TokenKey, JsonToken) then Error('Could not find a token with key %1', TokenKey);
    end;

}
