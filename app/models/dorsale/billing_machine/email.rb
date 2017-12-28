class Dorsale::BillingMachine::Email < Dorsale::Email
  attr_accessor :document

  def initialize(document, attributes = {})
    @document = document
    super(attributes)
  end

  private

  def model
    document.class
  end

  def default_to
    "#{document.customer} <#{document.customer.email}>" if document.customer
  end

  def default_subject
    "#{model.t} #{document.tracking_id} : #{document.label}"
  end

  def default_body
    I18n.t("billing_machine.emails.#{document.document_type}.body",
      :from => current_user.to_s,
      :to   => document.customer.to_s,
    )
  end

  def default_attachments
    {"#{document.t}_#{document.tracking_id}.pdf" => document.pdf_file.read}
  end
end
