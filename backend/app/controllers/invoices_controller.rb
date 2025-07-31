class InvoicesController < ApplicationController

	def create
		binding.pry
    invoice = Invoice.create_from_xml(params[:xml_file])
    render json: { message: "Invoice created successfully", id: invoice.id }, status: :created
  rescue ArgumentError => e
    render json: { error: e.message }, status: :unprocessable_entity
  rescue => e
    render json: { error: "Failed to process invoice: #{e.message}" }, status: :unprocessable_entity
  end

end
