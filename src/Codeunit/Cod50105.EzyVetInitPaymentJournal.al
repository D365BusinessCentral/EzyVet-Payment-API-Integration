codeunit 50105 "EzyVet Init Payment Journal"
{

    procedure InitPaymentRecords()
    begin
        EzyVetPayment.Reset();
        if gPaymentEntryNo <> 0 then
            EzyVetPayment.SetRange("Entry No.", gPaymentEntryNo);
        EzyVetPayment.SetRange(Processed, false);
        if EzyVetPayment.FindFirst() then
            repeat
                if ValidatePayments(EzyVetPayment) then begin
                    EzyVetInsertPaymentJournal.CreatePaymentJournal(EzyVetPayment);
                    EzyVetPayment.Processed := true;
                    EzyVetPayment.Modify();
                end;
            until EzyVetPayment.Next() = 0;

    end;

    procedure SetParameters(lPaymentEntryNo: Integer)
    begin
        gPaymentEntryNo := lPaymentEntryNo;
    end;

    procedure ValidatePayments(lEzyVetPayment: Record "EzyVet Payment") IsSuccess: Boolean
    var
        lCustomer: Record Customer;
        lEzyVetAPIIntegration: Record "EzyVet API Configuration";
        lEzyVetPaymentMethodMap: Record "EzyVet Payment Method Mapping";
        lPaymentMethodId: Integer;
    begin
        if lEzyVetPayment.IsError then
            lEzyVetPayment.IsError := false;
        if lEzyVetPayment."Error Message" <> '' then
            lEzyVetPayment."Error Message" := '';
        lEzyVetPayment.Modify();

        if not lEzyVetAPIIntegration.Get() then begin
            lEzyVetPayment.IsError := true;
            lEzyVetPayment."Error Message" := 'EzyVet API Configuration is not setup';
            lEzyVetPayment.Modify();
        end;
        if lEzyVetAPIIntegration."Payment Journal Template" = '' then begin
            lEzyVetPayment.IsError := true;
            lEzyVetPayment."Error Message" := 'Payment Journal Template is blank in EzyVet API Configuration setup';
            lEzyVetPayment.Modify();
        end;
        if lEzyVetAPIIntegration."Payment Journal Batch" = '' then begin
            lEzyVetPayment.IsError := true;
            lEzyVetPayment."Error Message" := 'Payment Journal Batch is blank in EzyVet API Configuration setup';
            lEzyVetPayment.Modify();
        end;

        if not lCustomer.get(lEzyVetPayment.client_id) then begin
            lEzyVetPayment.IsError := true;
            lEzyVetPayment."Error Message" := StrSubstNo('Customer %1 not found', lEzyVetPayment.client_id);
            lEzyVetPayment.Modify();
        end;

        if lEzyVetPayment.method <> '' then
            Evaluate(lPaymentMethodId, lEzyVetPayment.method);
        lEzyVetPaymentMethodMap.Reset();
        lEzyVetPaymentMethodMap.SetRange("Payment Method Id", lPaymentMethodId);
        lEzyVetPaymentMethodMap.FindFirst();
        lEzyVetPaymentMethodMap.TestField(lEzyVetPaymentMethodMap."G/L Account");
        exit(true);

    end;


    var
        EzyVetPayment: Record "EzyVet Payment";
        EzyVetPaymentLinkedInvoice: Record "EzyVet Payment Linked Invoice";
        EzyVetInsertPaymentJournal: Codeunit "EzyVet Insert Payment Journal";
        gPaymentEntryNo: Integer;

}
