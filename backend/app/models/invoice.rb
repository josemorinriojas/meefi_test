class Invoice < ApplicationRecord
  has_one_attached :xml_file
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
end
