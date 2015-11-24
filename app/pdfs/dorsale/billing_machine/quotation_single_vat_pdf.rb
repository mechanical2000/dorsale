module Dorsale
  module BillingMachine
    class QuotationSingleVatPdf < ::Dorsale::BillingMachine::InvoiceSingleVatPdf
      include ::Dorsale::BillingMachine::QuotationPdfCommonMethods
    end
  end
end
