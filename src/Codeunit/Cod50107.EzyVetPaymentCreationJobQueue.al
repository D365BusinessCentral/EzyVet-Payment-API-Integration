codeunit 50107 EzyVetPaymentCreationJobQueue
{
    trigger OnRun()
    begin
        //Insert and Create Payment Records
        Clear(InitPayments);
        InitPayments.InitPaymentRecords();
    end;

    var
        InitPayments: Codeunit "EzyVet Init Payment Journal";


}