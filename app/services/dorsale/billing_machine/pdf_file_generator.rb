class Dorsale::BillingMachine::PdfFileGenerator < Dorsale::Service
  attr_reader :document

  def initialize(document)
    # I have no idea why I need to do that,
    # if I don't do that, CarrierWare do not stores the file.
    # The reload() method don't work either.
    # The problem appears only on server, not in console.
    # I think CarrierWave do not work anymore after first save.
    @document = document.class.find(document.id)
  end

  def call
    document.update!(pdf_file: file)
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
