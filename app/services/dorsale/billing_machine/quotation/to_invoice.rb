class Dorsale::BillingMachine::Quotation::ToInvoice < ::Dorsale::Service
  attr_accessor :quotation, :invoice

  def initialize(quotation)
    @quotation = quotation
  end

  def call
    @invoice = Dorsale::BillingMachine::Invoice.new

    quotation.attributes.each do |k, v|
      next if ignored_key?(k)

      if invoice.respond_to?("#{k}=")
        invoice.public_send("#{k}=", v)
      end
    end

    quotation.lines.each do |quotation_line|
      invoice_line = invoice.lines.new

      quotation_line.attributes.each do |k, v|
        next if ignored_key?(k)

        if invoice_line.respond_to?("#{k}=")
          invoice_line.public_send("#{k}=", v)
        end
      end
    end

    invoice.date = Date.current

    invoice
  end

  private

  def ignored_key?(k)
    k = k.to_s
    k == "id" || k.match(/index|tracking|state/) || k.end_with?("_at")
  end
end
