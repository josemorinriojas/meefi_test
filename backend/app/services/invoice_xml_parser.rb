class InvoiceXmlParser
  require "nokogiri"

  NAMESPACES = {
    "cfdi" => "http://www.sat.gob.mx/cfd/4",
    "tfd"  => "http://www.sat.gob.mx/TimbreFiscalDigital"
  }.freeze

  def initialize(xml_file)
    @xml_doc = Nokogiri::XML(xml_file.read)
  end

  def parse
    {
      **base_data,
      **emisor_data,
      **receptor_data,
      **cfdi_data,
      **impuestos_data
    }
  end

  private

  def attr_from(path, attr, namespaces = NAMESPACES)
    node = @xml_doc.at_xpath(path, namespaces)
    node&.[](attr)
  end

  def base_data
    {
      series:        attr_from("//cfdi:Comprobante", "Serie"),
      folio:         attr_from("//cfdi:Comprobante", "Folio"),
      issued_at:     attr_from("//cfdi:Comprobante", "Fecha"),
      subtotal:      attr_from("//cfdi:Comprobante", "SubTotal"),
      total:         attr_from("//cfdi:Comprobante", "Total"),
      uuid:          attr_from("//tfd:TimbreFiscalDigital", "UUID")
    }
  end

  def emisor_data
    {
      issuer_rfc:           attr_from("//cfdi:Emisor", "Rfc"),
      issuer_name:          attr_from("//cfdi:Emisor", "Nombre"),
      issuer_fiscal_regime: attr_from("//cfdi:Emisor", "RegimenFiscal"),
      issuer_postal_code:   attr_from("//cfdi:Comprobante", "LugarExpedicion")
    }
  end

  def receptor_data
    {
      receiver_rfc:             attr_from("//cfdi:Receptor", "Rfc"),
      receiver_name:            attr_from("//cfdi:Receptor", "Nombre"),
      receiver_fiscal_regime:   attr_from("//cfdi:Receptor", "RegimenFiscalReceptor"),
      receiver_tax_zip_code:    attr_from("//cfdi:Receptor", "DomicilioFiscalReceptor"),
      receiver_cfdi_use:        attr_from("//cfdi:Receptor", "UsoCFDI")
    }
  end

  def cfdi_data
    {
      payment_method: attr_from("//cfdi:Comprobante", "MetodoPago"),
      payment_form:   attr_from("//cfdi:Comprobante", "FormaPago"),
      currency:       attr_from("//cfdi:Comprobante", "Moneda"),
      exportation:    attr_from("//cfdi:Comprobante", "Exportacion")
    }
  end

  def impuestos_data
    {
      tax_rate:   attr_from("//cfdi:Traslado[@Impuesto='002']", "TasaOCuota"),
      tax_base:   attr_from("//cfdi:Traslado[@Impuesto='002']", "Base"),
      tax_amount: attr_from("//cfdi:Traslado[@Impuesto='002']", "Importe")
    }
  end
end
