class AddFieldsToPaymentComplements < ActiveRecord::Migration[8.0]
  def change
    add_column :payment_complements, :facturama_id, :string
    add_column :payment_complements, :response, :jsonb
  end
end
