module Dorsale
  module BillingMachine
    class QuotationMultipleVatPdf < ::Dorsale::BillingMachine::InvoiceMultipleVatPdf
      include ::Dorsale::BillingMachine::QuotationPdfCommonMethods
    end
  end
end
