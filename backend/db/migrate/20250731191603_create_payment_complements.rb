class CreatePaymentComplements < ActiveRecord::Migration[8.0]
  def change
    create_table :payment_complements do |t|
      t.references :invoice, null: false, foreign_key: true
      t.string :uuid
      t.datetime :payment_date
      t.decimal :total
      t.string :xml_url
      t.string :pdf_url

      t.timestamps
    end
  end
end
