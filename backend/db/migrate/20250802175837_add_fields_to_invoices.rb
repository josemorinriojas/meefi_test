class AddFieldsToInvoices < ActiveRecord::Migration[8.0]
  def change
    add_column :invoices, :issuer_fiscal_regime, :string
    add_column :invoices, :issuer_postal_code, :string

    add_column :invoices, :receiver_fiscal_regime, :string
    add_column :invoices, :receiver_tax_zip_code, :string
    add_column :invoices, :receiver_cfdi_use, :string

    add_column :invoices, :payment_method, :string
    add_column :invoices, :payment_form, :string
    add_column :invoices, :currency, :string
    add_column :invoices, :exportation, :string

    add_column :invoices, :tax_rate, :decimal, precision: 5, scale: 4   # Tasa IVA (ej: 0.1600)
    add_column :invoices, :tax_base, :decimal, precision: 15, scale: 2  # Base IVA
    add_column :invoices, :tax_amount, :decimal, precision: 15, scale: 2 # Importe IVA
  end
end
