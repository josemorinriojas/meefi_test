class CreateInvoices < ActiveRecord::Migration[8.0]
  def change
    create_table :invoices do |t|
      t.string :series
      t.string :folio
      t.datetime :issued_at
      t.string :issuer_rfc
      t.string :issuer_name
      t.string :receiver_rfc
      t.string :receiver_name
      t.decimal :subtotal, precision: 15, scale: 2
      t.decimal :total, precision: 15, scale: 2
      t.string :uuid
      t.integer :status, default: 0
      t.timestamps
    end
  end
end
