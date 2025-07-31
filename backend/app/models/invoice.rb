class Invoice < ApplicationRecord
  has_one_attached :xml_file
  has_many :payment_complements, inverse_of: :invoice, dependent: :destroy

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

  def create_payment_complement!(payment_data)
    payment = payment_complements.create!(
      uuid: payment_data[:uuid],
      payment_date: payment_data[:payment_date],
      total: payment_data[:total],
      xml_url: payment_data[:xml_url],
      pdf_url: payment_data[:pdf_url]
    )
    update!(status: :paid)

    payment
  end
end
