module Api
  module V1
    class PaymentComplementsController < ApplicationController
      def create
        invoice = Invoice.find(params[:invoice_id])
        payment_complement = invoice.generate_complement

        render json: payment_complement, status: :created
      rescue => e
        render json: { error: e.message }, status: :unprocessable_entity
      end
    end
  end
end
