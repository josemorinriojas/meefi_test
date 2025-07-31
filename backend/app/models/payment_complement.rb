class PaymentComplement < ApplicationRecord
  belongs_to :invoice, inverse_of: :payment_complements

  validates :uuid, presence: true
end
