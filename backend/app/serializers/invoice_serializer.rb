class InvoiceSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :receiver_name, :issued_at, :uuid, :subtotal,
             :total, :status

  def issued_at
    object.issued_at.strftime("%d/%m/%Y")
  end
end
