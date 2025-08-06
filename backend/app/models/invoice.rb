class Invoice < ApplicationRecord
  has_one_attached :xml_file
  has_many :payment_complements, inverse_of: :invoice, dependent: :destroy
  default_scope { order(created_at: :desc) }

  enum :status, { pending: 0, payed: 1 }

  def self.create_from_xml(xml_file)
    raise ArgumentError, "Invalid file format" unless xml_file&.content_type&.in?(["application/xml", "text/xml"])

    data = InvoiceXmlParser.new(xml_file).parse
    invoice = new(data)
    invoice.xml_file.attach(
      io: File.open(xml_file.tempfile),
      filename: xml_file.original_filename
    )

    invoice.save!
    invoice
  end

  def generate_complement
    PaymentReceiptWorker.perform_async(id)
  end

  def payed!
    update!(status: :payed)
  end
end
