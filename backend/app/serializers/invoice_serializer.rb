class InvoiceSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :receiver_name, :issued_at, :uuid, :subtotal,
             :total, :status
end
