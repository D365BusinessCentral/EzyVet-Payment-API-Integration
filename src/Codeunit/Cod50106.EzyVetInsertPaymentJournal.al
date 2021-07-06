codeunit 50106 "EzyVet Insert Payment Journal"
{
    procedure CreatePaymentJournal(lEzyVetPayment: Record "EzyVet Payment")
    begin
        gAPIIntegrationSetup.Get();
        gGenJnlBatch.Get(gAPIIntegrationSetup."Payment Journal Template", gAPIIntegrationSetup."Payment Journal Batch");
        gCustomer.Get(lEzyVetPayment.client_id);
        gGenJnlLine.Reset();
        gGenJnlLine.SetRange("Journal Template Name", gGenJnlBatch."Journal Template Name");
        gGenJnlLine.SetRange("Journal Batch Name", gGenJnlBatch.Name);
        if gGenJnlLine.FindLast() then
            gLineNo := gGenJnlLine."Line No."
        else
            gLineNo := 0;

        CreateJournalLine(lEzyVetPayment);
        if GuiAllowed then
            Message('Payment Journal created for EzyVet Payment');
    end;

    local procedure CreateJournalLine(lEzyVetPayment: Record "EzyVet Payment")
    var
        lAmount: Decimal;
        lDate: Date;
        lPostingDateTime: DateTime;
        lPaymentMethodId: Integer;
        lEzyVetLinkedInvoice: Record "EzyVet Payment Linked Invoice";
        lSalesInvHeader: Record "Sales Invoice Header";
        lEzyVetPaymentMethodMap: Record "EzyVet Payment Method Mapping";

    begin
        if lEzyVetPayment."Payment date" <> 0DT then
            lDate := DT2Date(lEzyVetPayment."Payment date");

        if lEzyVetPayment.method <> '' then
            Evaluate(lPaymentMethodId, lEzyVetPayment.method);

        lEzyVetPaymentMethodMap.Reset();
        lEzyVetPaymentMethodMap.SetRange("Payment Method Id", lPaymentMethodId);
        lEzyVetPaymentMethodMap.FindFirst();
        lEzyVetPaymentMethodMap.TestField(lEzyVetPaymentMethodMap."G/L Account");

        Clear(lAmount);
        Evaluate(lAmount, lEzyVetPayment.allocated);
        if lAmount <> 0 then begin
            lEzyVetLinkedInvoice.Reset();
            lEzyVetLinkedInvoice.SetRange(lEzyVetLinkedInvoice."Payment id", lEzyVetPayment.id);
            if not lEzyVetLinkedInvoice.FindFirst() then begin
                InsertJournal(lAmount, lDate, '', lEzyVetPaymentMethodMap."G/L Account");
            end else
                repeat
                    Clear(lAmount);
                    Evaluate(lAmount, lEzyVetLinkedInvoice.allocated_amount);
                    lSalesInvHeader.Reset();
                    lSalesInvHeader.SetRange("EzyVet Invoice ID", lEzyVetLinkedInvoice.id);
                    if lSalesInvHeader.FindFirst() then
                        InsertJournal(lAmount, lDate, lSalesInvHeader."No.", lEzyVetPaymentMethodMap."G/L Account")
                    else
                        InsertJournal(lAmount, lDate, '', lEzyVetPaymentMethodMap."G/L Account");
                until lEzyVetLinkedInvoice.Next() = 0;
        end;
    end;

    local procedure InsertJournal(lAmount: Decimal; lDate: date; lAppliesToID: Code[20]; lBalAccount: Code[20])
    begin
        gLineNo += 10000;
        gGenJnlLine.Init();
        gGenJnlLine."Journal Template Name" := gGenJnlBatch."Journal Template Name";
        gGenJnlLine."Journal Batch Name" := gGenJnlBatch.Name;
        gGenJnlLine."Line No." := gLineNo;
        gGenJnlLine.Insert();

        gGenJnlLine."Document No." := gNoSeriesMgnt.GetNextNo(gGenJnlBatch."No. Series", WorkDate(), true);
        if lAmount > 0 then
            gGenJnlLine."Document Type" := gGenJnlLine."Document Type"::Payment
        else
            gGenJnlLine."Document Type" := gGenJnlLine."Document Type"::Refund;

        gGenJnlLine."Account Type" := gGenJnlLine."Account Type"::Customer;
        gGenJnlLine.validate("Account No.", gCustomer."No.");
        gGenJnlLine.Validate(Quantity, 1);
        gGenJnlLine.Validate(Amount, lAmount);
        gGenJnlLine."Bal. Account Type" := gGenJnlLine."Bal. Account Type"::"G/L Account";
        gGenJnlLine.Validate("Bal. Account No.", lBalAccount);
        if lAppliesToID <> '' then begin
            if lAmount > 0 then
                gGenJnlLine."Applies-to Doc. Type" := gGenJnlLine."Applies-to Doc. Type"::Invoice;
            if lAmount < 0 then
                gGenJnlLine."Applies-to Doc. Type" := gGenJnlLine."Applies-to Doc. Type"::"Credit Memo";
            gGenJnlLine."Applies-to ID" := lAppliesToID;
        end;
        gGenJnlLine.Validate("Posting Date", lDate);
        gGenJnlLine.Modify();

    end;

    var
        gEpochConvertor: Codeunit "EzyVet Epoch Convertor";
        gAPIIntegrationSetup: Record "EzyVet API Configuration";
        gLineNo: Integer;
        gGenJnlBatch: Record "Gen. Journal Batch";
        gCustomer: Record Customer;
        gGenJnlLine: Record "Gen. Journal Line";
        gNoSeriesMgnt: Codeunit NoSeriesManagement;


}
