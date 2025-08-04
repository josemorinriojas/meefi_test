class PaymentReceiptWorkerJob
  include Sidekiq::Job

  def perform(invoice_id)
    invoice = Invoice.find(invoice_id)
    payload = PaymentComplementBuilder.new(
      invoice
    ).build

    response = PacClient.new(payload).create_payment_complement

    tax_stamp = response["Complement"]["TaxStamp"]
    invoice.payment_complements.create!(
      invoice_id: invoice.id,
      uuid: tax_stamp["Uuid"],
      facturama_id: response["Id"],
      payment_date: Time.current,
      total: invoice.total,
      xml_url: nil,
      pdf_url: nil,
      response: response
    )

    invoice.payed!

    Rails.logger.info "Complemento de pago generado para factura ##{invoice.id} - UUID: #{response['Uuid']}"
  rescue => e
    Rails.logger.error "Error generando complemento de pago para factura ##{invoice_id}: #{e.message}"
    raise e # Sidekiq retry
    
  end
end
