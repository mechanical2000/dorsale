class Dorsale::BillingMachine::PdfFileGenerator < Dorsale::Service
  attr_reader :document

  def initialize(document)
    super()
    @document = document
  end

  def call
    document.pdf_file = file
    document.save! if document.persisted?
    document
  end

  private

  def pdf_klass
    if document.is_a?(::Dorsale::BillingMachine::Invoice)
      return ::Dorsale::BillingMachine.invoice_pdf_model
    end

    if document.is_a?(::Dorsale::BillingMachine::Quotation)
      return ::Dorsale::BillingMachine.quotation_pdf_model
    end
  end

  def pdf_data
    @pdf_data ||= pdf_klass.new(document).tap(&:build).render_with_attachments
  end

  def file
    @file ||= StringIO.new(pdf_data)
  end

  class StringIO < ::StringIO
    def original_filename
      @original_filename ||= "#{SecureRandom.uuid}.pdf"
    end
  end
end
