module Api
  module V1
    class PaymentComplementsController < ApplicationController
      def create
        invoice = Invoice.find(params[:invoice_id])

        # Aquí luego llamaremos al servicio de Facturama
        api_response = {
          uuid: "uuid-fake-123",
          payment_date: Time.current,
          total: invoice.total,
          xml_url: "https://facturama.mx/fake.xml",
          pdf_url: "https://facturama.mx/fake.pdf"
        }

        payment_complement = invoice.create_payment_complement!(api_response)

        render json: payment_complement, status: :created
      rescue => e
        render json: { error: e.message }, status: :unprocessable_entity
      end
    end
  end
end
