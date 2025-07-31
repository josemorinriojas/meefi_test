class InvoiceXmlParser
  require "nokogiri"

  NAMESPACES = {
    "cfdi" => "http://www.sat.gob.mx/cfd/4",
    "tfd"  => "http://www.sat.gob.mx/TimbreFiscalDigital"
  }

  def initialize(xml_file)
    @xml_file = xml_file
  end

  def parse
    xml_doc = Nokogiri::XML(@xml_file.read)

    comprobante = xml_doc.at_xpath("//cfdi:Comprobante", NAMESPACES)
    issuer      = xml_doc.at_xpath("//cfdi:Emisor", NAMESPACES)
    receiver    = xml_doc.at_xpath("//cfdi:Receptor", NAMESPACES)
    timbre      = xml_doc.at_xpath("//tfd:TimbreFiscalDigital", NAMESPACES)

    {
      series: comprobante["Serie"],
      folio: comprobante["Folio"],
      issued_at: comprobante["Fecha"],
      issuer_rfc: issuer["Rfc"],
      issuer_name: issuer["Nombre"],
      receiver_rfc: receiver["Rfc"],
      receiver_name: receiver["Nombre"],
      subtotal: comprobante["SubTotal"],
      total: comprobante["Total"],
      uuid: timbre&.[]("UUID")
    }
  end
end
