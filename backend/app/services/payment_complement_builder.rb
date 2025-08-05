class PaymentComplementBuilder
  def initialize(invoice)
    @invoice = invoice
    @partiality_number = ENV["PARTIALITY_NUMBER"]
    @payment_date = Time.current
    @payment_total = @invoice.total
  end

  def build
    {
      "Folio" => @invoice.folio,
      "CfdiType" => "P",
      "ExpeditionPlace" => @invoice.issuer_postal_code,
      "NameId" => "14",

      "Issuer" => {
        "Rfc" => @invoice.issuer_rfc,
        "Name" => @invoice.issuer_name,
        "FiscalRegime" => @invoice.issuer_fiscal_regime
      },

      "Receiver" => {
        "Rfc" => @invoice.receiver_rfc,
        "CfdiUse" => "CP01".freeze,
        "Name" => @invoice.receiver_name,
        "FiscalRegime" => @invoice.receiver_fiscal_regime,
        "TaxZipCode" => @invoice.receiver_tax_zip_code
      },

      "GlobalInformation" => {
        "Periodicity" => "01".freeze,
        "Months" => @payment_date.strftime("%m"),
        "Year" => @payment_date.year
      },

      "Complemento" => {
        "Payments" => [
          {
            "Date" => @payment_date.strftime("%Y-%m-%dT%H:%M:%S"),
            "PaymentForm" => "03".freeze,
            "Amount" => @payment_total,
            "Currency" => @invoice.currency,
            "RelatedDocuments" => [
              {
                "TaxObject" => "02".freeze,
                "Uuid" => @invoice.uuid,
                "Serie" => @invoice.series,
                "Folio" => @invoice.folio,
                "Currency" => @invoice.currency,
                "PartialityNumber" => @partiality_number,
                "PaymentMethod" => @invoice.payment_method,
                "PreviousBalanceAmount" => @invoice.total.to_f,
                "AmountPaid" => @payment_total,
                "ImpSaldoInsoluto" => (@invoice.total.to_f - @payment_total).round(2),
                "Taxes" => [
                  {
                    "Name" => "IVA".freeze,
                    "Rate" => @invoice.tax_rate.to_f,
                    "Total" => @invoice.tax_amount.to_f,
                    "Base" => @invoice.tax_base.to_f,
                    "IsRetention" => "false".freeze
                  }
                ]
              }
            ]
          }
        ]
      }
    }
  end
end
